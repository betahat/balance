make_palette <- function(num_groups, main_cols, num_cats_per_group){
  my_pal <- c()
  for (n in 1:num_groups) {
    new_cols <-
      colorRampPalette(
        colors = c("white", main_cols[n]))(as.numeric(num_cats_per_group[n, 2] + 2))[-1:-2]
    my_pal <- c(my_pal, new_cols)}
    return(my_pal)
}



