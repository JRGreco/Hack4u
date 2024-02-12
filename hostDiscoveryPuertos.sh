#!/bin/bash

# Colors
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm; exit 1
}

# Ctrl+C
trap ctrl_c SIGINT

echo -e "\n"

for i in $(seq 1 254); do
  for port in 21 22 23 25 80 139 443 8080; do
    timeout 1 bash -c "echo '' > /dev/tcp/192.168.1.$i/$port" 2>/dev/null && echo -e "${yellowColour}[+]${endColour} Host ${blueColour}192.168.1.$i ${endColour}- Port ${blueColour}$port${endColour} (${greenColour}OPEN${endColour})" | sort &
  done
done

wait

tput cnorm
