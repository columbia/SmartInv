1 pragma solidity 0.4.11;
2 
3 
4 
5 
6 contract ERC20Interface {
7 	uint256 public totalSupply;
8 	function balanceOf(address _owner) public constant returns (uint balance); // Get the account balance of another account with address _owner
9 	function transfer(address _to, uint256 _value) public returns (bool success); // Send _value amount of tokens to address _to
10 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success); // Send _value amount of tokens from address _from to address _to
11 	function approve(address _spender, uint256 _value) public returns (bool success);
12 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining); // Returns the amount which _spender is still allowed to withdraw from _owner
13 	event Transfer(address indexed _from, address indexed _to, uint256 _value); // Triggered when tokens are transferred.
14 	event Approval(address indexed _owner, address indexed _spender, uint256 _value); // Triggered whenever approve(address _spender, uint256 _value) is called.
15 }
16 
17 
18 
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26 		uint256 c = a * b;
27 		assert(a == 0 || c / a == b);
28 		return c;
29 	}
30 
31 
32 
33 
34 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
35 		// assert(b > 0); // Solidity automatically throws when dividing by 0
36 		uint256 c = a / b;
37 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 		return c;
39 	}
40 
41 
42 
43 
44 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
45 		assert(b <= a);
46 		return a - b;
47 	}
48 
49 
50 
51 
52 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
53 		uint256 c = a + b;
54 		assert(c >= a);
55 		return c;
56 	}
57 }
58 contract ERC20Token is ERC20Interface {
59 	using SafeMath for uint256;
60 
61 
62 
63 
64 	mapping (address => uint) balances;
65 	mapping (address => mapping (address => uint256)) allowed;
66 
67 
68 
69 
70 	modifier onlyPayloadSize(uint size) {
71 		require(msg.data.length >= (size + 4));
72 		_;
73 	}
74 
75 
76 
77 
78 	function () public{
79 		revert();
80 	}
81 
82 
83 
84 
85 	function balanceOf(address _owner) public constant returns (uint balance) {
86 		return balances[_owner];
87 	}
88 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
89 		return allowed[_owner][_spender];
90 	}
91 
92 
93 
94 
95 	function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool success) {
96 		_transferFrom(msg.sender, _to, _value);
97 		return true;
98 	}
99 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
100 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101 		_transferFrom(_from, _to, _value);
102 		return true;
103 	}
104 	function _transferFrom(address _from, address _to, uint256 _value) internal {
105 		require(_value > 0);
106 		balances[_from] = balances[_from].sub(_value);
107 		balances[_to] = balances[_to].add(_value);
108 		Transfer(_from, _to, _value);
109 	}
110 
111 
112 
113 
114 	function approve(address _spender, uint256 _value) public returns (bool) {
115 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
116 		allowed[msg.sender][_spender] = _value;
117 		Approval(msg.sender, _spender, _value);
118 		return true;
119 	}
120 }
121 
122 
123 
124 
125 contract owned {
126 	address public owner;
127 
128 
129 
130 
131 	function owned() public {
132 		owner = msg.sender;
133 	}
134 
135 
136 
137 
138 	modifier onlyOwner {
139 		if (msg.sender != owner) revert();
140 		_;
141 	}
142 
143 
144 
145 
146 	function transferOwnership(address newOwner) public onlyOwner {
147 		owner = newOwner;
148 	}
149 }
150 
151 
152 
153 
154 
155 
156 
157 
158 contract RFToken is ERC20Token, owned{
159 	using SafeMath for uint256;
160 
161 
162 
163 
164 	string public name = 'RF Token';
165 	string public symbol = 'RF';
166 	uint8 public decimals = 8;
167 	uint256 public totalSupply = 8625000000000000;//86250000 * 10^8
168 
169 
170 
171 
172 	function RFToken() public {
173 		balances[this] = totalSupply;
174 	}
175 
176 
177 
178 
179 	function setTokens(address target, uint256 _value) public onlyOwner {
180 		balances[this] = balances[this].sub(_value);
181 		balances[target] = balances[target].add(_value);
182 		Transfer(this, target, _value);
183 	}
184 
185 
186 
187 
188 	function burnBalance() public onlyOwner {
189 		totalSupply = totalSupply.sub(balances[this]);
190 		Transfer(this, address(0), balances[this]);
191 		balances[this] = 0;
192 	}
193 }