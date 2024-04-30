#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#If no argument 
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
fi

#If input numeric
if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY_RESULT=$($PSQL "SELECT name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,types.type FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON types.type_id=properties.type_id WHERE properties.atomic_number=$1" )    
  echo "$QUERY_RESULT" | while IFS="|" read NAME SYMBOL MASS MPC BPC TYPE
    do
      if [[ -z $QUERY_RESULT ]]
      then
        echo "I could not find that element in the database."
      else
        echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
      fi
    done
fi

#If input string
if [[ "$1" =~ ^[A-Za-z]+$ ]]
then
  QUERY_RESULT=$($PSQL "SELECT properties.atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,types.type FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON types.type_id=properties.type_id WHERE name='$1' OR symbol='$1'" )    
  echo "$QUERY_RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL MASS MPC BPC TYPE
    do
      if [[ -z $QUERY_RESULT ]]
      then
        echo "I could not find that element in the database."
      else
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
      fi
    done
fi
