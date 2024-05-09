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
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title Pausable
80  * @dev Base contract which allows children to implement an emergency stop mechanism.
81  */
82 contract Pausable is Ownable {
83   event Pause();
84   event Unpause();
85 
86   bool public paused = false;
87 
88 
89   /**
90    * @dev Modifier to make a function callable only when the contract is not paused.
91    */
92   modifier whenNotPaused() {
93     require(!paused);
94     _;
95   }
96 
97   /**
98    * @dev Modifier to make a function callable only when the contract is paused.
99    */
100   modifier whenPaused() {
101     require(paused);
102     _;
103   }
104 
105   /**
106    * @dev called by the owner to pause, triggers stopped state
107    */
108   function pause() onlyOwner whenNotPaused public {
109     paused = true;
110     Pause();
111   }
112 
113   /**
114    * @dev called by the owner to unpause, returns to normal state
115    */
116   function unpause() onlyOwner whenPaused public {
117     paused = false;
118     Unpause();
119   }
120 }
121 
122 /*****
123     * Orginally from https://github.com/OpenZeppelin/zeppelin-solidity
124     * Modified by https://github.com/agarwalakarsh
125     */
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
300 	string public constant name      = "JWC"; //tokens name
301 	string public constant symbol    = "JWC"; //token symbol
302 	uint256 public constant decimals = 18;    //token decimal
303 	string public constant version   = "1.0"; //tokens version
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
364   uint256 public constant phasePresale_From = 1517493600;//14h 01/02/2018 GMT
365   uint256 public constant phasePresale_To = 1518703200;//14h 15/02/2018 GMT
366 
367   uint256 public constant phasePublicSale1_From = 1520690400;//14h 10/03/2018 GMT
368   uint256 public constant phasePublicSale1_To = 1521122400;//14h 15/03/2018 GMT
369 
370   uint256 public constant phasePublicSale2_From = 1521122400;//14h 15/03/2018 GMT
371   uint256 public constant phasePublicSale2_To = 1521554400;//14h 20/03/2018 GMT
372 
373   uint256 public constant phasePublicSale3_From = 1521554400;//14h 20/03/2018 GMT
374   uint256 public constant phasePublicSale3_To = 1521986400;//14h 25/03/2018 GMT
375 }
376 
377 /**
378  * This contract will give affiliate for user when buy tokens. The affiliate will be paid after finishing ICO
379  */
380 contract Affiliate is Ownable {
381 
382 	//Control Affiliate feature.
383 	bool public isAffiliate;
384 
385 	//Affiliate level, init is 1
386 	uint256 public affiliateLevel = 1;
387 
388 	//Each user will have different rate
389 	mapping(uint256 => uint256) public affiliateRate;
390 
391 	//Keep balance of user
392 	mapping(address => uint256) public referralBalance;//referee=>value
393 
394 	mapping(address => address) public referral;//referee=>referrer
395 	mapping(uint256 => address) public referralIndex;//index=>referee
396 
397 	uint256 public referralCount;
398 
399 	//amount of accounts have been paid affiliate
400 	uint256 public indexPaidAffiliate;
401 
402 	/**
403 	 * Throw if affiliate is disable
404 	 */
405 	modifier whenAffiliate() {
406 		require (isAffiliate);
407 		_;
408 	}
409 
410 	/**
411 	 * constructor affiliate with level 1 rate = 10%
412 	 */
413 	function Affiliate() public {
414 		isAffiliate=true;
415 		affiliateLevel=1;
416 		affiliateRate[0]=10;
417 	}
418 
419 	/**
420 	 * Enable affiliate for the contract
421 	 */
422 	function enableAffiliate() public onlyOwner returns (bool) {
423 		require (!isAffiliate);
424 		isAffiliate=true;
425 		return true;
426 	}
427 
428 	/**
429 	 * Disable affiliate for the contract
430 	 */
431 	function disableAffiliate() public onlyOwner returns (bool) {
432 		require (isAffiliate);
433 		isAffiliate=false;
434 		return true;
435 	}
436 
437 	/**
438 	 * Return current affiliate level
439 	 */
440 	function getAffiliateLevel() public constant returns(uint256)
441 	{
442 		return affiliateLevel;
443 	}
444 
445 	/**
446 	 * Update affiliate level by owner
447 	 * @param _level - new level
448 	 */
449 	function setAffiliateLevel(uint256 _level) public onlyOwner whenAffiliate returns(bool)
450 	{
451 		affiliateLevel=_level;
452 		return true;
453 	}
454 
455 	/**
456 	 * Get referrer address
457 	 * @param _referee - the referee address
458 	 */
459 	function getReferrerAddress(address _referee) public constant returns (address)
460 	{
461 		return referral[_referee];
462 	}
463 
464 	/**
465 	 * Get referee address
466 	 * @param _referrer - the referrer address
467 	 */
468 	function getRefereeAddress(address _referrer) public constant returns (address[] _referee)
469 	{
470 		address[] memory refereeTemp = new address[](referralCount);
471 		uint count = 0;
472 		uint i;
473 		for (i=0; i<referralCount; i++){
474 			if(referral[referralIndex[i]] == _referrer){
475 				refereeTemp[count] = referralIndex[i];
476 
477 				count += 1;
478 			}
479 		}
480 
481 		_referee = new address[](count);
482 		for (i=0; i<count; i++)
483 			_referee[i] = refereeTemp[i];
484 	}
485 
486 	/**
487 	 * Mapping referee address with referrer address
488 	 * @param _parent - the referrer address
489 	 * @param _child - the referee address
490 	 */
491 	function setReferralAddress(address _parent, address _child) public onlyOwner whenAffiliate returns (bool)
492 	{
493 		require(_parent != address(0x00));
494 		require(_child != address(0x00));
495 
496 		referralIndex[referralCount]=_child;
497 		referral[_child]=_parent;
498 		referralCount++;
499 
500 		referralBalance[_child]=0;
501 
502 		return true;
503 	}
504 
505 	/**
506 	 * Get affiliate rate by level
507 	 * @param _level - level to get affiliate rate
508 	 */
509 	function getAffiliateRate(uint256 _level) public constant returns (uint256 rate)
510 	{
511 		return affiliateRate[_level];
512 	}
513 
514 	/**
515 	 * Set affiliate rate for level
516 	 * @param _level - the level to be set the new rate
517 	 * @param _rate - new rate
518 	 */
519 	function setAffiliateRate(uint256 _level, uint256 _rate) public onlyOwner whenAffiliate returns (bool)
520 	{
521 		affiliateRate[_level]=_rate;
522 		return true;
523 	}
524 
525 	/**
526 	 * Get affiliate balance of an account
527 	 * @param _referee - the address to get affiliate of
528 	 */
529 	function balanceAffiliateOf(address _referee) public constant returns (uint256)
530 	{
531 		return referralBalance[_referee];
532 	}
533 
534 	/**
535 	 * Pay affiliate
536 	 */
537 	function payAffiliate() public onlyOwner returns (bool success);
538 }
539 
540 /**
541  * This contract will give bonus for user when buy tokens. The bonus will be paid after finishing ICO
542  */
543 contract Bonus is IcoPhase, Ownable {
544 	using SafeMath for uint256;
545 
546 	//decimals of tokens
547 	uint256 constant decimals = 18;
548 
549 	//enable/disable
550 	bool public isBonus;
551 
552 	//storage
553 	mapping(address => uint256) public bonusAccountBalances;
554 	mapping(uint256 => address) public bonusAccountIndex;
555 	uint256 public bonusAccountCount;
556 
557 	uint256 public indexPaidBonus;//amount of accounts have been paid bonus
558 
559 	function Bonus() public {
560 		isBonus = true;
561 	}
562 
563 	/**
564 	 * Enable bonus
565 	 */
566 	function enableBonus() public onlyOwner returns (bool)
567 	{
568 		require(!isBonus);
569 		isBonus=true;
570 		return true;
571 	}
572 
573 	/**
574 	 * Disable bonus
575 	 */
576 	function disableBonus() public onlyOwner returns (bool)
577 	{
578 		require(isBonus);
579 		isBonus=false;
580 		return true;
581 	}
582 
583 	/**
584 	 * Get bonus percent by time
585 	 */
586 	function getTimeBonus() public constant returns(uint256) {
587 		uint256 bonus = 0;
588 
589 		if(now>=phasePresale_From && now<phasePresale_To){
590 			bonus = 20;
591 		} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {
592 			bonus = 10;
593 		} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {
594 			bonus = 6;
595 		} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {
596 			bonus = 3;
597 		}
598 
599 		return bonus;
600 	}
601 
602 	/**
603 	 * Get bonus balance of an account
604 	 * @param _owner - the address to get bonus of
605 	 */
606 	function balanceBonusOf(address _owner) public constant returns (uint256 balance)
607 	{
608 		return bonusAccountBalances[_owner];
609 	}
610 
611 	/**
612 	 * Get bonus balance of an account
613 	 */
614 	function payBonus() public onlyOwner returns (bool success);
615 }
616 
617 /**
618  * This contract will send tokens when an account send eth
619  * Note: before send eth to token, address has to be registered by registerRecipient function
620  */
621 contract IcoContract is IcoPhase, Ownable, Pausable, Affiliate, Bonus {
622 	using SafeMath for uint256;
623 
624 	JWCToken ccc;
625 
626 	uint256 public totalTokenSale;
627 	uint256 public minContribution = 0.5 ether;//minimun eth used to buy tokens
628 	uint256 public tokenExchangeRate = 7000;//1ETH=7000 tokens
629 	uint256 public constant decimals = 18;
630 
631 	uint256 public tokenRemainPreSale;//tokens remain for pre-sale
632 	uint256 public tokenRemainPublicSale;//tokens for public-sale
633 
634 	address public ethFundDeposit = 0xC69f762Cf7255c13e616E8D8eb328A6588cA2826;//multi-sig wallet
635 	address public tokenAddress;
636 
637 	bool public isFinalized;
638 
639 	uint256 public maxGasRefund = 0.004 ether;//maximum gas used to refund for each transaction
640 
641 	//constructor
642 	function IcoContract(address _tokenAddress) public {
643 		tokenAddress = _tokenAddress;
644 
645 		ccc = JWCToken(tokenAddress);
646 		totalTokenSale = ccc.tokenPreSale() + ccc.tokenPublicSale();
647 
648 		tokenRemainPreSale = ccc.tokenPreSale();//tokens remain for pre-sale
649 		tokenRemainPublicSale = ccc.tokenPublicSale();//tokens for public-sale
650 
651 		isFinalized=false;
652 	}
653 
654 	/**
655 	 * web3 change token from eth
656 	 * @param _value - amount of ETH to convert to token
657 	 */
658 	function changeETH2Token(uint256 _value) public constant returns(uint256) {
659 		uint256 etherRecev = _value + maxGasRefund;
660 		require (etherRecev >= minContribution);
661 
662 		uint256 rate = getTokenExchangeRate();
663 
664 		uint256 tokens = etherRecev.mul(rate);
665 
666 		//get current phase of ICO
667 		uint256 phaseICO = getCurrentICOPhase();
668 		uint256 tokenRemain = 0;
669 		if(phaseICO == 1){//pre-sale
670 			tokenRemain = tokenRemainPreSale;
671 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
672 			tokenRemain = tokenRemainPublicSale;
673 		}
674 
675 		if (tokenRemain < tokens) {
676 			tokens=tokenRemain;
677 		}
678 
679 		return tokens;
680 	}
681 
682 	/**
683 	 * will be called when user send eth to buy token
684 	 */
685 	function () public payable whenNotPaused {
686 		require (!isFinalized);
687 		require (msg.sender != address(0));
688 
689 		uint256 etherRecev = msg.value + maxGasRefund;
690 		require (etherRecev >= minContribution);
691 
692 		//get current token exchange rate
693 		tokenExchangeRate = getTokenExchangeRate();
694 
695 		uint256 tokens = etherRecev.mul(tokenExchangeRate);
696 
697 		//get current phase of ICO
698 		uint256 phaseICO = getCurrentICOPhase();
699 
700 		require(phaseICO!=0);
701 
702 		uint256 tokenRemain = 0;
703 		if(phaseICO == 1){//pre-sale
704 			tokenRemain = tokenRemainPreSale;
705 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
706 			tokenRemain = tokenRemainPublicSale;
707 		}
708 
709 		//throw if tokenRemain==0
710 		require(tokenRemain>0);
711 
712 		if (tokenRemain < tokens) {
713 			//if tokens is not enough to buy
714 
715 			uint256 tokensToRefund = tokens.sub(tokenRemain);
716 			uint256 etherToRefund = tokensToRefund / tokenExchangeRate;
717 
718 			//refund eth to buyer
719 			msg.sender.transfer(etherToRefund);
720 
721 			tokens=tokenRemain;
722 			etherRecev = etherRecev.sub(etherToRefund);
723 
724 			tokenRemain = 0;
725 		} else {
726 			tokenRemain = tokenRemain.sub(tokens);
727 		}
728 
729 		//store token remain by phase
730 		if(phaseICO == 1){//pre-sale
731 			tokenRemainPreSale = tokenRemain;
732 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
733 			tokenRemainPublicSale = tokenRemain;
734 		}
735 
736 		//send token
737 		ccc.sell(msg.sender, tokens);
738 		ethFundDeposit.transfer(this.balance);
739 
740 		//bonus
741 		if(isBonus){
742 			//bonus time
743 			uint256 bonusTimeToken = tokens.mul(getTimeBonus())/100;
744 
745 			//store bonus
746 			if(bonusAccountBalances[msg.sender]==0){//new
747 				bonusAccountIndex[bonusAccountCount]=msg.sender;
748 				bonusAccountCount++;
749 			}
750 
751 			bonusAccountBalances[msg.sender]=bonusAccountBalances[msg.sender].add(bonusTimeToken);
752 		}
753 
754 		//affiliate
755 		if(isAffiliate){
756 			address child=msg.sender;
757 			for(uint256 i=0; i<affiliateLevel; i++){
758 				uint256 giftToken=affiliateRate[i].mul(tokens)/100;
759 
760 				address parent = referral[child];
761 				if(parent != address(0x00)){//has affiliate
762 					referralBalance[child]=referralBalance[child].add(giftToken);
763 				}
764 
765 				child=parent;
766 			}
767 		}
768 	}
769 
770 	/**
771 	 * Pay affiliate to address. Called when ICO finish
772 	 */
773 	function payAffiliate() public onlyOwner returns (bool success) {
774 		uint256 toIndex = indexPaidAffiliate + 15;
775 		if(referralCount < toIndex)
776 			toIndex = referralCount;
777 
778 		for(uint256 i=indexPaidAffiliate; i<toIndex; i++) {
779 			address referee = referralIndex[i];
780 
781 			if(referralBalance[referee]>0)
782 				payAffiliate1Address(referee);
783 		}
784 
785 		return true;
786 	}
787 
788 	/**
789 	 * Pay affiliate to only a address
790 	 * @param _referee - the address of referee
791 	 */
792 	function payAffiliate1Address(address _referee) public onlyOwner returns (bool success) {
793 		address referrer = referral[_referee];
794 		ccc.payBonusAffiliate(referrer, referralBalance[_referee]);
795 
796 		referralBalance[_referee]=0;
797 		return true;
798 	}
799 
800 	/**
801 	 * Pay bonus to address. Called when ICO finish
802 	 */
803 	function payBonus() public onlyOwner returns (bool success) {
804 		uint256 toIndex = indexPaidBonus + 15;
805 		if(bonusAccountCount < toIndex)
806 			toIndex = bonusAccountCount;
807 
808 		for(uint256 i=indexPaidBonus; i<toIndex; i++)
809 		{
810 			if(bonusAccountBalances[bonusAccountIndex[i]]>0)
811 				payBonus1Address(bonusAccountIndex[i]);
812 		}
813 
814 		return true;
815 	}
816 
817 	/**
818 	 * Pay bonus to only a address
819 	 * @param _address - the address to pay bonus
820 	 */
821 	function payBonus1Address(address _address) public onlyOwner returns (bool success) {
822 		ccc.payBonusAffiliate(_address, bonusAccountBalances[_address]);
823 		bonusAccountBalances[_address]=0;
824 		return true;
825 	}
826 
827 	function finalize() external onlyOwner {
828 		require (!isFinalized);
829 		// move to operational
830 		isFinalized = true;
831 		payAffiliate();
832 		payBonus();
833 		ethFundDeposit.transfer(this.balance);
834 	}
835 
836 	/**
837 	 * Get token exchange rate
838 	 */
839 	function getTokenExchangeRate() public constant returns(uint256 rate) {
840 		rate = tokenExchangeRate;
841 		if(now<phasePresale_To){
842 			if(now>=phasePresale_From)
843 				rate = 10000;
844 		} else if(now<phasePublicSale3_To){
845 			rate = 7000;
846 		}
847 	}
848 
849 	/**
850 	 * Get the current ICO phase
851 	 */
852 	function getCurrentICOPhase() public constant returns(uint256 phase) {
853 		phase = 0;
854 		if(now>=phasePresale_From && now<phasePresale_To){
855 			phase = 1;
856 		} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {
857 			phase = 2;
858 		} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {
859 			phase = 3;
860 		} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {
861 			phase = 4;
862 		}
863 	}
864 
865 	/**
866 	 * Get amount of tokens that be sold
867 	 */
868 	function getTokenSold() public constant returns(uint256 tokenSold) {
869 		//get current phase of ICO
870 		uint256 phaseICO = getCurrentICOPhase();
871 		tokenSold = 0;
872 		if(phaseICO == 1){//pre-sale
873 			tokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale);
874 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
875 			tokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale) + ccc.tokenPublicSale().sub(tokenRemainPublicSale);
876 		}
877 	}
878 
879 	/**
880 	 * Set token exchange rate
881 	 * @param _tokenExchangeRate - rate of eth-token
882 	 */
883 	function setTokenExchangeRate(uint256 _tokenExchangeRate) public onlyOwner returns (bool) {
884 		require(_tokenExchangeRate>0);
885 		tokenExchangeRate=_tokenExchangeRate;
886 		return true;
887 	}
888 
889 	/**
890 	 * set min eth contribute
891 	 * @param _minContribution - min eth to contribute
892 	 */
893 	function setMinContribution(uint256 _minContribution) public onlyOwner returns (bool) {
894 		require(_minContribution>0);
895 		minContribution=_minContribution;
896 		return true;
897 	}
898 
899 	/**
900 	 * Change multi-sig address, the address to receive ETH
901 	 * @param _ethFundDeposit - new multi-sig address
902 	 */
903 	function setEthFundDeposit(address _ethFundDeposit) public onlyOwner returns (bool) {
904 		require(_ethFundDeposit != address(0));
905 		ethFundDeposit=_ethFundDeposit;
906 		return true;
907 	}
908 
909 	/**
910 	 * Set max gas to refund when an address send ETH to buy tokens
911 	 * @param _maxGasRefund - max gas
912 	 */
913 	function setMaxGasRefund(uint256 _maxGasRefund) public onlyOwner returns (bool) {
914 		require(_maxGasRefund > 0);
915 		maxGasRefund = _maxGasRefund;
916 		return true;
917 	}
918 }