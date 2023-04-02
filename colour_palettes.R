# Custom colour palettes
# Specify number of requested palette
# Returned as vector
my_palettes <- function(
    pal_num = 1
    ){
  
  # all colour palettes
  all_pal <- list(
    # 1
    c("#dfe0e0", "#91adb8", "#517588", "#1e252e", "#d5a91d"), 
    
    # 2
    c("#fde6bb", "#eac283", "#df995d", "#9d7a6b", "#c09985", 
               "#d3b79b", "#d8cabd", "#e4dcd4"), # 2
               
    # 3
    c("#dde3e2", "#54746c", "#3a2814", "#855d3d", "#b49157", "#e9e7d3"),
    
    # 4
    c("#2e1f16", "#67201f", "#a14847", "#d29548", "#d7ba95", "#f0e7d7"),
    
    # 5
    c("#f1f0e5", "#a79f59", "#444c49", "#224f50", '#d0ac3d'),
    
    # 6
    c("#bbb27e", "#a79f59", "#444c49", "#224f50", "#bc6020")
    
  )
  
  # select requested palette
  pal <- all_pal[[pal_num]]
    
  return(pal)
}
  