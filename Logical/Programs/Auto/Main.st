//JESZCZE NIE DZIA£A
PROGRAM _INIT
	ActuatorByte := 2#0000_0000_0000_0000;
	MotorResetError := TRUE;
	gMotorBeltAxisBasic;
	gMotorBeltParType;
	gMotorBeltParType; //tylko do watcha
END_PROGRAM

PROGRAM _CYCLIC
	
	//ZROB COS Z TYM
	gAxis_1;
	gMotorBeltParType;
	gMotorBeltAxisBasic.MpLink := ADR(gAxis_1);
	gMotorBeltAxisBasic.Enable := TRUE;
	gMotorBeltAxisBasic.Parameters := ADR(gMotorBeltParType);
	//przypisywanie parametrów ruchu
	//	gMotorBeltParType.Direction := FORWARD;
	gMotorBeltParType.Acceleration := MotorAcc;
	gMotorBeltParType.Deceleration := MotorDec;
	gMotorBeltParType.Velocity := MotorVel;
	gMotorBeltParType.Distance := MotorDist;
	gMotorBeltAxisBasic();
	//
	
	
	
	//przypisywanie zmiennych globalnych do localnych 
	Start 							 := gStart;						
	Stop							 := gStop;
	ActuatorByte 					 := gActuatorByte;
	gMotorBeltAxisBasic.Power 		 := MotorPower;
	gMotorBeltAxisBasic.MoveAdditive := MotorMoveAdd;
	gMotorBeltAxisBasic.ErrorReset	 := MotorResetError;
	MotorInPosition 				 := gMotorBeltAxisBasic.InPosition;
	ItemDetected					 := gWeightDetected;
	ItemWeight 						 := gInWeightMeasure;	

	
	

	//TYMCZASOWO BEZ HMI
	SortChoice := WEIGHT; 
	ItemWeightChoosen := 13;
	

	//TIMERY
	TimerTonActuator(IN := TimerTonActuatorIn, PT := TIME_TON_ACTUATOR); //zmien //dodaj moze drugi timer //WYZWALANIE TIMERA (moze inna zmienna)
	TimerTonActuatorOut := TimerTonActuator.Q;			 
	
	
	//WARUNEK WYKRYCIA OBIEKTU
	ItemDetected := (ItemWeight > 1);
	
	//PROGRAM
	CASE State OF
		STOP:
			TimerTonActuatorIn := FALSE;
			MotorPower := FALSE;
			MotorMoveAdd := FALSE;
			MotorResetError := TRUE;
			IF NOT Stop THEN
				State := INIT;
			END_IF;
			
		STOP_AND_MANUAL:
			//DOPISZ
			
		INIT:
			ItemWeightMeasured := 0;
			TimerTonActuatorIn := FALSE;
			ActuatorByte := 2#0000_0000_0000_0000;
			MotorResetError := FALSE;
			MotorPower := TRUE;
			IF Stop THEN
				State := STOP;
			ELSIF Start THEN
				gStart := FALSE;
				State := DETECTION;
			END_IF;
			
		DETECTION:
			IF Stop THEN
				State := STOP;
			ELSIF ItemDetected THEN
				ItemWeightMeasured := ItemWeight;
				State := DROP;
			END_IF;
			
		DROP:
			TimerTonActuatorIn := TRUE;
			ActuatorByte := 2#0000_0000_0000_0100;
			IF Stop THEN
				State := STOP;
			ELSIF TimerTonActuatorOut THEN
				ActuatorByte := 2#0000_0000_0000_0000;
				TimerTonActuatorIn := FALSE;
				State := CATEGORIZATION;
			END_IF;
			
		CATEGORIZATION: 
			IF Stop THEN
				State := STOP;
			ELSIF SortChoice = WEIGHT THEN
				State := SORT_WEIGHT;
			ELSIF SortChoice = WEIGHT_AND_OPTIC THEN
				State := SORT_WEIGHT_AND_OPTIC;
			ELSIF SortChoice = OPTIC THEN
				State := SORT_OPTIC;
			END_IF;
			
		SORT_WEIGHT: //od 0 do ItemWeightChoosen wpadaja do lewego, a powyzej do prawego - DO EWENTUALNEJ MODYFIKACJI
			IF Stop THEN
				State := STOP;
			ELSIF ItemWeightMeasured > 1 AND ItemWeightMeasured < ItemWeightChoosen THEN 
				State := SORT_STORGE_LEFT;
			ELSIF ItemWeightMeasured >= ItemWeightChoosen THEN 
				State := SORT_STORGE_RIGHT;
			END_IF;
			
		SORT_WEIGHT_AND_OPTIC:
			//DOPISZ
			
		SORT_OPTIC:
			//DOPISZ
			
		SORT_STORGE_LEFT:
			IF Stop THEN
				State := STOP;
			ELSE
				MotorDist := 100;
				MotorMoveAdd := TRUE;
				IF MotorInPosition AND MotorMoveDone THEN //rozdziel na pare kroków
					MotorMoveAdd := FALSE;
					IF TimerTonActuatorOut THEN
						ActuatorByte := 2#0000_0000_0000_0001;
						TimerTonActuatorIn := FALSE;
						State := INIT;
					END_IF;
				END_IF;
			END_IF;
			
		SORT_STORGE_RIGHT:
			IF Stop THEN
				State := STOP;
			ELSE
				MotorDist := 300; //zmien na CONST
				MotorMoveAdditive := TRUE;
				IF MotorInPosition AND MotorMoveDone THEN
					
					MotorMoveAdd := FALSE;
					TimerTonActuatorIn:= TRUE;
					IF TimerTonActuatorOut THEN
						TimerTonActuatorIn:= FALSE;
						State := INIT;
					END_IF;
				END_IF;
			END_IF;
		
	END_CASE;
END_PROGRAM

PROGRAM _EXIT

	 
END_PROGRAM

