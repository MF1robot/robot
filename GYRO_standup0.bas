
DIM tilt_CNT AS BYTE
DIM grip_pose AS BYTE
DIM Action_mode AS BYTE

DIM motorONOFF AS BYTE'把I定义成字节型
DIM I AS BYTE'把I定义成字节型
DIM J AS BYTE'把J定义成字节型
DIM pose AS BYTE

DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE


'**** tilt_port *****

CONST FB_tilt_AD_port = 2'前后倾斜地址 点
CONST LR_tilt_AD_port = 3'左右倾斜地址 点

'**** 2012 NEW tilt Sensors *****‘2012新的倾斜传感器
CONST tilt_time_check = 5  '倾斜时间检查
CONST min = 61			'最小值
CONST max = 107			'最大值
CONST COUNT_MAX = 20'计算
'*******************


PTP SETON 				
PTP ALLON				

DIR G6A,1,0,0,1,0,0		'motor0~5
DIR G6B,1,1,1,1,1,1		'motor6~11
DIR G6C,0,0,0,0,0,0		'motor12~17
DIR G6D,0,1,1,0,1,0		'motor18~23

'**** Feedback *****************************
'**** Feedback *****************************

GOSUB MOTOR_ON

SPEED 5
GOSUB power_first_pose
GOSUB stand_pose


GOTO MAIN




MOTOR_ON:

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    motorONOFF = 0
    'GOSUB start_music			
    RETURN
power_first_pose:
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,100,  45,  90, 100, 100, 100
    MOVE G6C,100,  45,  90, 100, 100, 100
    WAIT
    pose = 0
    RETURN

    '************************************************
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,0
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN


    '******************************************	
MAIN: '


    ' 'GOSUB LOW_Voltage
    GOSUB FB_tilt_check
    GOSUB LR_tilt_check


    ERX 4800,A,MAIN				'通过RX端口接收RS232信号;4800:端口速度；A:端口号
    A_old = A
    '根据变量的值条件转移,A=0跳转到MAIN，A=1跳转到'...
    ON A GOTO MAIN,KEY1,KEY2,KEY3',KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25',KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32
    '
    '    GOTO MAIN					跳转到MAIN	
    '*******************************************
    '*******************************************
    '*******************************************
KEY1:
    GOSUB hand_front_side
    GOSUB hands_front_heart
    GOSUB leap_left_right
    GOSUB walk_left_right
	GOSUB clap_hands
	GOSUB leap_left_right
    GOSUB walk_left_right
	GOSUB hands_turnaround
	GOSUB stretch_handsandlegs
	GOSUB xishuashua
	GOSUB stretch_arms
	GOSUB wrap_head
	GOSUB xishuashua_and_walk
	FOR i = 1 TO 2
		GOSUB leap_left_delux
		GOSUB hands_turnaround
		WAIT
	NEXT i
	GOSUB hand_front_side_delux
    GOTO RX_EXIT
    '*******************************************
KEY2:
    GOSUB hand_front_side_delux
	
    WAIT


    GOTO RX_EXIT
    '*******************************************
KEY3:
	GOSUB leap_left_delux


    GOTO RX_EXIT


    '************************************************

RX_EXIT:

    ERX 4800, A, MAIN

    GOTO RX_EXIT
FB_tilt_check:
    '  IF tilt_check_failure = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        A = AD(FB_tilt_AD_port)	'将AD端口的模拟信号赋给A
        IF A > 250 OR A < 5 THEN RETURN '返回11041行
        IF A > MIN AND A < MAX THEN RETURN '返回11041行
        DELAY tilt_time_check
    NEXT i

    IF A < MIN THEN GOSUB tilt_front '执行4654行
    IF A > MAX THEN GOSUB tilt_back '执行4660行

    GOSUB GOSUB_RX_EXIT '执行291行

    RETURN '返回11041行

LR_tilt_check:
    '  IF tilt_check_failure = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        B = AD(LR_tilt_AD_port)	'
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY tilt_time_check
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB standard_pose	
        RETURN

    ENDIF
    RETURN '返回11042行

GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2'蓝牙发射频率2

    GOTO GOSUB_RX_EXIT
GOSUB_RX_EXIT2:
    RETURN '返回原程序（1.4651行)
