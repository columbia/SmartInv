1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
28 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
63      * @dev Safely transfers `tokenId` token from `from` to `to`.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId,
79         bytes calldata data
80     ) external;
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Transfers `tokenId` token from `from` to `to`.
104      *
105      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must be owned by `from`.
112      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
124      * The approval is cleared when the token is transferred.
125      *
126      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
127      *
128      * Requirements:
129      *
130      * - The caller must own the token or be an approved operator.
131      * - `tokenId` must exist.
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Approve or remove `operator` as an operator for the caller.
139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
140      *
141      * Requirements:
142      *
143      * - The `operator` cannot be the caller.
144      *
145      * Emits an {ApprovalForAll} event.
146      */
147     function setApprovalForAll(address operator, bool _approved) external;
148 
149     /**
150      * @dev Returns the account approved for `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function getApproved(uint256 tokenId) external view returns (address operator);
157 
158     /**
159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
160      *
161      * See {setApprovalForAll}
162      */
163     function isApprovedForAll(address owner, address operator) external view returns (bool);
164 }
165 
166 
167 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
168 /**
169  * @title ERC721 token receiver interface
170  * @dev Interface for any contract that wants to support safeTransfers
171  * from ERC721 asset contracts.
172  */
173 interface IERC721Receiver {
174     /**
175      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
176      * by `operator` from `from`, this function is called.
177      *
178      * It must return its Solidity selector to confirm the token transfer.
179      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
180      *
181      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
182      */
183     function onERC721Received(
184         address operator,
185         address from,
186         uint256 tokenId,
187         bytes calldata data
188     ) external returns (bytes4);
189 }
190 
191 
192 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
195  * @dev See https://eips.ethereum.org/EIPS/eip-721
196  */
197 interface IERC721Metadata is IERC721 {
198     /**
199      * @dev Returns the token collection name.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the token collection symbol.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
210      */
211     function tokenURI(uint256 tokenId) external view returns (string memory);
212 }
213 
214 
215 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
216 /**
217  * @dev Collection of functions related to the address type
218  */
219 library Address {
220     /**
221      * @dev Returns true if `account` is a contract.
222      *
223      * [IMPORTANT]
224      * ====
225      * It is unsafe to assume that an address for which this function returns
226      * false is an externally-owned account (EOA) and not a contract.
227      *
228      * Among others, `isContract` will return false for the following
229      * types of addresses:
230      *
231      *  - an externally-owned account
232      *  - a contract in construction
233      *  - an address where a contract will be created
234      *  - an address where a contract lived, but was destroyed
235      * ====
236      *
237      * [IMPORTANT]
238      * ====
239      * You shouldn't rely on `isContract` to protect against flash loan attacks!
240      *
241      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
242      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
243      * constructor.
244      * ====
245      */
246     function isContract(address account) internal view returns (bool) {
247         // This method relies on extcodesize/address.code.length, which returns 0
248         // for contracts in construction, since the code is only stored at the end
249         // of the constructor execution.
250 
251         return account.code.length > 0;
252     }
253 
254     /**
255      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
256      * `recipient`, forwarding all available gas and reverting on errors.
257      *
258      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
259      * of certain opcodes, possibly making contracts go over the 2300 gas limit
260      * imposed by `transfer`, making them unable to receive funds via
261      * `transfer`. {sendValue} removes this limitation.
262      *
263      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
264      *
265      * IMPORTANT: because control is transferred to `recipient`, care must be
266      * taken to not create reentrancy vulnerabilities. Consider using
267      * {ReentrancyGuard} or the
268      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
269      */
270     function sendValue(address payable recipient, uint256 amount) internal {
271         require(address(this).balance >= amount, "Address: insufficient balance");
272 
273         (bool success, ) = recipient.call{value: amount}("");
274         require(success, "Address: unable to send value, recipient may have reverted");
275     }
276 
277     /**
278      * @dev Performs a Solidity function call using a low level `call`. A
279      * plain `call` is an unsafe replacement for a function call: use this
280      * function instead.
281      *
282      * If `target` reverts with a revert reason, it is bubbled up by this
283      * function (like regular Solidity function calls).
284      *
285      * Returns the raw returned data. To convert to the expected return value,
286      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
287      *
288      * Requirements:
289      *
290      * - `target` must be a contract.
291      * - calling `target` with `data` must not revert.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionCall(target, data, "Address: low-level call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
301      * `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but also transferring `value` wei to `target`.
316      *
317      * Requirements:
318      *
319      * - the calling contract must have an ETH balance of at least `value`.
320      * - the called Solidity function must be `payable`.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
334      * with `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         require(isContract(target), "Address: call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.call{value: value}(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
358         return functionStaticCall(target, data, "Address: low-level static call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal view returns (bytes memory) {
372         require(isContract(target), "Address: static call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.staticcall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(isContract(target), "Address: delegate call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.delegatecall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
407      * revert reason using the provided one.
408      *
409      * _Available since v4.3._
410      */
411     function verifyCallResult(
412         bool success,
413         bytes memory returndata,
414         string memory errorMessage
415     ) internal pure returns (bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
436 /**
437  * @dev Provides information about the current execution context, including the
438  * sender of the transaction and its data. While these are generally available
439  * via msg.sender and msg.data, they should not be accessed in such a direct
440  * manner, since when dealing with meta-transactions the account sending and
441  * paying for execution may not be the actual sender (as far as an application
442  * is concerned).
443  *
444  * This contract is only required for intermediate, library-like contracts.
445  */
446 abstract contract Context {
447     function _msgSender() internal view virtual returns (address) {
448         return msg.sender;
449     }
450 
451     function _msgData() internal view virtual returns (bytes calldata) {
452         return msg.data;
453     }
454 }
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
458 /**
459  * @dev String operations.
460  */
461 library Strings {
462     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
463 
464     /**
465      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
466      */
467     function toString(uint256 value) internal pure returns (string memory) {
468         // Inspired by OraclizeAPI's implementation - MIT licence
469         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
470 
471         if (value == 0) {
472             return "0";
473         }
474         uint256 temp = value;
475         uint256 digits;
476         while (temp != 0) {
477             digits++;
478             temp /= 10;
479         }
480         bytes memory buffer = new bytes(digits);
481         while (value != 0) {
482             digits -= 1;
483             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
484             value /= 10;
485         }
486         return string(buffer);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
491      */
492     function toHexString(uint256 value) internal pure returns (string memory) {
493         if (value == 0) {
494             return "0x00";
495         }
496         uint256 temp = value;
497         uint256 length = 0;
498         while (temp != 0) {
499             length++;
500             temp >>= 8;
501         }
502         return toHexString(value, length);
503     }
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
507      */
508     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
509         bytes memory buffer = new bytes(2 * length + 2);
510         buffer[0] = "0";
511         buffer[1] = "x";
512         for (uint256 i = 2 * length + 1; i > 1; --i) {
513             buffer[i] = _HEX_SYMBOLS[value & 0xf];
514             value >>= 4;
515         }
516         require(value == 0, "Strings: hex length insufficient");
517         return string(buffer);
518     }
519 }
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
523 /**
524  * @dev Implementation of the {IERC165} interface.
525  *
526  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
527  * for the additional interface id that will be supported. For example:
528  *
529  * ```solidity
530  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
532  * }
533  * ```
534  *
535  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
536  */
537 abstract contract ERC165 is IERC165 {
538     /**
539      * @dev See {IERC165-supportsInterface}.
540      */
541     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542         return interfaceId == type(IERC165).interfaceId;
543     }
544 }
545 
546 
547 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
548 /**
549  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
550  * the Metadata extension, but not including the Enumerable extension, which is available separately as
551  * {ERC721Enumerable}.
552  */
553 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
554     using Address for address;
555     using Strings for uint256;
556 
557     // Token name
558     string private _name;
559 
560     // Token symbol
561     string private _symbol;
562 
563     // Mapping from token ID to owner address
564     mapping(uint256 => address) private _owners;
565 
566     // Mapping owner address to token count
567     mapping(address => uint256) private _balances;
568 
569     // Mapping from token ID to approved address
570     mapping(uint256 => address) private _tokenApprovals;
571 
572     // Mapping from owner to operator approvals
573     mapping(address => mapping(address => bool)) private _operatorApprovals;
574 
575     /**
576      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
577      */
578     constructor(string memory name_, string memory symbol_) {
579         _name = name_;
580         _symbol = symbol_;
581     }
582 
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
587         return
588             interfaceId == type(IERC721).interfaceId ||
589             interfaceId == type(IERC721Metadata).interfaceId ||
590             super.supportsInterface(interfaceId);
591     }
592 
593     /**
594      * @dev See {IERC721-balanceOf}.
595      */
596     function balanceOf(address owner) public view virtual override returns (uint256) {
597         require(owner != address(0), "ERC721: balance query for the zero address");
598         return _balances[owner];
599     }
600 
601     /**
602      * @dev See {IERC721-ownerOf}.
603      */
604     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
605         address owner = _owners[tokenId];
606         require(owner != address(0), "ERC721: owner query for nonexistent token");
607         return owner;
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-name}.
612      */
613     function name() public view virtual override returns (string memory) {
614         return _name;
615     }
616 
617     /**
618      * @dev See {IERC721Metadata-symbol}.
619      */
620     function symbol() public view virtual override returns (string memory) {
621         return _symbol;
622     }
623 
624     /**
625      * @dev See {IERC721Metadata-tokenURI}.
626      */
627     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
628         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
629 
630         string memory baseURI = _baseURI();
631         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
632     }
633 
634     /**
635      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
636      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
637      * by default, can be overridden in child contracts.
638      */
639     function _baseURI() internal view virtual returns (string memory) {
640         return "";
641     }
642 
643     /**
644      * @dev See {IERC721-approve}.
645      */
646     function approve(address to, uint256 tokenId) public virtual override {
647         address owner = ERC721.ownerOf(tokenId);
648         require(to != owner, "ERC721: approval to current owner");
649 
650         require(
651             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
652             "ERC721: approve caller is not owner nor approved for all"
653         );
654 
655         _approve(to, tokenId);
656     }
657 
658     /**
659      * @dev See {IERC721-getApproved}.
660      */
661     function getApproved(uint256 tokenId) public view virtual override returns (address) {
662         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
663 
664         return _tokenApprovals[tokenId];
665     }
666 
667     /**
668      * @dev See {IERC721-setApprovalForAll}.
669      */
670     function setApprovalForAll(address operator, bool approved) public virtual override {
671         _setApprovalForAll(_msgSender(), operator, approved);
672     }
673 
674     /**
675      * @dev See {IERC721-isApprovedForAll}.
676      */
677     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
678         return _operatorApprovals[owner][operator];
679     }
680 
681     /**
682      * @dev See {IERC721-transferFrom}.
683      */
684     function transferFrom(
685         address from,
686         address to,
687         uint256 tokenId
688     ) public virtual override {
689         //solhint-disable-next-line max-line-length
690         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
691 
692         _transfer(from, to, tokenId);
693     }
694 
695     /**
696      * @dev See {IERC721-safeTransferFrom}.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId
702     ) public virtual override {
703         safeTransferFrom(from, to, tokenId, "");
704     }
705 
706     /**
707      * @dev See {IERC721-safeTransferFrom}.
708      */
709     function safeTransferFrom(
710         address from,
711         address to,
712         uint256 tokenId,
713         bytes memory _data
714     ) public virtual override {
715         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
716         _safeTransfer(from, to, tokenId, _data);
717     }
718 
719     /**
720      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
721      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
722      *
723      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
724      *
725      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
726      * implement alternative mechanisms to perform token transfer, such as signature-based.
727      *
728      * Requirements:
729      *
730      * - `from` cannot be the zero address.
731      * - `to` cannot be the zero address.
732      * - `tokenId` token must exist and be owned by `from`.
733      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
734      *
735      * Emits a {Transfer} event.
736      */
737     function _safeTransfer(
738         address from,
739         address to,
740         uint256 tokenId,
741         bytes memory _data
742     ) internal virtual {
743         _transfer(from, to, tokenId);
744         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
745     }
746 
747     /**
748      * @dev Returns whether `tokenId` exists.
749      *
750      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
751      *
752      * Tokens start existing when they are minted (`_mint`),
753      * and stop existing when they are burned (`_burn`).
754      */
755     function _exists(uint256 tokenId) internal view virtual returns (bool) {
756         return _owners[tokenId] != address(0);
757     }
758 
759     /**
760      * @dev Returns whether `spender` is allowed to manage `tokenId`.
761      *
762      * Requirements:
763      *
764      * - `tokenId` must exist.
765      */
766     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
767         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
768         address owner = ERC721.ownerOf(tokenId);
769         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
770     }
771 
772     /**
773      * @dev Safely mints `tokenId` and transfers it to `to`.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must not exist.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _safeMint(address to, uint256 tokenId) internal virtual {
783         _safeMint(to, tokenId, "");
784     }
785 
786     /**
787      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
788      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
789      */
790     function _safeMint(
791         address to,
792         uint256 tokenId,
793         bytes memory _data
794     ) internal virtual {
795         _mint(to, tokenId);
796         require(
797             _checkOnERC721Received(address(0), to, tokenId, _data),
798             "ERC721: transfer to non ERC721Receiver implementer"
799         );
800     }
801 
802     /**
803      * @dev Mints `tokenId` and transfers it to `to`.
804      *
805      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
806      *
807      * Requirements:
808      *
809      * - `tokenId` must not exist.
810      * - `to` cannot be the zero address.
811      *
812      * Emits a {Transfer} event.
813      */
814     function _mint(address to, uint256 tokenId) internal virtual {
815         require(to != address(0), "ERC721: mint to the zero address");
816         require(!_exists(tokenId), "ERC721: token already minted");
817 
818         _beforeTokenTransfer(address(0), to, tokenId);
819 
820         _balances[to] += 1;
821         _owners[tokenId] = to;
822 
823         emit Transfer(address(0), to, tokenId);
824 
825         _afterTokenTransfer(address(0), to, tokenId);
826     }
827 
828     /**
829      * @dev Destroys `tokenId`.
830      * The approval is cleared when the token is burned.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _burn(uint256 tokenId) internal virtual {
839         address owner = ERC721.ownerOf(tokenId);
840 
841         _beforeTokenTransfer(owner, address(0), tokenId);
842 
843         // Clear approvals
844         _approve(address(0), tokenId);
845 
846         _balances[owner] -= 1;
847         delete _owners[tokenId];
848 
849         emit Transfer(owner, address(0), tokenId);
850 
851         _afterTokenTransfer(owner, address(0), tokenId);
852     }
853 
854     /**
855      * @dev Transfers `tokenId` from `from` to `to`.
856      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
857      *
858      * Requirements:
859      *
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must be owned by `from`.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _transfer(
866         address from,
867         address to,
868         uint256 tokenId
869     ) internal virtual {
870         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
871         require(to != address(0), "ERC721: transfer to the zero address");
872 
873         _beforeTokenTransfer(from, to, tokenId);
874 
875         // Clear approvals from the previous owner
876         _approve(address(0), tokenId);
877 
878         _balances[from] -= 1;
879         _balances[to] += 1;
880         _owners[tokenId] = to;
881 
882         emit Transfer(from, to, tokenId);
883 
884         _afterTokenTransfer(from, to, tokenId);
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
964 
965     /**
966      * @dev Hook that is called after any transfer of tokens. This includes
967      * minting and burning.
968      *
969      * Calling conditions:
970      *
971      * - when `from` and `to` are both non-zero.
972      * - `from` and `to` are never both zero.
973      *
974      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
975      */
976     function _afterTokenTransfer(
977         address from,
978         address to,
979         uint256 tokenId
980     ) internal virtual {}
981 }
982 
983 
984 contract Membership is Context {
985     address private owner;
986     event MembershipChanged(address indexed owner, uint256 level);
987     event OwnerTransferred(address indexed preOwner, address indexed newOwner);
988 
989     mapping(address => uint256) internal membership;
990 
991     constructor() {
992         owner = _msgSender();
993         setMembership(_msgSender(), 1);
994     }
995 
996     function transferOwner(address newOwner) public onlyOwner {
997         address preOwner = owner;
998         setMembership(newOwner, 1);
999         setMembership(preOwner, 0);
1000         owner = newOwner;
1001         emit OwnerTransferred(preOwner, newOwner);
1002     }
1003 
1004     function setMembership(address key, uint256 level) public onlyOwner {
1005         membership[key] = level;
1006         emit MembershipChanged(key, level);
1007     }
1008 
1009     modifier onlyOwner() {
1010         require(isOwner(), "Membership : caller is not the owner");
1011         _;
1012     }
1013 
1014     function isOwner() public view returns (bool) {
1015         return _msgSender() == owner;
1016     }
1017 
1018 
1019     modifier onlyAdmin() {
1020         require(isAdmin(), "Membership : caller is not a admin");
1021         _;
1022     }
1023 
1024     function isAdmin() public view returns (bool) {
1025         return membership[_msgSender()] == 1;
1026     }
1027 
1028     modifier onlyMinter() {
1029         require(isMinter(), "Memberhsip : caller is not a Minter");
1030         _;
1031     }
1032 
1033     function isMinter() public view returns (bool) {
1034         return isOwner() || membership[_msgSender()] == 11;
1035     }
1036     
1037     function getMembership(address account) public view returns (uint256){
1038         return membership[account];
1039     }
1040 }
1041 
1042 
1043 contract Drago is ERC721, Membership {
1044     event Born(uint256 indexed id, uint256 indexed parents);
1045     event Data(uint256 indexed id, uint256 indexed data);
1046 
1047     mapping(uint256 => uint256) private _datas;
1048     mapping(uint256 => uint256) private _parents;
1049     mapping(uint256 => uint256) private _breeds;
1050     mapping(uint256 => uint256) private _fusions;
1051     string baseURI;
1052     // constructor() ERC721("DDDA", "DDDB") {
1053     constructor() ERC721("Drago", "DRG") {
1054         setBaseURI("https://lok-nft.leagueofkingdoms.com/api/drago/");
1055     }
1056     function _baseURI() internal view override returns (string memory) {
1057         return baseURI;
1058     }
1059     function setBaseURI(string memory uri) public onlyOwner {
1060         baseURI = uri;
1061     }
1062     function born(uint256 tokenId, uint256 data) public onlyMinter{
1063         _datas[tokenId] = data;
1064         emit Data(tokenId, data);
1065     }
1066     function burn(uint256 tokenId) public onlyMinter{
1067         _burn(tokenId);
1068     }
1069     function mint(address to, uint256 tokenId, uint256 data) public onlyMinter{
1070         _datas[tokenId] = data;
1071         _mint(to, tokenId);
1072         emit Data(tokenId, data);
1073     }
1074     function breed(uint256 tokenId) public onlyMinter {
1075         _breeds[tokenId] += 1;
1076     }
1077     function fusion(uint256 tokenId) public onlyMinter {
1078         _fusions[tokenId] += 1;
1079     }
1080     function setParents(uint256 tokenId, uint256 parents) public onlyMinter {
1081         _parents[tokenId] = parents;
1082         emit Born(tokenId, parents);
1083     }
1084     function getParents(uint256 tokenId) public view returns(uint256){
1085         return _parents[tokenId];
1086     }
1087     function getData(uint256 tokenId) public view returns(uint256){
1088         return _datas[tokenId];
1089     }
1090     function getBreed(uint256 tokenId) public view returns(uint256){
1091         return _breeds[tokenId];
1092     }
1093     function getFusion(uint256 tokenId) public view returns(uint256){
1094         return _fusions[tokenId];
1095     }
1096 }