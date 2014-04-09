#!/bin/bash
#failas=$(hostname)_$(date +%Y_%m_%d)
localdir='/Users/edgaras/Desktop/Work'
remotedir='/Users/edgaras/Desktop/Work/remote'
user='edgaras'
#hostname='192.168.1.63'

clear
echo Enter INTRANET domain username:
read username
read -s -p Password:  mypassword
clear

mount.cifs //192.168.1.63/Work /mnt/health_check -o user=$username,password=$mypassword,nounix,sec=ntlmssp

server=('192.168.1.63' '192.168.1.49')

for i in "${server[@]}"
do
        ssh $user@$server << EOF
                failas=$(hostname)_$(date +%Y_%m_%d)
                unzip -o /Users/edgaras/Desktop/1.zip -d "$localdir"/
                cp -v "$localdir"/1.csv "$localdir"/jobs_optimized.csv
                head -1 "$localdir"/jobs_optimized.csv > "$localdir"/$failas.csv | tail -n+2 "$localdir"/jobs_optimized.csv |\
                sort -rn -t, -k5.7,5.10 -k5.4,5.5 -k 5.1,5.2 >> "$localdir"/$failas.csv
                head -40 "$localdir"/$failas.csv > "$remotedir"/$failas.csv
EOF
        scp $user@$hostname:$remotedir/$failas.csv /tmp/
        echo "$i"

done

umount /mnt/health_check


ssh edgaras@192.168.1.63 "unzip /Users/edgaras/Desktop/1.zip -d /Users/edgaras/Desktop/Work/ \
&& cp -v /Users/edgaras/Desktop/Work/1.csv /Users/edgaras/Desktop/Work/jobs_optimized.csv"

ssh edgaras@192.168.1.63 "head -1 $localdir/jobs_optimized.csv > $localdir/$failas.csv | tail -n+2 $localdir/jobs_optimized.csv |\
	sort -rn -t, -k5.7,5.10 -k5.4,5.5 -k 5.1,5.2 >> $localdir/$failas.csv && head -40 $localdir/$failas.csv > $remotedir/$failas.csv"

failas=$(hostname)_$(date +%Y_%m_%d)
localdir='/Users/edgaras/Desktop/Work'
remotedir='/Users/edgaras/Desktop/Work/remote'

ssh edgaras@192.168.1.63 << EOF
    unzip /Users/edgaras/Desktop/1.zip -d -o "$localdir"/
    cp -v "$localdir"/1.csv "$localdir"/jobs_optimized.csv
EOF

#umount /Users/edgaras/Work/remote