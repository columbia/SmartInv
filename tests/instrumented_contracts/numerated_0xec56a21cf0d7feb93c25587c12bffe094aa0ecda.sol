1 // File: contracts/Storage.sol
2 
3 pragma solidity 0.5.16;
4 
5 contract Storage {
6 
7   address public governance;
8   address public controller;
9 
10   constructor() public {
11     governance = msg.sender;
12   }
13 
14   modifier onlyGovernance() {
15     require(isGovernance(msg.sender), "Not governance");
16     _;
17   }
18 
19   function setGovernance(address _governance) public onlyGovernance {
20     require(_governance != address(0), "new governance shouldn't be empty");
21     governance = _governance;
22   }
23 
24   function setController(address _controller) public onlyGovernance {
25     require(_controller != address(0), "new controller shouldn't be empty");
26     controller = _controller;
27   }
28 
29   function isGovernance(address account) public view returns (bool) {
30     return account == governance;
31   }
32 
33   function isController(address account) public view returns (bool) {
34     return account == controller;
35   }
36 }
37 
38 // File: contracts/Governable.sol
39 
40 pragma solidity 0.5.16;
41 
42 
43 contract Governable {
44 
45   Storage public store;
46 
47   constructor(address _store) public {
48     require(_store != address(0), "new storage shouldn't be empty");
49     store = Storage(_store);
50   }
51 
52   modifier onlyGovernance() {
53     require(store.isGovernance(msg.sender), "Not governance");
54     _;
55   }
56 
57   function setStorage(address _store) public onlyGovernance {
58     require(_store != address(0), "new storage shouldn't be empty");
59     store = Storage(_store);
60   }
61 
62   function governance() public view returns (address) {
63     return store.governance();
64   }
65 }
66 
67 // File: contracts/Controllable.sol
68 
69 pragma solidity 0.5.16;
70 
71 
72 contract Controllable is Governable {
73 
74   constructor(address _storage) Governable(_storage) public {
75   }
76 
77   modifier onlyController() {
78     require(store.isController(msg.sender), "Not a controller");
79     _;
80   }
81 
82   modifier onlyControllerOrGovernance(){
83     require((store.isController(msg.sender) || store.isGovernance(msg.sender)),
84       "The caller must be controller or governance");
85     _;
86   }
87 
88   function controller() public view returns (address) {
89     return store.controller();
90   }
91 }
92 
93 // File: contracts/hardworkInterface/IController.sol
94 
95 pragma solidity 0.5.16;
96 
97 interface IController {
98     // [Grey list]
99     // An EOA can safely interact with the system no matter what.
100     // If you're using Metamask, you're using an EOA.
101     // Only smart contracts may be affected by this grey list.
102     //
103     // This contract will not be able to ban any EOA from the system
104     // even if an EOA is being added to the greyList, he/she will still be able
105     // to interact with the whole system as if nothing happened.
106     // Only smart contracts will be affected by being added to the greyList.
107     // This grey list is only used in Vault.sol, see the code there for reference
108     function greyList(address _target) external view returns(bool);
109 
110     function addVaultAndStrategy(address _vault, address _strategy) external;
111     function doHardWork(address _vault) external;
112     function hasVault(address _vault) external returns(bool);
113 
114     function salvage(address _token, uint256 amount) external;
115     function salvageStrategy(address _strategy, address _token, uint256 amount) external;
116 
117     function notifyFee(address _underlying, uint256 fee) external;
118     function profitSharingNumerator() external view returns (uint256);
119     function profitSharingDenominator() external view returns (uint256);
120 }
121 
122 // File: contracts/RewardPool.sol
123 
124 // https://etherscan.io/address/0xDCB6A51eA3CA5d3Fd898Fd6564757c7aAeC3ca92#code
125 
126 /**
127  *Submitted for verification at Etherscan.io on 2020-04-22
128 */
129 
130 /*
131    ____            __   __        __   _
132   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
133  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
134 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
135      /___/
136 
137 * Synthetix: CurveRewards.sol
138 *
139 * Docs: https://docs.synthetix.io/
140 *
141 *
142 * MIT License
143 * ===========
144 *
145 * Copyright (c) 2020 Synthetix
146 *
147 * Permission is hereby granted, free of charge, to any person obtaining a copy
148 * of this software and associated documentation files (the "Software"), to deal
149 * in the Software without restriction, including without limitation the rights
150 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
151 * copies of the Software, and to permit persons to whom the Software is
152 * furnished to do so, subject to the following conditions:
153 *
154 * The above copyright notice and this permission notice shall be included in all
155 * copies or substantial portions of the Software.
156 *
157 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
158 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
159 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
160 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
161 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
162 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
163 */
164 
165 // File: @openzeppelin/contracts/math/Math.sol
166 
167 pragma solidity ^0.5.0;
168 
169 
170 
171 /**
172  * @dev Standard math utilities missing in the Solidity language.
173  */
174 library Math {
175     /**
176      * @dev Returns the largest of two numbers.
177      */
178     function max(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a >= b ? a : b;
180     }
181 
182     /**
183      * @dev Returns the smallest of two numbers.
184      */
185     function min(uint256 a, uint256 b) internal pure returns (uint256) {
186         return a < b ? a : b;
187     }
188 
189     /**
190      * @dev Returns the average of two numbers. The result is rounded towards
191      * zero.
192      */
193     function average(uint256 a, uint256 b) internal pure returns (uint256) {
194         // (a + b) / 2 can overflow, so we distribute
195         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
196     }
197 }
198 
199 // File: @openzeppelin/contracts/math/SafeMath.sol
200 
201 pragma solidity ^0.5.0;
202 
203 /**
204  * @dev Wrappers over Solidity's arithmetic operations with added overflow
205  * checks.
206  *
207  * Arithmetic operations in Solidity wrap on overflow. This can easily result
208  * in bugs, because programmers usually assume that an overflow raises an
209  * error, which is the standard behavior in high level programming languages.
210  * `SafeMath` restores this intuition by reverting the transaction when an
211  * operation overflows.
212  *
213  * Using this library instead of the unchecked operations eliminates an entire
214  * class of bugs, so it's recommended to use it always.
215  */
216 library SafeMath {
217     /**
218      * @dev Returns the addition of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `+` operator.
222      *
223      * Requirements:
224      * - Addition cannot overflow.
225      */
226     function add(uint256 a, uint256 b) internal pure returns (uint256) {
227         uint256 c = a + b;
228         require(c >= a, "SafeMath: addition overflow");
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the subtraction of two unsigned integers, reverting on
235      * overflow (when the result is negative).
236      *
237      * Counterpart to Solidity's `-` operator.
238      *
239      * Requirements:
240      * - Subtraction cannot overflow.
241      */
242     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243         return sub(a, b, "SafeMath: subtraction overflow");
244     }
245 
246     /**
247      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
248      * overflow (when the result is negative).
249      *
250      * Counterpart to Solidity's `-` operator.
251      *
252      * Requirements:
253      * - Subtraction cannot overflow.
254      *
255      * _Available since v2.4.0._
256      */
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         uint256 c = a - b;
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the multiplication of two unsigned integers, reverting on
266      * overflow.
267      *
268      * Counterpart to Solidity's `*` operator.
269      *
270      * Requirements:
271      * - Multiplication cannot overflow.
272      */
273     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
275         // benefit is lost if 'b' is also tested.
276         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
277         if (a == 0) {
278             return 0;
279         }
280 
281         uint256 c = a * b;
282         require(c / a == b, "SafeMath: multiplication overflow");
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers. Reverts on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
299         return div(a, b, "SafeMath: division by zero");
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
304      * division by zero. The result is rounded towards zero.
305      *
306      * Counterpart to Solidity's `/` operator. Note: this function uses a
307      * `revert` opcode (which leaves remaining gas untouched) while Solidity
308      * uses an invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      * - The divisor cannot be zero.
312      *
313      * _Available since v2.4.0._
314      */
315     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         // Solidity only automatically asserts when dividing by 0
317         require(b > 0, errorMessage);
318         uint256 c = a / b;
319         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
320 
321         return c;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * Reverts when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         return mod(a, b, "SafeMath: modulo by zero");
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * Reverts with custom message when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      * - The divisor cannot be zero.
349      *
350      * _Available since v2.4.0._
351      */
352     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
353         require(b != 0, errorMessage);
354         return a % b;
355     }
356 }
357 
358 // File: @openzeppelin/contracts/GSN/Context.sol
359 
360 pragma solidity ^0.5.0;
361 
362 /*
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with GSN meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 contract Context {
373     // Empty internal constructor, to prevent people from mistakenly deploying
374     // an instance of this contract, which should be used via inheritance.
375     constructor () internal { }
376     // solhint-disable-previous-line no-empty-blocks
377 
378     function _msgSender() internal view returns (address payable) {
379         return msg.sender;
380     }
381 
382     function _msgData() internal view returns (bytes memory) {
383         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
384         return msg.data;
385     }
386 }
387 
388 // File: @openzeppelin/contracts/ownership/Ownable.sol
389 
390 pragma solidity ^0.5.0;
391 
392 /**
393  * @dev Contract module which provides a basic access control mechanism, where
394  * there is an account (an owner) that can be granted exclusive access to
395  * specific functions.
396  *
397  * This module is used through inheritance. It will make available the modifier
398  * `onlyOwner`, which can be applied to your functions to restrict their use to
399  * the owner.
400  */
401 contract Ownable is Context {
402     address private _owner;
403 
404     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
405 
406     /**
407      * @dev Initializes the contract setting the deployer as the initial owner.
408      */
409     constructor () internal {
410         _owner = _msgSender();
411         emit OwnershipTransferred(address(0), _owner);
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(isOwner(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429     /**
430      * @dev Returns true if the caller is the current owner.
431      */
432     function isOwner() public view returns (bool) {
433         return _msgSender() == _owner;
434     }
435 
436     /**
437      * @dev Leaves the contract without owner. It will not be possible to call
438      * `onlyOwner` functions anymore. Can only be called by the current owner.
439      *
440      * NOTE: Renouncing ownership will leave the contract without an owner,
441      * thereby removing any functionality that is only available to the owner.
442      */
443     function renounceOwnership() public onlyOwner {
444         emit OwnershipTransferred(_owner, address(0));
445         _owner = address(0);
446     }
447 
448     /**
449      * @dev Transfers ownership of the contract to a new account (`newOwner`).
450      * Can only be called by the current owner.
451      */
452     function transferOwnership(address newOwner) public onlyOwner {
453         _transferOwnership(newOwner);
454     }
455 
456     /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      */
459     function _transferOwnership(address newOwner) internal {
460         require(newOwner != address(0), "Ownable: new owner is the zero address");
461         emit OwnershipTransferred(_owner, newOwner);
462         _owner = newOwner;
463     }
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
467 
468 pragma solidity ^0.5.0;
469 
470 /**
471  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
472  * the optional functions; to access them see {ERC20Detailed}.
473  */
474 interface IERC20 {
475     /**
476      * @dev Returns the amount of tokens in existence.
477      */
478     function totalSupply() external view returns (uint256);
479 
480     /**
481      * @dev Returns the amount of tokens owned by `account`.
482      */
483     function balanceOf(address account) external view returns (uint256);
484 
485     /**
486      * @dev Moves `amount` tokens from the caller's account to `recipient`.
487      *
488      * Returns a boolean value indicating whether the operation succeeded.
489      *
490      * Emits a {Transfer} event.
491      */
492     function transfer(address recipient, uint256 amount) external returns (bool);
493 
494     /**
495      * @dev Returns the remaining number of tokens that `spender` will be
496      * allowed to spend on behalf of `owner` through {transferFrom}. This is
497      * zero by default.
498      *
499      * This value changes when {approve} or {transferFrom} are called.
500      */
501     function allowance(address owner, address spender) external view returns (uint256);
502 
503     /**
504      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
505      *
506      * Returns a boolean value indicating whether the operation succeeded.
507      *
508      * IMPORTANT: Beware that changing an allowance with this method brings the risk
509      * that someone may use both the old and the new allowance by unfortunate
510      * transaction ordering. One possible solution to mitigate this race
511      * condition is to first reduce the spender's allowance to 0 and set the
512      * desired value afterwards:
513      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
514      *
515      * Emits an {Approval} event.
516      */
517     function approve(address spender, uint256 amount) external returns (bool);
518 
519     /**
520      * @dev Moves `amount` tokens from `sender` to `recipient` using the
521      * allowance mechanism. `amount` is then deducted from the caller's
522      * allowance.
523      *
524      * Returns a boolean value indicating whether the operation succeeded.
525      *
526      * Emits a {Transfer} event.
527      */
528     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
529 
530     /**
531      * @dev Emitted when `value` tokens are moved from one account (`from`) to
532      * another (`to`).
533      *
534      * Note that `value` may be zero.
535      */
536     event Transfer(address indexed from, address indexed to, uint256 value);
537 
538     /**
539      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
540      * a call to {approve}. `value` is the new allowance.
541      */
542     event Approval(address indexed owner, address indexed spender, uint256 value);
543 }
544 
545 // File: @openzeppelin/contracts/utils/Address.sol
546 
547 pragma solidity ^0.5.5;
548 
549 /**
550  * @dev Collection of functions related to the address type
551  */
552 library Address {
553     /**
554      * @dev Returns true if `account` is a contract.
555      *
556      * This test is non-exhaustive, and there may be false-negatives: during the
557      * execution of a contract's constructor, its address will be reported as
558      * not containing a contract.
559      *
560      * IMPORTANT: It is unsafe to assume that an address for which this
561      * function returns false is an externally-owned account (EOA) and not a
562      * contract.
563      */
564     function isContract(address account) internal view returns (bool) {
565         // This method relies in extcodesize, which returns 0 for contracts in
566         // construction, since the code is only stored at the end of the
567         // constructor execution.
568 
569         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
570         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
571         // for accounts without code, i.e. `keccak256('')`
572         bytes32 codehash;
573         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
574         // solhint-disable-next-line no-inline-assembly
575         assembly { codehash := extcodehash(account) }
576         return (codehash != 0x0 && codehash != accountHash);
577     }
578 
579     /**
580      * @dev Converts an `address` into `address payable`. Note that this is
581      * simply a type cast: the actual underlying value is not changed.
582      *
583      * _Available since v2.4.0._
584      */
585     function toPayable(address account) internal pure returns (address payable) {
586         return address(uint160(account));
587     }
588 
589     /**
590      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
591      * `recipient`, forwarding all available gas and reverting on errors.
592      *
593      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
594      * of certain opcodes, possibly making contracts go over the 2300 gas limit
595      * imposed by `transfer`, making them unable to receive funds via
596      * `transfer`. {sendValue} removes this limitation.
597      *
598      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
599      *
600      * IMPORTANT: because control is transferred to `recipient`, care must be
601      * taken to not create reentrancy vulnerabilities. Consider using
602      * {ReentrancyGuard} or the
603      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
604      *
605      * _Available since v2.4.0._
606      */
607     function sendValue(address payable recipient, uint256 amount) internal {
608         require(address(this).balance >= amount, "Address: insufficient balance");
609 
610         // solhint-disable-next-line avoid-call-value
611         (bool success, ) = recipient.call.value(amount)("");
612         require(success, "Address: unable to send value, recipient may have reverted");
613     }
614 }
615 
616 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
617 
618 pragma solidity ^0.5.0;
619 
620 
621 
622 
623 /**
624  * @title SafeERC20
625  * @dev Wrappers around ERC20 operations that throw on failure (when the token
626  * contract returns false). Tokens that return no value (and instead revert or
627  * throw on failure) are also supported, non-reverting calls are assumed to be
628  * successful.
629  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
630  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
631  */
632 library SafeERC20 {
633     using SafeMath for uint256;
634     using Address for address;
635 
636     function safeTransfer(IERC20 token, address to, uint256 value) internal {
637         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
638     }
639 
640     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
641         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
642     }
643 
644     function safeApprove(IERC20 token, address spender, uint256 value) internal {
645         // safeApprove should only be called when setting an initial allowance,
646         // or when resetting it to zero. To increase and decrease it, use
647         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
648         // solhint-disable-next-line max-line-length
649         require((value == 0) || (token.allowance(address(this), spender) == 0),
650             "SafeERC20: approve from non-zero to non-zero allowance"
651         );
652         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
653     }
654 
655     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
656         uint256 newAllowance = token.allowance(address(this), spender).add(value);
657         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
658     }
659 
660     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
661         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
662         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
663     }
664 
665     /**
666      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
667      * on the return value: the return value is optional (but if data is returned, it must not be false).
668      * @param token The token targeted by the call.
669      * @param data The call data (encoded using abi.encode or one of its variants).
670      */
671     function callOptionalReturn(IERC20 token, bytes memory data) private {
672         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
673         // we're implementing it ourselves.
674 
675         // A Solidity high level call has three parts:
676         //  1. The target address is checked to verify it contains contract code
677         //  2. The call itself is made, and success asserted
678         //  3. The return value is decoded, which in turn checks the size of the returned data.
679         // solhint-disable-next-line max-line-length
680         require(address(token).isContract(), "SafeERC20: call to non-contract");
681 
682         // solhint-disable-next-line avoid-low-level-calls
683         (bool success, bytes memory returndata) = address(token).call(data);
684         require(success, "SafeERC20: low-level call failed");
685 
686         if (returndata.length > 0) { // Return data is optional
687             // solhint-disable-next-line max-line-length
688             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
689         }
690     }
691 }
692 
693 // File: contracts/IRewardDistributionRecipient.sol
694 
695 pragma solidity ^0.5.0;
696 
697 
698 
699 contract IRewardDistributionRecipient is Ownable {
700     address rewardDistribution;
701 
702     constructor(address _rewardDistribution) public {
703         rewardDistribution = _rewardDistribution;
704     }
705 
706     function notifyRewardAmount(uint256 reward) external;
707 
708     modifier onlyRewardDistribution() {
709         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
710         _;
711     }
712 
713     function setRewardDistribution(address _rewardDistribution)
714         external
715         onlyOwner
716     {
717         rewardDistribution = _rewardDistribution;
718     }
719 }
720 
721 // File: contracts/CurveRewards.sol
722 
723 pragma solidity ^0.5.0;
724 
725 
726 
727 
728 /*
729 *   Changes made to the SynthetixReward contract
730 *
731 *   uni to lpToken, and make it as a parameter of the constructor instead of hardcoded.
732 *
733 *
734 */
735 
736 contract LPTokenWrapper {
737     using SafeMath for uint256;
738     using SafeERC20 for IERC20;
739 
740     IERC20 public lpToken;
741 
742     uint256 private _totalSupply;
743     mapping(address => uint256) private _balances;
744 
745     function totalSupply() public view returns (uint256) {
746         return _totalSupply;
747     }
748 
749     function balanceOf(address account) public view returns (uint256) {
750         return _balances[account];
751     }
752 
753     function stake(uint256 amount) public {
754         _totalSupply = _totalSupply.add(amount);
755         _balances[msg.sender] = _balances[msg.sender].add(amount);
756         lpToken.safeTransferFrom(msg.sender, address(this), amount);
757     }
758 
759     function withdraw(uint256 amount) public {
760         _totalSupply = _totalSupply.sub(amount);
761         _balances[msg.sender] = _balances[msg.sender].sub(amount);
762         lpToken.safeTransfer(msg.sender, amount);
763     }
764 }
765 
766 /*
767 *   [Hardwork]
768 *   This pool doesn't mint.
769 *   the rewards should be first transferred to this pool, then get "notified"
770 *   by calling `notifyRewardAmount`
771 */
772 
773 contract NoMintRewardPool is LPTokenWrapper, IRewardDistributionRecipient, Controllable {
774 
775     using Address for address;
776 
777     IERC20 public rewardToken;
778     uint256 public duration; // making it not a constant is less gas efficient, but portable
779 
780     uint256 public periodFinish = 0;
781     uint256 public rewardRate = 0;
782     uint256 public lastUpdateTime;
783     uint256 public rewardPerTokenStored;
784     mapping(address => uint256) public userRewardPerTokenPaid;
785     mapping(address => uint256) public rewards;
786 
787     event RewardAdded(uint256 reward);
788     event Staked(address indexed user, uint256 amount);
789     event Withdrawn(address indexed user, uint256 amount);
790     event RewardPaid(address indexed user, uint256 reward);
791     event RewardDenied(address indexed user, uint256 reward);
792 
793     modifier updateReward(address account) {
794         rewardPerTokenStored = rewardPerToken();
795         lastUpdateTime = lastTimeRewardApplicable();
796         if (account != address(0)) {
797             rewards[account] = earned(account);
798             userRewardPerTokenPaid[account] = rewardPerTokenStored;
799         }
800         _;
801     }
802 
803     // [Hardwork] setting the reward, lpToken, duration, and rewardDistribution for each pool
804     constructor(address _rewardToken,
805         address _lpToken,
806         uint256 _duration,
807         address _rewardDistribution,
808         address _storage) public
809     IRewardDistributionRecipient(_rewardDistribution)
810     Controllable(_storage) // only used for referencing the grey list
811     {
812         rewardToken = IERC20(_rewardToken);
813         lpToken = IERC20(_lpToken);
814         duration = _duration;
815     }
816 
817     function lastTimeRewardApplicable() public view returns (uint256) {
818         return Math.min(block.timestamp, periodFinish);
819     }
820 
821     function rewardPerToken() public view returns (uint256) {
822         if (totalSupply() == 0) {
823             return rewardPerTokenStored;
824         }
825         return
826             rewardPerTokenStored.add(
827                 lastTimeRewardApplicable()
828                     .sub(lastUpdateTime)
829                     .mul(rewardRate)
830                     .mul(1e18)
831                     .div(totalSupply())
832             );
833     }
834 
835     function earned(address account) public view returns (uint256) {
836         return
837             balanceOf(account)
838                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
839                 .div(1e18)
840                 .add(rewards[account]);
841     }
842 
843     // stake visibility is public as overriding LPTokenWrapper's stake() function
844     function stake(uint256 amount) public updateReward(msg.sender) {
845         require(amount > 0, "Cannot stake 0");
846         super.stake(amount);
847         emit Staked(msg.sender, amount);
848     }
849 
850     function withdraw(uint256 amount) public updateReward(msg.sender) {
851         require(amount > 0, "Cannot withdraw 0");
852         super.withdraw(amount);
853         emit Withdrawn(msg.sender, amount);
854     }
855 
856     function exit() external {
857         withdraw(balanceOf(msg.sender));
858         getReward();
859     }
860 
861     /// A push mechanism for accounts that have not claimed their rewards for a long time.
862     /// The implementation is semantically analogous to getReward(), but uses a push pattern
863     /// instead of pull pattern.
864     function pushReward(address recipient) public updateReward(recipient) onlyGovernance {
865         uint256 reward = earned(recipient);
866         if (reward > 0) {
867             rewards[recipient] = 0;
868             // If it is a normal user and not smart contract,
869             // then the requirement will pass
870             // If it is a smart contract, then
871             // make sure that it is not on our greyList.
872             if (!recipient.isContract() || !IController(controller()).greyList(recipient)) {
873                 rewardToken.safeTransfer(recipient, reward);
874                 emit RewardPaid(recipient, reward);
875             } else {
876                 emit RewardDenied(recipient, reward);
877             }
878         }
879     }
880 
881     function getReward() public updateReward(msg.sender) {
882         uint256 reward = earned(msg.sender);
883         if (reward > 0) {
884             rewards[msg.sender] = 0;
885             // If it is a normal user and not smart contract,
886             // then the requirement will pass
887             // If it is a smart contract, then
888             // make sure that it is not on our greyList.
889             if (tx.origin == msg.sender || !IController(controller()).greyList(msg.sender)) {
890                 rewardToken.safeTransfer(msg.sender, reward);
891                 emit RewardPaid(msg.sender, reward);
892             } else {
893                 emit RewardDenied(msg.sender, reward);
894             }
895         }
896     }
897 
898     function notifyRewardAmount(uint256 reward)
899         external
900         onlyRewardDistribution
901         updateReward(address(0))
902     {
903         if (block.timestamp >= periodFinish) {
904             rewardRate = reward.div(duration);
905         } else {
906             uint256 remaining = periodFinish.sub(block.timestamp);
907             uint256 leftover = remaining.mul(rewardRate);
908             rewardRate = reward.add(leftover).div(duration);
909         }
910         lastUpdateTime = block.timestamp;
911         periodFinish = block.timestamp.add(duration);
912         emit RewardAdded(reward);
913     }
914 }