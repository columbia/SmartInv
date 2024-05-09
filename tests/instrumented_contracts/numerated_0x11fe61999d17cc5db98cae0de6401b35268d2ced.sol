1 // File: Staking_flat.sol
2 
3 
4 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
5 
6 // 
7 
8 pragma solidity ^0.8.0;
9 
10 // CAUTION
11 // This version of SafeMath should only be used with Solidity 0.8 or later,
12 // because it relies on the compiler's built in overflow checks.
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations.
16  *
17  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
18  * now has built in overflow checking.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a % b);
84         }
85     }
86 
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a + b;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a * b;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator.
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * reverting when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         unchecked {
174             require(b <= a, errorMessage);
175             return a - b;
176         }
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         unchecked {
197             require(b > 0, errorMessage);
198             return a / b;
199         }
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * reverting with custom message when dividing by zero.
205      *
206      * CAUTION: This function is deprecated because it requires allocating memory for the error
207      * message unnecessarily. For custom revert reasons use {tryMod}.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         unchecked {
219             require(b > 0, errorMessage);
220             return a % b;
221         }
222     }
223 }
224 
225 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
226 
227 // 
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Collection of functions related to the address type
233  */
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * [IMPORTANT]
239      * ====
240      * It is unsafe to assume that an address for which this function returns
241      * false is an externally-owned account (EOA) and not a contract.
242      *
243      * Among others, `isContract` will return false for the following
244      * types of addresses:
245      *
246      *  - an externally-owned account
247      *  - a contract in construction
248      *  - an address where a contract will be created
249      *  - an address where a contract lived, but was destroyed
250      * ====
251      */
252     function isContract(address account) internal view returns (bool) {
253         // This method relies on extcodesize, which returns 0 for contracts in
254         // construction, since the code is only stored at the end of the
255         // constructor execution.
256 
257         uint256 size;
258         // solhint-disable-next-line no-inline-assembly
259         assembly { size := extcodesize(account) }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
283         (bool success, ) = recipient.call{ value: amount }("");
284         require(success, "Address: unable to send value, recipient may have reverted");
285     }
286 
287     /**
288      * @dev Performs a Solidity function call using a low level `call`. A
289      * plain`call` is an unsafe replacement for a function call: use this
290      * function instead.
291      *
292      * If `target` reverts with a revert reason, it is bubbled up by this
293      * function (like regular Solidity function calls).
294      *
295      * Returns the raw returned data. To convert to the expected return value,
296      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
297      *
298      * Requirements:
299      *
300      * - `target` must be a contract.
301      * - calling `target` with `data` must not revert.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
306       return functionCall(target, data, "Address: low-level call failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
311      * `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, 0, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but also transferring `value` wei to `target`.
322      *
323      * Requirements:
324      *
325      * - the calling contract must have an ETH balance of at least `value`.
326      * - the called Solidity function must be `payable`.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336      * with `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
341         require(address(this).balance >= value, "Address: insufficient balance for call");
342         require(isContract(target), "Address: call to non-contract");
343 
344         // solhint-disable-next-line avoid-low-level-calls
345         (bool success, bytes memory returndata) = target.call{ value: value }(data);
346         return _verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
356         return functionStaticCall(target, data, "Address: low-level static call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
366         require(isContract(target), "Address: static call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = target.staticcall(data);
370         return _verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
380         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a delegate call.
386      *
387      * _Available since v3.4._
388      */
389     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
390         require(isContract(target), "Address: delegate call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return _verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol
418 
419 // 
420 
421 pragma solidity ^0.8.0;
422 
423 
424 
425 /**
426  * @title SafeERC20
427  * @dev Wrappers around ERC20 operations that throw on failure (when the token
428  * contract returns false). Tokens that return no value (and instead revert or
429  * throw on failure) are also supported, non-reverting calls are assumed to be
430  * successful.
431  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
432  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
433  */
434 library SafeERC20 {
435     using Address for address;
436 
437     function safeTransfer(IERC20 token, address to, uint256 value) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
439     }
440 
441     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
442         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
443     }
444 
445     /**
446      * @dev Deprecated. This function has issues similar to the ones found in
447      * {IERC20-approve}, and its usage is discouraged.
448      *
449      * Whenever possible, use {safeIncreaseAllowance} and
450      * {safeDecreaseAllowance} instead.
451      */
452     function safeApprove(IERC20 token, address spender, uint256 value) internal {
453         // safeApprove should only be called when setting an initial allowance,
454         // or when resetting it to zero. To increase and decrease it, use
455         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
456         // solhint-disable-next-line max-line-length
457         require((value == 0) || (token.allowance(address(this), spender) == 0),
458             "SafeERC20: approve from non-zero to non-zero allowance"
459         );
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
461     }
462 
463     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
464         uint256 newAllowance = token.allowance(address(this), spender) + value;
465         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
466     }
467 
468     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
469         unchecked {
470             uint256 oldAllowance = token.allowance(address(this), spender);
471             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
472             uint256 newAllowance = oldAllowance - value;
473             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
474         }
475     }
476 
477     /**
478      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
479      * on the return value: the return value is optional (but if data is returned, it must not be false).
480      * @param token The token targeted by the call.
481      * @param data The call data (encoded using abi.encode or one of its variants).
482      */
483     function _callOptionalReturn(IERC20 token, bytes memory data) private {
484         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
485         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
486         // the target address contains contract code and also asserts for success in the low-level call.
487 
488         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
489         if (returndata.length > 0) { // Return data is optional
490             // solhint-disable-next-line max-line-length
491             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
492         }
493     }
494 }
495 
496 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
497 
498 // 
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Interface of the ERC20 standard as defined in the EIP.
504  */
505 interface IERC20 {
506     /**
507      * @dev Returns the amount of tokens in existence.
508      */
509     function totalSupply() external view returns (uint256);
510 
511     /**
512      * @dev Returns the amount of tokens owned by `account`.
513      */
514     function balanceOf(address account) external view returns (uint256);
515 
516     /**
517      * @dev Moves `amount` tokens from the caller's account to `recipient`.
518      *
519      * Returns a boolean value indicating whether the operation succeeded.
520      *
521      * Emits a {Transfer} event.
522      */
523     function transfer(address recipient, uint256 amount) external returns (bool);
524 
525     /**
526      * @dev Returns the remaining number of tokens that `spender` will be
527      * allowed to spend on behalf of `owner` through {transferFrom}. This is
528      * zero by default.
529      *
530      * This value changes when {approve} or {transferFrom} are called.
531      */
532     function allowance(address owner, address spender) external view returns (uint256);
533 
534     /**
535      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
536      *
537      * Returns a boolean value indicating whether the operation succeeded.
538      *
539      * IMPORTANT: Beware that changing an allowance with this method brings the risk
540      * that someone may use both the old and the new allowance by unfortunate
541      * transaction ordering. One possible solution to mitigate this race
542      * condition is to first reduce the spender's allowance to 0 and set the
543      * desired value afterwards:
544      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
545      *
546      * Emits an {Approval} event.
547      */
548     function approve(address spender, uint256 amount) external returns (bool);
549 
550     /**
551      * @dev Moves `amount` tokens from `sender` to `recipient` using the
552      * allowance mechanism. `amount` is then deducted from the caller's
553      * allowance.
554      *
555      * Returns a boolean value indicating whether the operation succeeded.
556      *
557      * Emits a {Transfer} event.
558      */
559     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
560 
561     /**
562      * @dev Emitted when `value` tokens are moved from one account (`from`) to
563      * another (`to`).
564      *
565      * Note that `value` may be zero.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 value);
568 
569     /**
570      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
571      * a call to {approve}. `value` is the new allowance.
572      */
573     event Approval(address indexed owner, address indexed spender, uint256 value);
574 }
575 
576 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
577 
578 // 
579 
580 pragma solidity ^0.8.0;
581 
582 /**
583  * @dev Interface of the ERC165 standard, as defined in the
584  * https://eips.ethereum.org/EIPS/eip-165[EIP].
585  *
586  * Implementers can declare support of contract interfaces, which can then be
587  * queried by others ({ERC165Checker}).
588  *
589  * For an implementation, see {ERC165}.
590  */
591 interface IERC165 {
592     /**
593      * @dev Returns true if this contract implements the interface defined by
594      * `interfaceId`. See the corresponding
595      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
596      * to learn more about how these ids are created.
597      *
598      * This function call must use less than 30 000 gas.
599      */
600     function supportsInterface(bytes4 interfaceId) external view returns (bool);
601 }
602 
603 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
604 
605 // 
606 
607 pragma solidity ^0.8.0;
608 
609 
610 /**
611  * @dev Implementation of the {IERC165} interface.
612  *
613  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
614  * for the additional interface id that will be supported. For example:
615  *
616  * ```solidity
617  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
618  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
619  * }
620  * ```
621  *
622  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
623  */
624 abstract contract ERC165 is IERC165 {
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629         return interfaceId == type(IERC165).interfaceId;
630     }
631 }
632 
633 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
634 
635 // 
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @dev String operations.
641  */
642 library Strings {
643     bytes16 private constant alphabet = "0123456789abcdef";
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
647      */
648     function toString(uint256 value) internal pure returns (string memory) {
649         // Inspired by OraclizeAPI's implementation - MIT licence
650         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
651 
652         if (value == 0) {
653             return "0";
654         }
655         uint256 temp = value;
656         uint256 digits;
657         while (temp != 0) {
658             digits++;
659             temp /= 10;
660         }
661         bytes memory buffer = new bytes(digits);
662         while (value != 0) {
663             digits -= 1;
664             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
665             value /= 10;
666         }
667         return string(buffer);
668     }
669 
670     /**
671      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
672      */
673     function toHexString(uint256 value) internal pure returns (string memory) {
674         if (value == 0) {
675             return "0x00";
676         }
677         uint256 temp = value;
678         uint256 length = 0;
679         while (temp != 0) {
680             length++;
681             temp >>= 8;
682         }
683         return toHexString(value, length);
684     }
685 
686     /**
687      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
688      */
689     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
690         bytes memory buffer = new bytes(2 * length + 2);
691         buffer[0] = "0";
692         buffer[1] = "x";
693         for (uint256 i = 2 * length + 1; i > 1; --i) {
694             buffer[i] = alphabet[value & 0xf];
695             value >>= 4;
696         }
697         require(value == 0, "Strings: hex length insufficient");
698         return string(buffer);
699     }
700 
701 }
702 
703 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
704 
705 // 
706 
707 pragma solidity ^0.8.0;
708 
709 /*
710  * @dev Provides information about the current execution context, including the
711  * sender of the transaction and its data. While these are generally available
712  * via msg.sender and msg.data, they should not be accessed in such a direct
713  * manner, since when dealing with meta-transactions the account sending and
714  * paying for execution may not be the actual sender (as far as an application
715  * is concerned).
716  *
717  * This contract is only required for intermediate, library-like contracts.
718  */
719 abstract contract Context {
720     function _msgSender() internal view virtual returns (address) {
721         return msg.sender;
722     }
723 
724     function _msgData() internal view virtual returns (bytes calldata) {
725         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
726         return msg.data;
727     }
728 }
729 
730 
731 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol
732 
733 // 
734 
735 pragma solidity ^0.8.0;
736 
737 
738 
739 
740 /**
741  * @dev External interface of AccessControl declared to support ERC165 detection.
742  */
743 interface IAccessControl {
744     function hasRole(bytes32 role, address account) external view returns (bool);
745     function getRoleAdmin(bytes32 role) external view returns (bytes32);
746     function grantRole(bytes32 role, address account) external;
747     function revokeRole(bytes32 role, address account) external;
748     function renounceRole(bytes32 role, address account) external;
749 }
750 
751 /**
752  * @dev Contract module that allows children to implement role-based access
753  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
754  * members except through off-chain means by accessing the contract event logs. Some
755  * applications may benefit from on-chain enumerability, for those cases see
756  * {AccessControlEnumerable}.
757  *
758  * Roles are referred to by their `bytes32` identifier. These should be exposed
759  * in the external API and be unique. The best way to achieve this is by
760  * using `public constant` hash digests:
761  *
762  * ```
763  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
764  * ```
765  *
766  * Roles can be used to represent a set of permissions. To restrict access to a
767  * function call, use {hasRole}:
768  *
769  * ```
770  * function foo() public {
771  *     require(hasRole(MY_ROLE, msg.sender));
772  *     ...
773  * }
774  * ```
775  *
776  * Roles can be granted and revoked dynamically via the {grantRole} and
777  * {revokeRole} functions. Each role has an associated admin role, and only
778  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
779  *
780  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
781  * that only accounts with this role will be able to grant or revoke other
782  * roles. More complex role relationships can be created by using
783  * {_setRoleAdmin}.
784  *
785  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
786  * grant and revoke this role. Extra precautions should be taken to secure
787  * accounts that have been granted it.
788  */
789 abstract contract AccessControl is Context, IAccessControl, ERC165 {
790     struct RoleData {
791         mapping (address => bool) members;
792         bytes32 adminRole;
793     }
794 
795     mapping (bytes32 => RoleData) private _roles;
796 
797     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
798 
799     /**
800      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
801      *
802      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
803      * {RoleAdminChanged} not being emitted signaling this.
804      *
805      * _Available since v3.1._
806      */
807     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
808 
809     /**
810      * @dev Emitted when `account` is granted `role`.
811      *
812      * `sender` is the account that originated the contract call, an admin role
813      * bearer except when using {_setupRole}.
814      */
815     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
816 
817     /**
818      * @dev Emitted when `account` is revoked `role`.
819      *
820      * `sender` is the account that originated the contract call:
821      *   - if using `revokeRole`, it is the admin role bearer
822      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
823      */
824     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
825 
826     /**
827      * @dev Modifier that checks that an account has a specific role. Reverts
828      * with a standardized message including the required role.
829      *
830      * The format of the revert reason is given by the following regular expression:
831      *
832      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
833      *
834      * _Available since v4.1._
835      */
836     modifier onlyRole(bytes32 role) {
837         _checkRole(role, _msgSender());
838         _;
839     }
840 
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
845         return interfaceId == type(IAccessControl).interfaceId
846             || super.supportsInterface(interfaceId);
847     }
848 
849     /**
850      * @dev Returns `true` if `account` has been granted `role`.
851      */
852     function hasRole(bytes32 role, address account) public view override returns (bool) {
853         return _roles[role].members[account];
854     }
855 
856     /**
857      * @dev Revert with a standard message if `account` is missing `role`.
858      *
859      * The format of the revert reason is given by the following regular expression:
860      *
861      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
862      */
863     function _checkRole(bytes32 role, address account) internal view {
864         if(!hasRole(role, account)) {
865             revert(string(abi.encodePacked(
866                 "AccessControl: account ",
867                 Strings.toHexString(uint160(account), 20),
868                 " is missing role ",
869                 Strings.toHexString(uint256(role), 32)
870             )));
871         }
872     }
873 
874     /**
875      * @dev Returns the admin role that controls `role`. See {grantRole} and
876      * {revokeRole}.
877      *
878      * To change a role's admin, use {_setRoleAdmin}.
879      */
880     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
881         return _roles[role].adminRole;
882     }
883 
884     /**
885      * @dev Grants `role` to `account`.
886      *
887      * If `account` had not been already granted `role`, emits a {RoleGranted}
888      * event.
889      *
890      * Requirements:
891      *
892      * - the caller must have ``role``'s admin role.
893      */
894     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
895         _grantRole(role, account);
896     }
897 
898     /**
899      * @dev Revokes `role` from `account`.
900      *
901      * If `account` had been granted `role`, emits a {RoleRevoked} event.
902      *
903      * Requirements:
904      *
905      * - the caller must have ``role``'s admin role.
906      */
907     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
908         _revokeRole(role, account);
909     }
910 
911     /**
912      * @dev Revokes `role` from the calling account.
913      *
914      * Roles are often managed via {grantRole} and {revokeRole}: this function's
915      * purpose is to provide a mechanism for accounts to lose their privileges
916      * if they are compromised (such as when a trusted device is misplaced).
917      *
918      * If the calling account had been granted `role`, emits a {RoleRevoked}
919      * event.
920      *
921      * Requirements:
922      *
923      * - the caller must be `account`.
924      */
925     function renounceRole(bytes32 role, address account) public virtual override {
926         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
927 
928         _revokeRole(role, account);
929     }
930 
931     /**
932      * @dev Grants `role` to `account`.
933      *
934      * If `account` had not been already granted `role`, emits a {RoleGranted}
935      * event. Note that unlike {grantRole}, this function doesn't perform any
936      * checks on the calling account.
937      *
938      * [WARNING]
939      * ====
940      * This function should only be called from the constructor when setting
941      * up the initial roles for the system.
942      *
943      * Using this function in any other way is effectively circumventing the admin
944      * system imposed by {AccessControl}.
945      * ====
946      */
947     function _setupRole(bytes32 role, address account) internal virtual {
948         _grantRole(role, account);
949     }
950 
951     /**
952      * @dev Sets `adminRole` as ``role``'s admin role.
953      *
954      * Emits a {RoleAdminChanged} event.
955      */
956     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
957         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
958         _roles[role].adminRole = adminRole;
959     }
960 
961     function _grantRole(bytes32 role, address account) private {
962         if (!hasRole(role, account)) {
963             _roles[role].members[account] = true;
964             emit RoleGranted(role, account, _msgSender());
965         }
966     }
967 
968     function _revokeRole(bytes32 role, address account) private {
969         if (hasRole(role, account)) {
970             _roles[role].members[account] = false;
971             emit RoleRevoked(role, account, _msgSender());
972         }
973     }
974 }
975 
976 // File: contracts/TokenInterface.sol
977 
978 
979 pragma solidity ^0.8.0;
980 
981 interface TokenInterface{
982     function burnFrom(address _from, uint _amount) external;
983     function mintTo(address _to, uint _amount) external;
984 }
985 // File: contracts/Staking.sol
986 
987 // SPDX-License-Identifier: GPL-3.0
988 
989 // Author: Matt Hooft 
990 // https://github.com/Civitas-Fundamenta
991 // mhooft@fundamenta.network
992 
993 // A simple token Staking Contract that uses a configurable `stakeCap` to limit inflation.
994 // Employs the use of Role Based Access Control (RBAC) so allow outside accounts and contracts
995 // to interact with it securely allowing for future extensibility.
996 
997 pragma solidity ^0.8.0;
998 
999 
1000 
1001 
1002 
1003 
1004 contract Staking is AccessControl {
1005 
1006     using SafeMath for uint256;
1007     using SafeERC20 for IERC20;
1008     
1009     TokenInterface private fundamenta;  
1010     
1011     /**
1012      * Smart Contract uses Role Based Access Control to 
1013      * 
1014      * alllow for secure access as well as enabling the ability 
1015      *
1016      * for other contracts such as oracles to interact with ifundamenta.
1017      */
1018 
1019     //-------RBAC---------------------------
1020 
1021     bytes32 public constant _STAKING = keccak256("_STAKING");
1022     bytes32 public constant _RESCUE = keccak256("_RESCUE");
1023     bytes32 public constant _ADMIN = keccak256("_ADMIN");
1024 
1025     //-------Staking Vars-------------------
1026     
1027     uint public stakeCalc;
1028     uint public stakeCap;
1029     uint public rewardsWindow;
1030     uint public stakeLockMultiplier;
1031     bool public stakingOff;
1032     bool public paused;
1033     bool public emergencyWDoff;
1034     address private defaultAdmin = 0x82Ab0c69b6548e6Fd61365FeCc3256BcF70dc448;
1035     
1036     //--------Staking mapping/Arrays----------
1037 
1038     address[] internal stakeholders;
1039     mapping(address => uint) internal stakes;
1040     mapping(address => uint) internal rewards;
1041     mapping(address => uint) internal lastWithdraw;
1042     
1043     //----------Events----------------------
1044     
1045     event StakeCreated(address _stakeholder, uint _stakes, uint _blockHeight);
1046     event rewardsCompunded(address _stakeholder, uint _rewardsAdded, uint _blockHeight);
1047     event StakeRemoved(address _stakeholder, uint _stakes, uint rewards, uint _blockHeight);
1048     event RewardsWithdrawn(address _stakeholder, uint _rewards, uint blockHeight);
1049     event TokensRescued (address _pebcak, address _ERC20, uint _ERC20Amount, uint _blockHeightRescued);
1050     event ETHRescued (address _pebcak, uint _ETHAmount, uint _blockHeightRescued);
1051 
1052     //-------Constructor----------------------
1053 
1054     constructor(){
1055         stakingOff = true;
1056         emergencyWDoff = true;
1057         stakeCalc = 500;
1058         stakeCap = 3e22;
1059         rewardsWindow = 6500;
1060         stakeLockMultiplier = 2;
1061         _setupRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
1062     }
1063 
1064     //-------Set Token Address----------------
1065     
1066     function setAddress(TokenInterface _token) public {
1067         require(hasRole(_ADMIN, msg.sender));
1068         fundamenta = _token;
1069     }
1070     
1071     //-------Modifiers--------------------------
1072 
1073     modifier pause() {
1074         require(!paused, "TokenStaking: Contract is Paused");
1075         _;
1076     }
1077 
1078     modifier stakeToggle() {
1079         require(!stakingOff, "TokenStaking: Staking is not currently active");
1080         _;
1081     }
1082     
1083     modifier emergency() {
1084         require(!emergencyWDoff, "TokenStaking: Emergency Withdraw is not enabled");
1085         _;
1086     }
1087 
1088     //--------Staking Functions-------------------
1089 
1090     /**
1091      * allows a user to create a staking positon. Users will
1092      * 
1093      * not be allowed to stake more than the `stakeCap` which is 
1094      *
1095      * a settable variable by Admins/Contrcats with the `_STAKING` 
1096      * 
1097      * Role.
1098      */
1099 
1100     function createStake(uint _stake) public pause stakeToggle {
1101         require(rewardsAccrued() == 0);
1102         rewards[msg.sender] = rewards[msg.sender].add(rewardsAccrued());
1103         if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
1104         stakes[msg.sender] = stakes[msg.sender].add(_stake);
1105         fundamenta.burnFrom(msg.sender, _stake);
1106         require(stakes[msg.sender] <= stakeCap, "TokenStaking: Can't Stake More than allowed moneybags"); 
1107         lastWithdraw[msg.sender] = block.number;
1108         emit StakeCreated(msg.sender, _stake, block.number);
1109     }
1110     
1111     /**
1112      * removes a users staked positon if the required lock
1113      * 
1114      * window is satisfied. Also pays out any `_rewardsAccrued` to
1115      *
1116      * the user if any rewards are pending.
1117      */
1118     
1119     function removeStake(uint _stake) public pause {
1120         uint unlockWindow = rewardsWindow.mul(stakeLockMultiplier);
1121         require(block.number >= lastWithdraw[msg.sender].add(unlockWindow), "TokenStaking: FMTA has not been staked for long enough");
1122         rewards[msg.sender] = rewards[msg.sender].add(rewardsAccrued());
1123         uint totalAccrued;
1124         if(stakes[msg.sender] == 0 && _stake != 0 ) {
1125             revert("TokenStaking: You don't have any tokens staked");
1126         }else if (stakes[msg.sender] != 0 && _stake != 0) {
1127             totalAccrued = rewardsAccrued().add(_stake);
1128             fundamenta.mintTo(msg.sender, totalAccrued);
1129             stakes[msg.sender] = stakes[msg.sender].sub(_stake);
1130             lastWithdraw[msg.sender] = block.number;
1131         }
1132         
1133         if (stakes[msg.sender] == 0) {
1134             removeStakeholder(msg.sender);
1135         }
1136         emit StakeRemoved(msg.sender, _stake, totalAccrued, block.number);
1137     }
1138     
1139     /**
1140      * returns the amount of rewards a user as accrued.
1141      */
1142     
1143     function rewardsAccrued() public view returns (uint) {
1144         uint multiplier = block.number.sub(lastWithdraw[msg.sender]).div(rewardsWindow);
1145         uint _rewardsAccrued = calculateReward(msg.sender).mul(multiplier);
1146         return _rewardsAccrued;
1147         
1148     }
1149     
1150     /**
1151      * @dev allows user to withrdraw any pending rewards as
1152      * 
1153      * long as the `rewardsWindow` is satisfied.
1154      */
1155      
1156     function withdrawReward() public pause stakeToggle {
1157         rewards[msg.sender] = rewards[msg.sender].add(rewardsAccrued());
1158         if(lastWithdraw[msg.sender] == 0) {
1159            revert("TokenStaking: You cannot withdraw if you hve never staked");
1160         } else if (lastWithdraw[msg.sender] != 0){
1161             require(block.number > lastWithdraw[msg.sender].add(rewardsWindow), "TokenStaking: It hasn't been enough time since your last withdrawl");
1162             fundamenta.mintTo(msg.sender, rewardsAccrued());
1163             lastWithdraw[msg.sender] = block.number;
1164             emit RewardsWithdrawn(msg.sender, rewardsAccrued(), block.number);
1165         }
1166     }
1167     
1168     
1169     function compoundRewards() public pause stakeToggle {
1170         rewards[msg.sender] = rewards[msg.sender].add(rewardsAccrued());
1171         if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
1172         stakes[msg.sender] = stakes[msg.sender].add(rewardsAccrued());
1173         require(stakes[msg.sender] <= stakeCap, "TokenStaking: Can't Stake More than allowed moneybags"); 
1174         lastWithdraw[msg.sender] = block.number;
1175         emit rewardsCompunded(msg.sender, rewardsAccrued(), block.number);
1176     }
1177     
1178     /**
1179      * allows user to withrdraw any pending rewards and
1180      * 
1181      * staking position if `emergencyWDoff` is false enabling 
1182      * 
1183      * emergency withdraw situtaions when staking is off and 
1184      * 
1185      * the contract is paused.  This will likely never be used.
1186      */
1187     
1188     function emergencyWithdrawRewardAndStakes() public emergency {
1189         rewards[msg.sender] = rewards[msg.sender].add(rewardsAccrued());
1190         fundamenta.mintTo(msg.sender, rewardsAccrued().add(stakes[msg.sender]));
1191         stakes[msg.sender] = stakes[msg.sender].sub(stakes[msg.sender]);
1192         removeStakeholder(msg.sender);
1193     }
1194     
1195     /**
1196      * returns a users `lastWithdraw` which is the last block
1197      * 
1198      * height that the user last withdrew rewards.
1199      */
1200     
1201     function lastWdHeight() public view returns (uint) {
1202         return lastWithdraw[msg.sender];
1203     }
1204     
1205     /**
1206      * returns to the user the amount of blocks that they must
1207      * 
1208      * have their stake locked before they are able to unstake their
1209      * 
1210      * positon.
1211      */
1212     
1213     function stakeUnlockWindow() external view returns (uint) {
1214         uint unlockWindow = rewardsWindow.mul(stakeLockMultiplier);
1215         uint stakeWindow = lastWithdraw[msg.sender].add(unlockWindow);
1216         return stakeWindow;
1217     }
1218     
1219     /**
1220      * allows admin with the `_STAKING` role to set the 
1221      * 
1222      * `stakeMultiplier` which is used in the calculation that
1223      *
1224      * determines how long a user must have a staked positon 
1225      * 
1226      * before they are able to unstake said positon.
1227      */
1228     
1229     function setStakeMultiplier(uint _newMultiplier) public pause stakeToggle {
1230         require(hasRole(_STAKING, msg.sender));
1231         stakeLockMultiplier = _newMultiplier;
1232     }
1233     
1234     /**
1235      * returns a users staked position.
1236      */
1237     
1238     function stakeOf (address _stakeholder) public view returns(uint) {
1239         return stakes[_stakeholder];
1240     }
1241     
1242     /**
1243      * returns the total amount of FMTA that has been 
1244      * 
1245      * placed in staking postions by users.
1246      */
1247     
1248     function totalStakes() public view returns(uint) {
1249         uint _totalStakes = 0;
1250         for (uint s = 0; s < stakeholders.length; s += 1) {
1251             _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
1252         }
1253         
1254         return _totalStakes;
1255     }
1256     
1257     /**
1258      * returns if an account is a stakeholder and holds
1259      * 
1260      * a staked position.
1261      */
1262 
1263     function isStakeholder(address _address) public view returns(bool, uint) {
1264         for (uint s = 0; s < stakeholders.length; s += 1) {
1265             if (_address == stakeholders[s]) return (true, s);
1266         }
1267         
1268         return (false, 0);
1269     }
1270     
1271     /**
1272      * internal function that adds accounts as stakeholders.
1273      */
1274     
1275     function addStakeholder(address _stakeholder) internal pause stakeToggle {
1276         (bool _isStakeholder, ) = isStakeholder(_stakeholder);
1277         if(!_isStakeholder) stakeholders.push(_stakeholder);
1278     }
1279     
1280     /**
1281      * internal function that removes accounts as stakeholders.
1282      */
1283     
1284     function removeStakeholder(address _stakeholder) internal {
1285         (bool _isStakeholder, uint s) = isStakeholder(_stakeholder);
1286         if(_isStakeholder){
1287             stakeholders[s] = stakeholders[stakeholders.length - 1];
1288             stakeholders.pop();
1289         }
1290     }
1291     
1292     function getStakeholders() public view returns (uint _numOfStakeholders){
1293         return stakeholders.length;
1294     }
1295     
1296     function getByIndex(uint i) public view returns (address) {
1297     return stakeholders[i];
1298 }
1299     
1300     /**
1301      * returns an accounts total rewards paid over the
1302      * 
1303      * Staking Contracts lifetime.
1304      */
1305     
1306     function totalRewardsOf(address _stakeholder) external view returns(uint) {
1307         return rewards[_stakeholder];
1308     }
1309     
1310     /**
1311      * returns the amount of total rewards paid to all
1312      * 
1313      * accounts over the Staking Contracts lifetime.
1314      */
1315     
1316     function totalRewardsPaid() external view returns(uint) {
1317         uint _totalRewards = 0;
1318         for (uint s = 0; s < stakeholders.length; s += 1){
1319             _totalRewards = _totalRewards.add(rewards[stakeholders[s]]);
1320         }
1321         
1322         return _totalRewards;
1323     }
1324     
1325      /**
1326      * allows admin with the `_STAKING` role to set the
1327      * 
1328      * Staking Contracts `stakeCalc` which is the divisor used
1329      * 
1330      * in `calculateReward` to determine the reward during each 
1331      * 
1332      * `rewardsWindow`.
1333      */
1334     
1335     function setStakeCalc(uint _stakeCalc) external pause stakeToggle {
1336         require(hasRole(_STAKING, msg.sender));
1337         stakeCalc = _stakeCalc;
1338     }
1339     
1340      /**
1341      * allows admin with the `_STAKING` role to set the
1342      * 
1343      * Staking Contracts `stakeCap` which determines how many
1344      * 
1345      * tokens total can be staked per account.
1346      */
1347     
1348     function setStakeCap(uint _stakeCap) external pause stakeToggle {
1349         require(hasRole(_STAKING, msg.sender));
1350         stakeCap = _stakeCap;
1351     }
1352     
1353      /**
1354      * allows admin with the `_STAKING` role to set the
1355      * 
1356      * Staking Contracts `stakeOff` bool to true ot false 
1357      * 
1358      * effecively turning staking on or off. The only function 
1359      * 
1360      * that is not effected is removng stake 
1361      */
1362     
1363     function stakeOff(bool _stakingOff) public {
1364         require(hasRole(_STAKING, msg.sender));
1365         stakingOff = _stakingOff;
1366     }
1367     
1368     /**
1369      * allows admin with the `_STAKING` role to set the
1370      * 
1371      * Staking Contracts `rewardsWindow` which determines how
1372      * 
1373      * long a user must wait before they can with draw in the 
1374      * 
1375      * form of a number of blocks that must pass since the users
1376      * 
1377      * `lastWithdraw`.
1378      */
1379     
1380     function setRewardsWindow(uint _newWindow) external pause stakeToggle {
1381         require(hasRole(_STAKING, msg.sender));
1382         rewardsWindow = _newWindow;
1383     }
1384     
1385     /**
1386      * simple function help track and calculate the rewards
1387      * 
1388      * accrued between rewards windows. it uses `stakeCalc` which
1389      * 
1390      * is settable by admins with the `_STAKING` role.
1391      */
1392     
1393     function calculateReward(address _stakeholder) public view returns(uint) {
1394         return stakes[_stakeholder] / stakeCalc;
1395     }
1396     
1397     /**
1398      * turns on the emergencyWD function which is used for 
1399      * 
1400      * when the staking contract is paused or stopped for some
1401      * 
1402      * unforseeable reason and we still need to let users withdraw.
1403      */
1404     
1405     function setEmergencyWDoff(bool _emergencyWD) external {
1406         require(hasRole(_ADMIN, msg.sender));
1407         emergencyWDoff = _emergencyWD;
1408     }
1409     
1410 
1411     //----------Pause----------------------
1412 
1413     /**
1414      * pauses the Smart Contract.
1415      */
1416 
1417     function setPaused(bool _paused) external {
1418         require(hasRole(_ADMIN, msg.sender));
1419         paused = _paused;
1420     }
1421     
1422     //----Emergency PEBCAK Functions-------
1423     
1424     function mistakenERC20DepositRescue(address _ERC20, address _pebcak, uint _ERC20Amount) public {
1425         require(hasRole(_RESCUE, msg.sender),"TokenStaking: Message Sender must be _RESCUE");
1426         IERC20(_ERC20).safeTransfer(_pebcak, _ERC20Amount);
1427         emit TokensRescued (_pebcak, _ERC20, _ERC20Amount, block.number);
1428     }
1429 
1430     function mistakenDepositRescue(address payable _pebcak, uint _etherAmount) public {
1431         require(hasRole(_RESCUE, msg.sender),"TokenStaking: Message Sender must be _RESCUE");
1432         _pebcak.transfer(_etherAmount);
1433         emit ETHRescued (_pebcak, _etherAmount, block.number);
1434     }
1435 
1436 }