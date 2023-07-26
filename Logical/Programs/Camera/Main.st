
PROGRAM _INIT
(* Insert code here *)
	gMode;
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

//-------------CAMERA LED--Blinking-Auto-And-Semiauto-----------//
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



	//-----------------TEST--CAMERA-----------------------//

	ATON1();
	ATON2();
	ATON3();
	IF gMode = 1 THEN
		CASE sStep OF
			1:	
				ATON1.PT := TIME_LAMP_TEST;
				ATON2.PT := TIME_LAMP_TEST;
				ATON3.PT := TIME_LAMP_TEST;
		
				ATON1.IN := FALSE;
				IF (gMode = 1) AND ManualLampTest THEN
					CameraLED_OPC := 1;
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
	END_IF;

	TimerTonCameraLED();
	TimerTonCameraLED_2();
	


	//TASK: TAKE PICTURE
	//setting variable for recognised model with acknowledgement of 2 different types of B&R logos
	IF (RecognisedModel=1) OR (RecognisedModel=3) THEN
		gRecognisedModel := 1;
	ELSE
		gRecognisedModel := RecognisedModel;
	END_IF


END_PROGRAM

PROGRAM _EXIT
(* Insert code here *)
 
END_PROGRAM

