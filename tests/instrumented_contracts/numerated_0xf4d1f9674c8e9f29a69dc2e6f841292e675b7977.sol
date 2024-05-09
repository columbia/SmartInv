1 pragma solidity 0.5.17;
2 
3 /**
4  * @dev Standard math utilities missing in the Solidity language.
5  */
6 library Math {
7     /**
8      * @dev Returns the largest of two numbers.
9      */
10     function max(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a >= b ? a : b;
12     }
13 
14     /**
15      * @dev Returns the smallest of two numbers.
16      */
17     function min(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a < b ? a : b;
19     }
20 
21     /**
22      * @dev Returns the average of two numbers. The result is rounded towards
23      * zero.
24      */
25     function average(uint256 a, uint256 b) internal pure returns (uint256) {
26         // (a + b) / 2 can overflow, so we distribute
27         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
28     }
29 }
30 
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations with added overflow
33  * checks.
34  *
35  * Arithmetic operations in Solidity wrap on overflow. This can easily result
36  * in bugs, because programmers usually assume that an overflow raises an
37  * error, which is the standard behavior in high level programming languages.
38  * `SafeMath` restores this intuition by reverting the transaction when an
39  * operation overflows.
40  *
41  * Using this library instead of the unchecked operations eliminates an entire
42  * class of bugs, so it's recommended to use it always.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      * - Addition cannot overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      * - Subtraction cannot overflow.
69      */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         return sub(a, b, "SafeMath: subtraction overflow");
72     }
73 
74     /**
75      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
76      * overflow (when the result is negative).
77      *
78      * Counterpart to Solidity's `-` operator.
79      *
80      * Requirements:
81      * - Subtraction cannot overflow.
82      *
83      * _Available since v2.4.0._
84      */
85     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b <= a, errorMessage);
87         uint256 c = a - b;
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the multiplication of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `*` operator.
97      *
98      * Requirements:
99      * - Multiplication cannot overflow.
100      */
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
103         // benefit is lost if 'b' is also tested.
104         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
105         if (a == 0) {
106             return 0;
107         }
108 
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers. Reverts on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator. Note: this function uses a
120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
121      * uses an invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         return div(a, b, "SafeMath: division by zero");
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator. Note: this function uses a
135      * `revert` opcode (which leaves remaining gas untouched) while Solidity
136      * uses an invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      * - The divisor cannot be zero.
140      *
141      * _Available since v2.4.0._
142      */
143     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         // Solidity only automatically asserts when dividing by 0
145         require(b > 0, errorMessage);
146         uint256 c = a / b;
147         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
154      * Reverts when dividing by zero.
155      *
156      * Counterpart to Solidity's `%` operator. This function uses a `revert`
157      * opcode (which leaves remaining gas untouched) while Solidity uses an
158      * invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      * - The divisor cannot be zero.
162      */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         return mod(a, b, "SafeMath: modulo by zero");
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts with custom message when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      *
178      * _Available since v2.4.0._
179      */
180     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b != 0, errorMessage);
182         return a % b;
183     }
184 }
185 
186 /*
187  * @dev Provides information about the current execution context, including the
188  * sender of the transaction and its data. While these are generally available
189  * via msg.sender and msg.data, they should not be accessed in such a direct
190  * manner, since when dealing with GSN meta-transactions the account sending and
191  * paying for execution may not be the actual sender (as far as an application
192  * is concerned).
193  *
194  * This contract is only required for intermediate, library-like contracts.
195  */
196 contract Context {
197     // Empty internal constructor, to prevent people from mistakenly deploying
198     // an instance of this contract, which should be used via inheritance.
199     constructor () internal { }
200     // solhint-disable-previous-line no-empty-blocks
201 
202     function _msgSender() internal view returns (address payable) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view returns (bytes memory) {
207         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
208         return msg.data;
209     }
210 }
211 
212 /**
213  * @dev Contract module which provides a basic access control mechanism, where
214  * there is an account (an owner) that can be granted exclusive access to
215  * specific functions.
216  *
217  * This module is used through inheritance. It will make available the modifier
218  * `onlyOwner`, which can be applied to your functions to restrict their use to
219  * the owner.
220  */
221 contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor () internal {
230         _owner = _msgSender();
231         emit OwnershipTransferred(address(0), _owner);
232     }
233 
234     /**
235      * @dev Returns the address of the current owner.
236      */
237     function owner() public view returns (address) {
238         return _owner;
239     }
240 
241     /**
242      * @dev Throws if called by any account other than the owner.
243      */
244     modifier onlyOwner() {
245         require(isOwner(), "Ownable: caller is not the owner");
246         _;
247     }
248 
249     /**
250      * @dev Returns true if the caller is the current owner.
251      */
252     function isOwner() public view returns (bool) {
253         return _msgSender() == _owner;
254     }
255 
256     /**
257      * @dev Leaves the contract without owner. It will not be possible to call
258      * `onlyOwner` functions anymore. Can only be called by the current owner.
259      *
260      * NOTE: Renouncing ownership will leave the contract without an owner,
261      * thereby removing any functionality that is only available to the owner.
262      */
263     function renounceOwnership() public onlyOwner {
264         emit OwnershipTransferred(_owner, address(0));
265         _owner = address(0);
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Can only be called by the current owner.
271      */
272     function transferOwnership(address newOwner) public onlyOwner {
273         _transferOwnership(newOwner);
274     }
275 
276     /**
277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
278      */
279     function _transferOwnership(address newOwner) internal {
280         require(newOwner != address(0), "Ownable: new owner is the zero address");
281         emit OwnershipTransferred(_owner, newOwner);
282         _owner = newOwner;
283     }
284 }
285 
286 /**
287  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
288  * the optional functions; to access them see {ERC20Detailed}.
289  */
290 interface IERC20 {
291     /**
292      * @dev Returns the amount of tokens in existence.
293      */
294     function totalSupply() external view returns (uint256);
295 
296     /**
297      * @dev Returns the amount of tokens owned by `account`.
298      */
299     function balanceOf(address account) external view returns (uint256);
300 
301     /**
302      * @dev Moves `amount` tokens from the caller's account to `recipient`.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transfer(address recipient, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Returns the remaining number of tokens that `spender` will be
312      * allowed to spend on behalf of `owner` through {transferFrom}. This is
313      * zero by default.
314      *
315      * This value changes when {approve} or {transferFrom} are called.
316      */
317     function allowance(address owner, address spender) external view returns (uint256);
318 
319     /**
320      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * IMPORTANT: Beware that changing an allowance with this method brings the risk
325      * that someone may use both the old and the new allowance by unfortunate
326      * transaction ordering. One possible solution to mitigate this race
327      * condition is to first reduce the spender's allowance to 0 and set the
328      * desired value afterwards:
329      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
330      *
331      * Emits an {Approval} event.
332      */
333     function approve(address spender, uint256 amount) external returns (bool);
334 
335     /**
336      * @dev Moves `amount` tokens from `sender` to `recipient` using the
337      * allowance mechanism. `amount` is then deducted from the caller's
338      * allowance.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * Emits a {Transfer} event.
343      */
344     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
345 
346     /**
347      * @dev Emitted when `value` tokens are moved from one account (`from`) to
348      * another (`to`).
349      *
350      * Note that `value` may be zero.
351      */
352     event Transfer(address indexed from, address indexed to, uint256 value);
353 
354     /**
355      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
356      * a call to {approve}. `value` is the new allowance.
357      */
358     event Approval(address indexed owner, address indexed spender, uint256 value);
359 }
360 
361 /**
362  * @dev Collection of functions related to the address type
363  */
364 library Address {
365     /**
366      * @dev Returns true if `account` is a contract.
367      *
368      * This test is non-exhaustive, and there may be false-negatives: during the
369      * execution of a contract's constructor, its address will be reported as
370      * not containing a contract.
371      *
372      * IMPORTANT: It is unsafe to assume that an address for which this
373      * function returns false is an externally-owned account (EOA) and not a
374      * contract.
375      */
376     function isContract(address account) internal view returns (bool) {
377         // This method relies in extcodesize, which returns 0 for contracts in
378         // construction, since the code is only stored at the end of the
379         // constructor execution.
380 
381         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
382         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
383         // for accounts without code, i.e. `keccak256('')`
384         bytes32 codehash;
385         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
386         // solhint-disable-next-line no-inline-assembly
387         assembly { codehash := extcodehash(account) }
388         return (codehash != 0x0 && codehash != accountHash);
389     }
390 
391     /**
392      * @dev Converts an `address` into `address payable`. Note that this is
393      * simply a type cast: the actual underlying value is not changed.
394      *
395      * _Available since v2.4.0._
396      */
397     function toPayable(address account) internal pure returns (address payable) {
398         return address(uint160(account));
399     }
400 
401     /**
402      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
403      * `recipient`, forwarding all available gas and reverting on errors.
404      *
405      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
406      * of certain opcodes, possibly making contracts go over the 2300 gas limit
407      * imposed by `transfer`, making them unable to receive funds via
408      * `transfer`. {sendValue} removes this limitation.
409      *
410      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
411      *
412      * IMPORTANT: because control is transferred to `recipient`, care must be
413      * taken to not create reentrancy vulnerabilities. Consider using
414      * {ReentrancyGuard} or the
415      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
416      *
417      * _Available since v2.4.0._
418      */
419     function sendValue(address payable recipient, uint256 amount) internal {
420         require(address(this).balance >= amount, "Address: insufficient balance");
421 
422         // solhint-disable-next-line avoid-call-value
423         (bool success, ) = recipient.call.value(amount)("");
424         require(success, "Address: unable to send value, recipient may have reverted");
425     }
426 }
427 
428 /**
429  * @title SafeERC20
430  * @dev Wrappers around ERC20 operations that throw on failure (when the token
431  * contract returns false). Tokens that return no value (and instead revert or
432  * throw on failure) are also supported, non-reverting calls are assumed to be
433  * successful.
434  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
435  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
436  */
437 library SafeERC20 {
438     using SafeMath for uint256;
439     using Address for address;
440 
441     function safeTransfer(IERC20 token, address to, uint256 value) internal {
442         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
443     }
444 
445     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
446         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
447     }
448 
449     function safeApprove(IERC20 token, address spender, uint256 value) internal {
450         // safeApprove should only be called when setting an initial allowance,
451         // or when resetting it to zero. To increase and decrease it, use
452         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
453         // solhint-disable-next-line max-line-length
454         require((value == 0) || (token.allowance(address(this), spender) == 0),
455             "SafeERC20: approve from non-zero to non-zero allowance"
456         );
457         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
458     }
459 
460     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).add(value);
462         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
467         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     /**
471      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
472      * on the return value: the return value is optional (but if data is returned, it must not be false).
473      * @param token The token targeted by the call.
474      * @param data The call data (encoded using abi.encode or one of its variants).
475      */
476     function callOptionalReturn(IERC20 token, bytes memory data) private {
477         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
478         // we're implementing it ourselves.
479 
480         // A Solidity high level call has three parts:
481         //  1. The target address is checked to verify it contains contract code
482         //  2. The call itself is made, and success asserted
483         //  3. The return value is decoded, which in turn checks the size of the returned data.
484         // solhint-disable-next-line max-line-length
485         require(address(token).isContract(), "SafeERC20: call to non-contract");
486 
487         // solhint-disable-next-line avoid-low-level-calls
488         (bool success, bytes memory returndata) = address(token).call(data);
489         require(success, "SafeERC20: low-level call failed");
490 
491         if (returndata.length > 0) { // Return data is optional
492             // solhint-disable-next-line max-line-length
493             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
494         }
495     }
496 }
497 
498 contract IRewardDistributionRecipient is Ownable {
499     address rewardDistribution;
500 
501     function notifyRewardAmount(uint256 reward) external;
502 
503     modifier onlyRewardDistribution() {
504         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
505         _;
506     }
507 
508     function setRewardDistribution(address _rewardDistribution)
509         external
510         onlyOwner
511     {
512         rewardDistribution = _rewardDistribution;
513     }
514 }
515 
516 contract LPTokenWrapper {
517     using SafeMath for uint256;
518     using SafeERC20 for IERC20;
519 
520     IERC20 public stakeToken;
521 
522     uint256 private _totalSupply;
523     mapping(address => uint256) private _balances;
524 
525     function totalSupply() public view returns (uint256) {
526         return _totalSupply;
527     }
528 
529     function balanceOf(address account) public view returns (uint256) {
530         return _balances[account];
531     }
532 
533     function stake(uint256 amount) public {
534         _totalSupply = _totalSupply.add(amount);
535         _balances[msg.sender] = _balances[msg.sender].add(amount);
536         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
537     }
538 
539     function stakeFor(address to, uint256 amount) public {
540         _totalSupply = _totalSupply.add(amount);
541         _balances[to] = _balances[to].add(amount);
542         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
543     }
544 
545     function withdraw(uint256 amount) public {
546         _totalSupply = _totalSupply.sub(amount);
547         _balances[msg.sender] = _balances[msg.sender].sub(amount);
548         stakeToken.safeTransfer(msg.sender, amount);
549     }
550 }
551 
552 contract HakkaRewardsVesting is LPTokenWrapper, IRewardDistributionRecipient {
553     IERC20 public constant hakka = IERC20(0x0E29e5AbbB5FD88e28b2d355774e73BD47dE3bcd);
554     VestingVault public constant vault = VestingVault(0x51F12323820b3c0077864990d9E6aD9604238Ed6);
555     uint256 public constant DURATION = 30 days;
556 
557     uint256 public periodFinish = 0;
558     uint256 public rewardRate = 0;
559     uint256 public lastUpdateTime;
560     uint256 public rewardPerTokenStored;
561     mapping(address => uint256) public userRewardPerTokenPaid;
562     mapping(address => uint256) public rewards;
563 
564     event RewardAdded(uint256 reward);
565     event Staked(address indexed user, uint256 amount);
566     event Withdrawn(address indexed user, uint256 amount);
567     event RewardPaid(address indexed user, uint256 reward);
568 
569     modifier updateReward(address account) {
570         rewardPerTokenStored = rewardPerToken();
571         lastUpdateTime = lastTimeRewardApplicable();
572         if (account != address(0)) {
573             rewards[account] = earned(account);
574             userRewardPerTokenPaid[account] = rewardPerTokenStored;
575         }
576         _;
577     }
578 
579     constructor(IERC20 _stakeToken) public {
580         stakeToken = _stakeToken;
581         hakka.safeApprove(address(vault), uint256(-1));
582     }
583 
584     function lastTimeRewardApplicable() public view returns (uint256) {
585         return Math.min(block.timestamp, periodFinish);
586     }
587 
588     function rewardPerToken() public view returns (uint256) {
589         if (totalSupply() == 0) {
590             return rewardPerTokenStored;
591         }
592         return
593             rewardPerTokenStored.add(
594                 lastTimeRewardApplicable()
595                     .sub(lastUpdateTime)
596                     .mul(rewardRate)
597                     .mul(1e18)
598                     .div(totalSupply())
599             );
600     }
601 
602     function earned(address account) public view returns (uint256) {
603         return
604             balanceOf(account)
605                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
606                 .div(1e18)
607                 .add(rewards[account]);
608     }
609 
610     // stake visibility is public as overriding LPTokenWrapper's stake() function
611     function stake(uint256 amount) public updateReward(msg.sender) {
612         require(amount > 0, "Cannot stake 0");
613         super.stake(amount);
614         emit Staked(msg.sender, amount);
615     }
616 
617     function stakeFor(address to, uint256 amount) public updateReward(to) {
618         require(amount > 0, "Cannot stake 0");
619         super.stakeFor(to, amount);
620         emit Staked(to, amount);
621     }
622 
623     function withdraw(uint256 amount) public updateReward(msg.sender) {
624         require(amount > 0, "Cannot withdraw 0");
625         super.withdraw(amount);
626         emit Withdrawn(msg.sender, amount);
627     }
628 
629     function exit() external {
630         withdraw(balanceOf(msg.sender));
631         getReward();
632     }
633 
634     function getReward() public updateReward(msg.sender) {
635         uint256 reward = rewards[msg.sender];
636         if (reward > 0) {
637             rewards[msg.sender] = 0;
638             vault.deposit(msg.sender, reward);
639             emit RewardPaid(msg.sender, reward);
640         }
641     }
642 
643     function notifyRewardAmount(uint256 reward)
644         external
645         onlyRewardDistribution
646         updateReward(address(0))
647     {
648         if (block.timestamp >= periodFinish) {
649             rewardRate = reward.div(DURATION);
650         } else {
651             uint256 remaining = periodFinish.sub(block.timestamp);
652             uint256 leftover = remaining.mul(rewardRate);
653             rewardRate = reward.add(leftover).div(DURATION);
654         }
655         require(rewardRate < 1e36, "Too much reward"); //token per second < 1e18
656         lastUpdateTime = block.timestamp;
657         periodFinish = block.timestamp.add(DURATION);
658         emit RewardAdded(reward);
659     }
660 
661     // incase of airdrop token
662     function inCaseTokenGetsStuckPartial(IERC20 _TokenAddress, uint256 _amount) onlyOwner public {
663         require(_TokenAddress != hakka && _TokenAddress != stakeToken);
664         _TokenAddress.safeTransfer(msg.sender, _amount);
665     }
666 
667 }
668 
669 contract VestingVault {
670     function deposit(address to, uint256 amount) external;
671 }