1 // Verfication token for U42 token distribution
2 //
3 // Standard ERC-20 methods and the SafeMath library are adapated from OpenZeppelin's standard contract types
4 // as at https://github.com/OpenZeppelin/openzeppelin-solidity/commit/5daaf60d11ee2075260d0f3adfb22b1c536db983
5 // note that uint256 is used explicitly in place of uint
6 
7 pragma solidity ^0.4.24;
8 
9 //safemath extensions added to uint256
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
21     // benefit is lost if 'b' is also tested.
22     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23     if (a == 0) {
24       return 0;
25     }
26 
27     c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     // uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return a / b;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
54     c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 contract Verify_U42 {
61 	//use OZ SafeMath to avoid uint256 overflows
62 	using SafeMath for uint256;
63 
64 	string public constant name = "Verification token for U42 distribution";
65 	string public constant symbol = "VU42";
66 	uint8 public constant decimals = 18;
67 	uint256 public constant initialSupply = 525000000 * (10 ** uint256(decimals));
68 	uint256 internal totalSupply_ = initialSupply;
69 	address public contractOwner;
70 
71 	//token balances
72 	mapping(address => uint256) balances;
73 
74 	//for each balance address, map allowed addresses to amount allowed
75 	mapping (address => mapping (address => uint256)) internal allowed;
76 
77 	//methods emit the following events (note that these are a subset 
78 	event Transfer (
79 		address indexed from, 
80 		address indexed to, 
81 		uint256 value );
82 
83 	event TokensBurned (
84 		address indexed burner, 
85 		uint256 value );
86 
87 	event Approval (
88 		address indexed owner,
89 		address indexed spender,
90 		uint256 value );
91 
92 
93 	constructor() public {
94 		//contract creator holds all tokens at creation
95 		balances[msg.sender] = totalSupply_;
96 
97 		//record contract owner for later reference (e.g. in ownerBurn)
98 		contractOwner=msg.sender;
99 
100 		//indicate all tokens were sent to contract address
101 		emit Transfer(address(0), msg.sender, totalSupply_);
102 	}
103 
104 	function ownerBurn ( 
105 			uint256 _value )
106 		public returns (
107 			bool success) {
108 
109 		//only the contract owner can burn tokens
110 		require(msg.sender == contractOwner);
111 
112 		//can only burn tokens held by the owner
113 		require(_value <= balances[contractOwner]);
114 
115 		//total supply of tokens is decremented when burned
116 		totalSupply_ = totalSupply_.sub(_value);
117 
118 		//balance of the contract owner is reduced (the contract owner's tokens are burned)
119 		balances[contractOwner] = balances[contractOwner].sub(_value);
120 
121 		//burning tokens emits a transfer to 0, as well as TokensBurned
122 		emit Transfer(contractOwner, address(0), _value);
123 		emit TokensBurned(contractOwner, _value);
124 
125 		return true;
126 
127 	}
128 	
129 	
130 	function totalSupply ( ) public view returns (
131 		uint256 ) {
132 
133 		return totalSupply_;
134 	}
135 
136 	function balanceOf (
137 			address _owner ) 
138 		public view returns (
139 			uint256 ) {
140 
141 		return balances[_owner];
142 	}
143 
144 	function transfer (
145 			address _to, 
146 			uint256 _value ) 
147 		public returns (
148 			bool ) {
149 
150 		require(_to != address(0));
151 		require(_value <= balances[msg.sender]);
152 
153 		balances[msg.sender] = balances[msg.sender].sub(_value);
154 		balances[_to] = balances[_to].add(_value);
155 
156 		emit Transfer(msg.sender, _to, _value);
157 		return true;
158 	}
159 
160    	//changing approval with this method has the same underlying issue as https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    	//in that transaction order can be modified in a block to spend, change approval, spend again
162    	//the method is kept for ERC-20 compatibility, but a set to zero, set again or use of the below increase/decrease should be used instead
163 	function approve (
164 			address _spender, 
165 			uint256 _value ) 
166 		public returns (
167 			bool ) {
168 
169 		allowed[msg.sender][_spender] = _value;
170 
171 		emit Approval(msg.sender, _spender, _value);
172 		return true;
173 	}
174 
175 	function increaseApproval (
176 			address _spender, 
177 			uint256 _addedValue ) 
178 		public returns (
179 			bool ) {
180 
181 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182 
183 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184 		return true;
185 	}
186 
187 	function decreaseApproval (
188 			address _spender,
189 			uint256 _subtractedValue ) 
190 		public returns (
191 			bool ) {
192 
193 		uint256 oldValue = allowed[msg.sender][_spender];
194 
195 		if (_subtractedValue > oldValue) {
196 			allowed[msg.sender][_spender] = 0;
197 		} else {
198 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199 		}
200 
201 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202 		return true;
203 	}
204 
205 	function allowance (
206 			address _owner, 
207 			address _spender ) 
208 		public view returns (
209 			uint256 remaining ) {
210 
211 		return allowed[_owner][_spender];
212 	}
213 
214 	function transferFrom (
215 			address _from, 
216 			address _to, 
217 			uint256 _value ) 
218 		public returns (
219 			bool ) {
220 
221 		require(_to != address(0));
222 		require(_value <= balances[_from]);
223 		require(_value <= allowed[_from][msg.sender]);
224 
225 		balances[_from] = balances[_from].sub(_value);
226 		balances[_to] = balances[_to].add(_value);
227 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228 		emit Transfer(_from, _to, _value);
229 		return true;
230 	}
231 
232 }