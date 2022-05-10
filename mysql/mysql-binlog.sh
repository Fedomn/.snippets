mysqldump -uroot -p123456 --no-create-info database_name > backupfile.sql

mysqlbinlog mysql-bin.000134 --start-position 0 --stop-position 123 | mysql -uroot -p123456

show binlog events in 'mysql-bin.000134' limit 20;

mysqlbinlog --stop-datetime="2019-11-11 11:00:00" | mysql -uroot -p123456

mysqlbinlog mysql-bin.000134 --start-position 4 --stop-position 1798 | mysql -uroot -p123456

sudo mysqlbinlog --start-datetime="2019-10-11 18:00:00"  --stop-datetime="2019-11-11 11:00:00" mysql-bin.000111 > /opt/recovery-restore.sql

