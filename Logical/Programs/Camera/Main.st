
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
	
		
	IF gPicNotRecognised THEN
		CameraLED 	:= LED_BLUE;
		CameraLED_2 := LED_NOTHING;
	ELSIF gWeightDetected THEN
		CameraLED 	:= LED_RED;
		CameraLED_2 := LED_BLUE;
	ELSIF gAlarmExist THEN
		CameraLED 	:= LED_RED;
		CameraLED_2 := LED_NOTHING;
	END_IF;
	
	
	IF NOT gStopBlink THEN
		TimerTonCameraLED.IN := TRUE;
		CameraLED := LED_RED;
		IF TimerTonCameraLED.Q THEN
			TimerTonCameraLED_2.IN := TRUE;
			CameraLED := LED_BLUE; 
			IF TimerTonCameraLED_2.Q THEN
				TimerTonCameraLED.IN := FALSE; 				//1 TIMER
				TimerTonCameraLED_2.IN := FALSE;			//2 TIMER
			END_IF;
		END_IF;
	ELSE
		CameraLED  := LED_PLC_STATUS;
		CameraLED_2 := LED_PLC_STATUS;
	END_IF;
	
	
//
//	
//	
//	CASE gStateCameraLED OF
//		WARNING_ACTUATOR_PUSHING:
//			TimerTonCameraLED.IN := TRUE;
//			CameraLED := LED_RED;
//			IF TimerTonCameraLED.Q THEN
//				TimerTonCameraLED2.IN := TRUE;
//				CameraLED := LED_BLUE; 
//				IF TimerTonCameraLED2.Q THEN
//					TimerTonCameraLED.IN := FALSE; 			//1 TIMER
//					TimerTonCameraLED2.IN := FALSE;			//2 TIMER
//				END_IF;
//			END_IF;
//		  
//		PICTURE_UNRECOGNISED:
//			TimerTonCameraLED.IN := TRUE;
//			CameraLED := LED_NOTHING;
//			IF TimerTonCameraLED.Q THEN
//				TimerTonCameraLED2.IN := TRUE;
//				CameraLED := LED_BLUE; 
//				IF TimerTonCameraLED2.Q THEN
//					TimerTonCameraLED.IN := FALSE; 			//1 TIMER
//					TimerTonCameraLED2.IN := FALSE;			//2 TIMER
//				END_IF;
//			END_IF;
//			
//		ALARM:
//			TimerTonCameraLED.IN := TRUE;
//			CameraLED := LED_RED;
//			IF TimerTonCameraLED.Q THEN
//				TimerTonCameraLED2.IN := TRUE;
//				CameraLED := LED_NOTHING; 
//				IF TimerTonCameraLED2.Q THEN
//					TimerTonCameraLED.IN := FALSE; 			//1 TIMER
//					TimerTonCameraLED2.IN := FALSE;			//2 TIMER
//				END_IF;
//			END_IF;
//			
//		NONE:
//			TimerTonCameraLED.IN := FALSE;
//			CameraLED := LED_NOTHING;
//			
//	END_CASE;
	
	TimerTonCameraLED.PT := TIMER_TIME_BLINK;
	TimerTonCameraLED();
	
	TimerTonCameraLED_2.PT := TIMER_TIME_BLINK;
	TimerTonCameraLED_2();
	
	
	
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

