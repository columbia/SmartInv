1 pragma solidity ^0.4.11;
2 
3 
4 contract SafeMath{
5   function safeMul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 	
18 	function safeSub(uint a, uint b) internal returns (uint) {
19     	assert(b <= a);
20     	return a - b;
21   }
22 
23 	function safeAdd(uint a, uint b) internal returns (uint) {
24     	uint c = a + b;
25     	assert(c >= a);
26     	return c;
27   }
28 	function assert(bool assertion) internal {
29 	    if (!assertion) {
30 	      throw;
31 	    }
32 	}
33 }
34 
35 
36 contract ERC20{
37 
38 	event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
39 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41 }
42 
43 contract kkTestCoin1 is ERC20, SafeMath{
44 	
45 	mapping(address => uint256) balances;
46 
47 	uint256 public totalSupply;
48 
49 
50 	function balanceOf(address _owner) constant returns (uint256 balance) {
51 	    return balances[_owner];
52 	}
53 
54 	function transfer(address _to, uint256 _value) returns (bool success){
55 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
56 	    balances[_to] = safeAdd(balances[_to], _value);
57 	    Transfer(msg.sender, _to, _value);
58 	    return true;
59 	}
60 
61 	mapping (address => mapping (address => uint256)) allowed;
62 
63 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
64 	    var _allowance = allowed[_from][msg.sender];
65 	    
66 	    balances[_to] = safeAdd(balances[_to], _value);
67 	    balances[_from] = safeSub(balances[_from], _value);
68 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
69 	    Transfer(_from, _to, _value);
70 	    return true;
71 	}
72 
73 	function approve(address _spender, uint256 _value) returns (bool success) {
74 	    allowed[msg.sender][_spender] = _value;
75 	    Approval(msg.sender, _spender, _value);
76 	    return true;
77 	}
78 
79 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
80 	    return allowed[_owner][_spender];
81 	}
82 	string 	public name = "kkTestCoin2";
83 	string 	public symbol = "KTC2";
84 	uint 	public decimals = 0;
85 	uint 	public INITIAL_SUPPLY = 30000000;
86 
87 	function kkTestCoin1() {
88 	  totalSupply = INITIAL_SUPPLY;
89 	  balances[msg.sender] = INITIAL_SUPPLY;  // Give all of the initial tokens to the contract deployer.
90 	}
91 }
92 
93 
94 
95 
96 contract kkTestICO1 is ERC20, SafeMath{
97 
98 	
99 	mapping(address => uint256) balances;
100 
101 	uint256 public totalSupply;
102 
103 
104 	function balanceOf(address _owner) constant returns (uint256 balance) {
105 	    return balances[_owner];
106 	}
107 
108 	function transfer(address _to, uint256 _value) returns (bool success){
109 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
110 	    balances[_to] = safeAdd(balances[_to], _value);
111 	    Transfer(msg.sender, _to, _value);
112 	    return true;
113 	}
114 
115 	mapping (address => mapping (address => uint256)) allowed;
116 
117 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
118 	    var _allowance = allowed[_from][msg.sender];
119 	    
120 	    balances[_to] = safeAdd(balances[_to], _value);
121 	    balances[_from] = safeSub(balances[_from], _value);
122 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
123 	    Transfer(_from, _to, _value);
124 	    return true;
125 	}
126 
127 	function approve(address _spender, uint256 _value) returns (bool success) {
128 	    allowed[msg.sender][_spender] = _value;
129 	    Approval(msg.sender, _spender, _value);
130 	    return true;
131 	}
132 
133 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
134 	    return allowed[_owner][_spender];
135 	}
136 
137 
138 
139 
140 	uint256 public endTime;
141 
142 	modifier during_offering_time(){
143 		if (now >= endTime){
144 			throw;
145 		}else{
146 			_;
147 		}
148 	}
149 
150 	function () payable during_offering_time {
151 		createTokens(msg.sender);
152 	}
153 
154 	function createTokens(address recipient) payable {
155 		if (msg.value == 0) {
156 		  throw;
157 		}
158 
159 		uint tokens = safeDiv(safeMul(msg.value, price), 1 ether);
160 		totalSupply = safeAdd(totalSupply, tokens);
161 
162 		balances[recipient] = safeAdd(balances[recipient], tokens);
163 
164 		if (!owner.send(msg.value)) {
165 		  throw;
166 		}
167 	}
168 
169 
170 
171 
172 	string 	public name = "kkTestCoin1";
173 	string 	public symbol = "KTC1";
174 	uint 	public decimals = 0;
175 	uint256 public INITIAL_SUPPLY = 25000000;
176 	uint256 public price;
177 	address public owner;
178 
179 	function kkTestICO1() {
180 		totalSupply = INITIAL_SUPPLY;
181 		balances[msg.sender] = INITIAL_SUPPLY;  // Give all of the initial tokens to the contract deployer.
182 		endTime = now + 1 weeks;
183 		owner 	= msg.sender;
184 		price 	= 5000;
185 	}
186 
187 }