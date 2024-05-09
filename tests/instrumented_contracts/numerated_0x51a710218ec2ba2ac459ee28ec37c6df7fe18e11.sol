1 pragma solidity ^0.5.17;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(isOwner(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Returns true if the caller is the current owner.
69      */
70     function isOwner() public view returns (bool) {
71         return _msgSender() == _owner;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public onlyOwner {
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      */
97     function _transferOwnership(address newOwner) internal {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 /**
105  * @dev Standard math utilities missing in the Solidity language.
106  */
107 library Math {
108     /**
109      * @dev Returns the largest of two numbers.
110      */
111     function max(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a >= b ? a : b;
113     }
114 
115     /**
116      * @dev Returns the smallest of two numbers.
117      */
118     function min(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a < b ? a : b;
120     }
121 
122     /**
123      * @dev Returns the average of two numbers. The result is rounded towards
124      * zero.
125      */
126     function average(uint256 a, uint256 b) internal pure returns (uint256) {
127         // (a + b) / 2 can overflow, so we distribute
128         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
129     }
130 }
131 
132 /**
133  * @dev Wrappers over Solidity's arithmetic operations with added overflow
134  * checks.
135  *
136  * Arithmetic operations in Solidity wrap on overflow. This can easily result
137  * in bugs, because programmers usually assume that an overflow raises an
138  * error, which is the standard behavior in high level programming languages.
139  * `SafeMath` restores this intuition by reverting the transaction when an
140  * operation overflows.
141  *
142  * Using this library instead of the unchecked operations eliminates an entire
143  * class of bugs, so it's recommended to use it always.
144  */
145 library SafeMath {
146     /**
147      * @dev Returns the addition of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `+` operator.
151      *
152      * Requirements:
153      * - Addition cannot overflow.
154      */
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         uint256 c = a + b;
157         require(c >= a, "SafeMath: addition overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172         return sub(a, b, "SafeMath: subtraction overflow");
173     }
174 
175     /**
176      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
177      * overflow (when the result is negative).
178      *
179      * Counterpart to Solidity's `-` operator.
180      *
181      * Requirements:
182      * - Subtraction cannot overflow.
183      *
184      * _Available since v2.4.0._
185      */
186     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b <= a, errorMessage);
188         uint256 c = a - b;
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the multiplication of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `*` operator.
198      *
199      * Requirements:
200      * - Multiplication cannot overflow.
201      */
202     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
204         // benefit is lost if 'b' is also tested.
205         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
206         if (a == 0) {
207             return 0;
208         }
209 
210         uint256 c = a * b;
211         require(c / a == b, "SafeMath: multiplication overflow");
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b) internal pure returns (uint256) {
228         return div(a, b, "SafeMath: division by zero");
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      *
242      * _Available since v2.4.0._
243      */
244     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         // Solidity only automatically asserts when dividing by 0
246         require(b > 0, errorMessage);
247         uint256 c = a / b;
248         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
249 
250         return c;
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         return mod(a, b, "SafeMath: modulo by zero");
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * Reverts with custom message when dividing by zero.
271      *
272      * Counterpart to Solidity's `%` operator. This function uses a `revert`
273      * opcode (which leaves remaining gas untouched) while Solidity uses an
274      * invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      * - The divisor cannot be zero.
278      *
279      * _Available since v2.4.0._
280      */
281     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b != 0, errorMessage);
283         return a % b;
284     }
285 }
286 
287 /**
288  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
289  * the optional functions; to access them see {ERC20Detailed}.
290  */
291 interface IERC20 {
292     /**
293      * @dev Returns the amount of tokens in existence.
294      */
295     function totalSupply() external view returns (uint256);
296 
297     /**
298      * @dev Returns the amount of tokens owned by `account`.
299      */
300     function balanceOf(address account) external view returns (uint256);
301 
302     /**
303      * @dev Moves `amount` tokens from the caller's account to `recipient`.
304      *
305      * Returns a boolean value indicating whether the operation succeeded.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transfer(address recipient, uint256 amount) external returns (bool);
310 
311     /**
312      * @dev Returns the remaining number of tokens that `spender` will be
313      * allowed to spend on behalf of `owner` through {transferFrom}. This is
314      * zero by default.
315      *
316      * This value changes when {approve} or {transferFrom} are called.
317      */
318     function allowance(address owner, address spender) external view returns (uint256);
319 
320     /**
321      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * IMPORTANT: Beware that changing an allowance with this method brings the risk
326      * that someone may use both the old and the new allowance by unfortunate
327      * transaction ordering. One possible solution to mitigate this race
328      * condition is to first reduce the spender's allowance to 0 and set the
329      * desired value afterwards:
330      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
331      *
332      * Emits an {Approval} event.
333      */
334     function approve(address spender, uint256 amount) external returns (bool);
335 
336     /**
337      * @dev Moves `amount` tokens from `sender` to `recipient` using the
338      * allowance mechanism. `amount` is then deducted from the caller's
339      * allowance.
340      *
341      * Returns a boolean value indicating whether the operation succeeded.
342      *
343      * Emits a {Transfer} event.
344      */
345     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
346 
347     /**
348      * @dev Emitted when `value` tokens are moved from one account (`from`) to
349      * another (`to`).
350      *
351      * Note that `value` may be zero.
352      */
353     event Transfer(address indexed from, address indexed to, uint256 value);
354 
355     /**
356      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
357      * a call to {approve}. `value` is the new allowance.
358      */
359     event Approval(address indexed owner, address indexed spender, uint256 value);
360 }
361 
362 /**
363  * @dev Collection of functions related to the address type
364  */
365 library Address {
366     /**
367      * @dev Returns true if `account` is a contract.
368      *
369      * [IMPORTANT]
370      * ====
371      * It is unsafe to assume that an address for which this function returns
372      * false is an externally-owned account (EOA) and not a contract.
373      *
374      * Among others, `isContract` will return false for the following
375      * types of addresses:
376      *
377      *  - an externally-owned account
378      *  - a contract in construction
379      *  - an address where a contract will be created
380      *  - an address where a contract lived, but was destroyed
381      * ====
382      */
383     function isContract(address account) internal view returns (bool) {
384         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
385         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
386         // for accounts without code, i.e. `keccak256('')`
387         bytes32 codehash;
388         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
389         // solhint-disable-next-line no-inline-assembly
390         assembly { codehash := extcodehash(account) }
391         return (codehash != accountHash && codehash != 0x0);
392     }
393 
394     /**
395      * @dev Converts an `address` into `address payable`. Note that this is
396      * simply a type cast: the actual underlying value is not changed.
397      *
398      * _Available since v2.4.0._
399      */
400     function toPayable(address account) internal pure returns (address payable) {
401         return address(uint160(account));
402     }
403 
404     /**
405      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
406      * `recipient`, forwarding all available gas and reverting on errors.
407      *
408      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
409      * of certain opcodes, possibly making contracts go over the 2300 gas limit
410      * imposed by `transfer`, making them unable to receive funds via
411      * `transfer`. {sendValue} removes this limitation.
412      *
413      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
414      *
415      * IMPORTANT: because control is transferred to `recipient`, care must be
416      * taken to not create reentrancy vulnerabilities. Consider using
417      * {ReentrancyGuard} or the
418      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
419      *
420      * _Available since v2.4.0._
421      */
422     function sendValue(address payable recipient, uint256 amount) internal {
423         require(address(this).balance >= amount, "Address: insufficient balance");
424 
425         // solhint-disable-next-line avoid-call-value
426         (bool success, ) = recipient.call.value(amount)("");
427         require(success, "Address: unable to send value, recipient may have reverted");
428     }
429 }
430 
431 /**
432  * @title SafeERC20
433  * @dev Wrappers around ERC20 operations that throw on failure (when the token
434  * contract returns false). Tokens that return no value (and instead revert or
435  * throw on failure) are also supported, non-reverting calls are assumed to be
436  * successful.
437  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
438  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
439  */
440 library SafeERC20 {
441     using SafeMath for uint256;
442     using Address for address;
443 
444     function safeTransfer(IERC20 token, address to, uint256 value) internal {
445         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
446     }
447 
448     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
449         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
450     }
451 
452     function safeApprove(IERC20 token, address spender, uint256 value) internal {
453         // safeApprove should only be called when setting an initial allowance,
454         // or when resetting it to zero. To increase and decrease it, use
455         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
456         // solhint-disable-next-line max-line-length
457         require((value == 0) || (token.allowance(address(this), spender) == 0),
458             "SafeERC20: approve from non-zero to non-zero allowance"
459         );
460         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
461     }
462 
463     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
464         uint256 newAllowance = token.allowance(address(this), spender).add(value);
465         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
466     }
467 
468     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
469         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
470         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
471     }
472 
473     /**
474      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
475      * on the return value: the return value is optional (but if data is returned, it must not be false).
476      * @param token The token targeted by the call.
477      * @param data The call data (encoded using abi.encode or one of its variants).
478      */
479     function callOptionalReturn(IERC20 token, bytes memory data) private {
480         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
481         // we're implementing it ourselves.
482 
483         // A Solidity high level call has three parts:
484         //  1. The target address is checked to verify it contains contract code
485         //  2. The call itself is made, and success asserted
486         //  3. The return value is decoded, which in turn checks the size of the returned data.
487         // solhint-disable-next-line max-line-length
488         require(address(token).isContract(), "SafeERC20: call to non-contract");
489 
490         // solhint-disable-next-line avoid-low-level-calls
491         (bool success, bytes memory returndata) = address(token).call(data);
492         require(success, "SafeERC20: low-level call failed");
493 
494         if (returndata.length > 0) { // Return data is optional
495             // solhint-disable-next-line max-line-length
496             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
497         }
498     }
499 }
500 
501 /**
502  * @dev Contract module that helps prevent reentrant calls to a function.
503  *
504  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
505  * available, which can be applied to functions to make sure there are no nested
506  * (reentrant) calls to them.
507  *
508  * Note that because there is a single `nonReentrant` guard, functions marked as
509  * `nonReentrant` may not call one another. This can be worked around by making
510  * those functions `private`, and then adding `external` `nonReentrant` entry
511  * points to them.
512  *
513  * TIP: If you would like to learn more about reentrancy and alternative ways
514  * to protect against it, check out our blog post
515  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
516  *
517  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
518  * metering changes introduced in the Istanbul hardfork.
519  */
520 contract ReentrancyGuard {
521     bool private _notEntered;
522 
523     constructor () internal {
524         // Storing an initial non-zero value makes deployment a bit more
525         // expensive, but in exchange the refund on every call to nonReentrant
526         // will be lower in amount. Since refunds are capped to a percetange of
527         // the total transaction's gas, it is best to keep them low in cases
528         // like this one, to increase the likelihood of the full refund coming
529         // into effect.
530         _notEntered = true;
531     }
532 
533     /**
534      * @dev Prevents a contract from calling itself, directly or indirectly.
535      * Calling a `nonReentrant` function from another `nonReentrant`
536      * function is not supported. It is possible to prevent this from happening
537      * by making the `nonReentrant` function external, and make it call a
538      * `private` function that does the actual work.
539      */
540     modifier nonReentrant() {
541         // On the first call to nonReentrant, _notEntered will be true
542         require(_notEntered, "ReentrancyGuard: reentrant call");
543 
544         // Any calls to nonReentrant after this point will fail
545         _notEntered = false;
546 
547         _;
548 
549         // By storing the original value once again, a refund is triggered (see
550         // https://eips.ethereum.org/EIPS/eip-2200)
551         _notEntered = true;
552     }
553 }
554 
555 contract StakingRewardsWbtc is Ownable, ReentrancyGuard {
556     using SafeMath for uint256;
557     using SafeERC20 for IERC20;
558 
559     /* ========== STATE VARIABLES ========== */
560 
561     address public rewardsDistribution;
562     IERC20 public rewardsToken;
563     IERC20 public stakingToken;
564     uint256 public periodFinish;
565     uint256 public rewardRate;
566     uint256 public rewardsDuration;
567     uint256 public lastUpdateTime;
568     uint256 public rewardPerTokenStored;
569 
570     mapping(address => uint256) public userRewardPerTokenPaid;
571     mapping(address => uint256) public rewards;
572 
573     uint256 private _totalSupply;
574     mapping(address => uint256) private _balances;
575 
576     /* ========== CONSTRUCTOR ========== */
577 
578     constructor(
579         address _rewardsDistribution,
580         address _rewardsToken,
581         address _stakingToken
582     ) Ownable() public {
583         rewardsToken = IERC20(_rewardsToken);
584         stakingToken = IERC20(_stakingToken);
585         rewardsDistribution = _rewardsDistribution;
586     }
587 
588     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
589         require(_rewardsDistribution != address(0), "_rewardsDistribution is the zero address");
590         rewardsDistribution = _rewardsDistribution;
591     }
592 
593     /* ========== VIEWS ========== */
594 
595     function totalSupply() external view returns (uint256) {
596         return _totalSupply;
597     }
598 
599     function balanceOf(address account) external view returns (uint256) {
600         return _balances[account];
601     }
602 
603     function lastTimeRewardApplicable() public view returns (uint256) {
604         return Math.min(block.timestamp, periodFinish);
605     }
606 
607     function rewardPerToken() public view returns (uint256) {
608         if (_totalSupply == 0) {
609             return rewardPerTokenStored;
610         }
611         return
612         rewardPerTokenStored.add(
613             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
614         );
615     }
616 
617     function earned(address account) external view returns (uint256) {
618         uint256 amount = _earned(account);
619         return weiToSatoshi(amount);
620     }
621 
622     function _earned(address account) internal view returns (uint256) {
623         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
624     }
625 
626     function getRewardForDuration() external view returns (uint256) {
627         return rewardRate.mul(rewardsDuration);
628     }
629 
630     function weiToSatoshi(uint256 amount) public pure returns (uint256) {
631         return amount.div(10**10);
632     }
633 
634     function satoshiToWei(uint256 amount) public pure returns (uint256) {
635         return amount.mul(10**10);
636     }
637 
638     /* ========== MUTATIVE FUNCTIONS ========== */
639 
640     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
641         require(amount > 0, "Cannot stake 0");
642         _totalSupply = _totalSupply.add(amount);
643         _balances[msg.sender] = _balances[msg.sender].add(amount);
644 
645         // permit
646         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
647 
648         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
649         emit Staked(msg.sender, amount);
650     }
651 
652     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
653         require(amount > 0, "Cannot stake 0");
654         _totalSupply = _totalSupply.add(amount);
655         _balances[msg.sender] = _balances[msg.sender].add(amount);
656         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
657         emit Staked(msg.sender, amount);
658     }
659 
660     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
661         require(amount > 0, "Cannot withdraw 0");
662         _totalSupply = _totalSupply.sub(amount);
663         _balances[msg.sender] = _balances[msg.sender].sub(amount);
664         stakingToken.safeTransfer(msg.sender, amount);
665         emit Withdrawn(msg.sender, amount);
666     }
667 
668     function getReward() public nonReentrant updateReward(msg.sender) {
669         uint256 reward = rewards[msg.sender];
670         if (reward > 0) {
671             rewards[msg.sender] = 0;
672             reward = weiToSatoshi(reward);
673             if (reward > 0) {
674                 rewardsToken.safeTransfer(msg.sender, reward);
675             }
676             emit RewardPaid(msg.sender, reward);
677         }
678     }
679 
680     function exit() external {
681         withdraw(_balances[msg.sender]);
682         getReward();
683     }
684 
685     function inCaseTokensGetStuck(address _token, uint256 _amount) external onlyOwner {
686         require(_token != address(stakingToken), 'stakingToken cannot transfer.');
687         IERC20(_token).safeTransfer(owner(), _amount);
688     }
689 
690     /* ========== RESTRICTED FUNCTIONS ========== */
691 
692     function notifyRewardAmount(uint256 reward, uint256 duration) external onlyRewardsDistribution updateReward(address(0)) {
693         reward = satoshiToWei(reward);
694         if (block.timestamp >= periodFinish) {
695             rewardRate = reward.div(duration);
696         } else {
697             uint256 remaining = periodFinish.sub(block.timestamp);
698             uint256 leftover = remaining.mul(rewardRate);
699             rewardRate = reward.add(leftover).div(duration);
700         }
701 
702         // Ensure the provided reward amount is not more than the balance in the contract.
703         // This keeps the reward rate in the right range, preventing overflows due to
704         // very high values of rewardRate in the earned and rewardsPerToken functions;
705         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
706         uint balance = rewardsToken.balanceOf(address(this));
707         balance = satoshiToWei(balance);
708         require(rewardRate <= balance.div(duration), "Provided reward too high");
709 
710         lastUpdateTime = block.timestamp;
711         periodFinish = block.timestamp.add(duration);
712         rewardsDuration = duration;
713         emit RewardAdded(reward);
714     }
715 
716     /* ========== MODIFIERS ========== */
717 
718     modifier updateReward(address account) {
719         rewardPerTokenStored = rewardPerToken();
720         lastUpdateTime = lastTimeRewardApplicable();
721         if (account != address(0)) {
722             rewards[account] = _earned(account);
723             userRewardPerTokenPaid[account] = rewardPerTokenStored;
724         }
725         _;
726     }
727 
728     modifier onlyRewardsDistribution() {
729         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
730         _;
731     }
732 
733     /* ========== EVENTS ========== */
734 
735     event RewardAdded(uint256 reward);
736     event Staked(address indexed user, uint256 amount);
737     event Withdrawn(address indexed user, uint256 amount);
738     event RewardPaid(address indexed user, uint256 reward);
739 }
740 
741 interface IUniswapV2ERC20 {
742     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
743 }