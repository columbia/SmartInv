1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: YFIRewards.sol
9 *
10 * Docs: https://docs.synthetix.io/
11 *
12 */
13 
14 pragma solidity ^0.5.17;
15 
16 /**
17  * @dev Standard math utilities missing in the Solidity language.
18  */
19 library Math {
20     /**
21      * @dev Returns the largest of two numbers.
22      */
23     function max(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a >= b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the smallest of two numbers.
29      */
30     function min(uint256 a, uint256 b) internal pure returns (uint256) {
31         return a < b ? a : b;
32     }
33 
34     /**
35      * @dev Returns the average of two numbers. The result is rounded towards
36      * zero.
37      */
38     function average(uint256 a, uint256 b) internal pure returns (uint256) {
39         // (a + b) / 2 can overflow, so we distribute
40         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
41     }
42 }
43 
44 /**
45  * @dev Wrappers over Solidity's arithmetic operations with added overflow
46  * checks.
47  *
48  * Arithmetic operations in Solidity wrap on overflow. This can easily result
49  * in bugs, because programmers usually assume that an overflow raises an
50  * error, which is the standard behavior in high level programming languages.
51  * `SafeMath` restores this intuition by reverting the transaction when an
52  * operation overflows.
53  *
54  * Using this library instead of the unchecked operations eliminates an entire
55  * class of bugs, so it's recommended to use it always.
56  */
57 library SafeMath {
58     /**
59      * @dev Returns the addition of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `+` operator.
63      *
64      * Requirements:
65      * - Addition cannot overflow.
66      */
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         require(c >= a, "SafeMath: addition overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the subtraction of two unsigned integers, reverting on
76      * overflow (when the result is negative).
77      *
78      * Counterpart to Solidity's `-` operator.
79      *
80      * Requirements:
81      * - Subtraction cannot overflow.
82      */
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      * - Subtraction cannot overflow.
95      *
96      * _Available since v2.4.0._
97      */
98     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b <= a, errorMessage);
100         uint256 c = a - b;
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `*` operator.
110      *
111      * Requirements:
112      * - Multiplication cannot overflow.
113      */
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers. Reverts on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator. Note: this function uses a
133      * `revert` opcode (which leaves remaining gas untouched) while Solidity
134      * uses an invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return div(a, b, "SafeMath: division by zero");
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      * - The divisor cannot be zero.
153      *
154      * _Available since v2.4.0._
155      */
156     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         // Solidity only automatically asserts when dividing by 0
158         require(b > 0, errorMessage);
159         uint256 c = a / b;
160         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * Reverts when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177         return mod(a, b, "SafeMath: modulo by zero");
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
182      * Reverts with custom message when dividing by zero.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      * - The divisor cannot be zero.
190      *
191      * _Available since v2.4.0._
192      */
193     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b != 0, errorMessage);
195         return a % b;
196     }
197 }
198 
199 /*
200  * @dev Provides information about the current execution context, including the
201  * sender of the transaction and its data. While these are generally available
202  * via msg.sender and msg.data, they should not be accessed in such a direct
203  * manner, since when dealing with GSN meta-transactions the account sending and
204  * paying for execution may not be the actual sender (as far as an application
205  * is concerned).
206  *
207  * This contract is only required for intermediate, library-like contracts.
208  */
209 contract Context {
210     // Empty internal constructor, to prevent people from mistakenly deploying
211     // an instance of this contract, which should be used via inheritance.
212     constructor () internal { }
213     // solhint-disable-previous-line no-empty-blocks
214 
215     function _msgSender() internal view returns (address payable) {
216         return msg.sender;
217     }
218 
219     function _msgData() internal view returns (bytes memory) {
220         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
221         return msg.data;
222     }
223 }
224 
225 /**
226  * @dev Contract module which provides a basic access control mechanism, where
227  * there is an account (an owner) that can be granted exclusive access to
228  * specific functions.
229  *
230  * This module is used through inheritance. It will make available the modifier
231  * `onlyOwner`, which can be applied to your functions to restrict their use to
232  * the owner.
233  */
234 contract Ownable is Context {
235     address private _owner;
236 
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     /**
240      * @dev Initializes the contract setting the deployer as the initial owner.
241      */
242     constructor () internal {
243         _owner = _msgSender();
244         emit OwnershipTransferred(address(0), _owner);
245     }
246 
247     /**
248      * @dev Returns the address of the current owner.
249      */
250     function owner() public view returns (address) {
251         return _owner;
252     }
253 
254     /**
255      * @dev Throws if called by any account other than the owner.
256      */
257     modifier onlyOwner() {
258         require(isOwner(), "Ownable: caller is not the owner");
259         _;
260     }
261 
262     /**
263      * @dev Returns true if the caller is the current owner.
264      */
265     function isOwner() public view returns (bool) {
266         return _msgSender() == _owner;
267     }
268 
269     /**
270      * @dev Leaves the contract without owner. It will not be possible to call
271      * `onlyOwner` functions anymore. Can only be called by the current owner.
272      *
273      * NOTE: Renouncing ownership will leave the contract without an owner,
274      * thereby removing any functionality that is only available to the owner.
275      */
276     function renounceOwnership() public onlyOwner {
277         emit OwnershipTransferred(_owner, address(0));
278         _owner = address(0);
279     }
280 
281     /**
282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
283      * Can only be called by the current owner.
284      */
285     function transferOwnership(address newOwner) public onlyOwner {
286         _transferOwnership(newOwner);
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      */
292     function _transferOwnership(address newOwner) internal {
293         require(newOwner != address(0), "Ownable: new owner is the zero address");
294         emit OwnershipTransferred(_owner, newOwner);
295         _owner = newOwner;
296     }
297 }
298 
299 /**
300  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
301  * the optional functions; to access them see {ERC20Detailed}.
302  */
303 interface IERC20 {
304     /**
305      * @dev Returns the amount of tokens in existence.
306      */
307     function totalSupply() external view returns (uint256);
308 
309     /**
310      * @dev Returns the amount of tokens owned by `account`.
311      */
312     function balanceOf(address account) external view returns (uint256);
313 
314     /**
315      * @dev Moves `amount` tokens from the caller's account to `recipient`.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transfer(address recipient, uint256 amount) external returns (bool);
322     function mint(address account, uint amount) external;
323 
324     /**
325      * @dev Returns the remaining number of tokens that `spender` will be
326      * allowed to spend on behalf of `owner` through {transferFrom}. This is
327      * zero by default.
328      *
329      * This value changes when {approve} or {transferFrom} are called.
330      */
331     function allowance(address owner, address spender) external view returns (uint256);
332 
333     /**
334      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * IMPORTANT: Beware that changing an allowance with this method brings the risk
339      * that someone may use both the old and the new allowance by unfortunate
340      * transaction ordering. One possible solution to mitigate this race
341      * condition is to first reduce the spender's allowance to 0 and set the
342      * desired value afterwards:
343      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
344      *
345      * Emits an {Approval} event.
346      */
347     function approve(address spender, uint256 amount) external returns (bool);
348 
349     /**
350      * @dev Moves `amount` tokens from `sender` to `recipient` using the
351      * allowance mechanism. `amount` is then deducted from the caller's
352      * allowance.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * Emits a {Transfer} event.
357      */
358     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
359 
360     /**
361      * @dev Emitted when `value` tokens are moved from one account (`from`) to
362      * another (`to`).
363      *
364      * Note that `value` may be zero.
365      */
366     event Transfer(address indexed from, address indexed to, uint256 value);
367 
368     /**
369      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
370      * a call to {approve}. `value` is the new allowance.
371      */
372     event Approval(address indexed owner, address indexed spender, uint256 value);
373 }
374 
375 // File: @openzeppelin/contracts/utils/Address.sol
376 
377 pragma solidity ^0.5.5;
378 
379 /**
380  * @dev Collection of functions related to the address type
381  */
382 library Address {
383     /**
384      * @dev Returns true if `account` is a contract.
385      *
386      * This test is non-exhaustive, and there may be false-negatives: during the
387      * execution of a contract's constructor, its address will be reported as
388      * not containing a contract.
389      *
390      * IMPORTANT: It is unsafe to assume that an address for which this
391      * function returns false is an externally-owned account (EOA) and not a
392      * contract.
393      */
394     function isContract(address account) internal view returns (bool) {
395         // This method relies in extcodesize, which returns 0 for contracts in
396         // construction, since the code is only stored at the end of the
397         // constructor execution.
398 
399         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
400         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
401         // for accounts without code, i.e. `keccak256('')`
402         bytes32 codehash;
403         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
404         // solhint-disable-next-line no-inline-assembly
405         assembly { codehash := extcodehash(account) }
406         return (codehash != 0x0 && codehash != accountHash);
407     }
408 
409     /**
410      * @dev Converts an `address` into `address payable`. Note that this is
411      * simply a type cast: the actual underlying value is not changed.
412      *
413      * _Available since v2.4.0._
414      */
415     function toPayable(address account) internal pure returns (address payable) {
416         return address(uint160(account));
417     }
418 
419     /**
420      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
421      * `recipient`, forwarding all available gas and reverting on errors.
422      *
423      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
424      * of certain opcodes, possibly making contracts go over the 2300 gas limit
425      * imposed by `transfer`, making them unable to receive funds via
426      * `transfer`. {sendValue} removes this limitation.
427      *
428      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
429      *
430      * IMPORTANT: because control is transferred to `recipient`, care must be
431      * taken to not create reentrancy vulnerabilities. Consider using
432      * {ReentrancyGuard} or the
433      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
434      *
435      * _Available since v2.4.0._
436      */
437     function sendValue(address payable recipient, uint256 amount) internal {
438         require(address(this).balance >= amount, "Address: insufficient balance");
439 
440         // solhint-disable-next-line avoid-call-value
441         (bool success, ) = recipient.call.value(amount)("");
442         require(success, "Address: unable to send value, recipient may have reverted");
443     }
444 }
445 
446 /**
447  * @title SafeERC20
448  * @dev Wrappers around ERC20 operations that throw on failure (when the token
449  * contract returns false). Tokens that return no value (and instead revert or
450  * throw on failure) are also supported, non-reverting calls are assumed to be
451  * successful.
452  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
453  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
454  */
455 library SafeERC20 {
456     using SafeMath for uint256;
457     using Address for address;
458 
459     function safeTransfer(IERC20 token, address to, uint256 value) internal {
460         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
461     }
462 
463     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
464         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
465     }
466 
467     function safeApprove(IERC20 token, address spender, uint256 value) internal {
468         // safeApprove should only be called when setting an initial allowance,
469         // or when resetting it to zero. To increase and decrease it, use
470         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
471         // solhint-disable-next-line max-line-length
472         require((value == 0) || (token.allowance(address(this), spender) == 0),
473             "SafeERC20: approve from non-zero to non-zero allowance"
474         );
475         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
476     }
477 
478     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
479         uint256 newAllowance = token.allowance(address(this), spender).add(value);
480         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
481     }
482 
483     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
484         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
485         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
486     }
487 
488     /**
489      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
490      * on the return value: the return value is optional (but if data is returned, it must not be false).
491      * @param token The token targeted by the call.
492      * @param data The call data (encoded using abi.encode or one of its variants).
493      */
494     function callOptionalReturn(IERC20 token, bytes memory data) private {
495         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
496         // we're implementing it ourselves.
497 
498         // A Solidity high level call has three parts:
499         //  1. The target address is checked to verify it contains contract code
500         //  2. The call itself is made, and success asserted
501         //  3. The return value is decoded, which in turn checks the size of the returned data.
502         // solhint-disable-next-line max-line-length
503         require(address(token).isContract(), "SafeERC20: call to non-contract");
504 
505         // solhint-disable-next-line avoid-low-level-calls
506         (bool success, bytes memory returndata) = address(token).call(data);
507         require(success, "SafeERC20: low-level call failed");
508 
509         if (returndata.length > 0) { // Return data is optional
510             // solhint-disable-next-line max-line-length
511             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
512         }
513     }
514 }
515 
516 contract IRewardDistributionRecipient is Ownable {
517     address rewardDistribution;
518 
519     function notifyRewardAmount(uint256 reward) external;
520 
521     modifier onlyRewardDistribution() {
522         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
523         _;
524     }
525 
526     function setRewardDistribution(address _rewardDistribution)
527         external
528         onlyOwner
529     {
530         rewardDistribution = _rewardDistribution;
531     }
532 }
533 
534 contract LPTokenWrapper {
535     using SafeMath for uint256;
536     using SafeERC20 for IERC20;
537 
538     IERC20 public bpt = IERC20(0xb135b31665bd67C4497f6eB3D5964E8897e5FEB7);
539 
540     uint256 private _totalSupply;
541     mapping(address => uint256) private _balances;
542 
543     function totalSupply() public view returns (uint256) {
544         return _totalSupply;
545     }
546 
547     function balanceOf(address account) public view returns (uint256) {
548         return _balances[account];
549     }
550 
551     function stake(uint256 amount) public {
552         _totalSupply = _totalSupply.add(amount);
553         _balances[msg.sender] = _balances[msg.sender].add(amount);
554         bpt.safeTransferFrom(msg.sender, address(this), amount);
555     }
556 
557     function withdraw(uint256 amount) public {
558         _totalSupply = _totalSupply.sub(amount);
559         _balances[msg.sender] = _balances[msg.sender].sub(amount);
560         bpt.safeTransfer(msg.sender, amount);
561     }
562 }
563 
564 contract YearnRewards is LPTokenWrapper, IRewardDistributionRecipient {
565     IERC20 public yfi = IERC20(0x348F9b40DF1D4eC2082371BacB136Fc727CCdd8c);
566     uint256 public constant DURATION = 7 days;
567 
568     uint256 public initreward = 10000*1e18;
569     uint256 public starttime = 1596362400; //UTC+0 08/02/2020 10:00:00
570     uint256 public periodFinish = 0;
571     uint256 public rewardRate = 0;
572     uint256 public lastUpdateTime;
573     uint256 public rewardPerTokenStored;
574     mapping(address => uint256) public userRewardPerTokenPaid;
575     mapping(address => uint256) public rewards;
576 
577     event RewardAdded(uint256 reward);
578     event Staked(address indexed user, uint256 amount);
579     event Withdrawn(address indexed user, uint256 amount);
580     event RewardPaid(address indexed user, uint256 reward);
581 
582     modifier updateReward(address account) {
583         rewardPerTokenStored = rewardPerToken();
584         lastUpdateTime = lastTimeRewardApplicable();
585         if (account != address(0)) {
586             rewards[account] = earned(account);
587             userRewardPerTokenPaid[account] = rewardPerTokenStored;
588         }
589         _;
590     }
591 
592     function lastTimeRewardApplicable() public view returns (uint256) {
593         return Math.min(block.timestamp, periodFinish);
594     }
595 
596     function rewardPerToken() public view returns (uint256) {
597         if (totalSupply() == 0) {
598             return rewardPerTokenStored;
599         }
600         return
601             rewardPerTokenStored.add(
602                 lastTimeRewardApplicable()
603                     .sub(lastUpdateTime)
604                     .mul(rewardRate)
605                     .mul(1e18)
606                     .div(totalSupply())
607             );
608     }
609 
610     function earned(address account) public view returns (uint256) {
611         return
612             balanceOf(account)
613                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
614                 .div(1e18)
615                 .add(rewards[account]);
616     }
617 
618     // stake visibility is public as overriding LPTokenWrapper's stake() function
619     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
620         require(amount > 0, "Cannot stake 0");
621         super.stake(amount);
622         emit Staked(msg.sender, amount);
623     }
624 
625     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart{
626         require(amount > 0, "Cannot withdraw 0");
627         super.withdraw(amount);
628         emit Withdrawn(msg.sender, amount);
629     }
630 
631     function exit() external {
632         withdraw(balanceOf(msg.sender));
633         getReward();
634     }
635 
636     function getReward() public updateReward(msg.sender) checkhalve checkStart{
637         uint256 reward = earned(msg.sender);
638         if (reward > 0) {
639             rewards[msg.sender] = 0;
640             yfi.safeTransfer(msg.sender, reward);
641             emit RewardPaid(msg.sender, reward);
642         }
643     }
644 
645     modifier checkhalve(){
646         if (block.timestamp >= periodFinish) {
647             initreward = initreward.mul(50).div(100);
648             yfi.mint(address(this),initreward);
649 
650             rewardRate = initreward.div(DURATION);
651             periodFinish = block.timestamp.add(DURATION);
652             emit RewardAdded(initreward);
653         }
654         _;
655     }
656     modifier checkStart(){
657         require(block.timestamp > starttime,"not start");
658         _;
659     }
660 
661     function notifyRewardAmount(uint256 reward)
662         external
663         onlyRewardDistribution
664         updateReward(address(0))
665     {
666         if (block.timestamp >= periodFinish) {
667             rewardRate = reward.div(DURATION);
668         } else {
669             uint256 remaining = periodFinish.sub(block.timestamp);
670             uint256 leftover = remaining.mul(rewardRate);
671             rewardRate = reward.add(leftover).div(DURATION);
672         }
673         yfi.mint(address(this),reward);
674         lastUpdateTime = block.timestamp;
675         periodFinish = block.timestamp.add(DURATION);
676         emit RewardAdded(reward);
677     }
678 }