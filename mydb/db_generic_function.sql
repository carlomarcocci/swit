CREATE OR REPLACE FUNCTION fn_median (
                                        in_table regclass, 
                                        in_field text, 
                                        in_min float, 
                                        in_max float, 
                                        in_dt timestamp, 
                                        in_mindays int, 
                                        in_days int) 
RETURNS numeric
AS $$
DECLARE 
    l_out   numeric;
    l_num   integer;
BEGIN
    EXECUTE format ('
        SELECT COUNT(*)
        FROM %s
        WHERE dt BETWEEN timestamp ''%s'' - interval ''1d'' * (%s -1) AND timestamp ''%s'' - interval ''1d''
          AND %s BETWEEN %s AND %s
          AND %s IS NOT NULL
          AND extract(hour   from dt) = extract(hour   from timestamp ''%s'')
          AND extract(minute from dt) = extract(minute from timestamp ''%s'')

    ', in_table, in_dt, in_days, in_dt, in_field, in_min, in_max, in_field, in_dt, in_dt)
    INTO l_num;
    IF l_num >= in_mindays THEN
        EXECUTE format('
            SELECT ROUND(CAST(AVG(%s) AS numeric),3)
            FROM (
                SELECT *, ROW_NUMBER () OVER (ORDER BY %s) num
                FROM ( 
                    SELECT dt, %s
                    FROM %s
                        WHERE dt BETWEEN timestamp ''%s'' - interval ''1d'' * (%s -1) AND timestamp ''%s'' - interval ''1d''
                        AND %s BETWEEN %s AND %s
                        AND %s IS NOT NULL
                    ) a
                WHERE extract(hour   from a.dt) = extract(hour   from timestamp ''%s'')
                AND extract(minute from a.dt) = extract(minute from timestamp ''%s'')
                ) b
            WHERE b.num BETWEEN FLOOR((%s+1.0)/2) AND CEILING((%s+1.0)/2)
            ',
            in_field, in_field, in_field, in_table, in_dt, in_days, in_dt, in_field, in_min, in_max, in_field, in_dt, in_dt, l_num, l_num
            )
            INTO l_out;
    ELSE
        SELECT null INTO l_out;
    END IF;
    RETURN l_out;
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;

