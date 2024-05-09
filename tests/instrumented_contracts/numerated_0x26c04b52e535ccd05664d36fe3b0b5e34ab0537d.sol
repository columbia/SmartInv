1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
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
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
44      */
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of tokens in ``owner``'s account.
49      */
50     function balanceOf(address owner) external view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the `tokenId` token.
54      *
55      * Requirements:
56      *
57      * - `tokenId` must exist.
58      */
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60 
61     /**
62      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
63      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId
79     ) external;
80 
81     /**
82      * @dev Transfers `tokenId` token from `from` to `to`.
83      *
84      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
103      * The approval is cleared when the token is transferred.
104      *
105      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
106      *
107      * Requirements:
108      *
109      * - The caller must own the token or be an approved operator.
110      * - `tokenId` must exist.
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Returns the account approved for `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function getApproved(uint256 tokenId) external view returns (address operator);
124 
125     /**
126      * @dev Approve or remove `operator` as an operator for the caller.
127      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
128      *
129      * Requirements:
130      *
131      * - The `operator` cannot be the caller.
132      *
133      * Emits an {ApprovalForAll} event.
134      */
135     function setApprovalForAll(address operator, bool _approved) external;
136 
137     /**
138      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
139      *
140      * See {setApprovalForAll}
141      */
142     function isApprovedForAll(address owner, address operator) external view returns (bool);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must exist and be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154      *
155      * Emits a {Transfer} event.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes calldata data
162     ) external;
163 }
164 
165 /**
166  * @title ERC721 token receiver interface
167  * @dev Interface for any contract that wants to support safeTransfers
168  * from ERC721 asset contracts.
169  */
170 interface IERC721Receiver {
171     /**
172      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
173      * by `operator` from `from`, this function is called.
174      *
175      * It must return its Solidity selector to confirm the token transfer.
176      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
177      *
178      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
179      */
180     function onERC721Received(
181         address operator,
182         address from,
183         uint256 tokenId,
184         bytes calldata data
185     ) external returns (bytes4);
186 }
187 
188 /**
189  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
190  * @dev See https://eips.ethereum.org/EIPS/eip-721
191  */
192 interface IERC721Metadata is IERC721 {
193     /**
194      * @dev Returns the token collection name.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the token collection symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
205      */
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 /**
210  * @dev Collection of functions related to the address type
211  */
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies on extcodesize, which returns 0 for contracts in
232         // construction, since the code is only stored at the end of the
233         // constructor execution.
234 
235         uint256 size;
236         assembly {
237             size := extcodesize(account)
238         }
239         return size > 0;
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      */
258     function sendValue(address payable recipient, uint256 amount) internal {
259         require(address(this).balance >= amount, "Address: insufficient balance");
260 
261         (bool success, ) = recipient.call{value: amount}("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 
265     /**
266      * @dev Performs a Solidity function call using a low level `call`. A
267      * plain `call` is an unsafe replacement for a function call: use this
268      * function instead.
269      *
270      * If `target` reverts with a revert reason, it is bubbled up by this
271      * function (like regular Solidity function calls).
272      *
273      * Returns the raw returned data. To convert to the expected return value,
274      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
275      *
276      * Requirements:
277      *
278      * - `target` must be a contract.
279      * - calling `target` with `data` must not revert.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionCall(target, data, "Address: low-level call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
289      * `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, 0, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but also transferring `value` wei to `target`.
304      *
305      * Requirements:
306      *
307      * - the calling contract must have an ETH balance of at least `value`.
308      * - the called Solidity function must be `payable`.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         require(isContract(target), "Address: call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.call{value: value}(data);
336         return _verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
346         return functionStaticCall(target, data, "Address: low-level static call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal view returns (bytes memory) {
360         require(isContract(target), "Address: static call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.staticcall(data);
363         return _verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return _verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     function _verifyCallResult(
394         bool success,
395         bytes memory returndata,
396         string memory errorMessage
397     ) private pure returns (bytes memory) {
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 /*
417  * @dev Provides information about the current execution context, including the
418  * sender of the transaction and its data. While these are generally available
419  * via msg.sender and msg.data, they should not be accessed in such a direct
420  * manner, since when dealing with meta-transactions the account sending and
421  * paying for execution may not be the actual sender (as far as an application
422  * is concerned).
423  *
424  * This contract is only required for intermediate, library-like contracts.
425  */
426 abstract contract Context {
427     function _msgSender() internal view virtual returns (address) {
428         return msg.sender;
429     }
430 
431     function _msgData() internal view virtual returns (bytes calldata) {
432         return msg.data;
433     }
434 }
435 
436 /**
437  * @dev String operations.
438  */
439 library Strings {
440     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
441 
442     /**
443      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
444      */
445     function toString(uint256 value) internal pure returns (string memory) {
446         // Inspired by OraclizeAPI's implementation - MIT licence
447         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
448 
449         if (value == 0) {
450             return "0";
451         }
452         uint256 temp = value;
453         uint256 digits;
454         while (temp != 0) {
455             digits++;
456             temp /= 10;
457         }
458         bytes memory buffer = new bytes(digits);
459         while (value != 0) {
460             digits -= 1;
461             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
462             value /= 10;
463         }
464         return string(buffer);
465     }
466  
467     /**
468      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
469      */
470     function toHexString(uint256 value) internal pure returns (string memory) {
471         if (value == 0) {
472             return "0x00";
473         }
474         uint256 temp = value;
475         uint256 length = 0;
476         while (temp != 0) {
477             length++;
478             temp >>= 8;
479         }
480         return toHexString(value, length);
481     }
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
485      */
486     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
487         bytes memory buffer = new bytes(2 * length + 2);
488         buffer[0] = "0";
489         buffer[1] = "x";
490         for (uint256 i = 2 * length + 1; i > 1; --i) {
491             buffer[i] = _HEX_SYMBOLS[value & 0xf];
492             value >>= 4;
493         }
494         require(value == 0, "Strings: hex length insufficient");
495         return string(buffer);
496     }
497 }
498 
499 /**
500  * @dev Implementation of the {IERC165} interface.
501  *
502  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
503  * for the additional interface id that will be supported. For example:
504  *
505  * ```solidity
506  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
508  * }
509  * ```
510  *
511  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
512  */
513 abstract contract ERC165 is IERC165 {
514     /**
515      * @dev See {IERC165-supportsInterface}.
516      */
517     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518         return interfaceId == type(IERC165).interfaceId;
519     }
520 }
521 
522 /**
523  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
524  * the Metadata extension, but not including the Enumerable extension, which is available separately as
525  * {ERC721Enumerable}.
526  */
527 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
528     using Address for address;
529     using Strings for uint256;
530 
531     // Token name
532     string private _name;
533 
534     // Token symbol
535     string private _symbol;
536 
537     // Mapping from token ID to owner address
538     mapping(uint256 => address) private _owners;
539 
540     // Mapping owner address to token count
541     mapping(address => uint256) private _balances;
542 
543     // Mapping from token ID to approved address
544     mapping(uint256 => address) private _tokenApprovals;
545 
546     // Mapping from owner to operator approvals
547     mapping(address => mapping(address => bool)) private _operatorApprovals;
548 
549     /**
550      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
551      */
552     constructor(string memory name_, string memory symbol_) {
553         _name = name_;
554         _symbol = symbol_;
555     }
556 
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
561         return
562             interfaceId == type(IERC721).interfaceId ||
563             interfaceId == type(IERC721Metadata).interfaceId ||
564             super.supportsInterface(interfaceId);
565     }
566 
567     /**
568      * @dev See {IERC721-balanceOf}.
569      */
570     function balanceOf(address owner) public view virtual override returns (uint256) {
571         require(owner != address(0), "ERC721: balance query for the zero address");
572         return _balances[owner];
573     }
574 
575     /**
576      * @dev See {IERC721-ownerOf}.
577      */
578     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
579         address owner = _owners[tokenId];
580         require(owner != address(0), "ERC721: owner query for nonexistent token");
581         return owner;
582     }
583 
584     /**
585      * @dev See {IERC721Metadata-name}.
586      */
587     function name() public view virtual override returns (string memory) {
588         return _name;
589     }
590 
591     /**
592      * @dev See {IERC721Metadata-symbol}.
593      */
594     function symbol() public view virtual override returns (string memory) {
595         return _symbol;
596     }
597 
598     /**
599      * @dev See {IERC721Metadata-tokenURI}.
600      */
601     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
602         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
603 
604         string memory baseURI = _baseURI();
605         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
606     }
607 
608     /**
609      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
610      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
611      * by default, can be overriden in child contracts.
612      */
613     function _baseURI() internal view virtual returns (string memory) {
614         return "";
615     }
616 
617     /**
618      * @dev See {IERC721-approve}.
619      */
620     function approve(address to, uint256 tokenId) public virtual override {
621         address owner = ERC721.ownerOf(tokenId);
622         require(to != owner, "ERC721: approval to current owner");
623 
624         require(
625             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
626             "ERC721: approve caller is not owner nor approved for all"
627         );
628 
629         _approve(to, tokenId);
630     }
631 
632     /**
633      * @dev See {IERC721-getApproved}.
634      */
635     function getApproved(uint256 tokenId) public view virtual override returns (address) {
636         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
637 
638         return _tokenApprovals[tokenId];
639     }
640 
641     /**
642      * @dev See {IERC721-setApprovalForAll}.
643      */
644     function setApprovalForAll(address operator, bool approved) public virtual override {
645         require(operator != _msgSender(), "ERC721: approve to caller");
646 
647         _operatorApprovals[_msgSender()][operator] = approved;
648         emit ApprovalForAll(_msgSender(), operator, approved);
649     }
650 
651     /**
652      * @dev See {IERC721-isApprovedForAll}.
653      */
654     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
655         return _operatorApprovals[owner][operator];
656     }
657 
658     /**
659      * @dev See {IERC721-transferFrom}.
660      */
661     function transferFrom(
662         address from,
663         address to,
664         uint256 tokenId
665     ) public virtual override {
666         //solhint-disable-next-line max-line-length
667         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
668 
669         _transfer(from, to, tokenId);
670     }
671 
672     /**
673      * @dev See {IERC721-safeTransferFrom}.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) public virtual override {
680         safeTransferFrom(from, to, tokenId, "");
681     }
682 
683     /**
684      * @dev See {IERC721-safeTransferFrom}.
685      */
686     function safeTransferFrom(
687         address from,
688         address to,
689         uint256 tokenId,
690         bytes memory _data
691     ) public virtual override {
692         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
693         _safeTransfer(from, to, tokenId, _data);
694     }
695 
696     /**
697      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
698      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
699      *
700      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
701      *
702      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
703      * implement alternative mechanisms to perform token transfer, such as signature-based.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
711      *
712      * Emits a {Transfer} event.
713      */
714     function _safeTransfer(
715         address from,
716         address to,
717         uint256 tokenId,
718         bytes memory _data
719     ) internal virtual {
720         _transfer(from, to, tokenId);
721         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
722     }
723 
724     /**
725      * @dev Returns whether `tokenId` exists.
726      *
727      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
728      *
729      * Tokens start existing when they are minted (`_mint`),
730      * and stop existing when they are burned (`_burn`).
731      */
732     function _exists(uint256 tokenId) internal view virtual returns (bool) {
733         return _owners[tokenId] != address(0);
734     }
735 
736     /**
737      * @dev Returns whether `spender` is allowed to manage `tokenId`.
738      *
739      * Requirements:
740      *
741      * - `tokenId` must exist.
742      */
743     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
744         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
745         address owner = ERC721.ownerOf(tokenId);
746         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
747     }
748 
749     /**
750      * @dev Safely mints `tokenId` and transfers it to `to`.
751      *
752      * Requirements:
753      *
754      * - `tokenId` must not exist.
755      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _safeMint(address to, uint256 tokenId) internal virtual {
760         _safeMint(to, tokenId, "");
761     }
762 
763     /**
764      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
765      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
766      */
767     function _safeMint(
768         address to,
769         uint256 tokenId,
770         bytes memory _data
771     ) internal virtual {
772         _mint(to, tokenId);
773         require(
774             _checkOnERC721Received(address(0), to, tokenId, _data),
775             "ERC721: transfer to non ERC721Receiver implementer"
776         );
777     }
778 
779     /**
780      * @dev Mints `tokenId` and transfers it to `to`.
781      *
782      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
783      *
784      * Requirements:
785      *
786      * - `tokenId` must not exist.
787      * - `to` cannot be the zero address.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _mint(address to, uint256 tokenId) internal virtual {
792         require(to != address(0), "ERC721: mint to the zero address");
793         require(!_exists(tokenId), "ERC721: token already minted");
794 
795         _beforeTokenTransfer(address(0), to, tokenId);
796 
797         _balances[to] += 1;
798         _owners[tokenId] = to;
799 
800         emit Transfer(address(0), to, tokenId);
801     }
802 
803     /**
804      * @dev Destroys `tokenId`.
805      * The approval is cleared when the token is burned.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _burn(uint256 tokenId) internal virtual {
814         address owner = ERC721.ownerOf(tokenId);
815 
816         _beforeTokenTransfer(owner, address(0), tokenId);
817 
818         // Clear approvals
819         _approve(address(0), tokenId);
820 
821         _balances[owner] -= 1;
822         delete _owners[tokenId];
823 
824         emit Transfer(owner, address(0), tokenId);
825     }
826 
827     /**
828      * @dev Transfers `tokenId` from `from` to `to`.
829      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
830      *
831      * Requirements:
832      *
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must be owned by `from`.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _transfer(
839         address from,
840         address to,
841         uint256 tokenId
842     ) internal virtual {
843         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
844         require(to != address(0), "ERC721: transfer to the zero address");
845 
846         _beforeTokenTransfer(from, to, tokenId);
847 
848         // Clear approvals from the previous owner
849         _approve(address(0), tokenId);
850 
851         _balances[from] -= 1;
852         _balances[to] += 1;
853         _owners[tokenId] = to;
854 
855         emit Transfer(from, to, tokenId);
856     }
857 
858     /**
859      * @dev Approve `to` to operate on `tokenId`
860      *
861      * Emits a {Approval} event.
862      */
863     function _approve(address to, uint256 tokenId) internal virtual {
864         _tokenApprovals[tokenId] = to;
865         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
866     }
867 
868     /**
869      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
870      * The call is not executed if the target address is not a contract.
871      *
872      * @param from address representing the previous owner of the given token ID
873      * @param to target address that will receive the tokens
874      * @param tokenId uint256 ID of the token to be transferred
875      * @param _data bytes optional data to send along with the call
876      * @return bool whether the call correctly returned the expected magic value
877      */
878     function _checkOnERC721Received(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) private returns (bool) {
884         if (to.isContract()) {
885             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
886                 return retval == IERC721Receiver(to).onERC721Received.selector;
887             } catch (bytes memory reason) {
888                 if (reason.length == 0) {
889                     revert("ERC721: transfer to non ERC721Receiver implementer");
890                 } else {
891                     assembly {
892                         revert(add(32, reason), mload(reason))
893                     }
894                 }
895             }
896         } else {
897             return true;
898         }
899     }
900 
901     /**
902      * @dev Hook that is called before any token transfer. This includes minting
903      * and burning.
904      *
905      * Calling conditions:
906      *
907      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
908      * transferred to `to`.
909      * - When `from` is zero, `tokenId` will be minted for `to`.
910      * - When `to` is zero, ``from``'s `tokenId` will be burned.
911      * - `from` and `to` are never both zero.
912      *
913      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
914      */
915     function _beforeTokenTransfer(
916         address from,
917         address to,
918         uint256 tokenId
919     ) internal virtual {}
920 }
921 
922 /**
923  * @dev Contract module which allows children to implement an emergency stop
924  * mechanism that can be triggered by an authorized account.
925  *
926  * This module is used through inheritance. It will make available the
927  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
928  * the functions of your contract. Note that they will not be pausable by
929  * simply including this module, only once the modifiers are put in place.
930  */
931 abstract contract Pausable is Context {
932     /**
933      * @dev Emitted when the pause is triggered by `account`.
934      */
935     event Paused(address account);
936 
937     /**
938      * @dev Emitted when the pause is lifted by `account`.
939      */
940     event Unpaused(address account);
941 
942     bool private _paused;
943 
944     /**
945      * @dev Initializes the contract in unpaused state.
946      */
947     constructor() {
948         _paused = false;
949     }
950 
951     /**
952      * @dev Returns true if the contract is paused, and false otherwise.
953      */
954     function paused() public view virtual returns (bool) {
955         return _paused;
956     }
957 
958     /**
959      * @dev Modifier to make a function callable only when the contract is not paused.
960      *
961      * Requirements:
962      *
963      * - The contract must not be paused.
964      */
965     modifier whenNotPaused() {
966         require(!paused(), "Pausable: paused");
967         _;
968     }
969 
970     /**
971      * @dev Modifier to make a function callable only when the contract is paused.
972      *
973      * Requirements:
974      *
975      * - The contract must be paused.
976      */
977     modifier whenPaused() {
978         require(paused(), "Pausable: not paused");
979         _;
980     }
981 
982     /**
983      * @dev Triggers stopped state.
984      *
985      * Requirements:
986      *
987      * - The contract must not be paused.
988      */
989     function _pause() internal virtual whenNotPaused {
990         _paused = true;
991         emit Paused(_msgSender());
992     }
993 
994     /**
995      * @dev Returns to normal state.
996      *
997      * Requirements:
998      *
999      * - The contract must be paused.
1000      */
1001     function _unpause() internal virtual whenPaused {
1002         _paused = false;
1003         emit Unpaused(_msgSender());
1004     }
1005 }
1006 
1007 
1008 /**
1009  * @dev ERC721 token with pausable token transfers, minting and burning.
1010  *
1011  * Useful for scenarios such as preventing trades until the end of an evaluation
1012  * period, or having an emergency switch for freezing all token transfers in the
1013  * event of a large bug.
1014  */
1015 abstract contract ERC721Pausable is ERC721, Pausable {
1016     /**
1017      * @dev See {ERC721-_beforeTokenTransfer}.
1018      *
1019      * Requirements:
1020      *
1021      * - the contract must not be paused.
1022      */
1023     function _beforeTokenTransfer(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) internal virtual override {
1028         super._beforeTokenTransfer(from, to, tokenId);
1029 
1030         require(!paused(), "ERC721Pausable: token transfer while paused");
1031     }
1032 }
1033 
1034 /**
1035  * @title Counters
1036  * @author Matt Condon (@shrugs)
1037  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1038  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1039  *
1040  * Include with `using Counters for Counters.Counter;`
1041  */
1042 library Counters {
1043     struct Counter {
1044         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1045         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1046         // this feature: see https://github.com/ethereum/solidity/issues/4637
1047         uint256 _value; // default: 0
1048     }
1049 
1050     function current(Counter storage counter) internal view returns (uint256) {
1051         return counter._value;
1052     }
1053 
1054     function increment(Counter storage counter) internal {
1055         unchecked {
1056             counter._value += 1;
1057         }
1058     }
1059 
1060     function decrement(Counter storage counter) internal {
1061         uint256 value = counter._value;
1062         require(value > 0, "Counter: decrement overflow");
1063         unchecked {
1064             counter._value = value - 1;
1065         }
1066     }
1067 
1068     function reset(Counter storage counter) internal {
1069         counter._value = 0;
1070     }
1071 }
1072 
1073 /**
1074  * @dev Contract module which provides a basic access control mechanism, where
1075  * there is an account (an owner) that can be granted exclusive access to
1076  * specific functions.
1077  *
1078  * By default, the owner account will be the one that deploys the contract. This
1079  * can later be changed with {transferOwnership}.
1080  *
1081  * This module is used through inheritance. It will make available the modifier
1082  * `onlyOwner`, which can be applied to your functions to restrict their use to
1083  * the owner.
1084  */
1085 abstract contract Ownable is Context {
1086     address private _owner;
1087 
1088     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1089 
1090     /**
1091      * @dev Initializes the contract setting the deployer as the initial owner.
1092      */
1093     constructor() {
1094         _setOwner(_msgSender());
1095     }
1096 
1097     /**
1098      * @dev Returns the address of the current owner.
1099      */
1100     function owner() public view virtual returns (address) {
1101         return _owner;
1102     }
1103 
1104     /**
1105      * @dev Throws if called by any account other than the owner.
1106      */
1107     modifier onlyOwner() {
1108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1109         _;
1110     }
1111 
1112     /**
1113      * @dev Leaves the contract without owner. It will not be possible to call
1114      * `onlyOwner` functions anymore. Can only be called by the current owner.
1115      *
1116      * NOTE: Renouncing ownership will leave the contract without an owner,
1117      * thereby removing any functionality that is only available to the owner.
1118      */
1119     function renounceOwnership() public virtual onlyOwner {
1120         _setOwner(address(0));
1121     }
1122 
1123     /**
1124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1125      * Can only be called by the current owner.
1126      */
1127     function transferOwnership(address newOwner) public virtual onlyOwner {
1128         require(newOwner != address(0), "Ownable: new owner is the zero address");
1129         _setOwner(newOwner);
1130     }
1131 
1132     function _setOwner(address newOwner) private {
1133         address oldOwner = _owner;
1134         _owner = newOwner;
1135         emit OwnershipTransferred(oldOwner, newOwner);
1136     }
1137 }
1138 
1139 
1140 
1141 contract NFTHelmets is ERC721Pausable, Ownable {
1142     using Counters for Counters.Counter;
1143     using Strings for uint256;
1144     Counters.Counter private _tokenIds;
1145 
1146     address private constant _devAddress = 0x2Ea23ad853A68c0bD10cA15d5e896273585Ac3E0;
1147     address private constant _oldContract = 0x197b0C12B2DEbAE8905B3d3cD8F4dBEb988dB835; 
1148     address private constant _addr2 = 0x3ad25CA6A04b2970ae62F68e84394138c33471e7; 
1149 
1150     uint256 private  _maxTokens = 1138;
1151     uint256 private  _maxMint = 2;
1152     uint256 private  _maxPresaleMint = 2;
1153                         
1154     uint256 public  _price = 200000000000000000; // 0.2 ETH
1155 
1156     mapping (address => bool) private _whitelist;
1157     mapping (address => uint256) private _presaleMints;
1158     mapping (address => uint256) private _saleMints;
1159 
1160     bool private _presaleActive = false;
1161     bool private _saleActive = false;
1162     bool private _209minted = false; 
1163     bool private _oldHoldersTransferred = false; 
1164     string public _prefixURI;
1165     string public _baseExtension; 
1166 
1167     constructor() public ERC721("NFTHelmets", "NFTH") {
1168         _pause();
1169     }
1170     
1171     
1172     function _mint209() public onlyOwner {
1173         require(_209minted == false);
1174         _209minted = true; 
1175         _safeMint(_addr2, 209);
1176     }   
1177 
1178     function airdrop(address[] memory addrs) public onlyOwner {
1179         for (uint256 i = 0; i < addrs.length; i++) {
1180             _tokenIds.increment();
1181             uint256 id = _tokenIds.current();
1182             _safeMint(addrs[i], id);
1183         }
1184     }
1185 
1186     /* Resend tokens that people already minted */
1187     function transferOldHolders() public onlyOwner {
1188         require(_oldHoldersTransferred == false); 
1189         _oldHoldersTransferred = true; 
1190         // load old contract 
1191         IERC721 instance = IERC721(_oldContract); 
1192         // sends token IDs 1->221 (without 209) to the holders (from last contract)
1193         for(uint256 i = 1;i<=221;i++) {
1194             _tokenIds.increment();
1195             if(i == 209) {
1196                 continue;
1197             }
1198             address ownerID = instance.ownerOf(i);
1199             _safeMint(ownerID, i);
1200         }
1201     }
1202 
1203     function increaseTokenID(uint256 newID) public onlyOwner {
1204         uint256 currentID = _tokenIds.current();
1205         require(newID > currentID, "New ID must be greater than current ID");
1206         uint256 diff = newID - currentID; 
1207         for(uint256 i = 1;i<diff;i++) {
1208             _tokenIds.increment(); 
1209         }
1210     }
1211 
1212     function burnToken(uint256 tokenId) public virtual {
1213         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721 Burnable: caller is not owner nor approved"); 
1214         _burn(tokenId);
1215     }
1216 
1217     function _baseURI() internal view override returns (string memory) {
1218         return _prefixURI;
1219     }
1220 
1221     function setBaseURI(string memory _uri) public onlyOwner {
1222         _prefixURI = _uri;
1223     }
1224 
1225     function baseExtension() internal view returns (string memory) {
1226         return _baseExtension; 
1227     }
1228 
1229     function setBaseExtension(string memory _ext) public onlyOwner {
1230         _baseExtension = _ext; 
1231     }
1232 
1233     function totalSupply() public view returns (uint256) {
1234         return _tokenIds.current();
1235     }
1236 
1237     function isWhitelisted(address addr) public view returns (bool) {
1238         return _whitelist[addr];
1239     }
1240 
1241     function preSaleActive() public view returns (bool) {
1242         return _presaleActive; 
1243     }
1244 
1245     function saleActive() public view returns (bool) {
1246         return _saleActive; 
1247     }
1248 
1249     function presaleMinted(address addr) public view returns (uint256) {
1250         return _presaleMints[addr]; 
1251     }
1252 
1253     function saleMinted(address addr) public view returns (uint256) {
1254         return _saleMints[addr]; 
1255     }
1256     
1257     function addToWhitelist(address[] memory addrs) public onlyOwner {
1258         for (uint256 i = 0; i < addrs.length; i++) {
1259             _whitelist[addrs[i]] = true;
1260             _presaleMints[addrs[i]] = 0;
1261         }
1262     }
1263     
1264     function removeFromWhitelist(address[] memory addrs) public onlyOwner {
1265         for (uint256 i = 0; i < addrs.length; i++) {
1266             _whitelist[addrs[i]] = false;
1267             _presaleMints[addrs[i]] = 0;
1268         }
1269     }
1270 
1271     function resetSaleMintsForAddrs(address[] memory addrs) public onlyOwner {
1272         for (uint256 i = 0; i < addrs.length; i++) {
1273             _saleMints[addrs[i]] = 0;
1274         }
1275     }
1276 
1277     function presaleMintItems(uint256 amount) public payable {
1278         require(amount <= _maxMint);
1279         require(amount <= _maxPresaleMint);
1280         require(isWhitelisted(msg.sender));
1281         require(msg.value >= amount * _price);
1282         require(_presaleMints[msg.sender] + amount <= _maxPresaleMint);
1283         require(_presaleActive);
1284         uint256 totalMinted = _tokenIds.current();
1285         require(totalMinted + amount <= _maxTokens);
1286         for (uint256 i = 0; i < amount; i++) {
1287             _presaleMints[msg.sender] += 1;
1288             _mintItem(msg.sender);
1289         }
1290     }
1291 
1292     function mintItems(uint256 amount) public payable {
1293         require(amount <= _maxMint);
1294         require(_saleActive); 
1295         uint256 totalMinted = _tokenIds.current();
1296         require(totalMinted + amount <= _maxTokens);
1297         require(_saleMints[msg.sender] + amount <= _maxMint); 
1298         require(msg.value >= amount * _price);
1299         for (uint256 i = 0; i < amount; i++) {
1300             _saleMints[msg.sender] += 1; 
1301             _mintItem(msg.sender);
1302         }
1303     }
1304 
1305     function _mintItem(address to) internal returns (uint256) {
1306         _tokenIds.increment();
1307         uint256 id = _tokenIds.current();
1308         if(id == 209) {
1309             _tokenIds.increment(); 
1310             id = _tokenIds.current(); 
1311         }
1312         _safeMint(to, id);
1313         return id;
1314     }
1315 
1316     // State management 
1317     function togglePreSale() public onlyOwner {
1318         _presaleActive = !_presaleActive;
1319     }
1320 
1321     function toggleSale() public onlyOwner {
1322         _saleActive = !_saleActive;
1323     }
1324 
1325     function toggleTransferPause() public onlyOwner {
1326         paused() ? _unpause() : _pause();
1327     }
1328 
1329 
1330     function updateMaxTokens(uint256 newMax) public onlyOwner {
1331         _maxTokens = newMax; 
1332     }
1333 
1334     function updateMaxMint(uint256 newMax) public onlyOwner {
1335         _maxMint = newMax; 
1336     }
1337 
1338     function updateMaxPresaleMint(uint256 newMax) public onlyOwner {
1339         _maxPresaleMint = newMax; 
1340     }
1341 
1342     function updatePrice(uint256 newPrice) public onlyOwner {
1343         _price = newPrice; 
1344     }
1345 
1346     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1347         require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1348         string memory currentBaseURI = _baseURI();
1349         tokenId.toString();
1350         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), _baseExtension)) : "";
1351     }
1352 
1353     function withdraw() external onlyOwner {
1354         require(address(this).balance > 0); 
1355         payable(_devAddress).transfer(address(this).balance * 40 / 100);
1356         payable(msg.sender).transfer(address(this).balance);
1357     }
1358     
1359 
1360     // Allows minting(transfer from 0 address), but not transferring while paused() except from owner
1361     function _beforeTokenTransfer(
1362         address from,
1363         address to,
1364         uint256 tokenId
1365     ) internal virtual override {
1366         if (!(from == address(0)) && !(from == owner())) {
1367             require(!paused(), "ERC721Pausable: token transfer while paused");
1368         }
1369     }
1370 }