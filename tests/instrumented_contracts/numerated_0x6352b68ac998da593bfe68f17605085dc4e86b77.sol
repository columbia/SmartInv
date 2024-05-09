1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 
9 	/**
10 	* @dev Multiplies two numbers, throws on overflow.
11 	*/
12 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13 		if (a == 0) {
14 			return 0;
15 		}
16 		uint256 c = a * b;
17 		assert(c / a == b);
18 		return c;
19 	}
20 
21 	/**
22 	* @dev Integer division of two numbers, truncating the quotient.
23 	*/
24 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
25 		// assert(b > 0); // Solidity automatically throws when dividing by 0
26 		uint256 c = a / b;
27 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 		return c;
29 	}
30 
31 	/**
32 	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33 	*/
34 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35 		assert(b <= a);
36 		return a - b;
37 	}
38 
39 	/**
40 	* @dev Adds two numbers, throws on overflow.
41 	*/
42 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
43 		uint256 c = a + b;
44 		assert(c >= a);
45 		return c;
46 	}
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55 	address public owner;
56 
57 
58 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61 	/**
62 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63 	 * account.
64 	 */
65 	function Ownable() public {
66 		owner = msg.sender;
67 	}
68 
69 	/**
70 	 * @dev Throws if called by any account other than the owner.
71 	 */
72 	modifier onlyOwner() {
73 		require(msg.sender == owner);
74 		_;
75 	}
76 
77 	/**
78 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
79 	 * @param newOwner The address to transfer ownership to.
80 	 */
81 	function transferOwnership(address newOwner) public onlyOwner {
82 		require(newOwner != address(0));
83 		OwnershipTransferred(owner, newOwner);
84 		owner = newOwner;
85 	}
86 
87 }
88 
89 /**
90 *Standard ERC20 Token interface
91 */
92 contract ERC20 {
93 	// these functions aren't abstract since the compiler emits automatically generated getter functions as external
94 
95 	function totalSupply() public view returns (uint256);
96 	function balanceOf(address who) public view returns (uint256);
97 	function transfer(address to, uint256 value) public returns (bool);
98 	event Transfer(address indexed from, address indexed to, uint256 value);
99 
100 	function allowance(address owner, address spender) public view returns (uint256);
101 	function transferFrom(address from, address to, uint256 value) public returns (bool);
102 	function approve(address spender, uint256 value) public returns (bool);
103 	event Approval(address indexed owner, address indexed spender, uint256 value);
104 
105 }
106 
107 
108 /**
109 * @title Standard ERC20 token
110 *
111 * @dev Implementation of the basic standard token.
112 * @dev https://github.com/ethereum/EIPs/issues/20
113 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114 */
115 contract StandardToken is ERC20 {
116 
117 	using SafeMath for uint256;
118 
119 	mapping(address => uint256) balances;
120 	mapping (address => mapping (address => uint256)) internal allowed;
121 
122 	uint256 totalSupply_;
123 
124 	/**
125 	* @dev total number of tokens in existence
126 	*/
127 	function totalSupply() public view returns (uint256) {
128 		return totalSupply_;
129 	}
130 
131 	/**
132 	* @dev transfer token for a specified address
133 	* @param _to The address to transfer to.
134 	* @param _value The amount to be transferred.
135 	*/
136 	function transfer(address _to, uint256 _value) public returns (bool) {
137 		require(_to != address(0));
138 		require(_value <= balances[msg.sender]);
139 
140 		// SafeMath.sub will throw if there is not enough balance.
141 		balances[msg.sender] = balances[msg.sender].sub(_value);
142 		balances[_to] = balances[_to].add(_value);
143 		Transfer(msg.sender, _to, _value);
144 		return true;
145 	}
146 
147 
148 	/**
149 	* @dev Transfer tokens from one address to another
150 	* @param _from address The address which you want to send tokens from
151 	* @param _to address The address which you want to transfer to
152 	* @param _value uint256 the amount of tokens to be transferred
153 	*/
154 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155 		require(_to != address(0));
156 		require(_value <= balances[_from]);
157 		require(_value <= allowed[_from][msg.sender]);
158 
159 		balances[_from] = balances[_from].sub(_value);
160 		balances[_to] = balances[_to].add(_value);
161 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162 		Transfer(_from, _to, _value);
163 		return true;
164 	}
165 
166 
167 	/**
168 	* @dev Gets the balance of the specified address.
169 	* @param _owner The address to query the the balance of.
170 	* @return An uint256 representing the amount owned by the passed address.
171 	*/
172 	function balanceOf(address _owner) public view returns (uint256 balance) {
173 		return balances[_owner];
174 	}
175 
176 	/**
177 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178 	*
179 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
180 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183 	* @param _spender The address which will spend the funds.
184 	* @param _value The amount of tokens to be spent.
185 	*/
186 	function approve(address _spender, uint256 _value) public returns (bool) {
187 		allowed[msg.sender][_spender] = _value;
188 		Approval(msg.sender, _spender, _value);
189 		return true;
190 	}
191 
192 	/**
193 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
194 	* @param _owner address The address which owns the funds.
195 	* @param _spender address The address which will spend the funds.
196 	* @return A uint256 specifying the amount of tokens still available for the spender.
197 	*/
198 	function allowance(address _owner, address _spender) public view returns (uint256) {
199 		return allowed[_owner][_spender];
200 	}
201 }
202 
203 
204 /**
205 * @title EzPoint ERC20 token
206 *
207 */
208 contract EzPoint is StandardToken, Ownable{
209 	using SafeMath for uint256;
210 
211 	string public name = "EzPoint";
212 	string public symbol = "EZPT";
213 	uint8 public constant decimals = 18;
214 
215 	uint256 private _N = (10 ** uint256(decimals));
216 	uint256 public INITIAL_SUPPLY = _N.mul(10000000000);
217 
218 	/**
219 	* @dev Constructor that gives msg.sender all of existing tokens.
220 	*/
221 	function EzPoint() public {
222 		totalSupply_ = INITIAL_SUPPLY;
223 		balances[owner] = totalSupply_;
224 	}
225 
226 	function setName(string _name)  onlyOwner public {
227 		name = _name;
228 	}
229 
230 	function setSymbol(string _symbol) onlyOwner public {
231 		symbol = _symbol;
232 	}
233 }