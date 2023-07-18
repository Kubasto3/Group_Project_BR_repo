
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC

	gAxis_1;
	
	IF ManualStop THEN
		ManualStop := 0;
		gActuatorByte := 2#0000_0000_0000_0000;
		ManualStep := MANUAL_START;
	END_IF;
	
	ManualDistance;
	gMotorBeltParType.Distance;
	
	CASE ManualStep OF
		MANUAL_START:
			IF ManualStart THEN		//AND (NOT AutoStart) - zeby nie szlo tego wlaczyc gdy jest tryb automatyczny
				ManualStart := 0;
				ManualStep := MANUAL_WAIT;
			END_IF;
			
		MANUAL_WAIT:
			IF ManualActuatorDosing THEN
				ManualActuatorDosing := 0;
				ManualStep := MANUAL_ACTUATOR_DOSING;
			ELSIF ManualActuatorSorting THEN
				ManualActuatorSorting := 0;
				ManualStep := MANUAL_ACTUATOR_SORTING;
			ELSIF ManualActuatorBoth THEN
				ManualActuatorBoth := 0;
				ManualStep := MANUAL_ACTUATOR_BOTH;
			ELSIF ManualActuatorNone THEN
				ManualActuatorNone := 0;
				ManualStep := MANUAL_ACTUATOR_NONE;
			ELSIF BeltMove THEN
				BeltMove := 0;
				ManualStep := MANUAL_BELT_MOVE;
			END_IF;
			
		MANUAL_ACTUATOR_DOSING:
			gActuatorByte := 2#0000_0000_0000_0000;
			gActuatorByte := 2#0000_0000_0000_0100;
			ManualStep := MANUAL_WAIT;
			
		MANUAL_ACTUATOR_SORTING:
			gActuatorByte := 2#0000_0000_0000_0000;
			gActuatorByte := 2#0000_0000_0000_0001;	
			ManualStep := MANUAL_WAIT;
			
		MANUAL_ACTUATOR_BOTH:
			gActuatorByte := 2#0000_0000_0000_0000;
			gActuatorByte := 2#0000_0000_0000_0101;
			ManualStep := MANUAL_WAIT;
			
		MANUAL_ACTUATOR_NONE:
			gActuatorByte := 2#0000_0000_0000_0000;
			ManualStep := MANUAL_WAIT;
			
		MANUAL_BELT_MOVE:
			IF gMotorBeltParType.Distance = 0 THEN
				gMotorBeltAxisBasic.Power := 0;
				//UWAGA WIZJONERZY messagebox, ze dystans nieprawidlowy
				ManualStep := MANUAL_WAIT;
			ELSE
				gMotorBeltAxisBasic.Power := 1;
				gMotorBeltAxisBasic.MoveAdditive := 1;
				IF gMotorBeltAxisBasic.MoveDone THEN
					gMotorBeltAxisBasic.MoveAdditive := 0;
					ManualStep := MANUAL_WAIT;
				END_IF;
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

