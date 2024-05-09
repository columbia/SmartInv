1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 
30 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
31 
32 pragma solidity ^0.8.0;
33 /**
34  * @dev Implementation of the {IERC165} interface.
35  *
36  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
37  * for the additional interface id that will be supported. For example:
38  *
39  * ```solidity
40  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
41  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
42  * }
43  * ```
44  *
45  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
46  */
47 abstract contract ERC165 is IERC165 {
48     /**
49      * @dev See {IERC165-supportsInterface}.
50      */
51     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
52         return interfaceId == type(IERC165).interfaceId;
53     }
54 }
55 
56 pragma solidity ^0.8.0;
57 /**
58  * @dev Required interface of an ERC721 compliant contract.
59  */
60 interface IERC721 is IERC165 {
61     /**
62      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
65 
66     /**
67      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
68      */
69     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
70 
71     /**
72      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
73      */
74     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
75 
76     /**
77      * @dev Returns the number of tokens in ``owner``'s account.
78      */
79     function balanceOf(address owner) external view returns (uint256 balance);
80 
81     /**
82      * @dev Returns the owner of the `tokenId` token.
83      *
84      * Requirements:
85      *
86      * - `tokenId` must exist.
87      */
88     function ownerOf(uint256 tokenId) external view returns (address owner);
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Returns the account approved for `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function getApproved(uint256 tokenId) external view returns (address operator);
153 
154     /**
155      * @dev Approve or remove `operator` as an operator for the caller.
156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
157      *
158      * Requirements:
159      *
160      * - The `operator` cannot be the caller.
161      *
162      * Emits an {ApprovalForAll} event.
163      */
164     function setApprovalForAll(address operator, bool _approved) external;
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 
173     /**
174      * @dev Safely transfers `tokenId` token from `from` to `to`.
175      *
176      * Requirements:
177      *
178      * - `from` cannot be the zero address.
179      * - `to` cannot be the zero address.
180      * - `tokenId` token must exist and be owned by `from`.
181      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183      *
184      * Emits a {Transfer} event.
185      */
186     function safeTransferFrom(
187         address from,
188         address to,
189         uint256 tokenId,
190         bytes calldata data
191     ) external;
192 }
193 
194 
195 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
196 
197 pragma solidity ^0.8.0;
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Metadata is IERC721 {
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
220 
221 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
222 
223 
224 
225 pragma solidity ^0.8.0;
226 // CAUTION
227 // This version of SafeMath should only be used with Solidity 0.8 or later,
228 // because it relies on the compiler's built in overflow checks.
229 
230 /**
231  * @dev Wrappers over Solidity's arithmetic operations.
232  *
233  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
234  * now has built in overflow checking.
235  */
236 library SafeMath {
237     /**
238      * @dev Returns the addition of two unsigned integers, with an overflow flag.
239      *
240      * _Available since v3.4._
241      */
242     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
243         unchecked {
244             uint256 c = a + b;
245             if (c < a) return (false, 0);
246             return (true, c);
247         }
248     }
249 
250     /**
251      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
252      *
253      * _Available since v3.4._
254      */
255     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             if (b > a) return (false, 0);
258             return (true, a - b);
259         }
260     }
261 
262     /**
263      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
264      *
265      * _Available since v3.4._
266      */
267     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
270             // benefit is lost if 'b' is also tested.
271             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
272             if (a == 0) return (true, 0);
273             uint256 c = a * b;
274             if (c / a != b) return (false, 0);
275             return (true, c);
276         }
277     }
278 
279     /**
280      * @dev Returns the division of two unsigned integers, with a division by zero flag.
281      *
282      * _Available since v3.4._
283      */
284     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (b == 0) return (false, 0);
287             return (true, a / b);
288         }
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
293      *
294      * _Available since v3.4._
295      */
296     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
297         unchecked {
298             if (b == 0) return (false, 0);
299             return (true, a % b);
300         }
301     }
302 
303     /**
304      * @dev Returns the addition of two unsigned integers, reverting on
305      * overflow.
306      *
307      * Counterpart to Solidity's `+` operator.
308      *
309      * Requirements:
310      *
311      * - Addition cannot overflow.
312      */
313     function add(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a + b;
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting on
319      * overflow (when the result is negative).
320      *
321      * Counterpart to Solidity's `-` operator.
322      *
323      * Requirements:
324      *
325      * - Subtraction cannot overflow.
326      */
327     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
328         return a - b;
329     }
330 
331     /**
332      * @dev Returns the multiplication of two unsigned integers, reverting on
333      * overflow.
334      *
335      * Counterpart to Solidity's `*` operator.
336      *
337      * Requirements:
338      *
339      * - Multiplication cannot overflow.
340      */
341     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
342         return a * b;
343     }
344 
345     /**
346      * @dev Returns the integer division of two unsigned integers, reverting on
347      * division by zero. The result is rounded towards zero.
348      *
349      * Counterpart to Solidity's `/` operator.
350      *
351      * Requirements:
352      *
353      * - The divisor cannot be zero.
354      */
355     function div(uint256 a, uint256 b) internal pure returns (uint256) {
356         return a / b;
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
361      * reverting when dividing by zero.
362      *
363      * Counterpart to Solidity's `%` operator. This function uses a `revert`
364      * opcode (which leaves remaining gas untouched) while Solidity uses an
365      * invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
372         return a % b;
373     }
374 
375     /**
376      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
377      * overflow (when the result is negative).
378      *
379      * CAUTION: This function is deprecated because it requires allocating memory for the error
380      * message unnecessarily. For custom revert reasons use {trySub}.
381      *
382      * Counterpart to Solidity's `-` operator.
383      *
384      * Requirements:
385      *
386      * - Subtraction cannot overflow.
387      */
388     function sub(
389         uint256 a,
390         uint256 b,
391         string memory errorMessage
392     ) internal pure returns (uint256) {
393         unchecked {
394             require(b <= a, errorMessage);
395             return a - b;
396         }
397     }
398 
399     /**
400      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
401      * division by zero. The result is rounded towards zero.
402      *
403      * Counterpart to Solidity's `/` operator. Note: this function uses a
404      * `revert` opcode (which leaves remaining gas untouched) while Solidity
405      * uses an invalid opcode to revert (consuming all remaining gas).
406      *
407      * Requirements:
408      *
409      * - The divisor cannot be zero.
410      */
411     function div(
412         uint256 a,
413         uint256 b,
414         string memory errorMessage
415     ) internal pure returns (uint256) {
416         unchecked {
417             require(b > 0, errorMessage);
418             return a / b;
419         }
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
424      * reverting with custom message when dividing by zero.
425      *
426      * CAUTION: This function is deprecated because it requires allocating memory for the error
427      * message unnecessarily. For custom revert reasons use {tryMod}.
428      *
429      * Counterpart to Solidity's `%` operator. This function uses a `revert`
430      * opcode (which leaves remaining gas untouched) while Solidity uses an
431      * invalid opcode to revert (consuming all remaining gas).
432      *
433      * Requirements:
434      *
435      * - The divisor cannot be zero.
436      */
437     function mod(
438         uint256 a,
439         uint256 b,
440         string memory errorMessage
441     ) internal pure returns (uint256) {
442         unchecked {
443             require(b > 0, errorMessage);
444             return a % b;
445         }
446     }
447 }
448 
449 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
450 
451 
452 
453 pragma solidity ^0.8.0;
454 
455 
456 /**
457  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
458  * @dev See https://eips.ethereum.org/EIPS/eip-721
459  */
460 interface IERC721Enumerable is IERC721 {
461     /**
462      * @dev Returns the total amount of tokens stored by the contract.
463      */
464     function totalSupply() external view returns (uint256);
465 
466     /**
467      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
468      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
469      */
470     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
471 
472     /**
473      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
474      * Use along with {totalSupply} to enumerate all tokens.
475      */
476     function tokenByIndex(uint256 index) external view returns (uint256);
477 }
478 
479 
480 
481 // File: @openzeppelin/contracts/utils/Strings.sol
482 pragma solidity ^0.8.0;
483 /**
484  * @dev String operations.
485  */
486 library Strings {
487     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
491      */
492     function toString(uint256 value) internal pure returns (string memory) {
493         // Inspired by OraclizeAPI's implementation - MIT licence
494         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
495 
496         if (value == 0) {
497             return "0";
498         }
499         uint256 temp = value;
500         uint256 digits;
501         while (temp != 0) {
502             digits++;
503             temp /= 10;
504         }
505         bytes memory buffer = new bytes(digits);
506         while (value != 0) {
507             digits -= 1;
508             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
509             value /= 10;
510         }
511         return string(buffer);
512     }
513 
514     /**
515      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
516      */
517     function toHexString(uint256 value) internal pure returns (string memory) {
518         if (value == 0) {
519             return "0x00";
520         }
521         uint256 temp = value;
522         uint256 length = 0;
523         while (temp != 0) {
524             length++;
525             temp >>= 8;
526         }
527         return toHexString(value, length);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
532      */
533     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
534         bytes memory buffer = new bytes(2 * length + 2);
535         buffer[0] = "0";
536         buffer[1] = "x";
537         for (uint256 i = 2 * length + 1; i > 1; --i) {
538             buffer[i] = _HEX_SYMBOLS[value & 0xf];
539             value >>= 4;
540         }
541         require(value == 0, "Strings: hex length insufficient");
542         return string(buffer);
543     }
544 }
545 
546 // File: @openzeppelin/contracts/utils/Address.sol
547 
548 
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev Collection of functions related to the address type
554  */
555 library Address {
556     /**
557      * @dev Returns true if `account` is a contract.
558      *
559      * [IMPORTANT]
560      * ====
561      * It is unsafe to assume that an address for which this function returns
562      * false is an externally-owned account (EOA) and not a contract.
563      *
564      * Among others, `isContract` will return false for the following
565      * types of addresses:
566      *
567      *  - an externally-owned account
568      *  - a contract in construction
569      *  - an address where a contract will be created
570      *  - an address where a contract lived, but was destroyed
571      * ====
572      */
573     function isContract(address account) internal view returns (bool) {
574         // This method relies on extcodesize, which returns 0 for contracts in
575         // construction, since the code is only stored at the end of the
576         // constructor execution.
577 
578         uint256 size;
579         assembly {
580             size := extcodesize(account)
581         }
582         return size > 0;
583     }
584 
585     /**
586      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
587      * `recipient`, forwarding all available gas and reverting on errors.
588      *
589      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
590      * of certain opcodes, possibly making contracts go over the 2300 gas limit
591      * imposed by `transfer`, making them unable to receive funds via
592      * `transfer`. {sendValue} removes this limitation.
593      *
594      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
595      *
596      * IMPORTANT: because control is transferred to `recipient`, care must be
597      * taken to not create reentrancy vulnerabilities. Consider using
598      * {ReentrancyGuard} or the
599      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
600      */
601     function sendValue(address payable recipient, uint256 amount) internal {
602         require(address(this).balance >= amount, "Address: insufficient balance");
603 
604         (bool success, ) = recipient.call{value: amount}("");
605         require(success, "Address: unable to send value, recipient may have reverted");
606     }
607 
608     /**
609      * @dev Performs a Solidity function call using a low level `call`. A
610      * plain `call` is an unsafe replacement for a function call: use this
611      * function instead.
612      *
613      * If `target` reverts with a revert reason, it is bubbled up by this
614      * function (like regular Solidity function calls).
615      *
616      * Returns the raw returned data. To convert to the expected return value,
617      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
618      *
619      * Requirements:
620      *
621      * - `target` must be a contract.
622      * - calling `target` with `data` must not revert.
623      *
624      * _Available since v3.1._
625      */
626     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
627         return functionCall(target, data, "Address: low-level call failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
632      * `errorMessage` as a fallback revert reason when `target` reverts.
633      *
634      * _Available since v3.1._
635      */
636     function functionCall(
637         address target,
638         bytes memory data,
639         string memory errorMessage
640     ) internal returns (bytes memory) {
641         return functionCallWithValue(target, data, 0, errorMessage);
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
646      * but also transferring `value` wei to `target`.
647      *
648      * Requirements:
649      *
650      * - the calling contract must have an ETH balance of at least `value`.
651      * - the called Solidity function must be `payable`.
652      *
653      * _Available since v3.1._
654      */
655     function functionCallWithValue(
656         address target,
657         bytes memory data,
658         uint256 value
659     ) internal returns (bytes memory) {
660         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
665      * with `errorMessage` as a fallback revert reason when `target` reverts.
666      *
667      * _Available since v3.1._
668      */
669     function functionCallWithValue(
670         address target,
671         bytes memory data,
672         uint256 value,
673         string memory errorMessage
674     ) internal returns (bytes memory) {
675         require(address(this).balance >= value, "Address: insufficient balance for call");
676         require(isContract(target), "Address: call to non-contract");
677 
678         (bool success, bytes memory returndata) = target.call{value: value}(data);
679         return verifyCallResult(success, returndata, errorMessage);
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
684      * but performing a static call.
685      *
686      * _Available since v3.3._
687      */
688     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
689         return functionStaticCall(target, data, "Address: low-level static call failed");
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
694      * but performing a static call.
695      *
696      * _Available since v3.3._
697      */
698     function functionStaticCall(
699         address target,
700         bytes memory data,
701         string memory errorMessage
702     ) internal view returns (bytes memory) {
703         require(isContract(target), "Address: static call to non-contract");
704 
705         (bool success, bytes memory returndata) = target.staticcall(data);
706         return verifyCallResult(success, returndata, errorMessage);
707     }
708 
709     /**
710      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
711      * but performing a delegate call.
712      *
713      * _Available since v3.4._
714      */
715     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
716         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
717     }
718 
719     /**
720      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
721      * but performing a delegate call.
722      *
723      * _Available since v3.4._
724      */
725     function functionDelegateCall(
726         address target,
727         bytes memory data,
728         string memory errorMessage
729     ) internal returns (bytes memory) {
730         require(isContract(target), "Address: delegate call to non-contract");
731 
732         (bool success, bytes memory returndata) = target.delegatecall(data);
733         return verifyCallResult(success, returndata, errorMessage);
734     }
735 
736     /**
737      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
738      * revert reason using the provided one.
739      *
740      * _Available since v4.3._
741      */
742     function verifyCallResult(
743         bool success,
744         bytes memory returndata,
745         string memory errorMessage
746     ) internal pure returns (bytes memory) {
747         if (success) {
748             return returndata;
749         } else {
750             // Look for revert reason and bubble it up if present
751             if (returndata.length > 0) {
752                 // The easiest way to bubble the revert reason is using memory via assembly
753 
754                 assembly {
755                     let returndata_size := mload(returndata)
756                     revert(add(32, returndata), returndata_size)
757                 }
758             } else {
759                 revert(errorMessage);
760             }
761         }
762     }
763 }
764 
765 
766 
767 
768 pragma solidity ^0.8.0;
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
792 
793 
794 // File: @openzeppelin/contracts/utils/Context.sol
795 pragma solidity ^0.8.0;
796 /**
797  * @dev Provides information about the current execution context, including the
798  * sender of the transaction and its data. While these are generally available
799  * via msg.sender and msg.data, they should not be accessed in such a direct
800  * manner, since when dealing with meta-transactions the account sending and
801  * paying for execution may not be the actual sender (as far as an application
802  * is concerned).
803  *
804  * This contract is only required for intermediate, library-like contracts.
805  */
806 abstract contract Context {
807     function _msgSender() internal view virtual returns (address) {
808         return msg.sender;
809     }
810 
811     function _msgData() internal view virtual returns (bytes calldata) {
812         return msg.data;
813     }
814 }
815 
816 
817 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
818 pragma solidity ^0.8.0;
819 /**
820  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
821  * the Metadata extension, but not including the Enumerable extension, which is available separately as
822  * {ERC721Enumerable}.
823  */
824 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
825     using Address for address;
826     using Strings for uint256;
827 
828     // Token name
829     string private _name;
830 
831     // Token symbol
832     string private _symbol;
833 
834     // Mapping from token ID to owner address
835     mapping(uint256 => address) private _owners;
836 
837     // Mapping owner address to token count
838     mapping(address => uint256) private _balances;
839 
840     // Mapping from token ID to approved address
841     mapping(uint256 => address) private _tokenApprovals;
842 
843     // Mapping from owner to operator approvals
844     mapping(address => mapping(address => bool)) private _operatorApprovals;
845 
846     /**
847      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
848      */
849     constructor(string memory name_, string memory symbol_) {
850         _name = name_;
851         _symbol = symbol_;
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
858         return
859             interfaceId == type(IERC721).interfaceId ||
860             interfaceId == type(IERC721Metadata).interfaceId ||
861             super.supportsInterface(interfaceId);
862     }
863 
864     /**
865      * @dev See {IERC721-balanceOf}.
866      */
867     function balanceOf(address owner) public view virtual override returns (uint256) {
868         require(owner != address(0), "ERC721: balance query for the zero address");
869         return _balances[owner];
870     }
871 
872     /**
873      * @dev See {IERC721-ownerOf}.
874      */
875     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
876         address owner = _owners[tokenId];
877         require(owner != address(0), "ERC721: owner query for nonexistent token");
878         return owner;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-name}.
883      */
884     function name() public view virtual override returns (string memory) {
885         return _name;
886     }
887 
888     /**
889      * @dev See {IERC721Metadata-symbol}.
890      */
891     function symbol() public view virtual override returns (string memory) {
892         return _symbol;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-tokenURI}.
897      */
898     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
899         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
900 
901         string memory baseURI = _baseURI();
902         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
903     }
904 
905     /**
906      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
907      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
908      * by default, can be overriden in child contracts.
909      */
910     function _baseURI() internal view virtual returns (string memory) {
911         return "";
912     }
913 
914     /**
915      * @dev See {IERC721-approve}.
916      */
917     function approve(address to, uint256 tokenId) public virtual override {
918         address owner = ERC721.ownerOf(tokenId);
919         require(to != owner, "ERC721: approval to current owner");
920 
921         require(
922             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
923             "ERC721: approve caller is not owner nor approved for all"
924         );
925 
926         _approve(to, tokenId);
927     }
928 
929     /**
930      * @dev See {IERC721-getApproved}.
931      */
932     function getApproved(uint256 tokenId) public view virtual override returns (address) {
933         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
934 
935         return _tokenApprovals[tokenId];
936     }
937 
938     /**
939      * @dev See {IERC721-setApprovalForAll}.
940      */
941     function setApprovalForAll(address operator, bool approved) public virtual override {
942         require(operator != _msgSender(), "ERC721: approve to caller");
943 
944         _operatorApprovals[_msgSender()][operator] = approved;
945         emit ApprovalForAll(_msgSender(), operator, approved);
946     }
947 
948     /**
949      * @dev See {IERC721-isApprovedForAll}.
950      */
951     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
952         return _operatorApprovals[owner][operator];
953     }
954 
955     /**
956      * @dev See {IERC721-transferFrom}.
957      */
958     function transferFrom(
959         address from,
960         address to,
961         uint256 tokenId
962     ) public virtual override {
963         //solhint-disable-next-line max-line-length
964         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
965 
966         _transfer(from, to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         safeTransferFrom(from, to, tokenId, "");
978     }
979 
980     /**
981      * @dev See {IERC721-safeTransferFrom}.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) public virtual override {
989         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
990         _safeTransfer(from, to, tokenId, _data);
991     }
992 
993     /**
994      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
995      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
996      *
997      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
998      *
999      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1000      * implement alternative mechanisms to perform token transfer, such as signature-based.
1001      *
1002      * Requirements:
1003      *
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must exist and be owned by `from`.
1007      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _safeTransfer(
1012         address from,
1013         address to,
1014         uint256 tokenId,
1015         bytes memory _data
1016     ) internal virtual {
1017         _transfer(from, to, tokenId);
1018         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1019     }
1020 
1021     /**
1022      * @dev Returns whether `tokenId` exists.
1023      *
1024      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1025      *
1026      * Tokens start existing when they are minted (`_mint`),
1027      * and stop existing when they are burned (`_burn`).
1028      */
1029     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1030         return _owners[tokenId] != address(0);
1031     }
1032 
1033     /**
1034      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1035      *
1036      * Requirements:
1037      *
1038      * - `tokenId` must exist.
1039      */
1040     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1041         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1042         address owner = ERC721.ownerOf(tokenId);
1043         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1044     }
1045 
1046     /**
1047      * @dev Safely mints `tokenId` and transfers it to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must not exist.
1052      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _safeMint(address to, uint256 tokenId) internal virtual {
1057         _safeMint(to, tokenId, "");
1058     }
1059 
1060     /**
1061      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1062      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1063      */
1064     function _safeMint(
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) internal virtual {
1069         _mint(to, tokenId);
1070         require(
1071             _checkOnERC721Received(address(0), to, tokenId, _data),
1072             "ERC721: transfer to non ERC721Receiver implementer"
1073         );
1074     }
1075 
1076     /**
1077      * @dev Mints `tokenId` and transfers it to `to`.
1078      *
1079      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must not exist.
1084      * - `to` cannot be the zero address.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _mint(address to, uint256 tokenId) internal virtual {
1089         require(to != address(0), "ERC721: mint to the zero address");
1090         require(!_exists(tokenId), "ERC721: token already minted");
1091 
1092         _beforeTokenTransfer(address(0), to, tokenId);
1093 
1094         _balances[to] += 1;
1095         _owners[tokenId] = to;
1096 
1097         emit Transfer(address(0), to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev Destroys `tokenId`.
1102      * The approval is cleared when the token is burned.
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must exist.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _burn(uint256 tokenId) internal virtual {
1111         address owner = ERC721.ownerOf(tokenId);
1112 
1113         _beforeTokenTransfer(owner, address(0), tokenId);
1114 
1115         // Clear approvals
1116         _approve(address(0), tokenId);
1117 
1118         _balances[owner] -= 1;
1119         delete _owners[tokenId];
1120 
1121         emit Transfer(owner, address(0), tokenId);
1122     }
1123 
1124     /**
1125      * @dev Transfers `tokenId` from `from` to `to`.
1126      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1127      *
1128      * Requirements:
1129      *
1130      * - `to` cannot be the zero address.
1131      * - `tokenId` token must be owned by `from`.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _transfer(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) internal virtual {
1140         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1141         require(to != address(0), "ERC721: transfer to the zero address");
1142 
1143         _beforeTokenTransfer(from, to, tokenId);
1144 
1145         // Clear approvals from the previous owner
1146         _approve(address(0), tokenId);
1147 
1148         _balances[from] -= 1;
1149         _balances[to] += 1;
1150         _owners[tokenId] = to;
1151 
1152         emit Transfer(from, to, tokenId);
1153     }
1154 
1155     /**
1156      * @dev Approve `to` to operate on `tokenId`
1157      *
1158      * Emits a {Approval} event.
1159      */
1160     function _approve(address to, uint256 tokenId) internal virtual {
1161         _tokenApprovals[tokenId] = to;
1162         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1167      * The call is not executed if the target address is not a contract.
1168      *
1169      * @param from address representing the previous owner of the given token ID
1170      * @param to target address that will receive the tokens
1171      * @param tokenId uint256 ID of the token to be transferred
1172      * @param _data bytes optional data to send along with the call
1173      * @return bool whether the call correctly returned the expected magic value
1174      */
1175     function _checkOnERC721Received(
1176         address from,
1177         address to,
1178         uint256 tokenId,
1179         bytes memory _data
1180     ) private returns (bool) {
1181         if (to.isContract()) {
1182             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1183                 return retval == IERC721Receiver.onERC721Received.selector;
1184             } catch (bytes memory reason) {
1185                 if (reason.length == 0) {
1186                     revert("ERC721: transfer to non ERC721Receiver implementer");
1187                 } else {
1188                     assembly {
1189                         revert(add(32, reason), mload(reason))
1190                     }
1191                 }
1192             }
1193         } else {
1194             return true;
1195         }
1196     }
1197 
1198     /**
1199      * @dev Hook that is called before any token transfer. This includes minting
1200      * and burning.
1201      *
1202      * Calling conditions:
1203      *
1204      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1205      * transferred to `to`.
1206      * - When `from` is zero, `tokenId` will be minted for `to`.
1207      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1208      * - `from` and `to` are never both zero.
1209      *
1210      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1211      */
1212     function _beforeTokenTransfer(
1213         address from,
1214         address to,
1215         uint256 tokenId
1216     ) internal virtual {}
1217 }
1218 
1219 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1220 
1221 
1222 
1223 pragma solidity ^0.8.0;
1224 /**
1225  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1226  * enumerability of all the token ids in the contract as well as all token ids owned by each
1227  * account.
1228  */
1229 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1230     // Mapping from owner to list of owned token IDs
1231     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1232 
1233     // Mapping from token ID to index of the owner tokens list
1234     mapping(uint256 => uint256) private _ownedTokensIndex;
1235 
1236     // Array with all token ids, used for enumeration
1237     uint256[] private _allTokens;
1238 
1239     // Mapping from token id to position in the allTokens array
1240     mapping(uint256 => uint256) private _allTokensIndex;
1241 
1242     /**
1243      * @dev See {IERC165-supportsInterface}.
1244      */
1245     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1246         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1247     }
1248 
1249     /**
1250      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1251      */
1252     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1253         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1254         return _ownedTokens[owner][index];
1255     }
1256 
1257     /**
1258      * @dev See {IERC721Enumerable-totalSupply}.
1259      */
1260     function totalSupply() public view virtual override returns (uint256) {
1261         return _allTokens.length;
1262     }
1263 
1264     /**
1265      * @dev See {IERC721Enumerable-tokenByIndex}.
1266      */
1267     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1268         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1269         return _allTokens[index];
1270     }
1271 
1272     /**
1273      * @dev Hook that is called before any token transfer. This includes minting
1274      * and burning.
1275      *
1276      * Calling conditions:
1277      *
1278      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1279      * transferred to `to`.
1280      * - When `from` is zero, `tokenId` will be minted for `to`.
1281      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1282      * - `from` cannot be the zero address.
1283      * - `to` cannot be the zero address.
1284      *
1285      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1286      */
1287     function _beforeTokenTransfer(
1288         address from,
1289         address to,
1290         uint256 tokenId
1291     ) internal virtual override {
1292         super._beforeTokenTransfer(from, to, tokenId);
1293 
1294         if (from == address(0)) {
1295             _addTokenToAllTokensEnumeration(tokenId);
1296         } else if (from != to) {
1297             _removeTokenFromOwnerEnumeration(from, tokenId);
1298         }
1299         if (to == address(0)) {
1300             _removeTokenFromAllTokensEnumeration(tokenId);
1301         } else if (to != from) {
1302             _addTokenToOwnerEnumeration(to, tokenId);
1303         }
1304     }
1305 
1306     /**
1307      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1308      * @param to address representing the new owner of the given token ID
1309      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1310      */
1311     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1312         uint256 length = ERC721.balanceOf(to);
1313         _ownedTokens[to][length] = tokenId;
1314         _ownedTokensIndex[tokenId] = length;
1315     }
1316 
1317     /**
1318      * @dev Private function to add a token to this extension's token tracking data structures.
1319      * @param tokenId uint256 ID of the token to be added to the tokens list
1320      */
1321     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1322         _allTokensIndex[tokenId] = _allTokens.length;
1323         _allTokens.push(tokenId);
1324     }
1325 
1326     /**
1327      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1328      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1329      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1330      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1331      * @param from address representing the previous owner of the given token ID
1332      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1333      */
1334     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1335         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1336         // then delete the last slot (swap and pop).
1337 
1338         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1339         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1340 
1341         // When the token to delete is the last token, the swap operation is unnecessary
1342         if (tokenIndex != lastTokenIndex) {
1343             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1344 
1345             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1346             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1347         }
1348 
1349         // This also deletes the contents at the last position of the array
1350         delete _ownedTokensIndex[tokenId];
1351         delete _ownedTokens[from][lastTokenIndex];
1352     }
1353 
1354     /**
1355      * @dev Private function to remove a token from this extension's token tracking data structures.
1356      * This has O(1) time complexity, but alters the order of the _allTokens array.
1357      * @param tokenId uint256 ID of the token to be removed from the tokens list
1358      */
1359     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1360         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1361         // then delete the last slot (swap and pop).
1362 
1363         uint256 lastTokenIndex = _allTokens.length - 1;
1364         uint256 tokenIndex = _allTokensIndex[tokenId];
1365 
1366         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1367         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1368         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1369         uint256 lastTokenId = _allTokens[lastTokenIndex];
1370 
1371         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1372         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1373 
1374         // This also deletes the contents at the last position of the array
1375         delete _allTokensIndex[tokenId];
1376         _allTokens.pop();
1377     }
1378 }
1379 
1380 
1381 // File: @openzeppelin/contracts/access/Ownable.sol
1382 pragma solidity ^0.8.0;
1383 /**
1384  * @dev Contract module which provides a basic access control mechanism, where
1385  * there is an account (an owner) that can be granted exclusive access to
1386  * specific functions.
1387  *
1388  * By default, the owner account will be the one that deploys the contract. This
1389  * can later be changed with {transferOwnership}.
1390  *
1391  * This module is used through inheritance. It will make available the modifier
1392  * `onlyOwner`, which can be applied to your functions to restrict their use to
1393  * the owner.
1394  */
1395 abstract contract Ownable is Context {
1396     address private _owner;
1397 
1398     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1399 
1400     /**
1401      * @dev Initializes the contract setting the deployer as the initial owner.
1402      */
1403     constructor() {
1404         _setOwner(_msgSender());
1405     }
1406 
1407     /**
1408      * @dev Returns the address of the current owner.
1409      */
1410     function owner() public view virtual returns (address) {
1411         return _owner;
1412     }
1413 
1414     /**
1415      * @dev Throws if called by any account other than the owner.
1416      */
1417     modifier onlyOwner() {
1418         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1419         _;
1420     }
1421 
1422     /**
1423      * @dev Leaves the contract without owner. It will not be possible to call
1424      * `onlyOwner` functions anymore. Can only be called by the current owner.
1425      *
1426      * NOTE: Renouncing ownership will leave the contract without an owner,
1427      * thereby removing any functionality that is only available to the owner.
1428      */
1429     function renounceOwnership() public virtual onlyOwner {
1430         _setOwner(address(0));
1431     }
1432 
1433     /**
1434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1435      * Can only be called by the current owner.
1436      */
1437     function transferOwnership(address newOwner) public virtual onlyOwner {
1438         require(newOwner != address(0), "Ownable: new owner is the zero address");
1439         _setOwner(newOwner);
1440     }
1441 
1442     function _setOwner(address newOwner) private {
1443         address oldOwner = _owner;
1444         _owner = newOwner;
1445         emit OwnershipTransferred(oldOwner, newOwner);
1446     }
1447 }
1448 
1449 // File: contracts/PurrEvil.sol
1450 /*
1451 kkOOkkOOOOOkkxddddkkOOOOkkkkkOOkkkOOOOkkkkOOOkkkkOOOkkOkkOkkOkkkkkOOkOOOkkOOkOOkOOkkOkkOOkkOOkOOkOOO
1452 kkOOd;;llc;,......,cxOkkOkkkkOOkkOkkkkkkkkOOkOOOkOOOOOOOkkOOkOkkOkl:lllc:::lxOkkOOkkOkkOOOkOOOOOOOOO
1453 OOOOc.      ...''...,dOxldkkOOOOkOxxkOkkkOOOxl:;,,;;;;;lxkOOkkOkl'   ..'....'lkOOOkOOOkOOkkOOkOOkkkk
1454 OOOO:  ..';:loxkkl. .cOo...:xOOOOk:.ckkkkkkOc           .,:okOkkl.   .'..... .ckOOkkkkkOOkkOkkOOkkkk
1455 OkOk:  'xkOOOOOkOo.  'd:   .lOkkxx; .ckkkkOk, .looooodl.  ..lkkOo.   'lccc,.  'dOkOOOOOOkkOOOkkOOOOO
1456 OkOk;  'xOOkkkOOd,.  .l;   .;xxdxx:  ':cdxkx, 'dOkOOkOOx,   ,xOOx'   ,xOkOk;  .lOkOOOOOOOkkOOOOOOOOO
1457 kkOk;  .oOkkkkko' .. 'dc.   .cddxxl. .''cxxx: .cOOkkOkkko.  'xOkk;   .dOkOk:  .oOkOOOOOOOOOOOOOOOOOO
1458 kkkk:   cOkxo:'.   .,okd,    ,dddxo.  ..,ddxl. ,xkxxxxddc. .okkkkc.  .lOko:.  ,xOkkOkkkOOOOkOOOOkkkk
1459 kkkOl.  'c;.    ..;oxxxxl.   .ldddo'  ..'ldxo' .colllol'  .ckkkkOd.   ;l:,'. .lOkkkOkkkkkkkkOOkkkkkk
1460 kkkOx'  .,,..';coxkkxxxdd:.   :ddoo;  ...:odd;  .......  'ldxkkkkk;   ...... ;kOkkkkkkkkkddkxxxxxkkx
1461 kkkkkc. .ckxkkkkxkkxddddoo,   'lolc:. ...:lodc.   ...   .cdddxkkxxc.    ..  .cxkkxxkkxxxxdoooldddxdd
1462 kkkkkd.  ,oddxxdxxxdoodoodl.   ;l:::.   .:cloo'  ':::,.  .coodxxddo'   ..    .;oxdxkxxxddolllloooddd
1463 kkkxkk;  .:oddooxxdolooooodc.  .,::;.   '::loo;  .;;::;.  .;lodddoo;   .c:.    .cdxxddxooocclllooooo
1464 kkxxkkc.  ,oddoldxdllloooooo:.   .''.  .,;:clo:. ..,::::,.  .:lloll:.  .:lc;.   .,ododdlclcccccllloo
1465 kxdodxc.  .lolclodolllloolool;.        .;;;:cc:.   .::::;,.   .;cllc.  .;llol;.   .;ldolcllccccccllo
1466 xoooooc;,..:lc:loolcclllolllll:.      .,;;;:::;.   .;:::;;;'.   'cll;.  ,clllll,.   .clc:clcccccccll
1467 dllllc:::'.,cc:clcccccccllllllcc;....',;;;;;:::,...,;;:::;;;;...,cllc,  ,cccccc:;'.  .,:::clccccccll
1468 occc:;;;::'':c::::ccccc'.;ccllc:;;;,;;;;;;;;::::;;;;;;::;;,;:;',;:cllc. 'c:::::;;::,. .;::clccccccll
1469 :;:;;;;;:cc:cc::::cccc,. .;ccc:;;;;;;;;;;;;;::;;;;;;;;;:;;;;;;;;:::ccc;.,c:::;;;;::::;,;:;:ccccccccl
1470 ;.....,:clccc:::::::c,.   ':::;,;;;;;,;;;;;;;;;;;;;;;;;;;;;;;;;::::ccccc:cc::;;;;::;;;;;;;:ccccccccc
1471 ,... ..,cccc:::cc:;;,.    ':;',;;:;,,;;;;;;;;;;;;;,,,;;;;;;;;;;:::::cccc:c:;,;;;;;;;;;;;;;;:::::::cc
1472 ,. ''. ..;:c:::c:;'.   .. ':,..';;;,;;;;;;;,.';;;;,,,;,,,;;;;;;:::::ccc:::'..';;;;;;;;;;;;;;;;;;;::c
1473 ,. .;;. ..,::::;'.   .,;. .;,. .,;,,;;;;;;,. .;;,,,,,,,,,;;;;;;;;:::cc:;;;.. .',;;;;;;;;;;;;;;;;;;::
1474 ,'. ':,..,'',;,.   .';;. .';,. .';,;;;;;;;.  .;;,,,,,,,,,,,;;;;;:::::::;,,..  .,;;;;;;;;;;;;;;;;;;;:
1475 ,,'. ......  ...   .... .',,,.  .,;;;;;;;'  .';;,,'''................',;,,..  .;;;;;;;;;;;;;;;;;;;;;
1476 ,;,.               .....,,,,,.  .,;;;;;;;.  .,'..                   ..',,,..  .;;,;;;;;;;;;;;;;;;;;;
1477 ,;,.    .......'',,,,,,,,,,,,.   ';;,;,;,.  .'.             .....'',;,,,,,.   .;;,;;;;;;;;,;;;;;;;;;
1478 ,;,.   .,;;;;;,,;;;,,,,,,,,,,'   .;;,,,,.   ',.........    .,,;;,,;;;,,,,,.   .;,,;;;;;;,,,;;;;;;;;;
1479 ;;;.   .,;;;;;,;;;;,,,,,,,,,,,.  .,,,,;,.  .,,,,,,,,,,,.   .,,,,,,;;,,,,,,.   .,,,;;;;,,,,,;;;;;;;,;
1480 ;;;.   .';;;;;,;;;,,,,,,,,,,,,.  .';,;,.   .,,,,,,,,,,,.   .',,,,,,,,,,,,,.   .,,,,,,,,,,,,;;;;;;;;,
1481 ,;;'   .';,;;;,;;,,,,,,,,,,,,,'.  .,;;'.   .,,,,,,,,,,,.   .',,,,,,,,,,,,,.   .,,,,,,,,,,,,,;;;;;;;;
1482 ;;;'    ';,,;;,,,,,,,,,,,,,,,,,.  ..''.   .',,,,,,,,,,,'    .,,,,,,,,,,,,,.   .,,,,,,,,,,,,,;;;;;;;;
1483 ;;;,.   ........''...',,,,,,,,,..    ..   .,,,,,,,,,,,,'.   .,,,,,,,,,,,,,.   .',,,,,,,,,,,,,,;;;,,,
1484 ;;;,.               ..',,,,,,,,'.         ',,,,,,,,,,,,,.   .,,,,,,,,,,,,,'    ',,,,,,,,,,,,,,;;;,,,
1485 ;;;,.    ..........'',,,,,,,,,,,'.       .,,,,,,,,,,,,,,.   .',,,,,,,,,,,,'    .,,,,,,,,,,,,,,;;,,,,
1486 ,;;,.  ..';;;,;,,,,,,,,,,,,,,,,,,.       .,,,,,,,,,,,,,,.    .,,,,,,,,,,,,'     .,,,,,,,,,,,,,;,,,,,
1487 ,;;,.  ..';,,,,,,,,,,,,,,,,,,,,,,'.     .',,,,,,,,,,,,,,.    .,,,'','',,,,'.    .,,,,,,,,,,,,,,,,,,,
1488 ;;;'    .',,,,,,,,,,,,,,,,,,,,,,,,.     .,,,,,,,,,,,,,,,'.    ..   ...',,,,..   .,,,,,'''''..''',,,,
1489 ;;,.     .,,,,,,,,,,,,,,,,,,,,,,,,,.    ',,,,,,,,,,,,,'..         .....',,,'.    ...           ....,
1490 ;;,.     .,,,,,,,,,,,,,,,,,,,,,,,,,'.  .,,,,,,,,,''...         .......'',,,..           .......''',,
1491 ;;,.         .............,,,,,,,,,,,. .,,,,,,,,,...    ........'',,,,,,,,,,'.  ......',,,,;;;,,,,,,
1492 ;;,,'. .                .',,,,,,,,,,,'.',,,,,,,,'........'''',,,;,,,;,,,,,,,,'',,,,;;;;;;;,,;;,,,,;;
1493 ,,,,,.....'''''.........',,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;,;,,,,,,;;,,,;,,,,,,,,;;,,,,,;;;;;,;;;;,,;;;
1494 ,,,,,,,;;,,,,,,,,,;;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;,,,,,,,,,,,,,,,;;,,,,,,;,,,;,,,;;;;;;;;;;;;;;;
1495 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;;,,,,;,,,,;;,,,,,;;,;;;;;;;;;
1496 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;,,;;;;,,,,,;;,,,,;,,;;;,,;;;
1497 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;,,,,,,,;;,,,,;,,;;;;,,,,
1498 */
1499 
1500 
1501 pragma solidity ^0.8.0;
1502 
1503 interface PurrEvilInterface {
1504     function addToWhiteList(address[] calldata addresses) external;
1505 
1506     function onWhiteList(address addr) external returns (bool);
1507 
1508     function removeFromWhiteList(address[] calldata addresses) external;
1509 
1510     function whiteListClaimedBy(address owner) external returns (uint256);
1511 
1512     function mint(uint256 numberOfTokens) external payable;
1513 
1514     function mintWhiteList(uint256 numberOfTokens) external;
1515 
1516     function setIsPublicSaleActive(bool isPublicSaleActive) external;
1517 
1518     function setIsWhiteListActive(bool isWhiteListActive) external;
1519 
1520     function setwhiteListMaxMint(uint256 maxMint) external;
1521 
1522     function withdraw() external;
1523 }
1524 
1525 pragma solidity ^0.8.0;
1526 
1527 contract PurrEvil is ERC721Enumerable, Ownable, PurrEvilInterface {
1528     using Strings for uint256;
1529 
1530     string public provenance = "";
1531     uint256 public constant PurrEvil_RESERVE = 99;
1532     uint256 public constant PurrEvil_MAX = 9900;
1533     uint256 public constant PurrEvil_MAX_MINT = PurrEvil_RESERVE + PurrEvil_MAX;
1534     uint256 public constant PURCHASE_LIMIT = 10;
1535     uint256 public PRICE = 0.05 ether;
1536 
1537     uint256 public whiteListMaxMint = 1;
1538 
1539     uint256 public totalGiftSupply;
1540     uint256 public totalPublicSupply;
1541 
1542     bool public isPublicSaleActive = false;
1543     bool public isWhiteListActive = false;
1544 
1545     mapping(address => bool) private _whiteList;
1546     mapping(address => uint256) private _whiteListClaimed;
1547 
1548     string private _baseURIExtended;
1549     string private _baseURInoBGExtended;
1550     mapping (uint256 => string) _tokenURIs;
1551     mapping (uint256 => string) _tokenURIsnoBG;
1552 
1553     constructor() ERC721("Purr Evil","PURREVIL") {
1554     }
1555     
1556     function addToWhiteList(address[] calldata addresses) external override onlyOwner {
1557         for (uint256 i = 0; i < addresses.length; i++) {
1558             require(addresses[i] != address(0), "Can't add the null address");
1559 
1560             _whiteList[addresses[i]] = true;
1561             _whiteListClaimed[addresses[i]] > 0 ? _whiteListClaimed[addresses[i]] : 0;
1562         }
1563     }
1564 
1565     function onWhiteList(address addr) external view override returns (bool) {
1566         return _whiteList[addr];
1567     }
1568 
1569     function removeFromWhiteList(address[] calldata addresses) external override onlyOwner {
1570         for (uint256 i = 0; i < addresses.length; i++) {
1571             require(addresses[i] != address(0), "Can't remove the null address");
1572 
1573             _whiteList[addresses[i]] = false;
1574         }
1575     }
1576 
1577     function whiteListClaimedBy(address owner) external view override returns (uint256){
1578         require(owner != address(0), 'Zero address not on White List');
1579 
1580         return _whiteListClaimed[owner];
1581     }
1582 
1583     function mint(uint256 numberOfTokens) external override payable {
1584         require(isPublicSaleActive, 'Public sale is not active');
1585         require(totalSupply() < PurrEvil_MAX_MINT, 'All tokens have been minted');
1586         require(numberOfTokens <= PURCHASE_LIMIT, 'Would exceed purchase limit of 10');
1587         require(totalPublicSupply < PurrEvil_MAX, 'Purchase would exceed maximum public supply');
1588         require(PRICE * numberOfTokens <= msg.value, 'ETH amount is not sufficient');
1589 
1590         for (uint256 i = 0; i < numberOfTokens; i++) {
1591             if (totalPublicSupply < PurrEvil_MAX) {
1592                 uint256 tokenId = PurrEvil_RESERVE + totalPublicSupply + 1;
1593 
1594                 totalPublicSupply += 1;
1595                 _safeMint(msg.sender, tokenId);
1596             }
1597         }
1598     }
1599 
1600     function mintWhiteList(uint256 numberOfTokens) external override {
1601         require(isWhiteListActive, 'White List is not active');
1602         require(_whiteList[msg.sender], 'You are not on the White List');
1603         require(totalSupply() < PurrEvil_MAX_MINT, 'All cats have been minted');
1604         require(numberOfTokens <= whiteListMaxMint, 'Cannot purchase this many cats');
1605         require(totalPublicSupply + numberOfTokens <= PurrEvil_MAX, 'Purchase would exceed maximum public supply');
1606         require(_whiteListClaimed[msg.sender] + numberOfTokens <= whiteListMaxMint, 'You have already minted allowed maximum of 1');
1607         //require(PRICE * numberOfTokens <= msg.value, 'ETH amount is not sufficient');
1608 
1609         for (uint256 i = 0; i < numberOfTokens; i++) {
1610             uint256 tokenId = PurrEvil_RESERVE + totalPublicSupply + 1;
1611 
1612             totalPublicSupply += 1;
1613             _whiteListClaimed[msg.sender] += 1;
1614             _safeMint(msg.sender, tokenId);
1615         }
1616     }
1617 
1618     function mintReserve(uint256 _count, address _to) public onlyOwner {
1619         require(totalSupply() < PurrEvil_MAX_MINT, 'All tokens have been minted');
1620         require(totalGiftSupply + _count <= PurrEvil_RESERVE, 'Not enough tokens left to reserve');
1621 
1622         for(uint256 i = 0; i < _count; i++) {
1623             uint256 tokenId = totalGiftSupply + 1;
1624 
1625             totalGiftSupply += 1;
1626             _safeMint(_to, tokenId);
1627         }
1628     }
1629 
1630     function setIsPublicSaleActive (bool _isPublicSaleActive) external override onlyOwner {
1631         isPublicSaleActive = _isPublicSaleActive;
1632     }
1633 
1634     function setIsWhiteListActive(bool _isWhiteListActive) external override onlyOwner {
1635         isWhiteListActive = _isWhiteListActive;
1636     }
1637 
1638     function setwhiteListMaxMint(uint256 maxMint) external override onlyOwner {
1639         whiteListMaxMint = maxMint;
1640     }
1641 
1642     function _baseURI() internal view virtual override returns (string memory) {
1643         return _baseURIExtended;
1644     }
1645     
1646     function _baseURInoBG() internal view virtual returns (string memory) {
1647         return _baseURInoBGExtended;
1648     }
1649 
1650     // Sets base URI for all tokens, only able to be called by contract owner
1651     function setBaseURI(string memory baseURI_) external onlyOwner {
1652         _baseURIExtended = baseURI_;
1653     }
1654 
1655     // Sets base URI for images without background for all tokens, only able to be called by contract owner
1656     function setBaseURI_noBG(string memory baseURInoBG_) external onlyOwner {
1657         _baseURInoBGExtended = baseURInoBG_;
1658     }
1659 
1660     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1661         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1662 
1663         string memory _tokenURI = _tokenURIs[tokenId];
1664         string memory base = _baseURI();
1665 
1666         // If there is no base URI, return the token URI.
1667         if (bytes(base).length == 0) {
1668             return _tokenURI;
1669         }
1670         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1671         if (bytes(_tokenURI).length > 0) {
1672             return string(abi.encodePacked(base, _tokenURI));
1673         }
1674         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1675         return string(abi.encodePacked(base, tokenId.toString()));
1676     }
1677     
1678     function tokenURInoBG(uint256 tokenId) public view virtual returns (string memory) {
1679         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1680 
1681         string memory _tokenURInoBG = _tokenURIsnoBG[tokenId];
1682         string memory basenoBG = _baseURInoBG();
1683 
1684         // If there is no base URI, return the token URI.
1685         if (bytes(basenoBG).length == 0) {
1686             return _tokenURInoBG;
1687         }
1688         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1689         if (bytes(_tokenURInoBG).length > 0) {
1690             return string(abi.encodePacked(basenoBG, _tokenURInoBG,".png"));
1691         }
1692         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1693         return string(abi.encodePacked(basenoBG, tokenId.toString(),".png"));
1694     }
1695 
1696 
1697   //only owner
1698   function setPrice(uint256 _newPrice) public onlyOwner() {
1699     PRICE = _newPrice;
1700   }
1701   
1702   
1703     // Set the provenanceHash
1704   function setProvenanceHash(string memory provenanceHash) external onlyOwner {
1705     provenance = provenanceHash;
1706   }
1707  
1708      //Withdraw to owner
1709   function withdraw() external override onlyOwner {
1710     uint256 balance = address(this).balance;
1711 
1712     payable(msg.sender).transfer(balance);
1713   } 
1714 }