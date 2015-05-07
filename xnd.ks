// Execute the next node
// A test comment
SET do_staging TO 1.
SET nd TO NEXTNODE.
SET max_acc TO ship:maxthrust/ship:mass.
SET burn_duration TO nd:deltav:mag/max_acc.
SAS OFF.

PRINT "Waiting until turn".
RUN wtn(burn_duration/2 + 60).

// Calculate required direction
PRINT "Turning ship".
SET np TO lookdirup(nd:deltav, ship:facing:topvector).
LOCK steering TO np.

//now we need to wait until the burn vector and ship's facing are aligned
WAIT UNTIL abs(np:pitch - facing:pitch) < 0.15 and abs(np:yaw - facing:yaw) < 0.15.

//the ship is facing the right direction, let's wait for our burn time
RUN wtn(burn_duration/2).
// Execute the node

SET tset TO 0.
LOCK throttle TO tset.

SET done TO False.
//initial deltav
SET dv0 TO nd:deltav.
SET fuel0 TO STAGE:LIQUIDFUEL.


UNTIL done
{	
    SET max_acc TO ship:maxthrust/ship:mass.
	SET np TO lookdirup(nd:deltav, ship:facing:topvector).
	LOCK steering TO np.
	
	IF max_acc > 0.0001 {
		SET tset TO min(nd:deltav:mag/max_acc, 1).

		IF vdot(dv0, nd:deltav) < 0 {
			SET tset TO 0.
			WAIT UNTIL abs(np:pitch - facing:pitch) < 0.15 and abs(np:yaw - facing:yaw) < 0.15.			
			SET tset TO min(nd:deltav:mag/max_acc, 1).
		}

		IF nd:deltav:mag < 0.1 {
			//WAIT UNTIL vdot(dv0, nd:deltav) < 0.5.
			LOCK throttle TO 0.
			SET done TO TRUE.
			HUDTEXT("Burn completed!", 2, 2, 50, green, false).		
		}		
	}
	ELSE {
		IF do_staging {
			HUDTEXT("Staging", 2, 2, 50, green, false).
			STAGE.
			WAIT 0.5.
			STAGE.
			HUDTEXT("Ignition!", 2, 2, 50, green, false).		
		}
		ELSE
		{
			HUDTEXT("Burn failed, not enough fuel!", 2, 2, 50, green, false).		
			SET done TO TRUE.
		}
	}
	
	WAIT UNTIL TRUE.
}
WAIT 2.
UNLOCK steering.
UNLOCK throttle.
WAIT 1.

//we no longer need the maneuver node
REMOVE nd.

//set throttle to 0 just in case.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.