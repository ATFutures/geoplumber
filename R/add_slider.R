#' Adds a basic slider with a callback function to parent.
#'
#' At this moment, there is no strategy to manage parent <> child
#' interaction between what is main component (Welcome) and
#' children. React does have strong tools for this but geoplumber
#' is still young.
#'
#' @param js_function the function to run on React parent (Welcome).
#' @param min min to pass to the slider
#' @param max max to pass to the slider
#' @param to_vector instead of reading default Welcome.js
#'
#' @export
#' @examples \dontrun{
#' gp_add_slider()
#' }
#'
gp_add_slider <- function(
  min = 1L,
  max = 10L,
  js_function = "onChange={(sliderInput) => this.setState({sliderInput})}",
  to_vector = "NA"){
  if(!gp_is_wd_geoplumber()) {
    is.current.dir <- "Is current dir a geoplumber app? \nTry geoplumber::gp_create() first.\n"
    stop(is.current.dir)
    # no point going any further
  }
  # Read the template
  component.name <- "RBSlider"
  component.path <- paste0("components/", component.name, ".jsx")
  # Add component to geoplumber Welcome.js
  target <- to_vector # dont read then check, check then read.
  if("NA" == target)
     target <- readLines("src/Welcome.js")
  # read target compoennt, if not, stop
  if(length(target) < 10) { # TODO: much better check than this
    stop("geoplumber could not insert component into target component.")
  }
  # import component
  target <- add_import_component(target, component.name, component.path)

  # find end map component tag
  map.end.index <- grep(pattern = "</Map>", x = target)
  # TODO: more checks as file could be corrupt
  # insert line
  # TODO: insert at right tab count :)
  target <- c(target[1:map.end.index - 1],
               paste0("<", component.name),
               paste0("min={", min, "} max={", max, "}"),
               paste0(js_function, " />"),
               target[map.end.index:length(target)]
               )
  # now write to project
  if("NA" == to_vector){
    write(target, "src/Welcome.js")
  } else {
    return(target)
  }
  message("Remember to rebuild frontend: gp_build()")
  message("Success.")
}
