#!/bin/bash 
ssh edgaras@192.168.1.102 hostname | tee /Users/edgaras/Desktop/1.csv
#awk '{ col = $1 " " $1; $1 = col; print }' /Users/edgaras/Desktop/1.csv
ssh edgaras@192.168.1.102 df -h | awk '{print $1,$3,$4,$8}' OFS=';' | tee -a /Users/edgaras/Desktop/1.csv || echo "errorz" 