select
       n.name event,
       m.wait_count  cnt,
       10*m.time_waited ms,
       nvl(round(10*m.time_waited/nullif(m.wait_count,0),3) ,0) avg_ms
  from v$eventmetric m,
       v$event_name n
  where m.event_id=n.event_id
        and ( wait_class_id= 1740759767 --  User I/O 
             or
             wait_class_id= 4108307767 --  System I/O 
           )
        and m.wait_count > 0 ;