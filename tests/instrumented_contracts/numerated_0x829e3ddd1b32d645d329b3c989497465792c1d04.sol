1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a / b;
11     return c;
12   }
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17   function add(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a + b;
19     assert(c >= a && c >= b);
20     return c;
21   }
22 
23   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
24     return a >= b ? a : b;
25   }
26 
27   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
28     return a < b ? a : b;
29   }
30 
31   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
32     return a >= b ? a : b;
33   }
34 
35   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
36     return a < b ? a : b;
37   }
38 
39 
40 }
41 
42 
43 
44 
45 contract owned { //Contract used to only allow the owner to call some functions
46 	address public owner;
47 
48 	function owned() public {
49 	owner = msg.sender;
50 	}
51 
52 	modifier onlyOwner {
53 	require(msg.sender == owner);
54 	_;
55 	}
56 
57 	function transferOwnership(address newOwner) onlyOwner public {
58 	owner = newOwner;
59 	}
60 }
61 
62 
63 contract TokenERC20 {
64 
65 	using SafeMath for uint256;
66 	// Public variables of the token
67 	string public name;
68 	string public symbol;
69 	uint8 public decimals = 8;
70 	uint256 public totalSupply;
71 
72 
73 	// This creates an array with all balances
74 	mapping (address => uint256) public balanceOf;
75 	mapping (address => mapping (address => uint256)) public allowance;
76 
77 	// This generates a public event on the blockchain that will notify clients
78 	event Transfer(address indexed from, address indexed to, uint256 value);
79 
80 	// This notifies clients about the amount burnt
81 	event Burn(address indexed from, uint256 value);
82 
83 
84 	function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
85 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
86 		name = tokenName;                                   // Set the name for display purposes
87 		symbol = tokenSymbol;                               // Set the symbol for display purposes
88 	}
89 
90 
91 	function _transfer(address _from, address _to, uint _value) internal {
92 		// Prevent transfer to 0x0 address. Use burn() instead
93 		require(_to != 0x0);
94 		// Check for overflows
95 		// Save this for an assertion in the future
96 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
97 		// Subtract from the sender
98 		balanceOf[_from] = balanceOf[_from].sub(_value);
99 		// Add the same to the recipient
100 		balanceOf[_to] = balanceOf[_to].add(_value);
101 		emit Transfer(_from, _to, _value);
102 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
103 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
104 	}
105 
106 
107 	function transfer(address _to, uint256 _value) public {
108 		_transfer(msg.sender, _to, _value);
109 	}
110 
111 
112 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
113 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
114 		_transfer(_from, _to, _value);
115 		return true;
116 	}
117 
118 
119 	function approve(address _spender, uint256 _value) public returns (bool success) {
120 		allowance[msg.sender][_spender] = _value;
121 		return true;
122 	}
123 
124 
125 	function burn(uint256 _value) public returns (bool success) {
126 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
127 		totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
128 		emit Burn(msg.sender, _value);
129 		return true;
130 	}
131 
132 
133 
134 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
135 		balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
136 		allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
137 		totalSupply = totalSupply.sub(_value);                              // Update totalSupply
138 		emit Burn(_from, _value);
139 		return true;
140 	}
141 
142 
143 }
144 
145 /******************************************/
146 /*       TORCToken STARTS HERE       */
147 /******************************************/
148 
149 contract TORCToken is owned, TokenERC20  {
150 
151 	//Modify these variables
152 	uint256 _initialSupply=5000000000; 
153 	string _tokenName="TORC";
154 	string _tokenSymbol="Torchain";
155 	address public lockedWallet = 0x731b7Ee0f5122535f7dA63887d78E0C202f6a082;
156 	uint256 public startTime;
157 
158 	mapping (address => bool) public frozenAccount;
159 
160 	/* This generates a public event on the blockchain that will notify clients */
161 	event FrozenFunds(address target, bool frozen);
162 
163 	/* Initializes contract with initial supply tokens to the creator of the contract */
164 	function TORCToken( ) TokenERC20(_initialSupply, _tokenName, _tokenSymbol) public {
165 
166 		startTime = now;
167 
168 		balanceOf[lockedWallet] = totalSupply;
169 	}
170 
171 	function _transfer(address _from, address _to, uint _value) internal {
172 		require(_to != 0x0);
173 
174 		bool lockedBalance = checkLockedBalance(_from,_value);
175 		require(lockedBalance);
176 
177 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
178 		balanceOf[_from] = balanceOf[_from].sub(_value);
179 		balanceOf[_to] = balanceOf[_to].add(_value);
180 		emit Transfer(_from, _to, _value);
181 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
182 	}
183 
184 	function checkLockedBalance(address wallet, uint256 _value) internal returns (bool){
185 		if(wallet==lockedWallet){
186 			
187 			if(now<startTime + 365 * 1 days){ //15% tokens locked first year
188 				return balanceOf[lockedWallet].sub(_value)>=totalSupply.mul(15).div(100)? true : false;
189 			}else{ 
190 				return true;
191 			}
192 
193 		}else{
194 			return true;
195 		}
196 	}
197 
198 
199 }