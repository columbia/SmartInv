1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/math/SafeMath.sol"
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 
231 
232 
233 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
234 pragma solidity ^0.8.0;
235 /**
236  * @dev Interface of the ERC165 standard, as defined in the
237  * https://eips.ethereum.org/EIPS/eip-165[EIP].
238  *
239  * Implementers can declare support of contract interfaces, which can then be
240  * queried by others ({ERC165Checker}).
241  *
242  * For an implementation, see {ERC165}.
243  */
244 interface IERC165 {
245     /**
246      * @dev Returns true if this contract implements the interface defined by
247      * `interfaceId`. See the corresponding
248      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
249      * to learn more about how these ids are created.
250      *
251      * This function call must use less than 30 000 gas.
252      */
253     function supportsInterface(bytes4 interfaceId) external view returns (bool);
254 }
255 
256 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
257 pragma solidity ^0.8.0;
258 /**
259  * @dev Required interface of an ERC721 compliant contract.
260  */
261 interface IERC721 is IERC165 {
262     /**
263      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
264      */
265     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
266 
267     /**
268      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
269      */
270     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
271 
272     /**
273      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
274      */
275     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
276 
277     /**
278      * @dev Returns the number of tokens in ``owner``'s account.
279      */
280     function balanceOf(address owner) external view returns (uint256 balance);
281 
282     /**
283      * @dev Returns the owner of the `tokenId` token.
284      *
285      * Requirements:
286      *
287      * - `tokenId` must exist.
288      */
289     function ownerOf(uint256 tokenId) external view returns (address owner);
290 
291     /**
292      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
293      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
294      *
295      * Requirements:
296      *
297      * - `from` cannot be the zero address.
298      * - `to` cannot be the zero address.
299      * - `tokenId` token must exist and be owned by `from`.
300      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
301      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
302      *
303      * Emits a {Transfer} event.
304      */
305     function safeTransferFrom(
306         address from,
307         address to,
308         uint256 tokenId
309     ) external;
310 
311     /**
312      * @dev Transfers `tokenId` token from `from` to `to`.
313      *
314      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
315      *
316      * Requirements:
317      *
318      * - `from` cannot be the zero address.
319      * - `to` cannot be the zero address.
320      * - `tokenId` token must be owned by `from`.
321      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transferFrom(
326         address from,
327         address to,
328         uint256 tokenId
329     ) external;
330 
331     /**
332      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
333      * The approval is cleared when the token is transferred.
334      *
335      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
336      *
337      * Requirements:
338      *
339      * - The caller must own the token or be an approved operator.
340      * - `tokenId` must exist.
341      *
342      * Emits an {Approval} event.
343      */
344     function approve(address to, uint256 tokenId) external;
345 
346     /**
347      * @dev Returns the account approved for `tokenId` token.
348      *
349      * Requirements:
350      *
351      * - `tokenId` must exist.
352      */
353     function getApproved(uint256 tokenId) external view returns (address operator);
354 
355     /**
356      * @dev Approve or remove `operator` as an operator for the caller.
357      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
358      *
359      * Requirements:
360      *
361      * - The `operator` cannot be the caller.
362      *
363      * Emits an {ApprovalForAll} event.
364      */
365     function setApprovalForAll(address operator, bool _approved) external;
366 
367     /**
368      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
369      *
370      * See {setApprovalForAll}
371      */
372     function isApprovedForAll(address owner, address operator) external view returns (bool);
373 
374     /**
375      * @dev Safely transfers `tokenId` token from `from` to `to`.
376      *
377      * Requirements:
378      *
379      * - `from` cannot be the zero address.
380      * - `to` cannot be the zero address.
381      * - `tokenId` token must exist and be owned by `from`.
382      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
383      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
384      *
385      * Emits a {Transfer} event.
386      */
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 tokenId,
391         bytes calldata data
392     ) external;
393 }
394 
395 
396 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
397 pragma solidity ^0.8.0;
398 /**
399  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
400  * @dev See https://eips.ethereum.org/EIPS/eip-721
401  */
402 interface IERC721Enumerable is IERC721 {
403     /**
404      * @dev Returns the total amount of tokens stored by the contract.
405      */
406     function totalSupply() external view returns (uint256);
407 
408     /**
409      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
410      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
411      */
412     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
413 
414     /**
415      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
416      * Use along with {totalSupply} to enumerate all tokens.
417      */
418     function tokenByIndex(uint256 index) external view returns (uint256);
419 }
420 
421 
422 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
423 pragma solidity ^0.8.0;
424 /**
425  * @dev Implementation of the {IERC165} interface.
426  *
427  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
428  * for the additional interface id that will be supported. For example:
429  *
430  * ```solidity
431  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
432  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
433  * }
434  * ```
435  *
436  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
437  */
438 abstract contract ERC165 is IERC165 {
439     /**
440      * @dev See {IERC165-supportsInterface}.
441      */
442     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
443         return interfaceId == type(IERC165).interfaceId;
444     }
445 }
446 
447 // File: @openzeppelin/contracts/utils/Strings.sol
448 
449 
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev String operations.
455  */
456 library Strings {
457     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
458 
459     /**
460      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
461      */
462     function toString(uint256 value) internal pure returns (string memory) {
463         // Inspired by OraclizeAPI's implementation - MIT licence
464         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
465 
466         if (value == 0) {
467             return "0";
468         }
469         uint256 temp = value;
470         uint256 digits;
471         while (temp != 0) {
472             digits++;
473             temp /= 10;
474         }
475         bytes memory buffer = new bytes(digits);
476         while (value != 0) {
477             digits -= 1;
478             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
479             value /= 10;
480         }
481         return string(buffer);
482     }
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
486      */
487     function toHexString(uint256 value) internal pure returns (string memory) {
488         if (value == 0) {
489             return "0x00";
490         }
491         uint256 temp = value;
492         uint256 length = 0;
493         while (temp != 0) {
494             length++;
495             temp >>= 8;
496         }
497         return toHexString(value, length);
498     }
499 
500     /**
501      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
502      */
503     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
504         bytes memory buffer = new bytes(2 * length + 2);
505         buffer[0] = "0";
506         buffer[1] = "x";
507         for (uint256 i = 2 * length + 1; i > 1; --i) {
508             buffer[i] = _HEX_SYMBOLS[value & 0xf];
509             value >>= 4;
510         }
511         require(value == 0, "Strings: hex length insufficient");
512         return string(buffer);
513     }
514 }
515 
516 // File: @openzeppelin/contracts/utils/Address.sol
517 
518 
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Collection of functions related to the address type
524  */
525 library Address {
526     /**
527      * @dev Returns true if `account` is a contract.
528      *
529      * [IMPORTANT]
530      * ====
531      * It is unsafe to assume that an address for which this function returns
532      * false is an externally-owned account (EOA) and not a contract.
533      *
534      * Among others, `isContract` will return false for the following
535      * types of addresses:
536      *
537      *  - an externally-owned account
538      *  - a contract in construction
539      *  - an address where a contract will be created
540      *  - an address where a contract lived, but was destroyed
541      * ====
542      */
543     function isContract(address account) internal view returns (bool) {
544         // This method relies on extcodesize, which returns 0 for contracts in
545         // construction, since the code is only stored at the end of the
546         // constructor execution.
547 
548         uint256 size;
549         assembly {
550             size := extcodesize(account)
551         }
552         return size > 0;
553     }
554 
555     /**
556      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
557      * `recipient`, forwarding all available gas and reverting on errors.
558      *
559      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
560      * of certain opcodes, possibly making contracts go over the 2300 gas limit
561      * imposed by `transfer`, making them unable to receive funds via
562      * `transfer`. {sendValue} removes this limitation.
563      *
564      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
565      *
566      * IMPORTANT: because control is transferred to `recipient`, care must be
567      * taken to not create reentrancy vulnerabilities. Consider using
568      * {ReentrancyGuard} or the
569      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
570      */
571     function sendValue(address payable recipient, uint256 amount) internal {
572         require(address(this).balance >= amount, "Address: insufficient balance");
573 
574         (bool success, ) = recipient.call{value: amount}("");
575         require(success, "Address: unable to send value, recipient may have reverted");
576     }
577 
578     /**
579      * @dev Performs a Solidity function call using a low level `call`. A
580      * plain `call` is an unsafe replacement for a function call: use this
581      * function instead.
582      *
583      * If `target` reverts with a revert reason, it is bubbled up by this
584      * function (like regular Solidity function calls).
585      *
586      * Returns the raw returned data. To convert to the expected return value,
587      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
588      *
589      * Requirements:
590      *
591      * - `target` must be a contract.
592      * - calling `target` with `data` must not revert.
593      *
594      * _Available since v3.1._
595      */
596     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
597         return functionCall(target, data, "Address: low-level call failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
602      * `errorMessage` as a fallback revert reason when `target` reverts.
603      *
604      * _Available since v3.1._
605      */
606     function functionCall(
607         address target,
608         bytes memory data,
609         string memory errorMessage
610     ) internal returns (bytes memory) {
611         return functionCallWithValue(target, data, 0, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but also transferring `value` wei to `target`.
617      *
618      * Requirements:
619      *
620      * - the calling contract must have an ETH balance of at least `value`.
621      * - the called Solidity function must be `payable`.
622      *
623      * _Available since v3.1._
624      */
625     function functionCallWithValue(
626         address target,
627         bytes memory data,
628         uint256 value
629     ) internal returns (bytes memory) {
630         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
635      * with `errorMessage` as a fallback revert reason when `target` reverts.
636      *
637      * _Available since v3.1._
638      */
639     function functionCallWithValue(
640         address target,
641         bytes memory data,
642         uint256 value,
643         string memory errorMessage
644     ) internal returns (bytes memory) {
645         require(address(this).balance >= value, "Address: insufficient balance for call");
646         require(isContract(target), "Address: call to non-contract");
647 
648         (bool success, bytes memory returndata) = target.call{value: value}(data);
649         return verifyCallResult(success, returndata, errorMessage);
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
654      * but performing a static call.
655      *
656      * _Available since v3.3._
657      */
658     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
659         return functionStaticCall(target, data, "Address: low-level static call failed");
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
664      * but performing a static call.
665      *
666      * _Available since v3.3._
667      */
668     function functionStaticCall(
669         address target,
670         bytes memory data,
671         string memory errorMessage
672     ) internal view returns (bytes memory) {
673         require(isContract(target), "Address: static call to non-contract");
674 
675         (bool success, bytes memory returndata) = target.staticcall(data);
676         return verifyCallResult(success, returndata, errorMessage);
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
681      * but performing a delegate call.
682      *
683      * _Available since v3.4._
684      */
685     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
686         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
691      * but performing a delegate call.
692      *
693      * _Available since v3.4._
694      */
695     function functionDelegateCall(
696         address target,
697         bytes memory data,
698         string memory errorMessage
699     ) internal returns (bytes memory) {
700         require(isContract(target), "Address: delegate call to non-contract");
701 
702         (bool success, bytes memory returndata) = target.delegatecall(data);
703         return verifyCallResult(success, returndata, errorMessage);
704     }
705 
706     /**
707      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
708      * revert reason using the provided one.
709      *
710      * _Available since v4.3._
711      */
712     function verifyCallResult(
713         bool success,
714         bytes memory returndata,
715         string memory errorMessage
716     ) internal pure returns (bytes memory) {
717         if (success) {
718             return returndata;
719         } else {
720             // Look for revert reason and bubble it up if present
721             if (returndata.length > 0) {
722                 // The easiest way to bubble the revert reason is using memory via assembly
723 
724                 assembly {
725                     let returndata_size := mload(returndata)
726                     revert(add(32, returndata), returndata_size)
727                 }
728             } else {
729                 revert(errorMessage);
730             }
731         }
732     }
733 }
734 
735 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
736 
737 
738 
739 pragma solidity ^0.8.0;
740 
741 
742 /**
743  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
744  * @dev See https://eips.ethereum.org/EIPS/eip-721
745  */
746 interface IERC721Metadata is IERC721 {
747     /**
748      * @dev Returns the token collection name.
749      */
750     function name() external view returns (string memory);
751 
752     /**
753      * @dev Returns the token collection symbol.
754      */
755     function symbol() external view returns (string memory);
756 
757     /**
758      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
759      */
760     function tokenURI(uint256 tokenId) external view returns (string memory);
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
764 
765 
766 
767 pragma solidity ^0.8.0;
768 
769 /**
770  * @title ERC721 token receiver interface
771  * @dev Interface for any contract that wants to support safeTransfers
772  * from ERC721 asset contracts.
773  */
774 interface IERC721Receiver {
775     /**
776      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
777      * by `operator` from `from`, this function is called.
778      *
779      * It must return its Solidity selector to confirm the token transfer.
780      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
781      *
782      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
783      */
784     function onERC721Received(
785         address operator,
786         address from,
787         uint256 tokenId,
788         bytes calldata data
789     ) external returns (bytes4);
790 }
791 
792 // File: @openzeppelin/contracts/utils/Context.sol
793 pragma solidity ^0.8.0;
794 /**
795  * @dev Provides information about the current execution context, including the
796  * sender of the transaction and its data. While these are generally available
797  * via msg.sender and msg.data, they should not be accessed in such a direct
798  * manner, since when dealing with meta-transactions the account sending and
799  * paying for execution may not be the actual sender (as far as an application
800  * is concerned).
801  *
802  * This contract is only required for intermediate, library-like contracts.
803  */
804 abstract contract Context {
805     function _msgSender() internal view virtual returns (address) {
806         return msg.sender;
807     }
808 
809     function _msgData() internal view virtual returns (bytes calldata) {
810         return msg.data;
811     }
812 }
813 
814 
815 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
816 pragma solidity ^0.8.0;
817 /**
818  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
819  * the Metadata extension, but not including the Enumerable extension, which is available separately as
820  * {ERC721Enumerable}.
821  */
822 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
823     using Address for address;
824     using Strings for uint256;
825 
826     // Token name
827     string private _name;
828 
829     // Token symbol
830     string private _symbol;
831 
832     // Mapping from token ID to owner address
833     mapping(uint256 => address) private _owners;
834 
835     // Mapping owner address to token count
836     mapping(address => uint256) private _balances;
837 
838     // Mapping from token ID to approved address
839     mapping(uint256 => address) private _tokenApprovals;
840 
841     // Mapping from owner to operator approvals
842     mapping(address => mapping(address => bool)) private _operatorApprovals;
843 
844     /**
845      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
846      */
847     constructor(string memory name_, string memory symbol_) {
848         _name = name_;
849         _symbol = symbol_;
850     }
851 
852     /**
853      * @dev See {IERC165-supportsInterface}.
854      */
855     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
856         return
857             interfaceId == type(IERC721).interfaceId ||
858             interfaceId == type(IERC721Metadata).interfaceId ||
859             super.supportsInterface(interfaceId);
860     }
861 
862     /**
863      * @dev See {IERC721-balanceOf}.
864      */
865     function balanceOf(address owner) public view virtual override returns (uint256) {
866         require(owner != address(0), "ERC721: balance query for the zero address");
867         return _balances[owner];
868     }
869 
870     /**
871      * @dev See {IERC721-ownerOf}.
872      */
873     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
874         address owner = _owners[tokenId];
875         require(owner != address(0), "ERC721: owner query for nonexistent token");
876         return owner;
877     }
878 
879     /**
880      * @dev See {IERC721Metadata-name}.
881      */
882     function name() public view virtual override returns (string memory) {
883         return _name;
884     }
885 
886     /**
887      * @dev See {IERC721Metadata-symbol}.
888      */
889     function symbol() public view virtual override returns (string memory) {
890         return _symbol;
891     }
892 
893     /**
894      * @dev See {IERC721Metadata-tokenURI}.
895      */
896     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
897         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
898 
899         string memory baseURI = _baseURI();
900         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
901     }
902 
903     /**
904      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
905      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
906      * by default, can be overriden in child contracts.
907      */
908     function _baseURI() internal view virtual returns (string memory) {
909         return "";
910     }
911 
912     /**
913      * @dev See {IERC721-approve}.
914      */
915     function approve(address to, uint256 tokenId) public virtual override {
916         address owner = ERC721.ownerOf(tokenId);
917         require(to != owner, "ERC721: approval to current owner");
918 
919         require(
920             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
921             "ERC721: approve caller is not owner nor approved for all"
922         );
923 
924         _approve(to, tokenId);
925     }
926 
927     /**
928      * @dev See {IERC721-getApproved}.
929      */
930     function getApproved(uint256 tokenId) public view virtual override returns (address) {
931         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
932 
933         return _tokenApprovals[tokenId];
934     }
935 
936     /**
937      * @dev See {IERC721-setApprovalForAll}.
938      */
939     function setApprovalForAll(address operator, bool approved) public virtual override {
940         require(operator != _msgSender(), "ERC721: approve to caller");
941 
942         _operatorApprovals[_msgSender()][operator] = approved;
943         emit ApprovalForAll(_msgSender(), operator, approved);
944     }
945 
946     /**
947      * @dev See {IERC721-isApprovedForAll}.
948      */
949     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
950         return _operatorApprovals[owner][operator];
951     }
952 
953     /**
954      * @dev See {IERC721-transferFrom}.
955      */
956     function transferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public virtual override {
961         //solhint-disable-next-line max-line-length
962         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
963 
964         _transfer(from, to, tokenId);
965     }
966 
967     /**
968      * @dev See {IERC721-safeTransferFrom}.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId
974     ) public virtual override {
975         safeTransferFrom(from, to, tokenId, "");
976     }
977 
978     /**
979      * @dev See {IERC721-safeTransferFrom}.
980      */
981     function safeTransferFrom(
982         address from,
983         address to,
984         uint256 tokenId,
985         bytes memory _data
986     ) public virtual override {
987         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
988         _safeTransfer(from, to, tokenId, _data);
989     }
990 
991     /**
992      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
993      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
994      *
995      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
996      *
997      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
998      * implement alternative mechanisms to perform token transfer, such as signature-based.
999      *
1000      * Requirements:
1001      *
1002      * - `from` cannot be the zero address.
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must exist and be owned by `from`.
1005      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _safeTransfer(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) internal virtual {
1015         _transfer(from, to, tokenId);
1016         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1017     }
1018 
1019     /**
1020      * @dev Returns whether `tokenId` exists.
1021      *
1022      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1023      *
1024      * Tokens start existing when they are minted (`_mint`),
1025      * and stop existing when they are burned (`_burn`).
1026      */
1027     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1028         return _owners[tokenId] != address(0);
1029     }
1030 
1031     /**
1032      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must exist.
1037      */
1038     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1039         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1040         address owner = ERC721.ownerOf(tokenId);
1041         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1042     }
1043 
1044     /**
1045      * @dev Safely mints `tokenId` and transfers it to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must not exist.
1050      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _safeMint(address to, uint256 tokenId) internal virtual {
1055         _safeMint(to, tokenId, "");
1056     }
1057 
1058     /**
1059      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1060      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1061      */
1062     function _safeMint(
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) internal virtual {
1067         _mint(to, tokenId);
1068         require(
1069             _checkOnERC721Received(address(0), to, tokenId, _data),
1070             "ERC721: transfer to non ERC721Receiver implementer"
1071         );
1072     }
1073 
1074     /**
1075      * @dev Mints `tokenId` and transfers it to `to`.
1076      *
1077      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must not exist.
1082      * - `to` cannot be the zero address.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _mint(address to, uint256 tokenId) internal virtual {
1087         require(to != address(0), "ERC721: mint to the zero address");
1088         require(!_exists(tokenId), "ERC721: token already minted");
1089 
1090         _beforeTokenTransfer(address(0), to, tokenId);
1091 
1092         _balances[to] += 1;
1093         _owners[tokenId] = to;
1094 
1095         emit Transfer(address(0), to, tokenId);
1096     }
1097 
1098     /**
1099      * @dev Destroys `tokenId`.
1100      * The approval is cleared when the token is burned.
1101      *
1102      * Requirements:
1103      *
1104      * - `tokenId` must exist.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _burn(uint256 tokenId) internal virtual {
1109         address owner = ERC721.ownerOf(tokenId);
1110 
1111         _beforeTokenTransfer(owner, address(0), tokenId);
1112 
1113         // Clear approvals
1114         _approve(address(0), tokenId);
1115 
1116         _balances[owner] -= 1;
1117         delete _owners[tokenId];
1118 
1119         emit Transfer(owner, address(0), tokenId);
1120     }
1121 
1122     /**
1123      * @dev Transfers `tokenId` from `from` to `to`.
1124      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must be owned by `from`.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _transfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) internal virtual {
1138         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1139         require(to != address(0), "ERC721: transfer to the zero address");
1140 
1141         _beforeTokenTransfer(from, to, tokenId);
1142 
1143         // Clear approvals from the previous owner
1144         _approve(address(0), tokenId);
1145 
1146         _balances[from] -= 1;
1147         _balances[to] += 1;
1148         _owners[tokenId] = to;
1149 
1150         emit Transfer(from, to, tokenId);
1151     }
1152 
1153     /**
1154      * @dev Approve `to` to operate on `tokenId`
1155      *
1156      * Emits a {Approval} event.
1157      */
1158     function _approve(address to, uint256 tokenId) internal virtual {
1159         _tokenApprovals[tokenId] = to;
1160         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1165      * The call is not executed if the target address is not a contract.
1166      *
1167      * @param from address representing the previous owner of the given token ID
1168      * @param to target address that will receive the tokens
1169      * @param tokenId uint256 ID of the token to be transferred
1170      * @param _data bytes optional data to send along with the call
1171      * @return bool whether the call correctly returned the expected magic value
1172      */
1173     function _checkOnERC721Received(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) private returns (bool) {
1179         if (to.isContract()) {
1180             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1181                 return retval == IERC721Receiver.onERC721Received.selector;
1182             } catch (bytes memory reason) {
1183                 if (reason.length == 0) {
1184                     revert("ERC721: transfer to non ERC721Receiver implementer");
1185                 } else {
1186                     assembly {
1187                         revert(add(32, reason), mload(reason))
1188                     }
1189                 }
1190             }
1191         } else {
1192             return true;
1193         }
1194     }
1195 
1196     /**
1197      * @dev Hook that is called before any token transfer. This includes minting
1198      * and burning.
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1206      * - `from` and `to` are never both zero.
1207      *
1208      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1209      */
1210     function _beforeTokenTransfer(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) internal virtual {}
1215 }
1216 
1217 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1218 
1219 
1220 
1221 pragma solidity ^0.8.0;
1222 
1223 
1224 
1225 /**
1226  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1227  * enumerability of all the token ids in the contract as well as all token ids owned by each
1228  * account.
1229  */
1230 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1231     // Mapping from owner to list of owned token IDs
1232     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1233 
1234     // Mapping from token ID to index of the owner tokens list
1235     mapping(uint256 => uint256) private _ownedTokensIndex;
1236 
1237     // Array with all token ids, used for enumeration
1238     uint256[] private _allTokens;
1239 
1240     // Mapping from token id to position in the allTokens array
1241     mapping(uint256 => uint256) private _allTokensIndex;
1242 
1243     /**
1244      * @dev See {IERC165-supportsInterface}.
1245      */
1246     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1247         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1252      */
1253     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1254         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1255         return _ownedTokens[owner][index];
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Enumerable-totalSupply}.
1260      */
1261     function totalSupply() public view virtual override returns (uint256) {
1262         return _allTokens.length;
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Enumerable-tokenByIndex}.
1267      */
1268     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1269         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1270         return _allTokens[index];
1271     }
1272 
1273     /**
1274      * @dev Hook that is called before any token transfer. This includes minting
1275      * and burning.
1276      *
1277      * Calling conditions:
1278      *
1279      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1280      * transferred to `to`.
1281      * - When `from` is zero, `tokenId` will be minted for `to`.
1282      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1283      * - `from` cannot be the zero address.
1284      * - `to` cannot be the zero address.
1285      *
1286      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1287      */
1288     function _beforeTokenTransfer(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) internal virtual override {
1293         super._beforeTokenTransfer(from, to, tokenId);
1294 
1295         if (from == address(0)) {
1296             _addTokenToAllTokensEnumeration(tokenId);
1297         } else if (from != to) {
1298             _removeTokenFromOwnerEnumeration(from, tokenId);
1299         }
1300         if (to == address(0)) {
1301             _removeTokenFromAllTokensEnumeration(tokenId);
1302         } else if (to != from) {
1303             _addTokenToOwnerEnumeration(to, tokenId);
1304         }
1305     }
1306 
1307     /**
1308      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1309      * @param to address representing the new owner of the given token ID
1310      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1311      */
1312     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1313         uint256 length = ERC721.balanceOf(to);
1314         _ownedTokens[to][length] = tokenId;
1315         _ownedTokensIndex[tokenId] = length;
1316     }
1317 
1318     /**
1319      * @dev Private function to add a token to this extension's token tracking data structures.
1320      * @param tokenId uint256 ID of the token to be added to the tokens list
1321      */
1322     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1323         _allTokensIndex[tokenId] = _allTokens.length;
1324         _allTokens.push(tokenId);
1325     }
1326 
1327     /**
1328      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1329      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1330      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1331      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1332      * @param from address representing the previous owner of the given token ID
1333      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1334      */
1335     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1336         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1337         // then delete the last slot (swap and pop).
1338 
1339         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1340         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1341 
1342         // When the token to delete is the last token, the swap operation is unnecessary
1343         if (tokenIndex != lastTokenIndex) {
1344             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1345 
1346             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1347             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1348         }
1349 
1350         // This also deletes the contents at the last position of the array
1351         delete _ownedTokensIndex[tokenId];
1352         delete _ownedTokens[from][lastTokenIndex];
1353     }
1354 
1355     /**
1356      * @dev Private function to remove a token from this extension's token tracking data structures.
1357      * This has O(1) time complexity, but alters the order of the _allTokens array.
1358      * @param tokenId uint256 ID of the token to be removed from the tokens list
1359      */
1360     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1361         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1362         // then delete the last slot (swap and pop).
1363 
1364         uint256 lastTokenIndex = _allTokens.length - 1;
1365         uint256 tokenIndex = _allTokensIndex[tokenId];
1366 
1367         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1368         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1369         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1370         uint256 lastTokenId = _allTokens[lastTokenIndex];
1371 
1372         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1373         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1374 
1375         // This also deletes the contents at the last position of the array
1376         delete _allTokensIndex[tokenId];
1377         _allTokens.pop();
1378     }
1379 }
1380 
1381 
1382 // File: @openzeppelin/contracts/access/Ownable.sol
1383 pragma solidity ^0.8.0;
1384 /**
1385  * @dev Contract module which provides a basic access control mechanism, where
1386  * there is an account (an owner) that can be granted exclusive access to
1387  * specific functions.
1388  *
1389  * By default, the owner account will be the one that deploys the contract. This
1390  * can later be changed with {transferOwnership}.
1391  *
1392  * This module is used through inheritance. It will make available the modifier
1393  * `onlyOwner`, which can be applied to your functions to restrict their use to
1394  * the owner.
1395  */
1396 abstract contract Ownable is Context {
1397     address private _owner;
1398 
1399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1400 
1401     /**
1402      * @dev Initializes the contract setting the deployer as the initial owner.
1403      */
1404     constructor() {
1405         _setOwner(_msgSender());
1406     }
1407 
1408     /**
1409      * @dev Returns the address of the current owner.
1410      */
1411     function owner() public view virtual returns (address) {
1412         return _owner;
1413     }
1414 
1415     /**
1416      * @dev Throws if called by any account other than the owner.
1417      */
1418     modifier onlyOwner() {
1419         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1420         _;
1421     }
1422 
1423     /**
1424      * @dev Leaves the contract without owner. It will not be possible to call
1425      * `onlyOwner` functions anymore. Can only be called by the current owner.
1426      *
1427      * NOTE: Renouncing ownership will leave the contract without an owner,
1428      * thereby removing any functionality that is only available to the owner.
1429      */
1430     function renounceOwnership() public virtual onlyOwner {
1431         _setOwner(address(0));
1432     }
1433 
1434     /**
1435      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1436      * Can only be called by the current owner.
1437      */
1438     function transferOwnership(address newOwner) public virtual onlyOwner {
1439         require(newOwner != address(0), "Ownable: new owner is the zero address");
1440         _setOwner(newOwner);
1441     }
1442 
1443     function _setOwner(address newOwner) private {
1444         address oldOwner = _owner;
1445         _owner = newOwner;
1446         emit OwnershipTransferred(oldOwner, newOwner);
1447     }
1448 }
1449 
1450 
1451 // File: LarvaChicksClub.sol
1452 pragma solidity ^0.8.0;
1453 
1454 contract LarvaChicksClub is ERC721Enumerable, Ownable {
1455     using SafeMath for uint256;
1456     using Address for address;
1457 
1458     string public baseURI;
1459     string public baseExtension = ".json";
1460     uint16 public counter = 0;
1461     uint8 public giveaway = 10;
1462     uint8 public constant maxPublicPurchase = 10;
1463     uint16 public maxSupply = 5000;
1464     bool public publicSale = true; 
1465 
1466     mapping(address => uint256) addressBlockBought;
1467 
1468     constructor(string memory tokenBaseUri) ERC721("Larva Chicks Club", "CHICK")  {
1469         // starting tokens from 1
1470         counter = counter + 1;
1471 
1472         setBaseURI(tokenBaseUri);
1473         mintForGiveaway();
1474     }
1475 
1476 
1477     /**
1478      * mint Larva Chicks
1479      */
1480     function mintChicks(uint8 numberOfTokens) public payable {
1481         uint256 supply = totalSupply();
1482         require(publicSale, "Public mint is not live right now.");
1483         require(addressBlockBought[msg.sender] < block.timestamp, "Not allowed to Mint on the same Block");
1484         require(!Address.isContract(msg.sender),"Contracts are not allowed to mint");
1485         require(numberOfTokens <= maxPublicPurchase, "You can mint a maximum of 10 Chicks");
1486         require(supply + numberOfTokens <= maxSupply, "Exceeds maximum Chicks supply" );
1487         
1488 
1489         addressBlockBought[msg.sender] = block.timestamp;
1490 
1491         for(uint8 i; i < numberOfTokens; i++){
1492             _safeMint(msg.sender, counter);
1493             counter = counter + 1;
1494         }
1495     }
1496 
1497     /**
1498      * reserve Chicks for giveaways
1499      */
1500     function mintForGiveaway() public onlyOwner {
1501         require(giveaway > 0, "Giveaway has been minted!");
1502 
1503         for (uint8 i = 0; i < giveaway; i++) {
1504             _safeMint(msg.sender, counter);
1505             counter = counter + 1;
1506         }
1507 
1508         giveaway -= giveaway;
1509     }
1510 
1511     /**
1512      * Returns Chicks of the Caller
1513      */
1514     function chicksOfOwner(address _owner) public view returns(uint256[] memory) {
1515         uint256 tokenCount = balanceOf(_owner);
1516 
1517         uint256[] memory tokensId = new uint256[](tokenCount);
1518         for(uint256 i; i < tokenCount; i++){
1519             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1520         }
1521         return tokensId;
1522     }
1523 
1524     function toggleSale() public onlyOwner{
1525         publicSale = !publicSale;
1526     }
1527 
1528     function _baseURI() internal view virtual override returns (string memory) {
1529         return baseURI;
1530     }
1531 
1532     function setBaseURI(string memory newBaseURI) public onlyOwner {
1533         baseURI = newBaseURI;
1534     }
1535 
1536     function tokenURI(uint256 tokenId)
1537     public
1538     view
1539     virtual
1540     override
1541     returns (string memory)
1542     {
1543         require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1544         
1545         string memory tokenIdString = uint2str(tokenId);
1546         string memory currentBaseURI = _baseURI();
1547         
1548         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI,  tokenIdString, baseExtension))
1549         : "";
1550     }
1551 
1552     /**
1553      * Withdraw Ether
1554      */
1555     function withdraw() public onlyOwner {
1556         uint256 balance = address(this).balance;
1557         require(balance > 0, "No balance to withdraw");
1558 
1559         (bool success, ) = msg.sender.call{value: balance}("");
1560         require(success, "Failed to withdraw payment");
1561     }
1562 
1563     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1564         if (_i == 0) {
1565             return "0";
1566         }
1567         uint j = _i;
1568         uint len;
1569         while (j != 0) {
1570             len++;
1571             j /= 10;
1572         }
1573         bytes memory bstr = new bytes(len);
1574         uint k = len;
1575         while (_i != 0) {
1576             k = k-1;
1577             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1578             bytes1 b1 = bytes1(temp);
1579             bstr[k] = b1;
1580             _i /= 10;
1581         }
1582         return string(bstr);
1583     }
1584     
1585 }