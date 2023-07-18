
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
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
	(* Insert code here *)
	 
END_PROGRAM

