\c scint

CREATE OR REPLACE FUNCTION fn_gmttime2date (
                                        in_week int,
                                        in_sec  int
                                        )
RETURNS timestamp
AS $$
BEGIN
    RETURN  TO_TIMESTAMP('1980-01-06 00:00:00',  'YYYY-MM-DD HH24:MI:SS') + MAKE_INTERVAL(WEEKS => in_week, SECS => in_sec);
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_gmttime2date OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_s4_l1_vert (
                                        in_totalS4L1        float,
                                        in_correctionS4L1   float,
                                        in_pL1              float,
                                        in_elevation        float
                                        )
RETURNS float
AS $$
BEGIN
    RETURN fn_s4_l1_slant(in_totalS4L1, in_correctionS4L1) / POW(fn_F(in_elevation), ( in_pL1+1)/4) ;
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_s4_l1_vert OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_phi60_l1_vert (
                                        in_phi60l1slant float, 
                                        in_elevation    float
                                        )
RETURNS float
AS $$
BEGIN
    RETURN in_phi60l1slant / POW(fn_F(in_elevation), 0.5);
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_phi60_l1_vert OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_stec (
                                        in_tec0     float,
                                        in_tec15    float,
                                        in_tec30    float,
                                        in_tec45    float
                                        )
RETURNS float
AS $$
BEGIN
    RETURN (in_tec0+in_tec15+in_tec30+ in_tec45)/4;
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_stec OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_vtec (
                                        in_tec0         float,
                                        in_tec15        float,
                                        in_tec30        float,
                                        in_tec45        float,
                                        in_elevation    float
                                        )
RETURNS float
AS $$
BEGIN
    RETURN (in_tec0+in_tec15+in_tec30+ in_tec45) / (fn_F(in_elevation) * 4);
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_vtec OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_F (
                                        in_elevation    float
                                        )
RETURNS float
AS $$
BEGIN
    RETURN 1/SQRT(1-POW((6371 * COS(RADIANS(in_elevation)) / 6721 ), 2));
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_F OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_s4_l1_slant (
                                        in_totalS4L1        float,
                                        in_correctionS4L1   float
                                        )
RETURNS float
AS $$
BEGIN
    IF ((POW(in_totalS4L1, 2) - POW(in_correctionS4L1, 2)) > 0) THEN
        RETURN SQRT(POW(in_totalS4L1, 2) - POW(in_correctionS4L1, 2));
    ELSE
        RETURN 0;
    END IF;
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_s4_l1_slant OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_s4_l2_vert (
                                        in_totalS4_L2C      float,
                                        in_correctionS4_L2C float,
                                        in_p_l2c            float,
                                        in_elevation        float
                                        )
RETURNS float
AS $$
BEGIN
    RETURN fn_s4_l2_slant( in_totalS4_L2C, in_correctionS4_L2C) / POW(fn_F(in_elevation), ((in_p_l2c +1)/4)) ;
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_s4_l2_vert OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_phi60_l2_vert (
                                            in_phi60_l2c float,
                                            in_elevation float
                                        )
RETURNS float
AS $$
BEGIN
    RETURN in_phi60_l2c / POW(fn_F(in_elevation), 0.5);
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION fn_s4_l2_slant (
                                            in_totalS4_L2C      float,
                                            in_correctionS4_L2C float
                                        )
RETURNS float
AS $$
BEGIN
    IF ( (POW(in_totalS4_L2C, 2) - POW(in_correctionS4_L2C, 2) ) > 0) THEN
        RETURN SQRT( POW(in_totalS4_L2C, 2) - POW(in_correctionS4_L2C, 2));
    ELSE
        RETURN 0;
    END IF;
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_s4_l2_slant OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_s4_l5_vert (
                                            in_totalS4_L5       float,
                                            in_correctionS4_L5  float,
                                            in_p_l5             float,
                                            in_elevation        float
                                        )
