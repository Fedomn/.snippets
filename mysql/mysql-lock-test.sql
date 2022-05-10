CREATE TABLE `u` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `age` int(11) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `age` (`age`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


select * from u where id = 11 for update;
select * from u where id = 11 for update;
insert into u values (11,11,11);

------------------------------------------------------------------------

show open tables where in_use > 0;

show engine innodb status\G

show processlist;

SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCKS\G

SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCK_WAITS\G

select trx_mysql_thread_id,trx_id,trx_started,trx_wait_started,trx_requested_lock_id,trx_query,trx_rows_locked,trx_rows_modified from information_schema.innodb_trx\G

select @@tx_isolation;

set session transaction isolation level SERIALIZABLE;

set session transaction isolation level READ COMMITTED;

select * from user where id = 1;

update user set age = 13 where id = 1;

INSERT INTO `user` (`id`, `age`) VALUES (111, 3);


select * from user where id = 1 lock in share mode;
select * from user where id = 5 for update;

LOCK TABLES user WRITE;
LOCK TABLES user READ;
UNLOCK TABLES;
SHOW ENGINE INNODB STATUS\G


INSERT INTO `user` (`age`) VALUES (1);
INSERT INTO `user` (`age`) VALUES (2);


update user set age = 333 where name = '3';
select * from user where name = '3';

INSERT INTO `user` (`age`, `name`) VALUES (77, '7');
INSERT INTO `user` (`age`, `name`) VALUES (77, '7');


INSERT INTO `user` (`age`, `name`) VALUES (107, '5');


INSERT INTO `user` (`age`, `name`) VALUES (100, '6');
INSERT INTO `user` (`age`, `name`) VALUES (100, '7');
select * from user where name = 8 for update;

update user set age = 333 where name = '300';
select * from user where name='7' for update;


select * from user where name between 300 and 400 for update;
INSERT INTO `user` (`age`, `name`) VALUES (1001, '7');


select * from user where name = '111' for update;

INSERT INTO `user` (`name`) VALUES ('111');

INSERT INTO `user` (`id`, `age`, `name`) VALUES (12, 100, '7');

