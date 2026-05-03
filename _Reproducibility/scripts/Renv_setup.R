#This script ensures R packages used are documented, inclusing its version

#load Renv library
library(renv)

#to set up the R dependency management
renv::init()


#to update the dependency management 
renv::snapshot()
