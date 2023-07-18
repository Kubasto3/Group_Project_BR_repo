
PROGRAM _INIT
	(* Insert code here *)
	
	ImageAcqReady;
	ImageAcqActive;
	ImageAcq;
	PhotosTaken;
	NumberMatches;
	RecognisedModel;
	EnableMatch;
	TestExecuteMatch;
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	 
	gRecognisedModel := RecognisedModel;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

