1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-27
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-11-20
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-11-13
11 */
12 
13 pragma solidity 0.5.17;
14 
15 
16 library Math {
17     /**
18      * @dev Returns the largest of two numbers.
19      */
20     function max(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a >= b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the smallest of two numbers.
26      */
27     function min(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a < b ? a : b;
29     }
30 
31     /**
32      * @dev Returns the average of two numbers. The result is rounded towards
33      * zero.
34      */
35     function average(uint256 a, uint256 b) internal pure returns (uint256) {
36         // (a + b) / 2 can overflow, so we distribute
37         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
38     }
39 }
40 
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @dev Optional functions from the ERC20 standard.
114  */
115 contract ERC20Detailed is IERC20 {
116     string private _name;
117     string private _symbol;
118     uint8 private _decimals;
119 
120     /**
121      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
122      * these values are immutable: they can only be set once during
123      * construction.
124      */
125     constructor (string memory name, string memory symbol, uint8 decimals) public {
126         _name = name;
127         _symbol = symbol;
128         _decimals = decimals;
129     }
130 
131     /**
132      * @dev Returns the name of the token.
133      */
134     function name() public view returns (string memory) {
135         return _name;
136     }
137 
138     /**
139      * @dev Returns the symbol of the token, usually a shorter version of the
140      * name.
141      */
142     function symbol() public view returns (string memory) {
143         return _symbol;
144     }
145 
146     /**
147      * @dev Returns the number of decimals used to get its user representation.
148      * For example, if `decimals` equals `2`, a balance of `505` tokens should
149      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
150      *
151      * Tokens usually opt for a value of 18, imitating the relationship between
152      * Ether and Wei.
153      *
154      * NOTE: This information is only used for _display_ purposes: it in
155      * no way affects any of the arithmetic of the contract, including
156      * {IERC20-balanceOf} and {IERC20-transfer}.
157      */
158     function decimals() public view returns (uint8) {
159         return _decimals;
160     }
161 }
162 
163 
164 library Address {
165     /**
166      * @dev Returns true if `account` is a contract.
167      *
168      * [IMPORTANT]
169      * ====
170      * It is unsafe to assume that an address for which this function returns
171      * false is an externally-owned account (EOA) and not a contract.
172      *
173      * Among others, `isContract` will return false for the following 
174      * types of addresses:
175      *
176      *  - an externally-owned account
177      *  - a contract in construction
178      *  - an address where a contract will be created
179      *  - an address where a contract lived, but was destroyed
180      * ====
181      */
182     function isContract(address account) internal view returns (bool) {
183         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
184         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
185         // for accounts without code, i.e. `keccak256('')`
186         bytes32 codehash;
187         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
188         // solhint-disable-next-line no-inline-assembly
189         assembly { codehash := extcodehash(account) }
190         return (codehash != accountHash && codehash != 0x0);
191     }
192 
193     /**
194      * @dev Converts an `address` into `address payable`. Note that this is
195      * simply a type cast: the actual underlying value is not changed.
196      *
197      * _Available since v2.4.0._
198      */
199     function toPayable(address account) internal pure returns (address payable) {
200         return address(uint160(account));
201     }
202 
203     /**
204      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
205      * `recipient`, forwarding all available gas and reverting on errors.
206      *
207      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
208      * of certain opcodes, possibly making contracts go over the 2300 gas limit
209      * imposed by `transfer`, making them unable to receive funds via
210      * `transfer`. {sendValue} removes this limitation.
211      *
212      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
213      *
214      * IMPORTANT: because control is transferred to `recipient`, care must be
215      * taken to not create reentrancy vulnerabilities. Consider using
216      * {ReentrancyGuard} or the
217      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
218      *
219      * _Available since v2.4.0._
220      */
221     function sendValue(address payable recipient, uint256 amount) internal {
222         require(address(this).balance >= amount, "Address: insufficient balance");
223 
224         // solhint-disable-next-line avoid-call-value
225         (bool success, ) = recipient.call.value(amount)("");
226         require(success, "Address: unable to send value, recipient may have reverted");
227     }
228 }
229 
230 library SafeMath {
231     /**
232      * @dev Returns the addition of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `+` operator.
236      *
237      * Requirements:
238      * - Addition cannot overflow.
239      */
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         uint256 c = a + b;
242         require(c >= a, "SafeMath: addition overflow");
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, reverting on
249      * overflow (when the result is negative).
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      * - Subtraction cannot overflow.
255      */
256     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
257         return sub(a, b, "SafeMath: subtraction overflow");
258     }
259 
260     /**
261      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
262      * overflow (when the result is negative).
263      *
264      * Counterpart to Solidity's `-` operator.
265      *
266      * Requirements:
267      * - Subtraction cannot overflow.
268      *
269      * _Available since v2.4.0._
270      */
271     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b <= a, errorMessage);
273         uint256 c = a - b;
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the multiplication of two unsigned integers, reverting on
280      * overflow.
281      *
282      * Counterpart to Solidity's `*` operator.
283      *
284      * Requirements:
285      * - Multiplication cannot overflow.
286      */
287     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
288         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
289         // benefit is lost if 'b' is also tested.
290         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
291         if (a == 0) {
292             return 0;
293         }
294 
295         uint256 c = a * b;
296         require(c / a == b, "SafeMath: multiplication overflow");
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the integer division of two unsigned integers. Reverts on
303      * division by zero. The result is rounded towards zero.
304      *
305      * Counterpart to Solidity's `/` operator. Note: this function uses a
306      * `revert` opcode (which leaves remaining gas untouched) while Solidity
307      * uses an invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      * - The divisor cannot be zero.
311      */
312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
313         return div(a, b, "SafeMath: division by zero");
314     }
315 
316     /**
317      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
318      * division by zero. The result is rounded towards zero.
319      *
320      * Counterpart to Solidity's `/` operator. Note: this function uses a
321      * `revert` opcode (which leaves remaining gas untouched) while Solidity
322      * uses an invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      * - The divisor cannot be zero.
326      *
327      * _Available since v2.4.0._
328      */
329     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
330         // Solidity only automatically asserts when dividing by 0
331         require(b > 0, errorMessage);
332         uint256 c = a / b;
333         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
334 
335         return c;
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * Reverts when dividing by zero.
341      *
342      * Counterpart to Solidity's `%` operator. This function uses a `revert`
343      * opcode (which leaves remaining gas untouched) while Solidity uses an
344      * invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      * - The divisor cannot be zero.
348      */
349     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
350         return mod(a, b, "SafeMath: modulo by zero");
351     }
352 
353     /**
354      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
355      * Reverts with custom message when dividing by zero.
356      *
357      * Counterpart to Solidity's `%` operator. This function uses a `revert`
358      * opcode (which leaves remaining gas untouched) while Solidity uses an
359      * invalid opcode to revert (consuming all remaining gas).
360      *
361      * Requirements:
362      * - The divisor cannot be zero.
363      *
364      * _Available since v2.4.0._
365      */
366     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
367         require(b != 0, errorMessage);
368         return a % b;
369     }
370 }
371 
372 library SafeERC20 {
373     using SafeMath for uint256;
374     using Address for address;
375 
376     function safeTransfer(IERC20 token, address to, uint256 value) internal {
377         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
378     }
379 
380     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
381         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
382     }
383 
384     function safeApprove(IERC20 token, address spender, uint256 value) internal {
385         // safeApprove should only be called when setting an initial allowance,
386         // or when resetting it to zero. To increase and decrease it, use
387         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
388         // solhint-disable-next-line max-line-length
389         require((value == 0) || (token.allowance(address(this), spender) == 0),
390             "SafeERC20: approve from non-zero to non-zero allowance"
391         );
392         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
393     }
394 
395     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
396         uint256 newAllowance = token.allowance(address(this), spender).add(value);
397         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
398     }
399 
400     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
401         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
402         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
403     }
404 
405     /**
406      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
407      * on the return value: the return value is optional (but if data is returned, it must not be false).
408      * @param token The token targeted by the call.
409      * @param data The call data (encoded using abi.encode or one of its variants).
410      */
411     function callOptionalReturn(IERC20 token, bytes memory data) private {
412         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
413         // we're implementing it ourselves.
414 
415         // A Solidity high level call has three parts:
416         //  1. The target address is checked to verify it contains contract code
417         //  2. The call itself is made, and success asserted
418         //  3. The return value is decoded, which in turn checks the size of the returned data.
419         // solhint-disable-next-line max-line-length
420         require(address(token).isContract(), "SafeERC20: call to non-contract");
421 
422         // solhint-disable-next-line avoid-low-level-calls
423         (bool success, bytes memory returndata) = address(token).call(data);
424         require(success, "SafeERC20: low-level call failed");
425 
426         if (returndata.length > 0) { // Return data is optional
427             // solhint-disable-next-line max-line-length
428             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
429         }
430     }
431 }
432 
433 
434 contract ReentrancyGuard {
435     bool private _notEntered;
436 
437     constructor () internal {
438         // Storing an initial non-zero value makes deployment a bit more
439         // expensive, but in exchange the refund on every call to nonReentrant
440         // will be lower in amount. Since refunds are capped to a percetange of
441         // the total transaction's gas, it is best to keep them low in cases
442         // like this one, to increase the likelihood of the full refund coming
443         // into effect.
444         _notEntered = true;
445     }
446 
447     /**
448      * @dev Prevents a contract from calling itself, directly or indirectly.
449      * Calling a `nonReentrant` function from another `nonReentrant`
450      * function is not supported. It is possible to prevent this from happening
451      * by making the `nonReentrant` function external, and make it call a
452      * `private` function that does the actual work.
453      */
454     modifier nonReentrant() {
455         // On the first call to nonReentrant, _notEntered will be true
456         require(_notEntered, "ReentrancyGuard: reentrant call");
457 
458         // Any calls to nonReentrant after this point will fail
459         _notEntered = false;
460 
461         _;
462 
463         // By storing the original value once again, a refund is triggered (see
464         // https://eips.ethereum.org/EIPS/eip-2200)
465         _notEntered = true;
466     }
467 }
468 
469 contract Ownable {
470     address public owner;
471     address public newOwner;
472 
473     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
474 
475     constructor() public {
476         owner = msg.sender;
477         newOwner = address(0);
478     }
479 
480     modifier onlyOwner() {
481         require(msg.sender == owner);
482         _;
483     }
484 
485     modifier onlyNewOwner() {
486         require(msg.sender != address(0));
487         require(msg.sender == newOwner);
488         _;
489     }
490     
491     function isOwner(address account) public view returns (bool) {
492         if(account == owner) {
493             return true;
494         }
495         else {
496             return false;
497         }
498     }
499 
500     function transferOwnership(address _newOwner) public onlyOwner {
501         require(_newOwner != address(0));
502         newOwner = _newOwner;
503     }
504 
505     function acceptOwnership() public onlyNewOwner {
506         emit OwnershipTransferred(owner, newOwner);        
507         owner = newOwner;
508         newOwner = address(0);
509     }
510 }
511 
512 contract Pausable is Ownable {
513     event Paused(address account);
514     event Unpaused(address account);
515 
516     bool private _paused;
517 
518     constructor () public {
519         _paused = false;
520     }    
521 
522     modifier whenNotPaused() {
523         require(!_paused);
524         _;
525     }
526 
527     modifier whenPaused() {
528         require(_paused);
529         _;
530     }
531 
532     function paused() public view returns (bool) {
533         return _paused;
534     }
535 
536     function pause() public onlyOwner whenNotPaused {
537         _paused = true;
538         emit Paused(msg.sender);
539     }
540 
541     function unpause() public onlyOwner whenPaused {
542         _paused = false;
543         emit Unpaused(msg.sender);
544     }
545 }
546 
547 
548 contract StakingDextoken is ReentrancyGuard, Pausable {
549     using SafeERC20 for IERC20;
550     using SafeMath for uint;
551 
552     event Freeze(address indexed account);
553     event Unfreeze(address indexed account);
554     event TokenDeposit(address account, uint amount);
555     event TokenWithdraw(address account, uint amount);
556     event TokenClaim(address account, uint amount);
557     event RewardAdded(uint reward);
558 
559     uint public periodFinish = 0;
560     uint public rewardRate = 0;
561     uint public lastUpdateTime;
562     uint public rewardPerTokenStored = 0;
563     uint public rewardRounds = 0;
564     uint public rewardsDuration = 0;
565     bool public inStaking = true;
566 
567     // BAL beneficial address
568     address public beneficial = address(this);
569 
570     // User award balance
571     mapping(address => uint) public rewards;
572     mapping(address => uint) public userRewardPerTokenPaid;
573 
574     uint private _start;
575     uint private _end;
576 
577     /// Staking token
578     IERC20 private _token0;
579 
580     /// Reward token
581     IERC20 private _token1;
582 
583     /// Total rewards
584     uint private _rewards;
585     uint private _remainingRewards;
586 
587     /// Total amount of user staking tokens
588     uint private _totalSupply;
589 
590     mapping(address => bool) public frozenAccount;
591 
592     /// The staking users
593     mapping(address => bool) public stakeHolders;
594 
595     /// The amount of tokens staked
596     mapping(address => uint) private _balances;
597 
598     /// The remaining withdrawals of staked tokens
599     mapping(address => uint) internal withdrawalOf;  
600 
601     /// The remaining withdrawals of reward tokens
602     mapping(address => uint) internal claimOf;
603 
604     constructor (address token0, address token1) public {
605         require(token0 != address(0), "DEXToken: zero address");
606         require(token1 != address(0), "DEXToken: zero address");
607 
608         _token0 = IERC20(token0);
609         _token1 = IERC20(token1);
610     }
611 
612     modifier notFrozen(address _account) {
613         require(!frozenAccount[_account]);
614         _;
615     }
616 
617     modifier updateReward(address account) {
618         rewardPerTokenStored = rewardPerToken();
619         lastUpdateTime = lastTimeRewardApplicable();
620         if (account != address(0)) {
621             rewards[account] = earned(account);
622             userRewardPerTokenPaid[account] = rewardPerTokenStored;
623         }
624         _;
625     }
626 
627     function setBeneficial(address _beneficial) onlyOwner external {
628         require(_beneficial != address(this), "setBeneficial: can not send to self");
629         require(_beneficial != address(0), "setBeneficial: can not burn tokens");
630         beneficial = _beneficial;
631     }
632 
633     /// Capture BAL tokens or any other tokens
634     function capture(address _token, uint amount) onlyOwner external {
635         require(_token != address(_token0), "capture: can not capture staking tokens");
636         require(_token != address(_token1), "capture: can not capture reward tokens");
637         require(beneficial != address(this), "capture: can not send to self");
638         require(beneficial != address(0), "capture: can not burn tokens");
639         IERC20(_token).safeTransfer(beneficial, amount);
640     }  
641 
642     function lastTimeRewardApplicable() public view returns (uint) {
643         return Math.min(block.timestamp, periodFinish);
644     }
645 
646     function rewardPerToken() public view returns (uint) {
647         if (getTotalStakes() == 0) {
648             return rewardPerTokenStored;
649         }
650         return
651             rewardPerTokenStored.add(
652                 lastTimeRewardApplicable()
653                     .sub(lastUpdateTime)
654                     .mul(rewardRate)
655                     .mul(1e18)
656                     .div(getTotalStakes())
657             );
658     }
659 
660     function earned(address account) public view returns (uint) {
661         return
662             balanceOf(account)
663                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
664                 .div(1e18)
665                 .add(rewards[account]);
666     }
667 
668     /// setup the staking round
669     function setRewardRound(uint round, uint reward, uint start, uint end) 
670         external
671         onlyOwner    
672     {
673         require(block.timestamp > periodFinish, "setRewardRound: previous rewards period not complete");
674         require(rewardRounds < round, "setRewardRound: this round completed");
675 
676         rewardRounds = round;
677         _rewards = reward;
678         _start = start;
679         _end = end;
680         rewardsDuration = _end.sub(_start);
681 
682         inStaking = false;
683     }
684 
685     /// launch the staking round
686     function notifyRewards()
687         external
688         onlyOwner
689         updateReward(address(0))
690     {
691         // staking started
692         if (inStaking == true) {
693             return;
694         }
695 
696         if (block.timestamp >= periodFinish) {
697             rewardRate = _rewards.div(rewardsDuration);
698         } else {
699             uint remaining = periodFinish.sub(block.timestamp);
700             uint leftover = remaining.mul(rewardRate);
701             rewardRate = _rewards.add(leftover).div(rewardsDuration);
702             _remainingRewards = leftover;
703         }
704 
705         // Ensure the provided reward amount is not more than the balance in the contract.
706         // This keeps the reward rate in the right range, preventing overflows due to
707         // very high values of rewardRate in the earned and rewardsPerToken functions;
708         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
709         uint balance = _token1.balanceOf(address(this));
710         require(rewardRate <= balance.div(rewardsDuration), "notifyRewards: provided reward too high");
711 
712         inStaking = true;
713         lastUpdateTime = block.timestamp;
714         periodFinish = block.timestamp.add(rewardsDuration);
715         emit RewardAdded(_rewards);
716     }
717 
718     function addStakeholder(address _stakeholder) internal {
719         stakeHolders[_stakeholder] = true;
720     }
721 
722     function removeStakeholder(address _stakeholder) internal {
723         stakeHolders[_stakeholder] = false;
724     }
725 
726     /// Deposit staking tokens
727     function deposit(uint amount) 
728         external 
729         nonReentrant
730         whenNotPaused 
731         notFrozen(msg.sender) 
732         updateReward(msg.sender)
733     {
734         require(amount > 0, "deposit: cannot stake 0");
735         require(msg.sender != address(0), "withdraw: zero address");
736         require(_token0.balanceOf(msg.sender) >= amount, "deposit: insufficient balance");
737         _totalSupply = _totalSupply.add(amount);          
738         _balances[msg.sender] = _balances[msg.sender].add(amount);
739         addStakeholder(msg.sender);
740         _token0.safeTransferFrom(msg.sender, address(this), amount);
741         emit TokenDeposit(msg.sender, amount);
742     }
743 
744     /// Withdraw staked tokens
745     function withdraw(uint amount) 
746         external 
747         nonReentrant
748         whenNotPaused 
749         notFrozen(msg.sender) 
750         updateReward(msg.sender)
751     {
752         require(amount > 0, "withdraw: amount invalid");
753         require(msg.sender != address(0), "withdraw: zero address");
754         /// Not overflow
755         require(_balances[msg.sender] >= amount);
756         _totalSupply = _totalSupply.sub(amount);                
757         _balances[msg.sender] = _balances[msg.sender].sub(amount);
758         /// Keep track user withdraws
759         withdrawalOf[msg.sender] = withdrawalOf[msg.sender].add(amount);  
760         if (_balances[msg.sender] == 0) {
761             removeStakeholder(msg.sender);   
762         }
763         _token0.safeTransfer(msg.sender, amount);
764         emit TokenWithdraw(msg.sender, amount);
765     }
766 
767     /// Claim reward tokens
768     function claim() 
769         external 
770         nonReentrant
771         whenNotPaused 
772         notFrozen(msg.sender) 
773         updateReward(msg.sender)
774     {
775         require(msg.sender != address(0), "claim: zero address");        
776         require(block.timestamp > getEndTimestamp(), "claim: claim not open");   
777         require(block.timestamp > periodFinish, "claim: current staking period not complete");
778 
779         uint reward = earned(msg.sender);
780         /// Not overflow        
781         require(_token1.balanceOf(address(this)) >= reward, "claim: insufficient balance");        
782         require(reward > 0, "claim: zero rewards");                
783 
784         rewards[msg.sender] = 0;
785         claimOf[msg.sender] = reward;
786         _token1.safeTransfer(msg.sender, reward);
787         emit TokenClaim(msg.sender, reward);
788     }
789 
790     function freezeAccount(address account) external onlyOwner returns (bool) {
791         require(!frozenAccount[account], "ERC20: account frozen");
792         frozenAccount[account] = true;
793         emit Freeze(account);
794         return true;
795     }
796 
797     function unfreezeAccount(address account) external onlyOwner returns (bool) {
798         require(frozenAccount[account], "ERC20: account not frozen");
799         frozenAccount[account] = false;
800         emit Unfreeze(account);
801         return true;
802     }
803 
804     function getWithdrawalOf(address _stakeholder) external view returns (uint) {
805         return withdrawalOf[_stakeholder];
806     }
807 
808     function getClaimOf(address _stakeholder) external view returns (uint) {
809         return claimOf[_stakeholder];
810     }
811 
812     /// Get remaining rewards of the time period
813     function remainingRewards() external view returns(uint) {
814         return _remainingRewards;
815     }
816 
817     /// Retrieve the stake for a stakeholder
818     function stakeOf(address _stakeholder) external view returns (uint) {
819         return _balances[_stakeholder];
820     }
821 
822     /// Retrieve the stake for a stakeholder
823     function rewardOf(address _stakeholder) external view returns (uint) {
824         return earned(_stakeholder);
825     }
826 
827     /// Get total original rewards
828     function totalRewards() external view returns (uint) {
829         return _rewards;
830     }  
831 
832     function getStartTimestamp() public view returns (uint) {
833         return _start;
834     }
835 
836     function getEndTimestamp() public view returns (uint) {
837         return _end;
838     }
839 
840     /// The total supply of all staked tokens
841     function getTotalStakes() public view returns (uint) {
842         return _totalSupply;
843     }
844 
845     function balanceOf(address account) public view returns (uint) {
846         return _balances[account];
847     }    
848 }