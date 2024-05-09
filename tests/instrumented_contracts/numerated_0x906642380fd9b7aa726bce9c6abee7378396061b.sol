1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.0
2 
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
28 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.0
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
171 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.0
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
200 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.0
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
227 // File @openzeppelin/contracts/utils/Address.sol@v4.3.0
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
446 // File @openzeppelin/contracts/utils/Context.sol@v4.3.0
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
472 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.0
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
541 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.0
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
570 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.0
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
982 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.0
983 
984 
985 pragma solidity ^0.8.0;
986 
987 /**
988  * @dev Contract module which provides a basic access control mechanism, where
989  * there is an account (an owner) that can be granted exclusive access to
990  * specific functions.
991  *
992  * By default, the owner account will be the one that deploys the contract. This
993  * can later be changed with {transferOwnership}.
994  *
995  * This module is used through inheritance. It will make available the modifier
996  * `onlyOwner`, which can be applied to your functions to restrict their use to
997  * the owner.
998  */
999 abstract contract Ownable is Context {
1000     address private _owner;
1001 
1002     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1003 
1004     /**
1005      * @dev Initializes the contract setting the deployer as the initial owner.
1006      */
1007     constructor() {
1008         _setOwner(_msgSender());
1009     }
1010 
1011     /**
1012      * @dev Returns the address of the current owner.
1013      */
1014     function owner() public view virtual returns (address) {
1015         return _owner;
1016     }
1017 
1018     /**
1019      * @dev Throws if called by any account other than the owner.
1020      */
1021     modifier onlyOwner() {
1022         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1023         _;
1024     }
1025 
1026     /**
1027      * @dev Leaves the contract without owner. It will not be possible to call
1028      * `onlyOwner` functions anymore. Can only be called by the current owner.
1029      *
1030      * NOTE: Renouncing ownership will leave the contract without an owner,
1031      * thereby removing any functionality that is only available to the owner.
1032      */
1033     function renounceOwnership() public virtual onlyOwner {
1034         _setOwner(address(0));
1035     }
1036 
1037     /**
1038      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1039      * Can only be called by the current owner.
1040      */
1041     function transferOwnership(address newOwner) public virtual onlyOwner {
1042         require(newOwner != address(0), "Ownable: new owner is the zero address");
1043         _setOwner(newOwner);
1044     }
1045 
1046     function _setOwner(address newOwner) private {
1047         address oldOwner = _owner;
1048         _owner = newOwner;
1049         emit OwnershipTransferred(oldOwner, newOwner);
1050     }
1051 }
1052 
1053 
1054 // File contracts/INCOOOM.sol
1055 
1056 // SPDX-License-Identifier: AGPL-3.0-or-later
1057 pragma solidity ^0.8.0;
1058 
1059 
1060 interface IHelper {
1061     function cardValue(uint _number) external pure returns(string memory _suit, string memory _value, bool _joker);
1062 }
1063 
1064 contract INCOOOM is ERC721, Ownable {
1065     using Strings for uint256;
1066 
1067     /* ======== EVENTS ======== */
1068 
1069     event DealPreFlop(address _recipient, uint _amount);
1070     event Deal(address _recipient, uint _amount);
1071 
1072 
1073     /* ======== STRUCTS ======== */
1074 
1075     struct CardInfo {
1076         string suit;
1077         string value;
1078         bool joker;
1079         uint deck;
1080         uint cardNumber;
1081         TIER tier;
1082     }
1083 
1084     struct Deck {
1085         TIER tier;
1086         uint tiersRemaining;
1087     }
1088 
1089     struct PreSale {
1090         uint _blockStart;
1091         uint _blockEnd;
1092     }
1093 
1094     /* ======== ENUM ======== */
1095 
1096     enum TIER {COMMON, GOLD, PSYCHEDELIC}
1097 
1098     /* ======== STATE VARIABLES ======== */
1099 
1100     uint256[54] private numberArr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
1101     40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53];
1102 
1103     PreSale public preSale;
1104 
1105     address payable public treasury;
1106     address payable public fund;
1107     address public helper;
1108     string private _baseUri = "ipfs://QmaGRDin2YYRj3zbPE23p6YPeTpMn7YcFqtVDD6aY8Zoo3/";
1109     
1110     uint private constant numberOfDecks = 54;
1111     uint public cardsLeftInDeck;
1112     uint public currentDeck;
1113     uint public totalSupply;
1114     uint private immutable preSaleLength;
1115     uint256 private constant PRICE_PER_CARD = 99000000000000000 wei;
1116     uint256 private constant PRICE_PER_CARD_PRESALE = 33000000000000000 wei;
1117 
1118     bool public preSaleActive;
1119     bool public saleActive;
1120 
1121     /* ======== MAPPINGS ======== */
1122 
1123     mapping(address => mapping(uint => uint)) public cardsPerDeckPurchased;
1124     mapping(uint => CardInfo) private cardInfo;
1125     mapping(TIER => uint) private tiersRemaining;
1126     mapping(TIER => uint) private preSaleTiersRemaining;
1127     mapping(uint => TIER) private tierOfDeck;
1128     mapping(uint => Deck) private deckInfo;
1129     mapping(uint => bool) public deckFullyDelt;
1130 
1131     /* ======== CONSTRUCTOR ======== */
1132 
1133     constructor(address payable _treasury, address payable _fund, address _helper, uint _preSaleLength) ERC721("INCOOOM", "OOO") {
1134         require(_treasury != address(0));
1135         treasury = _treasury;
1136 
1137         require(_fund != address(0));
1138         fund = _fund;
1139 
1140         require(_helper != address(0));
1141         helper = _helper;
1142 
1143         preSaleLength = _preSaleLength;
1144 
1145         tiersRemaining[TIER.COMMON] = 36;
1146         tiersRemaining[TIER.GOLD] = 12;
1147         tiersRemaining[TIER.PSYCHEDELIC] = 6;
1148     }
1149 
1150     /* ======== ADMIN FUNCTIONS ======== */
1151 
1152     /**
1153         @notice start presale
1154     */
1155     function startPreSale() external onlyOwner() {
1156         require(preSale._blockStart == 0, "Presale already started");
1157         preSaleActive = true;
1158 
1159         preSale = PreSale ({
1160             _blockStart: block.number,
1161             _blockEnd: block.number + preSaleLength
1162         });
1163 
1164         preSaleTiersRemaining[TIER.COMMON] = 3;
1165         preSaleTiersRemaining[TIER.GOLD] = 2;
1166         preSaleTiersRemaining[TIER.PSYCHEDELIC] = 1;
1167         _newDeck(_randomTier());
1168     }
1169 
1170     /**
1171         @notice start main sale
1172     */
1173     function startSale() external onlyOwner() {
1174         require(preSale._blockStart != 0 && !saleActive && preSale._blockEnd < block.number, "Cannot start presale twice or start while presale is going on");
1175         preSaleActive = false;
1176         saleActive = true;
1177     }
1178 
1179     /**
1180         @notice allows admin to reserve decks
1181         @param _recipient address
1182         @param _amount uint
1183         @param _tier TIER
1184      */
1185     function reserveDeck(address _recipient, uint _amount, TIER _tier) external onlyOwner() {
1186         require(preSale._blockStart == 0, "Presale has been started");
1187         for(uint i; i < _amount; i++) {
1188             _newDeck(_tier);
1189             for(uint n; n < numberArr.length; n++){
1190                 _mintCard(_recipient, numberArr[n]);
1191             }
1192         }
1193         deckFullyDelt[currentDeck] = true;
1194     }
1195 
1196     /**
1197         @notice allows admin to set base URI
1198         @param _uri string
1199      */
1200     function setBaseURI(string calldata _uri) external onlyOwner() {
1201         _baseUri = _uri;
1202     }
1203 
1204     /**
1205         @notice withdraw ETH in contract to fund and treasury
1206      */
1207     function withdraw() external onlyOwner() {
1208         require(address(this).balance > 0, "Balance is 0");
1209         uint _fundSend = address(this).balance / 2;
1210         uint _treasurySend = address(this).balance - _fundSend;
1211 
1212         (bool successFund,) = fund.call{value:_fundSend}("");
1213         require(successFund, "could not send to fund");
1214 
1215         (bool successTreasury,) = treasury.call{value:_treasurySend}("");
1216         require(successTreasury, "could not send to treasury");
1217     }
1218 
1219     /* ======== USER FUNCTIONS ======== */
1220 
1221 
1222     /**
1223         @notice allows users to participate in presale
1224         @param _amount uint
1225      */
1226     function dealPreFlop(uint _amount) external payable {
1227         require(preSale._blockEnd > block.number && preSaleActive, "Presale not active");
1228         require(cardsPerDeckPurchased[msg.sender][currentDeck] + _amount <= 5, "Over 5 cards in a single deck");
1229         require( msg.value == PRICE_PER_CARD_PRESALE * _amount, "Wrong amount");
1230 
1231         if(cardsLeftInDeck >= _amount) {
1232             _deal(_amount);
1233         } else {
1234             uint _nextDeck = _amount - cardsLeftInDeck;
1235             _deal(cardsLeftInDeck);
1236             _deal(_nextDeck);
1237         }
1238 
1239         if(currentDeck == 13) {
1240             preSaleActive = false;
1241             require(cardsLeftInDeck == 54, "Cannot mint over 6 decks in presale");
1242         }
1243 
1244         emit DealPreFlop(msg.sender, _amount);
1245     }
1246 
1247     /**
1248         @notice allows users to participate in sale
1249         @param _amount uint
1250      */
1251     function deal(uint _amount) external payable {
1252         require(saleActive);
1253         require(cardsPerDeckPurchased[msg.sender][currentDeck] + _amount <= 5, "Over 5 cards in a single deck");
1254         require( msg.value == PRICE_PER_CARD * _amount, "Wrong amount");
1255 
1256         if(cardsLeftInDeck >= _amount) {
1257             _deal(_amount);
1258         } else {
1259             uint _nextDeck = _amount - cardsLeftInDeck;
1260             _deal(cardsLeftInDeck);
1261             _deal(_nextDeck);
1262         }
1263 
1264         emit Deal(msg.sender, _amount);
1265     }
1266 
1267 
1268     /* ======== INTERNAL HELPER FUNCTIONS ======== */
1269 
1270 
1271     /**
1272         @notice internal deal function
1273         @param _amount uint
1274      */
1275     function _deal(uint _amount) internal {
1276         cardsPerDeckPurchased[msg.sender][currentDeck] += _amount;
1277 
1278         for(uint i; i < _amount; i++) {
1279 
1280             uint _id = numberArr[numberArr.length - cardsLeftInDeck];
1281 
1282             _mintCard(msg.sender, _id);
1283 
1284             cardsLeftInDeck -= 1;
1285         }
1286 
1287         if(cardsLeftInDeck == 0) {
1288             _newDeck(_randomTier());
1289         }
1290     }
1291 
1292     /**
1293         @notice gets random tier for new deck
1294      */
1295     function _randomTier() internal view returns(TIER) {
1296         uint256 n = uint256(keccak256(abi.encodePacked(block.timestamp))) % 9;
1297 
1298         TIER _tier;
1299         if(preSale._blockEnd > block.number && preSaleActive && currentDeck < 12) {
1300             if(n <= 5 && preSaleTiersRemaining[TIER.COMMON] > 0) {
1301                 _tier = TIER.COMMON;
1302             } else if(n <= 7 && preSaleTiersRemaining[TIER.GOLD] > 0) {
1303                 _tier = TIER.GOLD;
1304             } else if( n == 8 && preSaleTiersRemaining[TIER.PSYCHEDELIC] > 0 ) {
1305                 _tier = TIER.PSYCHEDELIC;
1306             } else {
1307                 if(preSaleTiersRemaining[TIER.GOLD] > 0 ) {
1308                     _tier = TIER.GOLD;
1309                 } else if(preSaleTiersRemaining[TIER.COMMON] > 0) {
1310                     _tier = TIER.COMMON;
1311                 } else {
1312                     _tier = TIER.PSYCHEDELIC;
1313                 }
1314             }
1315         } else {
1316             if(n <= 5 && tiersRemaining[TIER.COMMON] > 0) {
1317                 _tier = TIER.COMMON;
1318             } else if(n <= 7 && tiersRemaining[TIER.GOLD] > 0) {
1319                 _tier = TIER.GOLD;
1320             } else if( n == 8 && tiersRemaining[TIER.PSYCHEDELIC] > 0 ) {
1321                 _tier = TIER.PSYCHEDELIC;
1322             } else {
1323                 if(tiersRemaining[TIER.GOLD] > 0 ) {
1324                     _tier = TIER.GOLD;
1325                 } else if(tiersRemaining[TIER.COMMON] > 0) {
1326                     _tier = TIER.COMMON;
1327                 } else {
1328                     _tier = TIER.PSYCHEDELIC;
1329                 }
1330             }
1331         }
1332 
1333         return _tier;
1334     }
1335 
1336     /**
1337         @notice sets new deck
1338         @param _tier TIER
1339      */
1340     function _newDeck(TIER _tier) internal {
1341         require(!deckFullyDelt[54], "All decks delt");
1342         deckFullyDelt[currentDeck] = true;
1343 
1344         if(preSale._blockEnd > block.number && preSaleActive && currentDeck < 12) {
1345             preSaleTiersRemaining[_tier] -= 1;
1346         }
1347 
1348         if(currentDeck < numberOfDecks) {
1349             deckInfo[currentDeck + 1] = Deck({
1350                 tier: _tier,
1351                 tiersRemaining: tiersRemaining[_tier]
1352             });
1353 
1354             tiersRemaining[_tier] -= 1;
1355 
1356             currentDeck += 1; 
1357             cardsLeftInDeck = 54;
1358             tierOfDeck[currentDeck] = _tier;
1359             _shuffle();
1360         }
1361     }
1362 
1363     /**
1364         @notice shuffles deck upon new deck being delt
1365      */
1366     function _shuffle() internal {
1367         for (uint256 i = 0; i < numberArr.length; i++) {
1368             uint256 n = i + uint256(keccak256(abi.encodePacked(block.timestamp))) % (numberArr.length - i);
1369             uint256 temp = numberArr[n];
1370             numberArr[n] = numberArr[i];
1371             numberArr[i] = temp;
1372         }
1373     }
1374 
1375     /**
1376         @notice mints card
1377         @param _recipient address
1378         @param _cardInDeck uint
1379         @return uint
1380      */
1381     function _mintCard(address _recipient, uint _cardInDeck) internal returns (uint) {
1382         uint id = totalSupply;
1383         totalSupply += 1;
1384 
1385         _safeMint(_recipient, id);
1386 
1387         (string memory _suit, string memory _value, bool _joker) = IHelper(helper).cardValue(_cardInDeck);
1388 
1389         cardInfo[id] = CardInfo({
1390             suit: _suit,
1391             value: _value,
1392             joker: _joker,
1393             deck: currentDeck,
1394             cardNumber: _cardInDeck,
1395             tier: tierOfDeck[currentDeck]
1396         });
1397 
1398         return(id);
1399     }
1400 
1401     /* ======== VIEW FUNCTIONS ======== */
1402 
1403     /**
1404         @notice gets info of a card
1405         @param _id uint
1406         @return _cardInfo CardInfo
1407      */
1408     function getCardInfo(uint _id) external view returns(CardInfo memory _cardInfo) {
1409         uint _deck = cardInfo[_id].deck;
1410         if(deckFullyDelt[_deck]) {
1411             _cardInfo = cardInfo[_id];
1412         }
1413     }
1414 
1415     /**
1416         @notice gets URI of a specific token ID
1417         @param tokenId uint
1418         @return string
1419      */
1420     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1421         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1422         CardInfo memory _cardInfo = cardInfo[tokenId];
1423     
1424         uint _uri;
1425         uint _tierNumber = deckInfo[_cardInfo.deck].tiersRemaining;
1426         uint _num = _cardInfo.cardNumber + 1;
1427 
1428         if(!deckFullyDelt[_cardInfo.deck]) {
1429             _uri = 0;
1430         } else {
1431             if(_cardInfo.tier == TIER.COMMON) {
1432                 _uri = _num + (54 * (36 - _tierNumber));
1433             } else if (_cardInfo.tier == TIER.GOLD) {
1434                 _uri = _num + (54 * (12 - _tierNumber + 36));
1435             } else {
1436                 _uri = _num + (54 * (6 - _tierNumber + 48));
1437             }
1438         }    
1439 
1440         return string(abi.encodePacked(baseURI(), uint256(_uri).toString()));
1441     }
1442 
1443      /**
1444         @notice gets base URI
1445         @return string
1446      */
1447     function baseURI() public view virtual returns (string memory) {
1448         return _baseUri;
1449     }
1450 
1451 }