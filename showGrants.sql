      SELECT r.usename AS grantor,
             e.usename AS grantee,
             nspname,
             privilege_type,
             is_grantable
        FROM pg_namespace
JOIN LATERAL (SELECT *
                FROM aclexplode(nspacl) AS x) a
          ON true
        JOIN pg_user e
          ON a.grantee = e.usesysid
        JOIN pg_user r
          ON a.grantor = r.usesysid 
       WHERE e.usename = 'wsreader';
