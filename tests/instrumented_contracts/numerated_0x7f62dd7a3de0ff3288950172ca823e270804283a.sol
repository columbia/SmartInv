1 // The Brainiacs //
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 
174 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
175 
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @title ERC721 token receiver interface
181  * @dev Interface for any contract that wants to support safeTransfers
182  * from ERC721 asset contracts.
183  */
184 interface IERC721Receiver {
185     /**
186      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
187      * by `operator` from `from`, this function is called.
188      *
189      * It must return its Solidity selector to confirm the token transfer.
190      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
191      *
192      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
193      */
194     function onERC721Received(
195         address operator,
196         address from,
197         uint256 tokenId,
198         bytes calldata data
199     ) external returns (bytes4);
200 }
201 
202 
203 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
204 
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213     /**
214      * @dev Returns the token collection name.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the token collection symbol.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
225      */
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228 
229 
230 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
231 
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // This method relies on extcodesize, which returns 0 for contracts in
258         // construction, since the code is only stored at the end of the
259         // constructor execution.
260 
261         uint256 size;
262         assembly {
263             size := extcodesize(account)
264         }
265         return size > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         (bool success, ) = recipient.call{value: amount}("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         require(isContract(target), "Address: call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.call{value: value}(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal view returns (bytes memory) {
386         require(isContract(target), "Address: static call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return _verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return _verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     function _verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) private pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430 
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 
443 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
444 
445 
446 pragma solidity ^0.8.0;
447 
448 /*
449  * @dev Provides information about the current execution context, including the
450  * sender of the transaction and its data. While these are generally available
451  * via msg.sender and msg.data, they should not be accessed in such a direct
452  * manner, since when dealing with meta-transactions the account sending and
453  * paying for execution may not be the actual sender (as far as an application
454  * is concerned).
455  *
456  * This contract is only required for intermediate, library-like contracts.
457  */
458 abstract contract Context {
459     function _msgSender() internal view virtual returns (address) {
460         return msg.sender;
461     }
462 
463     function _msgData() internal view virtual returns (bytes calldata) {
464         return msg.data;
465     }
466 }
467 
468 // File @openzeppelin/contracts/utils/math/SaftMath.sol
469 pragma solidity ^0.8.0;
470 
471 // CAUTION
472 // This version of SafeMath should only be used with Solidity 0.8 or later,
473 // because it relies on the compiler's built in overflow checks.
474 
475 /**
476  * @dev Wrappers over Solidity's arithmetic operations.
477  *
478  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
479  * now has built in overflow checking.
480  */
481 library SafeMath {
482     /**
483      * @dev Returns the addition of two unsigned integers, with an overflow flag.
484      *
485      * _Available since v3.4._
486      */
487     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
488         unchecked {
489             uint256 c = a + b;
490             if (c < a) return (false, 0);
491             return (true, c);
492         }
493     }
494 
495     /**
496      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
497      *
498      * _Available since v3.4._
499      */
500     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
501         unchecked {
502             if (b > a) return (false, 0);
503             return (true, a - b);
504         }
505     }
506 
507     /**
508      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
509      *
510      * _Available since v3.4._
511      */
512     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
513         unchecked {
514             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
515             // benefit is lost if 'b' is also tested.
516             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
517             if (a == 0) return (true, 0);
518             uint256 c = a * b;
519             if (c / a != b) return (false, 0);
520             return (true, c);
521         }
522     }
523 
524     /**
525      * @dev Returns the division of two unsigned integers, with a division by zero flag.
526      *
527      * _Available since v3.4._
528      */
529     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
530         unchecked {
531             if (b == 0) return (false, 0);
532             return (true, a / b);
533         }
534     }
535 
536     /**
537      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
538      *
539      * _Available since v3.4._
540      */
541     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
542         unchecked {
543             if (b == 0) return (false, 0);
544             return (true, a % b);
545         }
546     }
547 
548     /**
549      * @dev Returns the addition of two unsigned integers, reverting on
550      * overflow.
551      *
552      * Counterpart to Solidity's `+` operator.
553      *
554      * Requirements:
555      *
556      * - Addition cannot overflow.
557      */
558     function add(uint256 a, uint256 b) internal pure returns (uint256) {
559         return a + b;
560     }
561 
562     /**
563      * @dev Returns the subtraction of two unsigned integers, reverting on
564      * overflow (when the result is negative).
565      *
566      * Counterpart to Solidity's `-` operator.
567      *
568      * Requirements:
569      *
570      * - Subtraction cannot overflow.
571      */
572     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
573         return a - b;
574     }
575 
576     /**
577      * @dev Returns the multiplication of two unsigned integers, reverting on
578      * overflow.
579      *
580      * Counterpart to Solidity's `*` operator.
581      *
582      * Requirements:
583      *
584      * - Multiplication cannot overflow.
585      */
586     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a * b;
588     }
589 
590     /**
591      * @dev Returns the integer division of two unsigned integers, reverting on
592      * division by zero. The result is rounded towards zero.
593      *
594      * Counterpart to Solidity's `/` operator.
595      *
596      * Requirements:
597      *
598      * - The divisor cannot be zero.
599      */
600     function div(uint256 a, uint256 b) internal pure returns (uint256) {
601         return a / b;
602     }
603 
604     /**
605      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
606      * reverting when dividing by zero.
607      *
608      * Counterpart to Solidity's `%` operator. This function uses a `revert`
609      * opcode (which leaves remaining gas untouched) while Solidity uses an
610      * invalid opcode to revert (consuming all remaining gas).
611      *
612      * Requirements:
613      *
614      * - The divisor cannot be zero.
615      */
616     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
617         return a % b;
618     }
619 
620     /**
621      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
622      * overflow (when the result is negative).
623      *
624      * CAUTION: This function is deprecated because it requires allocating memory for the error
625      * message unnecessarily. For custom revert reasons use {trySub}.
626      *
627      * Counterpart to Solidity's `-` operator.
628      *
629      * Requirements:
630      *
631      * - Subtraction cannot overflow.
632      */
633     function sub(
634         uint256 a,
635         uint256 b,
636         string memory errorMessage
637     ) internal pure returns (uint256) {
638         unchecked {
639             require(b <= a, errorMessage);
640             return a - b;
641         }
642     }
643 
644     /**
645      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
646      * division by zero. The result is rounded towards zero.
647      *
648      * Counterpart to Solidity's `/` operator. Note: this function uses a
649      * `revert` opcode (which leaves remaining gas untouched) while Solidity
650      * uses an invalid opcode to revert (consuming all remaining gas).
651      *
652      * Requirements:
653      *
654      * - The divisor cannot be zero.
655      */
656     function div(
657         uint256 a,
658         uint256 b,
659         string memory errorMessage
660     ) internal pure returns (uint256) {
661         unchecked {
662             require(b > 0, errorMessage);
663             return a / b;
664         }
665     }
666 
667     /**
668      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
669      * reverting with custom message when dividing by zero.
670      *
671      * CAUTION: This function is deprecated because it requires allocating memory for the error
672      * message unnecessarily. For custom revert reasons use {tryMod}.
673      *
674      * Counterpart to Solidity's `%` operator. This function uses a `revert`
675      * opcode (which leaves remaining gas untouched) while Solidity uses an
676      * invalid opcode to revert (consuming all remaining gas).
677      *
678      * Requirements:
679      *
680      * - The divisor cannot be zero.
681      */
682     function mod(
683         uint256 a,
684         uint256 b,
685         string memory errorMessage
686     ) internal pure returns (uint256) {
687         unchecked {
688             require(b > 0, errorMessage);
689             return a % b;
690         }
691     }
692 }
693 
694 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
695 
696 
697 
698 pragma solidity ^0.8.0;
699 
700 /**
701  * @dev String operations.
702  */
703 library Strings {
704     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
705 
706     /**
707      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
708      */
709     function toString(uint256 value) internal pure returns (string memory) {
710         // Inspired by OraclizeAPI's implementation - MIT licence
711         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
712 
713         if (value == 0) {
714             return "0";
715         }
716         uint256 temp = value;
717         uint256 digits;
718         while (temp != 0) {
719             digits++;
720             temp /= 10;
721         }
722         bytes memory buffer = new bytes(digits);
723         while (value != 0) {
724             digits -= 1;
725             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
726             value /= 10;
727         }
728         return string(buffer);
729     }
730 
731     /**
732      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
733      */
734     function toHexString(uint256 value) internal pure returns (string memory) {
735         if (value == 0) {
736             return "0x00";
737         }
738         uint256 temp = value;
739         uint256 length = 0;
740         while (temp != 0) {
741             length++;
742             temp >>= 8;
743         }
744         return toHexString(value, length);
745     }
746 
747     /**
748      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
749      */
750     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
751         bytes memory buffer = new bytes(2 * length + 2);
752         buffer[0] = "0";
753         buffer[1] = "x";
754         for (uint256 i = 2 * length + 1; i > 1; --i) {
755             buffer[i] = _HEX_SYMBOLS[value & 0xf];
756             value >>= 4;
757         }
758         require(value == 0, "Strings: hex length insufficient");
759         return string(buffer);
760     }
761 }
762 
763 
764 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
765 
766 
767 pragma solidity ^0.8.0;
768 
769 /**
770  * @dev Implementation of the {IERC165} interface.
771  *
772  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
773  * for the additional interface id that will be supported. For example:
774  *
775  * ```solidity
776  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
777  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
778  * }
779  * ```
780  *
781  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
782  */
783 abstract contract ERC165 is IERC165 {
784     /**
785      * @dev See {IERC165-supportsInterface}.
786      */
787     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
788         return interfaceId == type(IERC165).interfaceId;
789     }
790 }
791 
792 
793 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
794 
795 
796 pragma solidity ^0.8.0;
797 
798 
799 
800 
801 
802 
803 
804 /**
805  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
806  * the Metadata extension, but not including the Enumerable extension, which is available separately as
807  * {ERC721Enumerable}.
808  */
809 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
810     using Address for address;
811     using Strings for uint256;
812 
813     // Token name
814     string private _name;
815 
816     // Token symbol
817     string private _symbol;
818 
819     // Mapping from token ID to owner address
820     mapping(uint256 => address) private _owners;
821 
822     // Mapping owner address to token count
823     mapping(address => uint256) private _balances;
824 
825     // Mapping from token ID to approved address
826     mapping(uint256 => address) private _tokenApprovals;
827 
828     // Mapping from owner to operator approvals
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831     /**
832      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
833      */
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837     }
838 
839     /**
840      * @dev See {IERC165-supportsInterface}.
841      */
842     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
843         return
844             interfaceId == type(IERC721).interfaceId ||
845             interfaceId == type(IERC721Metadata).interfaceId ||
846             super.supportsInterface(interfaceId);
847     }
848 
849     /**
850      * @dev See {IERC721-balanceOf}.
851      */
852     function balanceOf(address owner) public view virtual override returns (uint256) {
853         require(owner != address(0), "ERC721: balance query for the zero address");
854         return _balances[owner];
855     }
856 
857     /**
858      * @dev See {IERC721-ownerOf}.
859      */
860     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
861         address owner = _owners[tokenId];
862         require(owner != address(0), "ERC721: owner query for nonexistent token");
863         return owner;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-name}.
868      */
869     function name() public view virtual override returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-symbol}.
875      */
876     function symbol() public view virtual override returns (string memory) {
877         return _symbol;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-tokenURI}.
882      */
883     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
884         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
885 
886         string memory baseURI = _baseURI();
887         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
888     }
889 
890     /**
891      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
892      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
893      * by default, can be overriden in child contracts.
894      */
895     function _baseURI() internal view virtual returns (string memory) {
896         return "";
897     }
898 
899     /**
900      * @dev See {IERC721-approve}.
901      */
902     function approve(address to, uint256 tokenId) public virtual override {
903         address owner = ERC721.ownerOf(tokenId);
904         require(to != owner, "ERC721: approval to current owner");
905 
906         require(
907             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
908             "ERC721: approve caller is not owner nor approved for all"
909         );
910 
911         _approve(to, tokenId);
912     }
913 
914     /**
915      * @dev See {IERC721-getApproved}.
916      */
917     function getApproved(uint256 tokenId) public view virtual override returns (address) {
918         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
919 
920         return _tokenApprovals[tokenId];
921     }
922 
923     /**
924      * @dev See {IERC721-setApprovalForAll}.
925      */
926     function setApprovalForAll(address operator, bool approved) public virtual override {
927         require(operator != _msgSender(), "ERC721: approve to caller");
928 
929         _operatorApprovals[_msgSender()][operator] = approved;
930         emit ApprovalForAll(_msgSender(), operator, approved);
931     }
932 
933     /**
934      * @dev See {IERC721-isApprovedForAll}.
935      */
936     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev See {IERC721-transferFrom}.
942      */
943     function transferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         //solhint-disable-next-line max-line-length
949         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
950 
951         _transfer(from, to, tokenId);
952     }
953 
954     /**
955      * @dev See {IERC721-safeTransferFrom}.
956      */
957     function safeTransferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         safeTransferFrom(from, to, tokenId, "");
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) public virtual override {
974         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
975         _safeTransfer(from, to, tokenId, _data);
976     }
977 
978     /**
979      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
980      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
981      *
982      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
983      *
984      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
985      * implement alternative mechanisms to perform token transfer, such as signature-based.
986      *
987      * Requirements:
988      *
989      * - `from` cannot be the zero address.
990      * - `to` cannot be the zero address.
991      * - `tokenId` token must exist and be owned by `from`.
992      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _safeTransfer(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) internal virtual {
1002         _transfer(from, to, tokenId);
1003         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1004     }
1005 
1006     /**
1007      * @dev Returns whether `tokenId` exists.
1008      *
1009      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1010      *
1011      * Tokens start existing when they are minted (`_mint`),
1012      * and stop existing when they are burned (`_burn`).
1013      */
1014     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1015         return _owners[tokenId] != address(0);
1016     }
1017 
1018     /**
1019      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must exist.
1024      */
1025     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1026         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1027         address owner = ERC721.ownerOf(tokenId);
1028         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1029     }
1030 
1031     /**
1032      * @dev Safely mints `tokenId` and transfers it to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must not exist.
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _safeMint(address to, uint256 tokenId) internal virtual {
1042         _safeMint(to, tokenId, "");
1043     }
1044 
1045     /**
1046      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1047      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1048      */
1049     function _safeMint(
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) internal virtual {
1054         _mint(to, tokenId);
1055         require(
1056             _checkOnERC721Received(address(0), to, tokenId, _data),
1057             "ERC721: transfer to non ERC721Receiver implementer"
1058         );
1059     }
1060 
1061     /**
1062      * @dev Mints `tokenId` and transfers it to `to`.
1063      *
1064      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must not exist.
1069      * - `to` cannot be the zero address.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(address to, uint256 tokenId) internal virtual {
1074         require(to != address(0), "ERC721: mint to the zero address");
1075         require(!_exists(tokenId), "ERC721: token already minted");
1076 
1077         _beforeTokenTransfer(address(0), to, tokenId);
1078 
1079         _balances[to] += 1;
1080         _owners[tokenId] = to;
1081 
1082         emit Transfer(address(0), to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Destroys `tokenId`.
1087      * The approval is cleared when the token is burned.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _burn(uint256 tokenId) internal virtual {
1096         address owner = ERC721.ownerOf(tokenId);
1097 
1098         _beforeTokenTransfer(owner, address(0), tokenId);
1099 
1100         // Clear approvals
1101         _approve(address(0), tokenId);
1102 
1103         _balances[owner] -= 1;
1104         delete _owners[tokenId];
1105 
1106         emit Transfer(owner, address(0), tokenId);
1107     }
1108 
1109     /**
1110      * @dev Transfers `tokenId` from `from` to `to`.
1111      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must be owned by `from`.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _transfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) internal virtual {
1125         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1126         require(to != address(0), "ERC721: transfer to the zero address");
1127 
1128         _beforeTokenTransfer(from, to, tokenId);
1129 
1130         // Clear approvals from the previous owner
1131         _approve(address(0), tokenId);
1132 
1133         _balances[from] -= 1;
1134         _balances[to] += 1;
1135         _owners[tokenId] = to;
1136 
1137         emit Transfer(from, to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Approve `to` to operate on `tokenId`
1142      *
1143      * Emits a {Approval} event.
1144      */
1145     function _approve(address to, uint256 tokenId) internal virtual {
1146         _tokenApprovals[tokenId] = to;
1147         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1148     }
1149 
1150     /**
1151      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1152      * The call is not executed if the target address is not a contract.
1153      *
1154      * @param from address representing the previous owner of the given token ID
1155      * @param to target address that will receive the tokens
1156      * @param tokenId uint256 ID of the token to be transferred
1157      * @param _data bytes optional data to send along with the call
1158      * @return bool whether the call correctly returned the expected magic value
1159      */
1160     function _checkOnERC721Received(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) private returns (bool) {
1166         if (to.isContract()) {
1167             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1168                 return retval == IERC721Receiver(to).onERC721Received.selector;
1169             } catch (bytes memory reason) {
1170                 if (reason.length == 0) {
1171                     revert("ERC721: transfer to non ERC721Receiver implementer");
1172                 } else {
1173                     assembly {
1174                         revert(add(32, reason), mload(reason))
1175                     }
1176                 }
1177             }
1178         } else {
1179             return true;
1180         }
1181     }
1182 
1183     /**
1184      * @dev Hook that is called before any token transfer. This includes minting
1185      * and burning.
1186      *
1187      * Calling conditions:
1188      *
1189      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1190      * transferred to `to`.
1191      * - When `from` is zero, `tokenId` will be minted for `to`.
1192      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1193      * - `from` and `to` are never both zero.
1194      *
1195      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1196      */
1197     function _beforeTokenTransfer(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) internal virtual {}
1202 }
1203 
1204 
1205 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1206 
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 /**
1211  * @dev Contract module which provides a basic access control mechanism, where
1212  * there is an account (an owner) that can be granted exclusive access to
1213  * specific functions.
1214  *
1215  * By default, the owner account will be the one that deploys the contract. This
1216  * can later be changed with {transferOwnership}.
1217  *
1218  * This module is used through inheritance. It will make available the modifier
1219  * `onlyOwner`, which can be applied to your functions to restrict their use to
1220  * the owner.
1221  */
1222 abstract contract Ownable is Context {
1223     address private _owner;
1224 
1225     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1226 
1227     /**
1228      * @dev Initializes the contract setting the deployer as the initial owner.
1229      */
1230     constructor() {
1231         _setOwner(_msgSender());
1232     }
1233 
1234     /**
1235      * @dev Returns the address of the current owner.
1236      */
1237     function owner() public view virtual returns (address) {
1238         return _owner;
1239     }
1240 
1241     /**
1242      * @dev Throws if called by any account other than the owner.
1243      */
1244     modifier onlyOwner() {
1245         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1246         _;
1247     }
1248 
1249     /**
1250      * @dev Leaves the contract without owner. It will not be possible to call
1251      * `onlyOwner` functions anymore. Can only be called by the current owner.
1252      *
1253      * NOTE: Renouncing ownership will leave the contract without an owner,
1254      * thereby removing any functionality that is only available to the owner.
1255      */
1256     function renounceOwnership() public virtual onlyOwner {
1257         _setOwner(address(0));
1258     }
1259 
1260     /**
1261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1262      * Can only be called by the current owner.
1263      */
1264     function transferOwnership(address newOwner) public virtual onlyOwner {
1265         require(newOwner != address(0), "Ownable: new owner is the zero address");
1266         _setOwner(newOwner);
1267     }
1268 
1269     function _setOwner(address newOwner) private {
1270         address oldOwner = _owner;
1271         _owner = newOwner;
1272         emit OwnershipTransferred(oldOwner, newOwner);
1273     }
1274 }
1275 
1276 
1277 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1278 
1279 
1280 pragma solidity ^0.8.0;
1281 
1282 /**
1283  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1284  * @dev See https://eips.ethereum.org/EIPS/eip-721
1285  */
1286 interface IERC721Enumerable is IERC721 {
1287     /**
1288      * @dev Returns the total amount of tokens stored by the contract.
1289      */
1290     function totalSupply() external view returns (uint256);
1291 
1292     /**
1293      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1294      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1295      */
1296     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1297 
1298     /**
1299      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1300      * Use along with {totalSupply} to enumerate all tokens.
1301      */
1302     function tokenByIndex(uint256 index) external view returns (uint256);
1303 }
1304 
1305 
1306 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1307 
1308 
1309 pragma solidity ^0.8.0;
1310 
1311 
1312 /**
1313  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1314  * enumerability of all the token ids in the contract as well as all token ids owned by each
1315  * account.
1316  */
1317 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1318     // Mapping from owner to list of owned token IDs
1319     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1320 
1321     // Mapping from token ID to index of the owner tokens list
1322     mapping(uint256 => uint256) private _ownedTokensIndex;
1323 
1324     // Array with all token ids, used for enumeration
1325     uint256[] private _allTokens;
1326 
1327     // Mapping from token id to position in the allTokens array
1328     mapping(uint256 => uint256) private _allTokensIndex;
1329 
1330     /**
1331      * @dev See {IERC165-supportsInterface}.
1332      */
1333     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1334         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1335     }
1336 
1337     /**
1338      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1339      */
1340     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1341         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1342         return _ownedTokens[owner][index];
1343     }
1344 
1345     /**
1346      * @dev See {IERC721Enumerable-totalSupply}.
1347      */
1348     function totalSupply() public view virtual override returns (uint256) {
1349         return _allTokens.length;
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Enumerable-tokenByIndex}.
1354      */
1355     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1356         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1357         return _allTokens[index];
1358     }
1359 
1360     /**
1361      * @dev Hook that is called before any token transfer. This includes minting
1362      * and burning.
1363      *
1364      * Calling conditions:
1365      *
1366      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1367      * transferred to `to`.
1368      * - When `from` is zero, `tokenId` will be minted for `to`.
1369      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1370      * - `from` cannot be the zero address.
1371      * - `to` cannot be the zero address.
1372      *
1373      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1374      */
1375     function _beforeTokenTransfer(
1376         address from,
1377         address to,
1378         uint256 tokenId
1379     ) internal virtual override {
1380         super._beforeTokenTransfer(from, to, tokenId);
1381 
1382         if (from == address(0)) {
1383             _addTokenToAllTokensEnumeration(tokenId);
1384         } else if (from != to) {
1385             _removeTokenFromOwnerEnumeration(from, tokenId);
1386         }
1387         if (to == address(0)) {
1388             _removeTokenFromAllTokensEnumeration(tokenId);
1389         } else if (to != from) {
1390             _addTokenToOwnerEnumeration(to, tokenId);
1391         }
1392     }
1393 
1394     /**
1395      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1396      * @param to address representing the new owner of the given token ID
1397      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1398      */
1399     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1400         uint256 length = ERC721.balanceOf(to);
1401         _ownedTokens[to][length] = tokenId;
1402         _ownedTokensIndex[tokenId] = length;
1403     }
1404 
1405     /**
1406      * @dev Private function to add a token to this extension's token tracking data structures.
1407      * @param tokenId uint256 ID of the token to be added to the tokens list
1408      */
1409     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1410         _allTokensIndex[tokenId] = _allTokens.length;
1411         _allTokens.push(tokenId);
1412     }
1413 
1414     /**
1415      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1416      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1417      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1418      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1419      * @param from address representing the previous owner of the given token ID
1420      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1421      */
1422     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1423         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1424         // then delete the last slot (swap and pop).
1425 
1426         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1427         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1428 
1429         // When the token to delete is the last token, the swap operation is unnecessary
1430         if (tokenIndex != lastTokenIndex) {
1431             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1432 
1433             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1434             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1435         }
1436 
1437         // This also deletes the contents at the last position of the array
1438         delete _ownedTokensIndex[tokenId];
1439         delete _ownedTokens[from][lastTokenIndex];
1440     }
1441 
1442     /**
1443      * @dev Private function to remove a token from this extension's token tracking data structures.
1444      * This has O(1) time complexity, but alters the order of the _allTokens array.
1445      * @param tokenId uint256 ID of the token to be removed from the tokens list
1446      */
1447     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1448         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1449         // then delete the last slot (swap and pop).
1450 
1451         uint256 lastTokenIndex = _allTokens.length - 1;
1452         uint256 tokenIndex = _allTokensIndex[tokenId];
1453 
1454         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1455         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1456         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1457         uint256 lastTokenId = _allTokens[lastTokenIndex];
1458 
1459         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1460         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1461 
1462         // This also deletes the contents at the last position of the array
1463         delete _allTokensIndex[tokenId];
1464         _allTokens.pop();
1465     }
1466 }
1467 
1468 
1469 // File contracts/DZI.sol
1470 
1471 
1472 pragma solidity ^0.8.0;
1473 
1474 
1475 
1476 contract TheBrainiacs is ERC721, ERC721Enumerable, Ownable {
1477 
1478     using Strings for uint256;
1479 
1480     string public PROVENANCE;
1481     uint256 public constant tokenPrice = 80000000000000000; // 0.08 ETH
1482     uint public constant maxPresalePurchase = 4;
1483     uint public constant maxTokenPurchase = 8;
1484     uint public constant maxTokenPerWallet = 8888;
1485     uint256 public MAX_TOKENS = 8888;
1486     bool public saleIsActive = false;
1487     bool public preSaleIsActive = false;
1488     bool public revealed = false;
1489     string public notRevealedUri;
1490     string public baseExtension = ".json";
1491     string private _baseURIextended;
1492     // WhiteLists for presale.
1493     mapping (address => bool) private _isWhiteListed;
1494     mapping (address => uint) private _numberOfWallets;
1495     
1496     event AddWhiteListWallet(address _wallet );
1497     event RemoveWhiteListWallet(address _wallet );
1498     
1499     constructor(
1500 
1501     ) ERC721("The Brainiacs", "TB") {
1502 
1503     }
1504 
1505     function reveal() public onlyOwner {
1506         revealed = true;
1507     }
1508 
1509     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1510         notRevealedUri = _notRevealedURI;
1511     }
1512 
1513     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1514         super._beforeTokenTransfer(from, to, tokenId);
1515     }
1516 
1517     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1518         return super.supportsInterface(interfaceId);
1519     }
1520 
1521     function setBaseURI(string memory baseURI_) external onlyOwner() {
1522         _baseURIextended = baseURI_;
1523     }
1524 
1525     function _baseURI() internal view virtual override returns (string memory) {
1526         return _baseURIextended;
1527     }
1528 
1529     function setProvenance(string memory provenance) public onlyOwner {
1530         PROVENANCE = provenance;
1531     }
1532 
1533     function tokenURI(uint256 tokenId)
1534         public
1535         view
1536         virtual
1537         override
1538         returns (string memory)
1539     {
1540         require(
1541         _exists(tokenId),
1542         "ERC721Metadata: URI query for nonexistent token"
1543         );
1544         
1545         if(revealed == false) {
1546             return notRevealedUri;
1547         }
1548 
1549         string memory currentBaseURI = _baseURI();
1550         return bytes(currentBaseURI).length > 0
1551             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1552             : "";
1553     }
1554 
1555     // Reserve 100 Brainiacs for team & community (Used in giveaways, promotions etc...)
1556 
1557 
1558     function reserveTokens() public onlyOwner {
1559         uint supply = totalSupply();
1560         require(supply < 100, "More than 100 tokens have already been reserved or minted.");
1561         uint i;
1562         for (i = 0; i < 100; i++) {
1563             _safeMint(msg.sender, supply + i);
1564         }
1565     }
1566 
1567     function flipSaleState() public onlyOwner {
1568         saleIsActive = !saleIsActive;
1569     }
1570 
1571     function flipPreSaleState() public onlyOwner {
1572         preSaleIsActive = !preSaleIsActive;
1573     }
1574 
1575     function addWhiteListWallet (address _wallet) public onlyOwner {
1576         _isWhiteListed[_wallet] = true;
1577         emit AddWhiteListWallet(_wallet);
1578     }
1579     
1580     function removeWhiteListWallet (address _wallet) public onlyOwner {
1581         _isWhiteListed[_wallet] = false;
1582         emit RemoveWhiteListWallet(_wallet);
1583     }
1584     
1585     function preSaleToken(uint numberOfTokens) public payable {
1586         require(preSaleIsActive, "PreSale must be active to mint");
1587         require(!saleIsActive, "Could not pre-mint after sale is active");
1588         require(numberOfTokens <= maxPresalePurchase, "Exceeded max presale purchase");
1589         require(_numberOfWallets[msg.sender] + numberOfTokens <= maxPresalePurchase, "Exceeded max presale purchase per wallet");
1590         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Purchase would exceed max supply");
1591         require(tokenPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1592         
1593         for(uint i = 0; i < numberOfTokens; i++) {
1594             uint mintIndex = totalSupply();
1595             if (totalSupply() < MAX_TOKENS) {
1596                 _safeMint(msg.sender, mintIndex);
1597             }
1598         }
1599         
1600         _numberOfWallets[msg.sender] = _numberOfWallets[msg.sender] + numberOfTokens;
1601     }
1602     
1603     function mintToken(uint numberOfTokens) public payable {
1604         require(saleIsActive, "Sale must be active to mint");
1605         require(numberOfTokens <= maxTokenPurchase, "Exceeded max token purchase");
1606         require(_numberOfWallets[msg.sender] + numberOfTokens <= maxTokenPurchase, "Exceeded max token purchase per wallet");
1607         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Purchase would exceed max supply");
1608         require(tokenPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1609 
1610         for(uint i = 0; i < numberOfTokens; i++) {
1611             uint mintIndex = totalSupply();
1612             if (totalSupply() < MAX_TOKENS) {
1613                 _safeMint(msg.sender, mintIndex);
1614             }
1615         }
1616         _numberOfWallets[msg.sender] = _numberOfWallets[msg.sender] + numberOfTokens;
1617     }
1618 
1619     // Update dev address by the previous dev.
1620 
1621     function withdraw() public onlyOwner {
1622         uint256 balance = address(this).balance;
1623         payable(msg.sender).transfer(balance);
1624     }
1625 
1626 }