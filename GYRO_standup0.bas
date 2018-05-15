
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
KEY1: 'https://www.bilibili.com/video/av9147838?from=search&seid=382298428506653669
    GOSUB hand_front_side  '0min5s
    GOSUB hands_front_heart ' 0min11s
    FOR j = 1 TO 3			'2nd loop begin at 1min02s
    	GOSUB leap_left_right '0min14s, 
	    GOSUB walk_left_right
		GOSUB clap_hands
		GOSUB leap_left_right
    	GOSUB walk_left_right
		GOSUB hands_turnaround
		IF j < 3 THEN
		GOSUB stretch_handsandlegs
		GOSUB xishuashua
		GOSUB stretch_arms
		GOSUB wrap_head
		GOSUB xishuashua_and_walk
		FOR i = 1 TO 2
			GOSUB leap_left_delux
			GOSUB hands_turnaround_delux
			WAIT
		NEXT i
		DELAY 100
		FOR i = 1 TO 2
			GOSUB hand_front_side_delux
			DELAY 300 
			GOSUB hands_front_heart_delux 
		NEXT i
		ENDIF
	NEXT j
	' begin at 2min38s
	' need completed -- brand new gesture
	' end at 2min54s
	GOSUB arms_45_angle
	GOSUB left_walk_raising_hands
	GOSUB drag_backto_right
	GOSUB jump_raising_arms
	GOSUB split
	FOR i = 1 TO 2
		GOSUB hand_front_side_delux_nodelay 
		GOSUB hands_front_heart_delux 
	NEXT i
	GOSUB side_roll
	' begin at 3min08s
	' strange turnaround
    GOTO RX_EXIT
    '*******************************************
KEY2:'music <云水禅心>
	'movement: https://www.bilibili.com/video/av4301336 太极十六式
	'https://www.bilibili.com/video/av21169368 太极八式
	GOSUB initiation
	GOSUB yemafenzong'野马分鬃
	GOSUB baiheliangchi'白鹤亮翅
	GOSUB louxiaobu'搂膝拗步
	GOTO RX_EXIT
	GOSUB yunshou'云手 八 2min18s
	GOSUB shouhuipipa'手挥琵琶 八 1min22s
	GOSUB jinjiduli'金鸡独立 八 2min05s
	GOSUB shoushi'收势 八 2min50s

    GOTO RX_EXIT
    '*******************************************
KEY3:
	GOSUB jinjiduli

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
	SPEED 10 'wave to side
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
	SPEED 10
	GOSUB stand_pose
	WAIT
	'front back leap
	MOVE G6A,  96,  44, 159, 113, 104,  
	MOVE G6D,  97,  88, 138,  89, 105,  
	MOVE G6B,  72,  23,  80,  ,  ,  
	MOVE G6C, 146,  22,  81,  ,  ,  
	GOSUB stand_pose
	WAIT
	MOVE G6D,  96,  44, 159, 113, 104,  
	MOVE G6A,  97,  88, 138,  89, 105,  
	MOVE G6C,  72,  23,  80,  ,  ,  
	MOVE G6B, 146,  22,  81,  ,  ,  
	GOSUB stand_pose
	DELAY 150
	'right move
	SPEED 5
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  82, 141,  93,  97,  
	MOVE G6B, 101,  46, 100,  ,  ,  
	MOVE G6C, 102,  16, 100,  ,  ,  
	WAIT	
	SPEED 10
	GOSUB stand_pose
	WAIT
	'back front leap
	MOVE G6D,  96,  44, 159, 113, 104,  
	MOVE G6A,  97,  88, 138,  89, 105,  
	MOVE G6C,  72,  23,  80,  ,  ,  
	MOVE G6B, 146,  22,  81,  ,  ,  
	WAIT
	GOSUB stand_pose
	WAIT
	MOVE G6A,  97,  68, 128, 116,  ,  
	MOVE G6D,  98,  97, 140,  79, 104,  
	MOVE G6B,  72,  23,  80,  ,  ,  
	MOVE G6C, 146,  22,  81,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 150
	RETURN

walk_left_right:
	SPEED 5
	'left walk
	GOSUB left_walk  
	MOVE G6B, 100,  30,  80,  ,  ,  
	MOVE G6C, 101,  46, 100,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 200
	'right walk
	GOSUB right_walk
	MOVE G6B, 101,  46, 100,  ,  ,  
	MOVE G6C, 100,  30, 80,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 200
	RETURN

