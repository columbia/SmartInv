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
535     // Base URI
536     string private _baseURI;
537 
538     // Mapping from token ID to owner address
539     mapping(uint256 => address) private _owners;
540 
541     // Mapping owner address to token count
542     mapping(address => uint256) private _balances;
543 
544     // Mapping from token ID to approved address
545     mapping(uint256 => address) private _tokenApprovals;
546 
547     // Mapping from owner to operator approvals
548     mapping(address => mapping(address => bool)) private _operatorApprovals;
549 
550     // Optional mapping for token URIs
551     mapping (uint256 => string) private _tokenURIs;
552 
553     /**
554      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
555      */
556     constructor(string memory name_, string memory symbol_) {
557         _name = name_;
558         _symbol = symbol_;
559     }
560 
561     /**
562      * @dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
565         return
566             interfaceId == type(IERC721).interfaceId ||
567             interfaceId == type(IERC721Metadata).interfaceId ||
568             super.supportsInterface(interfaceId);
569     }
570 
571     /**
572      * @dev See {IERC721-balanceOf}.
573      */
574     function balanceOf(address owner) public view virtual override returns (uint256) {
575         require(owner != address(0), "ERC721: balance query for the zero address");
576         return _balances[owner];
577     }
578 
579     /**
580      * @dev See {IERC721-ownerOf}.
581      */
582     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
583         address owner = _owners[tokenId];
584         require(owner != address(0), "ERC721: owner query for nonexistent token");
585         return owner;
586     }
587 
588     /**
589      * @dev See {IERC721Metadata-name}.
590      */
591     function name() public view virtual override returns (string memory) {
592         return _name;
593     }
594 
595     /**
596      * @dev See {IERC721Metadata-symbol}.
597      */
598     function symbol() public view virtual override returns (string memory) {
599         return _symbol;
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-tokenURI}.
604      */
605     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
606         require(bytes(baseURI()).length != 0, "BaseURI has not been set yet");
607         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
608 
609         return string(abi.encodePacked(baseURI(), _tokenId.toString()));
610     }
611 
612     /**
613     * @dev Returns the base URI set via {_setBaseURI}. This will be
614     * automatically added as a prefix in {tokenURI} to each token's URI, or
615     * to the token ID if no specific URI is set for that token ID.
616     */
617     function baseURI() public view virtual returns (string memory) {
618         return _baseURI;
619     }
620 
621     /**
622      * @dev Internal function to set the base URI for all token IDs. It is
623      * automatically added as a prefix to the value returned in {tokenURI},
624      * or to the token ID if {tokenURI} is empty.
625      */
626     function _setBaseURI(string memory baseURI_) internal virtual {
627         _baseURI = baseURI_;
628     }
629 
630     /**
631      * @dev See {IERC721-approve}.
632      */
633     function approve(address to, uint256 tokenId) public virtual override {
634         address owner = ERC721.ownerOf(tokenId);
635         require(to != owner, "ERC721: approval to current owner");
636 
637         require(
638             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
639             "ERC721: approve caller is not owner nor approved for all"
640         );
641 
642         _approve(to, tokenId);
643     }
644 
645     /**
646      * @dev See {IERC721-getApproved}.
647      */
648     function getApproved(uint256 tokenId) public view virtual override returns (address) {
649         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
650 
651         return _tokenApprovals[tokenId];
652     }
653 
654     /**
655      * @dev See {IERC721-setApprovalForAll}.
656      */
657     function setApprovalForAll(address operator, bool approved) public virtual override {
658         require(operator != _msgSender(), "ERC721: approve to caller");
659 
660         _operatorApprovals[_msgSender()][operator] = approved;
661         emit ApprovalForAll(_msgSender(), operator, approved);
662     }
663 
664     /**
665      * @dev See {IERC721-isApprovedForAll}.
666      */
667     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
668         return _operatorApprovals[owner][operator];
669     }
670 
671     /**
672      * @dev See {IERC721-transferFrom}.
673      */
674     function transferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) public virtual override {
679         //solhint-disable-next-line max-line-length
680         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
681 
682         _transfer(from, to, tokenId);
683     }
684 
685     /**
686      * @dev See {IERC721-safeTransferFrom}.
687      */
688     function safeTransferFrom(
689         address from,
690         address to,
691         uint256 tokenId
692     ) public virtual override {
693         safeTransferFrom(from, to, tokenId, "");
694     }
695 
696     /**
697      * @dev See {IERC721-safeTransferFrom}.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId,
703         bytes memory _data
704     ) public virtual override {
705         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
706         _safeTransfer(from, to, tokenId, _data);
707     }
708 
709     /**
710      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
711      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
712      *
713      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
714      *
715      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
716      * implement alternative mechanisms to perform token transfer, such as signature-based.
717      *
718      * Requirements:
719      *
720      * - `from` cannot be the zero address.
721      * - `to` cannot be the zero address.
722      * - `tokenId` token must exist and be owned by `from`.
723      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
724      *
725      * Emits a {Transfer} event.
726      */
727     function _safeTransfer(
728         address from,
729         address to,
730         uint256 tokenId,
731         bytes memory _data
732     ) internal virtual {
733         _transfer(from, to, tokenId);
734         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
735     }
736 
737     /**
738      * @dev Returns whether `tokenId` exists.
739      *
740      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
741      *
742      * Tokens start existing when they are minted (`_mint`),
743      * and stop existing when they are burned (`_burn`).
744      */
745     function _exists(uint256 tokenId) internal view virtual returns (bool) {
746         return _owners[tokenId] != address(0);
747     }
748 
749     /**
750      * @dev Returns whether `spender` is allowed to manage `tokenId`.
751      *
752      * Requirements:
753      *
754      * - `tokenId` must exist.
755      */
756     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
757         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
758         address owner = ERC721.ownerOf(tokenId);
759         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
760     }
761 
762     /**
763      * @dev Safely mints `tokenId` and transfers it to `to`.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must not exist.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _safeMint(address to, uint256 tokenId) internal virtual {
773         _safeMint(to, tokenId, "");
774     }
775 
776     /**
777      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
778      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
779      */
780     function _safeMint(
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) internal virtual {
785         _mint(to, tokenId);
786         require(
787             _checkOnERC721Received(address(0), to, tokenId, _data),
788             "ERC721: transfer to non ERC721Receiver implementer"
789         );
790     }
791 
792     /**
793      * @dev Mints `tokenId` and transfers it to `to`.
794      *
795      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
796      *
797      * Requirements:
798      *
799      * - `tokenId` must not exist.
800      * - `to` cannot be the zero address.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _mint(address to, uint256 tokenId) internal virtual {
805         require(to != address(0), "ERC721: mint to the zero address");
806         require(!_exists(tokenId), "ERC721: token already minted");
807 
808         _beforeTokenTransfer(address(0), to, tokenId);
809 
810         _balances[to] += 1;
811         _owners[tokenId] = to;
812 
813         emit Transfer(address(0), to, tokenId);
814     }
815 
816     /**
817      * @dev Destroys `tokenId`.
818      * The approval is cleared when the token is burned.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _burn(uint256 tokenId) internal virtual {
827         address owner = ERC721.ownerOf(tokenId);
828 
829         _beforeTokenTransfer(owner, address(0), tokenId);
830 
831         // Clear approvals
832         _approve(address(0), tokenId);
833 
834         _balances[owner] -= 1;
835         delete _owners[tokenId];
836 
837         emit Transfer(owner, address(0), tokenId);
838     }
839 
840     /**
841      * @dev Transfers `tokenId` from `from` to `to`.
842      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
843      *
844      * Requirements:
845      *
846      * - `to` cannot be the zero address.
847      * - `tokenId` token must be owned by `from`.
848      *
849      * Emits a {Transfer} event.
850      */
851     function _transfer(
852         address from,
853         address to,
854         uint256 tokenId
855     ) internal virtual {
856         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
857         require(to != address(0), "ERC721: transfer to the zero address");
858 
859         _beforeTokenTransfer(from, to, tokenId);
860 
861         // Clear approvals from the previous owner
862         _approve(address(0), tokenId);
863 
864         _balances[from] -= 1;
865         _balances[to] += 1;
866         _owners[tokenId] = to;
867 
868         emit Transfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev Approve `to` to operate on `tokenId`
873      *
874      * Emits a {Approval} event.
875      */
876     function _approve(address to, uint256 tokenId) internal virtual {
877         _tokenApprovals[tokenId] = to;
878         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
879     }
880 
881     /**
882      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
883      * The call is not executed if the target address is not a contract.
884      *
885      * @param from address representing the previous owner of the given token ID
886      * @param to target address that will receive the tokens
887      * @param tokenId uint256 ID of the token to be transferred
888      * @param _data bytes optional data to send along with the call
889      * @return bool whether the call correctly returned the expected magic value
890      */
891     function _checkOnERC721Received(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) private returns (bool) {
897         if (to.isContract()) {
898             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
899                 return retval == IERC721Receiver(to).onERC721Received.selector;
900             } catch (bytes memory reason) {
901                 if (reason.length == 0) {
902                     revert("ERC721: transfer to non ERC721Receiver implementer");
903                 } else {
904                     assembly {
905                         revert(add(32, reason), mload(reason))
906                     }
907                 }
908             }
909         } else {
910             return true;
911         }
912     }
913 
914     /**
915      * @dev Hook that is called before any token transfer. This includes minting
916      * and burning.
917      *
918      * Calling conditions:
919      *
920      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
921      * transferred to `to`.
922      * - When `from` is zero, `tokenId` will be minted for `to`.
923      * - When `to` is zero, ``from``'s `tokenId` will be burned.
924      * - `from` and `to` are never both zero.
925      *
926      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
927      */
928     function _beforeTokenTransfer(
929         address from,
930         address to,
931         uint256 tokenId
932     ) internal virtual {}
933 }
934 
935 /**
936  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
937  * @dev See https://eips.ethereum.org/EIPS/eip-721
938  */
939 interface IERC721Enumerable is IERC721 {
940     /**
941      * @dev Returns the total amount of tokens stored by the contract.
942      */
943     function totalSupply() external view returns (uint256);
944 
945     /**
946      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
947      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
948      */
949     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
950 
951     /**
952      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
953      * Use along with {totalSupply} to enumerate all tokens.
954      */
955     function tokenByIndex(uint256 index) external view returns (uint256);
956 }
957 
958 /**
959  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
960  * enumerability of all the token ids in the contract as well as all token ids owned by each
961  * account.
962  */
963 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
964     // Mapping from owner to list of owned token IDs
965     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
966 
967     // Mapping from token ID to index of the owner tokens list
968     mapping(uint256 => uint256) private _ownedTokensIndex;
969 
970     // Array with all token ids, used for enumeration
971     uint256[] private _allTokens;
972 
973     // Mapping from token id to position in the allTokens array
974     mapping(uint256 => uint256) private _allTokensIndex;
975 
976     /**
977      * @dev See {IERC165-supportsInterface}.
978      */
979     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
980         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
981     }
982 
983     /**
984      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
985      */
986     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
987         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
988         return _ownedTokens[owner][index];
989     }
990 
991     /**
992      * @dev See {IERC721Enumerable-totalSupply}.
993      */
994     function totalSupply() public view virtual override returns (uint256) {
995         return _allTokens.length;
996     }
997 
998     /**
999      * @dev See {IERC721Enumerable-tokenByIndex}.
1000      */
1001     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1002         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1003         return _allTokens[index];
1004     }
1005 
1006     /**
1007      * @dev Hook that is called before any token transfer. This includes minting
1008      * and burning.
1009      *
1010      * Calling conditions:
1011      *
1012      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1013      * transferred to `to`.
1014      * - When `from` is zero, `tokenId` will be minted for `to`.
1015      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      *
1019      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1020      */
1021     function _beforeTokenTransfer(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) internal virtual override {
1026         super._beforeTokenTransfer(from, to, tokenId);
1027 
1028         if (from == address(0)) {
1029             _addTokenToAllTokensEnumeration(tokenId);
1030         } else if (from != to) {
1031             _removeTokenFromOwnerEnumeration(from, tokenId);
1032         }
1033         if (to == address(0)) {
1034             _removeTokenFromAllTokensEnumeration(tokenId);
1035         } else if (to != from) {
1036             _addTokenToOwnerEnumeration(to, tokenId);
1037         }
1038     }
1039 
1040     /**
1041      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1042      * @param to address representing the new owner of the given token ID
1043      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1044      */
1045     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1046         uint256 length = ERC721.balanceOf(to);
1047         _ownedTokens[to][length] = tokenId;
1048         _ownedTokensIndex[tokenId] = length;
1049     }
1050 
1051     /**
1052      * @dev Private function to add a token to this extension's token tracking data structures.
1053      * @param tokenId uint256 ID of the token to be added to the tokens list
1054      */
1055     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1056         _allTokensIndex[tokenId] = _allTokens.length;
1057         _allTokens.push(tokenId);
1058     }
1059 
1060     /**
1061      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1062      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1063      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1064      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1065      * @param from address representing the previous owner of the given token ID
1066      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1067      */
1068     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1069         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1070         // then delete the last slot (swap and pop).
1071 
1072         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1073         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1074 
1075         // When the token to delete is the last token, the swap operation is unnecessary
1076         if (tokenIndex != lastTokenIndex) {
1077             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1078 
1079             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1080             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1081         }
1082 
1083         // This also deletes the contents at the last position of the array
1084         delete _ownedTokensIndex[tokenId];
1085         delete _ownedTokens[from][lastTokenIndex];
1086     }
1087 
1088     /**
1089      * @dev Private function to remove a token from this extension's token tracking data structures.
1090      * This has O(1) time complexity, but alters the order of the _allTokens array.
1091      * @param tokenId uint256 ID of the token to be removed from the tokens list
1092      */
1093     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1094         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1095         // then delete the last slot (swap and pop).
1096 
1097         uint256 lastTokenIndex = _allTokens.length - 1;
1098         uint256 tokenIndex = _allTokensIndex[tokenId];
1099 
1100         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1101         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1102         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1103         uint256 lastTokenId = _allTokens[lastTokenIndex];
1104 
1105         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1106         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1107 
1108         // This also deletes the contents at the last position of the array
1109         delete _allTokensIndex[tokenId];
1110         _allTokens.pop();
1111     }
1112 }
1113 
1114 /**
1115  * @dev Contract module which provides a basic access control mechanism, where
1116  * there is an account (an owner) that can be granted exclusive access to
1117  * specific functions.
1118  *
1119  * By default, the owner account will be the one that deploys the contract. This
1120  * can later be changed with {transferOwnership}.
1121  *
1122  * This module is used through inheritance. It will make available the modifier
1123  * `onlyOwner`, which can be applied to your functions to restrict their use to
1124  * the owner.
1125  */
1126 abstract contract Ownable is Context {
1127     address private _owner;
1128 
1129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1130 
1131     /**
1132      * @dev Initializes the contract setting the deployer as the initial owner.
1133      */
1134     constructor() {
1135         _setOwner(_msgSender());
1136     }
1137 
1138     /**
1139      * @dev Returns the address of the current owner.
1140      */
1141     function owner() public view virtual returns (address) {
1142         return _owner;
1143     }
1144 
1145     /**
1146      * @dev Throws if called by any account other than the owner.
1147      */
1148     modifier onlyOwner() {
1149         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1150         _;
1151     }
1152 
1153     /**
1154      * @dev Leaves the contract without owner. It will not be possible to call
1155      * `onlyOwner` functions anymore. Can only be called by the current owner.
1156      *
1157      * NOTE: Renouncing ownership will leave the contract without an owner,
1158      * thereby removing any functionality that is only available to the owner.
1159      */
1160     function renounceOwnership() public virtual onlyOwner {
1161         _setOwner(address(0));
1162     }
1163 
1164     /**
1165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1166      * Can only be called by the current owner.
1167      */
1168     function transferOwnership(address newOwner) public virtual onlyOwner {
1169         require(newOwner != address(0), "Ownable: new owner is the zero address");
1170         _setOwner(newOwner);
1171     }
1172 
1173     function _setOwner(address newOwner) private {
1174         address oldOwner = _owner;
1175         _owner = newOwner;
1176         emit OwnershipTransferred(oldOwner, newOwner);
1177     }
1178 }
1179 
1180 contract InfectedBodies is ERC721Enumerable, Ownable {
1181     using Strings for uint256;
1182 
1183     // the supply of Punks
1184     uint256 public constant MAX_NFT_SUPPLY = 10000;
1185 
1186     // max amount of nfts you can mint at once
1187     uint256 public maxPurchase = 10;
1188 
1189     // number of reserve tokens in total; this should be the same as the publicTokenIdStart, where the reserve tokens end, the public tokens start
1190     uint256 public constant reserveTokens = 500;
1191 
1192     // the price per nft
1193     uint256 public tokenPrice = 50000000000000000; // 0.05 ETH
1194 
1195     // addresses of team members
1196     address public constant devAddress = 0x0dd874F41cE844FcdaeBA33714B6197136D89B7F;
1197     address public constant operationsAddress = 0xE9b8bC7aEf16Fb0d53d74f05a897E8A92B2de04f;
1198 
1199     // SHA256 of concatenated hash string containing all the hashes of all tokens
1200     string public IBProvenanceHash;
1201 
1202     // ensures that we do not change the metadata multiple times
1203     bool public metadataLocked = false;
1204 
1205     // expresses whether users can buy
1206     bool public saleIsActive = false;
1207 
1208     // list of addresses eligible for the first pre-sale
1209     address[] public _whitelistedAddresses;
1210 
1211     // if the publicSale is false, then it's the presale, after the presale, the publicSale will be forever true
1212     bool public publicSale = false;
1213 
1214     // mapping to keep count of how many tokens an address has bought during presale
1215     mapping(address => uint256) public _presaleCounter;
1216 
1217     // mapping to keep count of how many tokens an address has bought
1218     mapping(address => uint256) public amountPerAddress;
1219 
1220     // number of tokens an address can buy during each presale phase
1221     uint256 public presaleLimit = 5;
1222 
1223     // number of tokens an address can buy during each presale phase
1224     uint256 public maxPerAddress = 10;
1225 
1226     // counter for the current reserve token id i.e. the tokens reserved for the team, 1000 in total
1227     uint256 public _reserveTokensTaken = 0;
1228 
1229     // offset to randomise the getRandomId() function
1230     uint256 internal _randomOffset = 0;
1231     
1232     constructor() ERC721("Infected Bodies", "INF") {}
1233 
1234     function _getRandomId() internal returns (uint256)  {
1235       uint256 id = uint256(keccak256(abi.encodePacked(block.timestamp + block.difficulty + _randomOffset))) % MAX_NFT_SUPPLY;
1236 
1237       if (totalSupply() < MAX_NFT_SUPPLY) {
1238         while(_exists(id))  {
1239         _randomOffset++;
1240         id = uint256(keccak256(abi.encodePacked(block.timestamp + block.difficulty + _randomOffset))) % MAX_NFT_SUPPLY;
1241         }
1242       }
1243       return id;
1244     }
1245 
1246     function mintInfectedBodies(uint256 numberOfTokens) public payable {
1247         require(saleIsActive, "Sale must be active to mint");
1248         require(numberOfTokens > 0 && numberOfTokens <= maxPurchase, "Not within the range of maxPurchase");
1249         require((totalSupply() + numberOfTokens) <= MAX_NFT_SUPPLY, "Purchase would exceed max supply of Infected Bodies");
1250         require(amountPerAddress[msg.sender] + numberOfTokens <= maxPerAddress, "You already bought the maximum amount of tokens allowed");
1251         require(msg.value >= tokenPrice * numberOfTokens, "Ether value sent is not correct");
1252 
1253         if (publicSale != true) {
1254             require(isInPresale(msg.sender), "You are not whitelisted");
1255             require(_presaleCounter[msg.sender] + numberOfTokens <= presaleLimit, "Maximum amount of NFTs per address exceeded");
1256         }
1257 
1258         for (uint256 i = 0; i < numberOfTokens; i++) {
1259             uint256 id = _getRandomId();
1260             if (publicSale != true) {
1261                 _presaleCounter[msg.sender]++;
1262             } else {
1263                 amountPerAddress[msg.sender]++;
1264             }
1265             if (totalSupply() < MAX_NFT_SUPPLY) {
1266                 _safeMint(msg.sender, id);
1267             }
1268         }
1269     }
1270 
1271     function tokensOfOwner(address _owner) external view returns (uint256[] memory ) {
1272         uint256 tokenCount = balanceOf(_owner);
1273         if (tokenCount == 0) {
1274             // Return an empty array
1275             return new uint256[](0);
1276         } else {
1277             uint256[] memory result = new uint256[](tokenCount);
1278             uint256 index;
1279             for (index = 0; index < tokenCount; index++) {
1280                 result[index] = tokenOfOwnerByIndex(_owner, index);
1281             }
1282             return result;
1283         }
1284     }
1285 
1286     // checks whether the address is on the whitelist for 2nd presale
1287     function isInPresale(address user) public view returns (bool answer) {
1288         for (uint256 i = 0; i < _whitelistedAddresses.length; i++) {
1289             if (_whitelistedAddresses[i] == user) {
1290                 return true;
1291             }
1292         }
1293         return false;
1294     }
1295 
1296     // OWNER ONLY FUNCTIONS
1297 
1298     // add a whole array of addresses to the list of whitelisted addresses for the first presale
1299     function setWhitelisted(address[] memory addresses) public onlyOwner {
1300         delete _whitelistedAddresses;
1301         _whitelistedAddresses = addresses;
1302     }
1303 
1304     // change token price
1305     function changeTokenPrice(uint256 newPrice) public onlyOwner {
1306         tokenPrice = newPrice;
1307     }
1308 
1309     function goToPublicSalePhase() public onlyOwner {
1310         require(publicSale != true, "The public sale is already live!");
1311         publicSale = true;
1312     }
1313 
1314     // change the amount of tokens you can mint during the first presale
1315     function changePresaleLimit(uint256 amount) public onlyOwner {
1316         presaleLimit = amount;
1317     }
1318 
1319     // changes how many nfts can be own per address
1320     function changeSaleLimit(uint256 amount) public onlyOwner {
1321         maxPerAddress = amount;
1322     }
1323 
1324     // reveals the final provenance hash  and prohibits further changes
1325     function lockMetadata(string memory finalHash) public onlyOwner {
1326         require(metadataLocked != true, "Infected bodies: You've already locked the metadata!");
1327 
1328         IBProvenanceHash = finalHash;
1329         metadataLocked = true;
1330     }
1331 
1332     // change the amount of tokens users can buy at once
1333     function changeMaxPurchase(uint256 amount) public onlyOwner {
1334         maxPurchase = amount;
1335     }
1336 
1337     // withdraw all the Ether from the contract to the owner
1338     function withdrawAll() external onlyOwner {
1339         uint256 balance = address(this).balance;
1340         uint256 devPortion = balance*100/2000;
1341         uint256 operationsPortion = balance*100/1000;
1342         payable(devAddress).transfer(devPortion);
1343         payable(operationsAddress).transfer(operationsPortion);
1344         uint256 remainder = balance - devPortion - operationsPortion;
1345         payable(msg.sender).transfer(remainder);
1346     }
1347 
1348     // set baseURI
1349     function setBaseURI(string memory baseURI) public onlyOwner {
1350         require(metadataLocked != true, "Metadata has already been locked and cannot be changed anymore!");
1351         _setBaseURI(baseURI);
1352     }
1353 
1354     // allows minting
1355     function flipSaleIsActive() public onlyOwner {
1356         saleIsActive = !saleIsActive;
1357     }
1358 
1359     function getReserves(uint256 amount) public onlyOwner {
1360         require(_reserveTokensTaken + amount <= reserveTokens, "Amount would exceed the number of reserve tokens!");
1361         for (uint256 i = 0; i < amount; i++) {
1362             uint256 id = _getRandomId();
1363             if (totalSupply() < MAX_NFT_SUPPLY) {
1364                 _safeMint(msg.sender, id);
1365                 _reserveTokensTaken++;
1366             }
1367         }
1368     }
1369 }