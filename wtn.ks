// Warp To Node
PARAMETER lead_time.
SET nd TO NEXTNODE.
PRINT "Lead time: " + lead_time.

IF nd:eta > lead_time + 100000 {
	PRINT "WARP 7".
	SET WARP TO 7.
	WAIT UNTIL nd:eta <= lead_time + 100000.
}

IF nd:eta > lead_time + 10000 {
	PRINT "WARP 6".
	SET WARP TO 6.
	WAIT UNTIL nd:eta <= lead_time + 10000.
}

IF nd:eta > lead_time + 1000 {
	PRINT "WARP 5".
	SET WARP TO 5.
	WAIT UNTIL nd:eta <= lead_time + 1000.
}

IF nd:eta > lead_time + 100 {
	PRINT "WARP 4".
	SET WARP TO 4.
	WAIT UNTIL nd:eta <= lead_time + 100.
}

IF nd:eta > lead_time + 50 {
	PRINT "WARP 3".
	SET WARP TO 3.
	WAIT UNTIL nd:eta <= lead_time + 50.
}

IF nd:eta > lead_time + 10 {
	PRINT "WARP 2".
	SET WARP TO 2.
	WAIT UNTIL nd:eta <= lead_time + 10.
}

IF nd:eta > lead_time + 5 {
	PRINT "WARP 1".
	SET WARP TO 1.
	WAIT UNTIL nd:eta <= lead_time + 5.
}

SET WARP TO 0.
WAIT UNTIL nd:eta <= lead_time.

