1 //SPDX-License-Identifier: MIT
2 /*
3 * MIT License
4 * ===========
5 *
6 * Permission is hereby granted, free of charge, to any person obtaining a copy
7 * of this software and associated documentation files (the "Software"), to deal
8 * in the Software without restriction, including without limitation the rights
9 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 * copies of the Software, and to permit persons to whom the Software is
11 * furnished to do so, subject to the following conditions:
12 *
13 * The above copyright notice and this permission notice shall be included in all
14 * copies or substantial portions of the Software.
15 *
16 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
22 */
23 
24 pragma solidity ^0.5.17;
25 
26 /**
27  * @dev Standard math utilities missing in the Solidity language.
28  */
29 library Math {
30     /**
31      * @dev Returns the largest of two numbers.
32      */
33     function max(uint256 a, uint256 b) internal pure returns (uint256) {
34         return a >= b ? a : b;
35     }
36 
37     /**
38      * @dev Returns the smallest of two numbers.
39      */
40     function min(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a < b ? a : b;
42     }
43 
44     /**
45      * @dev Returns the average of two numbers. The result is rounded towards
46      * zero.
47      */
48     function average(uint256 a, uint256 b) internal pure returns (uint256) {
49         // (a + b) / 2 can overflow, so we distribute
50         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
51     }
52 }
53 
54 pragma solidity ^0.5.17;
55 
56 /**
57  * @dev Wrappers over Solidity's arithmetic operations with added overflow
58  * checks.
59  *
60  * Arithmetic operations in Solidity wrap on overflow. This can easily result
61  * in bugs, because programmers usually assume that an overflow raises an
62  * error, which is the standard behavior in high level programming languages.
63  * `SafeMath` restores this intuition by reverting the transaction when an
64  * operation overflows.
65  *
66  * Using this library instead of the unchecked operations eliminates an entire
67  * class of bugs, so it's recommended to use it always.
68  */
69 library SafeMath {
70     /**
71      * @dev Returns the addition of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `+` operator.
75      *
76      * Requirements:
77      * - Addition cannot overflow.
78      */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      * - Subtraction cannot overflow.
94      */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return sub(a, b, "SafeMath: subtraction overflow");
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      * - Subtraction cannot overflow.
107      *
108      * _Available since v2.4.0._
109      */
110     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `*` operator.
122      *
123      * Requirements:
124      * - Multiplication cannot overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
128         // benefit is lost if 'b' is also tested.
129         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
130         if (a == 0) {
131             return 0;
132         }
133 
134         uint256 c = a * b;
135         require(c / a == b, "SafeMath: multiplication overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the integer division of two unsigned integers. Reverts on
142      * division by zero. The result is rounded towards zero.
143      *
144      * Counterpart to Solidity's `/` operator. Note: this function uses a
145      * `revert` opcode (which leaves remaining gas untouched) while Solidity
146      * uses an invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         return div(a, b, "SafeMath: division by zero");
153     }
154 
155     /**
156      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
157      * division by zero. The result is rounded towards zero.
158      *
159      * Counterpart to Solidity's `/` operator. Note: this function uses a
160      * `revert` opcode (which leaves remaining gas untouched) while Solidity
161      * uses an invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      *
166      * _Available since v2.4.0._
167      */
168     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         // Solidity only automatically asserts when dividing by 0
170         require(b > 0, errorMessage);
171         uint256 c = a / b;
172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      */
188     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
189         return mod(a, b, "SafeMath: modulo by zero");
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
194      * Reverts with custom message when dividing by zero.
195      *
196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
197      * opcode (which leaves remaining gas untouched) while Solidity uses an
198      * invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      *
203      * _Available since v2.4.0._
204      */
205     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b != 0, errorMessage);
207         return a % b;
208     }
209 }
210 
211 pragma solidity ^0.5.17;
212 
213 /*
214  * @dev Provides information about the current execution context, including the
215  * sender of the transaction and its data. While these are generally available
216  * via msg.sender and msg.data, they should not be accessed in such a direct
217  * manner, since when dealing with GSN meta-transactions the account sending and
218  * paying for execution may not be the actual sender (as far as an application
219  * is concerned).
220  *
221  * This contract is only required for intermediate, library-like contracts.
222  */
223 contract Context {
224     // Empty internal constructor, to prevent people from mistakenly deploying
225     // an instance of this contract, which should be used via inheritance.
226     constructor () internal { }
227     // solhint-disable-previous-line no-empty-blocks
228 
229     function _msgSender() internal view returns (address payable) {
230         return msg.sender;
231     }
232 
233     function _msgData() internal view returns (bytes memory) {
234         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
235         return msg.data;
236     }
237 }
238 
239 pragma solidity ^0.5.17;
240 
241 /**
242  * @dev Contract module which provides a basic access control mechanism, where
243  * there is an account (an owner) that can be granted exclusive access to
244  * specific functions.
245  *
246  * This module is used through inheritance. It will make available the modifier
247  * `onlyOwner`, which can be applied to your functions to restrict their use to
248  * the owner.
249  */
250 contract Ownable is Context {
251     address private _owner;
252 
253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
254 
255     /**
256      * @dev Initializes the contract setting the deployer as the initial owner.
257      */
258     constructor () internal {
259         _owner = _msgSender();
260         emit OwnershipTransferred(address(0), _owner);
261     }
262 
263     /**
264      * @dev Returns the address of the current owner.
265      */
266     function owner() public view returns (address) {
267         return _owner;
268     }
269 
270     /**
271      * @dev Throws if called by any account other than the owner.
272      */
273     modifier onlyOwner() {
274         require(isOwner(), "Ownable: caller is not the owner");
275         _;
276     }
277 
278     /**
279      * @dev Returns true if the caller is the current owner.
280      */
281     function isOwner() public view returns (bool) {
282         return _msgSender() == _owner;
283     }
284 
285     /**
286      * @dev Leaves the contract without owner. It will not be possible to call
287      * `onlyOwner` functions anymore. Can only be called by the current owner.
288      *
289      * NOTE: Renouncing ownership will leave the contract without an owner,
290      * thereby removing any functionality that is only available to the owner.
291      */
292     function renounceOwnership() public onlyOwner {
293         emit OwnershipTransferred(_owner, address(0));
294         _owner = address(0);
295     }
296 
297     /**
298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
299      * Can only be called by the current owner.
300      */
301     function transferOwnership(address newOwner) public onlyOwner {
302         _transferOwnership(newOwner);
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      */
308     function _transferOwnership(address newOwner) internal {
309         require(newOwner != address(0), "Ownable: new owner is the zero address");
310         emit OwnershipTransferred(_owner, newOwner);
311         _owner = newOwner;
312     }
313 }
314 
315 pragma solidity ^0.5.17;
316 
317 /**
318  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
319  * the optional functions; to access them see {ERC20Detailed}.
320  */
321 interface IERC20 {
322     /**
323      * @dev Returns the amount of tokens in existence.
324      */
325     function totalSupply() external view returns (uint256);
326 
327     /**
328      * @dev Returns the amount of tokens owned by `account`.
329      */
330     function balanceOf(address account) external view returns (uint256);
331 
332     /**
333      * @dev Moves `amount` tokens from the caller's account to `recipient`.
334      *
335      * Returns a boolean value indicating whether the operation succeeded.
336      *
337      * Emits a {Transfer} event.
338      */
339     function transfer(address recipient, uint256 amount) external returns (bool);
340 
341     /**
342      * @dev Returns the remaining number of tokens that `spender` will be
343      * allowed to spend on behalf of `owner` through {transferFrom}. This is
344      * zero by default.
345      *
346      * This value changes when {approve} or {transferFrom} are called.
347      */
348     function allowance(address owner, address spender) external view returns (uint256);
349 
350     /**
351      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * IMPORTANT: Beware that changing an allowance with this method brings the risk
356      * that someone may use both the old and the new allowance by unfortunate
357      * transaction ordering. One possible solution to mitigate this race
358      * condition is to first reduce the spender's allowance to 0 and set the
359      * desired value afterwards:
360      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
361      *
362      * Emits an {Approval} event.
363      */
364     function approve(address spender, uint256 amount) external returns (bool);
365 
366     /**
367      * @dev Moves `amount` tokens from `sender` to `recipient` using the
368      * allowance mechanism. `amount` is then deducted from the caller's
369      * allowance.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * Emits a {Transfer} event.
374      */
375     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
376 
377     /**
378      * @dev Emitted when `value` tokens are moved from one account (`from`) to
379      * another (`to`).
380      *
381      * Note that `value` may be zero.
382      */
383     event Transfer(address indexed from, address indexed to, uint256 value);
384 
385     /**
386      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
387      * a call to {approve}. `value` is the new allowance.
388      */
389     event Approval(address indexed owner, address indexed spender, uint256 value);
390 }
391 
392 interface IERC20Burnable {
393     function totalSupply() external view returns (uint256);
394     function balanceOf(address account) external view returns (uint256);
395     function transfer(address recipient, uint256 amount) external returns (bool);
396     function allowance(address owner, address spender) external view returns (uint256);
397     function approve(address spender, uint256 amount) external returns (bool);
398     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
399     function burn(uint256 amount) external;
400     event Transfer(address indexed from, address indexed to, uint256 value);
401     event Approval(address indexed owner, address indexed spender, uint256 value);
402 }
403 
404 pragma solidity ^0.5.17;
405 
406 /**
407  * @dev Collection of functions related to the address type
408  */
409 library Address {
410     /**
411      * @dev Returns true if `account` is a contract.
412      *
413      * This test is non-exhaustive, and there may be false-negatives: during the
414      * execution of a contract's constructor, its address will be reported as
415      * not containing a contract.
416      *
417      * IMPORTANT: It is unsafe to assume that an address for which this
418      * function returns false is an externally-owned account (EOA) and not a
419      * contract.
420      */
421     function isContract(address account) internal view returns (bool) {
422         // This method relies in extcodesize, which returns 0 for contracts in
423         // construction, since the code is only stored at the end of the
424         // constructor execution.
425 
426         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
427         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
428         // for accounts without code, i.e. `keccak256('')`
429         bytes32 codehash;
430         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
431         // solhint-disable-next-line no-inline-assembly
432         assembly { codehash := extcodehash(account) }
433         return (codehash != 0x0 && codehash != accountHash);
434     }
435 
436     /**
437      * @dev Converts an `address` into `address payable`. Note that this is
438      * simply a type cast: the actual underlying value is not changed.
439      *
440      * _Available since v2.4.0._
441      */
442     function toPayable(address account) internal pure returns (address payable) {
443         return address(uint160(account));
444     }
445 
446     /**
447      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
448      * `recipient`, forwarding all available gas and reverting on errors.
449      *
450      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
451      * of certain opcodes, possibly making contracts go over the 2300 gas limit
452      * imposed by `transfer`, making them unable to receive funds via
453      * `transfer`. {sendValue} removes this limitation.
454      *
455      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
456      *
457      * IMPORTANT: because control is transferred to `recipient`, care must be
458      * taken to not create reentrancy vulnerabilities. Consider using
459      * {ReentrancyGuard} or the
460      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
461      *
462      * _Available since v2.4.0._
463      */
464     function sendValue(address payable recipient, uint256 amount) internal {
465         require(address(this).balance >= amount, "Address: insufficient balance");
466 
467         // solhint-disable-next-line avoid-call-value
468         (bool success, ) = recipient.call.value(amount)("");
469         require(success, "Address: unable to send value, recipient may have reverted");
470     }
471 }
472 
473 pragma solidity ^0.5.17;
474 
475 
476 /**
477  * @title SafeERC20
478  * @dev Wrappers around ERC20 operations that throw on failure (when the token
479  * contract returns false). Tokens that return no value (and instead revert or
480  * throw on failure) are also supported, non-reverting calls are assumed to be
481  * successful.
482  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
483  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
484  */
485 library SafeERC20 {
486     using SafeMath for uint256;
487     using Address for address;
488 
489     function safeTransfer(IERC20 token, address to, uint256 value) internal {
490         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
491     }
492 
493     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
494         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
495     }
496 
497     function safeApprove(IERC20 token, address spender, uint256 value) internal {
498         // safeApprove should only be called when setting an initial allowance,
499         // or when resetting it to zero. To increase and decrease it, use
500         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
501         // solhint-disable-next-line max-line-length
502         require((value == 0) || (token.allowance(address(this), spender) == 0),
503             "SafeERC20: approve from non-zero to non-zero allowance"
504         );
505         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
506     }
507 
508     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
509         uint256 newAllowance = token.allowance(address(this), spender).add(value);
510         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
511     }
512 
513     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
514         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
515         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
516     }
517 
518     /**
519      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
520      * on the return value: the return value is optional (but if data is returned, it must not be false).
521      * @param token The token targeted by the call.
522      * @param data The call data (encoded using abi.encode or one of its variants).
523      */
524     function callOptionalReturn(IERC20 token, bytes memory data) private {
525         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
526         // we're implementing it ourselves.
527 
528         // A Solidity high level call has three parts:
529         //  1. The target address is checked to verify it contains contract code
530         //  2. The call itself is made, and success asserted
531         //  3. The return value is decoded, which in turn checks the size of the returned data.
532         // solhint-disable-next-line max-line-length
533         require(address(token).isContract(), "SafeERC20: call to non-contract");
534 
535         // solhint-disable-next-line avoid-low-level-calls
536         (bool success, bytes memory returndata) = address(token).call(data);
537         require(success, "SafeERC20: low-level call failed");
538 
539         if (returndata.length > 0) { // Return data is optional
540             // solhint-disable-next-line max-line-length
541             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
542         }
543     }
544 }
545 
546 pragma solidity ^0.5.17;
547 
548 
549 contract LPTokenWrapper {
550     using SafeMath for uint256;
551     using SafeERC20 for IERC20;
552 
553     IERC20 public stakeToken;
554 
555     uint256 private _totalSupply;
556     mapping(address => uint256) private _balances;
557 
558     constructor(IERC20 _stakeToken) public {
559         stakeToken = _stakeToken;
560     }
561 
562     function totalSupply() public view returns (uint256) {
563         return _totalSupply;
564     }
565 
566     function balanceOf(address account) public view returns (uint256) {
567         return _balances[account];
568     }
569 
570     function stake(uint256 amount) public {
571         _totalSupply = _totalSupply.add(amount);
572         _balances[msg.sender] = _balances[msg.sender].add(amount);
573         // safeTransferFrom shifted to last line of overridden method
574     }
575 
576     function withdraw(uint256 amount) public {
577         _totalSupply = _totalSupply.sub(amount);
578         _balances[msg.sender] = _balances[msg.sender].sub(amount);
579         // safeTransfer shifted to last line of overridden method
580     }
581 }
582 
583 interface UniswapRouter {
584     function WETH() external pure returns (address);
585     function swapExactTokensForTokens(
586       uint amountIn,
587       uint amountOutMin,
588       address[] calldata path,
589       address to,
590       uint deadline
591     ) external returns (uint[] memory amounts);
592 }
593 
594 interface IGovernance {
595     function getStablecoin() external view returns (address);
596 }
597 
598 contract BoostRewardsPool is LPTokenWrapper, Ownable {
599     IERC20 public boostToken;
600     address public governance;
601     address public governanceSetter;
602     UniswapRouter public uniswapRouter;
603     address public stablecoin;
604     
605     uint256 public constant MAX_NUM_BOOSTERS = 5;
606     uint256 public tokenCapAmount;
607     uint256 public starttime;
608     uint256 public duration;
609     uint256 public periodFinish = 0;
610     uint256 public rewardRate = 0;
611     uint256 public lastUpdateTime;
612     uint256 public rewardPerTokenStored;
613     mapping(address => uint256) public userRewardPerTokenPaid;
614     mapping(address => uint256) public rewards;
615     
616     // booster variables
617     // variables to keep track of totalSupply and balances (after accounting for multiplier)
618     uint256 public boostedTotalSupply;
619     mapping(address => uint256) public boostedBalances;
620     mapping(address => uint256) public numBoostersBought; // each booster = 5% increase in stake amt
621     mapping(address => uint256) public nextBoostPurchaseTime; // timestamp for which user is eligible to purchase another booster
622     uint256 public boosterPrice = PRECISION;
623     uint256 internal constant PRECISION = 1e18;
624 
625     event RewardAdded(uint256 reward);
626     event RewardPaid(address indexed user, uint256 reward);
627 
628     modifier checkStart() {
629         require(block.timestamp >= starttime,"not start");
630         _;
631     }
632 
633     modifier updateReward(address account) {
634         rewardPerTokenStored = rewardPerToken();
635         lastUpdateTime = lastTimeRewardApplicable();
636         if (account != address(0)) {
637             rewards[account] = earned(account);
638             userRewardPerTokenPaid[account] = rewardPerTokenStored;
639         }
640         _;
641     }
642 
643     constructor(
644         uint256 _tokenCapAmount,
645         IERC20 _stakeToken,
646         IERC20 _boostToken,
647         address _governanceSetter,
648         UniswapRouter _uniswapRouter,
649         uint256 _starttime,
650         uint256 _duration
651     ) public LPTokenWrapper(_stakeToken) {
652         tokenCapAmount = _tokenCapAmount;
653         boostToken = _boostToken;
654         boostToken.approve(address(_uniswapRouter), uint256(-1));
655         governanceSetter = _governanceSetter;
656         uniswapRouter = _uniswapRouter;
657         starttime = _starttime;
658         duration = _duration;
659     }
660     
661     function lastTimeRewardApplicable() public view returns (uint256) {
662         return Math.min(block.timestamp, periodFinish);
663     }
664 
665     function rewardPerToken() public view returns (uint256) {
666         if (boostedTotalSupply == 0) {
667             return rewardPerTokenStored;
668         }
669         return
670             rewardPerTokenStored.add(
671                 lastTimeRewardApplicable()
672                     .sub(lastUpdateTime)
673                     .mul(rewardRate)
674                     .mul(1e18)
675                     .div(boostedTotalSupply)
676             );
677     }
678 
679     function earned(address account) public view returns (uint256) {
680         return
681             boostedBalances[account]
682                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
683                 .div(1e18)
684                 .add(rewards[account]);
685     }
686 
687     // stake visibility is public as overriding LPTokenWrapper's stake() function
688     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
689         require(amount > 0, "Cannot stake 0");
690         super.stake(amount);
691 
692         // check user cap
693         require(
694             balanceOf(msg.sender) <= tokenCapAmount || block.timestamp >= starttime.add(86400),
695             "token cap exceeded"
696         );
697 
698         // update boosted balance and supply
699         updateBoostBalanceAndSupply(msg.sender);
700         
701         // transfer token last, to follow CEI pattern
702         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
703     }
704 
705     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
706         require(amount > 0, "Cannot withdraw 0");
707         super.withdraw(amount);
708         
709         // update boosted balance and supply
710         updateBoostBalanceAndSupply(msg.sender);
711         
712         stakeToken.safeTransfer(msg.sender, amount);
713     }
714 
715     function exit() external {
716         withdraw(balanceOf(msg.sender));
717         getReward();
718     }
719 
720     function getReward() public updateReward(msg.sender) checkStart {
721         uint256 reward = earned(msg.sender);
722         if (reward > 0) {
723             rewards[msg.sender] = 0;
724             boostToken.safeTransfer(msg.sender, reward);
725             emit RewardPaid(msg.sender, reward);
726         }
727     }
728     
729     function boost() external updateReward(msg.sender) checkStart {
730         require(
731             // 1 hour after starttime
732             block.timestamp > starttime.add(3600) &&
733             block.timestamp > nextBoostPurchaseTime[msg.sender],
734             "early boost purchase"
735         );
736         
737         // increase next purchase eligibility by an hour
738         nextBoostPurchaseTime[msg.sender] = block.timestamp.add(3600);
739         
740         // increase no. of boosters bought
741         uint256 booster = numBoostersBought[msg.sender].add(1);
742         numBoostersBought[msg.sender] = booster;
743         require(booster <= MAX_NUM_BOOSTERS, "max boosters bought");
744 
745         // save current booster price, since transfer is done last
746         booster = boosterPrice;
747         // increase next booster price by 5%
748         boosterPrice = boosterPrice.mul(105).div(100);
749         
750         // update boosted balance and supply
751         updateBoostBalanceAndSupply(msg.sender);
752         
753         boostToken.safeTransferFrom(msg.sender, address(this), booster);
754         
755         IERC20Burnable burnableBoostToken = IERC20Burnable(address(boostToken));
756         // if governance not set, burn all
757         if (governance == address(0)) {
758             burnableBoostToken.burn(booster);
759             return;
760         }
761 
762         // otherwise, burn 50%
763         uint256 burnAmount = booster.div(2);
764         burnableBoostToken.burn(burnAmount);
765         booster = booster.sub(burnAmount);
766         
767         // swap to stablecoin, transferred to governance
768         address[] memory routeDetails = new address[](3);
769         routeDetails[0] = address(boostToken);
770         routeDetails[1] = uniswapRouter.WETH();
771         routeDetails[2] = stablecoin;
772         uniswapRouter.swapExactTokensForTokens(
773             booster,
774             0,
775             routeDetails,
776             governance,
777             block.timestamp + 100
778         );
779     }
780 
781     function notifyRewardAmount(uint256 reward)
782         external
783         onlyOwner
784         updateReward(address(0))
785     {
786         rewardRate = reward.div(duration);
787         lastUpdateTime = starttime;
788         periodFinish = starttime.add(duration);
789         emit RewardAdded(reward);
790     }
791     
792     function setGovernance(address _governance)
793         external
794     {
795         require(msg.sender == governanceSetter, "only setter");
796         governance = _governance;
797         stablecoin = IGovernance(governance).getStablecoin();
798         governanceSetter = address(0);
799     }
800     
801     function updateBoostBalanceAndSupply(address user) internal {
802          // subtract existing balance from boostedSupply
803         boostedTotalSupply = boostedTotalSupply.sub(boostedBalances[user]);
804         // calculate and update new boosted balance (user's balance has been updated by parent method)
805         // each booster adds 5% to stake amount
806         uint256 newBoostBalance = balanceOf(user).mul(numBoostersBought[user].mul(5).add(100)).div(100);
807         boostedBalances[user] = newBoostBalance;
808         // update boostedSupply
809         boostedTotalSupply = boostedTotalSupply.add(newBoostBalance);
810     }
811 }