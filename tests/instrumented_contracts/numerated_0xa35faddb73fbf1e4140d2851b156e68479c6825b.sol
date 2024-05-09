1 pragma solidity 		^0.4.8	;							
2 											
3 	contract	Ownable		{							
4 		address	owner	;							
5 											
6 		function	Ownable	() {							
7 			owner	= msg.sender;							
8 		}									
9 											
10 		modifier	onlyOwner	() {							
11 			require(msg.sender ==		owner	);					
12 			_;								
13 		}									
14 											
15 		function 	transfertOwnership		(address	newOwner	)	onlyOwner	{		
16 			owner	=	newOwner	;					
17 		}									
18 	}										
19 											
20 											
21 											
22 	contract	PLAY_B1				is	Ownable	{			
23 											
24 		string	public	constant	name =	"	PLAY_B1		"	;	
25 		string	public	constant	symbol =	"	PLAYB1		"	;	
26 		uint32	public	constant	decimals =		18			;	
27 		uint	public		totalSupply =		10000000000000000000000000			;	
28 											
29 		mapping (address => uint) balances;									
30 		mapping (address => mapping(address => uint)) allowed;									
31 											
32 		function mint(address _to, uint _value) onlyOwner {									
33 			assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);								
34 			balances[_to] += _value;								
35 			totalSupply += _value;								
36 		}									
37 											
38 		function balanceOf(address _owner) constant returns (uint balance) {									
39 			return balances[_owner];								
40 		}									
41 											
42 		function transfer(address _to, uint _value) returns (bool success) {									
43 			if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {								
44 				balances[msg.sender] -= _value; 							
45 				balances[_to] += _value;							
46 				return true;							
47 			}								
48 			return false;								
49 		}									
50 											
51 		function transferFrom(address _from, address _to, uint _value) returns (bool success) {									
52 			if( allowed[_from][msg.sender] >= _value &&								
53 				balances[_from] >= _value 							
54 				&& balances[_to] + _value >= balances[_to]) {							
55 				allowed[_from][msg.sender] -= _value;							
56 				balances[_from] -= _value;							
57 				balances[_to] += _value;							
58 				Transfer(_from, _to, _value);							
59 				return true;							
60 			}								
61 			return false;								
62 		}									
63 											
64 		function approve(address _spender, uint _value) returns (bool success) {									
65 			allowed[msg.sender][_spender] = _value;								
66 			Approval(msg.sender, _spender, _value);								
67 			return true;								
68 		}									
69 											
70 		function allowance(address _owner, address _spender) constant returns (uint remaining) {									
71 			return allowed[_owner][_spender];								
72 		}									
73 											
74 		event Transfer(address indexed _from, address indexed _to, uint _value);									
75 		event Approval(address indexed _owner, address indexed _spender, uint _value);									
76 //	}										
77 											
78 											
79 											
80 	// IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
81 											
82 											
83 		string	inData_1	=	"	FIFA WORLD CUP 2018			"	;	
84 											
85 		function	setData_1	(	string	newData_1	)	public	onlyOwner	{	
86 			inData_1	=	newData_1	;					
87 		}									
88 											
89 		function	getData_1	()	public	constant	returns	(	string	)	{
90 			return	inData_1	;						
91 		}									
92 											
93 											
94 											
95 	// IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
96 											
97 											
98 		string	inData_2	=	"	Match : 15.06.2018 14;00 (Bern Time)			"	;	
99 											
100 		function	setData_2	(	string	newData_2	)	public	onlyOwner	{	
101 			inData_2	=	newData_2	;					
102 		}									
103 											
104 		function	getData_2	()	public	constant	returns	(	string	)	{
105 			return	inData_2	;						
106 		}									
107 											
108 											
109 											
110 	// IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
111 											
112 											
113 		string	inData_3	=	"	EGYPTE - URUGUAY			"	;	
114 											
115 		function	setData_3	(	string	newData_3	)	public	onlyOwner	{	
116 			inData_3	=	newData_3	;					
117 		}									
118 											
119 		function	getData_3	()	public	constant	returns	(	string	)	{
120 			return	inData_3	;						
121 		}									
122 											
123 											
124 											
125 	// IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
126 											
127 											
128 		string	inData_4	=	"	COTES [7.1047 ; 3.9642 ; 1.6475]			"	;	
129 											
130 		function	setData_4	(	string	newData_4	)	public	onlyOwner	{	
131 			inData_4	=	newData_4	;					
132 		}									
133 											
134 		function	getData_4	()	public	constant	returns	(	string	)	{
135 			return	inData_4	;						
136 		}									
137 											
138 											
139 											
140 	// IN DATA / SET DATA / GET DATA / STRING / PUBLIC / ONLY OWNER / CONSTANT										
141 											
142 											
143 		string	inData_5	=	"	URUGUAY WINS			"	;	
144 											
145 		function	setData_5	(	string	newData_5	)	public	onlyOwner	{	
146 			inData_5	=	newData_5	;					
147 		}									
148 											
149 		function	getData_5	()	public	constant	returns	(	string	)	{
150 			return	inData_5	;						
151 		}									
152 											
153 											
154 	}