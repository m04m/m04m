prompt A conectar daa@e45.pt
conn daa@e45.pt


set termout off

column arq new_value Arquivo
select 'C:\Logs\Acessos\Acessos_Sintra_'||to_char(sysdate,'yyyymmdd_hh24mi')||'.log' arq from dual;
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

Prompt ARIIBUIR ROLES E SIN�NIMOS AO(S) USER(S) - EXECUTAR UMA VEZ PARA CADA USER
EXEC P_SET_USER_SINTRA('&user');

pause
Prompt VERIFICAR ROLES E SIN�NIMOS DO(S) USER(S)
@dba_role_privs
@dba_synonyms
pause

spool off

prompt O utilizador possui privil�gios para poder aceder ao SINTRA,
prompt no entanto, como a BD de HIST�RICO � de READ ONLY, estas altera��es apenas ter�o efeito amanh� 
prompt ap�s o refresh da BD.