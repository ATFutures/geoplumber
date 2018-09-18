#' TODO: install node for different systems
#'
#' Currently shows nodejs for deb 64bit distros only
#'
#' @export
#' @examples \dontrun{
#' gp_install_node_instructions()
#' }
gp_install_node_instructions <- function() {
  message(
    "You will need NodeJS and npm to use geoplumber.\n\n",
    "To install node and npm on debian 64 bit machines using apt: \n",
    "sudo apt-get install nodejs\n",
    "sudo apt-get install npm\n",
    "Or specific versions from NodeJS:\n",
    "curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -\n",
    "sudo apt-get install -y nodejs\n",
    "More here https://nodejs.org/en/download/package-manager/\n")
}
