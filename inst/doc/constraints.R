## ----echo = FALSE, message = FALSE--------------------------------------------
library(knitr)
library(kableExtra)
library(TestDesign)

constraints_science_data[is.na(constraints_science_data)] <- ""
constraints_reading_data[is.na(constraints_reading_data)] <- ""
constraints_fatigue_data[is.na(constraints_fatigue_data)] <- ""
constraints_bayes_data[is.na(constraints_bayes_data)] <- ""

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_science_data[1:5, ]) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_science_data[1, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em", background = "cyan") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
tmp <- constraints_bayes_data[2, ]
tmp$ONOFF <- ""
knitr::kable(tmp, row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em", background = "cyan") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_science_data[32, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em", background = "cyan") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_science_data[33, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em", background = "cyan") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_science_data[34, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em", background = "cyan") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_science_data[35, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em", background = "cyan") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_science_data[36, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em", background = "cyan") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
tmp <- constraints_bayes_data[2, ]
tmp$ONOFF <- ""
knitr::kable(tmp, row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em", background = "cyan") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
tmp <- constraints_bayes_data[3, ]
tmp$ONOFF <- ""
knitr::kable(tmp, row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em", background = "cyan") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_reading_data[3, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em", background = "cyan") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_fatigue_data[1, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em", background = "cyan") %>%
  column_spec(6, "3em", background = "cyan") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_reading_data[17, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em", background = "cyan") %>%
  column_spec(6, "3em", background = "cyan") %>%
  column_spec(7, "3em")

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(constraints_reading_data[18, ], row.names = FALSE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  column_spec(1, "5em") %>%
  column_spec(2, "5em") %>%
  column_spec(3, "5em") %>%
  column_spec(4, "10em") %>%
  column_spec(5, "3em") %>%
  column_spec(6, "3em") %>%
  column_spec(7, "3em", background = "cyan")

