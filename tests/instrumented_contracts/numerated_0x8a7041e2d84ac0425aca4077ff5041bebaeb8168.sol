1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
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
57 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 	/**
60 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61 	 * account.
62 	 */
63 	function Ownable() public {
64 		owner = msg.sender;
65 	}
66 
67 	/**
68 	 * @dev Throws if called by any account other than the owner.
69 	 */
70 	modifier onlyOwner() {
71 		require(msg.sender == owner);
72 		_;
73 	}
74 
75 	/**
76 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
77 	 * @param newOwner The address to transfer ownership to.
78 	 */
79 	function transferOwnership(address newOwner) public onlyOwner {
80 		require(newOwner != address(0));
81 		OwnershipTransferred(owner, newOwner);
82 		owner = newOwner;
83 	}
84 
85 }
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93 	function totalSupply() public view returns (uint256);
94 	function balanceOf(address who) public view returns (uint256);
95 	function transfer(address to, uint256 value) public returns (bool);
96 	event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104 	function allowance(address owner, address spender) public view returns (uint256);
105 	function transferFrom(address from, address to, uint256 value) public returns (bool);
106 	function approve(address spender, uint256 value) public returns (bool);
107 	event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken, with no allowances.
114  */
115 contract BasicToken is ERC20Basic {
116 	using SafeMath for uint256;
117 
118 	mapping(address => uint256) balances;
119 
120 	uint256 totalSupply_;
121 
122 	/**
123 	* @dev total number of tokens in existence
124 	*/
125 	function totalSupply() public view returns (uint256) {
126 		return totalSupply_;
127 	}
128 
129 	/**
130 	* @dev transfer token for a specified address
131 	* @param _to The address to transfer to.
132 	* @param _value The amount to be transferred.
133 	*/
134 	function transfer(address _to, uint256 _value) public returns (bool) {
135 		require(_to != address(0));
136 		require(_value <= balances[msg.sender]);
137 
138 		// SafeMath.sub will throw if there is not enough balance.
139 		balances[msg.sender] = balances[msg.sender].sub(_value);
140 		balances[_to] = balances[_to].add(_value);
141 		Transfer(msg.sender, _to, _value);
142 		return true;
143 	}
144 
145 	/**
146 	* @dev Gets the balance of the specified address.
147 	* @param _owner The address to query the the balance of.
148 	* @return An uint256 representing the amount owned by the passed address.
149 	*/
150 	function balanceOf(address _owner) public view returns (uint256 balance) {
151 		return balances[_owner];
152 	}
153 
154 }
155 
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166 	mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169 	/**
170 	 * @dev Transfer tokens from one address to another
171 	 * @param _from address The address which you want to send tokens from
172 	 * @param _to address The address which you want to transfer to
173 	 * @param _value uint256 the amount of tokens to be transferred
174 	 */
175 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176 		require(_to != address(0));
177 		require(_value <= balances[_from]);
178 		require(_value <= allowed[_from][msg.sender]);
179 
180 		balances[_from] = balances[_from].sub(_value);
181 		balances[_to] = balances[_to].add(_value);
182 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183 		Transfer(_from, _to, _value);
184 		return true;
185 	}
186 
187 	/**
188 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189 	 *
190 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
191 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194 	 * @param _spender The address which will spend the funds.
195 	 * @param _value The amount of tokens to be spent.
196 	 */
197 	function approve(address _spender, uint256 _value) public returns (bool) {
198 		allowed[msg.sender][_spender] = _value;
199 		Approval(msg.sender, _spender, _value);
200 		return true;
201 	}
202 
203 	/**
204 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
205 	 * @param _owner address The address which owns the funds.
206 	 * @param _spender address The address which will spend the funds.
207 	 * @return A uint256 specifying the amount of tokens still available for the spender.
208 	 */
209 	function allowance(address _owner, address _spender) public view returns (uint256) {
210 		return allowed[_owner][_spender];
211 	}
212 
213 	/**
214 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
215 	 *
216 	 * approve should be called when allowed[_spender] == 0. To increment
217 	 * allowed value is better to use this function to avoid 2 calls (and wait until
218 	 * the first transaction is mined)
219 	 * From MonolithDAO Token.sol
220 	 * @param _spender The address which will spend the funds.
221 	 * @param _addedValue The amount of tokens to increase the allowance by.
222 	 */
223 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226 		return true;
227 	}
228 
229 	/**
230 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
231 	 *
232 	 * approve should be called when allowed[_spender] == 0. To decrement
233 	 * allowed value is better to use this function to avoid 2 calls (and wait until
234 	 * the first transaction is mined)
235 	 * From MonolithDAO Token.sol
236 	 * @param _spender The address which will spend the funds.
237 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
238 	 */
239 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240 		uint oldValue = allowed[msg.sender][_spender];
241 		if (_subtractedValue > oldValue) {
242 			allowed[msg.sender][_spender] = 0;
243 		} else {
244 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245 		}
246 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247 		return true;
248 	}
249 
250 }
251 
252 /**
253  * @title Sebastian
254  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
255  * Note they can later distribute these tokens as they wish using `transfer` and other
256  * `StandardToken` functions.
257  */
258 contract SebastianToken is StandardToken, Ownable {
259 	using SafeMath for uint256;
260 
261 	string public name = "Sebastian";
262 	string public symbol = "SEB";
263 	uint256 public decimals = 5;
264 
265 	uint256 public totalSupply = 1000000000 * (10 ** uint256(decimals));
266 
267 	/**
268 	 * @dev Constructor that gives msg.sender all of existing tokens.
269 	 */
270 	function SebastianToken(string _name, string _symbol, uint256 _decimals, uint256 _totalSupply) public {
271 		name = _name;
272 		symbol = _symbol;
273 		decimals = _decimals;
274 		totalSupply = _totalSupply;
275 
276 		totalSupply_ = _totalSupply;
277 		balances[msg.sender] = totalSupply;
278 	}
279 
280 	/**
281 	 * @dev if ether is sent to this address, send it back.
282 	 */
283 	function () public payable {
284 		revert();
285 	}
286 }
287 
288 /**
289  * @title SebastianTokenSale
290  * @dev ICO Contract
291  */
292 contract SebastianTokenSale is Ownable {
293 
294 	using SafeMath for uint256;
295 
296 	// The token being sold, this holds reference to main token contract
297 	SebastianToken public token;
298 
299 	// timestamp when sale starts
300 	uint256 public startingTimestamp = 1518696000;
301 
302 	// timestamp when sale ends
303 	uint256 public endingTimestamp = 1521115200;
304 
305 	// how many token units a buyer gets per ether
306 	uint256 public tokenPriceInEth = 0.0001 ether;
307 
308 	// amount of token to be sold on sale
309 	uint256 public tokensForSale = 400000000 * 1E5;
310 
311 	// amount of token sold so far
312 	uint256 public totalTokenSold;
313 
314 	// amount of ether raised in sale
315 	uint256 public totalEtherRaised;
316 
317 	// ether raised per wallet
318 	mapping(address => uint256) public etherRaisedPerWallet;
319 
320 	// wallet which will receive the ether funding
321 	address public wallet;
322 
323 	// is contract close and ended
324 	bool internal isClose = false;
325 
326 	// wallet changed
327 	event WalletChange(address _wallet, uint256 _timestamp);
328 
329 	// token purchase event
330 	event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount, uint256 _timestamp);
331 
332 	// manual transfer by owner for external purchase
333 	event TransferManual(address indexed _from, address indexed _to, uint256 _value, string _message);
334 
335 	/**
336 	 * @dev Constructor that initializes token contract with token address in parameter
337 	 *
338 	 * @param _token Address of Token Contract
339 	 * @param _startingTimestamp Start time of Sale in Timestamp.
340 	 * @param _endingTimestamp End time of Sale in Timestamp.
341 	 * @param _tokensPerEth Number of Tokens to convert per 1 ETH.
342 	 * @param _tokensForSale Number of Tokens available for sale.
343 	 * @param _wallet Backup Wallet Address where funds should be transfered when contract is closed or Owner wants to Withdraw.
344 	 *
345 	 */
346 	function SebastianTokenSale(address _token, uint256 _startingTimestamp, uint256 _endingTimestamp, uint256 _tokensPerEth, uint256 _tokensForSale, address _wallet) public {
347 		// set token
348 		token = SebastianToken(_token);
349 
350 		startingTimestamp = _startingTimestamp;
351 		endingTimestamp = _endingTimestamp;
352 		tokenPriceInEth =  1E18 / _tokensPerEth; // Calculating Price of 1 Token in ETH 
353 		tokensForSale = _tokensForSale;
354 
355 		// set wallet
356 		wallet = _wallet;
357 	}
358 
359 	/**
360 	 * @dev Function that validates if the purchase is valid by verifying the parameters
361 	 *
362 	 * @param value Amount of ethers sent
363 	 * @param amount Total number of tokens user is trying to buy.
364 	 *
365 	 * @return checks various conditions and returns the bool result indicating validity.
366 	 */
367 	function isValidPurchase(uint256 value, uint256 amount) internal constant returns (bool) {
368 		// check if timestamp is falling in the range
369 		bool validTimestamp = startingTimestamp <= block.timestamp && endingTimestamp >= block.timestamp;
370 
371 		// check if value of the ether is valid
372 		bool validValue = value != 0;
373 
374 		// check if rate of the token is clearly defined
375 		bool validRate = tokenPriceInEth > 0;
376 
377 		// check if the tokens available in contract for sale
378 		bool validAmount = tokensForSale.sub(totalTokenSold) >= amount && amount > 0;
379 
380 		// validate if all conditions are met
381 		return validTimestamp && validValue && validRate && validAmount && !isClose;
382 	}
383 
384 	
385 	/**
386 	 * @dev Function that accepts ether value and returns the token amount
387 	 *
388 	 * @param value Amount of ethers sent
389 	 *
390 	 * @return checks various conditions and returns the bool result indicating validity.
391 	 */
392 	function calculate(uint256 value) public constant returns (uint256) {
393 		uint256 tokenDecimals = token.decimals();
394 		uint256 tokens = value.mul(10 ** tokenDecimals).div(tokenPriceInEth);
395 		return tokens;
396 	}
397 	
398 	/**
399 	 * @dev Default fallback method which will be called when any ethers are sent to contract
400 	 */
401 	function() public payable {
402 		buyTokens(msg.sender);
403 	}
404 
405 	/**
406 	 * @dev Function that is called either externally or by default payable method
407 	 *
408 	 * @param beneficiary who should receive tokens
409 	 */
410 	function buyTokens(address beneficiary) public payable {
411 		require(beneficiary != address(0));
412 
413 		// amount of ethers sent
414 		uint256 value = msg.value;
415 
416 		// calculate token amount from the ethers sent
417 		uint256 tokens = calculate(value);
418 
419 		// validate the purchase
420 		require(isValidPurchase(value , tokens));
421 
422 		// update the state to log the sold tokens and raised ethers.
423 		totalTokenSold = totalTokenSold.add(tokens);
424 		totalEtherRaised = totalEtherRaised.add(value);
425 		etherRaisedPerWallet[msg.sender] = etherRaisedPerWallet[msg.sender].add(value);
426 
427 		// transfer tokens from contract balance to beneficiary account. calling ERC223 method
428 		token.transfer(beneficiary, tokens);
429 		
430 		// log event for token purchase
431 		TokenPurchase(msg.sender, beneficiary, value, tokens, now);
432 	}
433 
434 	/**
435 	* @dev transmit token for a specified address. 
436 	* This is owner only method and should be called using web3.js if someone is trying to buy token using bitcoin or any other altcoin.
437 	* 
438 	* @param _to The address to transmit to.
439 	* @param _value The amount to be transferred.
440 	* @param _message message to log after transfer.
441 	*/
442 	function transferManual(address _to, uint256 _value, string _message) onlyOwner public returns (bool) {
443 		require(_to != address(0));
444 
445 		// transfer tokens manually from contract balance
446 		token.transfer(_to , _value);
447 		TransferManual(msg.sender, _to, _value, _message);
448 		return true;
449 	}
450 
451 	/**
452 	* @dev withdraw funds 
453 	* This will set the withdrawal wallet
454 	* 
455 	* @param _wallet The address to transmit to.
456 	*/	
457 	function setWallet(address _wallet) onlyOwner public returns(bool) {
458 		// set wallet 
459 		wallet = _wallet;
460 		WalletChange(_wallet , now);
461 		return true;
462 	}
463 
464 	/**
465 	* @dev Method called by owner of contract to withdraw funds
466 	*/
467 	function withdraw() onlyOwner public {
468 		wallet.transfer(this.balance);
469 	}
470 
471 	/**
472 	* @dev close contract 
473 	* This will send remaining token balance to owner
474 	* This will distribute available funds across team members
475 	*/	
476 	function close() onlyOwner public {
477 		// send remaining tokens back to owner.
478 		uint256 tokens = token.balanceOf(this); 
479 		token.transfer(owner , tokens);
480 
481 		// withdraw funds 
482 		withdraw();
483 
484 		// mark the flag to indicate closure of the contract
485 		isClose = true;
486 	}
487 }