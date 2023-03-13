# Spotify Tracks Preprocessing

Clean the Spotify tracks dataset.

You can find the origninal data set from Kaggle [here.](https://www.kaggle.com/datasets/maharshipandya/-spotify-tracks-dataset)
 

<hr>

 ### Usage
 
 In the root of your local repo, open terminal and run `R/clean_data.R --file_name=<file_name>`
 
 For example, `Rscript R/clean_data.R --file_name='spotify_tracks'`
 
 ##### Options
`--file_name` 
- The filename of the spotify tracks dataset.
  - (provide the filename only, not the directory nor the extension)
  - (should be stored in .csv format)
  - (loads raw data from local `'/data/raw/<file_name>.csv'`)
  - (saves clean data to local `'/data/clean/<file_name>.csv'`)
  
  
  <hr>
  
  ### Dependencies
- R version 4.2.2 with the following libraries:
   - [docopt](https://github.com/docopt/docopt.R)
   - [here](https://here.r-lib.org/)
   - [tidyverse](https://www.tidyverse.org/)

                            
                            
