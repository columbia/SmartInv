1 pragma solidity ^0.4.10;
2 
3 
4 contract Nigger
5 {
6 
7 
8 	address 	owner;
9 
10 
11     string 		public standard = 'Token 0.1';
12 	string 		public name = "Nigger"; 
13 	string 		public symbol = "NGR";
14 	uint8 		public decimals = 18; 
15 	uint256 	public totalSupply = 40695277 * 1e18;
16 	
17 
18 	mapping (address => uint256) balances;	
19 	mapping (address => mapping (address => uint256)) allowed;
20 
21 
22 	modifier ownerOnly() 
23 	{
24 		require(msg.sender == owner);
25 		_;
26 	}		
27 
28 
29 	function changeName(string _name) public ownerOnly returns(bool success) 
30 	{
31 
32 		name = _name;
33 		NameChange(name);
34 
35 		return true;
36 	}
37 
38 
39 	function changeSymbol(string _symbol) public ownerOnly returns(bool success) 
40 	{
41 
42 		symbol = _symbol;
43 		SymbolChange(symbol);
44 
45 		return true;
46 	}
47 
48 
49     function balanceOf(address _owner) public constant returns(uint256 tokens) 
50 	{
51 
52 		require(_owner != 0x0);
53 		return balances[_owner];
54 	}
55 
56 
57 	function balanceOfReadable(address _owner) public constant returns(uint256 tokens) 
58 	{
59 
60 		require(_owner != 0x0);
61 		return balances[_owner] / 1e18;
62 	}
63 	
64 
65     function transfer(address _to, uint256 _value) public returns(bool success)
66 	{ 
67 
68 		require(_to != 0x0 && _value > 0 && balances[msg.sender] >= _value && _to != msg.sender);
69 
70 
71 		balances[msg.sender] -= _value;
72 		balances[_to] += _value;
73 		Transfer(msg.sender, _to, _value);
74 
75 		return true;
76 	}
77 
78 
79    function burn(uint256 _value) public returns(bool success)
80 	{
81 
82 		require(balances[msg.sender] >= _value && _value > 0);
83 
84 
85 		balances[msg.sender] -= _value;
86 		totalSupply -= _value;
87 		Burn(msg.sender, _value);
88 
89 		return true;
90 	}
91 
92 
93 	function canTransferFrom(address _owner, address _spender) public constant returns(uint256 tokens) 
94 	{
95 
96 		require(_owner != 0x0 && _spender != 0x0);
97 		
98 
99 		if (_owner == _spender)
100 		{
101 			return balances[_owner];
102 		}
103 		else 
104 		{
105 			return allowed[_owner][_spender];
106 		}
107 	}
108 
109 	
110 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) 
111 	{
112 
113         require(_value > 0 && _from != 0x0 && _to != 0x0 && _to != _from &&
114         		allowed[_from][msg.sender] >= _value && 
115         		balances[_from] >= _value);
116                 
117 
118         balances[_from] -= _value;
119         allowed[_from][msg.sender] -= _value;
120         balances[_to] += _value;	
121         Transfer(_from, _to, _value);
122 
123         return true;
124     }
125 
126     
127     function approve(address _spender, uint256 _value) public returns(bool success)  
128     {
129 
130         require(_spender != 0x0 && _spender != msg.sender);
131 
132 
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135 
136         return true;
137     }
138 
139 
140     function Nigger() public
141 	{
142 		owner = msg.sender;
143 		balances[owner] = totalSupply;
144 		TokenDeployed(totalSupply);
145 	}
146 
147 
148 	// ====================================================================================
149 	//
150     // List of all events
151 
152     event NameChange(string _name);
153     event SymbolChange(string _symbol);
154 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
155 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
156 	event Burn(address indexed _from, uint256 _value);
157 	event TokenDeployed(uint256 _totalSupply);
158 
159 }