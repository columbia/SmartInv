1 /*
2 https://powerpool.finance/
3 
4           wrrrw r wrr
5          ppwr rrr wppr0       prwwwrp                                 prwwwrp                   wr0
6         rr 0rrrwrrprpwp0      pp   pr  prrrr0 pp   0r  prrrr0  0rwrrr pp   pr  prrrr0  prrrr0    r0
7         rrp pr   wr00rrp      prwww0  pp   wr pp w00r prwwwpr  0rw    prwww0  pp   wr pp   wr    r0
8         r0rprprwrrrp pr0      pp      wr   pr pp rwwr wr       0r     pp      wr   pr wr   pr    r0
9          prwr wrr0wpwr        00        www0   0w0ww    www0   0w     00        www0    www0   0www0
10           wrr ww0rrrr
11 
12 */
13 
14 // File: @openzeppelin/contracts/math/SafeMath.sol
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.6.0;
19 
20 /**
21  * @dev Wrappers over Solidity's arithmetic operations with added overflow
22  * checks.
23  *
24  * Arithmetic operations in Solidity wrap on overflow. This can easily result
25  * in bugs, because programmers usually assume that an overflow raises an
26  * error, which is the standard behavior in high level programming languages.
27  * `SafeMath` restores this intuition by reverting the transaction when an
28  * operation overflows.
29  *
30  * Using this library instead of the unchecked operations eliminates an entire
31  * class of bugs, so it's recommended to use it always.
32  */
33 library SafeMath {
34     /**
35      * @dev Returns the addition of two unsigned integers, reverting on
36      * overflow.
37      *
38      * Counterpart to Solidity's `+` operator.
39      *
40      * Requirements:
41      *
42      * - Addition cannot overflow.
43      */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      *
73      * - Subtraction cannot overflow.
74      */
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the multiplication of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `*` operator.
87      *
88      * Requirements:
89      *
90      * - Multiplication cannot overflow.
91      */
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
94         // benefit is lost if 'b' is also tested.
95         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
96         if (a == 0) {
97             return 0;
98         }
99 
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b > 0, errorMessage);
136         uint256 c = a / b;
137         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return mod(a, b, "SafeMath: modulo by zero");
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts with custom message when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b != 0, errorMessage);
172         return a % b;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
177 
178 pragma solidity ^0.6.0;
179 
180 /**
181  * @dev Interface of the ERC20 standard as defined in the EIP.
182  */
183 interface IERC20 {
184     /**
185      * @dev Returns the amount of tokens in existence.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns the amount of tokens owned by `account`.
191      */
192     function balanceOf(address account) external view returns (uint256);
193 
194     /**
195      * @dev Moves `amount` tokens from the caller's account to `recipient`.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transfer(address recipient, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Returns the remaining number of tokens that `spender` will be
205      * allowed to spend on behalf of `owner` through {transferFrom}. This is
206      * zero by default.
207      *
208      * This value changes when {approve} or {transferFrom} are called.
209      */
210     function allowance(address owner, address spender) external view returns (uint256);
211 
212     /**
213      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * IMPORTANT: Beware that changing an allowance with this method brings the risk
218      * that someone may use both the old and the new allowance by unfortunate
219      * transaction ordering. One possible solution to mitigate this race
220      * condition is to first reduce the spender's allowance to 0 and set the
221      * desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address spender, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Moves `amount` tokens from `sender` to `recipient` using the
230      * allowance mechanism. `amount` is then deducted from the caller's
231      * allowance.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a {Transfer} event.
236      */
237     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Emitted when `value` tokens are moved from one account (`from`) to
241      * another (`to`).
242      *
243      * Note that `value` may be zero.
244      */
245     event Transfer(address indexed from, address indexed to, uint256 value);
246 
247     /**
248      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
249      * a call to {approve}. `value` is the new allowance.
250      */
251     event Approval(address indexed owner, address indexed spender, uint256 value);
252 }
253 
254 // File: @openzeppelin/contracts/utils/Address.sol
255 
256 pragma solidity ^0.6.2;
257 
258 /**
259  * @dev Collection of functions related to the address type
260  */
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // This method relies in extcodesize, which returns 0 for contracts in
281         // construction, since the code is only stored at the end of the
282         // constructor execution.
283 
284         uint256 size;
285         // solhint-disable-next-line no-inline-assembly
286         assembly { size := extcodesize(account) }
287         return size > 0;
288     }
289 
290     /**
291      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292      * `recipient`, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by `transfer`, making them unable to receive funds via
297      * `transfer`. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to `recipient`, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      */
306     function sendValue(address payable recipient, uint256 amount) internal {
307         require(address(this).balance >= amount, "Address: insufficient balance");
308 
309         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
310         (bool success, ) = recipient.call{ value: amount }("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain`call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333       return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338      * `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
343         return _functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
368         require(address(this).balance >= value, "Address: insufficient balance for call");
369         return _functionCallWithValue(target, data, value, errorMessage);
370     }
371 
372     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
373         require(isContract(target), "Address: call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383 
384                 // solhint-disable-next-line no-inline-assembly
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
397 
398 pragma solidity ^0.6.0;
399 
400 
401 
402 
403 /**
404  * @title SafeERC20
405  * @dev Wrappers around ERC20 operations that throw on failure (when the token
406  * contract returns false). Tokens that return no value (and instead revert or
407  * throw on failure) are also supported, non-reverting calls are assumed to be
408  * successful.
409  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
410  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
411  */
412 library SafeERC20 {
413     using SafeMath for uint256;
414     using Address for address;
415 
416     function safeTransfer(IERC20 token, address to, uint256 value) internal {
417         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
418     }
419 
420     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
421         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
422     }
423 
424     /**
425      * @dev Deprecated. This function has issues similar to the ones found in
426      * {IERC20-approve}, and its usage is discouraged.
427      *
428      * Whenever possible, use {safeIncreaseAllowance} and
429      * {safeDecreaseAllowance} instead.
430      */
431     function safeApprove(IERC20 token, address spender, uint256 value) internal {
432         // safeApprove should only be called when setting an initial allowance,
433         // or when resetting it to zero. To increase and decrease it, use
434         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
435         // solhint-disable-next-line max-line-length
436         require((value == 0) || (token.allowance(address(this), spender) == 0),
437             "SafeERC20: approve from non-zero to non-zero allowance"
438         );
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
440     }
441 
442     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).add(value);
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
448         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
449         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
450     }
451 
452     /**
453      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
454      * on the return value: the return value is optional (but if data is returned, it must not be false).
455      * @param token The token targeted by the call.
456      * @param data The call data (encoded using abi.encode or one of its variants).
457      */
458     function _callOptionalReturn(IERC20 token, bytes memory data) private {
459         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
460         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
461         // the target address contains contract code and also asserts for success in the low-level call.
462 
463         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
464         if (returndata.length > 0) { // Return data is optional
465             // solhint-disable-next-line max-line-length
466             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
467         }
468     }
469 }
470 
471 // File: @openzeppelin/contracts/GSN/Context.sol
472 
473 pragma solidity ^0.6.0;
474 
475 /*
476  * @dev Provides information about the current execution context, including the
477  * sender of the transaction and its data. While these are generally available
478  * via msg.sender and msg.data, they should not be accessed in such a direct
479  * manner, since when dealing with GSN meta-transactions the account sending and
480  * paying for execution may not be the actual sender (as far as an application
481  * is concerned).
482  *
483  * This contract is only required for intermediate, library-like contracts.
484  */
485 abstract contract Context {
486     function _msgSender() internal view virtual returns (address payable) {
487         return msg.sender;
488     }
489 
490     function _msgData() internal view virtual returns (bytes memory) {
491         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
492         return msg.data;
493     }
494 }
495 
496 // File: @openzeppelin/contracts/access/Ownable.sol
497 
498 pragma solidity ^0.6.0;
499 
500 /**
501  * @dev Contract module which provides a basic access control mechanism, where
502  * there is an account (an owner) that can be granted exclusive access to
503  * specific functions.
504  *
505  * By default, the owner account will be the one that deploys the contract. This
506  * can later be changed with {transferOwnership}.
507  *
508  * This module is used through inheritance. It will make available the modifier
509  * `onlyOwner`, which can be applied to your functions to restrict their use to
510  * the owner.
511  */
512 contract Ownable is Context {
513     address private _owner;
514 
515     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
516 
517     /**
518      * @dev Initializes the contract setting the deployer as the initial owner.
519      */
520     constructor () internal {
521         address msgSender = _msgSender();
522         _owner = msgSender;
523         emit OwnershipTransferred(address(0), msgSender);
524     }
525 
526     /**
527      * @dev Returns the address of the current owner.
528      */
529     function owner() public view returns (address) {
530         return _owner;
531     }
532 
533     /**
534      * @dev Throws if called by any account other than the owner.
535      */
536     modifier onlyOwner() {
537         require(_owner == _msgSender(), "Ownable: caller is not the owner");
538         _;
539     }
540 
541     /**
542      * @dev Leaves the contract without owner. It will not be possible to call
543      * `onlyOwner` functions anymore. Can only be called by the current owner.
544      *
545      * NOTE: Renouncing ownership will leave the contract without an owner,
546      * thereby removing any functionality that is only available to the owner.
547      */
548     function renounceOwnership() public virtual onlyOwner {
549         emit OwnershipTransferred(_owner, address(0));
550         _owner = address(0);
551     }
552 
553     /**
554      * @dev Transfers ownership of the contract to a new account (`newOwner`).
555      * Can only be called by the current owner.
556      */
557     function transferOwnership(address newOwner) public virtual onlyOwner {
558         require(newOwner != address(0), "Ownable: new owner is the zero address");
559         emit OwnershipTransferred(_owner, newOwner);
560         _owner = newOwner;
561     }
562 }
563 
564 // File: contracts/interfaces/BMathInterface.sol
565 
566 pragma solidity 0.6.12;
567 
568 interface BMathInterface {
569   function calcInGivenOut(
570     uint256 tokenBalanceIn,
571     uint256 tokenWeightIn,
572     uint256 tokenBalanceOut,
573     uint256 tokenWeightOut,
574     uint256 tokenAmountOut,
575     uint256 swapFee
576   ) external pure returns (uint256 tokenAmountIn);
577 }
578 
579 // File: contracts/interfaces/BPoolInterface.sol
580 
581 pragma solidity 0.6.12;
582 
583 
584 
585 interface BPoolInterface is IERC20, BMathInterface {
586   function joinPool(uint256 poolAmountOut, uint256[] calldata maxAmountsIn) external;
587 
588   function exitPool(uint256 poolAmountIn, uint256[] calldata minAmountsOut) external;
589 
590   function swapExactAmountIn(
591     address,
592     uint256,
593     address,
594     uint256,
595     uint256
596   ) external returns (uint256, uint256);
597 
598   function swapExactAmountOut(
599     address,
600     uint256,
601     address,
602     uint256,
603     uint256
604   ) external returns (uint256, uint256);
605 
606   function joinswapExternAmountIn(
607     address,
608     uint256,
609     uint256
610   ) external returns (uint256);
611 
612   function joinswapPoolAmountOut(
613     address,
614     uint256,
615     uint256
616   ) external returns (uint256);
617 
618   function exitswapPoolAmountIn(
619     address,
620     uint256,
621     uint256
622   ) external returns (uint256);
623 
624   function exitswapExternAmountOut(
625     address,
626     uint256,
627     uint256
628   ) external returns (uint256);
629 
630   function getDenormalizedWeight(address) external view returns (uint256);
631 
632   function getBalance(address) external view returns (uint256);
633 
634   function getSwapFee() external view returns (uint256);
635 
636   function getTotalDenormalizedWeight() external view returns (uint256);
637 
638   function getCommunityFee()
639     external
640     view
641     returns (
642       uint256,
643       uint256,
644       uint256,
645       address
646     );
647 
648   function calcAmountWithCommunityFee(
649     uint256,
650     uint256,
651     address
652   ) external view returns (uint256, uint256);
653 
654   function getRestrictions() external view returns (address);
655 
656   function isPublicSwap() external view returns (bool);
657 
658   function isFinalized() external view returns (bool);
659 
660   function isBound(address t) external view returns (bool);
661 
662   function getCurrentTokens() external view returns (address[] memory tokens);
663 
664   function getFinalTokens() external view returns (address[] memory tokens);
665 
666   function setSwapFee(uint256) external;
667 
668   function setCommunityFeeAndReceiver(
669     uint256,
670     uint256,
671     uint256,
672     address
673   ) external;
674 
675   function setController(address) external;
676 
677   function setPublicSwap(bool) external;
678 
679   function finalize() external;
680 
681   function bind(
682     address,
683     uint256,
684     uint256
685   ) external;
686 
687   function rebind(
688     address,
689     uint256,
690     uint256
691   ) external;
692 
693   function unbind(address) external;
694 
695   function callVoting(
696     address voting,
697     bytes4 signature,
698     bytes calldata args,
699     uint256 value
700   ) external;
701 
702   function getMinWeight() external view returns (uint256);
703 
704   function getMaxBoundTokens() external view returns (uint256);
705 }
706 
707 // File: contracts/interfaces/TokenInterface.sol
708 
709 pragma solidity 0.6.12;
710 
711 
712 interface TokenInterface is IERC20 {
713   function deposit() external payable;
714 
715   function withdraw(uint256) external;
716 }
717 
718 // File: contracts/interfaces/IPoolRestrictions.sol
719 
720 pragma solidity 0.6.12;
721 
722 interface IPoolRestrictions {
723   function getMaxTotalSupply(address _pool) external view returns (uint256);
724 
725   function isVotingSignatureAllowed(address _votingAddress, bytes4 _signature) external view returns (bool);
726 
727   function isVotingSenderAllowed(address _votingAddress, address _sender) external view returns (bool);
728 
729   function isWithoutFee(address _addr) external view returns (bool);
730 }
731 
732 // File: contracts/interfaces/IUniswapV2Pair.sol
733 
734 pragma solidity >=0.5.0;
735 
736 interface IUniswapV2Pair {
737   event Approval(address indexed owner, address indexed spender, uint256 value);
738   event Transfer(address indexed from, address indexed to, uint256 value);
739 
740   function name() external pure returns (string memory);
741 
742   function symbol() external pure returns (string memory);
743 
744   function decimals() external pure returns (uint8);
745 
746   function totalSupply() external view returns (uint256);
747 
748   function balanceOf(address owner) external view returns (uint256);
749 
750   function allowance(address owner, address spender) external view returns (uint256);
751 
752   function approve(address spender, uint256 value) external returns (bool);
753 
754   function transfer(address to, uint256 value) external returns (bool);
755 
756   function transferFrom(
757     address from,
758     address to,
759     uint256 value
760   ) external returns (bool);
761 
762   function DOMAIN_SEPARATOR() external view returns (bytes32);
763 
764   function PERMIT_TYPEHASH() external pure returns (bytes32);
765 
766   function nonces(address owner) external view returns (uint256);
767 
768   function permit(
769     address owner,
770     address spender,
771     uint256 value,
772     uint256 deadline,
773     uint8 v,
774     bytes32 r,
775     bytes32 s
776   ) external;
777 
778   event Mint(address indexed sender, uint256 amount0, uint256 amount1);
779   event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
780   event Swap(
781     address indexed sender,
782     uint256 amount0In,
783     uint256 amount1In,
784     uint256 amount0Out,
785     uint256 amount1Out,
786     address indexed to
787   );
788   event Sync(uint112 reserve0, uint112 reserve1);
789 
790   function MINIMUM_LIQUIDITY() external pure returns (uint256);
791 
792   function factory() external view returns (address);
793 
794   function token0() external view returns (address);
795 
796   function token1() external view returns (address);
797 
798   function getReserves()
799     external
800     view
801     returns (
802       uint112 reserve0,
803       uint112 reserve1,
804       uint32 blockTimestampLast
805     );
806 
807   function price0CumulativeLast() external view returns (uint256);
808 
809   function price1CumulativeLast() external view returns (uint256);
810 
811   function kLast() external view returns (uint256);
812 
813   function mint(address to) external returns (uint256 liquidity);
814 
815   function burn(address to) external returns (uint256 amount0, uint256 amount1);
816 
817   function swap(
818     uint256 amount0Out,
819     uint256 amount1Out,
820     address to,
821     bytes calldata data
822   ) external;
823 
824   function skim(address to) external;
825 
826   function sync() external;
827 
828   function initialize(address, address) external;
829 }
830 
831 // File: contracts/interfaces/IUniswapV2Factory.sol
832 
833 pragma solidity >=0.5.0;
834 
835 interface IUniswapV2Factory {
836   event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
837 
838   function feeTo() external view returns (address);
839 
840   function feeToSetter() external view returns (address);
841 
842   function migrator() external view returns (address);
843 
844   function getPair(address tokenA, address tokenB) external view returns (address pair);
845 
846   function allPairs(uint256) external view returns (address pair);
847 
848   function allPairsLength() external view returns (uint256);
849 
850   function createPair(address tokenA, address tokenB) external returns (address pair);
851 
852   function setFeeTo(address) external;
853 
854   function setFeeToSetter(address) external;
855 
856   function setMigrator(address) external;
857 }
858 
859 // File: contracts/lib/SafeMathUniswap.sol
860 
861 pragma solidity =0.6.12;
862 
863 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
864 
865 library SafeMathUniswap {
866     function add(uint x, uint y) internal pure returns (uint z) {
867         require((z = x + y) >= x, 'ds-math-add-overflow');
868     }
869 
870     function sub(uint x, uint y) internal pure returns (uint z) {
871         require((z = x - y) <= x, 'ds-math-sub-underflow');
872     }
873 
874     function mul(uint x, uint y) internal pure returns (uint z) {
875         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
876     }
877 }
878 
879 // File: contracts/lib/UniswapV2Library.sol
880 
881 pragma solidity >=0.5.0;
882 
883 
884 
885 library UniswapV2Library {
886     using SafeMathUniswap for uint;
887 
888     // returns sorted token addresses, used to handle return values from pairs sorted in this order
889     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
890         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
891         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
892         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
893     }
894 
895     // calculates the CREATE2 address for a pair without making any external calls
896     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
897         (address token0, address token1) = sortTokens(tokenA, tokenB);
898         pair = address(uint(keccak256(abi.encodePacked(
899                 hex'ff',
900                 factory,
901                 keccak256(abi.encodePacked(token0, token1)),
902                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
903             ))));
904     }
905 
906     // fetches and sorts the reserves for a pair
907     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
908         (address token0,) = sortTokens(tokenA, tokenB);
909         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
910         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
911     }
912 
913     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
914     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
915         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
916         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
917         amountB = amountA.mul(reserveB) / reserveA;
918     }
919 
920     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
921     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
922         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
923         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
924         uint amountInWithFee = amountIn.mul(997);
925         uint numerator = amountInWithFee.mul(reserveOut);
926         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
927         amountOut = numerator / denominator;
928     }
929 
930     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
931     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
932         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
933         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
934         uint numerator = reserveIn.mul(amountOut).mul(1000);
935         uint denominator = reserveOut.sub(amountOut).mul(997);
936         amountIn = (numerator / denominator).add(1);
937     }
938 
939     // performs chained getAmountOut calculations on any number of pairs
940     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
941         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
942         amounts = new uint[](path.length);
943         amounts[0] = amountIn;
944         for (uint i; i < path.length - 1; i++) {
945             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
946             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
947         }
948     }
949 
950     // performs chained getAmountIn calculations on any number of pairs
951     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
952         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
953         amounts = new uint[](path.length);
954         amounts[amounts.length - 1] = amountOut;
955         for (uint i = path.length - 1; i > 0; i--) {
956             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
957             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
958         }
959     }
960 }
961 
962 // File: contracts/EthPiptSwap.sol
963 
964 pragma solidity 0.6.12;
965 
966 
967 
968 
969 
970 
971 
972 
973 
974 
975 
976 contract EthPiptSwap is Ownable {
977   using SafeMath for uint256;
978   using SafeERC20 for IERC20;
979   using SafeERC20 for TokenInterface;
980   using SafeERC20 for BPoolInterface;
981 
982   TokenInterface public weth;
983   TokenInterface public cvp;
984   BPoolInterface public pipt;
985 
986   uint256[] public feeLevels;
987   uint256[] public feeAmounts;
988   address public feePayout;
989   address public feeManager;
990 
991   mapping(address => address) public uniswapEthPairByTokenAddress;
992   mapping(address => bool) public reApproveTokens;
993   uint256 public defaultSlippage;
994 
995   struct CalculationStruct {
996     uint256 tokenAmount;
997     uint256 ethAmount;
998     uint256 tokenReserve;
999     uint256 ethReserve;
1000   }
1001 
1002   event SetTokenSetting(address indexed token, bool indexed reApprove, address indexed uniswapPair);
1003   event SetDefaultSlippage(uint256 newDefaultSlippage);
1004   event SetFees(
1005     address indexed sender,
1006     uint256[] newFeeLevels,
1007     uint256[] newFeeAmounts,
1008     address indexed feePayout,
1009     address indexed feeManager
1010   );
1011 
1012   event EthToPiptSwap(
1013     address indexed user,
1014     uint256 ethInAmount,
1015     uint256 ethSwapFee,
1016     uint256 poolOutAmount,
1017     uint256 poolCommunityFee
1018   );
1019   event OddEth(address indexed user, uint256 amount);
1020   event PiptToEthSwap(
1021     address indexed user,
1022     uint256 poolInAmount,
1023     uint256 poolCommunityFee,
1024     uint256 ethOutAmount,
1025     uint256 ethSwapFee
1026   );
1027   event PayoutCVP(address indexed receiver, uint256 wethAmount, uint256 cvpAmount);
1028 
1029   constructor(
1030     address _weth,
1031     address _cvp,
1032     address _pipt,
1033     address _feeManager
1034   ) public Ownable() {
1035     weth = TokenInterface(_weth);
1036     cvp = TokenInterface(_cvp);
1037     pipt = BPoolInterface(_pipt);
1038     feeManager = _feeManager;
1039     defaultSlippage = 0.02 ether;
1040   }
1041 
1042   modifier onlyFeeManagerOrOwner() {
1043     require(msg.sender == feeManager || msg.sender == owner(), "NOT_FEE_MANAGER");
1044     _;
1045   }
1046 
1047   receive() external payable {
1048     if (msg.sender != tx.origin) {
1049       return;
1050     }
1051     swapEthToPipt(defaultSlippage);
1052   }
1053 
1054   function swapEthToPipt(uint256 _slippage) public payable {
1055     (, uint256 swapAmount) = calcEthFee(msg.value);
1056 
1057     address[] memory tokens = pipt.getCurrentTokens();
1058 
1059     (, , uint256 poolAmountOut) = calcSwapEthToPiptInputs(swapAmount, tokens, _slippage);
1060 
1061     weth.deposit{ value: msg.value }();
1062 
1063     _swapWethToPiptByPoolOut(msg.value, poolAmountOut);
1064   }
1065 
1066   function swapEthToPiptByPoolOut(uint256 _poolAmountOut) external payable {
1067     weth.deposit{ value: msg.value }();
1068 
1069     _swapWethToPiptByPoolOut(msg.value, _poolAmountOut);
1070   }
1071 
1072   function swapPiptToEth(uint256 _poolAmountIn) external {
1073     uint256 ethOutAmount = _swapPiptToWeth(_poolAmountIn);
1074 
1075     weth.withdraw(ethOutAmount);
1076     msg.sender.transfer(ethOutAmount);
1077   }
1078 
1079   function convertOddToCvpAndSendToPayout(address[] memory oddTokens) external {
1080     require(msg.sender == tx.origin && !Address.isContract(msg.sender), "CONTRACT_NOT_ALLOWED");
1081 
1082     uint256 len = oddTokens.length;
1083 
1084     for (uint256 i = 0; i < len; i++) {
1085       uint256 tokenBalance = TokenInterface(oddTokens[i]).balanceOf(address(this));
1086       IUniswapV2Pair tokenPair = _uniswapPairFor(oddTokens[i]);
1087 
1088       (uint256 tokenReserve, uint256 ethReserve, ) = tokenPair.getReserves();
1089       uint256 wethOut = UniswapV2Library.getAmountOut(tokenBalance, tokenReserve, ethReserve);
1090 
1091       TokenInterface(oddTokens[i]).safeTransfer(address(tokenPair), tokenBalance);
1092 
1093       tokenPair.swap(uint256(0), wethOut, address(this), new bytes(0));
1094     }
1095 
1096     uint256 wethBalance = weth.balanceOf(address(this));
1097 
1098     IUniswapV2Pair cvpPair = _uniswapPairFor(address(cvp));
1099 
1100     (uint256 cvpReserve, uint256 ethReserve, ) = cvpPair.getReserves();
1101     uint256 cvpOut = UniswapV2Library.getAmountOut(wethBalance, ethReserve, cvpReserve);
1102 
1103     weth.safeTransfer(address(cvpPair), wethBalance);
1104 
1105     cvpPair.swap(cvpOut, uint256(0), address(this), new bytes(0));
1106 
1107     cvp.safeTransfer(feePayout, cvpOut);
1108 
1109     emit PayoutCVP(feePayout, wethBalance, cvpOut);
1110   }
1111 
1112   function setFees(
1113     uint256[] calldata _feeLevels,
1114     uint256[] calldata _feeAmounts,
1115     address _feePayout,
1116     address _feeManager
1117   ) external onlyFeeManagerOrOwner {
1118     feeLevels = _feeLevels;
1119     feeAmounts = _feeAmounts;
1120     feePayout = _feePayout;
1121     feeManager = _feeManager;
1122 
1123     emit SetFees(msg.sender, _feeLevels, _feeAmounts, _feePayout, _feeManager);
1124   }
1125 
1126   function setTokensSettings(
1127     address[] memory _tokens,
1128     address[] memory _pairs,
1129     bool[] memory _reapprove
1130   ) external onlyOwner {
1131     uint256 len = _tokens.length;
1132     require(len == _pairs.length && len == _reapprove.length, "LENGTHS_NOT_EQUAL");
1133     for (uint256 i = 0; i < len; i++) {
1134       uniswapEthPairByTokenAddress[_tokens[i]] = _pairs[i];
1135       reApproveTokens[_tokens[i]] = _reapprove[i];
1136       emit SetTokenSetting(_tokens[i], _reapprove[i], _pairs[i]);
1137     }
1138   }
1139 
1140   function fetchUnswapPairsFromFactory(address _factory, address[] calldata _tokens) external onlyOwner {
1141     uint256 len = _tokens.length;
1142     for (uint256 i = 0; i < len; i++) {
1143       uniswapEthPairByTokenAddress[_tokens[i]] = IUniswapV2Factory(_factory).getPair(_tokens[i], address(weth));
1144     }
1145   }
1146 
1147   function setDefaultSlippage(uint256 _defaultSlippage) external onlyOwner {
1148     defaultSlippage = _defaultSlippage;
1149     emit SetDefaultSlippage(_defaultSlippage);
1150   }
1151 
1152   function calcSwapEthToPiptInputs(
1153     uint256 _ethValue,
1154     address[] memory _tokens,
1155     uint256 _slippage
1156   )
1157     public
1158     view
1159     returns (
1160       uint256[] memory tokensInPipt,
1161       uint256[] memory ethInUniswap,
1162       uint256 poolOut
1163     )
1164   {
1165     _ethValue = _ethValue.sub(_ethValue.mul(_slippage).div(1 ether));
1166 
1167     // get shares and eth required for each share
1168     CalculationStruct[] memory calculations = new CalculationStruct[](_tokens.length);
1169 
1170     uint256 totalEthRequired = 0;
1171     {
1172       uint256 piptTotalSupply = pipt.totalSupply();
1173       // get pool out for 1 ether as 100% for calculate shares
1174       // poolOut by 1 ether first token join = piptTotalSupply.mul(1 ether).div(pipt.getBalance(_tokens[0]))
1175       // poolRatio = poolOut/totalSupply
1176       uint256 poolRatio =
1177         piptTotalSupply.mul(1 ether).div(pipt.getBalance(_tokens[0])).mul(1 ether).div(piptTotalSupply);
1178 
1179       for (uint256 i = 0; i < _tokens.length; i++) {
1180         // token share relatively 1 ether of first token
1181         calculations[i].tokenAmount = poolRatio.mul(pipt.getBalance(_tokens[i])).div(1 ether);
1182 
1183         (calculations[i].tokenReserve, calculations[i].ethReserve, ) = _uniswapPairFor(_tokens[i]).getReserves();
1184         calculations[i].ethAmount = UniswapV2Library.getAmountIn(
1185           calculations[i].tokenAmount,
1186           calculations[i].ethReserve,
1187           calculations[i].tokenReserve
1188         );
1189         totalEthRequired = totalEthRequired.add(calculations[i].ethAmount);
1190       }
1191     }
1192 
1193     // calculate eth and tokensIn based on shares and normalize if totalEthRequired more than 100%
1194     tokensInPipt = new uint256[](_tokens.length);
1195     ethInUniswap = new uint256[](_tokens.length);
1196     for (uint256 i = 0; i < _tokens.length; i++) {
1197       ethInUniswap[i] = _ethValue.mul(calculations[i].ethAmount.mul(1 ether).div(totalEthRequired)).div(1 ether);
1198       tokensInPipt[i] = calculations[i].tokenAmount.mul(_ethValue.mul(1 ether).div(totalEthRequired)).div(1 ether);
1199     }
1200 
1201     poolOut = pipt.totalSupply().mul(tokensInPipt[0]).div(pipt.getBalance(_tokens[0]));
1202   }
1203 
1204   function calcSwapPiptToEthInputs(uint256 _poolAmountIn, address[] memory _tokens)
1205     public
1206     view
1207     returns (
1208       uint256[] memory tokensOutPipt,
1209       uint256[] memory ethOutUniswap,
1210       uint256 totalEthOut,
1211       uint256 poolAmountFee
1212     )
1213   {
1214     tokensOutPipt = new uint256[](_tokens.length);
1215     ethOutUniswap = new uint256[](_tokens.length);
1216 
1217     (, , uint256 communityExitFee, ) = pipt.getCommunityFee();
1218 
1219     uint256 poolAmountInAfterFee;
1220     (poolAmountInAfterFee, poolAmountFee) = pipt.calcAmountWithCommunityFee(
1221       _poolAmountIn,
1222       communityExitFee,
1223       address(this)
1224     );
1225 
1226     uint256 poolRatio = poolAmountInAfterFee.mul(1 ether).div(pipt.totalSupply());
1227 
1228     totalEthOut = 0;
1229     for (uint256 i = 0; i < _tokens.length; i++) {
1230       tokensOutPipt[i] = poolRatio.mul(pipt.getBalance(_tokens[i])).div(1 ether);
1231 
1232       (uint256 tokenReserve, uint256 ethReserve, ) = _uniswapPairFor(_tokens[i]).getReserves();
1233       ethOutUniswap[i] = UniswapV2Library.getAmountOut(tokensOutPipt[i], tokenReserve, ethReserve);
1234       totalEthOut = totalEthOut.add(ethOutUniswap[i]);
1235     }
1236   }
1237 
1238   function calcNeedEthToPoolOut(uint256 _poolAmountOut, uint256 _slippage) public view returns (uint256) {
1239     uint256 ratio = _poolAmountOut.mul(1 ether).div(pipt.totalSupply()).add(10);
1240 
1241     address[] memory tokens = pipt.getCurrentTokens();
1242     uint256 len = tokens.length;
1243 
1244     CalculationStruct[] memory calculations = new CalculationStruct[](len);
1245     uint256[] memory tokensInPipt = new uint256[](len);
1246 
1247     uint256 totalEthSwap = 0;
1248     for (uint256 i = 0; i < len; i++) {
1249       IUniswapV2Pair tokenPair = _uniswapPairFor(tokens[i]);
1250 
1251       (calculations[i].tokenReserve, calculations[i].ethReserve, ) = tokenPair.getReserves();
1252       tokensInPipt[i] = ratio.mul(pipt.getBalance(tokens[i])).div(1 ether);
1253       totalEthSwap = UniswapV2Library
1254         .getAmountIn(tokensInPipt[i], calculations[i].ethReserve, calculations[i].tokenReserve)
1255         .add(totalEthSwap);
1256     }
1257     return totalEthSwap.add(totalEthSwap.mul(_slippage).div(1 ether));
1258   }
1259 
1260   function calcEthFee(uint256 ethAmount) public view returns (uint256 ethFee, uint256 ethAfterFee) {
1261     ethFee = 0;
1262     uint256 len = feeLevels.length;
1263     for (uint256 i = 0; i < len; i++) {
1264       if (ethAmount >= feeLevels[i]) {
1265         ethFee = ethAmount.mul(feeAmounts[i]).div(1 ether);
1266         break;
1267       }
1268     }
1269     ethAfterFee = ethAmount.sub(ethFee);
1270   }
1271 
1272   function getFeeLevels() external view returns (uint256[] memory) {
1273     return feeLevels;
1274   }
1275 
1276   function getFeeAmounts() external view returns (uint256[] memory) {
1277     return feeAmounts;
1278   }
1279 
1280   function _uniswapPairFor(address token) internal view returns (IUniswapV2Pair) {
1281     return IUniswapV2Pair(uniswapEthPairByTokenAddress[token]);
1282   }
1283 
1284   function _swapWethToPiptByPoolOut(uint256 _wethAmount, uint256 _poolAmountOut) internal {
1285     require(_wethAmount > 0, "ETH_REQUIRED");
1286 
1287     {
1288       address poolRestrictions = pipt.getRestrictions();
1289       if (address(poolRestrictions) != address(0)) {
1290         uint256 maxTotalSupply = IPoolRestrictions(poolRestrictions).getMaxTotalSupply(address(pipt));
1291         require(pipt.totalSupply().add(_poolAmountOut) <= maxTotalSupply, "PIPT_MAX_SUPPLY");
1292       }
1293     }
1294 
1295     (uint256 feeAmount, uint256 swapAmount) = calcEthFee(_wethAmount);
1296 
1297     uint256 ratio = _poolAmountOut.mul(1 ether).div(pipt.totalSupply()).add(10);
1298 
1299     address[] memory tokens = pipt.getCurrentTokens();
1300     uint256 len = tokens.length;
1301 
1302     CalculationStruct[] memory calculations = new CalculationStruct[](len);
1303     uint256[] memory tokensInPipt = new uint256[](len);
1304 
1305     uint256 totalEthSwap = 0;
1306     for (uint256 i = 0; i < len; i++) {
1307       IUniswapV2Pair tokenPair = _uniswapPairFor(tokens[i]);
1308 
1309       (calculations[i].tokenReserve, calculations[i].ethReserve, ) = tokenPair.getReserves();
1310       tokensInPipt[i] = ratio.mul(pipt.getBalance(tokens[i])).div(1 ether);
1311       calculations[i].ethAmount = UniswapV2Library.getAmountIn(
1312         tokensInPipt[i],
1313         calculations[i].ethReserve,
1314         calculations[i].tokenReserve
1315       );
1316 
1317       weth.safeTransfer(address(tokenPair), calculations[i].ethAmount);
1318 
1319       tokenPair.swap(tokensInPipt[i], uint256(0), address(this), new bytes(0));
1320       totalEthSwap = totalEthSwap.add(calculations[i].ethAmount);
1321 
1322       if (reApproveTokens[tokens[i]]) {
1323         TokenInterface(tokens[i]).approve(address(pipt), 0);
1324       }
1325 
1326       TokenInterface(tokens[i]).approve(address(pipt), tokensInPipt[i]);
1327     }
1328 
1329     (, uint256 communityJoinFee, , ) = pipt.getCommunityFee();
1330     (uint256 poolAmountOutAfterFee, uint256 poolAmountOutFee) =
1331       pipt.calcAmountWithCommunityFee(_poolAmountOut, communityJoinFee, address(this));
1332 
1333     emit EthToPiptSwap(msg.sender, swapAmount, feeAmount, _poolAmountOut, poolAmountOutFee);
1334 
1335     pipt.joinPool(_poolAmountOut, tokensInPipt);
1336     pipt.safeTransfer(msg.sender, poolAmountOutAfterFee);
1337 
1338     uint256 ethDiff = swapAmount.sub(totalEthSwap);
1339     if (ethDiff > 0) {
1340       weth.withdraw(ethDiff);
1341       msg.sender.transfer(ethDiff);
1342       emit OddEth(msg.sender, ethDiff);
1343     }
1344   }
1345 
1346   function _swapPiptToWeth(uint256 _poolAmountIn) internal returns (uint256) {
1347     address[] memory tokens = pipt.getCurrentTokens();
1348     uint256 len = tokens.length;
1349 
1350     (uint256[] memory tokensOutPipt, uint256[] memory ethOutUniswap, uint256 totalEthOut, uint256 poolAmountFee) =
1351       calcSwapPiptToEthInputs(_poolAmountIn, tokens);
1352 
1353     pipt.safeTransferFrom(msg.sender, address(this), _poolAmountIn);
1354 
1355     pipt.approve(address(pipt), _poolAmountIn);
1356 
1357     pipt.exitPool(_poolAmountIn, tokensOutPipt);
1358 
1359     for (uint256 i = 0; i < len; i++) {
1360       IUniswapV2Pair tokenPair = _uniswapPairFor(tokens[i]);
1361       TokenInterface(tokens[i]).safeTransfer(address(tokenPair), tokensOutPipt[i]);
1362       tokenPair.swap(uint256(0), ethOutUniswap[i], address(this), new bytes(0));
1363     }
1364 
1365     (uint256 ethFeeAmount, uint256 ethOutAmount) = calcEthFee(totalEthOut);
1366 
1367     emit PiptToEthSwap(msg.sender, _poolAmountIn, poolAmountFee, ethOutAmount, ethFeeAmount);
1368 
1369     return ethOutAmount;
1370   }
1371 }
1372 
1373 // File: contracts/Erc20PiptSwap.sol
1374 
1375 pragma solidity 0.6.12;
1376 
1377 
1378 contract Erc20PiptSwap is EthPiptSwap {
1379   event Erc20ToPiptSwap(
1380     address indexed user,
1381     address indexed swapToken,
1382     uint256 erc20InAmount,
1383     uint256 ethInAmount,
1384     uint256 poolOutAmount
1385   );
1386   event PiptToErc20Swap(
1387     address indexed user,
1388     address indexed swapToken,
1389     uint256 poolInAmount,
1390     uint256 ethOutAmount,
1391     uint256 erc20OutAmount
1392   );
1393 
1394   constructor(
1395     address _weth,
1396     address _cvp,
1397     address _pipt,
1398     address _feeManager
1399   ) public EthPiptSwap(_weth, _cvp, _pipt, _feeManager) {}
1400 
1401   function swapErc20ToPipt(
1402     address _swapToken,
1403     uint256 _swapAmount,
1404     uint256 _slippage
1405   ) external {
1406     IERC20(_swapToken).safeTransferFrom(msg.sender, address(this), _swapAmount);
1407 
1408     IUniswapV2Pair tokenPair = _uniswapPairFor(_swapToken);
1409     (uint256 tokenReserve, uint256 ethReserve, ) = tokenPair.getReserves();
1410     uint256 ethAmount = UniswapV2Library.getAmountOut(_swapAmount, tokenReserve, ethReserve);
1411 
1412     IERC20(_swapToken).safeTransfer(address(tokenPair), _swapAmount);
1413     tokenPair.swap(uint256(0), ethAmount, address(this), new bytes(0));
1414 
1415     (, uint256 ethSwapAmount) = calcEthFee(ethAmount);
1416     address[] memory tokens = pipt.getCurrentTokens();
1417     (, , uint256 poolAmountOut) = calcSwapEthToPiptInputs(ethSwapAmount, tokens, _slippage);
1418 
1419     _swapWethToPiptByPoolOut(ethAmount, poolAmountOut);
1420 
1421     emit Erc20ToPiptSwap(msg.sender, _swapToken, _swapAmount, ethAmount, poolAmountOut);
1422   }
1423 
1424   function swapPiptToErc20(address _swapToken, uint256 _poolAmountIn) external {
1425     uint256 ethOut = _swapPiptToWeth(_poolAmountIn);
1426 
1427     IUniswapV2Pair tokenPair = _uniswapPairFor(_swapToken);
1428 
1429     (uint256 tokenReserve, uint256 ethReserve, ) = tokenPair.getReserves();
1430     uint256 erc20Out = UniswapV2Library.getAmountOut(ethOut, ethReserve, tokenReserve);
1431 
1432     weth.safeTransfer(address(tokenPair), ethOut);
1433 
1434     tokenPair.swap(erc20Out, uint256(0), address(this), new bytes(0));
1435 
1436     IERC20(_swapToken).safeTransfer(msg.sender, erc20Out);
1437 
1438     emit PiptToErc20Swap(msg.sender, _swapToken, _poolAmountIn, ethOut, erc20Out);
1439   }
1440 
1441   function calcSwapErc20ToPiptInputs(
1442     address _swapToken,
1443     uint256 _swapAmount,
1444     address[] memory _tokens,
1445     uint256 _slippage,
1446     bool _withFee
1447   )
1448     external
1449     view
1450     returns (
1451       uint256[] memory tokensInPipt,
1452       uint256[] memory ethInUniswap,
1453       uint256 poolOut
1454     )
1455   {
1456     (uint256 tokenReserve, uint256 ethReserve, ) = _uniswapPairFor(_swapToken).getReserves();
1457     uint256 ethAmount = UniswapV2Library.getAmountOut(_swapAmount, tokenReserve, ethReserve);
1458     if (_withFee) {
1459       (, ethAmount) = calcEthFee(ethAmount);
1460     }
1461     return calcSwapEthToPiptInputs(ethAmount, _tokens, _slippage);
1462   }
1463 
1464   function calcNeedErc20ToPoolOut(
1465     address _swapToken,
1466     uint256 _poolAmountOut,
1467     uint256 _slippage
1468   ) external view returns (uint256) {
1469     uint256 resultEth = calcNeedEthToPoolOut(_poolAmountOut, _slippage);
1470     (uint256 tokenReserve, uint256 ethReserve, ) = _uniswapPairFor(_swapToken).getReserves();
1471     return UniswapV2Library.getAmountIn(resultEth.mul(1003).div(1000), tokenReserve, ethReserve);
1472   }
1473 
1474   function calcSwapPiptToErc20Inputs(
1475     address _swapToken,
1476     uint256 _poolAmountIn,
1477     address[] memory _tokens,
1478     bool _withFee
1479   )
1480     external
1481     view
1482     returns (
1483       uint256[] memory tokensOutPipt,
1484       uint256[] memory ethOutUniswap,
1485       uint256 totalErc20Out,
1486       uint256 poolAmountFee
1487     )
1488   {
1489     uint256 totalEthOut;
1490 
1491     (tokensOutPipt, ethOutUniswap, totalEthOut, poolAmountFee) = calcSwapPiptToEthInputs(_poolAmountIn, _tokens);
1492     if (_withFee) {
1493       (, totalEthOut) = calcEthFee(totalEthOut);
1494     }
1495     (uint256 tokenReserve, uint256 ethReserve, ) = _uniswapPairFor(_swapToken).getReserves();
1496     totalErc20Out = UniswapV2Library.getAmountOut(totalEthOut, ethReserve, tokenReserve);
1497   }
1498 
1499   function calcErc20Fee(address _swapToken, uint256 _swapAmount)
1500     external
1501     view
1502     returns (
1503       uint256 erc20Fee,
1504       uint256 erc20AfterFee,
1505       uint256 ethFee,
1506       uint256 ethAfterFee
1507     )
1508   {
1509     (uint256 tokenReserve, uint256 ethReserve, ) = _uniswapPairFor(_swapToken).getReserves();
1510     uint256 ethAmount = UniswapV2Library.getAmountOut(_swapAmount, tokenReserve, ethReserve);
1511 
1512     (ethFee, ethAfterFee) = calcEthFee(ethAmount);
1513 
1514     if (ethFee != 0) {
1515       erc20Fee = UniswapV2Library.getAmountOut(ethFee, ethReserve, tokenReserve);
1516     }
1517     erc20AfterFee = UniswapV2Library.getAmountOut(ethAfterFee, ethReserve, tokenReserve);
1518   }
1519 }