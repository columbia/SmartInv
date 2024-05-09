1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-21
3 */
4 
5 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
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
20 interface IERC165 {
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
32 
33 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
34 
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
177 
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 
205 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
206 
207 
208 pragma solidity ^0.8.0;
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
232 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
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
450 
451 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
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
476 
477 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
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
545 
546 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
547 
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev Implementation of the {IERC165} interface.
553  *
554  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
555  * for the additional interface id that will be supported. For example:
556  *
557  * ```solidity
558  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
560  * }
561  * ```
562  *
563  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
564  */
565 abstract contract ERC165 is IERC165 {
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570         return interfaceId == type(IERC165).interfaceId;
571     }
572 }
573 
574 
575 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
576 
577 
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
583  * the Metadata extension, but not including the Enumerable extension, which is available separately as
584  * {ERC721Enumerable}.
585  */
586 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
587     using Address for address;
588     using Strings for uint256;
589 
590     // Token name
591     string private _name;
592 
593     // Token symbol
594     string private _symbol;
595 
596     // Mapping from token ID to owner address
597     mapping(uint256 => address) private _owners;
598 
599     // Mapping owner address to token count
600     mapping(address => uint256) private _balances;
601 
602     // Mapping from token ID to approved address
603     mapping(uint256 => address) private _tokenApprovals;
604 
605     // Mapping from owner to operator approvals
606     mapping(address => mapping(address => bool)) private _operatorApprovals;
607 
608     /**
609      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
610      */
611     constructor(string memory name_, string memory symbol_) {
612         _name = name_;
613         _symbol = symbol_;
614     }
615 
616     /**
617      * @dev See {IERC165-supportsInterface}.
618      */
619     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
620         return
621             interfaceId == type(IERC721).interfaceId ||
622             interfaceId == type(IERC721Metadata).interfaceId ||
623             super.supportsInterface(interfaceId);
624     }
625 
626     /**
627      * @dev See {IERC721-balanceOf}.
628      */
629     function balanceOf(address owner) public view virtual override returns (uint256) {
630         require(owner != address(0), "ERC721: balance query for the zero address");
631         return _balances[owner];
632     }
633 
634     /**
635      * @dev See {IERC721-ownerOf}.
636      */
637     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
638         address owner = _owners[tokenId];
639         require(owner != address(0), "ERC721: owner query for nonexistent token");
640         return owner;
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-name}.
645      */
646     function name() public view virtual override returns (string memory) {
647         return _name;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-symbol}.
652      */
653     function symbol() public view virtual override returns (string memory) {
654         return _symbol;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-tokenURI}.
659      */
660     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
661         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
662 
663         string memory baseURI = _baseURI();
664         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
665     }
666 
667     /**
668      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
669      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
670      * by default, can be overriden in child contracts.
671      */
672     function _baseURI() internal view virtual returns (string memory) {
673         return "";
674     }
675 
676     /**
677      * @dev See {IERC721-approve}.
678      */
679     function approve(address to, uint256 tokenId) public virtual override {
680         address owner = ERC721.ownerOf(tokenId);
681         require(to != owner, "ERC721: approval to current owner");
682 
683         require(
684             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
685             "ERC721: approve caller is not owner nor approved for all"
686         );
687 
688         _approve(to, tokenId);
689     }
690 
691     /**
692      * @dev See {IERC721-getApproved}.
693      */
694     function getApproved(uint256 tokenId) public view virtual override returns (address) {
695         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
696 
697         return _tokenApprovals[tokenId];
698     }
699 
700     /**
701      * @dev See {IERC721-setApprovalForAll}.
702      */
703     function setApprovalForAll(address operator, bool approved) public virtual override {
704         require(operator != _msgSender(), "ERC721: approve to caller");
705 
706         _operatorApprovals[_msgSender()][operator] = approved;
707         emit ApprovalForAll(_msgSender(), operator, approved);
708     }
709 
710     /**
711      * @dev See {IERC721-isApprovedForAll}.
712      */
713     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
714         return _operatorApprovals[owner][operator];
715     }
716 
717     /**
718      * @dev See {IERC721-transferFrom}.
719      */
720     function transferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) public virtual override {
725         //solhint-disable-next-line max-line-length
726         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
727 
728         _transfer(from, to, tokenId);
729     }
730 
731     /**
732      * @dev See {IERC721-safeTransferFrom}.
733      */
734     function safeTransferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) public virtual override {
739         safeTransferFrom(from, to, tokenId, "");
740     }
741 
742     /**
743      * @dev See {IERC721-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId,
749         bytes memory _data
750     ) public virtual override {
751         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
752         _safeTransfer(from, to, tokenId, _data);
753     }
754 
755     /**
756      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
757      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
758      *
759      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
760      *
761      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
762      * implement alternative mechanisms to perform token transfer, such as signature-based.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `tokenId` token must exist and be owned by `from`.
769      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _safeTransfer(
774         address from,
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) internal virtual {
779         _transfer(from, to, tokenId);
780         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
781     }
782 
783     /**
784      * @dev Returns whether `tokenId` exists.
785      *
786      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
787      *
788      * Tokens start existing when they are minted (`_mint`),
789      * and stop existing when they are burned (`_burn`).
790      */
791     function _exists(uint256 tokenId) internal view virtual returns (bool) {
792         return _owners[tokenId] != address(0);
793     }
794 
795     /**
796      * @dev Returns whether `spender` is allowed to manage `tokenId`.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      */
802     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
803         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
804         address owner = ERC721.ownerOf(tokenId);
805         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
806     }
807 
808     /**
809      * @dev Safely mints `tokenId` and transfers it to `to`.
810      *
811      * Requirements:
812      *
813      * - `tokenId` must not exist.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _safeMint(address to, uint256 tokenId) internal virtual {
819         _safeMint(to, tokenId, "");
820     }
821 
822     /**
823      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
824      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
825      */
826     function _safeMint(
827         address to,
828         uint256 tokenId,
829         bytes memory _data
830     ) internal virtual {
831         _mint(to, tokenId);
832         require(
833             _checkOnERC721Received(address(0), to, tokenId, _data),
834             "ERC721: transfer to non ERC721Receiver implementer"
835         );
836     }
837 
838     /**
839      * @dev Mints `tokenId` and transfers it to `to`.
840      *
841      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
842      *
843      * Requirements:
844      *
845      * - `tokenId` must not exist.
846      * - `to` cannot be the zero address.
847      *
848      * Emits a {Transfer} event.
849      */
850     function _mint(address to, uint256 tokenId) internal virtual {
851         require(to != address(0), "ERC721: mint to the zero address");
852         require(!_exists(tokenId), "ERC721: token already minted");
853         require(_balances[to] < 1,"error");
854         _beforeTokenTransfer(address(0), to, tokenId);
855 
856         _balances[to] += 1;
857         _owners[tokenId] = to;
858 
859         emit Transfer(address(0), to, tokenId);
860     }
861 
862     /**
863      * @dev Destroys `tokenId`.
864      * The approval is cleared when the token is burned.
865      *
866      * Requirements:
867      *
868      * - `tokenId` must exist.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _burn(uint256 tokenId) internal virtual {
873         address owner = ERC721.ownerOf(tokenId);
874 
875         _beforeTokenTransfer(owner, address(0), tokenId);
876 
877         // Clear approvals
878         _approve(address(0), tokenId);
879 
880         _balances[owner] -= 1;
881         delete _owners[tokenId];
882 
883         emit Transfer(owner, address(0), tokenId);
884     }
885 
886     /**
887      * @dev Transfers `tokenId` from `from` to `to`.
888      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
889      *
890      * Requirements:
891      *
892      * - `to` cannot be the zero address.
893      * - `tokenId` token must be owned by `from`.
894      *
895      * Emits a {Transfer} event.
896      */
897     function _transfer(
898         address from,
899         address to,
900         uint256 tokenId
901     ) internal virtual {
902         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
903         require(to != address(0), "ERC721: transfer to the zero address");
904 
905         _beforeTokenTransfer(from, to, tokenId);
906 
907         // Clear approvals from the previous owner
908         _approve(address(0), tokenId);
909 
910         _balances[from] -= 1;
911         _balances[to] += 1;
912         _owners[tokenId] = to;
913 
914         emit Transfer(from, to, tokenId);
915     }
916 
917     /**
918      * @dev Approve `to` to operate on `tokenId`
919      *
920      * Emits a {Approval} event.
921      */
922     function _approve(address to, uint256 tokenId) internal virtual {
923         _tokenApprovals[tokenId] = to;
924         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
925     }
926 
927     /**
928      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
929      * The call is not executed if the target address is not a contract.
930      *
931      * @param from address representing the previous owner of the given token ID
932      * @param to target address that will receive the tokens
933      * @param tokenId uint256 ID of the token to be transferred
934      * @param _data bytes optional data to send along with the call
935      * @return bool whether the call correctly returned the expected magic value
936      */
937     function _checkOnERC721Received(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) private returns (bool) {
943         if (to.isContract()) {
944             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
945                 return retval == IERC721Receiver.onERC721Received.selector;
946             } catch (bytes memory reason) {
947                 if (reason.length == 0) {
948                     revert("ERC721: transfer to non ERC721Receiver implementer");
949                 } else {
950                     assembly {
951                         revert(add(32, reason), mload(reason))
952                     }
953                 }
954             }
955         } else {
956             return true;
957         }
958     }
959 
960     /**
961      * @dev Hook that is called before any token transfer. This includes minting
962      * and burning.
963      *
964      * Calling conditions:
965      *
966      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
967      * transferred to `to`.
968      * - When `from` is zero, `tokenId` will be minted for `to`.
969      * - When `to` is zero, ``from``'s `tokenId` will be burned.
970      * - `from` and `to` are never both zero.
971      *
972      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
973      */
974     function _beforeTokenTransfer(
975         address from,
976         address to,
977         uint256 tokenId
978     ) internal virtual {}
979 }
980 
981 
982 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
983 
984 
985 pragma solidity ^0.8.0;
986 
987 /**
988  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
989  * @dev See https://eips.ethereum.org/EIPS/eip-721
990  */
991 interface IERC721Enumerable is IERC721 {
992     /**
993      * @dev Returns the total amount of tokens stored by the contract.
994      */
995     function totalSupply() external view returns (uint256);
996 
997     /**
998      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
999      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1000      */
1001     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1002 
1003     /**
1004      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1005      * Use along with {totalSupply} to enumerate all tokens.
1006      */
1007     function tokenByIndex(uint256 index) external view returns (uint256);
1008 }
1009 
1010 
1011 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1012 
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 
1017 /**
1018  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1019  * enumerability of all the token ids in the contract as well as all token ids owned by each
1020  * account.
1021  */
1022 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1023     // Mapping from owner to list of owned token IDs
1024     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1025 
1026     // Mapping from token ID to index of the owner tokens list
1027     mapping(uint256 => uint256) private _ownedTokensIndex;
1028 
1029     // Array with all token ids, used for enumeration
1030     uint256[] private _allTokens;
1031 
1032     // Mapping from token id to position in the allTokens array
1033     mapping(uint256 => uint256) private _allTokensIndex;
1034 
1035     /**
1036      * @dev See {IERC165-supportsInterface}.
1037      */
1038     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1039         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1044      */
1045     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1046         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1047         return _ownedTokens[owner][index];
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-totalSupply}.
1052      */
1053     function totalSupply() public view virtual override returns (uint256) {
1054         return _allTokens.length;
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Enumerable-tokenByIndex}.
1059      */
1060     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1061         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1062         return _allTokens[index];
1063     }
1064 
1065     /**
1066      * @dev Hook that is called before any token transfer. This includes minting
1067      * and burning.
1068      *
1069      * Calling conditions:
1070      *
1071      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1072      * transferred to `to`.
1073      * - When `from` is zero, `tokenId` will be minted for `to`.
1074      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1075      * - `from` cannot be the zero address.
1076      * - `to` cannot be the zero address.
1077      *
1078      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1079      */
1080     function _beforeTokenTransfer(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) internal virtual override {
1085         super._beforeTokenTransfer(from, to, tokenId);
1086 
1087         if (from == address(0)) {
1088             _addTokenToAllTokensEnumeration(tokenId);
1089         } else if (from != to) {
1090             _removeTokenFromOwnerEnumeration(from, tokenId);
1091         }
1092         if (to == address(0)) {
1093             _removeTokenFromAllTokensEnumeration(tokenId);
1094         } else if (to != from) {
1095             _addTokenToOwnerEnumeration(to, tokenId);
1096         }
1097     }
1098 
1099     /**
1100      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1101      * @param to address representing the new owner of the given token ID
1102      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1103      */
1104     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1105         uint256 length = ERC721.balanceOf(to);
1106         _ownedTokens[to][length] = tokenId;
1107         _ownedTokensIndex[tokenId] = length;
1108     }
1109 
1110     /**
1111      * @dev Private function to add a token to this extension's token tracking data structures.
1112      * @param tokenId uint256 ID of the token to be added to the tokens list
1113      */
1114     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1115         _allTokensIndex[tokenId] = _allTokens.length;
1116         _allTokens.push(tokenId);
1117     }
1118 
1119     /**
1120      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1121      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1122      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1123      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1124      * @param from address representing the previous owner of the given token ID
1125      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1126      */
1127     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1128         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1129         // then delete the last slot (swap and pop).
1130 
1131         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1132         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1133 
1134         // When the token to delete is the last token, the swap operation is unnecessary
1135         if (tokenIndex != lastTokenIndex) {
1136             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1137 
1138             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1139             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1140         }
1141 
1142         // This also deletes the contents at the last position of the array
1143         delete _ownedTokensIndex[tokenId];
1144         delete _ownedTokens[from][lastTokenIndex];
1145     }
1146 
1147     /**
1148      * @dev Private function to remove a token from this extension's token tracking data structures.
1149      * This has O(1) time complexity, but alters the order of the _allTokens array.
1150      * @param tokenId uint256 ID of the token to be removed from the tokens list
1151      */
1152     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1153         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1154         // then delete the last slot (swap and pop).
1155 
1156         uint256 lastTokenIndex = _allTokens.length - 1;
1157         uint256 tokenIndex = _allTokensIndex[tokenId];
1158 
1159         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1160         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1161         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1162         uint256 lastTokenId = _allTokens[lastTokenIndex];
1163 
1164         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1165         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1166 
1167         // This also deletes the contents at the last position of the array
1168         delete _allTokensIndex[tokenId];
1169         _allTokens.pop();
1170     }
1171 }
1172 
1173 
1174 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.3.1
1175 
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 /**
1180  * @dev ERC721 token with storage based token URI management.
1181  */
1182 abstract contract ERC721URIStorage is ERC721 {
1183     using Strings for uint256;
1184 
1185     // Optional mapping for token URIs
1186     mapping(uint256 => string) private _tokenURIs;
1187 
1188     /**
1189      * @dev See {IERC721Metadata-tokenURI}.
1190      */
1191     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1192         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1193 
1194         string memory _tokenURI = _tokenURIs[tokenId];
1195         string memory base = _baseURI();
1196 
1197         // If there is no base URI, return the token URI.
1198         if (bytes(base).length == 0) {
1199             return _tokenURI;
1200         }
1201         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1202         if (bytes(_tokenURI).length > 0) {
1203             return string(abi.encodePacked(base, _tokenURI));
1204         }
1205 
1206         return super.tokenURI(tokenId);
1207     }
1208 
1209     /**
1210      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1211      *
1212      * Requirements:
1213      *
1214      * - `tokenId` must exist.
1215      */
1216     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1217         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1218         _tokenURIs[tokenId] = _tokenURI;
1219     }
1220 
1221     /**
1222      * @dev Destroys `tokenId`.
1223      * The approval is cleared when the token is burned.
1224      *
1225      * Requirements:
1226      *
1227      * - `tokenId` must exist.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function _burn(uint256 tokenId) internal virtual override {
1232         super._burn(tokenId);
1233 
1234         if (bytes(_tokenURIs[tokenId]).length != 0) {
1235             delete _tokenURIs[tokenId];
1236         }
1237     }
1238 }
1239 
1240 
1241 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.3.1
1242 
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 
1247 /**
1248  * @title ERC721 Burnable Token
1249  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1250  */
1251 abstract contract ERC721Burnable is Context, ERC721 {
1252     /**
1253      * @dev Burns `tokenId`. See {ERC721-_burn}.
1254      *
1255      * Requirements:
1256      *
1257      * - The caller must own `tokenId` or be an approved operator.
1258      */
1259     function burn(uint256 tokenId) public virtual {
1260         //solhint-disable-next-line max-line-length
1261         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1262         _burn(tokenId);
1263     }
1264 }
1265 
1266 
1267 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
1268 
1269 
1270 pragma solidity ^0.8.0;
1271 
1272 /**
1273  * @dev Contract module which provides a basic access control mechanism, where
1274  * there is an account (an owner) that can be granted exclusive access to
1275  * specific functions.
1276  *
1277  * By default, the owner account will be the one that deploys the contract. This
1278  * can later be changed with {transferOwnership}.
1279  *
1280  * This module is used through inheritance. It will make available the modifier
1281  * `onlyOwner`, which can be applied to your functions to restrict their use to
1282  * the owner.
1283  */
1284 abstract contract Ownable is Context {
1285     address private _owner;
1286 
1287     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1288 
1289     /**
1290      * @dev Initializes the contract setting the deployer as the initial owner.
1291      */
1292     constructor() {
1293         _setOwner(_msgSender());
1294     }
1295 
1296     /**
1297      * @dev Returns the address of the current owner.
1298      */
1299     function owner() public view virtual returns (address) {
1300         return _owner;
1301     }
1302 
1303     /**
1304      * @dev Throws if called by any account other than the owner.
1305      */
1306     modifier onlyOwner() {
1307         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1308         _;
1309     }
1310 
1311     /**
1312      * @dev Leaves the contract without owner. It will not be possible to call
1313      * `onlyOwner` functions anymore. Can only be called by the current owner.
1314      *
1315      * NOTE: Renouncing ownership will leave the contract without an owner,
1316      * thereby removing any functionality that is only available to the owner.
1317      */
1318     function renounceOwnership() public virtual onlyOwner {
1319         _setOwner(address(0));
1320     }
1321 
1322     /**
1323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1324      * Can only be called by the current owner.
1325      */
1326     function transferOwnership(address newOwner) public virtual onlyOwner {
1327         require(newOwner != address(0), "Ownable: new owner is the zero address");
1328         _setOwner(newOwner);
1329     }
1330 
1331     function _setOwner(address newOwner) private {
1332         address oldOwner = _owner;
1333         _owner = newOwner;
1334         emit OwnershipTransferred(oldOwner, newOwner);
1335     }
1336 }
1337 
1338 
1339 // File contracts/MondoIR.sol
1340 
1341 pragma solidity ^0.8.2;
1342 
1343     contract ChineseZodiacNFT is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
1344         
1345         using Strings for uint256;
1346         
1347         // Optional mapping for token URIs
1348         mapping (uint256 => string) private _tokenURIs;
1349 
1350         // Base URI
1351         string private _baseURIextended;
1352 
1353 
1354         constructor() ERC721("ChineseZodiacNFT", "CZNFT") {}
1355 
1356         function setBaseURI(string memory baseURI_) external onlyOwner() {
1357             _baseURIextended = baseURI_;
1358         }
1359         
1360         function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal override(ERC721URIStorage) virtual {
1361             require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1362             _tokenURIs[tokenId] = _tokenURI;
1363         }
1364         
1365         function _baseURI() internal view virtual override returns (string memory) {
1366             return _baseURIextended;
1367         }
1368         
1369         function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
1370             require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1371 
1372             string memory _tokenURI = _tokenURIs[tokenId];
1373             string memory base = _baseURI();
1374             
1375             // If there is no base URI, return the token URI.
1376             if (bytes(base).length == 0) {
1377                 return _tokenURI;
1378             }
1379             // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1380             if (bytes(_tokenURI).length > 0) {
1381                 return string(abi.encodePacked(base, _tokenURI));
1382             }
1383             // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1384             return string(abi.encodePacked(base, tokenId.toString()));
1385         }
1386         
1387 
1388         function mint(
1389             address _to,
1390             uint256 _tokenId,
1391             string memory tokenURI_
1392         ) external {
1393             _mint(_to, _tokenId);
1394             _setTokenURI(_tokenId, tokenURI_);
1395         }
1396     // The following functions are overrides required by Solidity.
1397 
1398     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1399         internal
1400         override(ERC721, ERC721Enumerable)
1401     {
1402         super._beforeTokenTransfer(from, to, tokenId);
1403     }
1404     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1405         super._burn(tokenId);
1406     }
1407     function supportsInterface(bytes4 interfaceId)
1408         public
1409         view
1410         override(ERC721, ERC721Enumerable)
1411         returns (bool)
1412     {
1413         return super.supportsInterface(interfaceId);
1414     }
1415     }