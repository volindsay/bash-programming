#!/bin/bash

#######################################################################################
#                                                                                     #
#                                Memory Check Program                                 #
#                                                                                     #
#           Created by: Vincent Lindsay                                               #
#           Date made : 03/28/2019                                                    #
#           Purpose   : To create a program that will alert the user to               #
#                       a threshold amount of memory being used as                    #
#                       either being a warning or critical in usage.                  #
#                                                                                     #
#######################################################################################

#####################Variables#####################
####COLORS####

RED='\033[0;31m'
YEL='\033[1;33m'
GRN='\033[0;32m'
 NC='\033[0m'

##############INITIAL CHECK FOR INPUT##############
if  [[ (-z $1) && (-z $2) ]]; then                                # Check to make sure there are proper variables
    echo ""
    echo -e "${RED}Warning${NC}: You must supply threshold for warning and critical values."
    echo "Exit code 2"
    echo ""
    exit 2
elif [[ -z $2 ]];then
    echo ""
    echo -e "${YEL}Warning${NC}: You must supply two arguments for this script."
    echo "Exit Code 2"
    echo ""
    exit 2
elif  [[ ($1 -eq 0) && ($2 -eq 0) ]]; then                        # Check to make sure there are proper variables
    echo ""
    echo -e  "${RED}Warning${NC}: Arguments must be numbers."
    echo "Exit code 2"
    echo ""
    exit 2
elif ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo ""
    echo -e  "${YEL}Warning${NC}: Argument must be a number."
    echo "Exit code 2"
    echo ""
    exit 2
elif ! [[ $2 =~ ^[0-9]+$ ]]; then                                 # Check to make sure there are proper variables
    echo ""
    echo -e "${YEL}Warning${NC}: Argument must be a number."
    echo "Exit code 2"
    echo ""
    exit 2
fi

if [[ $1 -eq $2 ]]; then
    echo ""
    echo -e "${YEL}Your numbers for the warning and critical thresholds should not be the same.${NC}"
    echo ""
fi
                                         
warning=$1                                                        #warning threshold input
critical=$2                                                       #critical threshold input
totalMem=`grep MemTotal /proc/meminfo | awk '{ print $2 }'`       #retrieval of total memory from /proc/meminfo
 freeMem=`grep MemFree /proc/meminfo | awk '{ print $2 }'`        #retrieval of free memory from /proc/meminfo
usedMem=$((totalMem-freeMem))                                     #calculating the used memory

percentMem=`echo "scale=2;( $usedMem / $totalMem ) * 100"  | bc`  #calculating the percentage of used memory for the thresholds. 
                                                                  #This requires using the echo and piping to the bc 
                                                                  #(basic calculator program for a proper output as Bash does not do floating point arithmetic.
percentMemNoDec=`printf "%.0f" $percentMem`                       #stripping the number from the percentMem back to an integer
totalMemMB=`echo "scale=0;($totalMem / 1024)" | bc `  
freeMemMB=`echo "scale=0;($freeMem / 1024)" | bc `
usedMemMB=`echo "scale=0;($usedMem / 1024)" | bc `

#######################OUTPUT######################

echo ""
echo "Total Memory available: $totalMemMB MB"
echo "Total Free Memory     : $freeMemMB MB"
echo "Total Used Memory     : $usedMemMB MB"
echo "Percent Memory Used   : $percentMem %"
echo ""

#Note: not sure of what the purpose is of the exit codes for the following commands as they're unrelated to errors.

if  [[ $percentMemNoDec -ge $critical ]]; then
    echo -e "${RED}CRITICAL${NC}: $percentMem% $usedMemMB/$totalMemMB MB RAM Used"
    echo "Exit code 1"
    echo ""
    exit 1
elif [[ $percentMemNoDec -ge $warning ]]; then
    echo -e "${YEL}WARNING${NC}: $percentMem% $usedMemMB/$totalMemMB MB RAM Used"
    echo "Exit code 2"
    echo ""
    exit 2
elif [[ $percentMemNoDec -lt $warning ]]; then
    echo -e "${GRN}OK${NC}: $percentMem% $usedMemMB/$totalMemMB MB"
    echo "Exit code 0"
    echo ""
    exit 0
fi 