tilt_front:
    A = AD(FB_tilt_AD_port)  '将AD端口的模拟信号赋给A
    'IF A < MIN THEN GOSUB front_standup
    IF A < MIN THEN  GOSUB back_standup '执行605行
    RETURN '返回4648行
    '**************************************************
tilt_back:
    A = AD(FB_tilt_AD_port)
    'IF A > MAX THEN GOSUB back_standup
    IF A > MAX THEN GOSUB front_standup '执行661行
    RETURN '返回4650行
    '**************************************************
back_standup: '后倒自动站立

    GOSUB Arm_motor_mode1
    GOSUB Leg_motor_mode1


    SPEED 15
    MOVE G6A,100, 150, 170,  40, 100
    MOVE G6D,100, 150, 170,  40, 100
    MOVE G6B, 150, 150,  45
    MOVE G6C, 150, 150,  45
    WAIT

    SPEED 15
    MOVE G6A,  100, 155,  110, 120, 100
    MOVE G6D,  100, 155,  110, 120, 100
    MOVE G6B, 190, 80,  15
    MOVE G6C, 190, 80,  15
    WAIT

    GOSUB Leg_motor_mode2
    SPEED 15	
    MOVE G6A,  100, 165,  27, 162, 100
    MOVE G6D,  100, 165,  27, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT


    SPEED 10	
    MOVE G6A,  100, 150,  27, 162, 100
    MOVE G6D,  100, 150,  27, 162, 100
    MOVE G6B,  140, 15, 90
    MOVE G6C,  140, 15, 90
    WAIT


    SPEED 6
    MOVE G6A,  100, 138,  27, 155, 100
    MOVE G6D,  100, 138,  27, 155, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    DELAY 100
    SPEED 10
    GOSUB stand_pose
    GOSUB Leg_motor_mode1

    RETURN
front_standup: '后倒自动站立
    GOSUB Arm_motor_mode1
    GOSUB Leg_motor_mode1


    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 10
    GOSUB stand_pose

    RETURN

    '******************************************

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


start_music:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
stand_pose:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93,100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    pose = 0
    grip_pose = 0
    RETURN
standard_pose:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    RETURN
    
hand_front_side:
	'move hand from front to side
	'left hand
	SPEED 10 
	MOVE G6A, 100, 144,  67,  97, 100,  
	MOVE G6D, 100, 144,  67,  97, 100,  
	MOVE G6B, 190,  10,  50,  ,  ,  
	MOVE G6C, 100,  64,  10,  ,  ,  
	SPEED 13 'wave hand
	DELAY 200
	MOVE G6A, 100, 144,  67,  97, 100, 
	MOVE G6D, 100, 144,  67,  97, 100,  
	MOVE G6B, 190,  10,  68,  ,  ,  
	MOVE G6C, 100,  64,  10,  ,  ,  
	WAIT
	MOVE G6A, 100, 144,  67,  97, 100,
	MOVE G6D, 100, 144,  67,  97, 100,  
	MOVE G6B, 190,  10,  50,  ,  ,  
	MOVE G6C, 100,  64,  10,  ,  , 
	WAIT
	SPEED 8
	MOVE G6A, 100, 144,  67,  97, 100,20
	MOVE G6D, 100, 144,  67,  97, 100, 20 
	MOVE G6B, 187,  96,  97,  ,  ,  20
	MOVE G6C, 100,  64,  10,  ,  , 20
	WAIT
	SPEED 10
	GOSUB stand_pose
	WAIT
	'right hand
	SPEED 13 
	MOVE G6A, 100, 144,  67,  97, 100,
	MOVE G6D, 100, 144,  67,  97, 100, 
	MOVE G6C, 190,  10,  50,  ,  , 
	MOVE G6B, 100,  64,  10,  ,  ,  
	SPEED 10 'wave hand
	DELAY 200
	MOVE G6A, 100, 144,  67,  97, 100, 
	MOVE G6D, 100, 144,  67,  97, 100,  
	MOVE G6C, 190,  10,  68,  ,  , 
	MOVE G6B, 100,  64,  10,  ,  ,  
	WAIT
	MOVE G6A, 100, 144,  67,  97, 100,
	MOVE G6D, 100, 144,  67,  97, 100, 
	MOVE G6C, 190,  10,  50,  ,  ,  
	MOVE G6B, 100,  64,  10,  ,  ,  
	WAIT
	SPEED 8
	MOVE G6A, 100, 144,  67,  97, 100,180
	MOVE G6D, 100, 144,  67,  97, 100, 180
	MOVE G6B, 100,  64,  10,  ,  ,  180
	MOVE G6C, 190, 100,  95,  ,  ,  180
	SPEED 10
	WAIT
	GOSUB stand_pose
	WAIT
	RETURN
	
