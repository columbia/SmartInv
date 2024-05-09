1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 
173 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
177 
178 pragma solidity ^0.8.0;
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
237     function transferFrom(
238         address sender,
239         address recipient,
240         uint256 amount
241     ) external returns (bool);
242 
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to {approve}. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 
259 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.4.2
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 // CAUTION
267 // This version of SafeMath should only be used with Solidity 0.8 or later,
268 // because it relies on the compiler's built in overflow checks.
269 
270 /**
271  * @dev Wrappers over Solidity's arithmetic operations.
272  *
273  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
274  * now has built in overflow checking.
275  */
276 library SafeMath {
277     /**
278      * @dev Returns the addition of two unsigned integers, with an overflow flag.
279      *
280      * _Available since v3.4._
281      */
282     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
283         unchecked {
284             uint256 c = a + b;
285             if (c < a) return (false, 0);
286             return (true, c);
287         }
288     }
289 
290     /**
291      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
292      *
293      * _Available since v3.4._
294      */
295     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
296         unchecked {
297             if (b > a) return (false, 0);
298             return (true, a - b);
299         }
300     }
301 
302     /**
303      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
304      *
305      * _Available since v3.4._
306      */
307     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
308         unchecked {
309             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
310             // benefit is lost if 'b' is also tested.
311             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
312             if (a == 0) return (true, 0);
313             uint256 c = a * b;
314             if (c / a != b) return (false, 0);
315             return (true, c);
316         }
317     }
318 
319     /**
320      * @dev Returns the division of two unsigned integers, with a division by zero flag.
321      *
322      * _Available since v3.4._
323      */
324     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
325         unchecked {
326             if (b == 0) return (false, 0);
327             return (true, a / b);
328         }
329     }
330 
331     /**
332      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
333      *
334      * _Available since v3.4._
335      */
336     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
337         unchecked {
338             if (b == 0) return (false, 0);
339             return (true, a % b);
340         }
341     }
342 
343     /**
344      * @dev Returns the addition of two unsigned integers, reverting on
345      * overflow.
346      *
347      * Counterpart to Solidity's `+` operator.
348      *
349      * Requirements:
350      *
351      * - Addition cannot overflow.
352      */
353     function add(uint256 a, uint256 b) internal pure returns (uint256) {
354         return a + b;
355     }
356 
357     /**
358      * @dev Returns the subtraction of two unsigned integers, reverting on
359      * overflow (when the result is negative).
360      *
361      * Counterpart to Solidity's `-` operator.
362      *
363      * Requirements:
364      *
365      * - Subtraction cannot overflow.
366      */
367     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
368         return a - b;
369     }
370 
371     /**
372      * @dev Returns the multiplication of two unsigned integers, reverting on
373      * overflow.
374      *
375      * Counterpart to Solidity's `*` operator.
376      *
377      * Requirements:
378      *
379      * - Multiplication cannot overflow.
380      */
381     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
382         return a * b;
383     }
384 
385     /**
386      * @dev Returns the integer division of two unsigned integers, reverting on
387      * division by zero. The result is rounded towards zero.
388      *
389      * Counterpart to Solidity's `/` operator.
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function div(uint256 a, uint256 b) internal pure returns (uint256) {
396         return a / b;
397     }
398 
399     /**
400      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
401      * reverting when dividing by zero.
402      *
403      * Counterpart to Solidity's `%` operator. This function uses a `revert`
404      * opcode (which leaves remaining gas untouched) while Solidity uses an
405      * invalid opcode to revert (consuming all remaining gas).
406      *
407      * Requirements:
408      *
409      * - The divisor cannot be zero.
410      */
411     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
412         return a % b;
413     }
414 
415     /**
416      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
417      * overflow (when the result is negative).
418      *
419      * CAUTION: This function is deprecated because it requires allocating memory for the error
420      * message unnecessarily. For custom revert reasons use {trySub}.
421      *
422      * Counterpart to Solidity's `-` operator.
423      *
424      * Requirements:
425      *
426      * - Subtraction cannot overflow.
427      */
428     function sub(
429         uint256 a,
430         uint256 b,
431         string memory errorMessage
432     ) internal pure returns (uint256) {
433         unchecked {
434             require(b <= a, errorMessage);
435             return a - b;
436         }
437     }
438 
439     /**
440      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
441      * division by zero. The result is rounded towards zero.
442      *
443      * Counterpart to Solidity's `/` operator. Note: this function uses a
444      * `revert` opcode (which leaves remaining gas untouched) while Solidity
445      * uses an invalid opcode to revert (consuming all remaining gas).
446      *
447      * Requirements:
448      *
449      * - The divisor cannot be zero.
450      */
451     function div(
452         uint256 a,
453         uint256 b,
454         string memory errorMessage
455     ) internal pure returns (uint256) {
456         unchecked {
457             require(b > 0, errorMessage);
458             return a / b;
459         }
460     }
461 
462     /**
463      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
464      * reverting with custom message when dividing by zero.
465      *
466      * CAUTION: This function is deprecated because it requires allocating memory for the error
467      * message unnecessarily. For custom revert reasons use {tryMod}.
468      *
469      * Counterpart to Solidity's `%` operator. This function uses a `revert`
470      * opcode (which leaves remaining gas untouched) while Solidity uses an
471      * invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      *
475      * - The divisor cannot be zero.
476      */
477     function mod(
478         uint256 a,
479         uint256 b,
480         string memory errorMessage
481     ) internal pure returns (uint256) {
482         unchecked {
483             require(b > 0, errorMessage);
484             return a % b;
485         }
486     }
487 }
488 
489 
490 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev Collection of functions related to the address type
499  */
500 library Address {
501     /**
502      * @dev Returns true if `account` is a contract.
503      *
504      * [IMPORTANT]
505      * ====
506      * It is unsafe to assume that an address for which this function returns
507      * false is an externally-owned account (EOA) and not a contract.
508      *
509      * Among others, `isContract` will return false for the following
510      * types of addresses:
511      *
512      *  - an externally-owned account
513      *  - a contract in construction
514      *  - an address where a contract will be created
515      *  - an address where a contract lived, but was destroyed
516      * ====
517      */
518     function isContract(address account) internal view returns (bool) {
519         // This method relies on extcodesize, which returns 0 for contracts in
520         // construction, since the code is only stored at the end of the
521         // constructor execution.
522 
523         uint256 size;
524         assembly {
525             size := extcodesize(account)
526         }
527         return size > 0;
528     }
529 
530     /**
531      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
532      * `recipient`, forwarding all available gas and reverting on errors.
533      *
534      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
535      * of certain opcodes, possibly making contracts go over the 2300 gas limit
536      * imposed by `transfer`, making them unable to receive funds via
537      * `transfer`. {sendValue} removes this limitation.
538      *
539      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
540      *
541      * IMPORTANT: because control is transferred to `recipient`, care must be
542      * taken to not create reentrancy vulnerabilities. Consider using
543      * {ReentrancyGuard} or the
544      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
545      */
546     function sendValue(address payable recipient, uint256 amount) internal {
547         require(address(this).balance >= amount, "Address: insufficient balance");
548 
549         (bool success, ) = recipient.call{value: amount}("");
550         require(success, "Address: unable to send value, recipient may have reverted");
551     }
552 
553     /**
554      * @dev Performs a Solidity function call using a low level `call`. A
555      * plain `call` is an unsafe replacement for a function call: use this
556      * function instead.
557      *
558      * If `target` reverts with a revert reason, it is bubbled up by this
559      * function (like regular Solidity function calls).
560      *
561      * Returns the raw returned data. To convert to the expected return value,
562      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
563      *
564      * Requirements:
565      *
566      * - `target` must be a contract.
567      * - calling `target` with `data` must not revert.
568      *
569      * _Available since v3.1._
570      */
571     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
572         return functionCall(target, data, "Address: low-level call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
577      * `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         return functionCallWithValue(target, data, 0, errorMessage);
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
591      * but also transferring `value` wei to `target`.
592      *
593      * Requirements:
594      *
595      * - the calling contract must have an ETH balance of at least `value`.
596      * - the called Solidity function must be `payable`.
597      *
598      * _Available since v3.1._
599      */
600     function functionCallWithValue(
601         address target,
602         bytes memory data,
603         uint256 value
604     ) internal returns (bytes memory) {
605         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
610      * with `errorMessage` as a fallback revert reason when `target` reverts.
611      *
612      * _Available since v3.1._
613      */
614     function functionCallWithValue(
615         address target,
616         bytes memory data,
617         uint256 value,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         require(address(this).balance >= value, "Address: insufficient balance for call");
621         require(isContract(target), "Address: call to non-contract");
622 
623         (bool success, bytes memory returndata) = target.call{value: value}(data);
624         return verifyCallResult(success, returndata, errorMessage);
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
629      * but performing a static call.
630      *
631      * _Available since v3.3._
632      */
633     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
634         return functionStaticCall(target, data, "Address: low-level static call failed");
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
639      * but performing a static call.
640      *
641      * _Available since v3.3._
642      */
643     function functionStaticCall(
644         address target,
645         bytes memory data,
646         string memory errorMessage
647     ) internal view returns (bytes memory) {
648         require(isContract(target), "Address: static call to non-contract");
649 
650         (bool success, bytes memory returndata) = target.staticcall(data);
651         return verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
656      * but performing a delegate call.
657      *
658      * _Available since v3.4._
659      */
660     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
661         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
666      * but performing a delegate call.
667      *
668      * _Available since v3.4._
669      */
670     function functionDelegateCall(
671         address target,
672         bytes memory data,
673         string memory errorMessage
674     ) internal returns (bytes memory) {
675         require(isContract(target), "Address: delegate call to non-contract");
676 
677         (bool success, bytes memory returndata) = target.delegatecall(data);
678         return verifyCallResult(success, returndata, errorMessage);
679     }
680 
681     /**
682      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
683      * revert reason using the provided one.
684      *
685      * _Available since v4.3._
686      */
687     function verifyCallResult(
688         bool success,
689         bytes memory returndata,
690         string memory errorMessage
691     ) internal pure returns (bytes memory) {
692         if (success) {
693             return returndata;
694         } else {
695             // Look for revert reason and bubble it up if present
696             if (returndata.length > 0) {
697                 // The easiest way to bubble the revert reason is using memory via assembly
698 
699                 assembly {
700                     let returndata_size := mload(returndata)
701                     revert(add(32, returndata), returndata_size)
702                 }
703             } else {
704                 revert(errorMessage);
705             }
706         }
707     }
708 }
709 
710 
711 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.4.2
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @title SafeERC20
721  * @dev Wrappers around ERC20 operations that throw on failure (when the token
722  * contract returns false). Tokens that return no value (and instead revert or
723  * throw on failure) are also supported, non-reverting calls are assumed to be
724  * successful.
725  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
726  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
727  */
728 library SafeERC20 {
729     using Address for address;
730 
731     function safeTransfer(
732         IERC20 token,
733         address to,
734         uint256 value
735     ) internal {
736         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
737     }
738 
739     function safeTransferFrom(
740         IERC20 token,
741         address from,
742         address to,
743         uint256 value
744     ) internal {
745         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
746     }
747 
748     /**
749      * @dev Deprecated. This function has issues similar to the ones found in
750      * {IERC20-approve}, and its usage is discouraged.
751      *
752      * Whenever possible, use {safeIncreaseAllowance} and
753      * {safeDecreaseAllowance} instead.
754      */
755     function safeApprove(
756         IERC20 token,
757         address spender,
758         uint256 value
759     ) internal {
760         // safeApprove should only be called when setting an initial allowance,
761         // or when resetting it to zero. To increase and decrease it, use
762         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
763         require(
764             (value == 0) || (token.allowance(address(this), spender) == 0),
765             "SafeERC20: approve from non-zero to non-zero allowance"
766         );
767         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
768     }
769 
770     function safeIncreaseAllowance(
771         IERC20 token,
772         address spender,
773         uint256 value
774     ) internal {
775         uint256 newAllowance = token.allowance(address(this), spender) + value;
776         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
777     }
778 
779     function safeDecreaseAllowance(
780         IERC20 token,
781         address spender,
782         uint256 value
783     ) internal {
784         unchecked {
785             uint256 oldAllowance = token.allowance(address(this), spender);
786             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
787             uint256 newAllowance = oldAllowance - value;
788             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
789         }
790     }
791 
792     /**
793      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
794      * on the return value: the return value is optional (but if data is returned, it must not be false).
795      * @param token The token targeted by the call.
796      * @param data The call data (encoded using abi.encode or one of its variants).
797      */
798     function _callOptionalReturn(IERC20 token, bytes memory data) private {
799         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
800         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
801         // the target address contains contract code and also asserts for success in the low-level call.
802 
803         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
804         if (returndata.length > 0) {
805             // Return data is optional
806             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
807         }
808     }
809 }
810 
811 
812 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
813 
814 
815 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
816 
817 pragma solidity ^0.8.0;
818 
819 /**
820  * @dev Provides information about the current execution context, including the
821  * sender of the transaction and its data. While these are generally available
822  * via msg.sender and msg.data, they should not be accessed in such a direct
823  * manner, since when dealing with meta-transactions the account sending and
824  * paying for execution may not be the actual sender (as far as an application
825  * is concerned).
826  *
827  * This contract is only required for intermediate, library-like contracts.
828  */
829 abstract contract Context {
830     function _msgSender() internal view virtual returns (address) {
831         return msg.sender;
832     }
833 
834     function _msgData() internal view virtual returns (bytes calldata) {
835         return msg.data;
836     }
837 }
838 
839 
840 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
841 
842 
843 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 /**
848  * @dev Contract module which provides a basic access control mechanism, where
849  * there is an account (an owner) that can be granted exclusive access to
850  * specific functions.
851  *
852  * By default, the owner account will be the one that deploys the contract. This
853  * can later be changed with {transferOwnership}.
854  *
855  * This module is used through inheritance. It will make available the modifier
856  * `onlyOwner`, which can be applied to your functions to restrict their use to
857  * the owner.
858  */
859 abstract contract Ownable is Context {
860     address private _owner;
861 
862     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
863 
864     /**
865      * @dev Initializes the contract setting the deployer as the initial owner.
866      */
867     constructor() {
868         _transferOwnership(_msgSender());
869     }
870 
871     /**
872      * @dev Returns the address of the current owner.
873      */
874     function owner() public view virtual returns (address) {
875         return _owner;
876     }
877 
878     /**
879      * @dev Throws if called by any account other than the owner.
880      */
881     modifier onlyOwner() {
882         require(owner() == _msgSender(), "Ownable: caller is not the owner");
883         _;
884     }
885 
886     /**
887      * @dev Leaves the contract without owner. It will not be possible to call
888      * `onlyOwner` functions anymore. Can only be called by the current owner.
889      *
890      * NOTE: Renouncing ownership will leave the contract without an owner,
891      * thereby removing any functionality that is only available to the owner.
892      */
893     function renounceOwnership() public virtual onlyOwner {
894         _transferOwnership(address(0));
895     }
896 
897     /**
898      * @dev Transfers ownership of the contract to a new account (`newOwner`).
899      * Can only be called by the current owner.
900      */
901     function transferOwnership(address newOwner) public virtual onlyOwner {
902         require(newOwner != address(0), "Ownable: new owner is the zero address");
903         _transferOwnership(newOwner);
904     }
905 
906     /**
907      * @dev Transfers ownership of the contract to a new account (`newOwner`).
908      * Internal function without access restriction.
909      */
910     function _transferOwnership(address newOwner) internal virtual {
911         address oldOwner = _owner;
912         _owner = newOwner;
913         emit OwnershipTransferred(oldOwner, newOwner);
914     }
915 }
916 
917 
918 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.4.2
919 
920 
921 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 /**
926  * @dev Library for managing
927  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
928  * types.
929  *
930  * Sets have the following properties:
931  *
932  * - Elements are added, removed, and checked for existence in constant time
933  * (O(1)).
934  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
935  *
936  * ```
937  * contract Example {
938  *     // Add the library methods
939  *     using EnumerableSet for EnumerableSet.AddressSet;
940  *
941  *     // Declare a set state variable
942  *     EnumerableSet.AddressSet private mySet;
943  * }
944  * ```
945  *
946  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
947  * and `uint256` (`UintSet`) are supported.
948  */
949 library EnumerableSet {
950     // To implement this library for multiple types with as little code
951     // repetition as possible, we write it in terms of a generic Set type with
952     // bytes32 values.
953     // The Set implementation uses private functions, and user-facing
954     // implementations (such as AddressSet) are just wrappers around the
955     // underlying Set.
956     // This means that we can only create new EnumerableSets for types that fit
957     // in bytes32.
958 
959     struct Set {
960         // Storage of set values
961         bytes32[] _values;
962         // Position of the value in the `values` array, plus 1 because index 0
963         // means a value is not in the set.
964         mapping(bytes32 => uint256) _indexes;
965     }
966 
967     /**
968      * @dev Add a value to a set. O(1).
969      *
970      * Returns true if the value was added to the set, that is if it was not
971      * already present.
972      */
973     function _add(Set storage set, bytes32 value) private returns (bool) {
974         if (!_contains(set, value)) {
975             set._values.push(value);
976             // The value is stored at length-1, but we add 1 to all indexes
977             // and use 0 as a sentinel value
978             set._indexes[value] = set._values.length;
979             return true;
980         } else {
981             return false;
982         }
983     }
984 
985     /**
986      * @dev Removes a value from a set. O(1).
987      *
988      * Returns true if the value was removed from the set, that is if it was
989      * present.
990      */
991     function _remove(Set storage set, bytes32 value) private returns (bool) {
992         // We read and store the value's index to prevent multiple reads from the same storage slot
993         uint256 valueIndex = set._indexes[value];
994 
995         if (valueIndex != 0) {
996             // Equivalent to contains(set, value)
997             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
998             // the array, and then remove the last element (sometimes called as 'swap and pop').
999             // This modifies the order of the array, as noted in {at}.
1000 
1001             uint256 toDeleteIndex = valueIndex - 1;
1002             uint256 lastIndex = set._values.length - 1;
1003 
1004             if (lastIndex != toDeleteIndex) {
1005                 bytes32 lastvalue = set._values[lastIndex];
1006 
1007                 // Move the last value to the index where the value to delete is
1008                 set._values[toDeleteIndex] = lastvalue;
1009                 // Update the index for the moved value
1010                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1011             }
1012 
1013             // Delete the slot where the moved value was stored
1014             set._values.pop();
1015 
1016             // Delete the index for the deleted slot
1017             delete set._indexes[value];
1018 
1019             return true;
1020         } else {
1021             return false;
1022         }
1023     }
1024 
1025     /**
1026      * @dev Returns true if the value is in the set. O(1).
1027      */
1028     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1029         return set._indexes[value] != 0;
1030     }
1031 
1032     /**
1033      * @dev Returns the number of values on the set. O(1).
1034      */
1035     function _length(Set storage set) private view returns (uint256) {
1036         return set._values.length;
1037     }
1038 
1039     /**
1040      * @dev Returns the value stored at position `index` in the set. O(1).
1041      *
1042      * Note that there are no guarantees on the ordering of values inside the
1043      * array, and it may change when more values are added or removed.
1044      *
1045      * Requirements:
1046      *
1047      * - `index` must be strictly less than {length}.
1048      */
1049     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1050         return set._values[index];
1051     }
1052 
1053     /**
1054      * @dev Return the entire set in an array
1055      *
1056      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1057      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1058      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1059      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1060      */
1061     function _values(Set storage set) private view returns (bytes32[] memory) {
1062         return set._values;
1063     }
1064 
1065     // Bytes32Set
1066 
1067     struct Bytes32Set {
1068         Set _inner;
1069     }
1070 
1071     /**
1072      * @dev Add a value to a set. O(1).
1073      *
1074      * Returns true if the value was added to the set, that is if it was not
1075      * already present.
1076      */
1077     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1078         return _add(set._inner, value);
1079     }
1080 
1081     /**
1082      * @dev Removes a value from a set. O(1).
1083      *
1084      * Returns true if the value was removed from the set, that is if it was
1085      * present.
1086      */
1087     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1088         return _remove(set._inner, value);
1089     }
1090 
1091     /**
1092      * @dev Returns true if the value is in the set. O(1).
1093      */
1094     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1095         return _contains(set._inner, value);
1096     }
1097 
1098     /**
1099      * @dev Returns the number of values in the set. O(1).
1100      */
1101     function length(Bytes32Set storage set) internal view returns (uint256) {
1102         return _length(set._inner);
1103     }
1104 
1105     /**
1106      * @dev Returns the value stored at position `index` in the set. O(1).
1107      *
1108      * Note that there are no guarantees on the ordering of values inside the
1109      * array, and it may change when more values are added or removed.
1110      *
1111      * Requirements:
1112      *
1113      * - `index` must be strictly less than {length}.
1114      */
1115     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1116         return _at(set._inner, index);
1117     }
1118 
1119     /**
1120      * @dev Return the entire set in an array
1121      *
1122      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1123      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1124      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1125      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1126      */
1127     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1128         return _values(set._inner);
1129     }
1130 
1131     // AddressSet
1132 
1133     struct AddressSet {
1134         Set _inner;
1135     }
1136 
1137     /**
1138      * @dev Add a value to a set. O(1).
1139      *
1140      * Returns true if the value was added to the set, that is if it was not
1141      * already present.
1142      */
1143     function add(AddressSet storage set, address value) internal returns (bool) {
1144         return _add(set._inner, bytes32(uint256(uint160(value))));
1145     }
1146 
1147     /**
1148      * @dev Removes a value from a set. O(1).
1149      *
1150      * Returns true if the value was removed from the set, that is if it was
1151      * present.
1152      */
1153     function remove(AddressSet storage set, address value) internal returns (bool) {
1154         return _remove(set._inner, bytes32(uint256(uint160(value))));
1155     }
1156 
1157     /**
1158      * @dev Returns true if the value is in the set. O(1).
1159      */
1160     function contains(AddressSet storage set, address value) internal view returns (bool) {
1161         return _contains(set._inner, bytes32(uint256(uint160(value))));
1162     }
1163 
1164     /**
1165      * @dev Returns the number of values in the set. O(1).
1166      */
1167     function length(AddressSet storage set) internal view returns (uint256) {
1168         return _length(set._inner);
1169     }
1170 
1171     /**
1172      * @dev Returns the value stored at position `index` in the set. O(1).
1173      *
1174      * Note that there are no guarantees on the ordering of values inside the
1175      * array, and it may change when more values are added or removed.
1176      *
1177      * Requirements:
1178      *
1179      * - `index` must be strictly less than {length}.
1180      */
1181     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1182         return address(uint160(uint256(_at(set._inner, index))));
1183     }
1184 
1185     /**
1186      * @dev Return the entire set in an array
1187      *
1188      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1189      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1190      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1191      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1192      */
1193     function values(AddressSet storage set) internal view returns (address[] memory) {
1194         bytes32[] memory store = _values(set._inner);
1195         address[] memory result;
1196 
1197         assembly {
1198             result := store
1199         }
1200 
1201         return result;
1202     }
1203 
1204     // UintSet
1205 
1206     struct UintSet {
1207         Set _inner;
1208     }
1209 
1210     /**
1211      * @dev Add a value to a set. O(1).
1212      *
1213      * Returns true if the value was added to the set, that is if it was not
1214      * already present.
1215      */
1216     function add(UintSet storage set, uint256 value) internal returns (bool) {
1217         return _add(set._inner, bytes32(value));
1218     }
1219 
1220     /**
1221      * @dev Removes a value from a set. O(1).
1222      *
1223      * Returns true if the value was removed from the set, that is if it was
1224      * present.
1225      */
1226     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1227         return _remove(set._inner, bytes32(value));
1228     }
1229 
1230     /**
1231      * @dev Returns true if the value is in the set. O(1).
1232      */
1233     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1234         return _contains(set._inner, bytes32(value));
1235     }
1236 
1237     /**
1238      * @dev Returns the number of values on the set. O(1).
1239      */
1240     function length(UintSet storage set) internal view returns (uint256) {
1241         return _length(set._inner);
1242     }
1243 
1244     /**
1245      * @dev Returns the value stored at position `index` in the set. O(1).
1246      *
1247      * Note that there are no guarantees on the ordering of values inside the
1248      * array, and it may change when more values are added or removed.
1249      *
1250      * Requirements:
1251      *
1252      * - `index` must be strictly less than {length}.
1253      */
1254     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1255         return uint256(_at(set._inner, index));
1256     }
1257 
1258     /**
1259      * @dev Return the entire set in an array
1260      *
1261      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1262      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1263      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1264      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1265      */
1266     function values(UintSet storage set) internal view returns (uint256[] memory) {
1267         bytes32[] memory store = _values(set._inner);
1268         uint256[] memory result;
1269 
1270         assembly {
1271             result := store
1272         }
1273 
1274         return result;
1275     }
1276 }
1277 
1278 
1279 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
1280 
1281 
1282 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1283 
1284 pragma solidity ^0.8.0;
1285 
1286 /**
1287  * @title ERC721 token receiver interface
1288  * @dev Interface for any contract that wants to support safeTransfers
1289  * from ERC721 asset contracts.
1290  */
1291 interface IERC721Receiver {
1292     /**
1293      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1294      * by `operator` from `from`, this function is called.
1295      *
1296      * It must return its Solidity selector to confirm the token transfer.
1297      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1298      *
1299      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1300      */
1301     function onERC721Received(
1302         address operator,
1303         address from,
1304         uint256 tokenId,
1305         bytes calldata data
1306     ) external returns (bytes4);
1307 }
1308 
1309 
1310 // File @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol@v4.4.2
1311 
1312 
1313 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
1314 
1315 pragma solidity ^0.8.0;
1316 
1317 /**
1318  * @dev Implementation of the {IERC721Receiver} interface.
1319  *
1320  * Accepts all token transfers.
1321  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
1322  */
1323 contract ERC721Holder is IERC721Receiver {
1324     /**
1325      * @dev See {IERC721Receiver-onERC721Received}.
1326      *
1327      * Always returns `IERC721Receiver.onERC721Received.selector`.
1328      */
1329     function onERC721Received(
1330         address,
1331         address,
1332         uint256,
1333         bytes memory
1334     ) public virtual override returns (bytes4) {
1335         return this.onERC721Received.selector;
1336     }
1337 }
1338 
1339 
1340 // File contracts/BOOMBAZNFTStaking.sol
1341 
1342 
1343 pragma solidity ^0.8.0;
1344 interface IBOOMBAZNFT {
1345 	function safeTransferFrom(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) external;
1350     function transferFrom(
1351         address from,
1352         address to,
1353         uint256 tokenId
1354     ) external;
1355 	function ownerOf(uint256 tokenId) external view returns (address owner);
1356 	function balanceOf(address owner) external view returns (uint256 balance);
1357     function nftLevel(uint256 tokenId) external view returns (uint256 nftLevel);
1358 }
1359 
1360 contract BOOMBAZNFTStaking is ERC721Holder, Ownable  {
1361     using SafeMath for uint256;
1362     using SafeERC20 for IERC20;
1363     using EnumerableSet for EnumerableSet.UintSet;
1364 
1365     // Info of each user.
1366     struct UserInfo {
1367         uint256 amount;     // How many NFT items the user has provided.
1368         uint256 rewardDebt; // Reward debt. See explanation below.
1369         EnumerableSet.UintSet nftIds;
1370     }
1371 
1372     // Info of each pool.
1373     struct PoolInfo {
1374         IERC20 rewardsToken;
1375         uint256 allocPoint;       // How many allocation points assigned to this pool. Rewards Tokens to distribute per block.
1376         uint256 lastRewardBlock;  // Last block number that Rewards Tokens distribution occurs.
1377         uint256 accTokenPerShare; // Accumulated Rewards Tokens per share,
1378         uint256 maxNFTs;          // Max amount of nfts allowed
1379         uint256 totalStaked;
1380         uint256 nftLevel;
1381         EnumerableSet.UintSet nftIds;
1382         bool    active;
1383     }
1384     mapping(uint256 => uint256) private _nftLevels; // tokenId <-> nftlevel
1385     mapping(uint256 => bool) private _nftLevelSet; // tokenId <-> levelSet bool
1386     mapping(address => bool) public earlyWhitelisted; // user <-> earlyWhitelisted
1387     bool launched = false;
1388     bool launchWL = false;
1389 
1390     // The BOOMBAZ NFT TOKEN!
1391     IBOOMBAZNFT public BOOMBAZNFTToken;
1392 
1393     address public rewardsWallet;
1394 
1395     uint256 public totalPools;
1396 
1397     // Info of each pool.
1398     mapping(uint256 => PoolInfo) private poolInfo;
1399        
1400     // Info of each user that stakes NFT tokens.
1401     mapping (uint256 => mapping (address => UserInfo)) private userInfo;
1402 
1403     // The block number when Rewards Token mining starts.
1404     uint256 public startBlock;
1405 
1406     event Deposit(address indexed user, uint256 indexed pid, uint256 id);
1407     event DepositBatch(address indexed user, uint256 indexed pid, uint256[] ids);
1408     event Withdraw(address indexed user, uint256 indexed pid, uint256 id);
1409     event WithdrawBatch(address indexed user, uint256 indexed pid, uint256[] ids);
1410     event Redeem(address indexed user, uint256 indexed pid, uint256 amount);
1411 
1412     constructor(
1413         IBOOMBAZNFT _boomb,
1414         address _rewardsWallet,
1415         uint256 _startBlock
1416     ) {
1417         BOOMBAZNFTToken = _boomb;
1418         rewardsWallet = _rewardsWallet;
1419         startBlock = _startBlock;
1420     }
1421 
1422     function updateRewardsWallet(address _wallet) external onlyOwner {
1423         require(_wallet != address(0x0), "invalid rewards wallet address");
1424         rewardsWallet = _wallet;
1425     }
1426 
1427 
1428     function poolLength() public view returns (uint256) {
1429         return totalPools;
1430     }
1431 
1432     // Add a new lp to the pool. Can only be called by the owner.
1433     function add(
1434         uint256 _allocPoint, 
1435         IERC20 _rewardsToken, 
1436         uint256 _nftLevel, 
1437         uint256 _maxNFTs,
1438         bool _withUpdate
1439     ) public onlyOwner {
1440         if (_withUpdate) {
1441             massUpdatePools();
1442         }
1443         require(_nftLevel >= 0, "invalid nftLevel");
1444         require(_maxNFTs >= 1, "invalid max nfts");
1445 
1446         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1447         
1448         PoolInfo storage pool = poolInfo[++totalPools];
1449         pool.rewardsToken     = _rewardsToken;
1450         pool.allocPoint       = _allocPoint;
1451         pool.lastRewardBlock  = lastRewardBlock;
1452         pool.accTokenPerShare = 0;
1453         pool.totalStaked      = 0;
1454         pool.nftLevel         = _nftLevel;
1455         pool.maxNFTs          = _maxNFTs;
1456         pool.active           = true;
1457     }
1458 
1459     // Update the given pool's Rewards Token allocation point. Can only be called by the owner.
1460     function set(
1461         uint256 _pid, 
1462         uint256 _allocPoint, 
1463         uint256 _nftLevel, 
1464         uint256 _maxNFTs,
1465         bool _active, 
1466         bool _withUpdate
1467     ) external onlyOwner {
1468         require(_pid <= totalPools, "invalid pool id");
1469         require(_nftLevel >= 0, "invalid nftLevel");
1470         require(_maxNFTs >= 1, "invalid max nfts");
1471 
1472         if (_withUpdate) {
1473             massUpdatePools();
1474         }
1475         poolInfo[_pid].allocPoint = _allocPoint;
1476         poolInfo[_pid].nftLevel = _nftLevel;
1477         poolInfo[_pid].maxNFTs  = _maxNFTs;
1478         poolInfo[_pid].active = _active;
1479     }
1480 
1481     // Return reward multiplier over the given _from to _to block.
1482     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
1483         return _to.sub(_from);
1484     }
1485 
1486     // View function to see pending Rewards Tokens on frontend.
1487     function pendingRewardsToken(uint256 _pid, address _user) external view returns (uint256) {
1488         PoolInfo storage pool = poolInfo[_pid];
1489         UserInfo storage user = userInfo[_pid][_user];
1490         uint256 accTokenPerShare = pool.accTokenPerShare;
1491         uint256 totalStaked = pool.totalStaked;
1492         if (block.number > pool.lastRewardBlock && totalStaked != 0) {
1493             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1494             uint256 reward = multiplier.mul(pool.allocPoint);
1495             accTokenPerShare = accTokenPerShare.add(reward.div(totalStaked));
1496         }
1497         return user.amount.mul(accTokenPerShare).sub(user.rewardDebt);
1498     }
1499 
1500     // Update reward variables for all pools. Be careful of gas spending!
1501     function massUpdatePools() public {
1502         uint256 length = poolLength();
1503         for (uint256 pid = 0; pid < length; ++pid) {
1504             updatePool(pid);
1505         }
1506     }
1507 
1508 
1509     // Update reward variables of the given pool to be up-to-date.
1510     function updatePool(uint256 _pid) public {
1511         PoolInfo storage pool = poolInfo[_pid];
1512         if (block.number <= pool.lastRewardBlock) {
1513             return;
1514         }
1515         uint256 totalStaked = pool.totalStaked;
1516         if (totalStaked == 0) {
1517             pool.lastRewardBlock = block.number;
1518             return;
1519         }
1520         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1521         uint256 reward = multiplier.mul(pool.allocPoint);
1522         pool.accTokenPerShare = pool.accTokenPerShare.add(reward.div(totalStaked));
1523         pool.lastRewardBlock = block.number;
1524     }
1525 
1526     // Set the level of a NFT ID#
1527     function setNFTLevel(uint256 tokenId, uint256 level) external onlyOwner {
1528         _nftLevels[tokenId] = level;
1529         _nftLevelSet[tokenId] = true;
1530     }
1531 
1532     // Add and remove addresses to be allowed to stake early.
1533     function earlyWhitelist(address _user, bool _state) external onlyOwner {
1534         earlyWhitelisted[_user] = _state;
1535     }
1536 
1537     // If true, only Whitelisted addresses can stake.
1538     function earlyBird() external onlyOwner {
1539         launchWL = true;
1540     }
1541 
1542     // If true, everyone can stake. Used for launch purposes.
1543     function launch() external onlyOwner {
1544         launched = true;
1545     }
1546 
1547     // Deposit NFT items tokens to contract for Rewards Token allocation.
1548     function joinPool(uint256 _pid, uint256 _tokenId) external {
1549         PoolInfo storage pool = poolInfo[_pid];
1550         UserInfo storage user = userInfo[_pid][msg.sender];
1551         require(launchWL == true, "Oh no you don't!");
1552         require(launched == true || earlyWhitelisted[msg.sender] == true, "Whitelisters Period only!");
1553         require(pool.active, "pool not active");
1554         require(pool.totalStaked.add(1) <= pool.maxNFTs, "exceeded max nfts");
1555         require(_nftLevels[_tokenId] == pool.nftLevel || _nftLevelSet[_tokenId] == false, "level mismatch");
1556 
1557         updatePool(_pid);
1558         
1559         if (user.amount > 0) {
1560             uint256 pending = user.amount.mul(pool.accTokenPerShare).sub(user.rewardDebt);
1561             if(pending > 0) {
1562                 safeRewardTransfer(_pid, msg.sender, pending);
1563             }
1564         }   
1565 
1566         BOOMBAZNFTToken.safeTransferFrom(msg.sender, address(this), _tokenId);
1567 
1568         if (_nftLevelSet[_tokenId] != true){
1569             _nftLevels[_tokenId] = pool.nftLevel;
1570             _nftLevelSet[_tokenId] = true;
1571         }
1572 
1573         user.nftIds.add(_tokenId);
1574         user.amount = user.amount.add(1);
1575         user.rewardDebt = user.amount.mul(pool.accTokenPerShare);
1576 
1577         pool.totalStaked = pool.totalStaked.add(1);
1578         pool.nftIds.add(_tokenId);
1579         emit Deposit(msg.sender, _pid, _tokenId);
1580     }
1581 
1582     function joinPoolBatch(uint256 _pid,  uint256[] memory _tokenIds) external {
1583         uint256 amount = _tokenIds.length;
1584         require(amount > 0, "length mismatch");
1585         require(launchWL == true, "Oh no you don't!");
1586         require(launched == true || earlyWhitelisted[msg.sender] == true, "Whitelisters Period only!");
1587 
1588         PoolInfo storage pool = poolInfo[_pid];
1589         UserInfo storage user = userInfo[_pid][msg.sender];
1590 
1591         require(pool.active, "pool not active");
1592         require(pool.totalStaked.add(amount) <= pool.maxNFTs, "exceeded max nfts");
1593 
1594         updatePool(_pid);
1595         
1596         if (user.amount > 0) {
1597             uint256 pending = user.amount.mul(pool.accTokenPerShare).sub(user.rewardDebt);
1598             if(pending > 0) {
1599                 safeRewardTransfer(_pid, msg.sender, pending);
1600             }
1601         }
1602 
1603         uint256 totalAmount = 0;
1604         for (uint i = 0 ; i < amount; i++) {
1605             uint _id = _tokenIds[i];
1606             require(_nftLevels[_id] == pool.nftLevel || _nftLevelSet[_id] == false, "level mismatch");
1607             BOOMBAZNFTToken.safeTransferFrom(msg.sender, address(this), _id);
1608 
1609         if (_nftLevelSet[_id] != true){
1610             _nftLevels[_id] = pool.nftLevel;
1611             _nftLevelSet[_id] = true;
1612         }
1613 
1614             user.nftIds.add(_id);
1615             pool.nftIds.add(_id);
1616 
1617             totalAmount = totalAmount.add(1);
1618         }
1619 
1620         if (totalAmount > 0) {
1621             user.amount = user.amount.add(totalAmount);
1622         }
1623 
1624         user.rewardDebt = user.amount.mul(pool.accTokenPerShare);
1625 
1626         pool.totalStaked = pool.totalStaked.add(totalAmount);
1627         emit DepositBatch(msg.sender, _pid, _tokenIds);
1628     }
1629 
1630     // Leave NFT items.
1631     function leavePool(uint256 _pid, uint256 _id) external {
1632         PoolInfo storage pool = poolInfo[_pid];
1633         UserInfo storage user = userInfo[_pid][msg.sender];
1634 
1635         require(user.nftIds.contains(_id), "not owner of nft");
1636 
1637         updatePool(_pid);
1638 
1639         uint256 pending = user.amount.mul(pool.accTokenPerShare).sub(user.rewardDebt);
1640         if(pending > 0) {
1641             safeRewardTransfer(_pid, msg.sender, pending);
1642         }
1643 
1644         BOOMBAZNFTToken.safeTransferFrom(address(this), msg.sender, _id);
1645 
1646         user.amount = user.amount.sub(1);
1647         user.nftIds.remove(_id);
1648             
1649 
1650         user.rewardDebt = user.amount.mul(pool.accTokenPerShare);
1651         pool.totalStaked = pool.totalStaked.sub(1);
1652         pool.nftIds.remove(_id);
1653 
1654         emit Withdraw(msg.sender, _pid, _id);
1655     }
1656 
1657     function leavePoolBatch(uint256 _pid, uint256[] memory _ids) public {
1658         PoolInfo storage pool = poolInfo[_pid];
1659         UserInfo storage user = userInfo[_pid][msg.sender];
1660 
1661         require (_ids.length > 0, "length mismatch");
1662 
1663         updatePool(_pid);
1664 
1665         uint256 pending = user.amount.mul(pool.accTokenPerShare).sub(user.rewardDebt);
1666         if(pending > 0) {
1667             safeRewardTransfer(_pid, msg.sender, pending);
1668         }
1669         
1670         uint256 totalAmount = 0;
1671         for(uint i = 0 ; i < _ids.length; i++) {
1672             uint _id = _ids[i];
1673             require(user.nftIds.contains(_id), "not owner of nft");
1674             BOOMBAZNFTToken.safeTransferFrom(address(this), msg.sender, _id);
1675 
1676             totalAmount = totalAmount.add(1);
1677             user.nftIds.remove(_id);
1678             pool.nftIds.remove(_id);
1679         }
1680 
1681         if(totalAmount > 0) {
1682             user.amount = user.amount.sub(totalAmount);
1683             pool.totalStaked = pool.totalStaked.sub(totalAmount);
1684         }
1685 
1686         user.rewardDebt = user.amount.mul(pool.accTokenPerShare);
1687         
1688         emit WithdrawBatch(msg.sender, _pid, _ids);
1689     }
1690 
1691     // Leave NFT items.
1692     function leavePoolForUser(uint256 _pid, uint256 _id, address _account, bool _rewardsToUser) external onlyOwner {
1693         PoolInfo storage pool = poolInfo[_pid];
1694         UserInfo storage user = userInfo[_pid][_account];
1695 
1696         require(user.nftIds.contains(_id), "not owner of nft");
1697 
1698         updatePool(_pid);
1699 
1700         uint256 pending = user.amount.mul(pool.accTokenPerShare).sub(user.rewardDebt);
1701         if(_rewardsToUser == false && pending > 0) {
1702             safeRewardTransfer(_pid, rewardsWallet, pending);
1703         }
1704 
1705         if(_rewardsToUser == true && pending > 0) {
1706             safeRewardTransfer(_pid, _account, pending);
1707         }
1708 
1709         BOOMBAZNFTToken.safeTransferFrom(address(this), _account, _id);
1710 
1711         user.amount = user.amount.sub(1);
1712         user.nftIds.remove(_id);
1713             
1714 
1715         user.rewardDebt = user.amount.mul(pool.accTokenPerShare);
1716         pool.totalStaked = pool.totalStaked.sub(1);
1717         pool.nftIds.remove(_id);
1718 
1719         emit Withdraw(_account, _pid, _id);
1720     }
1721 
1722     function leavePoolBatchForUser(uint256 _pid, uint256[] memory _ids, address _account, bool _rewardsToUser) external onlyOwner {
1723         PoolInfo storage pool = poolInfo[_pid];
1724         UserInfo storage user = userInfo[_pid][_account];
1725 
1726         require (_ids.length > 0, "length mismatch");
1727 
1728         updatePool(_pid);
1729 
1730         uint256 pending = user.amount.mul(pool.accTokenPerShare).sub(user.rewardDebt);
1731         if(_rewardsToUser == false && pending > 0) {
1732             safeRewardTransfer(_pid, rewardsWallet, pending);
1733         }
1734 
1735         if(_rewardsToUser == true && pending > 0) {
1736             safeRewardTransfer(_pid, _account, pending);
1737         }
1738         
1739         uint256 totalAmount = 0;
1740         for(uint i = 0 ; i < _ids.length; i++) {
1741             uint _id = _ids[i];
1742             require(user.nftIds.contains(_id), "not owner of nft");
1743             BOOMBAZNFTToken.safeTransferFrom(address(this), _account, _id);
1744 
1745             totalAmount = totalAmount.add(1);
1746             user.nftIds.remove(_id);
1747             pool.nftIds.remove(_id);
1748         }
1749 
1750         if(totalAmount > 0) {
1751             user.amount = user.amount.sub(totalAmount);
1752             pool.totalStaked = pool.totalStaked.sub(totalAmount);
1753         }
1754 
1755         user.rewardDebt = user.amount.mul(pool.accTokenPerShare);
1756         
1757         emit WithdrawBatch(_account, _pid, _ids);
1758     }
1759 
1760     // Withdraw without caring about rewards. EMERGENCY ONLY.
1761     function exit(uint256 _pid) public {
1762         UserInfo storage user = userInfo[_pid][msg.sender];
1763 
1764         (uint256[] memory ids) 
1765             = userStakedNFTs(_pid, msg.sender);
1766 
1767         leavePoolBatch(_pid, ids);
1768 
1769         user.amount = 0;
1770         user.rewardDebt = 0;
1771     }
1772 
1773     // Redeem currently pending rewards from a specific pool
1774     function redeem(uint256 _pid) public {
1775         PoolInfo storage pool = poolInfo[_pid];
1776         UserInfo storage user = userInfo[_pid][msg.sender];
1777 
1778         updatePool(_pid);
1779 
1780         uint256 pending = user.amount.mul(pool.accTokenPerShare).sub(user.rewardDebt);
1781         if(pending > 0) {
1782             safeRewardTransfer(_pid, msg.sender, pending);
1783         }
1784         
1785         user.rewardDebt = user.amount.mul(pool.accTokenPerShare);
1786 
1787         emit Redeem(msg.sender, _pid, pending);
1788     }
1789 
1790     // Redeem all currently pending rewards
1791     function redeemAll() public {
1792         for(uint _pid = 1; _pid <= poolLength(); _pid++) {
1793             PoolInfo storage pool = poolInfo[_pid];
1794             UserInfo storage user = userInfo[_pid][msg.sender];
1795 
1796             updatePool(_pid);
1797 
1798             uint256 pending = user.amount.mul(pool.accTokenPerShare).sub(user.rewardDebt);
1799             if(pending > 0) {
1800                 safeRewardTransfer(_pid, msg.sender, pending);
1801             }
1802             
1803             user.rewardDebt = user.amount.mul(pool.accTokenPerShare);
1804 
1805             emit Redeem(msg.sender, _pid, pending);
1806         }
1807     }
1808 
1809 
1810     function safeRewardTransfer(uint256 _pid, address _to, uint256 _amount) internal {
1811         IERC20(poolInfo[_pid].rewardsToken).safeTransferFrom(rewardsWallet, _to, _amount);
1812     }
1813 
1814     function getUserInfo(uint256 _pid, address _account) public view returns(uint256, uint256, uint256[] memory) {
1815         UserInfo storage user = userInfo[_pid][_account];
1816         uint256[] memory ids = userStakedNFTs(_pid, msg.sender);
1817         return (
1818             user.amount,
1819             user.rewardDebt,
1820             ids
1821         );
1822     }
1823 
1824     function getPoolInfo(uint256 _pid) public view returns(
1825         address,
1826         uint256,   
1827         uint256,
1828         uint256,
1829         uint256,
1830         uint256[] memory
1831     ) {
1832         PoolInfo storage pool = poolInfo[_pid];
1833         uint256[] memory ids = poolStakedNFTs(_pid);
1834         return (
1835             address(pool.rewardsToken),
1836             pool.allocPoint,
1837             pool.lastRewardBlock,
1838             pool.accTokenPerShare,
1839             pool.totalStaked,
1840             ids
1841         );
1842     }
1843     
1844     function userStakedNFTs(uint256 _pid, address _account) 
1845         public 
1846         view 
1847         returns(uint256[] memory ids) 
1848     {
1849         ids = userInfo[_pid][_account].nftIds.values();
1850     }
1851 
1852     function poolStakedNFTs(uint256 _pid) 
1853         public 
1854         view 
1855         returns(uint256[] memory ids) 
1856     {
1857         ids = poolInfo[_pid].nftIds.values();
1858     }
1859 
1860     function nftLevel(uint256 tokenId) external view returns (uint256) {
1861         return _nftLevels[tokenId];
1862     }
1863 
1864     function isNftLevelSet(uint256 tokenId) external view returns (bool) {
1865         return _nftLevelSet[tokenId];
1866     }
1867 
1868     function isLaunch() external view returns (bool) {
1869         return launched;
1870     }
1871 
1872     function isLaunchWL() external view returns (bool) {
1873         return launchWL;
1874     }
1875 
1876 }