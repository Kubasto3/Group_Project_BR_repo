
PROGRAM _INIT
	PhotosTaken;
	NumberMatches;
	RecognisedModel;
	MatchEnable;
END_PROGRAM

PROGRAM _CYCLIC
	
	//---CAMERA LED---
	//0 - PLC State
	//1 - Nothing
	//2 - Green
	//3 - Red
	//4 - Blue
	IF NOT gStopBlink THEN
		IF gPicNotRecognised THEN
			gStateCameraLED := PICTURE_UNRECOGNISED;
		ELSIF gWeightDetected THEN
			gStateCameraLED := WARNING_ACTUATOR_PUSHING;
		ELSE
			gStateCameraLED := NONE;
		END_IF;
	END_IF;	
	
	
	CASE gStateCameraLED OF
		WARNING_ACTUATOR_PUSHING:
			TimerTonCameraLED.IN := TRUE;
			IF TimerTonCameraLED.Q THEN
				TimerTonCameraLED.IN := FALSE;
				CameraLED := 1;
			ELSE
				CameraLED := 3; //RED
			END_IF;
		  
		PICTURE_UNRECOGNISED:
			TimerTonCameraLED.IN := TRUE;
			IF TimerTonCameraLED.Q THEN
				TimerTonCameraLED.IN := FALSE;
				CameraLED := 1;
			ELSE
				CameraLED := 4; //BLUE
			END_IF;
			
		NONE:
			CameraLED := 0;
			
	END_CASE;
	
	TimerTonCameraLED.PT := TIMER_TIME_BLINK;
	TimerTonCameraLED();
	
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
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

