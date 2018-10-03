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
  if(before) {
    target <- c(target[1:where.index - 1],
                what,
                target[where.index:length(target)]
    )
  } else {
    target <- c(target[1:where.index],
                what,
                target[(where.index + 1):length(target)]
    )
  }
  target
}
