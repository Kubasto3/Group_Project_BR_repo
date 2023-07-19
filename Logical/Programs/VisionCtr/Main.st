
PROGRAM _INIT
	gMotorBeltAxisBasic;
	gMotorBeltParType;
END_PROGRAM

PROGRAM _CYCLIC
	
	gAxis_1;
	gMotorBeltParType;
	gMotorBeltAxisBasic.MpLink := ADR(gAxis_1);
	gMotorBeltAxisBasic.Enable := TRUE;
	gMotorBeltAxisBasic.Parameters := ADR(gMotorBeltParType);
	//przypisywanie parametrów ruchu
	//	gMotorBeltParType.Direction := FORWARD;
	gMotorBeltParType.Acceleration := gMotorAcc;
	gMotorBeltParType.Deceleration := gMotorDec;
	gMotorBeltParType.Velocity := gMotorVel;
	gMotorBeltParType.Distance := gMotorDist;
	gMotorBeltAxisBasic();
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

