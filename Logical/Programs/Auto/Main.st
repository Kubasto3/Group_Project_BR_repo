// ALREADY WORKING, ONLY SOME CHANGES REQUIRED
PROGRAM _INIT
//	// NEED ONLY FOR WATCH
//	gAxis_1;
//	gMotorBeltParType;
//	gMotorBeltAxisBasic;
	
END_PROGRAM

PROGRAM _CYCLIC
//
//	// MOTOR MANAGEMENT
//	gMotorBeltAxisBasic.Enable 		:= TRUE;
//	gMotorBeltAxisBasic.MpLink 		:= ADR(gAxis_1);
//	gMotorBeltAxisBasic.Parameters 	:= ADR(gMotorBeltParType);
//	MotorMoveDone 					:= gMotorBeltAxisBasic.MoveDone;
//	gMotorBeltAxisBasic.Power 		:= MotorPower;
//	gMotorBeltAxisBasic.Home 		:= MotorHome;
//	// ASSIGNING MOTION PARAMETERS
//	gMotorBeltParType.Acceleration 	:= MotorAcc; 
//	gMotorBeltParType.Deceleration 	:= MotorDec; 
//	gMotorBeltParType.Velocity 		:= MotorVel;
//	gMotorBeltParType.Position 		:= MotorReqPosition;
//	
//	gMotorBeltAxisBasic();
//	
//	// ASSIGNING GLOBAL VARIABLES TO LOCAL VARIABLES
//	gActuatorByte					 := ActuatorByte;
//	gMotorBeltAxisBasic.Power 		 := MotorPower;
//	gMotorBeltAxisBasic.MoveAbsolute := MotorMoveAbsolute;
//	gMotorBeltAxisBasic.ErrorReset	 := MotorResetError;
//	// ASSIGNING LOCAL VARIABLES TO GLOBAL VARIABLES
//	MotorInPosition 				 := gMotorBeltAxisBasic.InPosition;
//	ItemDetected					 := gWeightDetected;
//	ItemWeight 						 := gInWeightMeasure;
//
//	// ITEM DETECTION CONDITION 
//	ItemDetected := (ItemWeight > 1);
//	
//	// TIMERS
//	// actuator
//	TimerTonActuator(IN := TimerTonActuatorIn, PT := TIME_TON_ACTUATOR);
//	TimerActuatorOut := TimerTonActuator.Q;
//	// camera
//	TimerTonCamera(IN := gImageAcq , PT := TIME_TON_CAMERA);
//	TimerCameraPicDone := TimerTonCamera.Q;
//	// delay after detection
//	TimerTonDetect.IN := ItemDetected;
//	TimerTonDetect.PT := TIME_TON_DETECT;
//	TimerAfterDetect := TimerTonDetect.Q;
//	TimerTonDetect();
//
//	
//	// COUNTERS
//	CTU_QuantityLeft(CU := AddToLeft, RESET := CTU_Reset_Left, PV := gMaxLeftStorage);
//	CTU_QuantityRight(CU := AddToRight, RESET := CTU_Reset_Right, PV := gMaxRightStorage);
//	QuantityLeftStorage  := CTU_QuantityLeft.CV;
//	QuantityRightStorage := CTU_QuantityRight.CV;
//	
//	//COUNTERS ALARMS (MOZE PRZERZUC DO ALARMÓW)
//	IF QuantityLeftStorage >= gMaxLeftStorage THEN
//		ErrorMaxL;
//	END_IF;
//	
//	IF QuantityRightStorage >= gMaxRightStorage THEN
//		ErrorMaxR;
//	END_IF;
//	
//	// PROGRAM MANUAL TURNED ON
//	IF Stop OR gMode = 1 THEN
//		Stop := FALSE;
//		State := STOP;
//	END_IF;
//	// PROGRAM AUTO
//	CASE State OF
//		STOP:
//			StringState := 'Stop';
//			IF gMode = 0 THEN
//				MotorPower := FALSE;
//				MotorMoveAbsolute := FALSE;
//				MotorHome := FALSE;
//			END_IF;
//			TimerTonActuatorIn := FALSE;
//			ActuatorSorting := FALSE;
//			ActuatorPushing := FALSE;
//			ItemWeightMeasured := RESET_ITEM_MEM_WEIGHT;
//			IF Start THEN
//				State := INIT;
//			END_IF;
//			
//		INIT:
//			StringState 		:= 'Inicjalizacja';
//			ItemWeightMeasured 	:= RESET_ITEM_MEM_WEIGHT;
//			AddToRight 			:= FALSE;
//			AddToLeft 			:= FALSE;
//			TimerTonActuatorIn 	:= FALSE;
//			ActuatorSorting 	:= FALSE;
//			ActuatorPushing 	:= FALSE;
//			MotorMoveAbsolute 	:= FALSE;
//			MotorPower 			:= TRUE;
//			MotorHome 			:= TRUE;
//			IF ItemDetected THEN
//				State := DETECTION;
//			END_IF;
//			
//		DETECTION:
//			MotorHome 			:= FALSE;
//			StringState := 'Wykrycie detalu';
//			IF TimerAfterDetect THEN
//				ItemWeightMeasured := ItemWeight;
//				State := CATEGORIZATION;
//			END_IF;
//				
//		CATEGORIZATION: 
//			StringState := 'Kategoryzacja detalu';
//			IF SortChoice = WEIGHT THEN
//				State := DROP;
//			ELSIF SortChoice = OPTIC THEN
//				State := TAKE_PICT_CAMERA;
//			END_IF;
//			
//		TAKE_PICT_CAMERA:
//			StringState := 'Robienie zdjêcia i rozpoznawanie';
//			gImageAcq 	:= TRUE; //zrob zdj na zboczu narastajacym
//			IF TimerCameraPicDone THEN
//				gImageAcq := FALSE;
//				State := DROP;
//			END_IF;
//				
//		DROP:
//			StringState := 'Dozowanie detalu';
//			ActuatorPushing := TRUE;
//			IF TimerActuatorOut THEN
//				ActuatorPushing := FALSE;
//				IF SortChoice = OPTIC THEN
//					State := SORT_OPTIC;
//				ELSIF SortChoice = WEIGHT THEN
//					State := SORT_WEIGHT;
//				END_IF;
//			END_IF;
//			
//			// ABOVE 1 TO ItemWeightChoosen ITEM FALL INTO THE LEFT, AND ABOVE ItemWeightChoosen INTO THE RIGHT	
//		SORT_WEIGHT: 
//			StringState := 'Sortowanie wagowe';
//			IF ItemWeightMeasured > 1 AND ItemWeightMeasured < ItemWeightChoosen THEN
//				State := GO_STORAGE_LEFT;
//			ELSIF ItemWeightMeasured >= ItemWeightChoosen THEN 
//				State := GO_STORAGE_RIGHT;
//			END_IF;
//			
//		SORT_OPTIC:
//			StringState := 'Sortowanie optyczne';
//			IF gRecognisedModel = 0 THEN 
//				gImageAcq 			  := FALSE;
//				StringRecognisedModel := 'Unrecognised';
//				State 				  := UNRECOGNISED_PIC;
//			ELSIF gRecognisedModel = 1 THEN
//				gImageAcq 			  := FALSE;
//				StringRecognisedModel := 'B&R';
//				State 				  := GO_STORAGE_LEFT;
//				
//			ELSIF gRecognisedModel = 2 THEN
//				gImageAcq 			  := FALSE;
//				StringRecognisedModel := 'AS';
//				State 			 	  := GO_STORAGE_RIGHT;
//			END_IF;
//			
//		GO_STORAGE_LEFT:
//			StringState := 'Transport detalu do lewego zbiornika';
//			MotorReqPosition := MOTOR_DIST_LEFT;
//			MotorMoveAbsolute := TRUE;
//			IF MotorInPosition AND MotorMoveDone THEN
//				State := SORT_STORAGE_LEFT;
//			END_IF;
//
//		GO_STORAGE_RIGHT:
//			StringState := 'Transport detalu do prawego zbiornika';
//			MotorReqPosition := MOTOR_DIST_RIGHT;
//			MotorMoveAbsolute := TRUE;
//			IF MotorInPosition AND MotorMoveDone THEN
//				State := SORT_STORAGE_RIGHT;				
//			END_IF;
//			
//		SORT_STORAGE_LEFT:
//			StringState := 'Zepchniecie detalu z taœmy do zbiornika lewego';
//			MotorMoveAbsolute := FALSE;
//			ActuatorSorting := TRUE;
//			AddToLeft := TRUE;
//			IF TimerActuatorOut THEN
//				State := INIT;
//			END_IF;
//
//		SORT_STORAGE_RIGHT:
//			AddToRight := TRUE;
//			MotorMoveAbsolute := FALSE;
//			State := INIT;
//		
//		UNRECOGNISED_PIC:
//			StringState := 'Nie rozpoznano zdjêcia';
//			State := STOP;
//
//	END_CASE;
//
//	
//	// TIMER INPUT TRIGGER TO DELAY ACTUATORS
//	IF ActuatorPushing OR ActuatorSorting THEN
//		TimerTonActuatorIn := TRUE;
//	ELSE
//		TimerTonActuatorIn := FALSE;
//	END_IF;
//	
//	// OPERATION OF BYTE ACTUATORS WITH TIMER
//	IF ActuatorPushing THEN
//		ActuatorByte := ACTUATOR_BYTE_PUSH;	
//		IF TimerActuatorOut THEN
//			ActuatorPushing := FALSE;
//		END_IF;
//	ELSIF ActuatorSorting THEN
//		ActuatorByte := ACTUATOR_BYTE_SORT;
//		IF TimerActuatorOut THEN
//			ActuatorSorting := FALSE;
//		END_IF;
//	ELSE
//		ActuatorByte := ACTUATOR_BYTE_NOT_ACTIV;
//	END_IF;
//	
//	ActuatorNotSorting := NOT ActuatorSorting;
//	ActuatorNotPushing 	:= NOT ActuatorPushing;
//	
//	IF Start THEN
//		Start := FALSE;
//	END_IF;
	
END_PROGRAM

PROGRAM _EXIT

	 
END_PROGRAM

