
PROGRAM _INIT
	(* Insert code here *)
	
	PhotosTaken;
	NumberMatches;
	RecognisedModel;
	MatchEnable;
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	 
	gRecognisedModel := RecognisedModel;
	
	//calling variables used in I/O matching of camera to delete warnings
	SET_FOCUS;
	NUM_SEARCH_MAX;
	EXPO_TIME;
	MIN_SCORE;
	MAX_OVERLAP;
	FLASH_COLOR;
	FLASH_SEGMENT;
	gImageAcq;
	MatchScore;
	
	
	//displaying last taken photo
	ViBaseGetImage_0(MpLink := ADR(gCamera), Execute := ExecuteGetImg, Type := 0, Buffer := BufferImage, BufferSize := BufferImageSize);
	
	(*strcpy(BufferEncodedImg, '<image x=$'0$' y=$'0$' width=$'1280px$' height=$'1024px$' href=$'data:application/octet-stream;base64,');
	
	EnableEncode := ViBaseGetImage_0.Done;
	
	httpEncodeBase64_0(enable := EnableEncode, pSrc := ADR(BufferImage), srcLen := ViBaseGetImage_0.BufferLen, pDest := ADR(BufferEncodedImg) + strlen(BufferEncodedImg), destSize := SIZEOF(BufferEncodedImg) - strlen(BufferEncodedImg) – strlen('$' />'));
	
	strcat(BufferEncodedImg, '$' />') ;*)
	
	TONWarning1.IN := StartWarning;
	TONWarning1.PT := TIME_TON_WARNING;
	
	TONWarning2.IN := TONWarning1.Q;
	TONWarning2.PT := TIME_TON_WARNING;
	
	TONWarning1();
	TONWarning2();
	
	IF TONWarning1.Q THEN 
		StatusLEDWarning := 4;
		StartWarning := FALSE;
	END_IF
	
	IF TONWarning2.Q THEN
		StatusLEDWarning := 1;
		i := i + 1;
		StartWarning := TRUE;
	END_IF
	
	IF i=4 THEN 
		StartWarning := FALSE;
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

