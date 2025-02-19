# NCMV0: 
wget http://172.17.0.1:8080/swit/ais/records/ncmv0 -O ncmv0.out
# NCMR0: 
wget http://172.17.0.1:8080/swit/ais/records/ncmr0 -O ncmr0.out
# FCMV0: 
http://172.17.0.1:8080/swit/ais/records/fcmv0 -O fcmv0.out

# SCINT:
#	1. DMC0P: 
wget http://172.17.0.1:8080/swit/scintillation/records/dmc0p -O dmc0p.out
#	2. DMC0S: 
wget http://172.17.0.1:8080/swit/scintillation/records/dmc0s -O dmc0s.out
#	3. KIL0N: 
wget http://172.17.0.1:8080/swit/scintillation/records/kil0n -O kil0n.out
#	4. SAN0P: 
wget http://172.17.0.1:8080/swit/scintillation/records/san0p -O san0p.out

# IONOSONDES:
#   1. RM041_AUTO: 
wget http://172.17.0.1:8080/swit/ais/records/rm041_auto -O rm041_auto.out
#	2. RM041_RDF: 
wget http://172.17.0.1:8080/swit/ais/records/rm041_rdf -O rm041_rdf.out
#3. RO041_AUTO: 
wget http://172.17.0.1:8080/swit/ais/records/ro041_auto -O ro041_auto.out
# SO148
wget http://172.17.0.1:8080/swit/ais/records/so148_auto -O so148_auto.out

#- TEC:
#	1. NC_MED: 
wget http://172.17.0.1:8080/swit/tecdb/records/nc_med -O nc_med.out
#	2. NC_GL: 
wget http://172.17.0.1:8080/swit/tecdb/records/nc_gl -O nc_gl.out
#	3. NC_EU: 
wget http://172.17.0.1:8080/swit/tecdb/records/nc_eu -O nc_eu.out
