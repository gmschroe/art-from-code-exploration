#' Plotting function for 2D long grid canvas 
#' Slightly modified from Art from Code function plot_painted_canvas
#' https://art-from-code.netlify.app/day-1/session-2/
#'
#' @param canvas long grid canvas (e.g., as returned by worley_and_wave_canvas)
#' @param palette vector of colours to use for palette
#' @param alpha plot transparancy
#'
#' @return plotted canvas 
#' @export
plot_canvas <- function(canvas, palette = NULL, alpha = 1) {
  
  # set default colours
  if(is.null(palette)) {
    palette <- c("#dfe0e0", "#91adb8", "#517588", "#1e252e", "#d5a91d")
  }
  
  # plot
  canvas |> 
    ggplot(aes(x, y, fill = paint)) + 
    geom_raster(show.legend = FALSE, alpha = alpha) +
    theme_void() +
    coord_equal() +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_fill_gradientn(colours = palette)
}

#' Generate 2D grid of additive Worley noise and waves
#'
#' @param grid_n integer, grid size (grid_n x grid_n)
#' @param wor_frequencies numeric vector of frequencies to use for Worley noise
#' @param wor_seed numeric vector of seed to use for each Worley frequency
#' @param wave_frequencies numeric vector of wave frequencies
#' @param wave_shift numeric vector, length 2, of how to shift waves centre
#' @param wave_mult number specifying strength of wave pattern
#' @param ... addition arguments to pass to gen_worley (ambient package)
#'
#' @return long grid of combined Worley noise and waves
#' @export
worley_and_wave_canvas <- function(
    grid_n = 2000, 
    wor_frequencies = c(1, 10, 50), 
    wor_seed = rep(0, length(wor_frequencies)), 
    wave_frequencies = c(1, 10, 50),
    wave_shift = c(0, 0),
    wave_mult = 0.2,
    ...
    ) {
  
  # start canvas
  canvas <- long_grid(
    x = seq(from = 0, to = 1, length.out = grid_n),
    y = seq(from = 0, to = 1, length.out = grid_n),
    ) |>
    mutate(
      paint = 0
    )
  
  # number of frequencies for worley and wave generation
  wor_n <- length(wor_frequencies)
  wave_n <- length(wave_frequencies)

  # add worley noise
  for (i in 1:wor_n) {
    # generate worley noise at each frequency
    canvas <- canvas |>
      mutate(
        paint = paint + gen_worley(
          x, y, frequency = wor_frequencies[i], seed = wor_seed[i], ...
        )
      )
  }
  
  # add waves
  for (i in 1:wave_n) {
    # generate waves at each frequency
    canvas <- canvas |>
      mutate(
        paint = paint + wave_mult * gen_waves(
          x + wave_shift[1], y + wave_shift[2],
          frequency = wave_frequencies[i]
          )
      )
  }
  
  return(canvas)
}

#' Reproducibly randomly sample parameters within specified constraints for
#' worley and wave canvas
#'
#' @param sample_seed number, seed for sampling parameters
#' @param n_wor vector of integers giving possible numbers of Worley noise 
#' frequencies
#' @param n_wave vector of integers giving possible numbers of wave frequencies
#' @param sample_freq vector of possible frequencies for Worley noise and waves
#' @param wor_seed vector of possible seeds to use for generating Worley noise
#' @param mult_bounds vector of length two giving the upper and lower bounds of 
#' the uniform distribution to draw from to determine the wave multiplier
#' @param shift_bounds vector of length two giving the upper and lower bounds of
#' the uniform distribution to draw from to determine how the waves centre is 
#' shifted
#'
#' @return a list of parameters to use for worley_and_wave_canvas 
#' @export
#'
#' @examples
#' # Using default paramater options example for sample_seed
#' param <- sample_worley_and_wave_param(10)
#' 
#' # Change possible frequencies for waves and Worley noise
#' param <- sample_worley_and_wave_param(sample_seed = 1, sample_freq = c(0.4, 4, 40))
sample_worley_and_wave_param <- function(
    sample_seed = 0,
    n_wor = 1:5, # possible number of worley frequencies
    n_wave = 1:5, # possible number of wave frequencies 
    sample_freq = c(0.25, 0.5, 1, 2, 5, 10, 20, 30, 50, 75, 100, 200), # possible worley and wave frequencies
    wor_seed = 1:5000, # possible noise seeds
    mult_bounds = c(0, 1),
    shift_bounds = c(-2, 2)
    ) {
  
  # set seed
  set.seed(sample_seed)
  
  # sample parameters
  wor_frequencies <- sample(sample_freq, sample(n_wor, 1))
  wave_frequencies <- sample(sample_freq, sample(n_wave, 1))
  wor_seed <- sample(wor_seed, length(wor_frequencies))
  wave_mult <- runif(1, mult_bounds[1], mult_bounds[2])
  wave_shift <- runif(2, shift_bounds[1], shift_bounds[2])
  
  # save in list
  param <- list(wor_frequencies = wor_frequencies,
                wave_frequencies = wave_frequencies,
                wor_seed = wor_seed,
                wave_mult = wave_mult,
                wave_shift = wave_shift)
  
  return(param)
}
