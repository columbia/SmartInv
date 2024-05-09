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
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
189  * @dev See https://eips.ethereum.org/EIPS/eip-721
190  */
191 interface IERC721Metadata is IERC721 {
192     /**
193      * @dev Returns the token collection name.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the token collection symbol.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
204      */
205     function tokenURI(uint256 tokenId) external view returns (string memory);
206 }
207  
208 /**
209  * @dev Collection of functions related to the address type
210  */
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies on extcodesize, which returns 0 for contracts in
231         // construction, since the code is only stored at the end of the
232         // constructor execution.
233 
234         uint256 size;
235         assembly {
236             size := extcodesize(account)
237         }
238         return size > 0;
239     }
240 
241     /**
242      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
243      * `recipient`, forwarding all available gas and reverting on errors.
244      *
245      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
246      * of certain opcodes, possibly making contracts go over the 2300 gas limit
247      * imposed by `transfer`, making them unable to receive funds via
248      * `transfer`. {sendValue} removes this limitation.
249      *
250      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
251      *
252      * IMPORTANT: because control is transferred to `recipient`, care must be
253      * taken to not create reentrancy vulnerabilities. Consider using
254      * {ReentrancyGuard} or the
255      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
256      */
257     function sendValue(address payable recipient, uint256 amount) internal {
258         require(address(this).balance >= amount, "Address: insufficient balance");
259 
260         (bool success, ) = recipient.call{value: amount}("");
261         require(success, "Address: unable to send value, recipient may have reverted");
262     }
263 
264     /**
265      * @dev Performs a Solidity function call using a low level `call`. A
266      * plain `call` is an unsafe replacement for a function call: use this
267      * function instead.
268      *
269      * If `target` reverts with a revert reason, it is bubbled up by this
270      * function (like regular Solidity function calls).
271      *
272      * Returns the raw returned data. To convert to the expected return value,
273      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
274      *
275      * Requirements:
276      *
277      * - `target` must be a contract.
278      * - calling `target` with `data` must not revert.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionCall(target, data, "Address: low-level call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
288      * `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, 0, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but also transferring `value` wei to `target`.
303      *
304      * Requirements:
305      *
306      * - the calling contract must have an ETH balance of at least `value`.
307      * - the called Solidity function must be `payable`.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value
315     ) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
321      * with `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(
326         address target,
327         bytes memory data,
328         uint256 value,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         require(address(this).balance >= value, "Address: insufficient balance for call");
332         require(isContract(target), "Address: call to non-contract");
333 
334         (bool success, bytes memory returndata) = target.call{value: value}(data);
335         return _verifyCallResult(success, returndata, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
345         return functionStaticCall(target, data, "Address: low-level static call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal view returns (bytes memory) {
359         require(isContract(target), "Address: static call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.staticcall(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         require(isContract(target), "Address: delegate call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.delegatecall(data);
389         return _verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     function _verifyCallResult(
393         bool success,
394         bytes memory returndata,
395         string memory errorMessage
396     ) private pure returns (bytes memory) {
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414  
415 /*
416  * @dev Provides information about the current execution context, including the
417  * sender of the transaction and its data. While these are generally available
418  * via msg.sender and msg.data, they should not be accessed in such a direct
419  * manner, since when dealing with meta-transactions the account sending and
420  * paying for execution may not be the actual sender (as far as an application
421  * is concerned).
422  *
423  * This contract is only required for intermediate, library-like contracts.
424  */
425 abstract contract Context {
426     function _msgSender() internal view virtual returns (address) {
427         return msg.sender;
428     }
429 
430     function _msgData() internal view virtual returns (bytes calldata) {
431         return msg.data;
432     }
433 }
434  
435 /**
436  * @dev String operations.
437  */
438 library Strings {
439     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
440 
441     /**
442      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
443      */
444     function toString(uint256 value) internal pure returns (string memory) {
445         // Inspired by OraclizeAPI's implementation - MIT licence
446         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
447 
448         if (value == 0) {
449             return "0";
450         }
451         uint256 temp = value;
452         uint256 digits;
453         while (temp != 0) {
454             digits++;
455             temp /= 10;
456         }
457         bytes memory buffer = new bytes(digits);
458         while (value != 0) {
459             digits -= 1;
460             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
461             value /= 10;
462         }
463         return string(buffer);
464     }
465 
466     /**
467      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
468      */
469     function toHexString(uint256 value) internal pure returns (string memory) {
470         if (value == 0) {
471             return "0x00";
472         }
473         uint256 temp = value;
474         uint256 length = 0;
475         while (temp != 0) {
476             length++;
477             temp >>= 8;
478         }
479         return toHexString(value, length);
480     }
481 
482     /**
483      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
484      */
485     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
486         bytes memory buffer = new bytes(2 * length + 2);
487         buffer[0] = "0";
488         buffer[1] = "x";
489         for (uint256 i = 2 * length + 1; i > 1; --i) {
490             buffer[i] = _HEX_SYMBOLS[value & 0xf];
491             value >>= 4;
492         }
493         require(value == 0, "Strings: hex length insufficient");
494         return string(buffer);
495     }
496 }
497  
498 /**
499  * @dev Implementation of the {IERC165} interface.
500  *
501  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
502  * for the additional interface id that will be supported. For example:
503  *
504  * ```solidity
505  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
506  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
507  * }
508  * ```
509  *
510  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
511  */
512 abstract contract ERC165 is IERC165 {
513     /**
514      * @dev See {IERC165-supportsInterface}.
515      */
516     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517         return interfaceId == type(IERC165).interfaceId;
518     }
519 }
520  
521 
522 
523 /**
524  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
525  * the Metadata extension, but not including the Enumerable extension, which is available separately as
526  * {ERC721Enumerable}.
527  */
528 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
529     using Address for address;
530     using Strings for uint256;
531 
532     // Token name
533     string private _name;
534 
535     // Token symbol
536     string private _symbol;
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
550     /**
551      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
552      */
553     constructor(string memory name_, string memory symbol_) {
554         _name = name_;
555         _symbol = symbol_;
556     }
557 
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
562         return
563             interfaceId == type(IERC721).interfaceId ||
564             interfaceId == type(IERC721Metadata).interfaceId ||
565             super.supportsInterface(interfaceId);
566     }
567 
568     /**
569      * @dev See {IERC721-balanceOf}.
570      */
571     function balanceOf(address owner) public view virtual override returns (uint256) {
572         require(owner != address(0), "ERC721: balance query for the zero address");
573         return _balances[owner];
574     }
575 
576     /**
577      * @dev See {IERC721-ownerOf}.
578      */
579     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
580         address owner = _owners[tokenId];
581         require(owner != address(0), "ERC721: owner query for nonexistent token");
582         return owner;
583     }
584 
585     /**
586      * @dev See {IERC721Metadata-name}.
587      */
588     function name() public view virtual override returns (string memory) {
589         return _name;
590     }
591 
592     /**
593      * @dev See {IERC721Metadata-symbol}.
594      */
595     function symbol() public view virtual override returns (string memory) {
596         return _symbol;
597     }
598 
599     /**
600      * @dev See {IERC721Metadata-tokenURI}.
601      */
602     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
603         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
604 
605         string memory baseURI = _baseURI();
606         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
607     }
608 
609     /**
610      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
611      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
612      * by default, can be overriden in child contracts.
613      */
614     function _baseURI() internal view virtual returns (string memory) {
615         return "";
616     }
617 
618     /**
619      * @dev See {IERC721-approve}.
620      */
621     function approve(address to, uint256 tokenId) public virtual override {
622         address owner = ERC721.ownerOf(tokenId);
623         require(to != owner, "ERC721: approval to current owner");
624 
625         require(
626             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
627             "ERC721: approve caller is not owner nor approved for all"
628         );
629 
630         _approve(to, tokenId);
631     }
632 
633     /**
634      * @dev See {IERC721-getApproved}.
635      */
636     function getApproved(uint256 tokenId) public view virtual override returns (address) {
637         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
638 
639         return _tokenApprovals[tokenId];
640     }
641 
642     /**
643      * @dev See {IERC721-setApprovalForAll}.
644      */
645     function setApprovalForAll(address operator, bool approved) public virtual override {
646         require(operator != _msgSender(), "ERC721: approve to caller");
647 
648         _operatorApprovals[_msgSender()][operator] = approved;
649         emit ApprovalForAll(_msgSender(), operator, approved);
650     }
651 
652     /**
653      * @dev See {IERC721-isApprovedForAll}.
654      */
655     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
656         return _operatorApprovals[owner][operator];
657     }
658 
659     /**
660      * @dev See {IERC721-transferFrom}.
661      */
662     function transferFrom(
663         address from,
664         address to,
665         uint256 tokenId
666     ) public virtual override {
667         //solhint-disable-next-line max-line-length
668         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
669 
670         _transfer(from, to, tokenId);
671     }
672 
673     /**
674      * @dev See {IERC721-safeTransferFrom}.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) public virtual override {
681         safeTransferFrom(from, to, tokenId, "");
682     }
683 
684     /**
685      * @dev See {IERC721-safeTransferFrom}.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes memory _data
692     ) public virtual override {
693         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
694         _safeTransfer(from, to, tokenId, _data);
695     }
696 
697     /**
698      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
699      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
700      *
701      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
702      *
703      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
704      * implement alternative mechanisms to perform token transfer, such as signature-based.
705      *
706      * Requirements:
707      *
708      * - `from` cannot be the zero address.
709      * - `to` cannot be the zero address.
710      * - `tokenId` token must exist and be owned by `from`.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function _safeTransfer(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes memory _data
720     ) internal virtual {
721         _transfer(from, to, tokenId);
722         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
723     }
724 
725     /**
726      * @dev Returns whether `tokenId` exists.
727      *
728      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
729      *
730      * Tokens start existing when they are minted (`_mint`),
731      * and stop existing when they are burned (`_burn`).
732      */
733     function _exists(uint256 tokenId) internal view virtual returns (bool) {
734         return _owners[tokenId] != address(0);
735     }
736 
737     /**
738      * @dev Returns whether `spender` is allowed to manage `tokenId`.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
745         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
746         address owner = ERC721.ownerOf(tokenId);
747         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
748     }
749 
750     /**
751      * @dev Safely mints `tokenId` and transfers it to `to`.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must not exist.
756      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
757      *
758      * Emits a {Transfer} event.
759      */
760     function _safeMint(address to, uint256 tokenId) internal virtual {
761         _safeMint(to, tokenId, "");
762     }
763 
764     /**
765      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
766      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
767      */
768     function _safeMint(
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) internal virtual {
773         _mint(to, tokenId);
774         require(
775             _checkOnERC721Received(address(0), to, tokenId, _data),
776             "ERC721: transfer to non ERC721Receiver implementer"
777         );
778     }
779 
780     /**
781      * @dev Mints `tokenId` and transfers it to `to`.
782      *
783      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
784      *
785      * Requirements:
786      *
787      * - `tokenId` must not exist.
788      * - `to` cannot be the zero address.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _mint(address to, uint256 tokenId) internal virtual {
793         require(to != address(0), "ERC721: mint to the zero address");
794         require(!_exists(tokenId), "ERC721: token already minted");
795 
796         _beforeTokenTransfer(address(0), to, tokenId);
797 
798         _balances[to] += 1;
799         _owners[tokenId] = to;
800 
801         emit Transfer(address(0), to, tokenId);
802     }
803 
804     /**
805      * @dev Destroys `tokenId`.
806      * The approval is cleared when the token is burned.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must exist.
811      *
812      * Emits a {Transfer} event.
813      */
814     function _burn(uint256 tokenId) internal virtual {
815         address owner = ERC721.ownerOf(tokenId);
816 
817         _beforeTokenTransfer(owner, address(0), tokenId);
818 
819         // Clear approvals
820         _approve(address(0), tokenId);
821 
822         _balances[owner] -= 1;
823         delete _owners[tokenId];
824 
825         emit Transfer(owner, address(0), tokenId);
826     }
827 
828     /**
829      * @dev Transfers `tokenId` from `from` to `to`.
830      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
831      *
832      * Requirements:
833      *
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must be owned by `from`.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _transfer(
840         address from,
841         address to,
842         uint256 tokenId
843     ) internal virtual {
844         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
845         require(to != address(0), "ERC721: transfer to the zero address");
846 
847         _beforeTokenTransfer(from, to, tokenId);
848 
849         // Clear approvals from the previous owner
850         _approve(address(0), tokenId);
851 
852         _balances[from] -= 1;
853         _balances[to] += 1;
854         _owners[tokenId] = to;
855 
856         emit Transfer(from, to, tokenId);
857     }
858 
859     /**
860      * @dev Approve `to` to operate on `tokenId`
861      *
862      * Emits a {Approval} event.
863      */
864     function _approve(address to, uint256 tokenId) internal virtual {
865         _tokenApprovals[tokenId] = to;
866         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
867     }
868 
869     /**
870      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
871      * The call is not executed if the target address is not a contract.
872      *
873      * @param from address representing the previous owner of the given token ID
874      * @param to target address that will receive the tokens
875      * @param tokenId uint256 ID of the token to be transferred
876      * @param _data bytes optional data to send along with the call
877      * @return bool whether the call correctly returned the expected magic value
878      */
879     function _checkOnERC721Received(
880         address from,
881         address to,
882         uint256 tokenId,
883         bytes memory _data
884     ) private returns (bool) {
885         if (to.isContract()) {
886             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
887                 return retval == IERC721Receiver(to).onERC721Received.selector;
888             } catch (bytes memory reason) {
889                 if (reason.length == 0) {
890                     revert("ERC721: transfer to non ERC721Receiver implementer");
891                 } else {
892                     assembly {
893                         revert(add(32, reason), mload(reason))
894                     }
895                 }
896             }
897         } else {
898             return true;
899         }
900     }
901 
902     /**
903      * @dev Hook that is called before any token transfer. This includes minting
904      * and burning.
905      *
906      * Calling conditions:
907      *
908      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
909      * transferred to `to`.
910      * - When `from` is zero, `tokenId` will be minted for `to`.
911      * - When `to` is zero, ``from``'s `tokenId` will be burned.
912      * - `from` and `to` are never both zero.
913      *
914      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
915      */
916     function _beforeTokenTransfer(
917         address from,
918         address to,
919         uint256 tokenId
920     ) internal virtual {}
921 }
922  
923 
924 /**
925  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
926  * @dev See https://eips.ethereum.org/EIPS/eip-721
927  */
928 interface IERC721Enumerable is IERC721 {
929     /**
930      * @dev Returns the total amount of tokens stored by the contract.
931      */
932     function totalSupply() external view returns (uint256);
933 
934     /**
935      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
936      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
937      */
938     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
939 
940     /**
941      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
942      * Use along with {totalSupply} to enumerate all tokens.
943      */
944     function tokenByIndex(uint256 index) external view returns (uint256);
945 }
946  
947 
948 /**
949  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
950  * enumerability of all the token ids in the contract as well as all token ids owned by each
951  * account.
952  */
953 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
954     // Mapping from owner to list of owned token IDs
955     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
956 
957     // Mapping from token ID to index of the owner tokens list
958     mapping(uint256 => uint256) private _ownedTokensIndex;
959 
960     // Array with all token ids, used for enumeration
961     uint256[] private _allTokens;
962 
963     // Mapping from token id to position in the allTokens array
964     mapping(uint256 => uint256) private _allTokensIndex;
965 
966     /**
967      * @dev See {IERC165-supportsInterface}.
968      */
969     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
970         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
971     }
972 
973     /**
974      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
975      */
976     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
977         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
978         return _ownedTokens[owner][index];
979     }
980 
981     /**
982      * @dev See {IERC721Enumerable-totalSupply}.
983      */
984     function totalSupply() public view virtual override returns (uint256) {
985         return _allTokens.length;
986     }
987 
988     /**
989      * @dev See {IERC721Enumerable-tokenByIndex}.
990      */
991     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
992         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
993         return _allTokens[index];
994     }
995 
996     /**
997      * @dev Hook that is called before any token transfer. This includes minting
998      * and burning.
999      *
1000      * Calling conditions:
1001      *
1002      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1003      * transferred to `to`.
1004      * - When `from` is zero, `tokenId` will be minted for `to`.
1005      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1006      * - `from` cannot be the zero address.
1007      * - `to` cannot be the zero address.
1008      *
1009      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1010      */
1011     function _beforeTokenTransfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) internal virtual override {
1016         super._beforeTokenTransfer(from, to, tokenId);
1017 
1018         if (from == address(0)) {
1019             _addTokenToAllTokensEnumeration(tokenId);
1020         } else if (from != to) {
1021             _removeTokenFromOwnerEnumeration(from, tokenId);
1022         }
1023         if (to == address(0)) {
1024             _removeTokenFromAllTokensEnumeration(tokenId);
1025         } else if (to != from) {
1026             _addTokenToOwnerEnumeration(to, tokenId);
1027         }
1028     }
1029 
1030     /**
1031      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1032      * @param to address representing the new owner of the given token ID
1033      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1034      */
1035     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1036         uint256 length = ERC721.balanceOf(to);
1037         _ownedTokens[to][length] = tokenId;
1038         _ownedTokensIndex[tokenId] = length;
1039     }
1040 
1041     /**
1042      * @dev Private function to add a token to this extension's token tracking data structures.
1043      * @param tokenId uint256 ID of the token to be added to the tokens list
1044      */
1045     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1046         _allTokensIndex[tokenId] = _allTokens.length;
1047         _allTokens.push(tokenId);
1048     }
1049 
1050     /**
1051      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1052      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1053      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1054      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1055      * @param from address representing the previous owner of the given token ID
1056      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1057      */
1058     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1059         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1060         // then delete the last slot (swap and pop).
1061 
1062         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1063         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1064 
1065         // When the token to delete is the last token, the swap operation is unnecessary
1066         if (tokenIndex != lastTokenIndex) {
1067             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1068 
1069             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1070             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1071         }
1072 
1073         // This also deletes the contents at the last position of the array
1074         delete _ownedTokensIndex[tokenId];
1075         delete _ownedTokens[from][lastTokenIndex];
1076     }
1077 
1078     /**
1079      * @dev Private function to remove a token from this extension's token tracking data structures.
1080      * This has O(1) time complexity, but alters the order of the _allTokens array.
1081      * @param tokenId uint256 ID of the token to be removed from the tokens list
1082      */
1083     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1084         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1085         // then delete the last slot (swap and pop).
1086 
1087         uint256 lastTokenIndex = _allTokens.length - 1;
1088         uint256 tokenIndex = _allTokensIndex[tokenId];
1089 
1090         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1091         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1092         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1093         uint256 lastTokenId = _allTokens[lastTokenIndex];
1094 
1095         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1096         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1097 
1098         // This also deletes the contents at the last position of the array
1099         delete _allTokensIndex[tokenId];
1100         _allTokens.pop();
1101     }
1102 }
1103  
1104 
1105 
1106 /**
1107  * @dev External interface of AccessControl declared to support ERC165 detection.
1108  */
1109 interface IAccessControl {
1110     function hasRole(bytes32 role, address account) external view returns (bool);
1111 
1112     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1113 
1114     function grantRole(bytes32 role, address account) external;
1115 
1116     function revokeRole(bytes32 role, address account) external;
1117 
1118     function renounceRole(bytes32 role, address account) external;
1119 }
1120 
1121 /**
1122  * @dev Contract module that allows children to implement role-based access
1123  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1124  * members except through off-chain means by accessing the contract event logs. Some
1125  * applications may benefit from on-chain enumerability, for those cases see
1126  * {AccessControlEnumerable}.
1127  *
1128  * Roles are referred to by their `bytes32` identifier. These should be exposed
1129  * in the external API and be unique. The best way to achieve this is by
1130  * using `public constant` hash digests:
1131  *
1132  * ```
1133  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1134  * ```
1135  *
1136  * Roles can be used to represent a set of permissions. To restrict access to a
1137  * function call, use {hasRole}:
1138  *
1139  * ```
1140  * function foo() public {
1141  *     require(hasRole(MY_ROLE, msg.sender));
1142  *     ...
1143  * }
1144  * ```
1145  *
1146  * Roles can be granted and revoked dynamically via the {grantRole} and
1147  * {revokeRole} functions. Each role has an associated admin role, and only
1148  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1149  *
1150  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1151  * that only accounts with this role will be able to grant or revoke other
1152  * roles. More complex role relationships can be created by using
1153  * {_setRoleAdmin}.
1154  *
1155  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1156  * grant and revoke this role. Extra precautions should be taken to secure
1157  * accounts that have been granted it.
1158  */
1159 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1160     struct RoleData {
1161         mapping(address => bool) members;
1162         bytes32 adminRole;
1163     }
1164 
1165     mapping(bytes32 => RoleData) private _roles;
1166 
1167     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1168 
1169     /**
1170      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1171      *
1172      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1173      * {RoleAdminChanged} not being emitted signaling this.
1174      *
1175      * _Available since v3.1._
1176      */
1177     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1178 
1179     /**
1180      * @dev Emitted when `account` is granted `role`.
1181      *
1182      * `sender` is the account that originated the contract call, an admin role
1183      * bearer except when using {_setupRole}.
1184      */
1185     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1186 
1187     /**
1188      * @dev Emitted when `account` is revoked `role`.
1189      *
1190      * `sender` is the account that originated the contract call:
1191      *   - if using `revokeRole`, it is the admin role bearer
1192      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1193      */
1194     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1195 
1196     /**
1197      * @dev Modifier that checks that an account has a specific role. Reverts
1198      * with a standardized message including the required role.
1199      *
1200      * The format of the revert reason is given by the following regular expression:
1201      *
1202      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1203      *
1204      * _Available since v4.1._
1205      */
1206     modifier onlyRole(bytes32 role) {
1207         _checkRole(role, _msgSender());
1208         _;
1209     }
1210 
1211     /**
1212      * @dev See {IERC165-supportsInterface}.
1213      */
1214     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1215         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1216     }
1217 
1218     /**
1219      * @dev Returns `true` if `account` has been granted `role`.
1220      */
1221     function hasRole(bytes32 role, address account) public view override returns (bool) {
1222         return _roles[role].members[account];
1223     }
1224 
1225     /**
1226      * @dev Revert with a standard message if `account` is missing `role`.
1227      *
1228      * The format of the revert reason is given by the following regular expression:
1229      *
1230      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1231      */
1232     function _checkRole(bytes32 role, address account) internal view {
1233         if (!hasRole(role, account)) {
1234             revert(
1235                 string(
1236                     abi.encodePacked(
1237                         "AccessControl: account ",
1238                         Strings.toHexString(uint160(account), 20),
1239                         " is missing role ",
1240                         Strings.toHexString(uint256(role), 32)
1241                     )
1242                 )
1243             );
1244         }
1245     }
1246 
1247     /**
1248      * @dev Returns the admin role that controls `role`. See {grantRole} and
1249      * {revokeRole}.
1250      *
1251      * To change a role's admin, use {_setRoleAdmin}.
1252      */
1253     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1254         return _roles[role].adminRole;
1255     }
1256 
1257     /**
1258      * @dev Grants `role` to `account`.
1259      *
1260      * If `account` had not been already granted `role`, emits a {RoleGranted}
1261      * event.
1262      *
1263      * Requirements:
1264      *
1265      * - the caller must have ``role``'s admin role.
1266      */
1267     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1268         _grantRole(role, account);
1269     }
1270 
1271     /**
1272      * @dev Revokes `role` from `account`.
1273      *
1274      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1275      *
1276      * Requirements:
1277      *
1278      * - the caller must have ``role``'s admin role.
1279      */
1280     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1281         _revokeRole(role, account);
1282     }
1283 
1284     /**
1285      * @dev Revokes `role` from the calling account.
1286      *
1287      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1288      * purpose is to provide a mechanism for accounts to lose their privileges
1289      * if they are compromised (such as when a trusted device is misplaced).
1290      *
1291      * If the calling account had been granted `role`, emits a {RoleRevoked}
1292      * event.
1293      *
1294      * Requirements:
1295      *
1296      * - the caller must be `account`.
1297      */
1298     function renounceRole(bytes32 role, address account) public virtual override {
1299         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1300 
1301         _revokeRole(role, account);
1302     }
1303 
1304     /**
1305      * @dev Grants `role` to `account`.
1306      *
1307      * If `account` had not been already granted `role`, emits a {RoleGranted}
1308      * event. Note that unlike {grantRole}, this function doesn't perform any
1309      * checks on the calling account.
1310      *
1311      * [WARNING]
1312      * ====
1313      * This function should only be called from the constructor when setting
1314      * up the initial roles for the system.
1315      *
1316      * Using this function in any other way is effectively circumventing the admin
1317      * system imposed by {AccessControl}.
1318      * ====
1319      */
1320     function _setupRole(bytes32 role, address account) internal virtual {
1321         _grantRole(role, account);
1322     }
1323 
1324     /**
1325      * @dev Sets `adminRole` as ``role``'s admin role.
1326      *
1327      * Emits a {RoleAdminChanged} event.
1328      */
1329     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1330         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1331         _roles[role].adminRole = adminRole;
1332     }
1333 
1334     function _grantRole(bytes32 role, address account) private {
1335         if (!hasRole(role, account)) {
1336             _roles[role].members[account] = true;
1337             emit RoleGranted(role, account, _msgSender());
1338         }
1339     }
1340 
1341     function _revokeRole(bytes32 role, address account) private {
1342         if (hasRole(role, account)) {
1343             _roles[role].members[account] = false;
1344             emit RoleRevoked(role, account, _msgSender());
1345         }
1346     }
1347 }
1348  
1349 /**
1350  * @title Counters
1351  * @author Matt Condon (@shrugs)
1352  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1353  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1354  *
1355  * Include with `using Counters for Counters.Counter;`
1356  */
1357 library Counters {
1358     struct Counter {
1359         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1360         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1361         // this feature: see https://github.com/ethereum/solidity/issues/4637
1362         uint256 _value; // default: 0
1363     }
1364 
1365     function current(Counter storage counter) internal view returns (uint256) {
1366         return counter._value;
1367     }
1368 
1369     function increment(Counter storage counter) internal {
1370         //unchecked {
1371             counter._value += 1;
1372         //}
1373     }
1374 
1375     function decrement(Counter storage counter) internal {
1376         uint256 value = counter._value;
1377         require(value > 0, "Counter: decrement overflow");
1378         //unchecked {
1379             counter._value = value - 1;
1380         //}
1381     }
1382 
1383     function reset(Counter storage counter) internal {
1384         counter._value = 0;
1385     }
1386 }
1387  
1388 /**
1389  * @dev Contract module which provides a basic access control mechanism, where
1390  * there is an account (an owner) that can be granted exclusive access to
1391  * specific functions.
1392  *
1393  * By default, the owner account will be the one that deploys the contract. This
1394  * can later be changed with {transferOwnership}.
1395  *
1396  * This module is used through inheritance. It will make available the modifier
1397  * `onlyOwner`, which can be applied to your functions to restrict their use to
1398  * the owner.
1399  */
1400 abstract contract Ownable {
1401     address private _owner;
1402 
1403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1404 
1405     /**
1406      * @dev Initializes the contract setting the deployer as the initial owner.
1407      */
1408     constructor() {
1409         _setOwner(msg.sender);
1410     }
1411 
1412     /**
1413      * @dev Returns the address of the current owner.
1414      */
1415     function owner() public view virtual returns (address) {
1416         return _owner;
1417     }
1418 
1419     /**
1420      * @dev Throws if called by any account other than the owner.
1421      */
1422     modifier onlyOwner() {
1423         require(owner() == msg.sender, "Ownable: caller is not the owner");
1424         _;
1425     }
1426 
1427     /**
1428      * @dev Leaves the contract without owner. It will not be possible to call
1429      * `onlyOwner` functions anymore. Can only be called by the current owner.
1430      *
1431      * NOTE: Renouncing ownership will leave the contract without an owner,
1432      * thereby removing any functionality that is only available to the owner.
1433      */
1434     function renounceOwnership() public virtual onlyOwner {
1435         _setOwner(address(0));
1436     }
1437 
1438     /**
1439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1440      * Can only be called by the current owner.
1441      */
1442     function transferOwnership(address newOwner) public virtual onlyOwner {
1443         require(newOwner != address(0), "Ownable: new owner is the zero address");
1444         _setOwner(newOwner);
1445     }
1446 
1447     function _setOwner(address newOwner) private {
1448         address oldOwner = _owner;
1449         _owner = newOwner;
1450         emit OwnershipTransferred(oldOwner, newOwner);
1451     }
1452 }
1453  
1454 
1455 contract CrazyBunny is ERC721Enumerable, AccessControl, Ownable {
1456 
1457     using Counters for Counters.Counter;
1458     Counters.Counter private _tokenIds;
1459 
1460     string _baseTokenURI = "https://api.chainbunnies.io/token/";
1461 
1462     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1463 
1464     address public upgradedToAddress = address(0);
1465     uint256 internal _cap = 10000;
1466 
1467 
1468     constructor() ERC721("Crazy Bunny", "CBP")  {
1469         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1470         _setupRole(MINTER_ROLE, _msgSender());
1471     }
1472 
1473     function upgrade(address _upgradedToAddress) public {
1474         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1475         
1476         upgradedToAddress = _upgradedToAddress;
1477     }
1478 
1479     function getCurrentTokenId() public view returns (uint256) {
1480         return _tokenIds.current();
1481     }
1482 
1483     function cap() external view returns (uint256) {
1484         return _cap;
1485     }
1486 
1487     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, AccessControl) returns (bool) {
1488         return super.supportsInterface(interfaceId);
1489     }
1490 
1491     function _baseURI() internal view virtual override returns (string memory) {
1492         return _baseTokenURI;
1493     }
1494 
1495     function setBaseURI(string memory baseURI) public {
1496         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1497 
1498         _baseTokenURI = baseURI;
1499     }
1500 
1501     function mintNextToken(address _mintTo) external returns (bool) {
1502         _tokenIds.increment();
1503 
1504         return mint(_mintTo, _tokenIds.current());
1505     }
1506 
1507     function mint(address _mintTo, uint256 _tokenId) public returns (bool) {
1508         require(address(0) == upgradedToAddress, "Contract has been upgraded to a new address");
1509         require(hasRole(MINTER_ROLE, _msgSender()), "Caller is not a minter");
1510         require(_mintTo != address(0), "ERC721: mint to the zero address");
1511         require(!_exists(_tokenId), "ERC721: token already minted");
1512 
1513         require(_tokenId <= _cap, "Cap reached, maximum 10000 mints possible");
1514         
1515         _safeMint(_mintTo, _tokenId);
1516 
1517         return true;
1518     }
1519 
1520 }