left_walk:
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 115,  79, 143,  93, 128,  
	RETURN

right_walk:
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  76, 145,  93,  100,  
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
	MOVE G6C, 100,  45,  80,  ,  ,  
	MOVE G6B, 100,  20,  80,  ,  ,  
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
	DELAY 100
	RETURN

hands_turnaround:
	SPEED 50
	MOVE G6A,  98, 115,  98,  94,  98,  
	MOVE G6D, 101, 118,  92,  98, 102,  
	MOVE G6B, 186,  20,  41,  ,  ,  
	MOVE G6C,  10,  10,  63,  ,  ,  
	DELAY 100
	MOVE G6A,  97,  74, 144,  93, 101,  
	MOVE G6D, 101,  79, 138,  94, 103,  
	MOVE G6B, 188, 101,  82,  ,  ,  
	MOVE G6C,  13, 105,  81,  ,  ,  
	MOVE G6A, 100,  73, 139, 101, 101,  
	MOVE G6D, 100,  73, 139, 100, 102,  
	MOVE G6B, 188, 184, 139,  ,  ,  
	MOVE G6C,  13, 188, 148,  ,  ,  
	DELAY 200
	GOSUB stand_pose
	DELAY 300
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
	FOR i = 1 TO 4
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
	SPEED 8
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
	SPEED 15
	GOSUB wave_hand_pose2
	'left move
	SPEED 5
	MOVE G6A, 100,  76, 145,  93, 100,  
	MOVE G6D, 115,  79, 143,  93, 128,   
	GOSUB wave_hand_pose1 
	DELAY 200
	 
	'front back leap
	SPEED 10
	MOVE G6A,  98,  42, 146, 134, 107,  
	MOVE G6D, 100, 105, 144,  72,  96,  
	GOSUB wave_hand_pose2
	WAIT
	
	MOVE G6D,  98,  42, 146, 134, 107,  
	MOVE G6A, 100, 105, 144,  72,  96,  
	GOSUB wave_hand_pose1 
	DELAY 200
	'right move
	SPEED 5
	MOVE G6A, 115,  79, 143,  93, 128,  
	MOVE G6D, 100,  76, 145,  93, 100,  
	GOSUB wave_hand_pose2 
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
	DELAY 200
	RETURN

hands_turnaround_delux:
	SPEED 10
	MOVE G6A,  98, 115,  98,  94,  98,  
	MOVE G6D, 101, 118,  92,  98, 102,  
	MOVE G6B, 186,  20,  41,  ,  ,  
	MOVE G6C,  10,  10,  63,  ,  ,  
	DELAY 100
	SPEED 15
	MOVE G6A,  97,  74, 144,  93, 101,  180
	MOVE G6D, 101,  79, 138,  94, 103,  180
	MOVE G6B, 188, 101,  82,  ,  ,  180
	MOVE G6C,  13, 105,  81,  ,  ,  180
	MOVE G6A, 100,  73, 139, 101, 101, 20 
	MOVE G6D, 100,  73, 139, 100, 102,  20
	MOVE G6B, 188, 184, 139,  ,  ,  20
	MOVE G6C,  13, 188, 148,  ,  ,  20
	DELAY 100
	SPEED 10
	GOSUB stand_pose
	DELAY 200
	RETURN

hand_front_side_delux:
	'move hand from front to side with walking
	'left hand, right walk
	SPEED 13
	GOSUB right_walk
	MOVE G6B, 190,  10,  50,  ,  ,  
	MOVE G6C, 100,  64,  10,  ,  ,  
	SPEED 8 'wave hand, crouch
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
	DELAY 300
	'right hand, left walk
	SPEED 13
	GOSUB left_walk
	MOVE G6C, 190,  10,  50,  ,  , 
	MOVE G6B, 100,  64,  10,  ,  ,  
	SPEED 8 'wave hand, crouch
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
	DELAY 300
	GOSUB stand_pose
	WAIT
	RETURN

hand_front_side_delux_nodelay:
	'move hand from front to side with walking
	'left hand, right walk
	SPEED 13
	GOSUB right_walk
	MOVE G6B, 190,  10,  50,  ,  ,  
	MOVE G6C, 100,  64,  10,  ,  ,  
	SPEED 10 'wave hand, crouch
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
	'right hand, left walk
	SPEED 13
	GOSUB left_walk
	MOVE G6C, 190,  10,  50,  ,  , 
	MOVE G6B, 100,  64,  10,  ,  ,  
	SPEED 10 'wave hand, crouch
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
	GOSUB stand_pose
	WAIT
	RETURN
		
