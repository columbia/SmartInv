1 pragma solidity ^0.4.24;
2 
3 /**
4  * Dijital Para
5  * Appreciate The Difference
6  * developed by itostarter.com
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a && c >= b);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44 
45 }
46 
47 
48 
49 
50 contract owned { //Contract used to only allow the owner to call some functions
51 	address public owner;
52 
53 	function owned() public {
54 	owner = msg.sender;
55 	}
56 
57 	modifier onlyOwner {
58 	require(msg.sender == owner);
59 	_;
60 	}
61 
62 	function transferOwnership(address newOwner) onlyOwner public {
63 	owner = newOwner;
64 	}
65 }
66 
67 
68 contract TokenERC20 {
69 
70 	using SafeMath for uint256;
71 	// Public variables of the token
72 	string public name;
73 	string public symbol;
74 	uint8 public decimals = 8;
75 	//
76 	uint256 public totalSupply;
77 
78 
79 	// This creates an array with all balances
80 	mapping (address => uint256) public balanceOf;
81 	mapping (address => mapping (address => uint256)) public allowance;
82 
83 	// This generates a public event on the blockchain that will notify clients
84 	event Transfer(address indexed from, address indexed to, uint256 value);
85 
86 	// This notifies clients about the amount burnt
87 	event Burn(address indexed from, uint256 value);
88 
89 
90 	function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
91 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
92 		name = tokenName;                                   // Set the name for display purposes
93 		symbol = tokenSymbol;                               // Set the symbol for display purposes
94 	}
95 
96 
97 	function _transfer(address _from, address _to, uint _value) internal {
98 		// Prevent transfer to 0x0 address. Use burn() instead
99 		require(_to != 0x0);
100 		// Check for overflows
101 		// Save this for an assertion in the future
102 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
103 		// Subtract from the sender
104 		balanceOf[_from] = balanceOf[_from].sub(_value);
105 		// Add the same to the recipient
106 		balanceOf[_to] = balanceOf[_to].add(_value);
107 		emit Transfer(_from, _to, _value);
108 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
109 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
110 	}
111 
112 
113 	function transfer(address _to, uint256 _value) public {
114 		_transfer(msg.sender, _to, _value);
115 	}
116 
117 
118 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
119 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
120 		_transfer(_from, _to, _value);
121 		return true;
122 	}
123 
124 
125 	function approve(address _spender, uint256 _value) public returns (bool success) {
126 		allowance[msg.sender][_spender] = _value;
127 		return true;
128 	}
129 
130 
131 	function burn(uint256 _value) public returns (bool success) {
132 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
133 		totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
134 		emit Burn(msg.sender, _value);
135 		return true;
136 	}
137 
138 
139 
140 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
141 		balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
142 		allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
143 		totalSupply = totalSupply.sub(_value);                              // Update totalSupply
144 		emit Burn(_from, _value);
145 		return true;
146 	}
147 
148 
149 }
150 
151 /******************************************/
152 /*       DJPToken STARTS HERE       */
153 /******************************************/
154 
155 contract DJPToken is owned, TokenERC20  {
156 
157 	//Modify these variables
158 	uint256 _initialSupply=500000000; 
159 	string _tokenName="DJP";
160 	string _tokenSymbol="DijitalPara";
161 	address public lockedWallet = 0x3d41E1d1941957FB21c2d3503E59a69aa7990370;
162 	uint256 public startTime;
163 
164 	mapping (address => bool) public frozenAccount;
165 
166 	/* This generates a public event on the blockchain that will notify clients */
167 	event FrozenFunds(address target, bool frozen);
168 
169 	/* Initializes contract with initial supply tokens to the creator of the contract */
170 	function DJPToken( ) TokenERC20(_initialSupply, _tokenName, _tokenSymbol) public {
171 
172 		startTime = now;
173 
174 		balanceOf[lockedWallet] = totalSupply;
175 	}
176 
177 	function _transfer(address _from, address _to, uint _value) internal {
178 		require(_to != 0x0);
179 
180 		bool lockedBalance = checkLockedBalance(_from,_value);
181 		require(lockedBalance);
182 
183 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
184 		balanceOf[_from] = balanceOf[_from].sub(_value);
185 		balanceOf[_to] = balanceOf[_to].add(_value);
186 		emit Transfer(_from, _to, _value);
187 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
188 	}
189 
190 	function checkLockedBalance(address wallet, uint256 _value) internal returns (bool){
191 		if(wallet==lockedWallet){
192 			
193 			if(now<startTime + 365 * 1 days){ //15% tokens locked first year
194 				return balanceOf[lockedWallet].sub(_value)>=totalSupply.mul(15).div(100)? true : false;
195 			}else if(now>=startTime + 365 * 1 days && now<startTime + 730 * 1 days){ //13% tokens locked second year
196 				return balanceOf[lockedWallet].sub(_value)>=totalSupply.mul(13).div(100)? true : false;
197 			}else if(now>=startTime + 730 * 1 days && now<startTime + 1095 * 1 days){ //10% tokens locked third year
198 				return balanceOf[lockedWallet].sub(_value)>=totalSupply.mul(10).div(100)? true : false;	
199 			}else if(now>=startTime + 1095 * 1 days && now<startTime + 1460 * 1 days){ //6% tokens locked fourth year
200 				return balanceOf[lockedWallet].sub(_value)>=totalSupply.mul(6).div(100)? true : false;	
201 			}else{ //No tokens locked from the forth year on
202 				return true;
203 			}
204 
205 		}else{
206 			return true;
207 		}
208 	}
209 
210 
211 }