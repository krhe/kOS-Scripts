// Calculating required delta-v to circularize orbit
SET target_speed TO SQRT(KERBIN:MU / (APOAPSIS + KERBIN:RADIUS)).
SET vpredicted TO VELOCITYAT(SHIP, ETA:APOAPSIS + TIME:SECONDS).
SET deltav TO target_speed - vpredicted:orbit:mag.
SET max_acc TO ship:maxthrust/ship:mass.
SET burn_duration TO deltav/max_acc.

PRINT "Apoapsis in   : " + ETA:APOAPSIS.
PRINT "Req. speed    : " + target_speed.
PRINT "Req. delta-v  : " + deltav.
PRINT "Burn duration : " + burn_duration.

// Adding a node with the required burn
SET nd TO NODE(ETA:APOAPSIS + TIME:SECONDS, 0, 0, deltav).
ADD nd.