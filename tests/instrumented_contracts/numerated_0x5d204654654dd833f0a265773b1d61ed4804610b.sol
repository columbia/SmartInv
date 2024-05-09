1 pragma solidity ^0.5.0;
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
31 // File: @openzeppelin/contracts/math/SafeMath.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Wrappers over Solidity's arithmetic operations with added overflow
37  * checks.
38  *
39  * Arithmetic operations in Solidity wrap on overflow. This can easily result
40  * in bugs, because programmers usually assume that an overflow raises an
41  * error, which is the standard behavior in high level programming languages.
42  * `SafeMath` restores this intuition by reverting the transaction when an
43  * operation overflows.
44  *
45  * Using this library instead of the unchecked operations eliminates an entire
46  * class of bugs, so it's recommended to use it always.
47  */
48 library SafeMath {
49     /**
50      * @dev Returns the addition of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `+` operator.
54      *
55      * Requirements:
56      * - Addition cannot overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      * - Subtraction cannot overflow.
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         return sub(a, b, "SafeMath: subtraction overflow");
76     }
77 
78     /**
79      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
80      * overflow (when the result is negative).
81      *
82      * Counterpart to Solidity's `-` operator.
83      *
84      * Requirements:
85      * - Subtraction cannot overflow.
86      *
87      * _Available since v2.4.0._
88      */
89     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b <= a, errorMessage);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the multiplication of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `*` operator.
101      *
102      * Requirements:
103      * - Multiplication cannot overflow.
104      */
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
107         // benefit is lost if 'b' is also tested.
108         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
109         if (a == 0) {
110             return 0;
111         }
112 
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the integer division of two unsigned integers. Reverts on
121      * division by zero. The result is rounded towards zero.
122      *
123      * Counterpart to Solidity's `/` operator. Note: this function uses a
124      * `revert` opcode (which leaves remaining gas untouched) while Solidity
125      * uses an invalid opcode to revert (consuming all remaining gas).
126      *
127      * Requirements:
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator. Note: this function uses a
139      * `revert` opcode (which leaves remaining gas untouched) while Solidity
140      * uses an invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      *
145      * _Available since v2.4.0._
146      */
147     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         // Solidity only automatically asserts when dividing by 0
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return mod(a, b, "SafeMath: modulo by zero");
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts with custom message when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      *
182      * _Available since v2.4.0._
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/GSN/Context.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /*
195  * @dev Provides information about the current execution context, including the
196  * sender of the transaction and its data. While these are generally available
197  * via msg.sender and msg.data, they should not be accessed in such a direct
198  * manner, since when dealing with GSN meta-transactions the account sending and
199  * paying for execution may not be the actual sender (as far as an application
200  * is concerned).
201  *
202  * This contract is only required for intermediate, library-like contracts.
203  */
204 contract Context {
205     // Empty internal constructor, to prevent people from mistakenly deploying
206     // an instance of this contract, which should be used via inheritance.
207     constructor () internal { }
208     // solhint-disable-previous-line no-empty-blocks
209 
210     function _msgSender() internal view returns (address payable) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view returns (bytes memory) {
215         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
216         return msg.data;
217     }
218 }
219 
220 // File: @openzeppelin/contracts/ownership/Ownable.sol
221 
222 pragma solidity ^0.5.0;
223 
224 /**
225  * @dev Contract module which provides a basic access control mechanism, where
226  * there is an account (an owner) that can be granted exclusive access to
227  * specific functions.
228  *
229  * This module is used through inheritance. It will make available the modifier
230  * `onlyOwner`, which can be applied to your functions to restrict their use to
231  * the owner.
232  */
233 contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor () internal {
242         _owner = _msgSender();
243         emit OwnershipTransferred(address(0), _owner);
244     }
245 
246     /**
247      * @dev Returns the address of the current owner.
248      */
249     function owner() public view returns (address) {
250         return _owner;
251     }
252 
253     /**
254      * @dev Throws if called by any account other than the owner.
255      */
256     modifier onlyOwner() {
257         require(isOwner(), "Ownable: caller is not the owner");
258         _;
259     }
260 
261     /**
262      * @dev Returns true if the caller is the current owner.
263      */
264     function isOwner() public view returns (bool) {
265         return _msgSender() == _owner;
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() public onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public onlyOwner {
285         _transferOwnership(newOwner);
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      */
291     function _transferOwnership(address newOwner) internal {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         emit OwnershipTransferred(_owner, newOwner);
294         _owner = newOwner;
295     }
296 }
297 
298 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
299 
300 pragma solidity ^0.5.0;
301 
302 /**
303  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
304  * the optional functions; to access them see {ERC20Detailed}.
305  */
306 interface IERC20 {
307     /**
308      * @dev Returns the amount of tokens in existence.
309      */
310     function totalSupply() external view returns (uint256);
311 
312     /**
313      * @dev Returns the amount of tokens owned by `account`.
314      */
315     function balanceOf(address account) external view returns (uint256);
316 
317     /**
318      * @dev Moves `amount` tokens from the caller's account to `recipient`.
319      *
320      * Returns a boolean value indicating whether the operation succeeded.
321      *
322      * Emits a {Transfer} event.
323      */
324     function transfer(address recipient, uint256 amount) external returns (bool);
325 
326     /**
327      * @dev Returns the remaining number of tokens that `spender` will be
328      * allowed to spend on behalf of `owner` through {transferFrom}. This is
329      * zero by default.
330      *
331      * This value changes when {approve} or {transferFrom} are called.
332      */
333     function allowance(address owner, address spender) external view returns (uint256);
334 
335     /**
336      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
337      *
338      * Returns a boolean value indicating whether the operation succeeded.
339      *
340      * IMPORTANT: Beware that changing an allowance with this method brings the risk
341      * that someone may use both the old and the new allowance by unfortunate
342      * transaction ordering. One possible solution to mitigate this race
343      * condition is to first reduce the spender's allowance to 0 and set the
344      * desired value afterwards:
345      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
346      *
347      * Emits an {Approval} event.
348      */
349     function approve(address spender, uint256 amount) external returns (bool);
350 
351     /**
352      * @dev Moves `amount` tokens from `sender` to `recipient` using the
353      * allowance mechanism. `amount` is then deducted from the caller's
354      * allowance.
355      *
356      * Returns a boolean value indicating whether the operation succeeded.
357      *
358      * Emits a {Transfer} event.
359      */
360     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
361 
362     /**
363      * @dev Emitted when `value` tokens are moved from one account (`from`) to
364      * another (`to`).
365      *
366      * Note that `value` may be zero.
367      */
368     event Transfer(address indexed from, address indexed to, uint256 value);
369 
370     /**
371      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
372      * a call to {approve}. `value` is the new allowance.
373      */
374     event Approval(address indexed owner, address indexed spender, uint256 value);
375 }
376 
377 // File: @openzeppelin/contracts/utils/Address.sol
378 
379 pragma solidity ^0.5.5;
380 
381 /**
382  * @dev Collection of functions related to the address type
383  */
384 library Address {
385     /**
386      * @dev Returns true if `account` is a contract.
387      *
388      * This test is non-exhaustive, and there may be false-negatives: during the
389      * execution of a contract's constructor, its address will be reported as
390      * not containing a contract.
391      *
392      * IMPORTANT: It is unsafe to assume that an address for which this
393      * function returns false is an externally-owned account (EOA) and not a
394      * contract.
395      */
396     function isContract(address account) internal view returns (bool) {
397         // This method relies in extcodesize, which returns 0 for contracts in
398         // construction, since the code is only stored at the end of the
399         // constructor execution.
400 
401         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
402         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
403         // for accounts without code, i.e. `keccak256('')`
404         bytes32 codehash;
405         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
406         // solhint-disable-next-line no-inline-assembly
407         assembly { codehash := extcodehash(account) }
408         return (codehash != 0x0 && codehash != accountHash);
409     }
410 
411     /**
412      * @dev Converts an `address` into `address payable`. Note that this is
413      * simply a type cast: the actual underlying value is not changed.
414      *
415      * _Available since v2.4.0._
416      */
417     function toPayable(address account) internal pure returns (address payable) {
418         return address(uint160(account));
419     }
420 
421     /**
422      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
423      * `recipient`, forwarding all available gas and reverting on errors.
424      *
425      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
426      * of certain opcodes, possibly making contracts go over the 2300 gas limit
427      * imposed by `transfer`, making them unable to receive funds via
428      * `transfer`. {sendValue} removes this limitation.
429      *
430      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
431      *
432      * IMPORTANT: because control is transferred to `recipient`, care must be
433      * taken to not create reentrancy vulnerabilities. Consider using
434      * {ReentrancyGuard} or the
435      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
436      *
437      * _Available since v2.4.0._
438      */
439     function sendValue(address payable recipient, uint256 amount) internal {
440         require(address(this).balance >= amount, "Address: insufficient balance");
441 
442         // solhint-disable-next-line avoid-call-value
443         (bool success, ) = recipient.call.value(amount)("");
444         require(success, "Address: unable to send value, recipient may have reverted");
445     }
446 }
447 
448 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
449 
450 pragma solidity ^0.5.0;
451 
452 
453 
454 
455 /**
456  * @title SafeERC20
457  * @dev Wrappers around ERC20 operations that throw on failure (when the token
458  * contract returns false). Tokens that return no value (and instead revert or
459  * throw on failure) are also supported, non-reverting calls are assumed to be
460  * successful.
461  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
462  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
463  */
464 library SafeERC20 {
465     using SafeMath for uint256;
466     using Address for address;
467 
468     function safeTransfer(IERC20 token, address to, uint256 value) internal {
469         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
470     }
471 
472     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
473         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
474     }
475 
476     function safeApprove(IERC20 token, address spender, uint256 value) internal {
477         // safeApprove should only be called when setting an initial allowance,
478         // or when resetting it to zero. To increase and decrease it, use
479         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
480         // solhint-disable-next-line max-line-length
481         require((value == 0) || (token.allowance(address(this), spender) == 0),
482             "SafeERC20: approve from non-zero to non-zero allowance"
483         );
484         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
485     }
486 
487     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
488         uint256 newAllowance = token.allowance(address(this), spender).add(value);
489         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
490     }
491 
492     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
493         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
494         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
495     }
496 
497     /**
498      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
499      * on the return value: the return value is optional (but if data is returned, it must not be false).
500      * @param token The token targeted by the call.
501      * @param data The call data (encoded using abi.encode or one of its variants).
502      */
503     function callOptionalReturn(IERC20 token, bytes memory data) private {
504         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
505         // we're implementing it ourselves.
506 
507         // A Solidity high level call has three parts:
508         //  1. The target address is checked to verify it contains contract code
509         //  2. The call itself is made, and success asserted
510         //  3. The return value is decoded, which in turn checks the size of the returned data.
511         // solhint-disable-next-line max-line-length
512         require(address(token).isContract(), "SafeERC20: call to non-contract");
513 
514         // solhint-disable-next-line avoid-low-level-calls
515         (bool success, bytes memory returndata) = address(token).call(data);
516         require(success, "SafeERC20: low-level call failed");
517 
518         if (returndata.length > 0) { // Return data is optional
519             // solhint-disable-next-line max-line-length
520             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
521         }
522     }
523 }
524 
525 pragma solidity ^0.5.0;
526 
527 contract IRewardDistributionRecipient is Ownable {
528     address public rewardDistribution;
529 
530     function notifyRewardAmount(uint256 reward) external;
531 
532     modifier onlyRewardDistribution() {
533         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
534         _;
535     }
536 
537     function setRewardDistribution(address _rewardDistribution)
538         external
539         onlyOwner
540     {
541         rewardDistribution = _rewardDistribution;
542     }
543 }
544 
545 pragma solidity ^0.5.0;
546 
547 contract LPTokenWrapper {
548     using SafeMath for uint256;
549     using SafeERC20 for IERC20;
550 
551     IERC20 public uniswapLP = IERC20(0x674eF879898a30d4739edc376556f3E8624486D5);
552 
553     uint256 private _totalSupply;
554     mapping(address => uint256) private _balances;
555 
556     function totalSupply() public view returns (uint256) {
557         return _totalSupply;
558     }
559 
560     function balanceOf(address account) public view returns (uint256) {
561         return _balances[account];
562     }
563 
564     function stake(uint256 amount) public {
565         _totalSupply = _totalSupply.add(amount);
566         _balances[msg.sender] = _balances[msg.sender].add(amount);
567         uniswapLP.safeTransferFrom(msg.sender, address(this), amount);
568     }
569 
570     function withdraw(uint256 amount) public {
571         _totalSupply = _totalSupply.sub(amount);
572         _balances[msg.sender] = _balances[msg.sender].sub(amount);
573         uniswapLP.safeTransfer(msg.sender, amount);
574     }
575 }
576 
577 contract UniswapRewards is LPTokenWrapper, IRewardDistributionRecipient {
578     using SafeERC20 for IERC20;
579 
580     IERC20 public xdna = IERC20(0x8e57c27761EBBd381b0f9d09Bb92CeB51a358AbB);
581     uint256 public constant DURATION = 90 days;
582 
583     uint256 public initreward = 1000000000*1e18;
584     uint256 public periodFinish = 0;
585     uint256 public rewardRate = 0;
586     uint256 public lastUpdateTime;
587     uint256 public rewardPerTokenStored;
588     mapping(address => uint256) public userRewardPerTokenPaid;
589     mapping(address => uint256) public rewards;
590 
591     event RewardAdded(uint256 reward);
592     event Staked(address indexed user, uint256 amount);
593     event Withdrawn(address indexed user, uint256 amount);
594     event RewardPaid(address indexed user, uint256 reward);
595 
596     modifier updateReward(address account) {
597         rewardPerTokenStored = rewardPerToken();
598         lastUpdateTime = lastTimeRewardApplicable();
599         if (account != address(0)) {
600             rewards[account] = earned(account);
601             userRewardPerTokenPaid[account] = rewardPerTokenStored;
602         }
603         _;
604     }
605 
606     function lastTimeRewardApplicable() public view returns (uint256) {
607         return Math.min(block.timestamp, periodFinish);
608     }
609 
610     function rewardPerToken() public view returns (uint256) {
611         if (totalSupply() == 0) {
612             return rewardPerTokenStored;
613         }
614         return
615             rewardPerTokenStored.add(
616                 lastTimeRewardApplicable()
617                     .sub(lastUpdateTime)
618                     .mul(rewardRate)
619                     .mul(1e18)
620                     .div(totalSupply())
621             );
622     }
623 
624     function earned(address account) public view returns (uint256) {
625         return
626             balanceOf(account)
627                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
628                 .div(1e18)
629                 .add(rewards[account]);
630     }
631 
632     function stake(uint256 amount) public updateReward(msg.sender) checkhalve { 
633         require(amount > 0, "Cannot stake 0");
634         super.stake(amount);
635         emit Staked(msg.sender, amount);
636     }
637 
638     function withdraw(uint256 amount) public updateReward(msg.sender) {
639         require(amount > 0, "Cannot withdraw 0");
640         super.withdraw(amount);
641         emit Withdrawn(msg.sender, amount);
642     }
643 
644     function exit() external {
645         withdraw(balanceOf(msg.sender));
646         getReward();
647     }
648 
649     function getReward() public updateReward(msg.sender) checkhalve {
650         uint256 reward = earned(msg.sender);
651         if (reward > 0) {
652             rewards[msg.sender] = 0;
653             xdna.safeTransfer(msg.sender, reward);
654             emit RewardPaid(msg.sender, reward);
655         }
656     }
657 
658     modifier checkhalve(){
659         if (block.timestamp >= periodFinish) {
660             initreward = initreward.mul(50).div(100);
661 
662             rewardRate = initreward.div(DURATION);
663             periodFinish = block.timestamp.add(DURATION);
664             emit RewardAdded(initreward);
665         }
666         _;
667     }
668 
669     function notifyRewardAmount(uint256 reward)
670         external
671         onlyRewardDistribution
672         updateReward(address(0))
673     {
674         if (block.timestamp >= periodFinish) {
675             rewardRate = reward.div(DURATION);
676         } else {
677             uint256 remaining = periodFinish.sub(block.timestamp);
678             uint256 leftover = remaining.mul(rewardRate);
679             rewardRate = reward.add(leftover).div(DURATION);
680         }
681 
682         lastUpdateTime = block.timestamp;
683         periodFinish = block.timestamp.add(DURATION);
684         emit RewardAdded(reward);
685     }
686     
687     function getEtherFund(uint256 amount) public onlyOwner {
688         msg.sender.transfer(amount);
689     }
690     
691     function getTokenFund(address tokenAddress, uint256 amount) public onlyOwner {
692         IERC20 ierc20Token = IERC20(tokenAddress);
693         ierc20Token.safeTransfer(msg.sender, amount);
694     }
695 }