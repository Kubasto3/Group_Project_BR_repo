// ALREADY WORKING, ONLY SOME CHANGES REQUIRED
PROGRAM _INIT
	// NEED ONLY FOR WATCH
	gAxis_1;
	gMotorBeltParType;
	gMotorBeltAxisBasic;
END_PROGRAM

PROGRAM _CYCLIC
	//CODE WORKS ONLY WHEN MANUAL MODE IS OFF	
	
	IF  gMode = 0 THEN
		//ALARM
		IF gAlarmHardware THEN
			IF NOT (State = ERROR) THEN
				State := ERROR;
			END_IF;
		END_IF;
		
		// MOTOR MANAGEMENT
		gMotorBeltAxisBasic.Enable 		:= TRUE;
		gMotorBeltAxisBasic.MpLink 		:= ADR(gAxis_1);
		gMotorBeltAxisBasic.Parameters 	:= ADR(gMotorBeltParType);
		MotorMoveDone 					:= gMotorBeltAxisBasic.MoveDone;
		gMotorBeltAxisBasic.Power 		:= MotorPower;
		gMotorBeltAxisBasic.Home 		:= MotorHome;
		
		// IN STATE STOP VALUES DOESN'T FLUCTUATE
		IF gMotorBeltAxisBasic.Velocity > 15 THEN
			MotorVel := gMotorBeltAxisBasic.Velocity;
		ELSE
			MotorVel := 0;
		END_IF;
		IF gMotorBeltAxisBasic.Position > 5 THEN
			MotorPos := gMotorBeltAxisBasic.Position;
		ELSE
			MotorPos := 0;
		END_IF;
		
		// ASSIGNING MOTION PARAMETERS
		gMotorBeltParType.Acceleration 	:= MotorReqAcc; 
		gMotorBeltParType.Deceleration 	:= MotorReqDec; 
		gMotorBeltParType.Velocity 		:= MotorReqVel;
		gMotorBeltParType.Position 		:= MotorReqPosition;
		
		gMotorBeltAxisBasic();
	
		// ASSIGNING GLOBAL VARIABLES TO LOCAL VARIABLES
		gActuatorByte					 := ActuatorByte;
		gMotorBeltAxisBasic.Power 		 := MotorPower;
		gMotorBeltAxisBasic.MoveAbsolute := MotorMoveAbsolute;
		gMotorBeltAxisBasic.ErrorReset	 := MotorResetError;
		gStopState 						 := (State = 0);
		
		// ASSIGNING LOCAL VARIABLES TO GLOBAL VARIABLES
		MotorInPosition 				 := gMotorBeltAxisBasic.InPosition;
		ItemWeight 						 := gInWeightMeasure;							 

		
		
		
		// ITEM DETECTION CONDITION 
		ItemDetected := (ItemWeight > 1);
		gWeightDetected := ItemDetected;
		
		// TIMERS
		// actuator
		TimerTonActuator(IN := TimerTonActuatorIn, PT := TIME_TON_ACTUATOR);
		TimerActuatorOut := TimerTonActuator.Q;
		// camera
		TimerTonCamera(IN := gImageAcq , PT := TIME_TON_CAMERA);
		TimerCameraPicDone := TimerTonCamera.Q;
		// delay after detection
		TimerTonDetect.IN := ItemDetected;
		TimerTonDetect.PT := TIME_TON_DETECT;
		TimerAfterDetect := TimerTonDetect.Q;
		TimerTonDetect();
	
		// COUNTERS
		CTU_QuantityLeft(CU := AddToLeft, RESET := CTU_Reset_Left, PV := gMaxLeftStorage);
		CTU_QuantityRight(CU := AddToRight, RESET := CTU_Reset_Right, PV := gMaxRightStorage);
		QuantityLeftStorage  := CTU_QuantityLeft.CV;
		QuantityRightStorage := CTU_QuantityRight.CV;
	END_IF; 
	
	
	// STOP OR MANUAL TURNED ON
	IF Stop OR NOT gMode = 0 THEN //uwagaw trzeba to zmienic alarm
		Stop := FALSE;
		State := STOP;
	END_IF;
	// PROGRAM AUTO
	CASE State OF
		STOP:
			IF gAlarmHardware THEN
	  			State := ERROR;
			END_IF;
			
			IF gMode = 0 THEN
				MotorPower 		  := FALSE;
				MotorMoveAbsolute := FALSE;
				MotorHome 		  := FALSE;
			END_IF;
			
			gMotorBeltAxisBasic.ErrorReset := FALSE;
			MotorPos := 0;
			MotorVel := 0;
			StringState := 'Stop';
			TimerTonActuatorIn 	  := FALSE;
			ActuatorSorting 	  := FALSE;
			ActuatorPushing  	  := FALSE;
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
			MotorMoveAbsolute 	:= FALSE;
			MotorPower 			:= TRUE;
			MotorHome 			:= TRUE;
			gPicNotRecognised	:= FALSE; //pozniej musi zniknac, reset z poziomu alarmow lepszy
			IF ItemDetected THEN
				State := DETECTION;
			END_IF;
			
		DETECTION:
			MotorHome 	:= FALSE;
			StringState := 'Wykrycie detalu';
			IF TimerAfterDetect THEN
				ItemWeightMeasured := ItemWeight;
				State := CATEGORIZATION;
			END_IF;
				
		CATEGORIZATION: 
			StringState := 'Kategoryzacja detalu';
			IF gSortChoice = WEIGHT THEN
				State := DROP;
			ELSIF gSortChoice = OPTIC THEN
				State := TAKE_PICT_CAMERA;
			END_IF;
			
		TAKE_PICT_CAMERA:
			StringState := 'Robienie zdjecia';
			gImageAcq 	:= TRUE;
			IF TimerCameraPicDone THEN
				IF gRecognisedModel = 0 THEN 						//0
					gImageAcq 			  := FALSE;
					StringRecognisedModel := 'Unrecognised';
					State 				  := UNRECOGNISED_PIC;
				ELSE 
					State 				  := DROP;
				END_IF;
			END_IF;
				
		DROP:
			StringState := 'Dozowanie detalu';
			ActuatorPushing := TRUE;
			IF TimerActuatorOut THEN
				ActuatorPushing := FALSE;
				IF gSortChoice = OPTIC THEN
					gSortChoiceView := TRUE;
					State := SORT_OPTIC;
				ELSIF gSortChoice = WEIGHT THEN
					gSortChoiceView := FALSE;
					State := SORT_WEIGHT;
				END_IF;
			END_IF;
			
			// ABOVE 1 TO ItemWeightChoosen ITEM FALL INTO THE LEFT, EQUAL AND ABOVE ItemWeightChoosen INTO THE RIGHT	
		SORT_WEIGHT: 
			StringState := 'Sortowanie wagowe';
			IF ItemWeightMeasured > 1 AND ItemWeightMeasured < ItemWeightChoosen THEN
				IF SortLeftMin THEN
					State := GO_STORAGE_LEFT;
				ELSE
					State := GO_STORAGE_RIGHT;
				END_IF;
			ELSIF ItemWeightMeasured >= ItemWeightChoosen THEN 
				IF SortLeftMin THEN
					State := GO_STORAGE_RIGHT;
				ELSE
					State := GO_STORAGE_LEFT;
				END_IF;
			END_IF;
			
		SORT_OPTIC:
			StringState := 'Sortowanie optyczne';
			IF gRecognisedModel = 1 THEN	
				gImageAcq 			  := FALSE;
				StringRecognisedModel := 'B&R';					//1
				IF SortLeftBR THEN
					State := GO_STORAGE_LEFT;
				ELSE
					State := GO_STORAGE_RIGHT;
				END_IF;
			
			ELSIF gRecognisedModel = 2 THEN						//2
				gImageAcq 			  := FALSE;
				StringRecognisedModel := 'AS';
				IF SortLeftBR THEN
					State := GO_STORAGE_RIGHT;
				ELSE
					State := GO_STORAGE_LEFT;
				END_IF;
			END_IF;
			
			
		GO_STORAGE_LEFT:
			StringState := 'Transport detalu do lewego zbiornika';
			MotorReqPosition := MOTOR_DIST_LEFT;
			MotorMoveAbsolute := TRUE;
			IF MotorInPosition AND MotorMoveDone THEN
				State := SORT_STORAGE_LEFT;
			END_IF;

		GO_STORAGE_RIGHT:
			StringState := 'Transport detalu do prawego zbiornika';
			MotorReqPosition  := MOTOR_DIST_RIGHT;
			MotorMoveAbsolute := TRUE;
			IF MotorInPosition AND MotorMoveDone THEN
				State := SORT_STORAGE_RIGHT;				
			END_IF;
			
		SORT_STORAGE_LEFT:
			StringState := 'Zepchniecie detalu z taœmy do zbiornika lewego';
			MotorMoveAbsolute := FALSE;
			ActuatorSorting   := TRUE;
			AddToLeft 		  := TRUE;
			IF TimerActuatorOut THEN
				State := INIT;
			END_IF;

		SORT_STORAGE_RIGHT:
			AddToRight := TRUE;
			MotorMoveAbsolute := FALSE;
			State := INIT;
		
		UNRECOGNISED_PIC:
			StringState := 'Nie rozpoznano zdjêcia';
			gPicNotRecognised := TRUE; 
			State := STOP;
			
		ERROR:
			gMotorBeltAxisBasic.ErrorReset := TRUE;
			IF NOT gAlarmHardware AND gAlarmHardAck THEN
				State := STOP;
			END_IF;
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
		IF TimerActuatorOut THEN
			ActuatorPushing := FALSE;
		END_IF;
	ELSIF ActuatorSorting THEN
		ActuatorByte := ACTUATOR_BYTE_SORT;
		IF TimerActuatorOut THEN
			ActuatorSorting := FALSE;
		END_IF;
	ELSE
		ActuatorByte := ACTUATOR_BYTE_NOT_ACTIV;
	END_IF;
	
	ActuatorNotSorting := NOT ActuatorSorting;
	ActuatorNotPushing 	:= NOT ActuatorPushing;
	
	IF Start THEN
		Start := FALSE;
	END_IF;
	
	//Kod do wizualizacji ilosci klockow ~~J
	
	IF QuantityLeftStorage = 1 THEN 
		Rectangle1_Left_Visibility := 1;
		Rectangle2_Left_Visibility := 1;
		Rectangle3_Left_Visibility := 1;
		Rectangle4_Left_Visibility := 1;
	ELSIF QuantityLeftStorage = 2 THEN
		Rectangle1_Left_Visibility := 1;
		Rectangle2_Left_Visibility := 1;
		Rectangle3_Left_Visibility := 1;
		Rectangle4_Left_Visibility := 1;
	ELSIF QuantityLeftStorage = 3 THEN
		Rectangle1_Left_Visibility := 1;
		Rectangle2_Left_Visibility := 1;
		Rectangle3_Left_Visibility := 1;
		Rectangle4_Left_Visibility := 1;
	ELSIF QuantityLeftStorage >= 4 THEN
		Rectangle1_Left_Visibility := 1;
		Rectangle2_Left_Visibility := 1;
		Rectangle3_Left_Visibility := 1;
		Rectangle4_Left_Visibility := 1;
	ELSE
		Rectangle1_Left_Visibility := 0;
		Rectangle2_Left_Visibility := 0;
		Rectangle3_Left_Visibility := 0;
		Rectangle4_Left_Visibility := 0;
	END_IF
	
	IF QuantityRightStorage = 1 THEN 
		Rectangle1_Right_Visibility := 1;
		Rectangle2_Right_Visibility := 0;
		Rectangle3_Right_Visibility := 0;
		Rectangle4_Right_Visibility := 0;
	ELSIF QuantityRightStorage = 2 THEN
		Rectangle1_Right_Visibility := 1;
		Rectangle2_Right_Visibility := 1;
		Rectangle3_Right_Visibility := 0;
		Rectangle4_Right_Visibility := 0;
	ELSIF QuantityRightStorage = 3 THEN
		Rectangle1_Right_Visibility := 1;
		Rectangle2_Right_Visibility := 1;
		Rectangle3_Right_Visibility := 1;
		Rectangle4_Right_Visibility := 0;
	ELSIF QuantityRightStorage >= 4 THEN
		Rectangle1_Right_Visibility := 1;
		Rectangle2_Right_Visibility := 1;
		Rectangle3_Right_Visibility := 1;
		Rectangle4_Right_Visibility := 1;
	ELSE
		Rectangle1_Right_Visibility := 0;
		Rectangle2_Right_Visibility := 0;
		Rectangle3_Right_Visibility := 0;
		Rectangle4_Right_Visibility := 0;
	END_IF
		
	
END_PROGRAM

PROGRAM _EXIT

	 
END_PROGRAM

