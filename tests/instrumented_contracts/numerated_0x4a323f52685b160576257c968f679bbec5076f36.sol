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
13 // SPDX-License-Identifier: MIT
14 
15 // File: @openzeppelin/contracts/math/SafeMath.sol
16 
17 pragma solidity >=0.6.0 <0.8.0;
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
177 pragma solidity >=0.6.0 <0.8.0;
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
255 pragma solidity >=0.6.2 <0.8.0;
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
279         // This method relies on extcodesize, which returns 0 for contracts in
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
342         return functionCallWithValue(target, data, 0, errorMessage);
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
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.call{ value: value }(data);
372         return _verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
382         return functionStaticCall(target, data, "Address: low-level static call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
392         require(isContract(target), "Address: static call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.staticcall(data);
396         return _verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
400         if (success) {
401             return returndata;
402         } else {
403             // Look for revert reason and bubble it up if present
404             if (returndata.length > 0) {
405                 // The easiest way to bubble the revert reason is using memory via assembly
406 
407                 // solhint-disable-next-line no-inline-assembly
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
420 
421 pragma solidity >=0.6.0 <0.8.0;
422 
423 
424 
425 
426 /**
427  * @title SafeERC20
428  * @dev Wrappers around ERC20 operations that throw on failure (when the token
429  * contract returns false). Tokens that return no value (and instead revert or
430  * throw on failure) are also supported, non-reverting calls are assumed to be
431  * successful.
432  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
433  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
434  */
435 library SafeERC20 {
436     using SafeMath for uint256;
437     using Address for address;
438 
439     function safeTransfer(IERC20 token, address to, uint256 value) internal {
440         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
441     }
442 
443     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
444         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
445     }
446 
447     /**
448      * @dev Deprecated. This function has issues similar to the ones found in
449      * {IERC20-approve}, and its usage is discouraged.
450      *
451      * Whenever possible, use {safeIncreaseAllowance} and
452      * {safeDecreaseAllowance} instead.
453      */
454     function safeApprove(IERC20 token, address spender, uint256 value) internal {
455         // safeApprove should only be called when setting an initial allowance,
456         // or when resetting it to zero. To increase and decrease it, use
457         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
458         // solhint-disable-next-line max-line-length
459         require((value == 0) || (token.allowance(address(this), spender) == 0),
460             "SafeERC20: approve from non-zero to non-zero allowance"
461         );
462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
463     }
464 
465     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).add(value);
467         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
471         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
472         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
473     }
474 
475     /**
476      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
477      * on the return value: the return value is optional (but if data is returned, it must not be false).
478      * @param token The token targeted by the call.
479      * @param data The call data (encoded using abi.encode or one of its variants).
480      */
481     function _callOptionalReturn(IERC20 token, bytes memory data) private {
482         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
483         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
484         // the target address contains contract code and also asserts for success in the low-level call.
485 
486         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
487         if (returndata.length > 0) { // Return data is optional
488             // solhint-disable-next-line max-line-length
489             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
490         }
491     }
492 }
493 
494 // File: @openzeppelin/contracts/GSN/Context.sol
495 
496 pragma solidity >=0.6.0 <0.8.0;
497 
498 /*
499  * @dev Provides information about the current execution context, including the
500  * sender of the transaction and its data. While these are generally available
501  * via msg.sender and msg.data, they should not be accessed in such a direct
502  * manner, since when dealing with GSN meta-transactions the account sending and
503  * paying for execution may not be the actual sender (as far as an application
504  * is concerned).
505  *
506  * This contract is only required for intermediate, library-like contracts.
507  */
508 abstract contract Context {
509     function _msgSender() internal view virtual returns (address payable) {
510         return msg.sender;
511     }
512 
513     function _msgData() internal view virtual returns (bytes memory) {
514         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
515         return msg.data;
516     }
517 }
518 
519 // File: @openzeppelin/contracts/access/Ownable.sol
520 
521 pragma solidity >=0.6.0 <0.8.0;
522 
523 /**
524  * @dev Contract module which provides a basic access control mechanism, where
525  * there is an account (an owner) that can be granted exclusive access to
526  * specific functions.
527  *
528  * By default, the owner account will be the one that deploys the contract. This
529  * can later be changed with {transferOwnership}.
530  *
531  * This module is used through inheritance. It will make available the modifier
532  * `onlyOwner`, which can be applied to your functions to restrict their use to
533  * the owner.
534  */
535 abstract contract Ownable is Context {
536     address private _owner;
537 
538     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
539 
540     /**
541      * @dev Initializes the contract setting the deployer as the initial owner.
542      */
543     constructor () internal {
544         address msgSender = _msgSender();
545         _owner = msgSender;
546         emit OwnershipTransferred(address(0), msgSender);
547     }
548 
549     /**
550      * @dev Returns the address of the current owner.
551      */
552     function owner() public view returns (address) {
553         return _owner;
554     }
555 
556     /**
557      * @dev Throws if called by any account other than the owner.
558      */
559     modifier onlyOwner() {
560         require(_owner == _msgSender(), "Ownable: caller is not the owner");
561         _;
562     }
563 
564     /**
565      * @dev Leaves the contract without owner. It will not be possible to call
566      * `onlyOwner` functions anymore. Can only be called by the current owner.
567      *
568      * NOTE: Renouncing ownership will leave the contract without an owner,
569      * thereby removing any functionality that is only available to the owner.
570      */
571     function renounceOwnership() public virtual onlyOwner {
572         emit OwnershipTransferred(_owner, address(0));
573         _owner = address(0);
574     }
575 
576     /**
577      * @dev Transfers ownership of the contract to a new account (`newOwner`).
578      * Can only be called by the current owner.
579      */
580     function transferOwnership(address newOwner) public virtual onlyOwner {
581         require(newOwner != address(0), "Ownable: new owner is the zero address");
582         emit OwnershipTransferred(_owner, newOwner);
583         _owner = newOwner;
584     }
585 }
586 
587 // File: contracts/interfaces/BMathInterface.sol
588 
589 pragma solidity 0.6.12;
590 
591 interface BMathInterface {
592   function calcInGivenOut(
593     uint256 tokenBalanceIn,
594     uint256 tokenWeightIn,
595     uint256 tokenBalanceOut,
596     uint256 tokenWeightOut,
597     uint256 tokenAmountOut,
598     uint256 swapFee
599   ) external pure returns (uint256 tokenAmountIn);
600 
601   function calcSingleInGivenPoolOut(
602     uint256 tokenBalanceIn,
603     uint256 tokenWeightIn,
604     uint256 poolSupply,
605     uint256 totalWeight,
606     uint256 poolAmountOut,
607     uint256 swapFee
608   ) external pure returns (uint256 tokenAmountIn);
609 }
610 
611 // File: contracts/interfaces/BPoolInterface.sol
612 
613 pragma solidity 0.6.12;
614 
615 
616 
617 interface BPoolInterface is IERC20, BMathInterface {
618   function joinPool(uint256 poolAmountOut, uint256[] calldata maxAmountsIn) external;
619 
620   function exitPool(uint256 poolAmountIn, uint256[] calldata minAmountsOut) external;
621 
622   function swapExactAmountIn(
623     address,
624     uint256,
625     address,
626     uint256,
627     uint256
628   ) external returns (uint256, uint256);
629 
630   function swapExactAmountOut(
631     address,
632     uint256,
633     address,
634     uint256,
635     uint256
636   ) external returns (uint256, uint256);
637 
638   function joinswapExternAmountIn(
639     address,
640     uint256,
641     uint256
642   ) external returns (uint256);
643 
644   function joinswapPoolAmountOut(
645     address,
646     uint256,
647     uint256
648   ) external returns (uint256);
649 
650   function exitswapPoolAmountIn(
651     address,
652     uint256,
653     uint256
654   ) external returns (uint256);
655 
656   function exitswapExternAmountOut(
657     address,
658     uint256,
659     uint256
660   ) external returns (uint256);
661 
662   function getDenormalizedWeight(address) external view returns (uint256);
663 
664   function getBalance(address) external view returns (uint256);
665 
666   function getSwapFee() external view returns (uint256);
667 
668   function getTotalDenormalizedWeight() external view returns (uint256);
669 
670   function getCommunityFee()
671     external
672     view
673     returns (
674       uint256,
675       uint256,
676       uint256,
677       address
678     );
679 
680   function calcAmountWithCommunityFee(
681     uint256,
682     uint256,
683     address
684   ) external view returns (uint256, uint256);
685 
686   function getRestrictions() external view returns (address);
687 
688   function isPublicSwap() external view returns (bool);
689 
690   function isFinalized() external view returns (bool);
691 
692   function isBound(address t) external view returns (bool);
693 
694   function getCurrentTokens() external view returns (address[] memory tokens);
695 
696   function getFinalTokens() external view returns (address[] memory tokens);
697 
698   function setSwapFee(uint256) external;
699 
700   function setCommunityFeeAndReceiver(
701     uint256,
702     uint256,
703     uint256,
704     address
705   ) external;
706 
707   function setController(address) external;
708 
709   function setPublicSwap(bool) external;
710 
711   function finalize() external;
712 
713   function bind(
714     address,
715     uint256,
716     uint256
717   ) external;
718 
719   function rebind(
720     address,
721     uint256,
722     uint256
723   ) external;
724 
725   function unbind(address) external;
726 
727   function gulp(address) external;
728 
729   function callVoting(
730     address voting,
731     bytes4 signature,
732     bytes calldata args,
733     uint256 value
734   ) external;
735 
736   function getMinWeight() external view returns (uint256);
737 
738   function getMaxBoundTokens() external view returns (uint256);
739 }
740 
741 // File: contracts/interfaces/PowerIndexWrapperInterface.sol
742 
743 pragma solidity 0.6.12;
744 
745 interface PowerIndexWrapperInterface {
746   function getFinalTokens() external view returns (address[] memory tokens);
747 
748   function getCurrentTokens() external view returns (address[] memory tokens);
749 
750   function getBalance(address _token) external view returns (uint256);
751 
752   function setPiTokenForUnderlyingsMultiple(address[] calldata _underlyingTokens, address[] calldata _piTokens)
753     external;
754 
755   function setPiTokenForUnderlying(address _underlyingTokens, address _piToken) external;
756 
757   function updatePiTokenEthFees(address[] calldata _underlyingTokens) external;
758 
759   function withdrawOddEthFee(address payable _recipient) external;
760 
761   function calcEthFeeForTokens(address[] memory tokens) external view returns (uint256 feeSum);
762 
763   function joinPool(uint256 poolAmountOut, uint256[] calldata maxAmountsIn) external payable;
764 
765   function exitPool(uint256 poolAmountIn, uint256[] calldata minAmountsOut) external payable;
766 
767   function swapExactAmountIn(
768     address,
769     uint256,
770     address,
771     uint256,
772     uint256
773   ) external payable returns (uint256, uint256);
774 
775   function swapExactAmountOut(
776     address,
777     uint256,
778     address,
779     uint256,
780     uint256
781   ) external payable returns (uint256, uint256);
782 
783   function joinswapExternAmountIn(
784     address,
785     uint256,
786     uint256
787   ) external payable returns (uint256);
788 
789   function joinswapPoolAmountOut(
790     address,
791     uint256,
792     uint256
793   ) external payable returns (uint256);
794 
795   function exitswapPoolAmountIn(
796     address,
797     uint256,
798     uint256
799   ) external payable returns (uint256);
800 
801   function exitswapExternAmountOut(
802     address,
803     uint256,
804     uint256
805   ) external payable returns (uint256);
806 }
807 
808 // File: contracts/interfaces/TokenInterface.sol
809 
810 pragma solidity 0.6.12;
811 
812 
813 interface TokenInterface is IERC20 {
814   function deposit() external payable;
815 
816   function withdraw(uint256) external;
817 }
818 
819 // File: contracts/interfaces/IPoolRestrictions.sol
820 
821 pragma solidity 0.6.12;
822 
823 interface IPoolRestrictions {
824   function getMaxTotalSupply(address _pool) external view returns (uint256);
825 
826   function isVotingSignatureAllowed(address _votingAddress, bytes4 _signature) external view returns (bool);
827 
828   function isVotingSenderAllowed(address _votingAddress, address _sender) external view returns (bool);
829 
830   function isWithoutFee(address _addr) external view returns (bool);
831 }
832 
833 // File: contracts/interfaces/IUniswapV2Pair.sol
834 
835 pragma solidity >=0.5.0;
836 
837 interface IUniswapV2Pair {
838   event Approval(address indexed owner, address indexed spender, uint256 value);
839   event Transfer(address indexed from, address indexed to, uint256 value);
840 
841   function name() external pure returns (string memory);
842 
843   function symbol() external pure returns (string memory);
844 
845   function decimals() external pure returns (uint8);
846 
847   function totalSupply() external view returns (uint256);
848 
849   function balanceOf(address owner) external view returns (uint256);
850 
851   function allowance(address owner, address spender) external view returns (uint256);
852 
853   function approve(address spender, uint256 value) external returns (bool);
854 
855   function transfer(address to, uint256 value) external returns (bool);
856 
857   function transferFrom(
858     address from,
859     address to,
860     uint256 value
861   ) external returns (bool);
862 
863   function DOMAIN_SEPARATOR() external view returns (bytes32);
864 
865   function PERMIT_TYPEHASH() external pure returns (bytes32);
866 
867   function nonces(address owner) external view returns (uint256);
868 
869   function permit(
870     address owner,
871     address spender,
872     uint256 value,
873     uint256 deadline,
874     uint8 v,
875     bytes32 r,
876     bytes32 s
877   ) external;
878 
879   event Mint(address indexed sender, uint256 amount0, uint256 amount1);
880   event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
881   event Swap(
882     address indexed sender,
883     uint256 amount0In,
884     uint256 amount1In,
885     uint256 amount0Out,
886     uint256 amount1Out,
887     address indexed to
888   );
889   event Sync(uint112 reserve0, uint112 reserve1);
890 
891   function MINIMUM_LIQUIDITY() external pure returns (uint256);
892 
893   function factory() external view returns (address);
894 
895   function token0() external view returns (address);
896 
897   function token1() external view returns (address);
898 
899   function getReserves()
900     external
901     view
902     returns (
903       uint112 reserve0,
904       uint112 reserve1,
905       uint32 blockTimestampLast
906     );
907 
908   function price0CumulativeLast() external view returns (uint256);
909 
910   function price1CumulativeLast() external view returns (uint256);
911 
912   function kLast() external view returns (uint256);
913 
914   function mint(address to) external returns (uint256 liquidity);
915 
916   function burn(address to) external returns (uint256 amount0, uint256 amount1);
917 
918   function swap(
919     uint256 amount0Out,
920     uint256 amount1Out,
921     address to,
922     bytes calldata data
923   ) external;
924 
925   function skim(address to) external;
926 
927   function sync() external;
928 
929   function initialize(address, address) external;
930 }
931 
932 // File: contracts/interfaces/IUniswapV2Factory.sol
933 
934 pragma solidity >=0.5.0;
935 
936 interface IUniswapV2Factory {
937   event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
938 
939   function feeTo() external view returns (address);
940 
941   function feeToSetter() external view returns (address);
942 
943   function migrator() external view returns (address);
944 
945   function getPair(address tokenA, address tokenB) external view returns (address pair);
946 
947   function allPairs(uint256) external view returns (address pair);
948 
949   function allPairsLength() external view returns (uint256);
950 
951   function createPair(address tokenA, address tokenB) external returns (address pair);
952 
953   function setFeeTo(address) external;
954 
955   function setFeeToSetter(address) external;
956 
957   function setMigrator(address) external;
958 }
959 
960 // File: contracts/lib/SafeMathUniswap.sol
961 
962 pragma solidity =0.6.12;
963 
964 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
965 
966 library SafeMathUniswap {
967     function add(uint x, uint y) internal pure returns (uint z) {
968         require((z = x + y) >= x, 'ds-math-add-overflow');
969     }
970 
971     function sub(uint x, uint y) internal pure returns (uint z) {
972         require((z = x - y) <= x, 'ds-math-sub-underflow');
973     }
974 
975     function mul(uint x, uint y) internal pure returns (uint z) {
976         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
977     }
978 }
979 
980 // File: contracts/lib/UniswapV2Library.sol
981 
982 pragma solidity >=0.5.0;
983 
984 
985 
986 
987 library UniswapV2Library {
988     using SafeMathUniswap for uint;
989 
990     // returns sorted token addresses, used to handle return values from pairs sorted in this order
991     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
992         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
993         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
994         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
995     }
996 
997     // calculates the CREATE2 address for a pair without making any external calls
998     // NOTICE: In order to make testing more convenient  this method was hacked to fetch a pair address
999     // from the factory, since the pair contract hash changes depending on compiler and coverage setup.
1000     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
1001         return IUniswapV2Factory(factory).getPair(tokenA, tokenB);
1002     }
1003 
1004     // fetches and sorts the reserves for a pair
1005     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1006         (address token0,) = sortTokens(tokenA, tokenB);
1007         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1008         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1009     }
1010 
1011     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1012     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1013         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1014         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1015         amountB = amountA.mul(reserveB) / reserveA;
1016     }
1017 
1018     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1019     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
1020         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
1021         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1022         uint amountInWithFee = amountIn.mul(997);
1023         uint numerator = amountInWithFee.mul(reserveOut);
1024         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1025         amountOut = numerator / denominator;
1026     }
1027 
1028     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
1029     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
1030         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
1031         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1032         uint numerator = reserveIn.mul(amountOut).mul(1000);
1033         uint denominator = reserveOut.sub(amountOut).mul(997);
1034         amountIn = (numerator / denominator).add(1);
1035     }
1036 
1037     // performs chained getAmountOut calculations on any number of pairs
1038     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
1039         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1040         amounts = new uint[](path.length);
1041         amounts[0] = amountIn;
1042         for (uint i; i < path.length - 1; i++) {
1043             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
1044             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
1045         }
1046     }
1047 
1048     // performs chained getAmountIn calculations on any number of pairs
1049     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
1050         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1051         amounts = new uint[](path.length);
1052         amounts[amounts.length - 1] = amountOut;
1053         for (uint i = path.length - 1; i > 0; i--) {
1054             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
1055             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
1056         }
1057     }
1058 }
1059 
1060 // File: contracts/EthPiptSwap.sol
1061 
1062 pragma solidity 0.6.12;
1063 
1064 contract EthPiptSwap is Ownable {
1065   using SafeMath for uint256;
1066   using SafeERC20 for IERC20;
1067   using SafeERC20 for TokenInterface;
1068   using SafeERC20 for BPoolInterface;
1069 
1070   TokenInterface public weth;
1071   TokenInterface public cvp;
1072   BPoolInterface public pipt;
1073   PowerIndexWrapperInterface public piptWrapper;
1074 
1075   uint256[] public feeLevels;
1076   uint256[] public feeAmounts;
1077   address public feePayout;
1078   address public feeManager;
1079 
1080   mapping(address => address) public uniswapEthPairByTokenAddress;
1081   mapping(address => address) public uniswapEthPairToken0;
1082   mapping(address => bool) public reApproveTokens;
1083   uint256 public defaultSlippage;
1084 
1085   struct CalculationStruct {
1086     uint256 tokenAmount;
1087     uint256 ethAmount;
1088     uint256 tokenReserve;
1089     uint256 ethReserve;
1090   }
1091 
1092   event SetTokenSetting(address indexed token, bool indexed reApprove, address indexed uniswapPair);
1093   event SetDefaultSlippage(uint256 newDefaultSlippage);
1094   event SetPiptWrapper(address _piptWrapper);
1095   event SetFees(
1096     address indexed sender,
1097     uint256[] newFeeLevels,
1098     uint256[] newFeeAmounts,
1099     address indexed feePayout,
1100     address indexed feeManager
1101   );
1102 
1103   event EthToPiptSwap(
1104     address indexed user,
1105     uint256 ethInAmount,
1106     uint256 ethSwapFee,
1107     uint256 poolOutAmount,
1108     uint256 poolCommunityFee
1109   );
1110   event OddEth(address indexed user, uint256 amount);
1111   event PiptToEthSwap(
1112     address indexed user,
1113     uint256 poolInAmount,
1114     uint256 poolCommunityFee,
1115     uint256 ethOutAmount,
1116     uint256 ethSwapFee
1117   );
1118   event PayoutCVP(address indexed receiver, uint256 wethAmount, uint256 cvpAmount);
1119 
1120   constructor(
1121     address _weth,
1122     address _cvp,
1123     address _pipt,
1124     address _piptWrapper,
1125     address _feeManager
1126   ) public Ownable() {
1127     weth = TokenInterface(_weth);
1128     cvp = TokenInterface(_cvp);
1129     pipt = BPoolInterface(_pipt);
1130     piptWrapper = PowerIndexWrapperInterface(_piptWrapper);
1131     feeManager = _feeManager;
1132     defaultSlippage = 0.02 ether;
1133   }
1134 
1135   modifier onlyFeeManagerOrOwner() {
1136     require(msg.sender == feeManager || msg.sender == owner(), "NOT_FEE_MANAGER");
1137     _;
1138   }
1139 
1140   receive() external payable {
1141     if (msg.sender != tx.origin) {
1142       return;
1143     }
1144     swapEthToPipt(defaultSlippage);
1145   }
1146 
1147   function swapEthToPipt(uint256 _slippage) public payable returns (uint256 poolAmountOutAfterFee, uint256 oddEth) {
1148     address[] memory tokens = getPiptTokens();
1149 
1150     uint256 wrapperFee = getWrapFee(tokens);
1151     (, uint256 swapAmount) = calcEthFee(msg.value, wrapperFee);
1152 
1153     (, , uint256 poolAmountOut) = calcSwapEthToPiptInputs(swapAmount, tokens, _slippage);
1154 
1155     weth.deposit{ value: msg.value }();
1156 
1157     return _swapWethToPiptByPoolOut(msg.value, poolAmountOut, tokens, wrapperFee);
1158   }
1159 
1160   function swapEthToPiptByPoolOut(uint256 _poolAmountOut)
1161     external
1162     payable
1163     returns (uint256 poolAmountOutAfterFee, uint256 oddEth)
1164   {
1165     weth.deposit{ value: msg.value }();
1166 
1167     address[] memory tokens = getPiptTokens();
1168     return _swapWethToPiptByPoolOut(msg.value, _poolAmountOut, tokens, getWrapFee(tokens));
1169   }
1170 
1171   function swapPiptToEth(uint256 _poolAmountIn) external payable returns (uint256 ethOutAmount) {
1172     ethOutAmount = _swapPiptToWeth(_poolAmountIn);
1173 
1174     weth.withdraw(ethOutAmount);
1175     msg.sender.transfer(ethOutAmount);
1176   }
1177 
1178   function convertOddToCvpAndSendToPayout(address[] memory oddTokens) external {
1179     require(msg.sender == tx.origin && !Address.isContract(msg.sender), "CONTRACT_NOT_ALLOWED");
1180 
1181     uint256 len = oddTokens.length;
1182 
1183     for (uint256 i = 0; i < len; i++) {
1184       _swapTokenForWethOut(oddTokens[i], TokenInterface(oddTokens[i]).balanceOf(address(this)));
1185     }
1186 
1187     uint256 wethBalance = weth.balanceOf(address(this));
1188     uint256 cvpOut = _swapWethForTokenOut(address(cvp), wethBalance);
1189 
1190     cvp.safeTransfer(feePayout, cvpOut);
1191 
1192     emit PayoutCVP(feePayout, wethBalance, cvpOut);
1193   }
1194 
1195   function setFees(
1196     uint256[] calldata _feeLevels,
1197     uint256[] calldata _feeAmounts,
1198     address _feePayout,
1199     address _feeManager
1200   ) external onlyFeeManagerOrOwner {
1201     feeLevels = _feeLevels;
1202     feeAmounts = _feeAmounts;
1203     feePayout = _feePayout;
1204     feeManager = _feeManager;
1205 
1206     emit SetFees(msg.sender, _feeLevels, _feeAmounts, _feePayout, _feeManager);
1207   }
1208 
1209   function setTokensSettings(
1210     address[] memory _tokens,
1211     address[] memory _pairs,
1212     bool[] memory _reapprove
1213   ) external onlyOwner {
1214     uint256 len = _tokens.length;
1215     require(len == _pairs.length && len == _reapprove.length, "LENGTHS_NOT_EQUAL");
1216     for (uint256 i = 0; i < len; i++) {
1217       _setUniswapSettingAndPrepareToken(_tokens[i], _pairs[i]);
1218       reApproveTokens[_tokens[i]] = _reapprove[i];
1219       emit SetTokenSetting(_tokens[i], _reapprove[i], _pairs[i]);
1220     }
1221   }
1222 
1223   function fetchUnswapPairsFromFactory(address _factory, address[] calldata _tokens) external onlyOwner {
1224     uint256 len = _tokens.length;
1225     for (uint256 i = 0; i < len; i++) {
1226       _setUniswapSettingAndPrepareToken(_tokens[i], IUniswapV2Factory(_factory).getPair(_tokens[i], address(weth)));
1227     }
1228   }
1229 
1230   function setDefaultSlippage(uint256 _defaultSlippage) external onlyOwner {
1231     defaultSlippage = _defaultSlippage;
1232     emit SetDefaultSlippage(_defaultSlippage);
1233   }
1234 
1235   function setPiptWrapper(address _piptWrapper) external onlyOwner {
1236     piptWrapper = PowerIndexWrapperInterface(_piptWrapper);
1237     emit SetPiptWrapper(_piptWrapper);
1238   }
1239 
1240   function calcSwapEthToPiptInputs(
1241     uint256 _ethValue,
1242     address[] memory _tokens,
1243     uint256 _slippage
1244   )
1245     public
1246     view
1247     returns (
1248       uint256[] memory tokensInPipt,
1249       uint256[] memory ethInUniswap,
1250       uint256 poolOut
1251     )
1252   {
1253     _ethValue = _ethValue.sub(_ethValue.mul(_slippage).div(1 ether));
1254 
1255     // get shares and eth required for each share
1256     CalculationStruct[] memory calculations = new CalculationStruct[](_tokens.length);
1257 
1258     uint256 totalEthRequired = 0;
1259     {
1260       uint256 piptTotalSupply = pipt.totalSupply();
1261       // get pool out for 1 ether as 100% for calculate shares
1262       // poolOut by 1 ether first token join = piptTotalSupply.mul(1 ether).div(getPiptTokenBalance(_tokens[0]))
1263       // poolRatio = poolOut/totalSupply
1264       uint256 poolRatio =
1265         piptTotalSupply.mul(1 ether).div(getPiptTokenBalance(_tokens[0])).mul(1 ether).div(piptTotalSupply);
1266 
1267       for (uint256 i = 0; i < _tokens.length; i++) {
1268         // token share relatively 1 ether of first token
1269         calculations[i].tokenAmount = poolRatio.mul(getPiptTokenBalance(_tokens[i])).div(1 ether);
1270         calculations[i].ethAmount = getAmountInForUniswapValue(
1271           _uniswapPairFor(_tokens[i]),
1272           calculations[i].tokenAmount,
1273           true
1274         );
1275         totalEthRequired = totalEthRequired.add(calculations[i].ethAmount);
1276       }
1277     }
1278 
1279     // calculate eth and tokensIn based on shares and normalize if totalEthRequired more than 100%
1280     tokensInPipt = new uint256[](_tokens.length);
1281     ethInUniswap = new uint256[](_tokens.length);
1282     for (uint256 i = 0; i < _tokens.length; i++) {
1283       ethInUniswap[i] = _ethValue.mul(calculations[i].ethAmount.mul(1 ether).div(totalEthRequired)).div(1 ether);
1284       tokensInPipt[i] = calculations[i].tokenAmount.mul(_ethValue.mul(1 ether).div(totalEthRequired)).div(1 ether);
1285     }
1286 
1287     poolOut = pipt.totalSupply().mul(tokensInPipt[0]).div(getPiptTokenBalance(_tokens[0]));
1288   }
1289 
1290   function calcSwapPiptToEthInputs(uint256 _poolAmountIn, address[] memory _tokens)
1291     public
1292     view
1293     returns (
1294       uint256[] memory tokensOutPipt,
1295       uint256[] memory ethOutUniswap,
1296       uint256 totalEthOut,
1297       uint256 poolAmountFee
1298     )
1299   {
1300     tokensOutPipt = new uint256[](_tokens.length);
1301     ethOutUniswap = new uint256[](_tokens.length);
1302 
1303     (, , uint256 communityExitFee, ) = pipt.getCommunityFee();
1304 
1305     uint256 poolAmountInAfterFee;
1306     (poolAmountInAfterFee, poolAmountFee) = pipt.calcAmountWithCommunityFee(
1307       _poolAmountIn,
1308       communityExitFee,
1309       address(this)
1310     );
1311 
1312     uint256 poolRatio = poolAmountInAfterFee.mul(1 ether).div(pipt.totalSupply());
1313 
1314     totalEthOut = 0;
1315     for (uint256 i = 0; i < _tokens.length; i++) {
1316       tokensOutPipt[i] = poolRatio.mul(getPiptTokenBalance(_tokens[i])).div(1 ether);
1317       ethOutUniswap[i] = getAmountOutForUniswapValue(_uniswapPairFor(_tokens[i]), tokensOutPipt[i], true);
1318       totalEthOut = totalEthOut.add(ethOutUniswap[i]);
1319     }
1320   }
1321 
1322   function calcNeedEthToPoolOut(uint256 _poolAmountOut, uint256 _slippage) public view returns (uint256) {
1323     uint256 ratio = _poolAmountOut.mul(1 ether).div(pipt.totalSupply()).add(100);
1324 
1325     address[] memory tokens = getPiptTokens();
1326     uint256 len = tokens.length;
1327 
1328     CalculationStruct[] memory calculations = new CalculationStruct[](len);
1329     uint256[] memory tokensInPipt = new uint256[](len);
1330 
1331     uint256 totalEthSwap = 0;
1332     for (uint256 i = 0; i < len; i++) {
1333       tokensInPipt[i] = ratio.mul(getPiptTokenBalance(tokens[i])).div(1 ether);
1334       totalEthSwap = getAmountInForUniswapValue(_uniswapPairFor(tokens[i]), tokensInPipt[i], true).add(totalEthSwap);
1335     }
1336     return totalEthSwap.add(totalEthSwap.mul(_slippage).div(1 ether));
1337   }
1338 
1339   function calcEthFee(uint256 ethAmount, uint256 wrapperFee) public view returns (uint256 ethFee, uint256 ethAfterFee) {
1340     uint256 len = feeLevels.length;
1341     for (uint256 i = 0; i < len; i++) {
1342       if (ethAmount >= feeLevels[i]) {
1343         ethFee = ethAmount.mul(feeAmounts[i]).div(1 ether);
1344         break;
1345       }
1346     }
1347     ethFee = ethFee.add(wrapperFee);
1348     ethAfterFee = ethAmount.sub(ethFee);
1349   }
1350 
1351   function calcEthFee(uint256 ethAmount) external view returns (uint256 ethFee, uint256 ethAfterFee) {
1352     (ethFee, ethAfterFee) = calcEthFee(ethAmount, getWrapFee(getPiptTokens()));
1353   }
1354 
1355   function getFeeLevels() external view returns (uint256[] memory) {
1356     return feeLevels;
1357   }
1358 
1359   function getFeeAmounts() external view returns (uint256[] memory) {
1360     return feeAmounts;
1361   }
1362 
1363   function getWrapFee(address[] memory tokens) public view returns (uint256 wrapperFee) {
1364     if (address(piptWrapper) != address(0)) {
1365       wrapperFee = piptWrapper.calcEthFeeForTokens(tokens);
1366     }
1367   }
1368 
1369   function getPiptTokens() public view returns (address[] memory) {
1370     return address(piptWrapper) == address(0) ? pipt.getCurrentTokens() : piptWrapper.getCurrentTokens();
1371   }
1372 
1373   function getPiptTokenBalance(address _token) public view returns (uint256) {
1374     return address(piptWrapper) == address(0) ? pipt.getBalance(_token) : piptWrapper.getBalance(_token);
1375   }
1376 
1377   function getAmountInForUniswap(
1378     IUniswapV2Pair _tokenPair,
1379     uint256 _swapAmount,
1380     bool _isEthIn
1381   ) public view returns (uint256 amountIn, bool isInverse) {
1382     isInverse = uniswapEthPairToken0[address(_tokenPair)] == address(weth);
1383     if (_isEthIn ? !isInverse : isInverse) {
1384       (uint256 ethReserve, uint256 tokenReserve, ) = _tokenPair.getReserves();
1385       amountIn = UniswapV2Library.getAmountIn(_swapAmount, tokenReserve, ethReserve);
1386     } else {
1387       (uint256 tokenReserve, uint256 ethReserve, ) = _tokenPair.getReserves();
1388       amountIn = UniswapV2Library.getAmountIn(_swapAmount, tokenReserve, ethReserve);
1389     }
1390   }
1391 
1392   function getAmountInForUniswapValue(
1393     IUniswapV2Pair _tokenPair,
1394     uint256 _swapAmount,
1395     bool _isEthIn
1396   ) public view returns (uint256 amountIn) {
1397     (amountIn, ) = getAmountInForUniswap(_tokenPair, _swapAmount, _isEthIn);
1398   }
1399 
1400   function getAmountOutForUniswap(
1401     IUniswapV2Pair _tokenPair,
1402     uint256 _swapAmount,
1403     bool _isEthOut
1404   ) public view returns (uint256 amountOut, bool isInverse) {
1405     isInverse = uniswapEthPairToken0[address(_tokenPair)] == address(weth);
1406     if (_isEthOut ? isInverse : !isInverse) {
1407       (uint256 ethReserve, uint256 tokenReserve, ) = _tokenPair.getReserves();
1408       amountOut = UniswapV2Library.getAmountOut(_swapAmount, tokenReserve, ethReserve);
1409     } else {
1410       (uint256 tokenReserve, uint256 ethReserve, ) = _tokenPair.getReserves();
1411       amountOut = UniswapV2Library.getAmountOut(_swapAmount, tokenReserve, ethReserve);
1412     }
1413   }
1414 
1415   function getAmountOutForUniswapValue(
1416     IUniswapV2Pair _tokenPair,
1417     uint256 _swapAmount,
1418     bool _isEthOut
1419   ) public view returns (uint256 ethAmount) {
1420     (ethAmount, ) = getAmountOutForUniswap(_tokenPair, _swapAmount, _isEthOut);
1421   }
1422 
1423   function _setUniswapSettingAndPrepareToken(address _token, address _pair) internal {
1424     uniswapEthPairByTokenAddress[_token] = _pair;
1425     uniswapEthPairToken0[_pair] = IUniswapV2Pair(_pair).token0();
1426   }
1427 
1428   function _uniswapPairFor(address token) internal view returns (IUniswapV2Pair) {
1429     return IUniswapV2Pair(uniswapEthPairByTokenAddress[token]);
1430   }
1431 
1432   function _swapWethToPiptByPoolOut(
1433     uint256 _wethAmount,
1434     uint256 _poolAmountOut,
1435     address[] memory tokens,
1436     uint256 wrapperFee
1437   ) internal returns (uint256 poolAmountOutAfterFee, uint256 oddEth) {
1438     require(_wethAmount > 0, "ETH_REQUIRED");
1439 
1440     {
1441       address poolRestrictions = pipt.getRestrictions();
1442       if (address(poolRestrictions) != address(0)) {
1443         uint256 maxTotalSupply = IPoolRestrictions(poolRestrictions).getMaxTotalSupply(address(pipt));
1444         require(pipt.totalSupply().add(_poolAmountOut) <= maxTotalSupply, "PIPT_MAX_SUPPLY");
1445       }
1446     }
1447 
1448     (uint256 feeAmount, uint256 swapAmount) = calcEthFee(_wethAmount, wrapperFee);
1449     (uint256[] memory tokensInPipt, uint256 totalEthSwap) = _prepareTokensForJoin(tokens, _poolAmountOut);
1450 
1451     {
1452       uint256 poolAmountOutFee;
1453       (, uint256 communityJoinFee, , ) = pipt.getCommunityFee();
1454       (poolAmountOutAfterFee, poolAmountOutFee) = pipt.calcAmountWithCommunityFee(
1455         _poolAmountOut,
1456         communityJoinFee,
1457         address(this)
1458       );
1459 
1460       emit EthToPiptSwap(msg.sender, swapAmount, feeAmount, _poolAmountOut, poolAmountOutFee);
1461     }
1462 
1463     _joinPool(_poolAmountOut, tokensInPipt, wrapperFee);
1464     totalEthSwap = totalEthSwap.add(wrapperFee);
1465     pipt.safeTransfer(msg.sender, poolAmountOutAfterFee);
1466 
1467     oddEth = swapAmount.sub(totalEthSwap);
1468     if (oddEth > 0) {
1469       weth.withdraw(oddEth);
1470       msg.sender.transfer(oddEth);
1471       emit OddEth(msg.sender, oddEth);
1472     }
1473   }
1474 
1475   function _prepareTokensForJoin(address[] memory _tokens, uint256 _poolAmountOut)
1476     internal
1477     returns (uint256[] memory tokensInPipt, uint256 totalEthSwap)
1478   {
1479     uint256 len = _tokens.length;
1480     tokensInPipt = new uint256[](len);
1481     uint256 ratio = _poolAmountOut.mul(1 ether).div(pipt.totalSupply()).add(100);
1482     for (uint256 i = 0; i < len; i++) {
1483       tokensInPipt[i] = ratio.mul(getPiptTokenBalance(_tokens[i])).div(1 ether);
1484       totalEthSwap = totalEthSwap.add(_swapWethForTokenIn(_tokens[i], tokensInPipt[i]));
1485 
1486       address approveAddress = address(piptWrapper) == address(0) ? address(pipt) : address(piptWrapper);
1487       if (reApproveTokens[_tokens[i]]) {
1488         TokenInterface(_tokens[i]).approve(approveAddress, 0);
1489       }
1490       TokenInterface(_tokens[i]).approve(approveAddress, tokensInPipt[i]);
1491     }
1492   }
1493 
1494   function _swapPiptToWeth(uint256 _poolAmountIn) internal returns (uint256) {
1495     address[] memory tokens = getPiptTokens();
1496     uint256 len = tokens.length;
1497 
1498     (uint256[] memory tokensOutPipt, uint256[] memory ethOutUniswap, uint256 totalEthOut, uint256 poolAmountFee) =
1499       calcSwapPiptToEthInputs(_poolAmountIn, tokens);
1500 
1501     pipt.safeTransferFrom(msg.sender, address(this), _poolAmountIn);
1502 
1503     uint256 wrapperFee = getWrapFee(tokens);
1504 
1505     (uint256 ethFeeAmount, uint256 ethOutAmount) = calcEthFee(totalEthOut, wrapperFee);
1506 
1507     _exitPool(_poolAmountIn, tokensOutPipt, wrapperFee);
1508 
1509     for (uint256 i = 0; i < len; i++) {
1510       IUniswapV2Pair tokenPair = _uniswapPairFor(tokens[i]);
1511       TokenInterface(tokens[i]).safeTransfer(address(tokenPair), tokensOutPipt[i]);
1512       tokenPair.swap(uint256(0), ethOutUniswap[i], address(this), new bytes(0));
1513     }
1514 
1515     emit PiptToEthSwap(msg.sender, _poolAmountIn, poolAmountFee, ethOutAmount, ethFeeAmount);
1516 
1517     return ethOutAmount;
1518   }
1519 
1520   function _joinPool(
1521     uint256 _poolAmountOut,
1522     uint256[] memory _maxAmountsIn,
1523     uint256 _wrapperFee
1524   ) internal {
1525     if (address(piptWrapper) == address(0)) {
1526       pipt.joinPool(_poolAmountOut, _maxAmountsIn);
1527     } else {
1528       if (address(this).balance < _wrapperFee) {
1529         weth.withdraw(_wrapperFee);
1530       }
1531       piptWrapper.joinPool{ value: _wrapperFee }(_poolAmountOut, _maxAmountsIn);
1532     }
1533   }
1534 
1535   function _exitPool(
1536     uint256 _poolAmountIn,
1537     uint256[] memory _minAmountsOut,
1538     uint256 _wrapperFee
1539   ) internal {
1540     pipt.approve(address(piptWrapper) == address(0) ? address(pipt) : address(piptWrapper), _poolAmountIn);
1541 
1542     if (address(piptWrapper) == address(0)) {
1543       pipt.exitPool(_poolAmountIn, _minAmountsOut);
1544     } else {
1545       piptWrapper.exitPool{ value: _wrapperFee }(_poolAmountIn, _minAmountsOut);
1546     }
1547   }
1548 
1549   function _swapWethForTokenIn(address _erc20, uint256 _erc20Out) internal returns (uint256 ethIn) {
1550     IUniswapV2Pair tokenPair = _uniswapPairFor(_erc20);
1551     bool isInverse;
1552     (ethIn, isInverse) = getAmountInForUniswap(tokenPair, _erc20Out, true);
1553     weth.safeTransfer(address(tokenPair), ethIn);
1554     tokenPair.swap(isInverse ? uint256(0) : _erc20Out, isInverse ? _erc20Out : uint256(0), address(this), new bytes(0));
1555   }
1556 
1557   function _swapWethForTokenOut(address _erc20, uint256 _ethIn) internal returns (uint256 erc20Out) {
1558     IUniswapV2Pair tokenPair = _uniswapPairFor(_erc20);
1559     bool isInverse;
1560     (erc20Out, isInverse) = getAmountOutForUniswap(tokenPair, _ethIn, false);
1561     weth.safeTransfer(address(tokenPair), _ethIn);
1562     tokenPair.swap(isInverse ? uint256(0) : erc20Out, isInverse ? erc20Out : uint256(0), address(this), new bytes(0));
1563   }
1564 
1565   function _swapTokenForWethOut(address _erc20, uint256 _erc20In) internal returns (uint256 ethOut) {
1566     IUniswapV2Pair tokenPair = _uniswapPairFor(_erc20);
1567     bool isInverse;
1568     (ethOut, isInverse) = getAmountOutForUniswap(tokenPair, _erc20In, true);
1569     IERC20(_erc20).safeTransfer(address(tokenPair), _erc20In);
1570     tokenPair.swap(isInverse ? ethOut : uint256(0), isInverse ? uint256(0) : ethOut, address(this), new bytes(0));
1571   }
1572 }
1573 
1574 // File: contracts/Erc20PiptSwap.sol
1575 
1576 /*
1577 https://powerpool.finance/
1578 
1579           wrrrw r wrr
1580          ppwr rrr wppr0       prwwwrp                                 prwwwrp                   wr0
1581         rr 0rrrwrrprpwp0      pp   pr  prrrr0 pp   0r  prrrr0  0rwrrr pp   pr  prrrr0  prrrr0    r0
1582         rrp pr   wr00rrp      prwww0  pp   wr pp w00r prwwwpr  0rw    prwww0  pp   wr pp   wr    r0
1583         r0rprprwrrrp pr0      pp      wr   pr pp rwwr wr       0r     pp      wr   pr wr   pr    r0
1584          prwr wrr0wpwr        00        www0   0w0ww    www0   0w     00        www0    www0   0www0
1585           wrr ww0rrrr
1586 
1587 */
1588 
1589 pragma solidity 0.6.12;
1590 
1591 
1592 contract Erc20PiptSwap is EthPiptSwap {
1593   event Erc20ToPiptSwap(
1594     address indexed user,
1595     address indexed swapToken,
1596     uint256 erc20InAmount,
1597     uint256 ethInAmount,
1598     uint256 poolOutAmount
1599   );
1600   event PiptToErc20Swap(
1601     address indexed user,
1602     address indexed swapToken,
1603     uint256 poolInAmount,
1604     uint256 ethOutAmount,
1605     uint256 erc20OutAmount
1606   );
1607 
1608   constructor(
1609     address _weth,
1610     address _cvp,
1611     address _pipt,
1612     address _piptWrapper,
1613     address _feeManager
1614   ) public EthPiptSwap(_weth, _cvp, _pipt, _piptWrapper, _feeManager) {}
1615 
1616   function swapErc20ToPipt(
1617     address _swapToken,
1618     uint256 _swapAmount,
1619     uint256 _slippage
1620   ) external payable returns (uint256 poolAmountOut) {
1621     IERC20(_swapToken).safeTransferFrom(msg.sender, address(this), _swapAmount);
1622 
1623     uint256 ethAmount = _swapTokenForWethOut(_swapToken, _swapAmount);
1624 
1625     address[] memory tokens = getPiptTokens();
1626     uint256 wrapperFee = getWrapFee(tokens);
1627     (, uint256 ethSwapAmount) = calcEthFee(ethAmount, wrapperFee);
1628     (, , poolAmountOut) = calcSwapEthToPiptInputs(ethSwapAmount, tokens, _slippage);
1629 
1630     _swapWethToPiptByPoolOut(ethAmount, poolAmountOut, tokens, wrapperFee);
1631 
1632     emit Erc20ToPiptSwap(msg.sender, _swapToken, _swapAmount, ethAmount, poolAmountOut);
1633   }
1634 
1635   function swapPiptToErc20(address _swapToken, uint256 _poolAmountIn) external payable returns (uint256 erc20Out) {
1636     uint256 ethOut = _swapPiptToWeth(_poolAmountIn);
1637 
1638     erc20Out = _swapWethForTokenOut(_swapToken, ethOut);
1639 
1640     IERC20(_swapToken).safeTransfer(msg.sender, erc20Out);
1641 
1642     emit PiptToErc20Swap(msg.sender, _swapToken, _poolAmountIn, ethOut, erc20Out);
1643   }
1644 
1645   function calcSwapErc20ToPiptInputs(
1646     address _swapToken,
1647     uint256 _swapAmount,
1648     address[] memory _tokens,
1649     uint256 _slippage,
1650     bool _withFee
1651   )
1652     external
1653     view
1654     returns (
1655       uint256[] memory tokensInPipt,
1656       uint256[] memory ethInUniswap,
1657       uint256 poolOut
1658     )
1659   {
1660     uint256 ethAmount = getAmountOutForUniswapValue(_uniswapPairFor(_swapToken), _swapAmount, true);
1661 
1662     if (_withFee) {
1663       (, ethAmount) = calcEthFee(ethAmount, getWrapFee(_tokens));
1664     }
1665     return calcSwapEthToPiptInputs(ethAmount, _tokens, _slippage);
1666   }
1667 
1668   function calcNeedErc20ToPoolOut(
1669     address _swapToken,
1670     uint256 _poolAmountOut,
1671     uint256 _slippage
1672   ) external view returns (uint256) {
1673     uint256 resultEth = calcNeedEthToPoolOut(_poolAmountOut, _slippage);
1674 
1675     IUniswapV2Pair tokenPair = _uniswapPairFor(_swapToken);
1676     (uint256 token1Reserve, uint256 token2Reserve, ) = tokenPair.getReserves();
1677     if (tokenPair.token0() == address(weth)) {
1678       return UniswapV2Library.getAmountIn(resultEth.mul(1003).div(1000), token2Reserve, token1Reserve);
1679     } else {
1680       return UniswapV2Library.getAmountIn(resultEth.mul(1003).div(1000), token1Reserve, token2Reserve);
1681     }
1682   }
1683 
1684   function calcSwapPiptToErc20Inputs(
1685     address _swapToken,
1686     uint256 _poolAmountIn,
1687     address[] memory _tokens,
1688     bool _withFee
1689   )
1690     external
1691     view
1692     returns (
1693       uint256[] memory tokensOutPipt,
1694       uint256[] memory ethOutUniswap,
1695       uint256 totalErc20Out,
1696       uint256 poolAmountFee
1697     )
1698   {
1699     uint256 totalEthOut;
1700 
1701     (tokensOutPipt, ethOutUniswap, totalEthOut, poolAmountFee) = calcSwapPiptToEthInputs(_poolAmountIn, _tokens);
1702     if (_withFee) {
1703       (, totalEthOut) = calcEthFee(totalEthOut, getWrapFee(_tokens));
1704     }
1705     totalErc20Out = getAmountOutForUniswapValue(_uniswapPairFor(_swapToken), totalEthOut, false);
1706   }
1707 
1708   function calcErc20Fee(address _swapToken, uint256 _swapAmount)
1709     external
1710     view
1711     returns (
1712       uint256 erc20Fee,
1713       uint256 erc20AfterFee,
1714       uint256 ethFee,
1715       uint256 ethAfterFee
1716     )
1717   {
1718     IUniswapV2Pair tokenPair = _uniswapPairFor(_swapToken);
1719 
1720     uint256 ethAmount = getAmountOutForUniswapValue(tokenPair, _swapAmount, true);
1721 
1722     (ethFee, ethAfterFee) = calcEthFee(ethAmount, getWrapFee(getPiptTokens()));
1723 
1724     if (ethFee != 0) {
1725       erc20Fee = getAmountOutForUniswapValue(tokenPair, ethFee, false);
1726     }
1727     erc20AfterFee = getAmountOutForUniswapValue(tokenPair, ethAfterFee, false);
1728   }
1729 }