#' @include static_functions.R
NULL

#' Run adaptive test assembly
#'
#' \code{\link{Shadow}} is a test assembly function for performing adaptive test assembly based on the generalized shadow-test framework.
#'
#' @template parameter_config_Shadow
#' @template parameter_constraints
#' @param true_theta (optional) true theta values to use in simulation. Either \code{true_theta} or \code{data} must be supplied.
#' @param data (optional) a matrix containing item response data to use in simulation. Either \code{true_theta} or \code{data} must be supplied.
#' @param prior (optional) density at each \code{config@theta_grid} to use as prior.
#' Must be a length-\emph{nq} vector or a \emph{nj * nq} matrix.
#' This overrides \code{prior_dist} and \code{prior_par} in the config.
#' \code{prior} and \code{prior_par} cannot be used simultaneously.
#' @param prior_par (optional) normal distribution parameters \code{c(mean, sd)} to use as prior.
#' Must be a length-\emph{nq} vector or a \emph{nj * nq} matrix.
#' This overrides \code{prior_dist} and \code{prior_par} in the config.
#' \code{prior} and \code{prior_par} cannot be used simultaneously.
#' @param exclude (optional) a list containing item names in \code{$i} and set names in \code{$s} to exclude from selection for each participant. The length of the list must be equal to the number of participants.
#' @param include_items_for_estimation (optional) an examinee-wise list containing:
#' \itemize{
#'   \item{\code{administered_item_pool}} items to include in theta estimation as \code{\linkS4class{item_pool}} object.
#'   \item{\code{administered_item_resp}} item responses to include in theta estimation.
#' }
#' @template force_solver_param
#' @param session (optional) used to communicate with Shiny app \code{\link{TestDesign}}.
#' @param seed (optional) used to perform data generation internally.
#' @param cumulative_usage_matrix (optional) a *nj* by (*ni* + *ns*) matrix containing the number of times the item/stimulus was administered previously to each participant. Stimuli representations are appended to the right side of the matrix.
#'
#' @return \code{\link{Shadow}} returns an \code{\linkS4class{output_Shadow_all}} object containing assembly results.
#'
#' @template mip-ref
#' @template mipversus-ref
#' @template mipset-ref
#' @template mipbook-ref
#' @rdname Shadow-methods
#'
#' @examples
#' config <- createShadowTestConfig()
#' true_theta <- rnorm(1)
#' solution <- Shadow(config, constraints_science, true_theta)
#' solution@output
#' @export
setGeneric(
  name = "Shadow",
  def = function(config, constraints = NULL, true_theta = NULL, data = NULL, prior = NULL, prior_par = NULL, exclude = NULL, include_items_for_estimation = NULL, force_solver = FALSE, session = NULL, seed = NULL, cumulative_usage_matrix = NULL) {
    standardGeneric("Shadow")
  }
)

