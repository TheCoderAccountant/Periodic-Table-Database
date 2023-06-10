#!/bin/bash

# Set the PSQL command with desired options
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if the script is called without an argument
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  # Check if the argument is a numeric value
  if [[ $1 =~ ^[0-9]+$ ]]; then
    # Execute the SQL query to retrieve element properties by atomic number
    QUERY_RESULT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE atomic_number=$1")

    # Process the query result and display element properties
    echo "$QUERY_RESULT" | while IFS='|' read ATOMIC_NUMBER ATOMIC_MASS MELT_TEMP BOIL_TEMP SYMBOL NAME TYPE; do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_TEMP celsius and a boiling point of $BOIL_TEMP celsius."
    done

  # Check if the argument is an alphabetical value (symbol or name)
  elif [[ "$1" =~ ^[A-Za-z]+$ ]]; then
    # Execute the SQL query to retrieve element properties by symbol
    QUERY_RESULT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE symbol='$1'")
    
    # Check if the query result is not empty
    if [[ -n "$QUERY_RESULT" ]]; then
      # Process the query result and display element properties
      echo "$QUERY_RESULT" | while IFS='|' read ATOMIC_NUMBER ATOMIC_MASS MELT_TEMP BOIL_TEMP SYMBOL NAME TYPE; do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_TEMP celsius and a boiling point of $BOIL_TEMP celsius."
      done
    else
      # Execute the SQL query to retrieve element properties by name
      QUERY_RESULT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name='$1'")
      
      # Check if the query result is empty
      if [[ -z "$QUERY_RESULT" ]]; then
        echo "I could not find that element in the database."
      else
        # Process the query result and display element properties
        echo "$QUERY_RESULT" | while IFS='|' read ATOMIC_NUMBER ATOMIC_MASS MELT_TEMP BOIL_TEMP SYMBOL NAME TYPE; do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_TEMP celsius and a boiling point of $BOIL_TEMP celsius."
        done
      fi
    fi
  else
    echo "I could not find that element in the database."
  fi
fi