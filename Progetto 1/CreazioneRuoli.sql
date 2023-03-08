set search_path to Progetto1;

--3
create role amministratoreBanca;
create role responsabileCat;
create role correntista;
create role utente;

grant utente to correntista;
grant correntista to responsabileCat with admin option;
grant responsabileCat to amministratoreBanca with admin option;

grant create on schema Progetto1 TO amministratoreBanca;

select rolname, oid from pg_roles;

create user Alice;
create user Bianca;
create user Carlo;
create user Luca;
create user Nino;
grant amministratoreBanca to Nino with admin option;
grant correntista to luca;
grant utente to alice;
grant utente to bianca;
grant utente to carlo;


create user Donatella;
create user Elena;
create user Fabio;
create user Olga;

select usename, usesysid from pg_user;

set role to nino;

grant responsabileCat to Donatella;
grant responsabileCat to Elena;
grant responsabileCat to Fabio;

--Nino può delegare ad Olga i ruoli di Correntista, responsabileCat e amministratoreBanca
grant correntista to Olga;
grant responsabileCat to Olga;
grant amministratoreBanca to Olga;

set role to postgres;
grant usage on schema progetto1 to Alice with grant option;
grant usage on schema progetto1 to Bianca with grant option;
grant usage on schema progetto1 to Carlo with grant option;
grant usage on schema progetto1 to Luca with grant option;
grant usage on schema progetto1 to Nino with grant option;
grant usage on schema progetto1 to Donatella with grant option;
grant usage on schema progetto1 to Elena with grant option;
grant usage on schema progetto1 to Fabio with grant option;
grant usage on schema progetto1 to Olga with grant option;

--query da eseguire sui cataloghi per veriﬁcare l’avvenuta concessione dei ruoli.

SELECT usename, rolname
FROM pg_user JOIN pg_auth_members ON usesysid = member
    JOIN pg_roles ON oid = roleid
ORDER BY 1;

SELECT usename, string_agg(rolname, ', ') AS rolname
FROM pg_user JOIN pg_auth_members ON usesysid = member
    JOIN pg_roles ON oid = roleid
GROUP BY 1
ORDER BY 1;

--4
GRANT ALL PRIVILEGES ON SCHEMA Progetto1 TO AmministratoreBanca;
GRANT CREATE ON SCHEMA Progetto1 TO ResponsabileCat;
GRANT INSERT, SELECT ON Inserzione TO Utente;
GRANT SELECT ON Prestazione TO Utente;



--do il privilegio ad un utente direttamente senza passare dal ruolo
GRANT CREATE ON SCHEMA Progetto1 TO Alice;
GRANT UPDATE ON Prestazione TO Alice;
GRANT INSERT ON Prestazione TO Luca;
GRANT INSERT, SELECT, UPDATE on categoria to Bianca;
GRANT UPDATE on inserzione to Bianca;

--query che serve per costruire la tabella
SELECT grantee, table_name, string_agg(privilege_type, ', ') AS privilege_type
FROM information_schema.role_table_grants
WHERE table_name IN ('prestazione', 'inserzione', 'categoria', 'correntista')
GROUP BY grantee, table_name;

--5
revoke select on Prestazione from utente;
revoke update on Prestazione from Alice;
revoke insert on Prestazione from Luca;

create or replace view primavista as
SELECT COUNT(*) AS num_prestazioni, COUNT(DISTINCT email) AS num_utenti, ROUND(AVG(voto), 2) AS valutazione_media
FROM inserzione i JOIN prestazione p ON p.idIns = i.id
GROUP BY email, codCat;

grant select on primavista to utente;
--grant select on primavista to Alice;
grant select on primavista to Luca;


create or replace view saldopositivo as 
SELECT email, (CASE WHEN saldo > 0 THEN saldo
                    ELSE NULL
                END) AS saldo
FROM correntista;

grant select on saldopositivo to utente;

/*
Sarebbe possibile e come fare si che i correntisti possano consultare solo le informazioni ad essi riferite?
Sì, è possibile, bisogna confrontare l'attributo email della relazione Correntista con la variabile session_user, che restituisce il nome dell’utente loggato.
è possibile creare interrogazioni nelle quali si può specificare la condizione nella clausola WHERE correntista.email=session_user.	
*/


SELECT grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name='primavista';

SELECT grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name='saldopositivo';


--6
REVOKE SELECT ON categoria from Bianca restrict;
REVOKE UPDATE, INSERT on categoria from Bianca cascade;

SELECT grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name='categoria';

REVOKE responsabileCat from Olga restrict;
REVOKE amministratoreBanca from Nino cascade;

SELECT usename, string_agg(rolname, ', ') AS rolname
FROM pg_user JOIN pg_auth_members ON usesysid = member
    JOIN pg_roles ON oid = roleid
GROUP BY 1
ORDER BY 1;

