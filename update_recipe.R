library(desc)
library(yaml)
library(dplyr)
library(tibble)

description_path <- "DESCRIPTION"
recipe_path <- "recipe.yaml"

# Load DESCRIPTION
desc_file <- desc::desc(file = description_path)
version <- desc_file$get("Version")

# Load and update recipe.yaml
recipe <- read_yaml(recipe_path)
recipe$context$version <- version

# Get the base packages which are included in r-base, e.g. stats, grDevices
base_packages <- installed.packages() %>% 
  as_tibble %>%
  filter(Priority == 'base') %>%
  pull(Package)

additional_reqs <- c('r-base >= 4.3')

versioned_import_reqs <- desc_file$get_deps() %>%
  filter(type == 'Imports') %>%
  filter(!package %in% base_packages) %>%
  mutate(req = ifelse(version != '*', paste0(package, ' (', version, ')'), package)) %>%
  mutate(req = paste0('r-', tolower(req))) %>%
  pull(req)

recipe$requirements$host <- c(additional_reqs, versioned_import_reqs)
recipe$requirements$run <- c(additional_reqs, versioned_import_reqs)

write_yaml(recipe, recipe_path)
