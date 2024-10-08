#' @include constraints_operators.R
NULL

#' Run fixed-form test assembly
#'
#' \code{\link{Static}} is a test assembly function for performing fixed-form test assembly based on the generalized shadow-test framework.
#'
#' @template parameter_config_Static
#' @template parameter_constraints
#' @template force_solver_param
#'
#' @return \code{\link{Static}} returns a \code{\linkS4class{output_Static}} object containing the selected items.
#'
#' @template mipbook-ref
#' @examples
#' config_science <- createStaticTestConfig(
#'   list(
#'     method = "MAXINFO",
#'     target_location = c(-1, 1)
#'   )
#' )
#' solution <- Static(config_science, constraints_science)
#'
#' @docType methods
#' @rdname Static-methods
#' @export
setGeneric(
  name = "Static",
  def = function(config, constraints, force_solver = FALSE) {
    standardGeneric("Static")
  }
)

#' @docType methods
#' @rdname Static-methods
#' @export
setMethod(
  f = "Static",
  signature = c("config_Static"),
  definition = function(config, constraints, force_solver = FALSE) {

    function_call <- match.call()

    if (!validObject(config)) {
      stop("the 'config' argument is not a valid 'config_Static' object.")
    }

    if (!force_solver) {
      o <- validateSolver(config, constraints)
      if (!o) {
        return(invisible())
      }
    }

    item_pool <- constraints@pool

    nt <- length(config@item_selection$target_location)

    if (toupper(config@item_selection$method) == "MAXINFO") {

      objective <- as.vector(config@item_selection$target_weight %*% calcFisher(item_pool, config@item_selection$target_location))

    } else if (toupper(config@item_selection$method) == "TIF") {

      objective <- calcFisher(item_pool, config@item_selection$target_location)

    } else if (toupper(config@item_selection$method) == "TCC") {

      tmp <- lapply(item_pool@parms, calcEscore, config@item_selection$target_location)
      objective <- t(do.call(rbind, tmp))

    }

    results <- runAssembly(config, constraints, objective = objective)

    solution_is_optimal <- isSolutionOptimal(results$status, config@MIP$solver)
    if (!solution_is_optimal) {
      printSolverNewline(config@MIP$solver)
      msg <- getSolverStatusMessage(results$status, config@MIP$solver)
      warning(msg, immediate. = TRUE)
    }

    tmp <- NULL
    if (solution_is_optimal) {
      tmp <- getSolutionAttributes(
        constraints,
        results$shadow_test$INDEX,
        FALSE
      )
    }

    o             <- new("output_Static")
    o@call        <- function_call
    o@MIP         <- list(results$MIP)
    o@selected    <- results$shadow_test
    o@obj_value   <- results$obj_value
    o@solve_time  <- results$solve_time
    o@achieved    <- tmp
    o@pool        <- item_pool
    o@config      <- config
    o@constraints <- constraints

    return(o)

  }
)
