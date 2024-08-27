#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USER_NAME

USER_ID=$($PSQL "select user_id from users where name='$USER_NAME';")
if [[ -z $USER_ID ]]
then
  # new a user
  INSERT_RESULT=$($PSQL "insert into users(name) values('$USER_NAME');")
  USER_ID=$($PSQL "select user_id from users where name='$USER_NAME';")
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "select count(*) from games where user_id=$USER_ID;")
  BEST_GAME=$($PSQL "select min(count) from games where user_id=$USER_ID;")
  if [[ -z $BEST_GAME ]]
  then
    BEST_GAME=0;
  fi
  echo "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

THE_NUMBER=$(( 1 + $RANDOM % 1000 ))
COUNTER=1;
echo "Guess the secret number between 1 and 1000:"
while read GUESS_NUMBER;do
  if [[ ! $GUESS_NUMBER =~ ^-?[0-9]+ ]]
  then 
    echo "That is not an integer, guess again:"
  elif [[ $GUESS_NUMBER -gt $THE_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS_NUMBER -lt $THE_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else
    break
  fi
  COUNTER=$(( $COUNTER + 1 ))
done
echo "You guessed it in $COUNTER tries. The secret number was $THE_NUMBER. Nice job!"
RECORD_RESULT=$($PSQL "insert into games(user_id,count) values($USER_ID,$COUNTER);")