#' @rdname Shadow-methods
#' @export
setMethod(
  f = "Shadow",
  signature = "config_Shadow",
  definition = function(config, constraints, true_theta, data, prior, prior_par, exclude, include_items_for_estimation, force_solver = FALSE, session, seed = NULL, cumulative_usage_matrix = NULL) {

    function_call <- match.call()

    if (!validObject(config)) {
      stop("'config' argument is not a valid 'config_Shadow' object")
    }

    if (is.null(constraints)) {
      stop("'constraints' must be supplied")
    }

    if (!force_solver) {
      o <- validateSolver(config, constraints)
      if (!o) {
        return(invisible())
      }
    }

    if (inherits(true_theta, "numeric")) {
      true_theta <- matrix(true_theta, , 1)
    }

    item_pool             <- constraints@pool
    model_code            <- sanitizeModel(item_pool@model)
    simulation_data_cache <- makeSimulationDataCache(
      item_pool = item_pool,
      info_type = "FISHER",
      theta_grid = config@theta_grid,
      seed = seed,
      true_theta = true_theta,
      response_data = data
    )
    simulation_constants  <- getConstants(constraints, config, data, true_theta, simulation_data_cache@max_info)
    config@interim_theta  <- parsePriorParameters(config@interim_theta, simulation_constants, prior, prior_par)
    config@final_theta    <- parsePriorParameters(config@final_theta  , simulation_constants, prior, prior_par)
    bayesian_constants    <- getBayesianConstants(config, simulation_constants)
    initial_theta         <- parseInitialTheta(config, simulation_constants, item_pool, bayesian_constants, include_items_for_estimation)
    item_parameter_sample <- generateItemParameterSample(config, item_pool, bayesian_constants)
    exclude_index         <- getIndexOfExcludedEntry(exclude, constraints)

    # Only used if config@item_selection$method = "FIXED"
    info_fixed_theta      <- getInfoFixedTheta(config@item_selection, simulation_constants, item_pool, model_code)

    if (simulation_constants$use_shadowtest) {
      shadowtest_refresh_schedule <- parseShadowTestRefreshSchedule(simulation_constants, config@refresh_policy)
    }

    # Initialize exposure rate control
    if (simulation_constants$exposure_control_method %in% c("NONE", "ELIGIBILITY", "BIGM", "BIGM-BAYESIAN")) {

      segment_record             <- initializeSegmentRecord(simulation_constants)
      exposure_record            <- initializeExposureRecord(config@exposure_control, simulation_constants)
      diagnostic_exposure_record <- initializeDiagnosticExposureRecord(simulation_constants)
      if (!is.null(config@exposure_control$initial_eligibility_stats)) {
        exposure_record <- config@exposure_control$initial_eligibility_stats
      }

    }

    # Initialize usage matrix
    usage_matrix <- initializeUsageMatrix(simulation_constants)

    if (simulation_constants$use_overlap_control) {
      if (is.null(cumulative_usage_matrix)) {
        stop("'cumulative_usage_matrix' must be supplied when overlap control is effective")
      }
      if (
        !is.matrix(cumulative_usage_matrix) ||
        !identical(dim(cumulative_usage_matrix), dim(usage_matrix)) ||
        !identical(colnames(cumulative_usage_matrix), colnames(usage_matrix))
      ) {
        stop("'cumulative_usage_matrix' must have the same dimensions and column names as 'usage_matrix'")
      }
    }

    # Loop over nj simulees
    o_list <- vector(mode = "list", length = simulation_constants$nj)

    has_progress_pkg <- requireNamespace("progress")
    if (has_progress_pkg) {
      w <- options()$width - 50
      if (w <= 20) {
        w <- options()$width - 2
      }
      pb <- progress::progress_bar$new(
        format = "[:bar] :spin :current/:total (:percent) eta :eta | ",
        total = simulation_constants$nj, clear = FALSE,
        width = w)
      pb$tick(0)
    } else {
      pb <- txtProgressBar(0, simulation_constants$nj, char = "|", style = 3)
    }

    for (j in 1:simulation_constants$nj) {

      o <- new("output_Shadow")
      o@simulee_id <- j

      if (!is.null(true_theta)) {
        o@true_theta <- true_theta[j, ]
      }

      o@prior <- initial_theta$posterior[j, ]
      o@administered_item_index     <- rep(NA_real_, simulation_constants$max_ni)
      o@administered_item_resp      <- rep(NA_real_, simulation_constants$max_ni)
      o@administered_stimulus_index <- NaN
      o@theta_segment_index         <- rep(NA_real_, simulation_constants$max_ni)
      o@interim_theta_est           <- matrix(NA_real_, simulation_constants$max_ni, simulation_constants$nd)
      o@interim_se_est              <- matrix(NA_real_, simulation_constants$max_ni, simulation_constants$nd)
      o@shadow_test                 <- vector("list", simulation_constants$max_ni)
      o@max_cat_pool                <- item_pool@max_cat
      o@test_length_constraints     <- simulation_constants$max_ni
      o@ni_pool                     <- simulation_constants$ni
      o@ns_pool                     <- simulation_constants$ns
      o@set_based                   <- simulation_constants$group_by_stimulus
      o@item_index_by_stimulus      <- constraints@item_index_by_stimulus

      # Simulee: initialize theta estimate
      current_theta <- parseInitialThetaOfThisExaminee(
        config@interim_theta,
        initial_theta,
        j,
        bayesian_constants
      )
      o@initial_theta_est <- current_theta

      # Simulee: initialize selection
      selection <- list()

      # Simulee: initialize completed groupings (item sets) record

      if (simulation_constants$group_by_stimulus) {
        o@administered_stimulus_index <- rep(NA_real_, simulation_constants$max_ni)
        groupings_record <- initializeCompletedGroupingsRecord()
        selection$is_last_item_in_this_set <- TRUE
      }

      # Simulee: initialize shadowtest record

      if (simulation_constants$use_shadowtest) {
        o@shadow_test_feasible  <- logical(simulation_constants$test_length)
        o@shadow_test_refreshed <- logical(simulation_constants$test_length)
      }

      theta_change <- 10000
      done         <- FALSE
      position     <- 0

      # Simulee: flag previously administered items

      usage_flag <- NULL
      if (simulation_constants$use_overlap_control) {
        usage_flag <- cumulative_usage_matrix[j, ]
      }

      # Simulee: flag ineligibile items

      if (simulation_constants$use_exposure_control) {
        eligibility_flag <- flagIneligible(exposure_record, simulation_constants, constraints@item_index_by_stimulus, seed, j, usage_flag)
      }

      # Simulee: flag items to exclude

      exclude_flag <- NULL
      if (!is.null(exclude_index)) {
        exclude_flag <- exclude_index[[j]]
      }

      # Simulee: create augmented pool if applicable

      if (!is.null(include_items_for_estimation)) {
        augment_item_pool  <- include_items_for_estimation[[j]]$administered_item_pool
        augment_item_resp  <- include_items_for_estimation[[j]]$administered_item_resp
        augment_item_index <- item_pool@ni + 1:augment_item_pool@ni
        augmented_item_pool <- combineItemPool(item_pool, augment_item_pool, unique = FALSE, verbose = FALSE)
      }

      # Simulee: administer items

      position <- 0

      while (!done) {

        position <- position + 1
        info_current_theta <- computeInfoAtCurrentTheta(
          config@item_selection,
          j,
          current_theta,
          item_pool,
          model_code,
          info_fixed_theta,                # Only used if config@item_selection$method = "FIXED"
          simulation_data_cache@info_grid, # Only used if config@item_selection$method = "MPWI"
          item_parameter_sample            # Only used if config@item_selection$method = "FB"
        )

        # Item position / simulee: do shadowtest assembly

        if (simulation_constants$use_shadowtest) {

          o@theta_segment_index[position] <- determineCurrentThetaSegment(
            current_theta, position, config@exposure_control, simulation_constants
          )

          if (shouldShadowTestBeRefreshed(
            shadowtest_refresh_schedule,
            position,
            theta_change,
            selection
          )) {

            if (!is.null(seed)) {
              set.seed(seed * 234 + j)
            }
            shadowtest <- assembleShadowTest(
              j, position, o,
              eligibility_flag,
              exclude_flag,
              usage_flag,
              groupings_record,
              info_current_theta,
              config,
              simulation_constants,
              constraints
            )
            solution_is_optimal <- isSolutionOptimal(shadowtest$status, shadowtest$solver)
            if (!solution_is_optimal) {
              printSolverNewline(shadowtest$solver)
              msg <- getSolverStatusMessage(shadowtest$status, shadowtest$solver)
              warning(msg, immediate. = TRUE)
              stop(sprintf("MIP solver returned non-zero status at examinee %i position %i", j, position))
            }

            o@shadow_test_refreshed[position] <- TRUE
            o@solve_time[position] <- shadowtest$solve_time

            o@shadow_test_feasible[position] <- shadowtest$feasible

          } else {

            o@shadow_test_refreshed[position] <- FALSE
            o@shadow_test_feasible[position]  <- o@shadow_test_feasible[position - 1]

          }

          # Select an item from shadowtest

          selection <- selectItemFromShadowTest(
            shadowtest$shadow_test, position, simulation_constants, o,
            selection
          )
          o@administered_item_index[position] <- selection$item_selected
          o@shadow_test[[position]]$i         <- shadowtest$shadow_test$INDEX
          o@shadow_test[[position]]$s         <- shadowtest$shadow_test$STINDEX

        }

        if (!simulation_constants$use_shadowtest) {

          # Do traditional CAT

          o@administered_item_index[position] <- selectItem(info_current_theta, position, o)

        }

        # Item position / simulee: record which stimulus was administered

        if (simulation_constants$group_by_stimulus) {

          o@administered_stimulus_index[position] <- selection$stimulus_selected

          groupings_record <- updateCompletedGroupingsRecordForStimulus(
            groupings_record,
            selection,
            o,
            position
          )

        }

        # Item position / simulee: record which item was administered

        o@administered_item_ncat[position] <- item_pool@NCAT[o@administered_item_index[position]]

        # Item position / simulee: simulate examinee response

        if (!is.null(seed)) {
          # if seed is available, generate response data on the fly
          set.seed((seed * 345) + (j * 123) + o@administered_item_index[position])
          o@administered_item_resp[position] <- simResp(
            item_pool[o@administered_item_index[position]],
            o@true_theta
          )
        }
        if (is.null(seed)) {
          # if seed is empty, use pregenerated response data
          o@administered_item_resp[position] <- simulation_data_cache@response_data[j, o@administered_item_index[position]]
        }

        # Item position / simulee: update posterior

        prob_matrix_current_item <- simulation_data_cache@prob_grid[[o@administered_item_index[position]]]
        prob_resp_current_item   <- prob_matrix_current_item[, o@administered_item_resp[position] + 1]
        current_theta <- updateThetaPosterior(current_theta, prob_resp_current_item)

        # Item position / simulee: utilize supplied items if necessary

        if (!is.null(include_items_for_estimation)) {

          augmented_current_theta    <- current_theta
          augmented_item_pool        <- augmented_item_pool
          augmented_item_index       <- c(augment_item_index, o@administered_item_index[1:position])
          augmented_item_resp        <- c(augment_item_resp,  o@administered_item_resp[1:position])

        } else {

          augmented_current_theta    <- current_theta
          augmented_item_pool        <- item_pool
          augmented_item_index       <- o@administered_item_index[1:position]
          augmented_item_resp        <- o@administered_item_resp[1:position]

        }

        # Item position / simulee: estimate theta
        o <- estimateInterimTheta(
          o, j, position,
          augmented_current_theta,
          augmented_item_pool, model_code,
          augmented_item_index,
          augmented_item_resp,
          include_items_for_estimation,
          item_parameter_sample,
          config,
          simulation_constants,
          bayesian_constants
        )

        theta_change                   <- o@interim_theta_est[position, ] - current_theta$theta
        current_theta$posterior_sample <- o@posterior_sample
        current_theta$theta            <- o@interim_theta_est[position, ]
        current_theta$se               <- o@interim_se_est[position, ]

        # Item position / simulee: prepare for the next item position

        if (position == simulation_constants$max_ni) {
          done <- TRUE
          o@likelihood <- current_theta$likelihood
          o@posterior  <- current_theta$posterior
        }

        if (has_progress_pkg) {
          pb$tick(0)
        }

      }

      # Simulee: test complete, estimate theta
      o <- estimateFinalTheta(
        o, j, position,
        augmented_item_pool,
        model_code,
        augmented_item_index,
        augmented_item_resp,
        include_items_for_estimation,
        item_parameter_sample,
        config,
        simulation_constants,
        bayesian_constants
      )

      # Simulee: record item usage
      usage_matrix <- updateUsageMatrix(usage_matrix, j, o, simulation_constants)

      # Simulee: do exposure control
      exposure_record <- doExposureControl(
        exposure_record, segment_record,
        o, j,
        current_theta,
        eligibility_flag,
        simulation_constants
      )
      diagnostic_exposure_record <- updateDiagnosticExposureRecord(
        diagnostic_exposure_record,
        j,
        exposure_record,
        config,
        simulation_constants
      )

      segment_of           <- getSegmentOf(o, simulation_constants)
      o@true_theta_segment <- segment_of$true_theta
      o_list[[j]] <- o

      if (!is.null(session)) {
        shinyWidgets::updateProgressBar(session = session, id = "pb", value = j, total = simulation_constants$nj)
      } else {
        if (has_progress_pkg) {
          pb$tick()
        } else {
          setTxtProgressBar(pb, j)
        }
      }

      # Simulee: go to next simulee

    }

    if (!has_progress_pkg) {
      close(pb)
    }

    final_theta_est <- unlist(lapply(1:simulation_constants$nj, function(j) o_list[[j]]@final_theta_est))
    final_se_est    <- unlist(lapply(1:simulation_constants$nj, function(j) o_list[[j]]@final_se_est))

    # Aggregate exposure rates
    exposure_rate <- aggregateUsageMatrix(usage_matrix, simulation_constants, constraints)

    # Make diagnostic exposure record
    diagnostic_stats <- makeDiagnosticExposureRecord(
      true_theta, segment_record,
      diagnostic_exposure_record,
      config,
      simulation_constants
    )

    if (simulation_constants$use_shadowtest) {
      freq_infeasible <- table(unlist(lapply(1:simulation_constants$nj, function(j) sum(!o_list[[j]]@shadow_test_feasible))))
    } else {
      freq_infeasible <- NULL
    }

    # update cumulative usage matrix
    if (is.null(cumulative_usage_matrix)) {
      cumulative_usage_matrix <- usage_matrix * 0
    }
    if (identical(dim(cumulative_usage_matrix), dim(usage_matrix))) {
      cumulative_usage_matrix <-
        cumulative_usage_matrix + usage_matrix
    }

    o                             <- new("output_Shadow_all")
    o@call                        <- function_call
    o@output                      <- o_list
    o@pool                        <- item_pool
    o@config                      <- config
    o@true_theta                  <- true_theta
    o@constraints                 <- constraints
    o@prior                       <- prior
    o@prior_par                   <- prior_par
    o@final_theta_est             <- final_theta_est
    o@final_se_est                <- final_se_est
    o@exposure_rate               <- exposure_rate
    o@usage_matrix                <- usage_matrix
    o@cumulative_usage_matrix     <- cumulative_usage_matrix
    o@true_segment_count          <- segment_record$count_true
    o@est_segment_count           <- segment_record$count_est
    o@eligibility_stats           <- exposure_record
    o@check_eligibility_stats     <- diagnostic_stats$elg_stats
    o@no_fading_eligibility_stats <- diagnostic_stats$elg_stats_nofade
    o@freq_infeasible             <- freq_infeasible
    o@data                        <- simulation_data_cache@response_data
    o@adaptivity                  <- calculateAdaptivityMeasures(o)
    o@simulation_constants        <- simulation_constants

    return(o)

  }
)

