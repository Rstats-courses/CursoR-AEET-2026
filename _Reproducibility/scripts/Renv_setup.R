#This script ensures R packages used are documented, inclusing its version

#load Renv library
library(renv)

#to set up the R dependency management
renv::init()


#to update the dependency management
renv::snapshot()


#If you want to restore an environment
renv::restore()
#If you need to roll back to an even older version, take a look at renv::history() and renv::revert().

#Keeping a ‘stable’ machine image is a separate challenge,
#but Docker is one popular solution. See vignette("docker", package = "renv")
#for recommendations on how Docker can be used together with renv.

#more info: https://rstudio.github.io/renv/articles/renv.html
