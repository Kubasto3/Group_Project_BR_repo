 
PROGRAM _INIT


END_PROGRAM

PROGRAM _CYCLIC
	
	gMotorBeltAxisBasic();
	
	gAxis_1;
	
	gExposureTime;
	gSetFocus;

	NotMoveActive := NOT(gMotorBeltAxisBasic.MoveActive);
	

	
	//--------------DIRECTION---CHANGES--------------//
	IF DirectionChangeVelocity THEN
		DirectionChangeVelocity := 0;
		ManualVelocity := (-1)*ManualVelocity;
	END_IF;
	
	IF DirectionChangeDistance THEN
		DirectionChangeDistance := 0;
		ManualDistance := (-1)*ManualDistance;
	END_IF;
	
	
	//---------AXIS---VARIABLES---ASSIGMENT----------//
	
	IF gMode = 1 THEN
		gMotorBeltParType.Distance := ManualDistance;
		gMotorBeltParType.Velocity := ManualVelocity;
	END_IF;
	
	//-----------------MANUAL---STOP-----------------//
	IF ManualStop THEN
		ManualStop := 0;
		gActuatorByte := 2#0000_0000_0000_0000;
		gMotorBeltAxisBasic.MoveVelocity := 0;
		gMotorBeltAxisBasic.MoveAdditive := 0;
		gMotorBeltAxisBasic.Home := 0;
		gMotorBeltAxisBasic.Power := 0;
		ManualStep := MANUAL_WAIT;
		ManualStepAct := MANUAL_ACTUATOR_WAIT;
	END_IF;

	FlagVelAddOff;
	
	
	//----------------------MANUAL---MODE---CHECK---CONDITION----------------------//
	IF (gMode = 1) THEN
		
		//----------------------STATE---MACHINE---AXIS------------------------//
		CASE ManualStep OF
			
			MANUAL_WAIT:
				FlagVelAddOff := 1;
				FlagAdd := 0;
				FlagVel := 0;
				IF BeltMoveAdditive THEN
					gMotorBeltAxisBasic.Home := 0;
					BeltMoveAdditive := 0;
					FlagVelAddOff := 0;
					FlagAdd := 1;
					ManualStep := MANUAL_BELT_SET_ADDITIVE;
				ELSIF BeltMoveVelocityOn THEN
					gMotorBeltAxisBasic.Home := 0;
					BeltMoveVelocityOn := 0;
					FlagVelAddOff := 0;
					FlagVel := 1;
					ManualStep := MANUAL_BELT_SET_VELOCITY;
				END_IF;

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
			
			MANUAL_BELT_ERROR:
				
		END_CASE;
		
		//-------------------STATE---MACHINE---ACTUATORS---------------------//
		CASE ManualStepAct OF
			MANUAL_ACTUATOR_WAIT:
				IF ManualActuatorDosing THEN					//monostable button for dosing actuator
					ManualActuatorDosing := 0;
					ManualStepAct := MANUAL_ACTUATOR_DOSING;
				ELSIF ManualActuatorSorting THEN				//monostable button for sorting actuator
					ManualActuatorSorting := 0;
					ManualStepAct := MANUAL_ACTUATOR_SORTING;
				ELSIF ManualActuatorBoth THEN					//monostable button for both actuators
					ManualActuatorBoth := 0;
					ManualStepAct := MANUAL_ACTUATOR_BOTH;
				ELSIF ManualActuatorNone THEN					//monostable button for dosing actuator
					ManualActuatorNone := 0;
					ManualStepAct := MANUAL_ACTUATOR_NONE;
				END_IF;
			
				//actuating actuator responsibile for DOSING an element
			MANUAL_ACTUATOR_DOSING:
				gActuatorByte := 2#0000_0000_0000_0000;
				gActuatorByte := 2#0000_0000_0000_0100;
				ManualStepAct := MANUAL_ACTUATOR_WAIT;
				
				//actuating actuator responsibile for sorting an element
			MANUAL_ACTUATOR_SORTING:
				gActuatorByte := 2#0000_0000_0000_0000;
				gActuatorByte := 2#0000_0000_0000_0001;	
				ManualStepAct := MANUAL_ACTUATOR_WAIT;
				
				//actuating both actuators 
			MANUAL_ACTUATOR_BOTH:
				gActuatorByte := 2#0000_0000_0000_0000;
				gActuatorByte := 2#0000_0000_0000_0101;
				ManualStepAct := MANUAL_ACTUATOR_WAIT;
				
				//disactuating both actuators 
			MANUAL_ACTUATOR_NONE:
				gActuatorByte := 2#0000_0000_0000_0000;
				ManualStepAct := MANUAL_ACTUATOR_WAIT;
			
			MANUAL_ACTUATOR_ERROR:
			
		END_CASE;
		
		//------------END---OF---STATE---MACHINE---ACTUATORS---------------//
		IF AxisPowerOn THEN
			AxisPowerOn := 0;
			gMotorBeltAxisBasic.Power :=1;	//Axis power off is enabling by the button that is binded with stop step
		END_IF;
		
		//------------PHOTO---FUNCTIONS---------------//
		IF PhotoShoot THEN
			PhotoShoot :=0;
		END_IF;
	
		IF PhotoShow THEN
			gDisplayImg := 1;
		ELSE
			gDisplayImg := 0;
		END_IF;
		//---------END---OF---PHOTO---FUNCTIONS------------//
		
	END_IF;
	
	
	//----------------------------FLAG---SECTION----------------------------//	
	IF (FlagActDosing = FALSE AND FlagActDosingOff = FALSE) THEN
		FlagActDosingOff := TRUE;
	END_IF;
	IF (FlagActSorting = FALSE AND FlagActSortingOff = FALSE) THEN
		FlagActSortingOff := TRUE;
	END_IF;
	
	
	IF gMotorBeltAxisBasic.PowerOn THEN
		AxisPowerOff := 1;
	ELSE
		AxisPowerOff := 0;
	END_IF;
	
	IF gMode = 1 THEN
		FlagManual := 1;
		FlagNotManual := 0;
	ELSE
		FlagNotManual := 1;
		FlagManual := 0;
	END_IF;
	
	IF ManualStepAct = MANUAL_ACTUATOR_DOSING THEN
		FlagActBoth := 0;
		FlagActBothOff := NOT(FlagActBoth);
		FlagActDosing := 1;
		FlagActDosingOff := NOT(FlagActDosing);
		FlagActNone := 0;
		FlagActNoneOff := NOT(FlagActNone);
		FlagActSorting := 0;
		FlagActSortingOff := NOT(FlagActSorting);
	ELSIF ManualStepAct = MANUAL_ACTUATOR_SORTING THEN
		FlagActBoth := 0;
		FlagActBothOff := NOT(FlagActBoth);
		FlagActDosing := 0;
		FlagActDosingOff := NOT(FlagActDosing);
		FlagActNone := 0;
		FlagActNoneOff := NOT(FlagActNone);
		FlagActSorting := 1;
		FlagActSortingOff := NOT(FlagActSorting);
	ELSIF ManualStepAct = MANUAL_ACTUATOR_BOTH THEN
		FlagActBoth := 1;
		FlagActBothOff := NOT(FlagActBoth);
		FlagActDosing := 1;
		FlagActDosingOff := NOT(FlagActDosing);
		FlagActNone := 0;
		FlagActNoneOff := NOT(FlagActNone);
		FlagActSorting := 1;
		FlagActSortingOff := NOT(FlagActSorting);
	ELSIF ManualStepAct = MANUAL_ACTUATOR_NONE THEN
		FlagActBoth := 0;
		FlagActBothOff := NOT(FlagActBoth);
		FlagActDosing := 0;
		FlagActDosingOff := NOT(FlagActDosing);
		FlagActNone := 1;
		FlagActNoneOff := NOT(FlagActNone);
		FlagActSorting := 0;
		FlagActSortingOff := NOT(FlagActSorting);
	END_IF;
	
	IF (((gMotorBeltParType.Distance < 0) AND gMotorBeltAxisBasic.MoveActive AND FlagAdd) OR ((gMotorBeltParType.Velocity <0) AND gMotorBeltAxisBasic.MoveActive AND FlagVel)) THEN
		FlagArrowLeft := 1;
		FlagArrowRight := 0;
	ELSIF (((gMotorBeltParType.Distance > 0) AND gMotorBeltAxisBasic.MoveActive AND FlagAdd) OR ((gMotorBeltParType.Velocity > 0) AND gMotorBeltAxisBasic.MoveActive AND FlagVel)) THEN
		FlagArrowRight := 1;
		FlagArrowLeft := 0;
	ELSE
		FlagArrowRight := 0;
		FlagArrowLeft := 0;
	END_IF;
	
	
	//----------------------END---OF---FLAG---SECTION----------------------------//
	
END_PROGRAM

PROGRAM _EXIT
	 
END_PROGRAM

