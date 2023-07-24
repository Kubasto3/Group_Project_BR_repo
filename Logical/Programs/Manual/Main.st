
PROGRAM _INIT
//	gMotorBeltAxisBasic.Enable := 0;
//	gMotorBeltAxisBasic.Power := 0;
//	gMotorBeltAxisBasic.Home := 0;
//	
//	ManualStart := 0;
//
//	gMotorBeltParType.Acceleration := 2500;
//	gMotorBeltParType.Deceleration := 2500;
//	
//	gMotorBeltAxisBasic.MpLink := ADR(gAxis_1);				
//	gMotorBeltAxisBasic.Enable := 1;
//	gMotorBeltAxisBasic.Parameters := ADR(gMotorBeltParType);
//	
//	ManualStep := MANUAL_START;
//	
//	gMotorBeltAxisBasic.Home := 1;
//	gMotorBeltAxisBasic.Power := 0;
//	
//	
END_PROGRAM

PROGRAM _CYCLIC

	MC_BR_JogVelocity_0.Axis := ADR(gAxis_1);
	MC_BR_JogVelocity_0.Enable := TRUE;
	MC_BR_JogVelocity_0.Velocity := ABS(ManualVelocity);
	MC_BR_JogVelocity_0.Acceleration := 700;
	MC_BR_JogVelocity_0.Deceleration := 700;
	MC_BR_JogVelocity_0();
	
	gMotorBeltAxisBasic();
	
	gAxis_1;
	
	ExposureTime;
	SetFocus;
	
	

	
	IF DirectionChangeVelocity THEN
		DirectionChangeVelocity := 0;
		ManualVelocity := (-1)*ManualVelocity;
	END_IF;
	
	IF DirectionChangeDistance THEN
		DirectionChangeDistance := 0;
		ManualDistance := (-1)*ManualDistance;
	END_IF;
	
	IF gMode = 1 THEN
		FlagManual := 1;
		gMotorBeltParType.Distance := ManualDistance;
		gMotorBeltParType.Velocity := ManualVelocity;
	ELSE
		FlagManual := 0;
	END_IF;
		
	
	IF ManualStop THEN
		ManualStop := 0;
		StartButtonState := 1;	//ZMIENNA DO STANU PRZYCISKU START - ZEBY DALO SIE WLACZYC START TYLKO RAZ
		gActuatorByte := 2#0000_0000_0000_0000;
		ManualStep := MANUAL_START;
	END_IF;
	
	CASE ManualStep OF
		MANUAL_START:
			IF ManualStart AND (gMode = 1) THEN	
				ManualStart := 0;
				StartButtonState := 0;	//ZMIENNA DO STANU PRZYCISKU START - ZEBY DALO SIE WLACZYC START TYLKO RAZ
				ManualStep := MANUAL_WAIT;
			END_IF;
			
		MANUAL_WAIT:
			
			IF BeltMoveAdditive THEN
				gMotorBeltAxisBasic.Home := 0;
				BeltMoveAdditive := 0;
				ManualStep := MANUAL_BELT_SET_ADDITIVE;
			ELSIF BeltMoveVelocityOn THEN
				gMotorBeltAxisBasic.Home := 0;
				BeltMoveVelocityOn := 0;
				ManualStep := MANUAL_BELT_SET_VELOCITY;
			END_IF;
			
			//actuating actuator responsibile for dosing an element

			
		MANUAL_BELT_SET_ADDITIVE:
			ManualVelocity := ABS(ManualVelocity);
			gMotorBeltAxisBasic.Power := 0;
			gMotorBeltAxisBasic.Power := 1;
			IF gMotorBeltAxisBasic.PowerOn THEN
				gMotorBeltAxisBasic.Home := 0;
				
				ManualStep := MANUAL_BELT_MOVE_ADDITIVE;	  
			END_IF;
			
		MANUAL_BELT_MOVE_ADDITIVE:
			gMotorBeltAxisBasic.MoveAdditive := 1;
			IF gMotorBeltAxisBasic.MoveDone THEN
				gMotorBeltAxisBasic.ErrorReset := 1;
				gMotorBeltAxisBasic.MoveAdditive := 0;
				ManualStep := MANUAL_BELT_MOVE_ADDITIVE1;
			END_IF;
			
		MANUAL_BELT_MOVE_ADDITIVE1:
			gMotorBeltAxisBasic.ErrorReset := 0;
			//gMotorBeltAxisBasic.Power := 0;
			ManualStep := MANUAL_WAIT;
			
		MANUAL_BELT_SET_VELOCITY:
			gMotorBeltAxisBasic.Power := 0;
			gMotorBeltAxisBasic.Power := 1;
			IF gMotorBeltAxisBasic.PowerOn THEN
				gMotorBeltAxisBasic.MoveVelocity := 1;
				ManualStep := MANUAL_BELT_MOVE_VELOCITY;	  
			END_IF;
		
		MANUAL_BELT_MOVE_VELOCITY:
			IF gMotorBeltAxisBasic.InVelocity THEN
				IF BeltMoveVelocityOff THEN
					BeltMoveVelocityOff := 0;
					gMotorBeltAxisBasic.MoveVelocity := 0;
					ManualStep := MANUAL_WAIT;
				END_IF;
			END_IF;
	END_CASE;
	
	CASE ManualStepAct OF
		MANUAL_ACTUATOR_WAIT:
			IF ManualActuatorDosing THEN
				ManualActuatorDosing := 0;
				ManualStepAct := MANUAL_ACTUATOR_DOSING;
			ELSIF ManualActuatorSorting THEN
				ManualActuatorSorting := 0;
				ManualStepAct := MANUAL_ACTUATOR_SORTING;
			ELSIF ManualActuatorBoth THEN
				ManualActuatorBoth := 0;
				ManualStepAct := MANUAL_ACTUATOR_BOTH;
			ELSIF ManualActuatorNone THEN
				ManualActuatorNone := 0;
				ManualStepAct := MANUAL_ACTUATOR_NONE;
			END_IF;
			
		MANUAL_ACTUATOR_DOSING:
			FlagActBoth := 0;
			FlagActDosing := 1;
			FlagActNone := 0;
			FlagActSorting := 0;
			gActuatorByte := 2#0000_0000_0000_0000;
			gActuatorByte := 2#0000_0000_0000_0100;
			ManualStepAct := MANUAL_ACTUATOR_WAIT;
		
			//actuating actuator responsibile for sorting an element
		MANUAL_ACTUATOR_SORTING:
			FlagActBoth := 0;
			FlagActDosing := 0;
			FlagActNone := 0;
			FlagActSorting := 1;
			gActuatorByte := 2#0000_0000_0000_0000;
			gActuatorByte := 2#0000_0000_0000_0001;	
			ManualStepAct := MANUAL_ACTUATOR_WAIT;
		
			//actuating both actuators 
		MANUAL_ACTUATOR_BOTH:
			FlagActBoth := 1;
			FlagActDosing := 1;
			FlagActNone := 0;
			FlagActSorting := 1;
			gActuatorByte := 2#0000_0000_0000_0000;
			gActuatorByte := 2#0000_0000_0000_0101;
			ManualStepAct := MANUAL_ACTUATOR_WAIT;
			
			//disactuating both actuators 
		MANUAL_ACTUATOR_NONE:
			FlagActBoth := 0;
			FlagActDosing := 0;
			FlagActNone := 1;
			FlagActSorting := 0;
			gActuatorByte := 2#0000_0000_0000_0000;
			ManualStepAct := MANUAL_ACTUATOR_WAIT;
		
	END_CASE;
	
	
END_PROGRAM

PROGRAM _EXIT
	 
END_PROGRAM

