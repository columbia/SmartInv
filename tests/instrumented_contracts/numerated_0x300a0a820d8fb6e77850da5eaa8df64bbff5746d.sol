1 pragma solidity ^0.4.18;
2 
3 //*****************************************************
4 // BOOMR Coin contract
5 // For LibLob, Zach Spoor, by Michael Hanna
6 // ****************************************************
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
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 }
81 
82 /**
83  * @title Pausable
84  * @dev Base contract which allows children to implement an emergency stop mechanism.
85  */
86 contract Pausable is Ownable {
87   event Pause();
88   event Unpause();
89 
90   bool public paused = false;
91 
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is not paused.
95    */
96   modifier whenNotPaused() {
97     require(!paused);
98     _;
99   }
100 
101   /**
102    * @dev Modifier to make a function callable only when the contract is paused.
103    */
104   modifier whenPaused() {
105     require(paused);
106     _;
107   }
108 
109   /**
110    * @dev called by the owner to pause, triggers stopped state
111    */
112   function pause() onlyOwner whenNotPaused public {
113     paused = true;
114     Pause();
115   }
116 
117   /**
118    * @dev called by the owner to unpause, returns to normal state
119    */
120   function unpause() onlyOwner whenPaused public {
121     paused = false;
122     Unpause();
123   }
124 }
125 
126 /**
127  * @title ERC20Basic
128  * @dev Simpler version of ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/179
130  */
131 contract ERC20Basic {
132   uint256 public totalSupply;
133   function balanceOf(address who) public view returns (uint256);
134   function transfer(address to, uint256 value) public returns (bool);
135   event Transfer(address indexed from, address indexed to, uint256 value);
136 }
137 
138 /**
139  * @title Basic token
140  * @dev Basic version of StandardToken, with no allowances.
141  */
142 contract BasicToken is ERC20Basic {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[msg.sender]);
155 
156     // SafeMath.sub will throw if there is not enough balance.
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256 balance) {
169     return balances[_owner];
170   }
171 }
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    */
246   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
247     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 /**
266  * @title Pausable token
267  *
268  * @dev StandardToken modified with pausable transfers.
269  **/
270 contract PausableToken is StandardToken, Pausable {
271 
272   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
273     return super.transfer(_to, _value);
274   }
275 
276   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
277     return super.transferFrom(_from, _to, _value);
278   }
279 
280   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
281     return super.approve(_spender, _value);
282   }
283 
284   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
285     return super.increaseApproval(_spender, _addedValue);
286   }
287 
288   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
289     return super.decreaseApproval(_spender, _subtractedValue);
290   }
291 }
292 
293 /**
294  * @title RefundVault
295  * @dev This contract is used for storing funds while a crowdsale
296  * is in progress. Supports refunding the money if crowdsale fails,
297  * and forwarding it if crowdsale is successful.
298  */
299 contract RefundVault is Ownable {
300   using SafeMath for uint256;
301 
302   enum State { Active, Refunding, Closed }
303 
304   mapping (address => uint256) public deposited;
305   address public wallet;
306   State public state;
307 
308   event Closed();
309   event RefundsEnabled();
310   event Refunded(address indexed beneficiary, uint256 weiAmount);
311 
312   function RefundVault(address _wallet) public {
313     require(_wallet != address(0));
314     wallet = _wallet;
315     state = State.Active;
316   }
317 
318   function deposit(address investor) onlyOwner public payable {
319     require(state == State.Active);
320     deposited[investor] = deposited[investor].add(msg.value);
321   }
322 
323   function close() onlyOwner public {
324     require(state == State.Active);
325     state = State.Closed;
326     Closed();
327     wallet.transfer(this.balance);
328   }
329 
330   function enableRefunds() onlyOwner public {
331     require(state == State.Active);
332     state = State.Refunding;
333     RefundsEnabled();
334   }
335 
336   function refund(address investor) public {
337     require(state == State.Refunding);
338     uint256 depositedValue = deposited[investor];
339     deposited[investor] = 0;
340     investor.transfer(depositedValue);
341     Refunded(investor, depositedValue);
342   }
343 }
344 
345 //*****************************************************
346 // *   BoomrCoinCrowdsale
347 // *   Info:
348 //     - Sale will be for 30% (150M of 500) of total tokens
349 //     - Funding during presale determines price
350 //     - Times are in UTC (seconds since Jan 1 1970)
351 //
352 //*****************************************************
353 contract BoomrCoinCrowdsale is Ownable{
354   using SafeMath for uint256;
355 
356   //***************************************************
357   //  Settings
358   //***************************************************
359 
360   // minimum amount of funds to be raised in weis
361   uint256 private minGoal = 0;
362 
363   // maximum amount of funds to be raised in weis
364   uint256 private maxGoal = 0;
365 
366   // Tokens for presale
367   uint256 private tokenLimitPresale    =  0;
368 
369   // Tokens for crowdsale
370   uint256 private tokenLimitCrowdsale  = 0;
371 
372   // Presale discount for each phase
373   uint256 private presaleDiscount    = 0;
374   uint256 private crowdsaleDiscount1 = 0;
375   uint256 private crowdsaleDiscount2 = 0;
376   uint256 private crowdsaleDiscount3 = 0;
377   uint256 private crowdsaleDiscount4 = 0;
378 
379   // durations for each phase
380   uint256 private  presaleDuration    = 0;//604800; // One Week in seconds
381   uint256 private  crowdsaleDuration1 = 0;//604800; // One Week in seconds
382   uint256 private  crowdsaleDuration2 = 0;//604800; // One Week in seconds
383   uint256 private  crowdsaleDuration3 = 0;//604800; // One Week in seconds
384   uint256 private  crowdsaleDuration4 = 0;//604800; // One Week in seconds
385 
386   //***************************************************
387   //  Info
388   //***************************************************
389 
390   // Tokens Sold
391   uint256 private tokenPresaleTotalSold  = 0;
392   uint256 private tokenCrowdsaleTotalSold  = 0;
393 
394   // Backers
395   uint256 private totalBackers  = 0;
396 
397   // amount of raised money in wei
398   uint256 private weiRaised = 0;
399 
400   // prices for each phase
401   uint256 private presaleTokenPrice    = 0;
402   uint256 private baseTokenPrice = 0;
403   uint256 private crowdsaleTokenPrice1 = 0;
404   uint256 private crowdsaleTokenPrice2 = 0;
405   uint256 private crowdsaleTokenPrice3 = 0;
406   uint256 private crowdsaleTokenPrice4 = 0;
407 
408   // Count of token distributions by phase
409   uint256 private presaleTokenSent     = 0;
410   uint256 private crowdsaleTokenSold1  = 0;
411   uint256 private crowdsaleTokenSold2  = 0;
412   uint256 private crowdsaleTokenSold3  = 0;
413   uint256 private crowdsaleTokenSold4  = 0;
414 
415   //***************************************************
416   //  Vars
417   //***************************************************
418 
419   // Finalization Flag
420   bool private finalized = false;
421 
422   // Halted Flag
423   bool private halted = false;
424 
425   uint256 public startTime;
426 
427   // The token being sold
428   PausableToken public boomrToken;
429 
430   // Address where funds are collected
431   address private wallet;
432 
433   // refund vault used to hold funds while crowdsale is running
434   RefundVault private vault;
435 
436   // tracking for deposits
437   mapping (address => uint256) public deposits;
438 
439   // tracking for purchasers
440   mapping (address => uint256) public purchases;
441 
442   //***************************************************
443   //  Events
444   //***************************************************
445 
446   // Log event for crowdsale purchase
447   event TokenPurchase(address indexed Purchaser, address indexed Beneficiary, uint256 ValueInWei, uint256 TokenAmount);
448 
449   // Log event for presale purchase
450   event PresalePurchase(address indexed Purchaser, address indexed Beneficiary, uint256 ValueInWei);
451 
452   // Log event for distribution of tokens for presale purchasers
453   event PresaleDistribution(address indexed Purchaser, address indexed Beneficiary, uint256 TokenAmount);
454 
455   // Finalization
456   event Finalized();
457 
458   //***************************************************
459   //  Constructor
460   //***************************************************
461   function BoomrCoinCrowdsale() public{
462 
463   }
464 
465   function StartCrowdsale(address _token, address _wallet, uint256 _startTime) public onlyOwner{
466     require(_startTime >= now);
467     require(_token != 0x0);
468     require(_wallet != 0x0);
469 
470     // Set the start time
471     startTime = _startTime;
472 
473     // Assign the token
474     boomrToken = PausableToken(_token);
475 
476     // Wallet for funds
477     wallet = _wallet;
478 
479     // Refund vault
480     vault = new RefundVault(wallet);
481 
482     // minimum amount of funds to be raised in weis
483     minGoal = 5000 * 10**18; // Approx 3.5M Dollars
484     //minGoal = 1 * 10**18; // testing
485 
486     // maximum amount of funds to be raised in weis
487     maxGoal = 28600 * 10**18; // Approx 20M Dollars
488     //maxGoal = 16 * 10**18; // teesting
489 
490     // Tokens for presale
491     tokenLimitPresale    =  30000000 * 10**18;
492     //uint256 tokenLimitPresale    =  5 * 10**18;  // for testing
493 
494     // Tokens for crowdsale
495     tokenLimitCrowdsale  = 120000000 * 10**18;
496     //uint256 tokenLimitCrowdsale  = 5 * 10**18;
497 
498     // Presale discount for each phase
499     presaleDiscount    = 25 * 10**16;  // 25%
500     crowdsaleDiscount1 = 15 * 10**16;  // 15%
501     crowdsaleDiscount2 = 10 * 10**16;  // 10%
502     crowdsaleDiscount3 =  5 * 10**16;  //  5%
503     crowdsaleDiscount4 =           0;  //  0%
504 
505     // durations for each phase
506     presaleDuration    = 604800; // One Week in seconds
507     crowdsaleDuration1 = 604800; // One Week in seconds
508     crowdsaleDuration2 = 604800; // One Week in seconds
509     crowdsaleDuration3 = 604800; // One Week in seconds
510     crowdsaleDuration4 = 604800; // One Week in seconds
511 
512   }
513 
514   //***************************************************
515   //  Runtime state checks
516   //***************************************************
517 
518   function currentStateActive() public constant returns ( bool presaleWaitPhase,
519                                                           bool presalePhase,
520                                                           bool crowdsalePhase1,
521                                                           bool crowdsalePhase2,
522                                                           bool crowdsalePhase3,
523                                                           bool crowdsalePhase4,
524                                                           bool buyable,
525                                                           bool distributable,
526                                                           bool reachedMinimumEtherGoal,
527                                                           bool reachedMaximumEtherGoal,
528                                                           bool completed,
529                                                           bool finalizedAndClosed,
530                                                           bool stopped){
531 
532     return (  isPresaleWaitPhase(),
533               isPresalePhase(),
534               isCrowdsalePhase1(),
535               isCrowdsalePhase2(),
536               isCrowdsalePhase3(),
537               isCrowdsalePhase4(),
538               isBuyable(),
539               isDistributable(),
540               minGoalReached(),
541               maxGoalReached(),
542               isCompleted(),
543               finalized,
544               halted);
545   }
546 
547   function currentStateSales() public constant returns (uint256 PresaleTokenPrice,
548                                                         uint256 BaseTokenPrice,
549                                                         uint256 CrowdsaleTokenPrice1,
550                                                         uint256 CrowdsaleTokenPrice2,
551                                                         uint256 CrowdsaleTokenPrice3,
552                                                         uint256 CrowdsaleTokenPrice4,
553                                                         uint256 TokenPresaleTotalSold,
554                                                         uint256 TokenCrowdsaleTotalSold,
555                                                         uint256 TotalBackers,
556                                                         uint256 WeiRaised,
557                                                         address Wallet,
558                                                         uint256 GoalInWei,
559                                                         uint256 RemainingTokens){
560 
561     return (  presaleTokenPrice,
562               baseTokenPrice,
563               crowdsaleTokenPrice1,
564               crowdsaleTokenPrice2,
565               crowdsaleTokenPrice3,
566               crowdsaleTokenPrice4,
567               tokenPresaleTotalSold,
568               tokenCrowdsaleTotalSold,
569               totalBackers,
570               weiRaised,
571               wallet,
572               minGoal,
573               getContractTokenBalance());
574 
575   }
576 
577   function currentTokenDistribution() public constant returns (uint256 PresalePhaseTokens,
578                                                                uint256 CrowdsalePhase1Tokens,
579                                                                uint256 CrowdsalePhase2Tokens,
580                                                                uint256 CrowdsalePhase3Tokens,
581                                                                uint256 CrowdsalePhase4Tokens){
582 
583     return (  presaleTokenSent,
584               crowdsaleTokenSold1,
585               crowdsaleTokenSold2,
586               crowdsaleTokenSold3,
587               crowdsaleTokenSold4);
588 
589   }
590 
591   function isPresaleWaitPhase() internal constant returns (bool){
592     return startTime >= now;
593   }
594 
595   function isPresalePhase() internal constant returns (bool){
596     return startTime < now && (startTime + presaleDuration) >= now && !maxGoalReached();
597   }
598 
599   function isCrowdsalePhase1() internal constant returns (bool){
600     return (startTime + presaleDuration) < now && (startTime + presaleDuration + crowdsaleDuration1) >= now && !maxGoalReached();
601   }
602 
603   function isCrowdsalePhase2() internal constant returns (bool){
604     return (startTime + presaleDuration + crowdsaleDuration1) < now && (startTime + presaleDuration + crowdsaleDuration1 + crowdsaleDuration2) >= now && !maxGoalReached();
605   }
606 
607   function isCrowdsalePhase3() internal constant returns (bool){
608     return (startTime + presaleDuration + crowdsaleDuration1 + crowdsaleDuration2) < now && (startTime + presaleDuration + crowdsaleDuration1 + crowdsaleDuration2 + crowdsaleDuration3) >= now && !maxGoalReached();
609   }
610 
611   function isCrowdsalePhase4() internal constant returns (bool){
612     return (startTime + presaleDuration + crowdsaleDuration1 + crowdsaleDuration2 + crowdsaleDuration3) < now && (startTime + presaleDuration + crowdsaleDuration1 + crowdsaleDuration2 + crowdsaleDuration3 + crowdsaleDuration4) >= now && !maxGoalReached();
613   }
614 
615   function isCompleted() internal constant returns (bool){
616     return (startTime + presaleDuration + crowdsaleDuration1 + crowdsaleDuration2 + crowdsaleDuration3 + crowdsaleDuration4) < now || maxGoalReached();
617   }
618 
619   function isDistributable() internal constant returns (bool){
620     return (startTime + presaleDuration) < now;
621   }
622 
623   function isBuyable() internal constant returns (bool){
624     return isDistributable() && !isCompleted();
625   }
626 
627   // Test if we reached the goals
628   function minGoalReached() internal constant returns (bool) {
629     return weiRaised >= minGoal;
630   }
631 
632   function maxGoalReached() internal constant returns (bool) {
633     return weiRaised >= maxGoal;
634   }
635 
636   //***************************************************
637   //  Contract's token balance
638   //***************************************************
639   function getContractTokenBalance() internal constant returns (uint256) {
640     return boomrToken.balanceOf(this);
641   }
642 
643   //***************************************************
644   //  Emergency functions
645   //***************************************************
646   function halt() public onlyOwner{
647     halted = true;
648   }
649 
650   function unHalt() public onlyOwner{
651     halted = false;
652   }
653 
654   //***************************************************
655   //  Update all the prices
656   //***************************************************
657   function updatePrices() internal {
658 
659     presaleTokenPrice = weiRaised.mul(1 ether).div(tokenLimitPresale);
660     baseTokenPrice = (presaleTokenPrice * (1 ether)) / ((1 ether) - presaleDiscount);
661     crowdsaleTokenPrice1 = baseTokenPrice - ((baseTokenPrice * crowdsaleDiscount1)/(1 ether));
662     crowdsaleTokenPrice2 = baseTokenPrice - ((baseTokenPrice * crowdsaleDiscount2)/(1 ether));
663     crowdsaleTokenPrice3 = baseTokenPrice - ((baseTokenPrice * crowdsaleDiscount3)/(1 ether));
664     crowdsaleTokenPrice4 = baseTokenPrice - ((baseTokenPrice * crowdsaleDiscount4)/(1 ether));
665   }
666 
667   //***************************************************
668   //  Default presale and token purchase
669   //***************************************************
670   function () public payable{
671     if(msg.value == 0 && isDistributable())
672     {
673       distributePresale(msg.sender);
674     }else{
675       require(!isPresaleWaitPhase() && !isCompleted());
676 
677       // Select purchase action
678       if (isPresalePhase()){
679 
680         // Presale deposit
681         depositPresale(msg.sender);
682 
683       }else{
684         // Buy the tokens
685         buyTokens(msg.sender);
686       }
687     }
688   }
689 
690   //***************************************************
691   //  Low level deposit
692   //***************************************************
693   function depositPresale(address beneficiary) public payable{
694     internalDepositPresale(beneficiary, msg.value);
695   }
696 
697   function internalDepositPresale(address beneficiary, uint256 deposit) internal{
698     require(!halted);
699     require(beneficiary != 0x0);
700     require(deposit != 0);
701     require(isPresalePhase());
702     require(!maxGoalReached());
703 
704     // Amount invested
705     uint256 weiAmount = deposit;
706 
707     // If real deposit from person then forward funds
708     // otherwise it was from the manual routine for external
709     // deposits that were made in fiat instead of ether
710     if (msg.value > 0)
711     {
712       // Send funds to main wallet
713       forwardFunds();
714     }
715 
716     // Total innvested so far
717     weiRaised = weiRaised.add(weiAmount);
718 
719     // Mark the deposits, add if they deposit more than once
720     deposits[beneficiary] += weiAmount;
721     totalBackers++;
722 
723     // Determine the current price
724     updatePrices();
725 
726     // emit event for logging
727     PresalePurchase(msg.sender, beneficiary, weiAmount);
728   }
729 
730   //***************************************************
731   //  Token distribution for presale purchasers
732   //***************************************************
733   function distributePresale(address beneficiary) public{
734     require(!halted);
735     require(isDistributable());
736     require(deposits[beneficiary] > 0);
737     require(beneficiary != 0x0);
738 
739     // Amount investesd
740     uint256 weiDeposit = deposits[beneficiary];
741 
742     // prevent re-entrancy
743     deposits[beneficiary] = 0;
744 
745     // tokens out
746     uint256 tokensOut = weiDeposit.mul(1 ether).div(presaleTokenPrice);
747 
748     //trackTokens(tokensOut, index);
749     tokenPresaleTotalSold += tokensOut;
750     //presaleTokenSent += tokensOut;
751 
752     // transfer tokens
753     boomrToken.transfer(beneficiary, tokensOut);
754 
755     // emit event for logging
756     PresaleDistribution(msg.sender, beneficiary, tokensOut);
757   }
758 
759   //***************************************************
760   //  Low level purchase
761   //***************************************************
762   function buyTokens(address beneficiary) public payable{
763     internalBuyTokens(beneficiary, msg.value);
764   }
765 
766   function internalBuyTokens(address beneficiary, uint256 deposit) internal{
767     require(!halted);
768     require(beneficiary != 0x0);
769     require(deposit != 0);
770     require(isCrowdsalePhase1() || isCrowdsalePhase2() || isCrowdsalePhase3() || isCrowdsalePhase4());
771     require(!maxGoalReached());
772 
773     uint256 price = 0;
774 
775     if (isCrowdsalePhase1()){
776       price = crowdsaleTokenPrice1;
777     }else if (isCrowdsalePhase2()){
778       price = crowdsaleTokenPrice2;
779     }else if (isCrowdsalePhase3()){
780       price = crowdsaleTokenPrice3;
781     }else if (isCrowdsalePhase4()){
782       price = crowdsaleTokenPrice4;
783     }else{
784       price = baseTokenPrice;
785     }
786 
787     // Amount of ether sent
788     uint256 weiAmount = deposit;
789 
790     // calculate reward
791     uint256 tokensOut = weiAmount.mul(1 ether).div(price);
792 
793     // make sure we are not over sold
794     require(tokensOut + tokenCrowdsaleTotalSold < tokenLimitCrowdsale);
795 
796     // If real deposit from person then forward funds
797     // otherwise it was from the manual routine for external
798     // deposits that were made in fiat instead of ether
799     if (msg.value > 0)
800     {
801       // Send funds to main wallet
802       forwardFunds();
803     }
804 
805     // Update raised
806     weiRaised = weiRaised.add(weiAmount);
807 
808     // Track purchases
809     purchases[beneficiary] += weiRaised;
810 
811     // track issued
812     tokenCrowdsaleTotalSold += tokensOut;
813 
814     if (isCrowdsalePhase1()){
815       crowdsaleTokenSold1 += tokensOut;
816     }else if (isCrowdsalePhase2()){
817       crowdsaleTokenSold2 += tokensOut;
818     }else if (isCrowdsalePhase3()){
819       crowdsaleTokenSold3 += tokensOut;
820     }else if (isCrowdsalePhase4()){
821       crowdsaleTokenSold4 += tokensOut;
822     }
823 
824     // Send to buyers
825     boomrToken.transfer(beneficiary, tokensOut);
826 
827     // Emit event for logging
828     TokenPurchase(msg.sender, beneficiary, weiAmount, tokensOut);
829 
830     // Track the backers
831     totalBackers++;
832   }
833 
834   // For deposits that do not come thru the contract
835   function externalDeposit(address beneficiary, uint256 amount) public onlyOwner{
836       require(!isPresaleWaitPhase() && !isCompleted());
837 
838       // Select purchase action
839       if (isPresalePhase()){
840 
841         // Presale deposit
842         internalDepositPresale(beneficiary, amount);
843 
844       }else{
845         // Buy the tokens
846         internalBuyTokens(beneficiary, amount);
847       }
848   }
849 
850   // send ether to the fund collection wallet
851   // override to create custom fund forwarding mechanisms
852   function forwardFunds() internal {
853     //wallet.transfer(msg.value);
854     vault.deposit.value(msg.value)(msg.sender);
855   }
856 
857     // if crowdsale is unsuccessful, investors can claim refunds here
858   function claimRefund() public{
859     require(!halted);
860     require(finalized);
861     require(!minGoalReached());
862 
863     vault.refund(msg.sender);
864   }
865 
866   // Should be called after crowdsale ends, to do
867   // some extra finalization work
868   function finalize() public onlyOwner{
869     require(!finalized);
870     require(isCompleted());
871 
872     if (minGoalReached()) {
873       vault.close();
874     } else {
875       vault.enableRefunds();
876     }
877 
878     finalized = true;
879     Finalized();
880   }
881 }