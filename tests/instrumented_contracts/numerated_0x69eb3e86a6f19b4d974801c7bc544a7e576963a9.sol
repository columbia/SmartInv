1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-20
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-11-13
7 */
8 
9 pragma solidity 0.5.17;
10 
11 
12 library Math {
13     /**
14      * @dev Returns the largest of two numbers.
15      */
16     function max(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a >= b ? a : b;
18     }
19 
20     /**
21      * @dev Returns the smallest of two numbers.
22      */
23     function min(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a < b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the average of two numbers. The result is rounded towards
29      * zero.
30      */
31     function average(uint256 a, uint256 b) internal pure returns (uint256) {
32         // (a + b) / 2 can overflow, so we distribute
33         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
34     }
35 }
36 
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 /**
109  * @dev Optional functions from the ERC20 standard.
110  */
111 contract ERC20Detailed is IERC20 {
112     string private _name;
113     string private _symbol;
114     uint8 private _decimals;
115 
116     /**
117      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
118      * these values are immutable: they can only be set once during
119      * construction.
120      */
121     constructor (string memory name, string memory symbol, uint8 decimals) public {
122         _name = name;
123         _symbol = symbol;
124         _decimals = decimals;
125     }
126 
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() public view returns (string memory) {
131         return _name;
132     }
133 
134     /**
135      * @dev Returns the symbol of the token, usually a shorter version of the
136      * name.
137      */
138     function symbol() public view returns (string memory) {
139         return _symbol;
140     }
141 
142     /**
143      * @dev Returns the number of decimals used to get its user representation.
144      * For example, if `decimals` equals `2`, a balance of `505` tokens should
145      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
146      *
147      * Tokens usually opt for a value of 18, imitating the relationship between
148      * Ether and Wei.
149      *
150      * NOTE: This information is only used for _display_ purposes: it in
151      * no way affects any of the arithmetic of the contract, including
152      * {IERC20-balanceOf} and {IERC20-transfer}.
153      */
154     function decimals() public view returns (uint8) {
155         return _decimals;
156     }
157 }
158 
159 
160 library Address {
161     /**
162      * @dev Returns true if `account` is a contract.
163      *
164      * [IMPORTANT]
165      * ====
166      * It is unsafe to assume that an address for which this function returns
167      * false is an externally-owned account (EOA) and not a contract.
168      *
169      * Among others, `isContract` will return false for the following 
170      * types of addresses:
171      *
172      *  - an externally-owned account
173      *  - a contract in construction
174      *  - an address where a contract will be created
175      *  - an address where a contract lived, but was destroyed
176      * ====
177      */
178     function isContract(address account) internal view returns (bool) {
179         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
180         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
181         // for accounts without code, i.e. `keccak256('')`
182         bytes32 codehash;
183         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
184         // solhint-disable-next-line no-inline-assembly
185         assembly { codehash := extcodehash(account) }
186         return (codehash != accountHash && codehash != 0x0);
187     }
188 
189     /**
190      * @dev Converts an `address` into `address payable`. Note that this is
191      * simply a type cast: the actual underlying value is not changed.
192      *
193      * _Available since v2.4.0._
194      */
195     function toPayable(address account) internal pure returns (address payable) {
196         return address(uint160(account));
197     }
198 
199     /**
200      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
201      * `recipient`, forwarding all available gas and reverting on errors.
202      *
203      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
204      * of certain opcodes, possibly making contracts go over the 2300 gas limit
205      * imposed by `transfer`, making them unable to receive funds via
206      * `transfer`. {sendValue} removes this limitation.
207      *
208      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
209      *
210      * IMPORTANT: because control is transferred to `recipient`, care must be
211      * taken to not create reentrancy vulnerabilities. Consider using
212      * {ReentrancyGuard} or the
213      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
214      *
215      * _Available since v2.4.0._
216      */
217     function sendValue(address payable recipient, uint256 amount) internal {
218         require(address(this).balance >= amount, "Address: insufficient balance");
219 
220         // solhint-disable-next-line avoid-call-value
221         (bool success, ) = recipient.call.value(amount)("");
222         require(success, "Address: unable to send value, recipient may have reverted");
223     }
224 }
225 
226 library SafeMath {
227     /**
228      * @dev Returns the addition of two unsigned integers, reverting on
229      * overflow.
230      *
231      * Counterpart to Solidity's `+` operator.
232      *
233      * Requirements:
234      * - Addition cannot overflow.
235      */
236     function add(uint256 a, uint256 b) internal pure returns (uint256) {
237         uint256 c = a + b;
238         require(c >= a, "SafeMath: addition overflow");
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the subtraction of two unsigned integers, reverting on
245      * overflow (when the result is negative).
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      * - Subtraction cannot overflow.
251      */
252     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253         return sub(a, b, "SafeMath: subtraction overflow");
254     }
255 
256     /**
257      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
258      * overflow (when the result is negative).
259      *
260      * Counterpart to Solidity's `-` operator.
261      *
262      * Requirements:
263      * - Subtraction cannot overflow.
264      *
265      * _Available since v2.4.0._
266      */
267     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b <= a, errorMessage);
269         uint256 c = a - b;
270 
271         return c;
272     }
273 
274     /**
275      * @dev Returns the multiplication of two unsigned integers, reverting on
276      * overflow.
277      *
278      * Counterpart to Solidity's `*` operator.
279      *
280      * Requirements:
281      * - Multiplication cannot overflow.
282      */
283     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
284         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
285         // benefit is lost if 'b' is also tested.
286         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
287         if (a == 0) {
288             return 0;
289         }
290 
291         uint256 c = a * b;
292         require(c / a == b, "SafeMath: multiplication overflow");
293 
294         return c;
295     }
296 
297     /**
298      * @dev Returns the integer division of two unsigned integers. Reverts on
299      * division by zero. The result is rounded towards zero.
300      *
301      * Counterpart to Solidity's `/` operator. Note: this function uses a
302      * `revert` opcode (which leaves remaining gas untouched) while Solidity
303      * uses an invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      * - The divisor cannot be zero.
307      */
308     function div(uint256 a, uint256 b) internal pure returns (uint256) {
309         return div(a, b, "SafeMath: division by zero");
310     }
311 
312     /**
313      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
314      * division by zero. The result is rounded towards zero.
315      *
316      * Counterpart to Solidity's `/` operator. Note: this function uses a
317      * `revert` opcode (which leaves remaining gas untouched) while Solidity
318      * uses an invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      * - The divisor cannot be zero.
322      *
323      * _Available since v2.4.0._
324      */
325     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
326         // Solidity only automatically asserts when dividing by 0
327         require(b > 0, errorMessage);
328         uint256 c = a / b;
329         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
330 
331         return c;
332     }
333 
334     /**
335      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
336      * Reverts when dividing by zero.
337      *
338      * Counterpart to Solidity's `%` operator. This function uses a `revert`
339      * opcode (which leaves remaining gas untouched) while Solidity uses an
340      * invalid opcode to revert (consuming all remaining gas).
341      *
342      * Requirements:
343      * - The divisor cannot be zero.
344      */
345     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
346         return mod(a, b, "SafeMath: modulo by zero");
347     }
348 
349     /**
350      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
351      * Reverts with custom message when dividing by zero.
352      *
353      * Counterpart to Solidity's `%` operator. This function uses a `revert`
354      * opcode (which leaves remaining gas untouched) while Solidity uses an
355      * invalid opcode to revert (consuming all remaining gas).
356      *
357      * Requirements:
358      * - The divisor cannot be zero.
359      *
360      * _Available since v2.4.0._
361      */
362     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
363         require(b != 0, errorMessage);
364         return a % b;
365     }
366 }
367 
368 library SafeERC20 {
369     using SafeMath for uint256;
370     using Address for address;
371 
372     function safeTransfer(IERC20 token, address to, uint256 value) internal {
373         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
374     }
375 
376     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
377         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
378     }
379 
380     function safeApprove(IERC20 token, address spender, uint256 value) internal {
381         // safeApprove should only be called when setting an initial allowance,
382         // or when resetting it to zero. To increase and decrease it, use
383         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
384         // solhint-disable-next-line max-line-length
385         require((value == 0) || (token.allowance(address(this), spender) == 0),
386             "SafeERC20: approve from non-zero to non-zero allowance"
387         );
388         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
389     }
390 
391     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
392         uint256 newAllowance = token.allowance(address(this), spender).add(value);
393         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
394     }
395 
396     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
397         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
398         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
399     }
400 
401     /**
402      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
403      * on the return value: the return value is optional (but if data is returned, it must not be false).
404      * @param token The token targeted by the call.
405      * @param data The call data (encoded using abi.encode or one of its variants).
406      */
407     function callOptionalReturn(IERC20 token, bytes memory data) private {
408         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
409         // we're implementing it ourselves.
410 
411         // A Solidity high level call has three parts:
412         //  1. The target address is checked to verify it contains contract code
413         //  2. The call itself is made, and success asserted
414         //  3. The return value is decoded, which in turn checks the size of the returned data.
415         // solhint-disable-next-line max-line-length
416         require(address(token).isContract(), "SafeERC20: call to non-contract");
417 
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success, bytes memory returndata) = address(token).call(data);
420         require(success, "SafeERC20: low-level call failed");
421 
422         if (returndata.length > 0) { // Return data is optional
423             // solhint-disable-next-line max-line-length
424             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
425         }
426     }
427 }
428 
429 
430 contract ReentrancyGuard {
431     bool private _notEntered;
432 
433     constructor () internal {
434         // Storing an initial non-zero value makes deployment a bit more
435         // expensive, but in exchange the refund on every call to nonReentrant
436         // will be lower in amount. Since refunds are capped to a percetange of
437         // the total transaction's gas, it is best to keep them low in cases
438         // like this one, to increase the likelihood of the full refund coming
439         // into effect.
440         _notEntered = true;
441     }
442 
443     /**
444      * @dev Prevents a contract from calling itself, directly or indirectly.
445      * Calling a `nonReentrant` function from another `nonReentrant`
446      * function is not supported. It is possible to prevent this from happening
447      * by making the `nonReentrant` function external, and make it call a
448      * `private` function that does the actual work.
449      */
450     modifier nonReentrant() {
451         // On the first call to nonReentrant, _notEntered will be true
452         require(_notEntered, "ReentrancyGuard: reentrant call");
453 
454         // Any calls to nonReentrant after this point will fail
455         _notEntered = false;
456 
457         _;
458 
459         // By storing the original value once again, a refund is triggered (see
460         // https://eips.ethereum.org/EIPS/eip-2200)
461         _notEntered = true;
462     }
463 }
464 
465 contract Ownable {
466     address public owner;
467     address public newOwner;
468 
469     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
470 
471     constructor() public {
472         owner = msg.sender;
473         newOwner = address(0);
474     }
475 
476     modifier onlyOwner() {
477         require(msg.sender == owner);
478         _;
479     }
480 
481     modifier onlyNewOwner() {
482         require(msg.sender != address(0));
483         require(msg.sender == newOwner);
484         _;
485     }
486     
487     function isOwner(address account) public view returns (bool) {
488         if(account == owner) {
489             return true;
490         }
491         else {
492             return false;
493         }
494     }
495 
496     function transferOwnership(address _newOwner) public onlyOwner {
497         require(_newOwner != address(0));
498         newOwner = _newOwner;
499     }
500 
501     function acceptOwnership() public onlyNewOwner {
502         emit OwnershipTransferred(owner, newOwner);        
503         owner = newOwner;
504         newOwner = address(0);
505     }
506 }
507 
508 contract Pausable is Ownable {
509     event Paused(address account);
510     event Unpaused(address account);
511 
512     bool private _paused;
513 
514     constructor () public {
515         _paused = false;
516     }    
517 
518     modifier whenNotPaused() {
519         require(!_paused);
520         _;
521     }
522 
523     modifier whenPaused() {
524         require(_paused);
525         _;
526     }
527 
528     function paused() public view returns (bool) {
529         return _paused;
530     }
531 
532     function pause() public onlyOwner whenNotPaused {
533         _paused = true;
534         emit Paused(msg.sender);
535     }
536 
537     function unpause() public onlyOwner whenPaused {
538         _paused = false;
539         emit Unpaused(msg.sender);
540     }
541 }
542 
543 
544 contract StakingDextoken is ReentrancyGuard, Pausable {
545     using SafeERC20 for IERC20;
546     using SafeMath for uint;
547 
548     event Freeze(address indexed account);
549     event Unfreeze(address indexed account);
550     event TokenDeposit(address account, uint amount);
551     event TokenWithdraw(address account, uint amount);
552     event TokenClaim(address account, uint amount);
553     event RewardAdded(uint reward);
554 
555     uint public periodFinish = 0;
556     uint public rewardRate = 0;
557     uint public lastUpdateTime;
558     uint public rewardPerTokenStored = 0;
559     uint public rewardRounds = 0;
560     uint public rewardsDuration = 0;
561     bool public inStaking = true;
562 
563     // BAL beneficial address
564     address public beneficial = address(this);
565 
566     // User award balance
567     mapping(address => uint) public rewards;
568     mapping(address => uint) public userRewardPerTokenPaid;
569 
570     uint private _start;
571     uint private _end;
572 
573     /// Staking token
574     IERC20 private _token0;
575 
576     /// Reward token
577     IERC20 private _token1;
578 
579     /// Total rewards
580     uint private _rewards;
581     uint private _remainingRewards;
582 
583     /// Total amount of user staking tokens
584     uint private _totalSupply;
585 
586     mapping(address => bool) public frozenAccount;
587 
588     /// The staking users
589     mapping(address => bool) public stakeHolders;
590 
591     /// The amount of tokens staked
592     mapping(address => uint) private _balances;
593 
594     /// The remaining withdrawals of staked tokens
595     mapping(address => uint) internal withdrawalOf;  
596 
597     /// The remaining withdrawals of reward tokens
598     mapping(address => uint) internal claimOf;
599 
600     constructor (address token0, address token1) public {
601         require(token0 != address(0), "DEXToken: zero address");
602         require(token1 != address(0), "DEXToken: zero address");
603 
604         _token0 = IERC20(token0);
605         _token1 = IERC20(token1);
606     }
607 
608     modifier notFrozen(address _account) {
609         require(!frozenAccount[_account]);
610         _;
611     }
612 
613     modifier updateReward(address account) {
614         rewardPerTokenStored = rewardPerToken();
615         lastUpdateTime = lastTimeRewardApplicable();
616         if (account != address(0)) {
617             rewards[account] = earned(account);
618             userRewardPerTokenPaid[account] = rewardPerTokenStored;
619         }
620         _;
621     }
622 
623     function setBeneficial(address _beneficial) onlyOwner external {
624         require(_beneficial != address(this), "setBeneficial: can not send to self");
625         require(_beneficial != address(0), "setBeneficial: can not burn tokens");
626         beneficial = _beneficial;
627     }
628 
629     /// Capture BAL tokens or any other tokens
630     function capture(address _token, uint amount) onlyOwner external {
631         require(_token != address(_token0), "capture: can not capture staking tokens");
632         require(_token != address(_token1), "capture: can not capture reward tokens");
633         require(beneficial != address(this), "capture: can not send to self");
634         require(beneficial != address(0), "capture: can not burn tokens");
635         IERC20(_token).safeTransfer(beneficial, amount);
636     }  
637 
638     function lastTimeRewardApplicable() public view returns (uint) {
639         return Math.min(block.timestamp, periodFinish);
640     }
641 
642     function rewardPerToken() public view returns (uint) {
643         if (getTotalStakes() == 0) {
644             return rewardPerTokenStored;
645         }
646         return
647             rewardPerTokenStored.add(
648                 lastTimeRewardApplicable()
649                     .sub(lastUpdateTime)
650                     .mul(rewardRate)
651                     .mul(1e18)
652                     .div(getTotalStakes())
653             );
654     }
655 
656     function earned(address account) public view returns (uint) {
657         return
658             balanceOf(account)
659                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
660                 .div(1e18)
661                 .add(rewards[account]);
662     }
663 
664     /// setup the staking round
665     function setRewardRound(uint round, uint reward, uint start, uint end) 
666         external
667         onlyOwner    
668     {
669         require(block.timestamp > periodFinish, "setRewardRound: previous rewards period not complete");
670         require(rewardRounds < round, "setRewardRound: this round completed");
671 
672         rewardRounds = round;
673         _rewards = reward;
674         _start = start;
675         _end = end;
676         rewardsDuration = _end.sub(_start);
677 
678         inStaking = false;
679     }
680 
681     /// launch the staking round
682     function notifyRewards()
683         external
684         onlyOwner
685         updateReward(address(0))
686     {
687         // staking started
688         if (inStaking == true) {
689             return;
690         }
691 
692         if (block.timestamp >= periodFinish) {
693             rewardRate = _rewards.div(rewardsDuration);
694         } else {
695             uint remaining = periodFinish.sub(block.timestamp);
696             uint leftover = remaining.mul(rewardRate);
697             rewardRate = _rewards.add(leftover).div(rewardsDuration);
698             _remainingRewards = leftover;
699         }
700 
701         // Ensure the provided reward amount is not more than the balance in the contract.
702         // This keeps the reward rate in the right range, preventing overflows due to
703         // very high values of rewardRate in the earned and rewardsPerToken functions;
704         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
705         uint balance = _token1.balanceOf(address(this));
706         require(rewardRate <= balance.div(rewardsDuration), "notifyRewards: provided reward too high");
707 
708         inStaking = true;
709         lastUpdateTime = block.timestamp;
710         periodFinish = block.timestamp.add(rewardsDuration);
711         emit RewardAdded(_rewards);
712     }
713 
714     function addStakeholder(address _stakeholder) internal {
715         stakeHolders[_stakeholder] = true;
716     }
717 
718     function removeStakeholder(address _stakeholder) internal {
719         stakeHolders[_stakeholder] = false;
720     }
721 
722     /// Deposit staking tokens
723     function deposit(uint amount) 
724         external 
725         nonReentrant
726         whenNotPaused 
727         notFrozen(msg.sender) 
728         updateReward(msg.sender)
729     {
730         require(amount > 0, "deposit: cannot stake 0");
731         require(msg.sender != address(0), "withdraw: zero address");
732         require(_token0.balanceOf(msg.sender) >= amount, "deposit: insufficient balance");
733         _totalSupply = _totalSupply.add(amount);          
734         _balances[msg.sender] = _balances[msg.sender].add(amount);
735         addStakeholder(msg.sender);
736         _token0.safeTransferFrom(msg.sender, address(this), amount);
737         emit TokenDeposit(msg.sender, amount);
738     }
739 
740     /// Withdraw staked tokens
741     function withdraw(uint amount) 
742         external 
743         nonReentrant
744         whenNotPaused 
745         notFrozen(msg.sender) 
746         updateReward(msg.sender)
747     {
748         require(amount > 0, "withdraw: amount invalid");
749         require(msg.sender != address(0), "withdraw: zero address");
750         /// Not overflow
751         require(_balances[msg.sender] >= amount);
752         _totalSupply = _totalSupply.sub(amount);                
753         _balances[msg.sender] = _balances[msg.sender].sub(amount);
754         /// Keep track user withdraws
755         withdrawalOf[msg.sender] = withdrawalOf[msg.sender].add(amount);  
756         if (_balances[msg.sender] == 0) {
757             removeStakeholder(msg.sender);   
758         }
759         _token0.safeTransfer(msg.sender, amount);
760         emit TokenWithdraw(msg.sender, amount);
761     }
762 
763     /// Claim reward tokens
764     function claim() 
765         external 
766         nonReentrant
767         whenNotPaused 
768         notFrozen(msg.sender) 
769         updateReward(msg.sender)
770     {
771         require(msg.sender != address(0), "claim: zero address");        
772         require(block.timestamp > getEndTimestamp(), "claim: claim not open");   
773         require(block.timestamp > periodFinish, "claim: current staking period not complete");
774 
775         uint reward = earned(msg.sender);
776         /// Not overflow        
777         require(_token1.balanceOf(address(this)) >= reward, "claim: insufficient balance");        
778         require(reward > 0, "claim: zero rewards");                
779 
780         rewards[msg.sender] = 0;
781         claimOf[msg.sender] = reward;
782         _token1.safeTransfer(msg.sender, reward);
783         emit TokenClaim(msg.sender, reward);
784     }
785 
786     function freezeAccount(address account) external onlyOwner returns (bool) {
787         require(!frozenAccount[account], "ERC20: account frozen");
788         frozenAccount[account] = true;
789         emit Freeze(account);
790         return true;
791     }
792 
793     function unfreezeAccount(address account) external onlyOwner returns (bool) {
794         require(frozenAccount[account], "ERC20: account not frozen");
795         frozenAccount[account] = false;
796         emit Unfreeze(account);
797         return true;
798     }
799 
800     function getWithdrawalOf(address _stakeholder) external view returns (uint) {
801         return withdrawalOf[_stakeholder];
802     }
803 
804     function getClaimOf(address _stakeholder) external view returns (uint) {
805         return claimOf[_stakeholder];
806     }
807 
808     /// Get remaining rewards of the time period
809     function remainingRewards() external view returns(uint) {
810         return _remainingRewards;
811     }
812 
813     /// Retrieve the stake for a stakeholder
814     function stakeOf(address _stakeholder) external view returns (uint) {
815         return _balances[_stakeholder];
816     }
817 
818     /// Retrieve the stake for a stakeholder
819     function rewardOf(address _stakeholder) external view returns (uint) {
820         return earned(_stakeholder);
821     }
822 
823     /// Get total original rewards
824     function totalRewards() external view returns (uint) {
825         return _rewards;
826     }  
827 
828     function getStartTimestamp() public view returns (uint) {
829         return _start;
830     }
831 
832     function getEndTimestamp() public view returns (uint) {
833         return _end;
834     }
835 
836     /// The total supply of all staked tokens
837     function getTotalStakes() public view returns (uint) {
838         return _totalSupply;
839     }
840 
841     function balanceOf(address account) public view returns (uint) {
842         return _balances[account];
843     }    
844 }