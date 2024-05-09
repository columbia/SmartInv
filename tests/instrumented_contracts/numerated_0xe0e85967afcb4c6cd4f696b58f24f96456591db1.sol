1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35       owner=msg.sender;
36   
37   }
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   uint256 totalSupply_;
70 
71   /**
72   * @dev total number of tokens in existence
73   */
74   function totalSupply() public view returns (uint256) {
75     return totalSupply_;
76   }
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[msg.sender]);
86 
87     // SafeMath.sub will throw if there is not enough balance.
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public view returns (uint256 balance) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken ,Ownable {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 
215 /**
216  * @title Mintable token
217  * @dev Simple ERC20 Token example, with mintable token creation
218  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
219  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
220  */
221 contract MintableToken is StandardToken {
222   event Mint(address indexed to, uint256 amount);
223   event MintFinished();
224 
225   bool public mintingFinished = false;
226 
227 
228   modifier canMint() {
229     require(!mintingFinished);
230     _;
231   }
232 
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will receive the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
240     totalSupply_ = totalSupply_.add(_amount);
241     balances[_to] = balances[_to].add(_amount);
242     Mint(_to, _amount);
243     Transfer(address(0), _to, _amount);
244     return true;
245   }
246 
247   /**
248    * @dev Function to stop minting new tokens.
249    * @return True if the operation was successful.
250    */
251   function finishMinting() onlyOwner canMint public returns (bool) {
252     mintingFinished = true;
253     MintFinished();
254     return true;
255   }
256 }
257 
258 /**
259  * @title SafeMath
260  * @dev Math operations with safety checks that throw on error
261  */
262 library SafeMath {
263 
264   /**
265   * @dev Multiplies two numbers, throws on overflow.
266   */
267   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268     if (a == 0) {
269       return 0;
270     }
271     uint256 c = a * b;
272     assert(c / a == b);
273     return c;
274   }
275 
276   /**
277   * @dev Integer division of two numbers, truncating the quotient.
278   */
279   function div(uint256 a, uint256 b) internal pure returns (uint256) {
280     // assert(b > 0); // Solidity automatically throws when dividing by 0
281     uint256 c = a / b;
282     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283     return c;
284   }
285 
286   /**
287   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
288   */
289   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
290     assert(b <= a);
291     return a - b;
292   }
293 
294   /**
295   * @dev Adds two numbers, throws on overflow.
296   */
297   function add(uint256 a, uint256 b) internal pure returns (uint256) {
298     uint256 c = a + b;
299     assert(c >= a);
300     return c;
301   }
302 }
303 
304 
305 /**
306  * @title Crowdsale
307  * @dev Crowdsale is a base contract for managing a token crowdsale.
308  * Crowdsales have a start and end timestamps, where investors can make
309  * token purchases and the crowdsale will assign them tokens based
310  * on a token per ETH rate. Funds collected are forwarded to a wallet
311  * as they arrive.
312  */
313 contract Crowdsale {
314   using SafeMath for uint256;
315 
316   // The token being sold
317   MintableToken public token;
318 
319   // start and end timestamps where investments are allowed (both inclusive)
320   uint256 public startTime;
321   uint256 public endTime;
322 
323   // address where funds are collected
324   address public wallet;
325 
326   // how many token units a buyer gets per wei
327   uint256 public rate;
328 
329   // amount of raised money in wei
330   uint256 public weiRaised;
331 
332   /**
333    * event for token purchase logging
334    * @param purchaser who paid for the tokens
335    * @param beneficiary who got the tokens
336    * @param value weis paid for purchase
337    * @param amount amount of tokens purchased
338    */
339   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
340 
341 
342   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
343     require(_startTime >= now);
344     require(_endTime >= _startTime);
345     require(_rate > 0);
346     require(_wallet != address(0));
347 
348     token = createTokenContract();
349     startTime = _startTime;
350     endTime = _endTime;
351     rate = _rate;
352     wallet = _wallet;
353   }
354 
355   // fallback function can be used to buy tokens
356   function () external payable {
357     buyTokens(msg.sender);
358   }
359 
360   // low level token purchase function
361   function buyTokens(address beneficiary) public payable {
362     require(beneficiary != address(0));
363     require(validPurchase());
364 
365     uint256 weiAmount = msg.value;
366 
367     // calculate token amount to be created
368     uint256 tokens = getTokenAmount(weiAmount);
369 
370     // update state
371     weiRaised = weiRaised.add(weiAmount);
372 
373     token.mint(beneficiary, tokens);
374     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
375 
376     forwardFunds();
377   }
378 
379   // @return true if crowdsale event has ended
380   function hasEnded() public view returns (bool) {
381     return now > endTime;
382   }
383 
384   // creates the token to be sold.
385   // override this method to have crowdsale of a specific mintable token.
386   function createTokenContract() internal returns (MintableToken) {
387     return new MintableToken();
388   }
389 
390   // Override this method to have a way to add business logic to your crowdsale when buying
391   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
392     return weiAmount.mul(rate);
393   }
394 
395   // send ether to the fund collection wallet
396   // override to create custom fund forwarding mechanisms
397   function forwardFunds() internal {
398     wallet.transfer(msg.value);
399   }
400 
401   // @return true if the transaction can buy tokens
402   function validPurchase() internal view returns (bool) {
403     bool withinPeriod = now >= startTime && now <= endTime;
404     bool nonZeroPurchase = msg.value != 0;
405     return withinPeriod && nonZeroPurchase;
406   }
407 
408 }
409 
410 
411 
412 
413 
414 
415 
416 
417 
418 
419 
420 
421 
422 /**
423  * @title FinalizableCrowdsale
424  * @dev Extension of Crowdsale where an owner can do extra work
425  * after finishing.
426  */
427 contract FinalizableCrowdsale is Crowdsale, Ownable {
428   using SafeMath for uint256;
429 
430   bool public isFinalized = false;
431 
432   event Finalized();
433 
434   /**
435    * @dev Must be called after crowdsale ends, to do some extra finalization
436    * work. Calls the contract's finalization function.
437    */
438   function finalize() onlyOwner public {
439     require(!isFinalized);
440     require(hasEnded());
441 
442     finalization();
443     Finalized();
444 
445     isFinalized = true;
446   }
447 
448   /**
449    * @dev Can be overridden to add finalization logic. The overriding function
450    * should call super.finalization() to ensure the chain of finalization is
451    * executed entirely.
452    */
453   function finalization() internal {
454   }
455 }
456 
457 
458 /**
459  * @title RefundVault
460  * @dev This contract is used for storing funds while a crowdsale
461  * is in progress. Supports refunding the money if crowdsale fails,
462  * and forwarding it if crowdsale is successful.
463  */
464 contract RefundVault is Ownable {
465   using SafeMath for uint256;
466 
467   enum State { Active, Refunding, Closed }
468 
469   mapping (address => uint256) public deposited;
470   address public wallet;
471   State public state;
472 
473   event Closed();
474   event RefundsEnabled();
475   event Refunded(address indexed beneficiary, uint256 weiAmount);
476 
477   function RefundVault(address _wallet) public {
478     require(_wallet != address(0));
479     wallet = _wallet;
480     state = State.Active;
481   }
482 
483   function deposit(address investor) onlyOwner public payable {
484     require(state == State.Active);
485     deposited[investor] = deposited[investor].add(msg.value);
486   }
487 
488   function close() onlyOwner public {
489     require(state == State.Active);
490     state = State.Closed;
491     Closed();
492     wallet.transfer(this.balance);
493   }
494 
495 
496   function enableRefunds() onlyOwner public {
497     require(state == State.Active);
498     state = State.Refunding;
499     RefundsEnabled();
500   }
501 
502   function refund(address investor) public {
503     require(state == State.Refunding);
504     uint256 depositedValue = deposited[investor];
505     deposited[investor] = 0;
506     investor.transfer(depositedValue);
507     Refunded(investor, depositedValue);
508   }
509 }
510 
511 
512 
513 /**
514  * @title RefundableCrowdsale
515  * @dev Extension of Crowdsale contract that adds a funding goal, and
516  * the possibility of users getting a refund if goal is not met.
517  * Uses a RefundVault as the crowdsale's vault.
518  */
519 contract RefundableCrowdsale is FinalizableCrowdsale {
520   using SafeMath for uint256;
521 
522   // minimum amount of funds to be raised in weis
523   uint256 public goal;
524 
525   // refund vault used to hold funds while crowdsale is running
526   RefundVault public vault;
527 
528   function RefundableCrowdsale(uint256 _goal) public {
529     require(_goal > 0);
530     vault = new RefundVault(wallet);
531     goal = _goal;
532   }
533 
534   // if crowdsale is unsuccessful, investors can claim refunds here
535   function claimRefund() public {
536     require(isFinalized);
537     require(!goalReached());
538 
539     vault.refund(msg.sender);
540   }
541 
542   function goalReached() public view returns (bool) {
543     return weiRaised >= goal;
544   }
545 
546   // vault finalization task, called when owner calls finalize()
547   function finalization() internal {
548     if (goalReached()) {
549       vault.close();
550     } 
551     
552     else {
553       vault.enableRefunds();
554     }
555 
556     super.finalization();
557   }
558 
559   // We're overriding the fund forwarding from Crowdsale.
560   // In addition to sending the funds, we want to call
561   // the RefundVault deposit function
562   function forwardFunds() internal {
563     vault.deposit.value(msg.value)(msg.sender);
564   }
565 
566 }
567 
568 
569 
570 /**
571  * @title CappedCrowdsale
572  * @dev Extension of Crowdsale with a max amount of funds raised
573  */
574 contract CappedCrowdsale is Crowdsale {
575   using SafeMath for uint256;
576 
577   uint256 public cap;
578 
579   function CappedCrowdsale(uint256 _cap) public {
580     require(_cap > 0);
581     cap = _cap;
582   }
583 
584   // overriding Crowdsale#hasEnded to add cap logic
585   // @return true if crowdsale event has ended
586   function hasEnded() public view returns (bool) {
587     bool capReached = weiRaised >= cap;
588     return capReached || super.hasEnded();
589   }
590 
591   // overriding Crowdsale#validPurchase to add extra cap logic
592   // @return true if investors can buy at the moment
593   function validPurchase() internal view returns (bool) {
594     bool withinCap = weiRaised.add(msg.value) <= cap;
595     return withinCap && super.validPurchase();
596   }
597 
598 }
599 
600 
601 contract Toplancer is MintableToken {
602   string public constant name = "Toplancer";
603   string public constant symbol = "TLC";
604   uint8 public constant decimals = 18;
605  
606 
607 }
608 
609 contract Allocation is Ownable {
610   using SafeMath for uint;
611   uint256 public unlockedAt;
612   Toplancer tlc;
613   mapping (address => uint) founderAllocations;
614   uint256 tokensCreated = 0;
615  
616  
617 //decimal value
618  uint256 public constant decimalFactor = 10 ** uint256(18);
619 
620   uint256 constant public FounderAllocationTokens = 840000000*decimalFactor;
621 
622  
623   //address of the founder storage vault
624   address public founderStorageVault = 0x97763051c517DD3aBc2F6030eac6Aa04576E05E1;
625  
626   function TeamAllocation() {
627     tlc = Toplancer(msg.sender);
628   
629     unlockedAt = now;
630    
631     // 20% tokens from the FounderAllocation 
632     founderAllocations[founderStorageVault] = FounderAllocationTokens;
633    
634   }
635   function getTotalAllocation() returns (uint256){
636     return (FounderAllocationTokens);
637   }
638   function unlock() external payable {
639     require (now >=unlockedAt);
640     if (tokensCreated == 0) {
641       tokensCreated = tlc.balanceOf(this);
642     }
643     
644     //transfer the  tokens to the founderStorageAddress
645     tlc.transfer(founderStorageVault, tokensCreated);
646   
647   }
648 }
649 
650 
651 contract TLCMarketCrowdsale is RefundableCrowdsale,CappedCrowdsale {
652 
653 
654  enum State {PRESALE, PUBLICSALE}
655  State public state;
656 
657 //decimal value
658  uint256 public constant decimalFactor = 10 ** uint256(18);
659  
660  
661  uint256 public constant _totalSupply = 2990000000 *decimalFactor; 
662  
663  uint256 public presaleCap = 200000000 *decimalFactor; // 7%
664  uint256 public soldTokenInPresale;
665  uint256 public publicSaleCap = 1950000000 *decimalFactor; // 65%
666  uint256 public soldTokenInPublicsale;
667  uint256 public distributionSupply = 840000000 *decimalFactor; // 28%
668  
669 
670 
671 
672  Allocation allocation;
673 
674  // How much ETH each address has invested to this crowdsale
675  mapping (address => uint256) public investedAmountOf;
676  // How many distinct addresses have invested
677  uint256 public investorCount;
678  uint256 public minContribAmount = 0.1 ether; // minimum contribution amount is 0.1 ether
679 
680  // Constructor
681  // Token Creation and presale starts
682  //Start time end time should be given in unix timestamps
683  //goal and cap
684   function TLCMarketCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap)
685 
686     Crowdsale (_startTime, _endTime, _rate, _wallet)  RefundableCrowdsale(_goal*decimalFactor) CappedCrowdsale(_cap*decimalFactor)
687   {
688         state = State.PRESALE;
689   }
690    function createTokenContract() internal returns (MintableToken) {
691     return new Toplancer();
692   }
693 
694   // low level token purchase function
695   // @notice buyTokens
696   // @param beneficiary The address of the beneficiary
697    // @return the transaction address and send the event as TokenPurchase
698   function buyTokens(address beneficiary) public payable {
699       require(publicSaleCap > 0);
700       require(validPurchase());
701       uint256  weiAmount = msg.value;
702        
703        // calculate token amount to be created
704     uint256 tokens = weiAmount.mul(rate);
705 
706     uint256 Bonus = tokens.mul(getTimebasedBonusRate()).div(100);
707 
708     tokens = tokens.add(Bonus);
709     
710     if (state == State.PRESALE) {
711         assert (soldTokenInPresale + tokens <= presaleCap);
712         soldTokenInPresale = soldTokenInPresale.add(tokens);
713         presaleCap=presaleCap.sub(tokens);
714     } else if(state==State.PUBLICSALE){
715          assert (soldTokenInPublicsale + tokens <= publicSaleCap);
716         soldTokenInPublicsale = soldTokenInPublicsale.add(tokens);
717         publicSaleCap=publicSaleCap.sub(tokens);
718     }
719        
720        if(investedAmountOf[beneficiary] == 0) {
721            // A new investor
722            investorCount++;
723         }
724         // Update investor
725         investedAmountOf[beneficiary] = investedAmountOf[beneficiary].add(weiAmount);
726        forwardFunds();
727        weiRaised = weiRaised.add(weiAmount);
728        token.mint(beneficiary, tokens);
729        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
730     
731      }
732 
733 
734      // @return true if the transaction can buy tokens
735    function validPurchase() internal constant returns (bool) {
736         bool minContribution = minContribAmount <= msg.value;
737         bool withinPeriod = now >= startTime && now <= endTime;
738         bool nonZeroPurchase = msg.value != 0;
739         bool Publicsale =publicSaleCap !=0;
740         return withinPeriod && minContribution && nonZeroPurchase && Publicsale;
741     }
742    // @return  current time
743    function getNow() public constant returns (uint) {
744         return (now);
745     }
746 
747     // Get the time-based bonus rate
748    function getTimebasedBonusRate() internal constant returns (uint256) {
749   	  uint256 bonusRate = 0;
750       if (state == State.PRESALE) {
751           bonusRate = 100;
752       } else {
753           uint256 nowTime = getNow();
754           uint256 bonusFirstWeek = startTime + (7 days * 1000);
755           uint256 bonusSecondWeek = bonusFirstWeek + (7 days * 1000);
756           uint256 bonusThirdWeek = bonusSecondWeek + (7 days * 1000);
757           uint256 bonusFourthWeek = bonusThirdWeek + (7 days * 1000);
758           if (nowTime <= bonusFirstWeek) {
759               bonusRate = 30;
760           } else if (nowTime <= bonusSecondWeek) {
761               bonusRate = 30;
762           } else if (nowTime <= bonusThirdWeek) {
763               bonusRate = 15;
764           } else if (nowTime <= bonusFourthWeek) {
765               bonusRate = 15;
766           }
767       }
768       return bonusRate;
769    }  
770      
771         //start public sale
772       // @param startTime 
773       // @param _endTime 
774    function startPublicsale(uint256 _startTime, uint256 _endTime) public onlyOwner {
775       require(state == State.PRESALE && _endTime >= _startTime);
776       state = State.PUBLICSALE;
777       startTime = _startTime;
778       endTime = _endTime;
779       publicSaleCap=publicSaleCap.add(presaleCap);
780       presaleCap=presaleCap.sub(presaleCap);
781    }
782     
783      
784    //it will call when   crowdsale unsuccessful  if crowdsale  completed
785    function finalization() internal {
786        if(goalReached()){
787         allocation = new Allocation();
788         token.mint(address(allocation), distributionSupply);
789         distributionSupply=distributionSupply.sub(distributionSupply);
790        }
791         
792         token.finishMinting();
793         super.finalization();
794          
795    }
796 
797     //change Starttime
798    // @param startTime 
799    function changeStarttime(uint256 _startTime) public onlyOwner {
800         require(_startTime != 0);  
801         startTime = _startTime;
802     }
803         
804    
805   //change Edntime      
806  // @param _endTime
807   function changeEndtime(uint256 _endTime) public onlyOwner {
808         require(_endTime != 0);    
809         endTime = _endTime;
810            
811         }
812     //change token price per 1 ETH
813      // @param _rate
814   function changeRate(uint256 _rate) public onlyOwner {
815         require(_rate != 0);
816         rate = _rate;
817 
818        }
819 
820     //change  wallet address
821     // @param wallet address
822    function changeWallet (address _wallet) onlyOwner  {
823         wallet = _wallet;
824        
825     }
826         
827    }