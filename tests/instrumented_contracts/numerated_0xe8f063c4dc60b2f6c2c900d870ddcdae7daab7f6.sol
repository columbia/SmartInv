1 pragma solidity ^0.5.16;
2 
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 /**
33  * @dev Wrappers over Solidity's arithmetic operations with added overflow
34  * checks.
35  *
36  * Arithmetic operations in Solidity wrap on overflow. This can easily result
37  * in bugs, because programmers usually assume that an overflow raises an
38  * error, which is the standard behavior in high level programming languages.
39  * `SafeMath` restores this intuition by reverting the transaction when an
40  * operation overflows.
41  *
42  * Using this library instead of the unchecked operations eliminates an entire
43  * class of bugs, so it's recommended to use it always.
44  */
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a, "SafeMath: subtraction overflow");
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Solidity only automatically asserts when dividing by 0
114         require(b > 0, "SafeMath: division by zero");
115         uint256 c = a / b;
116         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
123      * Reverts when dividing by zero.
124      *
125      * Counterpart to Solidity's `%` operator. This function uses a `revert`
126      * opcode (which leaves remaining gas untouched) while Solidity uses an
127      * invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b != 0, "SafeMath: modulo by zero");
134         return a % b;
135     }
136 }
137 
138 /**
139  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
140  * the optional functions; to access them see `ERC20Detailed`.
141  */
142 interface IERC20 {
143     /**
144      * @dev Returns the amount of tokens in existence.
145      */
146     function totalSupply() external view returns (uint256);
147 
148     /**
149      * @dev Returns the amount of tokens owned by `account`.
150      */
151     function balanceOf(address account) external view returns (uint256);
152 
153     /**
154      * @dev Moves `amount` tokens from the caller's account to `recipient`.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a `Transfer` event.
159      */
160     function transfer(address recipient, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Returns the remaining number of tokens that `spender` will be
164      * allowed to spend on behalf of `owner` through `transferFrom`. This is
165      * zero by default.
166      *
167      * This value changes when `approve` or `transferFrom` are called.
168      */
169     function allowance(address owner, address spender) external view returns (uint256);
170 
171     /**
172      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * > Beware that changing an allowance with this method brings the risk
177      * that someone may use both the old and the new allowance by unfortunate
178      * transaction ordering. One possible solution to mitigate this race
179      * condition is to first reduce the spender's allowance to 0 and set the
180      * desired value afterwards:
181      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182      *
183      * Emits an `Approval` event.
184      */
185     function approve(address spender, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Moves `amount` tokens from `sender` to `recipient` using the
189      * allowance mechanism. `amount` is then deducted from the caller's
190      * allowance.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * Emits a `Transfer` event.
195      */
196     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Emitted when `value` tokens are moved from one account (`from`) to
200      * another (`to`).
201      *
202      * Note that `value` may be zero.
203      */
204     event Transfer(address indexed from, address indexed to, uint256 value);
205 
206     /**
207      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
208      * a call to `approve`. `value` is the new allowance.
209      */
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 }
212 
213 /**
214  * @dev Optional functions from the ERC20 standard.
215  */
216 contract ERC20Detailed is IERC20 {
217     string private _name;
218     string private _symbol;
219     uint8 private _decimals;
220 
221     /**
222      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
223      * these values are immutable: they can only be set once during
224      * construction.
225      */
226     constructor (string memory name, string memory symbol, uint8 decimals) public {
227         _name = name;
228         _symbol = symbol;
229         _decimals = decimals;
230     }
231 
232     /**
233      * @dev Returns the name of the token.
234      */
235     function name() public view returns (string memory) {
236         return _name;
237     }
238 
239     /**
240      * @dev Returns the symbol of the token, usually a shorter version of the
241      * name.
242      */
243     function symbol() public view returns (string memory) {
244         return _symbol;
245     }
246 
247     /**
248      * @dev Returns the number of decimals used to get its user representation.
249      * For example, if `decimals` equals `2`, a balance of `505` tokens should
250      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
251      *
252      * Tokens usually opt for a value of 18, imitating the relationship between
253      * Ether and Wei.
254      *
255      * > Note that this information is only used for _display_ purposes: it in
256      * no way affects any of the arithmetic of the contract, including
257      * `IERC20.balanceOf` and `IERC20.transfer`.
258      */
259     function decimals() public view returns (uint8) {
260         return _decimals;
261     }
262 }
263 
264 /**
265  * @dev Collection of functions related to the address type,
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * This test is non-exhaustive, and there may be false-negatives: during the
272      * execution of a contract's constructor, its address will be reported as
273      * not containing a contract.
274      *
275      * > It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies in extcodesize, which returns 0 for contracts in
280         // construction, since the code is only stored at the end of the
281         // constructor execution.
282 
283         uint256 size;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { size := extcodesize(account) }
286         return size > 0;
287     }
288 }
289 
290 /**
291  * @title SafeERC20
292  * @dev Wrappers around ERC20 operations that throw on failure (when the token
293  * contract returns false). Tokens that return no value (and instead revert or
294  * throw on failure) are also supported, non-reverting calls are assumed to be
295  * successful.
296  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
297  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
298  */
299 library SafeERC20 {
300     using SafeMath for uint256;
301     using Address for address;
302 
303     function safeTransfer(IERC20 token, address to, uint256 value) internal {
304         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
305     }
306 
307     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
308         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
309     }
310 
311     function safeApprove(IERC20 token, address spender, uint256 value) internal {
312         // safeApprove should only be called when setting an initial allowance,
313         // or when resetting it to zero. To increase and decrease it, use
314         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
315         // solhint-disable-next-line max-line-length
316         require((value == 0) || (token.allowance(address(this), spender) == 0),
317             "SafeERC20: approve from non-zero to non-zero allowance"
318         );
319         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
320     }
321 
322     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
323         uint256 newAllowance = token.allowance(address(this), spender).add(value);
324         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
325     }
326 
327     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
328         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
329         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
330     }
331 
332     /**
333      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
334      * on the return value: the return value is optional (but if data is returned, it must not be false).
335      * @param token The token targeted by the call.
336      * @param data The call data (encoded using abi.encode or one of its variants).
337      */
338     function callOptionalReturn(IERC20 token, bytes memory data) private {
339         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
340         // we're implementing it ourselves.
341 
342         // A Solidity high level call has three parts:
343         //  1. The target address is checked to verify it contains contract code
344         //  2. The call itself is made, and success asserted
345         //  3. The return value is decoded, which in turn checks the size of the returned data.
346         // solhint-disable-next-line max-line-length
347         require(address(token).isContract(), "SafeERC20: call to non-contract");
348 
349         // solhint-disable-next-line avoid-low-level-calls
350         (bool success, bytes memory returndata) = address(token).call(data);
351         require(success, "SafeERC20: low-level call failed");
352 
353         if (returndata.length > 0) { // Return data is optional
354             // solhint-disable-next-line max-line-length
355             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
356         }
357     }
358 }
359 
360 /**
361  * @dev Contract module that helps prevent reentrant calls to a function.
362  *
363  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
364  * available, which can be aplied to functions to make sure there are no nested
365  * (reentrant) calls to them.
366  *
367  * Note that because there is a single `nonReentrant` guard, functions marked as
368  * `nonReentrant` may not call one another. This can be worked around by making
369  * those functions `private`, and then adding `external` `nonReentrant` entry
370  * points to them.
371  */
372 contract ReentrancyGuard {
373     /// @dev counter to allow mutex lock with only one SSTORE operation
374     uint256 private _guardCounter;
375 
376     constructor () internal {
377         // The counter starts at one to prevent changing it from zero to a non-zero
378         // value, which is a more expensive operation.
379         _guardCounter = 1;
380     }
381 
382     /**
383      * @dev Prevents a contract from calling itself, directly or indirectly.
384      * Calling a `nonReentrant` function from another `nonReentrant`
385      * function is not supported. It is possible to prevent this from happening
386      * by making the `nonReentrant` function external, and make it call a
387      * `private` function that does the actual work.
388      */
389     modifier nonReentrant() {
390         _guardCounter += 1;
391         uint256 localCounter = _guardCounter;
392         _;
393         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
394     }
395 }
396 
397 // https://docs.synthetix.io/contracts/Owned
398 contract Owned {
399     address public owner;
400     address public nominatedOwner;
401 
402     constructor(address _owner) public {
403         require(_owner != address(0), "Owner address cannot be 0");
404         owner = _owner;
405         emit OwnerChanged(address(0), _owner);
406     }
407 
408     function nominateNewOwner(address _owner) external onlyOwner {
409         nominatedOwner = _owner;
410         emit OwnerNominated(_owner);
411     }
412 
413     function acceptOwnership() external {
414         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
415         emit OwnerChanged(owner, nominatedOwner);
416         owner = nominatedOwner;
417         nominatedOwner = address(0);
418     }
419 
420     modifier onlyOwner {
421         require(msg.sender == owner, "Only the contract owner may perform this action");
422         _;
423     }
424 
425     event OwnerNominated(address newOwner);
426     event OwnerChanged(address oldOwner, address newOwner);
427 }
428 
429 // Inheritance
430 // https://docs.synthetix.io/contracts/Pausable
431 contract Pausable is Owned {
432     uint public lastPauseTime;
433     bool public paused;
434 
435     constructor() internal {
436         // This contract is abstract, and thus cannot be instantiated directly
437         require(owner != address(0), "Owner must be set");
438         // Paused will be false, and lastPauseTime will be 0 upon initialisation
439     }
440 
441     /**
442      * @notice Change the paused state of the contract
443      * @dev Only the contract owner may call this.
444      */
445     function setPaused(bool _paused) external onlyOwner {
446         // Ensure we're actually changing the state before we do anything
447         if (_paused == paused) {
448             return;
449         }
450 
451         // Set our paused state.
452         paused = _paused;
453 
454         // If applicable, set the last pause time.
455         if (paused) {
456             lastPauseTime = now;
457         }
458 
459         // Let everyone know that our pause state has changed.
460         emit PauseChanged(paused);
461     }
462 
463     event PauseChanged(bool isPaused);
464 
465     modifier notPaused {
466         require(!paused, "This action cannot be performed while the contract is paused");
467         _;
468     }
469 }
470 
471 // Inheritance
472 contract StakingRewards is Owned, ReentrancyGuard, Pausable {
473     using SafeMath for uint256;
474     using SafeERC20 for IERC20;
475 
476     /* ========== UTIL FUNCTIONS ========== */
477 
478     function getTime() internal view returns (uint256) {
479         // current block timestamp as seconds since unix epoch
480         // Used to mock time changes in tests
481         return block.timestamp;
482     }
483 
484     /* ========== STATE VARIABLES ========== */
485 
486     // IERC20 public rewardsToken;
487     IERC20 public stakingToken;
488 
489     uint256 private _totalSupply;
490 
491     mapping(address => uint256) private _stakedBalance;
492     mapping(address => uint256) private _stakedTime;
493     mapping(address => uint256) private _unstakingBalance;
494     mapping(address => uint256) private _unstakingTime;
495     mapping(address => uint256) private _rewardBalance;
496 
497     // Added for looping over addresses in event of APR change
498     mapping(address => uint256) private _addressToIndex;
499     address[] public allAddress;
500 
501 
502     uint256 private rewardDistributorBalance = 0;
503     uint256 internal rewardInterval = 86400 * 1; // 1 day
504     uint256 internal unstakingInterval = 86400 * 8; // 8 day
505 
506     uint256 public rewardPerIntervalDivider = 411;
507 
508     uint256 private _convertDecimalTokenBalance = 10**18;
509 
510     uint256 public minStakeBalance = 1 * _convertDecimalTokenBalance;
511 
512     /* ========== CONSTRUCTOR ========== */
513 
514     constructor(
515         address _owner,
516         address _stakingToken
517     ) public Owned(_owner) {
518         stakingToken = IERC20(_stakingToken);
519     }
520 
521     /* ========== VIEWS ========== */
522 
523     // How much OM is in the contract total?
524     function totalSupply() external view returns (uint256) {
525         return _totalSupply;
526     }
527 
528     // How much OM has address staked?
529     function balanceOf(address account) external view returns (uint256) {
530         return _stakedBalance[account];
531     }
532 
533     // When did user stake?
534     function stakeTime(address account) external view returns (uint256) {
535         return _stakedTime[account];
536     }
537 
538     // How much OM is unstaking in the address's current unstaking procedure?
539     function unstakingBalanceOf(address account) external view returns (uint256) {
540         return  _unstakingBalance[account];
541     }
542 
543     // How much time is left in the address's current unstaking procedure?
544     function unstakingTimeOf(address account) external view returns (uint256) {
545         return _unstakingTime[account];
546     }
547 
548     // How much have the address earned?
549     function rewardBalanceOf(address account) external view returns (uint256) {
550         return _rewardBalance[account];
551     }
552 
553     // How much OM is available to distribute from reward disributor address? (Controlled by Mantra council)
554     function rewardDistributorBalanceOf() external view returns (uint256) {
555         return rewardDistributorBalance;
556     }
557 
558     // When is the address's next reward going to become unstakable? 
559     function nextRewardApplicableTime(address account) external view returns (uint256) {
560         require(_stakedTime[account] != 0, "You dont have a stake in progress");
561         require(_stakedTime[account] <= getTime(), "Your stake takes 24 hours to become available to interact with");
562         uint256 secondsRemaining = (getTime() - _stakedTime[account]).mod(rewardInterval);
563         return secondsRemaining;
564     }
565 
566     // How much has account earned? Account's potential rewards ready to begin unstaking. 
567     function earned(address account) public view returns (uint256) {
568         uint256 perIntervalReward = perIntervalRewardOf(account);
569         uint256 intervalsStaked = stakedIntervalsCountOf(account);
570         return perIntervalReward.mul(intervalsStaked);
571     }
572 
573     function perIntervalRewardOf(address account) public view returns (uint256) {
574         return _stakedBalance[account].div(rewardPerIntervalDivider);
575     }
576 
577     function stakedIntervalsCountOf(address account) public view returns (uint256) {
578         if (_stakedTime[account] == 0) return 0;
579         uint256 diffTime = getTime().sub(_stakedTime[account]);
580         return diffTime.div(rewardInterval);
581     }
582 
583     // Address loop
584 
585     function getAddresses(uint256 i) public view returns (address) {
586         return allAddress[i];
587     }
588 
589     function getAddressesLength() public view returns (uint256) {
590         return allAddress.length;
591     }
592 
593     
594 
595     // 
596 
597     /* ========== END OF VIEWS ========== */
598 
599 
600     /* ========== MUTATIVE FUNCTIONS ========== */
601 
602     // ------ FUNCTION -------
603     // 
604     //  STAKE ()
605     // 
606     //      #require() amount is greater than ZERO
607     //      #require() address that is staking is not the contract address
608     // 
609     //      Insert : token balance to user stakedBalances[address]
610     //      Insert : current block timestamp timestamp to stakeTime[address]
611     //      Add : token balance to total supply
612     //      Transfer : token balance from user to this contract
613     // 
614     //  EXIT
615     //  
616 
617     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
618         
619         require(amount > 0, "Cannot stake 0");
620         uint256 newStakedBalance = _stakedBalance[msg.sender].add(amount);
621         require(newStakedBalance >= minStakeBalance, "Staked balance is less than minimum stake balance");
622         uint256 currentTimestamp = getTime();
623         _stakedBalance[msg.sender] = newStakedBalance;
624         _stakedTime[msg.sender] = currentTimestamp;
625         _totalSupply = _totalSupply.add(amount);
626 
627 
628         // 
629             if (_addressToIndex[msg.sender] > 0) {
630                
631             } else {
632                 allAddress.push(msg.sender);
633                 uint256 index = allAddress.length;
634                 _addressToIndex[msg.sender] = index;
635             }
636         // 
637 
638         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
639         emit Staked(msg.sender, amount);
640     }
641 
642     // ------ FUNCTION -------
643     // 
644     //   UNSTAKE () 
645     // 
646     //      initiate by running updateReward() to push the system forward
647     //  
648     //      #require() that the amount of tokens specified to unstake is above ZERO    
649     //      #require() that the user has a current stakedBalance[address] above ZERO
650     //      #require() that the amount of tokens specified to unstake is equal or less than thier current stakedBalance[] 
651     //      #require() that the address staking is not the contract address
652     //   
653     //      MODIFY : subtract token balance from stakedBalance[address]
654     // 
655     //      if (stakedBalance == 0)
656     //          Update : stake timestamp to ZERO stakeTime[address] // exit the system
657     //      Else ()
658     //          #require() that the updates stake balance is above minimum stake value
659     //          Update : stake timestamp to now stakeTime[address] // Om for that address still remains in the system
660 
661     //      MODIFY : token balance to user  _unstakingBalance[address]
662     //      MODIFY : (time + unstakingInterval) timestamp to stakeTime[address]
663     //   
664     //   EXIT
665     //  
666 
667     function unstake(uint256 amount) public updateReward(msg.sender) {
668         _unstake(msg.sender, amount);
669     }
670 
671     // Allows user to unstake tokens without (or with partial) rewards in case of empty reward distribution pool
672     function exit() public {
673         uint256 reward = Math.min(earned(msg.sender), rewardDistributorBalance);
674         require(reward > 0 || _rewardBalance[msg.sender] > 0 || _stakedBalance[msg.sender] > 0, "No tokens to exit");
675         _addReward(msg.sender, reward);
676         _stakedTime[msg.sender] = 0;
677         if (_rewardBalance[msg.sender] > 0) withdrawReward();
678         if (_stakedBalance[msg.sender] > 0) _unstake(msg.sender, _stakedBalance[msg.sender]);
679     }
680 
681     // ------ FUNCTION -------
682     // 
683     //   WITHDRAW UNSTAKED BALANCE (uint256 amount) 
684     // 
685     //      updateReward()
686     //  
687     //      #require() that the amount of tokens specified to unstake is above ZERO    
688     //      #require() that the user has a current unstakingBalance[address] above amount specified to withdraw
689     //      #require() that the current block time is greater than their unstaking end date (their unstaking or vesting period has finished)
690     //   
691     //      MODIFY :  _unstakingBalance[address] to  _unstakingBalance[address] minus amount
692     //      MODIFY : _totalSupply to _totalSupply[address] minus amount
693     //      
694     //      TRANSFER : amount to address that called the function
695     // 
696     //   
697     //   EXIT
698     //  
699     
700     function withdrawUnstakedBalance(uint256 amount) public nonReentrant updateReward(msg.sender) {
701 
702         require(amount > 0, "Account does not have an unstaking balance");
703         require(_unstakingBalance[msg.sender] >= amount, "Account does not have that much balance unstaked");
704         require(_unstakingTime[msg.sender] <= getTime(), "Unstaking period has not finished yet");
705 
706          _unstakingBalance[msg.sender] =  _unstakingBalance[msg.sender].sub(amount);
707         _totalSupply = _totalSupply.sub(amount);
708 
709         stakingToken.safeTransfer(msg.sender, amount);
710         emit Withdrawn(msg.sender, amount);
711     }
712 
713     // ------ FUNCTION -------
714     // 
715     //   LOCK IN REWARD () 
716     // 
717     //      updateReward()
718     //   
719     //   EXIT
720     //  
721 
722     function lockInReward() public updateReward(msg.sender) {}
723 
724     function lockInRewardOnBehalf(address _address) private updateReward(_address) {}
725 
726     // ------ FUNCTION -------
727     // 
728     //   WITHDRAW REWARD ()
729     // 
730     //      updateReward()
731     //  
732     //      #require() that the reward balance of the user is above ZERO
733     //   
734     //      TRANSFER : transfer reward balance to address that called the function
735     // 
736     //      MODIFY : update rewardBalance to ZERO
737     //   
738     //   EXIT
739     //  
740 
741     function withdrawReward() public updateReward(msg.sender) {
742         uint256 reward = _rewardBalance[msg.sender];
743         require(reward > 0, "You have not earned any rewards yet");
744         _rewardBalance[msg.sender] = 0;
745         _unstakingBalance[msg.sender] = _unstakingBalance[msg.sender].add(reward);
746         _unstakingTime[msg.sender] = getTime() + unstakingInterval;
747         emit RewardWithdrawn(msg.sender, reward);
748     }
749 
750     // ------ FUNCTION -------
751     // 
752     //   STAKE REWARD ()
753     // 
754     //      updateReward()
755     //  
756     //      #require() that the reward balance of the user is above ZERO
757     //   
758     //      MODIFY : update stakedBalances[address] = (stakedBalances[address] + _rewardBalance[msg.sender])
759     // 
760     //      MODIFY : update rewardBalance to ZERO
761     //   
762     //   EXIT
763     //  
764 
765     function stakeReward() public updateReward(msg.sender) {
766         require(_rewardBalance[msg.sender] > 0, "You have not earned any rewards yet");
767         _stakedBalance[msg.sender] = _stakedBalance[msg.sender].add(_rewardBalance[msg.sender]);
768         _rewardBalance[msg.sender] = 0;
769     }
770 
771     // ------ FUNCTION -------
772     // 
773     //   ADD REWARD SUPPLY () 
774     // 
775     //      #require() that the amount of tokens being added is above ZERO
776     //      #require() that the user
777     //   
778     //      MODIFY : update rewardDistributorBalance = rewardDistributorBalance + amount
779     //      MODIFY : update _totalSupply = _totalSupply + amount
780     //   
781     //   EXIT
782     //  
783 
784     function addRewardSupply(uint256 amount) external onlyOwner {
785         require(amount > 0, "Cannot add 0 tokens");
786         
787         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
788         rewardDistributorBalance = rewardDistributorBalance.add(amount);
789         _totalSupply = _totalSupply.add(amount);
790     }
791 
792     // ------ FUNCTION -------
793     // 
794     //   REMOVE REWARD SUPPLY | ONLY OWNER
795     // 
796     //      #require() that the amount of tokens being removed is above ZERO
797     //      #require() that the amount is equal to or below the rewardDistributorBalance
798     //      #require() that the amount is equal to or below the totalSupply of tokens in the contract
799     //  
800     //      TRANSFER: amount of tokens from contract
801     //  
802     //      MODIFY : update rewardDistributorBalance = rewardDistributorBalance - amount
803     //      MODIFY : update _totalSupply = _totalSupply - amount
804     //   
805     //   EXIT
806     //  
807 
808     function removeRewardSupply(uint256 amount) external onlyOwner nonReentrant {
809         require(amount > 0, "Cannot withdraw 0");
810         require(amount <= rewardDistributorBalance, "rewardDistributorBalance has less tokens than requested");
811         require(amount <= _totalSupply, "Amount is greater that total supply");
812         stakingToken.safeTransfer(owner, amount);
813         rewardDistributorBalance = rewardDistributorBalance.sub(amount);
814         _totalSupply = _totalSupply.sub(amount);
815     }
816 
817     // ------ FUNCTION -------
818     // 
819     //   SET REWARDS INTERVAL () ONLY OWNER
820     // 
821     //      #require() that reward interval sullpied as argument is greater than 1 and less than 365 inclusive
822     //   
823     //      MODIFY : rewardInterval to supplied _rewardInterval
824     // 
825     //      EMIT : update reward interval
826     //   
827     //   EXIT
828     //  
829 
830     function setRewardsInterval(uint256 _rewardInterval) external onlyOwner {
831         require(
832             _rewardInterval >= 1 && _rewardInterval <= 365,
833             "Staking reward interval must be between 1 and 365 inclusive"
834         );
835         rewardInterval = _rewardInterval * 1 days;
836         emit RewardsDurationUpdated(rewardInterval);
837     }
838 
839     // ------ FUNCTION -------#
840     // 
841     //   SET REWARDS DIVIDER () ONLY OWNER
842     // 
843     //      #require() that reward divider sullpied as argument is greater than original divider
844     //   
845     //      MODIFY : rewardIntervalDivider to supplied _rewardInterval
846     //   
847     //   EXIT
848     //  
849 
850     function updateChunkUsersRewards(uint256 startIndex, uint256 endIndex) external onlyOwner {
851 
852         uint256 length = allAddress.length;
853         require(endIndex <= length, "Cant end on index greater than length of addresses");
854         require(endIndex > startIndex, "Nothing to iterate over");
855         
856 
857         for (uint i = startIndex; i < endIndex; i++) {
858             lockInRewardOnBehalf(allAddress[i]);
859         }
860     }
861 
862     function setRewardsDivider(uint256 _rewardPerIntervalDivider) external onlyOwner {
863         require(
864             _rewardPerIntervalDivider >= 411,
865             "Reward can only be lowered, divider must be greater than 410"
866         );
867         rewardPerIntervalDivider = _rewardPerIntervalDivider;
868     }
869 
870     // Keep in mind, that this method receives value in wei.
871     // It means, that if owner wants to set min staking balance to 2 om
872     // he needs to pass 2000000000000000000 as argument (if ERC20's decimals is 18).
873     function setMinStakeBalance(uint256 _minStakeBalance) external onlyOwner {
874         minStakeBalance = _minStakeBalance;
875     }
876     
877   /* ========== MODIFIERS ========== */
878 
879     // ------ FUNCTION -------
880     // 
881     //   UPDATE REWARD (address) INTERNAL
882     // 
883     //      IF (stakeTime[address] > 0)
884     //      
885     //          VAR reward = 0;
886     //          VAR diffTime : Take current block timestamp and subtract the users stakedTime entry (timestamp)
887     //          VAR perIntervalReward : current staked balance divided by APR variable divider. Calculate the reward they should earn per interval that have occured since inital stake or last call of updateReward()
888     //          VAR intervalsStaked : diffTime calculation divided by the rewardInterval (24 hours)
889     //          reward : reward earned per interval based on current stake multiplied by how many intervals you have not calimed a reward for.
890     //          
891     // 
892     //          #require() that reward user is about to receive is not greater than the rewardDistributorBalance
893     // 
894     //          IF (the reward is greater than ZERO)  
895     // 
896     //              MODIFY : rewardDistributorBalance to rewardDistributorBalance minus the reward paid
897     //              MODIFY : _totalSupply to _totalSupply minus the reward paid
898     //              MODIFY : _stakedTime[address] to now(timestamp)
899     //              MODIFY : _rewardBalance[address] to _rewardBalance[address] plus reward
900     // 
901     //              EMIT : rewardPaid to the address calling the function (reward)
902     // 
903     //          ELSE
904     //              NOTHING : user has nothing to claim. ignore and EXIT.
905     //      ELSE
906     //          NOTHING : user has nothing to claim. ignore and EXIT.
907     //   
908     //      EXIT
909     // 
910 
911     function _addReward(address account, uint256 amount) private {
912         if (amount == 0) return;
913         // Update stake balance to unstaking balance
914         rewardDistributorBalance = rewardDistributorBalance.sub(amount);
915         _rewardBalance[account] = _rewardBalance[account].add(amount);
916         emit RewardPaid(account, amount);
917     }
918 
919     function _unstake(address account, uint256 amount) private {
920         require(_stakedBalance[account] > 0, "Account does not have a balance staked");
921         require(amount > 0, "Cannot unstake Zero OM");
922         require(amount <= _stakedBalance[account], "Attempted to withdraw more than balance staked");
923         _stakedBalance[account] = _stakedBalance[account].sub(amount);
924         if (_stakedBalance[account] == 0) _stakedTime[account] = 0;
925         else {
926             require(
927                 _stakedBalance[account] >= minStakeBalance,
928                 "Your remaining staked balance would be under the minimum stake. Either leave at least 10 OM in the staking pool or withdraw all your OM"
929             );
930         }
931         _unstakingBalance[account] = _unstakingBalance[account].add(amount);
932         _unstakingTime[account] = getTime() + unstakingInterval;
933         emit Unstaked(account, amount);
934     }
935 
936     modifier updateReward(address account) {
937         // If their _stakeTime is 0, this means they arent active in the system
938         if (_stakedTime[account] > 0) {
939             uint256 stakedIntervals = stakedIntervalsCountOf(account);
940             uint256 perIntervalReward = perIntervalRewardOf(account);
941             uint256 reward = stakedIntervals.mul(perIntervalReward);
942             require(reward <= rewardDistributorBalance, "Rewards pool is extinguished");
943             _addReward(account, reward);
944             _stakedTime[account] = _stakedTime[account].add(rewardInterval.mul(stakedIntervals));
945         }
946         _;
947     }
948 
949     /* ========== END OF MODIFIERS ========== */
950 
951 
952 
953     /* ========== EVENTS ========== */
954 
955     event RewardAdded(uint256 reward);
956     event Staked(address indexed user, uint256 amount);
957     event Unstaked(address indexed user, uint256 amount);
958     event Withdrawn(address indexed user, uint256 amount);
959     event RewardWithdrawn(address indexed user, uint256 reward);
960     event RewardPaid(address indexed user, uint256 reward);
961     event RewardsDurationUpdated(uint256 newDuration);
962     event Recovered(address token, uint256 amount);
963 
964     /* ========== END EVENTS ========== */
965 }