hands_front_heart_delux:
	'hands move from front with heart shape and walking steps
	SPEED 10
	'left hand, right walk
	GOSUB right_walk
	MOVE G6B,  11, 166, 167,  ,  ,  
	MOVE G6C, 100,  30,  80,  ,  ,  
	WAIT
	'stand
	MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
	'right hand, left walk
	GOSUB left_walk
	MOVE G6B,  11, 166, 167,  ,  ,  
	MOVE G6C,  19, 188, 147,  ,  ,  
	WAIT
	SPEED 12 'wave to side
	MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
	MOVE G6B,  30, 187, 112,  ,  ,  
	MOVE G6C,  32, 188, 111,  ,  ,  
	WAIT
	MOVE G6A, 100,  83, 125, 113, 100,  
	MOVE G6D, 100,  83, 125, 113, 100,  
	MOVE G6B,  11, 157, 112,  ,  ,  
	MOVE G6C,  13, 155, 111,  ,  ,  
	WAIT
	MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
	MOVE G6B,  65, 105, 107,  ,  ,  
	MOVE G6C,  65, 104, 107,  ,  ,  
	WAIT
	GOSUB stand_pose
	DELAY 200
	RETURN
	
arms_45_angle:
	'left arm raise

	SPEED 13
	MOVE G6A, 106, 169,  22, 131, 106,20  
	MOVE G6D,  58, 102, 116, 111, 132,  20
	MOVE G6B, 100, 136,  96,  ,  ,  20
	MOVE G6C, 103,  66, 101,  ,  ,  20
	DELAY 200
	GOSUB balance_pose
	'right arm raise
	MOVE G6A,  58, 102, 116, 111, 132,  180
	MOVE G6D,  106, 169,  22, 131, 106,180  
	MOVE G6B,  103,  66, 101,  ,  , 180
	MOVE G6C,  100, 136,  96,  ,  ,  180
	DELAY 200
	GOSUB balance_pose
	'front pose
	'SPEED 7
	'MOVE G6A,  88,  75, 134,  96, 117,  100 
	'MOVE G6D,  96,  96, 141,  66, 100, 100
	'MOVE G6B,  103,  66, 101,  ,  , 100
	'MOVE G6C,  100, 136,  96,  ,  ,  100
	'DELAY 200
	SPEED 13
 	MOVE G6A,  88,  75, 134,  96, 117,  100 
	MOVE G6D,  96,  96, 141,  66, 100, 100
	MOVE G6B, 190,  13, 100,  ,  ,  
	MOVE G6C, 190,  13, 100,  ,  ,
	GOSUB stand_pose
	RETURN

left_walk_raising_hands:
	SPEED 20
	MOVE G6A,  81,  85, 114, 111, 137,  
	MOVE G6D, 100,  76, 143,  93, 100,  
	MOVE G6B, 100,  50,  81,  ,  ,  
	MOVE G6C, 100, 190, 110,  ,  ,  
	WAIT
	MOVE G6A,100,  76, 145,  93, 100, 
    MOVE G6D,100,  76, 145,  93,100,  
	MOVE G6B, 100, 183, 110,  ,  ,  
	MOVE G6C, 100, 190, 110,  ,  ,  
	WAIT
	GOSUB stand_pose
	RETURN

drag_backto_right:
	SPEED 20
	MOVE G6B, 190,  10,  52,  ,  ,  
	MOVE G6C, 190,  34,  69,  ,  ,  
	WAIT
	SPEED 10
	MOVE G6A,  100,  76, 143,  93, 100, 
	MOVE G6D,  81,  85, 114, 111, 137,  
	MOVE G6B, 190,  13, 100,  ,  ,  
	MOVE G6C, 190,  10,  71,  ,  ,  
	WAIT
	MOVE G6A, 100,  76, 145,  93,100,
    MOVE G6D, 100,  76, 145,  93, 100, 
	GOSUB stand_pose
	RETURN

