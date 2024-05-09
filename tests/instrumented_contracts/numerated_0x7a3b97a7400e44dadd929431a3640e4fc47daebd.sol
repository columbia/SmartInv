1 // SPDX-License-Identifier: MIT AND GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 
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
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
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
174 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
175 
176 
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @title ERC721 token receiver interface
182  * @dev Interface for any contract that wants to support safeTransfers
183  * from ERC721 asset contracts.
184  */
185 interface IERC721Receiver {
186     /**
187      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
188      * by `operator` from `from`, this function is called.
189      *
190      * It must return its Solidity selector to confirm the token transfer.
191      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
192      *
193      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
194      */
195     function onERC721Received(
196         address operator,
197         address from,
198         uint256 tokenId,
199         bytes calldata data
200     ) external returns (bytes4);
201 }
202 
203 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
204 
205 
206 
207 pragma solidity ^0.8.0;
208 
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
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
233 
234 
235 pragma solidity ^0.8.0;
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
450 // File: @openzeppelin/contracts/utils/Context.sol
451 
452 
453 
454 pragma solidity ^0.8.0;
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
476 // File: @openzeppelin/contracts/utils/Strings.sol
477 
478 
479 
480 pragma solidity ^0.8.0;
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
545 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
546 
547 
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @dev Implementation of the {IERC165} interface.
554  *
555  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
556  * for the additional interface id that will be supported. For example:
557  *
558  * ```solidity
559  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
561  * }
562  * ```
563  *
564  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
565  */
566 abstract contract ERC165 is IERC165 {
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      */
570     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571         return interfaceId == type(IERC165).interfaceId;
572     }
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
576 
577 
578 
579 pragma solidity ^0.8.0;
580 
581 
582 
583 
584 
585 
586 
587 
588 /**
589  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
590  * the Metadata extension, but not including the Enumerable extension, which is available separately as
591  * {ERC721Enumerable}.
592  */
593 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
594     using Address for address;
595     using Strings for uint256;
596 
597     // Token name
598     string private _name;
599 
600     // Token symbol
601     string private _symbol;
602 
603     // Mapping from token ID to owner address
604     mapping(uint256 => address) private _owners;
605 
606     // Mapping owner address to token count
607     mapping(address => uint256) private _balances;
608 
609     // Mapping from token ID to approved address
610     mapping(uint256 => address) private _tokenApprovals;
611 
612     // Mapping from owner to operator approvals
613     mapping(address => mapping(address => bool)) private _operatorApprovals;
614 
615     /**
616      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
617      */
618     constructor(string memory name_, string memory symbol_) {
619         _name = name_;
620         _symbol = symbol_;
621     }
622 
623     /**
624      * @dev See {IERC165-supportsInterface}.
625      */
626     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
627         return
628             interfaceId == type(IERC721).interfaceId ||
629             interfaceId == type(IERC721Metadata).interfaceId ||
630             super.supportsInterface(interfaceId);
631     }
632 
633     /**
634      * @dev See {IERC721-balanceOf}.
635      */
636     function balanceOf(address owner) public view virtual override returns (uint256) {
637         require(owner != address(0), "ERC721: balance query for the zero address");
638         return _balances[owner];
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
645         address owner = _owners[tokenId];
646         require(owner != address(0), "ERC721: owner query for nonexistent token");
647         return owner;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-name}.
652      */
653     function name() public view virtual override returns (string memory) {
654         return _name;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-symbol}.
659      */
660     function symbol() public view virtual override returns (string memory) {
661         return _symbol;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-tokenURI}.
666      */
667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
668         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
669 
670         string memory baseURI = _baseURI();
671         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
672     }
673 
674     /**
675      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
676      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
677      * by default, can be overriden in child contracts.
678      */
679     function _baseURI() internal view virtual returns (string memory) {
680         return "";
681     }
682 
683     /**
684      * @dev See {IERC721-approve}.
685      */
686     function approve(address to, uint256 tokenId) public virtual override {
687         address owner = ERC721.ownerOf(tokenId);
688         require(to != owner, "ERC721: approval to current owner");
689 
690         require(
691             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
692             "ERC721: approve caller is not owner nor approved for all"
693         );
694 
695         _approve(to, tokenId);
696     }
697 
698     /**
699      * @dev See {IERC721-getApproved}.
700      */
701     function getApproved(uint256 tokenId) public view virtual override returns (address) {
702         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
703 
704         return _tokenApprovals[tokenId];
705     }
706 
707     /**
708      * @dev See {IERC721-setApprovalForAll}.
709      */
710     function setApprovalForAll(address operator, bool approved) public virtual override {
711         require(operator != _msgSender(), "ERC721: approve to caller");
712 
713         _operatorApprovals[_msgSender()][operator] = approved;
714         emit ApprovalForAll(_msgSender(), operator, approved);
715     }
716 
717     /**
718      * @dev See {IERC721-isApprovedForAll}.
719      */
720     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
721         return _operatorApprovals[owner][operator];
722     }
723 
724     /**
725      * @dev See {IERC721-transferFrom}.
726      */
727     function transferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public virtual override {
732         //solhint-disable-next-line max-line-length
733         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
734 
735         _transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         safeTransferFrom(from, to, tokenId, "");
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) public virtual override {
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759         _safeTransfer(from, to, tokenId, _data);
760     }
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
767      *
768      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
769      * implement alternative mechanisms to perform token transfer, such as signature-based.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _safeTransfer(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _transfer(from, to, tokenId);
787         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
788     }
789 
790     /**
791      * @dev Returns whether `tokenId` exists.
792      *
793      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
794      *
795      * Tokens start existing when they are minted (`_mint`),
796      * and stop existing when they are burned (`_burn`).
797      */
798     function _exists(uint256 tokenId) internal view virtual returns (bool) {
799         return _owners[tokenId] != address(0);
800     }
801 
802     /**
803      * @dev Returns whether `spender` is allowed to manage `tokenId`.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
810         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
811         address owner = ERC721.ownerOf(tokenId);
812         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
813     }
814 
815     /**
816      * @dev Safely mints `tokenId` and transfers it to `to`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must not exist.
821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _safeMint(address to, uint256 tokenId) internal virtual {
826         _safeMint(to, tokenId, "");
827     }
828 
829     /**
830      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
831      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
832      */
833     function _safeMint(
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) internal virtual {
838         _mint(to, tokenId);
839         require(
840             _checkOnERC721Received(address(0), to, tokenId, _data),
841             "ERC721: transfer to non ERC721Receiver implementer"
842         );
843     }
844 
845     /**
846      * @dev Mints `tokenId` and transfers it to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
849      *
850      * Requirements:
851      *
852      * - `tokenId` must not exist.
853      * - `to` cannot be the zero address.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _mint(address to, uint256 tokenId) internal virtual {
858         require(to != address(0), "ERC721: mint to the zero address");
859         require(!_exists(tokenId), "ERC721: token already minted");
860 
861         _beforeTokenTransfer(address(0), to, tokenId);
862 
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(address(0), to, tokenId);
867     }
868 
869     /**
870      * @dev Destroys `tokenId`.
871      * The approval is cleared when the token is burned.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _burn(uint256 tokenId) internal virtual {
880         address owner = ERC721.ownerOf(tokenId);
881 
882         _beforeTokenTransfer(owner, address(0), tokenId);
883 
884         // Clear approvals
885         _approve(address(0), tokenId);
886 
887         _balances[owner] -= 1;
888         delete _owners[tokenId];
889 
890         emit Transfer(owner, address(0), tokenId);
891     }
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
896      *
897      * Requirements:
898      *
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) internal virtual {
909         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
910         require(to != address(0), "ERC721: transfer to the zero address");
911 
912         _beforeTokenTransfer(from, to, tokenId);
913 
914         // Clear approvals from the previous owner
915         _approve(address(0), tokenId);
916 
917         _balances[from] -= 1;
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev Approve `to` to operate on `tokenId`
926      *
927      * Emits a {Approval} event.
928      */
929     function _approve(address to, uint256 tokenId) internal virtual {
930         _tokenApprovals[tokenId] = to;
931         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
932     }
933 
934     /**
935      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
936      * The call is not executed if the target address is not a contract.
937      *
938      * @param from address representing the previous owner of the given token ID
939      * @param to target address that will receive the tokens
940      * @param tokenId uint256 ID of the token to be transferred
941      * @param _data bytes optional data to send along with the call
942      * @return bool whether the call correctly returned the expected magic value
943      */
944     function _checkOnERC721Received(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) private returns (bool) {
950         if (to.isContract()) {
951             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
952                 return retval == IERC721Receiver.onERC721Received.selector;
953             } catch (bytes memory reason) {
954                 if (reason.length == 0) {
955                     revert("ERC721: transfer to non ERC721Receiver implementer");
956                 } else {
957                     assembly {
958                         revert(add(32, reason), mload(reason))
959                     }
960                 }
961             }
962         } else {
963             return true;
964         }
965     }
966 
967     /**
968      * @dev Hook that is called before any token transfer. This includes minting
969      * and burning.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` will be minted for `to`.
976      * - When `to` is zero, ``from``'s `tokenId` will be burned.
977      * - `from` and `to` are never both zero.
978      *
979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
980      */
981     function _beforeTokenTransfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) internal virtual {}
986 }
987 
988 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
989 
990 
991 
992 pragma solidity ^0.8.0;
993 
994 
995 /**
996  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
997  * @dev See https://eips.ethereum.org/EIPS/eip-721
998  */
999 interface IERC721Enumerable is IERC721 {
1000     /**
1001      * @dev Returns the total amount of tokens stored by the contract.
1002      */
1003     function totalSupply() external view returns (uint256);
1004 
1005     /**
1006      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1007      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1008      */
1009     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1010 
1011     /**
1012      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1013      * Use along with {totalSupply} to enumerate all tokens.
1014      */
1015     function tokenByIndex(uint256 index) external view returns (uint256);
1016 }
1017 
1018 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1019 
1020 
1021 
1022 pragma solidity ^0.8.0;
1023 
1024 
1025 
1026 /**
1027  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1028  * enumerability of all the token ids in the contract as well as all token ids owned by each
1029  * account.
1030  */
1031 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1032     // Mapping from owner to list of owned token IDs
1033     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1034 
1035     // Mapping from token ID to index of the owner tokens list
1036     mapping(uint256 => uint256) private _ownedTokensIndex;
1037 
1038     // Array with all token ids, used for enumeration
1039     uint256[] private _allTokens;
1040 
1041     // Mapping from token id to position in the allTokens array
1042     mapping(uint256 => uint256) private _allTokensIndex;
1043 
1044     /**
1045      * @dev See {IERC165-supportsInterface}.
1046      */
1047     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1048         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1053      */
1054     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1055         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1056         return _ownedTokens[owner][index];
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-totalSupply}.
1061      */
1062     function totalSupply() public view virtual override returns (uint256) {
1063         return _allTokens.length;
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Enumerable-tokenByIndex}.
1068      */
1069     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1070         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1071         return _allTokens[index];
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before any token transfer. This includes minting
1076      * and burning.
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` will be minted for `to`.
1083      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1084      * - `from` cannot be the zero address.
1085      * - `to` cannot be the zero address.
1086      *
1087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088      */
1089     function _beforeTokenTransfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual override {
1094         super._beforeTokenTransfer(from, to, tokenId);
1095 
1096         if (from == address(0)) {
1097             _addTokenToAllTokensEnumeration(tokenId);
1098         } else if (from != to) {
1099             _removeTokenFromOwnerEnumeration(from, tokenId);
1100         }
1101         if (to == address(0)) {
1102             _removeTokenFromAllTokensEnumeration(tokenId);
1103         } else if (to != from) {
1104             _addTokenToOwnerEnumeration(to, tokenId);
1105         }
1106     }
1107 
1108     /**
1109      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1110      * @param to address representing the new owner of the given token ID
1111      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1112      */
1113     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1114         uint256 length = ERC721.balanceOf(to);
1115         _ownedTokens[to][length] = tokenId;
1116         _ownedTokensIndex[tokenId] = length;
1117     }
1118 
1119     /**
1120      * @dev Private function to add a token to this extension's token tracking data structures.
1121      * @param tokenId uint256 ID of the token to be added to the tokens list
1122      */
1123     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1124         _allTokensIndex[tokenId] = _allTokens.length;
1125         _allTokens.push(tokenId);
1126     }
1127 
1128     /**
1129      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1130      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1131      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1132      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1133      * @param from address representing the previous owner of the given token ID
1134      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1135      */
1136     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1137         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1138         // then delete the last slot (swap and pop).
1139 
1140         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1141         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1142 
1143         // When the token to delete is the last token, the swap operation is unnecessary
1144         if (tokenIndex != lastTokenIndex) {
1145             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1146 
1147             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1148             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1149         }
1150 
1151         // This also deletes the contents at the last position of the array
1152         delete _ownedTokensIndex[tokenId];
1153         delete _ownedTokens[from][lastTokenIndex];
1154     }
1155 
1156     /**
1157      * @dev Private function to remove a token from this extension's token tracking data structures.
1158      * This has O(1) time complexity, but alters the order of the _allTokens array.
1159      * @param tokenId uint256 ID of the token to be removed from the tokens list
1160      */
1161     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1162         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1163         // then delete the last slot (swap and pop).
1164 
1165         uint256 lastTokenIndex = _allTokens.length - 1;
1166         uint256 tokenIndex = _allTokensIndex[tokenId];
1167 
1168         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1169         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1170         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1171         uint256 lastTokenId = _allTokens[lastTokenIndex];
1172 
1173         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1174         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1175 
1176         // This also deletes the contents at the last position of the array
1177         delete _allTokensIndex[tokenId];
1178         _allTokens.pop();
1179     }
1180 }
1181 
1182 // File: @openzeppelin/contracts/access/Ownable.sol
1183 
1184 
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 
1189 /**
1190  * @dev Contract module which provides a basic access control mechanism, where
1191  * there is an account (an owner) that can be granted exclusive access to
1192  * specific functions.
1193  *
1194  * By default, the owner account will be the one that deploys the contract. This
1195  * can later be changed with {transferOwnership}.
1196  *
1197  * This module is used through inheritance. It will make available the modifier
1198  * `onlyOwner`, which can be applied to your functions to restrict their use to
1199  * the owner.
1200  */
1201 abstract contract Ownable is Context {
1202     address private _owner;
1203 
1204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1205 
1206     /**
1207      * @dev Initializes the contract setting the deployer as the initial owner.
1208      */
1209     constructor() {
1210         _setOwner(_msgSender());
1211     }
1212 
1213     /**
1214      * @dev Returns the address of the current owner.
1215      */
1216     function owner() public view virtual returns (address) {
1217         return _owner;
1218     }
1219 
1220     /**
1221      * @dev Throws if called by any account other than the owner.
1222      */
1223     modifier onlyOwner() {
1224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1225         _;
1226     }
1227 
1228     /**
1229      * @dev Leaves the contract without owner. It will not be possible to call
1230      * `onlyOwner` functions anymore. Can only be called by the current owner.
1231      *
1232      * NOTE: Renouncing ownership will leave the contract without an owner,
1233      * thereby removing any functionality that is only available to the owner.
1234      */
1235     function renounceOwnership() public virtual onlyOwner {
1236         _setOwner(address(0));
1237     }
1238 
1239     /**
1240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1241      * Can only be called by the current owner.
1242      */
1243     function transferOwnership(address newOwner) public virtual onlyOwner {
1244         require(newOwner != address(0), "Ownable: new owner is the zero address");
1245         _setOwner(newOwner);
1246     }
1247 
1248     function _setOwner(address newOwner) private {
1249         address oldOwner = _owner;
1250         _owner = newOwner;
1251         emit OwnershipTransferred(oldOwner, newOwner);
1252     }
1253 }
1254 
1255 // File: contracts/ApesInSpace.sol
1256 
1257 pragma solidity >=0.7.0 <0.9.0;
1258 
1259 
1260 
1261 contract ApesInSpace is ERC721Enumerable, Ownable {
1262   using Strings for uint256;
1263   string private baseURI;
1264   string public baseExtension = ".json";
1265   string public notRevealedUri;
1266   uint256 public preSaleCost = 0.12 ether;
1267   uint256 public cost = 0.3 ether;
1268   uint256 public maxSupply = 9999;
1269   uint256 public preSaleMaxSupply = 2250;
1270   uint256 public maxMintAmountPresale = 1;
1271   uint256 public maxMintAmount = 10;
1272   uint256 public nftPerAddressLimitPresale = 1;
1273   uint256 public nftPerAddressLimit = 100;
1274   uint256 public preSaleDate = 1638738000;
1275   uint256 public preSaleEndDate = 1638824400;
1276   uint256 public publicSaleDate = 1638842400;
1277   bool public paused = false;
1278   bool public revealed = false;
1279   mapping(address => bool) whitelistedAddresses;
1280   mapping(address => uint256) public addressMintedBalance;
1281 
1282   constructor(
1283     string memory _name,
1284     string memory _symbol,
1285     string memory _initNotRevealedUri
1286   ) ERC721(_name, _symbol) {
1287     setNotRevealedURI(_initNotRevealedUri);
1288   }
1289 
1290   //MODIFIERS
1291   modifier notPaused {
1292     require(!paused, "the contract is paused");
1293     _;
1294   }
1295 
1296   modifier saleStarted {
1297     require(block.timestamp >= preSaleDate, "Sale has not started yet");
1298     _;
1299   }
1300 
1301   modifier minimumMintAmount(uint256 _mintAmount) {
1302     require(_mintAmount > 0, "need to mint at least 1 NFT");
1303     _;
1304   }
1305 
1306   // INTERNAL
1307   function _baseURI() internal view virtual override returns (string memory) {
1308     return baseURI;
1309   }
1310 
1311   function presaleValidations(
1312     uint256 _ownerMintedCount,
1313     uint256 _mintAmount,
1314     uint256 _supply
1315   ) internal {
1316     uint256 actualCost;
1317     block.timestamp < preSaleEndDate
1318       ? actualCost = preSaleCost
1319       : actualCost = cost;
1320     require(isWhitelisted(msg.sender), "user is not whitelisted");
1321     require(
1322       _ownerMintedCount + _mintAmount <= nftPerAddressLimitPresale,
1323       "max NFT per address exceeded for presale"
1324     );
1325     require(msg.value >= actualCost * _mintAmount, "insufficient funds");
1326     require(
1327       _mintAmount <= maxMintAmountPresale,
1328       "max mint amount per transaction exceeded"
1329     );
1330     require(
1331       _supply + _mintAmount <= preSaleMaxSupply,
1332       "max NFT presale limit exceeded"
1333     );
1334   }
1335 
1336   function publicsaleValidations(uint256 _ownerMintedCount, uint256 _mintAmount)
1337     internal
1338   {
1339     require(
1340       _ownerMintedCount + _mintAmount <= nftPerAddressLimit,
1341       "max NFT per address exceeded"
1342     );
1343     require(msg.value >= cost * _mintAmount, "insufficient funds");
1344     require(
1345       _mintAmount <= maxMintAmount,
1346       "max mint amount per transaction exceeded"
1347     );
1348   }
1349 
1350   //MINT
1351   function mint(uint256 _mintAmount)
1352     public
1353     payable
1354     notPaused
1355     saleStarted
1356     minimumMintAmount(_mintAmount)
1357   {
1358     uint256 supply = totalSupply();
1359     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1360 
1361     //Do some validations depending on which step of the sale we are in
1362     block.timestamp < publicSaleDate
1363       ? presaleValidations(ownerMintedCount, _mintAmount, supply)
1364       : publicsaleValidations(ownerMintedCount, _mintAmount);
1365 
1366     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1367 
1368     for (uint256 i = 1; i <= _mintAmount; i++) {
1369       addressMintedBalance[msg.sender]++;
1370       _safeMint(msg.sender, supply + i);
1371     }
1372   }
1373 
1374   function gift(uint256 _mintAmount, address destination) public onlyOwner {
1375     require(_mintAmount > 0, "need to mint at least 1 NFT");
1376     uint256 supply = totalSupply();
1377     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1378 
1379     for (uint256 i = 1; i <= _mintAmount; i++) {
1380       addressMintedBalance[destination]++;
1381       _safeMint(destination, supply + i);
1382     }
1383   }
1384 
1385   //PUBLIC VIEWS
1386   function isWhitelisted(address _user) public view returns (bool) {
1387     return whitelistedAddresses[_user];
1388   }
1389 
1390   function walletOfOwner(address _owner)
1391     public
1392     view
1393     returns (uint256[] memory)
1394   {
1395     uint256 ownerTokenCount = balanceOf(_owner);
1396     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1397     for (uint256 i; i < ownerTokenCount; i++) {
1398       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1399     }
1400     return tokenIds;
1401   }
1402 
1403   function tokenURI(uint256 tokenId)
1404     public
1405     view
1406     virtual
1407     override
1408     returns (string memory)
1409   {
1410     require(
1411       _exists(tokenId),
1412       "ERC721Metadata: URI query for nonexistent token"
1413     );
1414 
1415     if (!revealed) {
1416       return notRevealedUri;
1417     } else {
1418       string memory currentBaseURI = _baseURI();
1419       return
1420         bytes(currentBaseURI).length > 0
1421           ? string(
1422             abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
1423           )
1424           : "";
1425     }
1426   }
1427 
1428   function getCurrentCost() public view returns (uint256) {
1429     if (block.timestamp < preSaleEndDate) {
1430       return preSaleCost;
1431     } else {
1432       return cost;
1433     }
1434   }
1435 
1436   //ONLY OWNER VIEWS
1437   function getBaseURI() public view onlyOwner returns (string memory) {
1438     return baseURI;
1439   }
1440 
1441   function getContractBalance() public view onlyOwner returns (uint256) {
1442     return address(this).balance;
1443   }
1444 
1445   //ONLY OWNER SETTERS
1446   function reveal() public onlyOwner {
1447     revealed = true;
1448   }
1449 
1450   function pause(bool _state) public onlyOwner {
1451     paused = _state;
1452   }
1453 
1454   function setNftPerAddressLimitPreSale(uint256 _limit) public onlyOwner {
1455     nftPerAddressLimitPresale = _limit;
1456   }
1457 
1458   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1459     nftPerAddressLimit = _limit;
1460   }
1461 
1462   function setPresaleCost(uint256 _newCost) public onlyOwner {
1463     preSaleCost = _newCost;
1464   }
1465 
1466   function setCost(uint256 _newCost) public onlyOwner {
1467     cost = _newCost;
1468   }
1469 
1470   function setmaxMintAmountPreSale(uint256 _newmaxMintAmount) public onlyOwner {
1471     maxMintAmountPresale = _newmaxMintAmount;
1472   }
1473 
1474   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1475     maxMintAmount = _newmaxMintAmount;
1476   }
1477 
1478   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1479     baseURI = _newBaseURI;
1480   }
1481 
1482   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1483     baseExtension = _newBaseExtension;
1484   }
1485 
1486   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1487     notRevealedUri = _notRevealedURI;
1488   }
1489 
1490   function setPresaleMaxSupply(uint256 _newPresaleMaxSupply) public onlyOwner {
1491     preSaleMaxSupply = _newPresaleMaxSupply;
1492   }
1493 
1494   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1495     maxSupply = _maxSupply;
1496   }
1497 
1498   function setPreSaleDate(uint256 _preSaleDate) public onlyOwner {
1499     preSaleDate = _preSaleDate;
1500   }
1501 
1502   function setPreSaleEndDate(uint256 _preSaleEndDate) public onlyOwner {
1503     preSaleEndDate = _preSaleEndDate;
1504   }
1505 
1506   function setPublicSaleDate(uint256 _publicSaleDate) public onlyOwner {
1507     publicSaleDate = _publicSaleDate;
1508   }
1509 
1510   function whitelistUsers(address[] memory addresses) public onlyOwner {
1511     for (uint256 i = 0; i < addresses.length; i++) {
1512       whitelistedAddresses[addresses[i]] = true;
1513     }
1514   }
1515 
1516   function withdraw() public payable onlyOwner {
1517     (bool success, ) = payable(msg.sender).call{ value: address(this).balance }(
1518       ""
1519     );
1520     require(success);
1521   }
1522 }