#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "Welcome to My Salon, how can I help you?"
  echo -e "Choose your service:\n1) CUT\n2) COLOR\n3) PERM\n4) STYLE\n5) TRIM\n6) EXIT"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTEMENT "CUT";;
    2) MAKE_APPOINTEMENT "COLOR";;
    3) MAKE_APPOINTEMENT "PERM";;
    4) MAKE_APPOINTEMENT "STYLE";;
    5) MAKE_APPOINTEMENT "TRIM";;
    6) EXIT;;
    *) MAIN_MENU "\nI could not find that service. What would you like today?\n" ;;
  esac
}

MAKE_APPOINTEMENT() {
  local SERVICE=$1
  # Placeholder for database interaction
  SERVICE_ID_SELECTED=$($PSQL "select service_id from services where name ilike '%$SERVICE%'")
  echo $SERVICE_ID_SELECTED
  if [[ -z $SERVICE_ID_SELECTED ]]
  then
  echo "Service doesn't exist"
  else
  echo "Please enter your phone number"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
  echo $CUSTOMER_NAME
  if [[ -z $CUSTOMER_NAME ]]
  then
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name,phone) values ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  echo -e "\nAt what Time?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
  INSERT_APPOINTEMENT_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU
