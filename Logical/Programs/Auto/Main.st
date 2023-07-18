
PROGRAM _INIT
	
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF gStart AND NOT gStop THEN
		
		IF TRUE THEN  //TESTOWANIE
			ActuatorByte := 2#0000_0000_0000_0101;
		ELSE
			ActuatorByte := 2#0000_0000_0000_0000;
		END_IF;
	
		//Fragment kodu odpowiedzialny za inicjalizacjê taœmy
		gAxis_1;
		MotorBeltAxisBasic.MpLink := ADR(gAxis_1);
		MotorBeltAxisBasic.Enable := TRUE;
		MotorBeltAxisBasic.Parameters := ADR(MotorBeltParType);	
		MotorBeltAxisBasic();
		
		
	END_IF;
END_PROGRAM

PROGRAM _EXIT
	
	 
END_PROGRAM

