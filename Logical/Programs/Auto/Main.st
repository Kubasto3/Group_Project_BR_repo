
PROGRAM _INIT
	gActuatorByte := 2#0000_0000_0000_0000;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF gStart AND NOT gStop THEN
		
		IF gInWeightDetected THEN  //TESTOWANIE
			gActuatorByte := 2#0000_0000_0000_0101;
		ELSE
			gActuatorByte := 2#0000_0000_0000_0000;
		END_IF;
	
		//Fragment kodu odpowiedzialny za inicjalizacjê taœmy
		
		
		
	END_IF;
END_PROGRAM

PROGRAM _EXIT
	
	 
END_PROGRAM

