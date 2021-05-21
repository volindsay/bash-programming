#!/bin/bash

#######################################################################################
#                                                                                     #
#                                Valid UID Program                                    #
#                                                                                     #
#           Created by: Vincent Lindsay                                               #
#           Date made : 04/23/2019                                                    #
#           Purpose   : To create a script that will request from                     #
#                       the user a UID to check. The script will                      #
#                       continue to ask for a valid UID until one                     #
#                       is given from the user input.                                 #
#                                                                                     #
#######################################################################################


#################################### Variables and Functions ####################################

VALID=0
ANOTHER=0
ANSWER='n'

function VALIDUID(){
  VALID=0
    while (( $VALID == 0 )); do	
	read -p "Please provide a valid UID to check: " USERUID
	echo ""
	sleep 1	
	if [[ $USERUID -lt 1000 ]] || [[ $USERUID -gt 65537 ]] && ! [[ $USERUID =~ ^[1-9][0-9]{3,5}$ ]]; then
		echo ""
		echo "Invalid input."
		sleep 1
		echo  "Enter a proper UID (1000-65537)."
		echo ""
	else
		echo ""
		echo "Thank you entering a valid UID value in range: $USERUID"
		sleep 1
		echo ""
		VALID=1
	fi	
done
}

function LOOKAGAIN(){
  while [ $ANOTHER -eq 0 ]; do 
    read -p "Would you like to find another UID (y/n): " ANSWER
    if [[ $ANSWER =~ ^[Yy]$ ]] ; then
      echo "Thank you"
      VALIDUID
      ANOTHER=2
    elif [[ $ANSWER =~ ^[Nn]$ ]]; then
      echo "Thank you"
      ANOTHER=1
    else
      echo "Invalid entry. Please try again."
      sleep .5
      ANOTHER=0
    fi 
  done
}

VALIDUID
#################################### PROCESS ####################################

MATCH=$(cat /etc/passwd | cut -f3 -d: | sort -n | egrep -o "^$USERUID$")

#################################### OUTPUT ####################################

if [[ $MATCH -eq $USERUID ]]; then 
  echo ""
  echo "Match found!"
  sleep .7
  echo "Your input: $USERUID"
  sleep .3
  echo "Matched input: $MATCH"
  sleep 4
  LOOKAGAIN
elif [[ $MATCH -ne $USERUID ]]; then
  echo ""
  echo "No match found on this system."
  echo ""
  VALIDUID
else
  echo ""
  echo "Invalid Operation"
  echo ""
fi



clear
echo "Goodbye"
sleep 2
clear
exit 0
