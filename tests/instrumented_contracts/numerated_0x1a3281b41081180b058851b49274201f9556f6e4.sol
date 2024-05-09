1 pragma solidity 		^0.4.8	;						
2 											
3 		contract	Ownable		{						
4 			address	owner	;						
5 											
6 			function	Ownable	() {						
7 				owner	= msg.sender;						
8 			}								
9 											
10 			modifier	onlyOwner	() {						
11 				require(msg.sender ==		owner	);				
12 				_;							
13 			}								
14 											
15 			function 	transfertOwnership		(address	newOwner	)	onlyOwner	{	
16 				owner	=	newOwner	;				
17 			}								
18 		}									
19 											
20 											
21 											
22 		contract	BIPOOH_DAO_32_b				is	Ownable	{		
23 											
24 			string	public	constant	name =	"	BIPOOH_DAO_32_b		"	;
25 			string	public	constant	symbol =	"	BIPI		"	;
26 			uint32	public	constant	decimals =		18			;
27 			uint	public		totalSupply =		0			;
28 											
29 			mapping (address => uint) balances;								
30 			mapping (address => mapping(address => uint)) allowed;								
31 											
32 			function mint(address _to, uint _value) onlyOwner {								
33 				assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);							
34 				balances[_to] += _value;							
35 				totalSupply += _value;							
36 			}								
37 											
38 			function balanceOf(address _owner) constant returns (uint balance) {								
39 				return balances[_owner];							
40 			}								
41 											
42 			function transfer(address _to, uint _value) returns (bool success) {								
43 				if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {							
44 					balances[msg.sender] -= _value; 						
45 					balances[_to] += _value;						
46 					return true;						
47 				}							
48 				return false;							
49 			}								
50 											
51 			function transferFrom(address _from, address _to, uint _value) returns (bool success) {								
52 				if( allowed[_from][msg.sender] >= _value &&							
53 					balances[_from] >= _value 						
54 					&& balances[_to] + _value >= balances[_to]) {						
55 					allowed[_from][msg.sender] -= _value;						
56 					balances[_from] -= _value;						
57 					balances[_to] += _value;						
58 					Transfer(_from, _to, _value);						
59 					return true;						
60 				}							
61 				return false;							
62 			}								
63 											
64 			function approve(address _spender, uint _value) returns (bool success) {								
65 				allowed[msg.sender][_spender] = _value;							
66 				Approval(msg.sender, _spender, _value);							
67 				return true;							
68 			}								
69 											
70 			function allowance(address _owner, address _spender) constant returns (uint remaining) {								
71 				return allowed[_owner][_spender];							
72 			}								
73 											
74 			event Transfer(address indexed _from, address indexed _to, uint _value);								
75 			event Approval(address indexed _owner, address indexed _spender, uint _value);								
76 											
77 											
78 											
79 //	1	Annexe -1 « PI_2_1 » ex-post édition « BIPOOH_DAO_32 » 									
80 //	2	-									
81 //	3	Droits rattachés, non-publiés (Contrat ; Nom ; Symbole)									
82 //	4	« BIPOOH_DAO_32_b » ; « BIPOOH_DAO_32_b » ; « BIPI »									
83 //	5	Meta-donnees, premier rang									
84 //	6	« BIPOOH_DAO_32_b » ; « BIPOOH_DAO_32_b » ; « BIPI_i »									
85 //	7	Meta-donnees, second rang									
86 //	8	« BIPOOH_DAO_32_b » ; « BIPOOH_DAO_32_b » ; « BIPI_j »									
87 //	9	Meta-donnees, troisième rang									
88 //	10	« BIPOOH_DAO_32_b » ; « BIPOOH_DAO_32_b » ; « BIPI_k »									
89 //	11	Droits rattachés, non-publiés (Contrat ; Nom ; Symbole)									
90 //	12	« BIPOOH_DAO_32_c » ; « BIPOOH_DAO_32_c » ; « BIPII »									
91 //	13	Meta-donnees, premier rang									
92 //	14	« BIPOOH_DAO_32_c » ; « BIPOOH_DAO_32_c » ; « BIPII_i »									
93 //	15	Meta-donnees, second rang									
94 //	16	« BIPOOH_DAO_32_c » ; « BIPOOH_DAO_32_c » ; « BIPII_j »									
95 //	17	Meta-donnees, troisième rang									
96 //	18	« BIPOOH_DAO_32_c » ; « BIPOOH_DAO_32_c » ; « BIPII_k »									
97 //	19										
98 //	20										
99 //	21										
100 //	22										
101 //	23										
102 //	24										
103 //	25										
104 //	26										
105 //	27										
106 //	28										
107 //	29										
108 //	30										
109 //	31										
110 //	32										
111 //	33										
112 //	34										
113 //	35										
114 //	36										
115 //	37										
116 //	38										
117 //	39										
118 //	40										
119 //	41										
120 //	42										
121 //	43										
122 //	44										
123 //	45										
124 //	46										
125 //	47										
126 //	48										
127 //	49										
128 //	50										
129 //	51										
130 //	52										
131 //	53										
132 //	54										
133 //	55										
134 //	56										
135 //	57										
136 //	58										
137 //	59										
138 //	60										
139 //	61										
140 //	62										
141 //	63										
142 //	64										
143 //	65										
144 //	66										
145 //	67										
146 //	68										
147 //	69										
148 //	70										
149 //	71										
150 //	72										
151 //	73										
152 //	74										
153 //	75										
154 //	76										
155 //	77										
156 //	78										
157 											
158 											
159 		}