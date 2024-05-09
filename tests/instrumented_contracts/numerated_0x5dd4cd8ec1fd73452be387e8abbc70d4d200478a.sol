1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title AccessDelegated
5  * @dev Modified version of standard Ownable Contract
6  * The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 
10 
11 contract IReputationToken {
12     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
13     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
14     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
15     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
16     function trustedDisputeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
17     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
18     function getUniverse() public view returns (IUniverse);
19     function getTotalMigrated() public view returns (uint256);
20     function getTotalTheoreticalSupply() public view returns (uint256);
21     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
22 }
23 
24 contract IUniverse {
25     
26     function createYesNoMarket(uint256 _endTime, uint256 _feePerEthInWei, address _designatedReporterAddress, address _denominationToken, bytes32 _topic, string memory _description, string memory _extraInfo) public payable;
27     
28     function fork() public returns (bool);
29     function getParentUniverse() public view returns (IUniverse);
30     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
31     function getForkEndTime() public view returns (uint256);
32     function getForkReputationGoal() public view returns (uint256);
33     function getParentPayoutDistributionHash() public view returns (bytes32);
34     function getDisputeRoundDurationInSeconds() public view returns (uint256);
35     function getOpenInterestInAttoEth() public view returns (uint256);
36     function getRepMarketCapInAttoEth() public view returns (uint256);
37     function getTargetRepMarketCapInAttoEth() public view returns (uint256);
38     function getOrCacheValidityBond() public returns (uint256);
39     function getOrCacheDesignatedReportStake() public returns (uint256);
40     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
41     function getOrCacheReportingFeeDivisor() public returns (uint256);
42     function getDisputeThresholdForFork() public view returns (uint256);
43     function getDisputeThresholdForDisputePacing() public view returns (uint256);
44     function getInitialReportMinValue() public view returns (uint256);
45     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
46     function getOrCacheMarketCreationCost() public returns (uint256);
47     function isParentOf(IUniverse _shadyChild) public view returns (bool);
48     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
49     function addMarketTo() public returns (bool);
50     function removeMarketFrom() public returns (bool);
51     function decrementOpenInterest(uint256 _amount) public returns (bool);
52     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
53     function incrementOpenInterest(uint256 _amount) public returns (bool);
54     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
55     function getWinningChildUniverse() public view returns (IUniverse);
56     function isForking() public view returns (bool);
57 }
58 
59 
60 contract AccessDelegated {
61 
62   /**
63    * @dev ownership set via mapping with the following levels of access:
64    * 0 - access level given to all addresses by default
65    * 1 - limited access
66    * 2 - priveleged access
67    * 3 - manager access
68    * 4 - owner access
69    */
70 
71     mapping(address => uint256) public accessLevel;
72 
73     event AccessLevelSet(
74         address accessSetFor,
75         uint256 accessLevel,
76         address setBy
77     );
78     event AccessRevoked(
79         address accessRevoked,
80         uint256 previousAccessLevel,
81         address revokedBy
82     );
83 
84 
85     /**
86     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87     * account.
88     */
89     constructor() public {
90         accessLevel[msg.sender] = 4;
91     }
92 
93     /// Modifiers to restrict access to only those ABOVE a specific access level
94 
95     modifier requiresNoAccessLevel () {
96         require(
97             accessLevel[msg.sender] >= 0,
98             "Access level greater than or equal to 0 required"
99         );
100         _;
101     }
102 
103     modifier requiresLimitedAccessLevel () {
104         require(
105             accessLevel[msg.sender] >= 1,
106             "Access level greater than or equal to 1 required"
107         );
108         _;
109     }
110 
111     modifier requiresPrivelegedAccessLevel () {
112         require(
113             accessLevel[msg.sender] >= 2,
114             "Access level greater than or equal to 2 required"
115         );
116         _;
117     }
118 
119     modifier requiresManagerAccessLevel () {
120         require(
121             accessLevel[msg.sender] >= 3,
122             "Access level greater than or equal to 3 required"
123         );
124         _;
125     }
126 
127     modifier requiresOwnerAccessLevel () {
128         require(
129             accessLevel[msg.sender] >= 4,
130             "Access level greater than or equal to 4 required"
131         );
132         _;
133     }
134 
135     /// Modifiers to restrict access to ONLY a specific access level
136 
137     modifier limitedAccessLevelOnly () {
138         require(accessLevel[msg.sender] == 1, "Access level 1 required");
139         _;
140     }
141 
142     modifier privelegedAccessLevelOnly () {
143         require(accessLevel[msg.sender] == 2, "Access level 2 required");
144         _;
145     }
146 
147     modifier managerAccessLevelOnly () {
148         require(accessLevel[msg.sender] == 3, "Access level 3 required");
149         _;
150     }
151 
152     modifier adminAccessLevelOnly () {
153         require(accessLevel[msg.sender] == 4, "Access level 4 required");
154         _;
155     }
156 
157 
158     /**
159      * @dev setAccessLevel for a user restricted to contract owner
160      * @dev Ideally, check for whole number should be implemented (TODO)
161      * @param _user address that access level is to be set for
162      * @param _access uint256 level of access to give 0, 1, 2, 3.
163      */
164     function setAccessLevel(
165         address _user,
166         uint256 _access
167     )
168         public
169         adminAccessLevelOnly
170     {
171         require(
172             accessLevel[_user] < 4,
173             "Cannot setAccessLevel for Admin Level Access User"
174         ); /// owner access not allowed to be set
175 
176         if (_access < 0 || _access > 4) {
177             revert("erroneous access level");
178         } else {
179             accessLevel[_user] = _access;
180         }
181 
182         emit AccessLevelSet(_user, _access, msg.sender);
183     }
184 
185     function revokeAccess(address _user) public adminAccessLevelOnly {
186         /// admin cannot revoke own access
187         require(
188             accessLevel[_user] < 4,
189             "admin cannot revoke their own access"
190         );
191         uint256 currentAccessLevel = accessLevel[_user];
192         accessLevel[_user] = 0;
193 
194         emit AccessRevoked(_user, currentAccessLevel, msg.sender);
195     }
196 
197     /**
198      * @dev getAccessLevel for a _user given their address
199      * @param _user address of user to return access level
200      * @return uint256 access level of _user
201      */
202     function getAccessLevel(address _user) public view returns (uint256) {
203         return accessLevel[_user];
204     }
205 
206     /**
207      * @dev helper function to make calls more efficient
208      * @return uint256 access level of the caller
209      */
210     function myAccessLevel() public view returns (uint256) {
211         return getAccessLevel(msg.sender);
212     }
213 
214 }
215 
216 // contract accessRestrictions {
217 
218 //     mapping(address => mapping(uint => uint)) public transactionLimits;
219 
220 //     /// COUNT OF USERS WITH ACCESS LEVELS FOR LIMITATION AND RECORD KEEPING
221 // }
222 
223 /**
224 * @title ERC20Basic
225 * @dev Simpler version of ERC20 interface
226 * See https://github.com/ethereum/EIPs/issues/179
227 */
228 contract ERC20Basic {
229     function totalSupply() public view returns (uint256);
230     function balanceOf(address who) public view returns (uint256);
231     function transfer(address to, uint256 value) public returns (bool);
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 }
234 
235 
236 /**
237 * @title SafeMath
238 * @dev Math operations with safety checks that throw on error
239 */
240 library SafeMath {
241 
242     /**
243     * @dev Multiplies two numbers, throws on overflow.
244     */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
246         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
247         // benefit is lost if 'b' is also tested.
248         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
249         if (a == 0) {
250             return 0;
251         }
252 
253         c = a * b;
254         assert(c / a == b);
255         return c;
256     }
257 
258     /**
259     * @dev Integer division of two numbers, truncating the quotient.
260     */
261     function div(uint256 a, uint256 b) internal pure returns (uint256) {
262         // assert(b > 0); // Solidity automatically throws when dividing by 0
263         // uint256 c = a / b;
264         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265         return a / b;
266     }
267 
268     /**
269     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
270     */
271     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
272         assert(b <= a);
273         return a - b;
274     }
275 
276     /**
277     * @dev Adds two numbers, throws on overflow.
278     */
279     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
280         c = a + b;
281         assert(c >= a);
282         return c;
283     }
284 }
285 
286 
287 /**
288 * @title Basic token
289 * @dev Basic version of StandardToken, with no allowances.
290 */
291 contract BasicToken is ERC20Basic {
292     using SafeMath for uint256;
293 
294     mapping(address => uint256) balances;
295 
296     uint256 totalSupply_;
297 
298     /**
299     * @dev Total number of tokens in existence
300     */
301     function totalSupply() public view returns (uint256) {
302         return totalSupply_;
303     }
304 
305     /**
306     * @dev Transfer token for a specified address
307     * @param _to The address to transfer to.
308     * @param _value The amount to be transferred.
309     */
310     function transfer(address _to, uint256 _value) public returns (bool) {
311         require(_to != address(0));
312         require(_value <= balances[msg.sender]);
313 
314         balances[msg.sender] = balances[msg.sender].sub(_value);
315         balances[_to] = balances[_to].add(_value);
316         emit Transfer(msg.sender, _to, _value);
317         return true;
318     }
319 
320     /**
321     * @dev Gets the balance of the specified address.
322     * @param _owner The address to query the the balance of.
323     * @return An uint256 representing the amount owned by the passed address.
324     */
325     function balanceOf(address _owner) public view returns (uint256) {
326         return balances[_owner];
327     }
328 
329 }
330 
331 
332 /**
333 * @title ERC20 interface
334 * @dev see https://github.com/ethereum/EIPs/issues/20
335 */
336 contract ERC20 is ERC20Basic {
337     function allowance(address owner, address spender)
338         public view returns (uint256);
339 
340     function transferFrom(address from, address to, uint256 value)
341         public returns (bool);
342 
343     function approve(address spender, uint256 value) public returns (bool);
344     event Approval(
345         address indexed owner,
346         address indexed spender,
347         uint256 value
348     );
349 }
350 
351 
352 /**
353 * @title Standard ERC20 token
354 *
355 * @dev Implementation of the basic standard token.
356 * https://github.com/ethereum/EIPs/issues/20
357 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
358 */
359 contract Token is ERC20, BasicToken {
360 
361     mapping (address => mapping (address => uint256)) internal allowed;
362 
363 
364     /**
365     * @dev Transfer tokens from one address to another
366     * @param _from address The address which you want to send tokens from
367     * @param _to address The address which you want to transfer to
368     * @param _value uint256 the amount of tokens to be transferred
369     */
370     function transferFrom(
371         address _from,
372         address _to,
373         uint256 _value
374     )
375         public
376         returns (bool)
377     {
378         require(_to != address(0));
379         require(_value <= balances[_from]);
380         require(_value <= allowed[_from][msg.sender]);
381 
382         balances[_from] = balances[_from].sub(_value);
383         balances[_to] = balances[_to].add(_value);
384         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
385         emit Transfer(_from, _to, _value);
386         return true;
387     }
388 
389     /**
390     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
391     * Beware that changing an allowance with this method brings the risk that someone may use both the old
392     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
393     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
394     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
395     * @param _spender The address which will spend the funds.
396     * @param _value The amount of tokens to be spent.
397     */
398     function approve(address _spender, uint256 _value) public returns (bool) {
399         allowed[msg.sender][_spender] = _value;
400         emit Approval(msg.sender, _spender, _value);
401         return true;
402     }
403 
404     /**
405     * @dev Function to check the amount of tokens that an owner allowed to a spender.
406     * @param _owner address The address which owns the funds.
407     * @param _spender address The address which will spend the funds.
408     * @return A uint256 specifying the amount of tokens still available for the spender.
409     */
410     function allowance(
411         address _owner,
412         address _spender
413     )
414         public
415         view
416         returns (uint256)
417     {
418         return allowed[_owner][_spender];
419     }
420 
421     /**
422     * @dev Increase the amount of tokens that an owner allowed to a spender.
423     * approve should be called when allowed[_spender] == 0. To increment
424     * allowed value is better to use this function to avoid 2 calls (and wait until
425     * the first transaction is mined)
426     * From MonolithDAO Token.sol
427     * @param _spender The address which will spend the funds.
428     * @param _addedValue The amount of tokens to increase the allowance by.
429     */
430     function increaseApproval(
431         address _spender,
432         uint256 _addedValue
433     )
434         public
435         returns (bool)
436     {
437         allowed[msg.sender][_spender] = (
438         allowed[msg.sender][_spender].add(_addedValue));
439         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
440         return true;
441     }
442 
443     /**
444     * @dev Decrease the amount of tokens that an owner allowed to a spender.
445     * approve should be called when allowed[_spender] == 0. To decrement
446     * allowed value is better to use this function to avoid 2 calls (and wait until
447     * the first transaction is mined)
448     * From MonolithDAO Token.sol
449     * @param _spender The address which will spend the funds.
450     * @param _subtractedValue The amount of tokens to decrease the allowance by.
451     */
452     function decreaseApproval(
453         address _spender,
454         uint256 _subtractedValue
455     )
456         public
457         returns (bool)
458     {
459         uint256 oldValue = allowed[msg.sender][_spender];
460         if (_subtractedValue > oldValue) {
461             allowed[msg.sender][_spender] = 0;
462         } else {
463             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
464         }
465         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
466         return true;
467     }
468 
469 }
470 
471 /**
472      * @title StakeToken
473      */
474 contract StakeToken is Token {
475 
476     string public constant NAME = "TestTokenERC20"; // solium-disable-line uppercase
477     string public constant SYMBOL = "T20"; // solium-disable-line uppercase
478     uint8 public constant DECIMALS = 18; // solium-disable-line uppercase
479     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(DECIMALS));
480 
481     /**
482     * @dev Constructor that gives msg.sender all of existing tokens.
483     */
484     constructor() public {
485         totalSupply_ = INITIAL_SUPPLY;
486         balances[msg.sender] = INITIAL_SUPPLY;
487         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
488     }
489 
490     /**
491      * @notice get some tokens to use for testing purposes
492      * @dev mints some tokens to the function caller
493      */
494     function giveMeTokens() public {
495         balances[msg.sender] += INITIAL_SUPPLY;
496         totalSupply_ += INITIAL_SUPPLY;
497     }
498 }
499 
500 contract StakingContract {
501     using SafeMath for *;
502 
503     event TokensStaked(address msgSender, address txOrigin, uint256 _amount);
504 
505     address public stakingTokenAddress;
506 
507     // Token used for staking
508     StakeToken stakingToken;
509 
510     // The default duration of stake lock-in (in seconds)
511     uint256 public defaultLockInDuration;
512 
513     // To save on gas, rather than create a separate mapping for totalStakedFor & personalStakes,
514     //  both data structures are stored in a single mapping for a given addresses.
515     //
516     // It's possible to have a non-existing personalStakes, but have tokens in totalStakedFor
517     //  if other users are staking on behalf of a given address.
518     mapping (address => StakeContract) public stakeHolders;
519 
520     // Struct for personal stakes (i.e., stakes made by this address)
521     // unlockedTimestamp - when the stake unlocks (in seconds since Unix epoch)
522     // actualAmount - the amount of tokens in the stake
523     // stakedFor - the address the stake was staked for
524     struct Stake {
525         uint256 unlockedTimestamp;
526         uint256 actualAmount;
527         address stakedFor;
528     }
529 
530     // Struct for all stake metadata at a particular address
531     // totalStakedFor - the number of tokens staked for this address
532     // personalStakeIndex - the index in the personalStakes array.
533     // personalStakes - append only array of stakes made by this address
534     // exists - whether or not there are stakes that involve this address
535     struct StakeContract {
536         uint256 totalStakedFor;
537 
538         uint256 personalStakeIndex;
539 
540         Stake[] personalStakes;
541 
542         bool exists;
543     }
544 
545     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
546     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
547 
548 
549     constructor() public {
550 
551     }
552 
553     modifier canStake(address _address, uint256 _amount) {
554         require(
555             stakingToken.transferFrom(_address, address(this), _amount),
556             "Stake required");
557         _;
558     }
559 
560 
561     function initForTests(address _token) public {
562         stakingTokenAddress = _token;
563         // StakeToken(stakingTokenAddress).giveMeTokens();
564         // StakeToken(stakingTokenAddress).balanceOf(this);
565         stakingToken = StakeToken(stakingTokenAddress);
566     }
567 
568 
569     function stake(uint256 _amount) public returns (bool) {
570         createStake(
571             msg.sender,
572             _amount);
573         return true;
574     }
575 
576 
577     function createStake(
578         address _address,
579         uint256 _amount
580     )
581         internal
582         canStake(msg.sender, _amount)
583     {
584         if (!stakeHolders[msg.sender].exists) {
585             stakeHolders[msg.sender].exists = true;
586         }
587 
588         stakeHolders[_address].totalStakedFor = stakeHolders[_address].totalStakedFor.add(_amount);
589         stakeHolders[msg.sender].personalStakes.push(
590             Stake(
591                 block.timestamp.add(2000),
592                 _amount,
593                 _address)
594             );
595 
596     }
597 
598 
599     function withdrawStake(
600         uint256 _amount
601     )
602         internal
603     {
604         Stake storage personalStake = stakeHolders[msg.sender].personalStakes[stakeHolders[msg.sender].personalStakeIndex];
605 
606         // Check that the current stake has unlocked & matches the unstake amount
607         require(
608             personalStake.unlockedTimestamp <= block.timestamp,
609             "The current stake hasn't unlocked yet");
610 
611         require(
612             personalStake.actualAmount == _amount,
613             "The unstake amount does not match the current stake");
614 
615         // Transfer the staked tokens from this contract back to the sender
616         // Notice that we are using transfer instead of transferFrom here, so
617         //  no approval is needed beforehand.
618         require(
619             stakingToken.transfer(msg.sender, _amount),
620             "Unable to withdraw stake");
621 
622         stakeHolders[personalStake.stakedFor].totalStakedFor = stakeHolders[personalStake.stakedFor]
623             .totalStakedFor.sub(personalStake.actualAmount);
624 
625         personalStake.actualAmount = 0;
626         stakeHolders[msg.sender].personalStakeIndex++;
627     }
628 
629 
630 }
631 
632 contract AccessDelegatedTokenStorage is AccessDelegated {
633 
634     using SafeMath for *;
635 
636 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|~Type Declarations~|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
637 
638     /// Token Balance for users with deposited tokens
639     mapping(address => uint256) public userTokenBalance;
640 
641 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|~~~~~Constants~~~~~|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
642 
643     // uint256 public constant TOKEN_DECIMALS = 18;
644     // uint256 public constant PPB = 10 ** TOKEN_DECIMALS;
645 
646 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|~~State Variables~~|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
647 
648     /// Total number of deposited tokens
649     uint256 public totalTokenBalance;
650     uint256 public stakedTokensReceivable;
651     uint256 public approvedTokensPayable;
652 
653     /// Address of the token contract assigned to this contract
654     // address public tokenAddress;
655     // StakeToken public stakingToken; 
656     address public token;
657     address public tokenStakingContractAddress;
658     address public augurUniverseAddress;
659 
660 
661 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|~~~~~~Events~~~~~~~|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
662 
663     // Event that logs the balance change of a user within this contract
664     event UserBalanceChange(address indexed user, uint256 previousBalance, uint256 currentBalance);
665     event TokenDeposit(address indexed user, uint256 amount);
666     event TokenWithdrawal(address indexed user, uint256 amount);
667 
668 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|~~~~~Modifiers~~~~~|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
669 
670 
671 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|~~~~Constructor~~~~|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
672 
673     constructor () public {
674         // stakingToken = _stakingToken;
675     }
676 
677 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|~Fallback~Function~|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
678 
679 
680 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|Delegated~Token~Functions|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
681 
682     function delegatedTotalSupply() public view returns (uint256) {
683         return StakeToken(token).totalSupply();
684     }
685 
686     function delegatedBalanceOf(address _balanceHolder) public view returns (uint256) {
687         return StakeToken(token).balanceOf(_balanceHolder);
688     }
689 
690     function delegatedAllowance(address _owner, address _spender) public view returns (uint256) {
691         return StakeToken(token).allowance(_owner, _spender);
692     }
693 
694     function delegatedApprove(address _spender, uint256 _value) public adminAccessLevelOnly returns (bool) {
695         return StakeToken(token).approve(_spender, _value);
696     }
697 
698     function delegatedTransferFrom(address _from, address _to, uint256 _value) public adminAccessLevelOnly returns (bool) {
699         return StakeToken(token).transferFrom(_from, _to, _value);
700     }
701 
702     function delegatedTokenTransfer(address _to, uint256 _value) public adminAccessLevelOnly returns (bool) {
703         return StakeToken(token).transfer(_to, _value);
704     }
705 
706     function delegatedIncreaseApproval(address _spender, uint256 _addedValue) public adminAccessLevelOnly returns (bool) {
707         return StakeToken(token).increaseApproval(_spender, _addedValue);
708     }
709 
710     function delegatedDecreaseApproval(address _spender, uint256 _subtractedValue) public adminAccessLevelOnly returns (bool) {
711         return StakeToken(token).decreaseApproval(_spender, _subtractedValue);
712     }
713 
714     function delegatedStake(uint256 _amount) public returns (bool) {
715         require(StakingContract(tokenStakingContractAddress).stake(_amount), "staking must be successful");
716         stakedTokensReceivable += _amount;
717         approvedTokensPayable -= _amount;
718     }
719 
720     function delegatedApproveSpender(address _address, uint256 _amount) public returns (bool) {
721         require(StakeToken(token).approve(_address, _amount), "approval must be successful");
722         approvedTokensPayable += _amount;
723     }
724     
725     function depositEther() public payable {
726         
727     }
728     
729     function delegatedCreateYesNoMarket(
730         uint256 _endTime,
731         uint256 _feePerEthInWei,
732         address _denominationToken,
733         address _designatedReporterAddress,
734         bytes32 _topic,
735         string memory _description,
736         string memory _extraInfo) public payable {
737             IUniverse(augurUniverseAddress).createYesNoMarket(
738         _endTime,
739         _feePerEthInWei,
740         _denominationToken,
741         _designatedReporterAddress,
742         _topic,
743         _description,
744         _extraInfo);
745         }
746     // function stakeFor(address user, uint256 amount, bytes data) public returns (bool);
747     // function unstake(uint256 amount, bytes data) public returns (bool);
748     // function totalStakedFor(address addr) public view returns (uint256);
749     // function totalStaked() public view returns (uint256);
750 
751 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|~Public~~Functions~|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
752 
753     // /**
754     //  * @dev setTokenContract sets the token contract for use within this contract
755     //  * @param _token address of the token contract to set
756     //  */
757     
758     function setTokenContract(address _token) external {
759         token = _token;
760     }
761 
762     function setTokenStakingContract(address _stakingContractAddress) external {
763         tokenStakingContractAddress = _stakingContractAddress;
764     }
765     
766     function setAugurUniverse(address augurUniverse) external {
767         augurUniverseAddress = address(IUniverse(augurUniverse));
768     }
769 
770     /**
771      * @notice Deposit funds into contract.
772      * @dev the amount of deposit is determined by allowance of this contract
773      */
774     function depositToken(address _user) public {
775 
776 
777         uint256 allowance = StakeToken(token).allowance(_user, address(this));
778         uint256 oldBalance = userTokenBalance[_user];
779         uint256 newBalance = oldBalance.add(allowance);
780         require(StakeToken(token).transferFrom(_user, address(this), allowance), "transfer failed");
781 
782         /// Update user balance
783         userTokenBalance[_user] = newBalance;
784 
785         /// update the total balance for the token
786         totalTokenBalance = totalTokenBalance.add(allowance);
787 
788         // assert(StakeToken(token).balanceOf(address(this)) == totalTokenBalance);
789 
790         /// Fire event and return some goodies
791         emit UserBalanceChange(_user, oldBalance, newBalance);
792     }
793     
794     function proxyDepositToken(address _user, uint256 _amount) external {
795         uint256 oldBalance = userTokenBalance[_user];
796         uint256 newBalance = oldBalance.add(_amount);
797         
798         /// Update user balance
799         userTokenBalance[_user] = newBalance;
800 
801         /// update the total balance for the token
802         totalTokenBalance = totalTokenBalance.add(_amount);
803         
804         emit UserBalanceChange(_user, oldBalance, newBalance);
805     }
806     
807 
808     function checkTotalBalanceExternal() public view returns (uint256, uint256) {
809         return (StakeToken(token).balanceOf(address(this)), StakeToken(token).balanceOf(address(this)));
810     }
811 
812     function balanceChecks() public view returns (uint256, uint256, uint256, uint256) {
813         return (
814             stakedTokensReceivable,
815             approvedTokensPayable,
816             totalTokenBalance,
817             StakeToken(token).balanceOf(address(tokenStakingContractAddress))
818         );
819     }
820 
821 
822     /**
823      * @dev withdrawTokens allows the initial depositing user to withdraw tokens previously deposited
824      * @param _user address of the user making the withdrawal
825      * @param _amount uint256 of token to be withdrawn
826      */
827     function withdrawTokens(address _user, uint256 _amount) public returns (bool) {
828 
829         // solium-ignore-next-line
830         // require(tx.origin == _user, "tx origin does not match _user");
831         
832         uint256 currentBalance = userTokenBalance[_user];
833 
834         require(_amount <= currentBalance, "Withdraw amount greater than current balance");
835 
836         uint256 newBalance = currentBalance.sub(_amount);
837 
838         require(StakeToken(token).transfer(_user, _amount), "error during token transfer");
839 
840         /// Update user balance
841         userTokenBalance[_user] = newBalance;
842 
843         /// update the total balance for the token
844         totalTokenBalance = SafeMath.sub(totalTokenBalance, _amount);
845 
846         /// Fire event and return some goodies
847         emit TokenWithdrawal(_user, _amount);
848         emit UserBalanceChange(_user, currentBalance, newBalance);
849     }
850 
851     /**
852      * @dev makeDeposit function calls deposit token passing msg.sender as the user
853      */
854     function makeDeposit() public { 
855         depositToken(msg.sender);
856     }
857 
858     /**
859      * @dev makeDeposit function calls deposit token passing msg.sender as the user
860      * @param _amount uint256 of token to withdraw
861      */
862     function makeWithdrawal(uint256 _amount) public { 
863         withdrawTokens(msg.sender, _amount);
864         emit TokenWithdrawal(msg.sender, _amount);
865     }
866 
867 
868     /**
869      * @dev getUserTokenBalance returns the token balance given a user address
870      * @param _user address of the user for balance retrieval
871      */
872     function getUserTokenBalance(address _user) public view returns (uint256 balance) {
873         return userTokenBalance[_user];
874     }
875 
876     /**
877      * @dev getstakingToken returns the address of the token set for this contract
878      */
879     function getTokenAddress() public view returns (address tokenContract) {
880         return token;
881     }
882 
883 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|Internal~~Functions|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
884 
885 
886 ///|=:=|=:=|=:=|=:=|=:=|=:=|=:=|~Private~Functions~|=:=|=:=|=:=|=:=|=:=|=:=|=:=|\\\
887 
888     
889 }