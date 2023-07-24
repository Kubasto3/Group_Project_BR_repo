
TYPE
	StateCamLED : 
		(
		WARNING_ACTUATOR_PUSHING,
		PICTURE_UNRECOGNISED,
		NONE
		);
	ModelEnum : 
		(
		BR := 1, (*%ID of B&R logo model*)
		AS := 2, (*%ID of AS logo model*)
		Unrecognised := 0 (*%case of nothing recognised*)
		);
	CofeeType : 	STRUCT 
		Sugar : USINT;
		Water : REAL;
		Powder : USINT;
		Temperature : REAL;
		Milk : REAL;
	END_STRUCT;
	SortingType : 	STRUCT 
		gRecognisedModel : USINT;
	END_STRUCT;
END_TYPE