jump_raising_arms:
	FOR i = 1 TO 3
	SPEED 20
	MOVE G6A,  85, 119,  81, 101, 115, 20 
	MOVE G6D,  95, 114,  78, 111, 111, 20   
	MOVE G6B, 100,  30,  80,  ,  ,  20
	MOVE G6C, 100, 190, 100,  ,  ,  20
	WAIT
	MOVE G6A, 100,  76, 145,  93, 100,180  
	MOVE G6D, 100,  76, 145,  93, 100,180
	MOVE G6B, 100, 190, 100,  ,  , 180
	MOVE G6C, 100,  30,  80,  ,  , 180
	WAIT
	NEXT i
	GOSUB stand_pose
	RETURN

arms_round:
	SPEED 20
	MOVE G6A,90,  76, 145,  93, 100, 20 
	MOVE G6D, 105,  85, 126,  98, 139,  20
	MOVE G6B, 104, 182, 104,  ,  ,  20
	MOVE G6C, 101,  57,  81,  ,  ,  20
	GOSUB stand_pose
	MOVE G6A,105,  85, 126,  98, 139, 180
	MOVE G6D,  90,  76, 145,  93, 100, 180  
	MOVE G6B, 101,  33,  82,  ,  ,180
	MOVE G6C, 100, 184, 102,  ,  ,180
	GOSUB stand_pose
	RETURN

split:
	SPEED 20
  	MOVE G6B, 101, 190, 147,  ,  ,  
  	MOVE G6C, 100, 190, 147,  ,  ,  
  	DELAY 200
  	SPEED 10
  	
	'raise right leg
	MOVE G6A, 117, 130,  74, 109,  87,  
	MOVE G6D,  63, 135,  79, 102, 141,  
  	DELAY 800
	
	MOVE G6A,  ,  ,  ,  ,  , 180  
	MOVE G6D,  ,  ,  ,  ,  ,  180
	MOVE G6C, 102,  90, 107, 100 , 100 , 180 
	MOVE G6B,  ,  ,  ,  ,  ,  180

	DELAY 500
	
	MOVE G6A,  ,  ,  ,  ,  , 100 
	MOVE G6D,  ,  ,  ,  ,  ,  100
	MOVE G6C, 100, 190, 147,  ,  , 100
	MOVE G6B,  ,  ,  ,  ,  ,  100

	DELAY 400
	MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93,100, 100
	WAIT
	
	'raise left leg
	'MOVE G6A, 63, 135,  79, 102, 141, 
	'MOVE G6D, 117, 130,  74, 109,  87,  
  	'DELAY 1000
	
	'MOVE G6A,  ,  ,  ,  ,  , 20  
	'MOVE G6D,  ,  ,  ,  ,  ,  20
	'MOVE G6B, 102,  90, 107, 100 , 100 , 20 
	'MOVE G6C,  ,  ,  ,  ,  ,  20

	'DELAY 200
	
	'MOVE G6A,  ,  ,  ,  ,  , 100 
	'MOVE G6D,  ,  ,  ,  ,  ,  100
	'MOVE G6B, 100, 190, 147,  ,  , 100
	'MOVE G6C,  ,  ,  ,  ,  ,  100

	'DELAY 200
	
	'MOVE G6A, 100,  76, 145,  93,100, 100
    'MOVE G6D, 100,  76, 145,  93, 100, 100
	'WAIT
	RETURN
	
