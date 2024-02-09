renv::status()

renv::update.packages("xfun")

packs = c("base64enc", "bslib", 
          "cachem", "cli", "colorspace", 
          "digest", 
          "ellipsis", "evaluate", 
          "fansi", "farver", "fastmap", "fontawesome", "fs", 
          "ggplot2", "glue", "gtable", 
          "highr", "htmltools", 
          "isoband", 
          "jquerylib", "jsonlite", 
          "knitr", 
          "labeling", "lifecycle", 
          "magrittr", "memoise", "mime", "munsell", 
          "pillar", "pkgconfig", 
          "R6", "rappdirs", "RColorBrewer", "rlang", "rmarkdown", 
          "sass", "scales", "stringi", "stringr", 
          "tibble", "tinytex", 
          "utf8", 
          "vctrs", "viridisLite", 
          "withr", 
          "xfun", 
          "yaml"
          )

renv::install.packages(packs)
