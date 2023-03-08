SET search_path TO Prog2;


create index zookeeperbtree on zookeeper using btree(salary);
cluster zookeeper using zookeeperbtree;
explain analyze SELECT * -- Rows Removed by Filter: 60
FROM zookeeper			 -- Planning time: 0.043 ms
WHERE salary < 197;		 -- Execution time: 0.475 ms

--Dopo aver clusterizzato con l'indice btree il Planning Time è di 0.299 ms e l'execution time è di 0.460 ms

create index dailyfeedsbtree on daily_feeds using btree(menu);
cluster daily_feeds using dailyfeedsbtree;
explain analyze SELECT aname, zname, aid  --Rows Removed by Filter: 795000 
FROM daily_feeds NATURAL JOIN animal	  --Planning time: 0.276 ms
                 NATURAL JOIN zookeeper	  --Execution time: 11.118 ms
WHERE menu = 3;

--Dopo aver clusterizzato con l'indice btree il Planning Time è 0.360 ms e l'execution time è di 6.446 ms


create index animalbtree on animal using btree(species);
cluster animal using animalbtree;
explain analyze SELECT clocation		--Rows Removed by Filter: 39990
FROM cage JOIN animal ON cid = cage		--Planning time: 0,090 ms
WHERE species = 1;						--Execution time: 3.419 ms

-- Dopo aver clusterizzato con l'indice btree il Planning Time è 0.314 ms e l'execution time è di 0.720 ms

create index clocation_hash on cage using hash(clocation);
create index shift_hash on daily_feeds using hash(shift);
create index zookeeperhash on zookeeper using hash(salary);
explain analyze SELECT zname						 --Rows Removed by Filter: 53426
FROM zookeeper NATURAL JOIN daily_feeds				 --Planning time: 0.219 ms
               NATURAL JOIN animal					 --Execution time: 14.950 ms
               JOIN cage ON cid = cage 
WHERE salary >= 150 AND shift = 3 AND clocation = 1;

--Dopo aver creato l'indice hash il Planning time è di 0.208 ms e l'Execution time è di 14.858 ms

create index btreespecies on animal using btree(species);
cluster animal using btreespecies;
create index btreemenu on daily_feeds using btree(menu);
cluster daily_feeds using btreemenu;
explain analyze SELECT clocation, menu	--Planning time: 0.193 ms
FROM cage JOIN animal ON cid = cage		--Execution time: 0.849 ms
          NATURAL JOIN daily_feeds
WHERE species = 1 AND menu = 3;

--Dopo aver clusterizzato con l'indice btreespecies il Planning Time è 0.181 ms e l'Execution Time è 0.648 ms
--Dopo aver clusterizzato con l'indice btreemenu il Planning Time è 0.171 ms e l'Execution Time è 0.586 ms


create index cagebtree on cage using btree(cname);
cluster cage using cagebtree;
explain analyze SELECT COUNT(*) AS num_animal  --Rows Removed by Filter:1921
FROM cage JOIN animal ON cid = cage			   --Planning time: 0.160 ms
WHERE cname LIKE 'a%'						   --Execution time: 9.996 ms
GROUP BY cid, species;

--Dopo aver clusterizzato con l'indice btree il Planning Time è 0.127 ms e l'Execution Time è 9.815 ms

