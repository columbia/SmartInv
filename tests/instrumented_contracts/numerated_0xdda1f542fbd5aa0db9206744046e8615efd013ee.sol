1 // Dependency file: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 
29 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // pragma solidity ^0.8.0;
33 
34 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
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
174 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
175 
176 
177 // pragma solidity ^0.8.0;
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
203 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
204 
205 
206 // pragma solidity ^0.8.0;
207 
208 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 
232 // Dependency file: @openzeppelin/contracts/utils/Address.sol
233 
234 
235 // pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies on extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         uint256 size;
264         assembly {
265             size := extcodesize(account)
266         }
267         return size > 0;
268     }
269 
270     /**
271      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
272      * `recipient`, forwarding all available gas and reverting on errors.
273      *
274      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
275      * of certain opcodes, possibly making contracts go over the 2300 gas limit
276      * imposed by `transfer`, making them unable to receive funds via
277      * `transfer`. {sendValue} removes this limitation.
278      *
279      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
280      *
281      * IMPORTANT: because control is transferred to `recipient`, care must be
282      * taken to not create reentrancy vulnerabilities. Consider using
283      * {ReentrancyGuard} or the
284      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
285      */
286     function sendValue(address payable recipient, uint256 amount) internal {
287         require(address(this).balance >= amount, "Address: insufficient balance");
288 
289         (bool success, ) = recipient.call{value: amount}("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain `call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         require(isContract(target), "Address: call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.call{value: value}(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
374         return functionStaticCall(target, data, "Address: low-level static call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal view returns (bytes memory) {
388         require(isContract(target), "Address: static call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.staticcall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a delegate call.
407      *
408      * _Available since v3.4._
409      */
410     function functionDelegateCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         require(isContract(target), "Address: delegate call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.delegatecall(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
423      * revert reason using the provided one.
424      *
425      * _Available since v4.3._
426      */
427     function verifyCallResult(
428         bool success,
429         bytes memory returndata,
430         string memory errorMessage
431     ) internal pure returns (bytes memory) {
432         if (success) {
433             return returndata;
434         } else {
435             // Look for revert reason and bubble it up if present
436             if (returndata.length > 0) {
437                 // The easiest way to bubble the revert reason is using memory via assembly
438 
439                 assembly {
440                     let returndata_size := mload(returndata)
441                     revert(add(32, returndata), returndata_size)
442                 }
443             } else {
444                 revert(errorMessage);
445             }
446         }
447     }
448 }
449 
450 
451 // Dependency file: @openzeppelin/contracts/utils/Context.sol
452 
453 
454 // pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Provides information about the current execution context, including the
458  * sender of the transaction and its data. While these are generally available
459  * via msg.sender and msg.data, they should not be accessed in such a direct
460  * manner, since when dealing with meta-transactions the account sending and
461  * paying for execution may not be the actual sender (as far as an application
462  * is concerned).
463  *
464  * This contract is only required for intermediate, library-like contracts.
465  */
466 abstract contract Context {
467     function _msgSender() internal view virtual returns (address) {
468         return msg.sender;
469     }
470 
471     function _msgData() internal view virtual returns (bytes calldata) {
472         return msg.data;
473     }
474 }
475 
476 
477 // Dependency file: @openzeppelin/contracts/utils/Strings.sol
478 
479 
480 // pragma solidity ^0.8.0;
481 
482 /**
483  * @dev String operations.
484  */
485 library Strings {
486     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
487 
488     /**
489      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
490      */
491     function toString(uint256 value) internal pure returns (string memory) {
492         // Inspired by OraclizeAPI's implementation - MIT licence
493         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
494 
495         if (value == 0) {
496             return "0";
497         }
498         uint256 temp = value;
499         uint256 digits;
500         while (temp != 0) {
501             digits++;
502             temp /= 10;
503         }
504         bytes memory buffer = new bytes(digits);
505         while (value != 0) {
506             digits -= 1;
507             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
508             value /= 10;
509         }
510         return string(buffer);
511     }
512 
513     /**
514      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
515      */
516     function toHexString(uint256 value) internal pure returns (string memory) {
517         if (value == 0) {
518             return "0x00";
519         }
520         uint256 temp = value;
521         uint256 length = 0;
522         while (temp != 0) {
523             length++;
524             temp >>= 8;
525         }
526         return toHexString(value, length);
527     }
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
531      */
532     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
533         bytes memory buffer = new bytes(2 * length + 2);
534         buffer[0] = "0";
535         buffer[1] = "x";
536         for (uint256 i = 2 * length + 1; i > 1; --i) {
537             buffer[i] = _HEX_SYMBOLS[value & 0xf];
538             value >>= 4;
539         }
540         require(value == 0, "Strings: hex length insufficient");
541         return string(buffer);
542     }
543 }
544 
545 
546 // Dependency file: @openzeppelin/contracts/utils/introspection/ERC165.sol
547 
548 
549 // pragma solidity ^0.8.0;
550 
551 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
552 
553 /**
554  * @dev Implementation of the {IERC165} interface.
555  *
556  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
557  * for the additional interface id that will be supported. For example:
558  *
559  * ```solidity
560  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
562  * }
563  * ```
564  *
565  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
566  */
567 abstract contract ERC165 is IERC165 {
568     /**
569      * @dev See {IERC165-supportsInterface}.
570      */
571     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572         return interfaceId == type(IERC165).interfaceId;
573     }
574 }
575 
576 
577 // Dependency file: @openzeppelin/contracts/token/ERC721/ERC721.sol
578 
579 
580 // pragma solidity ^0.8.0;
581 
582 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
583 // import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
584 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
585 // import "@openzeppelin/contracts/utils/Address.sol";
586 // import "@openzeppelin/contracts/utils/Context.sol";
587 // import "@openzeppelin/contracts/utils/Strings.sol";
588 // import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
589 
590 /**
591  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
592  * the Metadata extension, but not including the Enumerable extension, which is available separately as
593  * {ERC721Enumerable}.
594  */
595 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
596     using Address for address;
597     using Strings for uint256;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to owner address
606     mapping(uint256 => address) private _owners;
607 
608     // Mapping owner address to token count
609     mapping(address => uint256) private _balances;
610 
611     // Mapping from token ID to approved address
612     mapping(uint256 => address) private _tokenApprovals;
613 
614     // Mapping from owner to operator approvals
615     mapping(address => mapping(address => bool)) private _operatorApprovals;
616 
617     /**
618      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
619      */
620     constructor(string memory name_, string memory symbol_) {
621         _name = name_;
622         _symbol = symbol_;
623     }
624 
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
629         return
630         interfaceId == type(IERC721).interfaceId ||
631     interfaceId == type(IERC721Metadata).interfaceId ||
632     super.supportsInterface(interfaceId);
633     }
634 
635     /**
636      * @dev See {IERC721-balanceOf}.
637      */
638     function balanceOf(address owner) public view virtual override returns (uint256) {
639         require(owner != address(0), "ERC721: balance query for the zero address");
640         return _balances[owner];
641     }
642 
643     /**
644      * @dev See {IERC721-ownerOf}.
645      */
646     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
647         address owner = _owners[tokenId];
648         require(owner != address(0), "ERC721: owner query for nonexistent token");
649         return owner;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-name}.
654      */
655     function name() public view virtual override returns (string memory) {
656         return _name;
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-symbol}.
661      */
662     function symbol() public view virtual override returns (string memory) {
663         return _symbol;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-tokenURI}.
668      */
669     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
670         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
671 
672         string memory baseURI = _baseURI();
673         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
674     }
675 
676     /**
677      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
678      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
679      * by default, can be overriden in child contracts.
680      */
681     function _baseURI() internal view virtual returns (string memory) {
682         return "";
683     }
684 
685     /**
686      * @dev See {IERC721-approve}.
687      */
688     function approve(address to, uint256 tokenId) public virtual override {
689         address owner = ERC721.ownerOf(tokenId);
690         require(to != owner, "ERC721: approval to current owner");
691 
692         require(
693             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
694             "ERC721: approve caller is not owner nor approved for all"
695         );
696 
697         _approve(to, tokenId);
698     }
699 
700     /**
701      * @dev See {IERC721-getApproved}.
702      */
703     function getApproved(uint256 tokenId) public view virtual override returns (address) {
704         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
705 
706         return _tokenApprovals[tokenId];
707     }
708 
709     /**
710      * @dev See {IERC721-setApprovalForAll}.
711      */
712     function setApprovalForAll(address operator, bool approved) public virtual override {
713         require(operator != _msgSender(), "ERC721: approve to caller");
714 
715         _operatorApprovals[_msgSender()][operator] = approved;
716         emit ApprovalForAll(_msgSender(), operator, approved);
717     }
718 
719     /**
720      * @dev See {IERC721-isApprovedForAll}.
721      */
722     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
723         return _operatorApprovals[owner][operator];
724     }
725 
726     /**
727      * @dev See {IERC721-transferFrom}.
728      */
729     function transferFrom(
730         address from,
731         address to,
732         uint256 tokenId
733     ) public virtual override {
734         //solhint-disable-next-line max-line-length
735         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
736 
737         _transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         safeTransferFrom(from, to, tokenId, "");
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) public virtual override {
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761         _safeTransfer(from, to, tokenId, _data);
762     }
763 
764     /**
765      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
766      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
767      *
768      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
769      *
770      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
771      * implement alternative mechanisms to perform token transfer, such as signature-based.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must exist and be owned by `from`.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _safeTransfer(
783         address from,
784         address to,
785         uint256 tokenId,
786         bytes memory _data
787     ) internal virtual {
788         _transfer(from, to, tokenId);
789         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
790     }
791 
792     /**
793      * @dev Returns whether `tokenId` exists.
794      *
795      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
796      *
797      * Tokens start existing when they are minted (`_mint`),
798      * and stop existing when they are burned (`_burn`).
799      */
800     function _exists(uint256 tokenId) internal view virtual returns (bool) {
801         return _owners[tokenId] != address(0);
802     }
803 
804     /**
805      * @dev Returns whether `spender` is allowed to manage `tokenId`.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
812         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
813         address owner = ERC721.ownerOf(tokenId);
814         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
815     }
816 
817     /**
818      * @dev Safely mints `tokenId` and transfers it to `to`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must not exist.
823      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _safeMint(address to, uint256 tokenId) internal virtual {
828         _safeMint(to, tokenId, "");
829     }
830 
831     /**
832      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
833      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
834      */
835     function _safeMint(
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) internal virtual {
840         _mint(to, tokenId);
841         require(
842             _checkOnERC721Received(address(0), to, tokenId, _data),
843             "ERC721: transfer to non ERC721Receiver implementer"
844         );
845     }
846 
847     /**
848      * @dev Mints `tokenId` and transfers it to `to`.
849      *
850      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
851      *
852      * Requirements:
853      *
854      * - `tokenId` must not exist.
855      * - `to` cannot be the zero address.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _mint(address to, uint256 tokenId) internal virtual {
860         require(to != address(0), "ERC721: mint to the zero address");
861         require(!_exists(tokenId), "ERC721: token already minted");
862 
863         _beforeTokenTransfer(address(0), to, tokenId);
864 
865         _balances[to] += 1;
866         _owners[tokenId] = to;
867 
868         emit Transfer(address(0), to, tokenId);
869     }
870 
871     /**
872      * @dev Destroys `tokenId`.
873      * The approval is cleared when the token is burned.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _burn(uint256 tokenId) internal virtual {
882         address owner = ERC721.ownerOf(tokenId);
883 
884         _beforeTokenTransfer(owner, address(0), tokenId);
885 
886         // Clear approvals
887         _approve(address(0), tokenId);
888 
889         _balances[owner] -= 1;
890         delete _owners[tokenId];
891 
892         emit Transfer(owner, address(0), tokenId);
893     }
894 
895     /**
896      * @dev Transfers `tokenId` from `from` to `to`.
897      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
898      *
899      * Requirements:
900      *
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must be owned by `from`.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _transfer(
907         address from,
908         address to,
909         uint256 tokenId
910     ) internal virtual {
911         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
912         require(to != address(0), "ERC721: transfer to the zero address");
913 
914         _beforeTokenTransfer(from, to, tokenId);
915 
916         // Clear approvals from the previous owner
917         _approve(address(0), tokenId);
918 
919         _balances[from] -= 1;
920         _balances[to] += 1;
921         _owners[tokenId] = to;
922 
923         emit Transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev Approve `to` to operate on `tokenId`
928      *
929      * Emits a {Approval} event.
930      */
931     function _approve(address to, uint256 tokenId) internal virtual {
932         _tokenApprovals[tokenId] = to;
933         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
934     }
935 
936     /**
937      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
938      * The call is not executed if the target address is not a contract.
939      *
940      * @param from address representing the previous owner of the given token ID
941      * @param to target address that will receive the tokens
942      * @param tokenId uint256 ID of the token to be transferred
943      * @param _data bytes optional data to send along with the call
944      * @return bool whether the call correctly returned the expected magic value
945      */
946     function _checkOnERC721Received(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) private returns (bool) {
952         if (to.isContract()) {
953             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
954                 return retval == IERC721Receiver.onERC721Received.selector;
955             } catch (bytes memory reason) {
956                 if (reason.length == 0) {
957                     revert("ERC721: transfer to non ERC721Receiver implementer");
958                 } else {
959                     assembly {
960                         revert(add(32, reason), mload(reason))
961                     }
962                 }
963             }
964         } else {
965             return true;
966         }
967     }
968 
969     /**
970      * @dev Hook that is called before any token transfer. This includes minting
971      * and burning.
972      *
973      * Calling conditions:
974      *
975      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
976      * transferred to `to`.
977      * - When `from` is zero, `tokenId` will be minted for `to`.
978      * - When `to` is zero, ``from``'s `tokenId` will be burned.
979      * - `from` and `to` are never both zero.
980      *
981      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
982      */
983     function _beforeTokenTransfer(
984         address from,
985         address to,
986         uint256 tokenId
987     ) internal virtual {}
988 }
989 
990 
991 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
992 
993 
994 // pragma solidity ^0.8.0;
995 
996 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
997 
998 /**
999  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1000  * @dev See https://eips.ethereum.org/EIPS/eip-721
1001  */
1002 interface IERC721Enumerable is IERC721 {
1003     /**
1004      * @dev Returns the total amount of tokens stored by the contract.
1005      */
1006     function totalSupply() external view returns (uint256);
1007 
1008     /**
1009      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1010      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1011      */
1012     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1013 
1014     /**
1015      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1016      * Use along with {totalSupply} to enumerate all tokens.
1017      */
1018     function tokenByIndex(uint256 index) external view returns (uint256);
1019 }
1020 
1021 
1022 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1023 
1024 
1025 // pragma solidity ^0.8.0;
1026 
1027 // import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1028 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
1029 
1030 /**
1031  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1032  * enumerability of all the token ids in the contract as well as all token ids owned by each
1033  * account.
1034  */
1035 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1036     // Mapping from owner to list of owned token IDs
1037     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1038 
1039     // Mapping from token ID to index of the owner tokens list
1040     mapping(uint256 => uint256) private _ownedTokensIndex;
1041 
1042     // Array with all token ids, used for enumeration
1043     uint256[] private _allTokens;
1044 
1045     // Mapping from token id to position in the allTokens array
1046     mapping(uint256 => uint256) private _allTokensIndex;
1047 
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1052         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1057      */
1058     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1060         return _ownedTokens[owner][index];
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Enumerable-totalSupply}.
1065      */
1066     function totalSupply() public view virtual override returns (uint256) {
1067         return _allTokens.length;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Enumerable-tokenByIndex}.
1072      */
1073     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1074         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1075         return _allTokens[index];
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual override {
1098         super._beforeTokenTransfer(from, to, tokenId);
1099 
1100         if (from == address(0)) {
1101             _addTokenToAllTokensEnumeration(tokenId);
1102         } else if (from != to) {
1103             _removeTokenFromOwnerEnumeration(from, tokenId);
1104         }
1105         if (to == address(0)) {
1106             _removeTokenFromAllTokensEnumeration(tokenId);
1107         } else if (to != from) {
1108             _addTokenToOwnerEnumeration(to, tokenId);
1109         }
1110     }
1111 
1112     /**
1113      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1114      * @param to address representing the new owner of the given token ID
1115      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1116      */
1117     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1118         uint256 length = ERC721.balanceOf(to);
1119         _ownedTokens[to][length] = tokenId;
1120         _ownedTokensIndex[tokenId] = length;
1121     }
1122 
1123     /**
1124      * @dev Private function to add a token to this extension's token tracking data structures.
1125      * @param tokenId uint256 ID of the token to be added to the tokens list
1126      */
1127     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1128         _allTokensIndex[tokenId] = _allTokens.length;
1129         _allTokens.push(tokenId);
1130     }
1131 
1132     /**
1133      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1134      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1135      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1136      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1137      * @param from address representing the previous owner of the given token ID
1138      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1139      */
1140     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1141         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1142         // then delete the last slot (swap and pop).
1143 
1144         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1145         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1146 
1147         // When the token to delete is the last token, the swap operation is unnecessary
1148         if (tokenIndex != lastTokenIndex) {
1149             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1150 
1151             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1152             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1153         }
1154 
1155         // This also deletes the contents at the last position of the array
1156         delete _ownedTokensIndex[tokenId];
1157         delete _ownedTokens[from][lastTokenIndex];
1158     }
1159 
1160     /**
1161      * @dev Private function to remove a token from this extension's token tracking data structures.
1162      * This has O(1) time complexity, but alters the order of the _allTokens array.
1163      * @param tokenId uint256 ID of the token to be removed from the tokens list
1164      */
1165     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1166         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1167         // then delete the last slot (swap and pop).
1168 
1169         uint256 lastTokenIndex = _allTokens.length - 1;
1170         uint256 tokenIndex = _allTokensIndex[tokenId];
1171 
1172         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1173         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1174         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1175         uint256 lastTokenId = _allTokens[lastTokenIndex];
1176 
1177         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1178         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1179 
1180         // This also deletes the contents at the last position of the array
1181         delete _allTokensIndex[tokenId];
1182         _allTokens.pop();
1183     }
1184 }
1185 
1186 
1187 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
1188 
1189 
1190 // pragma solidity ^0.8.0;
1191 
1192 // CAUTION
1193 // This version of SafeMath should only be used with Solidity 0.8 or later,
1194 // because it relies on the compiler's built in overflow checks.
1195 
1196 /**
1197  * @dev Wrappers over Solidity's arithmetic operations.
1198  *
1199  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1200  * now has built in overflow checking.
1201  */
1202 library SafeMath {
1203     /**
1204      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1205      *
1206      * _Available since v3.4._
1207      */
1208     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1209     unchecked {
1210         uint256 c = a + b;
1211         if (c < a) return (false, 0);
1212         return (true, c);
1213     }
1214     }
1215 
1216     /**
1217      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1218      *
1219      * _Available since v3.4._
1220      */
1221     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1222     unchecked {
1223         if (b > a) return (false, 0);
1224         return (true, a - b);
1225     }
1226     }
1227 
1228     /**
1229      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1230      *
1231      * _Available since v3.4._
1232      */
1233     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1234     unchecked {
1235         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1236         // benefit is lost if 'b' is also tested.
1237         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1238         if (a == 0) return (true, 0);
1239         uint256 c = a * b;
1240         if (c / a != b) return (false, 0);
1241         return (true, c);
1242     }
1243     }
1244 
1245     /**
1246      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1247      *
1248      * _Available since v3.4._
1249      */
1250     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1251     unchecked {
1252         if (b == 0) return (false, 0);
1253         return (true, a / b);
1254     }
1255     }
1256 
1257     /**
1258      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1259      *
1260      * _Available since v3.4._
1261      */
1262     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1263     unchecked {
1264         if (b == 0) return (false, 0);
1265         return (true, a % b);
1266     }
1267     }
1268 
1269     /**
1270      * @dev Returns the addition of two unsigned integers, reverting on
1271      * overflow.
1272      *
1273      * Counterpart to Solidity's `+` operator.
1274      *
1275      * Requirements:
1276      *
1277      * - Addition cannot overflow.
1278      */
1279     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1280         return a + b;
1281     }
1282 
1283     /**
1284      * @dev Returns the subtraction of two unsigned integers, reverting on
1285      * overflow (when the result is negative).
1286      *
1287      * Counterpart to Solidity's `-` operator.
1288      *
1289      * Requirements:
1290      *
1291      * - Subtraction cannot overflow.
1292      */
1293     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1294         return a - b;
1295     }
1296 
1297     /**
1298      * @dev Returns the multiplication of two unsigned integers, reverting on
1299      * overflow.
1300      *
1301      * Counterpart to Solidity's `*` operator.
1302      *
1303      * Requirements:
1304      *
1305      * - Multiplication cannot overflow.
1306      */
1307     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1308         return a * b;
1309     }
1310 
1311     /**
1312      * @dev Returns the integer division of two unsigned integers, reverting on
1313      * division by zero. The result is rounded towards zero.
1314      *
1315      * Counterpart to Solidity's `/` operator.
1316      *
1317      * Requirements:
1318      *
1319      * - The divisor cannot be zero.
1320      */
1321     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1322         return a / b;
1323     }
1324 
1325     /**
1326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1327      * reverting when dividing by zero.
1328      *
1329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1330      * opcode (which leaves remaining gas untouched) while Solidity uses an
1331      * invalid opcode to revert (consuming all remaining gas).
1332      *
1333      * Requirements:
1334      *
1335      * - The divisor cannot be zero.
1336      */
1337     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1338         return a % b;
1339     }
1340 
1341     /**
1342      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1343      * overflow (when the result is negative).
1344      *
1345      * CAUTION: This function is deprecated because it requires allocating memory for the error
1346      * message unnecessarily. For custom revert reasons use {trySub}.
1347      *
1348      * Counterpart to Solidity's `-` operator.
1349      *
1350      * Requirements:
1351      *
1352      * - Subtraction cannot overflow.
1353      */
1354     function sub(
1355         uint256 a,
1356         uint256 b,
1357         string memory errorMessage
1358     ) internal pure returns (uint256) {
1359     unchecked {
1360         require(b <= a, errorMessage);
1361         return a - b;
1362     }
1363     }
1364 
1365     /**
1366      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1367      * division by zero. The result is rounded towards zero.
1368      *
1369      * Counterpart to Solidity's `/` operator. Note: this function uses a
1370      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1371      * uses an invalid opcode to revert (consuming all remaining gas).
1372      *
1373      * Requirements:
1374      *
1375      * - The divisor cannot be zero.
1376      */
1377     function div(
1378         uint256 a,
1379         uint256 b,
1380         string memory errorMessage
1381     ) internal pure returns (uint256) {
1382     unchecked {
1383         require(b > 0, errorMessage);
1384         return a / b;
1385     }
1386     }
1387 
1388     /**
1389      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1390      * reverting with custom message when dividing by zero.
1391      *
1392      * CAUTION: This function is deprecated because it requires allocating memory for the error
1393      * message unnecessarily. For custom revert reasons use {tryMod}.
1394      *
1395      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1396      * opcode (which leaves remaining gas untouched) while Solidity uses an
1397      * invalid opcode to revert (consuming all remaining gas).
1398      *
1399      * Requirements:
1400      *
1401      * - The divisor cannot be zero.
1402      */
1403     function mod(
1404         uint256 a,
1405         uint256 b,
1406         string memory errorMessage
1407     ) internal pure returns (uint256) {
1408     unchecked {
1409         require(b > 0, errorMessage);
1410         return a % b;
1411     }
1412     }
1413 }
1414 
1415 
1416 // Dependency file: @openzeppelin/contracts/security/ReentrancyGuard.sol
1417 
1418 
1419 // pragma solidity ^0.8.0;
1420 
1421 /**
1422  * @dev Contract module that helps prevent reentrant calls to a function.
1423  *
1424  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1425  * available, which can be applied to functions to make sure there are no nested
1426  * (reentrant) calls to them.
1427  *
1428  * Note that because there is a single `nonReentrant` guard, functions marked as
1429  * `nonReentrant` may not call one another. This can be worked around by making
1430  * those functions `private`, and then adding `external` `nonReentrant` entry
1431  * points to them.
1432  *
1433  * TIP: If you would like to learn more about reentrancy and alternative ways
1434  * to protect against it, check out our blog post
1435  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1436  */
1437 abstract contract ReentrancyGuard {
1438     // Booleans are more expensive than uint256 or any type that takes up a full
1439     // word because each write operation emits an extra SLOAD to first read the
1440     // slot's contents, replace the bits taken up by the boolean, and then write
1441     // back. This is the compiler's defense against contract upgrades and
1442     // pointer aliasing, and it cannot be disabled.
1443 
1444     // The values being non-zero value makes deployment a bit more expensive,
1445     // but in exchange the refund on every call to nonReentrant will be lower in
1446     // amount. Since refunds are capped to a percentage of the total
1447     // transaction's gas, it is best to keep them low in cases like this one, to
1448     // increase the likelihood of the full refund coming into effect.
1449     uint256 private constant _NOT_ENTERED = 1;
1450     uint256 private constant _ENTERED = 2;
1451 
1452     uint256 private _status;
1453 
1454     constructor() {
1455         _status = _NOT_ENTERED;
1456     }
1457 
1458     /**
1459      * @dev Prevents a contract from calling itself, directly or indirectly.
1460      * Calling a `nonReentrant` function from another `nonReentrant`
1461      * function is not supported. It is possible to prevent this from happening
1462      * by making the `nonReentrant` function external, and make it call a
1463      * `private` function that does the actual work.
1464      */
1465     modifier nonReentrant() {
1466         // On the first call to nonReentrant, _notEntered will be true
1467         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1468 
1469         // Any calls to nonReentrant after this point will fail
1470         _status = _ENTERED;
1471 
1472         _;
1473 
1474         // By storing the original value once again, a refund is triggered (see
1475         // https://eips.ethereum.org/EIPS/eip-2200)
1476         _status = _NOT_ENTERED;
1477     }
1478 }
1479 
1480 
1481 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
1482 
1483 
1484 // pragma solidity ^0.8.0;
1485 
1486 // import "@openzeppelin/contracts/utils/Context.sol";
1487 
1488 /**
1489  * @dev Contract module which provides a basic access control mechanism, where
1490  * there is an account (an owner) that can be granted exclusive access to
1491  * specific functions.
1492  *
1493  * By default, the owner account will be the one that deploys the contract. This
1494  * can later be changed with {transferOwnership}.
1495  *
1496  * This module is used through inheritance. It will make available the modifier
1497  * `onlyOwner`, which can be applied to your functions to restrict their use to
1498  * the owner.
1499  */
1500 abstract contract Ownable is Context {
1501     address private _owner;
1502 
1503     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1504 
1505     /**
1506      * @dev Initializes the contract setting the deployer as the initial owner.
1507      */
1508     constructor() {
1509         _setOwner(_msgSender());
1510     }
1511 
1512     /**
1513      * @dev Returns the address of the current owner.
1514      */
1515     function owner() public view virtual returns (address) {
1516         return _owner;
1517     }
1518 
1519     /**
1520      * @dev Throws if called by any account other than the owner.
1521      */
1522     modifier onlyOwner() {
1523         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1524         _;
1525     }
1526 
1527     /**
1528      * @dev Leaves the contract without owner. It will not be possible to call
1529      * `onlyOwner` functions anymore. Can only be called by the current owner.
1530      *
1531      * NOTE: Renouncing ownership will leave the contract without an owner,
1532      * thereby removing any functionality that is only available to the owner.
1533      */
1534     function renounceOwnership() public virtual onlyOwner {
1535         _setOwner(address(0));
1536     }
1537 
1538     /**
1539      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1540      * Can only be called by the current owner.
1541      */
1542     function transferOwnership(address newOwner) public virtual onlyOwner {
1543         require(newOwner != address(0), "Ownable: new owner is the zero address");
1544         _setOwner(newOwner);
1545     }
1546 
1547     function _setOwner(address newOwner) private {
1548         address oldOwner = _owner;
1549         _owner = newOwner;
1550         emit OwnershipTransferred(oldOwner, newOwner);
1551     }
1552 }
1553 
1554 
1555 // Root file: contracts/NFTitsColletion.sol
1556 
1557 pragma solidity >=0.8.0;
1558 
1559 /**
1560  * @title NFTitsCollection - "Bikini Bottom" collection.
1561  */
1562 contract NFTitsCollection is ERC721Enumerable, ReentrancyGuard, Ownable {
1563     using SafeMath for uint256;
1564 
1565     address public bank;
1566     uint256 public raisedEthers;
1567     uint256 public tokenPrice = 30000000000000000; // 0.03 ETH
1568     uint256 public maxTokenPurchase = 20;
1569     uint256 public maxTokens = 10000;
1570 
1571     bool public saleIsActive = false;
1572 
1573     string private _veryBaseURI;
1574 
1575     event TokenPriceChanged(uint256 price);
1576     event MaxTokenAmountChanged(uint256 value);
1577     event MaxPurchaseChanged(uint256 value);
1578     event BaseUriChanged(string uri);
1579     event BankSet(address bankAccount);
1580     event RolledOver(bool status);
1581 
1582     constructor(address _bank)
1583     ERC721("CryptoNFTits", "NFTITS")
1584     {
1585         bank = _bank;
1586         emit BankSet(_bank);
1587     }
1588 
1589     receive() external payable {
1590         require(
1591             !Address.isContract(_msgSender()),
1592             "Collection: smart contract call"
1593         );
1594 
1595         uint deposit = msg.value;
1596 
1597         require(deposit % tokenPrice == 0, "Collection: quantity with change");
1598 
1599         uint numberOfTokens = deposit.div(tokenPrice);
1600 
1601         require(
1602             numberOfTokens != 0 && numberOfTokens <= maxTokenPurchase,
1603             "Collection: incorrect token amount mint, exceeds max or min number"
1604         );
1605         require(
1606             totalSupply().add(numberOfTokens) <= maxTokens,
1607             "Collection: purchase would exceed max supply of Tokens"
1608         );
1609 
1610         if (bank != address(this)) {
1611             Address.sendValue(payable(bank), deposit);
1612         }
1613 
1614         raisedEthers += deposit;
1615 
1616         uint mintIndex;
1617         for (uint i; i < numberOfTokens; i++) {
1618             mintIndex = totalSupply();
1619             if (totalSupply() < maxTokens) {
1620                 _safeMint(_msgSender(), mintIndex);
1621             }
1622         }
1623     }
1624 
1625     function mintTokens(uint numberOfTokens) public payable nonReentrant {
1626         require(saleIsActive, "Collection: sale is not active");
1627         require(
1628             numberOfTokens <= maxTokenPurchase,
1629             "Collection: exceeds max number of Tokens in one transaction"
1630         );
1631         require(
1632             totalSupply().add(numberOfTokens) <= maxTokens,
1633             "Collection: purchase would exceed max supply of Tokens"
1634         );
1635 
1636         uint256 deposit = msg.value;
1637 
1638         require(tokenPrice.mul(numberOfTokens) == deposit,
1639             "Collection: ether value sent is not correct"
1640         );
1641 
1642         if (bank != address(this)) {
1643             Address.sendValue(payable(bank), deposit);
1644         }
1645 
1646         raisedEthers += deposit;
1647 
1648         uint mintIndex;
1649         for (uint i; i < numberOfTokens; i++) {
1650             mintIndex = totalSupply();
1651             if (totalSupply() < maxTokens) {
1652                 _safeMint(_msgSender(), mintIndex);
1653             }
1654         }
1655     }
1656 
1657     // @dev Withdraw ethereum from contract balance.
1658     // Permission: only owner
1659     function withdraw() public onlyOwner {
1660         uint balance = address(this).balance;
1661         Address.sendValue(payable(_msgSender()), balance);
1662     }
1663 
1664     // @dev Changes sale status.
1665     // Permission: only owner
1666     function flipSaleState() public onlyOwner {
1667         saleIsActive = !saleIsActive;
1668         emit RolledOver(saleIsActive);
1669     }
1670 
1671     // @dev Setup new token sale price.
1672     // Permission: only owner
1673     function setPrice(uint256 _price) external onlyOwner {
1674         require(_price != 0, "Zero price");
1675 
1676         tokenPrice = _price;
1677         emit TokenPriceChanged(_price);
1678     }
1679 
1680     // @dev Setup new max tokens amount, should be more then 10K.
1681     // Permission: only owner
1682     function setMaxTokenAmount(uint256 _value) external onlyOwner {
1683         require(
1684             _value > totalSupply() && _value <= 10_000,
1685             "Wrong value for max supply"
1686         );
1687 
1688         maxTokens = _value;
1689         emit MaxTokenAmountChanged(_value);
1690     }
1691 
1692     // @dev Setup max tokens purchase per transaction.
1693     // Permission: only owner
1694     function setMaxPurchase(uint256 _value) external onlyOwner {
1695         require(_value != 0, "Very low value");
1696 
1697         maxTokenPurchase = _value;
1698         emit MaxPurchaseChanged(_value);
1699     }
1700 
1701     // @dev Setup new bank account.
1702     // Permission: only owner
1703     function setBank(address _account) external onlyOwner {
1704         require(_account != address(0), "Zero address set");
1705 
1706         bank = _account;
1707         emit BankSet(_account);
1708     }
1709 
1710     // @dev Setup base URI.
1711     // Permission: only owner
1712     function setBaseURI(string memory _uri) external onlyOwner {
1713         _veryBaseURI = _uri;
1714         emit BaseUriChanged(_uri);
1715     }
1716 
1717     function _baseURI() internal view virtual override(ERC721) returns (string memory) {
1718         return _veryBaseURI;
1719     }
1720 }