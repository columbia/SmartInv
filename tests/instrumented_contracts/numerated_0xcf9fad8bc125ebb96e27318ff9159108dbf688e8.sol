1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-28
3 */
4 
5 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
86 
87 
88 pragma solidity ^0.8.0;
89 
90 // CAUTION
91 // This version of SafeMath should only be used with Solidity 0.8 or later,
92 // because it relies on the compiler's built in overflow checks.
93 
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations.
96  *
97  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
98  * now has built in overflow checking.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, with an overflow flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         unchecked {
108             uint256 c = a + b;
109             if (c < a) return (false, 0);
110             return (true, c);
111         }
112     }
113 
114     /**
115      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
116      *
117      * _Available since v3.4._
118      */
119     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         unchecked {
121             if (b > a) return (false, 0);
122             return (true, a - b);
123         }
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
128      *
129      * _Available since v3.4._
130      */
131     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
132         unchecked {
133             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
134             // benefit is lost if 'b' is also tested.
135             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
136             if (a == 0) return (true, 0);
137             uint256 c = a * b;
138             if (c / a != b) return (false, 0);
139             return (true, c);
140         }
141     }
142 
143     /**
144      * @dev Returns the division of two unsigned integers, with a division by zero flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         unchecked {
150             if (b == 0) return (false, 0);
151             return (true, a / b);
152         }
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
157      *
158      * _Available since v3.4._
159      */
160     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         unchecked {
162             if (b == 0) return (false, 0);
163             return (true, a % b);
164         }
165     }
166 
167     /**
168      * @dev Returns the addition of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `+` operator.
172      *
173      * Requirements:
174      *
175      * - Addition cannot overflow.
176      */
177     function add(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a + b;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting on
183      * overflow (when the result is negative).
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a - b;
193     }
194 
195     /**
196      * @dev Returns the multiplication of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `*` operator.
200      *
201      * Requirements:
202      *
203      * - Multiplication cannot overflow.
204      */
205     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a * b;
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers, reverting on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator.
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a / b;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * reverting when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a % b;
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
241      * overflow (when the result is negative).
242      *
243      * CAUTION: This function is deprecated because it requires allocating memory for the error
244      * message unnecessarily. For custom revert reasons use {trySub}.
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      *
250      * - Subtraction cannot overflow.
251      */
252     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         unchecked {
254             require(b <= a, errorMessage);
255             return a - b;
256         }
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         unchecked {
277             require(b > 0, errorMessage);
278             return a / b;
279         }
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * reverting with custom message when dividing by zero.
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {tryMod}.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         unchecked {
299             require(b > 0, errorMessage);
300             return a % b;
301         }
302     }
303 }
304 
305 // File: openzeppelin-solidity/contracts/utils/Context.sol
306 
307 
308 pragma solidity ^0.8.0;
309 
310 /*
311  * @dev Provides information about the current execution context, including the
312  * sender of the transaction and its data. While these are generally available
313  * via msg.sender and msg.data, they should not be accessed in such a direct
314  * manner, since when dealing with meta-transactions the account sending and
315  * paying for execution may not be the actual sender (as far as an application
316  * is concerned).
317  *
318  * This contract is only required for intermediate, library-like contracts.
319  */
320 abstract contract Context {
321     function _msgSender() internal view virtual returns (address) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view virtual returns (bytes calldata) {
326         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
327         return msg.data;
328     }
329 }
330 
331 // File: openzeppelin-solidity/contracts/access/Ownable.sol
332 
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Contract module which provides a basic access control mechanism, where
338  * there is an account (an owner) that can be granted exclusive access to
339  * specific functions.
340  *
341  * By default, the owner account will be the one that deploys the contract. This
342  * can later be changed with {transferOwnership}.
343  *
344  * This module is used through inheritance. It will make available the modifier
345  * `onlyOwner`, which can be applied to your functions to restrict their use to
346  * the owner.
347  */
348 abstract contract Ownable is Context {
349     address private _owner;
350 
351     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
352 
353     /**
354      * @dev Initializes the contract setting the deployer as the initial owner.
355      */
356     constructor () {
357         address msgSender = _msgSender();
358         _owner = msgSender;
359         emit OwnershipTransferred(address(0), msgSender);
360     }
361 
362     /**
363      * @dev Returns the address of the current owner.
364      */
365     function owner() public view virtual returns (address) {
366         return _owner;
367     }
368 
369     /**
370      * @dev Throws if called by any account other than the owner.
371      */
372     modifier onlyOwner() {
373         require(owner() == _msgSender(), "Ownable: caller is not the owner");
374         _;
375     }
376 
377     /**
378      * @dev Leaves the contract without owner. It will not be possible to call
379      * `onlyOwner` functions anymore. Can only be called by the current owner.
380      *
381      * NOTE: Renouncing ownership will leave the contract without an owner,
382      * thereby removing any functionality that is only available to the owner.
383      */
384     function renounceOwnership() public virtual onlyOwner {
385         emit OwnershipTransferred(_owner, address(0));
386         _owner = address(0);
387     }
388 
389     /**
390      * @dev Transfers ownership of the contract to a new account (`newOwner`).
391      * Can only be called by the current owner.
392      */
393     function transferOwnership(address newOwner) public virtual onlyOwner {
394         require(newOwner != address(0), "Ownable: new owner is the zero address");
395         emit OwnershipTransferred(_owner, newOwner);
396         _owner = newOwner;
397     }
398 }
399 
400 // File: openzeppelin-solidity/contracts/utils/Address.sol
401 
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @dev Collection of functions related to the address type
407  */
408 library Address {
409     /**
410      * @dev Returns true if `account` is a contract.
411      *
412      * [IMPORTANT]
413      * ====
414      * It is unsafe to assume that an address for which this function returns
415      * false is an externally-owned account (EOA) and not a contract.
416      *
417      * Among others, `isContract` will return false for the following
418      * types of addresses:
419      *
420      *  - an externally-owned account
421      *  - a contract in construction
422      *  - an address where a contract will be created
423      *  - an address where a contract lived, but was destroyed
424      * ====
425      */
426     function isContract(address account) internal view returns (bool) {
427         // This method relies on extcodesize, which returns 0 for contracts in
428         // construction, since the code is only stored at the end of the
429         // constructor execution.
430 
431         uint256 size;
432         // solhint-disable-next-line no-inline-assembly
433         assembly { size := extcodesize(account) }
434         return size > 0;
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
457         (bool success, ) = recipient.call{ value: amount }("");
458         require(success, "Address: unable to send value, recipient may have reverted");
459     }
460 
461     /**
462      * @dev Performs a Solidity function call using a low level `call`. A
463      * plain`call` is an unsafe replacement for a function call: use this
464      * function instead.
465      *
466      * If `target` reverts with a revert reason, it is bubbled up by this
467      * function (like regular Solidity function calls).
468      *
469      * Returns the raw returned data. To convert to the expected return value,
470      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
471      *
472      * Requirements:
473      *
474      * - `target` must be a contract.
475      * - calling `target` with `data` must not revert.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
480       return functionCall(target, data, "Address: low-level call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
485      * `errorMessage` as a fallback revert reason when `target` reverts.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
515         require(address(this).balance >= value, "Address: insufficient balance for call");
516         require(isContract(target), "Address: call to non-contract");
517 
518         // solhint-disable-next-line avoid-low-level-calls
519         (bool success, bytes memory returndata) = target.call{ value: value }(data);
520         return _verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
530         return functionStaticCall(target, data, "Address: low-level static call failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
535      * but performing a static call.
536      *
537      * _Available since v3.3._
538      */
539     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
540         require(isContract(target), "Address: static call to non-contract");
541 
542         // solhint-disable-next-line avoid-low-level-calls
543         (bool success, bytes memory returndata) = target.staticcall(data);
544         return _verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549      * but performing a delegate call.
550      *
551      * _Available since v3.4._
552      */
553     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
554         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
564         require(isContract(target), "Address: delegate call to non-contract");
565 
566         // solhint-disable-next-line avoid-low-level-calls
567         (bool success, bytes memory returndata) = target.delegatecall(data);
568         return _verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
572         if (success) {
573             return returndata;
574         } else {
575             // Look for revert reason and bubble it up if present
576             if (returndata.length > 0) {
577                 // The easiest way to bubble the revert reason is using memory via assembly
578 
579                 // solhint-disable-next-line no-inline-assembly
580                 assembly {
581                     let returndata_size := mload(returndata)
582                     revert(add(32, returndata), returndata_size)
583                 }
584             } else {
585                 revert(errorMessage);
586             }
587         }
588     }
589 }
590 
591 // File: openzeppelin-solidity/contracts/token/ERC20/utils/SafeERC20.sol
592 
593 
594 pragma solidity ^0.8.0;
595 
596 
597 
598 /**
599  * @title SafeERC20
600  * @dev Wrappers around ERC20 operations that throw on failure (when the token
601  * contract returns false). Tokens that return no value (and instead revert or
602  * throw on failure) are also supported, non-reverting calls are assumed to be
603  * successful.
604  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
605  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
606  */
607 library SafeERC20 {
608     using Address for address;
609 
610     function safeTransfer(IERC20 token, address to, uint256 value) internal {
611         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
612     }
613 
614     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
615         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
616     }
617 
618     /**
619      * @dev Deprecated. This function has issues similar to the ones found in
620      * {IERC20-approve}, and its usage is discouraged.
621      *
622      * Whenever possible, use {safeIncreaseAllowance} and
623      * {safeDecreaseAllowance} instead.
624      */
625     function safeApprove(IERC20 token, address spender, uint256 value) internal {
626         // safeApprove should only be called when setting an initial allowance,
627         // or when resetting it to zero. To increase and decrease it, use
628         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
629         // solhint-disable-next-line max-line-length
630         require((value == 0) || (token.allowance(address(this), spender) == 0),
631             "SafeERC20: approve from non-zero to non-zero allowance"
632         );
633         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
634     }
635 
636     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
637         uint256 newAllowance = token.allowance(address(this), spender) + value;
638         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
639     }
640 
641     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
642         unchecked {
643             uint256 oldAllowance = token.allowance(address(this), spender);
644             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
645             uint256 newAllowance = oldAllowance - value;
646             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
647         }
648     }
649 
650     /**
651      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
652      * on the return value: the return value is optional (but if data is returned, it must not be false).
653      * @param token The token targeted by the call.
654      * @param data The call data (encoded using abi.encode or one of its variants).
655      */
656     function _callOptionalReturn(IERC20 token, bytes memory data) private {
657         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
658         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
659         // the target address contains contract code and also asserts for success in the low-level call.
660 
661         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
662         if (returndata.length > 0) { // Return data is optional
663             // solhint-disable-next-line max-line-length
664             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
665         }
666     }
667 }
668 
669 // File: openzeppelin-solidity/contracts/utils/introspection/IERC165.sol
670 
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @dev Interface of the ERC165 standard, as defined in the
676  * https://eips.ethereum.org/EIPS/eip-165[EIP].
677  *
678  * Implementers can declare support of contract interfaces, which can then be
679  * queried by others ({ERC165Checker}).
680  *
681  * For an implementation, see {ERC165}.
682  */
683 interface IERC165 {
684     /**
685      * @dev Returns true if this contract implements the interface defined by
686      * `interfaceId`. See the corresponding
687      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
688      * to learn more about how these ids are created.
689      *
690      * This function call must use less than 30 000 gas.
691      */
692     function supportsInterface(bytes4 interfaceId) external view returns (bool);
693 }
694 
695 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
696 
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @dev Implementation of the {IERC165} interface.
703  *
704  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
705  * for the additional interface id that will be supported. For example:
706  *
707  * ```solidity
708  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
710  * }
711  * ```
712  *
713  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
714  */
715 abstract contract ERC165 is IERC165 {
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
720         return interfaceId == type(IERC165).interfaceId;
721     }
722 }
723 
724 // File: openzeppelin-solidity/contracts/utils/Strings.sol
725 
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @dev String operations.
731  */
732 library Strings {
733     bytes16 private constant alphabet = "0123456789abcdef";
734 
735     /**
736      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
737      */
738     function toString(uint256 value) internal pure returns (string memory) {
739         // Inspired by OraclizeAPI's implementation - MIT licence
740         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
741 
742         if (value == 0) {
743             return "0";
744         }
745         uint256 temp = value;
746         uint256 digits;
747         while (temp != 0) {
748             digits++;
749             temp /= 10;
750         }
751         bytes memory buffer = new bytes(digits);
752         while (value != 0) {
753             digits -= 1;
754             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
755             value /= 10;
756         }
757         return string(buffer);
758     }
759 
760     /**
761      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
762      */
763     function toHexString(uint256 value) internal pure returns (string memory) {
764         if (value == 0) {
765             return "0x00";
766         }
767         uint256 temp = value;
768         uint256 length = 0;
769         while (temp != 0) {
770             length++;
771             temp >>= 8;
772         }
773         return toHexString(value, length);
774     }
775 
776     /**
777      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
778      */
779     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
780         bytes memory buffer = new bytes(2 * length + 2);
781         buffer[0] = "0";
782         buffer[1] = "x";
783         for (uint256 i = 2 * length + 1; i > 1; --i) {
784             buffer[i] = alphabet[value & 0xf];
785             value >>= 4;
786         }
787         require(value == 0, "Strings: hex length insufficient");
788         return string(buffer);
789     }
790 
791 }
792 
793 // File: openzeppelin-solidity/contracts/access/AccessControl.sol
794 
795 
796 pragma solidity ^0.8.0;
797 
798 /**
799  * @dev External interface of AccessControl declared to support ERC165 detection.
800  */
801 interface IAccessControl {
802     function hasRole(bytes32 role, address account) external view returns (bool);
803     function getRoleAdmin(bytes32 role) external view returns (bytes32);
804     function grantRole(bytes32 role, address account) external;
805     function revokeRole(bytes32 role, address account) external;
806     function renounceRole(bytes32 role, address account) external;
807 }
808 
809 /**
810  * @dev Contract module that allows children to implement role-based access
811  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
812  * members except through off-chain means by accessing the contract event logs. Some
813  * applications may benefit from on-chain enumerability, for those cases see
814  * {AccessControlEnumerable}.
815  *
816  * Roles are referred to by their `bytes32` identifier. These should be exposed
817  * in the external API and be unique. The best way to achieve this is by
818  * using `public constant` hash digests:
819  *
820  * ```
821  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
822  * ```
823  *
824  * Roles can be used to represent a set of permissions. To restrict access to a
825  * function call, use {hasRole}:
826  *
827  * ```
828  * function foo() public {
829  *     require(hasRole(MY_ROLE, msg.sender));
830  *     ...
831  * }
832  * ```
833  *
834  * Roles can be granted and revoked dynamically via the {grantRole} and
835  * {revokeRole} functions. Each role has an associated admin role, and only
836  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
837  *
838  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
839  * that only accounts with this role will be able to grant or revoke other
840  * roles. More complex role relationships can be created by using
841  * {_setRoleAdmin}.
842  *
843  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
844  * grant and revoke this role. Extra precautions should be taken to secure
845  * accounts that have been granted it.
846  */
847 abstract contract AccessControl is Context, IAccessControl, ERC165 {
848     struct RoleData {
849         mapping (address => bool) members;
850         bytes32 adminRole;
851     }
852 
853     mapping (bytes32 => RoleData) private _roles;
854 
855     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
856 
857     /**
858      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
859      *
860      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
861      * {RoleAdminChanged} not being emitted signaling this.
862      *
863      * _Available since v3.1._
864      */
865     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
866 
867     /**
868      * @dev Emitted when `account` is granted `role`.
869      *
870      * `sender` is the account that originated the contract call, an admin role
871      * bearer except when using {_setupRole}.
872      */
873     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
874 
875     /**
876      * @dev Emitted when `account` is revoked `role`.
877      *
878      * `sender` is the account that originated the contract call:
879      *   - if using `revokeRole`, it is the admin role bearer
880      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
881      */
882     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
883 
884     /**
885      * @dev Modifier that checks that an account has a specific role. Reverts
886      * with a standardized message including the required role.
887      *
888      * The format of the revert reason is given by the following regular expression:
889      *
890      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
891      *
892      * _Available since v4.1._
893      */
894     modifier onlyRole(bytes32 role) {
895         _checkRole(role, _msgSender());
896         _;
897     }
898 
899     /**
900      * @dev See {IERC165-supportsInterface}.
901      */
902     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
903         return interfaceId == type(IAccessControl).interfaceId
904             || super.supportsInterface(interfaceId);
905     }
906 
907     /**
908      * @dev Returns `true` if `account` has been granted `role`.
909      */
910     function hasRole(bytes32 role, address account) public view override returns (bool) {
911         return _roles[role].members[account];
912     }
913 
914     /**
915      * @dev Revert with a standard message if `account` is missing `role`.
916      *
917      * The format of the revert reason is given by the following regular expression:
918      *
919      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
920      */
921     function _checkRole(bytes32 role, address account) internal view {
922         if(!hasRole(role, account)) {
923             revert(string(abi.encodePacked(
924                 "AccessControl: account ",
925                 Strings.toHexString(uint160(account), 20),
926                 " is missing role ",
927                 Strings.toHexString(uint256(role), 32)
928             )));
929         }
930     }
931 
932     /**
933      * @dev Returns the admin role that controls `role`. See {grantRole} and
934      * {revokeRole}.
935      *
936      * To change a role's admin, use {_setRoleAdmin}.
937      */
938     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
939         return _roles[role].adminRole;
940     }
941 
942     /**
943      * @dev Grants `role` to `account`.
944      *
945      * If `account` had not been already granted `role`, emits a {RoleGranted}
946      * event.
947      *
948      * Requirements:
949      *
950      * - the caller must have ``role``'s admin role.
951      */
952     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
953         _grantRole(role, account);
954     }
955 
956     /**
957      * @dev Revokes `role` from `account`.
958      *
959      * If `account` had been granted `role`, emits a {RoleRevoked} event.
960      *
961      * Requirements:
962      *
963      * - the caller must have ``role``'s admin role.
964      */
965     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
966         _revokeRole(role, account);
967     }
968 
969     /**
970      * @dev Revokes `role` from the calling account.
971      *
972      * Roles are often managed via {grantRole} and {revokeRole}: this function's
973      * purpose is to provide a mechanism for accounts to lose their privileges
974      * if they are compromised (such as when a trusted device is misplaced).
975      *
976      * If the calling account had been granted `role`, emits a {RoleRevoked}
977      * event.
978      *
979      * Requirements:
980      *
981      * - the caller must be `account`.
982      */
983     function renounceRole(bytes32 role, address account) public virtual override {
984         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
985 
986         _revokeRole(role, account);
987     }
988 
989     /**
990      * @dev Grants `role` to `account`.
991      *
992      * If `account` had not been already granted `role`, emits a {RoleGranted}
993      * event. Note that unlike {grantRole}, this function doesn't perform any
994      * checks on the calling account.
995      *
996      * [WARNING]
997      * ====
998      * This function should only be called from the constructor when setting
999      * up the initial roles for the system.
1000      *
1001      * Using this function in any other way is effectively circumventing the admin
1002      * system imposed by {AccessControl}.
1003      * ====
1004      */
1005     function _setupRole(bytes32 role, address account) internal virtual {
1006         _grantRole(role, account);
1007     }
1008 
1009     /**
1010      * @dev Sets `adminRole` as ``role``'s admin role.
1011      *
1012      * Emits a {RoleAdminChanged} event.
1013      */
1014     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1015         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1016         _roles[role].adminRole = adminRole;
1017     }
1018 
1019     function _grantRole(bytes32 role, address account) private {
1020         if (!hasRole(role, account)) {
1021             _roles[role].members[account] = true;
1022             emit RoleGranted(role, account, _msgSender());
1023         }
1024     }
1025 
1026     function _revokeRole(bytes32 role, address account) private {
1027         if (hasRole(role, account)) {
1028             _roles[role].members[account] = false;
1029             emit RoleRevoked(role, account, _msgSender());
1030         }
1031     }
1032 }
1033 
1034 // File: contracts/VestingMultiVault.sol
1035 
1036 pragma solidity ^0.8.0;
1037 
1038 
1039 
1040 
1041 
1042 /**
1043  * @title VestingMultiVault
1044  * @dev A token vesting contract that will release tokens gradually like a
1045  * standard equity vesting schedule, with a cliff and vesting period but no
1046  * arbitrary restrictions on the frequency of claims. Optionally has an initial
1047  * tranche claimable immediately after the cliff expires (in addition to any
1048  * amounts that would have vested up to that point but didn't due to a cliff).
1049  */
1050 contract VestingMultiVault is AccessControl {
1051     using SafeMath for uint256;
1052     using SafeERC20 for IERC20;
1053 
1054     event Issued(
1055         address indexed beneficiary,
1056         uint256 indexed allocationId,
1057         uint256 amount,
1058         uint256 start,
1059         uint256 cliff,
1060         uint256 duration
1061     );
1062 
1063     event Released(
1064         address indexed beneficiary,
1065         uint256 indexed allocationId,
1066         uint256 amount,
1067         uint256 remaining
1068     );
1069     
1070     event Revoked(
1071         address indexed beneficiary,
1072         uint256 indexed allocationId,
1073         uint256 allocationAmount,
1074         uint256 revokedAmount
1075     );
1076 
1077     struct Allocation {
1078         uint256 start;
1079         uint256 cliff;
1080         uint256 duration;
1081         uint256 total;
1082         uint256 claimed;
1083         uint256 initial;
1084     }
1085 
1086     // The token being vested.
1087     IERC20 public immutable token;
1088 
1089     // The amount unclaimed for an address, whether or not vested.
1090     mapping(address => uint256) public pendingAmount;
1091 
1092     // The allocations assigned to an address.
1093     mapping(address => Allocation[]) public userAllocations;
1094 
1095     // The precomputed hash of the "ISSUER" role.
1096     bytes32 public constant ISSUER = keccak256("ISSUER");
1097 
1098     /**
1099      * @dev Creates a vesting contract that releases allocations of a token
1100      * over an arbitrary time period with support for tranches and cliffs.
1101      * @param _token The ERC-20 token to be vested
1102      */
1103     constructor(IERC20 _token) {
1104         token = _token;
1105         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1106         _setupRole(ISSUER, msg.sender);
1107     }
1108 
1109     /**
1110      * @dev Creates a new allocation for a beneficiary. Tokens are released
1111      * linearly over time until a given number of seconds have passed since the
1112      * start of the vesting schedule. Callable only by issuers.
1113      * @param _beneficiary The address to which tokens will be released
1114      * @param _amount The amount of the allocation (in wei)
1115      * @param _startAt The unix timestamp at which the vesting may begin
1116      * @param _cliff The number of seconds after _startAt before which no vesting occurs
1117      * @param _duration The number of seconds after which the entire allocation is vested
1118      * @param _initialPct The percentage of the allocation initially available (integer, 0-100)
1119      */
1120     function issue(
1121         address _beneficiary,
1122         uint256 _amount,
1123         uint256 _startAt,
1124         uint256 _cliff,
1125         uint256 _duration,
1126         uint256 _initialPct
1127     ) public onlyRole(ISSUER) {
1128         require(token.allowance(msg.sender, address(this)) >= _amount, "Token allowance not sufficient");
1129         require(_beneficiary != address(0), "Cannot grant tokens to the zero address");
1130         require(_cliff <= _duration, "Cliff must not exceed duration");
1131         require(_initialPct <= 100, "Initial release percentage must be an integer 0 to 100 (inclusive)");
1132 
1133         // Pull the number of tokens required for the allocation.
1134         token.safeTransferFrom(msg.sender, address(this), _amount);
1135 
1136         // Increase the total pending for the address.
1137         pendingAmount[_beneficiary] = pendingAmount[_beneficiary].add(_amount);
1138 
1139         // Push the new allocation into the stack.
1140         userAllocations[_beneficiary].push(Allocation({
1141             claimed:    0,
1142             cliff:      _cliff,
1143             duration:   _duration,
1144             initial:    _amount.mul(_initialPct).div(100),
1145             start:      _startAt,
1146             total:      _amount
1147         }));
1148         
1149         emit Issued(
1150             _beneficiary,
1151             userAllocations[_beneficiary].length - 1,
1152             _amount,
1153             _startAt,
1154             _cliff,
1155             _duration
1156         );
1157     }
1158     
1159     /**
1160      * @dev Revokes an existing allocation. Any unclaimed tokens are recalled
1161      * and sent to the caller. Callable only be issuers.
1162      * @param _beneficiary The address whose allocation is to be revoked
1163      * @param _id The allocation ID to revoke
1164      */
1165     function revoke(
1166         address _beneficiary,
1167         uint256 _id
1168     ) public onlyRole(ISSUER) {
1169         Allocation storage allocation = userAllocations[_beneficiary][_id];
1170         
1171         // Calculate the remaining amount.
1172         uint256 total = allocation.total;
1173         uint256 remainder = total.sub(allocation.claimed);
1174 
1175         // Update the total pending for the address.
1176         pendingAmount[_beneficiary] = pendingAmount[_beneficiary].sub(remainder);
1177 
1178         // Update the allocation to be claimed in full.
1179         allocation.claimed = total;
1180         
1181         // Transfer the tokens vested 
1182         token.safeTransfer(msg.sender, remainder);
1183         emit Revoked(
1184             _beneficiary,
1185             _id,
1186             total,
1187             remainder
1188         );
1189     }
1190 
1191     /**
1192      * @dev Transfers vested tokens from an allocation to its beneficiary. Callable by anyone.
1193      * @param _beneficiary The address that has vested tokens
1194      * @param _id The vested allocation index
1195      */
1196     function release(
1197         address _beneficiary,
1198         uint256 _id
1199     ) public {
1200         Allocation storage allocation = userAllocations[_beneficiary][_id];
1201 
1202         // Calculate the releasable amount.
1203         uint256 amount = _releasableAmount(allocation);
1204         require(amount > 0, "Nothing to release");
1205         
1206         // Add the amount to the allocation's total claimed.
1207         allocation.claimed = allocation.claimed.add(amount);
1208 
1209         // Subtract the amount from the beneficiary's total pending.
1210         pendingAmount[_beneficiary] = pendingAmount[_beneficiary].sub(amount);
1211 
1212         // Transfer the tokens to the beneficiary.
1213         token.safeTransfer(_beneficiary, amount);
1214 
1215         emit Released(
1216             _beneficiary,
1217             _id,
1218             amount,
1219             allocation.total.sub(allocation.claimed)
1220         );
1221     }
1222     
1223     /**
1224      * @dev Transfers vested tokens from any number of allocations to their beneficiary. Callable by anyone. May be gas-intensive.
1225      * @param _beneficiary The address that has vested tokens
1226      * @param _ids The vested allocation indexes
1227      */
1228     function releaseMultiple(
1229         address _beneficiary,
1230         uint256[] calldata _ids
1231     ) external {
1232         for (uint256 i = 0; i < _ids.length; i++) {
1233             release(_beneficiary, _ids[i]);
1234         }
1235     }
1236     
1237     /**
1238      * @dev Gets the number of allocations issued for a given address.
1239      * @param _beneficiary The address to check for allocations
1240      */
1241     function allocationCount(
1242         address _beneficiary
1243     ) public view returns (uint256 count) {
1244         return userAllocations[_beneficiary].length;
1245     }
1246     
1247     /**
1248      * @dev Calculates the amount that has already vested but has not yet been released for a given address.
1249      * @param _beneficiary Address to check
1250      * @param _id The allocation index
1251      */
1252     function releasableAmount(
1253         address _beneficiary,
1254         uint256 _id
1255     ) public view returns (uint256 amount) {
1256         Allocation storage allocation = userAllocations[_beneficiary][_id];
1257         return _releasableAmount(allocation);
1258     }
1259     
1260     /**
1261      * @dev Gets the total releasable for a given address. Likely gas-intensive, not intended for contract use.
1262      * @param _beneficiary Address to check
1263      */
1264     function totalReleasableAount(
1265         address _beneficiary
1266     ) public view returns (uint256 amount) {
1267         for (uint256 i = 0; i < allocationCount(_beneficiary); i++) {
1268             amount = amount.add(releasableAmount(_beneficiary, i));
1269         }
1270         return amount;
1271     }
1272     
1273     /**
1274      * @dev Calculates the amount that has vested to date.
1275      * @param _beneficiary Address to check
1276      * @param _id The allocation index
1277      */
1278     function vestedAmount(
1279         address _beneficiary,
1280         uint256 _id
1281     ) public view returns (uint256) {
1282         Allocation storage allocation = userAllocations[_beneficiary][_id];
1283         return _vestedAmount(allocation);
1284     }
1285     
1286     /**
1287      * @dev Gets the total ever vested for a given address. Likely gas-intensive, not intended for contract use.
1288      * @param _beneficiary Address to check
1289      */
1290     function totalVestedAount(
1291         address _beneficiary
1292     ) public view returns (uint256 amount) {
1293         for (uint256 i = 0; i < allocationCount(_beneficiary); i++) {
1294             amount = amount.add(vestedAmount(_beneficiary, i));
1295         }
1296         return amount;
1297     }
1298 
1299     /**
1300      * @dev Calculates the amount that has already vested but hasn't been released yet.
1301      * @param allocation Allocation to calculate against
1302      */
1303     function _releasableAmount(
1304         Allocation storage allocation
1305     ) internal view returns (uint256) {
1306         return _vestedAmount(allocation).sub(allocation.claimed);
1307     }
1308 
1309     /**
1310      * @dev Calculates the amount that has already vested.
1311      * @param allocation Allocation to calculate against
1312      */
1313     function _vestedAmount(
1314         Allocation storage allocation
1315     ) internal view returns (uint256 amount) {
1316         if (block.timestamp < allocation.start.add(allocation.cliff)) {
1317             // Nothing is vested until after the start time + cliff length.
1318             amount = 0;
1319         } else if (block.timestamp >= allocation.start.add(allocation.duration)) {
1320             // The entire amount has vested if the entire duration has elapsed.
1321             amount = allocation.total;
1322         } else {
1323             // The initial tranche is available once the cliff expires, plus any portion of
1324             // tokens which have otherwise become vested as of the current block's timestamp.
1325             amount = allocation.initial.add(
1326                 allocation.total
1327                     .sub(allocation.initial)
1328                     .sub(amount)
1329                     .mul(block.timestamp.sub(allocation.start))
1330                     .div(allocation.duration)
1331             );
1332         }
1333         
1334         return amount;
1335     }
1336 }
1337 
1338 // File: contracts/StakeRewarder.sol
1339 
1340 pragma solidity ^0.8.5;
1341 
1342 /**
1343  * @title StakeRewarder
1344  * @dev This contract distributes rewards to depositors of supported tokens.
1345  * It's based on Sushi's MasterChef v1, but notably only serves what's already
1346  * available: no new tokens can be created. It's just a restaurant, not a farm.
1347  */
1348 contract StakeRewarder is Ownable {
1349     using SafeMath for uint256;
1350     using SafeERC20 for IERC20;
1351     
1352     struct UserInfo {
1353         uint256 amount;     // Quantity of tokens the user has staked.
1354         uint256 rewardDebt; // Reward debt. See explanation below.
1355         // We do some fancy math here. Basically, any point in time, the
1356         // amount of rewards entitled to a user but is pending to be distributed is:
1357         //
1358         //   pendingReward = (stakedAmount * pool.accPerShare) - user.rewardDebt
1359         //
1360         // Whenever a user deposits or withdraws tokens in a pool:
1361         //   1. The pool's `accPerShare` (and `lastRewardBlock`) gets updated.
1362         //   2. User's pending rewards are issued (greatly simplifies accounting).
1363         //   3. User's `amount` gets updated.
1364         //   4. User's `rewardDebt` gets updated.
1365     }
1366     
1367     struct PoolInfo {
1368         IERC20 token;            // Address of the token contract.
1369         uint256 weight;          // Weight points assigned to this pool.
1370         uint256 power;           // The multiplier for determining "staking power".
1371         uint256 total;           // Total number of tokens staked.
1372         uint256 accPerShare;     // Accumulated rewards per share (times 1e12).
1373         uint256 lastRewardBlock; // Last block where rewards were calculated.
1374     }
1375     
1376     // Distribution vault.
1377     VestingMultiVault public immutable vault;
1378     
1379     // Reward configuration.
1380     IERC20 public immutable rewardToken;
1381     uint256 public rewardPerBlock;
1382     uint256 public vestingCliff;
1383     uint256 public vestingDuration;
1384     
1385     // Housekeeping for each pool.
1386     PoolInfo[] public poolInfo;
1387     
1388     // Info of each user that stakes tokens.
1389     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1390     
1391     // Underpaid rewards owed to a user.
1392     mapping(address => uint256) public underpayment;
1393     
1394     // The sum of weights across all staking tokens.
1395     uint256 public totalWeight = 0;
1396     
1397     // The block number when staking starts.
1398     uint256 public startBlock;
1399     
1400     event TokenAdded(address indexed token, uint256 weight, uint256 totalWeight);
1401     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1402     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1403     event Claim(address indexed user, uint256 amount);
1404     event EmergencyReclaim(address indexed user, address token, uint256 amount);
1405     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1406 
1407     /**
1408      * @dev Create a staking contract that rewards depositors using its own token balance
1409      * and optionally vests rewards over time.
1410      * @param _rewardToken The token to be distributed as rewards.
1411      * @param _rewardPerBlock The quantity of reward tokens accrued per block.
1412      * @param _startBlock The first block at which staking is allowed.
1413      * @param _vestingCliff The number of seconds until issued rewards begin vesting.
1414      * @param _vestingDuration The number of seconds after issuance until vesting is completed.
1415      * @param _vault The VestingMultiVault that is ultimately responsible for reward distribution.
1416      */
1417     constructor(
1418         IERC20 _rewardToken,
1419         uint256 _rewardPerBlock,
1420         uint256 _startBlock,
1421         uint256 _vestingCliff,
1422         uint256 _vestingDuration,
1423         VestingMultiVault _vault
1424     ) {
1425         // Set the initial reward config
1426         rewardPerBlock = _rewardPerBlock;
1427         startBlock = _startBlock;
1428         vestingCliff = _vestingCliff;
1429         vestingDuration = _vestingDuration;
1430         
1431         // Set the vault and reward token (immutable after creation)
1432         vault = _vault;
1433         rewardToken = _rewardToken;
1434         
1435         // Approve the vault to pull reward tokens
1436         _rewardToken.approve(address(_vault), 2**256 - 1);
1437     }
1438 
1439     /**
1440      * @dev Adds a new staking pool to the stack. Can only be called by the owner.
1441      * @param _token The token to be staked.
1442      * @param _weight The weight of this pool (used to determine proportion of rewards relative to the total weight).
1443      * @param _power The power factor of this pool (used as a multiple of tokens staked, e.g. for determining voting power).
1444      * @param _shouldUpdate Whether to update all pools first.
1445      */
1446     function createPool(
1447         IERC20 _token,
1448         uint256 _weight,
1449         uint256 _power,
1450         bool _shouldUpdate
1451     ) public onlyOwner {
1452         if (_shouldUpdate) {
1453             pokePools();
1454         }
1455 
1456         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1457         totalWeight = totalWeight.add(_weight);
1458         poolInfo.push(
1459             PoolInfo({
1460                 token: _token,
1461                 weight: _weight,
1462                 power: _power,
1463                 total: 0,
1464                 accPerShare: 0,
1465                 lastRewardBlock: lastRewardBlock
1466             })
1467         );
1468     }
1469 
1470     /**
1471      * @dev Update the given staking pool's weight and power. Can only be called by the owner.
1472      * @param _pid The pool identifier.
1473      * @param _weight The weight of this pool (used to determine proportion of rewards relative to the total weight).
1474      * @param _power The power of this pool's token (used as a multiplier of tokens staked, e.g. for voting).
1475      * @param _shouldUpdate Whether to update all pools first.
1476      */ 
1477     function updatePool(
1478         uint256 _pid,
1479         uint256 _weight,
1480         uint256 _power,
1481         bool _shouldUpdate
1482     ) public onlyOwner {
1483         if (_shouldUpdate) {
1484             pokePools();
1485         }
1486         
1487         totalWeight = totalWeight.sub(poolInfo[_pid].weight).add(
1488             _weight
1489         );
1490 
1491         poolInfo[_pid].weight = _weight;
1492         poolInfo[_pid].power = _power;
1493     }
1494     
1495     /**
1496      * @dev Update the reward per block. Can only be called by the owner.
1497      * @param _rewardPerBlock The total quantity to distribute per block.
1498      */
1499     function setRewardPerBlock(
1500         uint256 _rewardPerBlock
1501     ) public onlyOwner {
1502         rewardPerBlock = _rewardPerBlock;
1503     }
1504     
1505     /**
1506      * @dev Update the vesting rules for rewards. Can only be called by the owner.
1507      * @param _duration the number of seconds over which vesting occurs (see VestingMultiVault)
1508      * @param _cliff the number of seconds before any release occurs (see VestingMultiVault)
1509      */
1510     function setVestingRules(
1511         uint256 _duration,
1512         uint256 _cliff
1513     ) public onlyOwner {
1514         vestingDuration = _duration;
1515         vestingCliff = _cliff;
1516     }
1517 
1518     /**
1519      * @dev Calculate elapsed blocks between `_from` and `_to`.
1520      * @param _from The starting block.
1521      * @param _to The ending block.
1522      */
1523     function duration(
1524         uint256 _from,
1525         uint256 _to
1526     ) public pure returns (uint256) {
1527         return _to.sub(_from);
1528     }
1529     
1530     function totalPendingRewards(
1531         address _beneficiary
1532     ) public view returns (uint256 total) {
1533         for (uint256 pid = 0; pid < poolInfo.length; pid++) {
1534             total = total.add(pendingRewards(pid, _beneficiary));
1535         }
1536 
1537         return total;
1538     }
1539 
1540     /**
1541      * @dev View function to see pending rewards for an address. Likely gas intensive.
1542      * @param _pid The pool identifier.
1543      * @param _beneficiary The address to check.
1544      */
1545     function pendingRewards(
1546         uint256 _pid,
1547         address _beneficiary
1548     ) public view returns (uint256 amount) {
1549         PoolInfo storage pool = poolInfo[_pid];
1550         UserInfo storage user = userInfo[_pid][_beneficiary];
1551         uint256 accPerShare = pool.accPerShare;
1552         uint256 tokenSupply = pool.total;
1553         
1554         if (block.number > pool.lastRewardBlock && tokenSupply != 0) {
1555             uint256 reward = duration(pool.lastRewardBlock, block.number)
1556                 .mul(rewardPerBlock)
1557                 .mul(pool.weight)
1558                 .div(totalWeight);
1559 
1560             accPerShare = accPerShare.add(
1561                 reward.mul(1e12).div(tokenSupply)
1562             );
1563         }
1564 
1565         return user.amount.mul(accPerShare).div(1e12).sub(user.rewardDebt);
1566     }
1567 
1568     /**
1569      * @dev Gets the sum of power for every pool. Likely gas intensive.
1570      * @param _beneficiary The address to check.
1571      */
1572     function totalPower(
1573         address _beneficiary
1574     ) public view returns (uint256 total) {
1575         for (uint256 pid = 0; pid < poolInfo.length; pid++) {
1576             total = total.add(power(pid, _beneficiary));
1577         }
1578 
1579         return total;
1580     }
1581 
1582     /**
1583      * @dev Gets power for a single pool.
1584      * @param _pid The pool identifier.
1585      * @param _beneficiary The address to check.
1586      */
1587     function power(
1588         uint256 _pid,
1589         address _beneficiary
1590     ) public view returns (uint256 amount) {
1591         PoolInfo storage pool = poolInfo[_pid];
1592         UserInfo storage user = userInfo[_pid][_beneficiary];
1593         return pool.power.mul(user.amount);
1594     }
1595 
1596     /**
1597      * @dev Update all pools. Callable by anyone. Could be gas intensive.
1598      */
1599     function pokePools() public {
1600         uint256 length = poolInfo.length;
1601         for (uint256 pid = 0; pid < length; ++pid) {
1602             pokePool(pid);
1603         }
1604     }
1605 
1606     /**
1607      * @dev Update rewards of the given pool to be up-to-date. Callable by anyone.
1608      * @param _pid The pool identifier.
1609      */
1610     function pokePool(
1611         uint256 _pid
1612     ) public {
1613         PoolInfo storage pool = poolInfo[_pid];
1614 
1615         if (block.number <= pool.lastRewardBlock) {
1616             return;
1617         }
1618 
1619         uint256 tokenSupply = pool.total;
1620         if (tokenSupply == 0) {
1621             pool.lastRewardBlock = block.number;
1622             return;
1623         }
1624 
1625         uint256 reward = duration(pool.lastRewardBlock, block.number)
1626             .mul(rewardPerBlock)
1627             .mul(pool.weight)
1628             .div(totalWeight);
1629 
1630         pool.accPerShare = pool.accPerShare.add(
1631             reward.mul(1e12).div(tokenSupply)
1632         );
1633 
1634         pool.lastRewardBlock = block.number;
1635     }
1636 
1637     /**
1638      * @dev Claim rewards not yet distributed for an address. Callable by anyone.
1639      * @param _pid The pool identifier.
1640      * @param _beneficiary The address to claim for.
1641      */
1642     function claim(
1643         uint256 _pid,
1644         address _beneficiary
1645     ) public {
1646         // make sure the pool is up-to-date
1647         pokePool(_pid);
1648 
1649         PoolInfo storage pool = poolInfo[_pid];
1650         UserInfo storage user = userInfo[_pid][_beneficiary];
1651 
1652         _claim(pool, user, _beneficiary);
1653     }
1654     
1655     /**
1656      * @dev Claim rewards from multiple pools. Callable by anyone.
1657      * @param _pids An array of pool identifiers.
1658      * @param _beneficiary The address to claim for.
1659      */
1660     function claimMultiple(
1661         uint256[] calldata _pids,
1662         address _beneficiary
1663     ) external {
1664         for (uint256 i = 0; i < _pids.length; i++) {
1665             claim(_pids[i], _beneficiary);
1666         }
1667     }
1668 
1669     /**
1670      * @dev Stake tokens to earn a share of rewards.
1671      * @param _pid The pool identifier.
1672      * @param _amount The number of tokens to deposit.
1673      */
1674     function deposit(
1675         uint256 _pid,
1676         uint256 _amount
1677     ) public {
1678         require(_amount > 0, "deposit: only non-zero amounts allowed");
1679         
1680         // make sure the pool is up-to-date
1681         pokePool(_pid);
1682 
1683         PoolInfo storage pool = poolInfo[_pid];
1684         UserInfo storage user = userInfo[_pid][msg.sender];
1685         
1686         // deliver any pending rewards
1687         _claim(pool, user, msg.sender);
1688         
1689         // pull in user's staked assets
1690         pool.token.safeTransferFrom(
1691             address(msg.sender),
1692             address(this),
1693             _amount
1694         );
1695 
1696         // update the pool's total deposit
1697         pool.total = pool.total.add(_amount);
1698         
1699         // update user's deposit and reward info
1700         user.amount = user.amount.add(_amount);
1701         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
1702         
1703         emit Deposit(msg.sender, _pid, _amount);
1704     }
1705 
1706     /**
1707      * @dev Withdraw staked tokens and any pending rewards.
1708      */
1709     function withdraw(
1710         uint256 _pid,
1711         uint256 _amount
1712     ) public {
1713         require(_amount > 0, "withdraw: only non-zero amounts allowed");
1714 
1715         // make sure the pool is up-to-date
1716         pokePool(_pid);
1717         
1718         PoolInfo storage pool = poolInfo[_pid];
1719         UserInfo storage user = userInfo[_pid][msg.sender];
1720         
1721         require(user.amount >= _amount, "withdraw: amount too large");
1722         
1723         // deliver any pending rewards
1724         _claim(pool, user, msg.sender);
1725 
1726         // update the pool's total deposit
1727         pool.total = pool.total.sub(_amount);
1728         
1729         // update the user's deposit and reward info
1730         user.amount = user.amount.sub(_amount);
1731         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
1732         
1733         // send back the staked assets
1734         pool.token.safeTransfer(address(msg.sender), _amount);
1735         
1736         emit Withdraw(msg.sender, _pid, _amount);
1737     }
1738 
1739     /**
1740      * @dev Withdraw staked tokens and forego any unclaimed rewards. This is a fail-safe.
1741      */
1742     function emergencyWithdraw(
1743         uint256 _pid
1744     ) public {
1745         PoolInfo storage pool = poolInfo[_pid];
1746         UserInfo storage user = userInfo[_pid][msg.sender];
1747         uint256 amount = user.amount;
1748         
1749         // reset everything to zero
1750         user.amount = 0;
1751         user.rewardDebt = 0;
1752         underpayment[msg.sender] = 0;
1753 
1754         // update the pool's total deposit
1755         pool.total = pool.total.sub(amount);
1756         
1757         // send back the staked assets
1758         pool.token.safeTransfer(address(msg.sender), amount);
1759         emit EmergencyWithdraw(msg.sender, _pid, amount);
1760     }
1761     
1762     /**
1763      * @dev Reclaim stuck tokens (e.g. unexpected external rewards). This is a fail-safe.
1764      */
1765     function emergencyReclaim(
1766         IERC20 _token,
1767         uint256 _amount
1768     ) public onlyOwner {
1769         if (_amount == 0) {
1770             _amount = _token.balanceOf(address(this));
1771         }
1772         
1773         _token.transfer(msg.sender, _amount);
1774         emit EmergencyReclaim(msg.sender, address(_token), _amount);
1775     }
1776     
1777     /**
1778      * @dev Gets the length of the pools array.
1779      */
1780     function poolLength() external view returns (uint256 length) {
1781         return poolInfo.length;
1782     }
1783     
1784     /**
1785      * @dev Claim rewards not yet distributed for an address.
1786      * @param pool The staking pool issuing rewards.
1787      * @param user The staker who earned them.
1788      * @param to The address to pay. 
1789      */
1790     function _claim(
1791         PoolInfo storage pool,
1792         UserInfo storage user,
1793         address to
1794     ) internal {
1795         if (user.amount > 0) {
1796             // calculate the pending reward
1797             uint256 pending = user.amount
1798                 .mul(pool.accPerShare)
1799                 .div(1e12)
1800                 .sub(user.rewardDebt)
1801                 .add(underpayment[to]);
1802             
1803             // send the rewards out
1804             uint256 payout = _safelyDistribute(to, pending);
1805             if (payout < pending) {
1806                 underpayment[to] = pending.sub(payout);
1807             } else {
1808                 underpayment[to] = 0;
1809             }
1810             
1811             emit Claim(to, payout);
1812         }
1813     }
1814     
1815     /**
1816      * @dev Safely distribute at most the amount of tokens in holding.
1817      */
1818     function _safelyDistribute(
1819         address _to,
1820         uint256 _amount
1821     ) internal returns (uint256 amount) {
1822         uint256 available = rewardToken.balanceOf(address(this));
1823         amount = _amount > available ? available : _amount;
1824         
1825         vault.issue(
1826             _to,                // address _beneficiary,
1827             _amount,            // uint256 _amount,
1828             block.timestamp,    // uint256 _startAt,
1829             vestingCliff,       // uint256 _cliff,
1830             vestingDuration,    // uint256 _duration,
1831             0                   // uint256 _initialPct
1832         );
1833         
1834         return amount;
1835     }
1836 }