
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpAlarmXCore_0.Enable := TRUE;
	MpAlarmXCore_0.MpLink := ADR(gAlarmXCore);
	MpAlarmXCore_0();
	
	MpAlarmXHistory_0.Enable := TRUE;
	MpAlarmXHistory_0.MpLink := ADR(gAlarmXHistory);
	MpAlarmXHistory_0();
	
	redIconTimer.PT := T#500ms;
	redIconTimer();
	
	isAcknowledged := MpAlarmXCheckState(gAlarmXCore, 'test_alarm', mpALARMX_STATE_ACKNOWLEDGED);

	IF (MpAlarmXCore_0.PendingAlarms > 0) THEN
		pendingAlarms := TRUE;
	ELSE
		pendingAlarms := FALSE;
	END_IF;
	
	IF (MpAlarmXCore_0.ActiveAlarms = 0 AND MpAlarmXCore_0.PendingAlarms > 0) THEN
		enableYellowIcon := TRUE;
	ELSE
		enableYellowIcon := FALSE;
	END_IF;
	
	IF (MpAlarmXCore_0.ActiveAlarms > 0) THEN
		gAlarmExist := TRUE;
		IF (NOT(isAcknowledged)) THEN
			//blinking
			IF (redIconTimer.IN = FALSE) THEN
				redIconTimer.IN := TRUE;
			ELSIF (redIconTimer.Q) THEN
				timerCycle := NOT timerCycle;
				redIconTimer.IN := FALSE;
			END_IF;
			enableRedIcon := timerCycle;
		ELSE
			//static
			enableRedIcon := TRUE;
		END_IF;
	ELSE
		gAlarmExist := FALSE;
		enableRedIcon := FALSE;
	END_IF;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

