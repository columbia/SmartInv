1 pragma solidity 0.4.18;
2 
3 contract ReentrancyGuard {
4 
5   /**
6    * @dev We use a single lock for the whole contract.
7    */
8   bool private rentrancy_lock = false;
9 
10   /**
11    * @dev Prevents a contract from calling itself, directly or indirectly.
12    * @notice If you mark a function `nonReentrant`, you should also
13    * mark it `external`. Calling one nonReentrant function from
14    * another is not supported. Instead, you can implement a
15    * `private` function doing the actual work, and a `external`
16    * wrapper marked as `nonReentrant`.
17    */
18   modifier nonReentrant() {
19     require(!rentrancy_lock);
20     rentrancy_lock = true;
21     _;
22     rentrancy_lock = false;
23   }
24 
25 }
26 
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function div(uint256 a, uint256 b) internal constant returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) onlyOwner public {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 contract Claimable is Ownable {
91   address public pendingOwner;
92 
93   /**
94    * @dev Modifier throws if called by any account other than the pendingOwner.
95    */
96   modifier onlyPendingOwner() {
97     require(msg.sender == pendingOwner);
98     _;
99   }
100 
101   /**
102    * @dev Allows the current owner to set the pendingOwner address.
103    * @param newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address newOwner) onlyOwner public {
106     pendingOwner = newOwner;
107   }
108 
109   /**
110    * @dev Allows the pendingOwner address to finalize the transfer.
111    */
112   function claimOwnership() onlyPendingOwner public {
113     OwnershipTransferred(owner, pendingOwner);
114     owner = pendingOwner;
115     pendingOwner = 0x0;
116   }
117 }
118 
119 contract HasNoContracts is Ownable {
120 
121   /**
122    * @dev Reclaim ownership of Ownable contracts
123    * @param contractAddr The address of the Ownable to be reclaimed.
124    */
125   function reclaimContract(address contractAddr) external onlyOwner {
126     Ownable contractInst = Ownable(contractAddr);
127     contractInst.transferOwnership(owner);
128   }
129 }
130 
131 contract HasNoEther is Ownable {
132 
133   /**
134   * @dev Constructor that rejects incoming Ether
135   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
136   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
137   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
138   * we could use assembly to access msg.value.
139   */
140   function HasNoEther() payable {
141     require(msg.value == 0);
142   }
143 
144   /**
145    * @dev Disallows direct send by settings a default function without the `payable` flag.
146    */
147   function() external {
148   }
149 
150   /**
151    * @dev Transfer all Ether held by the contract to the owner.
152    */
153   function reclaimEther() external onlyOwner {
154     assert(owner.send(this.balance));
155   }
156 }
157 
158 contract ERC20Basic {
159   uint256 public totalSupply;
160   function balanceOf(address who) public constant returns (uint256);
161   function transfer(address to, uint256 value) public returns (bool);
162   event Transfer(address indexed from, address indexed to, uint256 value);
163 }
164 
165 contract BasicToken is ERC20Basic {
166   using SafeMath for uint256;
167 
168   mapping(address => uint256) balances;
169 
170   /**
171   * @dev transfer token for a specified address
172   * @param _to The address to transfer to.
173   * @param _value The amount to be transferred.
174   */
175   function transfer(address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177 
178     // SafeMath.sub will throw if there is not enough balance.
179     balances[msg.sender] = balances[msg.sender].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     Transfer(msg.sender, _to, _value);
182     return true;
183   }
184 
185   /**
186   * @dev Gets the balance of the specified address.
187   * @param _owner The address to query the the balance of.
188   * @return An uint256 representing the amount owned by the passed address.
189   */
190   function balanceOf(address _owner) public constant returns (uint256 balance) {
191     return balances[_owner];
192   }
193 
194 }
195 
196 contract ERC20 is ERC20Basic {
197   function allowance(address owner, address spender) public constant returns (uint256);
198   function transferFrom(address from, address to, uint256 value) public returns (bool);
199   function approve(address spender, uint256 value) public returns (bool);
200   event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 
203 library SafeERC20 {
204   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
205     assert(token.transfer(to, value));
206   }
207 
208   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
209     assert(token.transferFrom(from, to, value));
210   }
211 
212   function safeApprove(ERC20 token, address spender, uint256 value) internal {
213     assert(token.approve(spender, value));
214   }
215 }
216 
217 contract CanReclaimToken is Ownable {
218   using SafeERC20 for ERC20Basic;
219 
220   /**
221    * @dev Reclaim all ERC20Basic compatible tokens
222    * @param token ERC20Basic The address of the token contract
223    */
224   function reclaimToken(ERC20Basic token) external onlyOwner {
225     uint256 balance = token.balanceOf(this);
226     token.safeTransfer(owner, balance);
227   }
228 
229 }
230 
231 contract HasNoTokens is CanReclaimToken {
232 
233  /**
234   * @dev Reject all ERC23 compatible tokens
235   * @param from_ address The address that is transferring the tokens
236   * @param value_ uint256 the amount of the specified token
237   * @param data_ Bytes The data passed from the caller.
238   */
239   function tokenFallback(address from_, uint256 value_, bytes data_) external {
240     revert();
241   }
242 
243 }
244 
245 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
246 }
247 
248 contract StandardToken is ERC20, BasicToken {
249 
250   mapping (address => mapping (address => uint256)) allowed;
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
260     require(_to != address(0));
261 
262     uint256 _allowance = allowed[_from][msg.sender];
263 
264     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
265     // require (_value <= _allowance);
266 
267     balances[_from] = balances[_from].sub(_value);
268     balances[_to] = balances[_to].add(_value);
269     allowed[_from][msg.sender] = _allowance.sub(_value);
270     Transfer(_from, _to, _value);
271     return true;
272   }
273 
274   /**
275    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
276    *
277    * Beware that changing an allowance with this method brings the risk that someone may use both the old
278    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
279    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
280    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281    * @param _spender The address which will spend the funds.
282    * @param _value The amount of tokens to be spent.
283    */
284   function approve(address _spender, uint256 _value) public returns (bool) {
285     allowed[msg.sender][_spender] = _value;
286     Approval(msg.sender, _spender, _value);
287     return true;
288   }
289 
290   /**
291    * @dev Function to check the amount of tokens that an owner allowed to a spender.
292    * @param _owner address The address which owns the funds.
293    * @param _spender address The address which will spend the funds.
294    * @return A uint256 specifying the amount of tokens still available for the spender.
295    */
296   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
297     return allowed[_owner][_spender];
298   }
299 
300   /**
301    * approve should be called when allowed[_spender] == 0. To increment
302    * allowed value is better to use this function to avoid 2 calls (and wait until
303    * the first transaction is mined)
304    * From MonolithDAO Token.sol
305    */
306   function increaseApproval (address _spender, uint _addedValue)
307     returns (bool success) {
308     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
309     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313   function decreaseApproval (address _spender, uint _subtractedValue)
314     returns (bool success) {
315     uint oldValue = allowed[msg.sender][_spender];
316     if (_subtractedValue > oldValue) {
317       allowed[msg.sender][_spender] = 0;
318     } else {
319       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
320     }
321     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325 }
326 
327 contract MintableToken is StandardToken, Ownable {
328   event Mint(address indexed to, uint256 amount);
329   event MintFinished();
330 
331   bool public mintingFinished = false;
332 
333 
334   modifier canMint() {
335     require(!mintingFinished);
336     _;
337   }
338 
339   /**
340    * @dev Function to mint tokens
341    * @param _to The address that will receive the minted tokens.
342    * @param _amount The amount of tokens to mint.
343    * @return A boolean that indicates if the operation was successful.
344    */
345   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
346     totalSupply = totalSupply.add(_amount);
347     balances[_to] = balances[_to].add(_amount);
348     Mint(_to, _amount);
349     Transfer(0x0, _to, _amount);
350     return true;
351   }
352 
353   /**
354    * @dev Function to stop minting new tokens.
355    * @return True if the operation was successful.
356    */
357   function finishMinting() onlyOwner public returns (bool) {
358     mintingFinished = true;
359     MintFinished();
360     return true;
361   }
362 }
363 
364 contract Campaign is Claimable, HasNoTokens, ReentrancyGuard {
365     using SafeMath for uint256;
366 
367     string constant public version = "1.0.0";
368 
369     string public id;
370 
371     string public name;
372 
373     string public website;
374 
375     bytes32 public whitePaperHash;
376 
377     uint256 public fundingThreshold;
378 
379     uint256 public fundingGoal;
380 
381     uint256 public tokenPrice;
382 
383     enum TimeMode {
384         Block,
385         Timestamp
386     }
387 
388     TimeMode public timeMode;
389 
390     uint256 public startTime;
391 
392     uint256 public finishTime;
393 
394     enum BonusMode {
395         Flat,
396         Block,
397         Timestamp,
398         AmountRaised,
399         ContributionAmount
400     }
401 
402     BonusMode public bonusMode;
403 
404     uint256[] public bonusLevels;
405 
406     uint256[] public bonusRates; // coefficients in ether
407 
408     address public beneficiary;
409 
410     uint256 public amountRaised;
411 
412     uint256 public minContribution;
413 
414     uint256 public earlySuccessTimestamp;
415 
416     uint256 public earlySuccessBlock;
417 
418     mapping (address => uint256) public contributions;
419 
420     Token public token;
421 
422     enum Stage {
423         Init,
424         Ready,
425         InProgress,
426         Failure,
427         Success
428     }
429 
430     function stage()
431     public
432     constant
433     returns (Stage)
434     {
435         if (token == address(0)) {
436             return Stage.Init;
437         }
438 
439         var _time = timeMode == TimeMode.Timestamp ? block.timestamp : block.number;
440 
441         if (_time < startTime) {
442             return Stage.Ready;
443         }
444 
445         if (finishTime <= _time) {
446             if (amountRaised < fundingThreshold) {
447                 return Stage.Failure;
448             }
449             return Stage.Success;
450         }
451 
452         if (fundingGoal <= amountRaised) {
453             return Stage.Success;
454         }
455 
456         return Stage.InProgress;
457     }
458 
459     modifier atStage(Stage _stage) {
460         require(stage() == _stage);
461         _;
462     }
463 
464     event Contribution(address sender, uint256 amount);
465 
466     event Refund(address recipient, uint256 amount);
467 
468     event Payout(address recipient, uint256 amount);
469 
470     event EarlySuccess();
471 
472     function Campaign(
473         string _id,
474         address _beneficiary,
475         string _name,
476         string _website,
477         bytes32 _whitePaperHash
478     )
479     public
480     {
481         id = _id;
482         beneficiary = _beneficiary;
483         name = _name;
484         website = _website;
485         whitePaperHash = _whitePaperHash;
486     }
487 
488     function setParams(
489         // Params are combined to the array to avoid the “Stack too deep” error
490         uint256[] _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime,
491         uint8[] _timeMode_bonusMode,
492         uint256[] _bonusLevels,
493         uint256[] _bonusRates
494     )
495     public
496     onlyOwner
497     atStage(Stage.Init)
498     {
499         assert(fundingGoal == 0);
500 
501         fundingThreshold = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[0];
502         fundingGoal = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[1];
503         tokenPrice = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[2];
504         timeMode = TimeMode(_timeMode_bonusMode[0]);
505         startTime = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[3];
506         finishTime = _fundingThreshold_fundingGoal_tokenPrice_startTime_finishTime[4];
507         bonusMode = BonusMode(_timeMode_bonusMode[1]);
508         bonusLevels = _bonusLevels;
509         bonusRates = _bonusRates;
510 
511         require(fundingThreshold > 0);
512         require(fundingThreshold <= fundingGoal);
513         require(startTime < finishTime);
514         require((timeMode == TimeMode.Block ? block.number : block.timestamp) < startTime);
515         require(bonusLevels.length == bonusRates.length);
516     }
517 
518     function createToken(
519         string _tokenName,
520         string _tokenSymbol,
521         uint8 _tokenDecimals,
522         address[] _distributionRecipients,
523         uint256[] _distributionAmounts,
524         uint256[] _releaseTimes
525     )
526     public
527     onlyOwner
528     atStage(Stage.Init)
529     {
530         assert(fundingGoal > 0);
531 
532         token = new Token(
533         _tokenName,
534         _tokenSymbol,
535         _tokenDecimals,
536         _distributionRecipients,
537         _distributionAmounts,
538         _releaseTimes,
539         uint8(timeMode)
540         );
541 
542         minContribution = tokenPrice.div(10 ** uint256(token.decimals()));
543         if (minContribution < 1 wei) {
544             minContribution = 1 wei;
545         }
546     }
547 
548     function()
549     public
550     payable
551     atStage(Stage.InProgress)
552     {
553         require(minContribution <= msg.value);
554 
555         contributions[msg.sender] = contributions[msg.sender].add(msg.value);
556 
557         // Calculate bonus
558         uint256 _level;
559         uint256 _tokensAmount;
560         uint i;
561         if (bonusMode == BonusMode.AmountRaised) {
562             _level = amountRaised;
563             uint256 _value = msg.value;
564             uint256 _weightedRateSum = 0;
565             uint256 _stepAmount;
566             for (i = 0; i < bonusLevels.length; i++) {
567                 if (_level <= bonusLevels[i]) {
568                     _stepAmount = bonusLevels[i].sub(_level);
569                     if (_value <= _stepAmount) {
570                         _level = _level.add(_value);
571                         _weightedRateSum = _weightedRateSum.add(_value.mul(bonusRates[i]));
572                         _value = 0;
573                         break;
574                     } else {
575                         _level = _level.add(_stepAmount);
576                         _weightedRateSum = _weightedRateSum.add(_stepAmount.mul(bonusRates[i]));
577                         _value = _value.sub(_stepAmount);
578                     }
579                 }
580             }
581             _weightedRateSum = _weightedRateSum.add(_value.mul(1 ether));
582 
583             _tokensAmount = _weightedRateSum.div(1 ether).mul(10 ** uint256(token.decimals())).div(tokenPrice);
584         } else {
585             _tokensAmount = msg.value.mul(10 ** uint256(token.decimals())).div(tokenPrice);
586 
587             if (bonusMode == BonusMode.Block) {
588                 _level = block.number;
589             }
590             if (bonusMode == BonusMode.Timestamp) {
591                 _level = block.timestamp;
592             }
593             if (bonusMode == BonusMode.ContributionAmount) {
594                 _level = msg.value;
595             }
596 
597             for (i = 0; i < bonusLevels.length; i++) {
598                 if (_level <= bonusLevels[i]) {
599                     _tokensAmount = _tokensAmount.mul(bonusRates[i]).div(1 ether);
600                     break;
601                 }
602             }
603         }
604 
605         amountRaised = amountRaised.add(msg.value);
606 
607         // We don’t want more than the funding goal
608         require(amountRaised <= fundingGoal);
609 
610         require(token.mint(msg.sender, _tokensAmount));
611 
612         Contribution(msg.sender, msg.value);
613 
614         if (fundingGoal <= amountRaised) {
615             earlySuccessTimestamp = block.timestamp;
616             earlySuccessBlock = block.number;
617             token.finishMinting();
618             EarlySuccess();
619         }
620     }
621 
622     function withdrawPayout()
623     public
624     atStage(Stage.Success)
625     {
626         require(msg.sender == beneficiary);
627 
628         if (!token.mintingFinished()) {
629             token.finishMinting();
630         }
631 
632         var _amount = this.balance;
633         require(beneficiary.call.value(_amount)());
634         Payout(beneficiary, _amount);
635     }
636 
637     // Anyone can make tokens available when the campaign is successful
638     function releaseTokens()
639     public
640     atStage(Stage.Success)
641     {
642         require(!token.mintingFinished());
643         token.finishMinting();
644     }
645 
646     function withdrawRefund()
647     public
648     atStage(Stage.Failure)
649     nonReentrant
650     {
651         var _amount = contributions[msg.sender];
652 
653         require(_amount > 0);
654 
655         contributions[msg.sender] = 0;
656 
657         msg.sender.transfer(_amount);
658         Refund(msg.sender, _amount);
659     }
660 }
661 
662 contract Token is MintableToken, NoOwner {
663     string constant public version = "1.0.0";
664 
665     string public name;
666 
667     string public symbol;
668 
669     uint8 public decimals;
670 
671     enum TimeMode {
672         Block,
673         Timestamp
674     }
675 
676     TimeMode public timeMode;
677 
678     mapping (address => uint256) public releaseTimes;
679 
680     function Token(
681         string _name,
682         string _symbol,
683         uint8 _decimals,
684         address[] _recipients,
685         uint256[] _amounts,
686         uint256[] _releaseTimes,
687         uint8 _timeMode
688     )
689     public
690     {
691         require(_recipients.length == _amounts.length);
692         require(_recipients.length == _releaseTimes.length);
693 
694         name = _name;
695         symbol = _symbol;
696         decimals = _decimals;
697         timeMode = TimeMode(_timeMode);
698 
699         // Mint pre-distributed tokens
700         for (uint8 i = 0; i < _recipients.length; i++) {
701             mint(_recipients[i], _amounts[i]);
702             if (_releaseTimes[i] > 0) {
703                 releaseTimes[_recipients[i]] = _releaseTimes[i];
704             }
705         }
706     }
707 
708     function transfer(address _to, uint256 _value)
709     public
710     returns (bool)
711     {
712         // Transfer is forbidden until minting is finished
713         require(mintingFinished);
714 
715         // Transfer of time-locked funds is forbidden
716         require(!timeLocked(msg.sender));
717 
718         return super.transfer(_to, _value);
719     }
720 
721     function transferFrom(address _from, address _to, uint256 _value)
722     public
723     returns (bool)
724     {
725         // Transfer is forbidden until minting is finished
726         require(mintingFinished);
727 
728         // Transfer of time-locked funds is forbidden
729         require(!timeLocked(_from));
730 
731         return super.transferFrom(_from, _to, _value);
732     }
733 
734     // Checks if funds of a given address are time-locked
735     function timeLocked(address _spender)
736     public
737     returns (bool)
738     {
739         if (releaseTimes[_spender] == 0) {
740             return false;
741         }
742 
743         // If time-lock is expired, delete it
744         var _time = timeMode == TimeMode.Timestamp ? block.timestamp : block.number;
745         if (releaseTimes[_spender] <= _time) {
746             delete releaseTimes[_spender];
747             return false;
748         }
749 
750         return true;
751     }
752 }