RETURNS float
AS $$
BEGIN
    RETURN fn_s4_l5_slant(in_totalS4_L5, in_correctionS4_L5) / POW(fn_F(in_elevation), ((in_p_l5 +1)/4)) ;
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_s4_l5_vert OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_phi60_l5_vert (
                                        in_phi60_l5     float,
                                        in_elevation    float
                                        )
RETURNS float
AS $$
BEGIN
    RETURN in_phi60_l5 / POW(fn_F(in_elevation), 0.5);
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_phi60_l5_vert OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_s4_l5_slant (
                                        in_totalS4_L5       float,
                                        in_correctionS4_L5  float
                                        )
RETURNS float
AS $$
BEGIN
    IF ( (POW(in_totalS4_L5, 2) - POW(in_correctionS4_L5, 2)) >0 ) THEN
        RETURN SQRT( POW(in_totalS4_L5, 2) - POW(in_correctionS4_L5, 2));
    ELSE
        RETURN 0;
    END IF;
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_s4_l5_slant OWNER TO scintu;

CREATE OR REPLACE FUNCTION fn_ismr_latlon (
                                        in_ll       int,
                                        in_stalat   float,
                                        in_stalon   float,
                                        in_az       float,
                                        in_el       float
                                        )
RETURNS float
AS $$
    DECLARE l_lat       float := 0;
            l_lon       float := 0;
            l_sbet      float;
            l_bet       float;
            l_alf       float;
            l_phi       float;
            l_slam      float;
            l_clam      float;
            l_lam       float;
            l_zen       float;
            l_Re        float := 6373;
            l_h         float := 350;
BEGIN
    -- Re=6373; %Earth's radius
    -- %coversion to radians
    -- stalat=stalat*pi/180;
    -- stalon=stalon*pi/180;
    -- az=az.*pi/180;
    -- zen=zen.*pi/180;

    in_stalon       := RADIANS(in_stalon);
    in_stalat       := RADIANS(in_stalat);
    in_az           := RADIANS(in_az);
    l_zen           := RADIANS(90-in_el );

    -- %angle between geocentre and observing station from the satellite
    -- sbet=Re*sin(zen)/(Re+h);
    l_sbet := l_Re * SIN(l_zen)/(l_Re + l_h);
    -- bet=asin(sbet);
    l_bet   := ASIN(l_sbet);
    --  %angle from the geocenter between observer and satellite
    --  alf=zen-bet;
    l_alf   := l_zen - l_bet;

    -- %geographic latitude of subsatellite point
    -- phi=asin(sin(stalat).*cos(alf)+cos(stalat).*sin(alf).*cos(az));
    l_phi   := ASIN(SIN(in_stalat) * COS(l_alf) + COS(in_stalat) * SIN(l_alf) * COS(in_az));

    -- %geographic longitude of the subsatellite point
    -- slam=sin(alf).*sin(az)./cos(phi);
    l_slam  := SIN(l_alf) * SIN(in_az) / COS(l_phi);
    -- clam=(cos(alf)-sin(stalat).*sin(phi))./cos(stalat)./cos(stalat);
    l_clam  := (COS(l_alf) - SIN(in_stalat) * SIN(l_phi)) / COS(in_stalat) / COS(in_stalat);
    -- lam=stalon+atan2(slam,clam);
    l_lam   := in_stalon + ATAN2(l_slam, l_clam);

    -- coord := [phi.*(180/pi) lam.*(180/pi)];

    -- 1: lat
    -- 0: lon
    IF in_ll=1 THEN
        RETURN DEGREES(l_phi);
    ELSEIF in_ll = 0 THEN
        -- if lon>180 lon=180-lon else end
        IF DEGREES(l_lam) > 180 THEN
            -- RETURN 180 - DEGREES(l_lam);
            RETURN -360 + DEGREES(l_lam);
        ELSE
            RETURN DEGREES(l_lam);
        END IF;
    ELSE
        RETURN NULL;
    END IF;
END;
$$  LANGUAGE PLPGSQL
    SECURITY DEFINER
    RETURNS NULL ON NULL INPUT;
ALTER FUNCTION fn_ismr_latlon OWNER TO scintu;

