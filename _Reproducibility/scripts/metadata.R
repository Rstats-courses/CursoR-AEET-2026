#How to set up metadata follwoing https://annakrystalli.me/dataspice-tutorial/

# Get the last version of dataspice and load it

install.packages("devtools")
devtools::install_github("ropenscilabs/dataspice")
library(dataspice)

#load data (see demo.qmd for details)
d <- read.csv("_Reproducibility/data/Herbivore_specialisation.csv", row.names = 1)
head(d)

#create basic .csv metadata files and folders.
create_spice(dir = "_Reproducibility/data")

#Add creators
edit_creators(metadata_dir = "_Reproducibility/data/metadata")

#Add how to access the data
prep_access(data_path = "_Reproducibility/data/",
            access_path = "_Reproducibility/data/metadata/access.csv")
edit_access(metadata_dir = "_Reproducibility/data/metadata")

#Add metadata

#useful to get ranges before adding those:
#range(d$Year)
#range(d$Latitude, na.rm = T)
#range(d$Longitude, na.rm = T)

edit_biblio(metadata_dir = "_Reproducibility/data/metadata")

#Describe variables
prep_attributes(data_path = "_Reproducibility/data/",
                attributes_path = "_Reproducibility/data/metadata/attributes.csv")
colnames(d)
edit_attributes(metadata_dir = "_Reproducibility/data/metadata")

#create a json file
write_spice(path = "_Reproducibility/data/metadata")

#look at the json:
jsonlite::read_json("_Reproducibility/data/metadata/dataspice.json") %>% listviewer::jsonedit()

#build a webpage!
build_site(path = "_Reproducibility/data/metadata/dataspice.json",
           out_path = "_Reproducibility/docs/index.html")


