#' Adds a basic slider with a callback function to parent.
#'
#' At this moment, there is no strategy to manage parent <> child
#' interaction between what is main component (Welcome) and
#' children. React does have strong tools for this but geoplumber
#' is still young.
#'
#' @param js_on_change_function the function to run on React parent (Welcome). By default,
#' `onChange={(sliderInput) => this.setState({sliderInput})}` sets the state of parent
#' with value returned from the html input's onChange function.
#' @param min min to pass to the slider
#' @param max max to pass to the slider
#' @param step step changes for min & max
#' @param to_vector instead of reading default Home.js
#'
#' @export
#' @examples \dontrun{
#' gp_add_slider()
#' }
#'
gp_add_slider <- function(
  min = 1L,
  max = 10L,
  step = 1L,
  js_on_change_function = "onChange={(sliderInput) => this.setState({sliderInput})}",
  to_vector = "NA"){
  stop_ifnot_geoplumber()
  # Read the template
  component.name <- "RBSlider"
  component.path <- paste0("components/", component.name, ".jsx")
  # Add component to geoplumber Home.js
  target <- to_vector # dont read then check, check then read.
  if("NA" == target)
     target <- readLines("src/Home.js")
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
  spaces <- next_spaces(target[map.end.index])
  target <- c(target[1:map.end.index - 1],
               paste0(spaces, "<", component.name),
               paste0(spaces, "min={", min, "} max={", max, "}", " step={", step, "}"),
               paste0(spaces, js_on_change_function, " />"),
               target[map.end.index:length(target)]
               )
  # now write to project
  if("NA" == to_vector){
    write(target, "src/Home.js")
  } else {
    return(target)
  }
  message("Remember to rebuild frontend: gp_build()")
  message("Success.")
}
