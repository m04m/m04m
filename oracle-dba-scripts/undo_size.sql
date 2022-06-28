-- Actual Undo Size
SELECT SUM(a.bytes)/1024/1024 "UNDO_SIZE_MB"
  FROM v$datafile a,
       v$tablespace b,
       dba_tablespaces c
 WHERE c.contents = 'UNDO'
   AND c.status = 'ONLINE'
   AND b.name = c.tablespace_name
   AND a.ts# = b.ts#; 

-- Undo Blocks per Second   
SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
      "UNDO_BLOCK_PER_SEC"
  FROM v$undostat; 

-- DB Block Size
SELECT TO_NUMBER(value) "DB_BLOCK_SIZE [Byte]"
FROM v$parameter
WHERE name = 'db_block_size'; 

-- Optimal Undo Retention
SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
       SUBSTR(e.value,1,25) "UNDO RETENTION [Sec]",
       ROUND((d.undo_size / (to_number(f.value) *
       g.undo_block_per_sec))) "OPTIMAL UNDO RETENTION [Sec]"
  FROM (
       SELECT SUM(a.bytes) undo_size
          FROM v$datafile a,
               v$tablespace b,
               dba_tablespaces c
         WHERE c.contents = 'UNDO'
           AND c.status = 'ONLINE'
           AND b.name = c.tablespace_name
           AND a.ts# = b.ts#
       ) d,
       v$parameter e,
       v$parameter f,
       (
       SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
              undo_block_per_sec
         FROM v$undostat
       ) g
WHERE e.name = 'undo_retention'
  AND f.name = 'db_block_size'
/

--  Calculate Needed UNDO Size for given Database Activity  
SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
       SUBSTR(e.value,1,25) "UNDO RETENTION [Sec]",
       (TO_NUMBER(e.value) * TO_NUMBER(f.value) *
       g.undo_block_per_sec) / (1024*1024) 
      "NEEDED UNDO SIZE [MByte]"
  FROM (
       SELECT SUM(a.bytes) undo_size
         FROM v$datafile a,
              v$tablespace b,
              dba_tablespaces c
        WHERE c.contents = 'UNDO'
          AND c.status = 'ONLINE'
          AND b.name = c.tablespace_name
          AND a.ts# = b.ts#
       ) d,
      v$parameter e,
       v$parameter f,
       (
       SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
         undo_block_per_sec
         FROM v$undostat
       ) g
 WHERE e.name = 'undo_retention'
  AND f.name = 'db_block_size'
/
