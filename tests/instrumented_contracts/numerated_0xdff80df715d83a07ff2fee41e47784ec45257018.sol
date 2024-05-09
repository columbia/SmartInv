1 /**
2         _____________             
3 _____  ____  __ \__(_)___________ 
4 __  / / /_  /_/ /_  /__  ___/  _ \
5 _  /_/ /_  _, _/_  / _(__  )/  __/
6 _\__, / /_/ |_| /_/  /____/ \___/ 
7 /____/                            
8 
9 *
10 *
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 Synthetix
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */
33 
34 // File: @openzeppelin/contracts/math/Math.sol
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
66 // File: @openzeppelin/contracts/math/SafeMath.sol
67 
68 pragma solidity ^0.5.0;
69 
70 /**
71  * @dev Wrappers over Solidity's arithmetic operations with added overflow
72  * checks.
73  *
74  * Arithmetic operations in Solidity wrap on overflow. This can easily result
75  * in bugs, because programmers usually assume that an overflow raises an
76  * error, which is the standard behavior in high level programming languages.
77  * `SafeMath` restores this intuition by reverting the transaction when an
78  * operation overflows.
79  *
80  * Using this library instead of the unchecked operations eliminates an entire
81  * class of bugs, so it's recommended to use it always.
82  */
83 library SafeMath {
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      * - Addition cannot overflow.
92      */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a, "SafeMath: addition overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return sub(a, b, "SafeMath: subtraction overflow");
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      * - Subtraction cannot overflow.
121      *
122      * _Available since v2.4.0._
123      */
124     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b <= a, errorMessage);
126         uint256 c = a - b;
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the multiplication of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `*` operator.
136      *
137      * Requirements:
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
144         if (a == 0) {
145             return 0;
146         }
147 
148         uint256 c = a * b;
149         require(c / a == b, "SafeMath: multiplication overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the integer division of two unsigned integers. Reverts on
156      * division by zero. The result is rounded towards zero.
157      *
158      * Counterpart to Solidity's `/` operator. Note: this function uses a
159      * `revert` opcode (which leaves remaining gas untouched) while Solidity
160      * uses an invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      * - The divisor cannot be zero.
164      */
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         return div(a, b, "SafeMath: division by zero");
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      *
180      * _Available since v2.4.0._
181      */
182     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         // Solidity only automatically asserts when dividing by 0
184         require(b > 0, errorMessage);
185         uint256 c = a / b;
186         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * Reverts when dividing by zero.
194      *
195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
196      * opcode (which leaves remaining gas untouched) while Solidity uses an
197      * invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      * - The divisor cannot be zero.
201      */
202     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
203         return mod(a, b, "SafeMath: modulo by zero");
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts with custom message when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      * - The divisor cannot be zero.
216      *
217      * _Available since v2.4.0._
218      */
219     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b != 0, errorMessage);
221         return a % b;
222     }
223 }
224 
225 // File: @openzeppelin/contracts/GSN/Context.sol
226 
227 pragma solidity ^0.5.0;
228 
229 /*
230  * @dev Provides information about the current execution context, including the
231  * sender of the transaction and its data. While these are generally available
232  * via msg.sender and msg.data, they should not be accessed in such a direct
233  * manner, since when dealing with GSN meta-transactions the account sending and
234  * paying for execution may not be the actual sender (as far as an application
235  * is concerned).
236  *
237  * This contract is only required for intermediate, library-like contracts.
238  */
239 contract Context {
240     // Empty internal constructor, to prevent people from mistakenly deploying
241     // an instance of this contract, which should be used via inheritance.
242     constructor () internal { }
243     // solhint-disable-previous-line no-empty-blocks
244 
245     function _msgSender() internal view returns (address payable) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view returns (bytes memory) {
250         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
251         return msg.data;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/ownership/Ownable.sol
256 
257 pragma solidity ^0.5.0;
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * This module is used through inheritance. It will make available the modifier
265  * `onlyOwner`, which can be applied to your functions to restrict their use to
266  * the owner.
267  */
268 contract Ownable is Context {
269     address private _owner;
270 
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273     /**
274      * @dev Initializes the contract setting the deployer as the initial owner.
275      */
276     constructor () internal {
277         _owner = _msgSender();
278         emit OwnershipTransferred(address(0), _owner);
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(isOwner(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Returns true if the caller is the current owner.
298      */
299     function isOwner() public view returns (bool) {
300         return _msgSender() == _owner;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public onlyOwner {
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      */
326     function _transferOwnership(address newOwner) internal {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         emit OwnershipTransferred(_owner, newOwner);
329         _owner = newOwner;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
334 
335 pragma solidity ^0.5.0;
336 
337 /**
338  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
339  * the optional functions; to access them see {ERC20Detailed}.
340  */
341 interface IERC20 {
342     /**
343      * @dev Returns the amount of tokens in existence.
344      */
345     function totalSupply() external view returns (uint256);
346 
347     /**
348      * @dev Returns the amount of tokens owned by `account`.
349      */
350     function balanceOf(address account) external view returns (uint256);
351 
352     /**
353      * @dev Moves `amount` tokens from the caller's account to `recipient`.
354      *
355      * Returns a boolean value indicating whether the operation succeeded.
356      *
357      * Emits a {Transfer} event.
358      */
359     function transfer(address recipient, uint256 amount) external returns (bool);
360 
361     /**
362      * @dev Returns the remaining number of tokens that `spender` will be
363      * allowed to spend on behalf of `owner` through {transferFrom}. This is
364      * zero by default.
365      *
366      * This value changes when {approve} or {transferFrom} are called.
367      */
368     function allowance(address owner, address spender) external view returns (uint256);
369 
370     /**
371      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * IMPORTANT: Beware that changing an allowance with this method brings the risk
376      * that someone may use both the old and the new allowance by unfortunate
377      * transaction ordering. One possible solution to mitigate this race
378      * condition is to first reduce the spender's allowance to 0 and set the
379      * desired value afterwards:
380      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
381      *
382      * Emits an {Approval} event.
383      */
384     function approve(address spender, uint256 amount) external returns (bool);
385 
386     /**
387      * @dev Moves `amount` tokens from `sender` to `recipient` using the
388      * allowance mechanism. `amount` is then deducted from the caller's
389      * allowance.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Emitted when `value` tokens are moved from one account (`from`) to
399      * another (`to`).
400      *
401      * Note that `value` may be zero.
402      */
403     event Transfer(address indexed from, address indexed to, uint256 value);
404 
405     /**
406      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
407      * a call to {approve}. `value` is the new allowance.
408      */
409     event Approval(address indexed owner, address indexed spender, uint256 value);
410 }
411 
412 // File: @openzeppelin/contracts/utils/Address.sol
413 
414 pragma solidity ^0.5.5;
415 
416 /**
417  * @dev Collection of functions related to the address type
418  */
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * This test is non-exhaustive, and there may be false-negatives: during the
424      * execution of a contract's constructor, its address will be reported as
425      * not containing a contract.
426      *
427      * IMPORTANT: It is unsafe to assume that an address for which this
428      * function returns false is an externally-owned account (EOA) and not a
429      * contract.
430      */
431     function isContract(address account) internal view returns (bool) {
432         // This method relies in extcodesize, which returns 0 for contracts in
433         // construction, since the code is only stored at the end of the
434         // constructor execution.
435 
436         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
437         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
438         // for accounts without code, i.e. `keccak256('')`
439         bytes32 codehash;
440         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
441         // solhint-disable-next-line no-inline-assembly
442         assembly { codehash := extcodehash(account) }
443         return (codehash != 0x0 && codehash != accountHash);
444     }
445 
446     /**
447      * @dev Converts an `address` into `address payable`. Note that this is
448      * simply a type cast: the actual underlying value is not changed.
449      *
450      * _Available since v2.4.0._
451      */
452     function toPayable(address account) internal pure returns (address payable) {
453         return address(uint160(account));
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      *
472      * _Available since v2.4.0._
473      */
474     function sendValue(address payable recipient, uint256 amount) internal {
475         require(address(this).balance >= amount, "Address: insufficient balance");
476 
477         // solhint-disable-next-line avoid-call-value
478         (bool success, ) = recipient.call.value(amount)("");
479         require(success, "Address: unable to send value, recipient may have reverted");
480     }
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
484 
485 pragma solidity ^0.5.0;
486 
487 
488 
489 
490 /**
491  * @title SafeERC20
492  * @dev Wrappers around ERC20 operations that throw on failure (when the token
493  * contract returns false). Tokens that return no value (and instead revert or
494  * throw on failure) are also supported, non-reverting calls are assumed to be
495  * successful.
496  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
497  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
498  */
499 library SafeERC20 {
500     using SafeMath for uint256;
501     using Address for address;
502 
503     function safeTransfer(IERC20 token, address to, uint256 value) internal {
504         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
505     }
506 
507     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
508         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
509     }
510 
511     function safeApprove(IERC20 token, address spender, uint256 value) internal {
512         // safeApprove should only be called when setting an initial allowance,
513         // or when resetting it to zero. To increase and decrease it, use
514         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
515         // solhint-disable-next-line max-line-length
516         require((value == 0) || (token.allowance(address(this), spender) == 0),
517             "SafeERC20: approve from non-zero to non-zero allowance"
518         );
519         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
520     }
521 
522     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
523         uint256 newAllowance = token.allowance(address(this), spender).add(value);
524         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
525     }
526 
527     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
529         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
530     }
531 
532     /**
533      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
534      * on the return value: the return value is optional (but if data is returned, it must not be false).
535      * @param token The token targeted by the call.
536      * @param data The call data (encoded using abi.encode or one of its variants).
537      */
538     function callOptionalReturn(IERC20 token, bytes memory data) private {
539         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
540         // we're implementing it ourselves.
541 
542         // A Solidity high level call has three parts:
543         //  1. The target address is checked to verify it contains contract code
544         //  2. The call itself is made, and success asserted
545         //  3. The return value is decoded, which in turn checks the size of the returned data.
546         // solhint-disable-next-line max-line-length
547         require(address(token).isContract(), "SafeERC20: call to non-contract");
548 
549         // solhint-disable-next-line avoid-low-level-calls
550         (bool success, bytes memory returndata) = address(token).call(data);
551         require(success, "SafeERC20: low-level call failed");
552 
553         if (returndata.length > 0) { // Return data is optional
554             // solhint-disable-next-line max-line-length
555             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
556         }
557     }
558 }
559 
560 // File: contracts/IRewardDistributionRecipient.sol
561 
562 pragma solidity ^0.5.0;
563 
564 
565 
566 contract IRewardDistributionRecipient is Ownable {
567     address rewardDistribution;
568 
569     function notifyRewardAmount(uint256 reward) external;
570 
571     modifier onlyRewardDistribution() {
572         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
573         _;
574     }
575 
576     function setRewardDistribution(address _rewardDistribution)
577         external
578         onlyOwner
579     {
580         rewardDistribution = _rewardDistribution;
581     }
582 }
583 
584 // File: contracts/CurveRewards.sol
585 
586 pragma solidity ^0.5.0;
587 
588 
589 
590 
591 
592 
593 contract LPTokenWrapper {
594     using SafeMath for uint256;
595     using SafeERC20 for IERC20;
596     // Token to be staked
597     IERC20 public ContractStaking = IERC20(address(0));
598 
599     uint256 private _totalSupply;
600     mapping(address => uint256) private _balances;
601 
602     function totalSupply() public view returns (uint256) {
603         return _totalSupply;
604     }
605 
606     function balanceOf(address account) public view returns (uint256) {
607         return _balances[account];
608     }
609 
610     function stake(uint256 amount) public {
611 
612         _totalSupply = _totalSupply.add(amount);
613         _balances[msg.sender] = _balances[msg.sender].add(amount);
614         ContractStaking.safeTransferFrom(msg.sender, address(this), amount);
615     }
616 
617     function withdraw(uint256 amount) public {
618         _totalSupply = _totalSupply.sub(amount);
619         _balances[msg.sender] = _balances[msg.sender].sub(amount);
620         ContractStaking.safeTransfer(msg.sender, amount);
621     } 
622     function setContractToken(address ContractTokenAddress) internal {
623         ContractStaking = IERC20(ContractTokenAddress);
624     }
625 }
626 
627 contract yRiseStaking is LPTokenWrapper, IRewardDistributionRecipient {
628     // Token to be rewarded 7 days from whitelist sale
629     IERC20 public yrise = IERC20(address(0));
630     uint256 public constant DURATION = 7 days;
631 
632     uint256 public periodFinish = 0;
633     uint256 public rewardRate = 0;
634     uint256 public lastUpdateTime;
635     uint256 public rewardPerTokenStored;
636     mapping(address => uint256) public userRewardPerTokenPaid;
637     mapping(address => uint256) public rewards;
638 
639     event RewardAdded(uint256 reward);
640     event Staked(address indexed user, uint256 amount);
641     event Withdrawn(address indexed user, uint256 amount);
642     event RewardPaid(address indexed user, uint256 reward);
643 
644     modifier updateReward(address account) {
645         rewardPerTokenStored = rewardPerToken();
646         lastUpdateTime = lastTimeRewardApplicable();
647         if (account != address(0)) {
648             rewards[account] = earned(account);
649             userRewardPerTokenPaid[account] = rewardPerTokenStored;
650         }
651         _;
652     }
653     function setyRise(address yRiseAddress,address ContractTokenAddress) external onlyRewardDistribution {
654         setContractToken(ContractTokenAddress);
655         yrise = IERC20(yRiseAddress);
656     }
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
684     function stake(uint256 amount) public updateReward(msg.sender) {
685         require(amount > 0, "Cannot stake 0");
686         require(amount >= 1e18, "Minimum stake 1 yRise");
687         super.stake(amount);
688         emit Staked(msg.sender, amount);
689     }
690 
691     function withdraw(uint256 amount) public updateReward(msg.sender) {
692         require(amount > 0, "Cannot withdraw 0");
693         super.withdraw(amount);
694         emit Withdrawn(msg.sender, amount);
695     }
696 
697     function exit() external {
698         withdraw(balanceOf(msg.sender));
699         getReward();
700     }
701 
702     function getReward() public updateReward(msg.sender) {
703         uint256 reward = earned(msg.sender);
704         if (reward > 0) {
705             rewards[msg.sender] = 0;
706             yrise.safeTransfer(msg.sender, reward);
707             emit RewardPaid(msg.sender, reward);
708         }
709     }
710 
711     function notifyRewardAmount(uint256 reward)
712         external
713         onlyRewardDistribution
714         updateReward(address(0))
715     {
716         if (block.timestamp >= periodFinish) {
717             rewardRate = reward.div(DURATION);
718         } else {
719             uint256 remaining = periodFinish.sub(block.timestamp);
720             uint256 leftover = remaining.mul(rewardRate);
721             rewardRate = reward.add(leftover).div(DURATION);
722         }
723         lastUpdateTime = block.timestamp;
724         periodFinish = block.timestamp.add(DURATION);
725         emit RewardAdded(reward);
726     }
727 }