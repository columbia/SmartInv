1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * Zoo Gang powered by Kollectiff
6  * https://zoogangnft.io
7  */
8 
9 
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20  interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 
170 /**
171  * @dev Implementation of the {IERC165} interface.
172  *
173  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
174  * for the additional interface id that will be supported. For example:
175  *
176  * ```solidity
177  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
178  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
179  * }
180  * ```
181  *
182  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
183  */
184  abstract contract ERC165 is IERC165 {
185     /**
186      * @dev See {IERC165-supportsInterface}.
187      */
188     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
189         return interfaceId == type(IERC165).interfaceId;
190     }
191 }
192 
193 /**
194  * @title ERC721 token receiver interface
195  * @dev Interface for any contract that wants to support safeTransfers
196  * from ERC721 asset contracts.
197  */
198  interface IERC721Receiver {
199     /**
200      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
201      * by `operator` from `from`, this function is called.
202      *
203      * It must return its Solidity selector to confirm the token transfer.
204      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
205      *
206      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
207      */
208     function onERC721Received(
209         address operator,
210         address from,
211         uint256 tokenId,
212         bytes calldata data
213     ) external returns (bytes4);
214 }
215 
216 
217 /**
218  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
219  * @dev See https://eips.ethereum.org/EIPS/eip-721
220  */
221  interface IERC721Metadata is IERC721 {
222     /**
223      * @dev Returns the token collection name.
224      */
225     function name() external view returns (string memory);
226 
227     /**
228      * @dev Returns the token collection symbol.
229      */
230     function symbol() external view returns (string memory);
231 
232     /**
233      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
234      */
235     function tokenURI(uint256 tokenId) external view returns (string memory);
236 }
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241  library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize, which returns 0 for contracts in
261         // construction, since the code is only stored at the end of the
262         // constructor execution.
263 
264         uint256 size;
265         assembly {
266             size := extcodesize(account)
267         }
268         return size > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         (bool success, ) = recipient.call{value: amount}("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain `call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         require(isContract(target), "Address: call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.call{value: value}(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.staticcall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(isContract(target), "Address: delegate call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.delegatecall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
424      * revert reason using the provided one.
425      *
426      * _Available since v4.3._
427      */
428     function verifyCallResult(
429         bool success,
430         bytes memory returndata,
431         string memory errorMessage
432     ) internal pure returns (bytes memory) {
433         if (success) {
434             return returndata;
435         } else {
436             // Look for revert reason and bubble it up if present
437             if (returndata.length > 0) {
438                 // The easiest way to bubble the revert reason is using memory via assembly
439 
440                 assembly {
441                     let returndata_size := mload(returndata)
442                     revert(add(32, returndata), returndata_size)
443                 }
444             } else {
445                 revert(errorMessage);
446             }
447         }
448     }
449 }
450 
451 
452 /**
453  * @dev Provides information about the current execution context, including the
454  * sender of the transaction and its data. While these are generally available
455  * via msg.sender and msg.data, they should not be accessed in such a direct
456  * manner, since when dealing with meta-transactions the account sending and
457  * paying for execution may not be the actual sender (as far as an application
458  * is concerned).
459  *
460  * This contract is only required for intermediate, library-like contracts.
461  */
462  abstract contract Context {
463     function _msgSender() internal view virtual returns (address) {
464         return msg.sender;
465     }
466 
467     function _msgData() internal view virtual returns (bytes calldata) {
468         return msg.data;
469     }
470 }
471 
472 
473 /**
474  * @dev String operations.
475  */
476  library Strings {
477     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
478 
479     /**
480      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
481      */
482     function toString(uint256 value) internal pure returns (string memory) {
483         // Inspired by OraclizeAPI's implementation - MIT licence
484         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
485 
486         if (value == 0) {
487             return "0";
488         }
489         uint256 temp = value;
490         uint256 digits;
491         while (temp != 0) {
492             digits++;
493             temp /= 10;
494         }
495         bytes memory buffer = new bytes(digits);
496         while (value != 0) {
497             digits -= 1;
498             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
499             value /= 10;
500         }
501         return string(buffer);
502     }
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
506      */
507     function toHexString(uint256 value) internal pure returns (string memory) {
508         if (value == 0) {
509             return "0x00";
510         }
511         uint256 temp = value;
512         uint256 length = 0;
513         while (temp != 0) {
514             length++;
515             temp >>= 8;
516         }
517         return toHexString(value, length);
518     }
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
522      */
523     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
524         bytes memory buffer = new bytes(2 * length + 2);
525         buffer[0] = "0";
526         buffer[1] = "x";
527         for (uint256 i = 2 * length + 1; i > 1; --i) {
528             buffer[i] = _HEX_SYMBOLS[value & 0xf];
529             value >>= 4;
530         }
531         require(value == 0, "Strings: hex length insufficient");
532         return string(buffer);
533     }
534 }
535 
536 
537 /**
538  * @dev Wrappers over Solidity's arithmetic operations.
539  *
540  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
541  * now has built in overflow checking.
542  */
543  library SafeMath {
544     /**
545      * @dev Returns the addition of two unsigned integers, with an overflow flag.
546      *
547      * _Available since v3.4._
548      */
549     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
550         unchecked {
551             uint256 c = a + b;
552             if (c < a) return (false, 0);
553             return (true, c);
554         }
555     }
556 
557     /**
558      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
559      *
560      * _Available since v3.4._
561      */
562     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
563         unchecked {
564             if (b > a) return (false, 0);
565             return (true, a - b);
566         }
567     }
568 
569     /**
570      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
571      *
572      * _Available since v3.4._
573      */
574     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
575         unchecked {
576             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
577             // benefit is lost if 'b' is also tested.
578             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
579             if (a == 0) return (true, 0);
580             uint256 c = a * b;
581             if (c / a != b) return (false, 0);
582             return (true, c);
583         }
584     }
585 
586     /**
587      * @dev Returns the division of two unsigned integers, with a division by zero flag.
588      *
589      * _Available since v3.4._
590      */
591     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
592         unchecked {
593             if (b == 0) return (false, 0);
594             return (true, a / b);
595         }
596     }
597 
598     /**
599      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
600      *
601      * _Available since v3.4._
602      */
603     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         unchecked {
605             if (b == 0) return (false, 0);
606             return (true, a % b);
607         }
608     }
609 
610     /**
611      * @dev Returns the addition of two unsigned integers, reverting on
612      * overflow.
613      *
614      * Counterpart to Solidity's `+` operator.
615      *
616      * Requirements:
617      *
618      * - Addition cannot overflow.
619      */
620     function add(uint256 a, uint256 b) internal pure returns (uint256) {
621         return a + b;
622     }
623 
624     /**
625      * @dev Returns the subtraction of two unsigned integers, reverting on
626      * overflow (when the result is negative).
627      *
628      * Counterpart to Solidity's `-` operator.
629      *
630      * Requirements:
631      *
632      * - Subtraction cannot overflow.
633      */
634     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
635         return a - b;
636     }
637 
638     /**
639      * @dev Returns the multiplication of two unsigned integers, reverting on
640      * overflow.
641      *
642      * Counterpart to Solidity's `*` operator.
643      *
644      * Requirements:
645      *
646      * - Multiplication cannot overflow.
647      */
648     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
649         return a * b;
650     }
651 
652     /**
653      * @dev Returns the integer division of two unsigned integers, reverting on
654      * division by zero. The result is rounded towards zero.
655      *
656      * Counterpart to Solidity's `/` operator.
657      *
658      * Requirements:
659      *
660      * - The divisor cannot be zero.
661      */
662     function div(uint256 a, uint256 b) internal pure returns (uint256) {
663         return a / b;
664     }
665 
666     /**
667      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
668      * reverting when dividing by zero.
669      *
670      * Counterpart to Solidity's `%` operator. This function uses a `revert`
671      * opcode (which leaves remaining gas untouched) while Solidity uses an
672      * invalid opcode to revert (consuming all remaining gas).
673      *
674      * Requirements:
675      *
676      * - The divisor cannot be zero.
677      */
678     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
679         return a % b;
680     }
681 
682     /**
683      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
684      * overflow (when the result is negative).
685      *
686      * CAUTION: This function is deprecated because it requires allocating memory for the error
687      * message unnecessarily. For custom revert reasons use {trySub}.
688      *
689      * Counterpart to Solidity's `-` operator.
690      *
691      * Requirements:
692      *
693      * - Subtraction cannot overflow.
694      */
695     function sub(
696         uint256 a,
697         uint256 b,
698         string memory errorMessage
699     ) internal pure returns (uint256) {
700         unchecked {
701             require(b <= a, errorMessage);
702             return a - b;
703         }
704     }
705 
706     /**
707      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
708      * division by zero. The result is rounded towards zero.
709      *
710      * Counterpart to Solidity's `/` operator. Note: this function uses a
711      * `revert` opcode (which leaves remaining gas untouched) while Solidity
712      * uses an invalid opcode to revert (consuming all remaining gas).
713      *
714      * Requirements:
715      *
716      * - The divisor cannot be zero.
717      */
718     function div(
719         uint256 a,
720         uint256 b,
721         string memory errorMessage
722     ) internal pure returns (uint256) {
723         unchecked {
724             require(b > 0, errorMessage);
725             return a / b;
726         }
727     }
728 
729     /**
730      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
731      * reverting with custom message when dividing by zero.
732      *
733      * CAUTION: This function is deprecated because it requires allocating memory for the error
734      * message unnecessarily. For custom revert reasons use {tryMod}.
735      *
736      * Counterpart to Solidity's `%` operator. This function uses a `revert`
737      * opcode (which leaves remaining gas untouched) while Solidity uses an
738      * invalid opcode to revert (consuming all remaining gas).
739      *
740      * Requirements:
741      *
742      * - The divisor cannot be zero.
743      */
744     function mod(
745         uint256 a,
746         uint256 b,
747         string memory errorMessage
748     ) internal pure returns (uint256) {
749         unchecked {
750             require(b > 0, errorMessage);
751             return a % b;
752         }
753     }
754 }
755 
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata extension, but not including the Enumerable extension, which is available separately as
760  * {ERC721Enumerable}.
761  */
762  contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
763     using Address for address;
764     using Strings for uint256;
765 
766     // Token name
767     string private _name;
768 
769     // Token symbol
770     string private _symbol;
771 
772 
773     string private baseURI = "";
774 
775     // Mapping from token ID to owner address
776     mapping(uint256 => address) private _owners;
777 
778     // Mapping owner address to token count
779     mapping(address => uint256) private _balances;
780 
781     // Mapping from token ID to approved address
782     mapping(uint256 => address) private _tokenApprovals;
783 
784     // Mapping from owner to operator approvals
785     mapping(address => mapping(address => bool)) private _operatorApprovals;
786 
787     /**
788      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
789      */
790     constructor(string memory name_, string memory symbol_) {
791         _name = name_;
792         _symbol = symbol_;
793     }
794 
795     /**
796      * @dev See {IERC165-supportsInterface}.
797      */
798     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
799         return
800             interfaceId == type(IERC721).interfaceId ||
801             interfaceId == type(IERC721Metadata).interfaceId ||
802             super.supportsInterface(interfaceId);
803     }
804 
805     /**
806      * @dev See {IERC721-balanceOf}.
807      */
808     function balanceOf(address owner) public view virtual override returns (uint256) {
809         require(owner != address(0), "ERC721: balance query for the zero address");
810         return _balances[owner];
811     }
812 
813     /**
814      * @dev See {IERC721-ownerOf}.
815      */
816     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
817         address owner = _owners[tokenId];
818         require(owner != address(0), "ERC721: owner query for nonexistent token");
819         return owner;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-name}.
824      */
825     function name() public view virtual override returns (string memory) {
826         return _name;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-symbol}.
831      */
832     function symbol() public view virtual override returns (string memory) {
833         return _symbol;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-tokenURI}.
838      */
839     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
840         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
841 
842         string memory baseURI_ = _baseURI();
843         return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
844     }
845 
846     /**
847      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
848      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
849      * by default, can be overriden in child contracts.
850      */
851     function _baseURI() internal view virtual returns (string memory) {
852         return baseURI;
853     }
854 
855     function _setBaseURI(string memory baseURI_) internal {
856         baseURI = baseURI_;
857     }
858 
859     /**
860      * @dev See {IERC721-approve}.
861      */
862     function approve(address to, uint256 tokenId) public virtual override {
863         address owner = ERC721.ownerOf(tokenId);
864         require(to != owner, "ERC721: approval to current owner");
865 
866         require(
867             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
868             "ERC721: approve caller is not owner nor approved for all"
869         );
870 
871         _approve(to, tokenId);
872     }
873 
874     /**
875      * @dev See {IERC721-getApproved}.
876      */
877     function getApproved(uint256 tokenId) public view virtual override returns (address) {
878         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
879 
880         return _tokenApprovals[tokenId];
881     }
882 
883     /**
884      * @dev See {IERC721-setApprovalForAll}.
885      */
886     function setApprovalForAll(address operator, bool approved) public virtual override {
887         require(operator != _msgSender(), "ERC721: approve to caller");
888 
889         _operatorApprovals[_msgSender()][operator] = approved;
890         emit ApprovalForAll(_msgSender(), operator, approved);
891     }
892 
893     /**
894      * @dev See {IERC721-isApprovedForAll}.
895      */
896     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
897         return _operatorApprovals[owner][operator];
898     }
899 
900     /**
901      * @dev See {IERC721-transferFrom}.
902      */
903     function transferFrom(
904         address from,
905         address to,
906         uint256 tokenId
907     ) public virtual override {
908         //solhint-disable-next-line max-line-length
909         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
910 
911         _transfer(from, to, tokenId);
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) public virtual override {
922         safeTransferFrom(from, to, tokenId, "");
923     }
924 
925     /**
926      * @dev See {IERC721-safeTransferFrom}.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) public virtual override {
934         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
935         _safeTransfer(from, to, tokenId, _data);
936     }
937 
938     /**
939      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
940      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
941      *
942      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
943      *
944      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
945      * implement alternative mechanisms to perform token transfer, such as signature-based.
946      *
947      * Requirements:
948      *
949      * - `from` cannot be the zero address.
950      * - `to` cannot be the zero address.
951      * - `tokenId` token must exist and be owned by `from`.
952      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _safeTransfer(
957         address from,
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) internal virtual {
962         _transfer(from, to, tokenId);
963         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
964     }
965 
966     /**
967      * @dev Returns whether `tokenId` exists.
968      *
969      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
970      *
971      * Tokens start existing when they are minted (`_mint`),
972      * and stop existing when they are burned (`_burn`).
973      */
974     function _exists(uint256 tokenId) internal view virtual returns (bool) {
975         return _owners[tokenId] != address(0);
976     }
977 
978     /**
979      * @dev Returns whether `spender` is allowed to manage `tokenId`.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must exist.
984      */
985     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
986         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
987         address owner = ERC721.ownerOf(tokenId);
988         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
989     }
990 
991     /**
992      * @dev Safely mints `tokenId` and transfers it to `to`.
993      *
994      * Requirements:
995      *
996      * - `tokenId` must not exist.
997      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _safeMint(address to, uint256 tokenId) internal virtual {
1002         _safeMint(to, tokenId, "");
1003     }
1004 
1005     /**
1006      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1007      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1008      */
1009     function _safeMint(
1010         address to,
1011         uint256 tokenId,
1012         bytes memory _data
1013     ) internal virtual {
1014         _mint(to, tokenId);
1015         require(
1016             _checkOnERC721Received(address(0), to, tokenId, _data),
1017             "ERC721: transfer to non ERC721Receiver implementer"
1018         );
1019     }
1020 
1021     /**
1022      * @dev Mints `tokenId` and transfers it to `to`.
1023      *
1024      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must not exist.
1029      * - `to` cannot be the zero address.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _mint(address to, uint256 tokenId) internal virtual {
1034         require(to != address(0), "ERC721: mint to the zero address");
1035         require(!_exists(tokenId), "ERC721: token already minted");
1036 
1037         _beforeTokenTransfer(address(0), to, tokenId);
1038 
1039         _balances[to] += 1;
1040         _owners[tokenId] = to;
1041 
1042         emit Transfer(address(0), to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Destroys `tokenId`.
1047      * The approval is cleared when the token is burned.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must exist.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _burn(uint256 tokenId) internal virtual {
1056         address owner = ERC721.ownerOf(tokenId);
1057 
1058         _beforeTokenTransfer(owner, address(0), tokenId);
1059 
1060         // Clear approvals
1061         _approve(address(0), tokenId);
1062 
1063         _balances[owner] -= 1;
1064         delete _owners[tokenId];
1065 
1066         emit Transfer(owner, address(0), tokenId);
1067     }
1068 
1069     /**
1070      * @dev Transfers `tokenId` from `from` to `to`.
1071      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1072      *
1073      * Requirements:
1074      *
1075      * - `to` cannot be the zero address.
1076      * - `tokenId` token must be owned by `from`.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _transfer(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) internal virtual {
1085         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1086         require(to != address(0), "ERC721: transfer to the zero address");
1087 
1088         _beforeTokenTransfer(from, to, tokenId);
1089 
1090         // Clear approvals from the previous owner
1091         _approve(address(0), tokenId);
1092 
1093         _balances[from] -= 1;
1094         _balances[to] += 1;
1095         _owners[tokenId] = to;
1096 
1097         emit Transfer(from, to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev Approve `to` to operate on `tokenId`
1102      *
1103      * Emits a {Approval} event.
1104      */
1105     function _approve(address to, uint256 tokenId) internal virtual {
1106         _tokenApprovals[tokenId] = to;
1107         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1108     }
1109 
1110     /**
1111      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1112      * The call is not executed if the target address is not a contract.
1113      *
1114      * @param from address representing the previous owner of the given token ID
1115      * @param to target address that will receive the tokens
1116      * @param tokenId uint256 ID of the token to be transferred
1117      * @param _data bytes optional data to send along with the call
1118      * @return bool whether the call correctly returned the expected magic value
1119      */
1120     function _checkOnERC721Received(
1121         address from,
1122         address to,
1123         uint256 tokenId,
1124         bytes memory _data
1125     ) private returns (bool) {
1126         if (to.isContract()) {
1127             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1128                 return retval == IERC721Receiver.onERC721Received.selector;
1129             } catch (bytes memory reason) {
1130                 if (reason.length == 0) {
1131                     revert("ERC721: transfer to non ERC721Receiver implementer");
1132                 } else {
1133                     assembly {
1134                         revert(add(32, reason), mload(reason))
1135                     }
1136                 }
1137             }
1138         } else {
1139             return true;
1140         }
1141     }
1142 
1143     /**
1144      * @dev Hook that is called before any token transfer. This includes minting
1145      * and burning.
1146      *
1147      * Calling conditions:
1148      *
1149      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1150      * transferred to `to`.
1151      * - When `from` is zero, `tokenId` will be minted for `to`.
1152      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1153      * - `from` and `to` are never both zero.
1154      *
1155      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1156      */
1157     function _beforeTokenTransfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) internal virtual {}
1162 }
1163 
1164 
1165 /**
1166  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1167  * @dev See https://eips.ethereum.org/EIPS/eip-721
1168  */
1169  interface IERC721Enumerable is IERC721 {
1170     /**
1171      * @dev Returns the total amount of tokens stored by the contract.
1172      */
1173     function totalSupply() external view returns (uint256);
1174 
1175     /**
1176      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1177      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1178      */
1179     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1180 
1181     /**
1182      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1183      * Use along with {totalSupply} to enumerate all tokens.
1184      */
1185     function tokenByIndex(uint256 index) external view returns (uint256);
1186 }
1187 
1188 /**
1189  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1190  * enumerability of all the token ids in the contract as well as all token ids owned by each
1191  * account.
1192  */
1193  abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1194     // Mapping from owner to list of owned token IDs
1195     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1196 
1197     // Mapping from token ID to index of the owner tokens list
1198     mapping(uint256 => uint256) private _ownedTokensIndex;
1199 
1200     // Array with all token ids, used for enumeration
1201     uint256[] private _allTokens;
1202 
1203     // Mapping from token id to position in the allTokens array
1204     mapping(uint256 => uint256) private _allTokensIndex;
1205 
1206     /**
1207      * @dev See {IERC165-supportsInterface}.
1208      */
1209     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1210         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1211     }
1212 
1213     /**
1214      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1215      */
1216     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1217         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1218         return _ownedTokens[owner][index];
1219     }
1220 
1221     /**
1222      * @dev See {IERC721Enumerable-totalSupply}.
1223      */
1224     function totalSupply() public view virtual override returns (uint256) {
1225         return _allTokens.length;
1226     }
1227 
1228     /**
1229      * @dev See {IERC721Enumerable-tokenByIndex}.
1230      */
1231     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1232         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1233         return _allTokens[index];
1234     }
1235 
1236     /**
1237      * @dev Hook that is called before any token transfer. This includes minting
1238      * and burning.
1239      *
1240      * Calling conditions:
1241      *
1242      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1243      * transferred to `to`.
1244      * - When `from` is zero, `tokenId` will be minted for `to`.
1245      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1246      * - `from` cannot be the zero address.
1247      * - `to` cannot be the zero address.
1248      *
1249      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1250      */
1251     function _beforeTokenTransfer(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) internal virtual override {
1256         super._beforeTokenTransfer(from, to, tokenId);
1257 
1258         if (from == address(0)) {
1259             _addTokenToAllTokensEnumeration(tokenId);
1260         } else if (from != to) {
1261             _removeTokenFromOwnerEnumeration(from, tokenId);
1262         }
1263         if (to == address(0)) {
1264             _removeTokenFromAllTokensEnumeration(tokenId);
1265         } else if (to != from) {
1266             _addTokenToOwnerEnumeration(to, tokenId);
1267         }
1268     }
1269 
1270     /**
1271      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1272      * @param to address representing the new owner of the given token ID
1273      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1274      */
1275     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1276         uint256 length = ERC721.balanceOf(to);
1277         _ownedTokens[to][length] = tokenId;
1278         _ownedTokensIndex[tokenId] = length;
1279     }
1280 
1281     /**
1282      * @dev Private function to add a token to this extension's token tracking data structures.
1283      * @param tokenId uint256 ID of the token to be added to the tokens list
1284      */
1285     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1286         _allTokensIndex[tokenId] = _allTokens.length;
1287         _allTokens.push(tokenId);
1288     }
1289 
1290     /**
1291      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1292      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1293      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1294      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1295      * @param from address representing the previous owner of the given token ID
1296      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1297      */
1298     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1299         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1300         // then delete the last slot (swap and pop).
1301 
1302         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1303         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1304 
1305         // When the token to delete is the last token, the swap operation is unnecessary
1306         if (tokenIndex != lastTokenIndex) {
1307             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1308 
1309             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1310             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1311         }
1312 
1313         // This also deletes the contents at the last position of the array
1314         delete _ownedTokensIndex[tokenId];
1315         delete _ownedTokens[from][lastTokenIndex];
1316     }
1317 
1318     /**
1319      * @dev Private function to remove a token from this extension's token tracking data structures.
1320      * This has O(1) time complexity, but alters the order of the _allTokens array.
1321      * @param tokenId uint256 ID of the token to be removed from the tokens list
1322      */
1323     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1324         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1325         // then delete the last slot (swap and pop).
1326 
1327         uint256 lastTokenIndex = _allTokens.length - 1;
1328         uint256 tokenIndex = _allTokensIndex[tokenId];
1329 
1330         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1331         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1332         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1333         uint256 lastTokenId = _allTokens[lastTokenIndex];
1334 
1335         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1336         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1337 
1338         // This also deletes the contents at the last position of the array
1339         delete _allTokensIndex[tokenId];
1340         _allTokens.pop();
1341     }
1342 }
1343 
1344 /**
1345  * @dev Contract module which provides a basic access control mechanism, where
1346  * there is an account (an owner) that can be granted exclusive access to
1347  * specific functions.
1348  *
1349  * By default, the owner account will be the one that deploys the contract. This
1350  * can later be changed with {transferOwnership}.
1351  *
1352  * This module is used through inheritance. It will make available the modifier
1353  * `onlyOwner`, which can be applied to your functions to restrict their use to
1354  * the owner.
1355  */
1356  abstract contract Ownable is Context {
1357     address private _owner;
1358 
1359     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1360 
1361     /**
1362      * @dev Initializes the contract setting the deployer as the initial owner.
1363      */
1364     constructor() {
1365         _transferOwnership(_msgSender());
1366     }
1367 
1368     /**
1369      * @dev Returns the address of the current owner.
1370      */
1371     function owner() public view virtual returns (address) {
1372         return _owner;
1373     }
1374 
1375     /**
1376      * @dev Throws if called by any account other than the owner.
1377      */
1378     modifier onlyOwner() {
1379         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1380         _;
1381     }
1382 
1383     /**
1384      * @dev Leaves the contract without owner. It will not be possible to call
1385      * `onlyOwner` functions anymore. Can only be called by the current owner.
1386      *
1387      * NOTE: Renouncing ownership will leave the contract without an owner,
1388      * thereby removing any functionality that is only available to the owner.
1389      */
1390     function renounceOwnership() public virtual onlyOwner {
1391         _transferOwnership(address(0));
1392     }
1393 
1394     /**
1395      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1396      * Can only be called by the current owner.
1397      */
1398     function transferOwnership(address newOwner) public virtual onlyOwner {
1399         require(newOwner != address(0), "Ownable: new owner is the zero address");
1400         _transferOwnership(newOwner);
1401     }
1402 
1403     /**
1404      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1405      * Internal function without access restriction.
1406      */
1407     function _transferOwnership(address newOwner) internal virtual {
1408         address oldOwner = _owner;
1409         _owner = newOwner;
1410         emit OwnershipTransferred(oldOwner, newOwner);
1411     }
1412 }
1413 
1414 
1415 
1416 contract ZooGang is ERC721Enumerable, Ownable {
1417 
1418     using SafeMath for uint256;
1419  
1420     uint256 public constant PRICE = 0.05 ether;
1421 
1422     uint256 public constant MAX_TOKENS = 10000;
1423 
1424     uint256 public constant MAX_PURCHASE = 20;
1425 
1426     bool public saleIsActive = false;
1427 
1428     constructor() ERC721("Zoo Gang", "ZGANG") {}
1429 
1430     function withdraw() public onlyOwner {
1431         address payable sender = payable(_msgSender());
1432         uint balance = address(this).balance;
1433         sender.transfer(balance);
1434     }
1435 
1436     function toggleSale() public onlyOwner {
1437         saleIsActive = !saleIsActive;
1438     }
1439 
1440     /**
1441      * Set some Zoo Gang aside
1442      */
1443     function reserve() public onlyOwner {     
1444         require(saleIsActive == false, "Impossible reserve a Zoo Gang when sale is active");   
1445         uint supply = totalSupply();
1446         for (uint i = 0; i < 20; i++) {
1447             _safeMint(_msgSender(), supply + i);
1448         }
1449     }
1450 
1451     /**
1452     * Mint Zoo Gang
1453     */
1454     function mint(uint256 numberOfTokens) public payable {
1455         require(saleIsActive, "Sale must be active to mint Zoo Gang");
1456         require(numberOfTokens <= MAX_PURCHASE, "Can only mint 20 tokens at a time");
1457         require(totalSupply().add(numberOfTokens) <= MAX_TOKENS, "Purchase would exceed max supply of Zoo Gangs");
1458         require(PRICE.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1459         
1460         for(uint i = 0; i < numberOfTokens; i++) {
1461             uint mintIndex = totalSupply();
1462             if (totalSupply() < MAX_TOKENS) {
1463                 _safeMint(_msgSender(), mintIndex);
1464             }
1465         }
1466     }
1467 
1468     function setBaseURI(string memory baseURI) public onlyOwner {
1469         _setBaseURI(baseURI);
1470     }
1471 }