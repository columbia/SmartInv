1 // SPDX-License-Identifier: MIT
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
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
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
185 /**
186  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
187  * @dev See https://eips.ethereum.org/EIPS/eip-721
188  */
189 interface IERC721Metadata is IERC721 {
190     /**
191      * @dev Returns the token collection name.
192      */
193     function name() external view returns (string memory);
194 
195     /**
196      * @dev Returns the token collection symbol.
197      */
198     function symbol() external view returns (string memory);
199 
200     /**
201      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
202      */
203     function tokenURI(uint256 tokenId) external view returns (string memory);
204 }
205 /**
206  * @dev Collection of functions related to the address type
207  */
208 library Address {
209     /**
210      * @dev Returns true if `account` is a contract.
211      *
212      * [IMPORTANT]
213      * ====
214      * It is unsafe to assume that an address for which this function returns
215      * false is an externally-owned account (EOA) and not a contract.
216      *
217      * Among others, `isContract` will return false for the following
218      * types of addresses:
219      *
220      *  - an externally-owned account
221      *  - a contract in construction
222      *  - an address where a contract will be created
223      *  - an address where a contract lived, but was destroyed
224      * ====
225      */
226     function isContract(address account) internal view returns (bool) {
227         // This method relies on extcodesize, which returns 0 for contracts in
228         // construction, since the code is only stored at the end of the
229         // constructor execution.
230 
231         uint256 size;
232         assembly {
233             size := extcodesize(account)
234         }
235         return size > 0;
236     }
237 
238     /**
239      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
240      * `recipient`, forwarding all available gas and reverting on errors.
241      *
242      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
243      * of certain opcodes, possibly making contracts go over the 2300 gas limit
244      * imposed by `transfer`, making them unable to receive funds via
245      * `transfer`. {sendValue} removes this limitation.
246      *
247      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
248      *
249      * IMPORTANT: because control is transferred to `recipient`, care must be
250      * taken to not create reentrancy vulnerabilities. Consider using
251      * {ReentrancyGuard} or the
252      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
253      */
254     function sendValue(address payable recipient, uint256 amount) internal {
255         require(address(this).balance >= amount, "Address: insufficient balance");
256 
257         (bool success, ) = recipient.call{value: amount}("");
258         require(success, "Address: unable to send value, recipient may have reverted");
259     }
260 
261     /**
262      * @dev Performs a Solidity function call using a low level `call`. A
263      * plain `call` is an unsafe replacement for a function call: use this
264      * function instead.
265      *
266      * If `target` reverts with a revert reason, it is bubbled up by this
267      * function (like regular Solidity function calls).
268      *
269      * Returns the raw returned data. To convert to the expected return value,
270      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
271      *
272      * Requirements:
273      *
274      * - `target` must be a contract.
275      * - calling `target` with `data` must not revert.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
280         return functionCall(target, data, "Address: low-level call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
285      * `errorMessage` as a fallback revert reason when `target` reverts.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, 0, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but also transferring `value` wei to `target`.
300      *
301      * Requirements:
302      *
303      * - the calling contract must have an ETH balance of at least `value`.
304      * - the called Solidity function must be `payable`.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value
312     ) internal returns (bytes memory) {
313         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
318      * with `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(
323         address target,
324         bytes memory data,
325         uint256 value,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(address(this).balance >= value, "Address: insufficient balance for call");
329         require(isContract(target), "Address: call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.call{value: value}(data);
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
342         return functionStaticCall(target, data, "Address: low-level static call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal view returns (bytes memory) {
356         require(isContract(target), "Address: static call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.staticcall(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
369         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
374      * but performing a delegate call.
375      *
376      * _Available since v3.4._
377      */
378     function functionDelegateCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(isContract(target), "Address: delegate call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.delegatecall(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
391      * revert reason using the provided one.
392      *
393      * _Available since v4.3._
394      */
395     function verifyCallResult(
396         bool success,
397         bytes memory returndata,
398         string memory errorMessage
399     ) internal pure returns (bytes memory) {
400         if (success) {
401             return returndata;
402         } else {
403             // Look for revert reason and bubble it up if present
404             if (returndata.length > 0) {
405                 // The easiest way to bubble the revert reason is using memory via assembly
406 
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 /**
418  * @dev Provides information about the current execution context, including the
419  * sender of the transaction and its data. While these are generally available
420  * via msg.sender and msg.data, they should not be accessed in such a direct
421  * manner, since when dealing with meta-transactions the account sending and
422  * paying for execution may not be the actual sender (as far as an application
423  * is concerned).
424  *
425  * This contract is only required for intermediate, library-like contracts.
426  */
427 abstract contract Context {
428     function _msgSender() internal view virtual returns (address) {
429         return msg.sender;
430     }
431 
432     function _msgData() internal view virtual returns (bytes calldata) {
433         return msg.data;
434     }
435 }
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
521 /**
522  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
523  * the Metadata extension, but not including the Enumerable extension, which is available separately as
524  * {ERC721Enumerable}.
525  */
526 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
527     using Address for address;
528     using Strings for uint256;
529 
530     // Token name
531     string private _name;
532 
533     // Token symbol
534     string private _symbol;
535 
536     // Mapping from token ID to owner address
537     mapping(uint256 => address) private _owners;
538 
539     // Mapping owner address to token count
540     mapping(address => uint256) private _balances;
541 
542     // Mapping from token ID to approved address
543     mapping(uint256 => address) private _tokenApprovals;
544 
545     // Mapping from owner to operator approvals
546     mapping(address => mapping(address => bool)) private _operatorApprovals;
547 
548     /**
549      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
550      */
551     constructor(string memory name_, string memory symbol_) {
552         _name = name_;
553         _symbol = symbol_;
554     }
555 
556     /**
557      * @dev See {IERC165-supportsInterface}.
558      */
559     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
560         return
561             interfaceId == type(IERC721).interfaceId ||
562             interfaceId == type(IERC721Metadata).interfaceId ||
563             super.supportsInterface(interfaceId);
564     }
565 
566     /**
567      * @dev See {IERC721-balanceOf}.
568      */
569     function balanceOf(address owner) public view virtual override returns (uint256) {
570         require(owner != address(0), "ERC721: balance query for the zero address");
571         return _balances[owner];
572     }
573 
574     /**
575      * @dev See {IERC721-ownerOf}.
576      */
577     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
578         address owner = _owners[tokenId];
579         require(owner != address(0), "ERC721: owner query for nonexistent token");
580         return owner;
581     }
582 
583     /**
584      * @dev See {IERC721Metadata-name}.
585      */
586     function name() public view virtual override returns (string memory) {
587         return _name;
588     }
589 
590     /**
591      * @dev See {IERC721Metadata-symbol}.
592      */
593     function symbol() public view virtual override returns (string memory) {
594         return _symbol;
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-tokenURI}.
599      */
600     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
601         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
602 
603         string memory baseURI = _baseURI();
604         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
605     }
606 
607     /**
608      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
609      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
610      * by default, can be overriden in child contracts.
611      */
612     function _baseURI() internal view virtual returns (string memory) {
613         return "";
614     }
615 
616     /**
617      * @dev See {IERC721-approve}.
618      */
619     function approve(address to, uint256 tokenId) public virtual override {
620         address owner = ERC721.ownerOf(tokenId);
621         require(to != owner, "ERC721: approval to current owner");
622 
623         require(
624             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
625             "ERC721: approve caller is not owner nor approved for all"
626         );
627 
628         _approve(to, tokenId);
629     }
630 
631     /**
632      * @dev See {IERC721-getApproved}.
633      */
634     function getApproved(uint256 tokenId) public view virtual override returns (address) {
635         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
636 
637         return _tokenApprovals[tokenId];
638     }
639 
640     /**
641      * @dev See {IERC721-setApprovalForAll}.
642      */
643     function setApprovalForAll(address operator, bool approved) public virtual override {
644         _setApprovalForAll(_msgSender(), operator, approved);
645     }
646 
647     /**
648      * @dev See {IERC721-isApprovedForAll}.
649      */
650     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
651         return _operatorApprovals[owner][operator];
652     }
653 
654     /**
655      * @dev See {IERC721-transferFrom}.
656      */
657     function transferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) public virtual override {
662         //solhint-disable-next-line max-line-length
663         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
664 
665         _transfer(from, to, tokenId);
666     }
667 
668     /**
669      * @dev See {IERC721-safeTransferFrom}.
670      */
671     function safeTransferFrom(
672         address from,
673         address to,
674         uint256 tokenId
675     ) public virtual override {
676         safeTransferFrom(from, to, tokenId, "");
677     }
678 
679     /**
680      * @dev See {IERC721-safeTransferFrom}.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId,
686         bytes memory _data
687     ) public virtual override {
688         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
689         _safeTransfer(from, to, tokenId, _data);
690     }
691 
692     /**
693      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
694      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
695      *
696      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
697      *
698      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
699      * implement alternative mechanisms to perform token transfer, such as signature-based.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must exist and be owned by `from`.
706      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
707      *
708      * Emits a {Transfer} event.
709      */
710     function _safeTransfer(
711         address from,
712         address to,
713         uint256 tokenId,
714         bytes memory _data
715     ) internal virtual {
716         _transfer(from, to, tokenId);
717         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
718     }
719 
720     /**
721      * @dev Returns whether `tokenId` exists.
722      *
723      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
724      *
725      * Tokens start existing when they are minted (`_mint`),
726      * and stop existing when they are burned (`_burn`).
727      */
728     function _exists(uint256 tokenId) internal view virtual returns (bool) {
729         return _owners[tokenId] != address(0);
730     }
731 
732     /**
733      * @dev Returns whether `spender` is allowed to manage `tokenId`.
734      *
735      * Requirements:
736      *
737      * - `tokenId` must exist.
738      */
739     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
740         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
741         address owner = ERC721.ownerOf(tokenId);
742         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
743     }
744 
745     /**
746      * @dev Safely mints `tokenId` and transfers it to `to`.
747      *
748      * Requirements:
749      *
750      * - `tokenId` must not exist.
751      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
752      *
753      * Emits a {Transfer} event.
754      */
755     function _safeMint(address to, uint256 tokenId) internal virtual {
756         _safeMint(to, tokenId, "");
757     }
758 
759     /**
760      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
761      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
762      */
763     function _safeMint(
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) internal virtual {
768         _mint(to, tokenId);
769         require(
770             _checkOnERC721Received(address(0), to, tokenId, _data),
771             "ERC721: transfer to non ERC721Receiver implementer"
772         );
773     }
774 
775     /**
776      * @dev Mints `tokenId` and transfers it to `to`.
777      *
778      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
779      *
780      * Requirements:
781      *
782      * - `tokenId` must not exist.
783      * - `to` cannot be the zero address.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _mint(address to, uint256 tokenId) internal virtual {
788         require(to != address(0), "ERC721: mint to the zero address");
789         require(!_exists(tokenId), "ERC721: token already minted");
790 
791         _beforeTokenTransfer(address(0), to, tokenId);
792 
793         _balances[to] += 1;
794         _owners[tokenId] = to;
795 
796         emit Transfer(address(0), to, tokenId);
797     }
798 
799     /**
800      * @dev Destroys `tokenId`.
801      * The approval is cleared when the token is burned.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _burn(uint256 tokenId) internal virtual {
810         address owner = ERC721.ownerOf(tokenId);
811 
812         _beforeTokenTransfer(owner, address(0), tokenId);
813 
814         // Clear approvals
815         _approve(address(0), tokenId);
816 
817         _balances[owner] -= 1;
818         delete _owners[tokenId];
819 
820         emit Transfer(owner, address(0), tokenId);
821     }
822 
823     /**
824      * @dev Transfers `tokenId` from `from` to `to`.
825      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
826      *
827      * Requirements:
828      *
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must be owned by `from`.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _transfer(
835         address from,
836         address to,
837         uint256 tokenId
838     ) internal virtual {
839         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
840         require(to != address(0), "ERC721: transfer to the zero address");
841 
842         _beforeTokenTransfer(from, to, tokenId);
843 
844         // Clear approvals from the previous owner
845         _approve(address(0), tokenId);
846 
847         _balances[from] -= 1;
848         _balances[to] += 1;
849         _owners[tokenId] = to;
850 
851         emit Transfer(from, to, tokenId);
852     }
853 
854     /**
855      * @dev Approve `to` to operate on `tokenId`
856      *
857      * Emits a {Approval} event.
858      */
859     function _approve(address to, uint256 tokenId) internal virtual {
860         _tokenApprovals[tokenId] = to;
861         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
862     }
863 
864     /**
865      * @dev Approve `operator` to operate on all of `owner` tokens
866      *
867      * Emits a {ApprovalForAll} event.
868      */
869     function _setApprovalForAll(
870         address owner,
871         address operator,
872         bool approved
873     ) internal virtual {
874         require(owner != operator, "ERC721: approve to caller");
875         _operatorApprovals[owner][operator] = approved;
876         emit ApprovalForAll(owner, operator, approved);
877     }
878 
879     /**
880      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
881      * The call is not executed if the target address is not a contract.
882      *
883      * @param from address representing the previous owner of the given token ID
884      * @param to target address that will receive the tokens
885      * @param tokenId uint256 ID of the token to be transferred
886      * @param _data bytes optional data to send along with the call
887      * @return bool whether the call correctly returned the expected magic value
888      */
889     function _checkOnERC721Received(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) private returns (bool) {
895         if (to.isContract()) {
896             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
897                 return retval == IERC721Receiver.onERC721Received.selector;
898             } catch (bytes memory reason) {
899                 if (reason.length == 0) {
900                     revert("ERC721: transfer to non ERC721Receiver implementer");
901                 } else {
902                     assembly {
903                         revert(add(32, reason), mload(reason))
904                     }
905                 }
906             }
907         } else {
908             return true;
909         }
910     }
911 
912     /**
913      * @dev Hook that is called before any token transfer. This includes minting
914      * and burning.
915      *
916      * Calling conditions:
917      *
918      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
919      * transferred to `to`.
920      * - When `from` is zero, `tokenId` will be minted for `to`.
921      * - When `to` is zero, ``from``'s `tokenId` will be burned.
922      * - `from` and `to` are never both zero.
923      *
924      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
925      */
926     function _beforeTokenTransfer(
927         address from,
928         address to,
929         uint256 tokenId
930     ) internal virtual {}
931 }
932 /**
933  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
934  * @dev See https://eips.ethereum.org/EIPS/eip-721
935  */
936 interface IERC721Enumerable is IERC721 {
937     /**
938      * @dev Returns the total amount of tokens stored by the contract.
939      */
940     function totalSupply() external view returns (uint256);
941 
942     /**
943      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
944      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
945      */
946     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
947 
948     /**
949      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
950      * Use along with {totalSupply} to enumerate all tokens.
951      */
952     function tokenByIndex(uint256 index) external view returns (uint256);
953 }
954 
955 /**
956  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
957  * enumerability of all the token ids in the contract as well as all token ids owned by each
958  * account.
959  */
960 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
961     // Mapping from owner to list of owned token IDs
962     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
963 
964     // Mapping from token ID to index of the owner tokens list
965     mapping(uint256 => uint256) private _ownedTokensIndex;
966 
967     // Array with all token ids, used for enumeration
968     uint256[] private _allTokens;
969 
970     // Mapping from token id to position in the allTokens array
971     mapping(uint256 => uint256) private _allTokensIndex;
972 
973     /**
974      * @dev See {IERC165-supportsInterface}.
975      */
976     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
977         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
978     }
979 
980     /**
981      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
982      */
983     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
984         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
985         return _ownedTokens[owner][index];
986     }
987 
988     /**
989      * @dev See {IERC721Enumerable-totalSupply}.
990      */
991     function totalSupply() public view virtual override returns (uint256) {
992         return _allTokens.length;
993     }
994 
995     /**
996      * @dev See {IERC721Enumerable-tokenByIndex}.
997      */
998     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
999         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1000         return _allTokens[index];
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before any token transfer. This includes minting
1005      * and burning.
1006      *
1007      * Calling conditions:
1008      *
1009      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1010      * transferred to `to`.
1011      * - When `from` is zero, `tokenId` will be minted for `to`.
1012      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1013      * - `from` cannot be the zero address.
1014      * - `to` cannot be the zero address.
1015      *
1016      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1017      */
1018     function _beforeTokenTransfer(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) internal virtual override {
1023         super._beforeTokenTransfer(from, to, tokenId);
1024 
1025         if (from == address(0)) {
1026             _addTokenToAllTokensEnumeration(tokenId);
1027         } else if (from != to) {
1028             _removeTokenFromOwnerEnumeration(from, tokenId);
1029         }
1030         if (to == address(0)) {
1031             _removeTokenFromAllTokensEnumeration(tokenId);
1032         } else if (to != from) {
1033             _addTokenToOwnerEnumeration(to, tokenId);
1034         }
1035     }
1036 
1037     /**
1038      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1039      * @param to address representing the new owner of the given token ID
1040      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1041      */
1042     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1043         uint256 length = ERC721.balanceOf(to);
1044         _ownedTokens[to][length] = tokenId;
1045         _ownedTokensIndex[tokenId] = length;
1046     }
1047 
1048     /**
1049      * @dev Private function to add a token to this extension's token tracking data structures.
1050      * @param tokenId uint256 ID of the token to be added to the tokens list
1051      */
1052     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1053         _allTokensIndex[tokenId] = _allTokens.length;
1054         _allTokens.push(tokenId);
1055     }
1056 
1057     /**
1058      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1059      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1060      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1061      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1062      * @param from address representing the previous owner of the given token ID
1063      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1064      */
1065     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1066         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1067         // then delete the last slot (swap and pop).
1068 
1069         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1070         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1071 
1072         // When the token to delete is the last token, the swap operation is unnecessary
1073         if (tokenIndex != lastTokenIndex) {
1074             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1075 
1076             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1077             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1078         }
1079 
1080         // This also deletes the contents at the last position of the array
1081         delete _ownedTokensIndex[tokenId];
1082         delete _ownedTokens[from][lastTokenIndex];
1083     }
1084 
1085     /**
1086      * @dev Private function to remove a token from this extension's token tracking data structures.
1087      * This has O(1) time complexity, but alters the order of the _allTokens array.
1088      * @param tokenId uint256 ID of the token to be removed from the tokens list
1089      */
1090     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1091         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1092         // then delete the last slot (swap and pop).
1093 
1094         uint256 lastTokenIndex = _allTokens.length - 1;
1095         uint256 tokenIndex = _allTokensIndex[tokenId];
1096 
1097         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1098         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1099         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1100         uint256 lastTokenId = _allTokens[lastTokenIndex];
1101 
1102         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1103         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1104 
1105         // This also deletes the contents at the last position of the array
1106         delete _allTokensIndex[tokenId];
1107         _allTokens.pop();
1108     }
1109 }
1110 /**
1111  * @dev Contract module which provides a basic access control mechanism, where
1112  * there is an account (an owner) that can be granted exclusive access to
1113  * specific functions.
1114  *
1115  * By default, the owner account will be the one that deploys the contract. This
1116  * can later be changed with {transferOwnership}.
1117  *
1118  * This module is used through inheritance. It will make available the modifier
1119  * `onlyOwner`, which can be applied to your functions to restrict their use to
1120  * the owner.
1121  */
1122 abstract contract Ownable is Context {
1123     address private _owner;
1124 
1125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1126 
1127     /**
1128      * @dev Initializes the contract setting the deployer as the initial owner.
1129      */
1130     constructor() {
1131         _transferOwnership(_msgSender());
1132     }
1133 
1134     /**
1135      * @dev Returns the address of the current owner.
1136      */
1137     function owner() public view virtual returns (address) {
1138         return _owner;
1139     }
1140 
1141     /**
1142      * @dev Throws if called by any account other than the owner.
1143      */
1144     modifier onlyOwner() {
1145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1146         _;
1147     }
1148 
1149     /**
1150      * @dev Leaves the contract without owner. It will not be possible to call
1151      * `onlyOwner` functions anymore. Can only be called by the current owner.
1152      *
1153      * NOTE: Renouncing ownership will leave the contract without an owner,
1154      * thereby removing any functionality that is only available to the owner.
1155      */
1156     function renounceOwnership() public virtual onlyOwner {
1157         _transferOwnership(address(0));
1158     }
1159 
1160     /**
1161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1162      * Can only be called by the current owner.
1163      */
1164     function transferOwnership(address newOwner) public virtual onlyOwner {
1165         require(newOwner != address(0), "Ownable: new owner is the zero address");
1166         _transferOwnership(newOwner);
1167     }
1168 
1169     /**
1170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1171      * Internal function without access restriction.
1172      */
1173     function _transferOwnership(address newOwner) internal virtual {
1174         address oldOwner = _owner;
1175         _owner = newOwner;
1176         emit OwnershipTransferred(oldOwner, newOwner);
1177     }
1178 }
1179 
1180 contract NomNoms is ERC721Enumerable, Ownable {
1181   using Strings for uint256;
1182 
1183   string public baseURI;
1184   string public baseExtension = ".json";
1185   string public notRevealedUri;
1186   uint256 public cost = 0.1 ether;
1187   uint256 public softCap = 555; //Genesis Nom Noms, use this to pause contract then change prices to sell regular Nom Noms
1188   uint256 public maxSupply = 5555;
1189   uint256 public maxMintAmount = 2;
1190   uint256 public nftPerAddressLimit = 2;
1191   bool public paused = false;
1192   bool public revealed = false;
1193   bool public onlyWhitelisted = true;
1194   address[] public whitelistedAddresses;
1195   mapping(address => uint256) public addressMintedBalance;
1196 
1197 
1198   constructor(
1199     string memory _name,
1200     string memory _symbol,
1201     string memory _initBaseURI,
1202     string memory _initNotRevealedUri
1203   ) ERC721(_name, _symbol) {
1204     setBaseURI(_initBaseURI);
1205     setNotRevealedURI(_initNotRevealedUri);
1206   }
1207 
1208   // internal
1209   function _baseURI() internal view virtual override returns (string memory) {
1210     return baseURI;
1211   }
1212 
1213   // public
1214   function mint(uint256 _mintAmount) public payable {
1215     require(!paused, "the contract is paused");
1216     uint256 supply = totalSupply();
1217     require(_mintAmount > 0, "need to mint at least 1 NFT");
1218     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1219     require(supply + _mintAmount <= softCap, "max NFT limit exceeded");
1220     if (msg.sender != owner()) {
1221         if(onlyWhitelisted == true) {
1222             require(isWhitelisted(msg.sender), "user is not whitelisted");
1223             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1224             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1225         }
1226         require(msg.value >= cost * _mintAmount, "insufficient funds");
1227     }
1228     
1229     for (uint256 i = 1; i <= _mintAmount; i++) {
1230         addressMintedBalance[msg.sender]++;
1231       _safeMint(msg.sender, supply + i);
1232     }
1233   }
1234   
1235   function isWhitelisted(address _user) public view returns (bool) {
1236     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1237       if (whitelistedAddresses[i] == _user) {
1238           return true;
1239       }
1240     }
1241     return false;
1242   }
1243 
1244   function walletOfOwner(address _owner)
1245     public
1246     view
1247     returns (uint256[] memory)
1248   {
1249     uint256 ownerTokenCount = balanceOf(_owner);
1250     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1251     for (uint256 i; i < ownerTokenCount; i++) {
1252       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1253     }
1254     return tokenIds;
1255   }
1256 
1257   function tokenURI(uint256 tokenId)
1258     public
1259     view
1260     virtual
1261     override
1262     returns (string memory)
1263   {
1264     require(
1265       _exists(tokenId),
1266       "ERC721Metadata: URI query for nonexistent token"
1267     );
1268     
1269     if(revealed == false) {
1270         return notRevealedUri;
1271     }
1272 
1273     string memory currentBaseURI = _baseURI();
1274     return bytes(currentBaseURI).length > 0
1275         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1276         : "";
1277   }
1278 
1279   //only owner
1280   function reveal() public onlyOwner() {
1281       revealed = true;
1282   }
1283   
1284   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1285     nftPerAddressLimit = _limit;
1286   }
1287   
1288   function setCost(uint256 _newCost) public onlyOwner() {
1289     cost = _newCost;
1290   }
1291   
1292   function setSoftCap(uint256 _newSoftCap) public onlyOwner() {
1293     require(_newSoftCap <= maxSupply); //IMPORTANT! ensures that softCap cannoher go over the maxSupply.
1294     softCap = _newSoftCap;
1295   }
1296 
1297   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1298     maxMintAmount = _newmaxMintAmount;
1299   }
1300 
1301   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1302     baseURI = _newBaseURI;
1303   }
1304 
1305   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1306     baseExtension = _newBaseExtension;
1307   }
1308   
1309   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1310     notRevealedUri = _notRevealedURI;
1311   }
1312 
1313   function pause(bool _state) public onlyOwner {
1314     paused = _state;
1315   }
1316   
1317   function setOnlyWhitelisted(bool _state) public onlyOwner {
1318     onlyWhitelisted = _state;
1319   }
1320   
1321   function whitelistUsers(address[] calldata _users) public onlyOwner {
1322     delete whitelistedAddresses;
1323     whitelistedAddresses = _users;
1324   }
1325  
1326   function withdraw() public payable onlyOwner {
1327     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1328     require(success);
1329   }
1330 }