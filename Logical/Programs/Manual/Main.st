
PROGRAM _INIT
	gMotorBeltAxisBasic.Enable := 0;
	gMotorBeltAxisBasic.Power := 0;
	gMotorBeltAxisBasic.Home := 0;
	
	ManualStart := 0;

	gMotorBeltParType.Acceleration := 2500;
	gMotorBeltParType.Deceleration := 2500;
	
	gMotorBeltAxisBasic.MpLink := ADR(gAxis_1);				
	gMotorBeltAxisBasic.Enable := 1;
	gMotorBeltAxisBasic.Parameters := ADR(gMotorBeltParType);
	
	ManualStep := MANUAL_START;
	
END_PROGRAM

PROGRAM _CYCLIC

	gAxis_1;
	
	gMotorBeltParType.Distance := ManualDistance;
	gMotorBeltParType.Velocity := ManualVelocity;
	
	IF DirectionChange THEN
		DirectionChange := 0;
		ManualVelocity := ManualVelocity * (-1);
	END_IF;
	
	IF ManualStop THEN
		ManualStop := 0;
		gActuatorByte := 2#0000_0000_0000_0000;
		ManualStep := MANUAL_START;
	END_IF;
	//lol
	
	CASE ManualStep OF
		MANUAL_START:
			IF ManualStart THEN		//AND (NOT AutoStart) - zeby nie szlo tego wlaczyc gdy jest tryb automatyczny
				ManualStart := 0;
				ManualStep := MANUAL_WAIT;
			END_IF;
			
		MANUAL_WAIT:
			//ManualDistance := gMotorBeltParType.Distance;
			//ManualVelocity := gMotorBeltParType.Velocity;
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
			ELSIF BeltMoveAdditive THEN
				gMotorBeltAxisBasic.Power := 0;
				gMotorBeltAxisBasic.Home := 0;
				BeltMoveAdditive := 0;
				gMotorBeltAxisBasic.Power := 1;
				ManualStep := MANUAL_BELT_SET_ADDITIVE;
			ELSIF BeltMoveVelocityOn THEN
				gMotorBeltAxisBasic.Power := 0;
				gMotorBeltAxisBasic.Home := 0;
				BeltMoveVelocityOn := 0;
				ManualStep := MANUAL_BELT_SET_VELOCITY;
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
			
		MANUAL_BELT_SET_ADDITIVE:

			gMotorBeltAxisBasic.Home := 1;
			IF gMotorBeltAxisBasic.PowerOn THEN
				gMotorBeltAxisBasic.Home := 0;
				gMotorBeltAxisBasic.MoveAdditive := 1;
				ManualStep := MANUAL_BELT_MOVE_ADDITIVE;	  
			END_IF;
			
		MANUAL_BELT_MOVE_ADDITIVE:
			//			IF gMotorBeltParType.Distance = 0 THEN
			//				gMotorBeltAxisBasic.Power := 0;
			//				//UWAGA WIZJONERZY messagebox, ze dystans nieprawidlowy
			//				ManualStep := MANUAL_WAIT;
			//			ELSE 
			IF gMotorBeltAxisBasic.MoveDone THEN
				//gMotorBeltAxisBasic.ErrorReset := 1;
				//gMotorBeltAxisBasic.ErrorReset := 0;
				gMotorBeltAxisBasic.Power := 0;
				gMotorBeltAxisBasic.MoveAdditive := 0;
				ManualStep := MANUAL_WAIT;
			END_IF;
			//END_IF;
					
		MANUAL_BELT_SET_VELOCITY:
			gMotorBeltAxisBasic.Power := 1;
			gMotorBeltAxisBasic.Home := 1;
			IF gMotorBeltAxisBasic.PowerOn THEN
				gMotorBeltAxisBasic.Home := 0;
				gMotorBeltAxisBasic.MoveVelocity := 1;
				ManualStep := MANUAL_BELT_MOVE_VELOCITY;	  
			END_IF;
		
		MANUAL_BELT_MOVE_VELOCITY:
			IF gMotorBeltAxisBasic.InVelocity THEN
				IF BeltMoveVelocityOff THEN
					BeltMoveVelocityOff := 0;
					gMotorBeltAxisBasic.MoveVelocity := 0;
					gMotorBeltAxisBasic.Power := 0;
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

