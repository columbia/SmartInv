1 pragma solidity 0.4.17;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
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
24   address internal owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 /**
62  * @titleVantageICO
63  * @dev VantageCrowdsale is a base contract for managing a token crowdsale.
64  * Crowdsales have a start and end timestamps, where investors can make
65  * token purchases and the crowdsale will assign them XVT tokens based
66  * on a XVT token per ETH rate. Funds collected are forwarded to a wallet
67  * as they arrive.
68  */
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public constant returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 
121 
122 
123 
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public constant returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) allowed;
149 
150 
151    /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     Transfer(_from, _to, _value);
166     return true;
167   }
168 
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    *
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public returns (bool) {
181     allowed[msg.sender][_spender] = _value;
182     Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifying the amount of tokens still available for the spender.
191    */
192   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
193     return allowed[_owner][_spender];
194   }
195 
196   /**
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    */
202   function increaseApproval (address _spender, uint _addedValue)
203     returns (bool success) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   function decreaseApproval (address _spender, uint _subtractedValue)
210     returns (bool success) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 
224 
225 
226 
227 /**
228  * @title Mintable token
229  * @dev Simple ERC20 Token example, with mintable token creation
230  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
231  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
232  */
233 
234 contract MintableToken is StandardToken, Ownable {
235   event Mint(address indexed to, uint256 amount);
236   event MintFinished();
237 
238   bool public mintingFinished = false;
239 
240 
241   modifier canMint() {
242     require(!mintingFinished);
243     _;
244   }
245 
246   /**
247    * @dev Function to mint tokens
248    * @param _to The address that will receive the minted tokens.
249    * @param _amount The amount of tokens to mint.
250    * @return A boolean that indicates if the operation was successful.
251    */
252 
253   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
254     balances[_to] = balances[_to].add(_amount);
255     Mint(_to, _amount);
256     Transfer(msg.sender, _to, _amount);
257     return true;
258   }
259 
260   /**
261    * @dev Function to stop minting new tokens.
262    * @return True if the operation was successful.
263    */
264   function finishMinting() onlyOwner public returns (bool) {
265     mintingFinished = true;
266     MintFinished();
267     return true;
268   }
269 }
270 
271 
272 
273 
274 /**
275  * @title SafeMath
276  * @dev Math operations with safety checks that throw on error
277  */
278 library SafeMath {
279   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
280     uint256 c = a * b;
281     assert(a == 0 || c / a == b);
282     return c;
283   }
284 
285   function div(uint256 a, uint256 b) internal constant returns (uint256) {
286     // assert(b > 0); // Solidity automatically throws when dividing by 0
287     uint256 c = a / b;
288     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289     return c;
290   }
291 
292   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
293     assert(b <= a);
294     return a - b;
295   }
296 
297   function add(uint256 a, uint256 b) internal constant returns (uint256) {
298     uint256 c = a + b;
299     assert(c >= a);
300     return c;
301   }
302 
303 }
304 
305 
306 
307 
308 
309 
310 
311 
312 /**
313  * @title Pausable
314  * @dev Base contract which allows children to implement an emergency stop mechanism.
315  */
316 contract Pausable is Ownable {
317   event Pause();
318   event Unpause();
319 
320   bool public paused = false;
321 
322 
323   /**
324    * @dev Modifier to make a function callable only when the contract is not paused.
325    */
326   modifier whenNotPaused() {
327     require(!paused);
328     _;
329   }
330 
331   /**
332    * @dev Modifier to make a function callable only when the contract is paused.
333    */
334   modifier whenPaused() {
335     require(paused);
336     _;
337   }
338 
339   /**
340    * @dev called by the owner to pause, triggers stopped state
341    */
342   function pause() onlyOwner whenNotPaused public {
343     paused = true;
344     Pause();
345   }
346 
347   /**
348    * @dev called by the owner to unpause, returns to normal state
349    */
350   function unpause() onlyOwner whenPaused public {
351     paused = false;
352     Unpause();
353   }
354 }
355 
356 /**
357  * @title Vantage Crowdsale
358  * @dev Crowdsale is a base contract for managing a token crowdsale.
359  * Crowdsales have a start and end timestamps, where investors can make
360  * token purchases and the crowdsale will assign them tokens based
361  * on a token per ETH rate. Funds collected are forwarded to a wallet
362  * as they arrive.
363  */
364 contract Crowdsale is Ownable, Pausable {
365   using SafeMath for uint256;
366 
367   // The token being sold
368   MintableToken internal token;
369 
370   // start and end timestamps where investments are allowed (both inclusive)
371   uint256 private privateStartTime;
372   uint256 private privateEndTime;
373   uint256 private publicStartTime;
374   uint256 private publicEndTime;
375   
376   // Bonuses will be calculated here of ICO and Pre-ICO (both inclusive)
377   uint256 private privateICOBonus;
378   // wallet address where funds will be saved
379   address internal wallet;
380   // base-rate of a particular Vantage token
381   uint256 public rate;
382   // amount of raised money in wei
383   uint256 internal weiRaised; // internal 
384   // total supply of token 
385   uint256 private totalSupply = SafeMath.mul(200000000, 1 ether);
386   // private supply of token 
387   uint256 private privateSupply = SafeMath.mul(40000000, 1 ether);
388   // public supply of token 
389   uint256 private publicSupply = SafeMath.mul(70000000, 1 ether);
390   // Team supply of token 
391   uint256 private teamAdvisorSupply = SafeMath.mul(SafeMath.div(totalSupply,100),25);
392   // reserve supply of token 
393   uint256 private reserveSupply = SafeMath.mul(SafeMath.div(totalSupply,100),20);
394   // Time lock or vested period of token for team allocated token
395   uint256 public teamTimeLock;
396   // Time lock or vested period of token for reserve allocated token
397   uint256 public reserveTimeLock;
398 
399   /**
400    *  @bool checkBurnTokens
401    *  @bool grantTeamAdvisorSupply
402    *  @bool grantAdvisorSupply     
403   */
404   bool public checkBurnTokens;
405   bool public grantTeamAdvisorSupply;
406   bool public grantReserveSupply;
407 
408   /**
409    * event for token purchase logging
410    * @param purchaser who paid for the tokens
411    * @param beneficiary who got the tokens
412    * @param value weis paid for purchase
413    * @param amount amount of tokens purchased
414    */
415   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
416   
417   event TokenLeft(uint256 tokensLeft);
418 
419   // Vantage Crowdsale constructor
420   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
421     require(_startTime >= now);
422     require(_endTime >= _startTime);
423     require(_rate > 0);
424     require(_wallet != 0x0);
425 
426     // Vantage token creation 
427     token = createTokenContract();
428 
429     // Pre-ICO start Time
430     privateStartTime = _startTime; // 27 march 2018 8 pm UTC
431     
432     // Pre-ICO end time
433      privateEndTime = 1525219199; // 1st May 2018 11:59:pm UTC 1525219199
434 
435     // // ICO start Time
436      publicStartTime = 1530403200;  // 1 july 2018 12 am UTC
437 
438     // ICO end Time
439     publicEndTime = _endTime;  // 20th june 2018 13:pm UTC
440 
441     // Base Rate of XVR Token
442     rate = _rate;
443 
444     // Multi-sig wallet where funds will be saved
445     wallet = _wallet;
446 
447     /** Calculations of Bonuses in ICO or Pre-ICO */
448     privateICOBonus = SafeMath.div(SafeMath.mul(rate,50),100);
449 
450     /** Vested Period calculations for team and advisors*/
451     teamTimeLock = SafeMath.add(publicEndTime, 3 minutes);
452     reserveTimeLock = SafeMath.add(publicEndTime, 3 minutes);
453 
454     checkBurnTokens = false;
455     grantTeamAdvisorSupply = false;
456     grantReserveSupply = false;
457   }
458 
459   // creates the token to be sold.
460   // override this method to have crowdsale of a specific mintable token.
461   function createTokenContract() internal returns (MintableToken) {
462     return new MintableToken();
463   }
464   
465   // fallback function can be used to buy tokens
466   function () payable {
467     buyTokens(msg.sender);    
468   }
469 
470   // High level token purchase function
471   function buyTokens(address beneficiary) whenNotPaused public payable {
472     require(beneficiary != 0x0);
473     require(validPurchase());
474 
475     uint256 weiAmount = msg.value;
476     // minimum investment should be 0.05 ETH
477     require(weiAmount >= 50000000000000000); //50000000000000000
478     
479     uint256 accessTime = now;
480     uint256 tokens = 0;
481 
482   // calculating the crowdsale and Pre-crowdsale bonuses on the basis of timing
483    require(!((accessTime > privateEndTime) && (accessTime < publicStartTime)));
484 
485     if ((accessTime >= privateStartTime) && (accessTime < privateEndTime)) {
486         require(privateSupply > 0);
487 
488         tokens = SafeMath.add(tokens, weiAmount.mul(privateICOBonus));
489         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
490         
491     } else if ((accessTime >= publicStartTime) && (accessTime <= publicEndTime)) {
492         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
493       } 
494     // update state
495     weiRaised = weiRaised.add(weiAmount);
496     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
497     // funds are forwarding
498     forwardFunds();
499   }
500 
501   // send ether to the fund collection wallet
502   // override to create custom fund forwarding mechanisms
503   function forwardFunds() internal {
504     wallet.transfer(msg.value);
505   }
506 
507   // @return true if the transaction can buy tokens
508   function validPurchase() internal constant returns (bool) {
509     bool withinPeriod = now >= privateStartTime && now <= publicEndTime;
510     bool nonZeroPurchase = msg.value != 0;
511     return withinPeriod && nonZeroPurchase;
512   }
513 
514   // @return true if crowdsale event has ended
515   function hasEnded() public constant returns (bool) {
516       return now > publicEndTime;
517   }
518 
519   function burnToken() onlyOwner  public returns (bool) {
520     require(hasEnded());
521     require(!checkBurnTokens);
522     totalSupply = SafeMath.sub(totalSupply, publicSupply);
523     totalSupply = SafeMath.sub(totalSupply,privateSupply);
524     privateSupply = 0;
525     publicSupply = 0;
526     checkBurnTokens = true;
527     return true;
528   }
529 
530   function grantReserveToken(address beneficiary) onlyOwner  public {
531     require((!grantReserveSupply) && (now > reserveTimeLock));
532     grantReserveSupply = true;
533     token.mint(beneficiary,reserveSupply);
534     reserveSupply = 0;  
535   }
536 
537   function grantTeamAdvisorToken(address beneficiary) onlyOwner public {
538     require((!grantTeamAdvisorSupply) && (now > teamTimeLock));
539     grantTeamAdvisorSupply = true;
540     token.mint(beneficiary,teamAdvisorSupply);
541     teamAdvisorSupply = 0;
542     
543   }
544 
545  function privateSaleTransfer(address[] recipients, uint256[] values) onlyOwner  public {
546      require(!checkBurnTokens);
547      for (uint256 i = 0; i < recipients.length; i++) {
548         values[i] = SafeMath.mul(values[i], 1 ether);
549         require(privateSupply >= values[i]);
550         privateSupply = SafeMath.sub(privateSupply,values[i]);
551         token.mint(recipients[i], values[i]); 
552     }
553     TokenLeft(privateSupply);
554   }
555 
556  function publicSaleTransfer(address[] recipients, uint256[] values) onlyOwner  public {
557      require(!checkBurnTokens);
558      for (uint256 i = 0; i < recipients.length; i++) {
559         values[i] = SafeMath.mul(values[i], 1 ether);
560         require(publicSupply >= values[i]);
561         publicSupply = SafeMath.sub(publicSupply,values[i]);
562         token.mint(recipients[i], values[i]);     
563     }
564     TokenLeft(publicSupply);
565   } 
566 
567 
568 
569   function getTokenAddress() onlyOwner public returns (address) {
570     return token;
571   }
572 
573 
574 }
575 
576 
577 
578 
579 
580 
581 
582 
583 
584 /**
585  * @title CappedCrowdsale
586  * @dev Extension of Crowdsale with a max amount of funds raised
587  */
588 contract CappedCrowdsale is Crowdsale {
589   using SafeMath for uint256;
590 
591   uint256 internal cap;
592 
593   function CappedCrowdsale(uint256 _cap) {
594     require(_cap > 0);
595     cap = _cap;
596   }
597 
598   // overriding Crowdsale#validPurchase to add extra cap logic
599   // @return true if investors can buy at the moment
600   function validPurchase() internal constant returns (bool) {
601     bool withinCap = weiRaised.add(msg.value) <= cap;
602     return super.validPurchase() && withinCap;
603   }
604 
605   // overriding Crowdsale#hasEnded to add cap logic
606   // @return true if crowdsale event has ended
607   function hasEnded() public constant returns (bool) {
608     bool capReached = weiRaised >= cap;
609     return super.hasEnded() || capReached;
610   }
611 
612 }
613 
614 
615 /**
616  * @title VantageToken
617  */
618 
619 
620 
621 contract VantageToken is MintableToken {
622 
623   string public constant name = "Vantage Token";
624   string public constant symbol = "XVT";
625   uint8 public constant decimals = 18;
626   uint256 public constant _totalSupply = SafeMath.mul(200000000, 1 ether);
627 
628   function VantageToken () {
629     totalSupply = _totalSupply;
630   }
631 }
632 
633 
634 
635 
636 
637 
638 
639 
640 
641 
642 
643 
644 
645 /**
646  * @title FinalizableCrowdsale
647  * @dev Extension of Crowdsale where an owner can do extra work
648  * after finishing.
649  */
650 contract FinalizableCrowdsale is Crowdsale {
651   using SafeMath for uint256;
652 
653   bool isFinalized = false;
654 
655   event Finalized();
656 
657   /**
658    * @dev Must be called after crowdsale ends, to do some extra finalization
659    * work. Calls the contract's finalization function.
660    */
661   function finalizeCrowdsale() onlyOwner public {
662     require(!isFinalized);
663     require(hasEnded());
664     
665     finalization();
666     Finalized();
667     
668     isFinalized = true;
669     }
670   
671 
672   /**
673    * @dev Can be overridden to add finalization logic. The overriding function
674    * should call super.finalization() to ensure the chain of finalization is
675    * executed entirely.
676    */
677   function finalization() internal {
678   }
679 }
680 
681 
682 
683 
684 
685 
686 /**
687  * @title RefundVault
688  * @dev This contract is used for storing funds while a crowdsale
689  * is in progress. Supports refunding the money if crowdsale fails,
690  * and forwarding it if crowdsale is successful.
691  */
692 contract RefundVault is Ownable {
693   using SafeMath for uint256;
694 
695   enum State { Active, Refunding, Closed }
696 
697   mapping (address => uint256) public deposited;
698   address public wallet;
699   State public state;
700 
701   event Closed();
702   event RefundsEnabled();
703   event Refunded(address indexed beneficiary, uint256 weiAmount);
704 
705   function RefundVault(address _wallet) {
706     require(_wallet != 0x0);
707     wallet = _wallet;
708     state = State.Active;
709   }
710 
711   function deposit(address investor) onlyOwner public payable {
712     require(state == State.Active);
713     deposited[investor] = deposited[investor].add(msg.value);
714   }
715 
716   function close() onlyOwner public {
717     require(state == State.Active);
718     state = State.Closed;
719     Closed();
720     wallet.transfer(this.balance);
721   }
722   
723   function enableRefunds() onlyOwner public {
724     require(state == State.Active);
725     state = State.Refunding;
726     RefundsEnabled();
727   }
728 
729   function refund(address investor) public {
730     require(state == State.Refunding);
731     uint256 depositedValue = deposited[investor];
732     deposited[investor] = 0;
733     investor.transfer(depositedValue);
734     Refunded(investor, depositedValue);
735   }
736 }
737 
738 
739 
740 
741 /**
742  * @title RefundableCrowdsale
743  * @dev Extension of Crowdsale contract that adds a funding goal, and
744  * the possibility of users getting a refund if goal is not met.
745  * Uses a RefundVault as the crowdsale's vault.
746  */
747 contract RefundableCrowdsale is FinalizableCrowdsale {
748   using SafeMath for uint256;
749 
750   // minimum amount of funds to be raised in weis
751   uint256 internal goal;
752   bool private _goalReached = false;
753   // bool public _updateTimeTransfer = false;
754   // refund vault used to hold funds while crowdsale is running
755   RefundVault private vault;
756 
757   function RefundableCrowdsale(uint256 _goal) {
758     require(_goal > 0);
759     vault = new RefundVault(wallet);
760     goal = _goal;
761   }
762 
763   // We're overriding the fund forwarding from Crowdsale.
764   // In addition to sending the funds, we want to call
765   // the RefundVault deposit function
766   function forwardFunds() internal {
767     vault.deposit.value(msg.value)(msg.sender);
768   }
769 
770   // if crowdsale is unsuccessful, investors can claim refunds here
771   function claimRefund() public {
772     require(isFinalized);
773     require(!goalReached());
774 
775     vault.refund(msg.sender);
776   }
777 
778   // vault finalization task, called when owner calls finalize()
779   function finalization() internal {
780     if (goalReached()) { 
781       vault.close();
782     } else {
783       vault.enableRefunds();
784     }
785     super.finalization();
786   
787   }
788 
789   function goalReached() public constant returns (bool) {
790     if (weiRaised >= goal) {
791       _goalReached = true;
792       return true;
793     } else if (_goalReached) {
794       return true;
795     } 
796     else {
797       return false;
798     }
799   }
800 
801   function updateGoalCheck() onlyOwner public {
802     _goalReached = true;
803   }
804 
805   function getVaultAddress() onlyOwner public returns (address) {
806     return vault;
807   }
808 }
809 
810 
811 contract VantageCrowdsale is Crowdsale, CappedCrowdsale, RefundableCrowdsale {
812     /** Constructor VantageICO */ 
813     function VantageCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, uint256 _goal, address _wallet)
814     CappedCrowdsale(_cap)
815     RefundableCrowdsale(_goal)
816     Crowdsale(_startTime, _endTime, _rate, _wallet)
817     {
818         require(_goal <= _cap);  
819     }
820 
821     /**VantageToken Contract is generating from here */
822     function createTokenContract() internal returns (MintableToken) {
823         return new VantageToken();
824     }
825 
826     
827   
828 }