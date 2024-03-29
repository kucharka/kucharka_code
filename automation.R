library(tidyverse)
library(rdrop2)

setwd("~/Documents/kucharka_code")
# download .md files from dropbox
if(!file.exists("md")) dir.create("md")
drop_dir('kucharska_kniha') %>%
  pull(path_lower) %>%
  walk(~drop_download(.x, overwrite = TRUE, local_path = "md/"))

# convert to .Rmd files and move to the top of directory
walk(list.files("md"), ~file.copy(paste0("md/",.x),
                                        str_replace(.x,"\\.md$", "\\.Rmd"),
                                        overwrite = TRUE))
#render book
bookdown::render_book("index.Rmd")

#remove libs folder from website
unlink("../kucharka.github.io/libs", recursive = T)

#delete old files, this does not affect hidden files
walk(paste0("../kucharka.github.io/", list.files("../kucharka.github.io")),
     file.remove)

R.utils::copyDirectory("_book", "../kucharka.github.io")

system('cd ../kucharka.github.io; git add --all; git commit -m "Updating website"; git push origin',
       intern = TRUE)

cat("------ Everything done. Nothing to do here. ------\n")

