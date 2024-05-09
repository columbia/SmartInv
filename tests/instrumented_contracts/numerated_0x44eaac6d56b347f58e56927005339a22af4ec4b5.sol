1 pragma solidity 		^0.4.21	;							
2 										
3 interface IERC20Token {										
4 	function totalSupply() public constant returns (uint);									
5 	function balanceOf(address tokenlender) public constant returns (uint balance);									
6 	function allowance(address tokenlender, address spender) public constant returns (uint remaining);									
7 	function transfer(address to, uint tokens) public returns (bool success);									
8 	function approve(address spender, uint tokens) public returns (bool success);									
9 	function transferFrom(address from, address to, uint tokens) public returns (bool success);									
10 										
11 	event Transfer(address indexed from, address indexed to, uint tokens);									
12 	event Approval(address indexed tokenlender, address indexed spender, uint tokens);	
13 }
14 										
15 contract	DTCC_ILOW_4		{							
16 										
17 	address	owner	;							
18 										
19 	function	DTCC_ILOW_4		()	public	{				
20 		owner	= msg.sender;							
21 	}									
22 										
23 	modifier	onlyOwner	() {							
24 		require(msg.sender ==		owner	);					
25 		_;								
26 	}									
27 										
28 										
29 										
30 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
31 										
32 										
33 	uint256	inData_1	=	1000	;					
34 										
35 	function	setData_1	(	uint256	newData_1	)	public	onlyOwner	{	
36 		inData_1	=	newData_1	;					
37 	}									
38 										
39 	function	getData_1	()	public	constant	returns	(	uint256	)	{
40 		return	inData_1	;						
41 	}									
42 										
43 										
44 										
45 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
46 										
47 										
48 	uint256	inData_2	=	1000	;					
49 										
50 	function	setData_2	(	uint256	newData_2	)	public	onlyOwner	{	
51 		inData_2	=	newData_2	;					
52 	}									
53 										
54 	function	getData_2	()	public	constant	returns	(	uint256	)	{
55 		return	inData_2	;						
56 	}									
57 										
58 										
59 										
60 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
61 										
62 										
63 	uint256	inData_3	=	1000	;					
64 										
65 	function	setData_3	(	uint256	newData_3	)	public	onlyOwner	{	
66 		inData_3	=	newData_3	;					
67 	}									
68 										
69 	function	getData_3	()	public	constant	returns	(	uint256	)	{
70 		return	inData_3	;						
71 	}									
72 										
73 										
74 										
75 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
76 										
77 										
78 	uint256	inData_4	=	1000	;					
79 										
80 	function	setData_4	(	uint256	newData_4	)	public	onlyOwner	{	
81 		inData_4	=	newData_4	;					
82 	}									
83 										
84 	function	getData_4	()	public	constant	returns	(	uint256	)	{
85 		return	inData_4	;						
86 	}									
87 										
88 										
89 										
90 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
91 										
92 										
93 	uint256	inData_5	=	1000	;					
94 										
95 	function	setData_5	(	uint256	newData_5	)	public	onlyOwner	{	
96 		inData_5	=	newData_5	;					
97 	}									
98 										
99 	function	getData_5	()	public	constant	returns	(	uint256	)	{
100 		return	inData_5	;						
101 	}									
102 										
103 										
104 										
105 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
106 										
107 										
108 	uint256	inData_6	=	1000	;					
109 										
110 	function	setData_6	(	uint256	newData_6	)	public	onlyOwner	{	
111 		inData_6	=	newData_6	;					
112 	}									
113 										
114 	function	getData_6	()	public	constant	returns	(	uint256	)	{
115 		return	inData_6	;						
116 	}									
117 										
118 										
119 										
120 	address	public	User_1		=	msg.sender				;
121 	address	public	User_2		;//	_User_2				;
122 	address	public	User_3		;//	_User_3				;
123 	address	public	User_4		;//	_User_4				;
124 	address	public	User_5		;//	_User_5				;
125 										
126 	IERC20Token	public	Token_1		;//	_Token_1				;
127 	IERC20Token	public	Token_2		;//	_Token_2				;
128 	IERC20Token	public	Token_3		;//	_Token_3				;
129 	IERC20Token	public	Token_4		;//	_Token_4				;
130 	IERC20Token	public	Token_5		;//	_Token_5				;
131 										
132 	uint256	public	retraitStandard_1		;//	_retraitStandard_1				;
133 	uint256	public	retraitStandard_2		;//	_retraitStandard_2				;
134 	uint256	public	retraitStandard_3		;//	_retraitStandard_3				;
135 	uint256	public	retraitStandard_4		;//	_retraitStandard_4				;
136 	uint256	public	retraitStandard_5		;//	_retraitStandard_5				;
137 										
138 	function	admiss_1				(				
139 		address	_User_1		,					
140 		IERC20Token	_Token_1		,					
141 		uint256	_retraitStandard_1							
142 	)									
143 		public	onlyOwner							
144 	{									
145 		User_1		=	_User_1		;			
146 		Token_1		=	_Token_1		;			
147 		retraitStandard_1		=	_retraitStandard_1		;			
148 	}									
149 										
150 	function	admiss_2				(				
151 		address	_User_2		,					
152 		IERC20Token	_Token_2		,					
153 		uint256	_retraitStandard_2							
154 	)									
155 		public	onlyOwner							
156 	{									
157 		User_2		=	_User_2		;			
158 		Token_2		=	_Token_2		;			
159 		retraitStandard_2		=	_retraitStandard_2		;			
160 	}									
161 										
162 	function	admiss_3				(				
163 		address	_User_3		,					
164 		IERC20Token	_Token_3		,					
165 		uint256	_retraitStandard_3							
166 	)									
167 		public	onlyOwner							
168 	{									
169 		User_3		=	_User_3		;			
170 		Token_3		=	_Token_3		;			
171 		retraitStandard_3		=	_retraitStandard_3		;			
172 	}									
173 										
174 	function	admiss_4				(				
175 		address	_User_4		,					
176 		IERC20Token	_Token_4		,					
177 		uint256	_retraitStandard_4							
178 	)									
179 		public	onlyOwner							
180 	{									
181 		User_4		=	_User_4		;			
182 		Token_4		=	_Token_4		;			
183 		retraitStandard_4		=	_retraitStandard_4		;			
184 	}									
185 										
186 	function	admiss_5				(				
187 		address	_User_5		,					
188 		IERC20Token	_Token_5		,					
189 		uint256	_retraitStandard_5							
190 	)									
191 		public	onlyOwner							
192 	{									
193 		User_5		=	_User_5		;			
194 		Token_5		=	_Token_5		;			
195 		retraitStandard_5		=	_retraitStandard_5		;			
196 	}									
197 	//									
198 	//									
199 										
200 	function	retrait_1				()	public	{		
201 		require(	msg.sender == User_1			);				
202 		require(	Token_1.transfer(User_1, retraitStandard_1)			);				
203 		require(	inData_1 == inData_2			);				
204 		require(	inData_3 == inData_4			);				
205 		require(	inData_5 == inData_6			);				
206 	}									
207 										
208 	function	retrait_2				()	public	{		
209 		require(	msg.sender == User_2			);				
210 		require(	Token_2.transfer(User_2, retraitStandard_2)			);				
211 		require(	inData_1 == inData_2			);				
212 		require(	inData_3 == inData_4			);				
213 		require(	inData_5 == inData_6			);				
214 	}									
215 										
216 	function	retrait_3				()	public	{		
217 		require(	msg.sender == User_3			);				
218 		require(	Token_3.transfer(User_3, retraitStandard_3)			);				
219 		require(	inData_1 == inData_2			);				
220 		require(	inData_3 == inData_4			);				
221 		require(	inData_5 == inData_6			);				
222 	}									
223 										
224 	function	retrait_4				()	public	{		
225 		require(	msg.sender == User_4			);				
226 		require(	Token_4.transfer(User_4, retraitStandard_4)			);				
227 		require(	inData_1 == inData_2			);				
228 		require(	inData_3 == inData_4			);				
229 		require(	inData_5 == inData_6			);				
230 	}									
231 										
232 	function	retrait_5				()	public	{		
233 		require(	msg.sender == User_5			);				
234 		require(	Token_5.transfer(User_5, retraitStandard_5)			);				
235 		require(	inData_1 == inData_2			);				
236 		require(	inData_3 == inData_4			);				
237 		require(	inData_5 == inData_6			);				
238 	}									
239 										
240 										
241 }