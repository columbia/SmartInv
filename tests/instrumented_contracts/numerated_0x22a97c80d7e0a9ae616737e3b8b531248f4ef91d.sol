1 contract ReentrancyGuard {
2 
3   /**
4    * @dev We use a single lock for the whole contract.
5    */
6   bool private rentrancy_lock = false;
7 
8   /**
9    * @dev Prevents a contract from calling itself, directly or indirectly.
10    * @notice If you mark a function `nonReentrant`, you should also
11    * mark it `external`. Calling one nonReentrant function from
12    * another is not supported. Instead, you can implement a
13    * `private` function doing the actual work, and a `external`
14    * wrapper marked as `nonReentrant`.
15    */
16   modifier nonReentrant() {
17     require(!rentrancy_lock);
18     rentrancy_lock = true;
19     _;
20     rentrancy_lock = false;
21   }
22 
23 }
24 
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal constant returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal constant returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) onlyOwner public {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 contract Claimable is Ownable {
89   address public pendingOwner;
90 
91   /**
92    * @dev Modifier throws if called by any account other than the pendingOwner.
93    */
94   modifier onlyPendingOwner() {
95     require(msg.sender == pendingOwner);
96     _;
97   }
98 
99   /**
100    * @dev Allows the current owner to set the pendingOwner address.
101    * @param newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address newOwner) onlyOwner public {
104     pendingOwner = newOwner;
105   }
106 
107   /**
108    * @dev Allows the pendingOwner address to finalize the transfer.
109    */
110   function claimOwnership() onlyPendingOwner public {
111     OwnershipTransferred(owner, pendingOwner);
112     owner = pendingOwner;
113     pendingOwner = 0x0;
114   }
115 }
116 
117 contract HasNoContracts is Ownable {
118 
119   /**
120    * @dev Reclaim ownership of Ownable contracts
121    * @param contractAddr The address of the Ownable to be reclaimed.
122    */
123   function reclaimContract(address contractAddr) external onlyOwner {
124     Ownable contractInst = Ownable(contractAddr);
125     contractInst.transferOwnership(owner);
126   }
127 }
128 
129 contract HasNoEther is Ownable {
130 
131   /**
132   * @dev Constructor that rejects incoming Ether
133   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
134   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
135   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
136   * we could use assembly to access msg.value.
137   */
138   function HasNoEther() payable {
139     require(msg.value == 0);
140   }
141 
142   /**
143    * @dev Disallows direct send by settings a default function without the `payable` flag.
144    */
145   function() external {
146   }
147 
148   /**
149    * @dev Transfer all Ether held by the contract to the owner.
150    */
151   function reclaimEther() external onlyOwner {
152     assert(owner.send(this.balance));
153   }
154 }
155 
156 contract ERC20Basic {
157   uint256 public totalSupply;
158   function balanceOf(address who) public constant returns (uint256);
159   function transfer(address to, uint256 value) public returns (bool);
160   event Transfer(address indexed from, address indexed to, uint256 value);
161 }
162 
163 contract BasicToken is ERC20Basic {
164   using SafeMath for uint256;
165 
166   mapping(address => uint256) balances;
167 
168   /**
169   * @dev transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175 
176     // SafeMath.sub will throw if there is not enough balance.
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public constant returns (uint256 balance) {
189     return balances[_owner];
190   }
191 
192 }
193 
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) public constant returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 library SafeERC20 {
202   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
203     assert(token.transfer(to, value));
204   }
205 
206   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
207     assert(token.transferFrom(from, to, value));
208   }
209 
210   function safeApprove(ERC20 token, address spender, uint256 value) internal {
211     assert(token.approve(spender, value));
212   }
213 }
214 
215 contract CanReclaimToken is Ownable {
216   using SafeERC20 for ERC20Basic;
217 
218   /**
219    * @dev Reclaim all ERC20Basic compatible tokens
220    * @param token ERC20Basic The address of the token contract
221    */
222   function reclaimToken(ERC20Basic token) external onlyOwner {
223     uint256 balance = token.balanceOf(this);
224     token.safeTransfer(owner, balance);
225   }
226 
227 }
228 
229 contract HasNoTokens is CanReclaimToken {
230 
231  /**
232   * @dev Reject all ERC23 compatible tokens
233   * @param from_ address The address that is transferring the tokens
234   * @param value_ uint256 the amount of the specified token
235   * @param data_ Bytes The data passed from the caller.
236   */
237   function tokenFallback(address from_, uint256 value_, bytes data_) external {
238     revert();
239   }
240 
241 }
242 
243 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
244 }
245 
246 contract StandardToken is ERC20, BasicToken {
247 
248   mapping (address => mapping (address => uint256)) allowed;
249 
250 
251   /**
252    * @dev Transfer tokens from one address to another
253    * @param _from address The address which you want to send tokens from
254    * @param _to address The address which you want to transfer to
255    * @param _value uint256 the amount of tokens to be transferred
256    */
257   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
258     require(_to != address(0));
259 
260     uint256 _allowance = allowed[_from][msg.sender];
261 
262     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
263     // require (_value <= _allowance);
264 
265     balances[_from] = balances[_from].sub(_value);
266     balances[_to] = balances[_to].add(_value);
267     allowed[_from][msg.sender] = _allowance.sub(_value);
268     Transfer(_from, _to, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
274    *
275    * Beware that changing an allowance with this method brings the risk that someone may use both the old
276    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
277    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
278    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279    * @param _spender The address which will spend the funds.
280    * @param _value The amount of tokens to be spent.
281    */
282   function approve(address _spender, uint256 _value) public returns (bool) {
283     allowed[msg.sender][_spender] = _value;
284     Approval(msg.sender, _spender, _value);
285     return true;
286   }
287 
288   /**
289    * @dev Function to check the amount of tokens that an owner allowed to a spender.
290    * @param _owner address The address which owns the funds.
291    * @param _spender address The address which will spend the funds.
292    * @return A uint256 specifying the amount of tokens still available for the spender.
293    */
294   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
295     return allowed[_owner][_spender];
296   }
297 
298   /**
299    * approve should be called when allowed[_spender] == 0. To increment
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    */
304   function increaseApproval (address _spender, uint _addedValue)
305     returns (bool success) {
306     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
307     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308     return true;
309   }
310 
311   function decreaseApproval (address _spender, uint _subtractedValue)
312     returns (bool success) {
313     uint oldValue = allowed[msg.sender][_spender];
314     if (_subtractedValue > oldValue) {
315       allowed[msg.sender][_spender] = 0;
316     } else {
317       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
318     }
319     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323 }
324 
325 contract MintableToken is StandardToken, Ownable {
326   event Mint(address indexed to, uint256 amount);
327   event MintFinished();
328 
329   bool public mintingFinished = false;
330 
331 
332   modifier canMint() {
333     require(!mintingFinished);
334     _;
335   }
336 
337   /**
338    * @dev Function to mint tokens
339    * @param _to The address that will receive the minted tokens.
340    * @param _amount The amount of tokens to mint.
341    * @return A boolean that indicates if the operation was successful.
342    */
343   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
344     totalSupply = totalSupply.add(_amount);
345     balances[_to] = balances[_to].add(_amount);
346     Mint(_to, _amount);
347     Transfer(0x0, _to, _amount);
348     return true;
349   }
350 
351   /**
352    * @dev Function to stop minting new tokens.
353    * @return True if the operation was successful.
354    */
355   function finishMinting() onlyOwner public returns (bool) {
356     mintingFinished = true;
357     MintFinished();
358     return true;
359   }
360 }
361 
362 contract Campaign is Claimable, HasNoTokens, ReentrancyGuard {
363     using SafeMath for uint256;
364 
365     string constant public version = "1.0.0";
366 
367     string public id;
368 
369     string public name;
370 
371     string public website;
372 
373     bytes32 public whitePaperHash;
374 
375     uint256 public fundingThreshold;
376 
377     uint256 public fundingGoal;
378 
379     uint256 public tokenPrice;
380 
381     enum TimeMode {
382         Block,
383         Timestamp
384     }
385 
386     TimeMode public timeMode;
387 
388     uint256 public startTime;
389 
390     uint256 public finishTime;
391 
392     enum BonusMode {
393         Flat,
394         Block,
395         Timestamp,
396         AmountRaised,
397         ContributionAmount
398     }
399 
400     BonusMode public bonusMode;
401 
402     uint256[] public bonusLevels;
403 
404     uint256[] public bonusRates; // coefficients in ether
405 
406     address public beneficiary;
407 
408     uint256 public amountRaised;
409 
410     uint256 public minContribution;
411 
412     uint256 public earlySuccessTimestamp;
413 
414     uint256 public earlySuccessBlock;
415 
416     mapping (address => uint256) public contributions;
417 
418     Token public token;
419 
420     enum Stage {
421         Init,
422         Ready,
423         InProgress,
424         Failure,
425         Success
426     }
427 
428     function stage()
429     public
430     constant
431     returns (Stage)
432     {
433         if (token == address(0)) {
434             return Stage.Init;
435         }
436 
437         var _time = timeMode == TimeMode.Timestamp ? block.timestamp : block.number;
438 
439         if (_time < startTime) {
440             return Stage.Ready;
441         }
442 
443         if (finishTime <= _time) {
444             if (amountRaised < fundingThreshold) {
445                 return Stage.Failure;
446             }
447             return Stage.Success;
448         }
449 
450         if (fundingGoal <= amountRaised) {
451             return Stage.Success;
452         }
453 
454         return Stage.InProgress;
455     }
456 
457     modifier atStage(Stage _stage) {
458         require(stage() == _stage);
459         _;
460     }
461 
462     event Contribution(address sender, uint256 amount);
463 
464     event Refund(address recipient, uint256 amount);
465 
466     event Payout(address recipient, uint256 amount);
467 
468     event EarlySuccess();
469 
470     function Campaign(
471         string _id,
472         address _beneficiary,
473         string _name,
474         string _website,
475         bytes32 _whitePaperHash
476     )
477     public
478     {
479         id = _id;
480         beneficiary = _beneficiary;
481         name = _name;
482         website = _website;
483         whitePaperHash = _whitePaperHash;
484     }
485 
486     function setParams(
487         // Params are combined to the array to avoid the “Stack too deep” error
488         uint256[] _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime,
489         uint8[] _timeMode_bonusMode,
490         uint256[] _bonusLevels,
491         uint256[] _bonusRates
492     )
493     public
494     onlyOwner
495     atStage(Stage.Init)
496     {
497         assert(fundingGoal == 0);
498 
499         fundingThreshold = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[0];
500         fundingGoal = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[1];
501         tokenPrice = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[2];
502         timeMode = TimeMode(_timeMode_bonusMode[0]);
503         startTime = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[3];
504         finishTime = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[4];
505         bonusMode = BonusMode(_timeMode_bonusMode[1]);
506         bonusLevels = _bonusLevels;
507         bonusRates = _bonusRates;
508 
509         require(fundingThreshold > 0);
510         require(fundingThreshold <= fundingGoal);
511         require(startTime < finishTime);
512         require((timeMode == TimeMode.Block ? block.number : block.timestamp) < startTime);
513         require(bonusLevels.length == bonusRates.length);
514     }
515 
516     function createToken(
517         string _tokenName,
518         string _tokenSymbol,
519         uint8 _tokenDecimals,
520         address[] _distributionRecipients,
521         uint256[] _distributionAmounts,
522         uint256[] _releaseTimes
523     )
524     public
525     onlyOwner
526     atStage(Stage.Init)
527     {
528         assert(fundingGoal > 0);
529 
530         token = new Token(
531             _tokenName,
532             _tokenSymbol,
533             _tokenDecimals,
534             _distributionRecipients,
535             _distributionAmounts,
536             _releaseTimes,
537             uint8(timeMode)
538         );
539 
540         minContribution = tokenPrice.div(10 ** uint256(token.decimals()));
541         if (minContribution < 1 wei) {
542             minContribution = 1 wei;
543         }
544     }
545 
546     function()
547     public
548     payable
549     atStage(Stage.InProgress)
550     {
551         require(minContribution <= msg.value);
552 
553         contributions[msg.sender] = contributions[msg.sender].add(msg.value);
554 
555         // Calculate bonus
556         uint256 _level;
557         uint256 _tokensAmount;
558         uint i;
559         if (bonusMode == BonusMode.AmountRaised) {
560             _level = amountRaised;
561             uint256 _value = msg.value;
562             uint256 _weightedRateSum = 0;
563             uint256 _stepAmount;
564             for (i = 0; i < bonusLevels.length; i++) {
565                 if (_level <= bonusLevels[i]) {
566                     _stepAmount = bonusLevels[i].sub(_level);
567                     if (_value <= _stepAmount) {
568                         _level = _level.add(_value);
569                         _weightedRateSum = _weightedRateSum.add(_value.mul(bonusRates[i]));
570                         _value = 0;
571                         break;
572                     } else {
573                         _level = _level.add(_stepAmount);
574                         _weightedRateSum = _weightedRateSum.add(_stepAmount.mul(bonusRates[i]));
575                         _value = _value.sub(_stepAmount);
576                     }
577                 }
578             }
579             _weightedRateSum = _weightedRateSum.add(_value.mul(1 ether));
580 
581             _tokensAmount = _weightedRateSum.div(1 ether).mul(10 ** uint256(token.decimals())).div(tokenPrice);
582         } else {
583             _tokensAmount = msg.value.mul(10 ** uint256(token.decimals())).div(tokenPrice);
584 
585             if (bonusMode == BonusMode.Block) {
586                 _level = block.number;
587             }
588             if (bonusMode == BonusMode.Timestamp) {
589                 _level = block.timestamp;
590             }
591             if (bonusMode == BonusMode.ContributionAmount) {
592                 _level = msg.value;
593             }
594 
595             for (i = 0; i < bonusLevels.length; i++) {
596                 if (_level <= bonusLevels[i]) {
597                     _tokensAmount = _tokensAmount.mul(bonusRates[i]).div(1 ether);
598                     break;
599                 }
600             }
601         }
602 
603         amountRaised = amountRaised.add(msg.value);
604 
605         // We don’t want more than the funding goal
606         require(amountRaised <= fundingGoal);
607 
608         require(token.mint(msg.sender, _tokensAmount));
609 
610         Contribution(msg.sender, msg.value);
611 
612         if (fundingGoal <= amountRaised) {
613             earlySuccessTimestamp = block.timestamp;
614             earlySuccessBlock = block.number;
615             token.finishMinting();
616             EarlySuccess();
617         }
618     }
619 
620     function withdrawPayout()
621     public
622     atStage(Stage.Success)
623     {
624         require(msg.sender == beneficiary);
625 
626         if (!token.mintingFinished()) {
627             token.finishMinting();
628         }
629 
630         var _amount = this.balance;
631         require(beneficiary.call.value(_amount)());
632         Payout(beneficiary, _amount);
633     }
634 
635     // Anyone can make tokens available when the campaign is successful
636     function releaseTokens()
637     public
638     atStage(Stage.Success)
639     {
640         require(!token.mintingFinished());
641         token.finishMinting();
642     }
643 
644     function withdrawRefund()
645     public
646     atStage(Stage.Failure)
647     nonReentrant
648     {
649         var _amount = contributions[msg.sender];
650 
651         require(_amount > 0);
652 
653         contributions[msg.sender] = 0;
654 
655         msg.sender.transfer(_amount);
656         Refund(msg.sender, _amount);
657     }
658 }
659 
660 contract Token is MintableToken, NoOwner {
661     string constant public version = "1.0.0";
662 
663     string public name;
664 
665     string public symbol;
666 
667     uint8 public decimals;
668 
669     enum TimeMode {
670         Block,
671         Timestamp
672     }
673 
674     TimeMode public timeMode;
675 
676     mapping (address => uint256) public releaseTimes;
677 
678     function Token(
679         string _name,
680         string _symbol,
681         uint8 _decimals,
682         address[] _recipients,
683         uint256[] _amounts,
684         uint256[] _releaseTimes,
685         uint8 _timeMode
686     )
687     public
688     {
689         require(_recipients.length == _amounts.length);
690         require(_recipients.length == _releaseTimes.length);
691 
692         name = _name;
693         symbol = _symbol;
694         decimals = _decimals;
695         timeMode = TimeMode(_timeMode);
696 
697         // Mint pre-distributed tokens
698         for (uint256 i = 0; i < _recipients.length; i++) {
699             mint(_recipients[i], _amounts[i]);
700             if (_releaseTimes[i] > 0) {
701                 releaseTimes[_recipients[i]] = _releaseTimes[i];
702             }
703         }
704     }
705 
706     function transfer(address _to, uint256 _value)
707     public
708     returns (bool)
709     {
710         // Transfer is forbidden until minting is finished
711         require(mintingFinished);
712 
713         // Transfer of time-locked funds is forbidden
714         require(!timeLocked(msg.sender));
715 
716         return super.transfer(_to, _value);
717     }
718 
719     function transferFrom(address _from, address _to, uint256 _value)
720     public
721     returns (bool)
722     {
723         // Transfer is forbidden until minting is finished
724         require(mintingFinished);
725 
726         // Transfer of time-locked funds is forbidden
727         require(!timeLocked(_from));
728 
729         return super.transferFrom(_from, _to, _value);
730     }
731 
732     // Checks if funds of a given address are time-locked
733     function timeLocked(address _spender)
734     public
735     constant
736     returns (bool)
737     {
738         if (releaseTimes[_spender] == 0) {
739             return false;
740         }
741 
742         // If time-lock is expired, delete it
743         var _time = timeMode == TimeMode.Timestamp ? block.timestamp : block.number;
744         if (releaseTimes[_spender] <= _time) {
745             delete releaseTimes[_spender];
746             return false;
747         }
748 
749         return true;
750     }
751 }