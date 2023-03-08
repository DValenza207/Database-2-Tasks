set search_path to prog2;

explain analyze SELECT zid                                  --Planning Time:34.349 ms
FROM Zookeeper 												--Execution Time:1.620 ms
WHERE zid IN (SELECT zid FROM Daily_Feeds WHERE menu = 10);

--miglioramento
select distinct zid into temp                               
from Daily_Feeds where menu=10;

explain analyze												--Planning Time: 0.192 ms
select Zookeeper.zid 										--Execution Time: 0.606 ms
from Zookeeper, temp
where Zookeeper.zid=temp.zid;


