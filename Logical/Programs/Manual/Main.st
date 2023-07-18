
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC

	gAxis_1;
	
	IF ManualStop THEN
		gActuatorByte := 2#0000_0000_0000_0000;
	END_IF;
	
	ManualDistance;
	
	CASE ManualStep OF
		MANUAL_START:
			IF ManualStart THEN		//AND (NOT AutoStart) - zeby nie szlo tego wlaczyc gdy jest tryb automatyczny
				ManualStep := MANUAL_WAIT;
			END_IF;
		MANUAL_WAIT:
			IF ManualActuatorDozing THEN
				gActuatorByte := 2#0000_0000_0000_0000;
				gActuatorByte := 2#0000_0000_0000_0100;
			ELSIF ManualActuatorSorting THEN
				gActuatorByte := 2#0000_0000_0000_0000;
				gActuatorByte := 2#0000_0000_0000_0001;	
			ELSIF ManualActuatorBoth THEN
				gActuatorByte := 2#0000_0000_0000_0000;
				gActuatorByte := 2#0000_0000_0000_0101;
			ELSIF BeltMove THEN
				
				
			END_IF;
			
					
				
		  

	END_CASE;
	
	gMotorBeltAxisBasic();
	
//	gMotorBeltAxisBasic.MpLink := ADR(gAxis_1);
//	gMotorBeltAxisBasic.Enable := TRUE;
//	gMotorBeltAxisBasic.Parameters := ADR(gMotorBeltParType);
//	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

