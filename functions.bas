Arm_motor_mode1:
    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1
    RETURN
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

StandState:'’æ¡¢◊¥Ã¨
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 100,  76, 145,  93, 100,  
	MOVE G6B, 100,  30,  80,  ,  ,  
	MOVE G6C, 100,  30,  80,  ,  ,  
	WAIT
	RETURN

StretchLeg:'∆´Õ»
	
	SPEED 5
	GOSUB StandState
	
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 115,  79, 143,  93, 128,  
	MOVE G6B, 100,  30,  80,  ,  ,  
	MOVE G6C, 101,  46, 100,  ,  ,  
	WAIT
	
	GOSUB StandState
	
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  82, 141,  93,  97,  
	MOVE G6B, 101,  46, 100,  ,  ,  
	MOVE G6C, 102,  16, 100,  ,  ,  
	WAIT
	
	GOSUB StandState
	
	
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 115,  79, 143,  93, 128,  
	MOVE G6B, 100,  30,  80,  ,  ,  
	MOVE G6C, 101,  46, 100,  ,  ,  
	WAIT
	
	GOSUB StandState
	
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  82, 141,  93,  97,  
	MOVE G6B, 101,  46, 100,  ,  ,  
	MOVE G6C, 102,  16, 100,  ,  ,  
	WAIT
	
	GOSUB StandState
	DELAY 400

StretchHands:'∂Ø ÷
	
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 100,  76, 145,  93, 100,  
	MOVE G6B, 100,  30,  80,  ,  ,  
	MOVE G6C, 101,  63, 136,  ,  ,  
	WAIT
	
	
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 100,  76, 145,  93, 100,  
	MOVE G6B, 100,  30,  80,  ,  ,  
	MOVE G6C, 101,  63, 136,  ,  ,  
	
	WAIT
	
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 100,  76, 145,  93, 100,  
	MOVE G6B, 101,  63, 136,  ,  ,  
	MOVE G6C, 101,  63, 136,  ,  ,  
	WAIT
	
	DELAY 700
	
	MOVE G6A, 100,  75,  ,  94,  99,  
	MOVE G6D, 100,  76, 145,  93, 100,  
	MOVE G6B, 102,  17,  86,  ,  ,  
	MOVE G6C, 101,  63, 136,  ,  ,  
	WAIT
	
	
	GOSUB StandState
	
	DELAY 300
	
ToeStand:'ı⁄Ω≈
	MOVE G6A,  50,  76, 145,  93, 100,  
	MOVE G6D,  50,  76, 145,  93, 100,  
	MOVE G6B, 100,  30,  80,  ,  ,  
	MOVE G6C, 100,  30,  80,  ,  ,  
	WAIT
	GOSUB StandState

Twist:°Ø≈§
	FOR i = 1 TO 3
		MOVE G6A,  82, 113, 133,  65, 120,  
		MOVE G6D,  92,  55, 127, 133, 107,  
		IF i = 1 THEN
			MOVE G6B,  66,  17,  53,  ,  ,  
			MOVE G6C,  70,  15,  56,  ,  ,  
		ELSE
			MOVE G6B, 100, 101, 100,  ,  ,  
			MOVE G6C, 100, 189,  98,  ,  ,  			
		ENDIF
		WAIT
		MOVE G6D,  82, 113, 133,  65, 120,  
		MOVE G6A,  92,  55, 127, 133, 107,  
		IF i = 1 THEN
			MOVE G6B,  66,  17,  53,  ,  ,  
			MOVE G6C,  70,  15,  56,  ,  ,  
		ELSE
			MOVE G6B, 100, 101, 100,  ,  ,  
			MOVE G6C, 100, 189,  98,  ,  ,  			
		ENDIF
		WAIT
	NEXT i
	
	SPEED 5
	MOVE G6A,  87, 124,  79, 108, 115,  
	MOVE G6D,  85, 114,  82, 119, 113,  
	MOVE G6B,  15, 177, 189,  ,  ,  
	MOVE G6C, 158,  10,  26,  ,  ,  
	WAIT
	MOVE G6A,  86, 155,  42, 108,  ,  
	MOVE G6D,  85, 136,  43, 129, 119,  
	MOVE G6B, 158,  10,  26,  ,  ,  
	MOVE G6C,  15, 177, 189,  ,  ,  
	WAIT
	MOVE G6A,  55, 164,  26, 109, 141,  
	MOVE G6D,  55, 164,  26, 109, 141,  
	MOVE G6B, 186,  89,  40,  ,  ,  
	MOVE G6C, 186,  89,  40,  ,  ,  
	WAIT

WaveArms:
	SPEED 10
	'≤®¿À ÷
	'∞⁄◊Û ÷
	FOR i = 1 TO 2
		'1
		MOVE G6A,  59,  67, 152,  90, 142, 10
		MOVE G6D,  94, 130,  71, 110,  99, 10
		MOVE G6B,  99, 145,  62,  ,  , 10
		MOVE G6C, 101, 101, 101,  ,  , 10
		WAIT
		'2
		MOVE G6A,  59,  67, 152,  90, 142, 10 
		MOVE G6D,  94, 130,  71, 110,  99, 10
		MOVE G6B,  99, 180, 190,  ,  ,  10
		MOVE G6C, 101, 101, 101,  ,  ,  10
		WAIT
		'3
		MOVE G6A,  59,  67, 152,  90, 142, 10  
		MOVE G6D,  94, 130,  71, 110,  99, 10
		MOVE G6B,  99,  90, 173,  ,  , 10
		MOVE G6C, 101, 101, 101,  ,  , 10
		WAIT
		'4
		MOVE G6A,  59,  67, 152,  90, 142, 10 
		MOVE G6D,  94, 130,  71, 110,  99, 10
		MOVE G6B,  99,  71,  62,  ,  ,  
		MOVE G6C, 101, 101, 101,  ,  ,  
		WAIT
	NEXT i
	'∞⁄”“ ÷
	FOR i = 1 TO 2
		'1
		MOVE G6D,  59,  67, 152,  90, 142,  190
		MOVE G6A,  94, 130,  71, 110,  99,  190
		MOVE G6C,  99, 145,  62,  ,  ,  190
		MOVE G6B, 101, 101, 101,  ,  ,  190
		WAIT
		'2
		MOVE G6D,  59,  67, 152,  90, 142, 190 
		MOVE G6A,  94, 130,  71, 110,  99, 190
		MOVE G6C,  99, 180, 190,  ,  ,  190
		MOVE G6B, 101, 101, 101,  ,  ,  190
		WAIT
		'3
		MOVE G6D,  59,  67, 152,  90, 142, 190 
		MOVE G6A,  94, 130,  71, 110,  99, 190
		MOVE G6C,  99,  90, 173,  ,  , 190
		MOVE G6B, 101, 101, 101,  ,  , 190
		WAIT
		'4
		MOVE G6D,  59,  67, 152,  90, 142, 190 
		MOVE G6A,  94, 130,  71, 110,  99, 190
		MOVE G6C,  99,  71,  62,  ,  , 190
		MOVE G6B, 101, 101, 101,  ,  , 190
		WAIT
	NEXT i
	DELAY 1200
