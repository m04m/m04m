undefine 1

set termout off

column arq new_value Arquivo
select 'C:\Logs\Acessos\Acessos_Sarin_'||to_char(sysdate,'yyyymmdd_hh24mi')||'.log' arq from dual;
spool &Arquivo

set termout on

Prompt VERIFICAR EXIST�NCIA DO(S) USER(S)
@dba_users '&&1'
pause

Prompt VERIFICAR ROLES DO(S) USER(S)
@dba_role_privs '&&1'
Prompt VERIFICAR SIN�NIMOS DO USER
@dba_synonyms '&&1'
pause

Prompt ATRIBUIR ROLES E SIN�NIMOS AO(S) USER(S)
GRANT RSAI_01 TO &&1;
@sinonimos_sarin

pause
Prompt VERIFICAR ROLES E SIN�NIMOS DO(S) USER(S)
@dba_role_privs '&&1'
@dba_synonyms '&&1'
pause

spool off

prompt Foram dados privil�gios ao user &&1 para aceder ao SARIN.
prompt � favor testar
prompt O user &&1 possui privil�gios para aceder ao SARIN.
prompt � favor testar

undefine 1