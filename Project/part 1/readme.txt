This program is a bomberman game
in order to the display scores function there must be a log file in the directory of the program
if there is no log file play the game once without displaying the scores, then there should be a log file made
the display scores function displays the top n scores from the log file

to quit the program at any point just enter -1 -1 instead of the normal cordinates

the $ is a bomb doubler (can stack infinately)
the * is the exit tile      
the ^ is the add bombs tile (adds 10 bombs)
the @ is the add lives tile (adds 3 lives)

the log file is formatted like:
score \n
name \n
rounds \n

And is read/written 3 lines at at time


when the user has a negative round score they loose a life
when the user runs out of lives they loose the game

