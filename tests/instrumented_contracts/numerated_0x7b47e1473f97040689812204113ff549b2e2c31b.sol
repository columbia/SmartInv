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
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83 
84   /**
85   * @dev total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     // SafeMath.sub will throw if there is not enough balance.
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) public view returns (uint256 balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 
119 
120 
121 
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender) public view returns (uint256);
129   function transferFrom(address from, address to, uint256 value) public returns (bool);
130   function approve(address spender, uint256 value) public returns (bool);
131   event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is ERC20, BasicToken ,Ownable {
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(address _owner, address _spender) public view returns (uint256) {
189     return allowed[_owner][_spender];
190   }
191 
192   /**
193    * @dev Increase the amount of tokens that an owner allowed to a spender.
194    *
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
203     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
204     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 
208   /**
209    * @dev Decrease the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To decrement
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _subtractedValue The amount of tokens to decrease the allowance by.
217    */
218   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 
232 
233 
234 /**
235  * @title Mintable token
236  * @dev Simple ERC20 Token example, with mintable token creation
237  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
238  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
239  */
240 contract MintableToken is StandardToken {
241   event Mint(address indexed to, uint256 amount);
242   event MintFinished();
243 
244   bool public mintingFinished = false;
245 
246 
247   modifier canMint() {
248     require(!mintingFinished);
249     _;
250   }
251 
252   /**
253    * @dev Function to mint tokens
254    * @param _to The address that will receive the minted tokens.
255    * @param _amount The amount of tokens to mint.
256    * @return A boolean that indicates if the operation was successful.
257    */
258   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
259     totalSupply_ = totalSupply_.add(_amount);
260     balances[_to] = balances[_to].add(_amount);
261     Mint(_to, _amount);
262     Transfer(address(0), _to, _amount);
263     return true;
264   }
265 
266   /**
267    * @dev Function to stop minting new tokens.
268    * @return True if the operation was successful.
269    */
270   function finishMinting() onlyOwner canMint public returns (bool) {
271     mintingFinished = true;
272     MintFinished();
273     return true;
274   }
275 }
276 
277 
278 
279 
280 /**
281  * @title SafeMath
282  * @dev Math operations with safety checks that throw on error
283  */
284 library SafeMath {
285 
286   /**
287   * @dev Multiplies two numbers, throws on overflow.
288   */
289   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
290     if (a == 0) {
291       return 0;
292     }
293     uint256 c = a * b;
294     assert(c / a == b);
295     return c;
296   }
297 
298   /**
299   * @dev Integer division of two numbers, truncating the quotient.
300   */
301   function div(uint256 a, uint256 b) internal pure returns (uint256) {
302     // assert(b > 0); // Solidity automatically throws when dividing by 0
303     uint256 c = a / b;
304     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
305     return c;
306   }
307 
308   /**
309   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
310   */
311   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
312     assert(b <= a);
313     return a - b;
314   }
315 
316   /**
317   * @dev Adds two numbers, throws on overflow.
318   */
319   function add(uint256 a, uint256 b) internal pure returns (uint256) {
320     uint256 c = a + b;
321     assert(c >= a);
322     return c;
323   }
324 }
325 
326 
327 
328 /**
329  * @title Crowdsale
330  * @dev Crowdsale is a base contract for managing a token crowdsale.
331  * Crowdsales have a start and end timestamps, where investors can make
332  * token purchases and the crowdsale will assign them tokens based
333  * on a token per ETH rate. Funds collected are forwarded to a wallet
334  * as they arrive.
335  */
336 contract Crowdsale {
337   using SafeMath for uint256;
338 
339   // The token being sold
340   MintableToken public token;
341 
342   // start and end timestamps where investments are allowed (both inclusive)
343   uint256 public startTime;
344   uint256 public endTime;
345 
346   // address where funds are collected
347   address public wallet;
348 
349   // how many token units a buyer gets per wei
350   uint256 public rate;
351 
352   // amount of raised money in wei
353   uint256 public weiRaised;
354 
355   /**
356    * event for token purchase logging
357    * @param purchaser who paid for the tokens
358    * @param beneficiary who got the tokens
359    * @param value weis paid for purchase
360    * @param amount amount of tokens purchased
361    */
362   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
363 
364 
365   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
366     require(_startTime >= now);
367     require(_endTime >= _startTime);
368     require(_rate > 0);
369     require(_wallet != address(0));
370 
371     token = createTokenContract();
372     startTime = _startTime;
373     endTime = _endTime;
374     rate = _rate;
375     wallet = _wallet;
376   }
377 
378   // fallback function can be used to buy tokens
379   function () external payable {
380     buyTokens(msg.sender);
381   }
382 
383   // low level token purchase function
384   function buyTokens(address beneficiary) public payable {
385     require(beneficiary != address(0));
386     require(validPurchase());
387 
388     uint256 weiAmount = msg.value;
389 
390     // calculate token amount to be created
391     uint256 tokens = getTokenAmount(weiAmount);
392 
393     // update state
394     weiRaised = weiRaised.add(weiAmount);
395 
396     token.mint(beneficiary, tokens);
397     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
398 
399     forwardFunds();
400   }
401 
402   // @return true if crowdsale event has ended
403   function hasEnded() public view returns (bool) {
404     return now > endTime;
405   }
406 
407   // creates the token to be sold.
408   // override this method to have crowdsale of a specific mintable token.
409   function createTokenContract() internal returns (MintableToken) {
410     return new MintableToken();
411   }
412 
413   // Override this method to have a way to add business logic to your crowdsale when buying
414   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
415     return weiAmount.mul(rate);
416   }
417 
418   // send ether to the fund collection wallet
419   // override to create custom fund forwarding mechanisms
420   function forwardFunds() internal {
421     wallet.transfer(msg.value);
422   }
423 
424   // @return true if the transaction can buy tokens
425   function validPurchase() internal view returns (bool) {
426     bool withinPeriod = now >= startTime && now <= endTime;
427     bool nonZeroPurchase = msg.value != 0;
428     return withinPeriod && nonZeroPurchase;
429   }
430 
431 }
432 
433 
434 
435 
436 
437 
438 
439 
440 
441 
442 
443 
444 
445 /**
446  * @title FinalizableCrowdsale
447  * @dev Extension of Crowdsale where an owner can do extra work
448  * after finishing.
449  */
450 contract FinalizableCrowdsale is Crowdsale, Ownable {
451   using SafeMath for uint256;
452 
453   bool public isFinalized = false;
454 
455   event Finalized();
456 
457   /**
458    * @dev Must be called after crowdsale ends, to do some extra finalization
459    * work. Calls the contract's finalization function.
460    */
461   function finalize() onlyOwner public {
462     require(!isFinalized);
463     require(hasEnded());
464 
465     finalization();
466     Finalized();
467 
468     isFinalized = true;
469   }
470 
471   /**
472    * @dev Can be overridden to add finalization logic. The overriding function
473    * should call super.finalization() to ensure the chain of finalization is
474    * executed entirely.
475    */
476   function finalization() internal {
477   }
478 }
479 
480 
481 
482 
483 
484 
485 
486 /**
487  * @title RefundVault
488  * @dev This contract is used for storing funds while a crowdsale
489  * is in progress. Supports refunding the money if crowdsale fails,
490  * and forwarding it if crowdsale is successful.
491  */
492 contract RefundVault is Ownable {
493   using SafeMath for uint256;
494 
495   enum State { Active, Refunding, Closed }
496 
497   mapping (address => uint256) public deposited;
498   address public wallet;
499   State public state;
500 
501   event Closed();
502   event RefundsEnabled();
503   event Refunded(address indexed beneficiary, uint256 weiAmount);
504 
505   function RefundVault(address _wallet) public {
506     require(_wallet != address(0));
507     wallet = _wallet;
508     state = State.Active;
509   }
510 
511   function deposit(address investor) onlyOwner public payable {
512     require(state == State.Active);
513     deposited[investor] = deposited[investor].add(msg.value);
514   }
515 
516   function close() onlyOwner public {
517  
518     state = State.Closed;
519     Closed();
520     wallet.transfer(this.balance);
521   }
522 
523 
524   function enableRefunds() onlyOwner public {
525     require(state == State.Active);
526     state = State.Refunding;
527     RefundsEnabled();
528   }
529 
530   function refund(address investor) public {
531     require(state == State.Refunding);
532     uint256 depositedValue = deposited[investor];
533     deposited[investor] = 0;
534     investor.transfer(depositedValue);
535     Refunded(investor, depositedValue);
536   }
537 }
538 
539 
540 
541 /**
542  * @title RefundableCrowdsale
543  * @dev Extension of Crowdsale contract that adds a funding goal, and
544  * the possibility of users getting a refund if goal is not met.
545  * Uses a RefundVault as the crowdsale's vault.
546  */
547 contract RefundableCrowdsale is FinalizableCrowdsale {
548   using SafeMath for uint256;
549 
550   // minimum amount of funds to be raised in weis
551   uint256 public goal;
552 
553   // refund vault used to hold funds while crowdsale is running
554   RefundVault public vault;
555 
556   function RefundableCrowdsale(uint256 _goal) public {
557     require(_goal > 0);
558     vault = new RefundVault(wallet);
559     goal = _goal;
560   }
561 
562   // if crowdsale is unsuccessful, investors can claim refunds here
563   function claimRefund() public {
564     require(isFinalized);
565     require(!goalReached());
566 
567     vault.refund(msg.sender);
568   }
569 
570   function goalReached() public view returns (bool) {
571     return weiRaised >= goal;
572   }
573 
574   // vault finalization task, called when owner calls finalize()
575   function finalization() internal {
576     if (goalReached()) {
577       vault.close();
578     } 
579     
580     else {
581       vault.enableRefunds();
582     }
583 
584     super.finalization();
585   }
586 
587   // We're overriding the fund forwarding from Crowdsale.
588   // In addition to sending the funds, we want to call
589   // the RefundVault deposit function
590   function forwardFunds() internal {
591     vault.deposit.value(msg.value)(msg.sender);
592   }
593 
594 }
595 
596 
597 
598 
599 
600 
601 
602 /**
603  * @title CappedCrowdsale
604  * @dev Extension of Crowdsale with a max amount of funds raised
605  */
606 contract CappedCrowdsale is Crowdsale {
607   using SafeMath for uint256;
608 
609   uint256 public cap;
610 
611   function CappedCrowdsale(uint256 _cap) public {
612     require(_cap > 0);
613     cap = _cap;
614   }
615 
616   // overriding Crowdsale#hasEnded to add cap logic
617   // @return true if crowdsale event has ended
618   function hasEnded() public view returns (bool) {
619     bool capReached = weiRaised >= cap;
620     return capReached || super.hasEnded();
621   }
622 
623   // overriding Crowdsale#validPurchase to add extra cap logic
624   // @return true if investors can buy at the moment
625   function validPurchase() internal view returns (bool) {
626     bool withinCap = weiRaised.add(msg.value) <= cap;
627     return withinCap && super.validPurchase();
628   }
629 
630 }
631 
632 
633 
634 
635 
636 
637 
638 contract Mest is MintableToken {
639   string public constant name = "Monaco Estate";
640   string public constant symbol = "MEST";
641   uint8 public constant decimals = 18;
642  
643   address public admin=0x6bfc645b3fd135f14eed944922157c41dcc5e9ab;
644  event Pause();
645  event Unpause();
646  event AdminAccessTransferred(address indexed admin, address indexed newAdmin);
647 
648   bool public paused = true;
649 
650  // modifier to allow only owner has full control on the function
651     modifier onlyAdmin {
652         require(msg.sender == admin);
653         _;
654     }
655   /**
656    * @dev Modifier to make a function callable only when the contract is not paused.
657    */
658   modifier whenNotPaused() {
659     require(!paused);
660     _;
661   }
662 
663   /**
664    * @dev Modifier to make a function callable only when the contract is paused.
665    */
666   modifier whenPaused() {
667     require(paused);
668     _;
669   }
670 
671   /**
672    * @dev called by the owner to pause, triggers stopped state
673    */
674   function pause() onlyAdmin whenNotPaused public {
675     paused = true;
676     Pause();
677   }
678 
679   /**
680    * @dev called by the owner to unpause, returns to normal state
681    */
682   function unpause() onlyAdmin whenPaused public {
683     paused = false;
684     Unpause();
685   }
686 
687   /**
688    * @dev Allows the current admin to transfer control of the contract to a newAdmin.
689    * @param newAdmin The address to transfer Admin to.
690    */
691   function changeAdmin(address newAdmin) public onlyAdmin {
692     require(newAdmin != address(0));
693     AdminAccessTransferred(admin, newAdmin);
694     admin = newAdmin;
695   }
696  /**
697   * @dev transfer token for a specified address
698   * @param _to The address to transfer to.
699   * @param _value The amount to be transferred.
700   */
701   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
702     require(_to != address(0));
703     require(_value <= balances[msg.sender]);
704 
705     // SafeMath.sub will throw if there is not enough balance.
706     balances[msg.sender] = balances[msg.sender].sub(_value);
707     balances[_to] = balances[_to].add(_value);
708     Transfer(msg.sender, _to, _value);
709     return true;
710   }
711 
712 
713    
714 
715   /**
716    * @dev Transfer tokens from one address to another
717    * @param _from address The address which you want to send tokens from
718    * @param _to address The address which you want to transfer to
719    * @param _value uint256 the amount of tokens to be transferred
720    */
721   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
722     require(_to != address(0));
723     require(_value <= balances[_from]);
724     require(_value <= allowed[_from][msg.sender]);
725 
726     balances[_from] = balances[_from].sub(_value);
727     balances[_to] = balances[_to].add(_value);
728     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
729     Transfer(_from, _to, _value);
730     return true;
731   }
732 
733 
734 
735 
736 }
737 
738 contract FounderAllocation is Ownable {
739   using SafeMath for uint;
740   uint256 public unlockedAt;
741   Mest mest;
742   mapping (address => uint) founderAllocations;
743   uint256 tokensCreated = 0;
744  
745  
746 //decimal value
747  uint256 public constant decimalFactor = 10 ** uint256(18);
748 
749   uint256 constant public FounderAllocationTokens = 20000000*decimalFactor;
750 
751  
752   //address of the founder storage vault
753   address public founderStorageVault = 0x4cCeF76C9883a4c416DACAA0c0e4f3a47D65883a;
754  
755   function TeamAllocation() {
756     mest = Mest(msg.sender);
757   
758     unlockedAt = now;
759    
760     // 20% tokens from the FounderAllocation 
761     founderAllocations[founderStorageVault] = FounderAllocationTokens;
762    
763   }
764   function getTotalAllocation() returns (uint256){
765     return (FounderAllocationTokens);
766   }
767   function unlock() external payable {
768     require (now >=unlockedAt);
769     if (tokensCreated == 0) {
770       tokensCreated = mest.balanceOf(this);
771     }
772     
773     //transfer the  tokens to the founderStorageAddress
774     mest.transfer(founderStorageVault, tokensCreated);
775   
776   }
777 }
778 
779 
780 contract MestCrowdsale is RefundableCrowdsale,CappedCrowdsale {
781 
782 
783 //decimal value
784  uint256 public constant decimalFactor = 10 ** uint256(18);
785  
786 //Available tokens for PublicAllocation
787 uint256 public publicAllocation = 80000000 *decimalFactor; //80%
788 //Available token for FounderAllocation
789 uint256 public _founder = 20000000* decimalFactor; //20%
790 
791 FounderAllocation founderAllocation;
792 
793 // How much ETH each address has invested to this crowdsale
794 mapping (address => uint256) public investedAmountOf;
795 // How many distinct addresses have invested
796 uint256 public investorCount;
797 uint256 public minContribAmount = 0.1 ether; // minimum contribution amount is 0.1 ether
798 
799 event Burn(address indexed burner, uint256 value);
800 uint256 public whitelistMaxContribAmount = 2.5 ether; // 2.5 ether
801 
802   
803 
804 //status to find  whitelist investor's max contribution amount
805 struct whiteListInStruct{
806 uint256 status;
807 
808 }
809 
810 //investor claim their amount  between refunding Starttime && refunding Endtime
811 uint256 public refundingStarttime;
812 uint256 public refundingEndtime=90 days;
813 
814 //To store whitelist investors address and status
815   
816 mapping(address => whiteListInStruct[]) whiteList;
817 
818 
819 
820 // Constructor
821 // Token Creation and presale starts
822 //Start time end time should be given in unix timestamps
823 function MestCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap)
824 
825     Crowdsale (_startTime, _endTime, _rate, _wallet)  RefundableCrowdsale(_goal*decimalFactor) CappedCrowdsale(_cap*decimalFactor)
826   {
827 
828   }
829   function createTokenContract() internal returns (MintableToken) {
830     return new Mest();
831   }
832 
833   // low level token purchase function
834   // @notice buyTokens
835   // @param beneficiary The address of the beneficiary
836   // @return the transaction address and send the event as TokenPurchase
837  function buyTokens(address beneficiary) public payable {
838       require(publicAllocation > 0);
839        require(validPurchase());
840       uint256  weiAmount = msg.value;
841           require(isVerified(beneficiary,weiAmount));
842        // calculate token amount to be created
843     uint256 tokens = weiAmount.mul(rate);
844 
845     uint256 Bonus = tokens.mul(getVolumBonusRate()).div(100);
846 
847     tokens = tokens.add(Bonus);
848 
849 
850 
851        if(investedAmountOf[beneficiary] == 0) {
852            // A new investor
853            investorCount++;
854         }
855         // Update investor
856         investedAmountOf[beneficiary] = investedAmountOf[beneficiary].add(weiAmount);
857 
858             assert (tokens <= publicAllocation);
859             publicAllocation = publicAllocation.sub(tokens);
860 
861 
862        forwardFunds();
863        weiRaised = weiRaised.add(weiAmount);
864        token.mint(beneficiary, tokens);
865        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
866     
867      }
868 
869 
870      // @return true if the transaction can buy tokens
871     function validPurchase() internal constant returns (bool) {
872         bool minContribution = minContribAmount <= msg.value;
873         bool withinPeriod = now >= startTime && now <= endTime;
874         bool nonZeroPurchase = msg.value != 0;
875         bool Publicsale =publicAllocation !=0;
876         return withinPeriod && minContribution && nonZeroPurchase && Publicsale;
877     }
878    // @return  current time
879     function getNow() public constant returns (uint) {
880         return (now);
881     }
882 
883     // ------------------------------------------------------------------------
884   // Add to whitelist
885   // ------------------------------------------------------------------------
886 
887     function addtoWhitelist(address _to, uint256 _status)public onlyOwner returns (bool){
888 
889     if(whiteList[_to].length==0) {
890 
891     whiteList[_to].push(whiteListInStruct(uint256(_status)));
892      return true;
893 
894     }else if(whiteList[_to].length>0){
895 
896         for (uint i = 0; i < whiteList[_to].length; i++){
897             whiteList[_to][i].status=_status;
898 
899         }
900 
901          return true;
902 
903     }
904 }
905 
906 //whiteList verification
907 
908 function isVerified(address _address, uint256 _amt)internal  returns  ( bool){
909 
910    if(whiteList[_address].length > 0) {
911     for (uint i = 0; i < whiteList[_address].length; i++){
912     if(whiteList[_address][i].status==0 ){
913         if( whitelistMaxContribAmount>=_amt+ investedAmountOf[_address])return true;
914 
915     }
916          if(whiteList[_address][i].status==1){
917              return true;
918          }
919 
920          }
921 
922    }
923 }
924 
925 
926 
927 
928        // Get the Volume-based bonus rate
929        function getVolumBonusRate() internal constant returns (uint256) {
930         uint256 bonusRate = 0;
931         if(!goalReached()){
932             bonusRate=10;
933 
934         }
935            return bonusRate;
936        }
937     //if the user not claim after 90days, owner revoke the ether to wallet
938      function revoke() public onlyOwner {
939          require(getNow()>refundingEndtime);
940           require(isFinalized);
941           vault.close();
942      }
943      
944      
945 // if crowdsale is unsuccessful, investors can claim refunds here
946   function claimRefund() public {
947         require(getNow()<=refundingEndtime);
948         require(isFinalized);
949         require(!goalReached());
950       
951          vault.refund(msg.sender);
952       
953       
954   }
955   
956      
957  
958   //it will call when   crowdsale unsuccessful  if crowdsale  completed
959   function finalization() internal {
960         refundingStarttime=getNow();
961         refundingEndtime=refundingEndtime.add(getNow());
962        
963        if(goalReached()){
964         founderAllocation = new FounderAllocation();
965         token.mint(address(founderAllocation), _founder);
966         _founder=_founder.sub(_founder);
967        }else if(!goalReached()){
968            
969            
970             Burn(msg.sender, _founder);
971              _founder=0;
972        }
973         
974         token.finishMinting();
975         super.finalization();
976          
977   }
978 
979  
980   // Change crowdsale Starttime 
981   function changeStarttime(uint256 _startTime) public onlyOwner {
982 
983            
984             startTime = _startTime;
985         }
986         
987           // Change the changeminContribAmount
988       function changeminContribAmount(uint256 _minContribAmount) public onlyOwner {
989         require(_minContribAmount != 0);
990          minContribAmount = _minContribAmount;
991 
992       }
993         
994   // Change crowdsale  Endtime 
995   function changeEndtime(uint256 _endTime) public onlyOwner {
996 
997             endTime = _endTime;
998            
999         }
1000 
1001         // Change the token price
1002        function changeRate(uint256 _rate) public onlyOwner {
1003          require(_rate != 0);
1004           rate = _rate;
1005 
1006        }
1007 
1008        // Change the goal
1009       function changeGoal(uint256 _softcap) public onlyOwner {
1010         require(_softcap != 0);
1011          goal = _softcap;
1012 
1013       }
1014 
1015 
1016       // Change the whiteList Maximum contribution amount
1017      function changeMaximumContribution(uint256 _whitelistMaxContribAmount) public onlyOwner {
1018        require(_whitelistMaxContribAmount != 0);
1019         whitelistMaxContribAmount = _whitelistMaxContribAmount;
1020         
1021      }
1022 
1023 
1024   
1025             
1026       //change  Publicallocation
1027     function changePublicallocation (uint256  _value) onlyOwner  {
1028         publicAllocation = _value.mul(decimalFactor);
1029        
1030     }
1031         
1032         
1033         
1034     //change  wallet address
1035     function changeWallet (address _wallet) onlyOwner  {
1036         wallet = _wallet;
1037        
1038     }
1039         
1040             
1041         //Burns a specific amount of tokens
1042     function burnToken(uint256 _value) onlyOwner {
1043         require(_value > 0 &&_value <= publicAllocation);
1044          publicAllocation = publicAllocation.sub(_value.mul(decimalFactor));
1045 
1046         
1047         Burn(msg.sender, _value);
1048     }}