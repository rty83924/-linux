#!/bin/bash

if [ $1 == 'create_ip'];then
        read -p "Enter your mail :" mail_u
        echo "mail_u=${mail_u}" > ./paping.conf
        read -p "Enter server quantity :" server_q
        echo "server_q=${server_q}" > ./paping.conf
                for ((  i=1; i<=${server_q}; i=i+1 ))
                do
                        read -p "server ip :" server_ip
                        echo "ip[${i}]=${server_ip}" > ./paping.conf
                        read -p "server port :" server_pt
                        echo "pt[${i}]=${server_pt}" > ./paping.conf
                done
fi

ping -c 1 192.168.0.1 > /dev/null

if [ $? -eq 0 ];then
        echo 'ok' > /dev/null
else
        exit 1
fi

if [ -f "./paping.conf" ];then
        echo 'OK' > /dev/null
else
        exit 1
fi

server_q=$(cat ./paping.conf |grep '^server_q'|cut -d "=" -f 2)
mail_u=$(cat ./paping.conf |grep '^mail_u'|cut -d "=" -f 2)
for (( i=1; i<=${server_q}; i=i+1 ))
do
        ip[${i}]=$(cat ./paping.conf |grep "ip[${i}]"|cut -d "=" -f 2)
        pt[${i}]=$(cat ./paping.conf |grep "ip[${i}]"|cut -d "=" -f 2)
done

for (( i=1; i<=${server_q}; i=i+1 ))
do
        paping -c 1 ${ip[${i}]} -p ${pt[${i}]}
                if [ $? -eq 0 ];then
                        echo 'OK' > ./var/log/paping.log
                else
                        echo "${ip[$i]} : ${pt[${i}]} not running !" | mail -s 'Error !' ${mail_u}
                fi
done
