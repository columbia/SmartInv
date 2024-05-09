1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10 	/**
11 	* @dev Multiplies two numbers, throws on overflow.
12 	*/
13 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14 		if (a == 0) {
15 			return 0;
16 		}
17 		c = a * b;
18 		assert(c / a == b);
19 		return c;
20 	}
21 
22 	/**
23 	* @dev Integer division of two numbers, truncating the quotient.
24 	*/
25 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
26 		// assert(b > 0); // Solidity automatically throws when dividing by 0
27 		// uint256 c = a / b;
28 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 		return a / b;
30 	}
31 
32 	/**
33 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34 	*/
35 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	/**
41 	* @dev Adds two numbers, throws on overflow.
42 	*/
43 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44 		c = a + b;
45 		assert(c >= a);
46 		return c;
47 	}
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56 	function totalSupply() public view returns (uint256);
57 	function balanceOf(address who) public view returns (uint256);
58 	function transfer(address to, uint256 value) public returns (bool);
59 	event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67 	using SafeMath for uint256;
68 
69 	mapping(address => uint256) balances;
70 
71 	uint256 totalSupply_;
72 
73 	/**
74 	* @dev total number of tokens in existence
75 	*/
76 	function totalSupply() public view returns (uint256) {
77 		return totalSupply_;
78 	}
79 
80 	/**
81 	* @dev transfer token for a specified address
82 	* @param _to The address to transfer to.
83 	* @param _value The amount to be transferred.
84 	*/
85 	function transfer(address _to, uint256 _value) public returns (bool) {
86 		require(_to != address(0));
87 		require(_value <= balances[msg.sender]);
88 
89 		balances[msg.sender] = balances[msg.sender].sub(_value);
90 		balances[_to] = balances[_to].add(_value);
91 		emit Transfer(msg.sender, _to, _value);
92 		return true;
93 	}
94 
95 	/**
96 	* @dev Gets the balance of the specified address.
97 	* @param _owner The address to query the the balance of.
98 	* @return An uint256 representing the amount owned by the passed address.
99 	*/
100 	function balanceOf(address _owner) public view returns (uint256) {
101 		return balances[_owner];
102 	}
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111 	function allowance(address owner, address spender) public view returns (uint256);
112 	function transferFrom(address from, address to, uint256 value) public returns (bool);
113 	function approve(address spender, uint256 value) public returns (bool);
114 	event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126 	mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129 	/**
130 	 * @dev Transfer tokens from one address to another
131 	 * @param _from address The address which you want to send tokens from
132 	 * @param _to address The address which you want to transfer to
133 	 * @param _value uint256 the amount of tokens to be transferred
134 	 */
135 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136 		require(_to != address(0));
137 		require(_value <= balances[_from]);
138 		require(_value <= allowed[_from][msg.sender]);
139 
140 		balances[_from] = balances[_from].sub(_value);
141 		balances[_to] = balances[_to].add(_value);
142 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143 		emit Transfer(_from, _to, _value);
144 		return true;
145 	}
146 
147 	/**
148 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149 	 *
150 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
151 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154 	 * @param _spender The address which will spend the funds.
155 	 * @param _value The amount of tokens to be spent.
156 	 */
157 	function approve(address _spender, uint256 _value) public returns (bool) {
158 		allowed[msg.sender][_spender] = _value;
159 		emit Approval(msg.sender, _spender, _value);
160 		return true;
161 	}
162 
163 	/**
164 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
165 	 * @param _owner address The address which owns the funds.
166 	 * @param _spender address The address which will spend the funds.
167 	 * @return A uint256 specifying the amount of tokens still available for the spender.
168 	 */
169 	function allowance(address _owner, address _spender) public view returns (uint256) {
170 		return allowed[_owner][_spender];
171 	}
172 
173 	/**
174 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
175 	 *
176 	 * approve should be called when allowed[_spender] == 0. To increment
177 	 * allowed value is better to use this function to avoid 2 calls (and wait until
178 	 * the first transaction is mined)
179 	 * From MonolithDAO Token.sol
180 	 * @param _spender The address which will spend the funds.
181 	 * @param _addedValue The amount of tokens to increase the allowance by.
182 	 */
183 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186 		return true;
187 	}
188 
189 	/**
190 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
191 	 *
192 	 * approve should be called when allowed[_spender] == 0. To decrement
193 	 * allowed value is better to use this function to avoid 2 calls (and wait until
194 	 * the first transaction is mined)
195 	 * From MonolithDAO Token.sol
196 	 * @param _spender The address which will spend the funds.
197 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
198 	 */
199 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200 		uint oldValue = allowed[msg.sender][_spender];
201 		if (_subtractedValue > oldValue) {
202 			allowed[msg.sender][_spender] = 0;
203 		} else {
204 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205 		}
206 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207 		return true;
208 	}
209 
210 }
211 
212 contract FinToken is StandardToken {
213 	address public owner;
214 	
215 	string public constant name = "FIN Token"; 
216 	string public constant symbol = "FIN";
217 	uint8 public constant decimals = 18;
218 
219 	uint256 public constant INITIAL_SUPPLY = 2623304 * (10 ** uint256(decimals));
220 	
221 	mapping (address => bool) internal verificatorAddresses;
222 	mapping (address => bool) internal verifiedAddresses;
223 	
224 	event AddVerificator(address indexed verificator);
225 	event RemoveVerificator(address indexed verificator);
226 	
227 	event AddVerified(address indexed verificatorAddress, address indexed verified);
228 	event RemoveVerified(address indexed verificatorAddress, address indexed verified);
229 	
230 	event Mint(address indexed to, uint256 amount);
231 	
232 	modifier onlyOwner() {
233 		require(msg.sender == owner);
234 		_;
235 	}
236 	
237 	modifier onlyVerificator() {
238 		require(isVerificator(msg.sender));
239 		_;
240 	}
241 	
242 	modifier onlyVerified(address _from, address _to) {
243 		require(isVerified(_from));
244 		require(isVerified(_to));
245 		_;
246 	}
247 
248 	function FinToken() public {
249 		owner = msg.sender;
250 		totalSupply_ = INITIAL_SUPPLY;
251 		balances[msg.sender] = INITIAL_SUPPLY;
252 		emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
253 	}
254 	
255 	function addVerificatorAddress(address addr) public onlyOwner {
256 		verificatorAddresses[addr] = true;
257 		emit AddVerificator(addr);
258 	}
259 	
260 	function removeVerificatorAddress(address addr) public onlyOwner {
261 		delete verificatorAddresses[addr];
262 		emit RemoveVerificator(addr);
263 	}
264 	
265 	function isVerificator(address addr) public constant returns (bool) {
266 		return verificatorAddresses[addr];
267 	}
268 		
269 	function addVerifiedAddress(address addr) public onlyVerificator {
270 		verifiedAddresses[addr] = true;
271 		emit AddVerified(msg.sender, addr);
272 	}
273 	
274 	function removeVerifiedAddress(address addr) public onlyVerificator {
275 		delete verifiedAddresses[addr];
276 		emit RemoveVerified(msg.sender, addr);
277 	}
278 	
279 	function isVerified(address addr) public constant returns (bool) {
280 		return verifiedAddresses[addr];
281 	}
282 	
283 	function transfer(address _to, uint256 _value) public onlyVerified(msg.sender, _to) returns (bool) {
284 		super.transfer(_to, _value);
285 	}
286 	
287 	function transferFrom(address _from, address _to, uint256 _value) public onlyVerified(_from, _to) returns (bool) {
288 	    super.transferFrom(_from, _to, _value);
289 	}
290 }