1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a && c >= b);
24     return c;
25   }
26 
27   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
28     return a >= b ? a : b;
29   }
30 
31   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
32     return a < b ? a : b;
33   }
34 
35   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
36     return a >= b ? a : b;
37   }
38 
39   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
40     return a < b ? a : b;
41   }
42 
43 
44 }
45 
46 
47 
48 
49 contract owned { //Contract used to only allow the owner to call some functions
50 	address public owner;
51 
52 	function owned() public {
53 	owner = msg.sender;
54 	}
55 
56 	modifier onlyOwner {
57 	require(msg.sender == owner);
58 	_;
59 	}
60 
61 	function transferOwnership(address newOwner) onlyOwner public {
62 	owner = newOwner;
63 	}
64 }
65 
66 
67 contract TokenERC20 {
68 
69 	using SafeMath for uint256;
70 	// Public variables of the token
71 	string public name;
72 	string public symbol;
73 	uint8 public decimals = 18;
74 	//
75 	uint256 public totalSupply;
76 
77 
78 	// This creates an array with all balances
79 	mapping (address => uint256) public balanceOf;
80 	mapping (address => mapping (address => uint256)) public allowance;
81 
82 	// This generates a public event on the blockchain that will notify clients
83 	event Transfer(address indexed from, address indexed to, uint256 value);
84 
85 	// This notifies clients about the amount burnt
86 	event Burn(address indexed from, uint256 value);
87 
88 
89 	function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
90 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
91 		name = tokenName;                                   // Set the name for display purposes
92 		symbol = tokenSymbol;                               // Set the symbol for display purposes
93 	}
94 
95 
96 	function _transfer(address _from, address _to, uint _value) internal {
97 		// Prevent transfer to 0x0 address. Use burn() instead
98 		require(_to != 0x0);
99 		// Check for overflows
100 		// Save this for an assertion in the future
101 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
102 		// Subtract from the sender
103 		balanceOf[_from] = balanceOf[_from].sub(_value);
104 		// Add the same to the recipient
105 		balanceOf[_to] = balanceOf[_to].add(_value);
106 		emit Transfer(_from, _to, _value);
107 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
108 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
109 	}
110 
111 
112 	function transfer(address _to, uint256 _value) public {
113 		_transfer(msg.sender, _to, _value);
114 	}
115 
116 
117 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
118 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
119 		_transfer(_from, _to, _value);
120 		return true;
121 	}
122 
123 
124 	function approve(address _spender, uint256 _value) public returns (bool success) {
125 		allowance[msg.sender][_spender] = _value;
126 		return true;
127 	}
128 
129 
130 	function burn(uint256 _value) public returns (bool success) {
131 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
132 		totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
133 		emit Burn(msg.sender, _value);
134 		return true;
135 	}
136 
137 
138 
139 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
140 		balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
141 		allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
142 		totalSupply = totalSupply.sub(_value);                              // Update totalSupply
143 		emit Burn(_from, _value);
144 		return true;
145 	}
146 
147 
148 }
149 
150 /******************************************/
151 /*       Token STARTS HERE       */
152 /******************************************/
153 
154 contract Token is owned, TokenERC20  {
155 
156 	//Modify these variables
157 	uint256 _initialSupply=420000000; 
158 	string _tokenName="testdist";  
159 	string _tokenSymbol="tsdt";
160 	address wallet1 = 0x8012Eb27b9F5Ac2b74A975a100F60d2403365871;
161 	uint256 public startTime;
162 
163 	mapping (address => bool) public frozenAccount;
164 
165 	/* Initializes contract with initial supply tokens to the creator of the contract */
166 	function Token( ) TokenERC20(_initialSupply, _tokenName, _tokenSymbol) public {
167 
168 		startTime = now;
169 
170 		balanceOf[wallet1] = totalSupply;
171 
172 	}
173 
174 	function _transfer(address _from, address _to, uint _value) internal {
175 		require(_to != 0x0);
176 
177 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
178 		balanceOf[_from] = balanceOf[_from].sub(_value);
179 		balanceOf[_to] = balanceOf[_to].add(_value);
180 		emit Transfer(_from, _to, _value);
181 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
182 	}
183 
184 
185 }