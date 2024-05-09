1 pragma solidity ^0.4.10;
2 
3 
4 contract CryptAI
5 {
6 
7 
8     string 		public standard = 'Token 0.1';
9 	string 		public name = "CryptAI"; 
10 	string 		public symbol = "TAI";
11 	uint8 		public decimals = 2; 
12 	uint256 	public totalSupply = 7000000 * 1e2;
13 	
14 
15 	mapping (address => uint256) balances;	
16 	mapping (address => mapping (address => uint256)) allowed;
17 
18 
19     // Use it to get your real TAI balance
20     // ____________________________________________________________________________________
21 	function balanceOf(address _owner) public constant returns(uint256 tokens) 
22 	{
23 
24 		require(_owner != 0x0);
25 		return balances[_owner];
26 	}
27 
28 
29 	// Use it to get your current TAI balance in readable format (the value will be rounded)
30     // ____________________________________________________________________________________
31 	function balanceOfReadable(address _owner) public constant returns(uint256 tokens) 
32 	{
33 
34 		require(_owner != 0x0);
35 		return balances[_owner] / 1e2;
36 	}
37 	
38 
39     // Use it to transfer TAI to another address
40     // ____________________________________________________________________________________
41 	function transfer(address _to, uint256 _value) public returns(bool success)
42 	{ 
43 
44 		require(_to != 0x0 && _value > 0 && balances[msg.sender] >= _value);
45 
46 
47 		balances[msg.sender] -= _value;
48 		balances[_to] += _value;
49 		emit Transfer(msg.sender, _to, _value);
50 
51 		return true;
52 	}
53 
54 
55 	// How much someone allows you to transfer from his/her address
56     // ____________________________________________________________________________________
57 	function canTransferFrom(address _owner, address _spender) public constant returns(uint256 tokens) 
58 	{
59 
60 		require(_owner != 0x0 && _spender != 0x0);
61 		
62 
63 		if (_owner == _spender)
64 		{
65 			return balances[_owner];
66 		}
67 		else 
68 		{
69 			return allowed[_owner][_spender];
70 		}
71 	}
72 
73 	
74 	// Transfer allowed amount of TAI tokens from another address
75     // ____________________________________________________________________________________
76 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) 
77 	{
78 
79         require(_value > 0 && _from != 0x0 && _to != 0x0 &&
80         		allowed[_from][msg.sender] >= _value && 
81         		balances[_from] >= _value);
82                 
83 
84         balances[_from] -= _value;
85         allowed[_from][msg.sender] -= _value;
86         balances[_to] += _value;	
87         emit Transfer(_from, _to, _value);
88 
89         return true;
90     }
91 
92     
93     // Allow someone transfer TAI tokens from your address
94     // ____________________________________________________________________________________
95     function approve(address _spender, uint256 _value) public returns(bool success)  
96     {
97 
98         require(_spender != 0x0 && _spender != msg.sender);
99 
100         allowed[msg.sender][_spender] = _value;
101         emit Approval(msg.sender, _spender, _value);
102 
103         return true;
104     }
105 
106 
107     // Token constructor
108     // ____________________________________________________________________________________
109 	constructor() public
110 	{
111 		balances[msg.sender] = totalSupply;
112 		emit TokenDeployed(totalSupply);
113 	}
114 
115 
116 	// ====================================================================================
117 	//
118     // List of all events
119 
120 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
121 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
122 	event TokenDeployed(uint256 _totalSupply);
123 
124 }