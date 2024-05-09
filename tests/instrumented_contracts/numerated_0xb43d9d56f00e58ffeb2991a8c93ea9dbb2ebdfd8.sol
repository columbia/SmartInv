1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 
9 		uint256 c = a * b;
10 		assert(c / a == b);
11 
12 		return c;
13 	}
14 
15 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 		uint256 c = a / b;
17 		return c;
18 	}
19 
20 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21 		assert(b <= a);
22 
23 		return a - b;
24 	}
25 
26 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
27 		uint256 c = a + b;
28 		assert(c >= a);
29 
30 		return c;
31 	}
32 }
33 
34 
35 interface ERC20Interface {
36     function totalSupply() public constant returns (uint256 total);
37     function balanceOf(address _owner) public constant returns (uint256 balance);
38     function transfer(address _to, uint256 _value) public returns (bool success);
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40     function approve(address _spender, uint256 _value) public returns (bool success);
41     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 
47 
48 
49 
50 contract BlabberToken is ERC20Interface {
51 
52 	using SafeMath for uint256;
53 
54 	uint public _totalSupply = 1250000000000000000000000000;
55 
56 	bool public isLocked = true;
57 	string public constant symbol = "BLA";
58 	string public constant name = "BLABBER Token";
59 	uint8 public constant decimals = 18;
60 
61 	address public tokenHolder = 0xB6ED8e4b27928009c407E298C475F937054AE19D;
62 
63 	mapping(address => uint256) balances;
64 	mapping(address => mapping(address => uint256)) allowed;
65 
66 	modifier onlyAdmin{
67 		require(msg.sender == 0x36Aa9a6E0595adfF3C42A23415758a1123381C23);
68 		_;
69 	}
70 
71 	function unlockTokens() public onlyAdmin {
72 		isLocked = false;
73 	}
74 
75 	constructor() public {
76 		balances[tokenHolder] = _totalSupply;
77 	}
78 
79 	function totalSupply() public constant returns (uint256 total) {
80 		return _totalSupply;
81 	}
82 
83 	function balanceOf(address _owner) public constant returns (uint256 balance) {
84 		return balances[_owner];
85 	}
86 
87 	function transfer(address _to, uint256 _value) public returns (bool success) {
88 		require(
89 			balances[msg.sender] >= _value
90 			&& _value > 0
91 		);
92 
93 		require(!isLocked || (msg.sender == tokenHolder));
94 
95 		balances[msg.sender] = balances[msg.sender].sub(_value);
96 		balances[_to] = balances[_to].add(_value);
97 
98 		emit Transfer(msg.sender, _to, _value);
99 
100 		return true;
101 	}
102 
103 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104 		require(
105 			allowed[_from][msg.sender] >= _value
106 			&& balances[_from] >= _value
107 			&& _value > 0
108 		);
109 
110 		require(!isLocked || (msg.sender == tokenHolder));
111 
112 		balances[_from] = balances[_from].sub(_value);
113 		balances[_to] = balances[_to].add(_value);
114 
115 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116 
117 		emit Transfer(_from, _to, _value);
118 
119 		return true;
120 	}
121 
122 	function approve(address _spender, uint256 _value) public returns (bool success) {
123 		allowed[msg.sender][_spender] = _value;
124 		emit Approval(msg.sender, _spender, _value);
125 
126 		return true;
127 	}
128 
129 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
130 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
131 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132 
133 		return true;
134 	}
135 
136 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
137 		uint oldValue = allowed[msg.sender][_spender];
138 
139 		if (_subtractedValue > oldValue) {
140 			allowed[msg.sender][_spender] = 0;
141 		} else {
142 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143 		}
144 
145 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146 
147 		return true;
148 	}
149 
150 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
151 		return allowed[_owner][_spender];
152 	}
153 
154 	function burn(uint256 _value) public {
155 		require(_value <= balances[msg.sender]);
156 
157 		require(msg.sender == tokenHolder);
158 
159 		address burner = msg.sender;
160 		balances[burner] = balances[burner].sub(_value);
161 		_totalSupply = _totalSupply.sub(_value);
162 		emit Burn(burner, _value);
163 	}
164 
165 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
166 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
167 	event Burn(address indexed burner, uint256 value);
168 }