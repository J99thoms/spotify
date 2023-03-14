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
  n_genre_cols <- 5
  
  # Read the raw data
  raw_data <- NULL
  in_path <- here() |> paste0("/data/raw/", file_name, ".csv") # The file to read the raw data from
  try({
    raw_data <- read_csv(in_path, show_col_types = FALSE)
  })
  if (is.null(raw_data)){
    print("Invalid filename supplied.")
    return()
  }
  
  
  #===Clean the data===
  
  clean_data <- raw_data |>
    # Split the 'artists' column (which contains a list of artists separated by
    # semi-colons) into multiple columns (one for each artist).
    pull(artists) |>
    str_split(pattern = ";", simplify = TRUE) |>
    as_tibble() |>
    select(1:4) |>
    rename(
      artist_1 = V1, artist_2 = V2, 
      artist_3 = V3, artist_4 = V4
    ) |> 
    cbind(raw_data) |>
    # Select the relevant columns
    select(
      track_id, track_name, album_name, 
      artist_1, artist_2, artist_3, artist_4, 
      track_genre, explicit, mode, key, time_signature, 
      tempo, duration_ms, popularity, danceability, 
      loudness, speechiness, acousticness, 
      instrumentalness, liveness, energy, valence
    ) |>
    mutate(
      # Convert the 'duration_ms' column from milliseconds to seconds and 
      # round to two decimal places.
      duration_ms = round(duration_ms * 0.001, 2),
      # Round the 'tempo' column (BPM) to two decimal places
      tempo = round(tempo, 2), 
      # Decode the 'mode' column
      mode = case_when(
        mode == 1 ~ 'Major',
        mode == 0 ~ 'Minor',
        TRUE ~ as.character(NA)
      ),
      # Decode the 'key' column
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
    rename(duartion_s = duration_ms) |>
    # Sort the dataframe
    arrange(
      track_genre, artist_1, album_name, 
      artist_2, artist_3, artist_4, 
      key, time_signature, tempo
    ) |> 
    # Replace empty strings with NAs for tracks without multiple artists
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
  
  # Some tracks have duplicate rows because there is one row for each
  # genre that the track falls under.
  genres_df <- clean_data |>
    # Group by 'track_id' to deal with duplicate rows
    group_by(track_id) |> 
    # Extract every genre that a track falls under, concatenate them into a 
    # string in which each genre is separated by a comma, and store the string in
    # a new column called 'genres'.
    summarize(genres = toString(track_genre)) |>
    # Split the 'genres' column into multiple columns (one for each genre)
    separate(
      col = 'genres', 
      into = sprintf("track_genre_%s", 1:n_genre_cols), 
      sep = ",", 
      fill = "right"
    ) 
  clean_data <- clean_data[!duplicated(clean_data$track_id), ] |>
    select(-c(track_genre)) |>
    inner_join(genres_df, by = 'track_id') |> 
    select(c(1:7, 23:27, 8:22))
  
  
  
  # Ensure the output directory exists
  out_dir <- here() |> paste0("/data/clean")
  try({
    dir.create(out_dir, showWarnings = FALSE)
  })
  
  # Save the cleaned data 
  out_path <- out_dir |> paste0("/", file_name, ".csv") # The file to save the clean data to
  write_csv(clean_data, out_path)
}

# Call the main function
main(opt$file_name)