hands_front_heart:
	'5-10s movement
	SPEED 10
	'left hand
	MOVE G6A, 100,  83, 125, 113, 100,  
	MOVE G6D, 100,  83, 125, 113, 100,  
	MOVE G6B,  11, 166, 167,  ,  ,  
	MOVE G6C, 100,  30,  80,  ,  ,  
	DELAY 200
	'right hand
	MOVE G6A, 100,  83, 125, 113, 100,  
	MOVE G6D, 100,  83, 125, 113, 100,  
	MOVE G6B,  11, 166, 167,  ,  ,  
	MOVE G6C,  19, 188, 147,  ,  ,  
	DELAY 200
	SPEED 12 'wave to side
	MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
	MOVE G6B,  30, 187, 112,  ,  ,  
	MOVE G6C,  32, 188, 111,  ,  ,  
	DELAY 100
	MOVE G6A, 100,  83, 125, 113, 100,  
	MOVE G6D, 100,  83, 125, 113, 100,  
	MOVE G6B,  11, 157, 112,  ,  ,  
	MOVE G6C,  13, 155, 111,  ,  ,  
	DELAY 100
	MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
	MOVE G6B,  65, 105, 107,  ,  ,  
	MOVE G6C,  65, 104, 107,  ,  ,  
	DELAY 200
	GOSUB stand_pose
	DELAY 200
	RETURN

leap_left_right:
	'leap left to right
	SPEED 5
	'left move
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 115,  79, 143,  93, 128,  
	MOVE G6B, 100,  30,  80,  ,  ,  
	MOVE G6C, 101,  46, 100,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 300
	'front back leap
	SPEED 10
	MOVE G6A, 105,  83, 135, 91, 100,  
	MOVE G6D, 105,  103, 155,  60, 100,  
	MOVE G6B,  65,  15,  70,  ,  ,  
	MOVE G6C, 135,  15,  70,  ,  ,  
	WAIT
	GOSUB stand_pose
	
	MOVE G6A,  105,  103, 155,  60, 100,  
	MOVE G6D,  105,  83, 135, 91, 100,  
	MOVE G6B, 135,  15,  70,  ,  ,  
	MOVE G6C, 65,  15,  70,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 200
	'right move
	SPEED 5
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  82, 141,  93,  97,  
	MOVE G6B, 101,  46, 100,  ,  ,  
	MOVE G6C, 102,  16, 100,  ,  ,  
	WAIT	
	GOSUB stand_pose
	DELAY 300
	'back front leap
	SPEED 10
	MOVE G6A,  105,  103, 155,  60, 100,  
	MOVE G6D,  105,  83, 135, 91, 100,  
	MOVE G6B, 135,  15,  70,  ,  ,  
	MOVE G6C, 65,  15,  70,  ,  ,  
	WAIT
	GOSUB stand_pose

	MOVE G6A, 105,  83, 135, 91, 100,  
	MOVE G6D, 105,  103, 150,  55, 100,  
	MOVE G6B,  65,  15,  70,  ,  ,  
	MOVE G6C, 135,  15,  70,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 300
	RETURN

walk_left_right:
	SPEED 5
	'left walk
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 115,  79, 143,  93, 128,  
	MOVE G6B, 100,  30,  80,  ,  ,  
	MOVE G6C, 101,  46, 100,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 100
	'right walk
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  76, 145,  93,  100,  
	MOVE G6B, 101,  46, 100,  ,  ,  
	MOVE G6C, 102,  30, 80,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 100
	RETURN

