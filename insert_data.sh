#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #get winner's team_id
    WINNERS_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    # if not found
    if [[ -z $WINNERS_TEAM_ID ]]
    then
      #insert into team
      $PSQL "insert into teams (name) values ('$WINNER')"
      #get opponent's team_id
      WINNERS_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi
    OPPONENTS_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    #if not found
    if [[ -z $OPPONENTS_TEAM_ID ]]
    then
      #insert into team
      $PSQL "insert into teams (name) values ('$OPPONENT')"
      #get opponent's team_id
      OPPONENTS_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi
    $PSQL "insert into games (year, winner_id, opponent_id, winner_goals, opponent_goals, round) values ($YEAR, $WINNERS_TEAM_ID, $OPPONENTS_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')"
  fi
done