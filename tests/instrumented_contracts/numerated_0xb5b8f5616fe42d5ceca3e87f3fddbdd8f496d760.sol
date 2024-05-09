1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5 /**
6  * @dev Multiplies two numbers, throws on overflow.
7  */
8 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9 		if (a == 0) {
10 			return 0;
11 		}
12 		c = a * b;
13 		assert(c / a == b);
14 		return c;
15 	}
16 
17 /**
18  * @dev Integer division of two numbers, truncating the quotient.
19  */
20 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
21 		// assert(b > 0); // Solidity automatically throws when dividing by 0
22 		// uint256 c = a / b;
23 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
24 		return a / b;
25 	}
26 
27 /**
28  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29  */
30 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31 		assert(b <= a);
32 		return a - b;
33 	}
34 
35 /**
36  * @dev Adds two numbers, throws on overflow.
37  */
38 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39 		c = a + b;
40 		assert(c >= a);
41 		return c;
42 	}
43 }
44 
45 contract ZperToken {
46 	using SafeMath for uint256;
47 
48 	address public owner;
49 	uint256 public totalSupply;
50 	uint256 public cap;
51 	string public constant name = "ZperToken";
52 	string public constant symbol = "ZPR";
53 	uint8 public constant decimals = 18;
54 
55 
56 	mapping (address => uint256) public balances;
57 	mapping (address => mapping (address => uint256)) public allowed;
58 
59 	event Mint(address indexed to, uint256 amount);
60 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
61 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 	event Burn(address indexed burner, uint256 value);
64 
65 	function ZperToken (address _owner, uint256 _totalSupply, uint256 _cap) public {
66 		require(_owner != address(0));
67 		require(_cap > _totalSupply && _totalSupply > 0);
68 		
69 		totalSupply = _totalSupply * (10 ** 18);
70 		cap = _cap * (10 ** 18);
71 		owner = _owner;
72 
73 		balances[owner] = totalSupply;
74 	}
75 
76 	modifier onlyOwner() {
77 		require(msg.sender == owner);
78 		_;
79 	}
80 
81 	function transferOwnership(address newOwner) onlyOwner public {
82 		require(newOwner != address(0));
83 		owner = newOwner;
84 		emit OwnershipTransferred(owner, newOwner);
85 	}
86 
87 	function transfer(address _to, uint256 _value) public returns (bool success) {
88 		require(_to != address(0));
89 		require(balances[msg.sender] >= _value);
90 
91 		balances[msg.sender] = balances[msg.sender].sub(_value);
92 		balances[_to] = balances[_to].add(_value);
93 		
94 		emit Transfer(msg.sender, _to, _value);
95 		return true;
96 	}
97 
98 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99 		require(_to != address(0));
100 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
101 
102 		balances[_from] = balances[_from].sub(_value);
103 		balances[_to] = balances[_to].add(_value);
104 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105 
106 		emit Transfer(_from, _to, _value);
107 		return true;
108 	}
109 
110 	function balanceOf(address _owner) public constant returns (uint256 balance) {
111 		return balances[_owner];
112 	}
113 
114 	function approve(address _spender, uint256 _value) public returns (bool success) {
115 		allowed[msg.sender][_spender] = _value;
116 
117 		emit Approval(msg.sender, _spender, _value);
118 		return true;
119 	}
120 
121 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
122 		return allowed[_owner][_spender];
123 	}
124 
125 	function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
126 		require(_to != address(0));
127 		require(cap >= totalSupply.add(_amount));
128 
129 		totalSupply = totalSupply.add(_amount);
130 		balances[_to] = balances[_to].add(_amount);
131 
132 		emit Mint(_to, _amount);
133 		emit Transfer(address(0), _to, _amount);
134 
135 		return true;
136 	}
137 
138 	function burn(uint256 _value) public returns (bool) {
139 		require(_value <= balances[msg.sender]);
140 
141 		balances[msg.sender] = balances[msg.sender].sub(_value);
142 		totalSupply = totalSupply.sub(_value);
143 
144 		emit Burn(msg.sender, _value);
145 		emit Transfer(msg.sender, address(0), _value);
146 
147 		return true;
148 	}
149 
150 	function batchTransfer(address[] _tos, uint256[] _amount) onlyOwner public returns (bool success) {
151 		require(_tos.length == _amount.length);
152 		uint256 i;
153 		uint256 sum = 0;
154 
155 		for(i = 0; i < _amount.length; i++) {
156 			sum = sum.add(_amount[i]);
157 			require(_tos[i] != address(0));
158 		}
159 
160 		require(balances[msg.sender] >= sum);
161 
162 		for(i = 0; i < _tos.length; i++)
163 			transfer(_tos[i], _amount[i]);
164 
165 		return true;
166 	}
167 }