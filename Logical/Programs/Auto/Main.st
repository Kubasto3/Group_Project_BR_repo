//// ALREADY WORKING, ONLY SOME CHANGES REQUIRED
//PROGRAM _INIT
//	// NEED ONLY FOR WATCH
//	gAxis_1;
//	gMotorBeltParType;
//	gMotorBeltAxisBasic;
//END_PROGRAM
//
//PROGRAM _CYCLIC
//
//	// MOTOR MANAGEMENT
//	gMotorBeltAxisBasic.Enable := TRUE;
//	gMotorBeltAxisBasic.MpLink := ADR(gAxis_1);
//	gMotorBeltAxisBasic.Parameters := ADR(gMotorBeltParType);
//	MotorMoveDone := gMotorBeltAxisBasic.MoveDone;
//	gMotorBeltAxisBasic.Power := MotorPower;
//	// ASSIGNING MOTION PARAMETERS
//	gMotorBeltParType.Acceleration := MotorAcc; 
//	gMotorBeltParType.Deceleration := MotorDec; 
//	gMotorBeltParType.Velocity := MotorVel;
//	gMotorBeltParType.Distance := MotorDist;
//	
//	gMotorBeltAxisBasic();
//	
//	// ASSIGNING GLOBAL VARIABLES TO LOCAL VARIABLES
//	gActuatorByte					 := ActuatorByte;
//	gMotorBeltAxisBasic.Power 		 := MotorPower;
//	gMotorBeltAxisBasic.MoveAdditive := MotorMoveAdditive;
//	gMotorBeltAxisBasic.ErrorReset	 := MotorResetError;
//	// ASSIGNING LOCAL VARIABLES TO GLOBAL VARIABLES
//	MotorInPosition 				 := gMotorBeltAxisBasic.InPosition;
//	ItemDetected					 := gWeightDetected;
//	ItemWeight 						 := gInWeightMeasure;
//
//	// TIMERS
//	TimerTonActuator(IN := TimerTonActuatorIn, PT := TIME_TON_ACTUATOR); //zmien //dodaj moze drugi timer //WYZWALANIE TIMERA (moze inna zmienna)
//	TimerTonActuatorOut := TimerTonActuator.Q;
//	
//	//COUNTERS
//	CTU_QuantityLeft(CU := AddToLeft, RESET := CTU_Reset, PV := MaxLeftStorage);
//	CTU_QuantityRight(CU := AddToRight, RESET := CTU_Reset, PV := MaxRightStorage);
//	QuantityLeftStorage  := CTU_QuantityLeft.CV;
//	QuantityRightStorage := CTU_QuantityRight.CV;
//	
//	// ITEM DETECTION CONDITION 
//	ItemDetected := (ItemWeight > 1);
//	
//	// ONLY FOR NOW
//	SortChoice := WEIGHT; 
//	
//	// PROGRAM
//	IF Stop OR gMode = 1 THEN
//		State := STOP;
//	END_IF;
//	
//	CASE State OF
//		STOP:
//			Stop := FALSE;
//			IF gMode = 0 THEN
//				MotorPower := FALSE;
//				MotorMoveAdditive := FALSE;
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
//			ItemWeightMeasured := RESET_ITEM_MEM_WEIGHT;
//			TimerTonActuatorIn := FALSE;
//			ActuatorSorting := FALSE;
//			ActuatorPushing := FALSE;
//			MotorPower := TRUE;
//			MotorMoveAdditive := FALSE;
//			IF Start THEN
//				Start := FALSE;
//				State := DETECTION;
//			END_IF;
//			
//		DETECTION:
//			IF ItemDetected THEN
//				ItemWeightMeasured := ItemWeight;
//				State := CATEGORIZATION;
//			END_IF;
//				
//		CATEGORIZATION: 
//			IF SortChoice = WEIGHT THEN
//				State := DROP;
//			ELSIF SortChoice = WEIGHT_AND_OPTIC THEN
//				State := TAKE_PICT_CAMERA_AND_DROP;
//			ELSIF SortChoice = OPTIC THEN
//				State := TAKE_PICT_CAMERA_AND_DROP;
//			END_IF;
//			
//		TAKE_PICT_CAMERA_AND_DROP:	
//			gImageAcq := TRUE; //zrob zdj na zboczu narastajacym
//			
//			IF gRecognisedModel = 0 THEN //BR AS Unrecognised
//			
//			ELSIF gRecognisedModel = 1 THEN
//				
//			ELSIF gRecognisedModel = 2 THEN
//			
//			END_IF;
//			State := SORT_OPTIC;
//			//DROP DODAJ
//				
//		DROP:
//			ActuatorPushing := TRUE;
//			IF TimerTonActuatorOut THEN
//				IF gRecognisedModel = 0 THEN
//	  				
//				END_IF;
//				
//				
//			END_IF;
//				
//			// ABOVE 1 TO ItemWeightChoosen ITEM FALL INTO THE LEFT, AND ABOVE ItemWeightChoosen INTO THE RIGHT	
//		SORT_WEIGHT: 
//			IF ItemWeightMeasured > 1 AND ItemWeightMeasured < ItemWeightChoosen THEN
//				State := GO_STORAGE_LEFT;
//			ELSIF ItemWeightMeasured >= ItemWeightChoosen THEN 
//				State := GO_STORAGE_RIGHT;
//			END_IF;
//			
//		SORT_WEIGHT_AND_OPTIC:
//			//DOPISZ
//			
//		SORT_OPTIC:
//			//DOPISZ
//			
//		GO_STORAGE_LEFT:
//			MotorDist := MOTOR_DIST_LEFT;
//			MotorMoveAdditive := TRUE;
//			IF MotorInPosition AND MotorMoveDone THEN
//				State := SORT_STORAGE_LEFT;
//			END_IF;
//
//		GO_STORAGE_RIGHT:
//			MotorDist := MOTOR_DIST_RIGHT;
//			MotorMoveAdditive := TRUE;
//			IF MotorInPosition AND MotorMoveDone THEN
//				State := SORT_STORAGE_RIGHT;				
//			END_IF;
//			
//		SORT_STORAGE_LEFT:
//			MotorMoveAdditive := FALSE;
//			ActuatorSorting := TRUE;
//			IF TimerTonActuatorOut THEN
//				State := INIT;
//			END_IF;
//
//		SORT_STORAGE_RIGHT:
//			MotorMoveAdditive := FALSE;
//			State := INIT;
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
//	// OBSLUGA BYTE SI£OWNIKÓW Z WAITEM
//	IF ActuatorPushing THEN
//		ActuatorByte := ACTUATOR_BYTE_PUSH;
//		IF TimerTonActuatorOut THEN
//			ActuatorPushing := FALSE;
//		END_IF;
//	ELSIF ActuatorSorting THEN
//		ActuatorByte := ACTUATOR_BYTE_SORT;
//		IF TimerTonActuatorOut THEN
//			ActuatorSorting := FALSE;
//		END_IF;
//	ELSE
//		ActuatorByte := ACTUATOR_BYTE_NOT_ACTIV;
//	END_IF;
//	
//
//	
//END_PROGRAM
//
//PROGRAM _EXIT
//
//	 
//END_PROGRAM
//
