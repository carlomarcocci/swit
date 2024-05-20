%Convert horizontal coordinates (azimuth, zenith angle) to geocentric geographic coordinates of the subsatellite or subionospheric point.
%
% CALLING SEQUENCE:
%       coord = top2geo(phi0,lam0, hs, az, zen)
%       
% 
% INPUTS:
%       PHI0:  	latitude of the observation point in degrees
%		LAM0:	longitude of the observation point in degrees
%		HS:		height of the satellite or ionosphere above the Earth surface in km
%		AZ:		vector of azimuths from north eastward in degrees
%		ZEN:	vector of zenith angles in degrees
%
% OUTPUTS:
%       coord: matrix of latitudes (1) and logitudes (2) of the IPP's
%
% MODIFICATION HISTORY:
%       Written by for IDL:  A.W. Wernik, February 2004 
%       Converted for root/C/C++: L. Spogli, October 2009
%       Converted for Matlab: L. Spogli, April 2016

function coord=top2geo(stalat,stalon,h,az,zen)
% addpath('/media/luca/External_HD/Routines_Matlab/Utili/Geodetic');

Re=6373; %Earth's radius

%coversion to radians
stalat=stalat*pi/180;
stalon=stalon*pi/180;
az=az.*pi/180;
zen=zen.*pi/180;

%angle between geocentre and observing station from the satellite
sbet=Re*sin(zen)/(Re+h);
bet=asin(sbet);

 %angle from the geocenter between observer and satellite
  alf=zen-bet;

%geographic latitude of subsatellite point
phi=asin(sin(stalat).*cos(alf)+cos(stalat).*sin(alf).*cos(az));

%geographic longitude of the subsatellite point
slam=sin(alf).*sin(az)./cos(phi);
clam=(cos(alf)-sin(stalat).*sin(phi))./cos(stalat)./cos(stalat);
lam=stalon+atan2(slam,clam);

coord = [phi.*(180/pi) lam.*(180/pi)];

end
