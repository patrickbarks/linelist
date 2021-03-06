% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean_spelling.R
\name{clean_spelling}
\alias{clean_spelling}
\title{Rename values in a vector based on a wordlist}
\usage{
clean_spelling(
  x = character(),
  wordlist = data.frame(),
  from = 1,
  to = 2,
  quiet = FALSE,
  warn_default = TRUE,
  anchor_regex = TRUE
)
}
\arguments{
\item{x}{a character or factor vector}

\item{wordlist}{a matrix or data frame defining mis-spelled words or keys
in one column (\code{from}) and replacement values (\code{to}) in another
column. There are keywords that can be appended to the \code{from} column for
addressing default values and missing data.}

\item{from}{a column name or position defining words or keys to be replaced}

\item{to}{a column name or position defining replacement values}

\item{quiet}{a \code{logical} indicating if warnings should be issued if no
replacement is made; if \code{FALSE}, these warnings will be disabled}

\item{warn_default}{a \code{logical}. When a \code{.default} keyword is set and
\code{warn_default = TRUE}, a warning will be issued listing the variables
that were changed to the default value. This can be used to update your
wordlist.}

\item{anchor_regex}{a \code{logical}. When \code{TRUE} (default), any regex within
the keywork}
}
\value{
a vector of the same type as \code{x} with mis-spelled labels cleaned.
Note that factors will be arranged by the order presented in the data
wordlist; other levels will appear afterwards.
}
\description{
This function provides an interface for \code{\link[forcats:fct_recode]{forcats::fct_recode()}},
\code{\link[forcats:fct_explicit_na]{forcats::fct_explicit_na()}}, and \code{\link[forcats:fct_relevel]{forcats::fct_relevel()}} in such a way that
a data wordlist can be imported from a data frame.
}
\details{
\subsection{Keys (\code{from} column)}{

The \code{from} column of the wordlist will contain the keys that you want to
match in your current data set. These are expected to match exactly with
the exception of three reserved keywords that start with a full stop:
\itemize{
\item \code{.regex [pattern]}: will replace anything matching \verb{[pattern]}. \strong{This
is executed before any other replacements are made}. The \verb{[pattern]}
should be an unquoted, valid, PERL-flavored regular expression. Any
whitespace padding the regular expression is discarded.
\item \code{.missing}: replaces any missing values (see NOTE)
\item \code{.default}: replaces \strong{ALL} values that are not defined in the wordlist
and are not missing.
}

}
\subsection{Values (second column)}{

The values will replace their respective keys exactly as they are presented.

There is currently one recognised keyword that can be placed in the \code{to}
column of your wordlist:
\itemize{
\item \code{.na}: Replace keys with missing data. When used in combination with the
\code{.missing} keyword (in column 1), it can allow you to differentiate
between explicit and implicit missing data.
}

}
}
\note{
If there are any missing values in the \code{from} column (keys), then they
are automatically converted to the character "NA" with a warning. If you want
to target missing data with your wordlist, use the \code{.missing} keyword. The
\code{.regex} keyword uses \code{\link[=gsub]{gsub()}} with the \code{perl = TRUE} option for replacement.
}
\examples{

corrections <- data.frame(
  bad = c("foubar", "foobr", "fubar", "unknown", ".missing"), 
  good = c("foobar", "foobar", "foobar", ".na", "missing"),
  stringsAsFactors = FALSE
)
corrections

# create some fake data
my_data <- c(letters[1:5], sample(corrections$bad[-5], 10, replace = TRUE))
my_data[sample(6:15, 2)] <- NA  # with missing elements

clean_spelling(my_data, corrections)

# You can use regular expressions to simplify your list
corrections <- data.frame(
  bad =  c(".regex f[ou][^m].+?r$", "unknown", ".missing"), 
  good = c("foobar",                ".na",     "missing"),
  stringsAsFactors = FALSE
)

# You can also set a default value
corrections_with_default <- rbind(corrections, c(bad = ".default", good = "unknown"))
corrections_with_default

# a warning will be issued about the data that were converted
clean_spelling(my_data, corrections_with_default)

# use the warn_default = FALSE, if you are absolutely sure you don't want it.
clean_spelling(my_data, corrections_with_default, warn_default = FALSE)

# The function will give you a warning if the wordlist does not
# match the data
clean_spelling(letters, corrections)

# The can be used for translating survey output

words <- data.frame(
  option_code = c(".regex ^[yY][eE]?[sS]?", 
                  ".regex ^[nN][oO]?", 
                  ".regex ^[uU][nN]?[kK]?", 
                  ".missing"),
  option_name = c("Yes", "No", ".na", "Missing"),
  stringsAsFactors = FALSE
)
clean_spelling(c("Y", "Y", NA, "No", "U", "UNK", "N"), words)

}
\seealso{
\code{\link[matchmaker:match_vec]{matchmaker::match_vec()}}, which this function wraps and
\code{\link[matchmaker:match_df]{matchmaker::match_df()}} for an implementation that acts across
multiple variables in a data frame.
}
\author{
Zhian N. Kamvar
}
