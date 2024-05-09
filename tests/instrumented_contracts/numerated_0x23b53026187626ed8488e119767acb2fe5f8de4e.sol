1 // Official Website: percent.finance
2 
3 // File: contracts/PctPool.sol
4 
5 // Modified from Synthetix's Unipool: https://etherscan.io/address/0x48D7f315feDcaD332F68aafa017c7C158BC54760#code
6 
7 // File: @openzeppelin/contracts/math/Math.sol
8 
9 pragma solidity ^0.5.0;
10 
11 /**
12  * @dev Standard math utilities missing in the Solidity language.
13  */
14 library Math {
15     /**
16      * @dev Returns the largest of two numbers.
17      */
18     function max(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a >= b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the smallest of two numbers.
24      */
25     function min(uint256 a, uint256 b) internal pure returns (uint256) {
26         return a < b ? a : b;
27     }
28 
29     /**
30      * @dev Returns the average of two numbers. The result is rounded towards
31      * zero.
32      */
33     function average(uint256 a, uint256 b) internal pure returns (uint256) {
34         // (a + b) / 2 can overflow, so we distribute
35         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
36     }
37 }
38 
39 // File: @openzeppelin/contracts/math/SafeMath.sol
40 
41 pragma solidity ^0.5.0;
42 
43 /**
44  * @dev Wrappers over Solidity's arithmetic operations with added overflow
45  * checks.
46  *
47  * Arithmetic operations in Solidity wrap on overflow. This can easily result
48  * in bugs, because programmers usually assume that an overflow raises an
49  * error, which is the standard behavior in high level programming languages.
50  * `SafeMath` restores this intuition by reverting the transaction when an
51  * operation overflows.
52  *
53  * Using this library instead of the unchecked operations eliminates an entire
54  * class of bugs, so it's recommended to use it always.
55  */
56 library SafeMath {
57     /**
58      * @dev Returns the addition of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `+` operator.
62      *
63      * Requirements:
64      * - Addition cannot overflow.
65      */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a, "SafeMath: addition overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      * - Subtraction cannot overflow.
94      *
95      * _Available since v2.4.0._
96      */
97     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         require(b <= a, errorMessage);
99         uint256 c = a - b;
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the multiplication of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `*` operator.
109      *
110      * Requirements:
111      * - Multiplication cannot overflow.
112      */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return div(a, b, "SafeMath: division by zero");
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator. Note: this function uses a
147      * `revert` opcode (which leaves remaining gas untouched) while Solidity
148      * uses an invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      * - The divisor cannot be zero.
152      *
153      * _Available since v2.4.0._
154      */
155     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         // Solidity only automatically asserts when dividing by 0
157         require(b > 0, errorMessage);
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * Reverts when dividing by zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         return mod(a, b, "SafeMath: modulo by zero");
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts with custom message when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      *
190      * _Available since v2.4.0._
191      */
192     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b != 0, errorMessage);
194         return a % b;
195     }
196 }
197 
198 // File: @openzeppelin/contracts/GSN/Context.sol
199 
200 pragma solidity ^0.5.0;
201 
202 /*
203  * @dev Provides information about the current execution context, including the
204  * sender of the transaction and its data. While these are generally available
205  * via msg.sender and msg.data, they should not be accessed in such a direct
206  * manner, since when dealing with GSN meta-transactions the account sending and
207  * paying for execution may not be the actual sender (as far as an application
208  * is concerned).
209  *
210  * This contract is only required for intermediate, library-like contracts.
211  */
212 contract Context {
213     // Empty internal constructor, to prevent people from mistakenly deploying
214     // an instance of this contract, which should be used via inheritance.
215     constructor () internal { }
216     // solhint-disable-previous-line no-empty-blocks
217 
218     function _msgSender() internal view returns (address payable) {
219         return msg.sender;
220     }
221 
222     function _msgData() internal view returns (bytes memory) {
223         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
224         return msg.data;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/ownership/Ownable.sol
229 
230 pragma solidity ^0.5.0;
231 
232 /**
233  * @dev Contract module which provides a basic access control mechanism, where
234  * there is an account (an owner) that can be granted exclusive access to
235  * specific functions.
236  *
237  * This module is used through inheritance. It will make available the modifier
238  * `onlyOwner`, which can be applied to your functions to restrict their use to
239  * the owner.
240  */
241 contract Ownable is Context {
242     address private _owner;
243 
244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
245 
246     /**
247      * @dev Initializes the contract setting the deployer as the initial owner.
248      */
249     constructor () internal {
250         _owner = _msgSender();
251         emit OwnershipTransferred(address(0), _owner);
252     }
253 
254     /**
255      * @dev Returns the address of the current owner.
256      */
257     function owner() public view returns (address) {
258         return _owner;
259     }
260 
261     /**
262      * @dev Throws if called by any account other than the owner.
263      */
264     modifier onlyOwner() {
265         require(isOwner(), "Ownable: caller is not the owner");
266         _;
267     }
268 
269     /**
270      * @dev Returns true if the caller is the current owner.
271      */
272     function isOwner() public view returns (bool) {
273         return _msgSender() == _owner;
274     }
275 
276     /**
277      * @dev Leaves the contract without owner. It will not be possible to call
278      * `onlyOwner` functions anymore. Can only be called by the current owner.
279      *
280      * NOTE: Renouncing ownership will leave the contract without an owner,
281      * thereby removing any functionality that is only available to the owner.
282      */
283     function renounceOwnership() public onlyOwner {
284         emit OwnershipTransferred(_owner, address(0));
285         _owner = address(0);
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      * Can only be called by the current owner.
291      */
292     function transferOwnership(address newOwner) public onlyOwner {
293         _transferOwnership(newOwner);
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      */
299     function _transferOwnership(address newOwner) internal {
300         require(newOwner != address(0), "Ownable: new owner is the zero address");
301         emit OwnershipTransferred(_owner, newOwner);
302         _owner = newOwner;
303     }
304 }
305 
306 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
307 
308 pragma solidity ^0.5.0;
309 
310 /**
311  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
312  * the optional functions; to access them see {ERC20Detailed}.
313  */
314 interface IERC20 {
315     /**
316      * @dev Returns the amount of tokens in existence.
317      */
318     function totalSupply() external view returns (uint256);
319 
320     /**
321      * @dev Returns the amount of tokens owned by `account`.
322      */
323     function balanceOf(address account) external view returns (uint256);
324 
325     /**
326      * @dev Moves `amount` tokens from the caller's account to `recipient`.
327      *
328      * Returns a boolean value indicating whether the operation succeeded.
329      *
330      * Emits a {Transfer} event.
331      */
332     function transfer(address recipient, uint256 amount) external returns (bool);
333 
334     /**
335      * @dev Returns the remaining number of tokens that `spender` will be
336      * allowed to spend on behalf of `owner` through {transferFrom}. This is
337      * zero by default.
338      *
339      * This value changes when {approve} or {transferFrom} are called.
340      */
341     function allowance(address owner, address spender) external view returns (uint256);
342 
343     /**
344      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
345      *
346      * Returns a boolean value indicating whether the operation succeeded.
347      *
348      * IMPORTANT: Beware that changing an allowance with this method brings the risk
349      * that someone may use both the old and the new allowance by unfortunate
350      * transaction ordering. One possible solution to mitigate this race
351      * condition is to first reduce the spender's allowance to 0 and set the
352      * desired value afterwards:
353      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
354      *
355      * Emits an {Approval} event.
356      */
357     function approve(address spender, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Moves `amount` tokens from `sender` to `recipient` using the
361      * allowance mechanism. `amount` is then deducted from the caller's
362      * allowance.
363      *
364      * Returns a boolean value indicating whether the operation succeeded.
365      *
366      * Emits a {Transfer} event.
367      */
368     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
369 
370     /**
371      * @dev Emitted when `value` tokens are moved from one account (`from`) to
372      * another (`to`).
373      *
374      * Note that `value` may be zero.
375      */
376     event Transfer(address indexed from, address indexed to, uint256 value);
377 
378     /**
379      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
380      * a call to {approve}. `value` is the new allowance.
381      */
382     event Approval(address indexed owner, address indexed spender, uint256 value);
383 }
384 
385 // File: @openzeppelin/contracts/utils/Address.sol
386 
387 pragma solidity ^0.5.5;
388 
389 /**
390  * @dev Collection of functions related to the address type
391  */
392 library Address {
393     /**
394      * @dev Returns true if `account` is a contract.
395      *
396      * This test is non-exhaustive, and there may be false-negatives: during the
397      * execution of a contract's constructor, its address will be reported as
398      * not containing a contract.
399      *
400      * IMPORTANT: It is unsafe to assume that an address for which this
401      * function returns false is an externally-owned account (EOA) and not a
402      * contract.
403      */
404     function isContract(address account) internal view returns (bool) {
405         // This method relies in extcodesize, which returns 0 for contracts in
406         // construction, since the code is only stored at the end of the
407         // constructor execution.
408 
409         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
410         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
411         // for accounts without code, i.e. `keccak256('')`
412         bytes32 codehash;
413         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
414         // solhint-disable-next-line no-inline-assembly
415         assembly { codehash := extcodehash(account) }
416         return (codehash != 0x0 && codehash != accountHash);
417     }
418 
419     /**
420      * @dev Converts an `address` into `address payable`. Note that this is
421      * simply a type cast: the actual underlying value is not changed.
422      *
423      * _Available since v2.4.0._
424      */
425     function toPayable(address account) internal pure returns (address payable) {
426         return address(uint160(account));
427     }
428 
429     /**
430      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
431      * `recipient`, forwarding all available gas and reverting on errors.
432      *
433      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
434      * of certain opcodes, possibly making contracts go over the 2300 gas limit
435      * imposed by `transfer`, making them unable to receive funds via
436      * `transfer`. {sendValue} removes this limitation.
437      *
438      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
439      *
440      * IMPORTANT: because control is transferred to `recipient`, care must be
441      * taken to not create reentrancy vulnerabilities. Consider using
442      * {ReentrancyGuard} or the
443      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
444      *
445      * _Available since v2.4.0._
446      */
447     function sendValue(address payable recipient, uint256 amount) internal {
448         require(address(this).balance >= amount, "Address: insufficient balance");
449 
450         // solhint-disable-next-line avoid-call-value
451         (bool success, ) = recipient.call.value(amount)("");
452         require(success, "Address: unable to send value, recipient may have reverted");
453     }
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
457 
458 pragma solidity ^0.5.0;
459 
460 
461 
462 
463 /**
464  * @title SafeERC20
465  * @dev Wrappers around ERC20 operations that throw on failure (when the token
466  * contract returns false). Tokens that return no value (and instead revert or
467  * throw on failure) are also supported, non-reverting calls are assumed to be
468  * successful.
469  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
470  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
471  */
472 library SafeERC20 {
473     using SafeMath for uint256;
474     using Address for address;
475 
476     function safeTransfer(IERC20 token, address to, uint256 value) internal {
477         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
478     }
479 
480     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
481         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
482     }
483 
484     function safeApprove(IERC20 token, address spender, uint256 value) internal {
485         // safeApprove should only be called when setting an initial allowance,
486         // or when resetting it to zero. To increase and decrease it, use
487         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
488         // solhint-disable-next-line max-line-length
489         require((value == 0) || (token.allowance(address(this), spender) == 0),
490             "SafeERC20: approve from non-zero to non-zero allowance"
491         );
492         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
493     }
494 
495     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
496         uint256 newAllowance = token.allowance(address(this), spender).add(value);
497         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
498     }
499 
500     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
501         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
502         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
503     }
504 
505     /**
506      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
507      * on the return value: the return value is optional (but if data is returned, it must not be false).
508      * @param token The token targeted by the call.
509      * @param data The call data (encoded using abi.encode or one of its variants).
510      */
511     function callOptionalReturn(IERC20 token, bytes memory data) private {
512         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
513         // we're implementing it ourselves.
514 
515         // A Solidity high level call has three parts:
516         //  1. The target address is checked to verify it contains contract code
517         //  2. The call itself is made, and success asserted
518         //  3. The return value is decoded, which in turn checks the size of the returned data.
519         // solhint-disable-next-line max-line-length
520         require(address(token).isContract(), "SafeERC20: call to non-contract");
521 
522         // solhint-disable-next-line avoid-low-level-calls
523         (bool success, bytes memory returndata) = address(token).call(data);
524         require(success, "SafeERC20: low-level call failed");
525 
526         if (returndata.length > 0) { // Return data is optional
527             // solhint-disable-next-line max-line-length
528             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
529         }
530     }
531 }
532 
533 // File: contracts/IRewardDistributionRecipient.sol
534 
535 pragma solidity ^0.5.0;
536 
537 
538 
539 contract IRewardDistributionRecipient is Ownable {
540     address rewardDistribution;
541 
542     function notifyRewardAmount(uint256 reward) external;
543 
544     modifier onlyRewardDistribution() {
545         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
546         _;
547     }
548 
549     function setRewardDistribution(address _rewardDistribution)
550         external
551         onlyOwner
552     {
553         rewardDistribution = _rewardDistribution;
554     }
555 }
556 
557 // File: contracts/PctPool.sol
558 
559 pragma solidity ^0.5.0;
560 
561 
562 
563 
564 
565 
566 contract LPTokenWrapper {
567     using SafeMath for uint256;
568     using SafeERC20 for IERC20;
569 
570     IERC20 public stakeToken;
571 
572     uint256 private _totalSupply;
573     mapping(address => uint256) private _balances;
574 
575     constructor(address stakeTokenAddress) public {
576         stakeToken = IERC20(stakeTokenAddress);
577     }
578 
579     function totalSupply() public view returns (uint256) {
580         return _totalSupply;
581     }
582 
583     function balanceOf(address account) public view returns (uint256) {
584         return _balances[account];
585     }
586 
587     function stake(uint256 amount) public {
588         _totalSupply = _totalSupply.add(amount);
589         _balances[msg.sender] = _balances[msg.sender].add(amount);
590         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
591     }
592 
593     function withdraw(uint256 amount) public {
594         _totalSupply = _totalSupply.sub(amount);
595         _balances[msg.sender] = _balances[msg.sender].sub(amount);
596         stakeToken.safeTransfer(msg.sender, amount);
597     }
598 }
599 
600 contract PctPool is LPTokenWrapper, IRewardDistributionRecipient {
601     IERC20 public pct;
602     uint256 public constant DURATION = 14 days;
603 
604     uint256 public periodFinish = 0;
605     uint256 public rewardRate = 0;
606     uint256 public lastUpdateTime;
607     uint256 public rewardPerTokenStored;
608     mapping(address => uint256) public userRewardPerTokenPaid;
609     mapping(address => uint256) public rewards;
610 
611     constructor(address pctAddress, address stakeTokenAddress) LPTokenWrapper(stakeTokenAddress) public {
612         rewardDistribution = msg.sender;
613         pct = IERC20(pctAddress);
614     }
615 
616     event RewardAdded(uint256 reward);
617     event Staked(address indexed user, uint256 amount);
618     event Withdrawn(address indexed user, uint256 amount);
619     event RewardPaid(address indexed user, uint256 reward);
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
631     function lastTimeRewardApplicable() public view returns (uint256) {
632         return Math.min(block.timestamp, periodFinish);
633     }
634 
635     function rewardPerToken() public view returns (uint256) {
636         if (totalSupply() == 0) {
637             return rewardPerTokenStored;
638         }
639         return
640             rewardPerTokenStored.add(
641                 lastTimeRewardApplicable()
642                     .sub(lastUpdateTime)
643                     .mul(rewardRate)
644                     .mul(1e18)
645                     .div(totalSupply())
646             );
647     }
648 
649     function earned(address account) public view returns (uint256) {
650         return
651             balanceOf(account)
652                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
653                 .div(1e18)
654                 .add(rewards[account]);
655     }
656 
657     // stake visibility is public as overriding LPTokenWrapper's stake() function
658     function stake(uint256 amount) public updateReward(msg.sender) {
659         require(amount > 0, "Cannot stake 0");
660         super.stake(amount);
661         emit Staked(msg.sender, amount);
662     }
663 
664     function withdraw(uint256 amount) public updateReward(msg.sender) {
665         require(amount > 0, "Cannot withdraw 0");
666         super.withdraw(amount);
667         emit Withdrawn(msg.sender, amount);
668     }
669 
670     function exit() external {
671         withdraw(balanceOf(msg.sender));
672         getReward();
673     }
674 
675     function getReward() public updateReward(msg.sender) {
676         uint256 reward = earned(msg.sender);
677         if (reward > 0) {
678             rewards[msg.sender] = 0;
679             pct.safeTransfer(msg.sender, reward);
680             emit RewardPaid(msg.sender, reward);
681         }
682     }
683 
684     function notifyRewardAmount(uint256 reward)
685         external
686         onlyRewardDistribution
687         updateReward(address(0))
688     {
689         if (block.timestamp >= periodFinish) {
690             rewardRate = reward.div(DURATION);
691         } else {
692             uint256 remaining = periodFinish.sub(block.timestamp);
693             uint256 leftover = remaining.mul(rewardRate);
694             rewardRate = reward.add(leftover).div(DURATION);
695         }
696         lastUpdateTime = block.timestamp;
697         periodFinish = block.timestamp.add(DURATION);
698         emit RewardAdded(reward);
699     }
700 }