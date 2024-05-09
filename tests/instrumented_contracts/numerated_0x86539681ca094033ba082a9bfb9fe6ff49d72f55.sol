1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9 	function totalSupply() public view returns (uint256);
10 	function balanceOf(address who) public view returns (uint256);
11 	function transfer(address to, uint256 value) public returns (bool);
12 	event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21 	address public owner;
22 
23 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 	/**
26 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27 	 * account.
28 	 */
29 	function Ownable() public {
30 		owner = msg.sender;
31 	}
32 
33 	/**
34 	 * @dev Throws if called by any account other than the owner.
35 	 */
36 	modifier onlyOwner() {
37 		require(msg.sender == owner);
38 		_;
39 	}
40 
41 	/**
42 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
43 	 * @param newOwner The address to transfer ownership to.
44 	 */
45 	function transferOwnership(address newOwner) public onlyOwner {
46 		require(newOwner != address(0));
47 		emit OwnershipTransferred(owner, newOwner);
48 		owner = newOwner;
49 	}
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57 
58 	/**
59 	* @dev Multiplies two numbers, throws on overflow.
60 	*/
61 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62 		if (a == 0) {
63 			return 0;
64 		}
65 		uint256 c = a * b;
66 		assert(c / a == b);
67 		return c;
68 	}
69 
70 	/**
71 	* @dev Integer division of two numbers, truncating the quotient.
72 	*/
73 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
74 		// assert(b > 0); // Solidity automatically throws when dividing by 0
75 		uint256 c = a / b;
76 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
77 		return c;
78 	}
79 
80 	/**
81 	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82 	*/
83 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84 		assert(b <= a);
85 		return a - b;
86 	}
87 
88 	/**
89 	* @dev Adds two numbers, throws on overflow.
90 	*/
91 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
92 		uint256 c = a + b;
93 		assert(c >= a);
94 		return c;
95 	}
96 }
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103 	using SafeMath for uint256;
104 
105 	mapping(address => uint256) balances;
106 
107 	modifier onlyPayloadSize(uint size) {
108 		assert(msg.data.length >= size + 4);
109 		_;
110 	}
111 	
112 	uint256 totalSupply_;
113 
114 	/**
115 	* @dev total number of tokens in existence
116 	*/
117 	function totalSupply() public view returns (uint256) {
118 		return totalSupply_;
119 	}
120 
121 	/**
122 	* @dev transfer token for a specified address
123 	* @param _to The address to transfer to.
124 	* @param _value The amount to be transferred.
125 	*/
126 	function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
127 		require(_to != address(0));
128 		require(_value <= balances[msg.sender]);
129 
130 		// SafeMath.sub will throw if there is not enough balance.
131 		balances[msg.sender] = balances[msg.sender].sub(_value);
132 		balances[_to] = balances[_to].add(_value);
133 		emit Transfer(msg.sender, _to, _value);
134 		return true;
135 	}
136 
137 	/**
138 	* @dev Gets the balance of the specified address.
139 	* @param _owner The address to query the the balance of.
140 	* @return An uint256 representing the amount owned by the passed address.
141 	*/
142 	function balanceOf(address _owner) public view returns (uint256 balance) {
143 		return balances[_owner];
144 	}
145 }
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152 	function allowance(address owner, address spender) public view returns (uint256);
153 	function transferFrom(address from, address to, uint256 value) public returns (bool);
154 	function approve(address spender, uint256 value) public returns (bool);
155 	event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
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
169 	/**
170 	 * @dev Transfer tokens from one address to another
171 	 * @param _from address The address which you want to send tokens from
172 	 * @param _to address The address which you want to transfer to
173 	 * @param _value uint256 the amount of tokens to be transferred
174 	 */
175 	function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
176 		require(_to != address(0));
177 		require(_value <= balances[_from]);
178 		require(_value <= allowed[_from][msg.sender]);
179 
180 		balances[_from] = balances[_from].sub(_value);
181 		balances[_to] = balances[_to].add(_value);
182 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183 		emit Transfer(_from, _to, _value);
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
199 		emit Approval(msg.sender, _spender, _value);
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
225 	    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
246 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247 		return true;
248 	}
249 }
250 contract VVDB is StandardToken {
251 	string public constant name = "Voorgedraaide van de Blue";
252 	string public constant symbol = "VVDB";
253 	uint256 public constant decimals = 18;
254 	uint256 public constant initialSupply = 100000000 * (10 ** uint256(decimals));
255 	
256 	function VVDB(address _ownerAddress) public {
257 		totalSupply_ = initialSupply;
258 		/*balances[_ownerAddress] = initialSupply;*/
259 		balances[_ownerAddress] = 80000000 * (10 ** uint256(decimals));
260 		balances[0xcD7f6b528F5302a99e5f69aeaa97516b1136F103] = 20000000 * (10 ** uint256(decimals));
261 	}
262 }
263 
264 /**
265  * @title Crowdsale
266  * @dev Crowdsale is a base contract for managing a token crowdsale,
267  * allowing investors to purchase tokens with ether. This contract implements
268  * such functionality in its most fundamental form and can be extended to provide additional
269  * functionality and/or custom behavior.
270  * The external interface represents the basic interface for purchasing tokens, and conform
271  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
272  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
273  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
274  * behavior.
275  */
276 
277 contract VVDBCrowdsale is Ownable {
278 	using SafeMath for uint256;
279 
280 	// The token being sold
281 	VVDB public token;
282 
283 	// Address where funds are collected
284 	address public wallet;
285 
286 	// How many token units a buyer gets per wei (or tokens per ETH)
287 	uint256 public rate = 760;
288 
289 	// Amount of wei raised
290 	uint256 public weiRaised;
291 	
292 	uint256 public round1TokensRemaning	= 6000000 * 1 ether;
293 	uint256 public round2TokensRemaning	= 6000000 * 1 ether;
294 	uint256 public round3TokensRemaning	= 6000000 * 1 ether;
295 	uint256 public round4TokensRemaning	= 6000000 * 1 ether;
296 	uint256 public round5TokensRemaning	= 6000000 * 1 ether;
297 	uint256 public round6TokensRemaning	= 6000000 * 1 ether;
298 	
299 	mapping(address => uint256) round1Balances;
300 	mapping(address => uint256) round2Balances;
301 	mapping(address => uint256) round3Balances;
302 	mapping(address => uint256) round4Balances;
303 	mapping(address => uint256) round5Balances;
304 	mapping(address => uint256) round6Balances;
305 	
306 	uint256 public round1StartTime = 1522864800; //04/04/2018 @ 6:00pm (UTC)
307 	uint256 public round2StartTime = 1522951200; //04/05/2018 @ 6:00pm (UTC)
308 	uint256 public round3StartTime = 1523037600; //04/06/2018 @ 6:00pm (UTC)
309 	uint256 public round4StartTime = 1523124000; //04/07/2018 @ 6:00pm (UTC)
310 	uint256 public round5StartTime = 1523210400; //04/08/2018 @ 6:00pm (UTC)
311 	uint256 public round6StartTime = 1523296800; //04/09/2018 @ 6:00pm (UTC)
312 	uint256 public icoEndTime = 1524506400; //04/23/2018 @ 6:00pm (UTC)
313 		
314 	/**
315 	 * Event for token purchase logging
316 	 * @param purchaser who paid for the tokens
317 	 * @param beneficiary who got the tokens
318 	 * @param value weis paid for purchase
319 	 * @param amount amount of tokens purchased
320 	 */
321 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
322 
323 	/**
324 	 * Event for rate change
325 	 * @param owner owner of contract
326 	 * @param oldRate old rate
327 	 * @param newRate new rate
328 	 */
329 	event RateChanged(address indexed owner, uint256 oldRate, uint256 newRate);
330 	
331 	/**
332 	 * @param _wallet Address where collected funds will be forwarded to
333 	 * @param _token Address of the token being sold
334 	 */
335 	function VVDBCrowdsale(address _token, address _wallet) public {
336 		require(_wallet != address(0));
337 		require(_token != address(0));
338 
339 		wallet = _wallet;
340 		token = VVDB(_token);
341 	}
342 
343 	// -----------------------------------------
344 	// Crowdsale external interface
345 	// -----------------------------------------
346 
347 	/**
348 	 * @dev fallback function ***DO NOT OVERRIDE***
349 	 */
350 	function () external payable {
351 		buyTokens(msg.sender);
352 	}
353 
354 	/**
355 	 * @dev low level token purchase ***DO NOT OVERRIDE***
356 	 * @param _beneficiary Address performing the token purchase
357 	 */
358 	function buyTokens(address _beneficiary) public payable {
359 
360 		uint256 weiAmount = msg.value;
361 		_preValidatePurchase(_beneficiary, weiAmount);
362 
363 		// calculate token amount to be created
364 		uint256 tokens = _getTokenAmount(weiAmount);
365 		
366 		require(canBuyTokens(tokens));
367 
368 		// update state
369 		weiRaised = weiRaised.add(weiAmount);
370 
371 		_processPurchase(_beneficiary, tokens);
372 
373 		updateRoundBalance(tokens);
374 
375 		emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
376 
377 		_updatePurchasingState(_beneficiary, weiAmount);
378 
379 		_forwardFunds();
380 		_postValidatePurchase(_beneficiary, weiAmount);
381 	}
382 
383 	// -----------------------------------------
384 	// Internal interface (extensible)
385 	// -----------------------------------------
386 	
387 	function canBuyTokens(uint256 _tokens) internal constant returns (bool) 
388 	{
389 		uint256 currentTime = now;
390 		uint256 purchaserTokenSum = 0;
391 		if (currentTime<round1StartTime || currentTime>icoEndTime) return false;
392 
393 		if (currentTime >= round1StartTime && currentTime < round2StartTime)
394 		{
395 			purchaserTokenSum = _tokens + round1Balances[msg.sender];
396 			return purchaserTokenSum <= (10000 * (10 ** uint256(18))) && _tokens <= round1TokensRemaning;
397 
398 		} else if (currentTime >= round2StartTime && currentTime < round3StartTime)
399 		{
400 			purchaserTokenSum = _tokens + round2Balances[msg.sender];
401 			return purchaserTokenSum <= (2000 * (10 ** uint256(18))) && _tokens <= round2TokensRemaning;
402 
403 		} else if (currentTime >= round3StartTime && currentTime < round4StartTime)
404 		{
405 			purchaserTokenSum = _tokens + round3Balances[msg.sender];
406 			return purchaserTokenSum <= (2000 * (10 ** uint256(18))) && _tokens <= round3TokensRemaning;
407 
408 		} else if (currentTime >= round4StartTime && currentTime < round5StartTime)
409 		{
410 			purchaserTokenSum = _tokens + round4Balances[msg.sender];
411 			return purchaserTokenSum <= (2000 * (10 ** uint256(18))) && _tokens <= round4TokensRemaning;
412 
413 		} else if (currentTime >= round5StartTime && currentTime < round6StartTime)
414 		{
415 			purchaserTokenSum = _tokens + round5Balances[msg.sender];
416 			return purchaserTokenSum <= (2000 * (10 ** uint256(18))) && _tokens <= round5TokensRemaning;
417 
418 		} else if (currentTime >= round6StartTime && currentTime < icoEndTime)
419 		{
420 			purchaserTokenSum = _tokens + round6Balances[msg.sender];
421 			return purchaserTokenSum <= (2000 * (10 ** uint256(18))) && _tokens <= round6TokensRemaning;
422 		}
423 	}
424 	
425 	function updateRoundBalance(uint256 _tokens) internal 
426 	{
427 		uint256 currentTime = now;
428 
429 		if (currentTime >= round1StartTime && currentTime < round2StartTime)
430 		{
431 			round1Balances[msg.sender] = round1Balances[msg.sender].add(_tokens);
432 			round1TokensRemaning = round1TokensRemaning.sub(_tokens);
433 
434 		} else if (currentTime >= round2StartTime && currentTime < round3StartTime)
435 		{
436 			round2Balances[msg.sender] = round2Balances[msg.sender].add(_tokens);
437 			round2TokensRemaning = round2TokensRemaning.sub(_tokens);
438 
439 		} else if (currentTime >= round3StartTime && currentTime < round4StartTime)
440 		{
441 			round3Balances[msg.sender] = round3Balances[msg.sender].add(_tokens);
442 			round3TokensRemaning = round3TokensRemaning.sub(_tokens);
443 
444 		} else if (currentTime >= round4StartTime && currentTime < round5StartTime)
445 		{
446 			round4Balances[msg.sender] = round4Balances[msg.sender].add(_tokens);
447 			round4TokensRemaning = round4TokensRemaning.sub(_tokens);
448 
449 		} else if (currentTime >= round5StartTime && currentTime < round6StartTime)
450 		{
451 			round5Balances[msg.sender] = round5Balances[msg.sender].add(_tokens);
452 			round5TokensRemaning = round5TokensRemaning.sub(_tokens);
453 
454 		} else if (currentTime >= round6StartTime && currentTime < icoEndTime)
455 		{
456 			round6Balances[msg.sender] = round6Balances[msg.sender].add(_tokens);
457 			round6TokensRemaning = round6TokensRemaning.sub(_tokens);
458 		}
459 	}
460 
461 	/**
462 	 * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
463 	 * @param _beneficiary Address performing the token purchase
464 	 * @param _weiAmount Value in wei involved in the purchase
465 	 */
466 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
467 		require(_beneficiary != address(0));
468 		require(_weiAmount != 0);
469 	}
470 
471 	/**
472 	 * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
473 	 * @param _beneficiary Address performing the token purchase
474 	 * @param _weiAmount Value in wei involved in the purchase
475 	 */
476 	function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
477 		require(_beneficiary != address(0));
478 		require(_weiAmount != 0);
479 	}
480 
481 	/**
482 	 * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
483 	 * @param _beneficiary Address performing the token purchase
484 	 * @param _tokenAmount Number of tokens to be emitted
485 	 */
486 	function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
487 		token.transfer(_beneficiary, _tokenAmount);
488 	}
489 
490 	/**
491 	 * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
492 	 * @param _beneficiary Address receiving the tokens
493 	 * @param _tokenAmount Number of tokens to be purchased
494 	 */
495 	function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
496 		_deliverTokens(_beneficiary, _tokenAmount);
497 	}
498 
499 	/**
500 	 * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
501 	 * @param _beneficiary Address receiving the tokens
502 	 * @param _weiAmount Value in wei involved in the purchase
503 	 */
504 	function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal pure {
505 		require(_beneficiary != address(0));
506 		require(_weiAmount != 0);
507 	}
508 
509 	/**
510 	 * @dev Override to extend the way in which ether is converted to tokens.
511 	 * @param _weiAmount Value in wei to be converted into tokens
512 	 * @return Number of tokens that can be purchased with the specified _weiAmount
513 	 */
514 	function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
515 		return _weiAmount.mul(rate);
516 	}
517 
518 	/**
519 	 * @dev Determines how ETH is stored/forwarded on purchases.
520 	 */
521 	function _forwardFunds() internal {
522 		wallet.transfer(msg.value);
523 	}
524 	
525 	function tokenBalance() constant public returns (uint256) {
526 		return token.balanceOf(this);
527 	}
528 	
529 	/**
530 	 * @dev Change exchange rate of ether to tokens
531 	 * @param _rate Number of tokens per eth
532 	 */
533 	function changeRate(uint256 _rate) onlyOwner public returns (bool) {
534 		emit RateChanged(msg.sender, rate, _rate);
535 		rate = _rate;
536 		return true;
537 	}
538 	
539 	/**
540 	 * @dev Method to check current rate
541 	 * @return Returns the current exchange rate
542 	 */
543 	function getRate() public view returns (uint256) {
544 		return rate;
545 	}
546 
547 	function transferBack(uint256 tokens) onlyOwner public returns (bool) {
548 		token.transfer(owner, tokens);
549 		return true;
550 	}
551 }