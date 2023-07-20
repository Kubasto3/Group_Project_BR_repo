// ALREADY WORKING, ONLY SOME CHANGES REQUIRED
PROGRAM _INIT
	// NEED ONLY FOR WATCH
	gAxis_1;
	gMotorBeltParType;
	gMotorBeltAxisBasic;
	
END_PROGRAM

PROGRAM _CYCLIC

	// MOTOR MANAGEMENT
	gMotorBeltAxisBasic.Enable 		:= TRUE;
	gMotorBeltAxisBasic.MpLink 		:= ADR(gAxis_1);
	gMotorBeltAxisBasic.Parameters 	:= ADR(gMotorBeltParType);
	MotorMoveDone 					:= gMotorBeltAxisBasic.MoveDone;
	gMotorBeltAxisBasic.Power 		:= MotorPower;
	// ASSIGNING MOTION PARAMETERS
	gMotorBeltParType.Acceleration 	:= MotorAcc; 
	gMotorBeltParType.Deceleration 	:= MotorDec; 
	gMotorBeltParType.Velocity 		:= MotorVel;
	gMotorBeltParType.Distance 		:= MotorDist;
	
	gMotorBeltAxisBasic();
	
	// ASSIGNING GLOBAL VARIABLES TO LOCAL VARIABLES
	gActuatorByte					 := ActuatorByte;
	gMotorBeltAxisBasic.Power 		 := MotorPower;
	gMotorBeltAxisBasic.MoveAdditive := MotorMoveAdditive;
	gMotorBeltAxisBasic.ErrorReset	 := MotorResetError;
	// ASSIGNING LOCAL VARIABLES TO GLOBAL VARIABLES
	MotorInPosition 				 := gMotorBeltAxisBasic.InPosition;
	ItemDetected					 := gWeightDetected;
	ItemWeight 						 := gInWeightMeasure;

	// TIMERS
	// actuator
	TimerTonActuator(IN := TimerTonActuatorIn, PT := TIME_TON_ACTUATOR);
	TimerTonActuatorOut := TimerTonActuator.Q;
	// camera
	TimerTonCamera(IN := gImageAcq , PT := TIME_TON_CAMERA);
	TimerCameraPicDone := TimerTonCamera.Q;
	
	// COUNTERS
	CTU_QuantityLeft(CU := AddToLeft, RESET := CTU_Reset, PV := gMaxLeftStorage);
	CTU_QuantityRight(CU := AddToRight, RESET := CTU_Reset, PV := gMaxRightStorage);
	QuantityLeftStorage  := CTU_QuantityLeft.CV;
	QuantityRightStorage := CTU_QuantityRight.CV;
	
	//COUNTERS ALARMS (MOZE PRZERZUC DO ALARMÓW)
	IF QuantityLeftStorage >= gMaxLeftStorage THEN
		//WYWO£AJ ERROR 
	END_IF;
	
	IF QuantityRightStorage >= gMaxRightStorage THEN
		//WYWO£AJ ERROR
	END_IF;
	
	// ITEM DETECTION CONDITION 
	ItemDetected := (ItemWeight > 1);
	
	// ONLY FOR NOW
	SortChoice := WEIGHT; 
	
	// PROGRAM
	IF Stop OR gMode = 1 THEN
		State := STOP;
	END_IF;
	
	CASE State OF
		STOP:
			StringState := 'Stop';
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
				State := INIT;
			END_IF;
			
		INIT:
			StringState 		:= 'Inicjalizacja';
			ItemWeightMeasured 	:= RESET_ITEM_MEM_WEIGHT;
			AddToRight 			:= FALSE;
			AddToLeft 			:= FALSE;
			TimerTonActuatorIn 	:= FALSE;
			ActuatorSorting 	:= FALSE;
			ActuatorPushing 	:= FALSE;
			MotorPower 			:= TRUE;
			MotorMoveAdditive 	:= FALSE;
			IF Start THEN
				Start := FALSE;
				State := DETECTION;
			END_IF;
			
		DETECTION:
			StringState := 'Wykrywanie detalu';
			IF ItemDetected THEN
				ItemWeightMeasured := ItemWeight;
				State := CATEGORIZATION;
			END_IF;
				
		CATEGORIZATION: 
			StringState := 'Kategoryzacja detalu';
			IF SortChoice = WEIGHT THEN
				State := DROP;
			ELSIF SortChoice = WEIGHT_AND_OPTIC THEN
				State := TAKE_PICT_CAMERA_AND_DROP;
			ELSIF SortChoice = OPTIC THEN
				State := TAKE_PICT_CAMERA_AND_DROP;
			END_IF;
			
		TAKE_PICT_CAMERA_AND_DROP:
			StringState := 'Robienie zdjêcia i rozpoznawanie';
			gImageAcq 	:= TRUE; //zrob zdj na zboczu narastajacym
			IF TimerCameraPicDone THEN
				IF gRecognisedModel = 0 THEN //BR AS Unrecognised
					gImageAcq 	:= FALSE;
					StringRecognisedModel := 'B&R';
					State := SORT_OPTIC;
				ELSIF gRecognisedModel = 1 THEN
					gImageAcq 	:= FALSE;
					StringRecognisedModel := 'AS';
					State := SORT_OPTIC;
				ELSIF gRecognisedModel = 2 THEN
					gImageAcq 	:= FALSE;
					StringRecognisedModel := 'Unrecognised';
					State := SORT_OPTIC;
				END_IF;
			END_IF;
			
			
			//DROP DODAJ
				
		DROP:
			StringState := 'Dozowanie detalu';
			gImageAcq := FALSE;
			ActuatorPushing := TRUE;
			IF TimerTonActuatorOut THEN
				ActuatorPushing := FALSE;
				State := SORT_WEIGHT;
			END_IF;
				
			// ABOVE 1 TO ItemWeightChoosen ITEM FALL INTO THE LEFT, AND ABOVE ItemWeightChoosen INTO THE RIGHT	
		SORT_WEIGHT: 
			StringState := 'Sortowanie wagowe';
			IF ItemWeightMeasured > 1 AND ItemWeightMeasured < ItemWeightChoosen THEN
				State := GO_STORAGE_LEFT;
			ELSIF ItemWeightMeasured >= ItemWeightChoosen THEN 
				State := GO_STORAGE_RIGHT;
			END_IF;
			
		SORT_WEIGHT_AND_OPTIC:
			//RESETUJ ZMIANY B&R I AS
			StringState := 'Sortowanie wagowe i optyczne';
			//DOPISZ
			
		SORT_OPTIC:
			StringState := 'Sortowanie optyczne';
			//DOPISZ
			
		GO_STORAGE_LEFT:
			StringState := 'Transport detalu do lewego zbiornika';
			MotorDist := MOTOR_DIST_LEFT;
			MotorMoveAdditive := TRUE;
			IF MotorInPosition AND MotorMoveDone THEN
				State := SORT_STORAGE_LEFT;
			END_IF;

		GO_STORAGE_RIGHT:
			StringState := 'Transport detalu do prawego zbiornika';
			MotorDist := MOTOR_DIST_RIGHT;
			MotorMoveAdditive := TRUE;
			IF MotorInPosition AND MotorMoveDone THEN
				State := SORT_STORAGE_RIGHT;				
			END_IF;
			
		SORT_STORAGE_LEFT:
			StringState := 'Zepchniecie z taœmy do zbiornika lewego';
			
			MotorMoveAdditive := FALSE;
			ActuatorSorting := TRUE;
			AddToLeft := TRUE;
			IF TimerTonActuatorOut THEN
				State := INIT;
			END_IF;

		SORT_STORAGE_RIGHT:
			AddToRight := TRUE;
			MotorMoveAdditive := FALSE;
			State := INIT;

	END_CASE;

	
	// TIMER INPUT TRIGGER TO DELAY ACTUATORS
	IF ActuatorPushing OR ActuatorSorting THEN
		TimerTonActuatorIn := TRUE;
	ELSE
		TimerTonActuatorIn := FALSE;
	END_IF;
	
	// OPERATION OF BYTE ACTUATORS WITH TIMER
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

PROGRAM _EXIT

	 
END_PROGRAM

