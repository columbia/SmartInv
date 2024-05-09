1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-13
3 */
4 
5 pragma solidity 0.5.17;
6 
7 
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @dev Optional functions from the ERC20 standard.
106  */
107 contract ERC20Detailed is IERC20 {
108     string private _name;
109     string private _symbol;
110     uint8 private _decimals;
111 
112     /**
113      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
114      * these values are immutable: they can only be set once during
115      * construction.
116      */
117     constructor (string memory name, string memory symbol, uint8 decimals) public {
118         _name = name;
119         _symbol = symbol;
120         _decimals = decimals;
121     }
122 
123     /**
124      * @dev Returns the name of the token.
125      */
126     function name() public view returns (string memory) {
127         return _name;
128     }
129 
130     /**
131      * @dev Returns the symbol of the token, usually a shorter version of the
132      * name.
133      */
134     function symbol() public view returns (string memory) {
135         return _symbol;
136     }
137 
138     /**
139      * @dev Returns the number of decimals used to get its user representation.
140      * For example, if `decimals` equals `2`, a balance of `505` tokens should
141      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
142      *
143      * Tokens usually opt for a value of 18, imitating the relationship between
144      * Ether and Wei.
145      *
146      * NOTE: This information is only used for _display_ purposes: it in
147      * no way affects any of the arithmetic of the contract, including
148      * {IERC20-balanceOf} and {IERC20-transfer}.
149      */
150     function decimals() public view returns (uint8) {
151         return _decimals;
152     }
153 }
154 
155 
156 library Address {
157     /**
158      * @dev Returns true if `account` is a contract.
159      *
160      * [IMPORTANT]
161      * ====
162      * It is unsafe to assume that an address for which this function returns
163      * false is an externally-owned account (EOA) and not a contract.
164      *
165      * Among others, `isContract` will return false for the following 
166      * types of addresses:
167      *
168      *  - an externally-owned account
169      *  - a contract in construction
170      *  - an address where a contract will be created
171      *  - an address where a contract lived, but was destroyed
172      * ====
173      */
174     function isContract(address account) internal view returns (bool) {
175         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
176         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
177         // for accounts without code, i.e. `keccak256('')`
178         bytes32 codehash;
179         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
180         // solhint-disable-next-line no-inline-assembly
181         assembly { codehash := extcodehash(account) }
182         return (codehash != accountHash && codehash != 0x0);
183     }
184 
185     /**
186      * @dev Converts an `address` into `address payable`. Note that this is
187      * simply a type cast: the actual underlying value is not changed.
188      *
189      * _Available since v2.4.0._
190      */
191     function toPayable(address account) internal pure returns (address payable) {
192         return address(uint160(account));
193     }
194 
195     /**
196      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
197      * `recipient`, forwarding all available gas and reverting on errors.
198      *
199      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
200      * of certain opcodes, possibly making contracts go over the 2300 gas limit
201      * imposed by `transfer`, making them unable to receive funds via
202      * `transfer`. {sendValue} removes this limitation.
203      *
204      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
205      *
206      * IMPORTANT: because control is transferred to `recipient`, care must be
207      * taken to not create reentrancy vulnerabilities. Consider using
208      * {ReentrancyGuard} or the
209      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
210      *
211      * _Available since v2.4.0._
212      */
213     function sendValue(address payable recipient, uint256 amount) internal {
214         require(address(this).balance >= amount, "Address: insufficient balance");
215 
216         // solhint-disable-next-line avoid-call-value
217         (bool success, ) = recipient.call.value(amount)("");
218         require(success, "Address: unable to send value, recipient may have reverted");
219     }
220 }
221 
222 library SafeMath {
223     /**
224      * @dev Returns the addition of two unsigned integers, reverting on
225      * overflow.
226      *
227      * Counterpart to Solidity's `+` operator.
228      *
229      * Requirements:
230      * - Addition cannot overflow.
231      */
232     function add(uint256 a, uint256 b) internal pure returns (uint256) {
233         uint256 c = a + b;
234         require(c >= a, "SafeMath: addition overflow");
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting on
241      * overflow (when the result is negative).
242      *
243      * Counterpart to Solidity's `-` operator.
244      *
245      * Requirements:
246      * - Subtraction cannot overflow.
247      */
248     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
249         return sub(a, b, "SafeMath: subtraction overflow");
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
254      * overflow (when the result is negative).
255      *
256      * Counterpart to Solidity's `-` operator.
257      *
258      * Requirements:
259      * - Subtraction cannot overflow.
260      *
261      * _Available since v2.4.0._
262      */
263     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b <= a, errorMessage);
265         uint256 c = a - b;
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the multiplication of two unsigned integers, reverting on
272      * overflow.
273      *
274      * Counterpart to Solidity's `*` operator.
275      *
276      * Requirements:
277      * - Multiplication cannot overflow.
278      */
279     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
280         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
281         // benefit is lost if 'b' is also tested.
282         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
283         if (a == 0) {
284             return 0;
285         }
286 
287         uint256 c = a * b;
288         require(c / a == b, "SafeMath: multiplication overflow");
289 
290         return c;
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers. Reverts on
295      * division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      * - The divisor cannot be zero.
303      */
304     function div(uint256 a, uint256 b) internal pure returns (uint256) {
305         return div(a, b, "SafeMath: division by zero");
306     }
307 
308     /**
309      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
310      * division by zero. The result is rounded towards zero.
311      *
312      * Counterpart to Solidity's `/` operator. Note: this function uses a
313      * `revert` opcode (which leaves remaining gas untouched) while Solidity
314      * uses an invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      * - The divisor cannot be zero.
318      *
319      * _Available since v2.4.0._
320      */
321     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
322         // Solidity only automatically asserts when dividing by 0
323         require(b > 0, errorMessage);
324         uint256 c = a / b;
325         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
326 
327         return c;
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * Reverts when dividing by zero.
333      *
334      * Counterpart to Solidity's `%` operator. This function uses a `revert`
335      * opcode (which leaves remaining gas untouched) while Solidity uses an
336      * invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      * - The divisor cannot be zero.
340      */
341     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
342         return mod(a, b, "SafeMath: modulo by zero");
343     }
344 
345     /**
346      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
347      * Reverts with custom message when dividing by zero.
348      *
349      * Counterpart to Solidity's `%` operator. This function uses a `revert`
350      * opcode (which leaves remaining gas untouched) while Solidity uses an
351      * invalid opcode to revert (consuming all remaining gas).
352      *
353      * Requirements:
354      * - The divisor cannot be zero.
355      *
356      * _Available since v2.4.0._
357      */
358     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
359         require(b != 0, errorMessage);
360         return a % b;
361     }
362 }
363 
364 library SafeERC20 {
365     using SafeMath for uint256;
366     using Address for address;
367 
368     function safeTransfer(IERC20 token, address to, uint256 value) internal {
369         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
370     }
371 
372     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
373         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
374     }
375 
376     function safeApprove(IERC20 token, address spender, uint256 value) internal {
377         // safeApprove should only be called when setting an initial allowance,
378         // or when resetting it to zero. To increase and decrease it, use
379         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
380         // solhint-disable-next-line max-line-length
381         require((value == 0) || (token.allowance(address(this), spender) == 0),
382             "SafeERC20: approve from non-zero to non-zero allowance"
383         );
384         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
385     }
386 
387     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
388         uint256 newAllowance = token.allowance(address(this), spender).add(value);
389         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
390     }
391 
392     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
393         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
394         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
395     }
396 
397     /**
398      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
399      * on the return value: the return value is optional (but if data is returned, it must not be false).
400      * @param token The token targeted by the call.
401      * @param data The call data (encoded using abi.encode or one of its variants).
402      */
403     function callOptionalReturn(IERC20 token, bytes memory data) private {
404         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
405         // we're implementing it ourselves.
406 
407         // A Solidity high level call has three parts:
408         //  1. The target address is checked to verify it contains contract code
409         //  2. The call itself is made, and success asserted
410         //  3. The return value is decoded, which in turn checks the size of the returned data.
411         // solhint-disable-next-line max-line-length
412         require(address(token).isContract(), "SafeERC20: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = address(token).call(data);
416         require(success, "SafeERC20: low-level call failed");
417 
418         if (returndata.length > 0) { // Return data is optional
419             // solhint-disable-next-line max-line-length
420             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
421         }
422     }
423 }
424 
425 
426 contract ReentrancyGuard {
427     bool private _notEntered;
428 
429     constructor () internal {
430         // Storing an initial non-zero value makes deployment a bit more
431         // expensive, but in exchange the refund on every call to nonReentrant
432         // will be lower in amount. Since refunds are capped to a percetange of
433         // the total transaction's gas, it is best to keep them low in cases
434         // like this one, to increase the likelihood of the full refund coming
435         // into effect.
436         _notEntered = true;
437     }
438 
439     /**
440      * @dev Prevents a contract from calling itself, directly or indirectly.
441      * Calling a `nonReentrant` function from another `nonReentrant`
442      * function is not supported. It is possible to prevent this from happening
443      * by making the `nonReentrant` function external, and make it call a
444      * `private` function that does the actual work.
445      */
446     modifier nonReentrant() {
447         // On the first call to nonReentrant, _notEntered will be true
448         require(_notEntered, "ReentrancyGuard: reentrant call");
449 
450         // Any calls to nonReentrant after this point will fail
451         _notEntered = false;
452 
453         _;
454 
455         // By storing the original value once again, a refund is triggered (see
456         // https://eips.ethereum.org/EIPS/eip-2200)
457         _notEntered = true;
458     }
459 }
460 
461 contract Ownable {
462     address public owner;
463     address public newOwner;
464 
465     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
466 
467     constructor() public {
468         owner = msg.sender;
469         newOwner = address(0);
470     }
471 
472     modifier onlyOwner() {
473         require(msg.sender == owner);
474         _;
475     }
476 
477     modifier onlyNewOwner() {
478         require(msg.sender != address(0));
479         require(msg.sender == newOwner);
480         _;
481     }
482     
483     function isOwner(address account) public view returns (bool) {
484         if(account == owner) {
485             return true;
486         }
487         else {
488             return false;
489         }
490     }
491 
492     function transferOwnership(address _newOwner) public onlyOwner {
493         require(_newOwner != address(0));
494         newOwner = _newOwner;
495     }
496 
497     function acceptOwnership() public onlyNewOwner {
498         emit OwnershipTransferred(owner, newOwner);        
499         owner = newOwner;
500         newOwner = address(0);
501     }
502 }
503 
504 contract Pausable is Ownable {
505     event Paused(address account);
506     event Unpaused(address account);
507 
508     bool private _paused;
509 
510     constructor () public {
511         _paused = false;
512     }    
513 
514     modifier whenNotPaused() {
515         require(!_paused);
516         _;
517     }
518 
519     modifier whenPaused() {
520         require(_paused);
521         _;
522     }
523 
524     function paused() public view returns (bool) {
525         return _paused;
526     }
527 
528     function pause() public onlyOwner whenNotPaused {
529         _paused = true;
530         emit Paused(msg.sender);
531     }
532 
533     function unpause() public onlyOwner whenPaused {
534         _paused = false;
535         emit Unpaused(msg.sender);
536     }
537 }
538 
539 
540 contract StakingDextoken is ReentrancyGuard, Pausable {
541     using SafeERC20 for IERC20;
542     using SafeMath for uint;
543 
544     event Freeze(address indexed account);
545     event Unfreeze(address indexed account);
546     event TokenDeposit(address account, uint amount);
547     event TokenWithdraw(address account, uint amount);
548     event TokenClaim(address account, uint amount);
549     event RewardAdded(uint reward);
550 
551     uint public periodFinish = 0;
552     uint public rewardRate = 0;
553     uint public lastUpdateTime;
554     uint public rewardPerTokenStored = 0;
555     uint public rewardRounds = 0;
556     uint public rewardsDuration = 0;
557     bool public inStaking = true;
558 
559     // BAL beneficial address
560     address public beneficial = address(this);
561 
562     // User award balance
563     mapping(address => uint) public rewards;
564     mapping(address => uint) public userRewardPerTokenPaid;
565 
566     uint private _start;
567     uint private _end;
568 
569     /// Staking token
570     IERC20 private _token0;
571 
572     /// Reward token
573     IERC20 private _token1;
574 
575     /// Total rewards
576     uint private _rewards;
577     uint private _remainingRewards;
578 
579     /// Total amount of user staking tokens
580     uint private _totalSupply;
581 
582     mapping(address => bool) public frozenAccount;
583 
584     /// The staking users
585     mapping(address => bool) public stakeHolders;
586 
587     /// The amount of tokens staked
588     mapping(address => uint) private _balances;
589 
590     /// The remaining withdrawals of staked tokens
591     mapping(address => uint) internal withdrawalOf;  
592 
593     /// The remaining withdrawals of reward tokens
594     mapping(address => uint) internal claimOf;
595 
596     constructor (address token0, address token1) public {
597         require(token0 != address(0), "DEXToken: zero address");
598         require(token1 != address(0), "DEXToken: zero address");
599 
600         _token0 = IERC20(token0);
601         _token1 = IERC20(token1);
602     }
603 
604     modifier notFrozen(address _account) {
605         require(!frozenAccount[_account]);
606         _;
607     }
608 
609     modifier updateReward(address account) {
610         rewardPerTokenStored = rewardPerToken();
611         lastUpdateTime = lastTimeRewardApplicable();
612         if (account != address(0)) {
613             rewards[account] = earned(account);
614             userRewardPerTokenPaid[account] = rewardPerTokenStored;
615         }
616         _;
617     }
618 
619     function setBeneficial(address _beneficial) onlyOwner external {
620         require(_beneficial != address(this), "setBeneficial: can not send to self");
621         require(_beneficial != address(0), "setBeneficial: can not burn tokens");
622         beneficial = _beneficial;
623     }
624 
625     /// Capture BAL tokens or any other tokens
626     function capture(address _token, uint amount) onlyOwner external {
627         require(_token != address(_token0), "capture: can not capture staking tokens");
628         require(_token != address(_token1), "capture: can not capture reward tokens");
629         require(beneficial != address(this), "capture: can not send to self");
630         require(beneficial != address(0), "capture: can not burn tokens");
631         IERC20(_token).safeTransfer(beneficial, amount);
632     }  
633 
634     function lastTimeRewardApplicable() public view returns (uint) {
635         return Math.min(block.timestamp, periodFinish);
636     }
637 
638     function rewardPerToken() public view returns (uint) {
639         if (getTotalStakes() == 0) {
640             return rewardPerTokenStored;
641         }
642         return
643             rewardPerTokenStored.add(
644                 lastTimeRewardApplicable()
645                     .sub(lastUpdateTime)
646                     .mul(rewardRate)
647                     .mul(1e18)
648                     .div(getTotalStakes())
649             );
650     }
651 
652     function earned(address account) public view returns (uint) {
653         return
654             balanceOf(account)
655                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
656                 .div(1e18)
657                 .add(rewards[account]);
658     }
659 
660     /// setup the staking round
661     function setRewardRound(uint round, uint reward, uint start, uint end) 
662         external
663         onlyOwner    
664     {
665         require(block.timestamp > periodFinish, "setRewardRound: previous rewards period not complete");
666         require(rewardRounds < round, "setRewardRound: this round completed");
667 
668         rewardRounds = round;
669         _rewards = reward;
670         _start = start;
671         _end = end;
672         rewardsDuration = _end.sub(_start);
673 
674         inStaking = false;
675     }
676 
677     /// launch the staking round
678     function notifyRewards()
679         external
680         onlyOwner
681         updateReward(address(0))
682     {
683         // staking started
684         if (inStaking == true) {
685             return;
686         }
687 
688         if (block.timestamp >= periodFinish) {
689             rewardRate = _rewards.div(rewardsDuration);
690         } else {
691             uint remaining = periodFinish.sub(block.timestamp);
692             uint leftover = remaining.mul(rewardRate);
693             rewardRate = _rewards.add(leftover).div(rewardsDuration);
694             _remainingRewards = leftover;
695         }
696 
697         // Ensure the provided reward amount is not more than the balance in the contract.
698         // This keeps the reward rate in the right range, preventing overflows due to
699         // very high values of rewardRate in the earned and rewardsPerToken functions;
700         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
701         uint balance = _token1.balanceOf(address(this));
702         require(rewardRate <= balance.div(rewardsDuration), "notifyRewards: provided reward too high");
703 
704         inStaking = true;
705         lastUpdateTime = block.timestamp;
706         periodFinish = block.timestamp.add(rewardsDuration);
707         emit RewardAdded(_rewards);
708     }
709 
710     function addStakeholder(address _stakeholder) internal {
711         stakeHolders[_stakeholder] = true;
712     }
713 
714     function removeStakeholder(address _stakeholder) internal {
715         stakeHolders[_stakeholder] = false;
716     }
717 
718     /// Deposit staking tokens
719     function deposit(uint amount) 
720         external 
721         nonReentrant
722         whenNotPaused 
723         notFrozen(msg.sender) 
724         updateReward(msg.sender)
725     {
726         require(amount > 0, "deposit: cannot stake 0");
727         require(msg.sender != address(0), "withdraw: zero address");
728         require(_token0.balanceOf(msg.sender) >= amount, "deposit: insufficient balance");
729         _totalSupply = _totalSupply.add(amount);          
730         _balances[msg.sender] = _balances[msg.sender].add(amount);
731         addStakeholder(msg.sender);
732         _token0.safeTransferFrom(msg.sender, address(this), amount);
733         emit TokenDeposit(msg.sender, amount);
734     }
735 
736     /// Withdraw staked tokens
737     function withdraw(uint amount) 
738         external 
739         nonReentrant
740         whenNotPaused 
741         notFrozen(msg.sender) 
742         updateReward(msg.sender)
743     {
744         require(amount > 0, "withdraw: amount invalid");
745         require(msg.sender != address(0), "withdraw: zero address");
746         /// Not overflow
747         require(_balances[msg.sender] >= amount);
748         _totalSupply = _totalSupply.sub(amount);                
749         _balances[msg.sender] = _balances[msg.sender].sub(amount);
750         /// Keep track user withdraws
751         withdrawalOf[msg.sender] = withdrawalOf[msg.sender].add(amount);  
752         if (_balances[msg.sender] == 0) {
753             removeStakeholder(msg.sender);   
754         }
755         _token0.safeTransfer(msg.sender, amount);
756         emit TokenWithdraw(msg.sender, amount);
757     }
758 
759     /// Claim reward tokens
760     function claim() 
761         external 
762         nonReentrant
763         whenNotPaused 
764         notFrozen(msg.sender) 
765         updateReward(msg.sender)
766     {
767         require(msg.sender != address(0), "claim: zero address");        
768         require(block.timestamp > getEndTimestamp(), "claim: claim not open");   
769         require(block.timestamp > periodFinish, "claim: current staking period not complete");
770 
771         uint reward = earned(msg.sender);
772         /// Not overflow        
773         require(_token1.balanceOf(address(this)) >= reward, "claim: insufficient balance");        
774         require(reward > 0, "claim: zero rewards");                
775 
776         rewards[msg.sender] = 0;
777         claimOf[msg.sender] = reward;
778         _token1.safeTransfer(msg.sender, reward);
779         emit TokenClaim(msg.sender, reward);
780     }
781 
782     function freezeAccount(address account) external onlyOwner returns (bool) {
783         require(!frozenAccount[account], "ERC20: account frozen");
784         frozenAccount[account] = true;
785         emit Freeze(account);
786         return true;
787     }
788 
789     function unfreezeAccount(address account) external onlyOwner returns (bool) {
790         require(frozenAccount[account], "ERC20: account not frozen");
791         frozenAccount[account] = false;
792         emit Unfreeze(account);
793         return true;
794     }
795 
796     function getWithdrawalOf(address _stakeholder) external view returns (uint) {
797         return withdrawalOf[_stakeholder];
798     }
799 
800     function getClaimOf(address _stakeholder) external view returns (uint) {
801         return claimOf[_stakeholder];
802     }
803 
804     /// Get remaining rewards of the time period
805     function remainingRewards() external view returns(uint) {
806         return _remainingRewards;
807     }
808 
809     /// Retrieve the stake for a stakeholder
810     function stakeOf(address _stakeholder) external view returns (uint) {
811         return _balances[_stakeholder];
812     }
813 
814     /// Retrieve the stake for a stakeholder
815     function rewardOf(address _stakeholder) external view returns (uint) {
816         return earned(_stakeholder);
817     }
818 
819     /// Get total original rewards
820     function totalRewards() external view returns (uint) {
821         return _rewards;
822     }  
823 
824     function getStartTimestamp() public view returns (uint) {
825         return _start;
826     }
827 
828     function getEndTimestamp() public view returns (uint) {
829         return _end;
830     }
831 
832     /// The total supply of all staked tokens
833     function getTotalStakes() public view returns (uint) {
834         return _totalSupply;
835     }
836 
837     function balanceOf(address account) public view returns (uint) {
838         return _balances[account];
839     }    
840 }