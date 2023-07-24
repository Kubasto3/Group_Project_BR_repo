
TYPE
	AxisParam : 	STRUCT 
		ManualDistance : LREAL := 500; (*Setting distance of the belt move [mm]*)
		ManualVelocity : REAL := 50; (*Value of velocity [mm/s]*)
	END_STRUCT;
	ManualStepsEnum : 
		(
		MANUAL_START := 10,
		MANUAL_WAIT := 20,
		MANUAL_BELT_SET_ADDITIVE := 70,
		MANUAL_BELT_MOVE_ADDITIVE := 80,
		MANUAL_BELT_SET_VELOCITY := 90,
		MANUAL_BELT_MOVE_VELOCITY := 100,
		MANUAL_BELT_MOVE_ADDITIVE1 := 110
		);
	ManualStepsActEnum : 
		(
		MANUAL_ACTUATOR_WAIT := 200,
		MANUAL_ACTUATOR_DOSING := 210,
		MANUAL_ACTUATOR_NONE := 220,
		MANUAL_ACTUATOR_BOTH := 230,
		MANUAL_ACTUATOR_SORTING := 240
		);
END_TYPE
