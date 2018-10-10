#' generates a temporary file name
#' /tmp/HasHfolDER
tempfile_name <- function (){
    file.path (tempdir(), ".geoplumber.dat")
}

# currently just writes project directory to tempfile
write_tempfile <- function (dir_name){
    con <- file (tempfile_name())
    writeLines (dir_name, con)
    close (con)
}

#' returns the project name from the temp file
read_tempfile <- function (){
    if (!file.exists (tempfile_name()))
        stop ("No geoplumber project has been created")
    con <- file (tempfile_name())
    dir_name <- readLines (con)
    close (con)
    return (dir_name)
}

#' Useful function to find temp project name from
#' temporary file in /tmp/HasHfolDER/.geoplumber.dat
#' If that is not available (user could already be in a
#' geoplumber directory) then just returns current wd.
change_to_proj_dir <- function () {
  if (!(file.exists (tempfile_name ()) | file.exists ("package.json")))
    stop ("If project was built in a previous R session, you must ",
          "first manually change to project directory")

  wd <- getwd ()
  if (file.exists (tempfile_name ())) {
    project_dir <- read_tempfile ()
    if (!file.exists (project_dir))
      stop ("Project directory ", project_dir, " does not exist")
    wd <- setwd (project_dir)
  }
  return (wd)
}

#' takes a vector of strings, adds another vector
#' either before or after pattern provided.
#' @param target the vector to add what to
#' @param pattern where to add the what to
#' @param what vector to add to target
#' @param before or after the pattern
add_lines <- function (target, pattern, what, before = TRUE) {
  where.index <- grep(pattern, target)
  spaces <- next_spaces(target[where.index])
  if(before) {
    target <- c(target[1:where.index - 1],
                paste0(spaces, what),
                target[where.index:length(target)]
    )
  } else {
    target <- c(target[1:where.index],
                paste0(spaces, what),
                target[(where.index + 1):length(target)]
    )
  }
  target
}

#' takes a vector of strings, adds a Babel style import statement
#'
#' @param target vector to add import in
#' @param component.name Raect name of component
#' @param component.path path to "import" from
#'
add_import_component <- function(target, component.name, component.path) {
  # Import new component
  # Above 'export default'
  export.index <- grep("export default", target)
  # check for duplicate
  component.name.added <- grepl(paste0("import ", component.name), target)
  if(!any(component.name.added)) {
    target <- c(target[1:export.index - 1],
                 # import GeoJSONComponent from '/components/GeoJSONComponent.jsx';
                 paste0("import ", component.name, " from './", component.path, "';"),
                 target[export.index:length(target)]
    )
  }
  target
}

#' Change a source file in place
#'
#' Utility function to make changes to a source file
#' @param path path of file to change, used in readLines()
#' @param what vector to add to path
#' @param pattern where to add the what to, 1st is used. Unique is best.
#' @param before s after the pattern
#' @param replace or replace pattern
#' @param verbose cat the change out
#' @export
#' @examples {
#'  gp_change_file(replace = TRUE, verbose = TRUE) # replacing the comment itself.
#' }
gp_change_file <- function(path = system.file("js/src/App.js", package = "geoplumber"),
                           what = " * geoplumber R package code.",
                           pattern = " * geoplumber R package code.",
                           before = TRUE,
                           replace = FALSE,
                           verbose= FALSE) {
  con <- file(path, "r")
  v <- readLines(con)
  if(length(v) == 0) {
    stop("Empty file, gp_change_file requires a file with min 1 line.")
  }
  # fail safe for default
  index <- grep(pattern, v)
  if(length(index) >= 1) {
    if(replace) {
      v <- c(v[1:index - 1], what, v[(index + 1):length(v)]
      )
    } else {
      v <- add_lines(target = v, pattern = pattern,
                     what = what, before = before)
    }
    if(verbose) {
      print(paste0("Changed at: ", index))
      print(v[index : (index + 5)])
    }
  } else {
    message("Pattern ", pattern, " not found.")
  }
  write(v, file = path)
  close(con)
}

next_spaces <- function(x, count = 4) {
  spaces <- regexpr("^\\s+", x)
  spaces <- attr(spaces, "match.length") # number of spaces of current line
  spaces <- rep(" ",  spaces + count)
  spaces <- paste(spaces, collapse = "")
  spaces
}
