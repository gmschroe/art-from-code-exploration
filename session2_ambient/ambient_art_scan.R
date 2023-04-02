# Exploring ambient R package for generative art
# Developed after following tutorial "Art from Code," Session 2 
# https://art-from-code.netlify.app/day-1/session-2/

# import libraries and custom functions ----

# clear variables
rm(list = ls()) 

# libraries
library(tidyverse)
library(ggthemes)
library(ambient)

# custom functions for ambient art
source('session2_ambient/ambient_art_functions.R')
source('colour_palettes.R')

# Directories ------------------------------------------------------------------

session_dir <- 'session2_ambient'
plot_dir <- 'plots'
example_plot_dir <- 'examples'

# Parameter scan: Worley noise and waves art -----------------------------------

# Not a grid scan - instead randomly choosing from possible values for function 
# parameters. Will use iteration number as seed for choosing values so can
# reproduce parameters.

# number of iterations - increase to explore more parameter combinations
n <- 5

# additional Worley noise settings (see gen_worley in ambient package)
value <- 'distance2div'
distance_ind <- c(2, 3)

# save settings
scan_date <- '20230401'
scan_dir <- paste(scan_date, 'wor_and_wave', value, sep = '_')
save_dir <- file.path(session_dir, plot_dir, scan_dir)
dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)

# sample parameters, make canvas, plot, and save 
for (i in 1:n) {

  # sample parameters
  seed_shift <- 0 # number to add to i to change seed
  param <- sample_worley_and_wave_param(i + seed_shift)
  
  # make canvas  
  canvas <- worley_and_wave_canvas(
    wor_frequencies = param$wor_frequencies,
    wor_seed = param$wor_seed,
    wave_frequencies = param$wave_frequencies,
    wave_mult = param$wave_mult,
    wave_shift = param$wave_shift,
    value = value, 
    distance_ind = distance_ind
  )
  
  # set up save
  fname <- paste(
    save_dir, '/',
    formatC(i + seed_shift, width = 4, format = 'd', flag = '0'), '.png', 
    sep = '')
  png(filename = fname, width = 2, height = 2, units = "in", res = 300)

  # plot
  plotted_canvas <- plot_canvas(canvas)
  
  # save and close file
  print(plotted_canvas)
  dev.off()
  
}

# Examples ---------------------------------------------------------------------

# seed for selecting parameters
# examples are 16, 74, 91, 107, 115
example_seed <- 115

# make directory for saving
save_dir <- file.path(session_dir, example_plot_dir)
dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)

# sample parameters
param <- sample_worley_and_wave_param(example_seed)
cat('EXAMPLE SEED', example_seed, '\n', sep = ' ')
for (j in 1:length(param)) {
  cat(names(param)[j], ':', param[[j]], '\n', sep = ' ')
}

# worley settings
value <- 'distance2div'
distance_ind <- c(2, 3)

# canvas
canvas <- worley_and_wave_canvas(
  wor_frequencies = param$wor_frequencies,
  wor_seed = param$wor_seed,
  wave_frequencies = param$wave_frequencies,
  wave_mult = param$wave_mult,
  wave_shift = param$wave_shift,
  value = value, 
  distance_ind = distance_ind
)


# colours 
if (example_seed == 16) {
  pal <- my_palettes(2)
} else if (example_seed == 74) {
  pal <- rev(my_palettes(2))
} else if (example_seed == 107) {
  pal <- rev(my_palettes(4))
} else {
  pal <- my_palettes(1)
}

# plot
plot_canvas(canvas, palette = pal)

# save
fname <- paste(formatC(example_seed, width = 4, format = 'd', flag = '0'),
               '.png', sep = '')
ggsave(file.path(save_dir, fname),
       dpi = 'print',
       width = 4,
       height = 4)
       
#--------------------------------------------------------------------------



