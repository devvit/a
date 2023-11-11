
# ~/.oracle/instantclient_19_8/sqlplus system/Pas_w0rd@localhost/XE
# usql oracle://useroracle:passwordoracle@localhost/XE
# pip install cx_Oracle

export OCI_DIR=$HOME/.oracle/instantclient_19_8

export RAILS_MAX_THREADS=1
export DYLD_FALLBACK_LIBRARY_PATH=`asdf where mysql`/lib:$HOME/.oracle/instantclient_19_8
export PGUSER=postgres
export ORACLE_SYSTEM_PASSWORD=Pas_w0rd
export NLS_LANG=AMERICAN_AMERICA.UTF8
