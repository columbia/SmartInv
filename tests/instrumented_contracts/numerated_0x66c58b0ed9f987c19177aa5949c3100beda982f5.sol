1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-11
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-07-17
7 */
8 
9 /*
10    ____            __   __        __   _
11   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
12  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
13 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
14      /___/
15 
16 * Synthetix: YAMRewards.sol
17 *
18 * Docs: https://docs.synthetix.io/
19 *
20 *
21 * MIT License
22 * ===========
23 *
24 * Copyright (c) 2020 Synthetix
25 *
26 * Permission is hereby granted, free of charge, to any person obtaining a copy
27 * of this software and associated documentation files (the "Software"), to deal
28 * in the Software without restriction, including without limitation the rights
29 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
30 * copies of the Software, and to permit persons to whom the Software is
31 * furnished to do so, subject to the following conditions:
32 *
33 * The above copyright notice and this permission notice shall be included in all
34 * copies or substantial portions of the Software.
35 *
36 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
37 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
38 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
39 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
40 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
41 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
42 */
43 
44 // File: @openzeppelin/contracts/math/Math.sol
45 
46 pragma solidity ^0.5.0;
47 
48 /**
49  * @dev Standard math utilities missing in the Solidity language.
50  */
51 library Math {
52     /**
53      * @dev Returns the largest of two numbers.
54      */
55     function max(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a >= b ? a : b;
57     }
58 
59     /**
60      * @dev Returns the smallest of two numbers.
61      */
62     function min(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a < b ? a : b;
64     }
65 
66     /**
67      * @dev Returns the average of two numbers. The result is rounded towards
68      * zero.
69      */
70     function average(uint256 a, uint256 b) internal pure returns (uint256) {
71         // (a + b) / 2 can overflow, so we distribute
72         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/math/SafeMath.sol
77 
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      *
132      * _Available since v2.4.0._
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      *
190      * _Available since v2.4.0._
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         // Solidity only automatically asserts when dividing by 0
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      * - The divisor cannot be zero.
226      *
227      * _Available since v2.4.0._
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 // File: @openzeppelin/contracts/GSN/Context.sol
236 
237 pragma solidity ^0.5.0;
238 
239 /*
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with GSN meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 contract Context {
250     // Empty internal constructor, to prevent people from mistakenly deploying
251     // an instance of this contract, which should be used via inheritance.
252     constructor () internal { }
253     // solhint-disable-previous-line no-empty-blocks
254 
255     function _msgSender() internal view returns (address payable) {
256         return msg.sender;
257     }
258 
259     function _msgData() internal view returns (bytes memory) {
260         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
261         return msg.data;
262     }
263 }
264 
265 // File: @openzeppelin/contracts/ownership/Ownable.sol
266 
267 pragma solidity ^0.5.0;
268 
269 /**
270  * @dev Contract module which provides a basic access control mechanism, where
271  * there is an account (an owner) that can be granted exclusive access to
272  * specific functions.
273  *
274  * This module is used through inheritance. It will make available the modifier
275  * `onlyOwner`, which can be applied to your functions to restrict their use to
276  * the owner.
277  */
278 contract Ownable is Context {
279     address private _owner;
280 
281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283     /**
284      * @dev Initializes the contract setting the deployer as the initial owner.
285      */
286     constructor () internal {
287         _owner = _msgSender();
288         emit OwnershipTransferred(address(0), _owner);
289     }
290 
291     /**
292      * @dev Returns the address of the current owner.
293      */
294     function owner() public view returns (address) {
295         return _owner;
296     }
297 
298     /**
299      * @dev Throws if called by any account other than the owner.
300      */
301     modifier onlyOwner() {
302         require(isOwner(), "Ownable: caller is not the owner");
303         _;
304     }
305 
306     /**
307      * @dev Returns true if the caller is the current owner.
308      */
309     function isOwner() public view returns (bool) {
310         return _msgSender() == _owner;
311     }
312 
313     /**
314      * @dev Leaves the contract without owner. It will not be possible to call
315      * `onlyOwner` functions anymore. Can only be called by the current owner.
316      *
317      * NOTE: Renouncing ownership will leave the contract without an owner,
318      * thereby removing any functionality that is only available to the owner.
319      */
320     function renounceOwnership() public onlyOwner {
321         emit OwnershipTransferred(_owner, address(0));
322         _owner = address(0);
323     }
324 
325     /**
326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
327      * Can only be called by the current owner.
328      */
329     function transferOwnership(address newOwner) public onlyOwner {
330         _transferOwnership(newOwner);
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      */
336     function _transferOwnership(address newOwner) internal {
337         require(newOwner != address(0), "Ownable: new owner is the zero address");
338         emit OwnershipTransferred(_owner, newOwner);
339         _owner = newOwner;
340     }
341 }
342 
343 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
344 
345 pragma solidity ^0.5.0;
346 
347 /**
348  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
349  * the optional functions; to access them see {ERC20Detailed}.
350  */
351 interface IERC20 {
352     /**
353      * @dev Returns the amount of tokens in existence.
354      */
355     function totalSupply() external view returns (uint256);
356 
357     /**
358      * @dev Returns the amount of tokens owned by `account`.
359      */
360     function balanceOf(address account) external view returns (uint256);
361 
362     /**
363      * @dev Moves `amount` tokens from the caller's account to `recipient`.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * Emits a {Transfer} event.
368      */
369     function transfer(address recipient, uint256 amount) external returns (bool);
370 
371     /**
372      * @dev Returns the remaining number of tokens that `spender` will be
373      * allowed to spend on behalf of `owner` through {transferFrom}. This is
374      * zero by default.
375      *
376      * This value changes when {approve} or {transferFrom} are called.
377      */
378     function allowance(address owner, address spender) external view returns (uint256);
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * IMPORTANT: Beware that changing an allowance with this method brings the risk
386      * that someone may use both the old and the new allowance by unfortunate
387      * transaction ordering. One possible solution to mitigate this race
388      * condition is to first reduce the spender's allowance to 0 and set the
389      * desired value afterwards:
390      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
391      *
392      * Emits an {Approval} event.
393      */
394     function approve(address spender, uint256 amount) external returns (bool);
395 
396     /**
397      * @dev Moves `amount` tokens from `sender` to `recipient` using the
398      * allowance mechanism. `amount` is then deducted from the caller's
399      * allowance.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Emitted when `value` tokens are moved from one account (`from`) to
409      * another (`to`).
410      *
411      * Note that `value` may be zero.
412      */
413     event Transfer(address indexed from, address indexed to, uint256 value);
414 
415     /**
416      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
417      * a call to {approve}. `value` is the new allowance.
418      */
419     event Approval(address indexed owner, address indexed spender, uint256 value);
420 }
421 
422 // File: @openzeppelin/contracts/utils/Address.sol
423 
424 pragma solidity ^0.5.5;
425 
426 /**
427  * @dev Collection of functions related to the address type
428  */
429 library Address {
430     /**
431      * @dev Returns true if `account` is a contract.
432      *
433      * This test is non-exhaustive, and there may be false-negatives: during the
434      * execution of a contract's constructor, its address will be reported as
435      * not containing a contract.
436      *
437      * IMPORTANT: It is unsafe to assume that an address for which this
438      * function returns false is an externally-owned account (EOA) and not a
439      * contract.
440      */
441     function isContract(address account) internal view returns (bool) {
442         // This method relies in extcodesize, which returns 0 for contracts in
443         // construction, since the code is only stored at the end of the
444         // constructor execution.
445 
446         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
447         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
448         // for accounts without code, i.e. `keccak256('')`
449         bytes32 codehash;
450         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
451         // solhint-disable-next-line no-inline-assembly
452         assembly { codehash := extcodehash(account) }
453         return (codehash != 0x0 && codehash != accountHash);
454     }
455 
456     /**
457      * @dev Converts an `address` into `address payable`. Note that this is
458      * simply a type cast: the actual underlying value is not changed.
459      *
460      * _Available since v2.4.0._
461      */
462     function toPayable(address account) internal pure returns (address payable) {
463         return address(uint160(account));
464     }
465 
466     /**
467      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
468      * `recipient`, forwarding all available gas and reverting on errors.
469      *
470      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
471      * of certain opcodes, possibly making contracts go over the 2300 gas limit
472      * imposed by `transfer`, making them unable to receive funds via
473      * `transfer`. {sendValue} removes this limitation.
474      *
475      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
476      *
477      * IMPORTANT: because control is transferred to `recipient`, care must be
478      * taken to not create reentrancy vulnerabilities. Consider using
479      * {ReentrancyGuard} or the
480      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
481      *
482      * _Available since v2.4.0._
483      */
484     function sendValue(address payable recipient, uint256 amount) internal {
485         require(address(this).balance >= amount, "Address: insufficient balance");
486 
487         // solhint-disable-next-line avoid-call-value
488         (bool success, ) = recipient.call.value(amount)("");
489         require(success, "Address: unable to send value, recipient may have reverted");
490     }
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
494 
495 pragma solidity ^0.5.0;
496 
497 
498 
499 
500 /**
501  * @title SafeERC20
502  * @dev Wrappers around ERC20 operations that throw on failure (when the token
503  * contract returns false). Tokens that return no value (and instead revert or
504  * throw on failure) are also supported, non-reverting calls are assumed to be
505  * successful.
506  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
507  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
508  */
509 library SafeERC20 {
510     using SafeMath for uint256;
511     using Address for address;
512 
513     function safeTransfer(IERC20 token, address to, uint256 value) internal {
514         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
515     }
516 
517     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
518         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
519     }
520 
521     function safeApprove(IERC20 token, address spender, uint256 value) internal {
522         // safeApprove should only be called when setting an initial allowance,
523         // or when resetting it to zero. To increase and decrease it, use
524         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
525         // solhint-disable-next-line max-line-length
526         require((value == 0) || (token.allowance(address(this), spender) == 0),
527             "SafeERC20: approve from non-zero to non-zero allowance"
528         );
529         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
530     }
531 
532     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
533         uint256 newAllowance = token.allowance(address(this), spender).add(value);
534         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
535     }
536 
537     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
538         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
539         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
540     }
541 
542     /**
543      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
544      * on the return value: the return value is optional (but if data is returned, it must not be false).
545      * @param token The token targeted by the call.
546      * @param data The call data (encoded using abi.encode or one of its variants).
547      */
548     function callOptionalReturn(IERC20 token, bytes memory data) private {
549         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
550         // we're implementing it ourselves.
551 
552         // A Solidity high level call has three parts:
553         //  1. The target address is checked to verify it contains contract code
554         //  2. The call itself is made, and success asserted
555         //  3. The return value is decoded, which in turn checks the size of the returned data.
556         // solhint-disable-next-line max-line-length
557         require(address(token).isContract(), "SafeERC20: call to non-contract");
558 
559         // solhint-disable-next-line avoid-low-level-calls
560         (bool success, bytes memory returndata) = address(token).call(data);
561         require(success, "SafeERC20: low-level call failed");
562 
563         if (returndata.length > 0) { // Return data is optional
564             // solhint-disable-next-line max-line-length
565             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
566         }
567     }
568 }
569 
570 // File: contracts/IRewardDistributionRecipient.sol
571 
572 pragma solidity ^0.5.0;
573 
574 
575 
576 contract IRewardDistributionRecipient is Ownable {
577     address public rewardDistribution;
578 
579     function notifyRewardAmount(uint256 reward) external;
580 
581     modifier onlyRewardDistribution() {
582         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
583         _;
584     }
585 
586     function setRewardDistribution(address _rewardDistribution)
587         external
588         onlyOwner
589     {
590         rewardDistribution = _rewardDistribution;
591     }
592 }
593 
594 // File: contracts/CurveRewards.sol
595 
596 pragma solidity ^0.5.0;
597 
598 
599 interface YAM {
600     function yamsScalingFactor() external returns (uint256);
601 }
602 
603 
604 
605 contract LPTokenWrapper {
606     using SafeMath for uint256;
607     using SafeERC20 for IERC20;
608 
609     IERC20 public weth = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
610 
611     uint256 private _totalSupply;
612     mapping(address => uint256) private _balances;
613 
614     function totalSupply() public view returns (uint256) {
615         return _totalSupply;
616     }
617 
618     function balanceOf(address account) public view returns (uint256) {
619         return _balances[account];
620     }
621 
622     function stake(uint256 amount) public {
623         _totalSupply = _totalSupply.add(amount);
624         _balances[msg.sender] = _balances[msg.sender].add(amount);
625         weth.safeTransferFrom(msg.sender, address(this), amount);
626     }
627 
628     function withdraw(uint256 amount) public {
629         _totalSupply = _totalSupply.sub(amount);
630         _balances[msg.sender] = _balances[msg.sender].sub(amount);
631         weth.safeTransfer(msg.sender, amount);
632     }
633 }
634 
635 contract ZOMBIEDAIPool is LPTokenWrapper, IRewardDistributionRecipient {
636     IERC20 public yam = IERC20(0xd55BD2C12B30075b325Bc35aEf0B46363B3818f8);
637     uint256 public DURATION = 259200; // ~3 days
638 
639     uint256 public starttime = 1598263200; // 2020-08-24 10:00:00 (UTC UTC +00:00)
640     uint256 public periodFinish = 0;
641     uint256 public rewardRate = 0;
642     uint256 public lastUpdateTime;
643     uint256 public rewardPerTokenStored;
644     mapping(address => uint256) public userRewardPerTokenPaid;
645     mapping(address => uint256) public rewards;
646 
647     event RewardAdded(uint256 reward);
648     event Staked(address indexed user, uint256 amount);
649     event Withdrawn(address indexed user, uint256 amount);
650     event RewardPaid(address indexed user, uint256 reward);
651 
652     modifier checkStart() {
653         require(block.timestamp >= starttime,"not start");
654         _;
655     }
656 
657     modifier updateReward(address account) {
658         rewardPerTokenStored = rewardPerToken();
659         lastUpdateTime = lastTimeRewardApplicable();
660         if (account != address(0)) {
661             rewards[account] = earned(account);
662             userRewardPerTokenPaid[account] = rewardPerTokenStored;
663         }
664         _;
665     }
666 
667     function lastTimeRewardApplicable() public view returns (uint256) {
668         return Math.min(block.timestamp, periodFinish);
669     }
670 
671     function rewardPerToken() public view returns (uint256) {
672         if (totalSupply() == 0) {
673             return rewardPerTokenStored;
674         }
675         return
676             rewardPerTokenStored.add(
677                 lastTimeRewardApplicable()
678                     .sub(lastUpdateTime)
679                     .mul(rewardRate)
680                     .mul(1e18)
681                     .div(totalSupply())
682             );
683     }
684 
685     function earned(address account) public view returns (uint256) {
686         return
687             balanceOf(account)
688                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
689                 .div(1e18)
690                 .add(rewards[account]);
691     }
692     function change_duration(uint du)public onlyRewardDistribution{
693         DURATION = du;
694     }
695     // stake visibility is public as overriding LPTokenWrapper's stake() function
696     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
697         require(amount > 0, "Cannot stake 0");
698         super.stake(amount);
699         emit Staked(msg.sender, amount);
700     }
701 
702     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
703         require(amount > 0, "Cannot withdraw 0");
704         super.withdraw(amount);
705         emit Withdrawn(msg.sender, amount);
706     }
707 
708     function exit() external {
709         withdraw(balanceOf(msg.sender));
710         getReward();
711     }
712 
713     function getReward() public updateReward(msg.sender) checkStart {
714         uint256 reward = earned(msg.sender);
715         if (reward > 0) {
716             rewards[msg.sender] = 0;
717             uint256 scalingFactor = YAM(address(yam)).yamsScalingFactor();
718             uint256 trueReward = reward.mul(scalingFactor).div(10**18);
719             yam.safeTransfer(msg.sender, trueReward);
720             emit RewardPaid(msg.sender, trueReward);
721         }
722     }
723 
724     function notifyRewardAmount(uint256 reward)
725         external
726         onlyRewardDistribution
727         updateReward(address(0))
728     {
729         if (block.timestamp > starttime) {
730           if (block.timestamp >= periodFinish) {
731               rewardRate = reward.div(DURATION);
732           } else {
733               uint256 remaining = periodFinish.sub(block.timestamp);
734               uint256 leftover = remaining.mul(rewardRate);
735               rewardRate = reward.add(leftover).div(DURATION);
736           }
737           lastUpdateTime = block.timestamp;
738           periodFinish = block.timestamp.add(DURATION);
739           emit RewardAdded(reward);
740         } else {
741           rewardRate = reward.div(DURATION);
742           lastUpdateTime = starttime;
743           periodFinish = starttime.add(DURATION);
744           emit RewardAdded(reward);
745         }
746     }
747 }