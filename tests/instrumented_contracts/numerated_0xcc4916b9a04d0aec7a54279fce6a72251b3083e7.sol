1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
37      */
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44 
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49 
50     /**
51      * @dev Returns the owner of the `tokenId` token.
52      *
53      * Requirements:
54      *
55      * - `tokenId` must exist.
56      */
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     /**
60      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
61      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 }
162 
163 /**
164  * @title ERC721 token receiver interface
165  * @dev Interface for any contract that wants to support safeTransfers
166  * from ERC721 asset contracts.
167  */
168 interface IERC721Receiver {
169     /**
170      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
171      * by `operator` from `from`, this function is called.
172      *
173      * It must return its Solidity selector to confirm the token transfer.
174      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
175      *
176      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
177      */
178     function onERC721Received(
179         address operator,
180         address from,
181         uint256 tokenId,
182         bytes calldata data
183     ) external returns (bytes4);
184 }
185 
186 /**
187  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
188  * @dev See https://eips.ethereum.org/EIPS/eip-721
189  */
190 interface IERC721Metadata is IERC721 {
191     /**
192      * @dev Returns the token collection name.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the token collection symbol.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
203      */
204     function tokenURI(uint256 tokenId) external view returns (string memory);
205 }
206 
207 /**
208  * @dev Collection of functions related to the address type
209  */
210 library Address {
211     /**
212      * @dev Returns true if `account` is a contract.
213      *
214      * [IMPORTANT]
215      * ====
216      * It is unsafe to assume that an address for which this function returns
217      * false is an externally-owned account (EOA) and not a contract.
218      *
219      * Among others, `isContract` will return false for the following
220      * types of addresses:
221      *
222      *  - an externally-owned account
223      *  - a contract in construction
224      *  - an address where a contract will be created
225      *  - an address where a contract lived, but was destroyed
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies on extcodesize, which returns 0 for contracts in
230         // construction, since the code is only stored at the end of the
231         // constructor execution.
232 
233         uint256 size;
234         assembly {
235             size := extcodesize(account)
236         }
237         return size > 0;
238     }
239 
240     /**
241      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
242      * `recipient`, forwarding all available gas and reverting on errors.
243      *
244      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
245      * of certain opcodes, possibly making contracts go over the 2300 gas limit
246      * imposed by `transfer`, making them unable to receive funds via
247      * `transfer`. {sendValue} removes this limitation.
248      *
249      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
250      *
251      * IMPORTANT: because control is transferred to `recipient`, care must be
252      * taken to not create reentrancy vulnerabilities. Consider using
253      * {ReentrancyGuard} or the
254      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         (bool success, ) = recipient.call{value: amount}("");
260         require(success, "Address: unable to send value, recipient may have reverted");
261     }
262 
263     /**
264      * @dev Performs a Solidity function call using a low level `call`. A
265      * plain `call` is an unsafe replacement for a function call: use this
266      * function instead.
267      *
268      * If `target` reverts with a revert reason, it is bubbled up by this
269      * function (like regular Solidity function calls).
270      *
271      * Returns the raw returned data. To convert to the expected return value,
272      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
273      *
274      * Requirements:
275      *
276      * - `target` must be a contract.
277      * - calling `target` with `data` must not revert.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionCall(target, data, "Address: low-level call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
287      * `errorMessage` as a fallback revert reason when `target` reverts.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, 0, errorMessage);
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301      * but also transferring `value` wei to `target`.
302      *
303      * Requirements:
304      *
305      * - the calling contract must have an ETH balance of at least `value`.
306      * - the called Solidity function must be `payable`.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value
314     ) internal returns (bytes memory) {
315         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
320      * with `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         require(address(this).balance >= value, "Address: insufficient balance for call");
331         require(isContract(target), "Address: call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.call{value: value}(data);
334         return _verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
344         return functionStaticCall(target, data, "Address: low-level static call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal view returns (bytes memory) {
358         require(isContract(target), "Address: static call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.staticcall(data);
361         return _verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(isContract(target), "Address: delegate call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.delegatecall(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     function _verifyCallResult(
392         bool success,
393         bytes memory returndata,
394         string memory errorMessage
395     ) private pure returns (bytes memory) {
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 /*
415  * @dev Provides information about the current execution context, including the
416  * sender of the transaction and its data. While these are generally available
417  * via msg.sender and msg.data, they should not be accessed in such a direct
418  * manner, since when dealing with meta-transactions the account sending and
419  * paying for execution may not be the actual sender (as far as an application
420  * is concerned).
421  *
422  * This contract is only required for intermediate, library-like contracts.
423  */
424 abstract contract Context {
425     function _msgSender() internal view virtual returns (address) {
426         return msg.sender;
427     }
428 
429     function _msgData() internal view virtual returns (bytes calldata) {
430         return msg.data;
431     }
432 }
433 
434 /**
435  * @dev String operations.
436  */
437 library Strings {
438     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
439 
440     /**
441      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
442      */
443     function toString(uint256 value) internal pure returns (string memory) {
444         // Inspired by OraclizeAPI's implementation - MIT licence
445         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
446 
447         if (value == 0) {
448             return "0";
449         }
450         uint256 temp = value;
451         uint256 digits;
452         while (temp != 0) {
453             digits++;
454             temp /= 10;
455         }
456         bytes memory buffer = new bytes(digits);
457         while (value != 0) {
458             digits -= 1;
459             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
460             value /= 10;
461         }
462         return string(buffer);
463     }
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
467      */
468     function toHexString(uint256 value) internal pure returns (string memory) {
469         if (value == 0) {
470             return "0x00";
471         }
472         uint256 temp = value;
473         uint256 length = 0;
474         while (temp != 0) {
475             length++;
476             temp >>= 8;
477         }
478         return toHexString(value, length);
479     }
480 
481     /**
482      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
483      */
484     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
485         bytes memory buffer = new bytes(2 * length + 2);
486         buffer[0] = "0";
487         buffer[1] = "x";
488         for (uint256 i = 2 * length + 1; i > 1; --i) {
489             buffer[i] = _HEX_SYMBOLS[value & 0xf];
490             value >>= 4;
491         }
492         require(value == 0, "Strings: hex length insufficient");
493         return string(buffer);
494     }
495 }
496 
497 /**
498  * @dev Implementation of the {IERC165} interface.
499  *
500  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
501  * for the additional interface id that will be supported. For example:
502  *
503  * ```solidity
504  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
505  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
506  * }
507  * ```
508  *
509  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
510  */
511 abstract contract ERC165 is IERC165 {
512     /**
513      * @dev See {IERC165-supportsInterface}.
514      */
515     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
516         return interfaceId == type(IERC165).interfaceId;
517     }
518 }
519 
520 /**
521  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
522  * the Metadata extension, but not including the Enumerable extension, which is available separately as
523  * {ERC721Enumerable}.
524  */
525 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
526     using Address for address;
527     using Strings for uint256;
528 
529     // Token name
530     string private _name;
531 
532     // Token symbol
533     string private _symbol;
534 
535     // Mapping from token ID to owner address
536     mapping(uint256 => address) private _owners;
537 
538     // Mapping owner address to token count
539     mapping(address => uint256) private _balances;
540 
541     // Mapping from token ID to approved address
542     mapping(uint256 => address) private _tokenApprovals;
543 
544     // Mapping from owner to operator approvals
545     mapping(address => mapping(address => bool)) private _operatorApprovals;
546 
547     /**
548      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
549      */
550     constructor(string memory name_, string memory symbol_) {
551         _name = name_;
552         _symbol = symbol_;
553     }
554 
555     /**
556      * @dev See {IERC165-supportsInterface}.
557      */
558     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
559         return
560             interfaceId == type(IERC721).interfaceId ||
561             interfaceId == type(IERC721Metadata).interfaceId ||
562             super.supportsInterface(interfaceId);
563     }
564 
565     /**
566      * @dev See {IERC721-balanceOf}.
567      */
568     function balanceOf(address owner) public view virtual override returns (uint256) {
569         require(owner != address(0), "ERC721: balance query for the zero address");
570         return _balances[owner];
571     }
572 
573     /**
574      * @dev See {IERC721-ownerOf}.
575      */
576     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
577         address owner = _owners[tokenId];
578         require(owner != address(0), "ERC721: owner query for nonexistent token");
579         return owner;
580     }
581 
582     /**
583      * @dev See {IERC721Metadata-name}.
584      */
585     function name() public view virtual override returns (string memory) {
586         return _name;
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-symbol}.
591      */
592     function symbol() public view virtual override returns (string memory) {
593         return _symbol;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-tokenURI}.
598      */
599     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
600         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
601 
602         string memory baseURI = _baseURI();
603         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
604     }
605 
606     /**
607      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
608      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
609      * by default, can be overriden in child contracts.
610      */
611     function _baseURI() internal view virtual returns (string memory) {
612         return "";
613     }
614 
615     /**
616      * @dev See {IERC721-approve}.
617      */
618     function approve(address to, uint256 tokenId) public virtual override {
619         address owner = ERC721.ownerOf(tokenId);
620         require(to != owner, "ERC721: approval to current owner");
621 
622         require(
623             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
624             "ERC721: approve caller is not owner nor approved for all"
625         );
626 
627         _approve(to, tokenId);
628     }
629 
630     /**
631      * @dev See {IERC721-getApproved}.
632      */
633     function getApproved(uint256 tokenId) public view virtual override returns (address) {
634         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
635 
636         return _tokenApprovals[tokenId];
637     }
638 
639     /**
640      * @dev See {IERC721-setApprovalForAll}.
641      */
642     function setApprovalForAll(address operator, bool approved) public virtual override {
643         require(operator != _msgSender(), "ERC721: approve to caller");
644 
645         _operatorApprovals[_msgSender()][operator] = approved;
646         emit ApprovalForAll(_msgSender(), operator, approved);
647     }
648 
649     /**
650      * @dev See {IERC721-isApprovedForAll}.
651      */
652     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
653         return _operatorApprovals[owner][operator];
654     }
655 
656     /**
657      * @dev See {IERC721-transferFrom}.
658      */
659     function transferFrom(
660         address from,
661         address to,
662         uint256 tokenId
663     ) public virtual override {
664         //solhint-disable-next-line max-line-length
665         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
666 
667         _transfer(from, to, tokenId);
668     }
669 
670     /**
671      * @dev See {IERC721-safeTransferFrom}.
672      */
673     function safeTransferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) public virtual override {
678         safeTransferFrom(from, to, tokenId, "");
679     }
680 
681     /**
682      * @dev See {IERC721-safeTransferFrom}.
683      */
684     function safeTransferFrom(
685         address from,
686         address to,
687         uint256 tokenId,
688         bytes memory _data
689     ) public virtual override {
690         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
691         _safeTransfer(from, to, tokenId, _data);
692     }
693 
694     /**
695      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
696      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
697      *
698      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
699      *
700      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
701      * implement alternative mechanisms to perform token transfer, such as signature-based.
702      *
703      * Requirements:
704      *
705      * - `from` cannot be the zero address.
706      * - `to` cannot be the zero address.
707      * - `tokenId` token must exist and be owned by `from`.
708      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
709      *
710      * Emits a {Transfer} event.
711      */
712     function _safeTransfer(
713         address from,
714         address to,
715         uint256 tokenId,
716         bytes memory _data
717     ) internal virtual {
718         _transfer(from, to, tokenId);
719         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
720     }
721 
722     /**
723      * @dev Returns whether `tokenId` exists.
724      *
725      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
726      *
727      * Tokens start existing when they are minted (`_mint`),
728      * and stop existing when they are burned (`_burn`).
729      */
730     function _exists(uint256 tokenId) internal view virtual returns (bool) {
731         return _owners[tokenId] != address(0);
732     }
733 
734     /**
735      * @dev Returns whether `spender` is allowed to manage `tokenId`.
736      *
737      * Requirements:
738      *
739      * - `tokenId` must exist.
740      */
741     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
742         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
743         address owner = ERC721.ownerOf(tokenId);
744         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
745     }
746 
747     /**
748      * @dev Safely mints `tokenId` and transfers it to `to`.
749      *
750      * Requirements:
751      *
752      * - `tokenId` must not exist.
753      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
754      *
755      * Emits a {Transfer} event.
756      */
757     function _safeMint(address to, uint256 tokenId) internal virtual {
758         _safeMint(to, tokenId, "");
759     }
760 
761     /**
762      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
763      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
764      */
765     function _safeMint(
766         address to,
767         uint256 tokenId,
768         bytes memory _data
769     ) internal virtual {
770         _mint(to, tokenId);
771         require(
772             _checkOnERC721Received(address(0), to, tokenId, _data),
773             "ERC721: transfer to non ERC721Receiver implementer"
774         );
775     }
776 
777     /**
778      * @dev Mints `tokenId` and transfers it to `to`.
779      *
780      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
781      *
782      * Requirements:
783      *
784      * - `tokenId` must not exist.
785      * - `to` cannot be the zero address.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _mint(address to, uint256 tokenId) internal virtual {
790         require(to != address(0), "ERC721: mint to the zero address");
791         require(!_exists(tokenId), "ERC721: token already minted");
792 
793         _beforeTokenTransfer(address(0), to, tokenId);
794 
795         _balances[to] += 1;
796         _owners[tokenId] = to;
797 
798         emit Transfer(address(0), to, tokenId);
799     }
800 
801     /**
802      * @dev Destroys `tokenId`.
803      * The approval is cleared when the token is burned.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _burn(uint256 tokenId) internal virtual {
812         address owner = ERC721.ownerOf(tokenId);
813 
814         _beforeTokenTransfer(owner, address(0), tokenId);
815 
816         // Clear approvals
817         _approve(address(0), tokenId);
818 
819         _balances[owner] -= 1;
820         delete _owners[tokenId];
821 
822         emit Transfer(owner, address(0), tokenId);
823     }
824 
825     /**
826      * @dev Transfers `tokenId` from `from` to `to`.
827      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
828      *
829      * Requirements:
830      *
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must be owned by `from`.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _transfer(
837         address from,
838         address to,
839         uint256 tokenId
840     ) internal virtual {
841         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
842         require(to != address(0), "ERC721: transfer to the zero address");
843 
844         _beforeTokenTransfer(from, to, tokenId);
845 
846         // Clear approvals from the previous owner
847         _approve(address(0), tokenId);
848 
849         _balances[from] -= 1;
850         _balances[to] += 1;
851         _owners[tokenId] = to;
852 
853         emit Transfer(from, to, tokenId);
854     }
855 
856     /**
857      * @dev Approve `to` to operate on `tokenId`
858      *
859      * Emits a {Approval} event.
860      */
861     function _approve(address to, uint256 tokenId) internal virtual {
862         _tokenApprovals[tokenId] = to;
863         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
864     }
865 
866     /**
867      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
868      * The call is not executed if the target address is not a contract.
869      *
870      * @param from address representing the previous owner of the given token ID
871      * @param to target address that will receive the tokens
872      * @param tokenId uint256 ID of the token to be transferred
873      * @param _data bytes optional data to send along with the call
874      * @return bool whether the call correctly returned the expected magic value
875      */
876     function _checkOnERC721Received(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) private returns (bool) {
882         if (to.isContract()) {
883             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
884                 return retval == IERC721Receiver(to).onERC721Received.selector;
885             } catch (bytes memory reason) {
886                 if (reason.length == 0) {
887                     revert("ERC721: transfer to non ERC721Receiver implementer");
888                 } else {
889                     assembly {
890                         revert(add(32, reason), mload(reason))
891                     }
892                 }
893             }
894         } else {
895             return true;
896         }
897     }
898 
899     /**
900      * @dev Hook that is called before any token transfer. This includes minting
901      * and burning.
902      *
903      * Calling conditions:
904      *
905      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
906      * transferred to `to`.
907      * - When `from` is zero, `tokenId` will be minted for `to`.
908      * - When `to` is zero, ``from``'s `tokenId` will be burned.
909      * - `from` and `to` are never both zero.
910      *
911      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
912      */
913     function _beforeTokenTransfer(
914         address from,
915         address to,
916         uint256 tokenId
917     ) internal virtual {}
918 }
919 
920 /**
921  * @dev Contract module which allows children to implement an emergency stop
922  * mechanism that can be triggered by an authorized account.
923  *
924  * This module is used through inheritance. It will make available the
925  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
926  * the functions of your contract. Note that they will not be pausable by
927  * simply including this module, only once the modifiers are put in place.
928  */
929 abstract contract Pausable is Context {
930     /**
931      * @dev Emitted when the pause is triggered by `account`.
932      */
933     event Paused(address account);
934 
935     /**
936      * @dev Emitted when the pause is lifted by `account`.
937      */
938     event Unpaused(address account);
939 
940     bool private _paused;
941 
942     /**
943      * @dev Initializes the contract in unpaused state.
944      */
945     constructor() {
946         _paused = false;
947     }
948 
949     /**
950      * @dev Returns true if the contract is paused, and false otherwise.
951      */
952     function paused() public view virtual returns (bool) {
953         return _paused;
954     }
955 
956     /**
957      * @dev Modifier to make a function callable only when the contract is not paused.
958      *
959      * Requirements:
960      *
961      * - The contract must not be paused.
962      */
963     modifier whenNotPaused() {
964         require(!paused(), "Pausable: paused");
965         _;
966     }
967 
968     /**
969      * @dev Modifier to make a function callable only when the contract is paused.
970      *
971      * Requirements:
972      *
973      * - The contract must be paused.
974      */
975     modifier whenPaused() {
976         require(paused(), "Pausable: not paused");
977         _;
978     }
979 
980     /**
981      * @dev Triggers stopped state.
982      *
983      * Requirements:
984      *
985      * - The contract must not be paused.
986      */
987     function _pause() internal virtual whenNotPaused {
988         _paused = true;
989         emit Paused(_msgSender());
990     }
991 
992     /**
993      * @dev Returns to normal state.
994      *
995      * Requirements:
996      *
997      * - The contract must be paused.
998      */
999     function _unpause() internal virtual whenPaused {
1000         _paused = false;
1001         emit Unpaused(_msgSender());
1002     }
1003 }
1004 
1005 /**
1006  * @dev ERC721 token with pausable token transfers, minting and burning.
1007  *
1008  * Useful for scenarios such as preventing trades until the end of an evaluation
1009  * period, or having an emergency switch for freezing all token transfers in the
1010  * event of a large bug.
1011  */
1012 abstract contract ERC721Pausable is ERC721, Pausable {
1013     /**
1014      * @dev See {ERC721-_beforeTokenTransfer}.
1015      *
1016      * Requirements:
1017      *
1018      * - the contract must not be paused.
1019      */
1020     function _beforeTokenTransfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) internal virtual override {
1025         super._beforeTokenTransfer(from, to, tokenId);
1026 
1027         require(!paused(), "ERC721Pausable: token transfer while paused");
1028     }
1029 }
1030 
1031 /**
1032  * @title Counters
1033  * @author Matt Condon (@shrugs)
1034  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1035  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1036  *
1037  * Include with `using Counters for Counters.Counter;`
1038  */
1039 library Counters {
1040     struct Counter {
1041         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1042         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1043         // this feature: see https://github.com/ethereum/solidity/issues/4637
1044         uint256 _value; // default: 0
1045     }
1046 
1047     function current(Counter storage counter) internal view returns (uint256) {
1048         return counter._value;
1049     }
1050 
1051     function increment(Counter storage counter) internal {
1052         unchecked {
1053             counter._value += 1;
1054         }
1055     }
1056 
1057     function decrement(Counter storage counter) internal {
1058         uint256 value = counter._value;
1059         require(value > 0, "Counter: decrement overflow");
1060         unchecked {
1061             counter._value = value - 1;
1062         }
1063     }
1064 
1065     function reset(Counter storage counter) internal {
1066         counter._value = 0;
1067     }
1068 }
1069 
1070 /**
1071  * @dev Contract module which provides a basic access control mechanism, where
1072  * there is an account (an owner) that can be granted exclusive access to
1073  * specific functions.
1074  *
1075  * By default, the owner account will be the one that deploys the contract. This
1076  * can later be changed with {transferOwnership}.
1077  *
1078  * This module is used through inheritance. It will make available the modifier
1079  * `onlyOwner`, which can be applied to your functions to restrict their use to
1080  * the owner.
1081  */
1082 abstract contract Ownable is Context {
1083     address private _owner;
1084 
1085     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1086 
1087     /**
1088      * @dev Initializes the contract setting the deployer as the initial owner.
1089      */
1090     constructor() {
1091         _setOwner(_msgSender());
1092     }
1093 
1094     /**
1095      * @dev Returns the address of the current owner.
1096      */
1097     function owner() public view virtual returns (address) {
1098         return _owner;
1099     }
1100 
1101     /**
1102      * @dev Throws if called by any account other than the owner.
1103      */
1104     modifier onlyOwner() {
1105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1106         _;
1107     }
1108 
1109     /**
1110      * @dev Leaves the contract without owner. It will not be possible to call
1111      * `onlyOwner` functions anymore. Can only be called by the current owner.
1112      *
1113      * NOTE: Renouncing ownership will leave the contract without an owner,
1114      * thereby removing any functionality that is only available to the owner.
1115      */
1116     function renounceOwnership() public virtual onlyOwner {
1117         _setOwner(address(0));
1118     }
1119 
1120     /**
1121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1122      * Can only be called by the current owner.
1123      */
1124     function transferOwnership(address newOwner) public virtual onlyOwner {
1125         require(newOwner != address(0), "Ownable: new owner is the zero address");
1126         _setOwner(newOwner);
1127     }
1128 
1129     function _setOwner(address newOwner) private {
1130         address oldOwner = _owner;
1131         _owner = newOwner;
1132         emit OwnershipTransferred(oldOwner, newOwner);
1133     }
1134 }
1135 
1136 
1137 
1138 /* 
1139                                                                          
1140                                                         dddddddd                 
1141                  kkkkkkkk             iiii              d::::::d                 
1142                  k::::::k            i::::i             d::::::d                 
1143                  k::::::k             iiii              d::::::d                 
1144                  k::::::k                               d:::::d                  
1145     ssssssssss    k:::::k    kkkkkkkiiiiiii     ddddddddd:::::d     ssssssssss   
1146   ss::::::::::s   k:::::k   k:::::k i:::::i   dd::::::::::::::d   ss::::::::::s  
1147 ss:::::::::::::s  k:::::k  k:::::k   i::::i  d::::::::::::::::d ss:::::::::::::s 
1148 s::::::ssss:::::s k:::::k k:::::k    i::::i d:::::::ddddd:::::d s::::::ssss:::::s
1149  s:::::s  ssssss  k::::::k:::::k     i::::i d::::::d    d:::::d  s:::::s  ssssss 
1150    s::::::s       k:::::::::::k      i::::i d:::::d     d:::::d    s::::::s      
1151       s::::::s    k:::::::::::k      i::::i d:::::d     d:::::d       s::::::s   
1152 ssssss   s:::::s  k::::::k:::::k     i::::i d:::::d     d:::::d ssssss   s:::::s 
1153 s:::::ssss::::::sk::::::k k:::::k   i::::::id::::::ddddd::::::dds:::::ssss::::::s
1154 s::::::::::::::s k::::::k  k:::::k  i::::::i d:::::::::::::::::ds::::::::::::::s 
1155  s:::::::::::ss  k::::::k   k:::::k i::::::i  d:::::::::ddd::::d s:::::::::::ss  
1156   sssssssssss    kkkkkkkk    kkkkkkkiiiiiiii   ddddddddd   ddddd  sssssssssss    
1157 
1158 
1159 Website: https://skids.io
1160 Discord: https://discord.gg/skidsNFT 
1161 Twitter: https://twitter.com/SkidsNFT
1162 
1163 */
1164 
1165 contract Skids is ERC721Pausable, Ownable {
1166     using Counters for Counters.Counter;
1167     Counters.Counter private _tokenIds;
1168 
1169     address private _markettingAddress = 0xd4BD555aE9c16b5E7cEC067D7C8C5988b8d8C965;
1170 
1171     uint256 private constant _maxTokens = 8888;
1172     uint256 private constant _maxMint = 9;
1173     uint256 private constant _maxPresaleMint = 3;
1174                         
1175     uint256 public constant _price = 77700000000000000; // 0.0777 ETH
1176 
1177     mapping (address => bool) private _whitelist;
1178     mapping (address => uint256) private _presaleMints;
1179     mapping (address => uint256) private _saleMints;
1180 
1181     bool private _presaleActive = false;
1182     bool private _saleActive = false;
1183        
1184     bool private _69minted = false; 
1185     bool private _1337minted = false; 
1186     bool private _420minted = false; 
1187 
1188 
1189     string public _prefixURI;
1190 
1191     constructor() public ERC721("Skids", "SKID") {
1192         _pause();
1193     }
1194 
1195 
1196     /* MINTING FOR CHARITABLE AUCTION */
1197     
1198     /* See FAQ in discord for which charities each of these sales will go to.*/
1199     function _mint69() public onlyOwner {
1200         require(_69minted == false);
1201         _69minted = true; 
1202         _safeMint(_markettingAddress, 69);
1203     }   
1204 
1205     function _mint1337() public onlyOwner {
1206         require(_1337minted == false);
1207         _1337minted = true; 
1208         _safeMint(_markettingAddress, 1337);
1209     }
1210 
1211     function _mint420() public onlyOwner {
1212         require(_420minted == false);
1213         _420minted = true; 
1214         _safeMint(_markettingAddress, 420);
1215     }
1216     /* */
1217 
1218     function _baseURI() internal view override returns (string memory) {
1219         return _prefixURI;
1220     }
1221 
1222     function setBaseURI(string memory _uri) public onlyOwner {
1223         _prefixURI = _uri;
1224     }
1225 
1226     function totalSupply() public view returns (uint256) {
1227         return _tokenIds.current();
1228     }
1229 
1230     function isWhitelisted(address addr) public view returns (bool) {
1231         return _whitelist[addr];
1232     }
1233 
1234     function preSaleActive() public view returns (bool) {
1235         return _presaleActive; 
1236     }
1237 
1238     function saleActive() public view returns (bool) {
1239         return _saleActive; 
1240     }
1241 
1242     function presaleMinted(address addr) public view returns (uint256) {
1243         return _presaleMints[addr]; 
1244     }
1245 
1246     function saleMinted(address addr) public view returns (uint256) {
1247         return _saleMints[addr]; 
1248     }
1249 
1250     function addToWhitelist(address[] memory addrs) public onlyOwner {
1251         for (uint256 i = 0; i < addrs.length; i++) {
1252             _whitelist[addrs[i]] = true;
1253             _presaleMints[addrs[i]] = 0;
1254         }
1255     }
1256 
1257     function presaleMintItems(uint256 amount) public payable {
1258         require(amount <= _maxMint);
1259         require(amount <= _maxPresaleMint);
1260         require(isWhitelisted(msg.sender));
1261         require(msg.value >= amount * _price);
1262         require(_presaleMints[msg.sender] + amount <= _maxPresaleMint);
1263         require(_presaleActive);
1264 
1265         uint256 totalMinted = _tokenIds.current();
1266         require(totalMinted + amount <= _maxTokens);
1267 
1268         for (uint256 i = 0; i < amount; i++) {
1269             _presaleMints[msg.sender] += 1;
1270             _mintItem(msg.sender);
1271         }
1272     }
1273 
1274     function mintItems(uint256 amount) public payable {
1275         require(amount <= _maxMint);
1276         require(_saleActive);
1277         require(amount <= _maxMint); 
1278         uint256 totalMinted = _tokenIds.current();
1279         require(totalMinted + amount <= _maxTokens);
1280         require(_saleMints[msg.sender] + amount <= _maxMint); 
1281 
1282         require(msg.value >= amount * _price);
1283 
1284         for (uint256 i = 0; i < amount; i++) {
1285             _saleMints[msg.sender] += 1; 
1286             _mintItem(msg.sender);
1287         }
1288     }
1289 
1290     function _mintItem(address to) internal returns (uint256) {
1291         _tokenIds.increment();
1292         uint256 id = _tokenIds.current();
1293         if(id == 69) {
1294             _tokenIds.increment(); 
1295             id = _tokenIds.current(); 
1296         }
1297         if(id == 420) {
1298             _tokenIds.increment(); 
1299             id = _tokenIds.current(); 
1300         }
1301         if(id == 1337) {
1302             _tokenIds.increment(); 
1303             id = _tokenIds.current(); 
1304         }
1305         _safeMint(to, id);
1306         return id;
1307     }
1308 
1309     function togglePreSale() public onlyOwner {
1310         _presaleActive = !_presaleActive;
1311     }
1312 
1313     function toggleSale() public onlyOwner {
1314         _saleActive = !_saleActive;
1315     }
1316 
1317     function toggleTransferPause() public onlyOwner {
1318         paused() ? _unpause() : _pause();
1319     }
1320 
1321     function reserve(uint256 quantity) public onlyOwner {
1322         for(uint i = _tokenIds.current(); i < quantity; i++) {
1323             if (i < _maxTokens) {
1324                 _tokenIds.increment();
1325                 _safeMint(msg.sender, i + 1);
1326             }
1327         }
1328     }
1329 
1330     function withdraw() external onlyOwner {
1331         require(address(this).balance > 0); 
1332         payable(_markettingAddress).transfer(address(this).balance * 5 / 100);
1333         payable(msg.sender).transfer(address(this).balance);
1334     }
1335     
1336 
1337     // Allows minting(transfer from 0 address), but not transferring while paused() except from owner
1338     function _beforeTokenTransfer(
1339         address from,
1340         address to,
1341         uint256 tokenId
1342     ) internal virtual override {
1343         if (!(from == address(0)) && !(from == owner())) {
1344             require(!paused(), "ERC721Pausable: token transfer while paused");
1345         }
1346     }
1347 }