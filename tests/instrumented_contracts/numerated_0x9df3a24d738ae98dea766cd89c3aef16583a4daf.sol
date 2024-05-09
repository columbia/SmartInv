1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply_ = totalSupply_.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
310 
311 /**
312  * @title Pausable
313  * @dev Base contract which allows children to implement an emergency stop mechanism.
314  */
315 contract Pausable is Ownable {
316   event Pause();
317   event Unpause();
318 
319   bool public paused = false;
320 
321 
322   /**
323    * @dev Modifier to make a function callable only when the contract is not paused.
324    */
325   modifier whenNotPaused() {
326     require(!paused);
327     _;
328   }
329 
330   /**
331    * @dev Modifier to make a function callable only when the contract is paused.
332    */
333   modifier whenPaused() {
334     require(paused);
335     _;
336   }
337 
338   /**
339    * @dev called by the owner to pause, triggers stopped state
340    */
341   function pause() onlyOwner whenNotPaused public {
342     paused = true;
343     Pause();
344   }
345 
346   /**
347    * @dev called by the owner to unpause, returns to normal state
348    */
349   function unpause() onlyOwner whenPaused public {
350     paused = false;
351     Unpause();
352   }
353 }
354 
355 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
356 
357 /**
358  * @title Pausable token
359  * @dev StandardToken modified with pausable transfers.
360  **/
361 contract PausableToken is StandardToken, Pausable {
362 
363   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
364     return super.transfer(_to, _value);
365   }
366 
367   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
368     return super.transferFrom(_from, _to, _value);
369   }
370 
371   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
372     return super.approve(_spender, _value);
373   }
374 
375   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
376     return super.increaseApproval(_spender, _addedValue);
377   }
378 
379   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
380     return super.decreaseApproval(_spender, _subtractedValue);
381   }
382 }
383 
384 // File: contracts/LifToken.sol
385 
386 /**
387    @title Líf, the Winding Tree token
388 
389    Implementation of Líf, the ERC827 token for Winding Tree, an extension of the
390    ERC20 token with extra methods to transfer value and data to execute a call
391    on transfer.
392    Uses OpenZeppelin StandardToken, ERC827Token, MintableToken and PausableToken.
393  */
394 contract LifToken is StandardToken, MintableToken, PausableToken {
395   // Token Name
396   string public constant NAME = "Líf";
397 
398   // Token Symbol
399   string public constant SYMBOL = "LIF";
400 
401   // Token decimals
402   uint public constant DECIMALS = 18;
403 
404   /**
405    * @dev Burns a specific amount of tokens.
406    *
407    * @param _value The amount of tokens to be burned.
408    */
409   function burn(uint256 _value) public whenNotPaused {
410 
411     require(_value <= balances[msg.sender]);
412 
413     balances[msg.sender] = balances[msg.sender].sub(_value);
414     totalSupply_ = totalSupply_.sub(_value);
415 
416     // a Transfer event to 0x0 can be useful for observers to keep track of
417     // all the Lif by just looking at those events
418     Transfer(msg.sender, address(0), _value);
419   }
420 
421   /**
422    * @dev Burns a specific amount of tokens of an address
423    * This function can be called only by the owner in the minting process
424    *
425    * @param _value The amount of tokens to be burned.
426    */
427   function burn(address burner, uint256 _value) public onlyOwner {
428 
429     require(!mintingFinished);
430 
431     require(_value <= balances[burner]);
432 
433     balances[burner] = balances[burner].sub(_value);
434     totalSupply_ = totalSupply_.sub(_value);
435 
436     // a Transfer event to 0x0 can be useful for observers to keep track of
437     // all the Lif by just looking at those events
438     Transfer(burner, address(0), _value);
439   }
440 }
441 
442 // File: contracts/LifMarketValidationMechanism.sol
443 
444 /**
445    @title Market Validation Mechanism (MVM)
446  */
447 contract LifMarketValidationMechanism is Ownable {
448   using SafeMath for uint256;
449 
450   // The Lif token contract
451   LifToken public lifToken;
452 
453   // The address of the foundation wallet. It can claim part of the eth funds
454   // following an exponential curve until the end of the MVM lifetime (24 or 48
455   // months). After that it can claim 100% of the remaining eth in the MVM.
456   address public foundationAddr;
457 
458   // The amount of wei that the MVM received initially
459   uint256 public initialWei;
460 
461   // Start timestamp since which the MVM begins to accept tokens via sendTokens
462   uint256 public startTimestamp;
463 
464   // Quantity of seconds in every period, usually equivalent to 30 days
465   uint256 public secondsPerPeriod;
466 
467   // Number of periods. It should be 24 or 48 (each period is roughly a month)
468   uint8 public totalPeriods;
469 
470   // The total amount of wei that was claimed by the foundation so far
471   uint256 public totalWeiClaimed = 0;
472 
473   // The price at which the MVM buys tokens at the beginning of its lifetime
474   uint256 public initialBuyPrice = 0;
475 
476   // Amount of tokens that were burned by the MVM
477   uint256 public totalBurnedTokens = 0;
478 
479   // Amount of wei that was reimbursed via sendTokens calls
480   uint256 public totalReimbursedWei = 0;
481 
482   // Total supply of tokens when the MVM was created
483   uint256 public originalTotalSupply;
484 
485   uint256 constant PRICE_FACTOR = 100000;
486 
487   // Has the MVM been funded by calling `fund`? It can be funded only once
488   bool public funded = false;
489 
490   // true when the market MVM is paused
491   bool public paused = false;
492 
493   // total amount of seconds that the MVM was paused
494   uint256 public totalPausedSeconds = 0;
495 
496   // the timestamp where the MVM was paused
497   uint256 public pausedTimestamp;
498 
499   uint256[] public periods;
500 
501   // Events
502   event Pause();
503   event Unpause(uint256 pausedSeconds);
504 
505   event ClaimedWei(uint256 claimedWei);
506   event SentTokens(address indexed sender, uint256 price, uint256 tokens, uint256 returnedWei);
507 
508   modifier whenNotPaused(){
509     assert(!paused);
510     _;
511   }
512 
513   modifier whenPaused(){
514     assert(paused);
515     _;
516   }
517 
518   /**
519      @dev Constructor
520 
521      @param lifAddr the lif token address
522      @param _startTimestamp see `startTimestamp`
523      @param _secondsPerPeriod see `secondsPerPeriod`
524      @param _totalPeriods see `totalPeriods`
525      @param _foundationAddr see `foundationAddr`
526     */
527   function LifMarketValidationMechanism(
528     address lifAddr, uint256 _startTimestamp, uint256 _secondsPerPeriod,
529     uint8 _totalPeriods, address _foundationAddr
530   ) {
531     require(lifAddr != address(0));
532     require(_startTimestamp > block.timestamp);
533     require(_secondsPerPeriod > 0);
534     require(_totalPeriods == 24 || _totalPeriods == 48);
535     require(_foundationAddr != address(0));
536 
537     lifToken = LifToken(lifAddr);
538     startTimestamp = _startTimestamp;
539     secondsPerPeriod = _secondsPerPeriod;
540     totalPeriods = _totalPeriods;
541     foundationAddr = _foundationAddr;
542 
543   }
544 
545   /**
546      @dev Receives the initial funding from the Crowdsale. Calculates the
547      initial buy price as initialWei / totalSupply
548     */
549   function fund() public payable onlyOwner {
550     assert(!funded);
551 
552     originalTotalSupply = lifToken.totalSupply();
553     initialWei = msg.value;
554     initialBuyPrice = initialWei.
555       mul(PRICE_FACTOR).
556       div(originalTotalSupply);
557 
558     funded = true;
559   }
560 
561   /**
562      @dev Change the LifToken address
563     */
564   function changeToken(address newToken) public onlyOwner {
565     lifToken = LifToken(newToken);
566   }
567 
568   /**
569      @dev calculates the exponential distribution curve. It determines how much
570      wei can be distributed back to the foundation every month. It starts with
571      very low amounts ending with higher chunks at the end of the MVM lifetime
572     */
573   function calculateDistributionPeriods() public {
574     assert(totalPeriods == 24 || totalPeriods == 48);
575     assert(periods.length == 0);
576 
577     // Table with the max delta % that can be distributed back to the foundation on
578     // each period. It follows an exponential curve (starts with lower % and ends
579     // with higher %) to keep the funds in the MVM longer. deltas24
580     // is used when MVM lifetime is 24 months, deltas48 when it's 48 months.
581     // The sum is less than 100% because the last % is missing: after the last period
582     // the 100% remaining can be claimed by the foundation. Values multipled by 10^5
583 
584     uint256[24] memory accumDistribution24 = [
585       uint256(0), 18, 117, 351, 767, 1407,
586       2309, 3511, 5047, 6952, 9257, 11995,
587       15196, 18889, 23104, 27870, 33215, 39166,
588       45749, 52992, 60921, 69561, 78938, 89076
589     ];
590 
591     uint256[48] memory accumDistribution48 = [
592       uint256(0), 3, 18, 54, 117, 214, 351, 534,
593       767, 1056, 1406, 1822, 2308, 2869, 3510, 4234,
594       5046, 5950, 6950, 8051, 9256, 10569, 11994, 13535,
595       15195, 16978, 18888, 20929, 23104, 25416, 27870, 30468,
596       33214, 36112, 39165, 42376, 45749, 49286, 52992, 56869,
597       60921, 65150, 69560, 74155, 78937, 83909, 89075, 94438
598     ];
599 
600     for (uint8 i = 0; i < totalPeriods; i++) {
601 
602       if (totalPeriods == 24) {
603         periods.push(accumDistribution24[i]);
604       } else {
605         periods.push(accumDistribution48[i]);
606       }
607 
608     }
609   }
610 
611   /**
612      @dev Returns the current period as a number from 0 to totalPeriods
613 
614      @return the current period as a number from 0 to totalPeriods
615     */
616   function getCurrentPeriodIndex() public view returns(uint256) {
617     assert(block.timestamp >= startTimestamp);
618     return block.timestamp.sub(startTimestamp).
619       sub(totalPausedSeconds).
620       div(secondsPerPeriod);
621   }
622 
623   /**
624      @dev calculates the accumulated distribution percentage as of now,
625      following the exponential distribution curve
626 
627      @return the accumulated distribution percentage, used to calculate things
628      like the maximum amount that can be claimed by the foundation
629     */
630   function getAccumulatedDistributionPercentage() public view returns(uint256 percentage) {
631     uint256 period = getCurrentPeriodIndex();
632 
633     assert(period < totalPeriods);
634 
635     return periods[period];
636   }
637 
638   /**
639      @dev returns the current buy price at which the MVM offers to buy tokens to
640      burn them
641 
642      @return the current buy price (in eth/lif, multiplied by PRICE_FACTOR)
643     */
644   function getBuyPrice() public view returns (uint256 price) {
645     uint256 accumulatedDistributionPercentage = getAccumulatedDistributionPercentage();
646 
647     return initialBuyPrice.
648       mul(PRICE_FACTOR.sub(accumulatedDistributionPercentage)).
649       div(PRICE_FACTOR);
650   }
651 
652   /**
653      @dev Returns the maximum amount of wei that the foundation can claim. It's
654      a portion of the ETH that was not claimed by token holders
655 
656      @return the maximum wei claimable by the foundation as of now
657     */
658   function getMaxClaimableWeiAmount() public view returns (uint256) {
659     if (isFinished()) {
660       return this.balance;
661     } else {
662       uint256 claimableFromReimbursed = initialBuyPrice.
663         mul(totalBurnedTokens).div(PRICE_FACTOR).
664         sub(totalReimbursedWei);
665       uint256 currentCirculation = lifToken.totalSupply();
666       uint256 accumulatedDistributionPercentage = getAccumulatedDistributionPercentage();
667       uint256 maxClaimable = initialWei.
668         mul(accumulatedDistributionPercentage).div(PRICE_FACTOR).
669         mul(currentCirculation).div(originalTotalSupply).
670         add(claimableFromReimbursed);
671 
672       if (maxClaimable > totalWeiClaimed) {
673         return maxClaimable.sub(totalWeiClaimed);
674       } else {
675         return 0;
676       }
677     }
678   }
679 
680   /**
681      @dev allows to send tokens to the MVM in exchange of Eth at the price
682      determined by getBuyPrice. The tokens are burned
683     */
684   function sendTokens(uint256 tokens) public whenNotPaused {
685     require(tokens > 0);
686 
687     uint256 price = getBuyPrice();
688     uint256 totalWei = tokens.mul(price).div(PRICE_FACTOR);
689 
690     lifToken.transferFrom(msg.sender, address(this), tokens);
691     lifToken.burn(tokens);
692     totalBurnedTokens = totalBurnedTokens.add(tokens);
693 
694     SentTokens(msg.sender, price, tokens, totalWei);
695 
696     totalReimbursedWei = totalReimbursedWei.add(totalWei);
697     msg.sender.transfer(totalWei);
698   }
699 
700   /**
701      @dev Returns whether the MVM end-of-life has been reached. When that
702      happens no more tokens can be sent to the MVM and the foundation can claim
703      100% of the remaining balance in the MVM
704 
705      @return true if the MVM end-of-life has been reached
706     */
707   function isFinished() public view returns (bool finished) {
708     return getCurrentPeriodIndex() >= totalPeriods;
709   }
710 
711   /**
712      @dev Called from the foundation wallet to claim eth back from the MVM.
713      Maximum amount that can be claimed is determined by
714      getMaxClaimableWeiAmount
715     */
716   function claimWei(uint256 weiAmount) public whenNotPaused {
717     require(msg.sender == foundationAddr);
718 
719     uint256 claimable = getMaxClaimableWeiAmount();
720 
721     assert(claimable >= weiAmount);
722 
723     foundationAddr.transfer(weiAmount);
724 
725     totalWeiClaimed = totalWeiClaimed.add(weiAmount);
726 
727     ClaimedWei(weiAmount);
728   }
729 
730   /**
731      @dev Pauses the MVM. No tokens can be sent to the MVM and no eth can be
732      claimed from the MVM while paused. MVM total lifetime is extended by the
733      period it stays paused
734     */
735   function pause() public onlyOwner whenNotPaused {
736     paused = true;
737     pausedTimestamp = block.timestamp;
738 
739     Pause();
740   }
741 
742   /**
743      @dev Unpauses the MVM. See `pause` for more details about pausing
744     */
745   function unpause() public onlyOwner whenPaused {
746     uint256 pausedSeconds = block.timestamp.sub(pausedTimestamp);
747     totalPausedSeconds = totalPausedSeconds.add(pausedSeconds);
748     paused = false;
749 
750     Unpause(pausedSeconds);
751   }
752 
753 }
754 
755 // File: contracts/VestedPayment.sol
756 
757 /**
758    @title Vested Payment Schedule for LifToken
759 
760    An ownable vesting schedule for the LifToken, the tokens can only be
761    claimed by the owner. The contract has a start timestamp, a duration
762    of each period in seconds (it can be days, months, years), a total
763    amount of periods and a cliff. The available amount of tokens will
764    be calculated based on the balance of LifTokens of the contract at
765    that time.
766  */
767 
768 contract VestedPayment is Ownable {
769   using SafeMath for uint256;
770 
771   // When the vested schedule starts
772   uint256 public startTimestamp;
773 
774   // How many seconds each period will last
775   uint256 public secondsPerPeriod;
776 
777   // How many periods will have in total
778   uint256 public totalPeriods;
779 
780   // The amount of tokens to be vested in total
781   uint256 public tokens;
782 
783   // How many tokens were claimed
784   uint256 public claimed;
785 
786   // The token contract
787   LifToken public token;
788 
789   // Duration (in periods) of the initial cliff in the vesting schedule
790   uint256 public cliffDuration;
791 
792   /**
793      @dev Constructor.
794 
795      @param _startTimestamp see `startTimestamp`
796      @param _secondsPerPeriod see `secondsPerPeriod`
797      @param _totalPeriods see `totalPeriods
798      @param _cliffDuration see `cliffDuration`
799      @param _tokens see `tokens`
800      @param tokenAddress the address of the token contract
801    */
802   function VestedPayment(
803     uint256 _startTimestamp, uint256 _secondsPerPeriod,
804     uint256 _totalPeriods, uint256 _cliffDuration,
805     uint256 _tokens, address tokenAddress
806   ) {
807     require(_startTimestamp >= block.timestamp);
808     require(_secondsPerPeriod > 0);
809     require(_totalPeriods > 0);
810     require(tokenAddress != address(0));
811     require(_cliffDuration < _totalPeriods);
812     require(_tokens > 0);
813 
814     startTimestamp = _startTimestamp;
815     secondsPerPeriod = _secondsPerPeriod;
816     totalPeriods = _totalPeriods;
817     cliffDuration = _cliffDuration;
818     tokens = _tokens;
819     token = LifToken(tokenAddress);
820   }
821 
822   /**
823      @dev Change the LifToken address
824     */
825   function changeToken(address newToken) public onlyOwner {
826     token = LifToken(newToken);
827   }
828 
829   /**
830      @dev Get how many tokens are available to be claimed
831    */
832   function getAvailableTokens() public view returns (uint256) {
833     uint256 period = block.timestamp.sub(startTimestamp)
834       .div(secondsPerPeriod);
835 
836     if (period < cliffDuration) {
837       return 0;
838     } else if (period >= totalPeriods) {
839       return tokens.sub(claimed);
840     } else {
841       return tokens.mul(period.add(1)).div(totalPeriods).sub(claimed);
842     }
843   }
844 
845   /**
846      @dev Claim the tokens, they can be claimed only by the owner
847      of the contract
848 
849      @param amount how many tokens to be claimed
850    */
851   function claimTokens(uint256 amount) public onlyOwner {
852     assert(getAvailableTokens() >= amount);
853 
854     claimed = claimed.add(amount);
855     token.transfer(owner, amount);
856   }
857 
858 }
859 
860 // File: contracts/LifCrowdsale.sol
861 
862 /**
863    @title Crowdsale for the Lif Token Generation Event
864 
865    Implementation of the Lif Token Generation Event (TGE) Crowdsale: A 2 week
866    fixed price, uncapped token sale, with a discounted ratefor contributions
867    ìn the private presale and a Market Validation Mechanism that will receive
868    the funds over the USD 10M soft cap.
869    The crowdsale has a minimum cap of USD 5M which in case of not being reached
870    by purchases made during the 2 week period the token will not start operating
871    and all funds sent during that period will be made available to be claimed by
872    the originating addresses.
873    Funds up to the USD 10M soft cap will be sent to the Winding Tree Foundation
874    wallet at the end of the crowdsale.
875    Funds over that amount will be put in a MarketValidationMechanism (MVM) smart
876    contract that guarantees a price floor for a period of 2 or 4 years, allowing
877    any token holder to burn their tokens in exchange of part of the eth amount
878    sent during the TGE in exchange of those tokens.
879  */
880 contract LifCrowdsale is Ownable, Pausable {
881   using SafeMath for uint256;
882 
883   // The token being sold.
884   LifToken public token;
885 
886   // Beginning of the period where tokens can be purchased at rate `rate1`.
887   uint256 public startTimestamp;
888   // Moment after which the rate to buy tokens goes from `rate1` to `rate2`.
889   uint256 public end1Timestamp;
890   // Marks the end of the Token Generation Event.
891   uint256 public end2Timestamp;
892 
893   // Address of the Winding Tree Foundation wallet. Funds up to the soft cap are
894   // sent to this address. It's also the address to which the MVM distributes
895   // the funds that are made available month after month. An extra 5% of tokens
896   // are put in a Vested Payment with this address as beneficiary, acting as a
897   // long-term reserve for the foundation.
898   address public foundationWallet;
899 
900   // Address of the Winding Tree Founders wallet. An extra 12.8% of tokens
901   // are put in a Vested Payment with this address as beneficiary, with 1 year
902   // cliff and 4 years duration.
903   address public foundersWallet;
904 
905   // TGE min cap, in USD. Converted to wei using `weiPerUSDinTGE`.
906   uint256 public minCapUSD = 5000000;
907 
908   // Maximun amount from the TGE that the foundation receives, in USD. Converted
909   // to wei using `weiPerUSDinTGE`. Funds over this cap go to the MVM.
910   uint256 public maxFoundationCapUSD = 10000000;
911 
912   // Maximum amount from the TGE that makes the MVM to last for 24 months. If
913   // funds from the TGE exceed this amount, the MVM will last for 24 months.
914   uint256 public MVM24PeriodsCapUSD = 40000000;
915 
916   // Conversion rate from USD to wei to use during the TGE.
917   uint256 public weiPerUSDinTGE = 0;
918 
919   // Seconds before the TGE since when the corresponding USD to
920   // wei rate cannot be set by the owner anymore.
921   uint256 public setWeiLockSeconds = 0;
922 
923   // Quantity of Lif that is received in exchage of 1 Ether during the first
924   // week of the 2 weeks TGE
925   uint256 public rate1;
926 
927   // Quantity of Lif that is received in exchage of 1 Ether during the second
928   // week of the 2 weeks TGE
929   uint256 public rate2;
930 
931   // Amount of wei received in exchange of tokens during the 2 weeks TGE
932   uint256 public weiRaised;
933 
934   // Amount of lif minted and transferred during the TGE
935   uint256 public tokensSold;
936 
937   // Address of the vesting schedule for the foundation created at the
938   // end of the crowdsale
939   VestedPayment public foundationVestedPayment;
940 
941   // Address of the vesting schedule for founders created at the
942   // end of the crowdsale
943   VestedPayment public foundersVestedPayment;
944 
945   // Address of the MVM created at the end of the crowdsale
946   LifMarketValidationMechanism public MVM;
947 
948   // Tracks the wei sent per address during the 2 week TGE. This is the amount
949   // that can be claimed by each address in case the minimum cap is not reached
950   mapping(address => uint256) public purchases;
951 
952   // Has the Crowdsale been finalized by a successful call to `finalize`?
953   bool public isFinalized = false;
954 
955   /**
956      @dev Event triggered (at most once) on a successful call to `finalize`
957   **/
958   event Finalized();
959 
960   /**
961      @dev Event triggered every time a presale purchase is done
962   **/
963   event TokenPresalePurchase(address indexed beneficiary, uint256 weiAmount, uint256 rate);
964 
965   /**
966      @dev Event triggered on every purchase during the TGE
967 
968      @param purchaser who paid for the tokens
969      @param beneficiary who got the tokens
970      @param value amount of wei paid
971      @param amount amount of tokens purchased
972    */
973   event TokenPurchase(
974     address indexed purchaser,
975     address indexed beneficiary,
976     uint256 value,
977     uint256 amount
978   );
979 
980   /**
981      @dev Constructor. Creates the token in a paused state
982 
983      @param _startTimestamp see `startTimestamp`
984      @param _end1Timestamp see `end1Timestamp`
985      @param _end2Timestamp see `end2Timestamp
986      @param _rate1 see `rate1`
987      @param _rate2 see `rate2`
988      @param _foundationWallet see `foundationWallet`
989    */
990   function LifCrowdsale(
991     uint256 _startTimestamp,
992     uint256 _end1Timestamp,
993     uint256 _end2Timestamp,
994     uint256 _rate1,
995     uint256 _rate2,
996     uint256 _setWeiLockSeconds,
997     address _foundationWallet,
998     address _foundersWallet
999   ) {
1000 
1001     require(_startTimestamp > block.timestamp);
1002     require(_end1Timestamp > _startTimestamp);
1003     require(_end2Timestamp > _end1Timestamp);
1004     require(_rate1 > 0);
1005     require(_rate2 > 0);
1006     require(_setWeiLockSeconds > 0);
1007     require(_foundationWallet != address(0));
1008     require(_foundersWallet != address(0));
1009 
1010     token = new LifToken();
1011     token.pause();
1012 
1013     startTimestamp = _startTimestamp;
1014     end1Timestamp = _end1Timestamp;
1015     end2Timestamp = _end2Timestamp;
1016     rate1 = _rate1;
1017     rate2 = _rate2;
1018     setWeiLockSeconds = _setWeiLockSeconds;
1019     foundationWallet = _foundationWallet;
1020     foundersWallet = _foundersWallet;
1021   }
1022 
1023   /**
1024      @dev Set the wei per USD rate for the TGE. Has to be called by
1025      the owner up to `setWeiLockSeconds` before `startTimestamp`
1026 
1027      @param _weiPerUSD wei per USD rate valid during the TGE
1028    */
1029   function setWeiPerUSDinTGE(uint256 _weiPerUSD) public onlyOwner {
1030     require(_weiPerUSD > 0);
1031     assert(block.timestamp < startTimestamp.sub(setWeiLockSeconds));
1032 
1033     weiPerUSDinTGE = _weiPerUSD;
1034   }
1035 
1036   /**
1037      @dev Returns the current Lif per Eth rate during the TGE
1038 
1039      @return the current Lif per Eth rate or 0 when not in TGE
1040    */
1041   function getRate() public view returns (uint256) {
1042     if (block.timestamp < startTimestamp)
1043       return 0;
1044     else if (block.timestamp <= end1Timestamp)
1045       return rate1;
1046     else if (block.timestamp <= end2Timestamp)
1047       return rate2;
1048     else
1049       return 0;
1050   }
1051 
1052   /**
1053      @dev Fallback function, payable. Calls `buyTokens`
1054    */
1055   function () payable {
1056     buyTokens(msg.sender);
1057   }
1058 
1059   /**
1060      @dev Allows to get tokens during the TGE. Payable. The value is converted to
1061      Lif using the current rate obtained by calling `getRate()`.
1062 
1063      @param beneficiary Address to which Lif should be sent
1064    */
1065   function buyTokens(address beneficiary) public payable whenNotPaused validPurchase {
1066     require(beneficiary != address(0));
1067     assert(weiPerUSDinTGE > 0);
1068 
1069     uint256 weiAmount = msg.value;
1070 
1071     // get current price (it depends on current block number)
1072     uint256 rate = getRate();
1073 
1074     assert(rate > 0);
1075 
1076     // calculate token amount to be created
1077     uint256 tokens = weiAmount.mul(rate);
1078 
1079     // store wei amount in case of TGE min cap not reached
1080     weiRaised = weiRaised.add(weiAmount);
1081     purchases[beneficiary] = purchases[beneficiary].add(weiAmount);
1082     tokensSold = tokensSold.add(tokens);
1083 
1084     token.mint(beneficiary, tokens);
1085     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1086   }
1087 
1088   /**
1089      @dev Allows to add the address and the amount of wei sent by a contributor
1090      in the private presale. Can only be called by the owner before the beginning
1091      of TGE
1092 
1093      @param beneficiary Address to which Lif will be sent
1094      @param weiSent Amount of wei contributed
1095      @param rate Lif per ether rate at the moment of the contribution
1096    */
1097   function addPrivatePresaleTokens(
1098     address beneficiary, uint256 weiSent, uint256 rate
1099   ) public onlyOwner {
1100     require(block.timestamp < startTimestamp);
1101     require(beneficiary != address(0));
1102     require(weiSent > 0);
1103 
1104     // validate that rate is higher than TGE rate
1105     require(rate > rate1);
1106 
1107     uint256 tokens = weiSent.mul(rate);
1108 
1109     weiRaised = weiRaised.add(weiSent);
1110 
1111     token.mint(beneficiary, tokens);
1112 
1113     TokenPresalePurchase(beneficiary, weiSent, rate);
1114   }
1115 
1116   /**
1117      @dev Internal. Forwards funds to the foundation wallet and in case the soft
1118      cap was exceeded it also creates and funds the Market Validation Mechanism.
1119    */
1120   function forwardFunds(bool deployMVM) internal {
1121 
1122     // calculate the max amount of wei for the foundation
1123     uint256 foundationBalanceCapWei = maxFoundationCapUSD.mul(weiPerUSDinTGE);
1124 
1125     // If the minimiun cap for the MVM is not reached or the MVM cant be deployed
1126     // transfer all funds to foundation else if the min cap for the MVM is reached,
1127     // create it and send the remaining funds.
1128     // We use weiRaised to compare becuase that is the total amount of wei raised in all TGE
1129     // but we have to distribute the balance using `this.balance` because thats the amount
1130     // raised by the crowdsale
1131     if ((weiRaised <= foundationBalanceCapWei) || !deployMVM) {
1132 
1133       foundationWallet.transfer(this.balance);
1134 
1135       mintExtraTokens(uint256(24));
1136 
1137     } else {
1138 
1139       uint256 mmFundBalance = this.balance.sub(foundationBalanceCapWei);
1140 
1141       // check how much preiods we have to use on the MVM
1142       uint8 MVMPeriods = 24;
1143       if (mmFundBalance > MVM24PeriodsCapUSD.mul(weiPerUSDinTGE))
1144         MVMPeriods = 48;
1145 
1146       foundationWallet.transfer(foundationBalanceCapWei);
1147 
1148       MVM = new LifMarketValidationMechanism(
1149         address(token), block.timestamp.add(30 days), 30 days, MVMPeriods, foundationWallet
1150       );
1151       MVM.calculateDistributionPeriods();
1152 
1153       mintExtraTokens(uint256(MVMPeriods));
1154 
1155       MVM.fund.value(mmFundBalance)();
1156       MVM.transferOwnership(foundationWallet);
1157 
1158     }
1159   }
1160 
1161   /**
1162      @dev Internal. Distribute extra tokens among founders,
1163      team and the foundation long-term reserve. Founders receive
1164      12.8% of tokens in a 4y (1y cliff) vesting schedule.
1165      Foundation long-term reserve receives 5% of tokens in a
1166      vesting schedule with the same duration as the MVM that
1167      starts when the MVM ends. An extra 7.2% is transferred to
1168      the foundation to be distributed among advisors and future hires
1169    */
1170   function mintExtraTokens(uint256 foundationMonthsStart) internal {
1171     // calculate how much tokens will the founders,
1172     // foundation and advisors will receive
1173     uint256 foundersTokens = token.totalSupply().mul(128).div(1000);
1174     uint256 foundationTokens = token.totalSupply().mul(50).div(1000);
1175     uint256 teamTokens = token.totalSupply().mul(72).div(1000);
1176 
1177     // create the vested payment schedule for the founders
1178     foundersVestedPayment = new VestedPayment(
1179       block.timestamp, 30 days, 48, 12, foundersTokens, token
1180     );
1181     token.mint(foundersVestedPayment, foundersTokens);
1182     foundersVestedPayment.transferOwnership(foundersWallet);
1183 
1184     // create the vested payment schedule for the foundation
1185     uint256 foundationPaymentStart = foundationMonthsStart.mul(30 days)
1186       .add(30 days);
1187     foundationVestedPayment = new VestedPayment(
1188       block.timestamp.add(foundationPaymentStart), 30 days,
1189       foundationMonthsStart, 0, foundationTokens, token
1190     );
1191     token.mint(foundationVestedPayment, foundationTokens);
1192     foundationVestedPayment.transferOwnership(foundationWallet);
1193 
1194     // transfer the token for advisors and future employees to the foundation
1195     token.mint(foundationWallet, teamTokens);
1196 
1197   }
1198 
1199   /**
1200      @dev Modifier
1201      ok if the transaction can buy tokens on TGE
1202    */
1203   modifier validPurchase() {
1204     bool withinPeriod = now >= startTimestamp && now <= end2Timestamp;
1205     bool nonZeroPurchase = msg.value != 0;
1206     assert(withinPeriod && nonZeroPurchase);
1207     _;
1208   }
1209 
1210   /**
1211      @dev Modifier
1212      ok when block.timestamp is past end2Timestamp
1213   */
1214   modifier hasEnded() {
1215     assert(block.timestamp > end2Timestamp);
1216     _;
1217   }
1218 
1219   /**
1220      @dev Modifier
1221      @return true if minCapUSD has been reached by contributions during the TGE
1222   */
1223   function funded() public view returns (bool) {
1224     assert(weiPerUSDinTGE > 0);
1225     return weiRaised >= minCapUSD.mul(weiPerUSDinTGE);
1226   }
1227 
1228   /**
1229      @dev Allows a TGE contributor to claim their contributed eth in case the
1230      TGE has finished without reaching the minCapUSD
1231    */
1232   function claimEth() public whenNotPaused hasEnded {
1233     require(isFinalized);
1234     require(!funded());
1235 
1236     uint256 toReturn = purchases[msg.sender];
1237     assert(toReturn > 0);
1238 
1239     purchases[msg.sender] = 0;
1240 
1241     msg.sender.transfer(toReturn);
1242   }
1243 
1244   /**
1245      @dev Allows the owner to return an purchase to a contributor
1246    */
1247   function returnPurchase(address contributor)
1248     public hasEnded onlyOwner
1249   {
1250     require(!isFinalized);
1251 
1252     uint256 toReturn = purchases[contributor];
1253     assert(toReturn > 0);
1254 
1255     uint256 tokenBalance = token.balanceOf(contributor);
1256 
1257     // Substract weiRaised and tokens sold
1258     weiRaised = weiRaised.sub(toReturn);
1259     tokensSold = tokensSold.sub(tokenBalance);
1260     token.burn(contributor, tokenBalance);
1261     purchases[contributor] = 0;
1262 
1263     contributor.transfer(toReturn);
1264   }
1265 
1266   /**
1267      @dev Finalizes the crowdsale, taking care of transfer of funds to the
1268      Winding Tree Foundation and creation and funding of the Market Validation
1269      Mechanism in case the soft cap was exceeded. It also unpauses the token to
1270      enable transfers. It can be called only once, after `end2Timestamp`
1271    */
1272   function finalize(bool deployMVM) public onlyOwner hasEnded {
1273     require(!isFinalized);
1274 
1275     // foward founds and unpause token only if minCap is reached
1276     if (funded()) {
1277 
1278       forwardFunds(deployMVM);
1279 
1280       // finish the minting of the token
1281       token.finishMinting();
1282 
1283       // transfer the ownership of the token to the foundation
1284       token.transferOwnership(owner);
1285 
1286     }
1287 
1288     Finalized();
1289     isFinalized = true;
1290   }
1291 
1292 }
1293 
1294 // File: contracts/deploy/TGEDeployer.sol
1295 
1296 /**
1297    @title TGEDeployer, A deployer contract for the Winding Tree TGE
1298 
1299    This contract is used to create a crowdsale and issue presale tokens in batches
1300    it will also set the weiPerUSD and transfer ownership, after that everything is
1301    ready for the TGE to succed.
1302  */
1303 contract TGEDeployer {
1304 
1305   LifCrowdsale public crowdsale;
1306   address public wallet;
1307   address public owner;
1308 
1309   function TGEDeployer(
1310     uint256 startTimestamp,
1311     uint256 end1Timestamp,
1312     uint256 end2Timestamp,
1313     uint256 rate1,
1314     uint256 rate2,
1315     uint256 setWeiLockSeconds,
1316     address foundationWallet,
1317     address foundersWallet
1318   ) public {
1319     crowdsale = new LifCrowdsale(
1320       startTimestamp, end1Timestamp, end2Timestamp, rate1, rate2,
1321       setWeiLockSeconds, foundationWallet, foundersWallet
1322     );
1323     wallet = foundationWallet;
1324     owner = msg.sender;
1325   }
1326 
1327   // Mint a batch of presale tokens
1328   function addPresaleTokens(address[] contributors, uint256[] values, uint256 rate) public {
1329     require(msg.sender == owner);
1330     require(contributors.length == values.length);
1331     for (uint32 i = 0; i < contributors.length; i ++) {
1332       crowdsale.addPrivatePresaleTokens(contributors[i], values[i], rate);
1333     }
1334   }
1335 
1336   // Set the wei per USD in the crowdsale and then transfer ownership to foundation
1337   function finish(uint256 weiPerUSDinTGE) public {
1338     require(msg.sender == owner);
1339     crowdsale.setWeiPerUSDinTGE(weiPerUSDinTGE);
1340     crowdsale.transferOwnership(wallet);
1341   }
1342 
1343 }