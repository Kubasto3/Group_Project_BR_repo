//JESZCZE NIE DZIA£A
PROGRAM _INIT
	ActuatorByte := ACTUATOR_BYTE_NOT_ACTIV;
	MotorResetError := TRUE;
	gMotorBeltAxisBasic;
	gMotorBeltParType; //tylko do watcha
	ActuatorPushing := FALSE;
	ActuatorSorting := FALSE;
END_PROGRAM

PROGRAM _CYCLIC
	
	//ZROB COS Z TYM
	gAxis_1;
	gMotorBeltParType;
	gMotorBeltAxisBasic.MpLink := ADR(gAxis_1);
	gMotorBeltAxisBasic.Enable := TRUE;
	gMotorBeltAxisBasic.Parameters := ADR(gMotorBeltParType);
	MotorMoveDone := gMotorBeltAxisBasic.MoveDone;
	gMotorBeltAxisBasic.Power := MotorPower;
	//przypisywanie parametrów ruchu
	//	gMotorBeltParType.Direction := FORWARD;
	gMotorBeltParType.Acceleration := MotorAcc; //tez
	gMotorBeltParType.Deceleration := MotorDec; //mniej niz 1000
	gMotorBeltParType.Velocity := MotorVel; //>100
	gMotorBeltParType.Distance := MotorDist; //mniej niz 100
	
	gMotorBeltAxisBasic();
	//WYZWALANIE WEJSCIA TIMERA DO CZEKANIA SI£OWNIKÓW
	IF ActuatorPushing OR ActuatorSorting THEN
		TimerTonActuatorIn := TRUE;
	ELSE
		TimerTonActuatorIn := FALSE;
	END_IF;
	
	//OBSLUGA BYTE SI£OWNIKÓW Z WAITEM
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
	
	//przypisywanie zmiennych globalnych do localnych 
	gActuatorByte					 := ActuatorByte;
	gMotorBeltAxisBasic.Power 		 := MotorPower;
	gMotorBeltAxisBasic.MoveAdditive := MotorMoveAdditive;
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
			//Zmien na monostabilny stop
			TimerTonActuatorIn := FALSE;
			MotorPower := FALSE;
			MotorMoveAdditive := FALSE;
			MotorResetError := TRUE;
			ActuatorSorting := FALSE;
			ActuatorPushing := FALSE;
			
			//
			IF NOT Stop THEN
				State := INIT;
			END_IF;
			
		STOP_AND_MANUAL:
			//DOPISZ
			
		INIT:
			ItemWeightMeasured := 0;
			TimerTonActuatorIn := FALSE;
			ActuatorSorting := FALSE;
			ActuatorPushing := FALSE;
			MotorResetError := FALSE;
			MotorPower := TRUE;
			IF Stop THEN
				State := STOP;
			ELSIF Start THEN
				Start := FALSE;
				State := DETECTION_AND_DROP;
			END_IF;
			
		DETECTION_AND_DROP:
			IF Stop THEN
				State := STOP;
			ELSIF ItemDetected THEN
				ItemWeightMeasured := ItemWeight;
				ActuatorPushing := TRUE;
				IF TimerTonActuatorOut THEN
					State := CATEGORIZATION;
				END_IF;
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
				State := GO_STORAGE_LEFT;
			ELSIF ItemWeightMeasured >= ItemWeightChoosen THEN 
				State := GO_STORAGE_RIGHT;
			END_IF;
			
		SORT_WEIGHT_AND_OPTIC:
			//DOPISZ
			
		SORT_OPTIC:
			//DOPISZ
			
		GO_STORAGE_LEFT:
			IF Stop THEN
				State := STOP;
			ELSE
				MotorDist := 100;
				MotorMoveAdditive := TRUE;
				IF MotorInPosition AND MotorMoveDone THEN //rozdziel na pare kroków
					State := SORT_STORAGE_LEFT;
				END_IF;
			END_IF;
			
		GO_STORAGE_RIGHT:
			IF Stop THEN
				State := STOP;
			ELSE
				MotorDist := 300; //zmien na CONST
				MotorMoveAdditive := TRUE;
				IF MotorInPosition AND MotorMoveDone THEN
					State := SORT_STORAGE_RIGHT;				
				END_IF;
			END_IF;
			
		SORT_STORAGE_LEFT:
			IF Stop THEN
				State := STOP;
			ELSE
				MotorMoveAdditive := FALSE;
				ActuatorSorting := TRUE;
				IF TimerTonActuatorOut THEN
					State := INIT;
				END_IF;
			END_IF;
			
		SORT_STORAGE_RIGHT:
			IF Stop THEN
				State := STOP;
			ELSE
				MotorMoveAdditive := FALSE;
				State := INIT;

			END_IF;
	END_CASE;
END_PROGRAM

PROGRAM _EXIT

	 
END_PROGRAM