#' Calculate Root Mean Squared Error
#'
#' Calculate Root Mean Squared Error.
#'
#' @param x A vector of values.
#' @param y A vector of values.
#' @param conditional If \code{TRUE}, calculate RMSE conditional on x.
RMSE <- function(x, y, conditional = TRUE) {
  if (length(x) != length(y)) {
    stop("length(x) and length(y) are not equal")
  }
  if (conditional) {
    MSE <- tapply((x - y)^2, x, mean)
  } else {
    MSE <- mean((x - y)^2)
  }
  return(sqrt(MSE))
}

#' Calculate Relative Errors
#'
#' Calculate Relative Errors.
#'
#' @param RMSE_foc A vector of RMSE values for the focal group.
#' @param RMSE_ref A vector of RMSE values for the reference group.
RE <- function(RMSE_foc, RMSE_ref) {
  if (length(RMSE_foc) != length(RMSE_ref)) {
    stop("length(x) and length(y) are not equal")
  }
  RE <- RMSE_ref^2 / RMSE_foc^2
  return(RE)
}

#' Check the consistency of constraints and item usage
#'
#' Check the consistency of constraints and item usage.
#'
#' @param constraints A \code{\linkS4class{constraints}} object generated by \code{\link{loadConstraints}}.
#' @param usage_matrix A matrix of item usage data from \code{\link{Shadow}}.
#' @param true_theta A vector of true theta values.
checkConstraints <- function(constraints, usage_matrix, true_theta = NULL) {

  raw_constraints <- constraints@constraints
  list_constraints <- constraints@list_constraints

  nc <- nrow(raw_constraints)
  nj <- nrow(usage_matrix)
  ni <- ncol(usage_matrix)

  MET <- matrix(FALSE, nrow = nj, ncol = nc)
  COUNT <- matrix(NA, nrow = nj, ncol = nc)
  if (ni != constraints@ni) {
    stop("unequal number of items in constraints and usage_matrix ")
  }
  byTheta <- FALSE
  MEAN <- rep(NA, nc)
  SD   <- rep(NA, nc)
  MIN  <- rep(NA, nc)
  MAX  <- rep(NA, nc)
  HIT  <- rep(NA, nc)
  if (!is.null(true_theta)) {
    if (length(true_theta) != nj) {
      stop("length of true_theta is not equal to nrow of usage_matrix")
    }
    byTheta <- TRUE
    groupMEAN <- matrix(NA, nrow = nc, ncol = length(unique(true_theta)))
    groupSD   <- matrix(NA, nrow = nc, ncol = length(unique(true_theta)))
    groupMIN  <- matrix(NA, nrow = nc, ncol = length(unique(true_theta)))
    groupMAX  <- matrix(NA, nrow = nc, ncol = length(unique(true_theta)))
    groupHIT  <- matrix(NA, nrow = nc, ncol = length(unique(true_theta)))
  } else {
    groupMEAN <- NULL
    groupSD   <- NULL
    groupMIN  <- NULL
    groupMAX  <- NULL
    groupHIT  <- NULL
  }
  nEnemy <- sum(raw_constraints$TYPE == "ENEMY")
  if (nEnemy > 0) {
    enemyIndex <- which(raw_constraints$TYPE == "ENEMY")
    raw_constraints$LB[enemyIndex] <- 0
    raw_constraints$UB[enemyIndex] <- 1
  }
  numberIndex <- which(raw_constraints$TYPE == "NUMBER")
  for (index in 1:nc) {
    if (raw_constraints$WHAT[index] == "ITEM") {
      if (raw_constraints$TYPE[index] %in% c("NUMBER", "ENEMY")) {
        items <- which(list_constraints[[index]]@mat[1, ] == 1)
        COUNT[, index] <- rowSums(usage_matrix[, items])
        MET[, index] <- COUNT[, index] >= raw_constraints$LB[index] & COUNT[, index] <= raw_constraints$UB[index]
        if (byTheta) {
          groupMEAN[index, ] <- round(tapply(COUNT[, index], true_theta, mean), 3)
          groupSD[index, ] <- round(tapply(COUNT[, index], true_theta, sd), 3)
          groupMIN[index, ] <- tapply(COUNT[, index], true_theta, min)
          groupMAX[index, ] <- tapply(COUNT[, index], true_theta, max)
          groupHIT[index, ] <- round(tapply(MET[, index], true_theta, mean), 3)
        }
        MEAN[index] <- round(mean(COUNT[, index]), 2)
        SD[index] <- round(sd(COUNT[, index]), 2)
        MIN[index] <- min(COUNT[, index])
        MAX[index] <- max(COUNT[, index])
        HIT[index] <- round(mean(MET[, index]), 3)
      }
    }
  }
  LD <- NULL
  if (nEnemy > 0) {
    LD <- rowSums(COUNT[, enemyIndex] > 1)
  }
  Check <- data.frame(raw_constraints, MEAN = MEAN, SD = SD, MIN = MIN, MAX = MAX, HIT = HIT)
  return(list(
    Check = Check[raw_constraints[["TYPE"]] == "NUMBER", ],
    LD = LD,
    groupMEAN = groupMEAN[numberIndex, ], groupSD = groupSD[numberIndex, ],
    groupMIN = groupMIN[numberIndex, ], groupMAX = groupMAX[numberIndex, ],
    groupHIT = groupHIT[numberIndex, ]))
}
