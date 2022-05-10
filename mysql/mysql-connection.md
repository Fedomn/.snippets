1. MySQL上有大量close_wait的连接
猜测：磁盘满了后，MySQL处理不了请求，导致hikari get conn时check alive出错，进而abort conn再新建一个conn，
但是MySQL仍然没有响应，最后会一直新建连接直到max_connection_sze，最后jdbc放弃master切到只读的slave。

2. MySQL磁盘满了，MySQL机器上大量close_wait连接没有释放
MySQL操作需要写redo/undo log
https://dev.mysql.com/doc/refman/8.0/en/full-disk.html

