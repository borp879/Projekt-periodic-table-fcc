#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then 
echo "Please provide an element as an argument."
exit
fi
if [[ $1 =~ ^[0-9]+$ ]]
then
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number = $1")
  if [[ -z $ATOMIC_NUMBER ]]
  then
  echo "I could not find that element in the database."
  else
  QUERY=$($PSQL "SELECT * FROM properties, elements, types WHERE properties.atomic_number = elements.atomic_number AND properties.type_id = types.type_id AND properties.atomic_number = $ATOMIC_NUMBER")
  echo "$QUERY" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID ATOMIC_NUMBER SYMBOL NAME TYPE_ID TYPE
  do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
else
CHECK_NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
  if [[ -z $CHECK_NAME ]]
  then
    CHECK_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
    if [[ -z $CHECK_SYMBOL ]]
    then
    echo "I could not find that element in the database."
    else
    QUERY2=$($PSQL "SELECT * FROM properties, elements, types WHERE properties.atomic_number = elements.atomic_number AND properties.type_id = types.type_id AND elements.symbol = '$CHECK_SYMBOL'")
    echo "$QUERY2" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID ATOMIC_NUMBER SYMBOL NAME TYPE_ID TYPE
    do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
    fi
  else
  QUERY3=$($PSQL "SELECT * FROM properties, elements, types WHERE properties.atomic_number = elements.atomic_number AND properties.type_id = types.type_id AND elements.name = '$CHECK_NAME'")
  echo "$QUERY3" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID ATOMIC_NUMBER SYMBOL NAME TYPE_ID TYPE
  do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
  fi
fi
