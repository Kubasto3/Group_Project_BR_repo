
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
	
	IF gMode <> 1 THEN
		IF gAlarmHardware AND NOT gAlarmHardAck THEN
			gStopBlink := FALSE;
			TimerTonCameraLED.PT := TIMER_TIME_BLINK_100MS;
			TimerTonCameraLED_2.PT := TIMER_TIME_BLINK_100MS;
			CameraLED 	:= LED_RED;
			CameraLED_2 := LED_NOTHING;
		ELSIF gAlarmExist THEN
			gStopBlink := FALSE;
			TimerTonCameraLED.PT := TIMER_TIME_BLINK_500MS;
			TimerTonCameraLED_2.PT := TIMER_TIME_BLINK_500MS;
			CameraLED 	:= LED_RED;
			CameraLED_2 := LED_NOTHING;	
		ELSIF gPicNotRecognised THEN
			gStopBlink := FALSE;
			TimerTonCameraLED.PT := TIMER_TIME_BLINK_500MS;
			TimerTonCameraLED_2.PT := TIMER_TIME_BLINK_500MS;
			CameraLED 	:= LED_BLUE;
			CameraLED_2 := LED_NOTHING;
		ELSIF gWeightDetected AND NOT gStopState AND NOT gErrorState THEN
			TimerTonCameraLED.PT := TIMER_TIME_BLINK_500MS;
			TimerTonCameraLED_2.PT := TIMER_TIME_BLINK_500MS;
			gStopBlink := FALSE;
			CameraLED 	:= LED_RED;
			CameraLED_2 := LED_BLUE;
		ELSE
			gStopBlink := TRUE;
		END_IF;
	ELSE
		gStopBlink := TRUE;
	END_IF;
	
	
	gMode;
	
	
	
	
	
	//	IF (gMode = 1) AND ManualLampTest THEN
	//		CameraLED := LED_RED;
	//		CameraLED_2 := LED_BLUE;
	//		CameraLED_3 := LED_GREEN;
	//		ManualLampTest := 0;
	//		TimerTonCameraLED.IN := TRUE;
	//		CameraLED_OPC := CameraLED;
	//		IF TimerTonCameraLED.Q THEN
	//			TimerTonCameraLED_2.IN := TRUE;
	//			CameraLED_OPC := CameraLED_2; 
	//			IF TimerTonCameraLED_2.Q THEN				
	//				TimerTonCameraLED_3.IN := TRUE;
	//				CameraLED_OPC := CameraLED_3; 
	//				IF TimerTonCameraLED_3.Q THEN
	//					CameraLED_OPC := LED_NOTHING;
	//					TimerTonCameraLED.IN := FALSE; 			
	//					TimerTonCameraLED_2.IN := FALSE;
	//					TimerTonCameraLED_3.IN := FALSE; 		
	//				END_IF;
	//			END_IF;
	//		END_IF;
	//	END_IF;
	
	//------------------------------------------
	
	ATON1();
	ATON2();
	ATON3();
	
	

	CASE sStep OF
		1:	
			ATON1.PT := TIME_LAMP_TEST;
			ATON2.PT := TIME_LAMP_TEST;
			ATON3.PT := TIME_LAMP_TEST;
	
			CameraLED_OPC := 1;
			ATON1.IN := FALSE;
			IF (gMode = 1) AND ManualLampTest THEN
				ManualLampTest := 0;
				ATON1.IN := TRUE;
				ATON2.IN := FALSE;
				sStep := 2;
			END_IF;
			
		2:
			CameraLED_OPC := 2;
			IF ATON1.Q THEN
				ATON2.IN := TRUE;
				ATON3.IN := FALSE;
				sStep := 3;
			END_IF;
			
		3:
			CameraLED_OPC := 3;
			IF ATON2.Q THEN
				sStep := 4;
			END_IF;
			
		4:
			CameraLED_OPC := 4;
			ATON3.IN := TRUE;
			ATON2.IN := FALSE;
			IF ATON3.Q THEN
				sStep := 1;
			END_IF;
	END_CASE;
	
	//------------------------------------------
		
	//	
	//	IF (gMode = 1) AND ManualLampTest THEN
	//		ATON1.IN := FALSE;
	//		gMode := 0;
	//		ATON1.IN := TRUE;
	//		ATON2.IN := FALSE;
	//		IF ATON1.Q THEN
	//			ATON2.IN := TRUE;
	//			ATON3.IN := FALSE;
	//			IF ATON2.Q THEN
	//				ATON3.IN := TRUE;
	//				ATON2.IN := FALSE;
	//				IF ATON3.Q THEN
	//					
	//				END_IF;
	//			END_IF;
	//		END_IF;
	//	END_IF;
	
	//	
	//	IF gAlarmExist THEN
	//		gStopBlink := FALSE;
	//		CameraLED 	:= LED_RED;
	//		CameraLED_2 := LED_NOTHING;
	//	ELSIF gPicNotRecognised THEN
	//		gStopBlink := FALSE;
	//		CameraLED 	:= LED_BLUE;
	//		CameraLED_2 := LED_NOTHING;
	//	ELSIF gWeightDetected THEN
	//		gStopBlink := FALSE;
	//		CameraLED 	:= LED_RED;
	//		CameraLED_2 := LED_BLUE;
	//	ELSE
	//		gStopBlink := TRUE;
	//	END_IF;
	//	
	//	
	//	IF gStopBlink THEN
	//		CameraLED_OPC   := LED_PLC_STATUS;
	//	ELSE
	//		TimerTonCameraLED.IN := TRUE;
	//		CameraLED_OPC := CameraLED;
	//		IF TimerTonCameraLED.Q THEN
	//			TimerTonCameraLED_2.IN := TRUE;
	//			CameraLED_OPC := CameraLED_2; 
	//			IF TimerTonCameraLED_2.Q THEN
	//				TimerTonCameraLED.IN := FALSE; 				//1 TIMER
	//				TimerTonCameraLED_2.IN := FALSE;			//2 TIMER
	//			END_IF;
	//		END_IF;
	//	END_IF;
	//	

