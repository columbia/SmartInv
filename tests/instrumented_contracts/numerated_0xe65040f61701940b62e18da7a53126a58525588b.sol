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
13 // File: @openzeppelin/contracts/math/SafeMath.sol
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.6.0;
18 
19 /**
20  * @dev Wrappers over Solidity's arithmetic operations with added overflow
21  * checks.
22  *
23  * Arithmetic operations in Solidity wrap on overflow. This can easily result
24  * in bugs, because programmers usually assume that an overflow raises an
25  * error, which is the standard behavior in high level programming languages.
26  * `SafeMath` restores this intuition by reverting the transaction when an
27  * operation overflows.
28  *
29  * Using this library instead of the unchecked operations eliminates an entire
30  * class of bugs, so it's recommended to use it always.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, reverting on
35      * overflow.
36      *
37      * Counterpart to Solidity's `+` operator.
38      *
39      * Requirements:
40      *
41      * - Addition cannot overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      *
72      * - Subtraction cannot overflow.
73      */
74     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the multiplication of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `*` operator.
86      *
87      * Requirements:
88      *
89      * - Multiplication cannot overflow.
90      */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b, "SafeMath: multiplication overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      *
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b) internal pure returns (uint256) {
118         return div(a, b, "SafeMath: division by zero");
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      *
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b > 0, errorMessage);
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return mod(a, b, "SafeMath: modulo by zero");
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts with custom message when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b != 0, errorMessage);
171         return a % b;
172     }
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
176 
177 pragma solidity ^0.6.0;
178 
179 /**
180  * @dev Interface of the ERC20 standard as defined in the EIP.
181  */
182 interface IERC20 {
183     /**
184      * @dev Returns the amount of tokens in existence.
185      */
186     function totalSupply() external view returns (uint256);
187 
188     /**
189      * @dev Returns the amount of tokens owned by `account`.
190      */
191     function balanceOf(address account) external view returns (uint256);
192 
193     /**
194      * @dev Moves `amount` tokens from the caller's account to `recipient`.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transfer(address recipient, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Returns the remaining number of tokens that `spender` will be
204      * allowed to spend on behalf of `owner` through {transferFrom}. This is
205      * zero by default.
206      *
207      * This value changes when {approve} or {transferFrom} are called.
208      */
209     function allowance(address owner, address spender) external view returns (uint256);
210 
211     /**
212      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * IMPORTANT: Beware that changing an allowance with this method brings the risk
217      * that someone may use both the old and the new allowance by unfortunate
218      * transaction ordering. One possible solution to mitigate this race
219      * condition is to first reduce the spender's allowance to 0 and set the
220      * desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      *
223      * Emits an {Approval} event.
224      */
225     function approve(address spender, uint256 amount) external returns (bool);
226 
227     /**
228      * @dev Moves `amount` tokens from `sender` to `recipient` using the
229      * allowance mechanism. `amount` is then deducted from the caller's
230      * allowance.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Emitted when `value` tokens are moved from one account (`from`) to
240      * another (`to`).
241      *
242      * Note that `value` may be zero.
243      */
244     event Transfer(address indexed from, address indexed to, uint256 value);
245 
246     /**
247      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
248      * a call to {approve}. `value` is the new allowance.
249      */
250     event Approval(address indexed owner, address indexed spender, uint256 value);
251 }
252 
253 // File: @openzeppelin/contracts/utils/Address.sol
254 
255 pragma solidity ^0.6.2;
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies in extcodesize, which returns 0 for contracts in
280         // construction, since the code is only stored at the end of the
281         // constructor execution.
282 
283         uint256 size;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { size := extcodesize(account) }
286         return size > 0;
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain`call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332       return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
396 
397 pragma solidity ^0.6.0;
398 
399 
400 
401 
402 /**
403  * @title SafeERC20
404  * @dev Wrappers around ERC20 operations that throw on failure (when the token
405  * contract returns false). Tokens that return no value (and instead revert or
406  * throw on failure) are also supported, non-reverting calls are assumed to be
407  * successful.
408  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
409  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
410  */
411 library SafeERC20 {
412     using SafeMath for uint256;
413     using Address for address;
414 
415     function safeTransfer(IERC20 token, address to, uint256 value) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
417     }
418 
419     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
420         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
421     }
422 
423     /**
424      * @dev Deprecated. This function has issues similar to the ones found in
425      * {IERC20-approve}, and its usage is discouraged.
426      *
427      * Whenever possible, use {safeIncreaseAllowance} and
428      * {safeDecreaseAllowance} instead.
429      */
430     function safeApprove(IERC20 token, address spender, uint256 value) internal {
431         // safeApprove should only be called when setting an initial allowance,
432         // or when resetting it to zero. To increase and decrease it, use
433         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
434         // solhint-disable-next-line max-line-length
435         require((value == 0) || (token.allowance(address(this), spender) == 0),
436             "SafeERC20: approve from non-zero to non-zero allowance"
437         );
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
439     }
440 
441     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
442         uint256 newAllowance = token.allowance(address(this), spender).add(value);
443         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
444     }
445 
446     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
447         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
449     }
450 
451     /**
452      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
453      * on the return value: the return value is optional (but if data is returned, it must not be false).
454      * @param token The token targeted by the call.
455      * @param data The call data (encoded using abi.encode or one of its variants).
456      */
457     function _callOptionalReturn(IERC20 token, bytes memory data) private {
458         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
459         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
460         // the target address contains contract code and also asserts for success in the low-level call.
461 
462         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
463         if (returndata.length > 0) { // Return data is optional
464             // solhint-disable-next-line max-line-length
465             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
466         }
467     }
468 }
469 
470 // File: @openzeppelin/contracts/GSN/Context.sol
471 
472 pragma solidity ^0.6.0;
473 
474 /*
475  * @dev Provides information about the current execution context, including the
476  * sender of the transaction and its data. While these are generally available
477  * via msg.sender and msg.data, they should not be accessed in such a direct
478  * manner, since when dealing with GSN meta-transactions the account sending and
479  * paying for execution may not be the actual sender (as far as an application
480  * is concerned).
481  *
482  * This contract is only required for intermediate, library-like contracts.
483  */
484 abstract contract Context {
485     function _msgSender() internal view virtual returns (address payable) {
486         return msg.sender;
487     }
488 
489     function _msgData() internal view virtual returns (bytes memory) {
490         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
491         return msg.data;
492     }
493 }
494 
495 // File: @openzeppelin/contracts/access/Ownable.sol
496 
497 pragma solidity ^0.6.0;
498 
499 /**
500  * @dev Contract module which provides a basic access control mechanism, where
501  * there is an account (an owner) that can be granted exclusive access to
502  * specific functions.
503  *
504  * By default, the owner account will be the one that deploys the contract. This
505  * can later be changed with {transferOwnership}.
506  *
507  * This module is used through inheritance. It will make available the modifier
508  * `onlyOwner`, which can be applied to your functions to restrict their use to
509  * the owner.
510  */
511 contract Ownable is Context {
512     address private _owner;
513 
514     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
515 
516     /**
517      * @dev Initializes the contract setting the deployer as the initial owner.
518      */
519     constructor () internal {
520         address msgSender = _msgSender();
521         _owner = msgSender;
522         emit OwnershipTransferred(address(0), msgSender);
523     }
524 
525     /**
526      * @dev Returns the address of the current owner.
527      */
528     function owner() public view returns (address) {
529         return _owner;
530     }
531 
532     /**
533      * @dev Throws if called by any account other than the owner.
534      */
535     modifier onlyOwner() {
536         require(_owner == _msgSender(), "Ownable: caller is not the owner");
537         _;
538     }
539 
540     /**
541      * @dev Leaves the contract without owner. It will not be possible to call
542      * `onlyOwner` functions anymore. Can only be called by the current owner.
543      *
544      * NOTE: Renouncing ownership will leave the contract without an owner,
545      * thereby removing any functionality that is only available to the owner.
546      */
547     function renounceOwnership() public virtual onlyOwner {
548         emit OwnershipTransferred(_owner, address(0));
549         _owner = address(0);
550     }
551 
552     /**
553      * @dev Transfers ownership of the contract to a new account (`newOwner`).
554      * Can only be called by the current owner.
555      */
556     function transferOwnership(address newOwner) public virtual onlyOwner {
557         require(newOwner != address(0), "Ownable: new owner is the zero address");
558         emit OwnershipTransferred(_owner, newOwner);
559         _owner = newOwner;
560     }
561 }
562 
563 // File: contracts/interfaces/BMathInterface.sol
564 
565 pragma solidity 0.6.12;
566 
567 interface BMathInterface {
568   function calcInGivenOut(
569     uint256 tokenBalanceIn,
570     uint256 tokenWeightIn,
571     uint256 tokenBalanceOut,
572     uint256 tokenWeightOut,
573     uint256 tokenAmountOut,
574     uint256 swapFee
575   ) external pure returns (uint256 tokenAmountIn);
576 }
577 
578 // File: contracts/interfaces/BPoolInterface.sol
579 
580 pragma solidity 0.6.12;
581 
582 
583 
584 interface BPoolInterface is IERC20, BMathInterface {
585   function joinPool(uint256 poolAmountOut, uint256[] calldata maxAmountsIn) external;
586 
587   function exitPool(uint256 poolAmountIn, uint256[] calldata minAmountsOut) external;
588 
589   function swapExactAmountIn(
590     address,
591     uint256,
592     address,
593     uint256,
594     uint256
595   ) external returns (uint256, uint256);
596 
597   function swapExactAmountOut(
598     address,
599     uint256,
600     address,
601     uint256,
602     uint256
603   ) external returns (uint256, uint256);
604 
605   function joinswapExternAmountIn(
606     address,
607     uint256,
608     uint256
609   ) external returns (uint256);
610 
611   function joinswapPoolAmountOut(
612     address,
613     uint256,
614     uint256
615   ) external returns (uint256);
616 
617   function exitswapPoolAmountIn(
618     address,
619     uint256,
620     uint256
621   ) external returns (uint256);
622 
623   function exitswapExternAmountOut(
624     address,
625     uint256,
626     uint256
627   ) external returns (uint256);
628 
629   function getDenormalizedWeight(address) external view returns (uint256);
630 
631   function getBalance(address) external view returns (uint256);
632 
633   function getSwapFee() external view returns (uint256);
634 
635   function getTotalDenormalizedWeight() external view returns (uint256);
636 
637   function getCommunityFee()
638     external
639     view
640     returns (
641       uint256,
642       uint256,
643       uint256,
644       address
645     );
646 
647   function calcAmountWithCommunityFee(
648     uint256,
649     uint256,
650     address
651   ) external view returns (uint256, uint256);
652 
653   function getRestrictions() external view returns (address);
654 
655   function isPublicSwap() external view returns (bool);
656 
657   function isFinalized() external view returns (bool);
658 
659   function isBound(address t) external view returns (bool);
660 
661   function getCurrentTokens() external view returns (address[] memory tokens);
662 
663   function getFinalTokens() external view returns (address[] memory tokens);
664 
665   function setSwapFee(uint256) external;
666 
667   function setCommunityFeeAndReceiver(
668     uint256,
669     uint256,
670     uint256,
671     address
672   ) external;
673 
674   function setController(address) external;
675 
676   function setPublicSwap(bool) external;
677 
678   function finalize() external;
679 
680   function bind(
681     address,
682     uint256,
683     uint256
684   ) external;
685 
686   function rebind(
687     address,
688     uint256,
689     uint256
690   ) external;
691 
692   function unbind(address) external;
693 
694   function callVoting(
695     address voting,
696     bytes4 signature,
697     bytes calldata args,
698     uint256 value
699   ) external;
700 
701   function getMinWeight() external view returns (uint256);
702 
703   function getMaxBoundTokens() external view returns (uint256);
704 }
705 
706 // File: contracts/interfaces/TokenInterface.sol
707 
708 pragma solidity 0.6.12;
709 
710 
711 interface TokenInterface is IERC20 {
712   function deposit() external payable;
713 
714   function withdraw(uint256) external;
715 }
716 
717 // File: contracts/interfaces/IPoolRestrictions.sol
718 
719 pragma solidity 0.6.12;
720 
721 interface IPoolRestrictions {
722   function getMaxTotalSupply(address _pool) external view returns (uint256);
723 
724   function isVotingSignatureAllowed(address _votingAddress, bytes4 _signature) external view returns (bool);
725 
726   function isVotingSenderAllowed(address _votingAddress, address _sender) external view returns (bool);
727 
728   function isWithoutFee(address _addr) external view returns (bool);
729 }
730 
731 // File: contracts/interfaces/IUniswapV2Pair.sol
732 
733 pragma solidity >=0.5.0;
734 
735 interface IUniswapV2Pair {
736   event Approval(address indexed owner, address indexed spender, uint256 value);
737   event Transfer(address indexed from, address indexed to, uint256 value);
738 
739   function name() external pure returns (string memory);
740 
741   function symbol() external pure returns (string memory);
742 
743   function decimals() external pure returns (uint8);
744 
745   function totalSupply() external view returns (uint256);
746 
747   function balanceOf(address owner) external view returns (uint256);
748 
749   function allowance(address owner, address spender) external view returns (uint256);
750 
751   function approve(address spender, uint256 value) external returns (bool);
752 
753   function transfer(address to, uint256 value) external returns (bool);
754 
755   function transferFrom(
756     address from,
757     address to,
758     uint256 value
759   ) external returns (bool);
760 
761   function DOMAIN_SEPARATOR() external view returns (bytes32);
762 
763   function PERMIT_TYPEHASH() external pure returns (bytes32);
764 
765   function nonces(address owner) external view returns (uint256);
766 
767   function permit(
768     address owner,
769     address spender,
770     uint256 value,
771     uint256 deadline,
772     uint8 v,
773     bytes32 r,
774     bytes32 s
775   ) external;
776 
777   event Mint(address indexed sender, uint256 amount0, uint256 amount1);
778   event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
779   event Swap(
780     address indexed sender,
781     uint256 amount0In,
782     uint256 amount1In,
783     uint256 amount0Out,
784     uint256 amount1Out,
785     address indexed to
786   );
787   event Sync(uint112 reserve0, uint112 reserve1);
788 
789   function MINIMUM_LIQUIDITY() external pure returns (uint256);
790 
791   function factory() external view returns (address);
792 
793   function token0() external view returns (address);
794 
795   function token1() external view returns (address);
796 
797   function getReserves()
798     external
799     view
800     returns (
801       uint112 reserve0,
802       uint112 reserve1,
803       uint32 blockTimestampLast
804     );
805 
806   function price0CumulativeLast() external view returns (uint256);
807 
808   function price1CumulativeLast() external view returns (uint256);
809 
810   function kLast() external view returns (uint256);
811 
812   function mint(address to) external returns (uint256 liquidity);
813 
814   function burn(address to) external returns (uint256 amount0, uint256 amount1);
815 
816   function swap(
817     uint256 amount0Out,
818     uint256 amount1Out,
819     address to,
820     bytes calldata data
821   ) external;
822 
823   function skim(address to) external;
824 
825   function sync() external;
826 
827   function initialize(address, address) external;
828 }
829 
830 // File: contracts/interfaces/IUniswapV2Factory.sol
831 
832 pragma solidity >=0.5.0;
833 
834 interface IUniswapV2Factory {
835   event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
836 
837   function feeTo() external view returns (address);
838 
839   function feeToSetter() external view returns (address);
840 
841   function migrator() external view returns (address);
842 
843   function getPair(address tokenA, address tokenB) external view returns (address pair);
844 
845   function allPairs(uint256) external view returns (address pair);
846 
847   function allPairsLength() external view returns (uint256);
848 
849   function createPair(address tokenA, address tokenB) external returns (address pair);
850 
851   function setFeeTo(address) external;
852 
853   function setFeeToSetter(address) external;
854 
855   function setMigrator(address) external;
856 }
857 
858 // File: contracts/lib/SafeMathUniswap.sol
859 
860 pragma solidity =0.6.12;
861 
862 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
863 
864 library SafeMathUniswap {
865     function add(uint x, uint y) internal pure returns (uint z) {
866         require((z = x + y) >= x, 'ds-math-add-overflow');
867     }
868 
869     function sub(uint x, uint y) internal pure returns (uint z) {
870         require((z = x - y) <= x, 'ds-math-sub-underflow');
871     }
872 
873     function mul(uint x, uint y) internal pure returns (uint z) {
874         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
875     }
876 }
877 
878 // File: contracts/lib/UniswapV2Library.sol
879 
880 pragma solidity >=0.5.0;
881 
882 
883 
884 library UniswapV2Library {
885     using SafeMathUniswap for uint;
886 
887     // returns sorted token addresses, used to handle return values from pairs sorted in this order
888     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
889         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
890         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
891         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
892     }
893 
894     // calculates the CREATE2 address for a pair without making any external calls
895     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
896         (address token0, address token1) = sortTokens(tokenA, tokenB);
897         pair = address(uint(keccak256(abi.encodePacked(
898                 hex'ff',
899                 factory,
900                 keccak256(abi.encodePacked(token0, token1)),
901                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
902             ))));
903     }
904 
905     // fetches and sorts the reserves for a pair
906     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
907         (address token0,) = sortTokens(tokenA, tokenB);
908         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
909         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
910     }
911 
912     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
913     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
914         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
915         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
916         amountB = amountA.mul(reserveB) / reserveA;
917     }
918 
919     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
920     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
921         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
922         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
923         uint amountInWithFee = amountIn.mul(997);
924         uint numerator = amountInWithFee.mul(reserveOut);
925         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
926         amountOut = numerator / denominator;
927     }
928 
929     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
930     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
931         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
932         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
933         uint numerator = reserveIn.mul(amountOut).mul(1000);
934         uint denominator = reserveOut.sub(amountOut).mul(997);
935         amountIn = (numerator / denominator).add(1);
936     }
937 
938     // performs chained getAmountOut calculations on any number of pairs
939     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
940         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
941         amounts = new uint[](path.length);
942         amounts[0] = amountIn;
943         for (uint i; i < path.length - 1; i++) {
944             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
945             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
946         }
947     }
948 
949     // performs chained getAmountIn calculations on any number of pairs
950     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
951         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
952         amounts = new uint[](path.length);
953         amounts[amounts.length - 1] = amountOut;
954         for (uint i = path.length - 1; i > 0; i--) {
955             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
956             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
957         }
958     }
959 }
960 
961 // File: contracts/EthPiptSwap.sol
962 
963 pragma solidity 0.6.12;
964 
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
975 contract EthPiptSwap is Ownable {
976   using SafeMath for uint256;
977   using SafeERC20 for IERC20;
978   using SafeERC20 for TokenInterface;
979   using SafeERC20 for BPoolInterface;
980 
981   TokenInterface public weth;
982   TokenInterface public cvp;
983   BPoolInterface public pipt;
984 
985   uint256[] public feeLevels;
986   uint256[] public feeAmounts;
987   address public feePayout;
988   address public feeManager;
989 
990   mapping(address => bool) public uniswapFactoryAllowed;
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
1002   event SetUniswapFactoryAllowed(address indexed factory, bool indexed allowed);
1003   event SetTokenSetting(address indexed token, bool indexed reApprove, address indexed uniswapPair);
1004   event SetDefaultSlippage(uint256 newDefaultSlippage);
1005   event SetFees(
1006     address indexed sender,
1007     uint256[] newFeeLevels,
1008     uint256[] newFeeAmounts,
1009     address indexed feePayout,
1010     address indexed feeManager
1011   );
1012 
1013   event EthToPiptSwap(
1014     address indexed user,
1015     uint256 ethInAmount,
1016     uint256 ethSwapFee,
1017     uint256 poolOutAmount,
1018     uint256 poolCommunityFee
1019   );
1020   event OddEth(address indexed user, uint256 amount);
1021   event PiptToEthSwap(
1022     address indexed user,
1023     uint256 poolInAmount,
1024     uint256 poolCommunityFee,
1025     uint256 ethOutAmount,
1026     uint256 ethSwapFee
1027   );
1028   event PayoutCVP(address indexed receiver, uint256 wethAmount, uint256 cvpAmount);
1029 
1030   constructor(
1031     address _weth,
1032     address _cvp,
1033     address _pipt,
1034     address _feeManager
1035   ) public Ownable() {
1036     weth = TokenInterface(_weth);
1037     cvp = TokenInterface(_cvp);
1038     pipt = BPoolInterface(_pipt);
1039     feeManager = _feeManager;
1040     defaultSlippage = 0.02 ether;
1041   }
1042 
1043   modifier onlyFeeManagerOrOwner() {
1044     require(msg.sender == feeManager || msg.sender == owner(), "NOT_FEE_MANAGER");
1045     _;
1046   }
1047 
1048   receive() external payable {
1049     if (msg.sender != tx.origin) {
1050       return;
1051     }
1052     swapEthToPipt(defaultSlippage);
1053   }
1054 
1055   function swapEthToPipt(uint256 _slippage) public payable {
1056     (, uint256 swapAmount) = calcEthFee(msg.value);
1057 
1058     address[] memory tokens = pipt.getCurrentTokens();
1059 
1060     (, , uint256 poolAmountOut) = calcSwapEthToPiptInputs(swapAmount, tokens, _slippage);
1061 
1062     weth.deposit{ value: msg.value }();
1063 
1064     _swapWethToPiptByPoolOut(msg.value, poolAmountOut);
1065   }
1066 
1067   function swapEthToPiptByPoolOut(uint256 _poolAmountOut) external payable {
1068     weth.deposit{ value: msg.value }();
1069 
1070     _swapWethToPiptByPoolOut(msg.value, _poolAmountOut);
1071   }
1072 
1073   function swapPiptToEth(uint256 _poolAmountIn) external {
1074     uint256 ethOutAmount = _swapPiptToWeth(_poolAmountIn);
1075 
1076     weth.withdraw(ethOutAmount);
1077     msg.sender.transfer(ethOutAmount);
1078   }
1079 
1080   function convertOddToCvpAndSendToPayout(address[] memory oddTokens) external {
1081     require(msg.sender == tx.origin && !Address.isContract(msg.sender), "CONTRACT_NOT_ALLOWED");
1082 
1083     uint256 len = oddTokens.length;
1084 
1085     for (uint256 i = 0; i < len; i++) {
1086       uint256 tokenBalance = TokenInterface(oddTokens[i]).balanceOf(address(this));
1087       IUniswapV2Pair tokenPair = _uniswapPairFor(oddTokens[i]);
1088 
1089       (uint256 tokenReserve, uint256 ethReserve, ) = tokenPair.getReserves();
1090       uint256 wethOut = UniswapV2Library.getAmountOut(tokenBalance, tokenReserve, ethReserve);
1091 
1092       TokenInterface(oddTokens[i]).safeTransfer(address(tokenPair), tokenBalance);
1093 
1094       tokenPair.swap(uint256(0), wethOut, address(this), new bytes(0));
1095     }
1096 
1097     uint256 wethBalance = weth.balanceOf(address(this));
1098 
1099     IUniswapV2Pair cvpPair = _uniswapPairFor(address(cvp));
1100 
1101     (uint256 cvpReserve, uint256 ethReserve, ) = cvpPair.getReserves();
1102     uint256 cvpOut = UniswapV2Library.getAmountOut(wethBalance, ethReserve, cvpReserve);
1103 
1104     weth.safeTransfer(address(cvpPair), wethBalance);
1105 
1106     cvpPair.swap(cvpOut, uint256(0), address(this), new bytes(0));
1107 
1108     cvp.safeTransfer(feePayout, cvpOut);
1109 
1110     emit PayoutCVP(feePayout, wethBalance, cvpOut);
1111   }
1112 
1113   function setFees(
1114     uint256[] calldata _feeLevels,
1115     uint256[] calldata _feeAmounts,
1116     address _feePayout,
1117     address _feeManager
1118   ) external onlyFeeManagerOrOwner {
1119     feeLevels = _feeLevels;
1120     feeAmounts = _feeAmounts;
1121     feePayout = _feePayout;
1122     feeManager = _feeManager;
1123 
1124     emit SetFees(msg.sender, _feeLevels, _feeAmounts, _feePayout, _feeManager);
1125   }
1126 
1127   function setTokensSettings(
1128     address[] memory _tokens,
1129     address[] memory _pairs,
1130     bool[] memory _reapprove
1131   ) external onlyOwner {
1132     uint256 len = _tokens.length;
1133     require(len == _pairs.length && len == _reapprove.length, "LENGTHS_NOT_EQUAL");
1134     for (uint256 i = 0; i < _tokens.length; i++) {
1135       uniswapEthPairByTokenAddress[_tokens[i]] = _pairs[i];
1136       reApproveTokens[_tokens[i]] = _reapprove[i];
1137       emit SetTokenSetting(_tokens[i], _reapprove[i], _pairs[i]);
1138     }
1139   }
1140 
1141   function setUniswapFactoryAllowed(address[] memory _factories, bool[] memory _allowed) external onlyOwner {
1142     uint256 len = _factories.length;
1143     require(len == _allowed.length, "LENGTHS_NOT_EQUAL");
1144     for (uint256 i = 0; i < _factories.length; i++) {
1145       uniswapFactoryAllowed[_factories[i]] = _allowed[i];
1146       emit SetUniswapFactoryAllowed(_factories[i], _allowed[i]);
1147     }
1148   }
1149 
1150   function fetchUnswapPairsFromFactory(address _factory, address[] calldata _tokens) external {
1151     require(uniswapFactoryAllowed[_factory], "FACTORY_NOT_ALLOWED");
1152 
1153     uint256 len = _tokens.length;
1154     for (uint256 i = 0; i < _tokens.length; i++) {
1155       require(uniswapEthPairByTokenAddress[_tokens[i]] == address(0), "ALREADY_SET");
1156       uniswapEthPairByTokenAddress[_tokens[i]] = IUniswapV2Factory(_factory).getPair(_tokens[i], address(weth));
1157     }
1158   }
1159 
1160   function setDefaultSlippage(uint256 _defaultSlippage) external onlyOwner {
1161     defaultSlippage = _defaultSlippage;
1162     emit SetDefaultSlippage(_defaultSlippage);
1163   }
1164 
1165   function calcSwapEthToPiptInputs(
1166     uint256 _ethValue,
1167     address[] memory _tokens,
1168     uint256 _slippage
1169   )
1170     public
1171     view
1172     returns (
1173       uint256[] memory tokensInPipt,
1174       uint256[] memory ethInUniswap,
1175       uint256 poolOut
1176     )
1177   {
1178     _ethValue = _ethValue.sub(_ethValue.mul(_slippage).div(1 ether));
1179 
1180     // get shares and eth required for each share
1181     CalculationStruct[] memory calculations = new CalculationStruct[](_tokens.length);
1182 
1183     uint256 totalEthRequired = 0;
1184     {
1185       uint256 piptTotalSupply = pipt.totalSupply();
1186       // get pool out for 1 ether as 100% for calculate shares
1187       // poolOut by 1 ether first token join = piptTotalSupply.mul(1 ether).div(pipt.getBalance(_tokens[0]))
1188       // poolRatio = poolOut/totalSupply
1189       uint256 poolRatio =
1190         piptTotalSupply.mul(1 ether).div(pipt.getBalance(_tokens[0])).mul(1 ether).div(piptTotalSupply);
1191 
1192       for (uint256 i = 0; i < _tokens.length; i++) {
1193         // token share relatively 1 ether of first token
1194         calculations[i].tokenAmount = poolRatio.mul(pipt.getBalance(_tokens[i])).div(1 ether);
1195 
1196         (calculations[i].tokenReserve, calculations[i].ethReserve, ) = _uniswapPairFor(_tokens[i]).getReserves();
1197         calculations[i].ethAmount = UniswapV2Library.getAmountIn(
1198           calculations[i].tokenAmount,
1199           calculations[i].ethReserve,
1200           calculations[i].tokenReserve
1201         );
1202         totalEthRequired = totalEthRequired.add(calculations[i].ethAmount);
1203       }
1204     }
1205 
1206     // calculate eth and tokensIn based on shares and normalize if totalEthRequired more than 100%
1207     tokensInPipt = new uint256[](_tokens.length);
1208     ethInUniswap = new uint256[](_tokens.length);
1209     for (uint256 i = 0; i < _tokens.length; i++) {
1210       ethInUniswap[i] = _ethValue.mul(calculations[i].ethAmount.mul(1 ether).div(totalEthRequired)).div(1 ether);
1211       tokensInPipt[i] = calculations[i].tokenAmount.mul(_ethValue.mul(1 ether).div(totalEthRequired)).div(1 ether);
1212     }
1213 
1214     poolOut = pipt.totalSupply().mul(tokensInPipt[0]).div(pipt.getBalance(_tokens[0]));
1215   }
1216 
1217   function calcSwapPiptToEthInputs(uint256 _poolAmountIn, address[] memory _tokens)
1218     public
1219     view
1220     returns (
1221       uint256[] memory tokensOutPipt,
1222       uint256[] memory ethOutUniswap,
1223       uint256 totalEthOut,
1224       uint256 poolAmountFee
1225     )
1226   {
1227     tokensOutPipt = new uint256[](_tokens.length);
1228     ethOutUniswap = new uint256[](_tokens.length);
1229 
1230     (, , uint256 communityExitFee, ) = pipt.getCommunityFee();
1231 
1232     uint256 poolAmountInAfterFee;
1233     (poolAmountInAfterFee, poolAmountFee) = pipt.calcAmountWithCommunityFee(
1234       _poolAmountIn,
1235       communityExitFee,
1236       address(this)
1237     );
1238 
1239     uint256 poolRatio = poolAmountInAfterFee.mul(1 ether).div(pipt.totalSupply());
1240 
1241     totalEthOut = 0;
1242     for (uint256 i = 0; i < _tokens.length; i++) {
1243       tokensOutPipt[i] = poolRatio.mul(pipt.getBalance(_tokens[i])).div(1 ether);
1244 
1245       (uint256 tokenReserve, uint256 ethReserve, ) = _uniswapPairFor(_tokens[i]).getReserves();
1246       ethOutUniswap[i] = UniswapV2Library.getAmountOut(tokensOutPipt[i], tokenReserve, ethReserve);
1247       totalEthOut = totalEthOut.add(ethOutUniswap[i]);
1248     }
1249   }
1250 
1251   function calcEthFee(uint256 ethAmount) public view returns (uint256 ethFee, uint256 ethAfterFee) {
1252     ethFee = 0;
1253     uint256 len = feeLevels.length;
1254     for (uint256 i = 0; i < len; i++) {
1255       if (ethAmount >= feeLevels[i]) {
1256         ethFee = ethAmount.mul(feeAmounts[i]).div(1 ether);
1257         break;
1258       }
1259     }
1260     ethAfterFee = ethAmount.sub(ethFee);
1261   }
1262 
1263   function getFeeLevels() external view returns (uint256[] memory) {
1264     return feeLevels;
1265   }
1266 
1267   function getFeeAmounts() external view returns (uint256[] memory) {
1268     return feeAmounts;
1269   }
1270 
1271   function _uniswapPairFor(address token) internal view returns (IUniswapV2Pair) {
1272     return IUniswapV2Pair(uniswapEthPairByTokenAddress[token]);
1273   }
1274 
1275   function _swapWethToPiptByPoolOut(uint256 _wethAmount, uint256 _poolAmountOut) internal {
1276     require(_wethAmount > 0, "ETH_REQUIRED");
1277 
1278     {
1279       address poolRestrictions = pipt.getRestrictions();
1280       if (address(poolRestrictions) != address(0)) {
1281         uint256 maxTotalSupply = IPoolRestrictions(poolRestrictions).getMaxTotalSupply(address(pipt));
1282         require(pipt.totalSupply().add(_poolAmountOut) <= maxTotalSupply, "PIPT_MAX_SUPPLY");
1283       }
1284     }
1285 
1286     (uint256 feeAmount, uint256 swapAmount) = calcEthFee(_wethAmount);
1287 
1288     uint256 ratio = _poolAmountOut.mul(1 ether).div(pipt.totalSupply()).add(10);
1289 
1290     address[] memory tokens = pipt.getCurrentTokens();
1291     uint256 len = tokens.length;
1292 
1293     CalculationStruct[] memory calculations = new CalculationStruct[](tokens.length);
1294     uint256[] memory tokensInPipt = new uint256[](tokens.length);
1295 
1296     uint256 totalEthSwap = 0;
1297     for (uint256 i = 0; i < len; i++) {
1298       IUniswapV2Pair tokenPair = _uniswapPairFor(tokens[i]);
1299 
1300       (calculations[i].tokenReserve, calculations[i].ethReserve, ) = tokenPair.getReserves();
1301       tokensInPipt[i] = ratio.mul(pipt.getBalance(tokens[i])).div(1 ether);
1302       calculations[i].ethAmount = UniswapV2Library.getAmountIn(
1303         tokensInPipt[i],
1304         calculations[i].ethReserve,
1305         calculations[i].tokenReserve
1306       );
1307 
1308       weth.safeTransfer(address(tokenPair), calculations[i].ethAmount);
1309 
1310       tokenPair.swap(tokensInPipt[i], uint256(0), address(this), new bytes(0));
1311       totalEthSwap = totalEthSwap.add(calculations[i].ethAmount);
1312 
1313       if (reApproveTokens[tokens[i]]) {
1314         TokenInterface(tokens[i]).approve(address(pipt), 0);
1315       }
1316 
1317       TokenInterface(tokens[i]).approve(address(pipt), tokensInPipt[i]);
1318     }
1319 
1320     (, uint256 communityJoinFee, , ) = pipt.getCommunityFee();
1321     (uint256 poolAmountOutAfterFee, uint256 poolAmountOutFee) =
1322       pipt.calcAmountWithCommunityFee(_poolAmountOut, communityJoinFee, address(this));
1323 
1324     emit EthToPiptSwap(msg.sender, swapAmount, feeAmount, _poolAmountOut, poolAmountOutFee);
1325 
1326     pipt.joinPool(_poolAmountOut, tokensInPipt);
1327     pipt.safeTransfer(msg.sender, poolAmountOutAfterFee);
1328 
1329     uint256 ethDiff = swapAmount.sub(totalEthSwap);
1330     if (ethDiff > 0) {
1331       weth.withdraw(ethDiff);
1332       msg.sender.transfer(ethDiff);
1333       emit OddEth(msg.sender, ethDiff);
1334     }
1335   }
1336 
1337   function _swapPiptToWeth(uint256 _poolAmountIn) internal returns (uint256) {
1338     address[] memory tokens = pipt.getCurrentTokens();
1339     uint256 len = tokens.length;
1340 
1341     (uint256[] memory tokensOutPipt, uint256[] memory ethOutUniswap, uint256 totalEthOut, uint256 poolAmountFee) =
1342       calcSwapPiptToEthInputs(_poolAmountIn, tokens);
1343 
1344     pipt.safeTransferFrom(msg.sender, address(this), _poolAmountIn);
1345 
1346     pipt.approve(address(pipt), _poolAmountIn);
1347 
1348     pipt.exitPool(_poolAmountIn, tokensOutPipt);
1349 
1350     for (uint256 i = 0; i < len; i++) {
1351       IUniswapV2Pair tokenPair = _uniswapPairFor(tokens[i]);
1352       TokenInterface(tokens[i]).safeTransfer(address(tokenPair), tokensOutPipt[i]);
1353       tokenPair.swap(uint256(0), ethOutUniswap[i], address(this), new bytes(0));
1354     }
1355 
1356     (uint256 ethFeeAmount, uint256 ethOutAmount) = calcEthFee(totalEthOut);
1357 
1358     emit PiptToEthSwap(msg.sender, _poolAmountIn, poolAmountFee, ethOutAmount, ethFeeAmount);
1359 
1360     return ethOutAmount;
1361   }
1362 }
1363 
1364 // File: contracts/Erc20PiptSwap.sol
1365 
1366 pragma solidity 0.6.12;
1367 
1368 
1369 contract Erc20PiptSwap is EthPiptSwap {
1370   event Erc20ToPiptSwap(
1371     address indexed user,
1372     address indexed swapToken,
1373     uint256 erc20InAmount,
1374     uint256 ethInAmount,
1375     uint256 poolOutAmount
1376   );
1377   event PiptToErc20Swap(
1378     address indexed user,
1379     address indexed swapToken,
1380     uint256 poolInAmount,
1381     uint256 ethOutAmount,
1382     uint256 erc20OutAmount
1383   );
1384 
1385   constructor(
1386     address _weth,
1387     address _cvp,
1388     address _pipt,
1389     address _feeManager
1390   ) public EthPiptSwap(_weth, _cvp, _pipt, _feeManager) {}
1391 
1392   function swapErc20ToPipt(
1393     address _swapToken,
1394     uint256 _swapAmount,
1395     uint256 _slippage
1396   ) external {
1397     IERC20(_swapToken).safeTransferFrom(msg.sender, address(this), _swapAmount);
1398 
1399     IUniswapV2Pair tokenPair = _uniswapPairFor(_swapToken);
1400     (uint256 tokenReserve, uint256 ethReserve, ) = tokenPair.getReserves();
1401     uint256 ethAmount = UniswapV2Library.getAmountOut(_swapAmount, tokenReserve, ethReserve);
1402 
1403     IERC20(_swapToken).safeTransfer(address(tokenPair), _swapAmount);
1404     tokenPair.swap(uint256(0), ethAmount, address(this), new bytes(0));
1405 
1406     (, uint256 ethSwapAmount) = calcEthFee(ethAmount);
1407     address[] memory tokens = pipt.getCurrentTokens();
1408     (, , uint256 poolAmountOut) = calcSwapEthToPiptInputs(ethSwapAmount, tokens, _slippage);
1409 
1410     _swapWethToPiptByPoolOut(ethAmount, poolAmountOut);
1411 
1412     emit Erc20ToPiptSwap(msg.sender, _swapToken, _swapAmount, ethAmount, poolAmountOut);
1413   }
1414 
1415   function swapPiptToErc20(address _swapToken, uint256 _poolAmountIn) external {
1416     uint256 ethOut = _swapPiptToWeth(_poolAmountIn);
1417 
1418     IUniswapV2Pair tokenPair = _uniswapPairFor(_swapToken);
1419 
1420     (uint256 tokenReserve, uint256 ethReserve, ) = tokenPair.getReserves();
1421     uint256 erc20Out = UniswapV2Library.getAmountOut(ethOut, ethReserve, tokenReserve);
1422 
1423     weth.safeTransfer(address(tokenPair), ethOut);
1424 
1425     tokenPair.swap(erc20Out, uint256(0), address(this), new bytes(0));
1426 
1427     IERC20(_swapToken).safeTransfer(msg.sender, erc20Out);
1428 
1429     emit PiptToErc20Swap(msg.sender, _swapToken, _poolAmountIn, ethOut, erc20Out);
1430   }
1431 
1432   function calcSwapErc20ToPiptInputs(
1433     address _swapToken,
1434     uint256 _swapAmount,
1435     address[] memory _tokens,
1436     uint256 _slippage,
1437     bool _withFee
1438   )
1439     external
1440     view
1441     returns (
1442       uint256[] memory tokensInPipt,
1443       uint256[] memory ethInUniswap,
1444       uint256 poolOut
1445     )
1446   {
1447     (uint256 tokenReserve, uint256 ethReserve, ) = _uniswapPairFor(_swapToken).getReserves();
1448     uint256 ethAmount = UniswapV2Library.getAmountOut(_swapAmount, tokenReserve, ethReserve);
1449     if (_withFee) {
1450       (, ethAmount) = calcEthFee(ethAmount);
1451     }
1452     return calcSwapEthToPiptInputs(ethAmount, _tokens, _slippage);
1453   }
1454 
1455   function calcSwapPiptToErc20Inputs(
1456     address _swapToken,
1457     uint256 _poolAmountIn,
1458     address[] memory _tokens,
1459     bool _withFee
1460   )
1461     external
1462     view
1463     returns (
1464       uint256[] memory tokensOutPipt,
1465       uint256[] memory ethOutUniswap,
1466       uint256 totalErc20Out,
1467       uint256 poolAmountFee
1468     )
1469   {
1470     uint256 totalEthOut;
1471 
1472     (tokensOutPipt, ethOutUniswap, totalEthOut, poolAmountFee) = calcSwapPiptToEthInputs(_poolAmountIn, _tokens);
1473     if (_withFee) {
1474       (, totalEthOut) = calcEthFee(totalEthOut);
1475     }
1476     (uint256 tokenReserve, uint256 ethReserve, ) = _uniswapPairFor(_swapToken).getReserves();
1477     totalErc20Out = UniswapV2Library.getAmountOut(totalEthOut, ethReserve, tokenReserve);
1478   }
1479 
1480   function calcErc20Fee(address _swapToken, uint256 _swapAmount)
1481     external
1482     view
1483     returns (
1484       uint256 erc20Fee,
1485       uint256 erc20AfterFee,
1486       uint256 ethFee,
1487       uint256 ethAfterFee
1488     )
1489   {
1490     (uint256 tokenReserve, uint256 ethReserve, ) = _uniswapPairFor(_swapToken).getReserves();
1491     uint256 ethAmount = UniswapV2Library.getAmountOut(_swapAmount, tokenReserve, ethReserve);
1492 
1493     (ethFee, ethAfterFee) = calcEthFee(ethAmount);
1494 
1495     if (ethFee != 0) {
1496       erc20Fee = UniswapV2Library.getAmountOut(ethFee, ethReserve, tokenReserve);
1497     }
1498     erc20AfterFee = UniswapV2Library.getAmountOut(ethAfterFee, ethReserve, tokenReserve);
1499   }
1500 }