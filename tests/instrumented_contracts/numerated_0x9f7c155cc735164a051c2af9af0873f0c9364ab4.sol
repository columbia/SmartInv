1 // SPDX-License-Identifier: MIT
2 
3 // Scroll down to the bottom to find the contract of interest. 
4 
5 // File: @openzeppelin/contracts@4.3.2/utils/introspection/IERC165.sol
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File: @openzeppelin/contracts@4.3.2/token/ERC721/IERC721.sol
33 
34 
35 pragma solidity ^0.8.0;
36 
37 // import "@openzeppelin/contracts@4.3.2/utils/introspection/IERC165.sol";
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File: @openzeppelin/contracts@4.3.2/token/ERC721/IERC721Receiver.sol
178 
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC721 token receiver interface
184  * @dev Interface for any contract that wants to support safeTransfers
185  * from ERC721 asset contracts.
186  */
187 interface IERC721Receiver {
188     /**
189      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
190      * by `operator` from `from`, this function is called.
191      *
192      * It must return its Solidity selector to confirm the token transfer.
193      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
194      *
195      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
196      */
197     function onERC721Received(
198         address operator,
199         address from,
200         uint256 tokenId,
201         bytes calldata data
202     ) external returns (bytes4);
203 }
204 
205 
206 // File: @openzeppelin/contracts@4.3.2/token/ERC721/extensions/IERC721Metadata.sol
207 
208 
209 pragma solidity ^0.8.0;
210 
211 // import "@openzeppelin/contracts@4.3.2/token/ERC721/IERC721.sol";
212 
213 /**
214  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
215  * @dev See https://eips.ethereum.org/EIPS/eip-721
216  */
217 interface IERC721Metadata is IERC721 {
218     /**
219      * @dev Returns the token collection name.
220      */
221     function name() external view returns (string memory);
222 
223     /**
224      * @dev Returns the token collection symbol.
225      */
226     function symbol() external view returns (string memory);
227 
228     /**
229      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
230      */
231     function tokenURI(uint256 tokenId) external view returns (string memory);
232 }
233 
234 
235 // File: @openzeppelin/contracts@4.3.2/utils/Address.sol
236 
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 
454 // File: @openzeppelin/contracts@4.3.2/utils/Context.sol
455 
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev Provides information about the current execution context, including the
461  * sender of the transaction and its data. While these are generally available
462  * via msg.sender and msg.data, they should not be accessed in such a direct
463  * manner, since when dealing with meta-transactions the account sending and
464  * paying for execution may not be the actual sender (as far as an application
465  * is concerned).
466  *
467  * This contract is only required for intermediate, library-like contracts.
468  */
469 abstract contract Context {
470     function _msgSender() internal view virtual returns (address) {
471         return msg.sender;
472     }
473 
474     function _msgData() internal view virtual returns (bytes calldata) {
475         return msg.data;
476     }
477 }
478 
479 
480 // File: @openzeppelin/contracts@4.3.2/utils/Strings.sol
481 
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev String operations.
487  */
488 library Strings {
489     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
493      */
494     function toString(uint256 value) internal pure returns (string memory) {
495         // Inspired by OraclizeAPI's implementation - MIT licence
496         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
497 
498         if (value == 0) {
499             return "0";
500         }
501         uint256 temp = value;
502         uint256 digits;
503         while (temp != 0) {
504             digits++;
505             temp /= 10;
506         }
507         bytes memory buffer = new bytes(digits);
508         while (value != 0) {
509             digits -= 1;
510             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
511             value /= 10;
512         }
513         return string(buffer);
514     }
515 
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
518      */
519     function toHexString(uint256 value) internal pure returns (string memory) {
520         if (value == 0) {
521             return "0x00";
522         }
523         uint256 temp = value;
524         uint256 length = 0;
525         while (temp != 0) {
526             length++;
527             temp >>= 8;
528         }
529         return toHexString(value, length);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
534      */
535     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
536         bytes memory buffer = new bytes(2 * length + 2);
537         buffer[0] = "0";
538         buffer[1] = "x";
539         for (uint256 i = 2 * length + 1; i > 1; --i) {
540             buffer[i] = _HEX_SYMBOLS[value & 0xf];
541             value >>= 4;
542         }
543         require(value == 0, "Strings: hex length insufficient");
544         return string(buffer);
545     }
546 }
547 
548 
549 // File: @openzeppelin/contracts@4.3.2/utils/introspection/ERC165.sol
550 
551 
552 pragma solidity ^0.8.0;
553 
554 // import "@openzeppelin/contracts@4.3.2/utils/introspection/IERC165.sol";
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 
580 // File: @openzeppelin/contracts@4.3.2/utils/math/SafeMath.sol
581 
582 
583 pragma solidity ^0.8.0;
584 
585 // CAUTION
586 // This version of SafeMath should only be used with Solidity 0.8 or later,
587 // because it relies on the compiler's built in overflow checks.
588 
589 /**
590  * @dev Wrappers over Solidity's arithmetic operations.
591  *
592  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
593  * now has built in overflow checking.
594  */
595 library SafeMath {
596     /**
597      * @dev Returns the addition of two unsigned integers, with an overflow flag.
598      *
599      * _Available since v3.4._
600      */
601     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
602         unchecked {
603             uint256 c = a + b;
604             if (c < a) return (false, 0);
605             return (true, c);
606         }
607     }
608 
609     /**
610      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
611      *
612      * _Available since v3.4._
613      */
614     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
615         unchecked {
616             if (b > a) return (false, 0);
617             return (true, a - b);
618         }
619     }
620 
621     /**
622      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
623      *
624      * _Available since v3.4._
625      */
626     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
627         unchecked {
628             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
629             // benefit is lost if 'b' is also tested.
630             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
631             if (a == 0) return (true, 0);
632             uint256 c = a * b;
633             if (c / a != b) return (false, 0);
634             return (true, c);
635         }
636     }
637 
638     /**
639      * @dev Returns the division of two unsigned integers, with a division by zero flag.
640      *
641      * _Available since v3.4._
642      */
643     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
644         unchecked {
645             if (b == 0) return (false, 0);
646             return (true, a / b);
647         }
648     }
649 
650     /**
651      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
652      *
653      * _Available since v3.4._
654      */
655     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
656         unchecked {
657             if (b == 0) return (false, 0);
658             return (true, a % b);
659         }
660     }
661 
662     /**
663      * @dev Returns the addition of two unsigned integers, reverting on
664      * overflow.
665      *
666      * Counterpart to Solidity's `+` operator.
667      *
668      * Requirements:
669      *
670      * - Addition cannot overflow.
671      */
672     function add(uint256 a, uint256 b) internal pure returns (uint256) {
673         return a + b;
674     }
675 
676     /**
677      * @dev Returns the subtraction of two unsigned integers, reverting on
678      * overflow (when the result is negative).
679      *
680      * Counterpart to Solidity's `-` operator.
681      *
682      * Requirements:
683      *
684      * - Subtraction cannot overflow.
685      */
686     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
687         return a - b;
688     }
689 
690     /**
691      * @dev Returns the multiplication of two unsigned integers, reverting on
692      * overflow.
693      *
694      * Counterpart to Solidity's `*` operator.
695      *
696      * Requirements:
697      *
698      * - Multiplication cannot overflow.
699      */
700     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
701         return a * b;
702     }
703 
704     /**
705      * @dev Returns the integer division of two unsigned integers, reverting on
706      * division by zero. The result is rounded towards zero.
707      *
708      * Counterpart to Solidity's `/` operator.
709      *
710      * Requirements:
711      *
712      * - The divisor cannot be zero.
713      */
714     function div(uint256 a, uint256 b) internal pure returns (uint256) {
715         return a / b;
716     }
717 
718     /**
719      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
720      * reverting when dividing by zero.
721      *
722      * Counterpart to Solidity's `%` operator. This function uses a `revert`
723      * opcode (which leaves remaining gas untouched) while Solidity uses an
724      * invalid opcode to revert (consuming all remaining gas).
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
731         return a % b;
732     }
733 
734     /**
735      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
736      * overflow (when the result is negative).
737      *
738      * CAUTION: This function is deprecated because it requires allocating memory for the error
739      * message unnecessarily. For custom revert reasons use {trySub}.
740      *
741      * Counterpart to Solidity's `-` operator.
742      *
743      * Requirements:
744      *
745      * - Subtraction cannot overflow.
746      */
747     function sub(
748         uint256 a,
749         uint256 b,
750         string memory errorMessage
751     ) internal pure returns (uint256) {
752         unchecked {
753             require(b <= a, errorMessage);
754             return a - b;
755         }
756     }
757 
758     /**
759      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
760      * division by zero. The result is rounded towards zero.
761      *
762      * Counterpart to Solidity's `/` operator. Note: this function uses a
763      * `revert` opcode (which leaves remaining gas untouched) while Solidity
764      * uses an invalid opcode to revert (consuming all remaining gas).
765      *
766      * Requirements:
767      *
768      * - The divisor cannot be zero.
769      */
770     function div(
771         uint256 a,
772         uint256 b,
773         string memory errorMessage
774     ) internal pure returns (uint256) {
775         unchecked {
776             require(b > 0, errorMessage);
777             return a / b;
778         }
779     }
780 
781     /**
782      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
783      * reverting with custom message when dividing by zero.
784      *
785      * CAUTION: This function is deprecated because it requires allocating memory for the error
786      * message unnecessarily. For custom revert reasons use {tryMod}.
787      *
788      * Counterpart to Solidity's `%` operator. This function uses a `revert`
789      * opcode (which leaves remaining gas untouched) while Solidity uses an
790      * invalid opcode to revert (consuming all remaining gas).
791      *
792      * Requirements:
793      *
794      * - The divisor cannot be zero.
795      */
796     function mod(
797         uint256 a,
798         uint256 b,
799         string memory errorMessage
800     ) internal pure returns (uint256) {
801         unchecked {
802             require(b > 0, errorMessage);
803             return a % b;
804         }
805     }
806 }
807 
808 
809 // File: @openzeppelin/contracts@4.3.2/utils/cryptography/MerkleProof.sol
810 
811 
812 pragma solidity ^0.8.0;
813 
814 /**
815  * @dev These functions deal with verification of Merkle Trees proofs.
816  *
817  * The proofs can be generated using the JavaScript library
818  * https://github.com/miguelmota/merkletreejs[merkletreejs].
819  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
820  *
821  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
822  */
823 library MerkleProof {
824     /**
825      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
826      * defined by `root`. For this, a `proof` must be provided, containing
827      * sibling hashes on the branch from the leaf to the root of the tree. Each
828      * pair of leaves and each pair of pre-images are assumed to be sorted.
829      */
830     function verify(
831         bytes32[] memory proof,
832         bytes32 root,
833         bytes32 leaf
834     ) internal pure returns (bool) {
835         bytes32 computedHash = leaf;
836 
837         for (uint256 i = 0; i < proof.length; i++) {
838             bytes32 proofElement = proof[i];
839 
840             if (computedHash <= proofElement) {
841                 // Hash(current computed hash + current element of the proof)
842                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
843             } else {
844                 // Hash(current element of the proof + current computed hash)
845                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
846             }
847         }
848 
849         // Check if the computed hash (root) is equal to the provided root
850         return computedHash == root;
851     }
852 }
853 
854 
855 // File: @openzeppelin/contracts@4.3.2/token/ERC721/extensions/IERC721Enumerable.sol
856 
857 
858 pragma solidity ^0.8.0;
859 
860 // import "@openzeppelin/contracts@4.3.2/token/ERC721/IERC721.sol";
861 
862 /**
863  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
864  * @dev See https://eips.ethereum.org/EIPS/eip-721
865  */
866 interface IERC721Enumerable is IERC721 {
867     /**
868      * @dev Returns the total amount of tokens stored by the contract.
869      */
870     function totalSupply() external view returns (uint256);
871 
872     /**
873      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
874      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
875      */
876     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
877 
878     /**
879      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
880      * Use along with {totalSupply} to enumerate all tokens.
881      */
882     function tokenByIndex(uint256 index) external view returns (uint256);
883 }
884 
885 
886 // File: @openzeppelin/contracts@4.3.2/access/Ownable.sol
887 
888 
889 pragma solidity ^0.8.0;
890 
891 // import "@openzeppelin/contracts@4.3.2/utils/Context.sol";
892 
893 /**
894  * @dev Contract module which provides a basic access control mechanism, where
895  * there is an account (an owner) that can be granted exclusive access to
896  * specific functions.
897  *
898  * By default, the owner account will be the one that deploys the contract. This
899  * can later be changed with {transferOwnership}.
900  *
901  * This module is used through inheritance. It will make available the modifier
902  * `onlyOwner`, which can be applied to your functions to restrict their use to
903  * the owner.
904  */
905 abstract contract Ownable is Context {
906     address private _owner;
907 
908     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
909 
910     /**
911      * @dev Initializes the contract setting the deployer as the initial owner.
912      */
913     constructor() {
914         _setOwner(_msgSender());
915     }
916 
917     /**
918      * @dev Returns the address of the current owner.
919      */
920     function owner() public view virtual returns (address) {
921         return _owner;
922     }
923 
924     /**
925      * @dev Throws if called by any account other than the owner.
926      */
927     modifier onlyOwner() {
928         require(owner() == _msgSender(), "Ownable: caller is not the owner");
929         _;
930     }
931 
932     /**
933      * @dev Leaves the contract without owner. It will not be possible to call
934      * `onlyOwner` functions anymore. Can only be called by the current owner.
935      *
936      * NOTE: Renouncing ownership will leave the contract without an owner,
937      * thereby removing any functionality that is only available to the owner.
938      */
939     function renounceOwnership() public virtual onlyOwner {
940         _setOwner(address(0));
941     }
942 
943     /**
944      * @dev Transfers ownership of the contract to a new account (`newOwner`).
945      * Can only be called by the current owner.
946      */
947     function transferOwnership(address newOwner) public virtual onlyOwner {
948         require(newOwner != address(0), "Ownable: new owner is the zero address");
949         _setOwner(newOwner);
950     }
951 
952     function _setOwner(address newOwner) private {
953         address oldOwner = _owner;
954         _owner = newOwner;
955         emit OwnershipTransferred(oldOwner, newOwner);
956     }
957 }
958 
959 
960 // File: @openzeppelin/contracts@4.3.2/security/ReentrancyGuard.sol
961 
962 
963 pragma solidity ^0.8.0;
964 
965 /**
966  * @dev Contract module that helps prevent reentrant calls to a function.
967  *
968  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
969  * available, which can be applied to functions to make sure there are no nested
970  * (reentrant) calls to them.
971  *
972  * Note that because there is a single `nonReentrant` guard, functions marked as
973  * `nonReentrant` may not call one another. This can be worked around by making
974  * those functions `private`, and then adding `external` `nonReentrant` entry
975  * points to them.
976  *
977  * TIP: If you would like to learn more about reentrancy and alternative ways
978  * to protect against it, check out our blog post
979  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
980  */
981 abstract contract ReentrancyGuard {
982     // Booleans are more expensive than uint256 or any type that takes up a full
983     // word because each write operation emits an extra SLOAD to first read the
984     // slot's contents, replace the bits taken up by the boolean, and then write
985     // back. This is the compiler's defense against contract upgrades and
986     // pointer aliasing, and it cannot be disabled.
987 
988     // The values being non-zero value makes deployment a bit more expensive,
989     // but in exchange the refund on every call to nonReentrant will be lower in
990     // amount. Since refunds are capped to a percentage of the total
991     // transaction's gas, it is best to keep them low in cases like this one, to
992     // increase the likelihood of the full refund coming into effect.
993     uint256 private constant _NOT_ENTERED = 1;
994     uint256 private constant _ENTERED = 2;
995 
996     uint256 private _status;
997 
998     constructor() {
999         _status = _NOT_ENTERED;
1000     }
1001 
1002     /**
1003      * @dev Prevents a contract from calling itself, directly or indirectly.
1004      * Calling a `nonReentrant` function from another `nonReentrant`
1005      * function is not supported. It is possible to prevent this from happening
1006      * by making the `nonReentrant` function external, and make it call a
1007      * `private` function that does the actual work.
1008      */
1009     modifier nonReentrant() {
1010         // On the first call to nonReentrant, _notEntered will be true
1011         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1012 
1013         // Any calls to nonReentrant after this point will fail
1014         _status = _ENTERED;
1015 
1016         _;
1017 
1018         // By storing the original value once again, a refund is triggered (see
1019         // https://eips.ethereum.org/EIPS/eip-2200)
1020         _status = _NOT_ENTERED;
1021     }
1022 }
1023 
1024 // File: www/contracts/LilBlobsWrld.sol
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 // import "@openzeppelin/contracts@4.3.2/token/ERC721/IERC721.sol";
1029 // import "@openzeppelin/contracts@4.3.2/token/ERC721/IERC721Receiver.sol";
1030 // import "@openzeppelin/contracts@4.3.2/token/ERC721/extensions/IERC721Metadata.sol";
1031 // import "@openzeppelin/contracts@4.3.2/utils/Address.sol";
1032 // import "@openzeppelin/contracts@4.3.2/utils/Context.sol";
1033 // import "@openzeppelin/contracts@4.3.2/utils/Strings.sol";
1034 // import "@openzeppelin/contracts@4.3.2/utils/introspection/ERC165.sol";
1035 // import "@openzeppelin/contracts@4.3.2/utils/math/SafeMath.sol";
1036 // import "@openzeppelin/contracts@4.3.2/utils/cryptography/MerkleProof.sol";
1037 /**
1038  * This is a modified version of the ERC721 class, where we only store
1039  * the address of the minter into an _owners array upon minting.
1040  * 
1041  * While this saves on minting gas costs, it means that the the balanceOf
1042  * function needs to do a bruteforce search through all the tokens.
1043  *
1044  * For small amounts of tokens (e.g. 8888), RPC services like Infura
1045  * can still query the function. 
1046  *
1047  * It also means any future contracts that reads the balanceOf function 
1048  * in a non-view function will incur a gigantic gas fee. 
1049  */
1050 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1051     
1052     using Address for address;
1053     
1054     string private _name;
1055     
1056     string private _symbol;
1057     
1058     address[] internal _owners;
1059     
1060     uint internal _burntCount;
1061 
1062     mapping(uint256 => address) private _tokenApprovals;
1063     
1064     mapping(address => mapping(address => bool)) private _operatorApprovals;     
1065     
1066     constructor(string memory name_, string memory symbol_) {
1067         _name = name_;
1068         _symbol = symbol_;
1069     }     
1070     
1071     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1072         return
1073             interfaceId == type(IERC721).interfaceId ||
1074             interfaceId == type(IERC721Metadata).interfaceId ||
1075             super.supportsInterface(interfaceId);
1076     }
1077     
1078     function balanceOf(address owner) public view virtual override returns (uint256) {
1079         require(owner != address(0), "ERC721: balance query for the zero address");
1080         uint count = 0;
1081         uint n = _owners.length;
1082         for (uint i = 0; i < n; ++i) {
1083             if (owner == _owners[i]) {
1084                 ++count;
1085             }
1086         }
1087         return count;
1088     }
1089     
1090     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1091         address owner = _owners[tokenId];
1092         require(owner != address(0), "ERC721: owner query for nonexistent token");
1093         return owner;
1094     }
1095     
1096     function name() public view virtual override returns (string memory) {
1097         return _name;
1098     }
1099     
1100     function symbol() public view virtual override returns (string memory) {
1101         return _symbol;
1102     }
1103     
1104     function approve(address to, uint256 tokenId) public virtual override {
1105         address owner = ERC721.ownerOf(tokenId);
1106         require(to != owner, "ERC721: approval to current owner");
1107 
1108         require(
1109             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1110             "ERC721: approve caller is not owner nor approved for all"
1111         );
1112 
1113         _approve(to, tokenId);
1114     }
1115     
1116     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1117         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1118 
1119         return _tokenApprovals[tokenId];
1120     }
1121     
1122     function setApprovalForAll(address operator, bool approved) public virtual override {
1123         require(operator != _msgSender(), "ERC721: approve to caller");
1124 
1125         _operatorApprovals[_msgSender()][operator] = approved;
1126         emit ApprovalForAll(_msgSender(), operator, approved);
1127     }
1128     
1129     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1130         return _operatorApprovals[owner][operator];
1131     }
1132     
1133     function transferFrom(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) public virtual override {
1138         //solhint-disable-next-line max-line-length
1139         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1140 
1141         _transfer(from, to, tokenId);
1142     }
1143     
1144     function safeTransferFrom(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) public virtual override {
1149         safeTransferFrom(from, to, tokenId, "");
1150     }
1151     
1152     function safeTransferFrom(
1153         address from,
1154         address to,
1155         uint256 tokenId,
1156         bytes memory _data
1157     ) public virtual override {
1158         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1159         _safeTransfer(from, to, tokenId, _data);
1160     }     
1161     
1162     function _safeTransfer(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) internal virtual {
1168         _transfer(from, to, tokenId);
1169         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1170     }
1171   
1172     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1173         return tokenId < _owners.length && _owners[tokenId] != address(0);
1174     }
1175   
1176     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1177         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1178         address owner = ERC721.ownerOf(tokenId);
1179         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1180     }
1181   
1182     function _safeMint(address to, uint256 tokenId) internal virtual {
1183         _safeMint(to, tokenId, "");
1184     }
1185   
1186     function _safeMint(
1187         address to,
1188         uint256 tokenId,
1189         bytes memory _data
1190     ) internal virtual {
1191         _mint(to, tokenId);
1192         require(
1193             _checkOnERC721Received(address(0), to, tokenId, _data),
1194             "ERC721: transfer to non ERC721Receiver implementer"
1195         );
1196     }
1197   
1198     function _mint(address to, uint256 tokenId) internal virtual {
1199         require(to != address(0), "ERC721: mint to the zero address");
1200         require(!_exists(tokenId), "ERC721: token already minted");
1201 
1202         _beforeTokenTransfer(address(0), to, tokenId);
1203         _owners.push(to);
1204 
1205         emit Transfer(address(0), to, tokenId);
1206     }
1207   
1208     function _burn(uint256 tokenId) internal virtual {
1209         address owner = ERC721.ownerOf(tokenId);
1210 
1211         _beforeTokenTransfer(owner, address(0), tokenId);
1212 
1213         // Clear approvals
1214         _approve(address(0), tokenId);
1215         _owners[tokenId] = address(0);
1216 
1217         emit Transfer(owner, address(0), tokenId);
1218     }
1219   
1220     function _transfer(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) internal virtual {
1225         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1226         require(to != address(0), "ERC721: transfer to the zero address");
1227 
1228         _beforeTokenTransfer(from, to, tokenId);
1229 
1230         // Clear approvals from the previous owner
1231         _approve(address(0), tokenId);
1232         _owners[tokenId] = to;
1233 
1234         emit Transfer(from, to, tokenId);
1235     }
1236   
1237     function _approve(address to, uint256 tokenId) internal virtual {
1238         _tokenApprovals[tokenId] = to;
1239         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1240     }
1241   
1242     function _checkOnERC721Received(
1243         address from,
1244         address to,
1245         uint256 tokenId,
1246         bytes memory _data
1247     ) private returns (bool) {
1248         if (to.isContract()) {
1249             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1250                 return retval == IERC721Receiver.onERC721Received.selector;
1251             } catch (bytes memory reason) {
1252                 if (reason.length == 0) {
1253                     revert("ERC721: transfer to non ERC721Receiver implementer");
1254                 } else {
1255                     assembly {
1256                         revert(add(32, reason), mload(reason))
1257                     }
1258                 }
1259             }
1260         } else {
1261             return true;
1262         }
1263     }
1264   
1265     function _beforeTokenTransfer(
1266         address from,
1267         address to,
1268         uint256 tokenId
1269     ) internal virtual {}
1270 }
1271 
1272 pragma solidity ^0.8.0;
1273 
1274 // import "@openzeppelin/contracts@4.3.2/token/ERC721/extensions/IERC721Enumerable.sol";
1275 
1276 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1277     
1278     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1279         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1280     }
1281     
1282     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
1283         uint256 count = 0;
1284         uint256 n = _owners.length;
1285         for (uint256 i = 0; i < n; ++i) {
1286             if (owner == _owners[i]) {
1287                 if (count == index) {
1288                     return i;
1289                 } else {
1290                     ++count;
1291                 }
1292             }
1293         }
1294         require(false, "Token not found.");
1295     }
1296     
1297     function totalSupply() public view virtual override returns (uint256) {
1298         return (_owners.length - _burntCount);
1299     }
1300     
1301     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1302         require(_exists(index), "ERC721: operator query for nonexistent token");
1303         return index;
1304     }
1305 }
1306 
1307 pragma solidity ^0.8.0;
1308 pragma abicoder v2;
1309 
1310 // import "@openzeppelin/contracts@4.3.2/access/Ownable.sol";
1311 // import "@openzeppelin/contracts@4.3.2/security/ReentrancyGuard.sol";
1312 
1313 contract LilBlobsWrld is ERC721Enumerable, Ownable, ReentrancyGuard {
1314 
1315     using Strings for uint;
1316 
1317     using SafeMath for uint256;
1318     
1319     uint public constant TOKEN_PRICE = 60000000000000000; // 0.06 ETH
1320 
1321     uint public constant PRE_SALE_TOKEN_PRICE = 60000000000000000; // 0.06 ETH
1322 
1323     uint public constant MAX_TOKENS_PER_PUBLIC_MINT = 5; // Only applies during public sale.
1324 
1325     uint public MAX_TOKENS = 8888;
1326     
1327     uint public MAX_PRESALE_TOKENS_PER_WALLET = 2;
1328 
1329     bytes32 public whitelistMerkleRoot;
1330 
1331     address constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
1332 
1333     address private VAULT_ADDRESS = 0xC378E5ca770D9D1D0AEfE0d644b9B97645757346;
1334 
1335     /// @dev 1: presale, 2: public sale, 255: closed.
1336     uint public saleState; 
1337 
1338     /// @dev 0: disable burn, 1: enable burn
1339     uint public burnState; 
1340 
1341     // @dev Save whitelist address for presale
1342     mapping(address => int) public presaleReservations;
1343 
1344     /// @dev The license text/url for every token.
1345     string public LICENSE = "https://www.nftlicense.org"; 
1346 
1347     ///      This contains all the information needed to reproduce the collection
1348     string public PROVENANCE; 
1349 
1350     /// @dev The base URI
1351     string public baseURI;
1352 
1353     event LicenseSet(string _license);
1354 
1355     event ProvenanceSet(string _provenance);
1356 
1357     event SaleClosed();
1358 
1359     event PreSaleOpened();
1360 
1361     event PublicSaleOpened();
1362 
1363     constructor() 
1364     ERC721("Lil Blobs WRLD - Official", "Blobs") { 
1365         saleState = 255;
1366         burnState = 0;
1367         baseURI = "https://www.lilblobswrld.io/api/tokens/";
1368     }
1369     
1370     /// @dev Withdraws Ether to vault address.    
1371     function withdraw() external onlyOwner {
1372         payable(VAULT_ADDRESS).transfer(address(this).balance);
1373     }
1374 
1375     function setVaultAddress(address addr) external onlyOwner {
1376         VAULT_ADDRESS = addr;
1377     }
1378 
1379     /// @dev Sets the provenance.
1380     function setProvenance(string memory _provenance) external onlyOwner {
1381         PROVENANCE = _provenance;
1382         emit ProvenanceSet(_provenance);
1383     }
1384 
1385     /// @dev Sets base URI for all token IDs.
1386     function setBaseURI(string memory _baseURI) external onlyOwner {
1387         baseURI = _baseURI;
1388     }
1389 
1390     /// @dev Sets setMaxPresaleToken
1391     function setMaxPresaleToken(uint _amount) external onlyOwner {
1392         MAX_PRESALE_TOKENS_PER_WALLET = _amount;
1393     }
1394 
1395     /// @dev Open the pre-sale. 
1396     function openPreSale() public onlyOwner {
1397         saleState = 1;
1398         emit PreSaleOpened();
1399     }
1400 
1401     /// @dev Open the public sale. 
1402     function openPublicSale() public onlyOwner {
1403         saleState = 2;
1404         emit PublicSaleOpened();
1405     }
1406 
1407     /// @dev Close the sale.
1408     function closeSale() public onlyOwner {
1409         saleState = 255;
1410         emit SaleClosed();
1411     }
1412 
1413     /// @dev Mint just one NFT.
1414     function mintOne(address _toAddress) internal {
1415         uint mintIndex = _owners.length;
1416         require(mintIndex < MAX_TOKENS, "Sold out.");
1417         _safeMint(_toAddress, mintIndex);
1418     }
1419 
1420     /// @dev Force mint for the addresses. 
1421     //       Can be called anytime.
1422     //       If called right after the creation of the contract, the tokens 
1423     //       are assigned sequentially starting from id 0. 
1424     function forceMint(address[] memory _addresses) external onlyOwner { 
1425         for (uint i = 0; i < _addresses.length; ++i) {
1426             mintOne(_addresses[i]);
1427         }
1428     }
1429     
1430     /// @dev Self mint for the owner. 
1431     ///      Can be called anytime.
1432     ///      This does not require the sale to be open.
1433     function selfMint(uint _numTokens) external onlyOwner { 
1434         for (uint i = 0; i < _numTokens; ++i) {
1435             mintOne(msg.sender);
1436         }
1437     }
1438     
1439     /// @dev Sets the license text.
1440     function setLicense(string memory _license) external onlyOwner {
1441         LICENSE = _license;
1442         emit LicenseSet(_license);
1443     }
1444 
1445     /// @dev Returns the license for tokens.
1446     function tokenLicense(uint _id) external view returns(string memory) {
1447         require(_exists(_id), "ERC721: operator query for nonexistent token");
1448         return LICENSE;
1449     }
1450     
1451     /// @dev Presale mint
1452     function presaleMint(uint _numTokens, bytes32[] calldata merkleProof) external payable nonReentrant {
1453         require(saleState == 1, "Presale not open."); 
1454         require(_numTokens > 0, "Minimum number to mint is 1.");
1455 
1456         require(
1457             MerkleProof.verify(
1458                 merkleProof,
1459                 whitelistMerkleRoot,
1460                 keccak256(abi.encodePacked(msg.sender))
1461             ),
1462             "Address does not exist in whitelist"
1463         );
1464 
1465         require(_numTokens <= MAX_PRESALE_TOKENS_PER_WALLET, "Maximum mint number exceeded");
1466         presaleReservations[msg.sender] += int(_numTokens);
1467 
1468         require(presaleReservations[msg.sender] <= int(MAX_PRESALE_TOKENS_PER_WALLET), "Whitelisted buying exceeded");
1469         require(msg.value >= PRE_SALE_TOKEN_PRICE * _numTokens, "Wrong Ether value.");
1470 
1471         for (uint i = 0; i < _numTokens; ++i) {
1472             mintOne(msg.sender);
1473         }
1474     }
1475 
1476     /// @dev Public mint
1477     function mint(uint _numTokens) external payable nonReentrant {
1478         require(saleState == 2, "Public mint not open."); 
1479         require(_numTokens > 0, "Minimum number to mint is 1.");
1480         require(_numTokens <= MAX_TOKENS_PER_PUBLIC_MINT, "Number per mint exceeded.");
1481         require(msg.value >= TOKEN_PRICE * _numTokens, "Wrong Ether value.");
1482 
1483         for (uint i = 0; i < _numTokens; ++i) {
1484             mintOne(msg.sender);
1485         }
1486     }
1487 
1488     /// @dev Returns an array of the token ids under the owner.
1489     function tokensOfOwner(address _owner) external view returns (uint[] memory) {
1490         uint[] memory a = new uint[](balanceOf(_owner));
1491         uint j = 0;
1492         uint n = _owners.length;
1493         for (uint i; i < n; ++i) {
1494             if (_owner == _owners[i]) {
1495                 a[j++] = i;
1496             }
1497         }
1498         return a;
1499     }
1500 
1501     /// @dev Returns the token's URI for the metadata.
1502     function tokenURI(uint256 _id) external view virtual override returns (string memory) {
1503         require(_exists(_id), "ERC721: operator query for nonexistent token");
1504         return string(abi.encodePacked(baseURI, _id.toString()));
1505     }
1506 
1507     /// @dev Returns the most relevant stats in a single go to reduce RPC calls.
1508     function stats() external view returns (uint[] memory) {
1509         uint[] memory a = new uint[](4);
1510         a[0] = saleState; 
1511         a[1] = totalSupply(); 
1512         a[2] = 0;
1513         a[3] = saleState == 1 ? PRE_SALE_TOKEN_PRICE : TOKEN_PRICE;
1514         return a;
1515     }
1516 
1517     function enableBurn() external onlyOwner {
1518         burnState = 1;
1519     }
1520 
1521     function disableBurn() external onlyOwner {
1522         burnState = 0;
1523     }
1524 
1525     function selfBurn(uint256 tokenId) external {
1526         require(burnState == 1, "Burning disabled");
1527         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1528         require(ownerOf(tokenId) == msg.sender, "You do not own this token.");
1529 
1530         _beforeTokenTransfer(msg.sender, BURN_ADDRESS, tokenId);
1531 
1532         // Clear approvals
1533         _approve(BURN_ADDRESS, tokenId);
1534 
1535         safeTransferFrom(msg.sender, BURN_ADDRESS, tokenId);
1536 
1537         _burntCount++;
1538         delete _owners[tokenId];
1539     }
1540 
1541     function getBurnCount() external view returns (uint){
1542         return _burntCount;
1543     }
1544 
1545     function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1546         whitelistMerkleRoot = merkleRoot;
1547     }
1548 
1549     function setPresaleReservations(address[] calldata _addresses, int _numTokens ) external onlyOwner {
1550         for (uint i = 0; i < _addresses.length; i++) {
1551             presaleReservations[_addresses[i]] = _numTokens;
1552         }
1553     }
1554 
1555     function getPresaleRemaining(address _address) external view returns (int) {
1556         return int(MAX_PRESALE_TOKENS_PER_WALLET) - presaleReservations[_address];
1557     }
1558 
1559     function setMaxToken(uint _maxToken) external onlyOwner {
1560         MAX_TOKENS = _maxToken;
1561     }
1562     
1563 }