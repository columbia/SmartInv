1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     emit Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     emit Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     emit Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: contracts/token/MintableToken.sol
245 
246 /**
247  * @title Mintable token
248  * @dev Simple ERC20 Token example, with mintable token creation
249  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
250  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
251  */
252 
253 contract MintableToken is StandardToken, Ownable {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258 
259 
260   modifier canMint() {
261     require(!mintingFinished);
262     _;
263   }
264 
265   /**
266    * @dev Function to mint tokens
267    * @param _to The address that will receive the minted tokens.
268    * @param _amount The amount of tokens to mint.
269    * @return A boolean that indicates if the operation was successful.
270    */
271   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
272     totalSupply = totalSupply.add(_amount);
273     balances[_to] = balances[_to].add(_amount);
274     emit Mint(_to, _amount);
275     emit Transfer(address(0), _to, _amount);
276     return true;
277   }
278 
279   /**
280    * @dev Function to stop minting new tokens.
281    * @return True if the operation was successful.
282    */
283   function finishMinting() onlyOwner canMint public returns (bool) {
284     mintingFinished = true;
285     emit MintFinished();
286     return true;
287   }
288 }
289 
290 // File: contracts/FFUELCoinToken.sol
291 
292 contract FFUELCoinToken is MintableToken {
293     string public constant name = "FIFO FUEL";
294     string public constant symbol = "FFUEL";
295     uint8 public decimals = 18;
296     bool public tradingStarted = false;
297 
298     // version cache buster
299     string public constant version = "v2";
300 
301     // allow exceptional transfer for sender address - this mapping  can be modified only before the starting rounds
302     mapping (address => bool) public transferable;
303 
304     /**
305      * @dev modifier that throws if spender address is not allowed to transfer
306      * and the trading is not enabled
307      */
308     modifier allowTransfer(address _spender) {
309 
310         require(tradingStarted || transferable[_spender]);
311         _;
312     }
313     /**
314     *
315     * Only the owner of the token smart contract can add allow token to be transfer before the trading has started
316     *
317     */
318 
319     function modifyTransferableHash(address _spender, bool value) onlyOwner public {
320         transferable[_spender] = value;
321     }
322 
323     /**
324      * @dev Allows the owner to enable the trading.
325      */
326     function startTrading() onlyOwner public {
327         tradingStarted = true;
328     }
329 
330     /**
331      * @dev Allows anyone to transfer the tokens once trading has started
332      * @param _to the recipient address of the tokens.
333      * @param _value number of tokens to be transfered.
334      */
335     function transfer(address _to, uint _value) allowTransfer(msg.sender) public returns (bool){
336         return super.transfer(_to, _value);
337     }
338 
339     /**
340      * @dev Allows anyone to transfer the  tokens once trading has started or if the spender is part of the mapping
341 
342      * @param _from address The address which you want to send tokens from
343      * @param _to address The address which you want to transfer to
344      * @param _value uint the amout of tokens to be transfered
345      */
346     function transferFrom(address _from, address _to, uint _value) allowTransfer(_from) public returns (bool){
347         return super.transferFrom(_from, _to, _value);
348     }
349 
350     /**
351    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
352    * @param _spender The address which will spend the funds.
353    * @param _value The amount of tokens to be spent.
354    */
355     function approve(address _spender, uint256 _value) public allowTransfer(_spender) returns (bool) {
356         return super.approve(_spender, _value);
357     }
358 
359     /**
360      * Adding whenNotPaused
361      */
362     function increaseApproval(address _spender, uint _addedValue) public allowTransfer(_spender) returns (bool success) {
363         return super.increaseApproval(_spender, _addedValue);
364     }
365 
366     /**
367      * Adding whenNotPaused
368      */
369     function decreaseApproval(address _spender, uint _subtractedValue) public allowTransfer(_spender) returns (bool success) {
370         return super.decreaseApproval(_spender, _subtractedValue);
371     }
372 }
373 
374 // File: contracts/crowdsale/Crowdsale.sol
375 
376 /**
377  * @title Crowdsale
378  * @dev Crowdsale is a base contract for managing a token crowdsale.
379  * Crowdsales have a start and end timestamps, where investors can make
380  * token purchases and the crowdsale will assign them tokens based
381  * on a token per ETH rate. Funds collected are forwarded to a wallet
382  * as they arrive.
383  */
384 contract Crowdsale {
385   using SafeMath for uint256;
386 
387   // The token being sold
388   MintableToken public token;
389 
390   // start and end timestamps where investments are allowed (both inclusive)
391   uint256 public startTime;
392   uint256 public endTime;
393 
394   // address where funds are collected
395   address public wallet;
396 
397   // how many token units a buyer gets per wei
398   uint256 public rate;
399 
400   // amount of raised money in wei
401   uint256 public weiRaised;
402 
403   /**
404    * event for token purchase logging
405    * @param purchaser who paid for the tokens
406    * @param beneficiary who got the tokens
407    * @param value weis paid for purchase
408    * @param amount amount of tokens purchased
409    */
410   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
411 
412 
413   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
414     require(_startTime >= now);
415     require(_endTime >= _startTime);
416     require(_rate > 0);
417     require(_wallet != address(0));
418 
419     token = createTokenContract();
420     startTime = _startTime;
421     endTime = _endTime;
422     rate = _rate;
423     wallet = _wallet;
424   }
425 
426   // creates the token to be sold.
427   // override this method to have crowdsale of a specific mintable token.
428   function createTokenContract() internal returns (MintableToken) {
429     return new MintableToken();
430   }
431 
432 
433   // fallback function can be used to buy tokens
434   function () external payable {
435     buyTokens(msg.sender);
436   }
437 
438   // low level token purchase function
439   // override to create custom buy
440   function buyTokens(address beneficiary) public payable {
441     require(beneficiary != address(0));
442     require(validPurchase());
443 
444     uint256 weiAmount = msg.value;
445 
446     // calculate token amount to be created
447     uint256 tokens = weiAmount.mul(rate);
448 
449     // update state
450     weiRaised = weiRaised.add(weiAmount);
451 
452     token.mint(beneficiary, tokens);
453     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
454 
455     forwardFunds();
456   }
457 
458   // send ether to the fund collection wallet
459   // overrided to create custom fund forwarding mechanisms
460   function forwardFunds() internal {
461     wallet.transfer(msg.value);
462   }
463 
464   // @return true if the transaction can buy tokens
465   function validPurchase() internal view returns (bool) {
466     bool withinPeriod = now >= startTime && now <= endTime;
467     bool nonZeroPurchase = msg.value != 0;
468     return withinPeriod && nonZeroPurchase;
469   }
470 
471   // @return true if crowdsale event has ended
472   function hasEnded() public view returns (bool) {
473     return now > endTime;
474   }
475 
476 
477 }
478 
479 // File: contracts/crowdsale/FinalizableCrowdsale.sol
480 
481 /**
482  * @title FinalizableCrowdsale
483  * @dev Extension of Crowdsale where an owner can do extra work
484  * after finishing.
485  */
486 contract FinalizableCrowdsale is Crowdsale, Ownable {
487   using SafeMath for uint256;
488 
489   bool public isFinalized = false;
490 
491   event Finalized();
492 
493   /**
494    * @dev Must be called after crowdsale ends, to do some extra finalization
495    * work. Calls the contract's finalization function.
496    */
497   function finalize() onlyOwner public {
498     require(!isFinalized);
499     require(hasEnded());
500 
501     finalization();
502     emit Finalized();
503 
504     isFinalized = true;
505   }
506 
507   /**
508    * @dev Can be overridden to add finalization logic. The overriding function
509    * should call super.finalization() to ensure the chain of finalization is
510    * executed entirely.
511    */
512   function finalization() internal{
513   }
514 }
515 
516 // File: contracts/FFUELCoinTokenCrowdSale.sol
517 
518 contract FFUELCoinTokenCrowdSale is FinalizableCrowdsale {
519     using SafeMath for uint256;
520 
521 
522     uint256 public numberOfPurchasers = 0;
523 
524     // maximum tokens that can be minted in this crowd sale
525     uint256 public maxTokenSupply = 0;
526 
527     // amounts of tokens already minted at the begining of this crowd sale - initialised later by the constructor
528     uint256 public initialTokenAmount = 0;
529 
530     // version cache buster
531     string public constant version = "v2";
532 
533     // pending contract owner
534     address public pendingOwner;
535 
536     // minimum amount to participate
537     uint256 public minimumAmount = 0;
538 
539     //
540     FFUELCoinToken public token;
541 
542     // white listing admin - initialised later by the constructor
543     address public whiteListingAdmin;
544     address public rateAdmin;
545 
546 
547     bool public preSaleMode = true;
548     uint256 public tokenRateGwei;
549     address vested;
550     uint256 vestedAmount;
551 
552     function FFUELCoinTokenCrowdSale(
553         uint256 _startTime,
554         uint256 _endTime,
555         uint256 _rate,
556         uint256 _minimumAmount,
557         uint256 _maxTokenSupply,
558         address _wallet,
559         address _pendingOwner,
560         address _whiteListingAdmin,
561         address _rateAdmin,
562         address _vested,
563         uint256 _vestedAmount,
564         FFUELCoinToken _token
565     )
566     FinalizableCrowdsale()
567     Crowdsale(_startTime, _endTime, _rate, _wallet) public
568     {
569         require(_pendingOwner != address(0));
570         require(_minimumAmount >= 0);
571         require(_maxTokenSupply > 0);
572 
573         pendingOwner = _pendingOwner;
574         minimumAmount = _minimumAmount;
575         maxTokenSupply = _maxTokenSupply;
576 
577         // whitelisting admin
578         setAdmin(_whiteListingAdmin, true);
579         setAdmin(_rateAdmin, false);
580 
581         vested = _vested;
582         vestedAmount = _vestedAmount;
583 
584         token=_token;
585     }
586 
587 
588     /**
589    * @dev Calculates the amount of  coins the buyer gets
590    * @param weiAmount uint the amount of wei send to the contract
591    * @return uint the amount of tokens the buyer gets
592    */
593     function computeTokenWithBonus(uint256 weiAmount) public view returns (uint256) {
594         uint256 tokens_ = 0;
595 
596         if (weiAmount >= 100000 ether) {
597 
598             tokens_ = weiAmount.mul(50).div(100);
599 
600         } else if (weiAmount < 100000 ether && weiAmount >= 50000 ether) {
601 
602             tokens_ = weiAmount.mul(35).div(100);
603 
604         } else if (weiAmount < 50000 ether && weiAmount >= 10000 ether) {
605 
606             tokens_ = weiAmount.mul(25).div(100);
607 
608         } else if (weiAmount < 10000 ether && weiAmount >= 2500 ether) {
609 
610             tokens_ = weiAmount.mul(15).div(100);
611         }
612 
613 
614         return tokens_;
615     }
616 
617     /**
618     *
619     * Create the token on the fly, owner is the contract, not the contract owner yet
620     *
621     **/
622     function createTokenContract() internal returns (MintableToken) {
623         return token;
624     }
625 
626     // low level token purchase function
627     function buyTokens(address beneficiary) public payable {
628         require(beneficiary != address(0), "not for 0x0");
629         //
630         require(validPurchase(), "Crowd sale not started or ended, or min amount too low");
631         // buying can only begins as soon as the ownership has been transferred
632         require(owner == pendingOwner, "ownership transfer not done");
633 
634         require(tokenRateGwei != 0, "rate invalid");
635 
636         // validate KYC here
637         // if not part of kyc then throw
638         bool cleared;
639         uint16 contributor_get;
640         address ref;
641         uint16 affiliate_get;
642 
643         (cleared, contributor_get, ref, affiliate_get) = getContributor(beneficiary);
644 
645         // Transaction do not happen if the contributor is not KYC cleared
646         require(cleared, "not whitelisted");
647 
648         uint256 weiAmount = msg.value;
649 
650         // make sure we accept only the minimum contribution
651         require(weiAmount > 0);
652 
653         // Compute the number of tokens per Gwei
654         uint256 tokens = weiAmount.div(1000000000).mul(tokenRateGwei);
655 
656         // compute the amount of bonus, from the contribution amount
657         uint256 bonus = computeTokenWithBonus(tokens);
658 
659         // compute the amount of token bonus for the contributor thank to his referral
660         uint256 contributorGet = tokens.mul(contributor_get).div(10000);
661 
662         // Sum it all
663         tokens = tokens.add(bonus);
664         tokens = tokens.add(contributorGet);
665 
666         token.mint(beneficiary, tokens);
667         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
668 
669         // update
670         weiRaised = weiRaised.add(weiAmount);
671         numberOfPurchasers = numberOfPurchasers + 1;
672 
673         forwardFunds();
674 
675         // ------------------------------------------------------------------
676         // compute the amount of token bonus that the referral get :
677         // only if KYC cleared, only if enough tokens still available
678         // ------------------------------------------------------------------
679         bool refCleared;
680         (refCleared) = getClearance(ref);
681         if (refCleared && ref != beneficiary)
682         {
683             // recompute the tokens amount using only the rate
684             tokens = weiAmount.div(1000000000).mul(tokenRateGwei);
685 
686             // compute the amount of token for the affiliate
687             uint256 affiliateGet = tokens.mul(affiliate_get).div(10000);
688 
689             // capped to a maxTokenSupply
690             // make sure we can not mint more token than expected
691             // we do not throw here as if this edge case happens it can be dealt with of chain
692             if (token.totalSupply() + affiliateGet <= maxTokenSupply)
693             {
694                 // Mint the token
695                 token.mint(ref, affiliateGet);
696                 emit TokenPurchase(ref, ref, 0, affiliateGet);
697             }
698         }
699     }
700 
701     // overriding Crowdsale#validPurchase to add extra cap logic
702     // @return true if investors can buy at the moment
703     function validPurchase() internal view returns (bool) {
704 
705         // make sure we accept only the minimum contribution
706         bool minAmount = (msg.value >= minimumAmount);
707 
708         // cap crowdsaled to a maxTokenSupply
709         // make sure we can not mint more token than expected
710         bool lessThanMaxSupply = (token.totalSupply() + msg.value.div(1000000000).mul(tokenRateGwei)) <= maxTokenSupply;
711 
712         //bool withinCap = weiRaised.add(msg.value) <= cap;
713         return super.validPurchase() && minAmount && lessThanMaxSupply;
714     }
715 
716     // overriding Crowdsale#hasEnded to add cap logic
717     // @return true if crowdsale event has ended
718     function hasEnded() public view returns (bool) {
719         bool capReached = token.totalSupply() >= maxTokenSupply;
720         return super.hasEnded() || capReached;
721     }
722 
723 
724     /**
725       *
726       * Called when the admin function finalize is called :
727       *
728       * it mint the remaining amount to have the supply exactly as planned
729       * it transfer the ownership of the token to the owner of the smart contract
730       *
731       */
732     function finalization() internal {
733         //
734         // send back to the owner the remaining tokens before finishing minting
735         // it ensure that there is only a exact maxTokenSupply token minted ever
736         //
737         uint256 remainingTokens = maxTokenSupply - token.totalSupply();
738 
739         // mint the remaining amount and assign them to the owner
740         token.mint(owner, remainingTokens);
741         emit TokenPurchase(owner, owner, 0, remainingTokens);
742 
743         // finalize the refundable inherited contract
744         super.finalization();
745 
746         // no more minting allowed - immutable
747         token.finishMinting();
748 
749         // transfer the token owner ship from the contract address to the real owner
750         token.transferOwnership(owner);
751     }
752 
753 
754     /**
755       *
756       * Admin functions only called by owner:
757       * Can change events dates
758       *
759       */
760     function changeDates(uint256 _startTime, uint256 _endTime) public onlyOwner {
761         require(_endTime >= _startTime, "End time need to be in the > _startTime");
762         startTime = _startTime;
763         endTime = _endTime;
764     }
765 
766     /**
767       *
768       * Admin functions only called by owner:
769       * Change the owner
770       *
771       */
772     function transferOwnerShipToPendingOwner() public {
773 
774         // only the pending owner can change the ownership
775         require(msg.sender == pendingOwner, "only the pending owner can change the ownership");
776 
777         // can only be changed one time
778         require(owner != pendingOwner, "Only one time allowed");
779 
780         // raise the event
781         emit OwnershipTransferred(owner, pendingOwner);
782 
783         // change the ownership
784         owner = pendingOwner;
785 
786         // pre mint the coins
787         preMint(vested, vestedAmount);
788     }
789 
790     /**
791     *
792     * Return the amount of token minted during that crowd sale, removing the token pre minted
793     *
794     */
795     function minted() public view returns (uint256)
796     {
797         return token.totalSupply().sub(initialTokenAmount);
798     }
799 
800     // hard code the pre minting
801     function preMint(address vestedAddress, uint256 _amount) public onlyOwner {
802         runPreMint(vestedAddress, _amount);
803         //
804         runPreMint(0x6B36b48Cb69472193444658b0b181C8049d371e1, 50000000000000000000000000);
805         // reserved
806         runPreMint(0xa484Ebcb519a6E50e4540d48F40f5ee466dEB7A7, 5000000000000000000000000);
807         // bounty
808         runPreMint(0x999f7f15Cf00E4495872D55221256Da7BCec2214, 5000000000000000000000000);
809         // team
810         runPreMint(0xB2233A3c93937E02a579422b6Ffc12DA5fc917E7, 5000000000000000000000000);
811         // advisors
812 
813         // only one time
814         preSaleMode = false;
815     }
816 
817     // run the pre minting
818     // can be done only one time
819     function runPreMint(address _target, uint256 _amount) public onlyOwner {
820         if (preSaleMode)
821         {
822             token.mint(_target, _amount);
823             emit TokenPurchase(owner, _target, 0, _amount);
824 
825             initialTokenAmount = token.totalSupply();
826         }
827     }
828 
829     /**
830       *
831       * Allow exceptional transfer
832       *
833       */
834 
835     function modifyTransferableHash(address _spender, bool value) public onlyOwner
836     {
837         token.modifyTransferableHash(_spender, value);
838     }
839 
840     // add a way to change the whitelistadmin user
841     function setAdmin(address _adminAddress, bool whiteListAdmin) public onlyOwner
842     {
843         if (whiteListAdmin)
844         {
845             whiteListingAdmin = _adminAddress;
846         } else {
847             rateAdmin = _adminAddress;
848         }
849     }
850     /**
851      *
852      * Admin functions only executed by rateAdmin
853      * Can change the rate for the token sold
854      * to increase the trust we could imagine to setup a range to avoid modification that are too far outside of the
855      * acceptable range :
856      *
857      */
858     function setTokenRateInGwei(uint256 _tokenRateGwei) public {
859         require(msg.sender == rateAdmin, "invalid admin");
860         tokenRateGwei = _tokenRateGwei;
861         // update the integer rate accordingly, even if not used to not confuse users
862         rate = _tokenRateGwei.div(1000000000);
863     }
864 
865     //
866     // Whitelist with affiliated structure
867     //
868     struct Contributor {
869 
870         bool cleared;
871 
872         // % more for the contributor bring on board
873         uint16 contributor_get;
874 
875         // eth address of the referer if any - the contributor address is the key of the hash
876         address ref;
877 
878         // % more for the referrer
879         uint16 affiliate_get;
880     }
881 
882 
883     mapping(address => Contributor) public whitelist;
884     address[] public whitelistArray;
885 
886     /**
887     *    @dev Populate the whitelist, only executed by whiteListingAdmin
888     *
889     */
890 
891     function setContributor(address _address, bool cleared, uint16 contributor_get, uint16 affiliate_get, address ref) public {
892 
893         // not possible to give an exorbitant bonus to be more than 100% (100x100 = 10000)
894         require(contributor_get < 10000, "c too high");
895         require(affiliate_get < 10000, "a too high");
896         require(msg.sender == whiteListingAdmin, "invalid admin");
897 
898         Contributor storage contributor = whitelist[_address];
899 
900         contributor.cleared = cleared;
901         contributor.contributor_get = contributor_get;
902 
903         contributor.ref = ref;
904         contributor.affiliate_get = affiliate_get;
905     }
906 
907     function getContributor(address _address) public view returns (bool, uint16, address, uint16) {
908         return (whitelist[_address].cleared, whitelist[_address].contributor_get, whitelist[_address].ref, whitelist[_address].affiliate_get);
909     }
910 
911     function getClearance(address _address) public view returns (bool) {
912         return whitelist[_address].cleared;
913     }
914 
915 
916 }