clap_hands:
	SPEED 5
	'list right
	MOVE G6A,  85,  76, 145,  93, 120,  
	MOVE G6D,  95,  76, 145,  93, 100,  
	MOVE G6B, 100,  45,  80,  ,  ,  
	MOVE G6C, 100,  20,  80,  ,  ,  
	WAIT
	'list left
	MOVE G6D,  85,  76, 145,  93, 120,  
	MOVE G6A,  95,  76, 145,  93, 100,  
	MOVE G6B, 100,  45,  80,  ,  ,  
	MOVE G6C, 100,  20,  80,  ,  ,  
	WAIT
	SPEED 15
	'clap hands at right
	DELAY 200
	MOVE G6A,  82, 113, 133,  65, 120,  
	MOVE G6D,  92,  55, 127, 133, 107,  
	MOVE G6B,  58, 184, 137,  ,  ,  
	MOVE G6C,  58, 188, 144,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 200
	RETURN

hands_turnaround:
	SPEED 50
	MOVE G6A,  98, 115,  98,  94,  98,  
	MOVE G6D, 101, 118,  92,  98, 102,  
	MOVE G6B, 186,  20,  41,  ,  ,  
	MOVE G6C,  10,  10,  63,  ,  ,  
	
	MOVE G6A,  97,  74, 144,  93, 101,  
	MOVE G6D, 101,  79, 138,  94, 103,  
	MOVE G6B, 188, 101,  82,  ,  ,  
	MOVE G6C,  13, 105,  81,  ,  ,  
	
	MOVE G6A, 100,  73, 139, 101, 101,  
	MOVE G6D, 100,  73, 139, 100, 102,  
	MOVE G6B, 188, 184, 139,  ,  ,  
	MOVE G6C,  13, 188, 148,  ,  ,  
	WAIT
	GOSUB stand_pose
	RETURN

stretch_handsandlegs:
	SPEED 20
	MOVE G6A, 100,  44, 129, 123,  99,  
	MOVE G6D, 112, 115,  99,  95, 108,  
	MOVE G6B, 187,  30,  80,  ,  ,  
	MOVE G6C, 101,  32,  81,  ,  ,  
	WAIT
	GOSUB stand_pose
	MOVE G6A, 108,  80, 139,  93,  93,  
	MOVE G6D,  88,  38, 146, 124, 114,  
	MOVE G6B, 100,  30,  81,  ,  ,  
	MOVE G6C, 190,  32,  81,  ,  ,  
	WAIT
	GOSUB stand_pose
	MOVE G6A,  78,  66, 161,  87, 102,  
	MOVE G6D,  78,  66, 161,  87, 102,  
	MOVE G6B, 189,  35,  83,  ,  ,  
	MOVE G6C, 189,  35,  83,  ,  ,  
	WAIT
	GOSUB stand_pose
	RETURN

xishuashua:
	SPEED 5	
		MOVE G6A, 100, 106, 105,  94,  99,  
		MOVE G6D, 101, 108, 105,  94,  99,  
		MOVE G6B, 164,  14,  52,  ,  ,  
		MOVE G6C, 163,  14,  52,  ,  ,  
		WAIT
	FOR i = 1 TO 5
		SPEED 20	
		MOVE G6A, 100, 106, 105,  94,  99,  
		MOVE G6D, 101, 108, 105,  94,  99,  
		MOVE G6B, 164,  14,  52,  ,  ,  
		MOVE G6C, 163,  14,  52,  ,  ,  
		WAIT
		MOVE G6A, 102, 106, 104,  95,  99,  
		MOVE G6D, 102, 108, 104,  95,  99,  
		MOVE G6B, 164,  16,  43,  ,  ,  
		MOVE G6C, 163,  16,  43,  ,  ,  
		WAIT
	NEXT i
	GOSUB balance_pose
	RETURN

balance_pose:
	SPEED 20
		MOVE G6A, 101,  75, 144,  94,  99,100  
		MOVE G6D, 101,  75, 143,  95, 100,  100
		MOVE G6B, 102,  90, 107, 100 , 100 ,  100
		MOVE G6C, 101, 101, 104, 100 , 100 ,  100
		WAIT
	RETURN

