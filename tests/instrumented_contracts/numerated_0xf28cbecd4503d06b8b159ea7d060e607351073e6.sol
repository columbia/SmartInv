1 pragma solidity ^0.4.18;
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
13 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14 		if (a == 0) {
15 			return 0;
16 		}
17 		uint256 c = a * b;
18 		assert(c / a == b);
19 		return c;
20 	}
21 
22 	/**
23 	* @dev Integer division of two numbers, truncating the quotient.
24 	*/
25 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
26 		// assert(b > 0); // Solidity automatically throws when dividing by 0
27 		uint256 c = a / b;
28 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 		return c;
30 	}
31 
32 	/**
33 	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34 	*/
35 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	/**
41 	* @dev Adds two numbers, throws on overflow.
42 	*/
43 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
44 		uint256 c = a + b;
45 		assert(c >= a);
46 		return c;
47 	}
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56 	address public owner;
57 
58 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 	/**
61 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62 	 * account.
63 	 */
64 	function Ownable() public {
65 		owner = msg.sender;
66 	}
67 
68 	/**
69 	 * @dev Throws if called by any account other than the owner.
70 	 */
71 	modifier onlyOwner() {
72 		require(msg.sender == owner);
73 		_;
74 	}
75 
76 	/**
77 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
78 	 * @param newOwner The address to transfer ownership to.
79 	 */
80 	function transferOwnership(address newOwner) public onlyOwner {
81 		require(newOwner != address(0));
82 		OwnershipTransferred(owner, newOwner);
83 		owner = newOwner;
84 	}
85 
86 }
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94 	function totalSupply() public view returns (uint256);
95 	function balanceOf(address who) public view returns (uint256);
96 	function transfer(address to, uint256 value) public returns (bool);
97 	event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105 	function allowance(address owner, address spender) public view returns (uint256);
106 	function transferFrom(address from, address to, uint256 value) public returns (bool);
107 	function approve(address spender, uint256 value) public returns (bool);
108 	event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117 	using SafeMath for uint256;
118 
119 	mapping(address => uint256) balances;
120 
121 	uint256 totalSupply_;
122 
123 	/**
124 	* @dev total number of tokens in existence
125 	*/
126 	function totalSupply() public view returns (uint256) {
127 		return totalSupply_;
128 	}
129 
130 	/**
131 	* @dev transfer token for a specified address
132 	* @param _to The address to transfer to.
133 	* @param _value The amount to be transferred.
134 	*/
135 	function transfer(address _to, uint256 _value) public returns (bool) {
136 		require(_to != address(0));
137 		require(_value <= balances[msg.sender]);
138 
139 		// SafeMath.sub will throw if there is not enough balance.
140 		balances[msg.sender] = balances[msg.sender].sub(_value);
141 		balances[_to] = balances[_to].add(_value);
142 		Transfer(msg.sender, _to, _value);
143 		return true;
144 	}
145 
146 	/**
147 	* @dev Gets the balance of the specified address.
148 	* @param _owner The address to query the the balance of.
149 	* @return An uint256 representing the amount owned by the passed address.
150 	*/
151 	function balanceOf(address _owner) public view returns (uint256 balance) {
152 		return balances[_owner];
153 	}
154 
155 }
156 
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167 	mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170 	/**
171 	 * @dev Transfer tokens from one address to another
172 	 * @param _from address The address which you want to send tokens from
173 	 * @param _to address The address which you want to transfer to
174 	 * @param _value uint256 the amount of tokens to be transferred
175 	 */
176 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177 		require(_to != address(0));
178 		require(_value <= balances[_from]);
179 		require(_value <= allowed[_from][msg.sender]);
180 
181 		balances[_from] = balances[_from].sub(_value);
182 		balances[_to] = balances[_to].add(_value);
183 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184 		Transfer(_from, _to, _value);
185 		return true;
186 	}
187 
188 	/**
189 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190 	 *
191 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
192 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195 	 * @param _spender The address which will spend the funds.
196 	 * @param _value The amount of tokens to be spent.
197 	 */
198 	function approve(address _spender, uint256 _value) public returns (bool) {
199 		allowed[msg.sender][_spender] = _value;
200 		Approval(msg.sender, _spender, _value);
201 		return true;
202 	}
203 
204 	/**
205 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
206 	 * @param _owner address The address which owns the funds.
207 	 * @param _spender address The address which will spend the funds.
208 	 * @return A uint256 specifying the amount of tokens still available for the spender.
209 	 */
210 	function allowance(address _owner, address _spender) public view returns (uint256) {
211 		return allowed[_owner][_spender];
212 	}
213 
214 	/**
215 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
216 	 *
217 	 * approve should be called when allowed[_spender] == 0. To increment
218 	 * allowed value is better to use this function to avoid 2 calls (and wait until
219 	 * the first transaction is mined)
220 	 * From MonolithDAO Token.sol
221 	 * @param _spender The address which will spend the funds.
222 	 * @param _addedValue The amount of tokens to increase the allowance by.
223 	 */
224 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227 		return true;
228 	}
229 
230 	/**
231 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
232 	 *
233 	 * approve should be called when allowed[_spender] == 0. To decrement
234 	 * allowed value is better to use this function to avoid 2 calls (and wait until
235 	 * the first transaction is mined)
236 	 * From MonolithDAO Token.sol
237 	 * @param _spender The address which will spend the funds.
238 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
239 	 */
240 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241 		uint oldValue = allowed[msg.sender][_spender];
242 		if (_subtractedValue > oldValue) {
243 			allowed[msg.sender][_spender] = 0;
244 		} else {
245 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246 		}
247 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248 		return true;
249 	}
250 
251 }
252 
253 /**
254  * @title Yachtco Token
255  * @dev ERC20 Token, where all tokens are pre-minted.
256  * Note they can later distribute these tokens as they wish using `transfer` and other
257  * `StandardToken` functions.
258  * @author Michael Arbach
259  */
260 contract Yachtco is StandardToken, Ownable {
261 
262 	using SafeMath for uint256;
263 
264 	string public name              = "Yachtco";
265 	string public symbol            = "YCO";
266 	uint8  public constant decimals = 18;
267 
268 	uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
269 
270 	bool public transmitStatus = true;
271 	bool public transferStatus = false;
272 
273 	event Transmit(address indexed from, address indexed to, uint256 value);
274 	event TransmitDisabled();
275 	event TransferStatus(bool value);
276 
277 	/**
278 	 * @dev Constructor that gives msg.sender all of existing tokens.
279 	 */
280 	function Yachtco() public {
281 		totalSupply_ = INITIAL_SUPPLY;
282 		balances[msg.sender] = INITIAL_SUPPLY;
283 	}
284 
285 	/**
286 	 * @dev if ether is sent to this address, send it back.
287 	 */
288 	function () public payable {
289 		revert();
290 	}
291 
292 	/**
293 		* @dev transfer token for a specified address
294 		* @param _to The address to transfer to.
295 		* @param _value The amount to be transferred.
296 	*/
297 	function transfer(address _to, uint256 _value) public returns (bool) {
298 		require(transferStatus || msg.sender == owner);
299 		return super.transfer(_to, _value);
300 	}
301 
302 	/**
303 		* @dev transferFrom token for a specified address
304 		* @param _from The address froms transfer to.
305 		* @param _to The address to transfer to.
306 		* @param _value The amount to be transferred.
307 	*/
308 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
309 		require(transferStatus || msg.sender == owner);
310 		return super.transferFrom(_from, _to, _value);
311 	}
312 
313 	/**
314 		* @dev transfer token for a specified address
315 		* @param _to The address to transfer to.
316 		* @param _value The amount to be transferred.
317 	*/
318 	function transmit(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
319 		require(transmitStatus);
320 		require(_to != address(0) && _from != address(0));
321 		require(_value <= balances[_from]);
322 
323 		// SafeMath.sub will throw if there is not enough balance.
324 		balances[_from] = balances[_from].sub(_value);
325 		balances[_to] = balances[_to].add(_value);
326 		Transmit(_from, _to, _value);
327 		return true;
328 	}
329 
330 	/**
331 	 * @dev Disable Transmit functionality for Owner.
332 	*/
333 	function disableTransmit() public onlyOwner {
334 		require(transmitStatus);
335 		transmitStatus = false;
336 		TransmitDisabled();
337 	}
338 
339 	/**
340 	 * @dev change token name
341 	*/
342 	function setName(string _name) public onlyOwner {
343         name = _name;
344 	}
345 
346 	/**
347 	 * @dev change token symbol
348 	*/
349 	function setSymbol(string _symbol) public onlyOwner {
350         symbol = _symbol;
351 	}
352 
353 
354 	/**
355 	 * @dev Disable Transfer.
356 	*/
357 	function disableTransfer() public onlyOwner {
358 		transferStatus = false;
359 		TransferStatus(transferStatus);
360 	}
361 
362 	/**
363 	 * @dev Enable Transfer. 
364 	*/
365 	function enableTransfer() public onlyOwner {
366 		transferStatus = true;
367 		TransferStatus(transferStatus);
368 	}
369 }