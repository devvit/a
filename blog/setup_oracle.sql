alter session set "_ORACLE_SCRIPT"=TRUE;

CREATE TABLESPACE indx_oracledb DATAFILE 'indx_oracledb.dbf' SIZE 200M SEGMENT SPACE MANAGEMENT AUTO;
DROP TABLESPACE indx_oracledb INCLUDING CONTENTS AND DATAFILES;
CREATE USER useroracle IDENTIFIED BY passwordoracle DEFAULT TABLESPACE indx_oracledb;
GRANT connect,dba TO useroracle;

select * from global_name;

SELECT * FROM all_users;
SELECT * FROM dba_users;
SELECT * FROM user_users;

select table_name from dba_tables;
select table_name   from all_tables;
select table_name   from user_tables;

SELECT DISTINCT sgm.TABLESPACE_NAME , dtf.FILE_NAME
FROM DBA_SEGMENTS sgm
JOIN DBA_DATA_FILES dtf ON (sgm.TABLESPACE_NAME = dtf.TABLESPACE_NAME)
WHERE sgm.OWNER = 'SCOTT'
