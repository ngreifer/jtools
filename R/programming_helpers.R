## Making a "opposite of %in%" or "not %in%" function to simplify code
#' @title Not `%in%`
#' @description This function does the very opposite of `%in%`
#' @param x An object
#' @param table The object you want see if `x` is not in
#' @return A logical vector
#' @rdname nin
#' @export 
`%nin%` <- function(x, table) is.na(match(x, table, nomatch = NA_integer_))


#' @export
#' @rdname subsetters
`%not%` <- function(x, y) {
  UseMethod("%not%")
}

#' @export
#' @rdname subsetters
#' @usage x %not% y <- value
`%not%<-` <- function(x, y, value) {
  UseMethod("%not%<-")
}

#' @export
#' @rdname subsetters
`%just%` <- function(x, y) {
  UseMethod("%just%")
}

#' @export
#' @rdname subsetters
#' @usage x %just% y <- value
`%just%<-` <- function(x, y, value) {
  UseMethod("%just%<-")
}


# Automates my most common use of %nin%
#' @title Subsetting operators
#' @description `%just%` and `%not%` are subsetting convenience functions 
#'  for situations when you would do `x[x %in% y]` or `x[x %nin% y]`. See
#'  details for behavior when `x` is a data frame or matrix.
#' @param x Object to subset
#' @param y List of items to include if they are/aren't in `x`
#' @param value The object(s) to assign to the subsetted `x`
#' @details 
#'  The behavior of %not% and %just% are different when you're subsetting 
#'  data frames or matrices. The subset `y` in this case is interpreted as
#'  **column** names or indices. 
#'
#'  You can also make assignments to the subset in the same way you could if
#'  subsetting with brackets. 
#'
#' @return All of `x` that are in `y` (`%just%`) or all of `x` that are not in
#'  `y` (`%not%`).
#' @examples 
#' 
#'  x <- 1:5
#'  y <- 3:8
#'  
#'  x %just% y # 3 4 5
#'  x %not% y # 1 2
#'
#'  # Assignment works too
#'  x %just% y <- NA # 1 2 NA NA NA
#'  x %not% y <- NA # NA NA 3 4 5
#'  
#'  mtcars %just% c("mpg", "qsec", "cyl") # keeps only columns with those names
#'  mtcars %not% 1:5 # drops columns 1 through 5
#'
#'  # Assignment works for data frames as well
#'  mtcars %just% c("mpg", "qsec") <- gscale(mtcars, c("mpg", "qsec"))
#'  mtcars %not% c("mpg", "qsec") <- gscale(mtcars %not% c("mpg", "qsec"))
#'  
#'  
#' @rdname subsetters
#' @export 

`%not%.default` <- function(x, y) {
  x[x %nin% y]
}

#' @rdname subsetters
#' @export 

`%not%<-.default` <- function(x, y, value) {
  x[x %nin% y] <- value
  x
}


#' @rdname subsetters
#' @export 

`%not%.data.frame` <- function(x, y) {
  if (is.character(y)) {
    x[names(x) %not% y]
  } else {
    x[seq_along(x) %not% y]
  }
}

#' @rdname subsetters
#' @export 

`%not%<-.data.frame` <- function(x, y, value) {
  if (is.character(y)) {
    x[names(x) %not% y] <- value
  } else {
    x[seq_along(x) %not% y] <- value
  }
  x
}

#' @rdname subsetters
#' @export 

`%not%.matrix` <- function(x, y) {
  if (is.character(y)) {
    x[, colnames(x) %not% y]
  } else {
    x[, seq_len(ncol(x)) %not% y]
  }
}

#' @rdname subsetters
#' @export 

`%not%<-.matrix` <- function(x, y, value) {
  if (is.character(y)) {
    x[, colnames(x) %not% y] <- value
  } else {
    x[, seq_len(ncol(x)) %not% y] <- value
  }
  x
}

#' @rdname subsetters
#' @export
# Automates my most common use of %in%
`%just%.default` <- function(x, y) {
  x[x %in% y]
}

#' @rdname subsetters
#' @export
# Automates my most common use of %in%
`%just%<-.default` <- function(x, y, value) {
  x[x %in% y] <- value
  x
}

#' @rdname subsetters
#' @export 

`%just%.data.frame` <- function(x, y) {
  if (is.character(y)) {
    x[y %just% names(x)]
  } else {
    x[y %just% seq_along(x)]
  }
}

#' @rdname subsetters
#' @export 

`%just%<-.data.frame` <- function(x, y, value) {
  if (is.character(y)) {
    x[y %just% names(x)] <- value
  } else {
    x[y %just% seq_along(x)] <- value
  }
  x
}

#' @rdname subsetters
#' @export 

`%just%.matrix` <- function(x, y) {
  if (is.character(y)) {
    x[, y %just% colnames(x)]
  } else {
    x[, y %just% seq_len(ncol(x))]
  }
}

#' @rdname subsetters
#' @export 

`%just%<-.matrix` <- function(x, y, value) {
  if (is.character(y)) {
    x[, y %just% colnames(x)] <- value
  } else {
    x[, y %just% seq_len(ncol(x))] <- value
  }
  x
}


## Print rounded numbers with all requested digits, signed zeroes
#' @title Numbering printing with signed zeroes and trailing zeroes
#' @description This function will print exactly the amount of digits requested
#'  as well as signed zeroes when appropriate (e.g, `-0.00`).
#' @param x The number(s) to print
#' @param digits Number of digits past the decimal to print
#' @param format equal to `"d"` (for integers),
#'  `"f"`, `"e"`, `"E"`, `"g"`, `"G"`, `"fg"` (for reals). Default is `"f"`
#' @export
num_print <- function(x, digits = getOption("jtools-digits", 2),
                      format = "f") {
  sapply(x, function(x) {if (is.numeric(x)) {
    formatC(x, digits = digits, format = format)
  } else {
    x
  }}, USE.NAMES = FALSE)
}

# Automate the addition of newline characters for long strings
#' @title `cat`, `message`, `warning`, and `stop` wrapped to fit the console's
#'  width.
#' @description These are convenience functions that format printed output to
#'  fit the width of the user's console.
#' @param ... Objects to print
#' @param sep Separator between `...`, Default: ''
#' @param brk What should the last character of the message/warning/error be?
#'  Default is `"\n"`, meaning the console output ends with a new line.
#' @param call. Here for legacy reasons. It is ignored.
#' @rdname wrap_str
#' @export 

wrap_str <- function(..., sep = "") {
  paste0(strwrap(paste(..., sep = sep), width = 0.95 * getOption("width", 80)),
         collapse = "\n")
}

# Go ahead and wrap the cat function too
#' @rdname wrap_str
#' @export 
cat_wrap <- function(..., brk = "") {
  cat(wrap_str(...), brk, sep = "")
}

# Define orange crayon output
orange <- crayon::make_style("orange")

# Like cat_wrap but for warnings
#' @rdname wrap_str
#' @export 
warn_wrap <- function(..., brk = "\n", call. = FALSE) {
  warning(orange(wrap_str(...)), brk, call. = FALSE)
}

# Like cat_wrap but for errors
#' @rdname wrap_str
#' @importFrom crayon red
#' @export 
stop_wrap <- function(...,  brk = "\n", call. = FALSE) {
  stop(red(wrap_str(...)), brk, call. = FALSE)
}

# Like cat_wrap but for messages
#' @importFrom crayon cyan
#' @rdname wrap_str
#' @export 
msg_wrap <- function(..., brk = "\n") {
  message(cyan(wrap_str(...)), brk)
}
