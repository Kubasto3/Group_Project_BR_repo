// ALREADY WORKING, ONLY SOME CHANGES REQUIRED
PROGRAM _INIT
	// NEED ONLY FOR WATCH
	gAxis_1;
//	gMotorBeltParType;
	gMotorBeltAxisBasic;
END_PROGRAM
//
PROGRAM _CYCLIC
		// MOTOR MANAGEMENT
	gMotorBeltAxisBasic.MpLink := ADR(gAxis_1);
	MotorMoveDone := gMotorBeltAxisBasic.MoveDone;
	gMotorBeltAxisBasic.Power := MotorPower;
	// ASSIGNING MOTION PARAMETERS
	gMotorBeltParType.Acceleration := MotorAcc; 
	gMotorBeltParType.Deceleration := MotorDec; 
//	gAxis_1;
	gMotorBeltAxisBasic();
//	gMotorBeltAxisBasic.MpLink := ADR(gAxis_1);
	// ASSIGNING GLOBAL VARIABLES TO LOCAL VARIABLES
	gActuatorByte					 := ActuatorByte;
//	gMotorBeltParType.Acceleration := MotorAcc;
	gMotorBeltAxisBasic.MoveAdditive := MotorMoveAdditive;
//	gMotorBeltParType.Velocity := MotorVel;
	// ASSIGNING LOCAL VARIABLES TO GLOBAL VARIABLES
//	gMotorBeltAxisBasic();
//	//
//	
//	
	// TIMERS
//	ItemDetected					 := gWeightDetected;
	TimerTonActuatorOut := TimerTonActuator.Q;
//
	// ITEM DETECTION CONDITION 
//
//	//TYMCZASOWO BEZ HMI
	// ONLY FOR NOW
	SortChoice := WEIGHT; 
	
	// PROGRAM
	IF Stop OR gMode = 1 THEN
		State := STOP;
	END_IF;
	
//	
//	//WARUNEK WYKRYCIA OBIEKTU
			Stop := FALSE;
			IF gMode = 0 THEN
				MotorPower := FALSE;
				MotorMoveAdditive := FALSE;
			END_IF;
			TimerTonActuatorIn := FALSE;
			ActuatorSorting := FALSE;
			ActuatorPushing := FALSE;
			ItemWeightMeasured := RESET_ITEM_MEM_WEIGHT;
			IF Start THEN
//				State := INIT;
//			END_IF;
//			
//		INIT:
			ItemWeightMeasured := RESET_ITEM_MEM_WEIGHT;
//			TimerTonActuatorIn := FALSE;
			ActuatorSorting := FALSE;
			ActuatorPushing := FALSE;
//			MotorPower := TRUE;
			MotorMoveAdditive := FALSE;
			IF Start THEN
				Start := FALSE;
//				State := DETECTION;
//			END_IF;
//			
//		DETECTION:
			IF ItemDetected THEN
//				ItemWeightMeasured := ItemWeight;
//				State := CATEGORIZATION;
//			END_IF;
				
//		CATEGORIZATION: 
			IF SortChoice = WEIGHT THEN
				State := DROP;
//			ELSIF SortChoice = WEIGHT_AND_OPTIC THEN
				State := TAKE_PICT_CAMERA_AND_DROP;
//			ELSIF SortChoice = OPTIC THEN
				State := TAKE_PICT_CAMERA_AND_DROP;
			END_IF;
			
		TAKE_PICT_CAMERA_AND_DROP:	
			//KOD KAMERY ZROB 
			State := SORT_OPTIC;
			//DROP DODAJ
				
		DROP:
			ActuatorPushing := TRUE;
			IF TimerTonActuatorOut THEN
				State := SORT_WEIGHT;
//		SORT_WEIGHT_AND_OPTIC:
				
			// ABOVE 1 TO ItemWeightChoosen ITEM FALL INTO THE LEFT, AND ABOVE ItemWeightChoosen INTO THE RIGHT	
		SORT_WEIGHT: 
			IF ItemWeightMeasured > 1 AND ItemWeightMeasured < ItemWeightChoosen THEN
				State := GO_STORAGE_LEFT;
//			IF Stop THEN
				State := GO_STORAGE_RIGHT;
//			ELSE
//				MotorDist := 100;
//				MotorMoveAdd := TRUE;
//				IF MotorInPosition AND MotorMoveDone THEN //rozdziel na pare kroków
//					MotorMoveAdd := FALSE;
//					IF TimerTonActuatorOut THEN
//						ActuatorByte := 2#0000_0000_0000_0001;
//						TimerTonActuatorIn := FALSE;
		GO_STORAGE_LEFT:
			MotorDist := MOTOR_DIST_LEFT;
			MotorMoveAdditive := TRUE;
			IF MotorInPosition AND MotorMoveDone THEN
				State := SORT_STORAGE_LEFT;
//					TimerTonActuatorIn:= TRUE;

		GO_STORAGE_RIGHT:
			MotorDist := MOTOR_DIST_RIGHT;
			MotorMoveAdditive := TRUE;
			IF MotorInPosition AND MotorMoveDone THEN
				State := SORT_STORAGE_RIGHT;				
			END_IF;
			
		SORT_STORAGE_LEFT:
			MotorMoveAdditive := FALSE;
			ActuatorSorting := TRUE;
			IF TimerTonActuatorOut THEN
				State := INIT;
			END_IF;

		SORT_STORAGE_RIGHT:
			MotorMoveAdditive := FALSE;
			State := INIT;

	END_CASE;

	
	// TIMER INPUT TRIGGER TO DELAY ACTUATORS
	IF ActuatorPushing OR ActuatorSorting THEN
		TimerTonActuatorIn := TRUE;
	ELSE
		TimerTonActuatorIn := FALSE;
	END_IF;
	
	// OBSLUGA BYTE SI£OWNIKÓW Z WAITEM
	IF ActuatorPushing THEN
		ActuatorByte := ACTUATOR_BYTE_PUSH;
		IF TimerTonActuatorOut THEN
			ActuatorPushing := FALSE;
		END_IF;
	ELSIF ActuatorSorting THEN
		ActuatorByte := ACTUATOR_BYTE_SORT;
		IF TimerTonActuatorOut THEN
			ActuatorSorting := FALSE;
		END_IF;
	ELSE
		ActuatorByte := ACTUATOR_BYTE_NOT_ACTIV;
	END_IF;
	

	
END_PROGRAM
//
PROGRAM _EXIT
//
//	 
END_PROGRAM
//
