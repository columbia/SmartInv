1 pragma solidity ^0.4.24;
2 
3 // DijitalPara
4 // Appreciate The Difference
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a && c >= b);
23     return c;
24   }
25 
26   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
27     return a >= b ? a : b;
28   }
29 
30   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
31     return a < b ? a : b;
32   }
33 
34   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
35     return a >= b ? a : b;
36   }
37 
38   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
39     return a < b ? a : b;
40   }
41 
42 
43 }
44 
45 
46 
47 
48 contract owned { //Contract used to only allow the owner to call some functions
49 	address public owner;
50 
51 	function owned() public {
52 	owner = msg.sender;
53 	}
54 
55 	modifier onlyOwner {
56 	require(msg.sender == owner);
57 	_;
58 	}
59 
60 	function transferOwnership(address newOwner) onlyOwner public {
61 	owner = newOwner;
62 	}
63 }
64 
65 
66 contract TokenERC20 {
67 
68 	using SafeMath for uint256;
69 	// Public variables of the token
70 	string public name;
71 	string public symbol;
72 	uint8 public decimals = 8;
73 	//
74 	uint256 public totalSupply;
75 
76 
77 	// This creates an array with all balances
78 	mapping (address => uint256) public balanceOf;
79 	mapping (address => mapping (address => uint256)) public allowance;
80 
81 	// This generates a public event on the blockchain that will notify clients
82 	event Transfer(address indexed from, address indexed to, uint256 value);
83 
84 	// This notifies clients about the amount burnt
85 	event Burn(address indexed from, uint256 value);
86 
87 
88 	function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
89 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
90 		name = tokenName;                                   // Set the name for display purposes
91 		symbol = tokenSymbol;                               // Set the symbol for display purposes
92 	}
93 
94 
95 	function _transfer(address _from, address _to, uint _value) internal {
96 		// Prevent transfer to 0x0 address. Use burn() instead
97 		require(_to != 0x0);
98 		// Check for overflows
99 		// Save this for an assertion in the future
100 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
101 		// Subtract from the sender
102 		balanceOf[_from] = balanceOf[_from].sub(_value);
103 		// Add the same to the recipient
104 		balanceOf[_to] = balanceOf[_to].add(_value);
105 		emit Transfer(_from, _to, _value);
106 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
107 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
108 	}
109 
110 
111 	function transfer(address _to, uint256 _value) public {
112 		_transfer(msg.sender, _to, _value);
113 	}
114 
115 
116 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
118 		_transfer(_from, _to, _value);
119 		return true;
120 	}
121 
122 
123 	function approve(address _spender, uint256 _value) public returns (bool success) {
124 		allowance[msg.sender][_spender] = _value;
125 		return true;
126 	}
127 
128 
129 	function burn(uint256 _value) public returns (bool success) {
130 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
131 		totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
132 		emit Burn(msg.sender, _value);
133 		return true;
134 	}
135 
136 
137 
138 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
139 		balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
140 		allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
141 		totalSupply = totalSupply.sub(_value);                              // Update totalSupply
142 		emit Burn(_from, _value);
143 		return true;
144 	}
145 
146 
147 }
148 
149 /******************************************/
150 /*       DJPToken STARTS HERE       */
151 /******************************************/
152 
153 contract DJPToken is owned, TokenERC20  {
154 
155 	//Modify these variables
156 	uint256 _initialSupply=500000000; 
157 	string _tokenName="DijitalPara";
158 	string _tokenSymbol="DJP";
159 	address public lockedWallet = 0x3d41E1d1941957FB21c2d3503E59a69aa7990370;
160 	uint256 public startTime;
161 
162 	mapping (address => bool) public frozenAccount;
163 
164 	/* This generates a public event on the blockchain that will notify clients */
165 	event FrozenFunds(address target, bool frozen);
166 
167 	/* Initializes contract with initial supply tokens to the creator of the contract */
168 	function DJPToken( ) TokenERC20(_initialSupply, _tokenName, _tokenSymbol) public {
169 
170 		startTime = now;
171 
172 		balanceOf[lockedWallet] = totalSupply;
173 	}
174 
175 	function _transfer(address _from, address _to, uint _value) internal {
176 		require(_to != 0x0);
177 
178 		bool lockedBalance = checkLockedBalance(_from,_value);
179 		require(lockedBalance);
180 
181 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
182 		balanceOf[_from] = balanceOf[_from].sub(_value);
183 		balanceOf[_to] = balanceOf[_to].add(_value);
184 		emit Transfer(_from, _to, _value);
185 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
186 	}
187 
188 	function checkLockedBalance(address wallet, uint256 _value) internal returns (bool){
189 		if(wallet==lockedWallet){
190 			
191 			if(now<startTime + 365 * 1 days){ //15% tokens locked first year
192 				return balanceOf[lockedWallet].sub(_value)>=totalSupply.mul(15).div(100)? true : false;
193 			}else if(now>=startTime + 365 * 1 days && now<startTime + 730 * 1 days){ //13% tokens locked second year
194 				return balanceOf[lockedWallet].sub(_value)>=totalSupply.mul(13).div(100)? true : false;
195 			}else if(now>=startTime + 730 * 1 days && now<startTime + 1095 * 1 days){ //10% tokens locked third year
196 				return balanceOf[lockedWallet].sub(_value)>=totalSupply.mul(10).div(100)? true : false;	
197 			}else if(now>=startTime + 1095 * 1 days && now<startTime + 1460 * 1 days){ //6% tokens locked fourth year
198 				return balanceOf[lockedWallet].sub(_value)>=totalSupply.mul(6).div(100)? true : false;	
199 			}else{ //No tokens locked from the forth year on
200 				return true;
201 			}
202 
203 		}else{
204 			return true;
205 		}
206 	}
207 
208 
209 }