//
	TimerTonCameraLED();
	TimerTonCameraLED_2();
		
	//setting variable for recognised model with acknowledgement of 2 different types of B&R logos
	IF (RecognisedModel=1) OR (RecognisedModel=3) THEN
		gRecognisedModel := 1;
	ELSE
		gRecognisedModel := RecognisedModel;
	END_IF
	//	gRecognisedModel := RecognisedModel;
	//	
	//	//calling variables used in I/O matching of camera to delete warnings
	//	SET_FOCUS;
	//	NUM_SEARCH_MAX;
	//	EXPO_TIME;
	//	MIN_SCORE;
	//	MAX_OVERLAP;
	//	FLASH_COLOR;
	//	FLASH_SEGMENT;
	//	gImageAcq;
	//	MatchScore;
	//	
	//	
	//	//displaying last taken photo
	//	CASE ImageProcess OF	// state machine to process the picture to different destinations
	//		0:	// state to wait for commands and set next steps in process
	//			IF ExecuteGetImg THEN
	//				ExecuteGetImg := FALSE;
	//				ImageProcess := 1;
	//			END_IF
	//			
	//			IF StartEncode THEN
	//				StartEncode := FALSE;
	//				ImageProcess := 2;
	//			END_IF
	//
	//								
	//		1:	// get the image which is saved on the camera
	//			ViBaseGetImage_0.Execute := TRUE;
	//			
	//			ViBaseGetImage_0();	// call FUB
	//			
	//			Base64srcLen := ViBaseGetImage_0.BufferLen;	// save length of buffer on a local variable
	//			
	//			IF ViBaseGetImage_0.Done THEN
	//				ViBaseGetImage_0.Execute := FALSE;
	//				ImageProcess := 0;
	//			END_IF
	//			
	//		2:	// transfer buffer to Base64 and merge the string to a valid SVG input
	//			httpEncodeBase64_0.pDest := ADR(Base64Buffer);
	//			httpEncodeBase64_0.destSize := SIZEOF(Base64Buffer) - strlen(ADR(Base64Buffer)) - strlen(ADR('$' />'));
	//			httpEncodeBase64_0.pSrc := ADR(Base64Buffer);
	//			httpEncodeBase64_0.srcLen := Base64srcLen;
	//			httpEncodeBase64_0.enable := TRUE;
	//			
	//			httpEncodeBase64_0();	// call FUB
	//			
	//			strcat(ADR(Base64Buffer), ADR('$' />')) ; // Abschluss des Image Elements
	//			strcat(ADR(URL), ADR(Base64Buffer));
	//			
	//			ImageProcess := 0;
	//				
	//	END_CASE;
	//	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

