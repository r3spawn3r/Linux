#!/bin/bash

servers=("192.168.1.102")

file="Weekly7"_$(date -dsunday +%Y_%m_%d)

echo 'Server;Filesystem;Used;Free;%' > $file.csv

for server in "${servers[@]}"
do

	ssh edgaras@$server hostname | tee -a /location/$file.csv; df -h | tail -n+2 | awk '{print " ",$1,$3,$4,$5,$8}' FS=';' | \
	tee -a /location/$file.csv && status="successfully" || status="unsuccessfully"

done

awk '{if($5>=80)print;}' FS=';' /location/$file.csv

mail -s "weekly9" "email@gmail.com" -c "email@yahooc.com"  <<EOF
$file has been created $status
world
EOF