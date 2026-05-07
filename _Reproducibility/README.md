[![DOI](https://zenodo.org/badge/1077120057.svg)](https://doi.org/10.5281/zenodo.17415477)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

# Reproducibility

Example of a reproducible workflow to run an analysis. The objective of this repo 
is to use a simple example and create a dynamic pipeline to analyze the data in a reproducible way.

To that end we will use:  
- Quarto: A Markdown-like syntaxis to combine text and R code and generate documents.  
- Github: A version control system to track changes as we go.  
- Zenodo: A platform to ensure stable releases with a permanent DOI.  

Content of this repo:

- README.md: The most important file to understand what this repo is about. 
All your projects need a README.md
- `workflow.qmd` (and .html): Step by step guide on how to be reproducible, open, and a very cool R connoisseur.
This is where you should start.
- `demo.qmd`: The skeleton of a dynamic analysis. You can clone this skeleton and create yours
- `OpSci.qmd` (and .html): A pesentation with a general introduction to Open Science
- LICENCE: Always let people know what they can do with your code. In this case, its cc-by
- `/docs`: The folder where the webpage lives. In this case, the metadata.
- `/scripts`: A folder with used sripts, including setting the environment, metadata, etc...
- `/data`: Where data and metadata lives.
- `/renv`: Where the environment used details live. `rend.lock`contains the list of packages used.
- Other folders contain the libraries and images for the .qmd documents.






