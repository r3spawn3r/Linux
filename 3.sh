#!/bin/bash

localdir="/local/dir"
remotedir="/remote/dir"
user="username"
#hostname="192.168.1.63"

clear
echo Enter INTRANET domain username:
read username
read -s -p Password:  mypassword
clear

mount.cifs //location/ /mnt/location -o user=$username,password=$mypassword,nounix,sec=ntlmssp

servers=("ip" "ip2" "ip3")

for server in "${servers[@]}"
do
        ssh -t $user@$server << EOF 2> /dev/null
                unzip -o /Users/edgaras/Desktop/1.zip -d "$localdir"/
                cp -v "$localdir"/1.csv "$localdir"/jobs_optimized.csv
                head -1 "$localdir"/jobs_optimized.csv > "$localdir"/$server.csv | tail -n+2 "$localdir"/jobs_optimized.csv |\
                sort -rn -t, -k5.7,5.10 -k5.4,5.5 -k 5.1,5.2 >> "$localdir"/$server.csv
                head -40 "$localdir"/$server.csv > "$remotedir"/$server.csv
                ls -lah "$remotedir"
EOF

	scp "$user"@$server/*.csv /tmp/

done

umount /mnt/hlocation