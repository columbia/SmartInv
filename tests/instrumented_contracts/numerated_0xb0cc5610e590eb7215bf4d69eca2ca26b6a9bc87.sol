1 pragma solidity ^0.4.18;
2 
3 interface IERC20 {
4 	function totalSupply() constant returns (uint totalSupply);
5 	function balanceOf(address _owner) constant returns (uint balance);
6 	function transfer(address _to, uint _value) returns (bool success);
7 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
8 	function approve(address _spender, uint _value) returns (bool success);
9 	function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 /**
15 * @title SafeMath
16 * @dev Math operations with safety checks that throw on error
17 */
18 library SafeMath {
19 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20 		uint256 c = a * b;
21 		assert(a == 0 || c / a == b);
22 		return c;
23 	}
24 
25 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
26 		// assert(b > 0); // Solidity automatically throws when dividing by 0
27 		uint256 c = a / b;
28 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 		return c;
30 	}
31 
32 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33 		assert(b <= a);
34 		return a - b;
35 	}
36 
37 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
38 		uint256 c = a + b;
39 		assert(c >= a);
40 		return c;
41 	}
42 }
43 
44 
45 
46 contract ScudoCash is IERC20{
47 	using SafeMath for uint256;
48 
49 	uint256 private _totalSupply = 0;
50 
51 	bool public purchasingAllowed = true;
52 
53 	string public constant symbol = "SCUDO";
54 	string public constant name = "ScudoCash";
55 	uint256 public constant decimals = 18;
56 
57 	uint256 private CREATOR_TOKEN = 3100000000 * 10**decimals;
58 	uint256 private CREATOR_TOKEN_END = 465000000 * 10**decimals;
59 	uint256 private constant RATE = 100000;
60 
61 	address private owner;
62 
63 	mapping(address => uint256) balances;
64 	mapping(address => mapping(address => uint256)) allowed;
65 
66 	struct Buyer{
67 	    address to;
68 	    uint256 value;
69 	}
70 
71 	Buyer[] buyers;
72 
73 	modifier onlyOwner {
74 	    require(msg.sender == owner);
75 	    _;
76 	}
77 
78 	function() payable{
79 		require(purchasingAllowed);
80 		createTokens();
81 	}
82 
83 	function ScudoCash(){
84 		owner = msg.sender;
85 		balances[msg.sender] = CREATOR_TOKEN;
86 		_totalSupply = CREATOR_TOKEN;
87 	}
88 
89 	function createTokens() payable{
90 		require(msg.value >= 0);
91 		uint256 tokens = msg.value.mul(10 ** decimals);
92 		tokens = tokens.mul(RATE);
93 		tokens = tokens.div(10 ** 18);
94 
95 		uint256 sum2 = balances[owner].sub(tokens);
96 		require(sum2 >= CREATOR_TOKEN_END);
97 		//uint256 sum = _totalSupply.add(tokens);
98 		_totalSupply = sum2;
99 		owner.transfer(msg.value);
100 		balances[msg.sender] = balances[msg.sender].add(tokens);
101 		balances[owner] = balances[owner].sub(tokens);
102 		Transfer(msg.sender, owner, msg.value);
103 	}
104 
105 	function totalSupply() constant returns (uint totalSupply){
106 		return _totalSupply;
107 	}
108 
109 	function balanceOf(address _owner) constant returns (uint balance){
110 		return balances[_owner];
111 	}
112 
113 	function enablePurchasing() onlyOwner {
114 		purchasingAllowed = true;
115 	}
116 
117 	function disablePurchasing() onlyOwner {
118 		purchasingAllowed = false;
119 	}
120 
121 	function transfer(address _to, uint256 _value) returns (bool success){
122 		require(balances[msg.sender] >= _value	&& balances[_to] + _value > balances[_to]);
123 		balances[msg.sender] = balances[msg.sender].sub(_value);
124 		balances[_to] = balances[_to].add(_value);
125 		Transfer(msg.sender, _to, _value);
126 		return true;
127 	}
128 
129 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
130 		require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value	&& balances[_to] + _value > balances[_to]);
131 		balances[_from] = balances[_from].sub(_value);
132 		balances[_to] = balances[_to].add(_value);
133 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134 		Transfer(_from, _to, _value);
135 		return true;
136 	}
137 
138 	function approve(address _spender, uint256 _value) returns (bool success){
139 		allowed[msg.sender][_spender] = _value;
140 		Approval(msg.sender, _spender, _value);
141 		return true;
142 	}
143 
144 	function allowance(address _owner, address _spender) constant returns (uint remaining){
145 		return allowed[_owner][_spender];
146 	}
147 
148 	function burnAll() onlyOwner public {
149 		address burner = msg.sender;
150 		uint256 total = balances[burner];
151 		if (total > CREATOR_TOKEN_END) {
152 			total = total.sub(CREATOR_TOKEN_END);
153 			balances[burner] = balances[burner].sub(total);
154 			if (_totalSupply >= total){
155 				_totalSupply = _totalSupply.sub(total);
156 			}
157 			Burn(burner, total);
158 		}
159 	}
160 
161 	function burn(uint256 _value) onlyOwner public {
162         require(_value > 0);
163         require(_value <= balances[msg.sender]);
164 		_value = _value.mul(10 ** decimals);
165         address burner = msg.sender;
166 		uint t = balances[burner].sub(_value);
167 		require(t >= CREATOR_TOKEN_END);
168         balances[burner] = balances[burner].sub(_value);
169         if (_totalSupply >= _value){
170 			_totalSupply = _totalSupply.sub(_value);
171 		}
172         Burn(burner, _value);
173 	}
174 
175 	event Transfer(address indexed _from, address indexed _to, uint _value);
176 	event Approval(address indexed _owner, address indexed _spender, uint _value);
177 	event Burn(address indexed burner, uint256 value);
178 }