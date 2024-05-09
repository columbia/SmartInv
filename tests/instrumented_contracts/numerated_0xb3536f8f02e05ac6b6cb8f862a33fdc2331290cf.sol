1 pragma solidity ^0.4.18;
2 
3 /**
4  * @author Hieu Phan - https://github.com/phanletrunghieu
5  * @author Hanh Pham - https://github.com/HanhPhamPhuoc
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() public {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 /**
85  * @title Pausable
86  * @dev Base contract which allows children to implement an emergency stop mechanism.
87  */
88 contract Pausable is Ownable {
89   event Pause();
90   event Unpause();
91 
92   bool public paused = false;
93 
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is not paused.
97    */
98   modifier whenNotPaused() {
99     require(!paused);
100     _;
101   }
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is paused.
105    */
106   modifier whenPaused() {
107     require(paused);
108     _;
109   }
110 
111   /**
112    * @dev called by the owner to pause, triggers stopped state
113    */
114   function pause() onlyOwner whenNotPaused public {
115     paused = true;
116     Pause();
117   }
118 
119   /**
120    * @dev called by the owner to unpause, returns to normal state
121    */
122   function unpause() onlyOwner whenPaused public {
123     paused = false;
124     Unpause();
125   }
126 }
127 
128 /*****
129     * Orginally from https://github.com/OpenZeppelin/zeppelin-solidity
130     * Modified by https://github.com/agarwalakarsh
131     */
132 
133 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
134 /*****
135     * @title Basic Token
136     * @dev Basic Version of a Generic Token
137     */
138 contract ERC20BasicToken is Pausable{
139     // 18 decimals is the strongly suggested default, avoid changing it
140     uint256 public totalSupply;
141 
142     // This creates an array with all balances
143     mapping (address => uint256) public balances;
144     mapping (address => mapping (address => uint256)) public allowance;
145 
146     // This generates a public event on the blockchain that will notify clients
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     // This notifies clients about the amount burnt
150     event Burn(address indexed from, uint256 value);
151 
152     //Fix for the ERC20 short address attack.
153     modifier onlyPayloadSize(uint size) {
154         require(msg.data.length >= size + 4) ;
155         _;
156     }
157 
158     /**
159      * Internal transfer, only can be called by this contract
160      */
161     function _transfer(address _from, address _to, uint _value) whenNotPaused internal {
162         // Prevent transfer to 0x0 address. Use burn() instead
163         require(_to != 0x0);
164         // Check if the sender has enough
165         require(balances[_from] >= _value);
166         // Check for overflows
167         require(balances[_to] + _value > balances[_to]);
168         // Save this for an assertion in the future
169         uint previousBalances = balances[_from] + balances[_to];
170         // Subtract from the sender
171         balances[_from] -= _value;
172         // Add the same to the recipient
173         balances[_to] += _value;
174         Transfer(_from, _to, _value);
175         // Asserts are used to use static analysis to find bugs in your code. They should never fail
176         assert(balances[_from] + balances[_to] == previousBalances);
177     }
178 
179 
180     /**
181      * Transfer tokens from other address
182      *
183      * Send `_value` tokens to `_to` in behalf of `_from`
184      *
185      * @param _from The address of the sender
186      * @param _to The address of the recipient
187      * @param _value the amount to send
188      */
189     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused onlyPayloadSize(2 * 32) public returns (bool success) {
190         require(_value <= allowance[_from][msg.sender]);     // Check allowance
191         allowance[_from][msg.sender] -= _value;
192         _transfer(_from, _to, _value);
193         return true;
194     }
195 
196     /**
197      * Transfer tokens
198      *
199      * Send `_value` tokens to `_to` from your account
200      *
201      * @param _to The address of the recipient
202      * @param _value the amount to send
203      */
204     function transfer(address _to, uint256 _value) whenNotPaused onlyPayloadSize(2 * 32) public {
205         _transfer(msg.sender, _to, _value);
206     }
207 
208     /**
209      * @notice Create `mintedAmount` tokens and send it to `target`
210      * @param target Address to receive the tokens
211      * @param mintedAmount the amount of tokens it will receive
212      */
213     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
214         balances[target] += mintedAmount;
215         totalSupply += mintedAmount;
216         Transfer(0, this, mintedAmount);
217         Transfer(this, target, mintedAmount);
218     }
219 
220     /**
221      * Set allowance for other address
222      *
223      * Allows `_spender` to spend no more than `_value` tokens in your behalf
224      *
225      * @param _spender The address authorized to spend
226      * @param _value the max amount they can spend
227      */
228     function approve(address _spender, uint256 _value) public
229         returns (bool success) {
230         allowance[msg.sender][_spender] = _value;
231         return true;
232     }
233 
234     /**
235      * Set allowance for other address and notify
236      *
237      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
238      *
239      * @param _spender The address authorized to spend
240      * @param _value the max amount they can spend
241      * @param _extraData some extra information to send to the approved contract
242      */
243     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
244         public
245         returns (bool success) {
246         tokenRecipient spender = tokenRecipient(_spender);
247         if (approve(_spender, _value)) {
248             spender.receiveApproval(msg.sender, _value, this, _extraData);
249             return true;
250         }
251     }
252 
253     /**
254      * Destroy tokens
255      *
256      * Remove `_value` tokens from the system irreversibly
257      *
258      * @param _value the amount of money to burn
259      */
260     function burn(uint256 _value) public returns (bool success) {
261         require(balances[msg.sender] >= _value);   // Check if the sender has enough
262         balances[msg.sender] -= _value;            // Subtract from the sender
263         totalSupply -= _value;                      // Updates totalSupply
264         Burn(msg.sender, _value);
265         return true;
266     }
267 
268     /**
269      * Destroy tokens from other account
270      *
271      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
272      *
273      * @param _from the address of the sender
274      * @param _value the amount of money to burn
275      */
276     function burnFrom(address _from, uint256 _value) public returns (bool success) {
277         require(balances[_from] >= _value);                // Check if the targeted balance is enough
278         require(_value <= allowance[_from][msg.sender]);    // Check allowance
279         balances[_from] -= _value;                         // Subtract from the targeted balance
280         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
281         totalSupply -= _value;                              // Update totalSupply
282         Burn(_from, _value);
283         return true;
284     }
285 
286     /**
287   	 * Return balance of an account
288      * @param _owner the address to get balance
289   	 */
290   	function balanceOf(address _owner) public constant returns (uint balance) {
291   		return balances[_owner];
292   	}
293 
294     /**
295   	 * Return allowance for other address
296      * @param _owner The address spend to the other
297      * @param _spender The address authorized to spend
298   	 */
299   	function allowance(address _owner, address _spender) public constant returns (uint remaining) {
300   		return allowance[_owner][_spender];
301   	}
302 }
303 
304 contract JWCToken is ERC20BasicToken {
305 	using SafeMath for uint256;
306 
307 	string public constant name      = "JWC Blockchain Ventures";   //tokens name
308 	string public constant symbol    = "JWC";                       //token symbol
309 	uint256 public constant decimals = 18;                          //token decimal
310 	string public constant version   = "1.0";                       //tokens version
311 
312 	uint256 public constant tokenPreSale         = 100000000 * 10**decimals;//tokens for pre-sale
313 	uint256 public constant tokenPublicSale      = 400000000 * 10**decimals;//tokens for public-sale
314 	uint256 public constant tokenReserve         = 300000000 * 10**decimals;//tokens for reserve
315 	uint256 public constant tokenTeamSupporter   = 120000000 * 10**decimals;//tokens for Team & Supporter
316 	uint256 public constant tokenAdvisorPartners = 80000000  * 10**decimals;//tokens for Advisor
317 
318 	address public icoContract;
319 
320 	// constructor
321 	function JWCToken() public {
322 		totalSupply = tokenPreSale + tokenPublicSale + tokenReserve + tokenTeamSupporter + tokenAdvisorPartners;
323 	}
324 
325 	/**
326 	 * Set ICO Contract for this token to make sure called by our ICO contract
327 	 * @param _icoContract - ICO Contract address
328 	 */
329 	function setIcoContract(address _icoContract) public onlyOwner {
330 		if (_icoContract != address(0)) {
331 			icoContract = _icoContract;
332 		}
333 	}
334 
335 	/**
336 	 * Sell tokens when ICO. Only called by ICO Contract
337 	 * @param _recipient - address send ETH to buy tokens
338 	 * @param _value - amount of ETHs
339 	 */
340 	function sell(address _recipient, uint256 _value) public whenNotPaused returns (bool success) {
341 		assert(_value > 0);
342 		require(msg.sender == icoContract);
343 
344 		balances[_recipient] = balances[_recipient].add(_value);
345 
346 		Transfer(0x0, _recipient, _value);
347 		return true;
348 	}
349 
350 	/**
351 	 * Pay bonus & affiliate to address
352 	 * @param _recipient - address to receive bonus & affiliate
353 	 * @param _value - value bonus & affiliate to give
354 	 */
355 	function payBonusAffiliate(address _recipient, uint256 _value) public returns (bool success) {
356 		assert(_value > 0);
357 		require(msg.sender == icoContract);
358 
359 		balances[_recipient] = balances[_recipient].add(_value);
360 		totalSupply = totalSupply.add(_value);
361 
362 		Transfer(0x0, _recipient, _value);
363 		return true;
364 	}
365 }
366 
367 /**
368  * Store config of phase ICO
369  */
370 contract IcoPhase {
371   uint256 public constant phasePresale_From = 1516456800;//14h 20/01/2018 GMT
372   uint256 public constant phasePresale_To = 1517839200;//14h 05/02/2018 GMT
373 
374   uint256 public constant phasePublicSale1_From = 1519912800;//14h 01/03/2018 GMT
375   uint256 public constant phasePublicSale1_To = 1520344800;//14h 06/03/2018 GMT
376 
377   uint256 public constant phasePublicSale2_From = 1520344800;//14h 06/03/2018 GMT
378   uint256 public constant phasePublicSale2_To = 1520776800;//14h 11/03/2018 GMT
379 
380   uint256 public constant phasePublicSale3_From = 1520776800;//14h 11/03/2018 GMT
381   uint256 public constant phasePublicSale3_To = 1521208800;//14h 16/03/2018 GMT
382 }
383 
384 /**
385  * This contract will give bonus for user when buy tokens. The bonus will be paid after finishing ICO
386  */
387 contract Bonus is IcoPhase, Ownable {
388 	using SafeMath for uint256;
389 
390 	//decimals of tokens
391 	uint256 constant decimals = 18;
392 
393 	//enable/disable
394 	bool public isBonus;
395 
396 	//max tokens for time bonus
397 	uint256 public maxTimeBonus = 225000000*10**decimals;
398 
399 	//max tokens for amount bonus
400 	uint256 public maxAmountBonus = 125000000*10**decimals;
401 
402 	//storage
403 	mapping(address => uint256) public bonusAccountBalances;
404 	mapping(uint256 => address) public bonusAccountIndex;
405 	uint256 public bonusAccountCount;
406 
407 	uint256 public indexPaidBonus;//amount of accounts have been paid bonus
408 
409 	function Bonus() public {
410 		isBonus = true;
411 	}
412 
413 	/**
414 	 * Enable bonus
415 	 */
416 	function enableBonus() public onlyOwner returns (bool)
417 	{
418 		require(!isBonus);
419 		isBonus=true;
420 		return true;
421 	}
422 
423 	/**
424 	 * Disable bonus
425 	 */
426 	function disableBonus() public onlyOwner returns (bool)
427 	{
428 		require(isBonus);
429 		isBonus=false;
430 		return true;
431 	}
432 
433 	/**
434 	 * Get bonus percent by time
435 	 */
436 	function getTimeBonus() public constant returns(uint256) {
437 		uint256 bonus = 0;
438 
439 		if(now>=phasePresale_From && now<phasePresale_To){
440 			bonus = 40;
441 		} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {
442 			bonus = 20;
443 		} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {
444 			bonus = 10;
445 		} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {
446 			bonus = 5;
447 		}
448 
449 		return bonus;
450 	}
451 
452 	/**
453 	 * Get bonus by eth
454 	 * @param _value - eth to convert to bonus
455 	 */
456 	function getBonusByETH(uint256 _value) public pure returns(uint256) {
457 		uint256 bonus = 0;
458 
459 		if(_value>=1500*10**decimals){
460 			bonus=_value.mul(25)/100;
461 		} else if(_value>=300*10**decimals){
462 			bonus=_value.mul(20)/100;
463 		} else if(_value>=150*10**decimals){
464 			bonus=_value.mul(15)/100;
465 		} else if(_value>=30*10**decimals){
466 			bonus=_value.mul(10)/100;
467 		} else if(_value>=15*10**decimals){
468 			bonus=_value.mul(5)/100;
469 		}
470 
471 		return bonus;
472 	}
473 
474 	/**
475 	 * Get bonus balance of an account
476 	 * @param _owner - the address to get bonus of
477 	 */
478 	function balanceBonusOf(address _owner) public constant returns (uint256 balance)
479 	{
480 		return bonusAccountBalances[_owner];
481 	}
482 
483 	/**
484 	 * Get bonus balance of an account
485 	 */
486 	function payBonus() public onlyOwner returns (bool success);
487 }
488 
489 
490 /**
491  * This contract will give affiliate for user when buy tokens. The affiliate will be paid after finishing ICO
492  */
493 contract Affiliate is Ownable {
494 
495 	//Control Affiliate feature.
496 	bool public isAffiliate;
497 
498 	//Affiliate level, init is 1
499 	uint256 public affiliateLevel = 1;
500 
501 	//Each user will have different rate
502 	mapping(uint256 => uint256) public affiliateRate;
503 
504 	//Keep balance of user
505 	mapping(address => uint256) public referralBalance;//referee=>value
506 
507 	mapping(address => address) public referral;//referee=>referrer
508 	mapping(uint256 => address) public referralIndex;//index=>referee
509 
510 	uint256 public referralCount;
511 
512 	//amount of accounts have been paid affiliate
513 	uint256 public indexPaidAffiliate;
514 
515 	// max tokens for affiliate
516 	uint256 public maxAffiliate = 100000000*(10**18);
517 
518 	/**
519 	 * Throw if affiliate is disable
520 	 */
521 	modifier whenAffiliate() {
522 		require (isAffiliate);
523 		_;
524 	}
525 
526 	/**
527 	 * constructor affiliate with level 1 rate = 10%
528 	 */
529 	function Affiliate() public {
530 		isAffiliate=true;
531 		affiliateLevel=1;
532 		affiliateRate[0]=10;
533 	}
534 
535 	/**
536 	 * Enable affiliate for the contract
537 	 */
538 	function enableAffiliate() public onlyOwner returns (bool) {
539 		require (!isAffiliate);
540 		isAffiliate=true;
541 		return true;
542 	}
543 
544 	/**
545 	 * Disable affiliate for the contract
546 	 */
547 	function disableAffiliate() public onlyOwner returns (bool) {
548 		require (isAffiliate);
549 		isAffiliate=false;
550 		return true;
551 	}
552 
553 	/**
554 	 * Return current affiliate level
555 	 */
556 	function getAffiliateLevel() public constant returns(uint256)
557 	{
558 		return affiliateLevel;
559 	}
560 
561 	/**
562 	 * Update affiliate level by owner
563 	 * @param _level - new level
564 	 */
565 	function setAffiliateLevel(uint256 _level) public onlyOwner whenAffiliate returns(bool)
566 	{
567 		affiliateLevel=_level;
568 		return true;
569 	}
570 
571 	/**
572 	 * Get referrer address
573 	 * @param _referee - the referee address
574 	 */
575 	function getReferrerAddress(address _referee) public constant returns (address)
576 	{
577 		return referral[_referee];
578 	}
579 
580 	/**
581 	 * Get referee address
582 	 * @param _referrer - the referrer address
583 	 */
584 	function getRefereeAddress(address _referrer) public constant returns (address[] _referee)
585 	{
586 		address[] memory refereeTemp = new address[](referralCount);
587 		uint count = 0;
588 		uint i;
589 		for (i=0; i<referralCount; i++){
590 			if(referral[referralIndex[i]] == _referrer){
591 				refereeTemp[count] = referralIndex[i];
592 
593 				count += 1;
594 			}
595 		}
596 
597 		_referee = new address[](count);
598 		for (i=0; i<count; i++)
599 			_referee[i] = refereeTemp[i];
600 	}
601 
602 	/**
603 	 * Mapping referee address with referrer address
604 	 * @param _parent - the referrer address
605 	 * @param _child - the referee address
606 	 */
607 	function setReferralAddress(address _parent, address _child) public onlyOwner whenAffiliate returns (bool)
608 	{
609 		require(_parent != address(0x00));
610 		require(_child != address(0x00));
611 
612 		referralIndex[referralCount]=_child;
613 		referral[_child]=_parent;
614 		referralCount++;
615 
616 		referralBalance[_child]=0;
617 
618 		return true;
619 	}
620 
621 	/**
622 	 * Get affiliate rate by level
623 	 * @param _level - level to get affiliate rate
624 	 */
625 	function getAffiliateRate(uint256 _level) public constant returns (uint256 rate)
626 	{
627 		return affiliateRate[_level];
628 	}
629 
630 	/**
631 	 * Set affiliate rate for level
632 	 * @param _level - the level to be set the new rate
633 	 * @param _rate - new rate
634 	 */
635 	function setAffiliateRate(uint256 _level, uint256 _rate) public onlyOwner whenAffiliate returns (bool)
636 	{
637 		affiliateRate[_level]=_rate;
638 		return true;
639 	}
640 
641 	/**
642 	 * Get affiliate balance of an account
643 	 * @param _referee - the address to get affiliate of
644 	 */
645 	function balanceAffiliateOf(address _referee) public constant returns (uint256)
646 	{
647 		return referralBalance[_referee];
648 	}
649 
650 	/**
651 	 * Pay affiliate
652 	 */
653 	function payAffiliate() public onlyOwner returns (bool success);
654 }
655 
656 
657 /**
658  * This contract will send tokens when an account send eth
659  * Note: before send eth to token, address has to be registered by registerRecipient function
660  */
661 contract IcoContract is IcoPhase, Ownable, Pausable, Affiliate, Bonus {
662 	using SafeMath for uint256;
663 
664 	JWCToken ccc;
665 
666 	uint256 public totalTokenSale;
667 	uint256 public minContribution = 0.1 ether;//minimun eth used to buy tokens
668 	uint256 public tokenExchangeRate = 7000;//1ETH=7000 tokens
669 	uint256 public constant decimals = 18;
670 
671 	uint256 public tokenRemainPreSale;//tokens remain for pre-sale
672 	uint256 public tokenRemainPublicSale;//tokens for public-sale
673 
674 	address public ethFundDeposit = 0x8780eCF6DB001B223aE48372f4045097e1a11aA9;//multi-sig wallet
675 	address public tokenAddress;
676 
677 	bool public isFinalized;
678 
679 	uint256 public maxGasRefund = 0.0046 ether;//maximum gas used to refund for each transaction
680 
681 	//constructor
682 	function IcoContract(address _tokenAddress) public {
683 		tokenAddress = _tokenAddress;
684 
685 		ccc = JWCToken(tokenAddress);
686 		totalTokenSale = ccc.tokenPreSale() + ccc.tokenPublicSale();
687 
688 		tokenRemainPreSale = ccc.tokenPreSale();//tokens remain for pre-sale
689 		tokenRemainPublicSale = ccc.tokenPublicSale();//tokens for public-sale
690 
691 		isFinalized=false;
692 	}
693 
694 	//usage: web3 change token from eth
695 	function changeETH2Token(uint256 _value) public constant returns(uint256) {
696 		uint256 etherRecev = _value + maxGasRefund;
697 		require (etherRecev >= minContribution);
698 
699 		uint256 rate = getTokenExchangeRate();
700 
701 		uint256 tokens = etherRecev.mul(rate);
702 
703 		//get current phase of ICO
704 		uint256 phaseICO = getCurrentICOPhase();
705 		uint256 tokenRemain = 0;
706 		if(phaseICO == 1){//pre-sale
707 			tokenRemain = tokenRemainPreSale;
708 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
709 			tokenRemain = tokenRemainPublicSale;
710 		}
711 
712 		if (tokenRemain < tokens) {
713 			tokens=tokenRemain;
714 		}
715 
716 		return tokens;
717 	}
718 
719 	function () public payable whenNotPaused {
720 		require (!isFinalized);
721 		require (msg.sender != address(0));
722 
723 		uint256 etherRecev = msg.value + maxGasRefund;
724 		require (etherRecev >= minContribution);
725 
726 		//get current token exchange rate
727 		tokenExchangeRate = getTokenExchangeRate();
728 
729 		uint256 tokens = etherRecev.mul(tokenExchangeRate);
730 
731 		//get current phase of ICO
732 		uint256 phaseICO = getCurrentICOPhase();
733 
734 		require(phaseICO!=0);
735 
736 		uint256 tokenRemain = 0;
737 		if(phaseICO == 1){//pre-sale
738 			tokenRemain = tokenRemainPreSale;
739 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
740 			tokenRemain = tokenRemainPublicSale;
741 		}
742 
743 		//throw if tokenRemain==0
744 		require(tokenRemain>0);
745 
746 		if (tokenRemain < tokens) {
747 			//if tokens is not enough to buy
748 
749 			uint256 tokensToRefund = tokens.sub(tokenRemain);
750 			uint256 etherToRefund = tokensToRefund / tokenExchangeRate;
751 
752 			//refund eth to buyer
753 			msg.sender.transfer(etherToRefund);
754 
755 			tokens=tokenRemain;
756 			etherRecev = etherRecev.sub(etherToRefund);
757 
758 			tokenRemain = 0;
759 		} else {
760 			tokenRemain = tokenRemain.sub(tokens);
761 		}
762 
763 		//store token remain by phase
764 		if(phaseICO == 1){//pre-sale
765 			tokenRemainPreSale = tokenRemain;
766 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
767 			tokenRemainPublicSale = tokenRemain;
768 		}
769 
770 		//send token
771 		ccc.sell(msg.sender, tokens);
772 		ethFundDeposit.transfer(this.balance);
773 
774 		//bonus
775 		if(isBonus){
776 			//bonus amount
777 			//get bonus by eth
778 			uint256 bonusAmountETH = getBonusByETH(etherRecev);
779 			//get bonus by token
780 			uint256 bonusAmountTokens = bonusAmountETH.mul(tokenExchangeRate);
781 
782 			//check if we have enough tokens for bonus
783 			if(maxAmountBonus>0){
784 				if(maxAmountBonus>=bonusAmountTokens){
785 					maxAmountBonus-=bonusAmountTokens;
786 				} else {
787 					bonusAmountTokens = maxAmountBonus;
788 					maxAmountBonus = 0;
789 				}
790 			} else {
791 				bonusAmountTokens = 0;
792 			}
793 
794 			//bonus time
795 			uint256 bonusTimeToken = tokens.mul(getTimeBonus())/100;
796 			//check if we have enough tokens for bonus
797 			if(maxTimeBonus>0){
798 				if(maxTimeBonus>=bonusTimeToken){
799 					maxTimeBonus-=bonusTimeToken;
800 				} else {
801 					bonusTimeToken = maxTimeBonus;
802 					maxTimeBonus = 0;
803 				}
804 			} else {
805 				bonusTimeToken = 0;
806 			}
807 
808 			//store bonus
809 			if(bonusAccountBalances[msg.sender]==0){//new
810 				bonusAccountIndex[bonusAccountCount]=msg.sender;
811 				bonusAccountCount++;
812 			}
813 
814 			uint256 bonusTokens=bonusAmountTokens + bonusTimeToken;
815 			bonusAccountBalances[msg.sender]=bonusAccountBalances[msg.sender].add(bonusTokens);
816 		}
817 
818 		//affiliate
819 		if(isAffiliate){
820 			address child=msg.sender;
821 			for(uint256 i=0; i<affiliateLevel; i++){
822 				uint256 giftToken=affiliateRate[i].mul(tokens)/100;
823 
824 				//check if we have enough tokens for affiliate
825 				if(maxAffiliate<=0){
826 					break;
827 				} else {
828 					if(maxAffiliate>=giftToken){
829 						maxAffiliate-=giftToken;
830 					} else {
831 						giftToken = maxAffiliate;
832 						maxAffiliate = 0;
833 					}
834 				}
835 
836 				address parent = referral[child];
837 				if(parent != address(0x00)){//has affiliate
838 					referralBalance[child]=referralBalance[child].add(giftToken);
839 				}
840 
841 				child=parent;
842 			}
843 		}
844 	}
845 
846 	/**
847 	 * Pay affiliate to address. Called when ICO finish
848 	 */
849 	function payAffiliate() public onlyOwner returns (bool success) {
850 		uint256 toIndex = indexPaidAffiliate + 15;
851 		if(referralCount < toIndex)
852 			toIndex = referralCount;
853 
854 		for(uint256 i=indexPaidAffiliate; i<toIndex; i++) {
855 			address referee = referralIndex[i];
856 			payAffiliate1Address(referee);
857 		}
858 
859 		return true;
860 	}
861 
862 	/**
863 	 * Pay affiliate to only a address
864 	 */
865 	function payAffiliate1Address(address _referee) public onlyOwner returns (bool success) {
866 		address referrer = referral[_referee];
867 		ccc.payBonusAffiliate(referrer, referralBalance[_referee]);
868 
869 		referralBalance[_referee]=0;
870 		return true;
871 	}
872 
873 	/**
874 	 * Pay bonus to address. Called when ICO finish
875 	 */
876 	function payBonus() public onlyOwner returns (bool success) {
877 		uint256 toIndex = indexPaidBonus + 15;
878 		if(bonusAccountCount < toIndex)
879 			toIndex = bonusAccountCount;
880 
881 		for(uint256 i=indexPaidBonus; i<toIndex; i++)
882 		{
883 			payBonus1Address(bonusAccountIndex[i]);
884 		}
885 
886 		return true;
887 	}
888 
889 	/**
890 	 * Pay bonus to only a address
891 	 */
892 	function payBonus1Address(address _address) public onlyOwner returns (bool success) {
893 		ccc.payBonusAffiliate(_address, bonusAccountBalances[_address]);
894 		bonusAccountBalances[_address]=0;
895 		return true;
896 	}
897 
898 	function finalize() external onlyOwner {
899 		require (!isFinalized);
900 		// move to operational
901 		isFinalized = true;
902 		payAffiliate();
903 		payBonus();
904 		ethFundDeposit.transfer(this.balance);
905 	}
906 
907 	/**
908 	 * Get token exchange rate
909 	 * Note: just use when ICO
910 	 */
911 	function getTokenExchangeRate() public constant returns(uint256 rate) {
912 		rate = tokenExchangeRate;
913 		if(now<phasePresale_To){
914 			if(now>=phasePresale_From)
915 				rate = 10000;
916 		} else if(now<phasePublicSale3_To){
917 			rate = 7000;
918 		}
919 	}
920 
921 	/**
922 	 * Get the current ICO phase
923 	 */
924 	function getCurrentICOPhase() public constant returns(uint256 phase) {
925 		phase = 0;
926 		if(now>=phasePresale_From && now<phasePresale_To){
927 			phase = 1;
928 		} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {
929 			phase = 2;
930 		} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {
931 			phase = 3;
932 		} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {
933 			phase = 4;
934 		}
935 	}
936 
937 	/**
938 	 * Get amount of tokens that be sold
939 	 */
940 	function getTokenSold() public constant returns(uint256 tokenSold) {
941 		//get current phase of ICO
942 		uint256 phaseICO = getCurrentICOPhase();
943 		tokenSold = 0;
944 		if(phaseICO == 1){//pre-sale
945 			tokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale);
946 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
947 			tokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale) + ccc.tokenPublicSale().sub(tokenRemainPublicSale);
948 		}
949 	}
950 
951 	/**
952 	 * Set token exchange rate
953 	 */
954 	function setTokenExchangeRate(uint256 _tokenExchangeRate) public onlyOwner returns (bool) {
955 		require(_tokenExchangeRate>0);
956 		tokenExchangeRate=_tokenExchangeRate;
957 		return true;
958 	}
959 
960 	/**
961 	 * set min eth contribute
962 	 * @param _minContribution - min eth to contribute
963 	 */
964 	function setMinContribution(uint256 _minContribution) public onlyOwner returns (bool) {
965 		require(_minContribution>0);
966 		minContribution=_minContribution;
967 		return true;
968 	}
969 
970 	/**
971 	 * Change multi-sig address, the address to receive ETH
972 	 * @param _ethFundDeposit - new multi-sig address
973 	 */
974 	function setEthFundDeposit(address _ethFundDeposit) public onlyOwner returns (bool) {
975 		require(_ethFundDeposit != address(0));
976 		ethFundDeposit=_ethFundDeposit;
977 		return true;
978 	}
979 
980 	/**
981 	 * Set max gas to refund when an address send ETH to buy tokens
982 	 * @param _maxGasRefund - max gas
983 	 */
984 	function setMaxGasRefund(uint256 _maxGasRefund) public onlyOwner returns (bool) {
985 		require(_maxGasRefund > 0);
986 		maxGasRefund = _maxGasRefund;
987 		return true;
988 	}
989 }