
PROGRAM _INIT
	(* Insert code here *)
	
	PhotosTaken;
	NumberMatches;
	RecognisedModel;
	MatchEnable;
	//init variables for displaying taken photo in HMI visualization
	ViBaseGetImage_0.MpLink := ADR(gCamera);
	ViBaseGetImage_0.Type := viBASE_IMAGE_TYPE_BMP;
	ViBaseGetImage_0.QualityLevel := VIBASE_GETIMG_QUALITY;
	ViBaseGetImage_0.Buffer := ADR(ViBaseBuffer);
	ViBaseGetImage_0.BufferSize := SIZEOF(ViBaseBuffer);
	
	URL := '<image x=$'0$' y=$'0$' width=$'1280px$' height=$'1024px$' href=$'data:application/octet-stream;base64,';
	
END_PROGRAM

PROGRAM _CYCLIC
	
	//---CAMERA LED---
	//0 - PLC State
	//1 - Nothing
	//2 - Green
	//3 - Red
	//4 - Blue
	
		
	IF gAlarmExist THEN
		gStopBlink := FALSE;
		CameraLED 	:= LED_RED;
		CameraLED_2 := LED_NOTHING;
	ELSIF gPicNotRecognised THEN
		gStopBlink := FALSE;
		CameraLED 	:= LED_BLUE;
		CameraLED_2 := LED_NOTHING;
	ELSIF gWeightDetected THEN
		gStopBlink := FALSE;
		CameraLED 	:= LED_RED;
		CameraLED_2 := LED_BLUE;
	ELSE
		gStopBlink := TRUE;
	END_IF;
	
	
	IF gStopBlink THEN
		CameraLED_OPC   := LED_PLC_STATUS;
	ELSE
		TimerTonCameraLED.IN := TRUE;
		CameraLED_OPC := CameraLED;
		IF TimerTonCameraLED.Q THEN
			TimerTonCameraLED_2.IN := TRUE;
			CameraLED_OPC := CameraLED_2; 
			IF TimerTonCameraLED_2.Q THEN
				TimerTonCameraLED.IN := FALSE; 				//1 TIMER
				TimerTonCameraLED_2.IN := FALSE;			//2 TIMER
			END_IF;
		END_IF;
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
	
	CTU_HowManyBlink(CU := OneMoreBlink, PV := 4);
	
	
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
	CASE ImageProcess OF	// state machine to process the picture to different destinations
		0:	// state to wait for commands and set next steps in process
			IF ExecuteGetImg THEN
				ExecuteGetImg := FALSE;
				ImageProcess := 1;
			END_IF
			
			IF StartEncode THEN
				StartEncode := FALSE;
				ImageProcess := 2;
			END_IF

								
		1:	// get the image which is saved on the camera
			ViBaseGetImage_0.Execute := TRUE;
			
			ViBaseGetImage_0();	// call FUB
			
			Base64srcLen := ViBaseGetImage_0.BufferLen;	// save length of buffer on a local variable
			
			IF ViBaseGetImage_0.Done THEN
				ViBaseGetImage_0.Execute := FALSE;
				ImageProcess := 0;
			END_IF
			
		2:	// transfer buffer to Base64 and merge the string to a valid SVG input
			httpEncodeBase64_0.pDest := ADR(Base64Buffer);
			httpEncodeBase64_0.destSize := SIZEOF(Base64Buffer) - strlen(ADR(Base64Buffer)) - strlen(ADR('$' />'));
			httpEncodeBase64_0.pSrc := ADR(Base64Buffer);
			httpEncodeBase64_0.srcLen := Base64srcLen;
			httpEncodeBase64_0.enable := TRUE;
			
			httpEncodeBase64_0();	// call FUB
			
			strcat(ADR(Base64Buffer), ADR('$' />')) ; // Abschluss des Image Elements
			strcat(ADR(URL), ADR(Base64Buffer));
			
			ImageProcess := 0;
				
	END_CASE;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

