#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table  -t --no-align -c"

if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
  exit 0;
fi

PARAM=$1;
if [[ $1 =~ ^[0-9]+ ]]
then
  ATOM_NUMBER_RESULT=$($PSQL "select atomic_number,name,symbol,t.type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements e left join properties p using(atomic_number) left join types t using(type_id) where atomic_number =$1;")
  if [[ -n $ATOM_NUMBER_RESULT ]]
  then 
    IFS='|'
    read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ATOM_NUMBER_RESULT";
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  exit 0;
  fi
fi

ATOM_SYMBOL_RESULT=$($PSQL "select atomic_number,name,symbol,t.type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements e left join properties p using(atomic_number) left join types t using(type_id) where symbol='$PARAM';")
if [[ -n $ATOM_SYMBOL_RESULT ]]
then 
  IFS='|'
  read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ATOM_SYMBOL_RESULT";
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  exit 0;
fi

ATOM_NAME_RESULT=$($PSQL "select atomic_number,name,symbol,t.type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements e left join properties p using(atomic_number) left join types t using(type_id) where name='$PARAM';")
if [[ -n $ATOM_NAME_RESULT ]]
then 
  IFS='|'
  read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ATOM_NAME_RESULT";
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  exit 0;
fi

# no match
echo "I could not find that element in the database."
