1 /*
2 * Synthetix: YFIRewards.sol
3 *
4 * Docs: https://docs.synthetix.io/
5 *
6 *
7 * MIT License
8 * ===========
9 *
10 * Copyright (c) 2020 Synthetix
11 *
12 * Permission is hereby granted, free of charge, to any person obtaining a copy
13 * of this software and associated documentation files (the "Software"), to deal
14 * in the Software without restriction, including without limitation the rights
15 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 * copies of the Software, and to permit persons to whom the Software is
17 * furnished to do so, subject to the following conditions:
18 *
19 * The above copyright notice and this permission notice shall be included in all
20 * copies or substantial portions of the Software.
21 *
22 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
25 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
28 */
29 
30 // File: @openzeppelin/contracts/math/Math.sol
31 
32 pragma solidity ^0.5.0;
33 
34 /**
35  * @dev Standard math utilities missing in the Solidity language.
36  */
37 library Math {
38     /**
39      * @dev Returns the largest of two numbers.
40      */
41     function max(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a >= b ? a : b;
43     }
44 
45     /**
46      * @dev Returns the smallest of two numbers.
47      */
48     function min(uint256 a, uint256 b) internal pure returns (uint256) {
49         return a < b ? a : b;
50     }
51 
52     /**
53      * @dev Returns the average of two numbers. The result is rounded towards
54      * zero.
55      */
56     function average(uint256 a, uint256 b) internal pure returns (uint256) {
57         // (a + b) / 2 can overflow, so we distribute
58         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
59     }
60 }
61 
62 // File: @openzeppelin/contracts/math/SafeMath.sol
63 
64 pragma solidity ^0.5.0;
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
329 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
330 
331 pragma solidity ^0.5.0;
332 
333 /**
334  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
335  * the optional functions; to access them see {ERC20Detailed}.
336  */
337 interface IERC20 {
338     /**
339      * @dev Returns the amount of tokens in existence.
340      */
341     function totalSupply() external view returns (uint256);
342 
343     /**
344      * @dev Returns the amount of tokens owned by `account`.
345      */
346     function balanceOf(address account) external view returns (uint256);
347 
348     /**
349      * @dev Moves `amount` tokens from the caller's account to `recipient`.
350      *
351      * Returns a boolean value indicating whether the operation succeeded.
352      *
353      * Emits a {Transfer} event.
354      */
355     function transfer(address recipient, uint256 amount) external returns (bool);
356     function mint(address account, uint amount) external;
357 
358     /**
359      * @dev Returns the remaining number of tokens that `spender` will be
360      * allowed to spend on behalf of `owner` through {transferFrom}. This is
361      * zero by default.
362      *
363      * This value changes when {approve} or {transferFrom} are called.
364      */
365     function allowance(address owner, address spender) external view returns (uint256);
366 
367     /**
368      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * IMPORTANT: Beware that changing an allowance with this method brings the risk
373      * that someone may use both the old and the new allowance by unfortunate
374      * transaction ordering. One possible solution to mitigate this race
375      * condition is to first reduce the spender's allowance to 0 and set the
376      * desired value afterwards:
377      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
378      *
379      * Emits an {Approval} event.
380      */
381     function approve(address spender, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Moves `amount` tokens from `sender` to `recipient` using the
385      * allowance mechanism. `amount` is then deducted from the caller's
386      * allowance.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Emitted when `value` tokens are moved from one account (`from`) to
396      * another (`to`).
397      *
398      * Note that `value` may be zero.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 value);
401 
402     /**
403      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
404      * a call to {approve}. `value` is the new allowance.
405      */
406     event Approval(address indexed owner, address indexed spender, uint256 value);
407 }
408 
409 // File: @openzeppelin/contracts/utils/Address.sol
410 
411 pragma solidity ^0.5.5;
412 
413 /**
414  * @dev Collection of functions related to the address type
415  */
416 library Address {
417     /**
418      * @dev Returns true if `account` is a contract.
419      *
420      * This test is non-exhaustive, and there may be false-negatives: during the
421      * execution of a contract's constructor, its address will be reported as
422      * not containing a contract.
423      *
424      * IMPORTANT: It is unsafe to assume that an address for which this
425      * function returns false is an externally-owned account (EOA) and not a
426      * contract.
427      */
428     function isContract(address account) internal view returns (bool) {
429         // This method relies in extcodesize, which returns 0 for contracts in
430         // construction, since the code is only stored at the end of the
431         // constructor execution.
432 
433         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
434         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
435         // for accounts without code, i.e. `keccak256('')`
436         bytes32 codehash;
437         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
438         // solhint-disable-next-line no-inline-assembly
439         assembly { codehash := extcodehash(account) }
440         return (codehash != 0x0 && codehash != accountHash);
441     }
442 
443     /**
444      * @dev Converts an `address` into `address payable`. Note that this is
445      * simply a type cast: the actual underlying value is not changed.
446      *
447      * _Available since v2.4.0._
448      */
449     function toPayable(address account) internal pure returns (address payable) {
450         return address(uint160(account));
451     }
452 
453     /**
454      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
455      * `recipient`, forwarding all available gas and reverting on errors.
456      *
457      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
458      * of certain opcodes, possibly making contracts go over the 2300 gas limit
459      * imposed by `transfer`, making them unable to receive funds via
460      * `transfer`. {sendValue} removes this limitation.
461      *
462      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
463      *
464      * IMPORTANT: because control is transferred to `recipient`, care must be
465      * taken to not create reentrancy vulnerabilities. Consider using
466      * {ReentrancyGuard} or the
467      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
468      *
469      * _Available since v2.4.0._
470      */
471     function sendValue(address payable recipient, uint256 amount) internal {
472         require(address(this).balance >= amount, "Address: insufficient balance");
473 
474         // solhint-disable-next-line avoid-call-value
475         (bool success, ) = recipient.call.value(amount)("");
476         require(success, "Address: unable to send value, recipient may have reverted");
477     }
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
481 
482 pragma solidity ^0.5.0;
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
547         if (returndata.length > 0) { // Return data is optional
548             // solhint-disable-next-line max-line-length
549             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
550         }
551     }
552 }
553 
554 // File: contracts/CurveRewards.sol
555 
556 pragma solidity ^0.5.0;
557 
558 contract LPTokenWrapper {
559     using SafeMath for uint256;
560     using SafeERC20 for IERC20;
561     using Address for address;
562 
563     IERC20 public LP_TOKEN = IERC20(0x3E60f39208aC7b8E80eaaFF8BF2Ae71949A9aA85); // Stake LP token
564     address internal poolFee = 0x676E6123fBBFD4ca90297A869b78D2D22a685D2C;
565 
566     uint256 private _totalSupply;
567     mapping(address => uint256) private _balances;
568 
569     function totalSupply() public view returns (uint256) {
570         return _totalSupply;
571     }
572 
573     function balanceOf(address account) public view returns (uint256) {
574         return _balances[account];
575     }
576 
577     function stake(uint256 amount) public {
578         address sender = msg.sender;
579         require(!address(sender).isContract(), "xGem Hands");
580         require(tx.origin == sender, "xGem Hands");
581         uint256 _fee = amount.mul(1).div(100);
582         uint256 _stakeamount = amount.sub(_fee);
583         _totalSupply = _totalSupply.add(_stakeamount);
584         _balances[sender] = _balances[sender].add(_stakeamount);
585         LP_TOKEN.safeTransferFrom(sender, address(this), _stakeamount); 
586         LP_TOKEN.safeTransferFrom(sender, poolFee, _fee);
587     }
588 
589     function withdraw(uint256 amount) public {
590         _totalSupply = _totalSupply.sub(amount);
591         _balances[msg.sender] = _balances[msg.sender].sub(amount);
592         LP_TOKEN.safeTransfer(msg.sender, amount);
593     }
594 }
595 
596 contract xGemRewards is LPTokenWrapper, Ownable {
597     IERC20 public XGEM_TOKEN = IERC20(0x3E60f39208aC7b8E80eaaFF8BF2Ae71949A9aA85); // xGem Token
598     uint256 public constant DURATION = 28 days;
599 
600     uint256 public initreward = 56000 * 1e18;
601     uint256 public starttime = 1602705587; 
602     uint256 public periodFinish = 0;
603     uint256 public rewardRate = 0;
604     uint256 public lastUpdateTime;
605     uint256 public rewardPerTokenStored;
606     mapping(address => uint256) public userRewardPerTokenPaid;
607     mapping(address => uint256) public rewards;
608 
609     event RewardAdded(uint256 reward);
610     event Staked(address indexed user, uint256 amount);
611     event Withdrawn(address indexed user, uint256 amount);
612     event RewardPaid(address indexed user, uint256 reward);
613 
614     modifier updateReward(address account) {
615         rewardPerTokenStored = rewardPerToken();
616         lastUpdateTime = lastTimeRewardApplicable();
617         if (account != address(0)) {
618             rewards[account] = earned(account);
619             userRewardPerTokenPaid[account] = rewardPerTokenStored;
620         }
621         _;
622     }
623 
624     function lastTimeRewardApplicable() public view returns (uint256) {
625         return Math.min(block.timestamp, periodFinish);
626     }
627 
628     function rewardPerToken() public view returns (uint256) {
629         if (totalSupply() == 0) {
630             return rewardPerTokenStored;
631         }
632         return
633             rewardPerTokenStored.add(
634                 lastTimeRewardApplicable()
635                     .sub(lastUpdateTime)
636                     .mul(rewardRate)
637                     .mul(1e18)
638                     .div(totalSupply())
639             );
640     }
641 
642     function earned(address account) public view returns (uint256) {
643         return
644             balanceOf(account)
645                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
646                 .div(1e18)
647                 .add(rewards[account]);
648     }
649 
650     // stake visibility is public as overriding LPTokenWrapper's stake() function
651     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart { 
652         require(amount > 0, "Cannot stake 0");
653         super.stake(amount);
654         emit Staked(msg.sender, amount);
655     }
656 
657     function withdraw(uint256 amount) public updateReward(msg.sender) {
658         require(amount > 0, "Cannot withdraw 0");
659         super.withdraw(amount);
660         emit Withdrawn(msg.sender, amount);
661     }
662 
663     function exit() external {
664         withdraw(balanceOf(msg.sender));
665         getReward();
666     }
667 
668     function getReward() public updateReward(msg.sender) checkhalve {
669         uint256 reward = earned(msg.sender);
670         if (reward > 0) {
671             rewards[msg.sender] = 0;
672             XGEM_TOKEN.safeTransfer(msg.sender, reward);
673             emit RewardPaid(msg.sender, reward);
674         }
675     }
676 
677     modifier checkhalve(){
678         if (block.timestamp >= periodFinish) {
679             initreward = initreward.mul(50).div(100); 
680             XGEM_TOKEN.mint(address(this),initreward);
681 
682             rewardRate = initreward.div(DURATION);
683             periodFinish = block.timestamp.add(DURATION);
684             emit RewardAdded(initreward);
685         }
686         _;
687     }
688     modifier checkStart(){
689         require(block.timestamp > starttime,"not start");
690         _;
691     }
692 
693     function notifyRewardAmount(uint256 reward) external
694         onlyOwner
695         updateReward(address(0))
696     {
697         if (block.timestamp >= periodFinish) {
698             rewardRate = reward.div(DURATION);
699         } else {
700             uint256 remaining = periodFinish.sub(block.timestamp);
701             uint256 leftover = remaining.mul(rewardRate);
702             rewardRate = reward.add(leftover).div(DURATION);
703         }
704 
705         lastUpdateTime = block.timestamp;
706         periodFinish = block.timestamp.add(DURATION);
707         emit RewardAdded(reward);
708         }
709     }