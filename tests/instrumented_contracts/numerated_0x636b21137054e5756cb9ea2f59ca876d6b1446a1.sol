1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
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
61      * @dev Safely transfers `tokenId` token from `from` to `to`.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId,
77         bytes calldata data
78     ) external;
79 
80     /**
81      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
82      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must exist and be owned by `from`.
89      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
90      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
91      *
92      * Emits a {Transfer} event.
93      */
94     function safeTransferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Transfers `tokenId` token from `from` to `to`.
102      *
103      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must be owned by `from`.
110      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(
115         address from,
116         address to,
117         uint256 tokenId
118     ) external;
119 
120     /**
121      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
122      * The approval is cleared when the token is transferred.
123      *
124      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
125      *
126      * Requirements:
127      *
128      * - The caller must own the token or be an approved operator.
129      * - `tokenId` must exist.
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address to, uint256 tokenId) external;
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
148      * @dev Returns the account approved for `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function getApproved(uint256 tokenId) external view returns (address operator);
155 
156     /**
157      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
158      *
159      * See {setApprovalForAll}
160      */
161     function isApprovedForAll(address owner, address operator) external view returns (bool);
162 }
163 
164 /**
165  * @title ERC721 token receiver interface
166  * @dev Interface for any contract that wants to support safeTransfers
167  * from ERC721 asset contracts.
168  */
169 interface IERC721Receiver {
170     /**
171      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
172      * by `operator` from `from`, this function is called.
173      *
174      * It must return its Solidity selector to confirm the token transfer.
175      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
176      *
177      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
178      */
179     function onERC721Received(
180         address operator,
181         address from,
182         uint256 tokenId,
183         bytes calldata data
184     ) external returns (bytes4);
185 }
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
228      *
229      * [IMPORTANT]
230      * ====
231      * You shouldn't rely on `isContract` to protect against flash loan attacks!
232      *
233      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
234      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
235      * constructor.
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize/address.code.length, which returns 0
240         // for contracts in construction, since the code is only stored at the end
241         // of the constructor execution.
242 
243         return account.code.length > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         (bool success, ) = recipient.call{value: amount}("");
266         require(success, "Address: unable to send value, recipient may have reverted");
267     }
268 
269     /**
270      * @dev Performs a Solidity function call using a low level `call`. A
271      * plain `call` is an unsafe replacement for a function call: use this
272      * function instead.
273      *
274      * If `target` reverts with a revert reason, it is bubbled up by this
275      * function (like regular Solidity function calls).
276      *
277      * Returns the raw returned data. To convert to the expected return value,
278      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
279      *
280      * Requirements:
281      *
282      * - `target` must be a contract.
283      * - calling `target` with `data` must not revert.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionCall(target, data, "Address: low-level call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
293      * `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
326      * with `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         require(isContract(target), "Address: call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.call{value: value}(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
350         return functionStaticCall(target, data, "Address: low-level static call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal view returns (bytes memory) {
364         require(isContract(target), "Address: static call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.staticcall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
399      * revert reason using the provided one.
400      *
401      * _Available since v4.3._
402      */
403     function verifyCallResult(
404         bool success,
405         bytes memory returndata,
406         string memory errorMessage
407     ) internal pure returns (bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414 
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 /**
427  * @dev Provides information about the current execution context, including the
428  * sender of the transaction and its data. While these are generally available
429  * via msg.sender and msg.data, they should not be accessed in such a direct
430  * manner, since when dealing with meta-transactions the account sending and
431  * paying for execution may not be the actual sender (as far as an application
432  * is concerned).
433  *
434  * This contract is only required for intermediate, library-like contracts.
435  */
436 abstract contract Context {
437     function _msgSender() internal view virtual returns (address) {
438         return msg.sender;
439     }
440 
441     function _msgData() internal view virtual returns (bytes calldata) {
442         return msg.data;
443     }
444 }
445 
446 /**
447  * @dev String operations.
448  */
449 library Strings {
450     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
451 
452     /**
453      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
454      */
455     function toString(uint256 value) internal pure returns (string memory) {
456         // Inspired by OraclizeAPI's implementation - MIT licence
457         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
458 
459         if (value == 0) {
460             return "0";
461         }
462         uint256 temp = value;
463         uint256 digits;
464         while (temp != 0) {
465             digits++;
466             temp /= 10;
467         }
468         bytes memory buffer = new bytes(digits);
469         while (value != 0) {
470             digits -= 1;
471             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
472             value /= 10;
473         }
474         return string(buffer);
475     }
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
479      */
480     function toHexString(uint256 value) internal pure returns (string memory) {
481         if (value == 0) {
482             return "0x00";
483         }
484         uint256 temp = value;
485         uint256 length = 0;
486         while (temp != 0) {
487             length++;
488             temp >>= 8;
489         }
490         return toHexString(value, length);
491     }
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
495      */
496     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
497         bytes memory buffer = new bytes(2 * length + 2);
498         buffer[0] = "0";
499         buffer[1] = "x";
500         for (uint256 i = 2 * length + 1; i > 1; --i) {
501             buffer[i] = _HEX_SYMBOLS[value & 0xf];
502             value >>= 4;
503         }
504         require(value == 0, "Strings: hex length insufficient");
505         return string(buffer);
506     }
507 }
508 
509 /**
510  * @dev Implementation of the {IERC165} interface.
511  *
512  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
513  * for the additional interface id that will be supported. For example:
514  *
515  * ```solidity
516  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
518  * }
519  * ```
520  *
521  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
522  */
523 abstract contract ERC165 is IERC165 {
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528         return interfaceId == type(IERC165).interfaceId;
529     }
530 }
531 
532 /**
533  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
534  * the Metadata extension, but not including the Enumerable extension, which is available separately as
535  * {ERC721Enumerable}.
536  */
537 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
538     using Address for address;
539     using Strings for uint256;
540 
541     // Token name
542     string private _name;
543 
544     // Token symbol
545     string private _symbol;
546 
547     // Mapping from token ID to owner address
548     mapping(uint256 => address) private _owners;
549 
550     // Mapping owner address to token count
551     mapping(address => uint256) private _balances;
552 
553     // Mapping from token ID to approved address
554     mapping(uint256 => address) private _tokenApprovals;
555 
556     // Mapping from owner to operator approvals
557     mapping(address => mapping(address => bool)) private _operatorApprovals;
558 
559     /**
560      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
561      */
562     constructor(string memory name_, string memory symbol_) {
563         _name = name_;
564         _symbol = symbol_;
565     }
566 
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      */
570     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
571         return
572             interfaceId == type(IERC721).interfaceId ||
573             interfaceId == type(IERC721Metadata).interfaceId ||
574             super.supportsInterface(interfaceId);
575     }
576 
577     /**
578      * @dev See {IERC721-balanceOf}.
579      */
580     function balanceOf(address owner) public view virtual override returns (uint256) {
581         require(owner != address(0), "ERC721: address zero is not a valid owner");
582         return _balances[owner];
583     }
584 
585     /**
586      * @dev See {IERC721-ownerOf}.
587      */
588     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
589         address owner = _owners[tokenId];
590         require(owner != address(0), "ERC721: owner query for nonexistent token");
591         return owner;
592     }
593 
594     /**
595      * @dev See {IERC721Metadata-name}.
596      */
597     function name() public view virtual override returns (string memory) {
598         return _name;
599     }
600 
601     /**
602      * @dev See {IERC721Metadata-symbol}.
603      */
604     function symbol() public view virtual override returns (string memory) {
605         return _symbol;
606     }
607 
608     /**
609      * @dev See {IERC721Metadata-tokenURI}.
610      */
611     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
612         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
613 
614         string memory baseURI = _baseURI();
615         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
616     }
617 
618     /**
619      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
620      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
621      * by default, can be overridden in child contracts.
622      */
623     function _baseURI() internal view virtual returns (string memory) {
624         return "";
625     }
626 
627     /**
628      * @dev See {IERC721-approve}.
629      */
630     function approve(address to, uint256 tokenId) public virtual override {
631         address owner = ERC721.ownerOf(tokenId);
632         require(to != owner, "ERC721: approval to current owner");
633 
634         require(
635             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
636             "ERC721: approve caller is not owner nor approved for all"
637         );
638 
639         _approve(to, tokenId);
640     }
641 
642     /**
643      * @dev See {IERC721-getApproved}.
644      */
645     function getApproved(uint256 tokenId) public view virtual override returns (address) {
646         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
647 
648         return _tokenApprovals[tokenId];
649     }
650 
651     /**
652      * @dev See {IERC721-setApprovalForAll}.
653      */
654     function setApprovalForAll(address operator, bool approved) public virtual override {
655         _setApprovalForAll(_msgSender(), operator, approved);
656     }
657 
658     /**
659      * @dev See {IERC721-isApprovedForAll}.
660      */
661     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
662         return _operatorApprovals[owner][operator];
663     }
664 
665     /**
666      * @dev See {IERC721-transferFrom}.
667      */
668     function transferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) public virtual override {
673         //solhint-disable-next-line max-line-length
674         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
675 
676         _transfer(from, to, tokenId);
677     }
678 
679     /**
680      * @dev See {IERC721-safeTransferFrom}.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) public virtual override {
687         safeTransferFrom(from, to, tokenId, "");
688     }
689 
690     /**
691      * @dev See {IERC721-safeTransferFrom}.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId,
697         bytes memory _data
698     ) public virtual override {
699         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
700         _safeTransfer(from, to, tokenId, _data);
701     }
702 
703     /**
704      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
705      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
706      *
707      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
708      *
709      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
710      * implement alternative mechanisms to perform token transfer, such as signature-based.
711      *
712      * Requirements:
713      *
714      * - `from` cannot be the zero address.
715      * - `to` cannot be the zero address.
716      * - `tokenId` token must exist and be owned by `from`.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function _safeTransfer(
722         address from,
723         address to,
724         uint256 tokenId,
725         bytes memory _data
726     ) internal virtual {
727         _transfer(from, to, tokenId);
728         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
729     }
730 
731     /**
732      * @dev Returns whether `tokenId` exists.
733      *
734      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
735      *
736      * Tokens start existing when they are minted (`_mint`),
737      * and stop existing when they are burned (`_burn`).
738      */
739     function _exists(uint256 tokenId) internal view virtual returns (bool) {
740         return _owners[tokenId] != address(0);
741     }
742 
743     /**
744      * @dev Returns whether `spender` is allowed to manage `tokenId`.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
751         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
752         address owner = ERC721.ownerOf(tokenId);
753         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
754     }
755 
756     /**
757      * @dev Safely mints `tokenId` and transfers it to `to`.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must not exist.
762      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
763      *
764      * Emits a {Transfer} event.
765      */
766     function _safeMint(address to, uint256 tokenId) internal virtual {
767         _safeMint(to, tokenId, "");
768     }
769 
770     /**
771      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
772      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
773      */
774     function _safeMint(
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) internal virtual {
779         _mint(to, tokenId);
780         require(
781             _checkOnERC721Received(address(0), to, tokenId, _data),
782             "ERC721: transfer to non ERC721Receiver implementer"
783         );
784     }
785 
786     /**
787      * @dev Mints `tokenId` and transfers it to `to`.
788      *
789      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
790      *
791      * Requirements:
792      *
793      * - `tokenId` must not exist.
794      * - `to` cannot be the zero address.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _mint(address to, uint256 tokenId) internal virtual {
799         require(to != address(0), "ERC721: mint to the zero address");
800         require(!_exists(tokenId), "ERC721: token already minted");
801 
802         _beforeTokenTransfer(address(0), to, tokenId);
803 
804         _balances[to] += 1;
805         _owners[tokenId] = to;
806 
807         emit Transfer(address(0), to, tokenId);
808 
809         _afterTokenTransfer(address(0), to, tokenId);
810     }
811 
812     /**
813      * @dev Destroys `tokenId`.
814      * The approval is cleared when the token is burned.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _burn(uint256 tokenId) internal virtual {
823         address owner = ERC721.ownerOf(tokenId);
824 
825         _beforeTokenTransfer(owner, address(0), tokenId);
826 
827         // Clear approvals
828         _approve(address(0), tokenId);
829 
830         _balances[owner] -= 1;
831         delete _owners[tokenId];
832 
833         emit Transfer(owner, address(0), tokenId);
834 
835         _afterTokenTransfer(owner, address(0), tokenId);
836     }
837 
838     /**
839      * @dev Transfers `tokenId` from `from` to `to`.
840      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
841      *
842      * Requirements:
843      *
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must be owned by `from`.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _transfer(
850         address from,
851         address to,
852         uint256 tokenId
853     ) internal virtual {
854         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
855         require(to != address(0), "ERC721: transfer to the zero address");
856 
857         _beforeTokenTransfer(from, to, tokenId);
858 
859         // Clear approvals from the previous owner
860         _approve(address(0), tokenId);
861 
862         _balances[from] -= 1;
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(from, to, tokenId);
867 
868         _afterTokenTransfer(from, to, tokenId);
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
882      * @dev Approve `operator` to operate on all of `owner` tokens
883      *
884      * Emits a {ApprovalForAll} event.
885      */
886     function _setApprovalForAll(
887         address owner,
888         address operator,
889         bool approved
890     ) internal virtual {
891         require(owner != operator, "ERC721: approve to caller");
892         _operatorApprovals[owner][operator] = approved;
893         emit ApprovalForAll(owner, operator, approved);
894     }
895 
896     /**
897      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
898      * The call is not executed if the target address is not a contract.
899      *
900      * @param from address representing the previous owner of the given token ID
901      * @param to target address that will receive the tokens
902      * @param tokenId uint256 ID of the token to be transferred
903      * @param _data bytes optional data to send along with the call
904      * @return bool whether the call correctly returned the expected magic value
905      */
906     function _checkOnERC721Received(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) private returns (bool) {
912         if (to.isContract()) {
913             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
914                 return retval == IERC721Receiver.onERC721Received.selector;
915             } catch (bytes memory reason) {
916                 if (reason.length == 0) {
917                     revert("ERC721: transfer to non ERC721Receiver implementer");
918                 } else {
919                     assembly {
920                         revert(add(32, reason), mload(reason))
921                     }
922                 }
923             }
924         } else {
925             return true;
926         }
927     }
928 
929     /**
930      * @dev Hook that is called before any token transfer. This includes minting
931      * and burning.
932      *
933      * Calling conditions:
934      *
935      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
936      * transferred to `to`.
937      * - When `from` is zero, `tokenId` will be minted for `to`.
938      * - When `to` is zero, ``from``'s `tokenId` will be burned.
939      * - `from` and `to` are never both zero.
940      *
941      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
942      */
943     function _beforeTokenTransfer(
944         address from,
945         address to,
946         uint256 tokenId
947     ) internal virtual {}
948 
949     /**
950      * @dev Hook that is called after any transfer of tokens. This includes
951      * minting and burning.
952      *
953      * Calling conditions:
954      *
955      * - when `from` and `to` are both non-zero.
956      * - `from` and `to` are never both zero.
957      *
958      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
959      */
960     function _afterTokenTransfer(
961         address from,
962         address to,
963         uint256 tokenId
964     ) internal virtual {}
965 }
966 
967 library BytesLibrary {
968     function toString(bytes32 value) internal pure returns (string memory) {
969         bytes memory alphabet = "0123456789abcdef";
970         bytes memory str = new bytes(64);
971         for (uint256 i = 0; i < 32; i++) {
972             str[i*2] = alphabet[uint8(value[i] >> 4)];
973             str[1+i*2] = alphabet[uint8(value[i] & 0x0f)];
974         }
975         return string(str);
976     }
977 }
978 
979 /**
980  * @dev Contract module which provides a basic access control mechanism, where
981  * there is an account (an owner) that can be granted exclusive access to
982  * specific functions.
983  *
984  * By default, the owner account will be the one that deploys the contract. This
985  * can later be changed with {transferOwnership}.
986  *
987  * This module is used through inheritance. It will make available the modifier
988  * `onlyOwner`, which can be applied to your functions to restrict their use to
989  * the owner.
990  */
991 abstract contract Ownable is Context {
992     address private _owner;
993 
994     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
995 
996     /**
997      * @dev Initializes the contract setting the deployer as the initial owner.
998      */
999     constructor() {
1000         _setOwner(_msgSender());
1001     }
1002 
1003     /**
1004      * @dev Returns the address of the current owner.
1005      */
1006     function owner() public view virtual returns (address) {
1007         return _owner;
1008     }
1009 
1010     /**
1011      * @dev Throws if called by any account other than the owner.
1012      */
1013     modifier onlyOwner() {
1014         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1015         _;
1016     }
1017 
1018     /**
1019      * @dev Leaves the contract without owner. It will not be possible to call
1020      * `onlyOwner` functions anymore. Can only be called by the current owner.
1021      *
1022      * NOTE: Renouncing ownership will leave the contract without an owner,
1023      * thereby removing any functionality that is only available to the owner.
1024      */
1025     function renounceOwnership() public virtual onlyOwner {
1026         _setOwner(address(0));
1027     }
1028 
1029     /**
1030      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1031      * Can only be called by the current owner.
1032      */
1033     function transferOwnership(address newOwner) public virtual onlyOwner {
1034         require(newOwner != address(0), "Ownable: new owner is the zero address");
1035         _setOwner(newOwner);
1036     }
1037 
1038     function _setOwner(address newOwner) private {
1039         address oldOwner = _owner;
1040         _owner = newOwner;
1041         emit OwnershipTransferred(oldOwner, newOwner);
1042     }
1043 }
1044 
1045 abstract contract Pausable is Ownable {
1046     bool private _paused;
1047 
1048     event PauseStatus(bool isPause);
1049 
1050     constructor() {
1051         _paused = false;
1052     }
1053 
1054     function paused() public view virtual returns (bool) {
1055         return _paused;
1056     }
1057 
1058     function pause() external onlyOwner {
1059         _paused = true;
1060         emit PauseStatus(_paused);
1061     }
1062 
1063     function unpause() external onlyOwner {
1064         _paused = false;
1065         emit PauseStatus(_paused);
1066     }
1067 }
1068 
1069 abstract contract DenyList is Ownable {
1070     mapping(address => bool) private _denyList;
1071 
1072     event DenyListChanged(address indexed target, bool isAdded, bool isRemoved);
1073 
1074     function addDenyList(address target_) external onlyOwner {
1075         _denyList[target_] = true;
1076         emit DenyListChanged(target_, true, false);
1077     }
1078 
1079     function removeDenyList(address target_) external onlyOwner {
1080         _denyList[target_] = false;
1081         emit DenyListChanged(target_, false, true);
1082     }
1083 
1084     function isDenied(address target_) public view virtual returns (bool) {
1085         return _denyList[target_];
1086     }
1087 }
1088 
1089 contract NFToken721 is Ownable, Pausable, DenyList, ERC721 {
1090     using BytesLibrary for bytes32;
1091 
1092     address public minter;
1093     string public tokenURIPrefix;
1094 
1095     constructor(string memory name_, string memory symbol_, address minter_, string memory tokenURIPrefix_) ERC721(name_, symbol_) {
1096         minter = minter_;
1097         tokenURIPrefix = tokenURIPrefix_;
1098     }
1099 
1100     modifier onlyMinter() {
1101         require(minter == _msgSender(), "caller is not the minter");
1102         _;
1103     }
1104 
1105     function setMinter(address minter_) external onlyOwner {
1106         minter = minter_;
1107     }
1108 
1109     function setTokenURIPrefix(string memory tokenURIPrefix_) external onlyOwner {
1110         tokenURIPrefix = tokenURIPrefix_;
1111     }
1112 
1113     function _baseURI() internal view override returns (string memory) {
1114         return tokenURIPrefix;
1115     }
1116 
1117     function mintTokenByMinter(address recipient, uint256 tokenId_) public onlyMinter {
1118         _safeMint(recipient, tokenId_);
1119     }
1120 
1121     function _beforeTokenTransfer(address from, address to, uint256) internal view override {
1122         if (from != address(0) && to != address(0)) {
1123             require(!paused(), "ERC721: transfer paused");
1124         }
1125         require(!isDenied(from), "ERC721: denied transfer source address");
1126         require(!isDenied(to), "ERC721: denied transfer destination address");
1127     }
1128 }