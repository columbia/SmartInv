1 pragma solidity 0.5.17;
2 
3 
4 library Math {
5     /**
6      * @dev Returns the largest of two numbers.
7      */
8     function max(uint256 a, uint256 b) internal pure returns (uint256) {
9         return a >= b ? a : b;
10     }
11 
12     /**
13      * @dev Returns the smallest of two numbers.
14      */
15     function min(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a < b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the average of two numbers. The result is rounded towards
21      * zero.
22      */
23     function average(uint256 a, uint256 b) internal pure returns (uint256) {
24         // (a + b) / 2 can overflow, so we distribute
25         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
26     }
27 }
28 
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @dev Optional functions from the ERC20 standard.
102  */
103 contract ERC20Detailed is IERC20 {
104     string private _name;
105     string private _symbol;
106     uint8 private _decimals;
107 
108     /**
109      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
110      * these values are immutable: they can only be set once during
111      * construction.
112      */
113     constructor (string memory name, string memory symbol, uint8 decimals) public {
114         _name = name;
115         _symbol = symbol;
116         _decimals = decimals;
117     }
118 
119     /**
120      * @dev Returns the name of the token.
121      */
122     function name() public view returns (string memory) {
123         return _name;
124     }
125 
126     /**
127      * @dev Returns the symbol of the token, usually a shorter version of the
128      * name.
129      */
130     function symbol() public view returns (string memory) {
131         return _symbol;
132     }
133 
134     /**
135      * @dev Returns the number of decimals used to get its user representation.
136      * For example, if `decimals` equals `2`, a balance of `505` tokens should
137      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
138      *
139      * Tokens usually opt for a value of 18, imitating the relationship between
140      * Ether and Wei.
141      *
142      * NOTE: This information is only used for _display_ purposes: it in
143      * no way affects any of the arithmetic of the contract, including
144      * {IERC20-balanceOf} and {IERC20-transfer}.
145      */
146     function decimals() public view returns (uint8) {
147         return _decimals;
148     }
149 }
150 
151 
152 library Address {
153     /**
154      * @dev Returns true if `account` is a contract.
155      *
156      * [IMPORTANT]
157      * ====
158      * It is unsafe to assume that an address for which this function returns
159      * false is an externally-owned account (EOA) and not a contract.
160      *
161      * Among others, `isContract` will return false for the following 
162      * types of addresses:
163      *
164      *  - an externally-owned account
165      *  - a contract in construction
166      *  - an address where a contract will be created
167      *  - an address where a contract lived, but was destroyed
168      * ====
169      */
170     function isContract(address account) internal view returns (bool) {
171         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
172         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
173         // for accounts without code, i.e. `keccak256('')`
174         bytes32 codehash;
175         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
176         // solhint-disable-next-line no-inline-assembly
177         assembly { codehash := extcodehash(account) }
178         return (codehash != accountHash && codehash != 0x0);
179     }
180 
181     /**
182      * @dev Converts an `address` into `address payable`. Note that this is
183      * simply a type cast: the actual underlying value is not changed.
184      *
185      * _Available since v2.4.0._
186      */
187     function toPayable(address account) internal pure returns (address payable) {
188         return address(uint160(account));
189     }
190 
191     /**
192      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
193      * `recipient`, forwarding all available gas and reverting on errors.
194      *
195      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
196      * of certain opcodes, possibly making contracts go over the 2300 gas limit
197      * imposed by `transfer`, making them unable to receive funds via
198      * `transfer`. {sendValue} removes this limitation.
199      *
200      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
201      *
202      * IMPORTANT: because control is transferred to `recipient`, care must be
203      * taken to not create reentrancy vulnerabilities. Consider using
204      * {ReentrancyGuard} or the
205      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
206      *
207      * _Available since v2.4.0._
208      */
209     function sendValue(address payable recipient, uint256 amount) internal {
210         require(address(this).balance >= amount, "Address: insufficient balance");
211 
212         // solhint-disable-next-line avoid-call-value
213         (bool success, ) = recipient.call.value(amount)("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 }
217 
218 library SafeMath {
219     /**
220      * @dev Returns the addition of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `+` operator.
224      *
225      * Requirements:
226      * - Addition cannot overflow.
227      */
228     function add(uint256 a, uint256 b) internal pure returns (uint256) {
229         uint256 c = a + b;
230         require(c >= a, "SafeMath: addition overflow");
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting on
237      * overflow (when the result is negative).
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      * - Subtraction cannot overflow.
243      */
244     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
245         return sub(a, b, "SafeMath: subtraction overflow");
246     }
247 
248     /**
249      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
250      * overflow (when the result is negative).
251      *
252      * Counterpart to Solidity's `-` operator.
253      *
254      * Requirements:
255      * - Subtraction cannot overflow.
256      *
257      * _Available since v2.4.0._
258      */
259     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b <= a, errorMessage);
261         uint256 c = a - b;
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the multiplication of two unsigned integers, reverting on
268      * overflow.
269      *
270      * Counterpart to Solidity's `*` operator.
271      *
272      * Requirements:
273      * - Multiplication cannot overflow.
274      */
275     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
276         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
277         // benefit is lost if 'b' is also tested.
278         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
279         if (a == 0) {
280             return 0;
281         }
282 
283         uint256 c = a * b;
284         require(c / a == b, "SafeMath: multiplication overflow");
285 
286         return c;
287     }
288 
289     /**
290      * @dev Returns the integer division of two unsigned integers. Reverts on
291      * division by zero. The result is rounded towards zero.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      * - The divisor cannot be zero.
299      */
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         return div(a, b, "SafeMath: division by zero");
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      * - The divisor cannot be zero.
314      *
315      * _Available since v2.4.0._
316      */
317     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         // Solidity only automatically asserts when dividing by 0
319         require(b > 0, errorMessage);
320         uint256 c = a / b;
321         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
322 
323         return c;
324     }
325 
326     /**
327      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
328      * Reverts when dividing by zero.
329      *
330      * Counterpart to Solidity's `%` operator. This function uses a `revert`
331      * opcode (which leaves remaining gas untouched) while Solidity uses an
332      * invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      * - The divisor cannot be zero.
336      */
337     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
338         return mod(a, b, "SafeMath: modulo by zero");
339     }
340 
341     /**
342      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
343      * Reverts with custom message when dividing by zero.
344      *
345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
346      * opcode (which leaves remaining gas untouched) while Solidity uses an
347      * invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      * - The divisor cannot be zero.
351      *
352      * _Available since v2.4.0._
353      */
354     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
355         require(b != 0, errorMessage);
356         return a % b;
357     }
358 }
359 
360 library SafeERC20 {
361     using SafeMath for uint256;
362     using Address for address;
363 
364     function safeTransfer(IERC20 token, address to, uint256 value) internal {
365         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
366     }
367 
368     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
369         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
370     }
371 
372     function safeApprove(IERC20 token, address spender, uint256 value) internal {
373         // safeApprove should only be called when setting an initial allowance,
374         // or when resetting it to zero. To increase and decrease it, use
375         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
376         // solhint-disable-next-line max-line-length
377         require((value == 0) || (token.allowance(address(this), spender) == 0),
378             "SafeERC20: approve from non-zero to non-zero allowance"
379         );
380         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
381     }
382 
383     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
384         uint256 newAllowance = token.allowance(address(this), spender).add(value);
385         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
386     }
387 
388     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
389         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
390         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
391     }
392 
393     /**
394      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
395      * on the return value: the return value is optional (but if data is returned, it must not be false).
396      * @param token The token targeted by the call.
397      * @param data The call data (encoded using abi.encode or one of its variants).
398      */
399     function callOptionalReturn(IERC20 token, bytes memory data) private {
400         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
401         // we're implementing it ourselves.
402 
403         // A Solidity high level call has three parts:
404         //  1. The target address is checked to verify it contains contract code
405         //  2. The call itself is made, and success asserted
406         //  3. The return value is decoded, which in turn checks the size of the returned data.
407         // solhint-disable-next-line max-line-length
408         require(address(token).isContract(), "SafeERC20: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = address(token).call(data);
412         require(success, "SafeERC20: low-level call failed");
413 
414         if (returndata.length > 0) { // Return data is optional
415             // solhint-disable-next-line max-line-length
416             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
417         }
418     }
419 }
420 
421 
422 contract ReentrancyGuard {
423     bool private _notEntered;
424 
425     constructor () internal {
426         // Storing an initial non-zero value makes deployment a bit more
427         // expensive, but in exchange the refund on every call to nonReentrant
428         // will be lower in amount. Since refunds are capped to a percetange of
429         // the total transaction's gas, it is best to keep them low in cases
430         // like this one, to increase the likelihood of the full refund coming
431         // into effect.
432         _notEntered = true;
433     }
434 
435     /**
436      * @dev Prevents a contract from calling itself, directly or indirectly.
437      * Calling a `nonReentrant` function from another `nonReentrant`
438      * function is not supported. It is possible to prevent this from happening
439      * by making the `nonReentrant` function external, and make it call a
440      * `private` function that does the actual work.
441      */
442     modifier nonReentrant() {
443         // On the first call to nonReentrant, _notEntered will be true
444         require(_notEntered, "ReentrancyGuard: reentrant call");
445 
446         // Any calls to nonReentrant after this point will fail
447         _notEntered = false;
448 
449         _;
450 
451         // By storing the original value once again, a refund is triggered (see
452         // https://eips.ethereum.org/EIPS/eip-2200)
453         _notEntered = true;
454     }
455 }
456 
457 contract Ownable {
458     address public owner;
459     address public newOwner;
460 
461     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
462 
463     constructor() public {
464         owner = msg.sender;
465         newOwner = address(0);
466     }
467 
468     modifier onlyOwner() {
469         require(msg.sender == owner);
470         _;
471     }
472 
473     modifier onlyNewOwner() {
474         require(msg.sender != address(0));
475         require(msg.sender == newOwner);
476         _;
477     }
478     
479     function isOwner(address account) public view returns (bool) {
480         if(account == owner) {
481             return true;
482         }
483         else {
484             return false;
485         }
486     }
487 
488     function transferOwnership(address _newOwner) public onlyOwner {
489         require(_newOwner != address(0));
490         newOwner = _newOwner;
491     }
492 
493     function acceptOwnership() public onlyNewOwner {
494         emit OwnershipTransferred(owner, newOwner);        
495         owner = newOwner;
496         newOwner = address(0);
497     }
498 }
499 
500 contract Pausable is Ownable {
501     event Paused(address account);
502     event Unpaused(address account);
503 
504     bool private _paused;
505 
506     constructor () public {
507         _paused = false;
508     }    
509 
510     modifier whenNotPaused() {
511         require(!_paused);
512         _;
513     }
514 
515     modifier whenPaused() {
516         require(_paused);
517         _;
518     }
519 
520     function paused() public view returns (bool) {
521         return _paused;
522     }
523 
524     function pause() public onlyOwner whenNotPaused {
525         _paused = true;
526         emit Paused(msg.sender);
527     }
528 
529     function unpause() public onlyOwner whenPaused {
530         _paused = false;
531         emit Unpaused(msg.sender);
532     }
533 }
534 
535 
536 contract StakingDextoken is ReentrancyGuard, Pausable {
537     using SafeERC20 for IERC20;
538     using SafeMath for uint;
539 
540     event Freeze(address indexed account);
541     event Unfreeze(address indexed account);
542     event TokenDeposit(address account, uint amount);
543     event TokenWithdraw(address account, uint amount);
544     event TokenClaim(address account, uint amount);
545     event RewardAdded(uint reward);
546 
547     uint public periodFinish = 0;
548     uint public rewardRate = 0;
549     uint public lastUpdateTime;
550     uint public rewardPerTokenStored = 0;
551     uint public rewardRounds = 0;
552     uint public rewardsDuration = 0;
553     bool public inStaking = true;
554 
555     // BAL beneficial address
556     address public beneficial = address(this);
557 
558     // User award balance
559     mapping(address => uint) public rewards;
560     mapping(address => uint) public userRewardPerTokenPaid;
561 
562     uint private _start;
563     uint private _end;
564 
565     /// Staking token
566     IERC20 private _token0;
567 
568     /// Reward token
569     IERC20 private _token1;
570 
571     /// Total rewards
572     uint private _rewards;
573     uint private _remainingRewards;
574 
575     /// Total amount of user staking tokens
576     uint private _totalSupply;
577 
578     mapping(address => bool) public frozenAccount;
579 
580     /// The staking users
581     mapping(address => bool) public stakeHolders;
582 
583     /// The amount of tokens staked
584     mapping(address => uint) private _balances;
585 
586     /// The remaining withdrawals of staked tokens
587     mapping(address => uint) internal withdrawalOf;  
588 
589     /// The remaining withdrawals of reward tokens
590     mapping(address => uint) internal claimOf;
591 
592     constructor (address token0, address token1) public {
593         require(token0 != address(0), "DEXToken: zero address");
594         require(token1 != address(0), "DEXToken: zero address");
595 
596         _token0 = IERC20(token0);
597         _token1 = IERC20(token1);
598     }
599 
600     modifier notFrozen(address _account) {
601         require(!frozenAccount[_account]);
602         _;
603     }
604 
605     modifier updateReward(address account) {
606         rewardPerTokenStored = rewardPerToken();
607         lastUpdateTime = lastTimeRewardApplicable();
608         if (account != address(0)) {
609             rewards[account] = earned(account);
610             userRewardPerTokenPaid[account] = rewardPerTokenStored;
611         }
612         _;
613     }
614 
615     function setBeneficial(address _beneficial) onlyOwner external {
616         require(_beneficial != address(this), "setBeneficial: can not send to self");
617         require(_beneficial != address(0), "setBeneficial: can not burn tokens");
618         beneficial = _beneficial;
619     }
620 
621     /// Capture BAL tokens or any other tokens
622     function capture(address _token, uint amount) onlyOwner external {
623         require(_token != address(_token0), "capture: can not capture staking tokens");
624         require(_token != address(_token1), "capture: can not capture reward tokens");
625         require(beneficial != address(this), "capture: can not send to self");
626         require(beneficial != address(0), "capture: can not burn tokens");
627         IERC20(_token).safeTransfer(beneficial, amount);
628     }  
629 
630     function lastTimeRewardApplicable() public view returns (uint) {
631         return Math.min(block.timestamp, periodFinish);
632     }
633 
634     function rewardPerToken() public view returns (uint) {
635         if (getTotalStakes() == 0) {
636             return rewardPerTokenStored;
637         }
638         return
639             rewardPerTokenStored.add(
640                 lastTimeRewardApplicable()
641                     .sub(lastUpdateTime)
642                     .mul(rewardRate)
643                     .mul(1e18)
644                     .div(getTotalStakes())
645             );
646     }
647 
648     function earned(address account) public view returns (uint) {
649         return
650             balanceOf(account)
651                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
652                 .div(1e18)
653                 .add(rewards[account]);
654     }
655 
656     /// setup the staking round
657     function setRewardRound(uint round, uint reward, uint start, uint end) 
658         external
659         onlyOwner    
660     {
661         require(block.timestamp > periodFinish, "setRewardRound: previous rewards period not complete");
662         require(rewardRounds < round, "setRewardRound: this round completed");
663 
664         rewardRounds = round;
665         _rewards = reward;
666         _start = start;
667         _end = end;
668         rewardsDuration = _end.sub(_start);
669 
670         inStaking = false;
671     }
672 
673     /// launch the staking round
674     function notifyRewards()
675         external
676         onlyOwner
677         updateReward(address(0))
678     {
679         // staking started
680         if (inStaking == true) {
681             return;
682         }
683 
684         if (block.timestamp >= periodFinish) {
685             rewardRate = _rewards.div(rewardsDuration);
686         } else {
687             uint remaining = periodFinish.sub(block.timestamp);
688             uint leftover = remaining.mul(rewardRate);
689             rewardRate = _rewards.add(leftover).div(rewardsDuration);
690             _remainingRewards = leftover;
691         }
692 
693         // Ensure the provided reward amount is not more than the balance in the contract.
694         // This keeps the reward rate in the right range, preventing overflows due to
695         // very high values of rewardRate in the earned and rewardsPerToken functions;
696         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
697         uint balance = _token1.balanceOf(address(this));
698         require(rewardRate <= balance.div(rewardsDuration), "notifyRewards: provided reward too high");
699 
700         inStaking = true;
701         lastUpdateTime = block.timestamp;
702         periodFinish = block.timestamp.add(rewardsDuration);
703         emit RewardAdded(_rewards);
704     }
705 
706     function addStakeholder(address _stakeholder) internal {
707         stakeHolders[_stakeholder] = true;
708     }
709 
710     function removeStakeholder(address _stakeholder) internal {
711         stakeHolders[_stakeholder] = false;
712     }
713 
714     /// Deposit staking tokens
715     function deposit(uint amount) 
716         external 
717         nonReentrant
718         whenNotPaused 
719         notFrozen(msg.sender) 
720         updateReward(msg.sender)
721     {
722         require(amount > 0, "deposit: cannot stake 0");
723         require(msg.sender != address(0), "withdraw: zero address");
724         require(_token0.balanceOf(msg.sender) >= amount, "deposit: insufficient balance");
725         _totalSupply = _totalSupply.add(amount);          
726         _balances[msg.sender] = _balances[msg.sender].add(amount);
727         addStakeholder(msg.sender);
728         _token0.safeTransferFrom(msg.sender, address(this), amount);
729         emit TokenDeposit(msg.sender, amount);
730     }
731 
732     /// Withdraw staked tokens
733     function withdraw(uint amount) 
734         external 
735         nonReentrant
736         whenNotPaused 
737         notFrozen(msg.sender) 
738         updateReward(msg.sender)
739     {
740         require(amount > 0, "withdraw: amount invalid");
741         require(msg.sender != address(0), "withdraw: zero address");
742         /// Not overflow
743         require(_balances[msg.sender] >= amount);
744         _totalSupply = _totalSupply.sub(amount);                
745         _balances[msg.sender] = _balances[msg.sender].sub(amount);
746         /// Keep track user withdraws
747         withdrawalOf[msg.sender] = withdrawalOf[msg.sender].add(amount);  
748         if (_balances[msg.sender] == 0) {
749             removeStakeholder(msg.sender);   
750         }
751         _token0.safeTransfer(msg.sender, amount);
752         emit TokenWithdraw(msg.sender, amount);
753     }
754 
755     /// Claim reward tokens
756     function claim() 
757         external 
758         nonReentrant
759         whenNotPaused 
760         notFrozen(msg.sender) 
761         updateReward(msg.sender)
762     {
763         require(msg.sender != address(0), "claim: zero address");        
764         require(block.timestamp > getEndTimestamp(), "claim: claim not open");   
765         require(block.timestamp > periodFinish, "claim: current staking period not complete");
766 
767         uint reward = earned(msg.sender);
768         /// Not overflow        
769         require(_token1.balanceOf(address(this)) >= reward, "claim: insufficient balance");        
770         require(reward > 0, "claim: zero rewards");                
771 
772         rewards[msg.sender] = 0;
773         claimOf[msg.sender] = reward;
774         _token1.safeTransfer(msg.sender, reward);
775         emit TokenClaim(msg.sender, reward);
776     }
777 
778     function freezeAccount(address account) external onlyOwner returns (bool) {
779         require(!frozenAccount[account], "ERC20: account frozen");
780         frozenAccount[account] = true;
781         emit Freeze(account);
782         return true;
783     }
784 
785     function unfreezeAccount(address account) external onlyOwner returns (bool) {
786         require(frozenAccount[account], "ERC20: account not frozen");
787         frozenAccount[account] = false;
788         emit Unfreeze(account);
789         return true;
790     }
791 
792     function getWithdrawalOf(address _stakeholder) external view returns (uint) {
793         return withdrawalOf[_stakeholder];
794     }
795 
796     function getClaimOf(address _stakeholder) external view returns (uint) {
797         return claimOf[_stakeholder];
798     }
799 
800     /// Get remaining rewards of the time period
801     function remainingRewards() external view returns(uint) {
802         return _remainingRewards;
803     }
804 
805     /// Retrieve the stake for a stakeholder
806     function stakeOf(address _stakeholder) external view returns (uint) {
807         return _balances[_stakeholder];
808     }
809 
810     /// Retrieve the stake for a stakeholder
811     function rewardOf(address _stakeholder) external view returns (uint) {
812         return earned(_stakeholder);
813     }
814 
815     /// Get total original rewards
816     function totalRewards() external view returns (uint) {
817         return _rewards;
818     }  
819 
820     function getStartTimestamp() public view returns (uint) {
821         return _start;
822     }
823 
824     function getEndTimestamp() public view returns (uint) {
825         return _end;
826     }
827 
828     /// The total supply of all staked tokens
829     function getTotalStakes() public view returns (uint) {
830         return _totalSupply;
831     }
832 
833     function balanceOf(address account) public view returns (uint) {
834         return _balances[account];
835     }    
836 }