 
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

//	MC_BR_JogVelocity_0.Axis := ADR(gAxis_1);
//	MC_BR_JogVelocity_0.Enable := TRUE;
//	MC_BR_JogVelocity_0.Velocity := ABS(ManualVelocity);
//	MC_BR_JogVelocity_0.Acceleration := 700;
//	MC_BR_JogVelocity_0.Deceleration := 700;
//	MC_BR_JogVelocity_0();
//	
//	gMotorBeltAxisBasic();
//	
//	gAxis_1;
//	
//	ExposureTime;
//	SetFocus;
//	
//	IF (FlagActDosing = FALSE AND FlagActDosingOff = FALSE) THEN
//		FlagActDosingOff := TRUE;
//	END_IF;
//	IF (FlagActSorting = FALSE AND FlagActSortingOff = FALSE) THEN
//		FlagActSortingOff := TRUE;
//	END_IF;
//	
//	
//	
//	NotMoveActive := NOT(gMotorBeltAxisBasic.MoveActive);
//	
//	IF DirectionChangeVelocity THEN
//		DirectionChangeVelocity := 0;
//		ManualVelocity := (-1)*ManualVelocity;
//	END_IF;
//	
//	IF DirectionChangeDistance THEN
//		DirectionChangeDistance := 0;
//		ManualDistance := (-1)*ManualDistance;
//	END_IF;
//	
//	IF gMode = 1 THEN
//		FlagManual := 1;
//		FlagNotManual := 0;
//		gMotorBeltParType.Distance := ManualDistance;
//		gMotorBeltParType.Velocity := ManualVelocity;
//	ELSE
//		FlagNotManual := 1;
//		FlagManual := 0;
//	END_IF;
//		
//	
//	IF ManualStop THEN
//		ManualStop := 0;
//		gActuatorByte := 2#0000_0000_0000_0000;
//		gMotorBeltAxisBasic.Power := 0;
//		ManualStep := MANUAL_WAIT;
//		ManualStepAct := MANUAL_ACTUATOR_WAIT;
//	END_IF;
//	
//	IF expression THEN
//		
//	END_IF;
//	
//	IF (gMode = 1) THEN
//		CASE ManualStep OF
//			MANUAL_WAIT:
//			
//				IF BeltMoveAdditive THEN
//					gMotorBeltAxisBasic.Home := 0;
//					BeltMoveAdditive := 0;
//					ManualStep := MANUAL_BELT_SET_ADDITIVE;
//				ELSIF BeltMoveVelocityOn THEN
//					gMotorBeltAxisBasic.Home := 0;
//					BeltMoveVelocityOn := 0;
//					ManualStep := MANUAL_BELT_SET_VELOCITY;
//				END_IF;
//			
//				//actuating actuator responsibile for dosing an element
//
//			
//			MANUAL_BELT_SET_ADDITIVE:
//				ManualVelocity := ABS(ManualVelocity);
//				gMotorBeltAxisBasic.Power := 0;
//				gMotorBeltAxisBasic.Power := 1;
//				IF gMotorBeltAxisBasic.PowerOn THEN
//					gMotorBeltAxisBasic.Home := 0;
//				
//					ManualStep := MANUAL_BELT_MOVE_ADDITIVE;	  
//				END_IF;
//			
//			MANUAL_BELT_MOVE_ADDITIVE:
//				gMotorBeltAxisBasic.MoveAdditive := 1;
//				IF gMotorBeltAxisBasic.MoveDone THEN
//					gMotorBeltAxisBasic.ErrorReset := 1;
//					gMotorBeltAxisBasic.MoveAdditive := 0;
//					ManualStep := MANUAL_BELT_MOVE_ADDITIVE1;
//				END_IF;
//			
//			MANUAL_BELT_MOVE_ADDITIVE1:
//				gMotorBeltAxisBasic.ErrorReset := 0;
//				//gMotorBeltAxisBasic.Power := 0;
//				ManualStep := MANUAL_WAIT;
//			
//			MANUAL_BELT_SET_VELOCITY:
//				gMotorBeltAxisBasic.Power := 0;
//				gMotorBeltAxisBasic.Power := 1;
//				IF gMotorBeltAxisBasic.PowerOn THEN
//					gMotorBeltAxisBasic.MoveVelocity := 1;
//					ManualStep := MANUAL_BELT_MOVE_VELOCITY;	  
//				END_IF;
//		
//			MANUAL_BELT_MOVE_VELOCITY:
//				IF gMotorBeltAxisBasic.InVelocity THEN
//					IF BeltMoveVelocityOff THEN
//						BeltMoveVelocityOff := 0;
//						gMotorBeltAxisBasic.MoveVelocity := 0;
//						ManualStep := MANUAL_WAIT;
//					END_IF;
//				END_IF;
//		END_CASE;
//	
//		CASE ManualStepAct OF
//			MANUAL_ACTUATOR_WAIT:
//				IF ManualActuatorDosing THEN
//					ManualActuatorDosing := 0;
//					ManualStepAct := MANUAL_ACTUATOR_DOSING;
//				ELSIF ManualActuatorSorting THEN
//					ManualActuatorSorting := 0;
//					ManualStepAct := MANUAL_ACTUATOR_SORTING;
//				ELSIF ManualActuatorBoth THEN
//					ManualActuatorBoth := 0;
//					ManualStepAct := MANUAL_ACTUATOR_BOTH;
//				ELSIF ManualActuatorNone THEN
//					ManualActuatorNone := 0;
//					ManualStepAct := MANUAL_ACTUATOR_NONE;
//				END_IF;
//			
//			MANUAL_ACTUATOR_DOSING:
//				FlagActBoth := 0;
//				FlagActBothOff := NOT(FlagActBoth);
//				FlagActDosing := 1;
//				FlagActDosingOff := NOT(FlagActDosing);
//				FlagActNone := 0;
//				FlagActNoneOff := NOT(FlagActNone);
//				FlagActSorting := 0;
//				FlagActSortingOff := NOT(FlagActSorting);
//				gActuatorByte := 2#0000_0000_0000_0000;
//				gActuatorByte := 2#0000_0000_0000_0100;
//				ManualStepAct := MANUAL_ACTUATOR_WAIT;
//		
//				//actuating actuator responsibile for sorting an element
//			MANUAL_ACTUATOR_SORTING:
//				FlagActBoth := 0;
//				FlagActBothOff := NOT(FlagActBoth);
//				FlagActDosing := 0;
//				FlagActDosingOff := NOT(FlagActDosing);
//				FlagActNone := 0;
//				FlagActNoneOff := NOT(FlagActNone);
//				FlagActSorting := 1;
//				FlagActSortingOff := NOT(FlagActSorting);
//				gActuatorByte := 2#0000_0000_0000_0000;
//				gActuatorByte := 2#0000_0000_0000_0001;	
//				ManualStepAct := MANUAL_ACTUATOR_WAIT;
//		
//				//actuating both actuators 
//			MANUAL_ACTUATOR_BOTH:
//				FlagActBoth := 1;
//				FlagActBothOff := NOT(FlagActBoth);
//				FlagActDosing := 1;
//				FlagActDosingOff := NOT(FlagActDosing);
//				FlagActNone := 0;
//				FlagActNoneOff := NOT(FlagActNone);
//				FlagActSorting := 1;
//				FlagActSortingOff := NOT(FlagActSorting);
//				gActuatorByte := 2#0000_0000_0000_0000;
//				gActuatorByte := 2#0000_0000_0000_0101;
//				ManualStepAct := MANUAL_ACTUATOR_WAIT;
//			
//				//disactuating both actuators 
//			MANUAL_ACTUATOR_NONE:
//				FlagActBoth := 0;
//				FlagActBothOff := NOT(FlagActBoth);
//				FlagActDosing := 0;
//				FlagActDosingOff := NOT(FlagActDosing);
//				FlagActNone := 1;
//				FlagActNoneOff := NOT(FlagActNone);
//				FlagActSorting := 0;
//				FlagActSortingOff := NOT(FlagActSorting);
//				gActuatorByte := 2#0000_0000_0000_0000;
//				ManualStepAct := MANUAL_ACTUATOR_WAIT;
//		
//		END_CASE;
//	END_IF;
//	
//	
	
END_PROGRAM

PROGRAM _EXIT
	 
END_PROGRAM

