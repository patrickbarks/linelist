% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean_dates.R
\name{clean_dates}
\alias{clean_dates}
\title{Handle dates data}
\usage{
clean_dates(
  x,
  force_Date = TRUE,
  guess_dates = TRUE,
  error_tolerance = 0.5,
  ...,
  classes = NULL
)
}
\arguments{
\item{x}{a \code{data.frame}}

\item{force_Date}{a \code{logical} or \code{integer} vector indicating the columns .
If \code{logical}, indicating if \code{POSIXct} and \code{POSIXlt} objects should be
converted to \code{Date} objects; defaults to \code{TRUE}; you should use this if your
dates are only precise to the day (i.e. no time information within days).}

\item{guess_dates}{a \code{logical} or \code{integer} vector indicating which columns
should be guessed , assuming these columns store character strings or
\code{factors}; this feature is experimental; see \code{\link[=guess_dates]{guess_dates()}} for more
information.}

\item{error_tolerance}{a number between 0 and 1 indicating the proportion of
entries which cannot be identified as dates to be tolerated; if this
proportion is exceeded, the original vector is returned, and a message is
issued; defaults to 0.1 (10 percent)}

\item{...}{further arguments passed on to \code{\link[=guess_dates]{guess_dates()}}}

\item{classes}{a vector of class definitions for each of the columns. If this
is not provided, the classes will be read from the columns themselves.
Practically, this is used in \code{\link[=clean_data]{clean_data()}} to mark columns as protected.}
}
\value{
A \code{data.frame} with standardised dates.
}
\description{
This function detects variables of \code{data.frame} which are effectively
representing dates, and converts them to \code{Date} objects. When variables are
character strings or factors, the function will try to convert dates with
various pre-defined formats (see \emph{details}). For each variable, the most
common date format is automatically detected, and dates not following it are
set to \code{NA} (i.e. missing). It uses a tolerance threshold for the amount of
entries which cannot be converted to date (\code{error_tolerance}). By default,
tolerance is set to \code{0.1}, meaning 10\% of errors in dates entry is allowed
for a given variable. If there are more errors, this variable is assumed not
to be a date, and left untouched.
}
\examples{

## make toy data
onsets <- as.POSIXct("2018-01-01", tz = "UTC")
onsets <- seq(onsets, by = "1 day", length.out = 10)
onsets <- sample(onsets, 20, replace = TRUE)
onsets2 <- format(as.Date(onsets), "\%d/\%m/\%Y")
onsets3 <- format(as.Date(onsets), "\%d \%m \%Y")
outcomes <- onsets + 1e7
admissions <- onsets + 86400 + sample(86400, 20)
admissions[1:5] <- NA
discharges <- admissions + (86400 * sample(5, 20, replace = TRUE)) + sample(86400, 20)
onset_with_errors <- onsets2
onset_with_errors[c(1,20)] <- c("male", "confirmed")
mixed_info <- onsets3
mixed_info[1:10] <- sample(c("bleeding", "fever"), 10, replace = TRUE)
gender <- sample(c("male", "female"), 20, replace = TRUE)
case_type <- c("confirmed", "probable", "suspected", "not a case")
case <- sample(case_type, 20, replace = TRUE)
toy_data <- data.frame("Date of Onset." = onsets,
                       "onset 2" = onsets2,
                       "ONSET 3" = onsets3,
                       "onset_4" = onset_with_errors,
                       "date admission" = admissions,
                       "DATE.of.DISCHARGE" = discharges,
                       "GENDER_ " = gender,
                       "Épi.Case_définition" = case,
                       "date of admission" = admissions,
                       "Date-of_discharge" = discharges,
                       "extra" = mixed_info,
                       stringsAsFactors = FALSE,
                       check.names = FALSE)
## show data
toy_data
str(toy_data)

## clean variable names, store in new object, show results
clean_data <- clean_variable_names(toy_data)
clean_data1 <- clean_dates(clean_data, first_date = "2018-01-01")
clean_data1

## Only clean the columns that have the words "date" or "admission" in them
the_date_cols <- grep("(date|admission)", names(clean_data))
the_date_cols
clean_data2 <- clean_dates(clean_data, 
                           first_date  = "2018-01-01", 
                           force_Date  = the_date_cols,
                           guess_dates = the_date_cols)
clean_data2
str(clean_data2)

## A more complex example: clean date and admissions, but avoid the discharge
## column, since the timestamp is important
the_date_cols <- grepl("(date|admission)", names(clean_data))
discharge     <- grepl("discharge", names(clean_data))

## set names so that these are easier to track
names(the_date_cols) <- names(clean_data) -> names(discharge)

the_date_cols # columns we want
!discharge    # columns that are not the discharge columns ("!" means "not")
to_keep     <- the_date_cols & !discharge # removing the discharge column
clean_data3 <- clean_dates(clean_data, 
                           first_date  = "2018-01-01", 
                           force_Date  = to_keep,
                           guess_dates = to_keep)
clean_data3
str(clean_data3)
}
\seealso{
\code{\link[=guess_dates]{guess_dates()}} to extract dates from a messy input vector
}
\author{
Thibaut Jombart, Zhian N. Kamvar
}
