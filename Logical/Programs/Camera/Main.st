
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
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

