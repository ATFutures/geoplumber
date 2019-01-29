#' Install an npm package locally
#'
#' TODO: in future it could do global installation.
#'
#' @param pkg of npm package to install
#'
#' @export
gp_install_npm_package <- function(pkg){
  # check if working dir is a valid node package
  if(missing(pkg)) {
    stop("Please provide a package name to install")
  }
  if (length(pkg) != 1L)
    stop("'pkg' must be of length 1")
  if (is.na(pkg) || (pkg == ""))
    stop("invalid package name to install")
  if(file.exists("package.json")){
    system(paste0("npm i ", pkg))
  } else {
    message(paste0("Error: working directory '", getwd(),
                   "' does not include a package.json."))
  }
}
