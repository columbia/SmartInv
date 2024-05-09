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
41     OwnershipTransferred(owner, newOwner);
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
119     Transfer(msg.sender, _to, _value);
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
175     Transfer(_from, _to, _value);
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
191     Approval(msg.sender, _spender, _value);
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
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
274     Mint(_to, _amount);
275     Transfer(address(0), _to, _amount);
276     return true;
277   }
278 
279   /**
280    * @dev Function to stop minting new tokens.
281    * @return True if the operation was successful.
282    */
283   function finishMinting() onlyOwner canMint public returns (bool) {
284     mintingFinished = true;
285     MintFinished();
286     return true;
287   }
288 }
289 
290 // File: contracts/PagosToken.sol
291 
292 contract PagosToken is MintableToken {
293     string public constant name = "Pagos Token";
294     string public constant symbol = "PGO";
295     uint8 public decimals = 18;
296     bool public tradingStarted = false;
297 
298     /**
299      * @dev modifier that throws if trading has not started yet
300      */
301     modifier hasStartedTrading() {
302         require(tradingStarted);
303         _;
304     }
305 
306     /**
307      * @dev Allows the owner to enable the trading.
308      */
309     function startTrading() onlyOwner public {
310         tradingStarted = true;
311     }
312 
313     /**
314      * @dev Allows anyone to transfer the PagosToken tokens once trading has started
315      * @param _to the recipient address of the tokens.
316      * @param _value number of tokens to be transfered.
317      */
318     function transfer(address _to, uint _value) hasStartedTrading public returns (bool){
319         return super.transfer(_to, _value);
320     }
321 
322 
323     /**
324      * @dev Allows anyone to transfer the  tokens once trading has started
325      * @param _from address The address which you want to send tokens from
326      * @param _to address The address which you want to transfer to
327      * @param _value uint the amout of tokens to be transfered
328      */
329     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public returns (bool){
330         return super.transferFrom(_from, _to, _value);
331     }
332 
333     /**
334    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
335    * @param _spender The address which will spend the funds.
336    * @param _value The amount of tokens to be spent.
337    */
338     function approve(address _spender, uint256 _value) public hasStartedTrading returns (bool) {
339         return super.approve(_spender, _value);
340     }
341 
342     /**
343      * Adding whenNotPaused
344      */
345     function increaseApproval(address _spender, uint _addedValue) public hasStartedTrading returns (bool success) {
346         return super.increaseApproval(_spender, _addedValue);
347     }
348 
349     /**
350      * Adding whenNotPaused
351      */
352     function decreaseApproval(address _spender, uint _subtractedValue) public hasStartedTrading returns (bool success) {
353         return super.decreaseApproval(_spender, _subtractedValue);
354     }
355 }
356 
357 // File: contracts/crowdsale/Crowdsale.sol
358 
359 /**
360  * @title Crowdsale
361  * @dev Crowdsale is a base contract for managing a token crowdsale.
362  * Crowdsales have a start and end timestamps, where investors can make
363  * token purchases and the crowdsale will assign them tokens based
364  * on a token per ETH rate. Funds collected are forwarded to a wallet
365  * as they arrive.
366  */
367 contract Crowdsale {
368   using SafeMath for uint256;
369 
370   // The token being sold
371   MintableToken public token;
372 
373   // start and end timestamps where investments are allowed (both inclusive)
374   uint256 public startTime;
375   uint256 public endTime;
376 
377   // address where funds are collected
378   address public wallet;
379 
380   // how many token units a buyer gets per wei
381   uint256 public rate;
382 
383   // amount of raised money in wei
384   uint256 public weiRaised;
385 
386   /**
387    * event for token purchase logging
388    * @param purchaser who paid for the tokens
389    * @param beneficiary who got the tokens
390    * @param value weis paid for purchase
391    * @param amount amount of tokens purchased
392    */
393   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
394 
395 
396   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
397     require(_startTime >= now);
398     require(_endTime >= _startTime);
399     require(_rate > 0);
400     require(_wallet != address(0));
401 
402     token = createTokenContract();
403     startTime = _startTime;
404     endTime = _endTime;
405     rate = _rate;
406     wallet = _wallet;
407   }
408 
409   // creates the token to be sold.
410   // override this method to have crowdsale of a specific mintable token.
411   function createTokenContract() internal returns (MintableToken) {
412     return new MintableToken();
413   }
414 
415 
416   // fallback function can be used to buy tokens
417   function () external payable {
418     buyTokens(msg.sender);
419   }
420 
421   // low level token purchase function
422   // overrided to create custom buy
423   function buyTokens(address beneficiary) public payable {
424     require(beneficiary != address(0));
425     require(validPurchase());
426 
427     uint256 weiAmount = msg.value;
428 
429     // calculate token amount to be created
430     uint256 tokens = weiAmount.mul(rate);
431 
432     // update state
433     weiRaised = weiRaised.add(weiAmount);
434 
435     token.mint(beneficiary, tokens);
436     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
437 
438     forwardFunds();
439   }
440 
441   // send ether to the fund collection wallet
442   // overrided to create custom fund forwarding mechanisms
443   function forwardFunds() internal {
444     wallet.transfer(msg.value);
445   }
446 
447   // @return true if the transaction can buy tokens
448   function validPurchase() internal view returns (bool) {
449     bool withinPeriod = now >= startTime && now <= endTime;
450     bool nonZeroPurchase = msg.value != 0;
451     return withinPeriod && nonZeroPurchase;
452   }
453 
454   // @return true if crowdsale event has ended
455   function hasEnded() public view returns (bool) {
456     return now > endTime;
457   }
458 
459 
460 }
461 
462 // File: contracts/crowdsale/FinalizableCrowdsale.sol
463 
464 /**
465  * @title FinalizableCrowdsale
466  * @dev Extension of Crowdsale where an owner can do extra work
467  * after finishing.
468  */
469 contract FinalizableCrowdsale is Crowdsale, Ownable {
470   using SafeMath for uint256;
471 
472   bool public isFinalized = false;
473 
474   event Finalized();
475 
476   /**
477    * @dev Must be called after crowdsale ends, to do some extra finalization
478    * work. Calls the contract's finalization function.
479    */
480   function finalize() onlyOwner public {
481     require(!isFinalized);
482     require(hasEnded());
483 
484     finalization();
485     Finalized();
486 
487     isFinalized = true;
488   }
489 
490   /**
491    * @dev Can be overridden to add finalization logic. The overriding function
492    * should call super.finalization() to ensure the chain of finalization is
493    * executed entirely.
494    */
495   function finalization() internal{
496   }
497 }
498 
499 // File: contracts/PagosCrowdSale.sol
500 
501 contract PagosCrowdSale is FinalizableCrowdsale {
502     using SafeMath for uint256;
503 
504     // number of participants in the Pagos Pre-Sale
505     uint256 public numberOfPurchasers = 0;
506 
507     // maximum tokens that can be minted in this crowd sale
508     uint256 public maxTokenSupply = 0;
509 
510     // version cache buster
511     string public constant version = "v1.4";
512 
513     // pending contract owner
514     address public pendingOwner;
515 
516     // number of participants in the Pagos Pre-Sale
517     uint256 public minimumAmount = 0;
518 
519     // Reserved amount
520     address public reservedAddr;
521     uint256 public reservedAmount;
522 
523     // different token supply and rate once in publicSale mode
524     uint256 public ratePublicSale;
525     uint256 public maxTokenSupplyPublicSale;
526 
527 
528     function PagosCrowdSale(uint256 _startTime,
529     uint256 _endTime,
530     uint256 _rate,
531     uint256 _minimumAmount,
532     uint256 _maxTokenSupply,
533     address _wallet,
534     address _reservedAddr,
535     uint256 _reservedAmount,
536     address _pendingOwner,
537     uint256 _ratePublicSale,
538     uint256 _maxTokenSupplyPublicSale
539     )
540     FinalizableCrowdsale()
541     Crowdsale(_startTime, _endTime, _rate, _wallet) public
542     {
543         require(_pendingOwner != address(0));
544         require(_minimumAmount >= 0);
545         require(_maxTokenSupply > 0);
546         require(_reservedAmount > 0 && _reservedAmount < _maxTokenSupply);
547 
548         pendingOwner = _pendingOwner;
549         minimumAmount = _minimumAmount;
550         maxTokenSupply = _maxTokenSupply;
551 
552         // reserved amount
553         reservedAddr = _reservedAddr;
554         reservedAmount = _reservedAmount;
555 
556         // different rate for the public sale
557         ratePublicSale=_ratePublicSale;
558         maxTokenSupplyPublicSale=_maxTokenSupplyPublicSale;
559 
560     }
561 
562     /**
563     *
564     * Create the token on the fly, owner is the contract, not the contract owner yet
565     *
566     **/
567     function createTokenContract() internal returns (MintableToken) {
568         return new PagosToken();
569     }
570 
571     // low level token purchase function
572     function buyTokens(address beneficiary) public payable {
573         require(beneficiary != address(0));
574         //
575         require(validPurchase());
576         // buying can only begins as soon as the owner ship has been transfered
577         require(owner==pendingOwner);
578 
579         uint256 weiAmount = msg.value;
580 
581         // make sure we accept only the minimum contribution
582         // require(weiAmount>minimumAmount);
583 
584         // Compute the number of tokens per wei
585         // bonus structure should be used here, if any
586         uint256 tokens = weiAmount.mul(rate);
587 
588         token.mint(beneficiary, tokens);
589         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
590 
591         // update
592         weiRaised = weiRaised.add(weiAmount);
593         numberOfPurchasers = numberOfPurchasers + 1;
594 
595         forwardFunds();
596     }
597 
598     // overriding Crowdsale#validPurchase to add extra cap logic
599     // @return true if investors can buy at the moment
600     function validPurchase() internal view returns (bool) {
601 
602         // make sure we accept only the minimum contribution
603         bool minAmount = (msg.value >= minimumAmount);
604 
605         // cap crowdsaled to a maxTokenSupply
606         // make sure we can not mint more token than expected
607         bool lessThanMaxSupply = (token.totalSupply() + msg.value.mul(rate)) <= maxTokenSupply;
608 
609         //bool withinCap = weiRaised.add(msg.value) <= cap;
610         return super.validPurchase() && minAmount && lessThanMaxSupply;
611     }
612 
613     // overriding Crowdsale#hasEnded to add cap logic
614     // @return true if crowdsale event has ended
615     function hasEnded() public view returns (bool) {
616         bool capReached = token.totalSupply() >= maxTokenSupply;
617         return super.hasEnded() || capReached;
618     }
619 
620     /**
621      *
622      * Admin functions only called by owner:
623      * Can change rate
624      *
625      */
626 
627     /**
628       *
629       * Called when the admin function finalize is called :
630       *
631       * it mint the remaining amount to have the supply exactly as planned
632       * it transfer the ownership of the token to the owner of the smart contract
633       *
634       */
635     function finalization() internal {
636         //
637         // send back to the owner the remaining tokens before finishing minting
638         // it ensure that there is only a exact maxTokenSupply token minted ever
639         //
640         uint256 remainingTokens = maxTokenSupply - token.totalSupply();
641 
642         // mint the remaining amount and assign them to the owner
643         token.mint(owner, remainingTokens);
644         TokenPurchase(owner, owner, 0, remainingTokens);
645 
646         // finalize the refundable inherited contract
647         super.finalization();
648 
649         // no more minting allowed - immutable
650         token.finishMinting();
651 
652         // transfer the token owner ship from the contract address to the real owner
653         token.transferOwnership(owner);
654     }
655 
656     /**
657       *
658       * Admin functions only called by owner:
659       * Can change rate
660       *
661       */
662     function changeMinimumAmount(uint256 _minimumAmount) onlyOwner public {
663         require(_minimumAmount > 0);
664         minimumAmount = _minimumAmount;
665     }
666 
667     /**
668       *
669       * Admin functions only called by owner:
670       * Can change events dates
671       *
672       */
673     function changeDates(uint256 _startTime, uint256 _endTime) onlyOwner public {
674         require(_startTime >= now);
675         require(_endTime >= _startTime);
676         startTime = _startTime;
677         endTime = _endTime;
678     }
679 
680     /**
681       *
682       * Admin functions only called by owner:
683       * Switch to publicSale mode, maxToken supply is changed as well as the normal rate
684       *
685       */
686     function publicSaleMode() onlyOwner public returns (uint256){
687         rate=ratePublicSale;
688         maxTokenSupply=maxTokenSupplyPublicSale;
689         return ratePublicSale;
690     }
691 
692 
693     /**
694       *
695       * Admin functions only called by owner:
696       * Change the owner
697       *
698       */
699     function transferOwnerShipToPendingOwner() public {
700 
701         // only the pending owner can change the ownership
702         require(msg.sender == pendingOwner);
703 
704         // can only be changed one time
705         require(owner != pendingOwner);
706 
707         // raise the event
708         OwnershipTransferred(owner, pendingOwner);
709 
710         // change the ownership
711         owner = pendingOwner;
712 
713         // run the PreMint
714         runPreMint();
715 
716     }
717 
718     // run the pre minting
719     // for now yes, after it will be done during the ownership transfer call
720 
721     function runPreMint() onlyOwner private {
722 
723         token.mint(reservedAddr, reservedAmount);
724         TokenPurchase(owner, reservedAddr, 0, reservedAmount);
725 
726         // update state
727         numberOfPurchasers = numberOfPurchasers + 1;
728     }
729 
730 }