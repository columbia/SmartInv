1 pragma solidity 		^0.4.8	;							
2 										
3 contract	MiniPoolEdit_2		{							
4 										
5 	address	owner	;							
6 										
7 	function	MiniPoolEdit_2		()	public	{				
8 		owner	= msg.sender;							
9 	}									
10 										
11 	modifier	onlyOwner	() {							
12 		require(msg.sender ==		owner	);					
13 		_;								
14 	}									
15 										
16 										
17 										
18 // 1 IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
19 										
20 										
21 	string	inMiniPoolEdit_1	=	"	une première phrase			"	;	
22 										
23 	function	setMiniPoolEdit_1	(	string	newMiniPoolEdit_1	)	public	onlyOwner	{	
24 		inMiniPoolEdit_1	=	newMiniPoolEdit_1	;					
25 	}									
26 										
27 	function	getMiniPoolEdit_1	()	public	constant	returns	(	string	)	{
28 		return	inMiniPoolEdit_1	;						
29 	}									
30 										
31 										
32 										
33 // 2 IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
34 										
35 										
36 	string	inMiniPoolEdit_2	=	"	une première phrase			"	;	
37 										
38 	function	setMiniPoolEdit_2	(	string	newMiniPoolEdit_2	)	public	onlyOwner	{	
39 		inMiniPoolEdit_2	=	newMiniPoolEdit_2	;					
40 	}									
41 										
42 	function	getMiniPoolEdit_2	()	public	constant	returns	(	string	)	{
43 		return	inMiniPoolEdit_2	;						
44 	}									
45 										
46 										
47 										
48 // 3 IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
49 										
50 										
51 	string	inMiniPoolEdit_3	=	"	une première phrase			"	;	
52 										
53 	function	setMiniPoolEdit_3	(	string	newMiniPoolEdit_3	)	public	onlyOwner	{	
54 		inMiniPoolEdit_3	=	newMiniPoolEdit_3	;					
55 	}									
56 										
57 	function	getMiniPoolEdit_3	()	public	constant	returns	(	string	)	{
58 		return	inMiniPoolEdit_3	;						
59 	}									
60 										
61 										
62 										
63 // 4 IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
64 										
65 										
66 	string	inMiniPoolEdit_4	=	"	une première phrase			"	;	
67 										
68 	function	setMiniPoolEdit_4	(	string	newMiniPoolEdit_4	)	public	onlyOwner	{	
69 		inMiniPoolEdit_4	=	newMiniPoolEdit_4	;					
70 	}									
71 										
72 	function	getMiniPoolEdit_4	()	public	constant	returns	(	string	)	{
73 		return	inMiniPoolEdit_4	;						
74 	}									
75 										
76 										
77 										
78 										
79 // 5 IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
80 										
81 										
82 	string	inMiniPoolEdit_5	=	"	une première phrase			"	;	
83 										
84 	function	setMiniPoolEdit_5	(	string	newMiniPoolEdit_5	)	public	onlyOwner	{	
85 		inMiniPoolEdit_5	=	newMiniPoolEdit_5	;					
86 	}									
87 										
88 	function	getMiniPoolEdit_5	()	public	constant	returns	(	string	)	{
89 		return	inMiniPoolEdit_5	;						
90 	}									
91 										
92 										
93 										
94 // 6 IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
95 										
96 										
97 	string	inMiniPoolEdit_6	=	"	une première phrase			"	;	
98 										
99 	function	setMiniPoolEdit_6	(	string	newMiniPoolEdit_6	)	public	onlyOwner	{	
100 		inMiniPoolEdit_6	=	newMiniPoolEdit_6	;					
101 	}									
102 										
103 	function	getMiniPoolEdit_6	()	public	constant	returns	(	string	)	{
104 		return	inMiniPoolEdit_6	;						
105 	}									
106 										
107 										
108 										
109 // 7 IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
110 										
111 										
112 	string	inMiniPoolEdit_7	=	"	une première phrase			"	;	
113 										
114 	function	setMiniPoolEdit_7	(	string	newMiniPoolEdit_7	)	public	onlyOwner	{	
115 		inMiniPoolEdit_7	=	newMiniPoolEdit_7	;					
116 	}									
117 										
118 	function	getMiniPoolEdit_7	()	public	constant	returns	(	string	)	{
119 		return	inMiniPoolEdit_7	;						
120 	}									
121 										
122 										
123 										
124 // 8 IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
125 										
126 										
127 	string	inMiniPoolEdit_8	=	"	une première phrase			"	;	
128 										
129 	function	setMiniPoolEdit_8	(	string	newMiniPoolEdit_8	)	public	onlyOwner	{	
130 		inMiniPoolEdit_8	=	newMiniPoolEdit_8	;					
131 	}									
132 										
133 	function	getMiniPoolEdit_8	()	public	constant	returns	(	string	)	{
134 		return	inMiniPoolEdit_8	;						
135 	}									
136 										
137 										
138 										
139 // 9 IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
140 										
141 										
142 	string	inMiniPoolEdit_9	=	"	une première phrase			"	;	
143 										
144 	function	setMiniPoolEdit_9	(	string	newMiniPoolEdit_9	)	public	onlyOwner	{	
145 		inMiniPoolEdit_9	=	newMiniPoolEdit_9	;					
146 	}									
147 										
148 	function	getMiniPoolEdit_9	()	public	constant	returns	(	string	)	{
149 		return	inMiniPoolEdit_9	;						
150 	}									
151 										
152 										
153 }