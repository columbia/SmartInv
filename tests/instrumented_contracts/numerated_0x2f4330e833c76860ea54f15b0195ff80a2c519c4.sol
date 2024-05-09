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
290 // File: contracts/BigToken.sol
291 
292 contract BigToken is MintableToken {
293     string public constant name = "BigToken";
294 
295     string public constant symbol = "BTK";
296 
297     uint8 public decimals = 18;
298 
299     bool public tradingStarted = false;
300 
301     /**
302      * @dev modifier that throws if trading has not started yet
303      */
304     modifier hasStartedTrading() {
305         require(tradingStarted);
306         _;
307     }
308 
309     /**
310      * @dev Allows the owner to enable the trading.
311      */
312     function startTrading() onlyOwner public {
313         tradingStarted = true;
314     }
315 
316     /**
317      * @dev Allows anyone to transfer the tokens once trading has started
318      * @param _to the recipient address of the tokens.
319      * @param _value number of tokens to be transfered.
320      */
321     function transfer(address _to, uint _value) hasStartedTrading public returns (bool){
322         return super.transfer(_to, _value);
323     }
324 
325     /**
326      * @dev Allows anyone to transfer the  tokens once trading has started
327      * @param _from address The address which you want to send tokens from
328      * @param _to address The address which you want to transfer to
329      * @param _value uint the amout of tokens to be transfered
330      */
331     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public returns (bool){
332         return super.transferFrom(_from, _to, _value);
333     }
334 
335     /**
336    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
337    * @param _spender The address which will spend the funds.
338    * @param _value The amount of tokens to be spent.
339    */
340     function approve(address _spender, uint256 _value) public hasStartedTrading returns (bool) {
341         return super.approve(_spender, _value);
342     }
343 
344     /**
345      * Adding whenNotPaused
346      */
347     function increaseApproval(address _spender, uint _addedValue) public hasStartedTrading returns (bool success) {
348         return super.increaseApproval(_spender, _addedValue);
349     }
350 
351     /**
352      * Adding whenNotPaused
353      */
354     function decreaseApproval(address _spender, uint _subtractedValue) public hasStartedTrading returns (bool success) {
355         return super.decreaseApproval(_spender, _subtractedValue);
356     }
357 
358 }
359 
360 // File: contracts/crowdsale/Crowdsale.sol
361 
362 /**
363  * @title Crowdsale
364  * @dev Crowdsale is a base contract for managing a token crowdsale.
365  * Crowdsales have a start and end timestamps, where investors can make
366  * token purchases and the crowdsale will assign them tokens based
367  * on a token per ETH rate. Funds collected are forwarded to a wallet
368  * as they arrive.
369  */
370 contract Crowdsale {
371   using SafeMath for uint256;
372 
373   // The token being sold
374   MintableToken public token;
375 
376   // start and end timestamps where investments are allowed (both inclusive)
377   uint256 public startTime;
378   uint256 public endTime;
379 
380   // address where funds are collected
381   address public wallet;
382 
383   // how many token units a buyer gets per wei
384   uint256 public rate;
385 
386   // amount of raised money in wei
387   uint256 public weiRaised;
388 
389   /**
390    * event for token purchase logging
391    * @param purchaser who paid for the tokens
392    * @param beneficiary who got the tokens
393    * @param value weis paid for purchase
394    * @param amount amount of tokens purchased
395    */
396   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
397 
398 
399   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
400     require(_startTime >= now);
401     require(_endTime >= _startTime);
402     require(_rate > 0);
403     require(_wallet != address(0));
404 
405     token = createTokenContract();
406     startTime = _startTime;
407     endTime = _endTime;
408     rate = _rate;
409     wallet = _wallet;
410   }
411 
412   // creates the token to be sold.
413   // override this method to have crowdsale of a specific mintable token.
414   function createTokenContract() internal returns (MintableToken) {
415     return new MintableToken();
416   }
417 
418 
419   // fallback function can be used to buy tokens
420   function () external payable {
421     buyTokens(msg.sender);
422   }
423 
424   // low level token purchase function
425   // overrided to create custom buy
426   function buyTokens(address beneficiary) public payable {
427     require(beneficiary != address(0));
428     require(validPurchase());
429 
430     uint256 weiAmount = msg.value;
431 
432     // calculate token amount to be created
433     uint256 tokens = weiAmount.mul(rate);
434 
435     // update state
436     weiRaised = weiRaised.add(weiAmount);
437 
438     token.mint(beneficiary, tokens);
439     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
440 
441     forwardFunds();
442   }
443 
444   // send ether to the fund collection wallet
445   // overrided to create custom fund forwarding mechanisms
446   function forwardFunds() internal {
447     wallet.transfer(msg.value);
448   }
449 
450   // @return true if the transaction can buy tokens
451   function validPurchase() internal view returns (bool) {
452     bool withinPeriod = now >= startTime && now <= endTime;
453     bool nonZeroPurchase = msg.value != 0;
454     return withinPeriod && nonZeroPurchase;
455   }
456 
457   // @return true if crowdsale event has ended
458   function hasEnded() public view returns (bool) {
459     return now > endTime;
460   }
461 
462 
463 }
464 
465 // File: contracts/crowdsale/FinalizableCrowdsale.sol
466 
467 /**
468  * @title FinalizableCrowdsale
469  * @dev Extension of Crowdsale where an owner can do extra work
470  * after finishing.
471  */
472 contract FinalizableCrowdsale is Crowdsale, Ownable {
473   using SafeMath for uint256;
474 
475   bool public isFinalized = false;
476 
477   event Finalized();
478 
479   /**
480    * @dev Must be called after crowdsale ends, to do some extra finalization
481    * work. Calls the contract's finalization function.
482    */
483   function finalize() onlyOwner public {
484     require(!isFinalized);
485     require(hasEnded());
486 
487     finalization();
488     Finalized();
489 
490     isFinalized = true;
491   }
492 
493   /**
494    * @dev Can be overridden to add finalization logic. The overriding function
495    * should call super.finalization() to ensure the chain of finalization is
496    * executed entirely.
497    */
498   function finalization() internal{
499   }
500 }
501 
502 // File: contracts/modified.crowdsale/RefundVaultWithCommission.sol
503 
504 /**
505  * @title RefundVault
506  * @dev This contract is used for storing funds while a crowdsale
507  * is in progress. Supports refunding the money if crowdsale fails,
508  * and forwarding it if crowdsale is successful.
509  */
510 contract RefundVaultWithCommission is Ownable {
511   using SafeMath for uint256;
512 
513   enum State { Active, Refunding, Closed }
514 
515   mapping (address => uint256) public deposited;
516   address public wallet;
517   address public walletFees;
518   State public state;
519 
520   event Closed();
521   event RefundsEnabled();
522   event Refunded(address indexed beneficiary, uint256 weiAmount);
523 
524   function RefundVaultWithCommission(address _wallet,address _walletFees) public {
525     require(_wallet != address(0));
526     require(_walletFees != address(0));
527     wallet = _wallet;
528     walletFees = _walletFees;
529     state = State.Active;
530   }
531 
532   function deposit(address investor) onlyOwner public payable {
533     require(state == State.Active);
534     deposited[investor] = deposited[investor].add(msg.value);
535   }
536 
537   function close() onlyOwner public {
538     require(state == State.Active);
539     state = State.Closed;
540     Closed();
541 
542     uint256 fees = this.balance.mul(25).div(10000);
543 
544     // transfer the fees
545     walletFees.transfer(fees);
546 
547     //transfer the remaining part
548     wallet.transfer(this.balance);
549   }
550 
551   function enableRefunds() onlyOwner public {
552     require(state == State.Active);
553     state = State.Refunding;
554     RefundsEnabled();
555   }
556 
557   function refund(address investor) public {
558     require(state == State.Refunding);
559     uint256 depositedValue = deposited[investor];
560     deposited[investor] = 0;
561     investor.transfer(depositedValue);
562     Refunded(investor, depositedValue);
563   }
564 }
565 
566 // File: contracts/modified.crowdsale/RefundableCrowdsaleWithCommission.sol
567 
568 /**
569  * @title RefundableCrowdsale
570  * @dev Extension of Crowdsale contract that adds a funding goal, and
571  * the possibility of users getting a refund if goal is not met.
572  * Uses a RefundVault as the crowdsale's vault.
573  */
574 contract RefundableCrowdsaleWithCommission is FinalizableCrowdsale {
575   using SafeMath for uint256;
576 
577   // minimum amount of funds to be raised in weis
578   uint256 public goal;
579 
580   // refund vault used to hold funds while crowdsale is running
581   RefundVaultWithCommission public vault;
582 
583   function RefundableCrowdsaleWithCommission(uint256 _goal,address _walletFees) public {
584     require(_goal > 0);
585     vault = new RefundVaultWithCommission(wallet,_walletFees);
586     goal = _goal;
587   }
588 
589   // We're overriding the fund forwarding from Crowdsale.
590   // In addition to sending the funds, we want to call
591   // the RefundVault deposit function
592   function forwardFunds() internal {
593     vault.deposit.value(msg.value)(msg.sender);
594   }
595 
596   // if crowdsale is unsuccessful, investors can claim refunds here
597   function claimRefund() public {
598     require(isFinalized);
599     require(!goalReached());
600 
601     vault.refund(msg.sender);
602   }
603 
604   // vault finalization task, called when owner calls finalize()
605   function finalization() internal {
606     if (goalReached()) {
607       vault.close();
608     } else {
609       vault.enableRefunds();
610     }
611 
612     super.finalization();
613   }
614 
615   function goalReached() public view returns (bool) {
616     return weiRaised >= goal;
617   }
618 
619 }
620 
621 // File: contracts/BigTokenCrowdSale.sol
622 
623 contract BigTokenCrowdSale is Crowdsale, RefundableCrowdsaleWithCommission {
624     using SafeMath for uint256;
625 
626     // number of participants
627     uint256 public numberOfPurchasers = 0;
628 
629     // maximum tokens that can be minted in this crowd sale - initialised later by the constructor
630     uint256 public maxTokenSupply = 0;
631 
632     // version cache buster
633     string public constant version = "v1.3";
634 
635     // pending contract owner - initialised later by the constructor
636     address public pendingOwner;
637 
638     // Minimum amount to been able to contribute - initialised later by the constructor
639     uint256 public minimumAmount = 0;
640 
641     // Reserved amount - initialised later by the constructor
642     address public reservedAddr;
643     uint256 public reservedAmount;
644 
645     // white list for KYC
646     mapping (address => bool) public whitelist;
647 
648     // white listing admin - initialised later by the constructor
649     address public whiteListingAdmin;
650 
651 
652 
653     function BigTokenCrowdSale(
654         uint256 _startTime,
655         uint256 _endTime,
656         uint256 _rate,
657         uint256 _goal,
658         uint256 _minimumAmount,
659         uint256 _maxTokenSupply,
660         address _wallet,
661         address _reservedAddr,
662         uint256 _reservedAmount,
663         address _pendingOwner,
664         address _whiteListingAdmin,
665         address _walletFees
666     )
667     FinalizableCrowdsale()
668     RefundableCrowdsaleWithCommission(_goal,_walletFees)
669     Crowdsale(_startTime, _endTime, _rate, _wallet) public
670     {
671         require(_pendingOwner != address(0));
672         require(_minimumAmount >= 0);
673         require(_maxTokenSupply > 0);
674         require(_reservedAmount > 0 && _reservedAmount < _maxTokenSupply);
675 
676         // make sure that the refund goal is within the max supply, using the default rate,  without the reserved supply
677         require(_goal.mul(rate) <= _maxTokenSupply.sub(_reservedAmount));
678 
679         pendingOwner = _pendingOwner;
680         minimumAmount = _minimumAmount;
681         maxTokenSupply = _maxTokenSupply;
682 
683         // reserved amount
684         reservedAddr = _reservedAddr;
685         reservedAmount = _reservedAmount;
686 
687         // whitelisting admin
688         setWhiteListingAdmin(_whiteListingAdmin);
689 
690     }
691 
692     /**
693     *
694     * Create the token on the fly, owner is the contract, not the contract owner yet
695     *
696     **/
697     function createTokenContract() internal returns (MintableToken) {
698         return new BigToken();
699     }
700 
701     // low level token purchase function
702     function buyTokens(address beneficiary) public payable {
703         require(beneficiary != address(0));
704         require(whitelist[beneficiary] == true);
705         //
706         require(validPurchase());
707 
708         // buying can only begins as soon as the ownership has been transfer to the pendingOwner
709         require(owner==pendingOwner);
710 
711         uint256 weiAmount = msg.value;
712 
713         // Compute the number of tokens per wei
714         // bonus structure should be used here, if any
715         uint256 tokens = weiAmount.mul(rate);
716 
717         token.mint(beneficiary, tokens);
718         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
719 
720         // update wei raised and number of purchasers
721         weiRaised = weiRaised.add(weiAmount);
722         numberOfPurchasers = numberOfPurchasers + 1;
723 
724         forwardFunds();
725     }
726 
727     // overriding Crowdsale#validPurchase to add extra cap logic
728     // @return true if investors can buy at the moment
729     function validPurchase() internal view returns (bool) {
730 
731         // make sure we accept only the minimum contribution
732         bool minAmount = (msg.value >= minimumAmount);
733 
734         // cap crowdsaled to a maxTokenSupply
735         // make sure we can not mint more token than expected
736         bool lessThanMaxSupply = (token.totalSupply() + msg.value.mul(rate)) <= maxTokenSupply;
737 
738         // make sure that the purchase follow each rules to be valid
739         return super.validPurchase() && minAmount && lessThanMaxSupply;
740     }
741 
742     // overriding Crowdsale#hasEnded to add cap logic
743     // @return true if crowdsale event has ended
744     function hasEnded() public view returns (bool) {
745         bool capReached = token.totalSupply() >= maxTokenSupply;
746         return super.hasEnded() || capReached;
747     }
748     /**
749      *
750      * Admin functions only called by owner:
751      *
752      *
753      */
754 
755     /**
756       *
757       * Called when the admin function finalize is called :
758       *
759       * it mint the remaining amount to have the supply exactly as planned
760       * it transfer the ownership of the token to the owner of the smart contract
761       *
762       */
763     function finalization() internal {
764         //
765         // send back to the owner the remaining tokens before finishing minting
766         // it ensure that there is only a exact maxTokenSupply token minted ever
767         //
768         uint256 remainingTokens = maxTokenSupply - token.totalSupply();
769 
770         // mint the remaining amount and assign them to the owner
771         token.mint(owner, remainingTokens);
772         TokenPurchase(owner, owner, 0, remainingTokens);
773 
774         // finalize the refundable inherited contract
775         super.finalization();
776 
777         // no more minting allowed - immutable
778         token.finishMinting();
779 
780         // transfer the token owner ship from the contract address to the owner
781         token.transferOwnership(owner);
782     }
783 
784     /**
785       *
786       * Admin functions only executed by owner:
787       * Can change minimum amount
788       *
789       */
790     function changeMinimumAmount(uint256 _minimumAmount) onlyOwner public {
791         require(_minimumAmount > 0);
792         minimumAmount = _minimumAmount;
793     }
794 
795      /**
796       *
797       * Admin functions only executed by owner:
798       * Can change rate
799       *
800       * We do not use an oracle here as oracle need to be paid each time, and if the oracle is not responding
801       * or hacked the rate could be detrimentally modified from an contributor perspective.
802       *
803       */
804     function changeRate(uint256 _rate) onlyOwner public {
805         require(_rate > 0);
806         rate = _rate;
807     }
808 
809     /**
810       *
811       * Admin functions only called by owner:
812       * Can change events dates
813       *
814       */
815     function changeDates(uint256 _startTime, uint256 _endTime) onlyOwner public {
816         require(_startTime >= now);
817         require(_endTime >= _startTime);
818         startTime = _startTime;
819         endTime = _endTime;
820     }
821 
822 
823     /**
824       *
825       * Admin functions only executed by pendingOwner
826       * Change the owner
827       *
828       */
829     function transferOwnerShipToPendingOwner() public {
830 
831         // only the pending owner can change the ownership
832         require(msg.sender == pendingOwner);
833 
834         // can only be changed one time
835         require(owner != pendingOwner);
836 
837         // raise the event
838         OwnershipTransferred(owner, pendingOwner);
839 
840         // change the ownership
841         owner = pendingOwner;
842 
843         // run the PreMint
844         runPreMint();
845 
846     }
847 
848     // run the pre minting of the reserved token
849 
850     function runPreMint() onlyOwner private {
851 
852         token.mint(reservedAddr, reservedAmount);
853         TokenPurchase(owner, reservedAddr, 0, reservedAmount);
854 
855         // update state
856         numberOfPurchasers = numberOfPurchasers + 1;
857     }
858 
859 
860     // add a way to change the whitelistadmin user
861     function setWhiteListingAdmin(address _whiteListingAdmin) onlyOwner public {
862         whiteListingAdmin=_whiteListingAdmin;
863     }
864 
865 
866     /**
867     *    @dev Populate the whitelist, only executed by whiteListingAdmin
868     *
869     */
870     function updateWhitelistMapping(address[] _address,bool value) public {
871         require(msg.sender == whiteListingAdmin);
872         // Add an event here to keep track
873 
874         // add the whitelisted addresses to the mapping
875         for (uint i = 0; i < _address.length; i++) {
876             whitelist[_address[i]] = value;
877         }
878     }
879 
880 }