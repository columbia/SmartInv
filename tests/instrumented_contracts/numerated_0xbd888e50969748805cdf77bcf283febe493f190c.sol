1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**  
5  * 
6  * Metaverse Travel Agency
7  * =======================
8  * https://themta.io
9  * twiter: @themtaofficial
10  *
11  * MetaHelmet
12  * ----------
13  */
14 
15 
16 /**
17  * @dev Interface of the ERC165 standard, as defined in the
18  * https://eips.ethereum.org/EIPS/eip-165[EIP].
19  *
20  * Implementers can declare support of contract interfaces, which can then be
21  * queried by others ({ERC165Checker}).
22  *
23  * For an implementation, see {ERC165}.
24  */
25  interface IERC165 {
26     /**
27      * @dev Returns true if this contract implements the interface defined by
28      * `interfaceId`. See the corresponding
29      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
30      * to learn more about how these ids are created.
31      *
32      * This function call must use less than 30 000 gas.
33      */
34     function supportsInterface(bytes4 interfaceId) external view returns (bool);
35 }
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 
175 /**
176  * @dev Implementation of the {IERC165} interface.
177  *
178  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
179  * for the additional interface id that will be supported. For example:
180  *
181  * ```solidity
182  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
183  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
184  * }
185  * ```
186  *
187  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
188  */
189  abstract contract ERC165 is IERC165 {
190     /**
191      * @dev See {IERC165-supportsInterface}.
192      */
193     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
194         return interfaceId == type(IERC165).interfaceId;
195     }
196 }
197 
198 /**
199  * @title ERC721 token receiver interface
200  * @dev Interface for any contract that wants to support safeTransfers
201  * from ERC721 asset contracts.
202  */
203  interface IERC721Receiver {
204     /**
205      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
206      * by `operator` from `from`, this function is called.
207      *
208      * It must return its Solidity selector to confirm the token transfer.
209      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
210      *
211      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
212      */
213     function onERC721Received(
214         address operator,
215         address from,
216         uint256 tokenId,
217         bytes calldata data
218     ) external returns (bytes4);
219 }
220 
221 
222 /**
223  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
224  * @dev See https://eips.ethereum.org/EIPS/eip-721
225  */
226  interface IERC721Metadata is IERC721 {
227     /**
228      * @dev Returns the token collection name.
229      */
230     function name() external view returns (string memory);
231 
232     /**
233      * @dev Returns the token collection symbol.
234      */
235     function symbol() external view returns (string memory);
236 
237     /**
238      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
239      */
240     function tokenURI(uint256 tokenId) external view returns (string memory);
241 }
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246  library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         assembly {
271             size := extcodesize(account)
272         }
273         return size > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         (bool success, ) = recipient.call{value: amount}("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain `call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         require(isContract(target), "Address: call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.call{value: value}(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
380         return functionStaticCall(target, data, "Address: low-level static call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal view returns (bytes memory) {
394         require(isContract(target), "Address: static call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.staticcall(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
407         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(isContract(target), "Address: delegate call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.delegatecall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
429      * revert reason using the provided one.
430      *
431      * _Available since v4.3._
432      */
433     function verifyCallResult(
434         bool success,
435         bytes memory returndata,
436         string memory errorMessage
437     ) internal pure returns (bytes memory) {
438         if (success) {
439             return returndata;
440         } else {
441             // Look for revert reason and bubble it up if present
442             if (returndata.length > 0) {
443                 // The easiest way to bubble the revert reason is using memory via assembly
444 
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 
457 /**
458  * @dev Provides information about the current execution context, including the
459  * sender of the transaction and its data. While these are generally available
460  * via msg.sender and msg.data, they should not be accessed in such a direct
461  * manner, since when dealing with meta-transactions the account sending and
462  * paying for execution may not be the actual sender (as far as an application
463  * is concerned).
464  *
465  * This contract is only required for intermediate, library-like contracts.
466  */
467  abstract contract Context {
468     function _msgSender() internal view virtual returns (address) {
469         return msg.sender;
470     }
471 
472     function _msgData() internal view virtual returns (bytes calldata) {
473         return msg.data;
474     }
475 }
476 
477 
478 /**
479  * @dev String operations.
480  */
481  library Strings {
482     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
486      */
487     function toString(uint256 value) internal pure returns (string memory) {
488         // Inspired by OraclizeAPI's implementation - MIT licence
489         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
490 
491         if (value == 0) {
492             return "0";
493         }
494         uint256 temp = value;
495         uint256 digits;
496         while (temp != 0) {
497             digits++;
498             temp /= 10;
499         }
500         bytes memory buffer = new bytes(digits);
501         while (value != 0) {
502             digits -= 1;
503             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
504             value /= 10;
505         }
506         return string(buffer);
507     }
508 
509     /**
510      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
511      */
512     function toHexString(uint256 value) internal pure returns (string memory) {
513         if (value == 0) {
514             return "0x00";
515         }
516         uint256 temp = value;
517         uint256 length = 0;
518         while (temp != 0) {
519             length++;
520             temp >>= 8;
521         }
522         return toHexString(value, length);
523     }
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
527      */
528     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
529         bytes memory buffer = new bytes(2 * length + 2);
530         buffer[0] = "0";
531         buffer[1] = "x";
532         for (uint256 i = 2 * length + 1; i > 1; --i) {
533             buffer[i] = _HEX_SYMBOLS[value & 0xf];
534             value >>= 4;
535         }
536         require(value == 0, "Strings: hex length insufficient");
537         return string(buffer);
538     }
539 }
540 
541 
542 /**
543  * @dev Wrappers over Solidity's arithmetic operations.
544  *
545  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
546  * now has built in overflow checking.
547  */
548  library SafeMath {
549     /**
550      * @dev Returns the addition of two unsigned integers, with an overflow flag.
551      *
552      * _Available since v3.4._
553      */
554     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
555         unchecked {
556             uint256 c = a + b;
557             if (c < a) return (false, 0);
558             return (true, c);
559         }
560     }
561 
562     /**
563      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
564      *
565      * _Available since v3.4._
566      */
567     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
568         unchecked {
569             if (b > a) return (false, 0);
570             return (true, a - b);
571         }
572     }
573 
574     /**
575      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
576      *
577      * _Available since v3.4._
578      */
579     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
580         unchecked {
581             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
582             // benefit is lost if 'b' is also tested.
583             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
584             if (a == 0) return (true, 0);
585             uint256 c = a * b;
586             if (c / a != b) return (false, 0);
587             return (true, c);
588         }
589     }
590 
591     /**
592      * @dev Returns the division of two unsigned integers, with a division by zero flag.
593      *
594      * _Available since v3.4._
595      */
596     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
597         unchecked {
598             if (b == 0) return (false, 0);
599             return (true, a / b);
600         }
601     }
602 
603     /**
604      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
605      *
606      * _Available since v3.4._
607      */
608     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
609         unchecked {
610             if (b == 0) return (false, 0);
611             return (true, a % b);
612         }
613     }
614 
615     /**
616      * @dev Returns the addition of two unsigned integers, reverting on
617      * overflow.
618      *
619      * Counterpart to Solidity's `+` operator.
620      *
621      * Requirements:
622      *
623      * - Addition cannot overflow.
624      */
625     function add(uint256 a, uint256 b) internal pure returns (uint256) {
626         return a + b;
627     }
628 
629     /**
630      * @dev Returns the subtraction of two unsigned integers, reverting on
631      * overflow (when the result is negative).
632      *
633      * Counterpart to Solidity's `-` operator.
634      *
635      * Requirements:
636      *
637      * - Subtraction cannot overflow.
638      */
639     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
640         return a - b;
641     }
642 
643     /**
644      * @dev Returns the multiplication of two unsigned integers, reverting on
645      * overflow.
646      *
647      * Counterpart to Solidity's `*` operator.
648      *
649      * Requirements:
650      *
651      * - Multiplication cannot overflow.
652      */
653     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
654         return a * b;
655     }
656 
657     /**
658      * @dev Returns the integer division of two unsigned integers, reverting on
659      * division by zero. The result is rounded towards zero.
660      *
661      * Counterpart to Solidity's `/` operator.
662      *
663      * Requirements:
664      *
665      * - The divisor cannot be zero.
666      */
667     function div(uint256 a, uint256 b) internal pure returns (uint256) {
668         return a / b;
669     }
670 
671     /**
672      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
673      * reverting when dividing by zero.
674      *
675      * Counterpart to Solidity's `%` operator. This function uses a `revert`
676      * opcode (which leaves remaining gas untouched) while Solidity uses an
677      * invalid opcode to revert (consuming all remaining gas).
678      *
679      * Requirements:
680      *
681      * - The divisor cannot be zero.
682      */
683     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a % b;
685     }
686 
687     /**
688      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
689      * overflow (when the result is negative).
690      *
691      * CAUTION: This function is deprecated because it requires allocating memory for the error
692      * message unnecessarily. For custom revert reasons use {trySub}.
693      *
694      * Counterpart to Solidity's `-` operator.
695      *
696      * Requirements:
697      *
698      * - Subtraction cannot overflow.
699      */
700     function sub(
701         uint256 a,
702         uint256 b,
703         string memory errorMessage
704     ) internal pure returns (uint256) {
705         unchecked {
706             require(b <= a, errorMessage);
707             return a - b;
708         }
709     }
710 
711     /**
712      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
713      * division by zero. The result is rounded towards zero.
714      *
715      * Counterpart to Solidity's `/` operator. Note: this function uses a
716      * `revert` opcode (which leaves remaining gas untouched) while Solidity
717      * uses an invalid opcode to revert (consuming all remaining gas).
718      *
719      * Requirements:
720      *
721      * - The divisor cannot be zero.
722      */
723     function div(
724         uint256 a,
725         uint256 b,
726         string memory errorMessage
727     ) internal pure returns (uint256) {
728         unchecked {
729             require(b > 0, errorMessage);
730             return a / b;
731         }
732     }
733 
734     /**
735      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
736      * reverting with custom message when dividing by zero.
737      *
738      * CAUTION: This function is deprecated because it requires allocating memory for the error
739      * message unnecessarily. For custom revert reasons use {tryMod}.
740      *
741      * Counterpart to Solidity's `%` operator. This function uses a `revert`
742      * opcode (which leaves remaining gas untouched) while Solidity uses an
743      * invalid opcode to revert (consuming all remaining gas).
744      *
745      * Requirements:
746      *
747      * - The divisor cannot be zero.
748      */
749     function mod(
750         uint256 a,
751         uint256 b,
752         string memory errorMessage
753     ) internal pure returns (uint256) {
754         unchecked {
755             require(b > 0, errorMessage);
756             return a % b;
757         }
758     }
759 }
760 
761 
762 /**
763  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
764  * the Metadata extension, but not including the Enumerable extension, which is available separately as
765  * {ERC721Enumerable}.
766  */
767  contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
768     using Address for address;
769     using Strings for uint256;
770 
771     // Token name
772     string private _name;
773 
774     // Token symbol
775     string private _symbol;
776 
777 
778     string private baseURI = "";
779 
780     // Mapping from token ID to owner address
781     mapping(uint256 => address) private _owners;
782 
783     // Mapping owner address to token count
784     mapping(address => uint256) private _balances;
785 
786     // Mapping from token ID to approved address
787     mapping(uint256 => address) private _tokenApprovals;
788 
789     // Mapping from owner to operator approvals
790     mapping(address => mapping(address => bool)) private _operatorApprovals;
791 
792     /**
793      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
794      */
795     constructor(string memory name_, string memory symbol_) {
796         _name = name_;
797         _symbol = symbol_;
798     }
799 
800     /**
801      * @dev See {IERC165-supportsInterface}.
802      */
803     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
804         return
805             interfaceId == type(IERC721).interfaceId ||
806             interfaceId == type(IERC721Metadata).interfaceId ||
807             super.supportsInterface(interfaceId);
808     }
809 
810     /**
811      * @dev See {IERC721-balanceOf}.
812      */
813     function balanceOf(address owner) public view virtual override returns (uint256) {
814         require(owner != address(0), "ERC721: balance query for the zero address");
815         return _balances[owner];
816     }
817 
818     /**
819      * @dev See {IERC721-ownerOf}.
820      */
821     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
822         address owner = _owners[tokenId];
823         require(owner != address(0), "ERC721: owner query for nonexistent token");
824         return owner;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-name}.
829      */
830     function name() public view virtual override returns (string memory) {
831         return _name;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-symbol}.
836      */
837     function symbol() public view virtual override returns (string memory) {
838         return _symbol;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-tokenURI}.
843      */
844     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
845         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
846 
847         string memory baseURI_ = _baseURI();
848         return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
849     }
850 
851     /**
852      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
853      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
854      * by default, can be overriden in child contracts.
855      */
856     function _baseURI() internal view virtual returns (string memory) {
857         return baseURI;
858     }
859 
860     function _setBaseURI(string memory baseURI_) internal {
861         baseURI = baseURI_;
862     }
863 
864     /**
865      * @dev See {IERC721-approve}.
866      */
867     function approve(address to, uint256 tokenId) public virtual override {
868         address owner = ERC721.ownerOf(tokenId);
869         require(to != owner, "ERC721: approval to current owner");
870 
871         require(
872             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
873             "ERC721: approve caller is not owner nor approved for all"
874         );
875 
876         _approve(to, tokenId);
877     }
878 
879     /**
880      * @dev See {IERC721-getApproved}.
881      */
882     function getApproved(uint256 tokenId) public view virtual override returns (address) {
883         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
884 
885         return _tokenApprovals[tokenId];
886     }
887 
888     /**
889      * @dev See {IERC721-setApprovalForAll}.
890      */
891     function setApprovalForAll(address operator, bool approved) public virtual override {
892         require(operator != _msgSender(), "ERC721: approve to caller");
893 
894         _operatorApprovals[_msgSender()][operator] = approved;
895         emit ApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     /**
899      * @dev See {IERC721-isApprovedForAll}.
900      */
901     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
902         return _operatorApprovals[owner][operator];
903     }
904 
905     /**
906      * @dev See {IERC721-transferFrom}.
907      */
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         //solhint-disable-next-line max-line-length
914         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
915 
916         _transfer(from, to, tokenId);
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId
926     ) public virtual override {
927         safeTransferFrom(from, to, tokenId, "");
928     }
929 
930     /**
931      * @dev See {IERC721-safeTransferFrom}.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) public virtual override {
939         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
940         _safeTransfer(from, to, tokenId, _data);
941     }
942 
943     /**
944      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
945      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
946      *
947      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
948      *
949      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
950      * implement alternative mechanisms to perform token transfer, such as signature-based.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must exist and be owned by `from`.
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _safeTransfer(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) internal virtual {
967         _transfer(from, to, tokenId);
968         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted (`_mint`),
977      * and stop existing when they are burned (`_burn`).
978      */
979     function _exists(uint256 tokenId) internal view virtual returns (bool) {
980         return _owners[tokenId] != address(0);
981     }
982 
983     /**
984      * @dev Returns whether `spender` is allowed to manage `tokenId`.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
991         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
992         address owner = ERC721.ownerOf(tokenId);
993         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
994     }
995 
996     /**
997      * @dev Safely mints `tokenId` and transfers it to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeMint(address to, uint256 tokenId) internal virtual {
1007         _safeMint(to, tokenId, "");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1012      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1013      */
1014     function _safeMint(
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) internal virtual {
1019         _mint(to, tokenId);
1020         require(
1021             _checkOnERC721Received(address(0), to, tokenId, _data),
1022             "ERC721: transfer to non ERC721Receiver implementer"
1023         );
1024     }
1025 
1026     /**
1027      * @dev Mints `tokenId` and transfers it to `to`.
1028      *
1029      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must not exist.
1034      * - `to` cannot be the zero address.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _mint(address to, uint256 tokenId) internal virtual {
1039         require(to != address(0), "ERC721: mint to the zero address");
1040         require(!_exists(tokenId), "ERC721: token already minted");
1041 
1042         _beforeTokenTransfer(address(0), to, tokenId);
1043 
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(address(0), to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Destroys `tokenId`.
1052      * The approval is cleared when the token is burned.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _burn(uint256 tokenId) internal virtual {
1061         address owner = ERC721.ownerOf(tokenId);
1062 
1063         _beforeTokenTransfer(owner, address(0), tokenId);
1064 
1065         // Clear approvals
1066         _approve(address(0), tokenId);
1067 
1068         _balances[owner] -= 1;
1069         delete _owners[tokenId];
1070 
1071         emit Transfer(owner, address(0), tokenId);
1072     }
1073 
1074     /**
1075      * @dev Transfers `tokenId` from `from` to `to`.
1076      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `tokenId` token must be owned by `from`.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _transfer(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) internal virtual {
1090         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1091         require(to != address(0), "ERC721: transfer to the zero address");
1092 
1093         _beforeTokenTransfer(from, to, tokenId);
1094 
1095         // Clear approvals from the previous owner
1096         _approve(address(0), tokenId);
1097 
1098         _balances[from] -= 1;
1099         _balances[to] += 1;
1100         _owners[tokenId] = to;
1101 
1102         emit Transfer(from, to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev Approve `to` to operate on `tokenId`
1107      *
1108      * Emits a {Approval} event.
1109      */
1110     function _approve(address to, uint256 tokenId) internal virtual {
1111         _tokenApprovals[tokenId] = to;
1112         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1113     }
1114 
1115     /**
1116      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1117      * The call is not executed if the target address is not a contract.
1118      *
1119      * @param from address representing the previous owner of the given token ID
1120      * @param to target address that will receive the tokens
1121      * @param tokenId uint256 ID of the token to be transferred
1122      * @param _data bytes optional data to send along with the call
1123      * @return bool whether the call correctly returned the expected magic value
1124      */
1125     function _checkOnERC721Received(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes memory _data
1130     ) private returns (bool) {
1131         if (to.isContract()) {
1132             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1133                 return retval == IERC721Receiver.onERC721Received.selector;
1134             } catch (bytes memory reason) {
1135                 if (reason.length == 0) {
1136                     revert("ERC721: transfer to non ERC721Receiver implementer");
1137                 } else {
1138                     assembly {
1139                         revert(add(32, reason), mload(reason))
1140                     }
1141                 }
1142             }
1143         } else {
1144             return true;
1145         }
1146     }
1147 
1148     /**
1149      * @dev Hook that is called before any token transfer. This includes minting
1150      * and burning.
1151      *
1152      * Calling conditions:
1153      *
1154      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1155      * transferred to `to`.
1156      * - When `from` is zero, `tokenId` will be minted for `to`.
1157      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1158      * - `from` and `to` are never both zero.
1159      *
1160      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1161      */
1162     function _beforeTokenTransfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) internal virtual {}
1167 }
1168 
1169 
1170 /**
1171  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1172  * @dev See https://eips.ethereum.org/EIPS/eip-721
1173  */
1174  interface IERC721Enumerable is IERC721 {
1175     /**
1176      * @dev Returns the total amount of tokens stored by the contract.
1177      */
1178     function totalSupply() external view returns (uint256);
1179 
1180     /**
1181      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1182      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1183      */
1184     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1185 
1186     /**
1187      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1188      * Use along with {totalSupply} to enumerate all tokens.
1189      */
1190     function tokenByIndex(uint256 index) external view returns (uint256);
1191 }
1192 
1193 /**
1194  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1195  * enumerability of all the token ids in the contract as well as all token ids owned by each
1196  * account.
1197  */
1198  abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1199     // Mapping from owner to list of owned token IDs
1200     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1201 
1202     // Mapping from token ID to index of the owner tokens list
1203     mapping(uint256 => uint256) private _ownedTokensIndex;
1204 
1205     // Array with all token ids, used for enumeration
1206     uint256[] private _allTokens;
1207 
1208     // Mapping from token id to position in the allTokens array
1209     mapping(uint256 => uint256) private _allTokensIndex;
1210 
1211     /**
1212      * @dev See {IERC165-supportsInterface}.
1213      */
1214     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1215         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1216     }
1217 
1218     /**
1219      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1220      */
1221     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1222         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1223         return _ownedTokens[owner][index];
1224     }
1225 
1226     /**
1227      * @dev See {IERC721Enumerable-totalSupply}.
1228      */
1229     function totalSupply() public view virtual override returns (uint256) {
1230         return _allTokens.length;
1231     }
1232 
1233     /**
1234      * @dev See {IERC721Enumerable-tokenByIndex}.
1235      */
1236     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1237         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1238         return _allTokens[index];
1239     }
1240 
1241     /**
1242      * @dev Hook that is called before any token transfer. This includes minting
1243      * and burning.
1244      *
1245      * Calling conditions:
1246      *
1247      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1248      * transferred to `to`.
1249      * - When `from` is zero, `tokenId` will be minted for `to`.
1250      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1251      * - `from` cannot be the zero address.
1252      * - `to` cannot be the zero address.
1253      *
1254      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1255      */
1256     function _beforeTokenTransfer(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) internal virtual override {
1261         super._beforeTokenTransfer(from, to, tokenId);
1262 
1263         if (from == address(0)) {
1264             _addTokenToAllTokensEnumeration(tokenId);
1265         } else if (from != to) {
1266             _removeTokenFromOwnerEnumeration(from, tokenId);
1267         }
1268         if (to == address(0)) {
1269             _removeTokenFromAllTokensEnumeration(tokenId);
1270         } else if (to != from) {
1271             _addTokenToOwnerEnumeration(to, tokenId);
1272         }
1273     }
1274 
1275     /**
1276      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1277      * @param to address representing the new owner of the given token ID
1278      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1279      */
1280     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1281         uint256 length = ERC721.balanceOf(to);
1282         _ownedTokens[to][length] = tokenId;
1283         _ownedTokensIndex[tokenId] = length;
1284     }
1285 
1286     /**
1287      * @dev Private function to add a token to this extension's token tracking data structures.
1288      * @param tokenId uint256 ID of the token to be added to the tokens list
1289      */
1290     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1291         _allTokensIndex[tokenId] = _allTokens.length;
1292         _allTokens.push(tokenId);
1293     }
1294 
1295     /**
1296      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1297      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1298      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1299      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1300      * @param from address representing the previous owner of the given token ID
1301      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1302      */
1303     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1304         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1305         // then delete the last slot (swap and pop).
1306 
1307         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1308         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1309 
1310         // When the token to delete is the last token, the swap operation is unnecessary
1311         if (tokenIndex != lastTokenIndex) {
1312             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1313 
1314             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1315             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1316         }
1317 
1318         // This also deletes the contents at the last position of the array
1319         delete _ownedTokensIndex[tokenId];
1320         delete _ownedTokens[from][lastTokenIndex];
1321     }
1322 
1323     /**
1324      * @dev Private function to remove a token from this extension's token tracking data structures.
1325      * This has O(1) time complexity, but alters the order of the _allTokens array.
1326      * @param tokenId uint256 ID of the token to be removed from the tokens list
1327      */
1328     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1329         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1330         // then delete the last slot (swap and pop).
1331 
1332         uint256 lastTokenIndex = _allTokens.length - 1;
1333         uint256 tokenIndex = _allTokensIndex[tokenId];
1334 
1335         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1336         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1337         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1338         uint256 lastTokenId = _allTokens[lastTokenIndex];
1339 
1340         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1341         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1342 
1343         // This also deletes the contents at the last position of the array
1344         delete _allTokensIndex[tokenId];
1345         _allTokens.pop();
1346     }
1347 }
1348 
1349 /**
1350  * @dev Contract module which provides a basic access control mechanism, where
1351  * there is an account (an owner) that can be granted exclusive access to
1352  * specific functions.
1353  *
1354  * By default, the owner account will be the one that deploys the contract. This
1355  * can later be changed with {transferOwnership}.
1356  *
1357  * This module is used through inheritance. It will make available the modifier
1358  * `onlyOwner`, which can be applied to your functions to restrict their use to
1359  * the owner.
1360  */
1361  abstract contract Ownable is Context {
1362     address private _owner;
1363 
1364     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1365 
1366     /**
1367      * @dev Initializes the contract setting the deployer as the initial owner.
1368      */
1369     constructor() {
1370         _transferOwnership(_msgSender());
1371     }
1372 
1373     /**
1374      * @dev Returns the address of the current owner.
1375      */
1376     function owner() public view virtual returns (address) {
1377         return _owner;
1378     }
1379 
1380     /**
1381      * @dev Throws if called by any account other than the owner.
1382      */
1383     modifier onlyOwner() {
1384         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1385         _;
1386     }
1387 
1388     /**
1389      * @dev Leaves the contract without owner. It will not be possible to call
1390      * `onlyOwner` functions anymore. Can only be called by the current owner.
1391      *
1392      * NOTE: Renouncing ownership will leave the contract without an owner,
1393      * thereby removing any functionality that is only available to the owner.
1394      */
1395     function renounceOwnership() public virtual onlyOwner {
1396         _transferOwnership(address(0));
1397     }
1398 
1399     /**
1400      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1401      * Can only be called by the current owner.
1402      */
1403     function transferOwnership(address newOwner) public virtual onlyOwner {
1404         require(newOwner != address(0), "Ownable: new owner is the zero address");
1405         _transferOwnership(newOwner);
1406     }
1407 
1408     /**
1409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1410      * Internal function without access restriction.
1411      */
1412     function _transferOwnership(address newOwner) internal virtual {
1413         address oldOwner = _owner;
1414         _owner = newOwner;
1415         emit OwnershipTransferred(oldOwner, newOwner);
1416     }
1417 }
1418 
1419 
1420 
1421 contract Metahelmet is ERC721Enumerable, Ownable {
1422 
1423     using SafeMath for uint256;
1424 
1425     string public METAHELMET_PROVENANCE = "";
1426  
1427     uint256 public constant PRICE = 101010000000000000;
1428 
1429     uint256 public constant MAX_METAHELMETS = 10101;
1430 
1431     uint256 public constant MAX_PURCHASE = 7;
1432 
1433     bool public saleIsActive = false;
1434 
1435     mapping (address => uint256) public whitelistMinted;
1436 
1437     address public WHITELIST_SIGNER;
1438 
1439     event Merge(uint256 indexed tokenId, address indexed nftContract, uint256 indexed nftId);
1440 
1441     event Unmerge(uint256 indexed tokenId);
1442 
1443     constructor() ERC721("MetaHelmet", "MTAH") {}
1444 
1445     function withdraw() public onlyOwner {
1446         address payable sender = payable(_msgSender());
1447         uint balance = address(this).balance;
1448         sender.transfer(balance);
1449     }
1450 
1451     function toggleSale() public onlyOwner {
1452         saleIsActive = !saleIsActive;
1453     }
1454 
1455     function setWhiteListSigner(address signer) public onlyOwner {
1456         WHITELIST_SIGNER = signer;
1457     }
1458 
1459     /**
1460      * Set some Metahelmets aside
1461      */
1462     function reserveMetahelmets() public onlyOwner {     
1463         require(saleIsActive == false, "Impossible reserve a Metahelmet when sale is active");   
1464         uint supply = totalSupply();
1465         for (uint i = 0; i < 21; i++) {
1466             _safeMint(_msgSender(), supply + i);
1467         }
1468     }
1469 
1470     /**
1471     * Mint Metahelmet
1472     */
1473     function mintMetahelmet(uint256 numberOfTokens) public payable {
1474         require(saleIsActive, "Sale must be active to mint Metahelmet");
1475         require(numberOfTokens <= MAX_PURCHASE, "Can only mint 7 tokens at a time");
1476         require(totalSupply().add(numberOfTokens) <= MAX_METAHELMETS, "Purchase would exceed max supply of Metahelmets");
1477         require(PRICE.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1478         
1479         for(uint i = 0; i < numberOfTokens; i++) {
1480             uint mintIndex = totalSupply();
1481             if (totalSupply() < MAX_METAHELMETS) {
1482                 _safeMint(_msgSender(), mintIndex);
1483             }
1484         }
1485     }
1486 
1487     /**
1488      * PreMint: Only people in whitelist can mint
1489      */
1490     function preMintMetahelmet(uint256 numberOfTokens, uint max, bytes memory signature) public payable {
1491         bytes32 hash;
1492         require(WHITELIST_SIGNER != address(0), "Pre-Mint is not available yet");
1493         require(saleIsActive == false, "Impossible Pre-Mint a Matahelmet when sale is active");   
1494         require(numberOfTokens <= MAX_PURCHASE, "Can only mint 7 tokens at a time");
1495         require(totalSupply().add(numberOfTokens) <= MAX_METAHELMETS, "Purchase would exceed max supply of Metahelmets");
1496         require(PRICE.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1497 
1498         /*
1499          * keccak256(address,number);
1500          */
1501         hash = keccak256(abi.encodePacked(_msgSender(), max));
1502 
1503         /*
1504          * Check Signature
1505          */ 
1506         require(recover(hash,signature) == WHITELIST_SIGNER, "Invalid Signature");
1507 
1508         /*
1509          * Check max min reached
1510          */ 
1511         require(whitelistMinted[_msgSender()].add(numberOfTokens) <= max, "Max mint reached");
1512 
1513         /*
1514          * Update total minted in preMint state
1515          */
1516         whitelistMinted[_msgSender()] = whitelistMinted[_msgSender()].add(numberOfTokens);
1517 
1518         uint supply = totalSupply();
1519         for(uint i = 0; i < numberOfTokens; i++) {
1520             _safeMint(_msgSender(), supply+i);
1521         }
1522     }
1523 
1524     /**      
1525      * Set provenance once it's calculated
1526      */
1527     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1528         METAHELMET_PROVENANCE = provenanceHash;
1529     }
1530 
1531     function setBaseURI(string memory baseURI) public onlyOwner {
1532         _setBaseURI(baseURI);
1533     }
1534 
1535     function merge(uint256 _tokenId, IERC721 _nftContract, uint256 _nftId) public {
1536         require(ownerOf(_tokenId) == _msgSender(), "Only owner can merge tokens");
1537         require(_nftContract.ownerOf(_nftId) == _msgSender(), "Only owner can merge tokens");
1538     
1539         emit Merge(_tokenId, address(_nftContract), _nftId);
1540     }
1541 
1542     function unmerge(uint256 _tokenId) public {
1543         require(ownerOf(_tokenId) == _msgSender(), "Only owner can unmerge tokens");
1544         emit Unmerge(_tokenId);
1545     }
1546 
1547     function recover(bytes32 _hash, bytes memory _signed) internal pure returns(address) {
1548         bytes32 r;
1549         bytes32 s;
1550         uint8 v;
1551         
1552         assembly {
1553             r:= mload(add(_signed,32))
1554             s:= mload(add(_signed,64))
1555             v:= and(mload(add(_signed,65)) ,255)
1556         }
1557         return ecrecover(_hash,v,r,s);
1558     } 
1559 }