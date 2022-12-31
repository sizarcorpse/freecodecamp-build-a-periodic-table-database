#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

RESULT=''

# If no argmuent passed
if [[ -z $1 ]]; then
    echo 'Please provide an element as an argument.'

#If passed ? Do Query
else
    if [[ $1 =~ ^[0-9]+$ ]]; then
        RESULT="$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")"
    fi

    # Query element with Symbol
    if [[ $1 =~ ^[A-Za-z][a-z]{0,1}$ ]]; then
        RESULT="$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol ILIKE '%$1'")"
    fi

    # Query element with element name
    if [[ $1 =~ ^[A-Z][a-z]{2,39}$ ]]; then
        RESULT="$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name ILIKE '%$1'")"
    fi

    # Output recommended string

    if [[ -z $RESULT ]]; then
        echo 'I could not find that element in the database.'
    else
        echo $RESULT | while read atomic_number bar name bar symbol bar 'type' bar atomic_mass abr melting_point_celsius bar boiling_point_celsius; do
            echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
        done
    fi
fi
