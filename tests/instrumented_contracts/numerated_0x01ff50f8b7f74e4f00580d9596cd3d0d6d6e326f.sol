1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10 	uint256 public totalSupply;
11 	function balanceOf(address who) public view returns (uint256);
12 	function transfer(address to, uint256 value) public returns (bool);
13 	event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21 	function allowance(address owner, address spender) public view returns (uint256);
22 	function transferFrom(address from, address to, uint256 value) public returns (bool);
23 	function approve(address spender, uint256 value) public returns (bool);
24 	event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 contract DetailedERC20 is ERC20 {
29 	string public name;
30 	string public symbol;
31 	uint8 public decimals;
32 
33 	function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
34 		name = _name;
35 		symbol = _symbol;
36 		decimals = _decimals;
37 	}
38 }
39 
40 
41 /**
42  * @title Basic token
43  * @dev Basic version of StandardToken, with no allowances.
44  */
45 contract BasicToken is ERC20Basic {
46 	using SafeMath for uint256;
47 
48 	mapping(address => uint256) balances;
49 
50 	/**
51 	* @dev transfer token for a specified address
52 	* @param _to The address to transfer to.
53 	* @param _value The amount to be transferred.
54 	*/
55 	function transfer(address _to, uint256 _value) public returns (bool) {
56 		require(_to != address(0));
57 		require(_value <= balances[msg.sender]);
58 
59 		// SafeMath.sub will throw if there is not enough balance.
60 		balances[msg.sender] = balances[msg.sender].sub(_value);
61 		balances[_to] = balances[_to].add(_value);
62 		Transfer(msg.sender, _to, _value);
63 		return true;
64 	}
65 
66 	/**
67 	* @dev Gets the balance of the specified address.
68 	* @param _owner The address to query the the balance of.
69 	* @return An uint256 representing the amount owned by the passed address.
70 	*/
71 	function balanceOf(address _owner) public view returns (uint256 balance) {
72 		return balances[_owner];
73 	}
74 
75 }
76 
77 /**
78  * @title Standard ERC20 token
79  *
80  * @dev Implementation of the basic standard token.
81  * @dev https://github.com/ethereum/EIPs/issues/20
82  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
83  */
84 contract StandardToken is ERC20, BasicToken {
85 
86 	mapping (address => mapping (address => uint256)) internal allowed;
87 
88 
89 	/**
90 	 * @dev Transfer tokens from one address to another
91 	 * @param _from address The address which you want to send tokens from
92 	 * @param _to address The address which you want to transfer to
93 	 * @param _value uint256 the amount of tokens to be transferred
94 	 */
95 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96 		require(_to != address(0));
97 		require(_value <= balances[_from]);
98 		require(_value <= allowed[_from][msg.sender]);
99 
100 		balances[_from] = balances[_from].sub(_value);
101 		balances[_to] = balances[_to].add(_value);
102 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103 		Transfer(_from, _to, _value);
104 		return true;
105 	}
106 
107 	/**
108 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
109 	 *
110 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
111 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
112 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
113 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114 	 * @param _spender The address which will spend the funds.
115 	 * @param _value The amount of tokens to be spent.
116 	 */
117 	function approve(address _spender, uint256 _value) public returns (bool) {
118 		allowed[msg.sender][_spender] = _value;
119 		Approval(msg.sender, _spender, _value);
120 		return true;
121 	}
122 
123 	/**
124 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
125 	 * @param _owner address The address which owns the funds.
126 	 * @param _spender address The address which will spend the funds.
127 	 * @return A uint256 specifying the amount of tokens still available for the spender.
128 	 */
129 	function allowance(address _owner, address _spender) public view returns (uint256) {
130 		return allowed[_owner][_spender];
131 	}
132 
133 	/**
134 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
135 	 *
136 	 * approve should be called when allowed[_spender] == 0. To increment
137 	 * allowed value is better to use this function to avoid 2 calls (and wait until
138 	 * the first transaction is mined)
139 	 * From MonolithDAO Token.sol
140 	 * @param _spender The address which will spend the funds.
141 	 * @param _addedValue The amount of tokens to increase the allowance by.
142 	 */
143 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
144 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
145 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146 		return true;
147 	}
148 
149 	/**
150 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
151 	 *
152 	 * approve should be called when allowed[_spender] == 0. To decrement
153 	 * allowed value is better to use this function to avoid 2 calls (and wait until
154 	 * the first transaction is mined)
155 	 * From MonolithDAO Token.sol
156 	 * @param _spender The address which will spend the funds.
157 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
158 	 */
159 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
160 		uint oldValue = allowed[msg.sender][_spender];
161 		if (_subtractedValue > oldValue) {
162 			allowed[msg.sender][_spender] = 0;
163 		} else {
164 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
165 		}
166 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167 		return true;
168 	}
169 
170 }
171 
172 /**
173  * @title Ownable
174  * @dev The Ownable contract has an owner address, and provides basic authorization control
175  * functions, this simplifies the implementation of "user permissions".
176  */
177 contract Ownable {
178 	address public owner;
179 
180 
181 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182 
183 
184 	/**
185 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186 	 * account.
187 	 */
188 	function Ownable() public {
189 		owner = msg.sender;
190 	}
191 
192 
193 	/**
194 	 * @dev Throws if called by any account other than the owner.
195 	 */
196 	modifier onlyOwner() {
197 		require(msg.sender == owner);
198 		_;
199 	}
200 
201 
202 	/**
203 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
204 	 * @param newOwner The address to transfer ownership to.
205 	 */
206 	function transferOwnership(address newOwner) public onlyOwner {
207 		require(newOwner != address(0));
208 		OwnershipTransferred(owner, newOwner);
209 		owner = newOwner;
210 	}
211 
212 }
213 
214 
215 /**
216  * @title Pausable
217  * @dev Base contract which allows children to implement an emergency stop mechanism.
218  */
219 contract Pausable is Ownable {
220 	event Pause();
221 	event Unpause();
222 
223 	bool public paused = false;
224 
225 
226 	/**
227 	 * @dev Modifier to make a function callable only when the contract is not paused.
228 	 */
229 	modifier whenNotPaused() {
230 		require(!paused);
231 		_;
232 	}
233 
234 	/**
235 	 * @dev Modifier to make a function callable only when the contract is paused.
236 	 */
237 	modifier whenPaused() {
238 		require(paused);
239 		_;
240 	}
241 
242 	/**
243 	 * @dev called by the owner to pause, triggers stopped state
244 	 */
245 	function pause() onlyOwner whenNotPaused public {
246 		paused = true;
247 		Pause();
248 	}
249 
250 	/**
251 	 * @dev called by the owner to unpause, returns to normal state
252 	 */
253 	function unpause() onlyOwner whenPaused public {
254 		paused = false;
255 		Unpause();
256 	}
257 }
258 
259 
260 
261 
262 /**
263  * @title Mintable token
264  * @dev Simple ERC20 Token example, with mintable token creation
265  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
266  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
267  */
268 
269 contract MintableToken is StandardToken, Ownable {
270 	event Mint(address indexed to, uint256 amount);
271 	event MintFinished();
272 
273 	bool public mintingFinished = false;
274 
275 
276 	modifier canMint() {
277 		require(!mintingFinished);
278 		_;
279 	}
280 
281 	/**
282 	 * @dev Function to mint tokens
283 	 * @param _to The address that will receive the minted tokens.
284 	 * @param _amount The amount of tokens to mint.
285 	 * @return A boolean that indicates if the operation was successful.
286 	 */
287 	function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
288 		totalSupply = totalSupply.add(_amount);
289 		balances[_to] = balances[_to].add(_amount);
290 		Mint(_to, _amount);
291 		Transfer(address(0), _to, _amount);
292 		return true;
293 	}
294 
295 	/**
296 	 * @dev Function to stop minting new tokens.
297 	 * @return True if the operation was successful.
298 	 */
299 	function finishMinting() onlyOwner canMint public returns (bool) {
300 		mintingFinished = true;
301 		MintFinished();
302 		return true;
303 	}
304 }
305 
306 
307 /**
308  * @title Capped token
309  * @dev Mintable token with a token cap.
310  */
311 
312 contract CappedToken is MintableToken {
313 
314 	uint256 public cap;
315 
316 	function CappedToken(uint256 _cap) public {
317 		require(_cap > 0);
318 		cap = _cap;
319 	}
320 
321 	/**
322 	 * @dev Function to mint tokens
323 	 * @param _to The address that will receive the minted tokens.
324 	 * @param _amount The amount of tokens to mint.
325 	 * @return A boolean that indicates if the operation was successful.
326 	 */
327 	function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
328 		require(totalSupply.add(_amount) <= cap);
329 
330 		return super.mint(_to, _amount);
331 	}
332 
333 }
334 
335 /**
336  * @title Burnable Token
337  * @dev Token that can be irreversibly burned (destroyed).
338  */
339 contract BurnableToken is BasicToken {
340 
341 	event Burn(address indexed burner, uint256 value);
342 
343 	/**
344 	 * @dev Burns a specific amount of tokens.
345 	 * @param _value The amount of token to be burned.
346 	 */
347 	function burn(uint256 _value) public {
348 		require(_value <= balances[msg.sender]);
349 		// no need to require value <= totalSupply, since that would imply the
350 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
351 
352 		address burner = msg.sender;
353 		balances[burner] = balances[burner].sub(_value);
354 		totalSupply = totalSupply.sub(_value);
355 		Burn(burner, _value);
356 	}
357 }
358 
359 
360 /**
361  * @title SafeMath
362  * @dev Math operations with safety checks that throw on error
363  */
364 library SafeMath {
365 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
366 		if (a == 0) {
367 			return 0;
368 		}
369 		uint256 c = a * b;
370 		assert(c / a == b);
371 		return c;
372 	}
373 
374 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
375 		// assert(b > 0); // Solidity automatically throws when dividing by 0
376 		uint256 c = a / b;
377 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
378 		return c;
379 	}
380 
381 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
382 		assert(b <= a);
383 		return a - b;
384 	}
385 
386 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
387 		uint256 c = a + b;
388 		assert(c >= a);
389 		return c;
390 	}
391 }
392 
393 
394 
395 /**
396  * @title Crowdsale
397  * @dev Crowdsale is a base contract for managing a token crowdsale.
398  * Crowdsales have a start and end timestamps, where investors can make
399  * token purchases and the crowdsale will assign them tokens based
400  * on a token per ETH rate. Funds collected are forwarded to a wallet
401  * as they arrive.
402  */
403 contract Crowdsale {
404 	using SafeMath for uint256;
405 
406 	// The token being sold
407 	MintableToken public token;
408 
409 	// start and end timestamps where investments are allowed (both inclusive)
410 	uint256 public startTime;
411 	uint256 public endTime;
412 
413 	// address where funds are collected
414 	address public wallet;
415 
416 	// how many token units a buyer gets per wei
417 	uint256 public rate;
418 
419 	// amount of raised money in wei
420 	uint256 public weiRaised;
421 
422 	/**
423 	 * event for token purchase logging
424 	 * @param purchaser who paid for the tokens
425 	 * @param beneficiary who got the tokens
426 	 * @param value weis paid for purchase
427 	 * @param amount amount of tokens purchased
428 	 */
429 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
430 
431 
432 	function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
433 		require(_startTime >= now);
434 		require(_endTime >= _startTime);
435 		require(_rate > 0);
436 		require(_wallet != address(0));
437 
438 		token = createTokenContract();
439 		startTime = _startTime;
440 		endTime = _endTime;
441 		rate = _rate;
442 		wallet = _wallet;
443 	}
444 
445 	// creates the token to be sold.
446 	// override this method to have crowdsale of a specific mintable token.
447 	function createTokenContract() internal returns (MintableToken) {
448 		return new MintableToken();
449 	}
450 
451 
452 	// fallback function can be used to buy tokens
453 	function () external payable {
454 		buyTokens(msg.sender);
455 	}
456 
457 	// low level token purchase function
458 	function buyTokens(address beneficiary) public payable {
459 		require(beneficiary != address(0));
460 		require(validPurchase());
461 
462 		uint256 weiAmount = msg.value;
463 
464 		// calculate token amount to be created
465 		uint256 tokens = weiAmount.mul(rate);
466 
467 		// update state
468 		weiRaised = weiRaised.add(weiAmount);
469 
470 		token.mint(beneficiary, tokens);
471 		TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
472 
473 		forwardFunds();
474 	}
475 
476 	// send ether to the fund collection wallet
477 	// override to create custom fund forwarding mechanisms
478 	function forwardFunds() internal {
479 		wallet.transfer(msg.value);
480 	}
481 
482 	// @return true if the transaction can buy tokens
483 	function validPurchase() internal view returns (bool) {
484 		bool withinPeriod = now >= startTime && now <= endTime;
485 		bool nonZeroPurchase = msg.value != 0;
486 		return withinPeriod && nonZeroPurchase;
487 	}
488 
489 	// @return true if crowdsale event has ended
490 	function hasEnded() public view returns (bool) {
491 		return now > endTime;
492 	}
493 
494 
495 }
496 
497 /**
498  * @title CappedCrowdsale
499  * @dev Extension of Crowdsale with a max amount of funds raised
500  */
501 contract CappedCrowdsale is Crowdsale {
502 	using SafeMath for uint256;
503 
504 	uint256 public cap;
505 
506 	function CappedCrowdsale(uint256 _cap) public {
507 		require(_cap > 0);
508 		cap = _cap;
509 	}
510 
511 	// overriding Crowdsale#validPurchase to add extra cap logic
512 	// @return true if investors can buy at the moment
513 	function validPurchase() internal view returns (bool) {
514 		bool withinCap = weiRaised.add(msg.value) <= cap;
515 		return super.validPurchase() && withinCap;
516 	}
517 
518 	// overriding Crowdsale#hasEnded to add cap logic
519 	// @return true if crowdsale event has ended
520 	function hasEnded() public view returns (bool) {
521 		bool capReached = weiRaised >= cap;
522 		return super.hasEnded() || capReached;
523 	}
524 
525 }
526 
527 
528 /**
529  * @title Pausable token
530  *
531  * @dev StandardToken modified with pausable transfers.
532  **/
533 
534 contract PausableToken is StandardToken, Pausable {
535 
536   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
537     return super.transfer(_to, _value);
538   }
539 
540   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
541     return super.transferFrom(_from, _to, _value);
542   }
543 
544   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
545     return super.approve(_spender, _value);
546   }
547 
548   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
549     return super.increaseApproval(_spender, _addedValue);
550   }
551 
552   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
553     return super.decreaseApproval(_spender, _subtractedValue);
554   }
555 }
556 
557 contract BftToken is DetailedERC20, CappedToken, BurnableToken, PausableToken {
558 
559 	CappedCrowdsale public crowdsale;
560 
561 	function BftToken(
562 		uint256 _tokenCap,
563 		uint8 _decimals,
564 		CappedCrowdsale _crowdsale
565 	)
566 		DetailedERC20("BF Token", "BFT", _decimals)
567 		CappedToken(_tokenCap) public {
568 
569 		crowdsale = _crowdsale;
570 	}
571 
572 	// ----------------------------------------------------------------------------------------------------------------
573 	// the following is the functionality to upgrade this token smart contract to a new one
574 
575 	MintableToken public newToken = MintableToken(0x0);
576 	event LogRedeem(address beneficiary, uint256 amount);
577 
578 	modifier hasUpgrade() {
579 		require(newToken != MintableToken(0x0));
580 		_;
581 	}
582 
583 	function upgrade(MintableToken _newToken) onlyOwner public {
584 		newToken = _newToken;
585 	}
586 
587 	// overriding BurnableToken#burn to make disable it for public use
588 	function burn(uint256 _value) public {
589 		revert();
590 		_value = _value; // to silence compiler warning
591 	}
592 
593 	function redeem() hasUpgrade public {
594 
595 		var balance = balanceOf(msg.sender);
596 
597 		// burn the tokens in this token smart contract
598 		super.burn(balance);
599 
600 		// mint tokens in the new token smart contract
601 		require(newToken.mint(msg.sender, balance));
602 		LogRedeem(msg.sender, balance);
603 	}
604 
605 	// ----------------------------------------------------------------------------------------------------------------
606 	// we override the token transfer functions to block transfers before startTransfersDate timestamp
607 
608 	modifier canDoTransfers() {
609 		require(hasCrowdsaleFinished());
610 		_;
611 	}
612 
613 	function hasCrowdsaleFinished() view public returns(bool) {
614 		return crowdsale.hasEnded();
615 	}
616 
617 	function transfer(address _to, uint256 _value) public canDoTransfers returns (bool) {
618 		return super.transfer(_to, _value);
619 	}
620 
621 	function transferFrom(address _from, address _to, uint256 _value) public canDoTransfers returns (bool) {
622 		return super.transferFrom(_from, _to, _value);
623 	}
624 
625 	function approve(address _spender, uint256 _value) public canDoTransfers returns (bool) {
626 		return super.approve(_spender, _value);
627 	}
628 
629 	function increaseApproval(address _spender, uint _addedValue) public canDoTransfers returns (bool success) {
630 		return super.increaseApproval(_spender, _addedValue);
631 	}
632 
633 	function decreaseApproval(address _spender, uint _subtractedValue) public canDoTransfers returns (bool success) {
634 		return super.decreaseApproval(_spender, _subtractedValue);
635 	}
636 
637 	// ----------------------------------------------------------------------------------------------------------------
638 	// functionality to change the token ticker - in case of conflict
639 
640 	function changeSymbol(string _symbol) onlyOwner public {
641 		symbol = _symbol;
642 	}
643 
644 	function changeName(string _name) onlyOwner public {
645 		name = _name;
646 	}
647 }