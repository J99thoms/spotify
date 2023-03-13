"Clean the Spotify tracks dataset.
(from https://www.kaggle.com/datasets/maharshipandya/-spotify-tracks-dataset).

Usage: R/clean_data.R --file_name=<file_name>
Example: Rscript R/clean_data.R --file_name='spotify_tracks'

Options:
--file_name=<file_name>     Filename of the spotify tracks dataset
                            (provide the filename only, not the directory nor the extension)
                            (should be stored in .csv format)
                            (loads from local '/data/raw/<file_name>.csv')
                            (saves to local '/data/clean/<file_name>.csv')
" -> doc

# Setup command line functionality
library(docopt)
opt <- docopt(doc)

# Main driver function
main <- function(file_name){
  
  # Imports
  suppressPackageStartupMessages({
    library(tidyverse)
    library(here)
  })
  
  # Constants
  n_artist_cols <- 4
  n_genre_cols <- 5
    
  
  
  # File to read the raw data from
  in_path <- here() |> paste0("/data/raw/", file_name, ".csv")
  
  # Safely read the raw data
  raw_data <- NULL
  try({
    raw_data <- read_csv(in_path, show_col_types = FALSE)
  })
  if (is.null(raw_data)){
    print("Invalid filename supplied.")
    return()
  }
  
  # Clean the data
  clean_data <- raw_data |>
    pull(artists) |>
    str_split(pattern = ";", simplify = TRUE) |>
    as_tibble() |>
    select(all_of(1:n_artist_cols)) |>
    cbind(
      raw_data |> select(-c(1, 3))
    ) |>
    rename(
      artist_1 = V1, artist_2 = V2, 
      artist_3 = V3, artist_4 = V4
    ) |> 
    select(
      track_id, track_name, album_name, 
      artist_1, artist_2, artist_3, artist_4, 
      track_genre, explicit, mode, key, time_signature, 
      tempo, duration_ms, popularity, danceability, 
      loudness, speechiness, acousticness, 
      instrumentalness, liveness, energy, valence
    ) |> 
    mutate(
      duration_ms = round(duration_ms * 0.001, 2),
      tempo = round(tempo, 2)
    ) |> 
    rename(duartion_s = duration_ms) |>
    mutate(
      mode = case_when(
        mode == 1 ~ 'Major',
        mode == 0 ~ 'Minor',
        TRUE ~ as.character(NA)
      ),
      key = case_when(
        key == 0 ~ 'C',
        key == 1 ~ 'C-sharp',
        key == 2 ~ 'D',
        key == 3 ~ 'E-flat',
        key == 4 ~ 'E',
        key == 5 ~ 'F',
        key == 6 ~ 'F-sharp',
        key == 7 ~ 'G',
        key == 8 ~ 'A-flat',
        key == 9 ~ 'A',
        key == 10 ~ 'B-flat',
        key == 11 ~ 'B',
        TRUE ~ as.character(NA)
      ),
    ) |> 
    arrange(
      track_genre, artist_1, album_name, 
      artist_2, artist_3, artist_4, 
      key, time_signature, tempo
    )
  
  genres_df <- clean_data |>
    group_by(track_id) |>
    summarize(toString(track_genre)) |>
    separate(
      col = 'toString(track_genre)', 
      into = sprintf("track_genre_%s", 1:n_genre_cols), 
      sep = ",", 
      fill = "right"
    ) 
  
  clean_data <- clean_data[!duplicated(clean_data$track_id), ] |>
    select(-c(track_genre)) |>
    inner_join(genres_df, by = 'track_id') |> 
    select(c(1:7, 23:27, 8:22)) |> 
    mutate(
      artist_2 = case_when(
        artist_2 == '' ~ as.character(NA),
        TRUE ~ artist_2
      ),
      artist_3 = case_when(
        artist_3 == '' ~ as.character(NA),
        TRUE ~ artist_3
      ),
      artist_4 = case_when(
        artist_4 == '' ~ as.character(NA),
        TRUE ~ artist_4
      )
    )
  

  
  # Ensure the output directory exists
  out_dir <- here() |> paste0("/data/clean")
  try({
    dir.create(out_dir, showWarnings = FALSE)
  })
  
  # Save the cleaned data 
  out_path <- out_dir |> paste0("/", file_name, ".csv")
  write_csv(clean_data, out_path)
}

# Call the main function
main(opt$file_name)
