1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     Unpause();
87   }
88 }
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
95     uint256 c = a * b;
96     assert(a == 0 || c / a == b);
97     return c;
98   }
99 
100   function div(uint256 a, uint256 b) internal constant returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return c;
105   }
106 
107   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   function add(uint256 a, uint256 b) internal constant returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 /**
120  * @title ERC20Basic
121  * @dev Simpler version of ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/179
123  */
124 contract ERC20Basic {
125   uint256 public totalSupply;
126   function balanceOf(address who) public constant returns (uint256);
127   function transfer(address to, uint256 value) public returns (bool);
128   event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147 
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public constant returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender) public constant returns (uint256);
172   function transferFrom(address from, address to, uint256 value) public returns (bool);
173   function approve(address spender, uint256 value) public returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract StandardToken is ERC20, BasicToken {
185 
186   mapping (address => mapping (address => uint256)) allowed;
187 
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amount of tokens to be transferred
194    */
195   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
196     require(_to != address(0));
197 
198     uint256 _allowance = allowed[_from][msg.sender];
199 
200     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
201     // require (_value <= _allowance);
202 
203     balances[_from] = balances[_from].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     allowed[_from][msg.sender] = _allowance.sub(_value);
206     Transfer(_from, _to, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212    *
213    * Beware that changing an allowance with this method brings the risk that someone may use both the old
214    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
215    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
216    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217    * @param _spender The address which will spend the funds.
218    * @param _value The amount of tokens to be spent.
219    */
220   function approve(address _spender, uint256 _value) public returns (bool) {
221     allowed[msg.sender][_spender] = _value;
222     Approval(msg.sender, _spender, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Function to check the amount of tokens that an owner allowed to a spender.
228    * @param _owner address The address which owns the funds.
229    * @param _spender address The address which will spend the funds.
230    * @return A uint256 specifying the amount of tokens still available for the spender.
231    */
232   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
233     return allowed[_owner][_spender];
234   }
235 
236   /**
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    */
242   function increaseApproval (address _spender, uint _addedValue)
243     returns (bool success) {
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   function decreaseApproval (address _spender, uint _subtractedValue)
250     returns (bool success) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 /**
264    @title SmartToken, an extension of ERC20 token standard
265 
266    Implementation the SmartToken, following the ERC20 standard with extra
267    methods to transfer value and data and execute calls in transfers and
268    approvals.
269    Uses OpenZeppelin StandardToken.
270  */
271 contract SmartToken is StandardToken {
272 
273   /**
274      @dev `approveData` is an addition to ERC20 token methods. It allows to
275      approve the transfer of value and execute a call with the sent data.
276 
277      Beware that changing an allowance with this method brings the risk that
278      someone may use both the old and the new allowance by unfortunate
279      transaction ordering. One possible solution to mitigate this race condition
280      is to first reduce the spender's allowance to 0 and set the desired value
281      afterwards:
282      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
283 
284      @param _spender The address that will spend the funds.
285      @param _value The amount of tokens to be spent.
286      @param _data ABI-encoded contract call to call `_to` address.
287 
288      @return true if the call function was executed successfully
289    */
290   function approveData(address _spender, uint256 _value, bytes _data) returns (bool) {
291     require(_spender != address(this));
292 
293     super.approve(_spender, _value);
294 
295     require(_spender.call(_data));
296 
297     return true;
298   }
299 
300   /**
301      @dev Addition to ERC20 token methods. Transfer tokens to a specified
302      address and execute a call with the sent data on the same transaction
303 
304      @param _to address The address which you want to transfer to
305      @param _value uint256 the amout of tokens to be transfered
306      @param _data ABI-encoded contract call to call `_to` address.
307 
308      @return true if the call function was executed successfully
309    */
310   function transferData(address _to, uint256 _value, bytes _data) public returns (bool) {
311     require(_to != address(this));
312 
313     require(_to.call(_data));
314 
315     super.transfer(_to, _value);
316     return true;
317   }
318 
319   /**
320      @dev Addition to ERC20 token methods. Transfer tokens from one address to
321      another and make a contract call on the same transaction
322 
323      @param _from The address which you want to send tokens from
324      @param _to The address which you want to transfer to
325      @param _value The amout of tokens to be transferred
326      @param _data ABI-encoded contract call to call `_to` address.
327 
328      @return true if the call function was executed successfully
329    */
330   function transferDataFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
331     require(_to != address(this));
332 
333     require(_to.call(_data));
334 
335     super.transferFrom(_from, _to, _value);
336     return true;
337   }
338 
339 }
340 
341 /**
342  * @title Mintable token
343  * @dev Simple ERC20 Token example, with mintable token creation
344  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
345  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
346  */
347 
348 contract MintableToken is StandardToken, Ownable {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   /**
361    * @dev Function to mint tokens
362    * @param _to The address that will receive the minted tokens.
363    * @param _amount The amount of tokens to mint.
364    * @return A boolean that indicates if the operation was successful.
365    */
366   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
367     totalSupply = totalSupply.add(_amount);
368     balances[_to] = balances[_to].add(_amount);
369     Mint(_to, _amount);
370     Transfer(0x0, _to, _amount);
371     return true;
372   }
373 
374   /**
375    * @dev Function to stop minting new tokens.
376    * @return True if the operation was successful.
377    */
378   function finishMinting() onlyOwner public returns (bool) {
379     mintingFinished = true;
380     MintFinished();
381     return true;
382   }
383 }
384 
385 
386 
387 /**
388    @title Líf, the Winding Tree token
389 
390    Implementation of Líf, the ERC20 token for Winding Tree, with extra methods
391    to transfer value and data to execute a call on transfer.
392    Uses OpenZeppelin MintableToken and Pausable.
393  */
394 contract LifToken is SmartToken, MintableToken, Pausable {
395   // Token Name
396   string public constant NAME = "Líf";
397 
398   // Token Symbol
399   string public constant SYMBOL = "LIF";
400 
401   // Token decimals
402   uint public constant DECIMALS = 18;
403 
404   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
405     return super.transfer(_to, _value);
406   }
407 
408   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
409     return super.approve(_spender, _value);
410   }
411 
412   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
413     return super.transferFrom(_from, _to, _value);
414   }
415 
416   function approveData(address spender, uint256 value, bytes data) public whenNotPaused returns (bool) {
417     return super.approveData(spender, value, data);
418   }
419 
420   function transferData(address to, uint256 value, bytes data) public whenNotPaused returns (bool) {
421     return super.transferData(to, value, data);
422   }
423 
424   function transferDataFrom(address from, address to, uint256 value, bytes data) public whenNotPaused returns (bool) {
425     return super.transferDataFrom(from, to, value, data);
426   }
427 
428   /**
429      @dev Burns a specific amount of tokens.
430 
431      @param _value The amount of tokens to be burned.
432    */
433   function burn(uint256 _value) public whenNotPaused {
434     require(_value > 0);
435 
436     address burner = msg.sender;
437     balances[burner] = balances[burner].sub(_value);
438     totalSupply = totalSupply.sub(_value);
439     Burn(burner, _value);
440 
441     // a Transfer event to 0x0 can be useful for observers to keep track of
442     // all the Lif by just looking at those events
443     Transfer(burner, address(0), _value);
444   }
445 
446   event Burn(address indexed burner, uint value);
447 
448 }
449 
450 
451 /**
452    @title Vested Payment Schedule for LifToken
453 
454    An ownable vesting schedule for the LifToken, the tokens can only be
455    claimed by the owner. The contract has a start timestamp, a duration
456    of each period in seconds (it can be days, months, years), a total
457    amount of periods and a cliff. The available amount of tokens will
458    be calculated based on the balance of LifTokens of the contract at
459    that time.
460  */
461 
462 contract VestedPayment is Ownable {
463   using SafeMath for uint256;
464 
465   // When the vested schedule starts
466   uint256 public startTimestamp;
467 
468   // How many seconds each period will last
469   uint256 public secondsPerPeriod;
470 
471   // How many periods will have in total
472   uint256 public totalPeriods;
473 
474   // The amount of tokens to be vested in total
475   uint256 public tokens;
476 
477   // How many tokens were claimed
478   uint256 public claimed;
479 
480   // The token contract
481   LifToken public token;
482 
483   // Duration (in periods) of the initial cliff in the vesting schedule
484   uint256 public cliffDuration;
485 
486   /**
487      @dev Constructor.
488 
489      @param _startTimestamp see `startTimestamp`
490      @param _secondsPerPeriod see `secondsPerPeriod`
491      @param _totalPeriods see `totalPeriods
492      @param _cliffDuration see `cliffDuration`
493      @param _tokens see `tokens`
494      @param tokenAddress the address of the token contract
495    */
496   function VestedPayment(
497     uint256 _startTimestamp, uint256 _secondsPerPeriod,
498     uint256 _totalPeriods, uint256 _cliffDuration,
499     uint256 _tokens, address tokenAddress
500   ) {
501     require(_startTimestamp >= block.timestamp);
502     require(_secondsPerPeriod > 0);
503     require(_totalPeriods > 0);
504     require(tokenAddress != address(0));
505     require(_cliffDuration < _totalPeriods);
506     require(_tokens > 0);
507 
508     startTimestamp = _startTimestamp;
509     secondsPerPeriod = _secondsPerPeriod;
510     totalPeriods = _totalPeriods;
511     cliffDuration = _cliffDuration;
512     tokens = _tokens;
513     token = LifToken(tokenAddress);
514   }
515 
516   /**
517      @dev Get how many tokens are available to be claimed
518    */
519   function getAvailableTokens() public constant returns (uint256) {
520     uint256 period = block.timestamp.sub(startTimestamp)
521       .div(secondsPerPeriod);
522 
523     if (period < cliffDuration) {
524       return 0;
525     } else if (period >= totalPeriods) {
526       return tokens.sub(claimed);
527     } else {
528       return tokens.mul(period.add(1)).div(totalPeriods).sub(claimed);
529     }
530   }
531 
532   /**
533      @dev Claim the tokens, they can be claimed only by the owner
534      of the contract
535 
536      @param amount how many tokens to be claimed
537    */
538   function claimTokens(uint256 amount) public onlyOwner {
539     assert(getAvailableTokens() >= amount);
540 
541     claimed = claimed.add(amount);
542     token.transfer(owner, amount);
543   }
544 
545 }
546 
547 
548 /**
549    @title Market Validation Mechanism (MVM)
550  */
551 contract LifMarketValidationMechanism is Ownable {
552   using SafeMath for uint256;
553 
554   // The Lif token contract
555   LifToken public lifToken;
556 
557   // The address of the foundation wallet. It can claim part of the eth funds
558   // following an exponential curve until the end of the MVM lifetime (24 or 48
559   // months). After that it can claim 100% of the remaining eth in the MVM.
560   address public foundationAddr;
561 
562   // The amount of wei that the MVM received initially
563   uint256 public initialWei;
564 
565   // Start timestamp since which the MVM begins to accept tokens via sendTokens
566   uint256 public startTimestamp;
567 
568   // Quantity of seconds in every period, usually equivalent to 30 days
569   uint256 public secondsPerPeriod;
570 
571   // Number of periods. It should be 24 or 48 (each period is roughly a month)
572   uint8 public totalPeriods;
573 
574   // The total amount of wei that was claimed by the foundation so far
575   uint256 public totalWeiClaimed = 0;
576 
577   // The price at which the MVM buys tokens at the beginning of its lifetime
578   uint256 public initialBuyPrice = 0;
579 
580   // Amount of tokens that were burned by the MVM
581   uint256 public totalBurnedTokens = 0;
582 
583   // Amount of wei that was reimbursed via sendTokens calls
584   uint256 public totalReimbursedWei = 0;
585 
586   // Total supply of tokens when the MVM was created
587   uint256 public originalTotalSupply;
588 
589   uint256 constant PRICE_FACTOR = 100000;
590 
591   // Has the MVM been funded by calling `fund`? It can be funded only once
592   bool public funded = false;
593 
594   // true when the market MVM is paused
595   bool public paused = false;
596 
597   // total amount of seconds that the MVM was paused
598   uint256 public totalPausedSeconds = 0;
599 
600   // the timestamp where the MVM was paused
601   uint256 public pausedTimestamp;
602 
603   uint256[] public periods;
604 
605   // Events
606   event Pause();
607   event Unpause(uint256 pausedSeconds);
608 
609   event ClaimedWei(uint256 claimedWei);
610   event SentTokens(address indexed sender, uint256 price, uint256 tokens, uint256 returnedWei);
611 
612   modifier whenNotPaused(){
613     assert(!paused);
614     _;
615   }
616 
617   modifier whenPaused(){
618     assert(paused);
619     _;
620   }
621 
622   /**
623      @dev Constructor
624 
625      @param lifAddr the lif token address
626      @param _startTimestamp see `startTimestamp`
627      @param _secondsPerPeriod see `secondsPerPeriod`
628      @param _totalPeriods see `totalPeriods`
629      @param _foundationAddr see `foundationAddr`
630     */
631   function LifMarketValidationMechanism(
632     address lifAddr, uint256 _startTimestamp, uint256 _secondsPerPeriod,
633     uint8 _totalPeriods, address _foundationAddr
634   ) {
635     require(lifAddr != address(0));
636     require(_startTimestamp > block.timestamp);
637     require(_secondsPerPeriod > 0);
638     require(_totalPeriods == 24 || _totalPeriods == 48);
639     require(_foundationAddr != address(0));
640 
641     lifToken = LifToken(lifAddr);
642     startTimestamp = _startTimestamp;
643     secondsPerPeriod = _secondsPerPeriod;
644     totalPeriods = _totalPeriods;
645     foundationAddr = _foundationAddr;
646 
647   }
648 
649   /**
650      @dev Receives the initial funding from the Crowdsale. Calculates the
651      initial buy price as initialWei / totalSupply
652     */
653   function fund() public payable onlyOwner {
654     assert(!funded);
655 
656     originalTotalSupply = lifToken.totalSupply();
657     initialWei = msg.value;
658     initialBuyPrice = initialWei.
659       mul(PRICE_FACTOR).
660       div(originalTotalSupply);
661 
662     funded = true;
663   }
664 
665   /**
666      @dev calculates the exponential distribution curve. It determines how much
667      wei can be distributed back to the foundation every month. It starts with
668      very low amounts ending with higher chunks at the end of the MVM lifetime
669     */
670   function calculateDistributionPeriods() public {
671     assert(totalPeriods == 24 || totalPeriods == 48);
672     assert(periods.length == 0);
673 
674     // Table with the max delta % that can be distributed back to the foundation on
675     // each period. It follows an exponential curve (starts with lower % and ends
676     // with higher %) to keep the funds in the MVM longer. deltas24
677     // is used when MVM lifetime is 24 months, deltas48 when it's 48 months.
678     // The sum is less than 100% because the last % is missing: after the last period
679     // the 100% remaining can be claimed by the foundation. Values multipled by 10^5
680 
681     uint256[24] memory accumDistribution24 = [
682       uint256(0), 18, 117, 351, 767, 1407,
683       2309, 3511, 5047, 6952, 9257, 11995,
684       15196, 18889, 23104, 27870, 33215, 39166,
685       45749, 52992, 60921, 69561, 78938, 89076
686     ];
687 
688     uint256[48] memory accumDistribution48 = [
689       uint256(0), 3, 18, 54, 117, 214, 351, 534,
690       767, 1056, 1406, 1822, 2308, 2869, 3510, 4234,
691       5046, 5950, 6950, 8051, 9256, 10569, 11994, 13535,
692       15195, 16978, 18888, 20929, 23104, 25416, 27870, 30468,
693       33214, 36112, 39165, 42376, 45749, 49286, 52992, 56869,
694       60921, 65150, 69560, 74155, 78937, 83909, 89075, 94438
695     ];
696 
697     for (uint8 i = 0; i < totalPeriods; i++) {
698 
699       if (totalPeriods == 24) {
700         periods.push(accumDistribution24[i]);
701       } else {
702         periods.push(accumDistribution48[i]);
703       }
704 
705     }
706   }
707 
708   /**
709      @dev Returns the current period as a number from 0 to totalPeriods
710 
711      @return the current period as a number from 0 to totalPeriods
712     */
713   function getCurrentPeriodIndex() public constant returns(uint256) {
714     assert(block.timestamp >= startTimestamp);
715     return block.timestamp.sub(startTimestamp).
716       sub(totalPausedSeconds).
717       div(secondsPerPeriod);
718   }
719 
720   /**
721      @dev calculates the accumulated distribution percentage as of now,
722      following the exponential distribution curve
723 
724      @return the accumulated distribution percentage, used to calculate things
725      like the maximum amount that can be claimed by the foundation
726     */
727   function getAccumulatedDistributionPercentage() public constant returns(uint256 percentage) {
728     uint256 period = getCurrentPeriodIndex();
729 
730     assert(period < totalPeriods);
731 
732     return periods[period];
733   }
734 
735   /**
736      @dev returns the current buy price at which the MVM offers to buy tokens to
737      burn them
738 
739      @return the current buy price (in eth/lif, multiplied by PRICE_FACTOR)
740     */
741   function getBuyPrice() public constant returns (uint256 price) {
742     uint256 accumulatedDistributionPercentage = getAccumulatedDistributionPercentage();
743 
744     return initialBuyPrice.
745       mul(PRICE_FACTOR.sub(accumulatedDistributionPercentage)).
746       div(PRICE_FACTOR);
747   }
748 
749   /**
750      @dev Returns the maximum amount of wei that the foundation can claim. It's
751      a portion of the ETH that was not claimed by token holders
752 
753      @return the maximum wei claimable by the foundation as of now
754     */
755   function getMaxClaimableWeiAmount() public constant returns (uint256) {
756     if (isFinished()) {
757       return this.balance;
758     } else {
759       uint256 claimableFromReimbursed = initialBuyPrice.
760         mul(totalBurnedTokens).div(PRICE_FACTOR).
761         sub(totalReimbursedWei);
762       uint256 currentCirculation = lifToken.totalSupply();
763       uint256 accumulatedDistributionPercentage = getAccumulatedDistributionPercentage();
764       uint256 maxClaimable = initialWei.
765         mul(accumulatedDistributionPercentage).div(PRICE_FACTOR).
766         mul(currentCirculation).div(originalTotalSupply).
767         add(claimableFromReimbursed);
768 
769       if (maxClaimable > totalWeiClaimed) {
770         return maxClaimable.sub(totalWeiClaimed);
771       } else {
772         return 0;
773       }
774     }
775   }
776 
777   /**
778      @dev allows to send tokens to the MVM in exchange of Eth at the price
779      determined by getBuyPrice. The tokens are burned
780     */
781   function sendTokens(uint256 tokens) public whenNotPaused {
782     require(tokens > 0);
783 
784     uint256 price = getBuyPrice();
785     uint256 totalWei = tokens.mul(price).div(PRICE_FACTOR);
786 
787     lifToken.transferFrom(msg.sender, address(this), tokens);
788     lifToken.burn(tokens);
789     totalBurnedTokens = totalBurnedTokens.add(tokens);
790 
791     SentTokens(msg.sender, price, tokens, totalWei);
792 
793     totalReimbursedWei = totalReimbursedWei.add(totalWei);
794     msg.sender.transfer(totalWei);
795   }
796 
797   /**
798      @dev Returns whether the MVM end-of-life has been reached. When that
799      happens no more tokens can be sent to the MVM and the foundation can claim
800      100% of the remaining balance in the MVM
801 
802      @return true if the MVM end-of-life has been reached
803     */
804   function isFinished() public constant returns (bool finished) {
805     return getCurrentPeriodIndex() >= totalPeriods;
806   }
807 
808   /**
809      @dev Called from the foundation wallet to claim eth back from the MVM.
810      Maximum amount that can be claimed is determined by
811      getMaxClaimableWeiAmount
812     */
813   function claimWei(uint256 weiAmount) public whenNotPaused {
814     require(msg.sender == foundationAddr);
815 
816     uint256 claimable = getMaxClaimableWeiAmount();
817 
818     assert(claimable >= weiAmount);
819 
820     foundationAddr.transfer(weiAmount);
821 
822     totalWeiClaimed = totalWeiClaimed.add(weiAmount);
823 
824     ClaimedWei(weiAmount);
825   }
826 
827   /**
828      @dev Pauses the MVM. No tokens can be sent to the MVM and no eth can be
829      claimed from the MVM while paused. MVM total lifetime is extended by the
830      period it stays paused
831     */
832   function pause() public onlyOwner whenNotPaused {
833     paused = true;
834     pausedTimestamp = block.timestamp;
835 
836     Pause();
837   }
838 
839   /**
840      @dev Unpauses the MVM. See `pause` for more details about pausing
841     */
842   function unpause() public onlyOwner whenPaused {
843     uint256 pausedSeconds = block.timestamp.sub(pausedTimestamp);
844     totalPausedSeconds = totalPausedSeconds.add(pausedSeconds);
845     paused = false;
846 
847     Unpause(pausedSeconds);
848   }
849 
850 }
851 
852 /**
853    @title Crowdsale for the Lif Token Generation Event
854 
855    Implementation of the Lif Token Generation Event (TGE) Crowdsale: A 2 week
856    fixed price, uncapped token sale, with a discounted ratefor contributions
857    ìn the private presale and a Market Validation Mechanism that will receive
858    the funds over the USD 10M soft cap.
859    The crowdsale has a minimum cap of USD 5M which in case of not being reached
860    by purchases made during the 2 week period the token will not start operating
861    and all funds sent during that period will be made available to be claimed by
862    the originating addresses.
863    Funds up to the USD 10M soft cap will be sent to the Winding Tree Foundation
864    wallet at the end of the crowdsale.
865    Funds over that amount will be put in a MarketValidationMechanism (MVM) smart
866    contract that guarantees a price floor for a period of 2 or 4 years, allowing
867    any token holder to burn their tokens in exchange of part of the eth amount
868    sent during the TGE in exchange of those tokens.
869  */
870 contract LifCrowdsale is Ownable, Pausable {
871   using SafeMath for uint256;
872 
873   // The token being sold.
874   LifToken public token;
875 
876   // Beginning of the period where tokens can be purchased at rate `rate1`.
877   uint256 public startTimestamp;
878   // Moment after which the rate to buy tokens goes from `rate1` to `rate2`.
879   uint256 public end1Timestamp;
880   // Marks the end of the Token Generation Event.
881   uint256 public end2Timestamp;
882 
883   // Address of the Winding Tree Foundation wallet. Funds up to the soft cap are
884   // sent to this address. It's also the address to which the MVM distributes
885   // the funds that are made available month after month. An extra 5% of tokens
886   // are put in a Vested Payment with this address as beneficiary, acting as a
887   // long-term reserve for the foundation.
888   address public foundationWallet;
889 
890   // Address of the Winding Tree Founders wallet. An extra 12.8% of tokens
891   // are put in a Vested Payment with this address as beneficiary, with 1 year
892   // cliff and 4 years duration.
893   address public foundersWallet;
894 
895   // TGE min cap, in USD. Converted to wei using `weiPerUSDinTGE`.
896   uint256 public minCapUSD = 5000000;
897 
898   // Maximun amount from the TGE that the foundation receives, in USD. Converted
899   // to wei using `weiPerUSDinTGE`. Funds over this cap go to the MVM.
900   uint256 public maxFoundationCapUSD = 10000000;
901 
902   // Maximum amount from the TGE that makes the MVM to last for 24 months. If
903   // funds from the TGE exceed this amount, the MVM will last for 24 months.
904   uint256 public MVM24PeriodsCapUSD = 40000000;
905 
906   // Conversion rate from USD to wei to use during the TGE.
907   uint256 public weiPerUSDinTGE = 0;
908 
909   // Seconds before the TGE since when the corresponding USD to
910   // wei rate cannot be set by the owner anymore.
911   uint256 public setWeiLockSeconds = 0;
912 
913   // Quantity of Lif that is received in exchage of 1 Ether during the first
914   // week of the 2 weeks TGE
915   uint256 public rate1;
916 
917   // Quantity of Lif that is received in exchage of 1 Ether during the second
918   // week of the 2 weeks TGE
919   uint256 public rate2;
920 
921   // Amount of wei received in exchange of tokens during the 2 weeks TGE
922   uint256 public weiRaised;
923 
924   // Amount of lif minted and transferred during the TGE
925   uint256 public tokensSold;
926 
927   // Amount of wei received as private presale payments
928   uint256 public totalPresaleWei;
929 
930   // Address of the vesting schedule for the foundation created at the
931   // end of the crowdsale
932   VestedPayment public foundationVestedPayment;
933 
934   // Address of the vesting schedule for founders created at the
935   // end of the crowdsale
936   VestedPayment public foundersVestedPayment;
937 
938   // Address of the MVM created at the end of the crowdsale
939   LifMarketValidationMechanism public MVM;
940 
941   // Tracks the wei sent per address during the 2 week TGE. This is the amount
942   // that can be claimed by each address in case the minimum cap is not reached
943   mapping(address => uint256) public purchases;
944 
945   // Has the Crowdsale been finalized by a successful call to `finalize`?
946   bool public isFinalized = false;
947 
948   /**
949      @dev Event triggered (at most once) on a successful call to `finalize`
950   **/
951   event Finalized();
952 
953   /**
954      @dev Event triggered every time a presale purchase is done
955   **/
956   event TokenPresalePurchase(address indexed beneficiary, uint256 weiAmount, uint256 rate);
957 
958   /**
959      @dev Event triggered on every purchase during the TGE
960 
961      @param purchaser who paid for the tokens
962      @param beneficiary who got the tokens
963      @param value amount of wei paid
964      @param amount amount of tokens purchased
965    */
966   event TokenPurchase(
967     address indexed purchaser,
968     address indexed beneficiary,
969     uint256 value,
970     uint256 amount
971   );
972 
973   /**
974      @dev Constructor. Creates the token in a paused state
975 
976      @param _startTimestamp see `startTimestamp`
977      @param _end1Timestamp see `end1Timestamp`
978      @param _end2Timestamp see `end2Timestamp
979      @param _rate1 see `rate1`
980      @param _rate2 see `rate2`
981      @param _foundationWallet see `foundationWallet`
982    */
983   function LifCrowdsale(
984     uint256 _startTimestamp,
985     uint256 _end1Timestamp,
986     uint256 _end2Timestamp,
987     uint256 _rate1,
988     uint256 _rate2,
989     uint256 _setWeiLockSeconds,
990     address _foundationWallet,
991     address _foundersWallet
992   ) {
993 
994     require(_startTimestamp > block.timestamp);
995     require(_end1Timestamp > _startTimestamp);
996     require(_end2Timestamp > _end1Timestamp);
997     require(_rate1 > 0);
998     require(_rate2 > 0);
999     require(_setWeiLockSeconds > 0);
1000     require(_foundationWallet != address(0));
1001     require(_foundersWallet != address(0));
1002 
1003     token = new LifToken();
1004     token.pause();
1005 
1006     startTimestamp = _startTimestamp;
1007     end1Timestamp = _end1Timestamp;
1008     end2Timestamp = _end2Timestamp;
1009     rate1 = _rate1;
1010     rate2 = _rate2;
1011     setWeiLockSeconds = _setWeiLockSeconds;
1012     foundationWallet = _foundationWallet;
1013     foundersWallet = _foundersWallet;
1014   }
1015 
1016   /**
1017      @dev Set the wei per USD rate for the TGE. Has to be called by
1018      the owner up to `setWeiLockSeconds` before `startTimestamp`
1019 
1020      @param _weiPerUSD wei per USD rate valid during the TGE
1021    */
1022   function setWeiPerUSDinTGE(uint256 _weiPerUSD) public onlyOwner {
1023     require(_weiPerUSD > 0);
1024     assert(block.timestamp < startTimestamp.sub(setWeiLockSeconds));
1025 
1026     weiPerUSDinTGE = _weiPerUSD;
1027   }
1028 
1029   /**
1030      @dev Returns the current Lif per Eth rate during the TGE
1031 
1032      @return the current Lif per Eth rate or 0 when not in TGE
1033    */
1034   function getRate() public constant returns (uint256) {
1035     if (block.timestamp < startTimestamp)
1036       return 0;
1037     else if (block.timestamp <= end1Timestamp)
1038       return rate1;
1039     else if (block.timestamp <= end2Timestamp)
1040       return rate2;
1041     else
1042       return 0;
1043   }
1044 
1045   /**
1046      @dev Fallback function, payable. Calls `buyTokens`
1047    */
1048   function () payable {
1049     buyTokens(msg.sender);
1050   }
1051 
1052   /**
1053      @dev Allows to get tokens during the TGE. Payable. The value is converted to
1054      Lif using the current rate obtained by calling `getRate()`.
1055 
1056      @param beneficiary Address to which Lif should be sent
1057    */
1058   function buyTokens(address beneficiary) public payable validPurchase {
1059     require(beneficiary != address(0));
1060     assert(weiPerUSDinTGE > 0);
1061 
1062     uint256 weiAmount = msg.value;
1063 
1064     // get current price (it depends on current block number)
1065     uint256 rate = getRate();
1066 
1067     assert(rate > 0);
1068 
1069     // calculate token amount to be created
1070     uint256 tokens = weiAmount.mul(rate);
1071 
1072     // store wei amount in case of TGE min cap not reached
1073     weiRaised = weiRaised.add(weiAmount);
1074     purchases[beneficiary] = weiAmount;
1075     tokensSold = tokensSold.add(tokens);
1076 
1077     token.mint(beneficiary, tokens);
1078     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1079   }
1080 
1081   /**
1082      @dev Allows to add the address and the amount of wei sent by a contributor
1083      in the private presale. Can only be called by the owner before the beginning
1084      of TGE
1085 
1086      @param beneficiary Address to which Lif will be sent
1087      @param weiSent Amount of wei contributed
1088      @param rate Lif per ether rate at the moment of the contribution
1089    */
1090   function addPrivatePresaleTokens(
1091     address beneficiary, uint256 weiSent, uint256 rate
1092   ) public onlyOwner {
1093     require(block.timestamp < startTimestamp);
1094     require(beneficiary != address(0));
1095     require(weiSent > 0);
1096 
1097     // validate that rate is higher than TGE rate
1098     require(rate > rate1);
1099 
1100     uint256 tokens = weiSent.mul(rate);
1101 
1102     totalPresaleWei = totalPresaleWei.add(weiSent);
1103 
1104     token.mint(beneficiary, tokens);
1105 
1106     TokenPresalePurchase(beneficiary, weiSent, rate);
1107   }
1108 
1109   /**
1110      @dev Internal. Forwards funds to the foundation wallet and in case the soft
1111      cap was exceeded it also creates and funds the Market Validation Mechanism.
1112    */
1113   function forwardFunds() internal {
1114 
1115     // calculate the max amount of wei for the foundation
1116     uint256 foundationBalanceCapWei = maxFoundationCapUSD.mul(weiPerUSDinTGE);
1117 
1118     // if the minimiun cap for the MVM is not reached transfer all funds to foundation
1119     // else if the min cap for the MVM is reached, create it and send the remaining funds
1120     if (weiRaised <= foundationBalanceCapWei) {
1121 
1122       foundationWallet.transfer(this.balance);
1123 
1124       mintExtraTokens(uint256(24));
1125 
1126     } else {
1127 
1128       uint256 mmFundBalance = this.balance.sub(foundationBalanceCapWei);
1129 
1130       // check how much preiods we have to use on the MVM
1131       uint8 MVMPeriods = 24;
1132       if (mmFundBalance > MVM24PeriodsCapUSD.mul(weiPerUSDinTGE))
1133         MVMPeriods = 48;
1134 
1135       foundationWallet.transfer(foundationBalanceCapWei);
1136 
1137       MVM = new LifMarketValidationMechanism(
1138         address(token), block.timestamp.add(3600), 3600, MVMPeriods, foundationWallet
1139       );
1140       MVM.calculateDistributionPeriods();
1141 
1142       mintExtraTokens(uint256(MVMPeriods));
1143 
1144       MVM.fund.value(mmFundBalance)();
1145       MVM.transferOwnership(foundationWallet);
1146 
1147     }
1148   }
1149 
1150   /**
1151      @dev Internal. Distribute extra tokens among founders,
1152      team and the foundation long-term reserve. Founders receive
1153      12.8% of tokens in a 4y (1y cliff) vesting schedule.
1154      Foundation long-term reserve receives 5% of tokens in a
1155      vesting schedule with the same duration as the MVM that
1156      starts when the MVM ends. An extra 7.2% is transferred to
1157      the foundation to be distributed among advisors and future hires
1158    */
1159   function mintExtraTokens(uint256 foundationMonthsStart) internal {
1160     // calculate how much tokens will the founders,
1161     // foundation and advisors will receive
1162     uint256 foundersTokens = token.totalSupply().mul(128).div(1000);
1163     uint256 foundationTokens = token.totalSupply().mul(50).div(1000);
1164     uint256 teamTokens = token.totalSupply().mul(72).div(1000);
1165 
1166     // create the vested payment schedule for the founders
1167     foundersVestedPayment = new VestedPayment(
1168       block.timestamp, 3600, 48, 12, foundersTokens, token
1169     );
1170     token.mint(foundersVestedPayment, foundersTokens);
1171     foundersVestedPayment.transferOwnership(foundersWallet);
1172 
1173     // create the vested payment schedule for the foundation
1174     uint256 foundationPaymentStart = foundationMonthsStart.mul(3600);
1175     foundationVestedPayment = new VestedPayment(
1176       block.timestamp.add(foundationPaymentStart), 3600,
1177       foundationMonthsStart, 0, foundationTokens, token
1178     );
1179     token.mint(foundationVestedPayment, foundationTokens);
1180     foundationVestedPayment.transferOwnership(foundationWallet);
1181 
1182     // transfer the token for advisors and future employees to the foundation
1183     token.mint(foundationWallet, teamTokens);
1184 
1185   }
1186 
1187   /**
1188      @dev Modifier
1189      ok if the transaction can buy tokens on TGE
1190    */
1191   modifier validPurchase() {
1192     bool withinPeriod = now >= startTimestamp && now <= end2Timestamp;
1193     bool nonZeroPurchase = msg.value != 0;
1194     assert(withinPeriod && nonZeroPurchase);
1195 
1196     _;
1197   }
1198 
1199   /**
1200      @dev Modifier
1201      ok when block.timestamp is past end2Timestamp
1202   */
1203   modifier hasEnded() {
1204     assert(block.timestamp > end2Timestamp);
1205     _;
1206   }
1207 
1208   /**
1209      @dev Modifier
1210      @return true if minCapUSD has been reached by contributions during the TGE
1211   */
1212   function funded() public constant returns (bool) {
1213     assert(weiPerUSDinTGE > 0);
1214     return weiRaised >= minCapUSD.mul(weiPerUSDinTGE);
1215   }
1216 
1217   /**
1218      @dev Allows a TGE contributor to claim their contributed eth in case the
1219      TGE has finished without reaching the minCapUSD
1220    */
1221   function claimEth() public hasEnded {
1222     require(isFinalized);
1223     require(!funded());
1224 
1225     uint256 toReturn = purchases[msg.sender];
1226     assert(toReturn > 0);
1227 
1228     purchases[msg.sender] = 0;
1229 
1230     msg.sender.transfer(toReturn);
1231   }
1232 
1233   /**
1234      @dev Finalizes the crowdsale, taking care of transfer of funds to the
1235      Winding Tree Foundation and creation and funding of the Market Validation
1236      Mechanism in case the soft cap was exceeded. It also unpauses the token to
1237      enable transfers. It can be called only once, after `end2Timestamp`
1238    */
1239   function finalize() public hasEnded {
1240     require(!isFinalized);
1241 
1242     // foward founds and unpause token only if minCap is reached
1243     if (funded()) {
1244 
1245       forwardFunds();
1246 
1247       // finish the minting of the token and unpause it
1248       token.finishMinting();
1249       token.unpause();
1250 
1251       // transfer the ownership of the token to the foundation
1252       token.transferOwnership(owner);
1253 
1254     }
1255 
1256     Finalized();
1257     isFinalized = true;
1258   }
1259 
1260 }