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
325     function mint(address account, uint amount) external;
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
525 // File: contracts/IRewardDistributionRecipient.sol
526 
527 pragma solidity ^0.5.0;
528 
529 
530 
531 contract IRewardDistributionRecipient is Ownable {
532     address rewardDistribution;
533 
534     function notifyRewardAmount(uint256 reward) external;
535 
536     modifier onlyRewardDistribution() {
537         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
538         _;
539     }
540 
541     function setRewardDistribution(address _rewardDistribution)
542         external
543         onlyOwner
544     {
545         rewardDistribution = _rewardDistribution;
546     }
547 }
548 
549 // File: contracts/CurveRewards.sol
550 
551 pragma solidity ^0.5.0;
552 
553 
554 
555 
556 
557 
558 contract LPTokenWrapper {
559     using SafeMath for uint256;
560     using SafeERC20 for IERC20;
561 
562     IERC20 public u = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
563 
564     uint256 private _totalSupply;
565     mapping(address => uint256) private _balances;
566 
567     function totalSupply() public view returns (uint256) {
568         return _totalSupply;
569     }
570 
571     function balanceOf(address account) public view returns (uint256) {
572         return _balances[account];
573     }
574 
575     function stake(uint256 amount) public {
576         _totalSupply = _totalSupply.add(amount);
577         _balances[msg.sender] = _balances[msg.sender].add(amount);
578         u.safeTransferFrom(msg.sender, address(this), amount);
579     }
580 
581     function withdraw(uint256 amount) public {
582         _totalSupply = _totalSupply.sub(amount);
583         _balances[msg.sender] = _balances[msg.sender].sub(amount);
584         u.safeTransfer(msg.sender, amount);
585     }
586 }
587 
588 contract dUSDTPool is LPTokenWrapper, IRewardDistributionRecipient {
589     IERC20 public syfi = IERC20(0xdc38a4846d811572452cB4CE747dc9F5F509820f);
590     uint256 public constant DURATION = 7 days;
591 
592     uint256 public initreward = 10000*1e18;
593     uint256 public starttime = 1599321600; //utc+8 2020 09-06 00:00:00
594     uint256 public periodFinish = 0;
595     uint256 public rewardRate = 0;
596     uint256 public lastUpdateTime;
597     uint256 public rewardPerTokenStored;
598     mapping(address => uint256) public userRewardPerTokenPaid;
599     mapping(address => uint256) public rewards;
600 
601     event RewardAdded(uint256 reward);
602     event Staked(address indexed user, uint256 amount);
603     event Withdrawn(address indexed user, uint256 amount);
604     event RewardPaid(address indexed user, uint256 reward);
605 
606     modifier updateReward(address account) {
607         rewardPerTokenStored = rewardPerToken();
608         lastUpdateTime = lastTimeRewardApplicable();
609         if (account != address(0)) {
610             rewards[account] = earned(account);
611             userRewardPerTokenPaid[account] = rewardPerTokenStored;
612         }
613         _;
614     }
615 
616     function lastTimeRewardApplicable() public view returns (uint256) {
617         return Math.min(block.timestamp, periodFinish);
618     }
619 
620     function rewardPerToken() public view returns (uint256) {
621         if (totalSupply() == 0) {
622             return rewardPerTokenStored;
623         }
624         return
625             rewardPerTokenStored.add(
626                 lastTimeRewardApplicable()
627                     .sub(lastUpdateTime)
628                     .mul(rewardRate)
629                     .mul(1e18)
630                     .div(totalSupply())
631             );
632     }
633 
634     function earned(address account) public view returns (uint256) {
635         return
636             balanceOf(account)
637                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
638                 .div(1e18)
639                 .add(rewards[account]);
640     }
641 
642     // stake visibility is public as overriding LPTokenWrapper's stake() function
643     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart {
644         require(amount > 0, "Cannot stake 0");
645         super.stake(amount);
646         emit Staked(msg.sender, amount);
647     }
648 
649     function withdraw(uint256 amount) public updateReward(msg.sender) checkhalve checkStart {
650         require(amount > 0, "Cannot withdraw 0");
651         super.withdraw(amount);
652         emit Withdrawn(msg.sender, amount);
653     }
654 
655     function exit() external {
656         withdraw(balanceOf(msg.sender));
657         getReward();
658     }
659 
660     function getReward() public updateReward(msg.sender) checkhalve checkStart {
661         uint256 reward = earned(msg.sender);
662         if (reward > 0) {
663             rewards[msg.sender] = 0;
664             syfi.safeTransfer(msg.sender, reward);
665             emit RewardPaid(msg.sender, reward);
666         }
667     }
668 
669     modifier checkhalve(){
670         if (block.timestamp >= periodFinish && periodFinish != 0) {
671             initreward = initreward.mul(50).div(100); 
672             syfi.mint(address(this),initreward);
673 
674             rewardRate = initreward.div(DURATION);
675             periodFinish = block.timestamp.add(DURATION);
676             emit RewardAdded(initreward);
677         }
678         _;
679     }
680 
681     modifier checkStart(){
682         require(block.timestamp > starttime,"not start");
683         _;
684     }
685 
686     function notifyRewardAmount(uint256 reward)
687         external
688         onlyRewardDistribution
689         updateReward(address(0))
690     {
691         if (block.timestamp >= periodFinish) {
692             rewardRate = reward.div(DURATION);
693         } else {
694             uint256 remaining = periodFinish.sub(block.timestamp);
695             uint256 leftover = remaining.mul(rewardRate);
696             rewardRate = reward.add(leftover).div(DURATION);
697         }
698         syfi.mint(address(this),reward);
699         lastUpdateTime = block.timestamp;
700         if(block.timestamp < starttime){
701             periodFinish = starttime.add(DURATION);
702         }else {
703             periodFinish = block.timestamp.add(DURATION);
704         }
705         emit RewardAdded(reward);
706     }
707 }