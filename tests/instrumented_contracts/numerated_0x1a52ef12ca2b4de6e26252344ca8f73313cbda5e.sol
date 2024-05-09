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
305 	uint256 public tokenPreSale         = 100000000 * 10**decimals;//tokens for pre-sale
306 	uint256 public tokenPublicSale      = 400000000 * 10**decimals;//tokens for public-sale
307 	uint256 public tokenReserve         = 300000000 * 10**decimals;//tokens for reserve
308 	uint256 public tokenTeamSupporter   = 120000000 * 10**decimals;//tokens for Team & Supporter
309 	uint256 public tokenAdvisorPartners = 80000000  * 10**decimals;//tokens for Advisor
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
331 	 * @param _value - amount of tokens
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
344 	 * Sell tokens when we don't have enough token in PreSale. Only called by ICO Contract
345 	 * @param _recipient - address send ETH to buy tokens
346 	 * @param _value - amount of tokens
347 	 */
348 	function sellSpecialTokensForPreSale(address _recipient, uint256 _value) public whenNotPaused returns (bool success) {
349 		assert(_value > 0);
350 		require(msg.sender == icoContract);
351 
352 		balances[_recipient] = balances[_recipient].add(_value);
353 		tokenPreSale = tokenPreSale.add(_value);
354 		totalSupply = totalSupply.add(_value);
355 
356 		Transfer(0x0, _recipient, _value);
357 		return true;
358 	}
359 
360 	/**
361 	 * Sell tokens when we don't have enough token in PublicSale. Only called by ICO Contract
362 	 * @param _recipient - address send ETH to buy tokens
363 	 * @param _value - amount of tokens
364 	 */
365 	function sellSpecialTokensForPublicSale(address _recipient, uint256 _value) public whenNotPaused returns (bool success) {
366 		assert(_value > 0);
367 		require(msg.sender == icoContract);
368 
369 		balances[_recipient] = balances[_recipient].add(_value);
370 		tokenPublicSale = tokenPublicSale.add(_value);
371 		totalSupply = totalSupply.add(_value);
372 
373 		Transfer(0x0, _recipient, _value);
374 		return true;
375 	}
376 
377 	/**
378 	 * Pay bonus & affiliate to address
379 	 * @param _recipient - address to receive bonus & affiliate
380 	 * @param _value - value bonus & affiliate to give
381 	 */
382 	function payBonusAffiliate(address _recipient, uint256 _value) public returns (bool success) {
383 		assert(_value > 0);
384 		require(msg.sender == icoContract);
385 
386 		balances[_recipient] = balances[_recipient].add(_value);
387 		totalSupply = totalSupply.add(_value);
388 
389 		Transfer(0x0, _recipient, _value);
390 		return true;
391 	}
392 }
393 
394 /**
395  * Store config of phase ICO
396  */
397 contract IcoPhase {
398   uint256 public constant phasePresale_From = 1517493600;//14h 01/02/2018 GMT
399   uint256 public constant phasePresale_To = 1518703200;//14h 15/02/2018 GMT
400 
401   uint256 public constant phasePublicSale1_From = 1520690400;//14h 10/03/2018 GMT
402   uint256 public constant phasePublicSale1_To = 1521122400;//14h 15/03/2018 GMT
403 
404   uint256 public constant phasePublicSale2_From = 1521122400;//14h 15/03/2018 GMT
405   uint256 public constant phasePublicSale2_To = 1521554400;//14h 20/03/2018 GMT
406 
407   uint256 public constant phasePublicSale3_From = 1521554400;//14h 20/03/2018 GMT
408   uint256 public constant phasePublicSale3_To = 1521986400;//14h 25/03/2018 GMT
409 }
410 
411 /**
412  * This contract will give affiliate for user when buy tokens. The affiliate will be paid after finishing ICO
413  */
414 contract Affiliate is Ownable {
415 
416 	//Control Affiliate feature.
417 	bool public isAffiliate;
418 
419 	//Affiliate level, init is 1
420 	uint256 public affiliateLevel = 1;
421 
422 	//Each user will have different rate
423 	mapping(uint256 => uint256) public affiliateRate;
424 
425 	//Keep balance of user
426 	mapping(address => uint256) public referralBalance;//referee=>value
427 
428 	mapping(address => address) public referral;//referee=>referrer
429 	mapping(uint256 => address) public referralIndex;//index=>referee
430 
431 	uint256 public referralCount;
432 
433 	/**
434 	 * Throw if affiliate is disable
435 	 */
436 	modifier whenAffiliate() {
437 		require (isAffiliate);
438 		_;
439 	}
440 
441 	/**
442 	 * constructor affiliate with level 1 rate = 6%
443 	 */
444 	function Affiliate() public {
445 		isAffiliate=true;
446 		affiliateLevel=1;
447 		affiliateRate[0]=6;
448 	}
449 
450 	/**
451 	 * Enable affiliate for the contract
452 	 */
453 	function enableAffiliate() public onlyOwner returns (bool) {
454 		require (!isAffiliate);
455 		isAffiliate=true;
456 		return true;
457 	}
458 
459 	/**
460 	 * Disable affiliate for the contract
461 	 */
462 	function disableAffiliate() public onlyOwner returns (bool) {
463 		require (isAffiliate);
464 		isAffiliate=false;
465 		return true;
466 	}
467 
468 	/**
469 	 * Return current affiliate level
470 	 */
471 	function getAffiliateLevel() public constant returns(uint256)
472 	{
473 		return affiliateLevel;
474 	}
475 
476 	/**
477 	 * Update affiliate level by owner
478 	 * @param _level - new level
479 	 */
480 	function setAffiliateLevel(uint256 _level) public onlyOwner whenAffiliate returns(bool)
481 	{
482 		affiliateLevel=_level;
483 		return true;
484 	}
485 
486 	/**
487 	 * Get referrer address
488 	 * @param _referee - the referee address
489 	 */
490 	function getReferrerAddress(address _referee) public constant returns (address)
491 	{
492 		return referral[_referee];
493 	}
494 
495 	/**
496 	 * Get referee address
497 	 * @param _referrer - the referrer address
498 	 */
499 	function getRefereeAddress(address _referrer) public constant returns (address[] _referee)
500 	{
501 		address[] memory refereeTemp = new address[](referralCount);
502 		uint count = 0;
503 		uint i;
504 		for (i=0; i<referralCount; i++){
505 			if(referral[referralIndex[i]] == _referrer){
506 				refereeTemp[count] = referralIndex[i];
507 
508 				count += 1;
509 			}
510 		}
511 
512 		_referee = new address[](count);
513 		for (i=0; i<count; i++)
514 			_referee[i] = refereeTemp[i];
515 	}
516 
517 	/**
518 	 * Mapping referee address with referrer address
519 	 * @param _parent - the referrer address
520 	 * @param _child - the referee address
521 	 */
522 	function setReferralAddress(address _parent, address _child) public onlyOwner whenAffiliate returns (bool)
523 	{
524 		require(_parent != address(0x00));
525 		require(_child != address(0x00));
526 
527 		referralIndex[referralCount]=_child;
528 		referral[_child]=_parent;
529 		referralCount++;
530 
531 		referralBalance[_child]=0;
532 
533 		return true;
534 	}
535 
536 	/**
537 	 * Get affiliate rate by level
538 	 * @param _level - level to get affiliate rate
539 	 */
540 	function getAffiliateRate(uint256 _level) public constant returns (uint256 rate)
541 	{
542 		return affiliateRate[_level];
543 	}
544 
545 	/**
546 	 * Set affiliate rate for level
547 	 * @param _level - the level to be set the new rate
548 	 * @param _rate - new rate
549 	 */
550 	function setAffiliateRate(uint256 _level, uint256 _rate) public onlyOwner whenAffiliate returns (bool)
551 	{
552 		affiliateRate[_level]=_rate;
553 		return true;
554 	}
555 
556 	/**
557 	 * Get affiliate balance of an account
558 	 * @param _referee - the address to get affiliate of
559 	 */
560 	function balanceAffiliateOf(address _referee) public constant returns (uint256)
561 	{
562 		return referralBalance[_referee];
563 	}
564 
565 	/**
566 	 * Pay affiliate
567 	 */
568 	function payAffiliateToAddress(address _referee) public onlyOwner returns (bool success);
569 }
570 
571 /**
572  * This contract will give bonus for user when buy tokens. The bonus will be paid after finishing ICO
573  */
574 contract Bonus is IcoPhase, Ownable {
575 	using SafeMath for uint256;
576 
577 	//decimals of tokens
578 	uint256 constant decimals = 18;
579 
580 	//enable/disable
581 	bool public isBonus;
582 
583 	//storage
584 	mapping(address => uint256) public bonusAccountBalances;
585 	mapping(uint256 => address) public bonusAccountIndex;
586 	uint256 public bonusAccountCount;
587 
588 	function Bonus() public {
589 		isBonus = true;
590 	}
591 
592 	/**
593 	 * Enable bonus
594 	 */
595 	function enableBonus() public onlyOwner returns (bool)
596 	{
597 		require(!isBonus);
598 		isBonus=true;
599 		return true;
600 	}
601 
602 	/**
603 	 * Disable bonus
604 	 */
605 	function disableBonus() public onlyOwner returns (bool)
606 	{
607 		require(isBonus);
608 		isBonus=false;
609 		return true;
610 	}
611 
612 	/**
613 	 * Get bonus percent by time
614 	 */
615 	function getBonusByTime() public constant returns(uint256) {
616 		uint256 bonus = 0;
617 
618 		if(now>=phasePresale_From && now<phasePresale_To){
619 			bonus = 10;
620 		} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {
621 			bonus = 6;
622 		} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {
623 			bonus = 3;
624 		} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {
625 			bonus = 1;
626 		}
627 
628 		return bonus;
629 	}
630 
631 	/**
632 	 * Get bonus by eth
633 	 * @param _value - eth to convert to bonus
634 	 */
635 	function getBonusByETH(uint256 _value) public constant returns(uint256) {
636 		uint256 bonus = 0;
637 
638 		if(now>=phasePresale_From && now<phasePresale_To){
639 			if(_value>=400*10**decimals){
640 				bonus=_value.mul(10).div(100);
641 			} else if(_value>=300*10**decimals){
642 				bonus=_value.mul(5).div(100);
643 			}
644 		}
645 
646 		return bonus;
647 	}
648 
649 	/**
650 	 * Get bonus balance of an account
651 	 * @param _owner - the address to get bonus of
652 	 */
653 	function balanceBonusOf(address _owner) public constant returns (uint256 balance)
654 	{
655 		return bonusAccountBalances[_owner];
656 	}
657 
658 	/**
659 	 * Get bonus balance of an account
660 	 */
661 	function payBonusToAddress(address _address) public onlyOwner returns (bool success);
662 }
663 
664 /**
665  * This contract will send tokens when an account send eth
666  * Note: before send eth to token, address has to be registered by registerRecipient function
667  */
668 contract IcoContract is IcoPhase, Ownable, Pausable, Affiliate, Bonus {
669 	using SafeMath for uint256;
670 
671 	JWCToken ccc;
672 
673 	uint256 public totalTokenSale;
674 	uint256 public minContribution = 0.5 ether;//minimun eth used to buy tokens
675 	uint256 public tokenExchangeRate = 10000;//1ETH=10000 tokens
676 	uint256 public constant decimals = 18;
677 
678 	uint256 public tokenRemainPreSale;//tokens remain for pre-sale
679 	uint256 public tokenRemainPublicSale;//tokens for public-sale
680 
681 	address public ethFundDeposit = 0x1Eb0fAaC52ED0AfCcbf1F3E67A399Da5440351cf;//multi-sig wallet
682 	address public tokenAddress;
683 
684 	bool public isFinalized;
685 
686 	uint256 public maxGasRefund = 0.004 ether;//maximum gas used to refund for each transaction
687 
688 	//constructor
689 	function IcoContract(address _tokenAddress) public {
690 		tokenAddress = _tokenAddress;
691 
692 		ccc = JWCToken(tokenAddress);
693 		totalTokenSale = ccc.tokenPreSale() + ccc.tokenPublicSale();
694 
695 		tokenRemainPreSale = ccc.tokenPreSale();//tokens remain for pre-sale
696 		tokenRemainPublicSale = ccc.tokenPublicSale();//tokens for public-sale
697 
698 		isFinalized=false;
699 	}
700 
701 	/**
702 	 * web3 change token from eth
703 	 * @param _value - amount of ETH to convert to token
704 	 */
705 	function changeETH2Token(uint256 _value) public constant returns(uint256) {
706 		uint256 etherRecev = _value + maxGasRefund;
707 		require (etherRecev >= minContribution);
708 
709 		uint256 tokens = etherRecev.mul(tokenExchangeRate);
710 
711 		//get current phase of ICO
712 		uint256 phaseICO = getCurrentICOPhase();
713 		uint256 tokenRemain = 0;
714 		if(phaseICO == 1){//pre-sale
715 			tokenRemain = tokenRemainPreSale;
716 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
717 			tokenRemain = tokenRemainPublicSale;
718 		}
719 
720 		if (tokenRemain < tokens) {
721 			tokens=tokenRemain;
722 		}
723 
724 		return tokens;
725 	}
726 
727 	/**
728 	 * will be called when user send eth to buy token
729 	 */
730 	function () public payable whenNotPaused {
731 		require (!isFinalized);
732 		require (msg.sender != address(0));
733 
734 		uint256 etherRecev = msg.value + maxGasRefund;
735 		require (etherRecev >= minContribution);
736 
737 		uint256 tokens = etherRecev.mul(tokenExchangeRate);
738 
739 		//get current phase of ICO
740 		uint256 phaseICO = getCurrentICOPhase();
741 
742 		require(phaseICO!=0);
743 
744 		uint256 tokenRemain = 0;
745 		if(phaseICO == 1){//pre-sale
746 			tokenRemain = tokenRemainPreSale;
747 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
748 			tokenRemain = tokenRemainPublicSale;
749 		}
750 
751 		//throw if tokenRemain==0
752 		require(tokenRemain>0);
753 
754 		if (tokenRemain < tokens) {
755 			//if tokens is not enough to buy
756 			uint256 tokensToIncrease = tokens.sub(tokenRemain);
757 			ccc.sell(msg.sender, tokenRemain);
758 
759 			if(phaseICO == 1){//pre-sale
760 				ccc.sellSpecialTokensForPreSale(msg.sender, tokensToIncrease);
761 			} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
762 				ccc.sellSpecialTokensForPublicSale(msg.sender, tokensToIncrease);
763 			}
764 
765 			tokenRemain = 0;
766 		} else {
767 			ccc.sell(msg.sender, tokens);
768 			tokenRemain = tokenRemain.sub(tokens);
769 		}
770 
771 		//store token remain by phase
772 		if(phaseICO == 1){//pre-sale
773 			tokenRemainPreSale = tokenRemain;
774 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
775 			tokenRemainPublicSale = tokenRemain;
776 		}
777 
778 		ethFundDeposit.transfer(this.balance);
779 
780 		//bonus
781 		if(isBonus){
782 			//bonus amount
783 			//get bonus by eth
784 			uint256 bonusByETH = getBonusByETH(etherRecev);
785 			//get bonus by token
786 			uint256 bonusTokenByETH = bonusByETH.mul(tokenExchangeRate);
787 
788 			//bonus time
789 			uint256 bonusTokenByTime = tokens.mul(getBonusByTime()).div(100);
790 
791 			//store bonus
792 			if(bonusAccountBalances[msg.sender]==0){//new
793 				bonusAccountIndex[bonusAccountCount]=msg.sender;
794 				bonusAccountCount++;
795 			}
796 
797 			uint256 bonusToken=bonusTokenByTime+bonusTokenByETH;
798 			bonusAccountBalances[msg.sender]=bonusAccountBalances[msg.sender].add(bonusToken);
799 		}
800 
801 		//affiliate
802 		if(isAffiliate){
803 			address child=msg.sender;
804 			for(uint256 i=0; i<affiliateLevel; i++){
805 				uint256 giftToken=affiliateRate[i].mul(tokens).div(100);
806 
807 				address parent = referral[child];
808 				if(parent != address(0x00)){//has affiliate
809 					referralBalance[child]=referralBalance[child].add(giftToken);
810 				}
811 
812 				child=parent;
813 			}
814 		}
815 	}
816 
817 	/**
818 	 * Pay affiliate to only a address
819 	 * @param _referee - the address of referee
820 	 */
821 	function payAffiliateToAddress(address _referee) public onlyOwner returns (bool success) {
822 		address referrer = referral[_referee];
823 		ccc.payBonusAffiliate(referrer, referralBalance[_referee]);
824 
825 		referralBalance[_referee]=0;
826 		return true;
827 	}
828 
829 	/**
830 	 * Pay bonus to only a address
831 	 * @param _address - the address to pay bonus
832 	 */
833 	function payBonusToAddress(address _address) public onlyOwner returns (bool success) {
834 		ccc.payBonusAffiliate(_address, bonusAccountBalances[_address]);
835 		bonusAccountBalances[_address]=0;
836 		return true;
837 	}
838 
839 	function finalize() external onlyOwner {
840 		require (!isFinalized);
841 		// move to operational
842 		isFinalized = true;
843 		ethFundDeposit.transfer(this.balance);
844 	}
845 
846 	/**
847 	 * Get the current ICO phase
848 	 */
849 	function getCurrentICOPhase() public constant returns(uint256 phase) {
850 		phase = 0;
851 		if(now>=phasePresale_From && now<phasePresale_To){
852 			phase = 1;
853 		} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {
854 			phase = 2;
855 		} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {
856 			phase = 3;
857 		} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {
858 			phase = 4;
859 		}
860 	}
861 
862 	/**
863 	 * Get amount of tokens that be sold
864 	 */
865 	function getTokenSold() public constant returns(uint256 tokenSold) {
866 		//get current phase of ICO
867 		uint256 phaseICO = getCurrentICOPhase();
868 		tokenSold = 0;
869 		if(phaseICO == 1){//pre-sale
870 			tokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale);
871 		} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {
872 			tokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale) + ccc.tokenPublicSale().sub(tokenRemainPublicSale);
873 		}
874 	}
875 
876 	/**
877 	 * Set token exchange rate
878 	 * @param _tokenExchangeRate - rate of eth-token
879 	 */
880 	function setTokenExchangeRate(uint256 _tokenExchangeRate) public onlyOwner returns (bool) {
881 		require(_tokenExchangeRate>0);
882 		tokenExchangeRate=_tokenExchangeRate;
883 		return true;
884 	}
885 
886 	/**
887 	 * set min eth contribute
888 	 * @param _minContribution - min eth to contribute
889 	 */
890 	function setMinContribution(uint256 _minContribution) public onlyOwner returns (bool) {
891 		require(_minContribution>0);
892 		minContribution=_minContribution;
893 		return true;
894 	}
895 
896 	/**
897 	 * Change multi-sig address, the address to receive ETH
898 	 * @param _ethFundDeposit - new multi-sig address
899 	 */
900 	function setEthFundDeposit(address _ethFundDeposit) public onlyOwner returns (bool) {
901 		require(_ethFundDeposit != address(0));
902 		ethFundDeposit=_ethFundDeposit;
903 		return true;
904 	}
905 
906 	/**
907 	 * Set max gas to refund when an address send ETH to buy tokens
908 	 * @param _maxGasRefund - max gas
909 	 */
910 	function setMaxGasRefund(uint256 _maxGasRefund) public onlyOwner returns (bool) {
911 		require(_maxGasRefund > 0);
912 		maxGasRefund = _maxGasRefund;
913 		return true;
914 	}
915 }