1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 pragma solidity ^0.4.18;
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 contract Haltable is Ownable {
92 	bool public halted;
93 
94 	modifier stopInEmergency {
95 		require(!halted);
96 		_;
97 	}
98 
99 	modifier onlyInEmergency {
100 		require(halted);
101 		_;
102 	}
103 
104 	// called by the owner on emergency, triggers stopped state
105 	function halt() public onlyOwner {
106 		halted = true;
107 	}
108 
109 	// called by the owner on end of emergency, returns to normal state
110 	function unhalt() public onlyOwner onlyInEmergency {
111 		halted = false;
112 	}
113 }
114 
115 
116 pragma solidity ^0.4.18;
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   uint256 totalSupply_;
140 
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[msg.sender]);
156 
157     // SafeMath.sub will throw if there is not enough balance.
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) public view returns (uint256 balance) {
170     return balances[_owner];
171   }
172 
173 }
174 
175 pragma solidity ^0.4.18;
176 
177 /**
178  * @title ERC20 interface
179  * @dev see https://github.com/ethereum/EIPs/issues/20
180  */
181 contract ERC20 is ERC20Basic {
182   function allowance(address owner, address spender) public view returns (uint256);
183   function transferFrom(address from, address to, uint256 value) public returns (bool);
184   function approve(address spender, uint256 value) public returns (bool);
185   event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/ethereum/EIPs/issues/20
195  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[_from]);
211     require(_value <= allowed[_from][msg.sender]);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 /**
286  * @title Mintable token
287  * @dev Simple ERC20 Token example, with mintable token creation
288  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
289  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
290  */
291 contract MintableToken is StandardToken, Ownable {
292   event Mint(address indexed to, uint256 amount);
293   event MintFinished();
294 
295   bool public mintingFinished = false;
296 
297 
298   modifier canMint() {
299     require(!mintingFinished);
300     _;
301   }
302 
303   /**
304    * @dev Function to mint tokens
305    * @param _to The address that will receive the minted tokens.
306    * @param _amount The amount of tokens to mint.
307    * @return A boolean that indicates if the operation was successful.
308    */
309   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
310     totalSupply_ = totalSupply_.add(_amount);
311     balances[_to] = balances[_to].add(_amount);
312     Mint(_to, _amount);
313     Transfer(address(0), _to, _amount);
314     return true;
315   }
316 
317   /**
318    * @dev Function to stop minting new tokens.
319    * @return True if the operation was successful.
320    */
321   function finishMinting() onlyOwner canMint public returns (bool) {
322     mintingFinished = true;
323     MintFinished();
324     return true;
325   }
326 }
327 
328 
329 
330 /**
331  * @title Capped token
332  * @dev Mintable token with a token cap.
333  */
334 contract CappedToken is MintableToken {
335 
336   uint256 public cap;
337 
338   function CappedToken(uint256 _cap) public {
339     require(_cap > 0);
340     cap = _cap;
341   }
342 
343   /**
344    * @dev Function to mint tokens
345    * @param _to The address that will receive the minted tokens.
346    * @param _amount The amount of tokens to mint.
347    * @return A boolean that indicates if the operation was successful.
348    */
349   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
350     require(totalSupply_.add(_amount) <= cap);
351 
352     return super.mint(_to, _amount);
353   }
354 
355 }
356 
357 
358 /**
359  * Merit token
360  */
361 contract MeritToken is CappedToken {
362 	event NewCap(uint256 value);
363 
364 	string public constant name = "Merit Token"; // solium-disable-line uppercase
365 	string public constant symbol = "MERIT"; // solium-disable-line uppercase
366 	uint8 public constant decimals = 18; // solium-disable-line uppercase
367 	bool public tokensReleased;
368 
369 	function MeritToken(uint256 _cap) public CappedToken(_cap * 10**uint256(decimals)) { }
370 
371     modifier released {
372         require(mintingFinished);
373         _;
374     }
375     
376     modifier notReleased {
377         require(!mintingFinished);
378         _;
379     }
380     
381     // only allow these functions once the token is released (minting is done)
382     // basically the zeppelin 'Pausable' token but using my token release flag
383     // Only allow our token to be usable once the minting phase is over
384     function transfer(address _to, uint256 _value) public released returns (bool) {
385         return super.transfer(_to, _value);
386     }
387     
388     function transferFrom(address _from, address _to, uint256 _value) public released returns (bool) {
389         return super.transferFrom(_from, _to, _value);
390     }
391     
392     function approve(address _spender, uint256 _value) public released returns (bool) {
393         return super.approve(_spender, _value);
394     }
395     
396     function increaseApproval(address _spender, uint _addedValue) public released returns (bool success) {
397         return super.increaseApproval(_spender, _addedValue);
398     }
399     
400     function decreaseApproval(address _spender, uint _subtractedValue) public released returns (bool success) {
401         return super.decreaseApproval(_spender, _subtractedValue);
402     }
403     
404     // for our token, the balance will always be zero if we're still minting them
405 	// once we're done minting, the tokens will be effectively released to their owners
406     function balanceOf(address _owner) public view released returns (uint256 balance) {
407         return super.balanceOf(_owner);
408     }
409 
410     // lets us see the pre-allocated balance, since we're just letting the token keep track of all of the allocations
411     // instead of going through another complete allocation step for all users
412     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
413         return super.balanceOf(_owner);
414     }
415     
416     // revoke a user's tokens if they have been banned for violating the TOS.
417     // Note, this can only be called during the ICO phase and not once the tokens are released.
418     function revoke(address _owner) public onlyOwner notReleased returns (uint256 balance) {
419         // the balance should never ben greater than our total supply, so don't worry about checking
420         balance = balances[_owner];
421         balances[_owner] = 0;
422         totalSupply_ = totalSupply_.sub(balance);
423     }
424   }
425 
426 
427 contract MeritICO is Ownable, Haltable {
428 	using SafeMath for uint256;
429 
430 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
431 		
432 	// token
433 	MeritToken public token;
434 	address public reserveVault;
435 	address public restrictedVault;
436 	//address public fundWallet;
437 
438 	enum Stage 		{ None, Closed, PrivateSale, PreSale, Round1, Round2, Round3, Round4, Allocating, Done }
439 	Stage public currentStage;
440 
441 	uint256 public tokenCap;
442 	uint256 public icoCap;
443 	uint256 public marketingCap;
444 	uint256 public teamCap;
445 	uint256 public reserveCap;
446 
447     // number of tokens per ether, kept with 3 decimals (so divide by 1000)
448 	uint public exchangeRate;
449 	uint public bonusRate;
450 	uint256 public currentSaleCap;
451 
452 	uint256 public weiRaised;
453 	uint256 public baseTokensAllocated;
454 	uint256 public bonusTokensAllocated;
455 	bool public saleAllocated;
456 	
457 	struct Contribution {
458 	    uint256 base;
459 	    uint256 bonus;
460 	}
461 	// current base and bonus balances for each contributor
462 	mapping (address => Contribution) contributionBalance;
463 
464 	// map of any address that has been banned from participating in the ICO, for violations of TOS
465 	mapping (address => bool) blacklist;
466 
467 	modifier saleActive {
468 		require(currentStage > Stage.Closed && currentStage < Stage.Allocating);
469 		_;
470 	}
471 
472 	modifier saleAllocatable {
473 		require(currentStage > Stage.Closed && currentStage <= Stage.Allocating);
474 		_;
475 	}
476 	
477 	modifier saleNotDone {
478 		require(currentStage != Stage.Done);
479 		_;
480 	}
481 
482 	modifier saleAllocating {
483 		require (currentStage == Stage.Allocating);
484 		_;
485 	}
486 	
487 	modifier saleClosed {
488 	    require (currentStage == Stage.Closed);
489 	    _;
490 	}
491 	
492 	modifier saleDone {
493 	    require (currentStage == Stage.Done);
494 	    _;
495 	}
496 
497 	// _token is the address of an already deployed MeritToken contract
498 	//
499 	// team tokens go into a restricted access vault
500 	// reserve tokens go into a reserve vault
501 	// any bonus or referral tokens come out of the marketing pool
502 	// any base purchased tokens come out of the ICO pool
503 	// all percentages are based off of the cap in the passed in token
504 	//
505 	// anything left over in the marketing or ico pool is burned
506 	//
507 	function MeritICO() public {
508 		//fundWallet = _fundWallet;
509 		currentStage = Stage.Closed;
510 	}
511 
512 	function updateToken(address _token) external onlyOwner saleNotDone {
513 		require(_token != address(0));
514 		
515 	    token = MeritToken(_token); 
516 	    
517 	    tokenCap = token.cap();
518 	    
519 	    require(MeritToken(_token).owner() == address(this));
520 	}
521 
522 	function updateCaps(uint256 _icoPercent, uint256 _marketingPercent, uint256 _teamPercent, uint256 _reservePercent) external onlyOwner saleNotDone {
523 		require(_icoPercent + _marketingPercent + _teamPercent + _reservePercent == 100);
524 
525 		uint256 max = tokenCap;
526         
527 		marketingCap = max.mul(_marketingPercent).div(100);
528 		icoCap = max.mul(_icoPercent).div(100);
529 		teamCap = max.mul(_teamPercent).div(100);
530 		reserveCap = max.mul(_reservePercent).div(100);
531 
532 		require (marketingCap + icoCap + teamCap + reserveCap == max);
533 	}
534 
535 	function setStage(Stage _stage) public onlyOwner saleNotDone {
536 		// don't allow you to set the stage to done unless the tokens have been released
537 		require (_stage != Stage.Done || saleAllocated == true);
538 		currentStage = _stage;
539 	}
540 
541 	function startAllocation() public onlyOwner saleActive {
542 		require (!saleAllocated);
543 		currentStage = Stage.Allocating;
544 	}
545     
546 	// set how many tokens per wei, kept with 3 decimals
547 	function updateExchangeRate(uint _rateTimes1000) public onlyOwner saleNotDone {
548 		exchangeRate = _rateTimes1000;
549 	}
550 
551 	// bonus rate percentage (value 0 to 100)
552 	// cap is the cumulative cap at this point in time
553 	function updateICO(uint _bonusRate, uint256 _cap, Stage _stage) external onlyOwner saleNotDone {
554 		require (_bonusRate <= 100);
555 		require(_cap <= icoCap);
556 		require(_stage != Stage.None);
557 		
558 		bonusRate = _bonusRate;
559 		currentSaleCap = _cap;	
560 		currentStage = _stage;
561 	}
562 	
563 	function updateVaults(address _reserve, address _restricted) external onlyOwner saleNotDone {
564 		require(_reserve != address(0));
565 		require(_restricted != address(0));
566 		
567 		reserveVault = _reserve;
568 		restrictedVault = _restricted;
569 		
570 	    require(Ownable(_reserve).owner() == address(this));
571 	    require(Ownable(_restricted).owner() == address(this));
572 	}
573 	
574 	function updateReserveVault(address _reserve) external onlyOwner saleNotDone {
575 		require(_reserve != address(0));
576 
577 		reserveVault = _reserve;
578 
579 	    require(Ownable(_reserve).owner() == address(this));
580 	}
581 	
582 	function updateRestrictedVault(address _restricted) external onlyOwner saleNotDone {
583 		require(_restricted != address(0));
584 		
585 		restrictedVault = _restricted;
586 		
587 	    require(Ownable(_restricted).owner() == address(this));
588 	}
589 	
590 	//function updateFundWallet(address _wallet) external onlyOwner saleNotDone {
591 	//	require(_wallet != address(0));
592 	//	require(fundWallet != _wallet);
593 	//  fundWallet = _wallet;
594 	//}
595 
596 	function bookkeep(address _beneficiary, uint256 _base, uint256 _bonus) internal returns(bool) {
597 		uint256 newBase = baseTokensAllocated.add(_base);
598 		uint256 newBonus = bonusTokensAllocated.add(_bonus);
599 
600 		if (newBase > currentSaleCap || newBonus > marketingCap) {
601 			return false;
602 		}
603 
604 		baseTokensAllocated = newBase;
605 		bonusTokensAllocated = newBonus;
606 
607 		Contribution storage c = contributionBalance[_beneficiary];
608 		c.base = c.base.add(_base);
609 		c.bonus = c.bonus.add(_bonus);
610 
611 		return true;
612 	}
613     
614 	function computeTokens(uint256 _weiAmount, uint _bonusRate) external view returns (uint256 base, uint256 bonus) {
615 		base = _weiAmount.mul(exchangeRate).div(1000);
616 		bonus = base.mul(_bonusRate).div(100);
617 	}
618     
619 	// can only 'buy' tokens while the sale is active. 
620 	function () public payable saleActive stopInEmergency {
621 	    revert();
622 	    
623 		//buyTokens(msg.sender);
624 	}
625 
626 	//function buyTokens(address _beneficiary) public payable saleActive stopInEmergency {
627 		//require(msg.value != 0);
628 		//require(_beneficiary != 0x0);
629 		//require(blacklist[_beneficiary] == false);
630 
631 		//uint256 weiAmount = msg.value;
632 		//uint256 baseTokens = weiAmount.mul(exchangeRate).div(1000);
633 		//uint256 bonusTokens = baseTokens.mul(bonusRate).div(100);
634 		
635 		//require (bookkeep(_beneficiary, baseTokens, bonusTokens));
636 
637         //uint256 total = baseTokens.add(bonusTokens);
638         
639 		//weiRaised = weiRaised.add(weiAmount);
640 
641         //TokenPurchase(msg.sender, _beneficiary, weiAmount, total);
642         
643 		//fundWallet.transfer(weiAmount);
644 		//token.mint(_beneficiary, total);
645 	//}
646 
647 	// function to purchase tokens for someone, from an external funding source.  This function 
648 	// assumes that the external source has been verified.  bonus amount is passed in, so we can 
649 	// handle an edge case where someone externally purchased tokens when the bonus should be different
650 	// than it currnetly is set to.
651 	function buyTokensFor(address _beneficiary, uint256 _baseTokens, uint _bonusTokens) external onlyOwner saleAllocatable {
652 		require(_beneficiary != 0x0);
653 		require(_baseTokens != 0 || _bonusTokens != 0);
654 		require(blacklist[_beneficiary] == false);
655 		
656         require(bookkeep(_beneficiary, _baseTokens, _bonusTokens));
657 
658         uint256 total = _baseTokens.add(_bonusTokens);
659 
660         TokenPurchase(msg.sender, _beneficiary, 0, total);
661         
662 		token.mint(_beneficiary, total);
663 	}
664     
665 	// same as above, but strictly for allocating tokens out of the bonus pool
666 	function giftTokens(address _beneficiary, uint256 _giftAmount) external onlyOwner saleAllocatable {
667 		require(_beneficiary != 0x0);
668 		require(_giftAmount != 0);
669 		require(blacklist[_beneficiary] == false);
670 
671         require(bookkeep(_beneficiary, 0, _giftAmount));
672         
673         TokenPurchase(msg.sender, _beneficiary, 0, _giftAmount);
674         
675 		token.mint(_beneficiary, _giftAmount);
676 	}
677 	function balanceOf(address _beneficiary) public view returns(uint256, uint256) {
678 		require(_beneficiary != address(0));
679 
680         Contribution storage c = contributionBalance[_beneficiary];
681 		return (c.base, c.bonus);
682 	}
683 
684 	
685 	// ban/prevent a user from participating in the ICO for violations of TOS, and deallocate any tokens they have allocated
686 	// if any refunds are necessary, they are handled offline
687 	function ban(address _owner) external onlyOwner saleAllocatable returns (uint256 total) {
688 	    require(_owner != address(0));
689 	    require(!blacklist[_owner]);
690 	    
691 	    uint256 base;
692 	    uint256 bonus;
693 	    
694 	    (base, bonus) = balanceOf(_owner);
695 	    
696 	    delete contributionBalance[_owner];
697 	    
698 		baseTokensAllocated = baseTokensAllocated.sub(base);
699 		bonusTokensAllocated = bonusTokensAllocated.sub(bonus);
700 		
701 	    blacklist[_owner] = true;
702 
703 	    total = token.revoke(_owner);
704 	}
705 
706     // unbans a user that was banned with the above function.  does NOT reallocate their tokens
707 	function unban(address _beneficiary) external onlyOwner saleAllocatable {
708 	    require(_beneficiary != address(0));
709 	    require(blacklist[_beneficiary] == true);
710 
711         delete blacklist[_beneficiary];
712 	}
713 	
714 	// release any other tokens needed and mark us as allocated
715 	function releaseTokens() external onlyOwner saleAllocating {
716 		require(reserveVault != address(0));
717 		require(restrictedVault != address(0));
718 		require(saleAllocated == false);
719 
720 		saleAllocated = true;
721 		
722         // allocate the team and reserve tokens to our vaults		
723 	    token.mint(reserveVault, reserveCap); 
724 		token.mint(restrictedVault, teamCap); 
725 	}
726 
727 	
728 	// end the ICO, tokens won't show up in anyone's wallets until this function is called.
729 	// once this is called, nothing works on the ICO any longer
730 	function endICO() external onlyOwner saleAllocating {
731 	    require(saleAllocated);
732 	    
733 	    currentStage = Stage.Done;
734 	    
735         // this will release all allocated tokens to their owners
736 	    token.finishMinting();  
737 	    
738 	    // now transfer all these objects back to our owner, which we know to be a trusted account
739 	    token.transferOwnership(owner);
740 	    Ownable(reserveVault).transferOwnership(owner);
741 	    Ownable(restrictedVault).transferOwnership(owner);
742 	}
743 	
744 	function giveBack() public onlyOwner {
745 	    if (address(token) != address(0))
746 	        token.transferOwnership(owner);
747         if (reserveVault != address(0))
748 	        Ownable(reserveVault).transferOwnership(owner);
749         if (restrictedVault != address(0))
750 	        Ownable(restrictedVault).transferOwnership(owner);
751 	}
752 }