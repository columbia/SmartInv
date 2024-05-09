1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @title ERC721 token receiver interface
171  * @dev Interface for any contract that wants to support safeTransfers
172  * from ERC721 asset contracts.
173  */
174 interface IERC721Receiver {
175     /**
176      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
177      * by `operator` from `from`, this function is called.
178      *
179      * It must return its Solidity selector to confirm the token transfer.
180      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
181      *
182      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
183      */
184     function onERC721Received(
185         address operator,
186         address from,
187         uint256 tokenId,
188         bytes calldata data
189     ) external returns (bytes4);
190 }
191 
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
197  * @dev See https://eips.ethereum.org/EIPS/eip-721
198  */
199 interface IERC721Metadata is IERC721 {
200     /**
201      * @dev Returns the token collection name.
202      */
203     function name() external view returns (string memory);
204 
205     /**
206      * @dev Returns the token collection symbol.
207      */
208     function symbol() external view returns (string memory);
209 
210     /**
211      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
212      */
213     function tokenURI(uint256 tokenId) external view returns (string memory);
214 }
215 
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @dev Collection of functions related to the address type
221  */
222 library Address {
223     /**
224      * @dev Returns true if `account` is a contract.
225      *
226      * [IMPORTANT]
227      * ====
228      * It is unsafe to assume that an address for which this function returns
229      * false is an externally-owned account (EOA) and not a contract.
230      *
231      * Among others, `isContract` will return false for the following
232      * types of addresses:
233      *
234      *  - an externally-owned account
235      *  - a contract in construction
236      *  - an address where a contract will be created
237      *  - an address where a contract lived, but was destroyed
238      * ====
239      */
240     function isContract(address account) internal view returns (bool) {
241         // This method relies on extcodesize, which returns 0 for contracts in
242         // construction, since the code is only stored at the end of the
243         // constructor execution.
244 
245         uint256 size;
246         assembly {
247             size := extcodesize(account)
248         }
249         return size > 0;
250     }
251 
252     /**
253      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
254      * `recipient`, forwarding all available gas and reverting on errors.
255      *
256      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
257      * of certain opcodes, possibly making contracts go over the 2300 gas limit
258      * imposed by `transfer`, making them unable to receive funds via
259      * `transfer`. {sendValue} removes this limitation.
260      *
261      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
262      *
263      * IMPORTANT: because control is transferred to `recipient`, care must be
264      * taken to not create reentrancy vulnerabilities. Consider using
265      * {ReentrancyGuard} or the
266      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
267      */
268     function sendValue(address payable recipient, uint256 amount) internal {
269         require(address(this).balance >= amount, "Address: insufficient balance");
270 
271         (bool success, ) = recipient.call{value: amount}("");
272         require(success, "Address: unable to send value, recipient may have reverted");
273     }
274 
275     /**
276      * @dev Performs a Solidity function call using a low level `call`. A
277      * plain `call` is an unsafe replacement for a function call: use this
278      * function instead.
279      *
280      * If `target` reverts with a revert reason, it is bubbled up by this
281      * function (like regular Solidity function calls).
282      *
283      * Returns the raw returned data. To convert to the expected return value,
284      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
285      *
286      * Requirements:
287      *
288      * - `target` must be a contract.
289      * - calling `target` with `data` must not revert.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
294         return functionCall(target, data, "Address: low-level call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
299      * `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, 0, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but also transferring `value` wei to `target`.
314      *
315      * Requirements:
316      *
317      * - the calling contract must have an ETH balance of at least `value`.
318      * - the called Solidity function must be `payable`.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(
323         address target,
324         bytes memory data,
325         uint256 value
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
332      * with `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         require(address(this).balance >= value, "Address: insufficient balance for call");
343         require(isContract(target), "Address: call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.call{value: value}(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
356         return functionStaticCall(target, data, "Address: low-level static call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal view returns (bytes memory) {
370         require(isContract(target), "Address: static call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.staticcall(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
383         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(isContract(target), "Address: delegate call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.delegatecall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
405      * revert reason using the provided one.
406      *
407      * _Available since v4.3._
408      */
409     function verifyCallResult(
410         bool success,
411         bytes memory returndata,
412         string memory errorMessage
413     ) internal pure returns (bytes memory) {
414         if (success) {
415             return returndata;
416         } else {
417             // Look for revert reason and bubble it up if present
418             if (returndata.length > 0) {
419                 // The easiest way to bubble the revert reason is using memory via assembly
420 
421                 assembly {
422                     let returndata_size := mload(returndata)
423                     revert(add(32, returndata), returndata_size)
424                 }
425             } else {
426                 revert(errorMessage);
427             }
428         }
429     }
430 }
431 
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Provides information about the current execution context, including the
437  * sender of the transaction and its data. While these are generally available
438  * via msg.sender and msg.data, they should not be accessed in such a direct
439  * manner, since when dealing with meta-transactions the account sending and
440  * paying for execution may not be the actual sender (as far as an application
441  * is concerned).
442  *
443  * This contract is only required for intermediate, library-like contracts.
444  */
445 abstract contract Context {
446     function _msgSender() internal view virtual returns (address) {
447         return msg.sender;
448     }
449 
450     function _msgData() internal view virtual returns (bytes calldata) {
451         return msg.data;
452     }
453 }
454 
455 
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev String operations.
461  */
462 library Strings {
463     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
467      */
468     function toString(uint256 value) internal pure returns (string memory) {
469         // Inspired by OraclizeAPI's implementation - MIT licence
470         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
471 
472         if (value == 0) {
473             return "0";
474         }
475         uint256 temp = value;
476         uint256 digits;
477         while (temp != 0) {
478             digits++;
479             temp /= 10;
480         }
481         bytes memory buffer = new bytes(digits);
482         while (value != 0) {
483             digits -= 1;
484             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
485             value /= 10;
486         }
487         return string(buffer);
488     }
489 
490     /**
491      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
492      */
493     function toHexString(uint256 value) internal pure returns (string memory) {
494         if (value == 0) {
495             return "0x00";
496         }
497         uint256 temp = value;
498         uint256 length = 0;
499         while (temp != 0) {
500             length++;
501             temp >>= 8;
502         }
503         return toHexString(value, length);
504     }
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
508      */
509     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
510         bytes memory buffer = new bytes(2 * length + 2);
511         buffer[0] = "0";
512         buffer[1] = "x";
513         for (uint256 i = 2 * length + 1; i > 1; --i) {
514             buffer[i] = _HEX_SYMBOLS[value & 0xf];
515             value >>= 4;
516         }
517         require(value == 0, "Strings: hex length insufficient");
518         return string(buffer);
519     }
520 }
521 
522 
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Implementation of the {IERC165} interface.
528  *
529  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
530  * for the additional interface id that will be supported. For example:
531  *
532  * ```solidity
533  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
534  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
535  * }
536  * ```
537  *
538  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
539  */
540 abstract contract ERC165 is IERC165 {
541     /**
542      * @dev See {IERC165-supportsInterface}.
543      */
544     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545         return interfaceId == type(IERC165).interfaceId;
546     }
547 }
548 
549 
550 pragma solidity ^0.8.0;
551 
552 
553 
554 /**
555  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
556  * the Metadata extension, but not including the Enumerable extension, which is available separately as
557  * {ERC721Enumerable}.
558  */
559 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
560     using Address for address;
561     using Strings for uint256;
562 
563     // Token name
564     string private _name;
565 
566     // Token symbol
567     string private _symbol;
568 
569     // Mapping from token ID to owner address
570     mapping(uint256 => address) private _owners;
571 
572     // Mapping owner address to token count
573     mapping(address => uint256) private _balances;
574 
575     // Mapping from token ID to approved address
576     mapping(uint256 => address) private _tokenApprovals;
577 
578     // Mapping from owner to operator approvals
579     mapping(address => mapping(address => bool)) private _operatorApprovals;
580 
581     /**
582      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
583      */
584     constructor(string memory name_, string memory symbol_) {
585         _name = name_;
586         _symbol = symbol_;
587     }
588 
589     /**
590      * @dev See {IERC165-supportsInterface}.
591      */
592     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
593         return
594             interfaceId == type(IERC721).interfaceId ||
595             interfaceId == type(IERC721Metadata).interfaceId ||
596             super.supportsInterface(interfaceId);
597     }
598 
599     /**
600      * @dev See {IERC721-balanceOf}.
601      */
602     function balanceOf(address owner) public view virtual override returns (uint256) {
603         require(owner != address(0), "ERC721: balance query for the zero address");
604         return _balances[owner];
605     }
606 
607     /**
608      * @dev See {IERC721-ownerOf}.
609      */
610     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
611         address owner = _owners[tokenId];
612         require(owner != address(0), "ERC721: owner query for nonexistent token");
613         return owner;
614     }
615 
616     /**
617      * @dev See {IERC721Metadata-name}.
618      */
619     function name() public view virtual override returns (string memory) {
620         return _name;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-symbol}.
625      */
626     function symbol() public view virtual override returns (string memory) {
627         return _symbol;
628     }
629 
630     /**
631      * @dev See {IERC721Metadata-tokenURI}.
632      */
633     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
634         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
635 
636         string memory baseURI = _baseURI();
637         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
638     }
639 
640     /**
641      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
642      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
643      * by default, can be overriden in child contracts.
644      */
645     function _baseURI() internal view virtual returns (string memory) {
646         return "";
647     }
648 
649     /**
650      * @dev See {IERC721-approve}.
651      */
652     function approve(address to, uint256 tokenId) public virtual override {
653         address owner = ERC721.ownerOf(tokenId);
654         require(to != owner, "ERC721: approval to current owner");
655 
656         require(
657             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
658             "ERC721: approve caller is not owner nor approved for all"
659         );
660 
661         _approve(to, tokenId);
662     }
663 
664     /**
665      * @dev See {IERC721-getApproved}.
666      */
667     function getApproved(uint256 tokenId) public view virtual override returns (address) {
668         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
669 
670         return _tokenApprovals[tokenId];
671     }
672 
673     /**
674      * @dev See {IERC721-setApprovalForAll}.
675      */
676     function setApprovalForAll(address operator, bool approved) public virtual override {
677         _setApprovalForAll(_msgSender(), operator, approved);
678     }
679 
680     /**
681      * @dev See {IERC721-isApprovedForAll}.
682      */
683     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
684         return _operatorApprovals[owner][operator];
685     }
686 
687     /**
688      * @dev See {IERC721-transferFrom}.
689      */
690     function transferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) public virtual override {
695         //solhint-disable-next-line max-line-length
696         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
697 
698         _transfer(from, to, tokenId);
699     }
700 
701     /**
702      * @dev See {IERC721-safeTransferFrom}.
703      */
704     function safeTransferFrom(
705         address from,
706         address to,
707         uint256 tokenId
708     ) public virtual override {
709         safeTransferFrom(from, to, tokenId, "");
710     }
711 
712     /**
713      * @dev See {IERC721-safeTransferFrom}.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes memory _data
720     ) public virtual override {
721         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
722         _safeTransfer(from, to, tokenId, _data);
723     }
724 
725     /**
726      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
727      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
728      *
729      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
730      *
731      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
732      * implement alternative mechanisms to perform token transfer, such as signature-based.
733      *
734      * Requirements:
735      *
736      * - `from` cannot be the zero address.
737      * - `to` cannot be the zero address.
738      * - `tokenId` token must exist and be owned by `from`.
739      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
740      *
741      * Emits a {Transfer} event.
742      */
743     function _safeTransfer(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes memory _data
748     ) internal virtual {
749         _transfer(from, to, tokenId);
750         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
751     }
752 
753     /**
754      * @dev Returns whether `tokenId` exists.
755      *
756      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
757      *
758      * Tokens start existing when they are minted (`_mint`),
759      * and stop existing when they are burned (`_burn`).
760      */
761     function _exists(uint256 tokenId) internal view virtual returns (bool) {
762         return _owners[tokenId] != address(0);
763     }
764 
765     /**
766      * @dev Returns whether `spender` is allowed to manage `tokenId`.
767      *
768      * Requirements:
769      *
770      * - `tokenId` must exist.
771      */
772     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
773         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
774         address owner = ERC721.ownerOf(tokenId);
775         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
776     }
777 
778     /**
779      * @dev Safely mints `tokenId` and transfers it to `to`.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must not exist.
784      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
785      *
786      * Emits a {Transfer} event.
787      */
788     function _safeMint(address to, uint256 tokenId) internal virtual {
789         _safeMint(to, tokenId, "");
790     }
791 
792     /**
793      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
794      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
795      */
796     function _safeMint(
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) internal virtual {
801         _mint(to, tokenId);
802         require(
803             _checkOnERC721Received(address(0), to, tokenId, _data),
804             "ERC721: transfer to non ERC721Receiver implementer"
805         );
806     }
807 
808     /**
809      * @dev Mints `tokenId` and transfers it to `to`.
810      *
811      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
812      *
813      * Requirements:
814      *
815      * - `tokenId` must not exist.
816      * - `to` cannot be the zero address.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _mint(address to, uint256 tokenId) internal virtual {
821         require(to != address(0), "ERC721: mint to the zero address");
822         require(!_exists(tokenId), "ERC721: token already minted");
823 
824         _beforeTokenTransfer(address(0), to, tokenId);
825 
826         _balances[to] += 1;
827         _owners[tokenId] = to;
828 
829         emit Transfer(address(0), to, tokenId);
830     }
831 
832     /**
833      * @dev Destroys `tokenId`.
834      * The approval is cleared when the token is burned.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _burn(uint256 tokenId) internal virtual {
843         address owner = ERC721.ownerOf(tokenId);
844 
845         _beforeTokenTransfer(owner, address(0), tokenId);
846 
847         // Clear approvals
848         _approve(address(0), tokenId);
849 
850         _balances[owner] -= 1;
851         delete _owners[tokenId];
852 
853         emit Transfer(owner, address(0), tokenId);
854     }
855 
856     /**
857      * @dev Transfers `tokenId` from `from` to `to`.
858      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
859      *
860      * Requirements:
861      *
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must be owned by `from`.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _transfer(
868         address from,
869         address to,
870         uint256 tokenId
871     ) internal virtual {
872         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
873         require(to != address(0), "ERC721: transfer to the zero address");
874 
875         _beforeTokenTransfer(from, to, tokenId);
876 
877         // Clear approvals from the previous owner
878         _approve(address(0), tokenId);
879 
880         _balances[from] -= 1;
881         _balances[to] += 1;
882         _owners[tokenId] = to;
883 
884         emit Transfer(from, to, tokenId);
885     }
886 
887     /**
888      * @dev Approve `to` to operate on `tokenId`
889      *
890      * Emits a {Approval} event.
891      */
892     function _approve(address to, uint256 tokenId) internal virtual {
893         _tokenApprovals[tokenId] = to;
894         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
895     }
896 
897     /**
898      * @dev Approve `operator` to operate on all of `owner` tokens
899      *
900      * Emits a {ApprovalForAll} event.
901      */
902     function _setApprovalForAll(
903         address owner,
904         address operator,
905         bool approved
906     ) internal virtual {
907         require(owner != operator, "ERC721: approve to caller");
908         _operatorApprovals[owner][operator] = approved;
909         emit ApprovalForAll(owner, operator, approved);
910     }
911 
912     /**
913      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
914      * The call is not executed if the target address is not a contract.
915      *
916      * @param from address representing the previous owner of the given token ID
917      * @param to target address that will receive the tokens
918      * @param tokenId uint256 ID of the token to be transferred
919      * @param _data bytes optional data to send along with the call
920      * @return bool whether the call correctly returned the expected magic value
921      */
922     function _checkOnERC721Received(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) private returns (bool) {
928         if (to.isContract()) {
929             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
930                 return retval == IERC721Receiver.onERC721Received.selector;
931             } catch (bytes memory reason) {
932                 if (reason.length == 0) {
933                     revert("ERC721: transfer to non ERC721Receiver implementer");
934                 } else {
935                     assembly {
936                         revert(add(32, reason), mload(reason))
937                     }
938                 }
939             }
940         } else {
941             return true;
942         }
943     }
944 
945     /**
946      * @dev Hook that is called before any token transfer. This includes minting
947      * and burning.
948      *
949      * Calling conditions:
950      *
951      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
952      * transferred to `to`.
953      * - When `from` is zero, `tokenId` will be minted for `to`.
954      * - When `to` is zero, ``from``'s `tokenId` will be burned.
955      * - `from` and `to` are never both zero.
956      *
957      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
958      */
959     function _beforeTokenTransfer(
960         address from,
961         address to,
962         uint256 tokenId
963     ) internal virtual {}
964 }
965 
966 
967 pragma solidity ^0.8.0;
968 
969 /**
970  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
971  * @dev See https://eips.ethereum.org/EIPS/eip-721
972  */
973 interface IERC721Enumerable is IERC721 {
974     /**
975      * @dev Returns the total amount of tokens stored by the contract.
976      */
977     function totalSupply() external view returns (uint256);
978 
979     /**
980      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
981      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
982      */
983     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
984 
985     /**
986      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
987      * Use along with {totalSupply} to enumerate all tokens.
988      */
989     function tokenByIndex(uint256 index) external view returns (uint256);
990 }
991 
992 
993 pragma solidity ^0.8.0;
994 
995 
996 /**
997  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
998  * enumerability of all the token ids in the contract as well as all token ids owned by each
999  * account.
1000  */
1001 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1002     // Mapping from owner to list of owned token IDs
1003     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1004 
1005     // Mapping from token ID to index of the owner tokens list
1006     mapping(uint256 => uint256) private _ownedTokensIndex;
1007 
1008     // Array with all token ids, used for enumeration
1009     uint256[] private _allTokens;
1010 
1011     // Mapping from token id to position in the allTokens array
1012     mapping(uint256 => uint256) private _allTokensIndex;
1013 
1014     /**
1015      * @dev See {IERC165-supportsInterface}.
1016      */
1017     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1018         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1023      */
1024     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1025         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1026         return _ownedTokens[owner][index];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Enumerable-totalSupply}.
1031      */
1032     function totalSupply() public view virtual override returns (uint256) {
1033         return _allTokens.length;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-tokenByIndex}.
1038      */
1039     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1040         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1041         return _allTokens[index];
1042     }
1043 
1044     /**
1045      * @dev Hook that is called before any token transfer. This includes minting
1046      * and burning.
1047      *
1048      * Calling conditions:
1049      *
1050      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1051      * transferred to `to`.
1052      * - When `from` is zero, `tokenId` will be minted for `to`.
1053      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1054      * - `from` cannot be the zero address.
1055      * - `to` cannot be the zero address.
1056      *
1057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1058      */
1059     function _beforeTokenTransfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual override {
1064         super._beforeTokenTransfer(from, to, tokenId);
1065 
1066         if (from == address(0)) {
1067             _addTokenToAllTokensEnumeration(tokenId);
1068         } else if (from != to) {
1069             _removeTokenFromOwnerEnumeration(from, tokenId);
1070         }
1071         if (to == address(0)) {
1072             _removeTokenFromAllTokensEnumeration(tokenId);
1073         } else if (to != from) {
1074             _addTokenToOwnerEnumeration(to, tokenId);
1075         }
1076     }
1077 
1078     /**
1079      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1080      * @param to address representing the new owner of the given token ID
1081      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1082      */
1083     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1084         uint256 length = ERC721.balanceOf(to);
1085         _ownedTokens[to][length] = tokenId;
1086         _ownedTokensIndex[tokenId] = length;
1087     }
1088 
1089     /**
1090      * @dev Private function to add a token to this extension's token tracking data structures.
1091      * @param tokenId uint256 ID of the token to be added to the tokens list
1092      */
1093     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1094         _allTokensIndex[tokenId] = _allTokens.length;
1095         _allTokens.push(tokenId);
1096     }
1097 
1098     /**
1099      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1100      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1101      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1102      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1103      * @param from address representing the previous owner of the given token ID
1104      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1105      */
1106     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1107         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1108         // then delete the last slot (swap and pop).
1109 
1110         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1111         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1112 
1113         // When the token to delete is the last token, the swap operation is unnecessary
1114         if (tokenIndex != lastTokenIndex) {
1115             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1116 
1117             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1118             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1119         }
1120 
1121         // This also deletes the contents at the last position of the array
1122         delete _ownedTokensIndex[tokenId];
1123         delete _ownedTokens[from][lastTokenIndex];
1124     }
1125 
1126     /**
1127      * @dev Private function to remove a token from this extension's token tracking data structures.
1128      * This has O(1) time complexity, but alters the order of the _allTokens array.
1129      * @param tokenId uint256 ID of the token to be removed from the tokens list
1130      */
1131     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1132         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1133         // then delete the last slot (swap and pop).
1134 
1135         uint256 lastTokenIndex = _allTokens.length - 1;
1136         uint256 tokenIndex = _allTokensIndex[tokenId];
1137 
1138         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1139         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1140         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1141         uint256 lastTokenId = _allTokens[lastTokenIndex];
1142 
1143         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1144         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1145 
1146         // This also deletes the contents at the last position of the array
1147         delete _allTokensIndex[tokenId];
1148         _allTokens.pop();
1149     }
1150 }
1151 
1152 
1153 pragma solidity ^0.8.0;
1154 
1155 /**
1156  * @dev Contract module which provides a basic access control mechanism, where
1157  * there is an account (an owner) that can be granted exclusive access to
1158  * specific functions.
1159  *
1160  * By default, the owner account will be the one that deploys the contract. This
1161  * can later be changed with {transferOwnership}.
1162  *
1163  * This module is used through inheritance. It will make available the modifier
1164  * `onlyOwner`, which can be applied to your functions to restrict their use to
1165  * the owner.
1166  */
1167 abstract contract Ownable is Context {
1168     address private _owner;
1169 
1170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1171 
1172     /**
1173      * @dev Initializes the contract setting the deployer as the initial owner.
1174      */
1175     constructor() {
1176         _transferOwnership(_msgSender());
1177     }
1178 
1179     /**
1180      * @dev Returns the address of the current owner.
1181      */
1182     function owner() public view virtual returns (address) {
1183         return _owner;
1184     }
1185 
1186     /**
1187      * @dev Throws if called by any account other than the owner.
1188      */
1189     modifier onlyOwner() {
1190         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1191         _;
1192     }
1193 
1194     /**
1195      * @dev Leaves the contract without owner. It will not be possible to call
1196      * `onlyOwner` functions anymore. Can only be called by the current owner.
1197      *
1198      * NOTE: Renouncing ownership will leave the contract without an owner,
1199      * thereby removing any functionality that is only available to the owner.
1200      */
1201     function renounceOwnership() public virtual onlyOwner {
1202         _transferOwnership(address(0));
1203     }
1204 
1205     /**
1206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1207      * Can only be called by the current owner.
1208      */
1209     function transferOwnership(address newOwner) public virtual onlyOwner {
1210         require(newOwner != address(0), "Ownable: new owner is the zero address");
1211         _transferOwnership(newOwner);
1212     }
1213 
1214     /**
1215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1216      * Internal function without access restriction.
1217      */
1218     function _transferOwnership(address newOwner) internal virtual {
1219         address oldOwner = _owner;
1220         _owner = newOwner;
1221         emit OwnershipTransferred(oldOwner, newOwner);
1222     }
1223 }
1224 
1225 
1226 pragma solidity ^0.8.2;
1227 
1228 contract GreenHomies is ERC721, ERC721Enumerable, Ownable {
1229     uint16 private greenyIndex = 0;
1230     bool public active = false;
1231     bool public activeBooth = false;
1232     string public baseURIextended;
1233     mapping(uint256 => string) public greenyBg;
1234     mapping(uint256 => string) public greenyName;
1235     mapping (address => uint) public giveaway;
1236     
1237     constructor() ERC721("GreenHomies", "GH") {}
1238 
1239     function contractURI() public view returns (string memory)
1240     {
1241         return string(abi.encodePacked(_baseURI(), "contract"));
1242     }
1243 
1244 
1245     // Mise à jour de l'url de base
1246     // @param string url - Url de base pour tous les tokens
1247     function setBaseURI(string memory url) public onlyOwner()
1248     {
1249         baseURIextended = url;
1250     }
1251  
1252 
1253     // Retourne l'url de base
1254     // @return string     
1255     function _baseURI() internal view override returns (string memory)
1256     {
1257         return baseURIextended;
1258     }
1259 
1260 
1261     // Mise à jour de la vente pour la stoper ou non 
1262     function changeActive() public onlyOwner
1263     {
1264         active = !active;
1265     }
1266 
1267 
1268     // Mise à jour de la Booth Machine pour la stoper ou non
1269     function changeBoothActive() public onlyOwner {
1270         activeBooth = !activeBooth;
1271     }
1272 
1273 
1274     // Retourne la liste des tokens d'une personne
1275     // @param address recipient - Address du wallet de la personne
1276     // @return array uint - Retourne un tableau de tokens   
1277     function tokensOfOwner(address recipient) public view returns (uint256[] memory)
1278     {
1279         uint256 tokenCount = balanceOf(recipient);
1280         
1281         if (tokenCount == 0) {
1282             return new uint256[](0);
1283         } else {
1284             uint256[] memory result = new uint256[](tokenCount);
1285             for (uint256 index; index < tokenCount; index++) {
1286                 result[index] = tokenOfOwnerByIndex(recipient, index);
1287             }
1288             return result;
1289         }
1290     }
1291 
1292 
1293     // Définit le prix de la transaction, hors frais
1294     // @param uint quantity - Quantité de tokens à mint
1295     // @return uint - Retourne le prix en wei    
1296     function getPrice(uint quantity) public view returns (uint256)
1297     {
1298         uint256 price = 0.015 ether;
1299         
1300         if(greenyIndex >= 500 && greenyIndex < 1000) {
1301             price = 0.025 ether;
1302         } else if(greenyIndex >= 1000 && greenyIndex < 1500) {
1303             price = 0.035 ether;
1304         } else if(greenyIndex >= 1500 && greenyIndex < 2000) {
1305             price = 0.045 ether;
1306         } else if(greenyIndex >= 2000 && greenyIndex < 2500) {
1307             price = 0.055 ether;
1308         } else if(greenyIndex >= 2500 && greenyIndex < 3000) {
1309             price = 0.065 ether;
1310         } else if(greenyIndex >= 3000) {
1311             price = 0.075 ether;
1312         } 
1313 
1314         price = price * quantity;
1315 
1316         return price;
1317     }
1318 
1319 
1320     // Mint le token si les conditions sont remplies
1321     // @param uint quantity - Nombre de token à mint
1322     function checkNFT(uint quantity) public payable
1323     {
1324         require(active,                                         "The sale must be active to allow this action.");
1325         require(quantity <= 5,                                  "Can only mint 5 tokens at a time.");
1326         require(msg.value >= getPrice(quantity),                "Please, send the correct amount.");
1327 
1328         for (uint256 index = 0; index < quantity; index++) {
1329             _safeMint(msg.sender, greenyIndex);
1330             greenyIndex++;
1331         }
1332     }
1333 
1334 
1335     // Mint le token pour un membre listé sur le giveaway
1336     function giveawayNFT() public
1337     {
1338         require(active,                                         "The sale must be active to allow this action.");
1339         require(giveaway[msg.sender] > 0,                       "You must be in the giveaway list to have a free greeny.");
1340         require(msg.sender == tx.origin,                        "You must be the direct owner to buy a greeny.");
1341 
1342         uint256 qty = giveaway[msg.sender];
1343 
1344         for (uint256 index = 0; index < qty; index++) {
1345             _safeMint(msg.sender, greenyIndex);
1346             greenyIndex++;
1347         }
1348 
1349         giveaway[msg.sender] = 0;
1350     }
1351 
1352 
1353     // Fusionne 2 Greenies entre eux
1354     // @param uint firstTokenId - Premier token à burn
1355     // @param uint secondTokenId - Second token à burn
1356     // @param string name - Nom du greeny
1357     // @param string bg - Fond qui sera appliqué
1358     function mixGreenies(uint256 firstTokenId, uint256 secondTokenId, string memory name, string memory bg) public
1359     {
1360         require(msg.sender == ownerOf(firstTokenId),            "You are not the owner of this token. Bad Guy.");
1361         require(msg.sender == ownerOf(secondTokenId),           "This is not your token. Bad Guy.");
1362         require(activeBooth,                                    "The Booth must be active to allow this action.");
1363 
1364         runBooth(firstTokenId, name, bg);
1365         _burn(secondTokenId);
1366     }
1367 
1368    
1369     // Défini le nom associé à un NFT et son bg
1370     // @param uint tokenId - Numéro du token
1371     // @param string name - Nom du greeny
1372     // @param string bg - Nom du background
1373     function runBooth(uint256 tokenId, string memory name, string memory bg) public {
1374         require(activeBooth,                                   "The Booth must be active to allow this action.");
1375         require(msg.sender == ownerOf(tokenId),                "You are not the owner of this token. Bad Guy.");
1376         greenyName[tokenId] = name;
1377         greenyBg[tokenId] = bg;
1378     }
1379     
1380     // Vérifier si le greeny a déjà été minté ou non
1381     // @param unit tokenId - Numéro du token
1382     // @return bool
1383     function greenyExists(uint256 tokenId) public view returns (bool)
1384     {
1385         return _exists(tokenId);
1386     }
1387 
1388 
1389     // Retourne le nom du greeny
1390     // @param unit tokenId - Numéro du token
1391     // @return string
1392     function getName(uint256 tokenId) public view returns (string memory) {
1393         return greenyName[tokenId];
1394     }
1395 
1396 
1397     // Vérifier si un greeny existe déjà
1398     // @param unit tokenId - Numéro du token
1399     // @return bool
1400     function checkName(string memory name) public view returns (bool) {
1401         for (uint256 index; index < greenyIndex; index++) {
1402             if(keccak256(bytes(greenyName[index])) == keccak256(bytes(name))) {
1403                 return true;
1404             }
1405         }
1406         return false;
1407     }
1408 
1409 
1410     // Retourne le fond attribué à un greeny
1411     // @param unit tokenId - Numéro du token
1412     // @return bool
1413     function getBackground(uint256 tokenId) public view returns (string memory)
1414     {
1415         return greenyBg[tokenId];
1416     }
1417 
1418 
1419     // Ajoute une personne aux giveaays
1420     // @param array of address wallet - Adresse du wallet
1421     function setGiveaway(address[] memory wallets) public onlyOwner
1422     {
1423         for (uint256 index; index < wallets.length; index++) {
1424             giveaway[wallets[index]]++;
1425         }
1426     }
1427  
1428     
1429     // Transfère de fonds vers le compte propriétaire ou autre
1430     // @param address recipient - Adresse où transférer les fonds
1431     function withdraw(address payable recipient) public onlyOwner
1432     {
1433         uint256 balance = address(this).balance;
1434         recipient.transfer(balance);
1435     }
1436     
1437 
1438     // Depuis la version > 0.8 de solidity et la version 4 de openzeppelin
1439     // Il est nécessaire d'override certaines fonctions
1440     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable)
1441     {
1442         require(active,                                         "The sale must be active to allow this action.");
1443         super._beforeTokenTransfer(from, to, tokenId);
1444     }
1445 
1446     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool)
1447     {
1448         return super.supportsInterface(interfaceId);
1449     }
1450 }