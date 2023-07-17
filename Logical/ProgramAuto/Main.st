
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
	
	gMpRecipeXML_0.MpLink := ADR(gRecipeXml);
	gMpRecipeXML_0.Enable := TRUE;
	gMpRecipeXML_0.DeviceName := ADR('CF'); 
	gMpRecipeXML_0.FileName := ADR('MyFile2');
	
	gMpRecipeRegPar_0.MpLink := ADR(gRecipeXml);
	gMpRecipeRegPar_0.Enable := TRUE;
	gMpRecipeRegPar_0.PVName := ADR('Coffee');
	
	gMpRecipeUI_0.MpLink := ADR(gRecipeXml);
	gMpRecipeUI_0.Enable := TRUE;
	gMpRecipeUI_0.UISetup := gUISetup;
	gMpRecipeUI_0.UIConnect := ADR(gUIConnect);
	
	Coffee.Water;
	Coffee.Milk;
	Coffee.Powder;
	Coffee.Sugar;
	Coffee.Temperature;
	
	gMpRecipeXML_0();
	gMpRecipeRegPar_0();
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	
	 
END_PROGRAM

