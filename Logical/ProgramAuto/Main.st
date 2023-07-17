
PROGRAM _INIT
	
	//Wysun; // testowa zmienna
	
END_PROGRAM

PROGRAM _CYCLIC
//	IF Wysun THEN  //TESTOWANIE
//		BAIT := 2#0000_0000_0000_0101;
//	ELSE
//		BAIT := 2#0000_0000_0000_0000;
//	END_IF;
	
	//Fragment kodu odpowiedzialny za inicjalizacjê taœmy
	gAxis_1;
	MotorBeltAxisBasic.MpLink := ADR(gAxis_1);
	MotorBeltAxisBasic.Enable := TRUE;
	MotorBeltAxisBasic.Parameters := ADR(MotorBeltParType);	
	MotorBeltAxisBasic();
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	
	 
END_PROGRAM

