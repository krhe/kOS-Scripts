// LTO Launch to orbit
// This script will launch a vessel to a circular orbit
//
// The script will attempt the following ascent profile:
//   1. Until 5000m in altitude the vessel will go straight up
//   2. From 5000m it will rotate the vessel gradually to a 45 degree angle
//   4. From 40000m it will rotate the vessel gradually to a 90 degree angle
//   5. At the apoapsis it will burn and circularize the orbit
SET target_altitude TO 100000.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
// Setup direction
SET direction TO SHIP:FACING.

// =============================================== 
//  PID-loop (Throttle control)
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.

SET gforce_setpoint TO 1.8.

LOCK Pt TO gforce_setpoint - gforce.
SET It TO 0.
SET Dt TO 0.
SET P0t TO Pt.

SET Kpt TO 0.0025.
SET Kit TO 0.006.
SET Kdt TO 0.006.

LOCK dthrott TO Kpt * Pt + Kit * It + Kdt * Dt.

SET thrott TO 1.
LOCK THROTTLE TO thrott.
SAS ON.
 
// =============================================== 

HUDTEXT("Ignition", 2, 2, 50, green, false).
STAGE.

SET t0 TO TIME:SECONDS.
SET t0p TO TIME:SECONDS.
SET fuel0 TO STAGE:LIQUIDFUEL.

WHEN ALTITUDE > 5000 THEN {
	HUDTEXT("Beginning gravity turn!", 2, 2, 50, green, false).	
}

UNTIL ALT:APOAPSIS > target_altitude {
    SET dt TO TIME:SECONDS - t0.
	
	// PID-Loop
    IF dt > 0 {
		// Throttle control
		SET It TO It + Pt * dt.
		SET Dt TO (Pt - P0t) / dt.
		SET thrott to thrott + dthrott.
		SET P0t TO Pt.
		SET t0 TO TIME:SECONDS.
    }	
	
	IF ALTITUDE > 1000 
	{
		IF (ALTITUDE < 60000)
		{
			SET SASMODE TO "STABILITYASSIST".
			LOCK STEERING TO direction+R(0,-70*(ALTITUDE-1000)/(60000-1000),0).
		}
		ELSE
		{
			LOCK STEERING TO direction+R(0,-70,0).
		}
	}
	
    //recalculate current max_acceleration, as it changes while we burn through fuel
    SET max_acc TO ship:maxthrust/ship:mass.
	IF max_acc < 0.0001 {
		HUDTEXT("Staging", 2, 2, 50, green, false).
		STAGE.
		WAIT 0.5.
		STAGE.
		HUDTEXT("Ignition!", 2, 2, 50, green, false).		
		SET fuel0 TO STAGE:LIQUIDFUEL.			
	}
		
    WAIT UNTIL TRUE.
}

SET thrott TO 0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

HUDTEXT("Coasting until the end of the atmosphere!", 2, 2, 50, green, false).
WAIT UNTIL ALTITUDE > 70000.

PANELS ON.

run cap.
run xnd.





