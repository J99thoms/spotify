# Spotify Tracks Preprocessing

Clean the Spotify tracks dataset.

This is a dataset of Spotify tracks from a range of 125 different genres. You can find the original data set from Kaggle [here.](https://www.kaggle.com/datasets/maharshipandya/-spotify-tracks-dataset)
 

<hr>

## Usage
 
 Clone this repository to your local machine.
 
 In the root directory of your local repo, open terminal and run `R/clean_data.R --file_name=<file_name>`
 
 For example, `Rscript R/clean_data.R --file_name='spotify_tracks'`
 
#### Options
`--file_name` 
- The filename of the spotify tracks dataset.
  - (provide the filename only, not the directory nor the extension)
  - (should be stored in .csv format)
  - (loads raw data from local `'/data/raw/<file_name>.csv'`)
  - (saves clean data to local `'/data/clean/<file_name>.csv'`)

  
 ### Dependencies
- R version 4.2.2 with the following libraries:
   - [docopt](https://github.com/docopt/docopt.R)
   - [here](https://here.r-lib.org/)
   - [tidyverse](https://www.tidyverse.org/)
   
 <hr>
   
## Column descriptions
   
   
- `track_id`: The Spotify track ID.


<br>


- `track_name`: The name of the track.

- `album_name`: The name of the album name in which the track appears.


<br>


- `artist_1`: The name of the artist who performed the track.

 - `artist_2`: The name of the second artist who performed the track (if applicable).

 - `artist_3`: The name of the third artist who performed the track (if applicable).

 - `artist_4`: The name of the fourth artist who performed the track (if applicable).


<br>


- `track_genre_1`: The genre in which the track belongs.

 - `track_genre_2`: The second genre in which the track belongs (if applicable).

 - `track_genre_3`: The third genre in which the track belongs (if applicable).

 - `track_genre_4`: The fourth genre in which the track belongs (if applicable).

 - `track_genre_5`: The fifth genre in which the track belongs (if applicable).


<br>


- `explicit`: Whether or not the track has explicit lyrics (TRUE = yes it does; FALSE = no it does not OR unknown).


<br>


- `mode`: The modality (major or minor) of a track, i.e. the type of scale from which its melodic content is derived. 

- `key`: The key the track is played in. E.g. C, C-sharp, D, E-flat, E, F, and so on. If no key was detected then the value is NA.


<br>


- `time_signature`: The (estimated) time signature of the track. The time signature (meter) is a notational convention to specify how many beats are in each measure (or bar). The value is an integer that ranges from 3 to 7 indicating time signatures of 3/4 to 7/4.

- `tempo`: The overall estimated tempo of a track in beats per minute (BPM). The tempo is the speed or pace of a given track and derives directly from the average beats per minute.


<br>

- `duration_s`: The track length in seconds.


<br>

- `popularity`: The popularity of a track. This is a value between 0 and 100, with 100 being the most popular. The popularity is calculated by an algorithm from Spotify.

- `danceability`: Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable.


<br>


- `loudness`: The overall loudness of a track in decibels (dB).

- `speechiness`: Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered, including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks.

- `acousticness`: A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic.

- `instrumentalness`: Predicts whether a track contains no vocals. "Ooh" and "aah" sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly "vocal". The closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal content.

- `liveness`: Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. A value above 0.8 provides strong likelihood that the track is live.



<br>

- `energy`: Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale.

- `valence`: A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry).


                            
                            
