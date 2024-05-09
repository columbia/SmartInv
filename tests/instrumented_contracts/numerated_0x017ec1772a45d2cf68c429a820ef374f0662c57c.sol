1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-29
3 */
4 
5 // File: contracts/Storage.sol
6 
7 pragma solidity 0.5.16;
8 
9 contract Storage {
10 
11   address public governance;
12   address public controller;
13 
14   constructor() public {
15     governance = msg.sender;
16   }
17 
18   modifier onlyGovernance() {
19     require(isGovernance(msg.sender), "Not governance");
20     _;
21   }
22 
23   function setGovernance(address _governance) public onlyGovernance {
24     require(_governance != address(0), "new governance shouldn't be empty");
25     governance = _governance;
26   }
27 
28   function setController(address _controller) public onlyGovernance {
29     require(_controller != address(0), "new controller shouldn't be empty");
30     controller = _controller;
31   }
32 
33   function isGovernance(address account) public view returns (bool) {
34     return account == governance;
35   }
36 
37   function isController(address account) public view returns (bool) {
38     return account == controller;
39   }
40 }
41 
42 // File: contracts/Governable.sol
43 
44 pragma solidity 0.5.16;
45 
46 
47 contract Governable {
48 
49   Storage public store;
50 
51   constructor(address _store) public {
52     require(_store != address(0), "new storage shouldn't be empty");
53     store = Storage(_store);
54   }
55 
56   modifier onlyGovernance() {
57     require(store.isGovernance(msg.sender), "Not governance");
58     _;
59   }
60 
61   function setStorage(address _store) public onlyGovernance {
62     require(_store != address(0), "new storage shouldn't be empty");
63     store = Storage(_store);
64   }
65 
66   function governance() public view returns (address) {
67     return store.governance();
68   }
69 }
70 
71 // File: contracts/Controllable.sol
72 
73 pragma solidity 0.5.16;
74 
75 
76 contract Controllable is Governable {
77 
78   constructor(address _storage) Governable(_storage) public {
79   }
80 
81   modifier onlyController() {
82     require(store.isController(msg.sender), "Not a controller");
83     _;
84   }
85 
86   modifier onlyControllerOrGovernance(){
87     require((store.isController(msg.sender) || store.isGovernance(msg.sender)),
88       "The caller must be controller or governance");
89     _;
90   }
91 
92   function controller() public view returns (address) {
93     return store.controller();
94   }
95 }
96 
97 // File: contracts/hardworkInterface/IController.sol
98 
99 pragma solidity 0.5.16;
100 
101 interface IController {
102     // [Grey list]
103     // An EOA can safely interact with the system no matter what.
104     // If you're using Metamask, you're using an EOA.
105     // Only smart contracts may be affected by this grey list.
106     //
107     // This contract will not be able to ban any EOA from the system
108     // even if an EOA is being added to the greyList, he/she will still be able
109     // to interact with the whole system as if nothing happened.
110     // Only smart contracts will be affected by being added to the greyList.
111     // This grey list is only used in Vault.sol, see the code there for reference
112     function greyList(address _target) external view returns(bool);
113 
114     function addVaultAndStrategy(address _vault, address _strategy) external;
115     function doHardWork(address _vault) external;
116     function hasVault(address _vault) external returns(bool);
117 
118     function salvage(address _token, uint256 amount) external;
119     function salvageStrategy(address _strategy, address _token, uint256 amount) external;
120 
121     function notifyFee(address _underlying, uint256 fee) external;
122     function profitSharingNumerator() external view returns (uint256);
123     function profitSharingDenominator() external view returns (uint256);
124 }
125 
126 // File: contracts/RewardPool.sol
127 
128 // https://etherscan.io/address/0xDCB6A51eA3CA5d3Fd898Fd6564757c7aAeC3ca92#code
129 
130 /**
131  *Submitted for verification at Etherscan.io on 2020-04-22
132 */
133 
134 /*
135    ____            __   __        __   _
136   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
137  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
138 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
139      /___/
140 
141 * Synthetix: CurveRewards.sol
142 *
143 * Docs: https://docs.synthetix.io/
144 *
145 *
146 * MIT License
147 * ===========
148 *
149 * Copyright (c) 2020 Synthetix
150 *
151 * Permission is hereby granted, free of charge, to any person obtaining a copy
152 * of this software and associated documentation files (the "Software"), to deal
153 * in the Software without restriction, including without limitation the rights
154 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
155 * copies of the Software, and to permit persons to whom the Software is
156 * furnished to do so, subject to the following conditions:
157 *
158 * The above copyright notice and this permission notice shall be included in all
159 * copies or substantial portions of the Software.
160 *
161 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
162 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
163 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
164 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
165 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
166 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
167 */
168 
169 // File: @openzeppelin/contracts/math/Math.sol
170 
171 pragma solidity ^0.5.0;
172 
173 
174 
175 /**
176  * @dev Standard math utilities missing in the Solidity language.
177  */
178 library Math {
179     /**
180      * @dev Returns the largest of two numbers.
181      */
182     function max(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a >= b ? a : b;
184     }
185 
186     /**
187      * @dev Returns the smallest of two numbers.
188      */
189     function min(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a < b ? a : b;
191     }
192 
193     /**
194      * @dev Returns the average of two numbers. The result is rounded towards
195      * zero.
196      */
197     function average(uint256 a, uint256 b) internal pure returns (uint256) {
198         // (a + b) / 2 can overflow, so we distribute
199         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
200     }
201 }
202 
203 // File: @openzeppelin/contracts/math/SafeMath.sol
204 
205 pragma solidity ^0.5.0;
206 
207 /**
208  * @dev Wrappers over Solidity's arithmetic operations with added overflow
209  * checks.
210  *
211  * Arithmetic operations in Solidity wrap on overflow. This can easily result
212  * in bugs, because programmers usually assume that an overflow raises an
213  * error, which is the standard behavior in high level programming languages.
214  * `SafeMath` restores this intuition by reverting the transaction when an
215  * operation overflows.
216  *
217  * Using this library instead of the unchecked operations eliminates an entire
218  * class of bugs, so it's recommended to use it always.
219  */
220 library SafeMath {
221     /**
222      * @dev Returns the addition of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `+` operator.
226      *
227      * Requirements:
228      * - Addition cannot overflow.
229      */
230     function add(uint256 a, uint256 b) internal pure returns (uint256) {
231         uint256 c = a + b;
232         require(c >= a, "SafeMath: addition overflow");
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the subtraction of two unsigned integers, reverting on
239      * overflow (when the result is negative).
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      * - Subtraction cannot overflow.
245      */
246     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247         return sub(a, b, "SafeMath: subtraction overflow");
248     }
249 
250     /**
251      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
252      * overflow (when the result is negative).
253      *
254      * Counterpart to Solidity's `-` operator.
255      *
256      * Requirements:
257      * - Subtraction cannot overflow.
258      *
259      * _Available since v2.4.0._
260      */
261     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b <= a, errorMessage);
263         uint256 c = a - b;
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the multiplication of two unsigned integers, reverting on
270      * overflow.
271      *
272      * Counterpart to Solidity's `*` operator.
273      *
274      * Requirements:
275      * - Multiplication cannot overflow.
276      */
277     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
279         // benefit is lost if 'b' is also tested.
280         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
281         if (a == 0) {
282             return 0;
283         }
284 
285         uint256 c = a * b;
286         require(c / a == b, "SafeMath: multiplication overflow");
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers. Reverts on
293      * division by zero. The result is rounded towards zero.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function div(uint256 a, uint256 b) internal pure returns (uint256) {
303         return div(a, b, "SafeMath: division by zero");
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
308      * division by zero. The result is rounded towards zero.
309      *
310      * Counterpart to Solidity's `/` operator. Note: this function uses a
311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
312      * uses an invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      * - The divisor cannot be zero.
316      *
317      * _Available since v2.4.0._
318      */
319     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         // Solidity only automatically asserts when dividing by 0
321         require(b > 0, errorMessage);
322         uint256 c = a / b;
323         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
324 
325         return c;
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * Reverts when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      * - The divisor cannot be zero.
338      */
339     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
340         return mod(a, b, "SafeMath: modulo by zero");
341     }
342 
343     /**
344      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
345      * Reverts with custom message when dividing by zero.
346      *
347      * Counterpart to Solidity's `%` operator. This function uses a `revert`
348      * opcode (which leaves remaining gas untouched) while Solidity uses an
349      * invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      * - The divisor cannot be zero.
353      *
354      * _Available since v2.4.0._
355      */
356     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
357         require(b != 0, errorMessage);
358         return a % b;
359     }
360 }
361 
362 // File: @openzeppelin/contracts/GSN/Context.sol
363 
364 pragma solidity ^0.5.0;
365 
366 /*
367  * @dev Provides information about the current execution context, including the
368  * sender of the transaction and its data. While these are generally available
369  * via msg.sender and msg.data, they should not be accessed in such a direct
370  * manner, since when dealing with GSN meta-transactions the account sending and
371  * paying for execution may not be the actual sender (as far as an application
372  * is concerned).
373  *
374  * This contract is only required for intermediate, library-like contracts.
375  */
376 contract Context {
377     // Empty internal constructor, to prevent people from mistakenly deploying
378     // an instance of this contract, which should be used via inheritance.
379     constructor () internal { }
380     // solhint-disable-previous-line no-empty-blocks
381 
382     function _msgSender() internal view returns (address payable) {
383         return msg.sender;
384     }
385 
386     function _msgData() internal view returns (bytes memory) {
387         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
388         return msg.data;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/ownership/Ownable.sol
393 
394 pragma solidity ^0.5.0;
395 
396 /**
397  * @dev Contract module which provides a basic access control mechanism, where
398  * there is an account (an owner) that can be granted exclusive access to
399  * specific functions.
400  *
401  * This module is used through inheritance. It will make available the modifier
402  * `onlyOwner`, which can be applied to your functions to restrict their use to
403  * the owner.
404  */
405 contract Ownable is Context {
406     address private _owner;
407 
408     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
409 
410     /**
411      * @dev Initializes the contract setting the deployer as the initial owner.
412      */
413     constructor () internal {
414         _owner = _msgSender();
415         emit OwnershipTransferred(address(0), _owner);
416     }
417 
418     /**
419      * @dev Returns the address of the current owner.
420      */
421     function owner() public view returns (address) {
422         return _owner;
423     }
424 
425     /**
426      * @dev Throws if called by any account other than the owner.
427      */
428     modifier onlyOwner() {
429         require(isOwner(), "Ownable: caller is not the owner");
430         _;
431     }
432 
433     /**
434      * @dev Returns true if the caller is the current owner.
435      */
436     function isOwner() public view returns (bool) {
437         return _msgSender() == _owner;
438     }
439 
440     /**
441      * @dev Leaves the contract without owner. It will not be possible to call
442      * `onlyOwner` functions anymore. Can only be called by the current owner.
443      *
444      * NOTE: Renouncing ownership will leave the contract without an owner,
445      * thereby removing any functionality that is only available to the owner.
446      */
447     function renounceOwnership() public onlyOwner {
448         emit OwnershipTransferred(_owner, address(0));
449         _owner = address(0);
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public onlyOwner {
457         _transferOwnership(newOwner);
458     }
459 
460     /**
461      * @dev Transfers ownership of the contract to a new account (`newOwner`).
462      */
463     function _transferOwnership(address newOwner) internal {
464         require(newOwner != address(0), "Ownable: new owner is the zero address");
465         emit OwnershipTransferred(_owner, newOwner);
466         _owner = newOwner;
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
471 
472 pragma solidity ^0.5.0;
473 
474 /**
475  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
476  * the optional functions; to access them see {ERC20Detailed}.
477  */
478 interface IERC20 {
479     /**
480      * @dev Returns the amount of tokens in existence.
481      */
482     function totalSupply() external view returns (uint256);
483 
484     /**
485      * @dev Returns the amount of tokens owned by `account`.
486      */
487     function balanceOf(address account) external view returns (uint256);
488 
489     /**
490      * @dev Moves `amount` tokens from the caller's account to `recipient`.
491      *
492      * Returns a boolean value indicating whether the operation succeeded.
493      *
494      * Emits a {Transfer} event.
495      */
496     function transfer(address recipient, uint256 amount) external returns (bool);
497 
498     /**
499      * @dev Returns the remaining number of tokens that `spender` will be
500      * allowed to spend on behalf of `owner` through {transferFrom}. This is
501      * zero by default.
502      *
503      * This value changes when {approve} or {transferFrom} are called.
504      */
505     function allowance(address owner, address spender) external view returns (uint256);
506 
507     /**
508      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
509      *
510      * Returns a boolean value indicating whether the operation succeeded.
511      *
512      * IMPORTANT: Beware that changing an allowance with this method brings the risk
513      * that someone may use both the old and the new allowance by unfortunate
514      * transaction ordering. One possible solution to mitigate this race
515      * condition is to first reduce the spender's allowance to 0 and set the
516      * desired value afterwards:
517      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
518      *
519      * Emits an {Approval} event.
520      */
521     function approve(address spender, uint256 amount) external returns (bool);
522 
523     /**
524      * @dev Moves `amount` tokens from `sender` to `recipient` using the
525      * allowance mechanism. `amount` is then deducted from the caller's
526      * allowance.
527      *
528      * Returns a boolean value indicating whether the operation succeeded.
529      *
530      * Emits a {Transfer} event.
531      */
532     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
533 
534     /**
535      * @dev Emitted when `value` tokens are moved from one account (`from`) to
536      * another (`to`).
537      *
538      * Note that `value` may be zero.
539      */
540     event Transfer(address indexed from, address indexed to, uint256 value);
541 
542     /**
543      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
544      * a call to {approve}. `value` is the new allowance.
545      */
546     event Approval(address indexed owner, address indexed spender, uint256 value);
547 }
548 
549 // File: @openzeppelin/contracts/utils/Address.sol
550 
551 pragma solidity ^0.5.5;
552 
553 /**
554  * @dev Collection of functions related to the address type
555  */
556 library Address {
557     /**
558      * @dev Returns true if `account` is a contract.
559      *
560      * This test is non-exhaustive, and there may be false-negatives: during the
561      * execution of a contract's constructor, its address will be reported as
562      * not containing a contract.
563      *
564      * IMPORTANT: It is unsafe to assume that an address for which this
565      * function returns false is an externally-owned account (EOA) and not a
566      * contract.
567      */
568     function isContract(address account) internal view returns (bool) {
569         // This method relies in extcodesize, which returns 0 for contracts in
570         // construction, since the code is only stored at the end of the
571         // constructor execution.
572 
573         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
574         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
575         // for accounts without code, i.e. `keccak256('')`
576         bytes32 codehash;
577         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
578         // solhint-disable-next-line no-inline-assembly
579         assembly { codehash := extcodehash(account) }
580         return (codehash != 0x0 && codehash != accountHash);
581     }
582 
583     /**
584      * @dev Converts an `address` into `address payable`. Note that this is
585      * simply a type cast: the actual underlying value is not changed.
586      *
587      * _Available since v2.4.0._
588      */
589     function toPayable(address account) internal pure returns (address payable) {
590         return address(uint160(account));
591     }
592 
593     /**
594      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
595      * `recipient`, forwarding all available gas and reverting on errors.
596      *
597      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
598      * of certain opcodes, possibly making contracts go over the 2300 gas limit
599      * imposed by `transfer`, making them unable to receive funds via
600      * `transfer`. {sendValue} removes this limitation.
601      *
602      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
603      *
604      * IMPORTANT: because control is transferred to `recipient`, care must be
605      * taken to not create reentrancy vulnerabilities. Consider using
606      * {ReentrancyGuard} or the
607      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
608      *
609      * _Available since v2.4.0._
610      */
611     function sendValue(address payable recipient, uint256 amount) internal {
612         require(address(this).balance >= amount, "Address: insufficient balance");
613 
614         // solhint-disable-next-line avoid-call-value
615         (bool success, ) = recipient.call.value(amount)("");
616         require(success, "Address: unable to send value, recipient may have reverted");
617     }
618 }
619 
620 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
621 
622 pragma solidity ^0.5.0;
623 
624 
625 
626 
627 /**
628  * @title SafeERC20
629  * @dev Wrappers around ERC20 operations that throw on failure (when the token
630  * contract returns false). Tokens that return no value (and instead revert or
631  * throw on failure) are also supported, non-reverting calls are assumed to be
632  * successful.
633  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
634  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
635  */
636 library SafeERC20 {
637     using SafeMath for uint256;
638     using Address for address;
639 
640     function safeTransfer(IERC20 token, address to, uint256 value) internal {
641         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
642     }
643 
644     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
645         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
646     }
647 
648     function safeApprove(IERC20 token, address spender, uint256 value) internal {
649         // safeApprove should only be called when setting an initial allowance,
650         // or when resetting it to zero. To increase and decrease it, use
651         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
652         // solhint-disable-next-line max-line-length
653         require((value == 0) || (token.allowance(address(this), spender) == 0),
654             "SafeERC20: approve from non-zero to non-zero allowance"
655         );
656         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
657     }
658 
659     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
660         uint256 newAllowance = token.allowance(address(this), spender).add(value);
661         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
662     }
663 
664     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
665         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
666         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
667     }
668 
669     /**
670      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
671      * on the return value: the return value is optional (but if data is returned, it must not be false).
672      * @param token The token targeted by the call.
673      * @param data The call data (encoded using abi.encode or one of its variants).
674      */
675     function callOptionalReturn(IERC20 token, bytes memory data) private {
676         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
677         // we're implementing it ourselves.
678 
679         // A Solidity high level call has three parts:
680         //  1. The target address is checked to verify it contains contract code
681         //  2. The call itself is made, and success asserted
682         //  3. The return value is decoded, which in turn checks the size of the returned data.
683         // solhint-disable-next-line max-line-length
684         require(address(token).isContract(), "SafeERC20: call to non-contract");
685 
686         // solhint-disable-next-line avoid-low-level-calls
687         (bool success, bytes memory returndata) = address(token).call(data);
688         require(success, "SafeERC20: low-level call failed");
689 
690         if (returndata.length > 0) { // Return data is optional
691             // solhint-disable-next-line max-line-length
692             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
693         }
694     }
695 }
696 
697 // File: contracts/IRewardDistributionRecipient.sol
698 
699 pragma solidity ^0.5.0;
700 
701 
702 
703 contract IRewardDistributionRecipient is Ownable {
704     address rewardDistribution;
705 
706     constructor(address _rewardDistribution) public {
707         rewardDistribution = _rewardDistribution;
708     }
709 
710     function notifyRewardAmount(uint256 reward) external;
711 
712     modifier onlyRewardDistribution() {
713         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
714         _;
715     }
716 
717     function setRewardDistribution(address _rewardDistribution)
718         external
719         onlyOwner
720     {
721         rewardDistribution = _rewardDistribution;
722     }
723 }
724 
725 // File: contracts/CurveRewards.sol
726 
727 pragma solidity ^0.5.0;
728 
729 
730 
731 
732 /*
733 *   Changes made to the SynthetixReward contract
734 *
735 *   uni to lpToken, and make it as a parameter of the constructor instead of hardcoded.
736 *
737 *
738 */
739 
740 contract LPTokenWrapper {
741     using SafeMath for uint256;
742     using SafeERC20 for IERC20;
743 
744     IERC20 public lpToken;
745 
746     uint256 private _totalSupply;
747     mapping(address => uint256) private _balances;
748 
749     function totalSupply() public view returns (uint256) {
750         return _totalSupply;
751     }
752 
753     function balanceOf(address account) public view returns (uint256) {
754         return _balances[account];
755     }
756 
757     function stake(uint256 amount) public {
758         _totalSupply = _totalSupply.add(amount);
759         _balances[msg.sender] = _balances[msg.sender].add(amount);
760         lpToken.safeTransferFrom(msg.sender, address(this), amount);
761     }
762 
763     function withdraw(uint256 amount) public {
764         _totalSupply = _totalSupply.sub(amount);
765         _balances[msg.sender] = _balances[msg.sender].sub(amount);
766         lpToken.safeTransfer(msg.sender, amount);
767     }
768 
769     // Harvest migrate
770     // only called by the migrateStakeFor in the MigrationHelperRewardPool
771     function migrateStakeFor(address target, uint256 amountNewShare) internal  {
772       _totalSupply = _totalSupply.add(amountNewShare);
773       _balances[target] = _balances[target].add(amountNewShare);
774     }
775 }
776 
777 /*
778 *   [Harvest]
779 *   This pool doesn't mint.
780 *   the rewards should be first transferred to this pool, then get "notified"
781 *   by calling `notifyRewardAmount`
782 */
783 
784 contract NoMintRewardPool is LPTokenWrapper, IRewardDistributionRecipient, Controllable {
785 
786     using Address for address;
787 
788     IERC20 public rewardToken;
789     uint256 public duration; // making it not a constant is less gas efficient, but portable
790 
791     uint256 public periodFinish = 0;
792     uint256 public rewardRate = 0;
793     uint256 public lastUpdateTime;
794     uint256 public rewardPerTokenStored;
795     mapping(address => uint256) public userRewardPerTokenPaid;
796     mapping(address => uint256) public rewards;
797 
798     mapping (address => bool) smartContractStakers;
799 
800     // Harvest Migration
801     // lpToken is the target vault
802     address public sourceVault;
803     address public migrationStrategy;
804     bool public canMigrate;
805 
806     event RewardAdded(uint256 reward);
807     event Staked(address indexed user, uint256 amount);
808     event Withdrawn(address indexed user, uint256 amount);
809     event RewardPaid(address indexed user, uint256 reward);
810     event RewardDenied(address indexed user, uint256 reward);
811     event SmartContractRecorded(address indexed smartContractAddress, address indexed smartContractInitiator);
812 
813     // Harvest Migration
814     event Migrated(address indexed account, uint256 legacyShare, uint256 newShare);
815 
816     modifier updateReward(address account) {
817         rewardPerTokenStored = rewardPerToken();
818         lastUpdateTime = lastTimeRewardApplicable();
819         if (account != address(0)) {
820             rewards[account] = earned(account);
821             userRewardPerTokenPaid[account] = rewardPerTokenStored;
822         }
823         _;
824     }
825 
826     modifier onlyMigrationStrategy() {
827       require(msg.sender == migrationStrategy, "sender needs to be migration strategy");
828       _;
829     }
830 
831     // [Hardwork] setting the reward, lpToken, duration, and rewardDistribution for each pool
832     constructor(address _rewardToken,
833         address _lpToken,
834         uint256 _duration,
835         address _rewardDistribution,
836         address _storage,
837         address _sourceVault,
838         address _migrationStrategy) public
839     IRewardDistributionRecipient(_rewardDistribution)
840     Controllable(_storage) // only used for referencing the grey list
841     {
842         rewardToken = IERC20(_rewardToken);
843         lpToken = IERC20(_lpToken);
844         duration = _duration;
845         sourceVault = _sourceVault;
846         migrationStrategy = _migrationStrategy;
847     }
848 
849     function lastTimeRewardApplicable() public view returns (uint256) {
850         return Math.min(block.timestamp, periodFinish);
851     }
852 
853     function rewardPerToken() public view returns (uint256) {
854         if (totalSupply() == 0) {
855             return rewardPerTokenStored;
856         }
857         return
858             rewardPerTokenStored.add(
859                 lastTimeRewardApplicable()
860                     .sub(lastUpdateTime)
861                     .mul(rewardRate)
862                     .mul(1e18)
863                     .div(totalSupply())
864             );
865     }
866 
867     function earned(address account) public view returns (uint256) {
868         return
869             balanceOf(account)
870                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
871                 .div(1e18)
872                 .add(rewards[account]);
873     }
874 
875     // stake visibility is public as overriding LPTokenWrapper's stake() function
876     function stake(uint256 amount) public updateReward(msg.sender) {
877         require(amount > 0, "Cannot stake 0");
878         recordSmartContract();
879 
880         super.stake(amount);
881         emit Staked(msg.sender, amount);
882     }
883 
884     function withdraw(uint256 amount) public updateReward(msg.sender) {
885         require(amount > 0, "Cannot withdraw 0");
886         super.withdraw(amount);
887         emit Withdrawn(msg.sender, amount);
888     }
889 
890     function exit() external {
891         withdraw(balanceOf(msg.sender));
892         getReward();
893     }
894 
895     /// A push mechanism for accounts that have not claimed their rewards for a long time.
896     /// The implementation is semantically analogous to getReward(), but uses a push pattern
897     /// instead of pull pattern.
898     function pushReward(address recipient) public updateReward(recipient) onlyGovernance {
899         uint256 reward = earned(recipient);
900         if (reward > 0) {
901             rewards[recipient] = 0;
902             // If it is a normal user and not smart contract,
903             // then the requirement will pass
904             // If it is a smart contract, then
905             // make sure that it is not on our greyList.
906             if (!recipient.isContract() || !IController(controller()).greyList(recipient)) {
907                 rewardToken.safeTransfer(recipient, reward);
908                 emit RewardPaid(recipient, reward);
909             } else {
910                 emit RewardDenied(recipient, reward);
911             }
912         }
913     }
914 
915     function getReward() public updateReward(msg.sender) {
916         uint256 reward = earned(msg.sender);
917         if (reward > 0) {
918             rewards[msg.sender] = 0;
919             // If it is a normal user and not smart contract,
920             // then the requirement will pass
921             // If it is a smart contract, then
922             // make sure that it is not on our greyList.
923             if (tx.origin == msg.sender || !IController(controller()).greyList(msg.sender)) {
924                 rewardToken.safeTransfer(msg.sender, reward);
925                 emit RewardPaid(msg.sender, reward);
926             } else {
927                 emit RewardDenied(msg.sender, reward);
928             }
929         }
930     }
931 
932     function notifyRewardAmount(uint256 reward)
933         external
934         onlyRewardDistribution
935         updateReward(address(0))
936     {
937         // overflow fix according to https://sips.synthetix.io/sips/sip-77
938         require(reward < uint(-1) / 1e18, "the notified reward cannot invoke multiplication overflow");
939 
940         if (block.timestamp >= periodFinish) {
941             rewardRate = reward.div(duration);
942         } else {
943             uint256 remaining = periodFinish.sub(block.timestamp);
944             uint256 leftover = remaining.mul(rewardRate);
945             rewardRate = reward.add(leftover).div(duration);
946         }
947         lastUpdateTime = block.timestamp;
948         periodFinish = block.timestamp.add(duration);
949         emit RewardAdded(reward);
950     }
951 
952     // Harvest Smart Contract recording
953     function recordSmartContract() internal {
954       if( tx.origin != msg.sender ) {
955         smartContractStakers[msg.sender] = true;
956         emit SmartContractRecorded(msg.sender, tx.origin);
957       }
958     }
959 
960 
961     // Harvest Migrate
962 
963     function setCanMigrate(bool _canMigrate) public onlyGovernance {
964       canMigrate = _canMigrate;
965     }
966 
967     // obtain the legacy vault sahres from the migration strategy
968     function pullFromStrategy() public onlyMigrationStrategy {
969       canMigrate = true;
970       lpToken.safeTransferFrom(msg.sender, address(this),lpToken.balanceOf(msg.sender));
971     }
972 
973     // called only by migrate() 
974     function migrateStakeFor(address target, uint256 amountNewShare) internal updateReward(target) {
975       super.migrateStakeFor(target, amountNewShare);
976       emit Staked(target, amountNewShare);
977     }
978 
979     // The MigrationHelperReward Pool already holds the shares of the targetVault
980     // the users are coming with the old share to exchange for the new one
981     // We want to incentivize the user to migrate, thus we will not stake for them before they migrate.
982     // We also want to save user some hassle, thus when user migrate, we will automatically stake for them
983 
984     function migrate() external {
985       require(canMigrate, "Funds not yet migrated");
986       recordSmartContract();
987 
988       // casting here for readability
989       address targetVault = address(lpToken);
990 
991       // total legacy share - migrated legacy shares
992       // What happens when people wrongfully send their shares directly to this pool
993       // without using the migrate() function? The people that are properly migrating would benefit from this.
994       uint256 remainingLegacyShares = (IERC20(sourceVault).totalSupply()).sub(IERC20(sourceVault).balanceOf(address(this)));
995 
996       // How many new shares does this contract hold?
997       // We cannot get this just by IERC20(targetVault).balanceOf(address(this))
998       // because this contract itself is a reward pool where they stake those vault shares
999       // luckily, reward pool share and the underlying lp token works in 1:1
1000       // _totalSupply is the amount that is staked
1001       uint256 unmigratedNewShares = IERC20(targetVault).balanceOf(address(this)).sub(totalSupply());
1002       uint256 userLegacyShares = IERC20(sourceVault).balanceOf(msg.sender);
1003       require(userLegacyShares <= remainingLegacyShares, "impossible for user legacy share to have more than the remaining legacy share");
1004 
1005       // Because of the assertion above, 
1006       // we know for sure that userEquivalentNewShares must be less than unmigratedNewShares (the idle tokens sitting in this contract)
1007       uint256 userEquivalentNewShares = userLegacyShares.mul(unmigratedNewShares).div(remainingLegacyShares);
1008       
1009       // Take the old shares from user
1010       IERC20(sourceVault).safeTransferFrom(msg.sender, address(this), userLegacyShares);
1011       
1012       // User has now migrated, let's stake the idle tokens into the pool for the user
1013       migrateStakeFor(msg.sender, userEquivalentNewShares);
1014 
1015       emit Migrated(msg.sender, userLegacyShares, userEquivalentNewShares);
1016     }
1017 }