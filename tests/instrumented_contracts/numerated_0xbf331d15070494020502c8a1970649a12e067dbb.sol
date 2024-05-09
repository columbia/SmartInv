1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.4;
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
28 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129 
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141 
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 }
169 
170 
171 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
172 
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @title ERC721 token receiver interface
178  * @dev Interface for any contract that wants to support safeTransfers
179  * from ERC721 asset contracts.
180  */
181 interface IERC721Receiver {
182     /**
183      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
184      * by `operator` from `from`, this function is called.
185      *
186      * It must return its Solidity selector to confirm the token transfer.
187      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
188      *
189      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
190      */
191     function onERC721Received(
192         address operator,
193         address from,
194         uint256 tokenId,
195         bytes calldata data
196     ) external returns (bytes4);
197 }
198 
199 
200 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
201 
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Metadata is IERC721 {
210     /**
211      * @dev Returns the token collection name.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the token collection symbol.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
222      */
223     function tokenURI(uint256 tokenId) external view returns (string memory);
224 }
225 
226 
227 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
228 
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev Collection of functions related to the address type
234  */
235 library Address {
236     /**
237      * @dev Returns true if `account` is a contract.
238      *
239      * [IMPORTANT]
240      * ====
241      * It is unsafe to assume that an address for which this function returns
242      * false is an externally-owned account (EOA) and not a contract.
243      *
244      * Among others, `isContract` will return false for the following
245      * types of addresses:
246      *
247      *  - an externally-owned account
248      *  - a contract in construction
249      *  - an address where a contract will be created
250      *  - an address where a contract lived, but was destroyed
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // This method relies on extcodesize, which returns 0 for contracts in
255         // construction, since the code is only stored at the end of the
256         // constructor execution.
257 
258         uint256 size;
259         assembly {
260             size := extcodesize(account)
261         }
262         return size > 0;
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, "Address: insufficient balance");
283 
284         (bool success, ) = recipient.call{value: amount}("");
285         require(success, "Address: unable to send value, recipient may have reverted");
286     }
287 
288     /**
289      * @dev Performs a Solidity function call using a low level `call`. A
290      * plain `call` is an unsafe replacement for a function call: use this
291      * function instead.
292      *
293      * If `target` reverts with a revert reason, it is bubbled up by this
294      * function (like regular Solidity function calls).
295      *
296      * Returns the raw returned data. To convert to the expected return value,
297      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
298      *
299      * Requirements:
300      *
301      * - `target` must be a contract.
302      * - calling `target` with `data` must not revert.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionCall(target, data, "Address: low-level call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
312      * `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but also transferring `value` wei to `target`.
327      *
328      * Requirements:
329      *
330      * - the calling contract must have an ETH balance of at least `value`.
331      * - the called Solidity function must be `payable`.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         require(isContract(target), "Address: call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.call{value: value}(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
369         return functionStaticCall(target, data, "Address: low-level static call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal view returns (bytes memory) {
383         require(isContract(target), "Address: static call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.staticcall(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
396         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.4._
404      */
405     function functionDelegateCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         require(isContract(target), "Address: delegate call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.delegatecall(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
418      * revert reason using the provided one.
419      *
420      * _Available since v4.3._
421      */
422     function verifyCallResult(
423         bool success,
424         bytes memory returndata,
425         string memory errorMessage
426     ) internal pure returns (bytes memory) {
427         if (success) {
428             return returndata;
429         } else {
430             // Look for revert reason and bubble it up if present
431             if (returndata.length > 0) {
432                 // The easiest way to bubble the revert reason is using memory via assembly
433 
434                 assembly {
435                     let returndata_size := mload(returndata)
436                     revert(add(32, returndata), returndata_size)
437                 }
438             } else {
439                 revert(errorMessage);
440             }
441         }
442     }
443 }
444 
445 
446 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
447 
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @dev Provides information about the current execution context, including the
453  * sender of the transaction and its data. While these are generally available
454  * via msg.sender and msg.data, they should not be accessed in such a direct
455  * manner, since when dealing with meta-transactions the account sending and
456  * paying for execution may not be the actual sender (as far as an application
457  * is concerned).
458  *
459  * This contract is only required for intermediate, library-like contracts.
460  */
461 abstract contract Context {
462     function _msgSender() internal view virtual returns (address) {
463         return msg.sender;
464     }
465 
466     function _msgData() internal view virtual returns (bytes calldata) {
467         return msg.data;
468     }
469 }
470 
471 
472 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
473 
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev String operations.
479  */
480 library Strings {
481     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
485      */
486     function toString(uint256 value) internal pure returns (string memory) {
487         // Inspired by OraclizeAPI's implementation - MIT licence
488         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
489 
490         if (value == 0) {
491             return "0";
492         }
493         uint256 temp = value;
494         uint256 digits;
495         while (temp != 0) {
496             digits++;
497             temp /= 10;
498         }
499         bytes memory buffer = new bytes(digits);
500         while (value != 0) {
501             digits -= 1;
502             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
503             value /= 10;
504         }
505         return string(buffer);
506     }
507 
508     /**
509      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
510      */
511     function toHexString(uint256 value) internal pure returns (string memory) {
512         if (value == 0) {
513             return "0x00";
514         }
515         uint256 temp = value;
516         uint256 length = 0;
517         while (temp != 0) {
518             length++;
519             temp >>= 8;
520         }
521         return toHexString(value, length);
522     }
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
526      */
527     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
528         bytes memory buffer = new bytes(2 * length + 2);
529         buffer[0] = "0";
530         buffer[1] = "x";
531         for (uint256 i = 2 * length + 1; i > 1; --i) {
532             buffer[i] = _HEX_SYMBOLS[value & 0xf];
533             value >>= 4;
534         }
535         require(value == 0, "Strings: hex length insufficient");
536         return string(buffer);
537     }
538 }
539 
540 
541 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
542 
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev Implementation of the {IERC165} interface.
548  *
549  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
550  * for the additional interface id that will be supported. For example:
551  *
552  * ```solidity
553  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
555  * }
556  * ```
557  *
558  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
559  */
560 abstract contract ERC165 is IERC165 {
561     /**
562      * @dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565         return interfaceId == type(IERC165).interfaceId;
566     }
567 }
568 
569 
570 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
571 
572 
573 pragma solidity ^0.8.0;
574 
575 
576 
577 
578 
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
853 
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
982 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
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
1011 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
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
1174 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
1175 
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 /**
1180  * @title Counters
1181  * @author Matt Condon (@shrugs)
1182  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1183  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1184  *
1185  * Include with `using Counters for Counters.Counter;`
1186  */
1187 library Counters {
1188     struct Counter {
1189         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1190         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1191         // this feature: see https://github.com/ethereum/solidity/issues/4637
1192         uint256 _value; // default: 0
1193     }
1194 
1195     function current(Counter storage counter) internal view returns (uint256) {
1196         return counter._value;
1197     }
1198 
1199     function increment(Counter storage counter) internal {
1200         unchecked {
1201             counter._value += 1;
1202         }
1203     }
1204 
1205     function decrement(Counter storage counter) internal {
1206         uint256 value = counter._value;
1207         require(value > 0, "Counter: decrement overflow");
1208         unchecked {
1209             counter._value = value - 1;
1210         }
1211     }
1212 
1213     function reset(Counter storage counter) internal {
1214         counter._value = 0;
1215     }
1216 }
1217 
1218 
1219 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1220 
1221 
1222 pragma solidity ^0.8.0;
1223 
1224 /**
1225  * @dev Contract module which provides a basic access control mechanism, where
1226  * there is an account (an owner) that can be granted exclusive access to
1227  * specific functions.
1228  *
1229  * By default, the owner account will be the one that deploys the contract. This
1230  * can later be changed with {transferOwnership}.
1231  *
1232  * This module is used through inheritance. It will make available the modifier
1233  * `onlyOwner`, which can be applied to your functions to restrict their use to
1234  * the owner.
1235  */
1236 abstract contract Ownable is Context {
1237     address private _owner;
1238 
1239     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1240 
1241     /**
1242      * @dev Initializes the contract setting the deployer as the initial owner.
1243      */
1244     constructor() {
1245         _setOwner(_msgSender());
1246     }
1247 
1248     /**
1249      * @dev Returns the address of the current owner.
1250      */
1251     function owner() public view virtual returns (address) {
1252         return _owner;
1253     }
1254 
1255     /**
1256      * @dev Throws if called by any account other than the owner.
1257      */
1258     modifier onlyOwner() {
1259         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1260         _;
1261     }
1262 
1263     /**
1264      * @dev Leaves the contract without owner. It will not be possible to call
1265      * `onlyOwner` functions anymore. Can only be called by the current owner.
1266      *
1267      * NOTE: Renouncing ownership will leave the contract without an owner,
1268      * thereby removing any functionality that is only available to the owner.
1269      */
1270     function renounceOwnership() public virtual onlyOwner {
1271         _setOwner(address(0));
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Can only be called by the current owner.
1277      */
1278     function transferOwnership(address newOwner) public virtual onlyOwner {
1279         require(newOwner != address(0), "Ownable: new owner is the zero address");
1280         _setOwner(newOwner);
1281     }
1282 
1283     function _setOwner(address newOwner) private {
1284         address oldOwner = _owner;
1285         _owner = newOwner;
1286         emit OwnershipTransferred(oldOwner, newOwner);
1287     }
1288 }
1289 
1290 
1291 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.2
1292 
1293 
1294 pragma solidity ^0.8.0;
1295 
1296 // CAUTION
1297 // This version of SafeMath should only be used with Solidity 0.8 or later,
1298 // because it relies on the compiler's built in overflow checks.
1299 
1300 /**
1301  * @dev Wrappers over Solidity's arithmetic operations.
1302  *
1303  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1304  * now has built in overflow checking.
1305  */
1306 library SafeMath {
1307     /**
1308      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1309      *
1310      * _Available since v3.4._
1311      */
1312     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1313         unchecked {
1314             uint256 c = a + b;
1315             if (c < a) return (false, 0);
1316             return (true, c);
1317         }
1318     }
1319 
1320     /**
1321      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1322      *
1323      * _Available since v3.4._
1324      */
1325     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1326         unchecked {
1327             if (b > a) return (false, 0);
1328             return (true, a - b);
1329         }
1330     }
1331 
1332     /**
1333      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1334      *
1335      * _Available since v3.4._
1336      */
1337     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1338         unchecked {
1339             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1340             // benefit is lost if 'b' is also tested.
1341             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1342             if (a == 0) return (true, 0);
1343             uint256 c = a * b;
1344             if (c / a != b) return (false, 0);
1345             return (true, c);
1346         }
1347     }
1348 
1349     /**
1350      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1351      *
1352      * _Available since v3.4._
1353      */
1354     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1355         unchecked {
1356             if (b == 0) return (false, 0);
1357             return (true, a / b);
1358         }
1359     }
1360 
1361     /**
1362      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1363      *
1364      * _Available since v3.4._
1365      */
1366     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1367         unchecked {
1368             if (b == 0) return (false, 0);
1369             return (true, a % b);
1370         }
1371     }
1372 
1373     /**
1374      * @dev Returns the addition of two unsigned integers, reverting on
1375      * overflow.
1376      *
1377      * Counterpart to Solidity's `+` operator.
1378      *
1379      * Requirements:
1380      *
1381      * - Addition cannot overflow.
1382      */
1383     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1384         return a + b;
1385     }
1386 
1387     /**
1388      * @dev Returns the subtraction of two unsigned integers, reverting on
1389      * overflow (when the result is negative).
1390      *
1391      * Counterpart to Solidity's `-` operator.
1392      *
1393      * Requirements:
1394      *
1395      * - Subtraction cannot overflow.
1396      */
1397     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1398         return a - b;
1399     }
1400 
1401     /**
1402      * @dev Returns the multiplication of two unsigned integers, reverting on
1403      * overflow.
1404      *
1405      * Counterpart to Solidity's `*` operator.
1406      *
1407      * Requirements:
1408      *
1409      * - Multiplication cannot overflow.
1410      */
1411     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1412         return a * b;
1413     }
1414 
1415     /**
1416      * @dev Returns the integer division of two unsigned integers, reverting on
1417      * division by zero. The result is rounded towards zero.
1418      *
1419      * Counterpart to Solidity's `/` operator.
1420      *
1421      * Requirements:
1422      *
1423      * - The divisor cannot be zero.
1424      */
1425     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1426         return a / b;
1427     }
1428 
1429     /**
1430      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1431      * reverting when dividing by zero.
1432      *
1433      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1434      * opcode (which leaves remaining gas untouched) while Solidity uses an
1435      * invalid opcode to revert (consuming all remaining gas).
1436      *
1437      * Requirements:
1438      *
1439      * - The divisor cannot be zero.
1440      */
1441     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1442         return a % b;
1443     }
1444 
1445     /**
1446      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1447      * overflow (when the result is negative).
1448      *
1449      * CAUTION: This function is deprecated because it requires allocating memory for the error
1450      * message unnecessarily. For custom revert reasons use {trySub}.
1451      *
1452      * Counterpart to Solidity's `-` operator.
1453      *
1454      * Requirements:
1455      *
1456      * - Subtraction cannot overflow.
1457      */
1458     function sub(
1459         uint256 a,
1460         uint256 b,
1461         string memory errorMessage
1462     ) internal pure returns (uint256) {
1463         unchecked {
1464             require(b <= a, errorMessage);
1465             return a - b;
1466         }
1467     }
1468 
1469     /**
1470      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1471      * division by zero. The result is rounded towards zero.
1472      *
1473      * Counterpart to Solidity's `/` operator. Note: this function uses a
1474      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1475      * uses an invalid opcode to revert (consuming all remaining gas).
1476      *
1477      * Requirements:
1478      *
1479      * - The divisor cannot be zero.
1480      */
1481     function div(
1482         uint256 a,
1483         uint256 b,
1484         string memory errorMessage
1485     ) internal pure returns (uint256) {
1486         unchecked {
1487             require(b > 0, errorMessage);
1488             return a / b;
1489         }
1490     }
1491 
1492     /**
1493      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1494      * reverting with custom message when dividing by zero.
1495      *
1496      * CAUTION: This function is deprecated because it requires allocating memory for the error
1497      * message unnecessarily. For custom revert reasons use {tryMod}.
1498      *
1499      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1500      * opcode (which leaves remaining gas untouched) while Solidity uses an
1501      * invalid opcode to revert (consuming all remaining gas).
1502      *
1503      * Requirements:
1504      *
1505      * - The divisor cannot be zero.
1506      */
1507     function mod(
1508         uint256 a,
1509         uint256 b,
1510         string memory errorMessage
1511     ) internal pure returns (uint256) {
1512         unchecked {
1513             require(b > 0, errorMessage);
1514             return a % b;
1515         }
1516     }
1517 }
1518 
1519 /**
1520  * @title Asset
1521  * @author Kevin Eimer (@kevineimer)
1522  * @dev Used for Ethereum projects compatible with OpenSea
1523  */
1524 
1525 contract Asset is ERC721, Ownable { 
1526 
1527     bool public sale = false;
1528     bool public presale = true;
1529 
1530     string private _baseURIextended;
1531 
1532     uint16 public nonce = 1;
1533     uint public price;
1534     uint16 public earlySupply;
1535     uint16 public totalSupply;
1536     uint8 public maxTx;
1537 
1538     mapping (address => uint8) private presaleWallets;
1539 
1540     constructor(
1541         string memory _name,
1542         string memory _ticker,
1543         uint _price, 
1544         uint16 _totalSupply,
1545         uint8 _maxTx,
1546         string memory baseURI_,
1547         address[] memory _presaleWallets,
1548         uint8[] memory _presaleAmounts
1549     ) ERC721(_name, _ticker) {
1550         price = _price;
1551         earlySupply = _totalSupply;
1552         totalSupply = _totalSupply;
1553         maxTx = _maxTx;
1554         _baseURIextended = baseURI_;
1555         setPresaleWalletsAmounts(_presaleWallets, _presaleAmounts);
1556     }
1557 
1558     function setBaseURI(string memory baseURI_) public onlyOwner {
1559         _baseURIextended = baseURI_;
1560     }
1561 
1562     function _baseURI() internal view virtual override returns (string memory) {
1563         return _baseURIextended;
1564     }
1565 
1566     function setPrice(uint _newPrice) external onlyOwner {
1567         price = _newPrice;
1568     }
1569 
1570     function setEarlySupply(uint16 _newSupply) external onlyOwner {
1571         earlySupply = _newSupply;
1572     }
1573 
1574     function setTotalSupply(uint16 _newSupply) external onlyOwner {
1575         totalSupply = _newSupply;
1576     }
1577 
1578     function setPresale(bool _value) public onlyOwner {
1579         presale = _value;
1580     }
1581 
1582     function setSale(bool _value) public onlyOwner {
1583         sale = _value;
1584     }
1585 
1586     function setPresaleWalletsAmounts(address[] memory _a, uint8[] memory _amount) public onlyOwner {
1587         for (uint8 i; i < _a.length; i++) {
1588             presaleWallets[_a[i]] = _amount[i];
1589         }
1590     }
1591 
1592     function setMaxTx(uint8 _newMax) external onlyOwner {
1593         maxTx = _newMax;
1594     }
1595 
1596     function getPresaleWalletAmount(address _wallet) public view returns(uint8) {
1597         return presaleWallets[_wallet];
1598     }
1599 
1600     function buyPresale(uint8 _qty) external payable {
1601         uint8 _qtyAllowed = presaleWallets[msg.sender];
1602         require(presale, 'Presale is not active');
1603         require(_qty <= _qtyAllowed, 'You can not buy more than allowed');
1604         require(_qtyAllowed > 0, 'You can not mint on presale');
1605         require(uint16(_qty) + nonce - 1 <= earlySupply, 'No more supply');
1606         require(uint16(_qty) + nonce - 1 <= totalSupply, 'No more supply');
1607         require(msg.value >= price * _qty, 'Invalid price');
1608         presaleWallets[msg.sender] = _qtyAllowed - _qty;
1609 
1610         mintNFTs(msg.sender, _qty);
1611     }
1612 
1613     function buy(uint8 _qty) external payable {
1614         require(sale, 'Sale is not active');
1615         require(_qty <= maxTx || _qty < 1, 'You can not buy more than allowed');
1616         require(uint16(_qty) + nonce - 1 <= earlySupply, 'No more supply');
1617         require(uint16(_qty) + nonce - 1 <= totalSupply, 'No more supply');
1618         require(msg.value >= price * _qty, 'Invalid price');
1619 
1620         mintNFTs(msg.sender, _qty);
1621     }
1622 
1623     function giveaway(address _to, uint8 _qty) external onlyOwner {
1624         require(uint16(_qty) + nonce - 1 <= totalSupply, 'No more supply');
1625 
1626         mintNFTs(_to, _qty);
1627     }
1628 
1629     function mintNFTs(address _to, uint8 _qty) private {
1630         for (uint8 i = 0; i < _qty; i++) {
1631             uint16 _tokenId = nonce;
1632             _safeMint(_to, _tokenId);
1633             nonce++;
1634         }
1635     }
1636 
1637     function withdraw() external onlyOwner {
1638         payable(msg.sender).transfer(address(this).balance);
1639     }
1640 }