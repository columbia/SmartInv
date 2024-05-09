1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-26
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
16 * Synthetix: YFIRewards.sol
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
370     function mint(address account, uint amount) external;
371 
372     /**
373      * @dev Returns the remaining number of tokens that `spender` will be
374      * allowed to spend on behalf of `owner` through {transferFrom}. This is
375      * zero by default.
376      *
377      * This value changes when {approve} or {transferFrom} are called.
378      */
379     function allowance(address owner, address spender) external view returns (uint256);
380 
381     /**
382      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * IMPORTANT: Beware that changing an allowance with this method brings the risk
387      * that someone may use both the old and the new allowance by unfortunate
388      * transaction ordering. One possible solution to mitigate this race
389      * condition is to first reduce the spender's allowance to 0 and set the
390      * desired value afterwards:
391      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
392      *
393      * Emits an {Approval} event.
394      */
395     function approve(address spender, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Moves `amount` tokens from `sender` to `recipient` using the
399      * allowance mechanism. `amount` is then deducted from the caller's
400      * allowance.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Emitted when `value` tokens are moved from one account (`from`) to
410      * another (`to`).
411      *
412      * Note that `value` may be zero.
413      */
414     event Transfer(address indexed from, address indexed to, uint256 value);
415 
416     /**
417      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
418      * a call to {approve}. `value` is the new allowance.
419      */
420     event Approval(address indexed owner, address indexed spender, uint256 value);
421 }
422 
423 // File: @openzeppelin/contracts/utils/Address.sol
424 
425 pragma solidity ^0.5.5;
426 
427 /**
428  * @dev Collection of functions related to the address type
429  */
430 library Address {
431     /**
432      * @dev Returns true if `account` is a contract.
433      *
434      * This test is non-exhaustive, and there may be false-negatives: during the
435      * execution of a contract's constructor, its address will be reported as
436      * not containing a contract.
437      *
438      * IMPORTANT: It is unsafe to assume that an address for which this
439      * function returns false is an externally-owned account (EOA) and not a
440      * contract.
441      */
442     function isContract(address account) internal view returns (bool) {
443         // This method relies in extcodesize, which returns 0 for contracts in
444         // construction, since the code is only stored at the end of the
445         // constructor execution.
446 
447         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
448         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
449         // for accounts without code, i.e. `keccak256('')`
450         bytes32 codehash;
451         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
452         // solhint-disable-next-line no-inline-assembly
453         assembly { codehash := extcodehash(account) }
454         return (codehash != 0x0 && codehash != accountHash);
455     }
456 
457     /**
458      * @dev Converts an `address` into `address payable`. Note that this is
459      * simply a type cast: the actual underlying value is not changed.
460      *
461      * _Available since v2.4.0._
462      */
463     function toPayable(address account) internal pure returns (address payable) {
464         return address(uint160(account));
465     }
466 
467     /**
468      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
469      * `recipient`, forwarding all available gas and reverting on errors.
470      *
471      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
472      * of certain opcodes, possibly making contracts go over the 2300 gas limit
473      * imposed by `transfer`, making them unable to receive funds via
474      * `transfer`. {sendValue} removes this limitation.
475      *
476      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
477      *
478      * IMPORTANT: because control is transferred to `recipient`, care must be
479      * taken to not create reentrancy vulnerabilities. Consider using
480      * {ReentrancyGuard} or the
481      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
482      *
483      * _Available since v2.4.0._
484      */
485     function sendValue(address payable recipient, uint256 amount) internal {
486         require(address(this).balance >= amount, "Address: insufficient balance");
487 
488         // solhint-disable-next-line avoid-call-value
489         (bool success, ) = recipient.call.value(amount)("");
490         require(success, "Address: unable to send value, recipient may have reverted");
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
495 
496 pragma solidity ^0.5.0;
497 
498 
499 
500 
501 /**
502  * @title SafeERC20
503  * @dev Wrappers around ERC20 operations that throw on failure (when the token
504  * contract returns false). Tokens that return no value (and instead revert or
505  * throw on failure) are also supported, non-reverting calls are assumed to be
506  * successful.
507  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
508  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
509  */
510 library SafeERC20 {
511     using SafeMath for uint256;
512     using Address for address;
513 
514     function safeTransfer(IERC20 token, address to, uint256 value) internal {
515         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
516     }
517 
518     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
519         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
520     }
521 
522     function safeApprove(IERC20 token, address spender, uint256 value) internal {
523         // safeApprove should only be called when setting an initial allowance,
524         // or when resetting it to zero. To increase and decrease it, use
525         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
526         // solhint-disable-next-line max-line-length
527         require((value == 0) || (token.allowance(address(this), spender) == 0),
528             "SafeERC20: approve from non-zero to non-zero allowance"
529         );
530         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
531     }
532 
533     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).add(value);
535         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
540         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     /**
544      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
545      * on the return value: the return value is optional (but if data is returned, it must not be false).
546      * @param token The token targeted by the call.
547      * @param data The call data (encoded using abi.encode or one of its variants).
548      */
549     function callOptionalReturn(IERC20 token, bytes memory data) private {
550         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
551         // we're implementing it ourselves.
552 
553         // A Solidity high level call has three parts:
554         //  1. The target address is checked to verify it contains contract code
555         //  2. The call itself is made, and success asserted
556         //  3. The return value is decoded, which in turn checks the size of the returned data.
557         // solhint-disable-next-line max-line-length
558         require(address(token).isContract(), "SafeERC20: call to non-contract");
559 
560         // solhint-disable-next-line avoid-low-level-calls
561         (bool success, bytes memory returndata) = address(token).call(data);
562         require(success, "SafeERC20: low-level call failed");
563 
564         if (returndata.length > 0) { // Return data is optional
565             // solhint-disable-next-line max-line-length
566             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
567         }
568     }
569 }
570 
571 // File: contracts/IRewardDistributionRecipient.sol
572 
573 pragma solidity ^0.5.0;
574 
575 
576 
577 contract IRewardDistributionRecipient is Ownable {
578     address rewardDistribution;
579 
580     function notifyRewardAmount(uint256 reward) external;
581 
582     modifier onlyRewardDistribution() {
583         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
584         _;
585     }
586 
587     function setRewardDistribution(address _rewardDistribution)
588         external
589         onlyOwner
590     {
591         rewardDistribution = _rewardDistribution;
592     }
593 }
594 
595 // File: contracts/CurveRewards.sol
596 
597 pragma solidity ^0.5.0;
598 
599 contract LPTokenWrapper {
600     using SafeMath for uint256;
601     using SafeERC20 for IERC20;
602 
603     IERC20 public uni_curry_eth_lp = IERC20(0xfA695fE220C02c8B61716E819E68Fb18f2038a4D);
604 
605     uint256 private _totalSupply;
606     mapping(address => uint256) private _balances;
607 
608     function totalSupply() public view returns (uint256) {
609         return _totalSupply;
610     }
611 
612     function balanceOf(address account) public view returns (uint256) {
613         return _balances[account];
614     }
615 
616     function stake(uint256 amount) public {
617         _totalSupply = _totalSupply.add(amount);
618         _balances[msg.sender] = _balances[msg.sender].add(amount);
619         uni_curry_eth_lp.safeTransferFrom(msg.sender, address(this), amount);
620     }
621 
622     function withdraw(uint256 amount) public {
623         _totalSupply = _totalSupply.sub(amount);
624         _balances[msg.sender] = _balances[msg.sender].sub(amount);
625         uni_curry_eth_lp.safeTransfer(msg.sender, amount);
626     }
627 }
628 
629 contract UNICURRYETHRewards is LPTokenWrapper, IRewardDistributionRecipient {
630     IERC20 public curry = IERC20(0x89494C685E06d18ff0c65F9e756976EdAa6E806a);
631     uint256 public constant DURATION = 7 days;
632 
633     uint256 public initreward = 6250*1e18;
634     uint256 public starttime = 1602824400; //utc+8 2020 10-16 13:00:00
635     uint256 public periodFinish = 0;
636     uint256 public rewardRate = 0;
637     uint256 public lastUpdateTime;
638     uint256 public rewardPerTokenStored;
639     mapping(address => uint256) public userRewardPerTokenPaid;
640     mapping(address => uint256) public rewards;
641 
642     event RewardAdded(uint256 reward);
643     event Staked(address indexed user, uint256 amount);
644     event Withdrawn(address indexed user, uint256 amount);
645     event RewardPaid(address indexed user, uint256 reward);
646 
647     modifier updateReward(address account) {
648         rewardPerTokenStored = rewardPerToken();
649         lastUpdateTime = lastTimeRewardApplicable();
650         if (account != address(0)) {
651             rewards[account] = earned(account);
652             userRewardPerTokenPaid[account] = rewardPerTokenStored;
653         }
654         _;
655     }
656 
657     function lastTimeRewardApplicable() public view returns (uint256) {
658         return Math.min(block.timestamp, periodFinish);
659     }
660 
661     function rewardPerToken() public view returns (uint256) {
662         if (totalSupply() == 0) {
663             return rewardPerTokenStored;
664         }
665         return
666             rewardPerTokenStored.add(
667                 lastTimeRewardApplicable()
668                     .sub(lastUpdateTime)
669                     .mul(rewardRate)
670                     .mul(1e18)
671                     .div(totalSupply())
672             );
673     }
674 
675     function earned(address account) public view returns (uint256) {
676         return
677             balanceOf(account)
678                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
679                 .div(1e18)
680                 .add(rewards[account]);
681     }
682 
683     // stake visibility is public as overriding LPTokenWrapper's stake() function
684     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{ 
685         require(amount > 0, "Cannot stake 0");
686         super.stake(amount);
687         emit Staked(msg.sender, amount);
688     }
689 
690     function withdraw(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
691         require(amount > 0, "Cannot withdraw 0");
692         super.withdraw(amount);
693         emit Withdrawn(msg.sender, amount);
694     }
695 
696     function exit() external {
697         withdraw(balanceOf(msg.sender));
698         getReward();
699     }
700 
701     function getReward() public updateReward(msg.sender) checkhalve checkStart{
702         uint256 reward = earned(msg.sender);
703         if (reward > 0) {
704             rewards[msg.sender] = 0;
705             curry.safeTransfer(msg.sender, reward);
706             emit RewardPaid(msg.sender, reward);
707         }
708     }
709 
710     modifier checkhalve(){
711         if (block.timestamp >= periodFinish) {
712             initreward = initreward.mul(50).div(100); 
713             curry.mint(address(this),initreward);
714 
715             rewardRate = initreward.div(DURATION);
716             periodFinish = block.timestamp.add(DURATION);
717             emit RewardAdded(initreward);
718         }
719         _;
720     }
721     modifier checkStart(){
722         require(block.timestamp > starttime,"not start");
723         _;
724     }
725 
726     function notifyRewardAmount(uint256 reward)
727         external
728         onlyRewardDistribution
729         updateReward(address(0))
730     {
731         if (block.timestamp >= periodFinish) {
732             rewardRate = reward.div(DURATION);
733         } else {
734             uint256 remaining = periodFinish.sub(block.timestamp);
735             uint256 leftover = remaining.mul(rewardRate);
736             rewardRate = reward.add(leftover).div(DURATION);
737         }
738         curry.mint(address(this),reward);
739         lastUpdateTime = block.timestamp;
740         periodFinish = block.timestamp.add(DURATION);
741         emit RewardAdded(reward);
742     }
743 }