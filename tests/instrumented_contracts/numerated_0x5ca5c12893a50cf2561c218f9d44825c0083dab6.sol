1 pragma solidity ^0.4.18;
2 
3 interface IERC20 {
4 	function TotalSupply() constant returns (uint totalSupply);
5 	function balanceOf(address _owner) constant returns (uint balance);
6 	function transfer(address _to, uint _value) returns (bool success);
7 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
8 	function approve(address _spender, uint _value) returns (bool success);
9 	function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 library SafeMath {
15 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16 		uint256 c = a * b;
17 		assert(a == 0 || c / a == b);
18 		return c;
19 	}
20 
21 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
22 		uint256 c = a / b;
23 		return c;
24 	}
25 
26 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
27 		assert(b <= a);
28 		return a - b;
29 	}
30 
31 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
32 		uint256 c = a + b;
33 		assert(c >= a);
34 		return c;
35 	}
36 }
37 
38 
39 
40 contract ETHACE is IERC20{
41 	using SafeMath for uint256;
42 
43 	uint256 public _totalSupply = 0;
44 
45 	bool public purchasingAllowed = true;
46 	bool public bonusAllowed = true;	
47 
48 	string public symbol = "ETA";
49 	string public constant name = "ETHACE";
50 	uint256 public constant decimals = 18;
51 
52 	uint256 public CREATOR_TOKEN = 20000000 * 10**decimals;
53 	uint256 public constant RATE = 1000;
54 	uint PERC_BONUS = 30;	
55 	
56 	address public owner;
57 
58 	mapping(address => uint256) balances;
59 	mapping(address => mapping(address => uint256)) allowed;
60 
61 	function() payable{
62 		require(purchasingAllowed);		
63 		createTokens();
64 	}
65    
66 	function ETHACE(){
67 		owner = msg.sender;
68 		balances[msg.sender] = CREATOR_TOKEN;
69 	}
70    
71 	function createTokens() payable{
72 		require(msg.value >= 0);
73 		uint256 tokens = msg.value.mul(10 ** decimals);
74 		tokens = tokens.mul(RATE);
75 		tokens = tokens.div(10 ** 18);
76 		if (bonusAllowed)
77 		{
78 			tokens += tokens.mul(PERC_BONUS).div(100);
79 		}
80 		uint256 sum = _totalSupply.add(tokens);		
81 		balances[msg.sender] = balances[msg.sender].add(tokens);
82 		balances[owner] = balances[owner].sub(tokens);
83 		_totalSupply = sum;
84 		owner.transfer(msg.value);
85 		Transfer(owner, msg.sender, tokens);
86 	}
87    
88 	function TotalSupply() constant returns (uint totalSupply){
89 		return _totalSupply;
90 	}
91    
92 	function balanceOf(address _owner) constant returns (uint balance){
93 		return balances[_owner];
94 	}
95 	
96 	function enablePurchasing() {
97 		require(msg.sender == owner); 
98 		purchasingAllowed = true;
99 	}
100 	
101 	function disablePurchasing() {
102 		require(msg.sender == owner);
103 		purchasingAllowed = false;
104 	}   
105 	
106 	function enableBonus() {
107 		require(msg.sender == owner); 
108 		bonusAllowed = true;
109 	}
110 	
111 	function disableBonus() {
112 		require(msg.sender == owner);
113 		bonusAllowed = false;
114 	}   
115 
116 	function transfer(address _to, uint256 _value) returns (bool success){
117 		require(balances[msg.sender] >= _value	&& _value > 0);
118 		balances[msg.sender] = balances[msg.sender].sub(_value);
119 		balances[_to] = balances[_to].add(_value);
120 		Transfer(msg.sender, _to, _value);
121 		return true;
122 	}
123    
124 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
125 		require(allowed[_from][msg.sender] >= _value && balances[msg.sender] >= _value	&& _value > 0);
126 		balances[_from] = balances[_from].sub(_value);
127 		balances[_to] = balances[_to].add(_value);
128 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129 		Transfer(_from, _to, _value);
130 		return true;
131 	}
132    
133 	function approve(address _spender, uint256 _value) returns (bool success){
134 		allowed[msg.sender][_spender] = _value;
135 		Approval(msg.sender, _spender, _value);
136 		return true;
137 	}
138    
139 	function allowance(address _owner, address _spender) constant returns (uint remaining){
140 		return allowed[_owner][_spender];
141 	}
142 	
143 	function burnAll() public {		
144 		require(msg.sender == owner);
145 		address burner = msg.sender;
146 		uint256 total = balances[burner];
147 		total = 0;
148 		balances[burner] = total;
149 		if (_totalSupply >= total){
150 			_totalSupply = _totalSupply.sub(total);
151 		}
152 		Burn(burner, total);
153 	}
154 	
155 	function burn(uint256 _value) public {
156 		require(msg.sender == owner);
157         require(_value > 0);
158         require(_value <= balances[msg.sender]);
159 		_value = _value.mul(10 ** decimals);
160         address burner = msg.sender;
161 		uint t = balances[burner].sub(_value);
162         balances[burner] = balances[burner].sub(_value);
163         if (_totalSupply >= _value){
164 			_totalSupply = _totalSupply.sub(_value);
165 		}
166         Burn(burner, _value);
167 	}
168 		
169     function mintToken(uint256 _value) public {
170 		require(msg.sender == owner);
171         require(_value > 0);
172 		_value = _value.mul(10 ** decimals);
173         balances[owner] = balances[owner].add(_value);
174         _totalSupply = _totalSupply.add(_value);
175         Transfer(0, this, _value);
176     }
177 	
178 	event Transfer(address indexed _from, address indexed _to, uint _value);
179 	event Approval(address indexed _owner, address indexed _spender, uint _value);
180 	event Burn(address indexed burner, uint256 value);	   
181 }