[![Build
Status](https://travis-ci.org/ATFutures/geoplumber.svg)](https://travis-ci.org/ATFutures/geoplumber)
[![codecov](https://codecov.io/gh/ATFutures/geoplumber/branch/master/graph/badge.svg)](https://codecov.io/gh/ATFutures/geoplumber)
[![Project Status:
WIP](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

<!-- README.md is generated from README.Rmd. Please edit that file -->
What is geoplumber?
===================

geoplumber is R package that extends
[`plumber`](https://github.com/trestletech/plumber), which was designed
for creating web APIs with R. It supports [React](https://reactjs.org/)
frontends at present (it may support other frontend frameworks such as
VueJS in the future) and geographic data, building on
[`sf`](https://github.com/r-spatial/sf).

In other words, geoplumber is a lightweight geographic data server, like
a barebones version of [GeoServer](http://geoserver.org/) but with a
smaller footprint (&lt; 5MB rather than &gt; 50MB download size) and
easier installation, especially if you are already an R user, with the
following command:

``` r
devtools::install_github("ATFutures/geoplumber")
#> Downloading GitHub repo ATFutures/geoplumber@master
#> from URL https://api.github.com/repos/ATFutures/geoplumber/zipball/master
#> Installing geoplumber
#> '/usr/lib64/R/bin/R' --no-site-file --no-environ --no-save --no-restore  \
#>   --quiet CMD INSTALL  \
#>   '/tmp/RtmpBGO7TW/devtools2b4a21ef7ca9/ATFutures-geoplumber-427a475'  \
#>   --library='/home/markus/R/x86_64-pc-linux-gnu-library/3.5'  \
#>   --install-tests
#> 
```

Development
-----------

geoplumber is built for Unix systems, we aim to support Windows in
future.

We have worked with Shiny and
[`plumber`](https://github.com/trestletech/plumber/) and we consider
ourselves experienced in ReactJS, too. In order to put together a web
application powered at the backend with R and React at the front-end,
there is a lot of setup and boilerplate to put together. This would be
also correct for other front end stack such as Angular or VueJS.

Currently geoplumber uses Facebook’s `create-react-app` (CRA) npm
package to deal with underlying app management (including building and
running) to keep you up to date with updates. `geoplumber` will
generally provide detailed installation instructions for all required
`npm` packages, but if not, the following are minimally required:

    sudo npm i -g create-react-app

<!-- ## Installation -->
<!-- Currently repo is available only on github. To install the package using `devtools`: -->
<!-- geoplumber, like `devtools` and similar packages works by working directory. It does not currently create an `.Rproj` file but may do so in future. -->
npm packages included by default
--------------------------------

``` js
  "dependencies": {
    "create-react-app": "^1.5.2",       # main package to manage front end
    "enzyme": "^3.3.0",                 # test suite
    "enzyme-adapter-react-16": "^1.1.1",# test suite adapter for React
    "leaflet": "^1.3.1",                # main web map tool (in future geoplumber could support other options)
    "prop-types": "^15.6.1",            # React bits and pieces
    "react": "^16.3.2",                 # React
    "react-bootstrap": "^0.32.1",       # bootstrap is current choice (future could be different)
    "react-dom": "^16.3.2",             # React
    "react-leaflet": "^1.9.1",          # React wrapper around leaflet above
    "react-leaflet-control": "^1.4.1",  # React map control
    "react-router": "^4.3.1",           # React router (RR) (supporting multuplage not singel page.)
    "react-router-dom": "^4.2.2",       # React dom for RR
    "react-scripts": "1.1.4",           # main package to manage front end
    "react-test-renderer": "^16.4.1",   # test suite
    "sinon": "^6.1.4"                   # test suite
  }
```

Usage
-----

To create a new web application:

``` r
library(geoplumber)
gp_create("my_app")
#> Initializing project at: /data/mega/code/repos/atfutures/geoplumber/my_app
#> To build/run app, set working directory to: my_app
#> Standard output from create-react-app above works.
#> You can run gp_ functions from directory: my_app
#> To build the front end run: gp_build()
#> To run the geoplumber app: gp_plumb()
#> Happy coding.
```

This will create a `my_app` folder at your current working directory.
Suppose you started an R session from a folder with path
`/Users/ruser/`, you will have `/Users/ruser/my_app` on your machine.

If you create an Rstudio project at `/Users/ruser/my_app` yourself, or
an empty `my_app` directory, you can create a geoplumber app using:
`geoplumber::gp_create(".")`.

You can also give geoplumber a path including one ending with a new
directory. Currently, geoplumber does not do any checks on this but the
underlying CRA does.

You can then build the new project

``` r
library(geoplumber)
setwd("my_app")
gp_build() # the front end and create minified js files.
#> Running: npm run build
#> Standard output from create-react-app above works.
#> To run the geoplumber app: gp_plumb()
```

At this point, if you created an app using the above examples or set
your working directory to a geoplumber app. You can then serve all
endpoints and front end with one command: `gp_plumb()` \# provide custom
port if you wish, default is 8000

Then visit `localhost:8000` to see your app.

Use case
--------

Serve the `geoplumber::traffic` dataset (data.frame) at a “/api/data”
endpoint, and view it on the front end.

The `traffic`
[dataset](https://data.cdrc.ac.uk/dataset/southwark-traffic-counts) is
from CDRC at University of Leeds which is traffic data locations for the
larger traffic dataset.

To achive this copy the following endpoint/API to the clipboard of your
machine. If you like to understand the function, you need to learn
`plumber` package.

``` r
#' Serve geoplumber::traffic from /api/data
#' @get /api/data
get_traffic <- function(res) {
  geojson <- geojsonsf::sf_geojson(geoplumber::traffic)
  res$body <- geojson
  res
}
```

Then run (re-copied into clipboard just in case):

``` r
setwd("my_app")
old_clip <- clipr::read_clip()
# adding above to clipboard
 clipr::write_clip(c(
 "#' Serve geoplumber::traffic from /api/data",
 "#' @get /api/data",
 "get_traffic <- function(res) {",
 "  geojson <- geojsonsf::sf_geojson(geoplumber::traffic)",
 "  res$body <- geojson",
 "  res",
 "}"
 ))
 gp_endpoint_from_clip()
#> Clipboard contents: 
#> ------begin----
#> #' Serve geoplumber::traffic from /api/data
#> #' @get /api/data
#> get_traffic <- function(res) {
#>   geojson <- geojsonsf::sf_geojson(geoplumber::traffic)
#>   res$body <- geojson
#>   res
#> }
#> -----end-----
#> No warnings given.
#> Success.
#> Please restart your server: gp_plumb()
 clipr::write_clip(old_clip)
```

This has now added a new endpoint at: `/api/data`. To consume it, we can
simply run:

``` r
setwd("my_app")
gp_add_geojson("/api/data") # param value is default
#> Remember to rebuild frontend: gp_build()
#> Success.
```

You can now see the data by running:

``` r
setwd("my_app")
gp_build() # build changes
gp_plumb()
```

<img src="man/figures/gp.png" alt="CDRC London traffic data on geoplumber" width="70%" />
<p class="caption">
CDRC London traffic data on geoplumber
</p>

You can also now see the raw JSON dataset at
`http://localhost:8000/api/data`, and on a map on a browser view the map
at `http://localhost:8000`.

Endpoints
---------

R package `plumber` comes with a default endpoint for documenting the
API using Swagger. This is also available from `geoplumber`’s
`/__swagger__/` path.

We follow a pattern of `/api/` before the endpoints and without for
other URL’s. A new web app will have `/api/helloworld` and you can
`curl` it:

``` sh
curl localhost:8000/api/helloworld
#> {"msg":["The message is: 'nothing given'"]}
```

Test
----

Tests currently only apply to very restricted components of full
functionality.

``` r
devtools::test()
```
