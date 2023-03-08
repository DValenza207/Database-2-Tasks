SET search_path TO Prog2;

SELECT relname, reltuples, relpages FROM pg_class WHERE relname IN ('zookeeper', 'daily_feeds', 'animal', 'cage');
DROP SCHEMA IF EXISTS Prog2 CASCADE; 
CREATE SCHEMA Prog2; 
SET search_path TO Prog2; 
create table Prog2.zookeeper ( 
        zid int, 
        zname varchar(100), 
        salary bigint, 
        age integer, 
        dummy0 char(200) 
); 
create table Prog2.cage ( 
        cid smallint, 
        cname varchar(200), 
        clocation bigint ,
        dummy0 char(256),
        dummy1 char(256),
        dummy2 char(256),
        dummy3 char(256),
        dummy4 char(256),
        dummy5 char(256),
        dummy6 char(256),
        dummy7 char(256)
); 
create table Prog2.animal ( 
        aid int, 
        cage smallint, 
        aname varchar(2), 
        species smallint 
); 
create table Prog2.daily_feeds ( 
        aid int, 
        zid int, 
        shift smallint, 
        menu smallint 
); 



