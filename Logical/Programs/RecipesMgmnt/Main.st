
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	gMpRecipeXML_0.MpLink := 		ADR(gRecipeXml);
	gMpRecipeXML_0.Enable := 		TRUE;
	gMpRecipeXML_0.DeviceName :=	ADR('SzymonZapis'); 
	gMpRecipeXML_0.FileName := 		ADR('TestoweParametry'); //zmienic sciezke
	
	gMpRecipeRegPar_0.MpLink := 	ADR(gRecipeXml);
	gMpRecipeRegPar_0.Enable :=		TRUE;
	gMpRecipeRegPar_0.PVName := 	ADR('Coffee');
	
	gMpRecipeUI_0.MpLink :=			ADR(gRecipeXml);
	gMpRecipeUI_0.Enable := 		TRUE;
	gMpRecipeUI_0.UISetup := 		gUISetup;
	gMpRecipeUI_0.UIConnect := 		ADR(gUIConnect);
	
	gSorting.gItemWeightChoosen;
	gSorting.gRecognisedModel; //CO TU DAC???
	gSorting.gSortLeftMin;
	
	Coffee.Water;
	Coffee.Milk;
	Coffee.Powder;
	Coffee.Sugar;
	Coffee.Temperature;
	
//	Parametry sortowania powinno dac sie zapisac oraz wczytac przy uzyciu systemu receptur 
//	MpRecipe. Na stronie parametrów powinna wiec istniec mozliwosc przegladania listy dostepnych receptur, 
//	wczytania receptury z listy, zapisania nowej receptury oraz modyfikacji parametrów dowolnej z zapisanych 
//	receptur. Powinno byc takze mozliwe wyswietlenie parametrów danej receptury bez wczytywania jej oraz 
//	calkowite usuniecie receptury widocznej na liscie. Zarówno na stronie parametrów jak i na stronie pracy automatycznej (oraz przy pracy pólautomatycznej) powinna byc wyswietlona obecnie wczytana receptura, 
//	chyba ze uzywane sa aktualnie niezapisane DO receptury, recznie ustawione, parametry sortowania.

	
	gMpRecipeXML_0();
	gMpRecipeRegPar_0();
	gMpRecipeUI_0();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

