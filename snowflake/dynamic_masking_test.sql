--# 1 # Set Database and Role:

    USE DEMO_DB;
    USE ROLE ACCOUNTADMIN;

--# 2 # Create table and loading:
    CREATE OR REPLACE TABLE clientes (
    id int NOT NULL identity,
    nome varchar,
    email varchar,
    fone varchar,
    empresa varchar);


--Data Generated on https://www.generatedata.com/
    INSERT INTO clientes (nome,email,fone,empresa) 
    VALUES 
        ('Brent B. Carlson','ut.odio.vel@Integer.org','(016795) 97837','Amet Orci Corporation'),
        ('Alana Q. Morales','augue.Sed.molestie@ornaretortor.com','(0111) 314 3921','Vestibulum Mauris Corporation'),
        ('Orla N. Stewart','Phasellus.libero@Suspendisseeleifend.org','07624 540132','Id Libero Donec LLC'),
        ('Roary K. Carson','eget.venenatis@elit.org','076 5015 4917','Semper Corporation'),
        ('Giselle J. Ferrell','Cras.eget.nisi@acmattissemper.ca','(013477) 01946','Vehicula Corp.'),
        ('Ciaran S. Contreras','fermentum.convallis@varius.org','(0121) 414 4017','Adipiscing Non Luctus LLC'),
        ('Imelda Z. Beasley','Cras.vulputate@purusMaecenaslibero.net','0800 1111','Interdum Feugiat Limited'),
        ('Tarik D. Foley','enim@turpisvitaepurus.co.uk','070 6999 2821','A Enim Incorporated'),
        ('Abel D. Burris','neque@dolor.co.uk','(016977) 4404','Vel PC'),
        ('Chava F. Barrett','eu@Nullam.net','056 3903 6598','Sit LLP');



--# 3 # Creating Roles and giving privileges to them:
    CREATE OR REPLACE ROLE RL_MASKED; --> Set to read users
    CREATE OR REPLACE ROLE RL_READ_FULL; --> Set to data's owners
    
    GRANT USAGE ON DATABASE DEMO_DB TO ROLE RL_MASKED;
    GRANT USAGE ON DATABASE DEMO_DB TO ROLE RL_READ_FULL;
    GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE RL_MASKED;
    GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE RL_READ_FULL;
    GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CLIENTES TO ROLE RL_MASKED;
    GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CLIENTES TO ROLE RL_READ_FULL;
    GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE RL_MASKED;
    GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE RL_READ_FULL;
    GRANT ROLE RL_MASKED TO USER M04MBR;
    GRANT ROLE RL_READ_FULL TO USER M04MBR;

--# 4 # Creating Masking Policies:
    USE ROLE ACCOUNTADMIN;
    create or replace masking policy policy_nome as
    (val varchar) returns varchar ->
    case
    when
        current_role() in ('RL_READ_FULL') 
        then val
        else substr(val,1,2)||'******'
    end;

    create or replace masking policy policy_email as
    (val varchar) returns varchar ->
    case
    when
        current_role() in ('RL_READ_FULL') 
        then val
        else regexp_replace(val,'.+\@','*****@')
    end;

    create or replace masking policy policy_fone as
    (val varchar) returns varchar ->
    case
    when
        current_role() in ('RL_READ_FULL') 
        then val
        else '(###) ###-####-'||right(val,3)
    end;

--# 5 # Setting columns table to right policies:
    alter table if exists clientes modify column nome set masking policy policy_nome;
    alter table if exists clientes modify column email set masking policy policy_email;
    alter table if exists clientes modify column fone set masking policy policy_fone;

--# 6 # Testing:
    use ROLE RL_MASKED;
    select * from demo_db.public.clientes;
