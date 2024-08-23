#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -X -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi

  SERVICES=$($PSQL "select service_id,name from services order by service_id;")
  echo "$SERVICES" | while read SERVICE_ID SERVICE_NAME
  do
    SERVICE_NAME_FORMATTED=$(echo "$SERVICE_NAME" | sed 's/| //')
    echo "$SERVICE_ID) $SERVICE_NAME_FORMATTED"
  done
  read SERVICE_ID_SELECTED
  WANT_SERVICE=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED;")
  if [[ -z $WANT_SERVICE ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else

    WANT_SERVICE=$(echo "$WANT_SERVICE" | sed 's/ //')
    echo -e "\nWhat's your phone number?\n"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?\n"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE');")
    fi
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
    echo -e "\nWhat time would you like your $WANT_SERVICE, $CUSTOMER_NAME?\n"
    read SERVICE_TIME
    INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")

    echo -e "\nI have put you down for a $WANT_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME.\n"
  fi
}

MAIN_MENU