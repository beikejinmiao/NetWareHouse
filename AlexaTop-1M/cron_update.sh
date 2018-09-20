#!/bin/bash
######################################################################################
#File Name      : cron_update.sh
#Author         : Li Jinmiao
#Mail           : beikejinmiao@gmail.com
#Created Time   : 2018-09-20 09:24:44
#Description    : 
######################################################################################


# make directory by datetime
datename=$(date +%Y%m%d)
root_dir=/tmp/whitelist/domain
work_home=${root_dir}/${datename}
mkdir -p ${work_home}; cd ${work_home}

# download laest file
## alexa
wget -c -t 5 -T 10 --no-check-certificate http://s3.amazonaws.com/alexa-static/top-1m.csv.zip
unzip top-1m.csv.zip
mv top-1m.csv alexa-top-1m.csv
rm -f top-1m.csv.zip

## majestic
wget -c -t 5 -T 10 --no-check-certificate http://downloads.majestic.com/majestic_million.csv
mv majestic_million.csv majestic-top-1m.csv

## cisco umbrella
wget -c -t 5 -T 10 --no-check-certificate http://s3-us-west-1.amazonaws.com/umbrella-static/top-1m.csv.zip
unzip top-1m.csv.zip
mv top-1m.csv cisco-top-1m.csv
rm -f top-1m.csv.zip

## statvoo
wget -c -t 5 -T 10 --no-check-certificate https://statvoo.com/dl/top-1million-sites.csv.zip
unzip top-1million-sites.csv.zip
mv top-1million-sites.csv statvoo-top-1m.csv
rm -f top-1million-sites.csv.zip


# clean expired folder
date_dirs=(`find ${root_dir} -name "20*" -type d | sort -n`)
cur_len=${#date_dirs[@]}
if [ $cur_len -gt 7 ]; then
    del_num=`expr $cur_len - 7`
    let del_num-=1
    for i in $(seq 0 $del_num)
    do  
        rm -rf ${date_dirs[$i]}
        echo "remove expired folder: '${date_dirs[$i]}'"
    done
fi



