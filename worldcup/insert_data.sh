#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL 'truncate teams,games;')
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
    # winner not found
    if [[ -z $WINNER_ID ]]
    then
      # insert winner team
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER');")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Insert into teams, $WINNER
      fi
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
    fi
    # get opponent id
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
    # opponent not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponent team
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT');")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Insert into teams, $OPPONENT
      fi
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
    fi
    INSERT_GAME_RESULT=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Insert into games, $YEAR,$ROUND,$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS
    fi

  fi
done