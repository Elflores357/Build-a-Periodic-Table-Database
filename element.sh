#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $# -eq 0 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ $# -ne 1 ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

query="SELECT 'The element with atomic number ' || e.atomic_number || ' is ' || e.name || ' (' || e.symbol || '). It''s a ' || t.type || ', with a mass of ' || p.atomic_mass || ' amu. ' || e.name || ' has a melting point of ' || p.melting_point_celsius || ' celsius and a boiling point of ' || p.boiling_point_celsius || ' celsius.' FROM elements e JOIN properties p USING (atomic_number) JOIN types t USING (type_id) WHERE"

if [[ "$1" =~ ^[0-9]+$ ]]; then
  condition="e.atomic_number = $1"
else
  escaped_input=$(printf '%s' "$1" | sed "s/'/''/g")
  condition="lower(e.symbol) = lower('$escaped_input') OR lower(e.name) = lower('$escaped_input')"
fi

result=$($PSQL "$query $condition")

if [[ -z "$result" ]]; then
  echo "I could not find that element in the database."
else
  echo "$result"
fi