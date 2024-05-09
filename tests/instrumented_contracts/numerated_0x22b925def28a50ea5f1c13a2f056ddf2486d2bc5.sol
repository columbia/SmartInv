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
406  * @title Crowdsale
407  * @dev Crowdsale is a base contract for managing a token crowdsale.
408  * Crowdsales have a start and end timestamps, where investors can make
409  * token purchases and the crowdsale will assign them tokens based
410  * on a token per ETH rate. Funds collected are forwarded to a wallet
411  * as they arrive.
412  */
413 contract Crowdsale is Ownable, Stoppable
414 {
415 	
416 	using SafeMath for uint256;
417 
418 	/** inclusive start timestamps of crowdsale */
419 	uint256 public startTime;
420 
421 	/** inclusive end timestamp of crowedsale */
422 	uint256 public endTime;
423 
424 	/** address where funds are collected */
425 	address public multisigWallet;
426 
427 	// how many token units a buyer gets per wei
428 	uint256 public rate;
429 
430 	/** minimal amount of sold tokens for crowdsale to be considered as successful */
431 	uint256 public minimumTokenAmount;
432 
433 	/** maximal number of tokens we can sell */
434 	uint256 public maximumTokenAmount;
435 
436 	// amount of raised money in wei
437 	uint256 public weiRaised;
438 
439 	/** amount of sold tokens */
440 	uint256 public tokensSold;
441 
442 	/** number of unique investors */
443 	uint public investorCount;
444 
445 	/** Identifies whether crowdsale has been finalized */
446 	bool public finalized;
447 
448 	/** Identifies wheather refund is opened */
449 	bool public isRefunding;
450 
451 	/** Amount of received ETH by investor */
452 	mapping (address => uint256) public investedAmountOf;
453 
454 	/** Amount of selled tokens by investor */
455 	mapping (address => uint256) public tokenAmountOf;
456 
457 	/**
458 	* event for token purchase logging
459 	* @param purchaser who paid for the tokens
460 	* @param beneficiary who got the tokens
461 	* @param value weis paid for purchase
462 	* @param amount amount of tokens purchased
463 	*/
464 	event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
465 
466 	event LogCrowdsaleStarted();
467 
468 	event LogCrowdsaleFinalized(bool isGoalReached);
469 
470 	event LogRefundingOpened(uint256 refundAmount);
471 
472 	event LogInvestorRefunded(address investorAddress, uint256 refundedAmount);
473 
474 
475 	function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
476 		//require(_startTime >= now);
477 		require(_endTime >= _startTime);
478 		require(_rate > 0);
479 		require(_wallet != address(0));
480 
481 		createTokenContract();
482 		startTime = _startTime;
483 		endTime = _endTime;
484 		rate = _rate;
485 		multisigWallet = _wallet;
486 		
487 	}
488 
489 	// creates the token to be sold.
490 	// override this method to have crowdsale of a specific token.
491 	function createTokenContract() internal;
492 
493 	/**
494 	* Prealocates tokens before crowdsale starts.
495 	* Override this function to prealocate for specific crowdsale
496 	*/
497 	function preallocateTokens() internal;
498 
499 
500 	// fallback function can be used to buy tokens
501 	function () public payable {
502 		buyTokens(msg.sender);
503 	}
504 
505 	// low level token purchase function
506 	function buyTokens(address beneficiary) public payable stopInEmergency 
507 	{
508 		require(beneficiary != address(0));
509 		require(validPurchase());
510 
511 		uint256 weiAmount = msg.value;
512 
513 		// calculate token amount to be created
514 		//uint256 tokens = weiAmount.mul(rate);
515 		uint256 tokens = calculateTokenAmount(weiAmount);
516 
517 		// Check whether within this ttransaction we will not overflow maximum token amount
518 		require(tokensSold.add(tokens) <= maximumTokenAmount);
519 
520 		// update state
521 		weiRaised = weiRaised.add(weiAmount);
522 		tokensSold = tokensSold.add(tokens);
523 		investedAmountOf[beneficiary] = investedAmountOf[beneficiary].add(weiAmount);
524 		tokenAmountOf[beneficiary] = tokenAmountOf[beneficiary].add(tokens);
525 
526 		// forward tokens to purchaser
527 		forwardTokens(beneficiary, tokens);
528 
529 		LogTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
530 
531 		// forward ETH to multisig wallet
532 		forwardFunds();
533 	}
534 
535 	/**
536 	 * This function just transfers tokens to beneficiary address. 
537 	 * It should be used for cases when investor buys tokens using other currencies
538 	 */
539 	function transferTokens(address beneficiary, uint256 amount) public onlyOwner
540 	{
541 		require(beneficiary != address(0));
542 		require(amount > 0);
543 
544 		uint256 weiAmount = amount * 1 ether;
545 		
546 		tokensSold = tokensSold.add(weiAmount);
547 		tokenAmountOf[beneficiary] = tokenAmountOf[beneficiary].add(weiAmount);
548 		
549 		forwardTokens(beneficiary, weiAmount);
550 	}
551 	
552 	// send ether to the fund collection wallet
553 	// override to create custom fund forwarding mechanisms
554 	function forwardFunds() internal {
555 		multisigWallet.transfer(msg.value);
556 	}
557 
558 
559 	/**
560 	* Forwards tokens to purchaser. 
561 	* Override this function to send approprieate tokens for specific crowdsale
562 	*/
563 	function forwardTokens(address _purchaser, uint256 _amount) internal;
564 	
565 	
566 	/**
567 	 * Calculates amount of tokens investor is buying based on funds
568 	 */
569 	function calculateTokenAmount(uint256 _weiAmount) constant internal returns (uint256);
570 
571 	/**
572 	* Closes crowdsale and changes its state to Finalized. 
573 	* Warning - this action is undoable!
574 	*/
575 	function finalize() public onlyOwner
576 	{
577 		finalized = true;
578 
579 		finalizeInternal();
580 
581 		LogCrowdsaleFinalized(goalReached());
582 	}
583 
584 	/**
585 	* Override this function to perform additional actions on crowdsale finalization
586 	*
587 	*/
588 	function finalizeInternal() internal;
589 
590 	// @return true if the transaction can buy tokens
591 	function validPurchase() internal constant returns (bool) {
592 		bool withinPeriod = now >= startTime && now <= endTime;
593 		bool nonZeroPurchase = msg.value != 0;
594 		bool notFinalized = !finalized;
595 		bool maxCapNotReached = tokensSold < maximumTokenAmount;
596 
597 		return withinPeriod && nonZeroPurchase && notFinalized && maxCapNotReached;
598 	}
599 
600 	function goalReached() public constant returns (bool)
601 	{
602 		return tokensSold >= minimumTokenAmount;
603 	}
604 
605 	// @return true if crowdsale event has ended
606 	function hasEnded() public constant returns (bool) {
607 		return now > endTime;
608 	}
609 
610 	/**
611 	* Opens smart contract for refunding
612 	*/
613 	function openRefund() public payable onlyOwner 
614 	{
615 		// Check that amount of funds transferred for refund is more than 0
616 		require(msg.value > 0);
617 
618 		// mark refunding as opened
619 		isRefunding = true; 
620 
621 		// perform internal custom actions
622 		openRefundInternal();
623 
624 		// Log refund event
625 		LogRefundingOpened(msg.value);
626 	}
627 
628 	/**
629 	* implement this function in ancesstor class to execute specific smart contract actions on open refunding
630 	*
631 	*/
632 	function openRefundInternal() internal;
633   
634 
635 	/**
636 	 * Requests refund. Can be called only when contract is open for refunding. 
637 	 * Returns investor funds and burns his tokens
638 	 */
639 	function requestRefund() public
640 	{
641 		// check if refunding is opened
642 		require(isRefunding);
643 
644 		// check that address is valid
645 		require(msg.sender != address(0));
646 
647 		// get investor invested amount 
648 		uint256 investedAmount = investedAmountOf[msg.sender];
649 		
650 		uint256 tokenAmount = tokenAmountOf[msg.sender];
651 		  
652 		// if invested amount is 0 then throw error
653 		require(investedAmount > 0);
654 
655 		// check if we have enough funds on smart contract to refund investor
656 		require(this.balance >= investedAmount);
657 
658 		// update investor amount - reset it its invested amount to 0
659 		investedAmountOf[msg.sender] = 0;
660 
661 		// update investor tokens - reset to 0
662 		tokenAmountOf[msg.sender] = 0;
663 
664 		// Log event that investor has been refunded
665 		LogInvestorRefunded(msg.sender, investedAmount);
666 
667 		// burn investor tokens
668 		burnTokensInternal(msg.sender, tokenAmount);
669 		
670 		// forward funds to investor address
671 		msg.sender.transfer(investedAmount);
672 	}
673   
674 	
675 	/**
676 	 * Burns specified investor tokens
677 	 */
678 	function burnAllInvestorTokens(address _address) public onlyOwner
679 	{
680 		require(_address != address(0));
681 		
682 		// Get investor tokens
683 		uint256 tokenAmount = tokenAmountOf[_address];
684 
685 		if (tokenAmount > 0)
686 		{
687 			burnTokensInternal(_address, tokenAmount);
688 		}
689 	}
690 
691 	/**
692 	 * Burns specified investor tokens
693 	 */
694 	function burnInvestorTokens(address _address, uint256 amount) public onlyOwner
695 	{
696 		require(_address != address(0));
697 		
698 		if (amount > 0)
699 		{
700 			burnTokensInternal(_address, amount * 1 ether);
701 		}
702 	}
703   
704 	/**
705 	* Implement this function in ancestor classes to perform token burning
706 	*/
707 	function burnTokensInternal(address _address, uint256 tokenAmount) internal;
708 
709 	/**
710 	* Gets current contract balance
711 	*/
712 	function getBalance() public constant returns (uint256)
713 	{
714 	  return this.balance;
715 	}
716 	
717 	/**
718 	 * Moves all funds from contract to owner's wallet
719 	 */
720   	function withdraw() public onlyOwner
721 	{
722 		require(this.balance > 0);
723 		
724 		multisigWallet.transfer(this.balance);
725 	}  
726 }
727 
728 
729 /**
730  * Handelion ICO crowdsale.
731  * 
732  */
733 contract HandelionCrowdsale is Crowdsale
734 {
735 	struct FundingTier {
736 		uint256 cap;
737 		uint256 rate;
738 	}
739 	
740 	/** amount of tokens Handelion owners are keeping for them selves */
741 	uint256 public preallocatedTokenAmount;
742 	
743 	/** Handelion token we are selling in this crowdsale */
744 	HIONToken public token; 
745 	
746 	/** how many tokens goes to contract owners from each token sent to investor */
747 	uint256 public ownerFraction;
748 
749 	/** Token price tiers and caps */
750 	FundingTier public tier1;
751 	
752 	FundingTier public tier2;
753 	
754 	FundingTier public tier3;
755 	
756 	FundingTier public tier4;
757 	
758 	FundingTier public tier5;	
759 	
760 	
761 	/**
762 	 * Start date: 08-12-2017 12:00 GMT
763 	 * End date: 31-03-2018 12:00 GMT
764 	 */
765 	function HandelionCrowdsale() 
766 		Crowdsale(1512734400, 1522497600, 300,  0x7E23cFa050d23B9706a071dEd0A62d30AE6BB6c8) 
767 	{
768 		minimumTokenAmount = 5000000 * 1 ether;
769 		maximumTokenAmount = 29750000 * 1 ether;
770 		preallocatedTokenAmount = 6564912 * 1 ether;
771 		ownerFraction = 4;
772 
773 		tier1 = FundingTier({cap: 2081338 * 1 ether, rate: 480});
774 		tier2 = FundingTier({cap: 2750000 * 1 ether, rate: 460});
775 		tier3 = FundingTier({cap: 5000000 * 1 ether, rate: 440});
776 		tier4 = FundingTier({cap: 5000000 * 1 ether, rate: 420});
777 		tier5 = FundingTier({cap: 8353750 * 1 ether, rate: 400});
778 		preallocateTokens();
779 
780 		finalized = false;
781 	}
782 	
783 	 
784 	/**
785 	 * Overriding function to create HandelionToken
786 	 */
787 	function createTokenContract() internal
788 	{
789 		token = new HIONToken();
790 	}
791 	
792 	
793 	/**
794 	 * Preallocate tokens to handelion platform owners */
795 	function preallocateTokens() internal 
796 	{
797 		tokensSold = tokensSold.add(preallocatedTokenAmount);
798 				
799 		forwardTokens(multisigWallet, preallocatedTokenAmount);
800 	}
801 	
802 	/**
803 	 * Forward handelion tokens to purchaset
804 	 */
805 	function forwardTokens(address _purchaser, uint256 _amount) internal
806 	{
807 		token.transfer(_purchaser, _amount);
808 
809 		/*
810 		if (_purchaser != multisigWallet)
811 		{
812 			uint256 tokensToOwners = _amount.div(ownerFraction);
813 			
814 			token.transfer(multisigWallet, tokensToOwners);
815 		}
816 		*/
817 	}
818 
819 	function calculateTierTokens(FundingTier _tier, uint256 _amount, uint256 _currentTokenAmount) constant internal returns (uint256)
820 	{
821 		uint256 maxTierTokens = _tier.cap.sub(_currentTokenAmount);
822 
823 		if (maxTierTokens <= 0)
824 		{
825 			return 0;
826 		}
827 				
828 		uint256 tokenCount = _amount.mul(_tier.rate);
829 			
830 		if (tokenCount > maxTierTokens)
831 		{
832 			tokenCount = maxTierTokens;
833 		}
834 			
835 		return tokenCount;
836 	}
837 	
838 	function calculateTokenAmount(uint256 _weiAmount) constant internal returns (uint256)
839 	{		
840 		uint256 nTokens = tokensSold;
841 		uint256 remainingWei = _weiAmount;
842 		uint256 tierTokens = 0;
843 		
844 		if (nTokens < tier1.cap)
845 		{			
846 			tierTokens = calculateTierTokens(tier1, remainingWei, nTokens);
847 			nTokens = nTokens.add(tierTokens);		
848 			remainingWei = remainingWei.sub(tierTokens.div(tier1.rate));
849 		}
850 		
851 		if (remainingWei > 0 && nTokens < tier2.cap)
852 		{
853 			tierTokens = calculateTierTokens(tier2, remainingWei, nTokens);
854 			nTokens = nTokens.add(tierTokens);			
855 			remainingWei = remainingWei.sub(tierTokens.div(tier2.rate));
856 		}
857 
858 		if (remainingWei > 0 && nTokens < tier3.cap)
859 		{
860 			tierTokens = calculateTierTokens(tier3, remainingWei, nTokens);
861 			nTokens = nTokens.add(tierTokens);			
862 			remainingWei = remainingWei.sub(tierTokens.div(tier3.rate));
863 		}
864 
865 		if (remainingWei > 0 && nTokens < tier4.cap)
866 		{
867 			tierTokens = calculateTierTokens(tier4, remainingWei, nTokens);
868 			nTokens = nTokens.add(tierTokens);			
869 			remainingWei = remainingWei.sub(tierTokens.div(tier4.rate));
870 		}
871 
872 		if (remainingWei > 0 && nTokens < tier5.cap)
873 		{
874 			tierTokens = calculateTierTokens(tier5, remainingWei, nTokens);
875 			nTokens = nTokens.add(tierTokens);			
876 			remainingWei = remainingWei.sub(tierTokens.div(tier5.rate));
877 		}		
878 		
879 		require(remainingWei == 0);
880 		
881 		return nTokens.sub(tokensSold);
882 	}
883 
884 	
885 	/**
886 	 * Perform actions on finalization - allow tokens transfer 
887 	 */
888 	function finalizeInternal() internal onlyOwner
889 	{
890 
891 	}
892 	
893 	/**
894 	 * Performs smart contract additional actions on refund opening
895 	 */
896 	function openRefundInternal() internal onlyOwner
897 	{
898 	
899 	}
900 	
901 	/**
902 	 * Burns all caller tokens
903 	 *
904 	 */
905 	function burnTokensInternal(address _address, uint256 tokenAmount) internal
906 	{
907 		require(_address != address(0));
908 		
909 		uint256 tokensToBurn = tokenAmount;
910 		uint256 maxTokens = token.balanceOf(_address);
911 		
912 		if (tokensToBurn > maxTokens)
913 		{
914 			tokensToBurn = maxTokens;
915 		}
916 		
917 		token.burn(_address, tokensToBurn);
918 	}
919 	
920 	
921 	/**
922 	 * Gets remaining tokens on a contract
923 	 */
924 	function getRemainingTokens() public constant returns(uint256)
925 	{
926 		return token.getRemainingTokens();
927 	}
928 	
929 	/**
930 	 * Gets total supply of tokens
931 	 */
932 	function getTotalSupply() constant returns (uint256 res)
933 	{
934 		return token.getTotalSupply();
935 	}
936 	
937 	/**
938 	 * Gets amount of token of specific investor
939 	 */
940 	function getTokenAmountOf(address investor) constant returns (uint256 res)
941 	{
942 		return token.balanceOf(investor);
943 	}
944 	
945 	
946 	/**
947 	 * Allow token transfer. By default and during crowdsale tokens are non-transferable. 
948 	 * Call these operation when you need to allow token transfer
949 	 */
950 	function allowTokenTransfer() public onlyOwner
951 	{
952 		token.allowTransfer();		
953 	}
954 	
955 	/**
956 	 * Burns remaining tokens which are not sold during crowdsale
957 	 */
958 	function burnRemainingTokens() public onlyOwner
959 	{
960 		burnTokensInternal(this, getRemainingTokens());
961 	}
962 		
963 }