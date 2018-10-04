#' Adds a basic slider with a callback function to parent.
#'
#' @export
#' @examples \dontrun{
#' gp_add_slider()
#' }
#'
gp_add_slider <- function(){
  if(!gp_is_wd_geoplumber()) {
    is.current.dir <- "Is current dir a geoplumber app? \nTry geoplumber::gp_create() first.\n"
    stop(is.current.dir)
    # no point going any further
  }
  # Read the template
  component.name <- "RBSlider"
  component.path <- paste0("components/", component.name, ".jsx")
  # Add component to geoplumber Welcome.js
  welcome <- readLines("src/Welcome.js")
  # read welcome compoennt, if not, stop
  if(length(welcome) < 10) { # TODO: much better check than this
    stop("geoplumber could not insert component into Welcome.js")
  }
  # import component
  welcome <- add_import_component(welcome, component.name, component.path)

  # find end map component tag
  map.end.index <- grep(pattern = "</Map>", x = welcome)
  # TODO: more checks as file could be corrupt
  # insert line
  # TODO: insert at right tab count :)
  welcome <- c(welcome[1:map.end.index - 1],
               paste0("<", component.name),
               "onChange={(sliderInput) => this.setState({sliderInput})} />",
               welcome[map.end.index:length(welcome)]
               )
  # now write to project
  write(welcome, "src/Welcome.js")
  message("Remember to rebuild frontend: gp_build()")
  message("Success.")
}
