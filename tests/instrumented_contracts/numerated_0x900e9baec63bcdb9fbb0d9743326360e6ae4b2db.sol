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
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 Synthetix
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 pragma solidity ^0.5.0;
37 
38 /**
39  * @dev Standard math utilities missing in the Solidity language.
40  */
41 library Math {
42     /**
43      * @dev Returns the largest of two numbers.
44      */
45     function max(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a >= b ? a : b;
47     }
48 
49     /**
50      * @dev Returns the smallest of two numbers.
51      */
52     function min(uint256 a, uint256 b) internal pure returns (uint256) {
53         return a < b ? a : b;
54     }
55 
56     /**
57      * @dev Returns the average of two numbers. The result is rounded towards
58      * zero.
59      */
60     function average(uint256 a, uint256 b) internal pure returns (uint256) {
61         // (a + b) / 2 can overflow, so we distribute
62         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
63     }
64 }
65 
66 /**
67  * @dev Wrappers over Solidity's arithmetic operations with added overflow
68  * checks.
69  *
70  * Arithmetic operations in Solidity wrap on overflow. This can easily result
71  * in bugs, because programmers usually assume that an overflow raises an
72  * error, which is the standard behavior in high level programming languages.
73  * `SafeMath` restores this intuition by reverting the transaction when an
74  * operation overflows.
75  *
76  * Using this library instead of the unchecked operations eliminates an entire
77  * class of bugs, so it's recommended to use it always.
78  */
79 library SafeMath {
80     /**
81      * @dev Returns the addition of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      *
118      * _Available since v2.4.0._
119      */
120     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b <= a, errorMessage);
122         uint256 c = a - b;
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return div(a, b, "SafeMath: division by zero");
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      *
176      * _Available since v2.4.0._
177      */
178     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         // Solidity only automatically asserts when dividing by 0
180         require(b > 0, errorMessage);
181         uint256 c = a / b;
182         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
189      * Reverts when dividing by zero.
190      *
191      * Counterpart to Solidity's `%` operator. This function uses a `revert`
192      * opcode (which leaves remaining gas untouched) while Solidity uses an
193      * invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      * - The divisor cannot be zero.
197      */
198     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
199         return mod(a, b, "SafeMath: modulo by zero");
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts with custom message when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      *
213      * _Available since v2.4.0._
214      */
215     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b != 0, errorMessage);
217         return a % b;
218     }
219 }
220 
221 // File: @openzeppelin/contracts/GSN/Context.sol
222 
223 pragma solidity ^0.5.0;
224 
225 /*
226  * @dev Provides information about the current execution context, including the
227  * sender of the transaction and its data. While these are generally available
228  * via msg.sender and msg.data, they should not be accessed in such a direct
229  * manner, since when dealing with GSN meta-transactions the account sending and
230  * paying for execution may not be the actual sender (as far as an application
231  * is concerned).
232  *
233  * This contract is only required for intermediate, library-like contracts.
234  */
235 contract Context {
236     // Empty internal constructor, to prevent people from mistakenly deploying
237     // an instance of this contract, which should be used via inheritance.
238     constructor () internal { }
239     // solhint-disable-previous-line no-empty-blocks
240 
241     function _msgSender() internal view returns (address payable) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view returns (bytes memory) {
246         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
247         return msg.data;
248     }
249 }
250 
251 // File: @openzeppelin/contracts/ownership/Ownable.sol
252 
253 pragma solidity ^0.5.0;
254 
255 /**
256  * @dev Contract module which provides a basic access control mechanism, where
257  * there is an account (an owner) that can be granted exclusive access to
258  * specific functions.
259  *
260  * This module is used through inheritance. It will make available the modifier
261  * `onlyOwner`, which can be applied to your functions to restrict their use to
262  * the owner.
263  */
264 contract Ownable is Context {
265     address private _owner;
266 
267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
268 
269     /**
270      * @dev Initializes the contract setting the deployer as the initial owner.
271      */
272     constructor () internal {
273         _owner = _msgSender();
274         emit OwnershipTransferred(address(0), _owner);
275     }
276 
277     /**
278      * @dev Returns the address of the current owner.
279      */
280     function owner() public view returns (address) {
281         return _owner;
282     }
283 
284     /**
285      * @dev Throws if called by any account other than the owner.
286      */
287     modifier onlyOwner() {
288         require(isOwner(), "Ownable: caller is not the owner");
289         _;
290     }
291 
292     /**
293      * @dev Returns true if the caller is the current owner.
294      */
295     function isOwner() public view returns (bool) {
296         return _msgSender() == _owner;
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public onlyOwner {
307         emit OwnershipTransferred(_owner, address(0));
308         _owner = address(0);
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      * Can only be called by the current owner.
314      */
315     function transferOwnership(address newOwner) public onlyOwner {
316         _transferOwnership(newOwner);
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      */
322     function _transferOwnership(address newOwner) internal {
323         require(newOwner != address(0), "Ownable: new owner is the zero address");
324         emit OwnershipTransferred(_owner, newOwner);
325         _owner = newOwner;
326     }
327 }
328 
329 /**
330  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
331  * the optional functions; to access them see {ERC20Detailed}.
332  */
333 interface IERC20 {
334     /**
335      * @dev Returns the amount of tokens in existence.
336      */
337     function totalSupply() external view returns (uint256);
338 
339     /**
340      * @dev Returns the amount of tokens owned by `account`.
341      */
342     function balanceOf(address account) external view returns (uint256);
343 
344     /**
345      * @dev Moves `amount` tokens from the caller's account to `recipient`.
346      *
347      * Returns a boolean value indicating whether the operation succeeded.
348      *
349      * Emits a {Transfer} event.
350      */
351     function transfer(address recipient, uint256 amount) external returns (bool);
352 
353     /**
354      * @dev Returns the remaining number of tokens that `spender` will be
355      * allowed to spend on behalf of `owner` through {transferFrom}. This is
356      * zero by default.
357      *
358      * This value changes when {approve} or {transferFrom} are called.
359      */
360     function allowance(address owner, address spender) external view returns (uint256);
361 
362     /**
363      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * IMPORTANT: Beware that changing an allowance with this method brings the risk
368      * that someone may use both the old and the new allowance by unfortunate
369      * transaction ordering. One possible solution to mitigate this race
370      * condition is to first reduce the spender's allowance to 0 and set the
371      * desired value afterwards:
372      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
373      *
374      * Emits an {Approval} event.
375      */
376     function approve(address spender, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Moves `amount` tokens from `sender` to `recipient` using the
380      * allowance mechanism. `amount` is then deducted from the caller's
381      * allowance.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
388 
389     /**
390      * @dev Emitted when `value` tokens are moved from one account (`from`) to
391      * another (`to`).
392      *
393      * Note that `value` may be zero.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 value);
396 
397     /**
398      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
399      * a call to {approve}. `value` is the new allowance.
400      */
401     event Approval(address indexed owner, address indexed spender, uint256 value);
402 }
403 
404 /**
405  * @dev Collection of functions related to the address type
406  */
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * This test is non-exhaustive, and there may be false-negatives: during the
412      * execution of a contract's constructor, its address will be reported as
413      * not containing a contract.
414      *
415      * IMPORTANT: It is unsafe to assume that an address for which this
416      * function returns false is an externally-owned account (EOA) and not a
417      * contract.
418      */
419     function isContract(address account) internal view returns (bool) {
420         // This method relies in extcodesize, which returns 0 for contracts in
421         // construction, since the code is only stored at the end of the
422         // constructor execution.
423 
424         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
425         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
426         // for accounts without code, i.e. `keccak256('')`
427         bytes32 codehash;
428         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
429         // solhint-disable-next-line no-inline-assembly
430         assembly { codehash := extcodehash(account) }
431         return (codehash != 0x0 && codehash != accountHash);
432     }
433 
434     /**
435      * @dev Converts an `address` into `address payable`. Note that this is
436      * simply a type cast: the actual underlying value is not changed.
437      *
438      * _Available since v2.4.0._
439      */
440     function toPayable(address account) internal pure returns (address payable) {
441         return address(uint160(account));
442     }
443 
444     /**
445      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
446      * `recipient`, forwarding all available gas and reverting on errors.
447      *
448      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
449      * of certain opcodes, possibly making contracts go over the 2300 gas limit
450      * imposed by `transfer`, making them unable to receive funds via
451      * `transfer`. {sendValue} removes this limitation.
452      *
453      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
454      *
455      * IMPORTANT: because control is transferred to `recipient`, care must be
456      * taken to not create reentrancy vulnerabilities. Consider using
457      * {ReentrancyGuard} or the
458      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
459      *
460      * _Available since v2.4.0._
461      */
462     function sendValue(address payable recipient, uint256 amount) internal {
463         require(address(this).balance >= amount, "Address: insufficient balance");
464 
465         // solhint-disable-next-line avoid-call-value
466         (bool success, ) = recipient.call.value(amount)("");
467         require(success, "Address: unable to send value, recipient may have reverted");
468     }
469 }
470 
471 /**
472  * @title SafeERC20
473  * @dev Wrappers around ERC20 operations that throw on failure (when the token
474  * contract returns false). Tokens that return no value (and instead revert or
475  * throw on failure) are also supported, non-reverting calls are assumed to be
476  * successful.
477  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
478  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
479  */
480 library SafeERC20 {
481     using SafeMath for uint256;
482     using Address for address;
483 
484     function safeTransfer(IERC20 token, address to, uint256 value) internal {
485         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
486     }
487 
488     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
489         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
490     }
491 
492     function safeApprove(IERC20 token, address spender, uint256 value) internal {
493         // safeApprove should only be called when setting an initial allowance,
494         // or when resetting it to zero. To increase and decrease it, use
495         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
496         // solhint-disable-next-line max-line-length
497         require((value == 0) || (token.allowance(address(this), spender) == 0),
498             "SafeERC20: approve from non-zero to non-zero allowance"
499         );
500         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
501     }
502 
503     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
504         uint256 newAllowance = token.allowance(address(this), spender).add(value);
505         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
506     }
507 
508     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
509         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
510         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
511     }
512 
513     /**
514      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
515      * on the return value: the return value is optional (but if data is returned, it must not be false).
516      * @param token The token targeted by the call.
517      * @param data The call data (encoded using abi.encode or one of its variants).
518      */
519     function callOptionalReturn(IERC20 token, bytes memory data) private {
520         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
521         // we're implementing it ourselves.
522 
523         // A Solidity high level call has three parts:
524         //  1. The target address is checked to verify it contains contract code
525         //  2. The call itself is made, and success asserted
526         //  3. The return value is decoded, which in turn checks the size of the returned data.
527         // solhint-disable-next-line max-line-length
528         require(address(token).isContract(), "SafeERC20: call to non-contract");
529 
530         // solhint-disable-next-line avoid-low-level-calls
531         (bool success, bytes memory returndata) = address(token).call(data);
532         require(success, "SafeERC20: low-level call failed");
533 
534         if (returndata.length > 0) { // Return data is optional
535             // solhint-disable-next-line max-line-length
536             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
537         }
538     }
539 }
540 
541 
542 contract IRewardDistributionRecipient is Ownable {
543     address rewardDistribution;
544 
545     function notifyRewardAmount(uint256 reward) external;
546 
547     modifier onlyRewardDistribution() {
548         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
549         _;
550     }
551 
552     function setRewardDistribution(address _rewardDistribution)
553     external
554     onlyOwner
555     {
556         rewardDistribution = _rewardDistribution;
557     }
558 }
559 
560 
561 contract LPTokenWrapper {
562     using SafeMath for uint256;
563     using SafeERC20 for IERC20;
564 
565     IERC20 public rewardToken = IERC20(0x6c4B85CaB20c13aF72766025F0e17E0fe558A553);
566 
567     uint256 private _totalSupply;
568     mapping(address => uint256) private _balances;
569 
570     function totalSupply() public view returns (uint256) {
571         return _totalSupply;
572     }
573 
574     function balanceOf(address account) public view returns (uint256) {
575         return _balances[account];
576     }
577 
578     function stake(uint256 amount) public {
579         _totalSupply = _totalSupply.add(amount);
580         _balances[msg.sender] = _balances[msg.sender].add(amount);
581         rewardToken.safeTransferFrom(msg.sender, address(this), amount);
582     }
583 
584     function withdraw(uint256 amount) public {
585         _totalSupply = _totalSupply.sub(amount);
586         _balances[msg.sender] = _balances[msg.sender].sub(amount);
587         rewardToken.safeTransfer(msg.sender, amount);
588     }
589 }
590 
591 contract YearnRewards is LPTokenWrapper, IRewardDistributionRecipient {
592     IERC20 public yffii = IERC20(0x6c4B85CaB20c13aF72766025F0e17E0fe558A553);
593     uint256 public constant DURATION = 7 days;
594 
595     uint256 public periodFinish = 0;
596     uint256 public rewardRate = 0;
597     uint256 public lastUpdateTime;
598     uint256 public rewardPerTokenStored;
599     mapping(address => uint256) public userRewardPerTokenPaid;
600     mapping(address => uint256) public rewards;
601 
602     event RewardAdded(uint256 reward);
603     event Staked(address indexed user, uint256 amount);
604     event Withdrawn(address indexed user, uint256 amount);
605     event RewardPaid(address indexed user, uint256 reward);
606 
607     modifier updateReward(address account) {
608         rewardPerTokenStored = rewardPerToken();
609         lastUpdateTime = lastTimeRewardApplicable();
610         if (account != address(0)) {
611             rewards[account] = earned(account);
612             userRewardPerTokenPaid[account] = rewardPerTokenStored;
613         }
614         _;
615     }
616 
617     function lastTimeRewardApplicable() public view returns (uint256) {
618         return Math.min(block.timestamp, periodFinish);
619     }
620 
621     function rewardPerToken() public view returns (uint256) {
622         if (totalSupply() == 0) {
623             return rewardPerTokenStored;
624         }
625         return
626         rewardPerTokenStored.add(
627             lastTimeRewardApplicable()
628             .sub(lastUpdateTime)
629             .mul(rewardRate)
630             .mul(1e18)
631             .div(totalSupply())
632         );
633     }
634 
635     function earned(address account) public view returns (uint256) {
636         return
637         balanceOf(account)
638         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
639         .div(1e18)
640         .add(rewards[account]);
641     }
642 
643     // stake visibility is public as overriding LPTokenWrapper's stake() function
644     function stake(uint256 amount) public updateReward(msg.sender) {
645         require(amount > 0, "Cannot stake 0");
646         super.stake(amount);
647         emit Staked(msg.sender, amount);
648     }
649 
650     function withdraw(uint256 amount) public updateReward(msg.sender) {
651         require(amount > 0, "Cannot withdraw 0");
652         super.withdraw(amount);
653         emit Withdrawn(msg.sender, amount);
654     }
655 
656     function exit() external {
657         withdraw(balanceOf(msg.sender));
658         getReward();
659     }
660 
661     function getReward() public updateReward(msg.sender) {
662         uint256 reward = earned(msg.sender);
663         if (reward > 0) {
664             rewards[msg.sender] = 0;
665             yffii.safeTransfer(msg.sender, reward);
666             emit RewardPaid(msg.sender, reward);
667         }
668     }
669 
670     function notifyRewardAmount(uint256 reward)
671     external
672     onlyRewardDistribution
673     updateReward(address(0))
674     {
675         if (block.timestamp >= periodFinish) {
676             rewardRate = reward.div(DURATION);
677         } else {
678             uint256 remaining = periodFinish.sub(block.timestamp);
679             uint256 leftover = remaining.mul(rewardRate);
680             rewardRate = reward.add(leftover).div(DURATION);
681         }
682         lastUpdateTime = block.timestamp;
683         periodFinish = block.timestamp.add(DURATION);
684         emit RewardAdded(reward);
685     }
686 }