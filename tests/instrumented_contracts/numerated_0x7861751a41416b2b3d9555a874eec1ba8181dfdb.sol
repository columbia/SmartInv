1 pragma solidity ^0.4.24;
2 
3 /*  ERC 20 token */
4 contract OBSToken {
5     mapping (address => uint256) balances;
6     mapping (address => mapping (address => uint256)) allowed;
7 	string lname = "OuroBoros";
8 	string lsymbol= "OBS";
9 	uint8 dec=6;
10 	address manager;
11 	uint256 thetotal;
12 	constructor(uint256 total) public
13 	{
14 	    thetotal= total;
15 		manager = msg.sender;
16 		balances[manager]=total;
17 	}
18 	
19 	function name() public view returns (string)
20 	{
21 	   return lname;
22 	}
23 	
24 	function symbol() public view returns (string)
25 	{
26 	   return lsymbol;
27 	}
28 	
29 	function decimals() public view returns (uint8)
30 	{
31 	   return dec;
32 	}
33 	
34 	function totalSupply() public view returns (uint256)
35 	{
36 		return thetotal;
37 	}
38 	
39 	function balanceOf(address _owner) public view returns (uint256 balance)
40 	{
41 	    return balances[_owner];
42 	}
43 	
44 	function transfer(address _to, uint256 _value) public returns (bool success)
45 	{
46 	    require(_value > 0 &&_value < 210000000000000000);
47 		require(balances[msg.sender] >= _value);
48 		
49 		uint256 oldtotal= add(balances[msg.sender],balances[_to]);
50 		balances[msg.sender] = sub(balances[msg.sender],_value);
51 		balances[_to] = add(balances[_to] ,_value);
52 		require(balances[_to] + balances[msg.sender] == oldtotal);
53 		emit Transfer(msg.sender, _to, _value);
54 		return true;
55 	}
56 	
57 	
58 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
59 	{
60 		require(_value > 0 &&_value < 210000000000000000);
61 		require(balances[_from] >= _value);
62 		if(msg.sender != manager)
63 		{
64 			require(allowed[_from][msg.sender] >= _value);
65 			allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_value);
66 		}
67 	
68 		uint256 oldtotal= add(balances[_from],balances[_to]);
69 		balances[_from] = sub(balances[_from],_value);	
70 		balances[_to] = add(balances[_to],_value);
71 		require(balances[_from] + balances[_to] == oldtotal);
72 		emit Transfer(_from, _to, _value);
73 		return true;
74 	}
75 	
76 	function approve(address _spender, uint256 _value) public returns (bool success)
77 	{
78         require(_value > 0 &&_value < 210000000000000000);
79 		require(balances[msg.sender] >= _value);
80         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender],_value);
81         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
82         return true;
83 	}
84 	
85 	function allowance(address _owner, address _spender) public view returns (uint256 remaining)
86 	{
87 	    return allowed[_owner][_spender];
88 	}
89 	
90 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
91 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92 	
93 	
94 	
95 	function batch(address []fromaddr, address []toAddr, uint256 []value) public returns (bool)
96 	{
97 		require(msg.sender == manager);
98 		require(toAddr.length == value.length && fromaddr.length==toAddr.length && toAddr.length >= 1);
99 		for(uint256 i = 0 ; i < toAddr.length; i++){
100 			if(!transferFrom(fromaddr[i], toAddr[i], value[i])) 
101 			   {  revert(); }
102 		}
103 	}
104 
105 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b);
112 
113         return c;
114     }
115 	
116 	 function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 	
125 	 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b <= a);
127         uint256 c = a - b;
128 
129         return c;
130     }
131 	
132 	 function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a);
135 
136         return c;
137     }
138 	
139 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b != 0);
141         return a % b;
142     }
143 }