stretch_arms:
	SPEED 20
	'right arm
	MOVE G6A, 101,  75, 141,  94,  99,  
	MOVE G6D, 101,  75, 143,  93,  99,  
	MOVE G6B, 101,  30,  81,  ,  ,  
	MOVE G6C, 100, 190, 102,  ,  ,  
	SPEED 8
	MOVE G6D,  85,  76, 145,  93, 120,  180
	MOVE G6A,  95,  76, 145,  93, 100,  180
	MOVE G6B, 101,  30,  81,  ,  ,  180
	MOVE G6C, 100,  90, 102,  ,  ,  180
	WAIT
	SPEED 20
	GOSUB balance_pose
	'left arm
	MOVE G6A, 100,  75, 141,  94,  99,  
	MOVE G6D, 100,  75, 143,  93,  99,  
	MOVE G6B, 100, 190, 100,  ,  ,  
	MOVE G6C, 100,  10, 100,  ,  ,  
	SPEED 8
	MOVE G6A,  85,  76, 145,  93, 120,  20
	MOVE G6D,  95,  76, 145,  93, 100,  20
	MOVE G6B, 100, 100, 100,  ,  ,  20
	MOVE G6C, 100,  10, 100,  ,  ,  20
	WAIT
	SPEED 20
	GOSUB stand_pose
	RETURN

windmill:
	SPEED 20
	FOR i =1 TO 2
	MOVE G6A, 100, 100, 100, 116, 100,  
	MOVE G6D, 100, 100, 100, 116, 100,  
	MOVE G6B,  97, 167, 189,  ,  ,  
	MOVE G6C,  96,  67,  13,  ,  , 
	WAIT
	MOVE G6B, 96,  67,  13,  ,  ,
	MOVE G6C, 97, 167, 189,  ,  ,  
	WAIT
	NEXT i
	GOSUB stand_pose
	RETURN
	 

wrap_head:
	SPEED 10
	MOVE G6A, 100,  44, 129, 123,  99,  
	MOVE G6D, 112, 115,  99,  95, 108,  
	MOVE G6B, 187,  30,  80,  ,  ,  
	MOVE G6C, 101,  32,  81,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 100
	SPEED 10	
	MOVE G6A,  99, 101,  96, 117,  ,  
	MOVE G6D,  99, 101,  96, 117,  99,  
	MOVE G6B, 141, 166, 179,  ,  ,  
	MOVE G6C, 141, 166, 179,  ,  ,  
	WAIT
	SPEED 10
	MOVE G6A, 100, 144,  67,  97, 100,
	MOVE G6D, 100, 144,  67,  97, 100, 
	MOVE G6B,  25, 166, 179,  ,  ,  
	MOVE G6C,  25, 166, 179,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 200
	RETURN

xishuashua_and_walk:
	SPEED 10
	MOVE G6A, 100, 76, 145,  93,  100,  
	MOVE G6D, 110, 78, 144,  93,  120,  
	
	FOR i = 1 TO 2
	MOVE G6B, 164,  14,  52,  ,  ,  
	MOVE G6C, 163,  14,  52,  ,  ,  
	MOVE G6B, 164,  16,  43,  ,  ,  
	MOVE G6C, 163,  16,  43,  ,  ,  
	NEXT i
	
	MOVE G6A, 102, 76, 145,  93,  100,  
	MOVE G6D, 115, 79, 143,  93,  128,  
	WAIT
	GOSUB stand_pose
	
	
	MOVE G6A, 107, 77, 144,  93,  114,  
	MOVE G6D, 100, 82, 141,  93,  97,
	
	FOR i = 1 TO 2
	MOVE G6B, 164,  14,  52,  ,  ,  
	MOVE G6C, 163,  14,  52,  ,  ,  
	MOVE G6B, 164,  16,  43,  ,  ,  
	MOVE G6C, 163,  16,  43,  ,  ,  
	NEXT i
	
	
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  82, 141,  93,  97,  
	WAIT
	GOSUB stand_pose
	
	MOVE G6A, 100, 76, 145,  93,  100,  
	MOVE G6D, 110, 78, 144,  93,  120,  
	
	FOR i = 1 TO 2
	MOVE G6B, 164,  14,  52,  ,  ,  
	MOVE G6C, 163,  14,  52,  ,  ,  
	MOVE G6B, 164,  16,  43,  ,  ,  
	MOVE G6C, 163,  16,  43,  ,  ,  
	NEXT i
	
	MOVE G6A, 102, 76, 145,  93,  100,  
	MOVE G6D, 115, 79, 143,  93,  128,  
	WAIT
	GOSUB stand_pose
	
	DELAY 200
	RETURN
