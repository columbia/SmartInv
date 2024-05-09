1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 * Synthetix: YFIRewards.sol
8 *
9 * Docs: https://docs.synthetix.io/
10 *
11 *
12 * MIT License
13 * ===========
14 *
15 * Copyright (c) 2020 Synthetix
16 *
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 */
34 
35 // File: @openzeppelin/contracts/math/Math.sol
36 
37 pragma solidity 0.6.0;
38 
39 /**
40  * @dev Standard math utilities missing in the Solidity language.
41  */
42 library Math {
43     /**
44      * @dev Returns the largest of two numbers.
45      */
46     function max(uint256 a, uint256 b) internal pure returns (uint256) {
47         return a >= b ? a : b;
48     }
49 
50     /**
51      * @dev Returns the smallest of two numbers.
52      */
53     function min(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a < b ? a : b;
55     }
56 
57     /**
58      * @dev Returns the average of two numbers. The result is rounded towards
59      * zero.
60      */
61     function average(uint256 a, uint256 b) internal pure returns (uint256) {
62         // (a + b) / 2 can overflow, so we distribute
63         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
64     }
65 }
66 
67 // File: @openzeppelin/contracts/math/SafeMath.sol
68 
69 pragma solidity 0.6.0;
70 
71 /**
72  * @dev Wrappers over Solidity's arithmetic operations with added overflow
73  * checks.
74  *
75  * Arithmetic operations in Solidity wrap on overflow. This can easily result
76  * in bugs, because programmers usually assume that an overflow raises an
77  * error, which is the standard behavior in high level programming languages.
78  * `SafeMath` restores this intuition by reverting the transaction when an
79  * operation overflows.
80  *
81  * Using this library instead of the unchecked operations eliminates an entire
82  * class of bugs, so it's recommended to use it always.
83  */
84 library SafeMath {
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return sub(a, b, "SafeMath: subtraction overflow");
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      *
123      * _Available since v2.4.0._
124      */
125     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
126         require(b <= a, errorMessage);
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `*` operator.
137      *
138      * Requirements:
139      * - Multiplication cannot overflow.
140      */
141     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
143         // benefit is lost if 'b' is also tested.
144         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
145         if (a == 0) {
146             return 0;
147         }
148 
149         uint256 c = a * b;
150         require(c / a == b, "SafeMath: multiplication overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the integer division of two unsigned integers. Reverts on
157      * division by zero. The result is rounded towards zero.
158      *
159      * Counterpart to Solidity's `/` operator. Note: this function uses a
160      * `revert` opcode (which leaves remaining gas untouched) while Solidity
161      * uses an invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         return div(a, b, "SafeMath: division by zero");
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      *
181      * _Available since v2.4.0._
182      */
183     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         // Solidity only automatically asserts when dividing by 0
185         require(b != 0, errorMessage);
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
194      * Reverts when dividing by zero.
195      *
196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
197      * opcode (which leaves remaining gas untouched) while Solidity uses an
198      * invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      */
203     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
204         return mod(a, b, "SafeMath: modulo by zero");
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts with custom message when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      * - The divisor cannot be zero.
217      *
218      * _Available since v2.4.0._
219      */
220     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b != 0, errorMessage);
222         return a % b;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/GSN/Context.sol
227 
228 pragma solidity 0.6.0;
229 
230 /*
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with GSN meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 contract Context {
241     // Empty internal constructor, to prevent people from mistakenly deploying
242     // an instance of this contract, which should be used via inheritance.
243     constructor () internal { }
244     // solhint-disable-previous-line no-empty-blocks
245 
246     function _msgSender() internal view returns (address payable) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view returns (bytes memory) {
251         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
252         return msg.data;
253     }
254 }
255 
256 // File: @openzeppelin/contracts/ownership/Ownable.sol
257 
258 pragma solidity 0.6.0;
259 
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 contract Ownable is Context {
270     address public _owner;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor () internal {
278         _owner = msg.sender;
279         emit OwnershipTransferred(address(0), _owner);
280     }
281 
282     /**
283      * @dev Throws if called by any account other than the owner.
284      */
285     modifier onlyOwner() {
286         require(isOwner(), "Ownable: caller is not the owner");
287         _;
288     }
289 
290     /**
291      * @dev Returns true if the caller is the current owner.
292      */
293     function isOwner() public view returns (bool) {
294         return msg.sender == _owner;
295     }
296 
297     /**
298      * @dev Leaves the contract without owner. It will not be possible to call
299      * `onlyOwner` functions anymore. Can only be called by the current owner.
300      *
301      * NOTE: Renouncing ownership will leave the contract without an owner,
302      * thereby removing any functionality that is only available to the owner.
303      */
304     function renounceOwnership() public onlyOwner {
305         emit OwnershipTransferred(_owner, address(0));
306         _owner = address(0);
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public onlyOwner {
314         _transferOwnership(newOwner);
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      */
320     function _transferOwnership(address newOwner) internal {
321         require(newOwner != address(0), "Ownable: new owner is the zero address");
322         emit OwnershipTransferred(_owner, newOwner);
323         _owner = newOwner;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
328 
329 pragma solidity 0.6.0;
330 
331 /**
332  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
333  * the optional functions; to access them see {ERC20Detailed}.
334  */
335 interface IERC20 {
336     /**
337      * @dev Returns the amount of tokens in existence.
338      */
339     function totalSupply() external view returns (uint256);
340 
341     /**
342      * @dev Returns the amount of tokens owned by `account`.
343      */
344     function balanceOf(address account) external view returns (uint256);
345 
346     /**
347      * @dev Moves `amount` tokens from the caller's account to `recipient`.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transfer(address recipient, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Returns the remaining number of tokens that `spender` will be
357      * allowed to spend on behalf of `owner` through {transferFrom}. This is
358      * zero by default.
359      *
360      * This value changes when {approve} or {transferFrom} are called.
361      */
362     function allowance(address owner, address spender) external view returns (uint256);
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * IMPORTANT: Beware that changing an allowance with this method brings the risk
370      * that someone may use both the old and the new allowance by unfortunate
371      * transaction ordering. One possible solution to mitigate this race
372      * condition is to first reduce the spender's allowance to 0 and set the
373      * desired value afterwards:
374      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
375      *
376      * Emits an {Approval} event.
377      */
378     function approve(address spender, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Moves `amount` tokens from `sender` to `recipient` using the
382      * allowance mechanism. `amount` is then deducted from the caller's
383      * allowance.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Emitted when `value` tokens are moved from one account (`from`) to
393      * another (`to`).
394      *
395      * Note that `value` may be zero.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 value);
398 
399     /**
400      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
401      * a call to {approve}. `value` is the new allowance.
402      */
403     event Approval(address indexed owner, address indexed spender, uint256 value);
404 }
405 
406 // File: @openzeppelin/contracts/utils/Address.sol
407 
408 pragma solidity 0.6.0;
409 
410 /**
411  * @dev Collection of functions related to the address type
412  */
413 library Address {
414     /**
415      * @dev Returns true if `account` is a contract.
416      *
417      * This test is non-exhaustive, and there may be false-negatives: during the
418      * execution of a contract's constructor, its address will be reported as
419      * not containing a contract.
420      *
421      * IMPORTANT: It is unsafe to assume that an address for which this
422      * function returns false is an externally-owned account (EOA) and not a
423      * contract.
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies in extcodesize, which returns 0 for contracts in
427         // construction, since the code is only stored at the end of the
428         // constructor execution.
429 
430         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
431         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
432         // for accounts without code, i.e. `keccak256('')`
433         bytes32 codehash;
434         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
435         // solhint-disable-next-line no-inline-assembly
436         assembly { codehash := extcodehash(account) }
437         return (codehash != 0x0 && codehash != accountHash);
438     }
439 
440     /**
441      * @dev Converts an `address` into `address payable`. Note that this is
442      * simply a type cast: the actual underlying value is not changed.
443      *
444      * _Available since v2.4.0._
445      */
446     function toPayable(address account) internal pure returns (address payable) {
447         return address(uint160(account));
448     }
449 
450     /**
451      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
452      * `recipient`, forwarding all available gas and reverting on errors.
453      *
454      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
455      * of certain opcodes, possibly making contracts go over the 2300 gas limit
456      * imposed by `transfer`, making them unable to receive funds via
457      * `transfer`. {sendValue} removes this limitation.
458      *
459      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
460      *
461      * IMPORTANT: because control is transferred to `recipient`, care must be
462      * taken to not create reentrancy vulnerabilities. Consider using
463      * {ReentrancyGuard} or the
464      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
465      *
466      * _Available since v2.4.0._
467      */
468     function sendValue(address payable recipient, uint256 amount) internal {
469         require(address(this).balance >= amount, "Address: insufficient balance");
470 
471         // solhint-disable-next-line avoid-call-value
472         (bool success, ) = recipient.call.value(amount)("");
473         require(success, "Address: unable to send value, recipient may have reverted");
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
478 
479 pragma solidity 0.6.0;
480 
481 
482 
483 
484 /**
485  * @title SafeERC20
486  * @dev Wrappers around ERC20 operations that throw on failure (when the token
487  * contract returns false). Tokens that return no value (and instead revert or
488  * throw on failure) are also supported, non-reverting calls are assumed to be
489  * successful.
490  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
491  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
492  */
493 library SafeERC20 {
494     using SafeMath for uint256;
495     using Address for address;
496 
497     function safeTransfer(IERC20 token, address to, uint256 value) internal {
498         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
499     }
500 
501     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
502         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
503     }
504 
505     function safeApprove(IERC20 token, address spender, uint256 value) internal {
506         // safeApprove should only be called when setting an initial allowance,
507         // or when resetting it to zero. To increase and decrease it, use
508         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
509         // solhint-disable-next-line max-line-length
510         require((value == 0) || (token.allowance(address(this), spender) == 0),
511             "SafeERC20: approve from non-zero to non-zero allowance"
512         );
513         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
514     }
515 
516     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
517         uint256 newAllowance = token.allowance(address(this), spender).add(value);
518         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
519     }
520 
521     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
522         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
523         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
524     }
525 
526     /**
527      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
528      * on the return value: the return value is optional (but if data is returned, it must not be false).
529      * @param token The token targeted by the call.
530      * @param data The call data (encoded using abi.encode or one of its variants).
531      */
532     function callOptionalReturn(IERC20 token, bytes memory data) private {
533         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
534         // we're implementing it ourselves.
535 
536         // A Solidity high level call has three parts:
537         //  1. The target address is checked to verify it contains contract code
538         //  2. The call itself is made, and success asserted
539         //  3. The return value is decoded, which in turn checks the size of the returned data.
540         // solhint-disable-next-line max-line-length
541         require(address(token).isContract(), "SafeERC20: call to non-contract");
542 
543         // solhint-disable-next-line avoid-low-level-calls
544         (bool success, bytes memory returndata) = address(token).call(data);
545         require(success, "SafeERC20: low-level call failed");
546 
547         if (returndata.length != 0) { // Return data is optional
548             // solhint-disable-next-line max-line-length
549             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
550         }
551     }
552 }
553 
554 // File: contracts/IRewardDistributionRecipient.sol
555 
556 pragma solidity 0.6.0;
557 
558 
559 
560 contract IRewardDistributionRecipient is Ownable {
561     address public rewardDistribution;
562 
563     function notifyRewardAmount(uint256 reward) external virtual {}
564 
565     modifier onlyRewardDistribution() {
566         require(msg.sender == rewardDistribution, "Caller is not reward distribution");
567         _;
568     }
569 
570     function setRewardDistribution(address _rewardDistribution)
571         external
572         onlyOwner
573     {
574         rewardDistribution = _rewardDistribution;
575     }
576 }
577 
578 // File: contracts/CurveRewards.sol
579 
580 pragma solidity 0.6.0;
581 
582 contract LPTokenWrapper {
583     using SafeMath for uint256;
584     using SafeERC20 for IERC20;
585     // Token to be staked
586     IERC20 public stakingToken = IERC20(address(0));
587     address public devFund = 0x3249f8c62640DC8ae2F4Ed14CD03bCA9C6Af98B2;
588 
589     uint256 public _totalSupply;
590     mapping(address => uint256) private _balances;
591 
592     function balanceOf(address account) public view returns (uint256) {
593         return _balances[account];
594     }
595 
596     function stake(uint256 amount) public virtual {
597         _totalSupply = _totalSupply.add(amount);
598         _balances[msg.sender] = _balances[msg.sender].add(amount);
599         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
600     }
601 
602     function withdraw(uint256 amount) public virtual{
603         _totalSupply = _totalSupply.sub(amount);
604         _balances[msg.sender] = _balances[msg.sender].sub(amount);
605         stakingToken.safeTransfer(msg.sender, amount);
606     } 
607     function setBPT(address BPTAddress) internal {
608         stakingToken = IERC20(BPTAddress);
609     }
610 }
611 
612 interface MultiplierInterface {
613   function getTotalMultiplier(address account) external view returns (uint256);
614 }
615 
616 interface CalculateCycle {
617   function calculate(uint256 deployedTime,uint256 currentTime,uint256 duration) external view returns(uint256);
618 }
619 
620 contract NonMintableRewardPool is LPTokenWrapper, IRewardDistributionRecipient {
621     // Token to be rewarded
622     IERC20 public rewardToken = IERC20(address(0));
623     IERC20 public multiplierToken = IERC20(address(0));
624     MultiplierInterface public multiplier = MultiplierInterface(address(0));
625     CalculateCycle public calculateCycle = CalculateCycle(address(0));
626     uint256 public constant DURATION = 14 days;
627 
628     uint256 public periodFinish;
629     uint256 public rewardRate;
630     uint256 public lastUpdateTime;
631     uint256 public rewardPerTokenStored;
632     uint256 public deployedTime;
633     uint256 public constant napsDiscountRange = 8 hours;
634     uint256 public constant napsLevelOneCost = 10000000000000000000000;
635     uint256 public constant napsLevelTwoCost = 20000000000000000000000;
636     uint256 public constant napsLevelThreeCost = 30000000000000000000000;
637     uint256 public constant TenPercentBonus = 1 * 10 ** 17;
638     uint256 public constant TwentyPercentBonus = 2 * 10 ** 17;
639     uint256 public constant ThirtyPercentBonus = 3 * 10 ** 17;
640     uint256 public constant FourtyPercentBonus = 4 * 10 ** 17;
641     
642     mapping(address => uint256) public userRewardPerTokenPaid;
643     mapping(address => uint256) public rewards;
644     mapping(address => uint256) public spentNAPS;
645     mapping(address => uint256) public NAPSlevel;
646 
647     event RewardAdded(uint256 reward);
648     event Staked(address indexed user, uint256 amount);
649     event Withdrawn(address indexed user, uint256 amount);
650     event RewardPaid(address indexed user, uint256 reward);
651     event Boost(uint256 level);
652     modifier updateReward(address account) {
653         rewardPerTokenStored = rewardPerToken();
654         lastUpdateTime = lastTimeRewardApplicable();
655         if (account != address(0)) {
656             rewards[account] = earned(account);
657             userRewardPerTokenPaid[account] = rewardPerTokenStored;
658         }
659         _;
660     }
661     constructor(address _stakingToken,address _rewardToken,address _multiplierToken,address _calculateCycleAddr,address _multiplierAddr) public{
662       setBPT(_stakingToken);
663       rewardToken = IERC20(_rewardToken);
664       multiplierToken = IERC20(_multiplierToken);
665       calculateCycle = CalculateCycle(_calculateCycleAddr);
666       multiplier = MultiplierInterface(_multiplierAddr);
667       deployedTime = block.timestamp;
668     }
669 
670     function lastTimeRewardApplicable() public view returns (uint256) {
671         return Math.min(block.timestamp, periodFinish);
672     }
673 
674     function rewardPerToken() public view returns (uint256) {
675         if (_totalSupply == 0) {
676             return rewardPerTokenStored;
677         }
678         return
679             rewardPerTokenStored.add(
680                 lastTimeRewardApplicable()
681                     .sub(lastUpdateTime)
682                     .mul(rewardRate)
683                     .mul(1e18)
684                     .div(_totalSupply)
685             );
686     }
687 
688     function earned(address account) public view returns (uint256) {
689         return
690             balanceOf(account)
691                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
692                 .mul(getTotalMultiplier(account))
693                 .div(1e18)
694                 .div(1e18)
695                 .add(rewards[account]);
696     }
697 
698     // stake visibility is public as overriding LPTokenWrapper's stake() function
699     function stake(uint256 amount) public override updateReward(msg.sender) {
700         require(amount != 0, "Cannot stake 0");
701         super.stake(amount);
702         emit Staked(msg.sender, amount);
703     }
704 
705     function withdraw(uint256 amount) public override updateReward(msg.sender) {
706         require(amount != 0, "Cannot withdraw 0");
707         super.withdraw(amount);
708         emit Withdrawn(msg.sender, amount);
709     }
710 
711     function exit() external {
712         getReward();
713         withdraw(balanceOf(msg.sender));
714     }
715 
716     function getReward() public updateReward(msg.sender) {
717         uint256 reward = earned(msg.sender);
718         if (reward != 0) {
719             rewards[msg.sender] = 0;
720             rewardToken.safeTransfer(msg.sender, reward.mul(97).div(100));
721             // 3 percent goes back to the dev fund
722             rewardToken.safeTransfer(devFund, reward.mul(3).div(100));
723             emit RewardPaid(msg.sender, reward);
724         }
725     }
726 
727     function notifyRewardAmount(uint256 reward)
728         external
729         override
730         onlyRewardDistribution
731         updateReward(address(0))
732     {
733         if (block.timestamp >= periodFinish) {
734             rewardRate = reward.div(DURATION);
735         } else {
736             uint256 remaining = periodFinish.sub(block.timestamp);
737             uint256 leftover = remaining.mul(rewardRate);
738             rewardRate = reward.add(leftover).div(DURATION);
739         }
740         lastUpdateTime = block.timestamp;
741         periodFinish = block.timestamp.add(DURATION);
742         emit RewardAdded(reward);
743     }
744     function setCycleContract(address _cycleContract) public onlyRewardDistribution {
745         calculateCycle = CalculateCycle(_cycleContract);
746     }
747     // naps stuff
748     function getLevel(address account) external view returns (uint256) {
749         return NAPSlevel[account];
750     }
751 
752     function getSpent(address account) external view returns (uint256) {
753         return spentNAPS[account];
754     }
755     // Returns the number of naps token to boost
756     function calculateCost(uint256 level) public view returns(uint256) {
757         uint256 cycles = calculateCycle.calculate(deployedTime,block.timestamp,napsDiscountRange);
758         // Cap it to 5 times
759         if(cycles > 5) {
760             cycles = 5;
761         }
762         // // cost = initialCost * (0.9)^cycles = initial cost * (9^cycles)/(10^cycles)
763         if (level == 1) {
764             return napsLevelOneCost.mul(9 ** cycles).div(10 ** cycles);
765         }else if(level == 2) {
766             return napsLevelTwoCost.mul(9 ** cycles).div(10 ** cycles);
767         }else if(level ==3) {
768             return napsLevelThreeCost.mul(9 ** cycles).div(10 ** cycles);
769         }
770     }
771     
772     function purchase(uint256 level) external {
773         require(NAPSlevel[msg.sender] <= level,"Cannot downgrade level or same level");
774         uint256 cost = calculateCost(level);
775         uint256 finalCost = cost.sub(spentNAPS[msg.sender]);
776         // Owner dev fund
777         multiplierToken.safeTransferFrom(msg.sender,devFund,finalCost);
778         spentNAPS[msg.sender] = spentNAPS[msg.sender].add(finalCost);
779         NAPSlevel[msg.sender] = level;
780         emit Boost(level);
781     }
782 
783     function setMultiplierAddress(address multiplierAddress) external onlyRewardDistribution {
784       multiplier = MultiplierInterface(multiplierAddress);
785     }
786 
787     function getTotalMultiplier(address account) public view returns (uint256) {
788         uint256 zzzMultiplier = multiplier.getTotalMultiplier(account);
789         uint256 napsMultiplier;
790         if(NAPSlevel[account] == 1) {
791             napsMultiplier = TenPercentBonus;
792         }else if(NAPSlevel[account] == 2) {
793             napsMultiplier = TwentyPercentBonus;
794         }else if(NAPSlevel[account] == 3) {
795             napsMultiplier = FourtyPercentBonus;
796         }
797         return zzzMultiplier.add(napsMultiplier).add(1*10**18);
798     }
799 
800     function eject() external onlyRewardDistribution {
801         require(block.timestamp > periodFinish,"Cannot eject before period finishes");
802         uint256 currBalance = rewardToken.balanceOf(address(this));
803         rewardToken.safeTransfer(devFund,currBalance);
804     }
805 }