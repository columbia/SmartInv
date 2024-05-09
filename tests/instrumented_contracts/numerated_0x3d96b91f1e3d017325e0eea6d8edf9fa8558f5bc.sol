1 /*
2 * MIT License
3 * ===========
4 *
5 * Copyright (c) 2020 Synthetix
6 *
7 * Permission is hereby granted, free of charge, to any person obtaining a copy
8 * of this software and associated documentation files (the "Software"), to deal
9 * in the Software without restriction, including without limitation the rights
10 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 * copies of the Software, and to permit persons to whom the Software is
12 * furnished to do so, subject to the following conditions:
13 *
14 * The above copyright notice and this permission notice shall be included in all
15 * copies or substantial portions of the Software.
16 *
17 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
18 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
19 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
20 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
21 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
22 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
23 */
24 
25 // File: @openzeppelin/contracts/math/Math.sol
26 
27 pragma solidity ^0.5.0;
28 
29 /**
30  * @dev Standard math utilities missing in the Solidity language.
31  */
32 library Math {
33     /**
34      * @dev Returns the largest of two numbers.
35      */
36     function max(uint256 a, uint256 b) internal pure returns (uint256) {
37         return a >= b ? a : b;
38     }
39 
40     /**
41      * @dev Returns the smallest of two numbers.
42      */
43     function min(uint256 a, uint256 b) internal pure returns (uint256) {
44         return a < b ? a : b;
45     }
46 
47     /**
48      * @dev Returns the average of two numbers. The result is rounded towards
49      * zero.
50      */
51     function average(uint256 a, uint256 b) internal pure returns (uint256) {
52         // (a + b) / 2 can overflow, so we distribute
53         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
54     }
55 }
56 
57 // File: @openzeppelin/contracts/math/SafeMath.sol
58 
59 pragma solidity ^0.5.0;
60 
61 /**
62  * @dev Wrappers over Solidity's arithmetic operations with added overflow
63  * checks.
64  *
65  * Arithmetic operations in Solidity wrap on overflow. This can easily result
66  * in bugs, because programmers usually assume that an overflow raises an
67  * error, which is the standard behavior in high level programming languages.
68  * `SafeMath` restores this intuition by reverting the transaction when an
69  * operation overflows.
70  *
71  * Using this library instead of the unchecked operations eliminates an entire
72  * class of bugs, so it's recommended to use it always.
73  */
74 library SafeMath {
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      * - Addition cannot overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      * - Subtraction cannot overflow.
99      */
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return sub(a, b, "SafeMath: subtraction overflow");
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
106      * overflow (when the result is negative).
107      *
108      * Counterpart to Solidity's `-` operator.
109      *
110      * Requirements:
111      * - Subtraction cannot overflow.
112      *
113      * _Available since v2.4.0._
114      */
115     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b <= a, errorMessage);
117         uint256 c = a - b;
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `*` operator.
127      *
128      * Requirements:
129      * - Multiplication cannot overflow.
130      */
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
133         // benefit is lost if 'b' is also tested.
134         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
135         if (a == 0) {
136             return 0;
137         }
138 
139         uint256 c = a * b;
140         require(c / a == b, "SafeMath: multiplication overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the integer division of two unsigned integers. Reverts on
147      * division by zero. The result is rounded towards zero.
148      *
149      * Counterpart to Solidity's `/` operator. Note: this function uses a
150      * `revert` opcode (which leaves remaining gas untouched) while Solidity
151      * uses an invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      * - The divisor cannot be zero.
155      */
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         return div(a, b, "SafeMath: division by zero");
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      *
171      * _Available since v2.4.0._
172      */
173     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         // Solidity only automatically asserts when dividing by 0
175         require(b > 0, errorMessage);
176         uint256 c = a / b;
177         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * Reverts when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      * - The divisor cannot be zero.
192      */
193     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194         return mod(a, b, "SafeMath: modulo by zero");
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts with custom message when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      *
208      * _Available since v2.4.0._
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b != 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 // File: @openzeppelin/contracts/GSN/Context.sol
217 
218 pragma solidity ^0.5.0;
219 
220 /*
221  * @dev Provides information about the current execution context, including the
222  * sender of the transaction and its data. While these are generally available
223  * via msg.sender and msg.data, they should not be accessed in such a direct
224  * manner, since when dealing with GSN meta-transactions the account sending and
225  * paying for execution may not be the actual sender (as far as an application
226  * is concerned).
227  *
228  * This contract is only required for intermediate, library-like contracts.
229  */
230 contract Context {
231     // Empty internal constructor, to prevent people from mistakenly deploying
232     // an instance of this contract, which should be used via inheritance.
233     constructor () internal { }
234     // solhint-disable-previous-line no-empty-blocks
235 
236     function _msgSender() internal view returns (address payable) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view returns (bytes memory) {
241         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
242         return msg.data;
243     }
244 }
245 
246 // File: @openzeppelin/contracts/ownership/Ownable.sol
247 
248 pragma solidity ^0.5.0;
249 
250 /**
251  * @dev Contract module which provides a basic access control mechanism, where
252  * there is an account (an owner) that can be granted exclusive access to
253  * specific functions.
254  *
255  * This module is used through inheritance. It will make available the modifier
256  * `onlyOwner`, which can be applied to your functions to restrict their use to
257  * the owner.
258  */
259 contract Ownable is Context {
260     address private _owner;
261 
262     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
263 
264     /**
265      * @dev Initializes the contract setting the deployer as the initial owner.
266      */
267     constructor () internal {
268         _owner = _msgSender();
269         emit OwnershipTransferred(address(0), _owner);
270     }
271 
272     /**
273      * @dev Returns the address of the current owner.
274      */
275     function owner() public view returns (address) {
276         return _owner;
277     }
278 
279     /**
280      * @dev Throws if called by any account other than the owner.
281      */
282     modifier onlyOwner() {
283         require(isOwner(), "Ownable: caller is not the owner");
284         _;
285     }
286 
287     /**
288      * @dev Returns true if the caller is the current owner.
289      */
290     function isOwner() public view returns (bool) {
291         return _msgSender() == _owner;
292     }
293 
294     /**
295      * @dev Leaves the contract without owner. It will not be possible to call
296      * `onlyOwner` functions anymore. Can only be called by the current owner.
297      *
298      * NOTE: Renouncing ownership will leave the contract without an owner,
299      * thereby removing any functionality that is only available to the owner.
300      */
301     function renounceOwnership() public onlyOwner {
302         emit OwnershipTransferred(_owner, address(0));
303         _owner = address(0);
304     }
305 
306     /**
307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
308      * Can only be called by the current owner.
309      */
310     function transferOwnership(address newOwner) public onlyOwner {
311         _transferOwnership(newOwner);
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      */
317     function _transferOwnership(address newOwner) internal {
318         require(newOwner != address(0), "Ownable: new owner is the zero address");
319         emit OwnershipTransferred(_owner, newOwner);
320         _owner = newOwner;
321     }
322 }
323 
324 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
325 
326 pragma solidity ^0.5.0;
327 
328 /**
329  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
330  * the optional functions; to access them see {ERC20Detailed}.
331  */
332 interface IERC20 {
333     /**
334      * @dev Returns the amount of tokens in existence.
335      */
336     function totalSupply() external view returns (uint256);
337 
338     /**
339      * @dev Returns the amount of tokens owned by `account`.
340      */
341     function balanceOf(address account) external view returns (uint256);
342 
343     /**
344      * @dev Moves `amount` tokens from the caller's account to `recipient`.
345      *
346      * Returns a boolean value indicating whether the operation succeeded.
347      *
348      * Emits a {Transfer} event.
349      */
350     function transfer(address recipient, uint256 amount) external returns (bool);
351     function mint(address account, uint amount) external;
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
404 // File: @openzeppelin/contracts/utils/Address.sol
405 
406 pragma solidity ^0.5.5;
407 
408 /**
409  * @dev Collection of functions related to the address type
410  */
411 library Address {
412     /**
413      * @dev Returns true if `account` is a contract.
414      *
415      * This test is non-exhaustive, and there may be false-negatives: during the
416      * execution of a contract's constructor, its address will be reported as
417      * not containing a contract.
418      *
419      * IMPORTANT: It is unsafe to assume that an address for which this
420      * function returns false is an externally-owned account (EOA) and not a
421      * contract.
422      */
423     function isContract(address account) internal view returns (bool) {
424         // This method relies in extcodesize, which returns 0 for contracts in
425         // construction, since the code is only stored at the end of the
426         // constructor execution.
427 
428         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
429         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
430         // for accounts without code, i.e. `keccak256('')`
431         bytes32 codehash;
432         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
433         // solhint-disable-next-line no-inline-assembly
434         assembly { codehash := extcodehash(account) }
435         return (codehash != 0x0 && codehash != accountHash);
436     }
437 
438     /**
439      * @dev Converts an `address` into `address payable`. Note that this is
440      * simply a type cast: the actual underlying value is not changed.
441      *
442      * _Available since v2.4.0._
443      */
444     function toPayable(address account) internal pure returns (address payable) {
445         return address(uint160(account));
446     }
447 
448     /**
449      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
450      * `recipient`, forwarding all available gas and reverting on errors.
451      *
452      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
453      * of certain opcodes, possibly making contracts go over the 2300 gas limit
454      * imposed by `transfer`, making them unable to receive funds via
455      * `transfer`. {sendValue} removes this limitation.
456      *
457      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
458      *
459      * IMPORTANT: because control is transferred to `recipient`, care must be
460      * taken to not create reentrancy vulnerabilities. Consider using
461      * {ReentrancyGuard} or the
462      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
463      *
464      * _Available since v2.4.0._
465      */
466     function sendValue(address payable recipient, uint256 amount) internal {
467         require(address(this).balance >= amount, "Address: insufficient balance");
468 
469         // solhint-disable-next-line avoid-call-value
470         (bool success, ) = recipient.call.value(amount)("");
471         require(success, "Address: unable to send value, recipient may have reverted");
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
476 
477 pragma solidity ^0.5.0;
478 
479 
480 
481 
482 /**
483  * @title SafeERC20
484  * @dev Wrappers around ERC20 operations that throw on failure (when the token
485  * contract returns false). Tokens that return no value (and instead revert or
486  * throw on failure) are also supported, non-reverting calls are assumed to be
487  * successful.
488  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
489  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
490  */
491 library SafeERC20 {
492     using SafeMath for uint256;
493     using Address for address;
494 
495     function safeTransfer(IERC20 token, address to, uint256 value) internal {
496         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
497     }
498 
499     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
500         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
501     }
502 
503     function safeApprove(IERC20 token, address spender, uint256 value) internal {
504         // safeApprove should only be called when setting an initial allowance,
505         // or when resetting it to zero. To increase and decrease it, use
506         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
507         // solhint-disable-next-line max-line-length
508         require((value == 0) || (token.allowance(address(this), spender) == 0),
509             "SafeERC20: approve from non-zero to non-zero allowance"
510         );
511         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
512     }
513 
514     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
515         uint256 newAllowance = token.allowance(address(this), spender).add(value);
516         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
517     }
518 
519     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
520         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
521         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
522     }
523 
524     /**
525      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
526      * on the return value: the return value is optional (but if data is returned, it must not be false).
527      * @param token The token targeted by the call.
528      * @param data The call data (encoded using abi.encode or one of its variants).
529      */
530     function callOptionalReturn(IERC20 token, bytes memory data) private {
531         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
532         // we're implementing it ourselves.
533 
534         // A Solidity high level call has three parts:
535         //  1. The target address is checked to verify it contains contract code
536         //  2. The call itself is made, and success asserted
537         //  3. The return value is decoded, which in turn checks the size of the returned data.
538         // solhint-disable-next-line max-line-length
539         require(address(token).isContract(), "SafeERC20: call to non-contract");
540 
541         // solhint-disable-next-line avoid-low-level-calls
542         (bool success, bytes memory returndata) = address(token).call(data);
543         require(success, "SafeERC20: low-level call failed");
544 
545         if (returndata.length > 0) { // Return data is optional
546             // solhint-disable-next-line max-line-length
547             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
548         }
549     }
550 }
551 
552 // File: contracts/IRewardDistributionRecipient.sol
553 
554 pragma solidity ^0.5.0;
555 
556 
557 
558 contract IRewardDistributionRecipient is Ownable {
559     address rewardDistribution;
560 
561     function notifyRewardAmount(uint256 reward) external;
562 
563     modifier onlyRewardDistribution() {
564         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
565         _;
566     }
567 
568     function setRewardDistribution(address _rewardDistribution)
569         external
570         onlyOwner
571     {
572         rewardDistribution = _rewardDistribution;
573     }
574 }
575 
576 // File: contracts/CurveRewards.sol
577 
578 pragma solidity ^0.5.0;
579 
580 
581 
582 
583 
584 
585 contract LPTokenWrapper {
586     using SafeMath for uint256;
587     using SafeERC20 for IERC20;
588 
589     IERC20 public LPtoken = IERC20(0xEa8091470479B457792F2F56a4E58C7329Bc1b1D);
590 
591     uint256 private _totalSupply;
592     mapping(address => uint256) private _balances;
593 
594     function totalSupply() public view returns (uint256) {
595         return _totalSupply;
596     }
597 
598     function balanceOf(address account) public view returns (uint256) {
599         return _balances[account];
600     }
601 
602     function stake(uint256 amount) public {
603         _totalSupply = _totalSupply.add(amount);
604         _balances[msg.sender] = _balances[msg.sender].add(amount);
605         LPtoken.safeTransferFrom(msg.sender, address(this), amount);
606     }
607 
608     function withdraw(uint256 amount) public {
609         _totalSupply = _totalSupply.sub(amount);
610         _balances[msg.sender] = _balances[msg.sender].sub(amount);
611         LPtoken.safeTransfer(msg.sender, amount);
612     }
613 }
614 
615 contract YFFCWETHreward is LPTokenWrapper, IRewardDistributionRecipient {
616     IERC20 public yffc = IERC20(0xea004e8FA3701B8E58E41b78D50996e0f7176CbD);
617     uint256 public constant DURATION = 30 days;
618 
619     uint256 public initreward = 5000*1e18;
620     uint256 public starttime = 1599868801; 
621     uint256 public periodFinish = 0;
622     uint256 public rewardRate = 0;
623     uint256 public lastUpdateTime;
624     uint256 public rewardPerTokenStored;
625     mapping(address => uint256) public userRewardPerTokenPaid;
626     mapping(address => uint256) public rewards;
627 
628     event RewardAdded(uint256 reward);
629     event Staked(address indexed user, uint256 amount);
630     event Withdrawn(address indexed user, uint256 amount);
631     event RewardPaid(address indexed user, uint256 reward);
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
643     function lastTimeRewardApplicable() public view returns (uint256) {
644         return Math.min(block.timestamp, periodFinish);
645     }
646 
647     function rewardPerToken() public view returns (uint256) {
648         if (totalSupply() == 0) {
649             return rewardPerTokenStored;
650         }
651         return
652             rewardPerTokenStored.add(
653                 lastTimeRewardApplicable()
654                     .sub(lastUpdateTime)
655                     .mul(rewardRate)
656                     .mul(1e18)
657                     .div(totalSupply())
658             );
659     }
660 
661     function earned(address account) public view returns (uint256) {
662         return
663             balanceOf(account)
664                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
665                 .div(1e18)
666                 .add(rewards[account]);
667     }
668 
669     // stake visibility is public as overriding LPTokenWrapper's stake() function
670     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{ 
671         require(amount > 0, "Cannot stake 0");
672         super.stake(amount);
673         emit Staked(msg.sender, amount);
674     }
675 
676     function withdraw(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
677         require(amount > 0, "Cannot withdraw 0");
678         super.withdraw(amount);
679         emit Withdrawn(msg.sender, amount);
680     }
681 
682     function exit() external {
683         withdraw(balanceOf(msg.sender));
684         getReward();
685     }
686 
687     function getReward() public updateReward(msg.sender) checkhalve checkStart{
688         uint256 reward = earned(msg.sender);
689         if (reward > 0) {
690             rewards[msg.sender] = 0;
691             yffc.safeTransfer(msg.sender, reward);
692             emit RewardPaid(msg.sender, reward);
693         }
694     }
695 
696     modifier checkhalve(){
697         if (block.timestamp >= periodFinish) {
698             initreward = initreward.mul(50).div(100); 
699             yffc.mint(address(this),initreward);
700 
701             rewardRate = initreward.div(DURATION);
702             periodFinish = block.timestamp.add(DURATION);
703             emit RewardAdded(initreward);
704         }
705         _;
706     }
707     modifier checkStart(){
708         require(block.timestamp > starttime,"not start");
709         _;
710     }
711 
712     function notifyRewardAmount(uint256 reward)
713         external
714         onlyRewardDistribution
715         updateReward(address(0))
716     {
717         if (block.timestamp >= periodFinish) {
718             rewardRate = reward.div(DURATION);
719         } else {
720             uint256 remaining = periodFinish.sub(block.timestamp);
721             uint256 leftover = remaining.mul(rewardRate);
722             rewardRate = reward.add(leftover).div(DURATION);
723         }
724         yffc.mint(address(this),reward);
725         lastUpdateTime = block.timestamp;
726         periodFinish = block.timestamp.add(DURATION);
727         emit RewardAdded(reward);
728     }
729 }