wave_hand_pose1:
	MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93,100, 100
    MOVE G6B, 100,  78, 167,  ,  ,  	
	MOVE G6C, 100,  78, 167,  ,  ,  
    
    WAIT
    RETURN

wave_hand_pose2:
	MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93,100, 100
    MOVE G6B, 100,  58, 147,  ,  ,  
	MOVE G6C, 100,  58, 147,  ,  ,  
    WAIT
    RETURN
leap_left_delux:
'leap left to right
	SPEED 5
	GOSUB wave_hand_pose2
	'left move
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 115,  79, 143,  93, 128,   
	GOSUB wave_hand_pose1 
	WAIT
	 
	'front back leap
	SPEED 10
	MOVE G6A,  98,  42, 146, 134, 107,  
	MOVE G6D, 100, 105, 144,  72,  96,  
	GOSUB wave_hand_pose2
	WAIT
	 
	
	MOVE G6A,  99, 103, 135,  66, 106,  
	MOVE G6D, 100,  56, 143, 109,  96,   
	GOSUB wave_hand_pose1 
	WAIT
	DELAY 200
	'right move
	SPEED 5
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  76, 145,  93, 100,  
	GOSUB wave_hand_pose2 
	WAIT
	DELAY 200
	'back front leap
	SPEED 10
	MOVE G6A,  99, 103, 135,  66, 106,  
	MOVE G6D, 100,  56, 143, 109,  96,     
	GOSUB wave_hand_pose1 
	WAIT

	MOVE G6A,  98,  42, 146, 134, 107,  
	MOVE G6D, 100, 105, 144,  72,  96,     
	GOSUB wave_hand_pose2 
	WAIT
	GOSUB stand_pose
	DELAY 300
	RETURN

hand_front_side_delux:
	'move hand from front to side with walking
	'left hand, right walk
	SPEED 13
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  76, 145,  93,  100,  
	MOVE G6B, 190,  10,  50,  ,  ,  
	MOVE G6C, 100,  64,  10,  ,  ,  
	SPEED 10 'wave hand, crouch
	DELAY 200
	MOVE G6A,100,  76, 145,  93, 100, 
    MOVE G6D,100,  76, 145,  93,100, 
	MOVE G6B, 190,  10,  68,  ,  ,  
	MOVE G6C, 100,  64,  10,  ,  ,  
	WAIT
	MOVE G6A, 100, 144,  67,  97, 100,
	MOVE G6D, 100, 144,  67,  97, 100,  
	MOVE G6B, 190,  10,  50,  ,  ,  
	MOVE G6C, 100,  64,  10,  ,  , 
	WAIT
	SPEED 15
	MOVE G6A, 100, 144,  67,  97, 100,20
	MOVE G6D, 100, 144,  67,  97, 100, 20 
	MOVE G6B, 187,  96,  97,  ,  ,  20
	MOVE G6C, 100,  64,  10,  ,  , 20
	WAIT
	SPEED 15
	GOSUB stand_pose
	WAIT
	'right hand, left walk
	SPEED 13
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 115,  79, 143,  93, 128,  
	MOVE G6C, 190,  10,  50,  ,  , 
	MOVE G6B, 100,  64,  10,  ,  ,  
	SPEED 10 'wave hand, crouch
	DELAY 200
	MOVE G6A,100,  76, 145,  93, 100, 
    MOVE G6D,100,  76, 145,  93,100, 
	MOVE G6C, 190,  10,  68,  ,  , 
	MOVE G6B, 100,  64,  10,  ,  ,  
	WAIT
	MOVE G6A, 100, 144,  67,  97, 100,
	MOVE G6D, 100, 144,  67,  97, 100, 
	MOVE G6C, 190,  10,  50,  ,  ,  
	MOVE G6B, 100,  64,  10,  ,  ,  
	WAIT
	SPEED 15
	MOVE G6A, 100, 144,  67,  97, 100,180
	MOVE G6D, 100, 144,  67,  97, 100, 180
	MOVE G6B, 100,  64,  10,  ,  ,  180
	MOVE G6C, 190, 100,  95,  ,  ,  180
	SPEED 15
	WAIT
	GOSUB stand_pose
	WAIT
	RETURN