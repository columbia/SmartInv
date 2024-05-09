1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 /**
78  * @title Pausable
79  * @dev Base contract which allows children to implement an emergency stop mechanism.
80  */
81 contract Pausable is Ownable {
82   event Pause();
83   event Unpause();
84 
85   bool public paused = false;
86 
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is not paused.
90    */
91   modifier whenNotPaused() {
92     require(!paused);
93     _;
94   }
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is paused.
98    */
99   modifier whenPaused() {
100     require(paused);
101     _;
102   }
103 
104   /**
105    * @dev called by the owner to pause, triggers stopped state
106    */
107   function pause() onlyOwner whenNotPaused public {
108     paused = true;
109     Pause();
110   }
111 
112   /**
113    * @dev called by the owner to unpause, returns to normal state
114    */
115   function unpause() onlyOwner whenPaused public {
116     paused = false;
117     Unpause();
118   }
119 }
120 
121 /*****
122     * Orginally from https://github.com/OpenZeppelin/zeppelin-solidity
123     * Modified by https://github.com/agarwalakarsh
124     */
125 
126 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
127 /*****
128     * @title Basic Token
129     * @dev Basic Version of a Generic Token
130     */
131 contract ERC20BasicToken is Pausable{
132     // 18 decimals is the strongly suggested default, avoid changing it
133     uint256 public totalSupply;
134 
135     // This creates an array with all balances
136     mapping (address => uint256) public balances;
137     mapping (address => mapping (address => uint256)) public allowance;
138 
139     // This generates a public event on the blockchain that will notify clients
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 
142     // This notifies clients about the amount burnt
143     event Burn(address indexed from, uint256 value);
144 
145     //Fix for the ERC20 short address attack.
146     modifier onlyPayloadSize(uint size) {
147         require(msg.data.length >= size + 4) ;
148         _;
149     }
150 
151     /**
152      * Internal transfer, only can be called by this contract
153      */
154     function _transfer(address _from, address _to, uint _value) whenNotPaused internal {
155         // Prevent transfer to 0x0 address. Use burn() instead
156         require(_to != 0x0);
157         // Check if the sender has enough
158         require(balances[_from] >= _value);
159         // Check for overflows
160         require(balances[_to] + _value > balances[_to]);
161         // Save this for an assertion in the future
162         uint previousBalances = balances[_from] + balances[_to];
163         // Subtract from the sender
164         balances[_from] -= _value;
165         // Add the same to the recipient
166         balances[_to] += _value;
167         Transfer(_from, _to, _value);
168         // Asserts are used to use static analysis to find bugs in your code. They should never fail
169         assert(balances[_from] + balances[_to] == previousBalances);
170     }
171 
172 
173     /**
174      * Transfer tokens from other address
175      *
176      * Send `_value` tokens to `_to` in behalf of `_from`
177      *
178      * @param _from The address of the sender
179      * @param _to The address of the recipient
180      * @param _value the amount to send
181      */
182     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused onlyPayloadSize(2 * 32) public returns (bool success) {
183         require(_value <= allowance[_from][msg.sender]);     // Check allowance
184         allowance[_from][msg.sender] -= _value;
185         _transfer(_from, _to, _value);
186         return true;
187     }
188 
189     /**
190      * Transfer tokens
191      *
192      * Send `_value` tokens to `_to` from your account
193      *
194      * @param _to The address of the recipient
195      * @param _value the amount to send
196      */
197     function transfer(address _to, uint256 _value) whenNotPaused onlyPayloadSize(2 * 32) public {
198         _transfer(msg.sender, _to, _value);
199     }
200 
201     /**
202      * @notice Create `mintedAmount` tokens and send it to `target`
203      * @param target Address to receive the tokens
204      * @param mintedAmount the amount of tokens it will receive
205      */
206     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
207         balances[target] += mintedAmount;
208         totalSupply += mintedAmount;
209         Transfer(0, this, mintedAmount);
210         Transfer(this, target, mintedAmount);
211     }
212 
213     /**
214      * Set allowance for other address
215      *
216      * Allows `_spender` to spend no more than `_value` tokens in your behalf
217      *
218      * @param _spender The address authorized to spend
219      * @param _value the max amount they can spend
220      */
221     function approve(address _spender, uint256 _value) public
222         returns (bool success) {
223         allowance[msg.sender][_spender] = _value;
224         return true;
225     }
226 
227     /**
228      * Set allowance for other address and notify
229      *
230      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
231      *
232      * @param _spender The address authorized to spend
233      * @param _value the max amount they can spend
234      * @param _extraData some extra information to send to the approved contract
235      */
236     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
237         public
238         returns (bool success) {
239         tokenRecipient spender = tokenRecipient(_spender);
240         if (approve(_spender, _value)) {
241             spender.receiveApproval(msg.sender, _value, this, _extraData);
242             return true;
243         }
244     }
245 
246     /**
247      * Destroy tokens
248      *
249      * Remove `_value` tokens from the system irreversibly
250      *
251      * @param _value the amount of money to burn
252      */
253     function burn(uint256 _value) public returns (bool success) {
254         require(balances[msg.sender] >= _value);   // Check if the sender has enough
255         balances[msg.sender] -= _value;            // Subtract from the sender
256         totalSupply -= _value;                      // Updates totalSupply
257         Burn(msg.sender, _value);
258         return true;
259     }
260 
261     /**
262      * Destroy tokens from other account
263      *
264      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
265      *
266      * @param _from the address of the sender
267      * @param _value the amount of money to burn
268      */
269     function burnFrom(address _from, uint256 _value) public returns (bool success) {
270         require(balances[_from] >= _value);                // Check if the targeted balance is enough
271         require(_value <= allowance[_from][msg.sender]);    // Check allowance
272         balances[_from] -= _value;                         // Subtract from the targeted balance
273         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
274         totalSupply -= _value;                              // Update totalSupply
275         Burn(_from, _value);
276         return true;
277     }
278 
279     /**
280   	 * Return balance of an account
281      * @param _owner the address to get balance
282   	 */
283   	function balanceOf(address _owner) public constant returns (uint balance) {
284   		return balances[_owner];
285   	}
286 
287     /**
288   	 * Return allowance for other address
289      * @param _owner The address spend to the other
290      * @param _spender The address authorized to spend
291   	 */
292   	function allowance(address _owner, address _spender) public constant returns (uint remaining) {
293   		return allowance[_owner][_spender];
294   	}
295 }
296 
297 contract JWCToken is ERC20BasicToken {
298 	using SafeMath for uint256;
299 
300 	string public constant name      = "JWC Blockchain Ventures";   //tokens name
301 	string public constant symbol    = "JWC";                       //token symbol
302 	uint256 public constant decimals = 18;                          //token decimal
303 	string public constant version   = "1.0";                       //tokens version
304 
305 	uint256 public constant tokenPreSale         = 100000000 * 10**decimals;//tokens for pre-sale
306 	uint256 public constant tokenPublicSale      = 400000000 * 10**decimals;//tokens for public-sale
307 	uint256 public constant tokenReserve         = 300000000 * 10**decimals;//tokens for reserve
308 	uint256 public constant tokenTeamSupporter   = 120000000 * 10**decimals;//tokens for Team & Supporter
309 	uint256 public constant tokenAdvisorPartners = 80000000  * 10**decimals;//tokens for Advisor
310 
311 	address public icoContract;
312 
313 	// constructor
314 	function JWCToken() public {
315 		totalSupply = tokenPreSale + tokenPublicSale + tokenReserve + tokenTeamSupporter + tokenAdvisorPartners;
316 	}
317 
318 	/**
319 	 * Set ICO Contract for this token to make sure called by our ICO contract
320 	 * @param _icoContract - ICO Contract address
321 	 */
322 	function setIcoContract(address _icoContract) public onlyOwner {
323 		if (_icoContract != address(0)) {
324 			icoContract = _icoContract;
325 		}
326 	}
327 
328 	/**
329 	 * Sell tokens when ICO. Only called by ICO Contract
330 	 * @param _recipient - address send ETH to buy tokens
331 	 * @param _value - amount of ETHs
332 	 */
333 	function sell(address _recipient, uint256 _value) public whenNotPaused returns (bool success) {
334 		assert(_value > 0);
335 		require(msg.sender == icoContract);
336 
337 		balances[_recipient] = balances[_recipient].add(_value);
338 
339 		Transfer(0x0, _recipient, _value);
340 		return true;
341 	}
342 
343 	/**
344 	 * Pay bonus & affiliate to address
345 	 * @param _recipient - address to receive bonus & affiliate
346 	 * @param _value - value bonus & affiliate to give
347 	 */
348 	function payBonusAffiliate(address _recipient, uint256 _value) public returns (bool success) {
349 		assert(_value > 0);
350 		require(msg.sender == icoContract);
351 
352 		balances[_recipient] = balances[_recipient].add(_value);
353 		totalSupply = totalSupply.add(_value);
354 
355 		Transfer(0x0, _recipient, _value);
356 		return true;
357 	}
358 }
359 
360 /**
361  * Store config of phase ICO
362  */
363 contract IcoPhase {
364   uint256 public constant phasePresale_From = 1516456800;//14h 20/01/2018 GMT
365   uint256 public constant phasePresale_To = 1517839200;//14h 05/02/2018 GMT
366 
367   uint256 public constant phasePublicSale1_From = 1519912800;//14h 01/03/2018 GMT
368   uint256 public constant phasePublicSale1_To = 1520344800;//14h 06/03/2018 GMT
369 
370   uint256 public constant phasePublicSale2_From = 1520344800;//14h 06/03/2018 GMT
371   uint256 public constant phasePublicSale2_To = 1520776800;//14h 11/03/2018 GMT
372 
373   uint256 public constant phasePublicSale3_From = 1520776800;//14h 11/03/2018 GMT
374   uint256 public constant phasePublicSale3_To = 1521208800;//14h 16/03/2018 GMT
375 }
376 
377 /**
378  * This contract will give bonus for user when buy tokens. The bonus will be paid after finishing ICO
379  */
380 contract Bonus is IcoPhase, Ownable {
381 	using SafeMath for uint256;
382 
383 	//decimals of tokens
384 	uint256 constant decimals = 18;
385 
386 	//enable/disable
387 	bool public isBonus;
388 
389 	//max tokens for time bonus
390 	uint256 public maxTimeBonus = 225000000*10**decimals;
391 
392 	//max tokens for amount bonus
393 	uint256 public maxAmountBonus = 125000000*10**decimals;
394 
395 	//storage
396 	mapping(address => uint256) public bonusAccountBalances;
397 	mapping(uint256 => address) public bonusAccountIndex;
398 	uint256 public bonusAccountCount;
399 
400 	uint256 public indexPaidBonus;//amount of accounts have been paid bonus
401 
402 	function Bonus() public {
403 		isBonus = true;
404 	}
405 
406 	/**
407 	 * Enable bonus
408 	 */
409 	function enableBonus() public onlyOwner returns (bool)
410 	{
411 		require(!isBonus);
412 		isBonus=true;
413 		return true;
414 	}
415 
416 	/**
417 	 * Disable bonus
418 	 */
419 	function disableBonus() public onlyOwner returns (bool)
420 	{
421 		require(isBonus);
422 		isBonus=false;
423 		return true;
424 	}
425 
426 	/**
427 	 * Get bonus percent by time
428 	 */
429 	function getTimeBonus() public constant returns(uint256) {
430 		uint256 bonus = 0;
431 
432 		if(now>=phasePresale_From && now<phasePresale_To){
433 			bonus = 40;
434 		} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {
435 			bonus = 20;
436 		} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {
437 			bonus = 10;
438 		} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {
439 			bonus = 5;
440 		}
441 
442 		return bonus;
443 	}
444 
445 	/**
446 	 * Get bonus by eth
447 	 * @param _value - eth to convert to bonus
448 	 */
449 	function getBonusByETH(uint256 _value) public pure returns(uint256) {
450 		uint256 bonus = 0;
451 
452 		if(_value>=1500*10**decimals){
453 			bonus=_value.mul(25)/100;
454 		} else if(_value>=300*10**decimals){
455 			bonus=_value.mul(20)/100;
456 		} else if(_value>=150*10**decimals){
457 			bonus=_value.mul(15)/100;
458 		} else if(_value>=30*10**decimals){
459 			bonus=_value.mul(10)/100;
460 		} else if(_value>=15*10**decimals){
461 			bonus=_value.mul(5)/100;
462 		}
463 
464 		return bonus;
465 	}
466 
467 	/**
468 	 * Get bonus balance of an account
469 	 * @param _owner - the address to get bonus of
470 	 */
471 	function balanceBonusOf(address _owner) public constant returns (uint256 balance)
472 	{
473 		return bonusAccountBalances[_owner];
474 	}
475 
476 	/**
477 	 * Get bonus balance of an account
478 	 */
479 	function payBonus() public onlyOwner returns (bool success);
480 }
481 
482 
483 /**
484  * This contract will give affiliate for user when buy tokens. The affiliate will be paid after finishing ICO
485  */
486 contract Affiliate is Ownable {
487 
488 	//Control Affiliate feature.
489 	bool public isAffiliate;
490 
491 	//Affiliate level, init is 1
492 	uint256 public affiliateLevel = 1;
493 
494 	//Each user will have different rate
495 	mapping(uint256 => uint256) public affiliateRate;
496 
497 	//Keep balance of user
498 	mapping(address => uint256) public referralBalance;//referee=>value
499 
500 	mapping(address => address) public referral;//referee=>referrer
501 	mapping(uint256 => address) public referralIndex;//index=>referee
502 
503 	uint256 public referralCount;
504 
505 	//amount of accounts have been paid affiliate
506 	uint256 public indexPaidAffiliate;
507 
508 	// max tokens for affiliate
509 	uint256 public maxAffiliate = 100000000*(10**18);
510 
511 	/**
512 	 * Throw if affiliate is disable
513 	 */
514 	modifier whenAffiliate() {
515 		require (isAffiliate);
516 		_;
517 	}
518 
519 	/**
520 	 * constructor affiliate with level 1 rate = 10%
521 	 */
522 	function Affiliate() public {
523 		isAffiliate=true;
524 		affiliateLevel=1;
525 		affiliateRate[0]=10;
526 	}
527 
528 	/**
529 	 * Enable affiliate for the contract
530 	 */
531 	function enableAffiliate() public onlyOwner returns (bool) {
532 		require (!isAffiliate);
533 		isAffiliate=true;
534 		return true;
535 	}
536 
537 	/**
538 	 * Disable affiliate for the contract
539 	 */
540 	function disableAffiliate() public onlyOwner returns (bool) {
541 		require (isAffiliate);
542 		isAffiliate=false;
543 		return true;
544 	}
545 
546 	/**
547 	 * Return current affiliate level
548 	 */
549 	function getAffiliateLevel() public constant returns(uint256)
550 	{
551 		return affiliateLevel;
552 	}
553 
554 	/**
555 	 * Update affiliate level by owner
556 	 * @param _level - new level
557 	 */
558 	function setAffiliateLevel(uint256 _level) public onlyOwner whenAffiliate returns(bool)
559 	{
560 		affiliateLevel=_level;
561 		return true;
562 	}
563 
564 	/**
565 	 * Get referrer address
566 	 * @param _referee - the referee address
567 	 */
568 	function getReferrerAddress(address _referee) public constant returns (address)
569 	{
570 		return referral[_referee];
571 	}
572 
573 	/**
574 	 * Get referee address
575 	 * @param _referrer - the referrer address
576 	 */
577 	function getRefereeAddress(address _referrer) public constant returns (address[] _referee)
578 	{
579 		address[] memory refereeTemp = new address[](referralCount);
580 		uint count = 0;
581 		uint i;
582 		for (i=0; i<referralCount; i++){
583 			if(referral[referralIndex[i]] == _referrer){
584 				refereeTemp[count] = referralIndex[i];
585 
586 				count += 1;
587 			}
588 		}
589 
590 		_referee = new address[](count);
591 		for (i=0; i<count; i++)
592 			_referee[i] = refereeTemp[i];
593 	}
594 
595 	/**
596 	 * Mapping referee address with referrer address
597 	 * @param _parent - the referrer address
598 	 * @param _child - the referee address
599 	 */
600 	function setReferralAddress(address _parent, address _child) public onlyOwner whenAffiliate returns (bool)
601 	{
602 		require(_parent != address(0x00));
603 		require(_child != address(0x00));
604 
605 		referralIndex[referralCount]=_child;
606 		referral[_child]=_parent;
607 		referralCount++;
608 
609 		referralBalance[_child]=0;
610 
611 		return true;
612 	}
613 
614 	/**
615 	 * Get affiliate rate by level
616 	 * @param _level - level to get affiliate rate
617 	 */
618 	function getAffiliateRate(uint256 _level) public constant returns (uint256 rate)
619 	{
620 		return affiliateRate[_level];
621 	}
622 
623 	/**
624 	 * Set affiliate rate for level
625 	 * @param _level - the level to be set the new rate
626 	 * @param _rate - new rate
627 	 */
628 	function setAffiliateRate(uint256 _level, uint256 _rate) public onlyOwner whenAffiliate returns (bool)
629 	{
630 		affiliateRate[_level]=_rate;
631 		return true;
632 	}
633 
634 	/**
635 	 * Get affiliate balance of an account
636 	 * @param _referee - the address to get affiliate of
637 	 */
638 	function balanceAffiliateOf(address _referee) public constant returns (uint256)
639 	{
640 		return referralBalance[_referee];
641 	}
642 
643 	/**
644 	 * Pay affiliate
645 	 */
646 	function payAffiliate() public onlyOwner returns (bool success);
647 }
648 
649 
650 /**
651  * This contract will send tokens when an account send eth
652  * Note: before send eth to token, address has to be registered by registerRecipient function
653  */
654 contract IcoContract is IcoPhase, Ownable, Pausable, Affiliate, Bonus {
655 	using SafeMath for uint256;
656 
657 	JWCToken ccc;
658 
659 	uint256 public totalTokenSale;
660 	uint256 public minContribution = 0.1 ether;//minimun eth used to buy tokens
661 	uint256 public tokenExchangeRate = 7000;//1ETH=7000 tokens
662 	uint256 public constant decimals = 18;
663 
664 	uint256 public tokenRemainPreSale;//tokens remain for pre-sale
665 	uint256 public tokenRemainPublicSale;//tokens for public-sale
666 
667 	address public ethFundDeposit = 0x133f29F316Aac08ABC0b39b5CdbD0E7f134671dB;//multi-sig wallet
668 	address public tokenAddress;
669 
670 	bool public isFinalized;
671 
672 	uint256 public maxGasRefund = 0.0046 ether;//maximum gas used to refund for each transaction
673 
674 	//constructor
675 	function IcoContract(address _tokenAddress) public {
676 		tokenAddress = _tokenAddress;
677 
678 		ccc = JWCToken(tokenAddress);
679 		totalTokenSale = ccc.tokenPreSale() + ccc.tokenPublicSale();
680 
681 		tokenRemainPreSale = ccc.tokenPreSale();//tokens remain for pre-sale
682 		tokenRemainPublicSale = ccc.tokenPublicSale();//tokens for public-sale
683 
684 		isFinalized=false;
685 	}
686 
687 	//usage: web3 change token from eth
688 	function changeETH2Token(uint256 _value) public constant returns(uint256) {
689 		uint256 etherRecev = _value + maxGasRefund;
690 		require (etherRecev >= minContribution);
691 
692 		uint256 rate = getTokenExchangeRate();
693 
694 		uint256 tokens = etherRecev.mul(rate);
695 
696 		//get current phase of ICO
697 		uint256 phaseICO = getCurrentICOPhase();
698 		uint256 tokenRemain = 0;
699 		if(phaseICO == 1){//pre-sale
700 			tokenRemain = tokenRemainPreSale;
701 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
702 			tokenRemain = tokenRemainPublicSale;
703 		}
704 
705 		if (tokenRemain < tokens) {
706 			tokens=tokenRemain;
707 		}
708 
709 		return tokens;
710 	}
711 
712 	function () public payable whenNotPaused {
713 		require (!isFinalized);
714 		require (msg.sender != address(0));
715 
716 		uint256 etherRecev = msg.value + maxGasRefund;
717 		require (etherRecev >= minContribution);
718 
719 		//get current token exchange rate
720 		tokenExchangeRate = getTokenExchangeRate();
721 
722 		uint256 tokens = etherRecev.mul(tokenExchangeRate);
723 
724 		//get current phase of ICO
725 		uint256 phaseICO = getCurrentICOPhase();
726 
727 		require(phaseICO!=0);
728 
729 		uint256 tokenRemain = 0;
730 		if(phaseICO == 1){//pre-sale
731 			tokenRemain = tokenRemainPreSale;
732 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
733 			tokenRemain = tokenRemainPublicSale;
734 		}
735 
736 		//throw if tokenRemain==0
737 		require(tokenRemain>0);
738 
739 		if (tokenRemain < tokens) {
740 			//if tokens is not enough to buy
741 
742 			uint256 tokensToRefund = tokens.sub(tokenRemain);
743 			uint256 etherToRefund = tokensToRefund / tokenExchangeRate;
744 
745 			//refund eth to buyer
746 			msg.sender.transfer(etherToRefund);
747 
748 			tokens=tokenRemain;
749 			etherRecev = etherRecev.sub(etherToRefund);
750 
751 			tokenRemain = 0;
752 		} else {
753 			tokenRemain = tokenRemain.sub(tokens);
754 		}
755 
756 		//store token remain by phase
757 		if(phaseICO == 1){//pre-sale
758 			tokenRemainPreSale = tokenRemain;
759 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
760 			tokenRemainPublicSale = tokenRemain;
761 		}
762 
763 		//send token
764 		ccc.sell(msg.sender, tokens);
765 		ethFundDeposit.transfer(this.balance);
766 
767 		//bonus
768 		if(isBonus){
769 			//bonus amount
770 			//get bonus by eth
771 			uint256 bonusAmountETH = getBonusByETH(etherRecev);
772 			//get bonus by token
773 			uint256 bonusAmountTokens = bonusAmountETH.mul(tokenExchangeRate);
774 
775 			//check if we have enough tokens for bonus
776 			if(maxAmountBonus>0){
777 				if(maxAmountBonus>=bonusAmountTokens){
778 					maxAmountBonus-=bonusAmountTokens;
779 				} else {
780 					bonusAmountTokens = maxAmountBonus;
781 					maxAmountBonus = 0;
782 				}
783 			} else {
784 				bonusAmountTokens = 0;
785 			}
786 
787 			//bonus time
788 			uint256 bonusTimeToken = tokens.mul(getTimeBonus())/100;
789 			//check if we have enough tokens for bonus
790 			if(maxTimeBonus>0){
791 				if(maxTimeBonus>=bonusTimeToken){
792 					maxTimeBonus-=bonusTimeToken;
793 				} else {
794 					bonusTimeToken = maxTimeBonus;
795 					maxTimeBonus = 0;
796 				}
797 			} else {
798 				bonusTimeToken = 0;
799 			}
800 
801 			//store bonus
802 			if(bonusAccountBalances[msg.sender]==0){//new
803 				bonusAccountIndex[bonusAccountCount]=msg.sender;
804 				bonusAccountCount++;
805 			}
806 
807 			uint256 bonusTokens=bonusAmountTokens + bonusTimeToken;
808 			bonusAccountBalances[msg.sender]=bonusAccountBalances[msg.sender].add(bonusTokens);
809 		}
810 
811 		//affiliate
812 		if(isAffiliate){
813 			address child=msg.sender;
814 			for(uint256 i=0; i<affiliateLevel; i++){
815 				uint256 giftToken=affiliateRate[i].mul(tokens)/100;
816 
817 				//check if we have enough tokens for affiliate
818 				if(maxAffiliate<=0){
819 					break;
820 				} else {
821 					if(maxAffiliate>=giftToken){
822 						maxAffiliate-=giftToken;
823 					} else {
824 						giftToken = maxAffiliate;
825 						maxAffiliate = 0;
826 					}
827 				}
828 
829 				address parent = referral[child];
830 				if(parent != address(0x00)){//has affiliate
831 					referralBalance[child]=referralBalance[child].add(giftToken);
832 				}
833 
834 				child=parent;
835 			}
836 		}
837 	}
838 
839 	/**
840 	 * Pay affiliate to address. Called when ICO finish
841 	 */
842 	function payAffiliate() public onlyOwner returns (bool success) {
843 		uint256 toIndex = indexPaidAffiliate + 15;
844 		if(referralCount < toIndex)
845 			toIndex = referralCount;
846 
847 		for(uint256 i=indexPaidAffiliate; i<toIndex; i++) {
848 			address referee = referralIndex[i];
849 			payAffiliate1Address(referee);
850 		}
851 
852 		return true;
853 	}
854 
855 	/**
856 	 * Pay affiliate to only a address
857 	 */
858 	function payAffiliate1Address(address _referee) public onlyOwner returns (bool success) {
859 		address referrer = referral[_referee];
860 		ccc.payBonusAffiliate(referrer, referralBalance[_referee]);
861 
862 		referralBalance[_referee]=0;
863 		return true;
864 	}
865 
866 	/**
867 	 * Pay bonus to address. Called when ICO finish
868 	 */
869 	function payBonus() public onlyOwner returns (bool success) {
870 		uint256 toIndex = indexPaidBonus + 15;
871 		if(bonusAccountCount < toIndex)
872 			toIndex = bonusAccountCount;
873 
874 		for(uint256 i=indexPaidBonus; i<toIndex; i++)
875 		{
876 			payBonus1Address(bonusAccountIndex[i]);
877 		}
878 
879 		return true;
880 	}
881 
882 	/**
883 	 * Pay bonus to only a address
884 	 */
885 	function payBonus1Address(address _address) public onlyOwner returns (bool success) {
886 		ccc.payBonusAffiliate(_address, bonusAccountBalances[_address]);
887 		bonusAccountBalances[_address]=0;
888 		return true;
889 	}
890 
891 	function finalize() external onlyOwner {
892 		require (!isFinalized);
893 		// move to operational
894 		isFinalized = true;
895 		payAffiliate();
896 		payBonus();
897 		ethFundDeposit.transfer(this.balance);
898 	}
899 
900 	/**
901 	 * Get token exchange rate
902 	 * Note: just use when ICO
903 	 */
904 	function getTokenExchangeRate() public constant returns(uint256 rate) {
905 		rate = tokenExchangeRate;
906 		if(now<phasePresale_To){
907 			if(now>=phasePresale_From)
908 				rate = 10000;
909 		} else if(now<phasePublicSale3_To){
910 			rate = 7000;
911 		}
912 	}
913 
914 	/**
915 	 * Get the current ICO phase
916 	 */
917 	function getCurrentICOPhase() public constant returns(uint256 phase) {
918 		phase = 0;
919 		if(now>=phasePresale_From && now<phasePresale_To){
920 			phase = 1;
921 		} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {
922 			phase = 2;
923 		} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {
924 			phase = 3;
925 		} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {
926 			phase = 4;
927 		}
928 	}
929 
930 	/**
931 	 * Get amount of tokens that be sold
932 	 */
933 	function getTokenSold() public constant returns(uint256 tokenSold) {
934 		//get current phase of ICO
935 		uint256 phaseICO = getCurrentICOPhase();
936 		tokenSold = 0;
937 		if(phaseICO == 1){//pre-sale
938 			tokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale);
939 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
940 			tokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale) + ccc.tokenPublicSale().sub(tokenRemainPublicSale);
941 		}
942 	}
943 
944 	/**
945 	 * Set token exchange rate
946 	 */
947 	function setTokenExchangeRate(uint256 _tokenExchangeRate) public onlyOwner returns (bool) {
948 		require(_tokenExchangeRate>0);
949 		tokenExchangeRate=_tokenExchangeRate;
950 		return true;
951 	}
952 
953 	/**
954 	 * set min eth contribute
955 	 * @param _minContribution - min eth to contribute
956 	 */
957 	function setMinContribution(uint256 _minContribution) public onlyOwner returns (bool) {
958 		require(_minContribution>0);
959 		minContribution=_minContribution;
960 		return true;
961 	}
962 
963 	/**
964 	 * Change multi-sig address, the address to receive ETH
965 	 * @param _ethFundDeposit - new multi-sig address
966 	 */
967 	function setEthFundDeposit(address _ethFundDeposit) public onlyOwner returns (bool) {
968 		require(_ethFundDeposit != address(0));
969 		ethFundDeposit=_ethFundDeposit;
970 		return true;
971 	}
972 
973 	/**
974 	 * Set max gas to refund when an address send ETH to buy tokens
975 	 * @param _maxGasRefund - max gas
976 	 */
977 	function setMaxGasRefund(uint256 _maxGasRefund) public onlyOwner returns (bool) {
978 		require(_maxGasRefund > 0);
979 		maxGasRefund = _maxGasRefund;
980 		return true;
981 	}
982 }