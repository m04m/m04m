prompt A conectar daa@e49.pt
conn daa@e49.pt

set termout off

column arq new_value Arquivo
select 'C:\Logs\Acessos\Acessos_Discoverer_'||to_char(sysdate,'yyyymmdd_hh24mi')||'.log' arq from dual;
spool &Arquivo

set termout on

Prompt VERIFICAR EXIST�NCIA DO(S) USER(S)
@dba_users
pause

Prompt VERIFICAR ROLES DO(S) USER(S)
@dba_role_privs
Prompt VERIFICAR SIN�NIMOS DO USER
@dba_synonyms
pause

Prompt CONSULTAR C�BULAS - EXECUTAR UMA VEZ PARA CADA USER

pause
Prompt VERIFICAR ROLES E SIN�NIMOS DO(S) USER(S)
@dba_role_privs
@dba_synonyms
pause

spool off

Os privil�gios necess�rios para o(s) utilizador(es) aceder(em) ao DISCOVERER foram concendidos.