1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() {
56     owner = msg.sender;
57   }
58 
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) onlyOwner public {
74     require(newOwner != address(0));
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) public constant returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public constant returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   mapping(address => uint256) balances;
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[msg.sender]);
122 
123     // SafeMath.sub will throw if there is not enough balance.
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public constant returns (uint256 balance) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, BasicToken {
150 
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint256 the amount of tokens to be transferred
159    */
160   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161     require(_to != address(0));
162     require(_value <= balances[_from]);
163     require(_value <= allowed[_from][msg.sender]);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    */
204   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
205     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 /**
224  * @title Burnable Token
225  * @dev Token that can be irreversibly burned (destroyed).
226  */
227 contract BurnableToken is StandardToken {
228 
229     address public constant BURN_ADDRESS = 0;
230 
231     event Burn(address indexed burner, uint256 value);
232 
233 	
234 	function burnTokensInternal(address _address, uint256 _value) internal {
235         require(_value > 0);
236         require(_value <= balances[_address]);
237         // no need to require value <= totalSupply, since that would imply the
238         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
239 
240         address burner = _address;
241         balances[burner] = balances[burner].sub(_value);
242         totalSupply = totalSupply.sub(_value);
243         Burn(burner, _value);
244 		Transfer(burner, BURN_ADDRESS, _value);
245 		
246 	}
247 		
248 }
249 
250 /**
251  * @title Handelion Token
252  * @dev Main token used for Handelion crowdsale
253  */
254  contract HIONToken is BurnableToken, Ownable
255  {
256 	
257 	/** Handelion token name official name. */
258 	string public constant name = "HION Token by Handelion"; 
259 	 
260 	 /** Handelion token official symbol.*/
261 	string public constant symbol = "HION"; 
262 
263 	/** Number of decimal units for Handelion token */
264 	uint256 public constant decimals = 18;
265 
266 	/* Preissued token amount */
267 	uint256 public constant PREISSUED_AMOUNT = 29750000 * 1 ether;
268 			
269 	/** 
270 	 * Indicates wheather token transfer is allowed. Token transfer is allowed after crowdsale is over. 
271 	 * Before crowdsale is over only token owner is allowed to transfer tokens to investors.
272 	 */
273 	bool public transferAllowed = false;
274 			
275 	/** Raises when initial amount of tokens is preissued */
276 	event LogTokenPreissued(address ownereAddress, uint256 amount);
277 	
278 	
279 	modifier canTransfer(address sender)
280 	{
281 		require(transferAllowed || sender == owner);
282 		
283 		_;
284 	}
285 	
286 	/**
287 	 * Creates and initializes Handelion token
288 	 */
289 	function HIONToken()
290 	{
291 		// Address of token creator. The creator of this token is major holder of all preissued tokens before crowdsale starts
292 		owner = msg.sender;
293 	 
294 		// Send all pre-created tokens to token creator address
295 		totalSupply = totalSupply.add(PREISSUED_AMOUNT);
296 		balances[owner] = balances[owner].add(PREISSUED_AMOUNT);
297 		
298 		LogTokenPreissued(owner, PREISSUED_AMOUNT);
299 	}
300 	
301 	/**
302 	 * Returns Token creator address
303 	 */
304 	function getCreatorAddress() public constant returns(address creatorAddress)
305 	{
306 		return owner;
307 	}
308 	
309 	/**
310 	 * Gets total supply of Handelion token
311 	 */
312 	function getTotalSupply() public constant returns(uint256)
313 	{
314 		return totalSupply;
315 	}
316 	
317 	/**
318 	 * Gets number of remaining tokens
319 	 */
320 	function getRemainingTokens() public constant returns(uint256)
321 	{
322 		return balanceOf(owner);
323 	}	
324 	
325 	/**
326 	 * Allows token transfer. Should be called after crowdsale is over
327 	 */
328 	function allowTransfer() onlyOwner public
329 	{
330 		transferAllowed = true;
331 	}
332 	
333 	
334 	/**
335 	 * Overrides transfer function by adding check whether transfer is allwed
336 	 */
337 	function transfer(address _to, uint256 _value) canTransfer(msg.sender) public returns (bool)	
338 	{
339 		super.transfer(_to, _value);
340 	}
341 
342 	/**
343 	 * Override transferFrom function and adds a check whether transfer is allwed
344 	 */
345 	function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) public returns (bool) {	
346 		super.transferFrom(_from, _to, _value);
347 	}
348 	
349 	/**
350      * @dev Burns a specific amount of tokens.
351      * @param _value The amount of token to be burned.
352      */
353     function burn(uint256 _value) public {
354 		burnTokensInternal(msg.sender, _value);
355     }
356 
357     /**
358      * @dev Burns a specific amount of tokens for specific address. Can be called only by token owner.
359 	 * @param _address 
360      * @param _value The amount of token to be burned.
361      */
362     function burn(address _address, uint256 _value) public onlyOwner {
363 		burnTokensInternal(_address, _value);
364     }
365 }
366 
367 /*
368  * Stoppable
369  *
370  * Abstract contract that allows children to implement an
371  * emergency stop mechanism.
372  *
373  *
374  */
375 contract Stoppable is Ownable {
376   bool public stopped;
377 
378   modifier stopInEmergency {
379     require(!stopped);
380     _;
381   }
382 
383   modifier stopNonOwnersInEmergency {
384     require(!stopped || msg.sender == owner);
385     _;
386   }
387 
388   modifier onlyInEmergency {
389     require(stopped);
390     _;
391   }
392 
393   // called by the owner on emergency, triggers stopped state
394   function stop() external onlyOwner {
395     stopped = true;
396   }
397 
398   // called by the owner on end of emergency, returns to normal state
399   function unstop() external onlyOwner onlyInEmergency {
400     stopped = false;
401   }
402 
403 }
404 
405 /**
406  * Handelion ICO crowdsale.
407  * 
408  */
409 contract HANDELIONdiscountSALE is Ownable, Stoppable
410 {
411 	using SafeMath for uint256;
412 
413 	struct FundingTier {
414 		uint256 cap;
415 		uint256 rate;
416 	}
417 		
418 	/** Handelion token we are selling in this crowdsale */
419 	HIONToken public token; 
420 	
421 	/** Token price tiers and caps */
422 	FundingTier public tier1;
423 	
424 	FundingTier public tier2;
425 	
426 	FundingTier public tier3;
427 	
428 	FundingTier public tier4;
429 	
430 	FundingTier public tier5;	
431 
432 	/** inclusive start timestamps of crowdsale */
433 	uint256 public startTime;
434 
435 	/** inclusive end timestamp of crowedsale */
436 	uint256 public endTime;
437 
438 	/** address where funds are collected */
439 	address public multisigWallet;
440 	
441 	/** minimal amount of sold tokens for crowdsale to be considered as successful */
442 	uint256 public minimumTokenAmount;
443 
444 	/** maximal number of tokens we can sell */
445 	uint256 public maximumTokenAmount;
446 
447 	// amount of raised money in wei
448 	uint256 public weiRaised;
449 
450 	/** amount of sold tokens */
451 	uint256 public tokensSold;
452 
453 	/** number of unique investors */
454 	uint public investorCount;
455 
456 	/** Identifies whether crowdsale has been finalized */
457 	bool public finalized;
458 
459 	/** Identifies wheather refund is opened */
460 	bool public isRefunding;
461 
462 	/** Amount of received ETH by investor */
463 	mapping (address => uint256) public investedAmountOf;
464 
465 	/** Amount of selled tokens by investor */
466 	mapping (address => uint256) public tokenAmountOf;
467 	
468 	/**
469 	* event for token purchase logging
470 	* @param purchaser who paid for the tokens
471 	* @param beneficiary who got the tokens
472 	* @param value weis paid for purchase
473 	* @param amount amount of tokens purchased
474 	*/
475 	event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
476 
477 	event LogCrowdsaleStarted();
478 
479 	event LogCrowdsaleFinalized(bool isGoalReached);
480 
481 	event LogRefundingOpened(uint256 refundAmount);
482 
483 	event LogInvestorRefunded(address investorAddress, uint256 refundedAmount);
484 	
485 	/**
486 	 * Start date: 08-12-2017 12:00 GMT
487 	 * End date: 31-03-2018 12:00 GMT
488 	 */
489 	function HANDELIONdiscountSALE() 
490 	{
491 		createTokenContract();
492 		
493 		startTime = 1512734400;
494 		endTime = 1522497600;
495 
496 		multisigWallet = 0x7E23cFa050d23B9706a071dEd0A62d30AE6BB6c8;
497 		
498 		minimumTokenAmount = 4830988 * 1 ether;
499 		maximumTokenAmount = 29750000 * 1 ether;
500 
501 		tokensSold = 0;
502 		weiRaised = 0;
503 
504 		tier1 = FundingTier({cap: 2081338 * 1 ether, rate: 480});
505 		tier2 = FundingTier({cap: 4830988 * 1 ether, rate: 460});
506 		tier3 = FundingTier({cap: 9830988 * 1 ether, rate: 440});
507 		tier4 = FundingTier({cap: 14830988 * 1 ether, rate: 420});
508 		tier5 = FundingTier({cap: 23184738 * 1 ether, rate: 400});
509 
510 		finalized = false;
511 	}
512 	
513 	 
514 	/**
515 	 * Overriding function to create HandelionToken
516 	 */
517 	function createTokenContract() internal
518 	{
519 		token = HIONToken(0xa089273724e07644da9739a708e544800d925115);
520 	}
521 	
522 	function calculateTierTokens(FundingTier _tier, uint256 _amount, uint256 _currentTokenAmount) constant internal returns (uint256)
523 	{
524 		uint256 maxTierTokens = _tier.cap.sub(_currentTokenAmount);
525 
526 		if (maxTierTokens <= 0)
527 		{
528 			return 0;
529 		}
530 				
531 		uint256 tokenCount = _amount.mul(_tier.rate);
532 			
533 		if (tokenCount > maxTierTokens)
534 		{
535 			tokenCount = maxTierTokens;
536 		}
537 			
538 		return tokenCount;
539 	}
540 	
541 	function calculateTokenAmount(uint256 _weiAmount) constant internal returns (uint256)
542 	{		
543 		uint256 nTokens = tokensSold;
544 		uint256 remainingWei = _weiAmount;
545 		uint256 tierTokens = 0;
546 		
547 		if (nTokens < tier1.cap)
548 		{			
549 			tierTokens = calculateTierTokens(tier1, remainingWei, nTokens);
550 			nTokens = nTokens.add(tierTokens);		
551 			remainingWei = remainingWei.sub(tierTokens.div(tier1.rate));
552 		}
553 		
554 		if (remainingWei > 0 && nTokens < tier2.cap)
555 		{
556 			tierTokens = calculateTierTokens(tier2, remainingWei, nTokens);
557 			nTokens = nTokens.add(tierTokens);			
558 			remainingWei = remainingWei.sub(tierTokens.div(tier2.rate));
559 		}
560 
561 		if (remainingWei > 0 && nTokens < tier3.cap)
562 		{
563 			tierTokens = calculateTierTokens(tier3, remainingWei, nTokens);
564 			nTokens = nTokens.add(tierTokens);			
565 			remainingWei = remainingWei.sub(tierTokens.div(tier3.rate));
566 		}
567 
568 		if (remainingWei > 0 && nTokens < tier4.cap)
569 		{
570 			tierTokens = calculateTierTokens(tier4, remainingWei, nTokens);
571 			nTokens = nTokens.add(tierTokens);			
572 			remainingWei = remainingWei.sub(tierTokens.div(tier4.rate));
573 		}
574 
575 		if (remainingWei > 0 && nTokens < tier5.cap)
576 		{
577 			tierTokens = calculateTierTokens(tier5, remainingWei, nTokens);
578 			nTokens = nTokens.add(tierTokens);			
579 			remainingWei = remainingWei.sub(tierTokens.div(tier5.rate));
580 		}		
581 		
582 		require(remainingWei == 0);
583 		
584 		return nTokens.sub(tokensSold);
585 	}	
586 
587 	// fallback function can be used to buy tokens
588 	function () public payable {
589 		buyTokens(msg.sender);
590 	}
591 
592 	// low level token purchase function
593 	function buyTokens(address beneficiary) public payable stopInEmergency 
594 	{
595 		require(beneficiary != address(0));
596 		require(validPurchase());
597 
598 		uint256 weiAmount = msg.value;
599 
600 		// calculate token amount to be created
601 		//uint256 tokens = weiAmount.mul(rate);
602 		uint256 tokens = calculateTokenAmount(weiAmount);
603 
604 		// Check whether within this ttransaction we will not overflow maximum token amount
605 		require(tokensSold.add(tokens) <= maximumTokenAmount);
606 
607 		// update state
608 		weiRaised = weiRaised.add(weiAmount);
609 		tokensSold = tokensSold.add(tokens);
610 		investedAmountOf[beneficiary] = investedAmountOf[beneficiary].add(weiAmount);
611 		tokenAmountOf[beneficiary] = tokenAmountOf[beneficiary].add(tokens);
612 
613 		// forward tokens to purchaser
614 		forwardTokens(beneficiary, tokens);
615 
616 		LogTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
617 
618 		// forward ETH to multisig wallet
619 		forwardFunds();
620 	}
621 
622 	/**
623 	 * This function just transfers tokens to beneficiary address. 
624 	 * It should be used for cases when investor buys tokens using other currencies
625 	 */
626 	function transferTokens(address beneficiary, uint256 amount) public onlyOwner
627 	{
628 		require(beneficiary != address(0));
629 		require(amount > 0);
630 
631 		uint256 weiAmount = amount * 1 ether;
632 		
633 		tokensSold = tokensSold.add(weiAmount);
634 		tokenAmountOf[beneficiary] = tokenAmountOf[beneficiary].add(weiAmount);
635 		
636 		forwardTokens(beneficiary, weiAmount);
637 	}
638 	
639 		/**
640 	 * This function just transfers tokens with decimals to beneficiary address. 
641 	 * It should be used for cases when investor buys tokens using other currencies
642 	 */
643 	function transferTokensWei(address beneficiary, uint256 amount) public onlyOwner
644 	{
645 		require(beneficiary != address(0));
646 		require(amount > 0);
647 
648 		uint256 weiAmount = amount;
649 		
650 		tokensSold = tokensSold.add(weiAmount);
651 		tokenAmountOf[beneficiary] = tokenAmountOf[beneficiary].add(weiAmount);
652 		
653 		forwardTokens(beneficiary, weiAmount);
654 	}
655 	
656 	// send ether to the fund collection wallet
657 	// override to create custom fund forwarding mechanisms
658 	function forwardFunds() internal {
659 		multisigWallet.transfer(msg.value);
660 	}
661 	
662 	/**
663 	 * Forward handelion tokens to purchaset
664 	 */
665 	function forwardTokens(address _purchaser, uint256 _amount) internal
666 	{
667 		token.transfer(_purchaser, _amount);
668 	}
669 
670 	/**
671 	* Closes crowdsale and changes its state to Finalized. 
672 	* Warning - this action is undoable!
673 	*/
674 	function finalize() public onlyOwner
675 	{
676 		finalized = true;
677 		
678 		LogCrowdsaleFinalized(goalReached());
679 	}
680 	
681 	/**
682 	 * Burns all caller tokens
683 	 *
684 	 */
685 	function burnTokensInternal(address _address, uint256 tokenAmount) internal
686 	{
687 		require(_address != address(0));
688 		
689 		uint256 tokensToBurn = tokenAmount;
690 		uint256 maxTokens = token.balanceOf(_address);
691 		
692 		if (tokensToBurn > maxTokens)
693 		{
694 			tokensToBurn = maxTokens;
695 		}
696 		
697 		token.burn(_address, tokensToBurn);
698 	}
699 		
700 	/**
701 	 * Burns remaining tokens which are not sold during crowdsale
702 	 */
703 	function burnRemainingTokens() public onlyOwner
704 	{
705 		burnTokensInternal(this, getRemainingTokens());
706 	}
707 		
708 		
709 	/**
710 	 * Gets remaining tokens on a contract
711 	 */
712 	function getRemainingTokens() public constant returns(uint256)
713 	{
714 		return token.getRemainingTokens();
715 	}
716 	
717 	/**
718 	 * Gets total supply of tokens
719 	 */
720 	function getTotalSupply() constant returns (uint256 res)
721 	{
722 		return token.getTotalSupply();
723 	}
724 	
725 	/**
726 	 * Gets amount of token of specific investor
727 	 */
728 	function getTokenAmountOf(address investor) constant returns (uint256 res)
729 	{
730 		return token.balanceOf(investor);
731 	}
732 
733 	// @return true if the transaction can buy tokens
734 	function validPurchase() internal constant returns (bool) {
735 		bool withinPeriod = now >= startTime && now <= endTime;
736 		bool nonZeroPurchase = msg.value != 0;
737 		bool notFinalized = !finalized;
738 		bool maxCapNotReached = tokensSold < maximumTokenAmount;
739 
740 		return withinPeriod && nonZeroPurchase && notFinalized && maxCapNotReached;
741 	}
742 
743 	function goalReached() public constant returns (bool)
744 	{
745 		return tokensSold >= minimumTokenAmount;
746 	}
747 
748 	// @return true if crowdsale event has ended
749 	function hasEnded() public constant returns (bool) {
750 		return now > endTime;
751 	}	
752 }