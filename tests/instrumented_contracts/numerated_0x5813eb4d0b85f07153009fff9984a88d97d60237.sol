1 pragma solidity 0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11 	address public owner;
12 
13 
14 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17 	/**
18 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19 	 * account.
20 	 */
21 	function Ownable() public {
22 		owner = msg.sender;
23 	}
24 
25 	/**
26 	 * @dev Throws if called by any account other than the owner.
27 	 */
28 	modifier onlyOwner() {
29 		require(msg.sender == owner);
30 		_;
31 	}
32 
33 	/**
34 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
35 	* @param newOwner The address to transfer ownership to.
36 		*/
37 	function transferOwnership(address newOwner) public onlyOwner {
38 		require(newOwner != address(0));
39 		emit OwnershipTransferred(owner, newOwner);
40 		owner = newOwner;
41 	}
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53 	/**
54 	 * @dev Multiplies two numbers, throws on overflow.
55 	 */
56 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
57 		if (a == 0) {
58 			return 0;
59 		}
60 		c = a * b;
61 		assert(c / a == b);
62 		return c;
63 	}
64 
65 	/**
66 	 * @dev Integer division of two numbers, truncating the quotient.
67 	 */
68 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
69 		// assert(b > 0); // Solidity automatically throws when dividing by 0
70 		// uint256 c = a / b;
71 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
72 		return a / b;
73 	}
74 
75 	/**
76 	 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77 	 */
78 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79 		assert(b <= a);
80 		return a - b;
81 	}
82 
83 	/**
84 	 * @dev Adds two numbers, throws on overflow.
85 	 */
86 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87 		c = a + b;
88 		assert(c >= a);
89 		return c;
90 	}
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101 	function totalSupply() public view returns (uint256);
102 	function balanceOf(address who) public view returns (uint256);
103 	function transfer(address to, uint256 value) public returns (bool);
104 	event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114 	using SafeMath for uint256;
115 
116 	mapping(address => uint256) balances;
117 
118 	uint256 totalSupply_;
119 
120 	/**
121 	* @dev total number of tokens in existence
122 	*/
123 	function totalSupply() public view returns (uint256) {
124 		return totalSupply_;
125 	}
126 
127 	/**
128 	* @dev transfer token for a specified address
129 	* @param _to The address to transfer to.
130 		* @param _value The amount to be transferred.
131 			*/
132 	function transfer(address _to, uint256 _value) public returns (bool) {
133 		require(_to != address(0));
134 		require(_value <= balances[msg.sender]);
135 
136 		balances[msg.sender] = balances[msg.sender].sub(_value);
137 		balances[_to] = balances[_to].add(_value);
138 		emit Transfer(msg.sender, _to, _value);
139 		return true;
140 	}
141 
142 	/**
143 	* @dev Gets the balance of the specified address.
144 	* @param _owner The address to query the the balance of.
145 		* @return An uint256 representing the amount owned by the passed address.
146 		*/
147 	function balanceOf(address _owner) public view returns (uint256) {
148 		return balances[_owner];
149 	}
150 
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160 	function allowance(address owner, address spender) public view returns (uint256);
161 	function transferFrom(address from, address to, uint256 value) public returns (bool);
162 	function approve(address spender, uint256 value) public returns (bool);
163 	event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177 	mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180 	/**
181 	* @dev Transfer tokens from one address to another
182 	* @param _from address The address which you want to send tokens from
183 	* @param _to address The address which you want to transfer to
184 	* @param _value uint256 the amount of tokens to be transferred
185 	*/
186 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187 		require(_to != address(0));
188 		require(_value <= balances[_from]);
189 		require(_value <= allowed[_from][msg.sender]);
190 
191 		balances[_from] = balances[_from].sub(_value);
192 		balances[_to] = balances[_to].add(_value);
193 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194 		emit Transfer(_from, _to, _value);
195 		return true;
196 	}
197 
198 	/**
199 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200 	 *
201 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
202 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205 	 * @param _spender The address which will spend the funds.
206 	 * @param _value The amount of tokens to be spent.
207 	 */
208 	function approve(address _spender, uint256 _value) public returns (bool) {
209 		allowed[msg.sender][_spender] = _value;
210 		emit Approval(msg.sender, _spender, _value);
211 		return true;
212 	}
213 
214 	/**
215 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
216 	 * @param _owner address The address which owns the funds.
217 	 * @param _spender address The address which will spend the funds.
218 	 * @return A uint256 specifying the amount of tokens still available for the spender.
219 	 */
220 	function allowance(address _owner, address _spender) public view returns (uint256) {
221 		return allowed[_owner][_spender];
222 	}
223 
224 	/**
225 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
226 	 *
227 	 * approve should be called when allowed[_spender] == 0. To increment
228 	 * allowed value is better to use this function to avoid 2 calls (and wait until
229 	 * the first transaction is mined)
230 	 * From MonolithDAO Token.sol
231 	 * @param _spender The address which will spend the funds.
232 	 * @param _addedValue The amount of tokens to increase the allowance by.
233 	 */
234 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237 		return true;
238 	}
239 
240 	/**
241 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
242 	 *
243 	 * approve should be called when allowed[_spender] == 0. To decrement
244 	 * allowed value is better to use this function to avoid 2 calls (and wait until
245 	 * the first transaction is mined)
246 	 * From MonolithDAO Token.sol
247 	 * @param _spender The address which will spend the funds.
248 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
249 	 */
250 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251 		uint oldValue = allowed[msg.sender][_spender];
252 		if (_subtractedValue > oldValue) {
253 			allowed[msg.sender][_spender] = 0;
254 		} else {
255 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256 		}
257 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258 		return true;
259 	}
260 
261 }
262 
263 
264 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
265 
266 /**
267  * @title Pausable
268  * @dev Base contract which allows children to implement an emergency stop mechanism.
269  */
270 contract Pausable is Ownable {
271 	event Pause();
272 	event Unpause();
273 
274 	bool public paused = false;
275 
276 
277 	/**
278 	* @dev Modifier to make a function callable only when the contract is not paused.
279 	*/
280 	modifier whenNotPaused() {
281 		require(!paused);
282 		_;
283 	}
284 
285 	/**
286 	* @dev Modifier to make a function callable only when the contract is paused.
287 	*/
288 	modifier whenPaused() {
289 		require(paused);
290 		_;
291 	}
292 
293 	/**
294 	* @dev called by the owner to pause, triggers stopped state
295 	*/
296 	function pause() onlyOwner whenNotPaused public {
297 		paused = true;
298 		emit Pause();
299 	}
300 
301 	/**
302 	* @dev called by the owner to unpause, returns to normal state
303 	*/
304 	function unpause() onlyOwner whenPaused public {
305 		paused = false;
306 		emit Unpause();
307 	}
308 }
309 
310 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
311 
312 /**
313  * @title Crowdsale
314  * @dev Crowdsale is a base contract for managing a token crowdsale,
315  * allowing investors to purchase tokens with ether. This contract implements
316  * such functionality in its most fundamental form and can be extended to provide additional
317  * functionality and/or custom behavior.
318  * The external interface represents the basic interface for purchasing tokens, and conform
319  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
320  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
321  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
322  * behavior.
323  */
324 contract Crowdsale {
325 	using SafeMath for uint256;
326 
327 	// The token being sold
328 	ERC20 public token;
329 
330 	// Address where funds are collected
331 	address public wallet;
332 
333 	// How many token units a buyer gets per wei
334 	uint256 public rate;
335 
336 	// Amount of wei raised
337 	uint256 public weiRaised;
338 
339 	/**
340 	* Event for token purchase logging
341 	* @param purchaser who paid for the tokens
342 		* @param beneficiary who got the tokens
343 	* @param value weis paid for purchase
344 		* @param amount amount of tokens purchased
345 	*/
346 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
347 
348 	/**
349 	* @param _rate Number of token units a buyer gets per wei
350 	* @param _wallet Address where collected funds will be forwarded to
351 	* @param _token Address of the token being sold
352 	*/
353 	function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
354 		require(_rate > 0);
355 		require(_wallet != address(0));
356 		require(_token != address(0));
357 
358 		rate = _rate;
359 		wallet = _wallet;
360 		token = _token;
361 	}
362 
363 	// -----------------------------------------
364 	// Crowdsale external interface
365 	// -----------------------------------------
366 
367 	/**
368 	* @dev fallback function ***DO NOT OVERRIDE***
369 	*/
370 	function () external payable {
371 		buyTokens(msg.sender);
372 	}
373 
374 	/**
375 	* @dev low level token purchase ***DO NOT OVERRIDE***
376 	* @param _beneficiary Address performing the token purchase
377 	*/
378 	function buyTokens(address _beneficiary) public payable {
379 
380 		uint256 weiAmount = msg.value;
381 		_preValidatePurchase(_beneficiary, weiAmount);
382 
383 		// calculate token amount to be created
384 		uint256 tokens = _getTokenAmount(weiAmount);
385 
386 		// update state
387 		weiRaised = weiRaised.add(weiAmount);
388 
389 		_processPurchase(_beneficiary, tokens);
390 		emit TokenPurchase(
391 			msg.sender,
392 			_beneficiary,
393 			weiAmount,
394 			tokens
395 		);
396 
397 		_updatePurchasingState(_beneficiary, weiAmount);
398 
399 		_forwardFunds();
400 		_postValidatePurchase(_beneficiary, weiAmount);
401 	}
402 
403 	// -----------------------------------------
404 	// Internal interface (extensible)
405 	// -----------------------------------------
406 
407 	/**
408 	* @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
409 	* @param _beneficiary Address performing the token purchase
410 	* @param _weiAmount Value in wei involved in the purchase
411 	*/
412 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
413 		require(_beneficiary != address(0));
414 		require(_weiAmount != 0);
415 	}
416 
417 	/**
418 	* @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
419 	* @param _beneficiary Address performing the token purchase
420 	* @param _weiAmount Value in wei involved in the purchase
421 	*/
422 	function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
423 		// optional override
424 	}
425 
426 	/**
427 	* @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
428 	* @param _beneficiary Address performing the token purchase
429 	* @param _tokenAmount Number of tokens to be emitted
430 	*/
431 	function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
432 		token.transfer(_beneficiary, _tokenAmount);
433 	}
434 
435 	/**
436 	* @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
437 	* @param _beneficiary Address receiving the tokens
438 	* @param _tokenAmount Number of tokens to be purchased
439 	*/
440 	function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
441 		_deliverTokens(_beneficiary, _tokenAmount);
442 	}
443 
444 	/**
445 	* @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
446 	* @param _beneficiary Address receiving the tokens
447 	* @param _weiAmount Value in wei involved in the purchase
448 	*/
449 	function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
450 		// optional override
451 	}
452 
453 	/**
454 	* @dev Override to extend the way in which ether is converted to tokens.
455 	* @param _weiAmount Value in wei to be converted into tokens
456 	* @return Number of tokens that can be purchased with the specified _weiAmount
457 	*/
458 	function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
459 		return _weiAmount.mul(66666667).div(5000);
460 	}
461 
462 	/**
463 	* @dev Determines how ETH is stored/forwarded on purchases.
464 	*/
465 	function _forwardFunds() internal {
466 		wallet.transfer(msg.value);
467 	}
468 }
469 
470 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
471 
472 /**
473  * @title CappedCrowdsale
474  * @dev Crowdsale with a limit for total contributions.
475  */
476 contract CappedCrowdsale is Crowdsale {
477 	using SafeMath for uint256;
478 
479 	uint256 public cap;
480 
481 	/**
482 	* @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
483 	* @param _cap Max amount of wei to be contributed
484 	*/
485 	function CappedCrowdsale(uint256 _cap) public {
486 		require(_cap > 0);
487 		cap = _cap;
488 	}
489 
490 	/**
491 	* @dev Checks whether the cap has been reached. 
492 	* @return Whether the cap was reached
493 	*/
494 	function capReached() public view returns (bool) {
495 		return weiRaised >= cap;
496 	}
497 
498 	/**
499 	* @dev Extend parent behavior requiring purchase to respect the funding cap.
500 	* @param _beneficiary Token purchaser
501 	* @param _weiAmount Amount of wei contributed
502 	*/
503 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
504 		super._preValidatePurchase(_beneficiary, _weiAmount);
505 		require(weiRaised.add(_weiAmount) <= cap);
506 	}
507 
508 }
509 
510 contract AmountLimitCrowdsale is Crowdsale, Ownable {
511 	using SafeMath for uint256;
512 
513 	uint256 public min;
514 	uint256 public max;
515 
516 	mapping(address => uint256) public contributions;
517 
518 	function AmountLimitCrowdsale(uint256 _min, uint256 _max) public {
519 		require(_min > 0);
520 		require(_max > _min);
521 		// each person should contribute between min-max amount of wei
522 		min = _min;
523 		max = _max;
524 	}
525 
526 	function getUserContribution(address _beneficiary) public view returns (uint256) {
527 		return contributions[_beneficiary];
528 	}
529 
530 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
531 		super._preValidatePurchase(_beneficiary, _weiAmount);
532 		require(contributions[_beneficiary].add(_weiAmount) <= max);
533 		require(contributions[_beneficiary].add(_weiAmount) >= min);
534 	}
535 
536 	function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
537 		super._updatePurchasingState(_beneficiary, _weiAmount);
538 		// update total contribution
539 		contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
540 	}
541 }
542 
543 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
544 
545 /**
546  * @title TimedCrowdsale
547  * @dev Crowdsale accepting contributions only within a time frame.
548  */
549 contract TimedCrowdsale is Crowdsale {
550 	using SafeMath for uint256;
551 
552 	uint256 public openingTime;
553 	uint256 public closingTime;
554 
555 	/**
556 	* @dev Reverts if not in crowdsale time range.
557 	*/
558 	modifier onlyWhileOpen {
559 		// solium-disable-next-line security/no-block-members
560 		require(block.timestamp >= openingTime && block.timestamp <= closingTime);
561 		_;
562 	}
563 
564 	/**
565 	* @dev Constructor, takes crowdsale opening and closing times.
566 	* @param _openingTime Crowdsale opening time
567 	* @param _closingTime Crowdsale closing time
568 	*/
569 	function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
570 		// solium-disable-next-line security/no-block-members
571 		require(_openingTime >= block.timestamp);
572 		require(_closingTime >= _openingTime);
573 
574 		openingTime = _openingTime;
575 		closingTime = _closingTime;
576 	}
577 
578 	/**
579 	* @dev Checks whether the period in which the crowdsale is open has already elapsed.
580 	* @return Whether crowdsale period has elapsed
581 	*/
582 	function hasClosed() public view returns (bool) {
583 		// solium-disable-next-line security/no-block-members
584 		return block.timestamp > closingTime;
585 	}
586 
587 	/**
588 	* @dev Extend parent behavior requiring to be within contributing period
589 	* @param _beneficiary Token purchaser
590 	* @param _weiAmount Amount of wei contributed
591 	*/
592 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
593 		super._preValidatePurchase(_beneficiary, _weiAmount);
594 	}
595 
596 }
597 
598 // File: zeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
599 
600 /**
601  * @title WhitelistedCrowdsale
602  * @dev Crowdsale in which only whitelisted users can contribute.
603  */
604 contract WhitelistedCrowdsale is Crowdsale, Ownable {
605 
606 	mapping(address => bool) public whitelist;
607 
608 	/**
609 	* @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
610 	*/
611 	modifier isWhitelisted(address _beneficiary) {
612 		require(whitelist[_beneficiary]);
613 		_;
614 	}
615 
616 	/**
617 	* @dev Adds single address to whitelist.
618 	* @param _beneficiary Address to be added to the whitelist
619 	*/
620 	function addToWhitelist(address _beneficiary) external onlyOwner {
621 		whitelist[_beneficiary] = true;
622 	}
623 
624 	/**
625 	* @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
626 	* @param _beneficiaries Addresses to be added to the whitelist
627 	*/
628 	function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
629 		for (uint256 i = 0; i < _beneficiaries.length; i++) {
630 			whitelist[_beneficiaries[i]] = true;
631 		}
632 	}
633 
634 	/**
635 	* @dev Removes single address from whitelist.
636 	* @param _beneficiary Address to be removed to the whitelist
637 	*/
638 	function removeFromWhitelist(address _beneficiary) external onlyOwner {
639 		whitelist[_beneficiary] = false;
640 	}
641 
642 	/**
643 	* @dev Extend parent behavior requiring beneficiary to be in whitelist.
644 	* @param _beneficiary Token beneficiary
645 	* @param _weiAmount Amount of wei contributed
646 	*/
647 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
648 		super._preValidatePurchase(_beneficiary, _weiAmount);
649 	}
650 
651 }
652 
653 contract T2TCrowdsale is WhitelistedCrowdsale, AmountLimitCrowdsale, CappedCrowdsale,
654 TimedCrowdsale, Pausable {
655 	using SafeMath for uint256;
656 
657 	uint256 public distributeTime;
658 	mapping(address => uint256) public balances;
659 
660 	function T2TCrowdsale(uint256 rate, 
661 		uint256 openTime, 
662 		uint256 closeTime, 
663 		uint256 totalCap,
664 		uint256 userMin,
665 		uint256 userMax,
666 		uint256 _distributeTime,
667 		address account,
668 		StandardToken token)
669 		Crowdsale(rate, account, token)
670 		TimedCrowdsale(openTime, closeTime)
671 		CappedCrowdsale(totalCap)
672 		AmountLimitCrowdsale(userMin, userMax) public {
673 	  distributeTime = _distributeTime;
674 	}
675 
676 	function withdrawTokens(address _beneficiary) public {
677 	  require(block.timestamp > distributeTime);
678 	  uint256 amount = balances[_beneficiary];
679 	  require(amount > 0);
680 	  balances[_beneficiary] = 0;
681 	  _deliverTokens(_beneficiary, amount);
682 	}
683 
684 	function distributeTokens(address[] _beneficiaries) external onlyOwner {
685 		for (uint256 i = 0; i < _beneficiaries.length; i++) {
686 			require(block.timestamp > distributeTime);
687 			address _beneficiary = _beneficiaries[i];
688 			uint256 amount = balances[_beneficiary];
689 			if(amount > 0) {
690 				balances[_beneficiary] = 0;
691 				_deliverTokens(_beneficiary, amount);
692 			}
693 		}
694 	}
695 
696 	function returnTokens(address _beneficiary, uint256 amount) external onlyOwner {
697 		_deliverTokens(_beneficiary, amount);
698 	}
699 
700 	function _processPurchase(
701 	  address _beneficiary,
702 	  uint256 _tokenAmount
703 	)
704 	internal {
705 	  balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
706 	}
707 
708 	function buyTokens(address beneficiary) public payable whenNotPaused {
709 	  super.buyTokens(beneficiary);
710 	}
711 }