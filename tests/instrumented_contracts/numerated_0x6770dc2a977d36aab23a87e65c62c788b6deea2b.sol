1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-11
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-11-27
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-11-20
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2020-11-13
15 */
16 
17 pragma solidity 0.5.17;
18 
19 
20 library Math {
21     /**
22      * @dev Returns the largest of two numbers.
23      */
24     function max(uint256 a, uint256 b) internal pure returns (uint256) {
25         return a >= b ? a : b;
26     }
27 
28     /**
29      * @dev Returns the smallest of two numbers.
30      */
31     function min(uint256 a, uint256 b) internal pure returns (uint256) {
32         return a < b ? a : b;
33     }
34 
35     /**
36      * @dev Returns the average of two numbers. The result is rounded towards
37      * zero.
38      */
39     function average(uint256 a, uint256 b) internal pure returns (uint256) {
40         // (a + b) / 2 can overflow, so we distribute
41         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
42     }
43 }
44 
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @dev Optional functions from the ERC20 standard.
118  */
119 contract ERC20Detailed is IERC20 {
120     string private _name;
121     string private _symbol;
122     uint8 private _decimals;
123 
124     /**
125      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
126      * these values are immutable: they can only be set once during
127      * construction.
128      */
129     constructor (string memory name, string memory symbol, uint8 decimals) public {
130         _name = name;
131         _symbol = symbol;
132         _decimals = decimals;
133     }
134 
135     /**
136      * @dev Returns the name of the token.
137      */
138     function name() public view returns (string memory) {
139         return _name;
140     }
141 
142     /**
143      * @dev Returns the symbol of the token, usually a shorter version of the
144      * name.
145      */
146     function symbol() public view returns (string memory) {
147         return _symbol;
148     }
149 
150     /**
151      * @dev Returns the number of decimals used to get its user representation.
152      * For example, if `decimals` equals `2`, a balance of `505` tokens should
153      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
154      *
155      * Tokens usually opt for a value of 18, imitating the relationship between
156      * Ether and Wei.
157      *
158      * NOTE: This information is only used for _display_ purposes: it in
159      * no way affects any of the arithmetic of the contract, including
160      * {IERC20-balanceOf} and {IERC20-transfer}.
161      */
162     function decimals() public view returns (uint8) {
163         return _decimals;
164     }
165 }
166 
167 
168 library Address {
169     /**
170      * @dev Returns true if `account` is a contract.
171      *
172      * [IMPORTANT]
173      * ====
174      * It is unsafe to assume that an address for which this function returns
175      * false is an externally-owned account (EOA) and not a contract.
176      *
177      * Among others, `isContract` will return false for the following 
178      * types of addresses:
179      *
180      *  - an externally-owned account
181      *  - a contract in construction
182      *  - an address where a contract will be created
183      *  - an address where a contract lived, but was destroyed
184      * ====
185      */
186     function isContract(address account) internal view returns (bool) {
187         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
188         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
189         // for accounts without code, i.e. `keccak256('')`
190         bytes32 codehash;
191         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
192         // solhint-disable-next-line no-inline-assembly
193         assembly { codehash := extcodehash(account) }
194         return (codehash != accountHash && codehash != 0x0);
195     }
196 
197     /**
198      * @dev Converts an `address` into `address payable`. Note that this is
199      * simply a type cast: the actual underlying value is not changed.
200      *
201      * _Available since v2.4.0._
202      */
203     function toPayable(address account) internal pure returns (address payable) {
204         return address(uint160(account));
205     }
206 
207     /**
208      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
209      * `recipient`, forwarding all available gas and reverting on errors.
210      *
211      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
212      * of certain opcodes, possibly making contracts go over the 2300 gas limit
213      * imposed by `transfer`, making them unable to receive funds via
214      * `transfer`. {sendValue} removes this limitation.
215      *
216      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
217      *
218      * IMPORTANT: because control is transferred to `recipient`, care must be
219      * taken to not create reentrancy vulnerabilities. Consider using
220      * {ReentrancyGuard} or the
221      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
222      *
223      * _Available since v2.4.0._
224      */
225     function sendValue(address payable recipient, uint256 amount) internal {
226         require(address(this).balance >= amount, "Address: insufficient balance");
227 
228         // solhint-disable-next-line avoid-call-value
229         (bool success, ) = recipient.call.value(amount)("");
230         require(success, "Address: unable to send value, recipient may have reverted");
231     }
232 }
233 
234 library SafeMath {
235     /**
236      * @dev Returns the addition of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `+` operator.
240      *
241      * Requirements:
242      * - Addition cannot overflow.
243      */
244     function add(uint256 a, uint256 b) internal pure returns (uint256) {
245         uint256 c = a + b;
246         require(c >= a, "SafeMath: addition overflow");
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the subtraction of two unsigned integers, reverting on
253      * overflow (when the result is negative).
254      *
255      * Counterpart to Solidity's `-` operator.
256      *
257      * Requirements:
258      * - Subtraction cannot overflow.
259      */
260     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
261         return sub(a, b, "SafeMath: subtraction overflow");
262     }
263 
264     /**
265      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
266      * overflow (when the result is negative).
267      *
268      * Counterpart to Solidity's `-` operator.
269      *
270      * Requirements:
271      * - Subtraction cannot overflow.
272      *
273      * _Available since v2.4.0._
274      */
275     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b <= a, errorMessage);
277         uint256 c = a - b;
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the multiplication of two unsigned integers, reverting on
284      * overflow.
285      *
286      * Counterpart to Solidity's `*` operator.
287      *
288      * Requirements:
289      * - Multiplication cannot overflow.
290      */
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
293         // benefit is lost if 'b' is also tested.
294         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
295         if (a == 0) {
296             return 0;
297         }
298 
299         uint256 c = a * b;
300         require(c / a == b, "SafeMath: multiplication overflow");
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the integer division of two unsigned integers. Reverts on
307      * division by zero. The result is rounded towards zero.
308      *
309      * Counterpart to Solidity's `/` operator. Note: this function uses a
310      * `revert` opcode (which leaves remaining gas untouched) while Solidity
311      * uses an invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      * - The divisor cannot be zero.
315      */
316     function div(uint256 a, uint256 b) internal pure returns (uint256) {
317         return div(a, b, "SafeMath: division by zero");
318     }
319 
320     /**
321      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
322      * division by zero. The result is rounded towards zero.
323      *
324      * Counterpart to Solidity's `/` operator. Note: this function uses a
325      * `revert` opcode (which leaves remaining gas untouched) while Solidity
326      * uses an invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      * - The divisor cannot be zero.
330      *
331      * _Available since v2.4.0._
332      */
333     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         // Solidity only automatically asserts when dividing by 0
335         require(b > 0, errorMessage);
336         uint256 c = a / b;
337         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
338 
339         return c;
340     }
341 
342     /**
343      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
344      * Reverts when dividing by zero.
345      *
346      * Counterpart to Solidity's `%` operator. This function uses a `revert`
347      * opcode (which leaves remaining gas untouched) while Solidity uses an
348      * invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      * - The divisor cannot be zero.
352      */
353     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
354         return mod(a, b, "SafeMath: modulo by zero");
355     }
356 
357     /**
358      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
359      * Reverts with custom message when dividing by zero.
360      *
361      * Counterpart to Solidity's `%` operator. This function uses a `revert`
362      * opcode (which leaves remaining gas untouched) while Solidity uses an
363      * invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      * - The divisor cannot be zero.
367      *
368      * _Available since v2.4.0._
369      */
370     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
371         require(b != 0, errorMessage);
372         return a % b;
373     }
374 }
375 
376 library SafeERC20 {
377     using SafeMath for uint256;
378     using Address for address;
379 
380     function safeTransfer(IERC20 token, address to, uint256 value) internal {
381         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
382     }
383 
384     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
385         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
386     }
387 
388     function safeApprove(IERC20 token, address spender, uint256 value) internal {
389         // safeApprove should only be called when setting an initial allowance,
390         // or when resetting it to zero. To increase and decrease it, use
391         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
392         // solhint-disable-next-line max-line-length
393         require((value == 0) || (token.allowance(address(this), spender) == 0),
394             "SafeERC20: approve from non-zero to non-zero allowance"
395         );
396         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
397     }
398 
399     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
400         uint256 newAllowance = token.allowance(address(this), spender).add(value);
401         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
402     }
403 
404     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
405         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
406         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
407     }
408 
409     /**
410      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
411      * on the return value: the return value is optional (but if data is returned, it must not be false).
412      * @param token The token targeted by the call.
413      * @param data The call data (encoded using abi.encode or one of its variants).
414      */
415     function callOptionalReturn(IERC20 token, bytes memory data) private {
416         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
417         // we're implementing it ourselves.
418 
419         // A Solidity high level call has three parts:
420         //  1. The target address is checked to verify it contains contract code
421         //  2. The call itself is made, and success asserted
422         //  3. The return value is decoded, which in turn checks the size of the returned data.
423         // solhint-disable-next-line max-line-length
424         require(address(token).isContract(), "SafeERC20: call to non-contract");
425 
426         // solhint-disable-next-line avoid-low-level-calls
427         (bool success, bytes memory returndata) = address(token).call(data);
428         require(success, "SafeERC20: low-level call failed");
429 
430         if (returndata.length > 0) { // Return data is optional
431             // solhint-disable-next-line max-line-length
432             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
433         }
434     }
435 }
436 
437 
438 contract ReentrancyGuard {
439     bool private _notEntered;
440 
441     constructor () internal {
442         // Storing an initial non-zero value makes deployment a bit more
443         // expensive, but in exchange the refund on every call to nonReentrant
444         // will be lower in amount. Since refunds are capped to a percetange of
445         // the total transaction's gas, it is best to keep them low in cases
446         // like this one, to increase the likelihood of the full refund coming
447         // into effect.
448         _notEntered = true;
449     }
450 
451     /**
452      * @dev Prevents a contract from calling itself, directly or indirectly.
453      * Calling a `nonReentrant` function from another `nonReentrant`
454      * function is not supported. It is possible to prevent this from happening
455      * by making the `nonReentrant` function external, and make it call a
456      * `private` function that does the actual work.
457      */
458     modifier nonReentrant() {
459         // On the first call to nonReentrant, _notEntered will be true
460         require(_notEntered, "ReentrancyGuard: reentrant call");
461 
462         // Any calls to nonReentrant after this point will fail
463         _notEntered = false;
464 
465         _;
466 
467         // By storing the original value once again, a refund is triggered (see
468         // https://eips.ethereum.org/EIPS/eip-2200)
469         _notEntered = true;
470     }
471 }
472 
473 contract Ownable {
474     address public owner;
475     address public newOwner;
476 
477     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
478 
479     constructor() public {
480         owner = msg.sender;
481         newOwner = address(0);
482     }
483 
484     modifier onlyOwner() {
485         require(msg.sender == owner);
486         _;
487     }
488 
489     modifier onlyNewOwner() {
490         require(msg.sender != address(0));
491         require(msg.sender == newOwner);
492         _;
493     }
494     
495     function isOwner(address account) public view returns (bool) {
496         if(account == owner) {
497             return true;
498         }
499         else {
500             return false;
501         }
502     }
503 
504     function transferOwnership(address _newOwner) public onlyOwner {
505         require(_newOwner != address(0));
506         newOwner = _newOwner;
507     }
508 
509     function acceptOwnership() public onlyNewOwner {
510         emit OwnershipTransferred(owner, newOwner);        
511         owner = newOwner;
512         newOwner = address(0);
513     }
514 }
515 
516 contract Pausable is Ownable {
517     event Paused(address account);
518     event Unpaused(address account);
519 
520     bool private _paused;
521 
522     constructor () public {
523         _paused = false;
524     }    
525 
526     modifier whenNotPaused() {
527         require(!_paused);
528         _;
529     }
530 
531     modifier whenPaused() {
532         require(_paused);
533         _;
534     }
535 
536     function paused() public view returns (bool) {
537         return _paused;
538     }
539 
540     function pause() public onlyOwner whenNotPaused {
541         _paused = true;
542         emit Paused(msg.sender);
543     }
544 
545     function unpause() public onlyOwner whenPaused {
546         _paused = false;
547         emit Unpaused(msg.sender);
548     }
549 }
550 
551 
552 contract StakingDextoken is ReentrancyGuard, Pausable {
553     using SafeERC20 for IERC20;
554     using SafeMath for uint;
555 
556     event Freeze(address indexed account);
557     event Unfreeze(address indexed account);
558     event TokenDeposit(address account, uint amount);
559     event TokenWithdraw(address account, uint amount);
560     event TokenClaim(address account, uint amount);
561     event RewardAdded(uint reward);
562 
563     uint public periodFinish = 0;
564     uint public rewardRate = 0;
565     uint public lastUpdateTime;
566     uint public rewardPerTokenStored = 0;
567     uint public rewardRounds = 0;
568     uint public rewardsDuration = 0;
569     bool public inStaking = true;
570 
571     // BAL beneficial address
572     address public beneficial = address(this);
573 
574     // User award balance
575     mapping(address => uint) public rewards;
576     mapping(address => uint) public userRewardPerTokenPaid;
577 
578     uint private _start;
579     uint private _end;
580 
581     /// Staking token
582     IERC20 private _token0;
583 
584     /// Reward token
585     IERC20 private _token1;
586 
587     /// Total rewards
588     uint private _rewards;
589     uint private _remainingRewards;
590 
591     /// Total amount of user staking tokens
592     uint private _totalSupply;
593 
594     mapping(address => bool) public frozenAccount;
595 
596     /// The staking users
597     mapping(address => bool) public stakeHolders;
598 
599     /// The amount of tokens staked
600     mapping(address => uint) private _balances;
601 
602     /// The remaining withdrawals of staked tokens
603     mapping(address => uint) internal withdrawalOf;  
604 
605     /// The remaining withdrawals of reward tokens
606     mapping(address => uint) internal claimOf;
607 
608     constructor (address token0, address token1) public {
609         require(token0 != address(0), "DEXToken: zero address");
610         require(token1 != address(0), "DEXToken: zero address");
611 
612         _token0 = IERC20(token0);
613         _token1 = IERC20(token1);
614     }
615 
616     modifier notFrozen(address _account) {
617         require(!frozenAccount[_account]);
618         _;
619     }
620 
621     modifier updateReward(address account) {
622         rewardPerTokenStored = rewardPerToken();
623         lastUpdateTime = lastTimeRewardApplicable();
624         if (account != address(0)) {
625             rewards[account] = earned(account);
626             userRewardPerTokenPaid[account] = rewardPerTokenStored;
627         }
628         _;
629     }
630 
631     function setBeneficial(address _beneficial) onlyOwner external {
632         require(_beneficial != address(this), "setBeneficial: can not send to self");
633         require(_beneficial != address(0), "setBeneficial: can not burn tokens");
634         beneficial = _beneficial;
635     }
636 
637     /// Capture BAL tokens or any other tokens
638     function capture(address _token, uint amount) onlyOwner external {
639         require(_token != address(_token0), "capture: can not capture staking tokens");
640         require(_token != address(_token1), "capture: can not capture reward tokens");
641         require(beneficial != address(this), "capture: can not send to self");
642         require(beneficial != address(0), "capture: can not burn tokens");
643         IERC20(_token).safeTransfer(beneficial, amount);
644     }  
645 
646     function lastTimeRewardApplicable() public view returns (uint) {
647         return Math.min(block.timestamp, periodFinish);
648     }
649 
650     function rewardPerToken() public view returns (uint) {
651         if (getTotalStakes() == 0) {
652             return rewardPerTokenStored;
653         }
654         return
655             rewardPerTokenStored.add(
656                 lastTimeRewardApplicable()
657                     .sub(lastUpdateTime)
658                     .mul(rewardRate)
659                     .mul(1e18)
660                     .div(getTotalStakes())
661             );
662     }
663 
664     function earned(address account) public view returns (uint) {
665         return
666             balanceOf(account)
667                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
668                 .div(1e18)
669                 .add(rewards[account]);
670     }
671 
672     /// setup the staking round
673     function setRewardRound(uint round, uint reward, uint start, uint end) 
674         external
675         onlyOwner    
676     {
677         require(block.timestamp > periodFinish, "setRewardRound: previous rewards period not complete");
678         require(rewardRounds < round, "setRewardRound: this round completed");
679 
680         rewardRounds = round;
681         _rewards = reward;
682         _start = start;
683         _end = end;
684         rewardsDuration = _end.sub(_start);
685 
686         inStaking = false;
687     }
688 
689     /// launch the staking round
690     function notifyRewards()
691         external
692         onlyOwner
693         updateReward(address(0))
694     {
695         // staking started
696         if (inStaking == true) {
697             return;
698         }
699 
700         if (block.timestamp >= periodFinish) {
701             rewardRate = _rewards.div(rewardsDuration);
702         } else {
703             uint remaining = periodFinish.sub(block.timestamp);
704             uint leftover = remaining.mul(rewardRate);
705             rewardRate = _rewards.add(leftover).div(rewardsDuration);
706             _remainingRewards = leftover;
707         }
708 
709         // Ensure the provided reward amount is not more than the balance in the contract.
710         // This keeps the reward rate in the right range, preventing overflows due to
711         // very high values of rewardRate in the earned and rewardsPerToken functions;
712         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
713         uint balance = _token1.balanceOf(address(this));
714         require(rewardRate <= balance.div(rewardsDuration), "notifyRewards: provided reward too high");
715 
716         inStaking = true;
717         lastUpdateTime = block.timestamp;
718         periodFinish = block.timestamp.add(rewardsDuration);
719         emit RewardAdded(_rewards);
720     }
721 
722     function addStakeholder(address _stakeholder) internal {
723         stakeHolders[_stakeholder] = true;
724     }
725 
726     function removeStakeholder(address _stakeholder) internal {
727         stakeHolders[_stakeholder] = false;
728     }
729 
730     /// Deposit staking tokens
731     function deposit(uint amount) 
732         external 
733         nonReentrant
734         whenNotPaused 
735         notFrozen(msg.sender) 
736         updateReward(msg.sender)
737     {
738         require(amount > 0, "deposit: cannot stake 0");
739         require(msg.sender != address(0), "withdraw: zero address");
740         require(_token0.balanceOf(msg.sender) >= amount, "deposit: insufficient balance");
741         _totalSupply = _totalSupply.add(amount);          
742         _balances[msg.sender] = _balances[msg.sender].add(amount);
743         addStakeholder(msg.sender);
744         _token0.safeTransferFrom(msg.sender, address(this), amount);
745         emit TokenDeposit(msg.sender, amount);
746     }
747 
748     /// Withdraw staked tokens
749     function withdraw(uint amount) 
750         external 
751         nonReentrant
752         whenNotPaused 
753         notFrozen(msg.sender) 
754         updateReward(msg.sender)
755     {
756         require(amount > 0, "withdraw: amount invalid");
757         require(msg.sender != address(0), "withdraw: zero address");
758         /// Not overflow
759         require(_balances[msg.sender] >= amount);
760         _totalSupply = _totalSupply.sub(amount);                
761         _balances[msg.sender] = _balances[msg.sender].sub(amount);
762         /// Keep track user withdraws
763         withdrawalOf[msg.sender] = withdrawalOf[msg.sender].add(amount);  
764         if (_balances[msg.sender] == 0) {
765             removeStakeholder(msg.sender);   
766         }
767         _token0.safeTransfer(msg.sender, amount);
768         emit TokenWithdraw(msg.sender, amount);
769     }
770 
771     /// Claim reward tokens
772     function claim() 
773         external 
774         nonReentrant
775         whenNotPaused 
776         notFrozen(msg.sender) 
777         updateReward(msg.sender)
778     {
779         require(msg.sender != address(0), "claim: zero address");        
780         require(block.timestamp > getEndTimestamp(), "claim: claim not open");   
781         require(block.timestamp > periodFinish, "claim: current staking period not complete");
782 
783         uint reward = earned(msg.sender);
784         /// Not overflow        
785         require(_token1.balanceOf(address(this)) >= reward, "claim: insufficient balance");        
786         require(reward > 0, "claim: zero rewards");                
787 
788         rewards[msg.sender] = 0;
789         claimOf[msg.sender] = reward;
790         _token1.safeTransfer(msg.sender, reward);
791         emit TokenClaim(msg.sender, reward);
792     }
793 
794     function freezeAccount(address account) external onlyOwner returns (bool) {
795         require(!frozenAccount[account], "ERC20: account frozen");
796         frozenAccount[account] = true;
797         emit Freeze(account);
798         return true;
799     }
800 
801     function unfreezeAccount(address account) external onlyOwner returns (bool) {
802         require(frozenAccount[account], "ERC20: account not frozen");
803         frozenAccount[account] = false;
804         emit Unfreeze(account);
805         return true;
806     }
807 
808     function getWithdrawalOf(address _stakeholder) external view returns (uint) {
809         return withdrawalOf[_stakeholder];
810     }
811 
812     function getClaimOf(address _stakeholder) external view returns (uint) {
813         return claimOf[_stakeholder];
814     }
815 
816     /// Get remaining rewards of the time period
817     function remainingRewards() external view returns(uint) {
818         return _remainingRewards;
819     }
820 
821     /// Retrieve the stake for a stakeholder
822     function stakeOf(address _stakeholder) external view returns (uint) {
823         return _balances[_stakeholder];
824     }
825 
826     /// Retrieve the stake for a stakeholder
827     function rewardOf(address _stakeholder) external view returns (uint) {
828         return earned(_stakeholder);
829     }
830 
831     /// Get total original rewards
832     function totalRewards() external view returns (uint) {
833         return _rewards;
834     }  
835 
836     function getStartTimestamp() public view returns (uint) {
837         return _start;
838     }
839 
840     function getEndTimestamp() public view returns (uint) {
841         return _end;
842     }
843 
844     /// The total supply of all staked tokens
845     function getTotalStakes() public view returns (uint) {
846         return _totalSupply;
847     }
848 
849     function balanceOf(address account) public view returns (uint) {
850         return _balances[account];
851     }    
852 }