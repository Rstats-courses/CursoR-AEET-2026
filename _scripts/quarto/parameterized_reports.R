# Select sites for which we want the reports
sites <- c("AEC", "CWT", "SEV")

### Render with a loop

for (i in sites) {
  quarto::quarto_render(
    "_scripts/quarto/Nigro_report.qmd",
    execute_params = list(site_name = i),
    output_file = paste0("Nigro_report_", i, ".pdf")
  )
}

### Render quarto with a function

render_reports <-
  function(site_name){
    quarto::quarto_render(
      "_scripts/quarto/Nigro_report.qmd",
      execute_params = list(site_name = site_name),
      output_file = paste0("Nigro_report_", site_name, ".pdf")
    )
  }

lapply(sites, render_reports)