side_roll:
	'''侧滚翻
	'举手 蹲
	SPEED 20
	MOVE G6A, 103, 166,  19, 128,  95,  
	MOVE G6D, 103, 166,  19, 128,  95,  
	MOVE G6B, 103, 110, 188,  ,  ,  
	MOVE G6C, 103, 110, 188,  ,  ,  
	WAIT
	SPEED 10
	'向左倒
	MOVE G6A, 120, 166,  19, 128, 186,  
	MOVE G6D, 100,  76, 145,  93, 100,  
	MOVE G6B, 103, 162, 190,  ,  ,  
	MOVE G6C, 103, 110, 188,  ,  ,  
	WAIT
	'左胳膊撑地  双腿侧伸直
	MOVE G6A, 100,  76, 145,  93, 186,  
	MOVE G6D, 100,  76, 145,  93, 186,  
	MOVE G6B, 100, 164, 190,  ,  ,  
	MOVE G6C, 101, 109, 179,  ,  ,  
	WAIT
	SPEED 20
	'回旋 右腿后 左腿前
	MOVE G6A,  62,  47, 136, 145, 124,  
	MOVE G6D, 101,  73, 157,  54, 146,  
	MOVE G6B, 100, 164, 190,  ,  ,  
	MOVE G6C, 101, 109, 179,  ,  ,  
	WAIT
	
	RETURN

initiation:
	'to prepare for the following moves
	'video 十六 15-27s
	SPEED 5
	'move left
	MOVE G6A, 103, 110,  87, 105, 125,  
	MOVE G6D, 100, 110, 100, 104, 100,  
	MOVE G6B, 103,  44,  81,  ,  ,  
	MOVE G6C, 100,  30,  80,  ,  ,  
	WAIT
	'lift hands
	MOVE G6A,  91, 127,  85,  96, 109, 'taiji stand 
	MOVE G6D,  91, 127,  85,  96, 109,  
	MOVE G6B, 185,  28,  67,  ,  ,  
	MOVE G6C, 190,  28,  67,  ,  ,  
	WAIT
	'lower hands
	MOVE G6A,  91, 127,  85,  96, 109,  
	MOVE G6D,  91, 127,  85,  96, 109,  
	MOVE G6B, 138,  30,  68,  ,  ,  
	MOVE G6C, 142,  30,  68,  ,  ,  
	DELAY 200
	RETURN

baoqiu:
	SPEED 5 
	'lower hands
	MOVE G6A,  91, 127,  85,  96, 109,  100
	MOVE G6D,  91, 127,  85,  96, 109,  100
	MOVE G6B, 138,  30,  68,  ,  ,  100
	MOVE G6C, 142,  30,  68,  ,  ,  100
	DELAY 200
	RETURN	

yemafenzong:
	'野马分鬃
	'video 十六 28-45s
	SPEED 5
	'left
	MOVE G6A, 101,  78, 126, 108, 144,  120
	MOVE G6D,  98, 105, 112,  99, 102,  120
	MOVE G6B, 179,  15,  25,  ,  ,  120
	MOVE G6C, 190,  32,  69,  ,  ,  120
	WAIT
	MOVE G6A,  95,  65, 102, 136, 112,  60
	MOVE G6D,  96, 107, 173,  27, 101,  60
	MOVE G6B, 176,  29,  42,  ,  ,  60
	MOVE G6C, 190,  15,  27,  ,  ,  60
	WAIT
	MOVE G6A,  95,  65, 102, 136, 112,  
	MOVE G6D,  96, 107, 173,  27, 101,  
	MOVE G6B, 176,  29,  42,  ,  ,  
	MOVE G6C,  76,  54,  78,  ,  ,  
	WAIT
	'left to right
	MOVE G6A,  94,  14, 161, 125, 138,  100
	MOVE G6D, 103, 149,  88,  78,  95,  100
	MOVE G6B, 176,  29,  42,  ,  ,  100
	MOVE G6C, 100,  54,  78,  ,  ,  100
	WAIT
	MOVE G6A,  96, 103, 101, 110, 115,  
	MOVE G6D,  85,  93, 133,  94, 110,  
	MOVE G6B, 176,  29,  42,  ,  ,  
	MOVE G6C, 149,  38,  64,  ,  ,  
	WAIT
	'right -- reverse of 'left'
	MOVE G6D, 101,  78, 126, 108, 144,  80
	MOVE G6A,  98, 105, 112,  99, 102,  80
	MOVE G6C, 179,  15,  25,  ,  ,  80
	MOVE G6B, 190,  32,  69,  ,  ,  80
	WAIT
	MOVE G6D,  95,  65, 102, 136, 112,  140
	MOVE G6A,  96, 107, 173,  27, 101,  140
	MOVE G6C, 176,  29,  42,  ,  ,  140
	MOVE G6B, 190,  15,  27,  ,  ,  140
	WAIT
	MOVE G6D,  95,  65, 102, 136, 112,  
	MOVE G6A,  96, 107, 173,  27, 101,  
	MOVE G6C, 176,  29,  42,  ,  ,  
	MOVE G6B,  76,  54,  78,  ,  ,  
	WAIT
	'end
	MOVE G6A,  91, 127,  85,  96, 109,100  
	MOVE G6D,  91, 127,  85,  96, 109,  100
	MOVE G6B, 159,  25,  42,  ,  ,  100
	MOVE G6C, 162,  15,  54,  ,  ,  100
	DELAY 200
	RETURN
	
baiheliangchi:
	'左白鹤亮翅
	'video 46-58s
	SPEED 5
	'亮翅
	MOVE G6A, 111, 153,  53,  96,  94,  20
	MOVE G6D,  78, 115,  44, 148, 119,  20
	MOVE G6B,  92, 141, 146,  ,  ,  20
	MOVE G6C, 155,  27,  79,  ,  ,  20
	WAIT
	MOVE G6A, 106, 145,  73,  90, 100,100  
	MOVE G6D,  93,  23, 115, 148, 103,  100
	MOVE G6B,  92, 141, 146,  ,  ,  100
	MOVE G6C, 112,  40,  63,  ,  ,  100
	WAIT
	'收翅
	MOVE G6A, 106, 145,  73,  90, 100,  60
	MOVE G6D,  94,  82,  54, 148, 104,  60
	MOVE G6B, 184,  13,  22,  ,  ,  60
	MOVE G6C, 190,  74,  80,  ,  ,  60
	WAIT
	MOVE G6A, 106, 145,  73,  90, 100,  20
	MOVE G6D,  89, 108,  46, 125, 106,  20
	MOVE G6B, 187,  75,  79,  ,  ,  20
	MOVE G6C, 190,  17,  13,  ,  ,  20
	DELAY 200
	RETURN
	
louxiaobu:
	'左右搂膝拗步
	'video 十六 59-1min11s
	MOVE G6A,  93, 147, 110,  54, 113,  
	MOVE G6D,  95, 106,  65, 139, 102,  
	MOVE G6B, 182,  13,  64,  ,  ,  
	MOVE G6C, 156,  40,  37,  ,  ,  
	WAIT
	RETURN

yunshou:
	'左右云手
	'video 8  2min18-2min30
	'left
	'右脚尖着地
	SPEED 4
	MOVE G6A, 110, 155,  64,  91,  92,  
	MOVE G6D,  78,  14, 118, 156, 125,  
	MOVE G6B, 90,  60,  100,  ,  ,  
	MOVE G6C, 160,  23,  71,  ,  ,
	WAIT
	DELAY 200     
	'重心左移
	WAIT
	MOVE G6A,  97, 137,  77,  92, 107,  20
	MOVE G6D,  64,  92, 133,  79, 136, 20 
	MOVE G6B,  88, 105, 137,  ,  ,  20
	MOVE G6C,  160,  11,  44,  ,  ,  20
	WAIT
	DELAY 200
	'l2r 转换姿势
	SPEED 3
	MOVE G6A,  85, 128,  84,  97, 119, 60 
	MOVE G6D,  98, 133,  91,  88, 101,  60
	MOVE G6B, 122,  53, 114,  ,  ,  60
	MOVE G6C, 180,  11,  32,  ,  ,  60
	WAIT
	
	MOVE G6A,  90, 101, 127,  80, 112,  100
	MOVE G6D, 100, 106, 113,  85, 101,  100
	MOVE G6B, 140,  40,  70,  ,  ,  100
	MOVE G6C, 160,  23,  71,  ,  ,  100
	WAIT
	
	'right
    SPEED 4
	MOVE G6A,  64,  92, 133,  79, 136, 180 
	MOVE G6D,  97, 137,  77,  92, 107,  180
	MOVE G6B, 166,  11,  44,  ,  ,  180
	MOVE G6C,  88, 105, 137,  ,  ,  180
	WAIT
	DELAY 200
	'r2l 转换姿势
	SPEED 3
	MOVE G6A,  98, 133,  91,  88, 101,  140 
	MOVE G6D,  85, 128,  84,  97, 119, 140 
	MOVE G6B, 180,  11,  32,  ,  ,  140
	MOVE G6C, 122,  53, 114,  ,  ,  140
	WAIT
	MOVE G6A,  90, 101, 127,  80, 112,  100
	MOVE G6D,  100, 106, 113,  85, 101,  100
	MOVE G6B,  160,  23,  71,  ,  ,  100
	MOVE G6C,  140,  40,  70,  ,  ,  100
	WAIT
	'left
	MOVE G6A,  97, 137,  77,  92, 107,  20
	MOVE G6D,  64,  92, 133,  79, 136, 20 
	MOVE G6B,  88, 105, 137,  ,  ,  20
	MOVE G6C,  166,  11,  44,  ,  ,  20
	DELAY 300
	RETURN 

shouhuipipa:
	GOSUB baoqiu
	SPEED 3
	'stand_up
	MOVE G6A,  66,  54, 136, 131, 116, 80 
	MOVE G6D,  77, 101,  98, 124, 100,  80
	MOVE G6B, 117,  86,  80,  ,  ,  80
	MOVE G6C, 123,  99,  83,  ,  , 80
	DELAY 200
	SPEED 3
	'left
	MOVE G6A,  67,  30,  72, 163, 129, 40 
	MOVE G6D, 120, 151,  55, 108,  88,  40
	MOVE G6B, 102,  81, 180,  ,  ,  40
	MOVE G6C, 187,  10,  10,  ,  ,  40
	WAIT
	DELAY 500
	GOSUB baoqiu
	SPEED 2
	'双手前平举
	MOVE G6A , 95, 100, 120, 94, 104,
	MOVE G6D , 95, 100, 120, 94, 104,
	MOVE G6B, 188,  10,  83,  ,  ,  
	MOVE G6C, 190,  11,  83,  ,  ,
	WAIT
	DELAY 400
	'right
	SPEED 3
	MOVE G6A,  77, 101,  98, 124, 100,
	MOVE G6D,  66,  54, 136, 131, 116,    
	WAIT
	
	MOVE G6A, 116, 127,  74, 119,  88,160 
	MOVE G6D,  81,  14, 115, 162, 117, 160
	MOVE G6B, 187,  10,  10,  ,  ,160
	MOVE G6C, 102,  81, 180,  ,  ,  160
	DELAY 500
	RETURN 
	
jinjiduli:
	SPEED 5
	'squat
	MOVE G6A,  84,  94,  45, 158, 119,  
	MOVE G6D, 109, 138,  55, 121,  88,  
	MOVE G6B, 105,  40,  120,  ,  ,  
	MOVE G6C, 120,  28,  60,  ,  ,  
	'raise l_leg
	MOVE G6A, 108,  10,  84, 160, 125,  60
	MOVE G6D, 116, 106, 104, 109,  80,  60
	MOVE G6B, 113,  57, 189,  ,  ,  60
	MOVE G6C, 143,  25,  35,  ,  ,  60
	WAIT
	DELAY 300
	'front_pose
	MOVE G6A, 96, 99,  93, 120, 105,  100
	MOVE G6D, 101, 103,  93, 120, 105,  100
	MOVE G6B, 187,  25,  62,  ,  ,  100
	MOVE G6C, 153,  25,  35,  ,  ,  100
	WAIT 
	
	MOVE G6A,  96, 107, 173,  27, 101,  
	MOVE G6D,  95,  65, 102, 136, 112,
	MOVE G6B,  153,  25,  35,  ,  ,  
	MOVE G6C,  187,  25,  62,  ,  ,  
	WAIT
	MOVE G6A, 96, 99,  93, 120, 105,  
	MOVE G6D, 101, 103,  93, 120, 105, 
	MOVE G6B, 187,  25,  62,  ,  ,  
	MOVE G6C, 153,  25,  35,  ,  ,   
	WAIT
	
	'squat
	MOVE G6A, 109, 138,  55, 121,  88, 
	MOVE G6D, 84,  94,  45, 158, 119,  
	MOVE G6B, 170,  25,  50,  ,  , 
	MOVE G6C, 140,  40, 110,  ,  ,  
	WAIT
	'rasie r_leg
	MOVE G6A, 116, 98, 104, 109,  80,  140
	MOVE G6D, 108,  10,  84, 160, 125,  140
	MOVE G6B, 143,  25,  35,  ,  ,  140
	MOVE G6C, 113,  57, 189,  ,  ,  140
	WAIT
	DELAY 300 
	RETURN
	
shoushi:
	GOSUB baoqiu
	DELAY 400
	
	SPEED 3
	'平举双手
	MOVE G6B, 185,  70,  76,  ,  ,  
	MOVE G6C, 190,  72,  76,  ,  ,  

	WAIT 
	DELAY 400
	'双手前平举
	MOVE G6A , 95, 100, 120, 94, 104,
	MOVE G6D , 95, 100, 120, 94, 104,
	MOVE G6B, 188,  10,  83,  ,  ,  
	MOVE G6C, 190,  11,  83,  ,  ,
	
	WAIT
	DELAY 400
	GOSUB stand_pose  
	RETURN

	



