library(glue)
library(here)
library(fs)
here::here()
setwd(here::here())

getwd()
local <- "/Users/baptiste/Documents/github/quarto-gallery/photos/"


tpl <- "
---
format:
  html:
    keep-md: false
    theme: litera
    css: ../gallery.css
    toc: false
title: <album>
album: <album>
editor: source
lightbox: auto
---

:::{.column-page  style=\"background-image: url('../images/white_wall_hash.webp');\"}
![](../images/<album>.svg){width=60% style=\"margin-left: auto; margin-right: auto;display: block;\" .nolightbox fig-alt=<shQuote(album)>}
:::


::: gallery

::: column-page


```{r, results='asis', echo=FALSE, warning=FALSE, message=FALSE}
library(glue)
library(fs)
library(here)
album = rmarkdown::metadata$album
localurl =  path('../photos/', album)
photos = fs::dir_ls(path = localurl, glob = '*.jpg')
# baseurl = glue('https://xxxxxxx.cloudfront.net/photos/{album}')
baseurl = localurl
if(file.exists('custom_order')){
reordering = intersect(as.integer(readLines('custom_order')), seq_along(photos))
photos = photos[reordering]
}
  
for (i in seq_along(photos)){
  if(i %in% c(1)) span = 'all' else span = 'none'

  cat(glue('![]({{ baseurl }}/{{ fs::path_file(photos[i]) }}){.lightbox style=\"column-span: {{ span }};\" group=\"<album>-gallery\"}', .open = '{{', .close = '}}'), '\n')

}
```
:::

:::
"

la <- c("ushuaia", "kaikoura")

for (album in la){
  fs::dir_create(here::here(glue('{album}')))
  cat(glue(tpl, .open = '<', .close = '>'), file = here::here(glue('{album}/index.qmd')))
}

