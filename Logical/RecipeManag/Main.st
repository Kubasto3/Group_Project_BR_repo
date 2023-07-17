
PROGRAM _INIT
	MpRecipeRegPar_0(MpLink := ADR(gRecipeXml) , Enable := TRUE, PVName := ADR('ProgramManual:ProcessRecipe0')); //tutaj zmienna do edycji
	MpRecipeXml_0(MpLink := ADR(gRecipeXml), Enable := TRUE, DeviceName := ADR('CF'), FileName := ADR('Recipes'));
	MpRecipeUI_0(MpLink := ADR(gRecipeXml), Enable := TRUE, UIConnect := ADR(UIConnect0) );
END_PROGRAM

PROGRAM _CYCLIC
	//Pamiêtaj pozmieniaæ strukturê wraz ze zmienna 
	MpRecipeXml_0();
	MpRecipeRegPar_0();
	MpRecipeUI_0();
END_PROGRAM

PROGRAM _EXIT
	MpRecipeXml_0(Enable := FALSE);
	MpRecipeXml_0();
	
	MpRecipeRegPar_0(Enable := FALSE);
	MpRecipeRegPar_0();
	
	MpRecipeUI_0(Enable := FALSE);
	MpRecipeUI_0();
END_PROGRAM

