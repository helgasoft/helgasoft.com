shiny_url_run <- function(url) {
	# run Shiny single file from URL string	
	# author: Helgasoft.com
	# run at Rstudio prompt: 
	#  > source('https://helgasoft.com/code/shrun.R')
	#  > shiny_url_run('https://mysite/myApp.R')
	# after execution stops with Sys.sleep(0.001), non-critical, to be fixed someday
	#
	# other available, but limited R commands:
	#   runUrl() accepts only ZIP files with 'app.R' inside
	#   runGist() works only with gist urls from Github
  require(shiny)
  file <- tempfile(fileext='.R')
  download.file(url, file, cacheOK=F)
  #obj <- shinyAppFile(file)
  obj <- shiny:::shinyAppDir_appR(basename(file), dirname(file))
  runApp(obj, quiet=T)  
}
