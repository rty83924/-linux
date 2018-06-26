#!/bin/bash
html=/var/www/html/easybank
mysql=/var/lib/mysql/easybank
web_eip=/var/lib/mysql/web_eip
date=$(date +%Y%m%d)
mkdir -p /NAS/$date/
read_only=$(mysql --login-path=easybank -e'show global variables like "%read_only%"'|grep "^read_only"|grep "OFF")
if [ "${read_only}" != "" ];then
        mysql --login-path=easybank -e'set global read_only=1'
        read_only_n=$(mysql --login-path=easybank -e'show global variables like "%read_only%"'|grep "^read_only"|grep "ON")
        if [ "${read_only_n}" != "" ];then
                mysqldump -u root -pmysqlroot --all-databases --triggers --routines --events > /NAS/${date}/a.sql
                mysqldump -u root -pmysqlroot --single-transaction --set-gtid-purged=OFF easybank > /NAS/${date}/easybank.sql
                mysqldump -u root -pmysqlroot --single-transaction --set-gtid-purged=OFF web_eip > /NAS/${date}/web_eip.sql
                mysql --login-path=easybank -e'set global read_only=0'
        fi
else
        mysql --login-path=easybank -e'set global read_only=0'
        /bin/bash /BASH/back.sh
fi
