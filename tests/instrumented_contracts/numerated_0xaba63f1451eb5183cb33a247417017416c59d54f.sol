1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity =0.8.11;
4  
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
28 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
167 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
181      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
215 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
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
547 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
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
637      * by default, can be overriden in child contracts.
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
769         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
984 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
985 /**
986  * @dev Interface for the NFT Royalty Standard.
987  *
988  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
989  * support for royalty payments across all NFT marketplaces and ecosystem participants.
990  *
991  * _Available since v4.5._
992  */
993 interface IERC2981 is IERC165 {
994     /**
995      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
996      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
997      */
998     function royaltyInfo(uint256 tokenId, uint256 salePrice)
999         external
1000         view
1001         returns (address receiver, uint256 royaltyAmount);
1002 }
1003 
1004  
1005 // OpenZeppelin Contracts v4.4.0 (token/common/ERC2981.sol)
1006 /**
1007  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1008  *
1009  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1010  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1011  *
1012  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1013  * fee is specified in basis points by default.
1014  *
1015  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1016  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1017  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1018  *
1019  * _Available since v4.5._
1020  */
1021 abstract contract ERC2981 is IERC2981, ERC165 {
1022     struct RoyaltyInfo {
1023         address receiver;
1024         uint96 royaltyFraction;
1025     }
1026 
1027     RoyaltyInfo private _defaultRoyaltyInfo;
1028     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1029 
1030     /**
1031      * @dev See {IERC165-supportsInterface}.
1032      */
1033     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1034         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1035     }
1036 
1037     /**
1038      * @inheritdoc IERC2981
1039      */
1040     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view override returns (address, uint256) {
1041         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1042 
1043         if (royalty.receiver == address(0)) {
1044             royalty = _defaultRoyaltyInfo;
1045         }
1046 
1047         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1048 
1049         return (royalty.receiver, royaltyAmount);
1050     }
1051 
1052     /**
1053      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1054      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1055      * override.
1056      */
1057     function _feeDenominator() internal pure virtual returns (uint96) {
1058         return 10000;
1059     }
1060 
1061     /**
1062      * @dev Sets the royalty information that all ids in this contract will default to.
1063      *
1064      * Requirements:
1065      *
1066      * - `receiver` cannot be the zero address.
1067      * - `feeNumerator` cannot be greater than the fee denominator.
1068      */
1069     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1070         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1071         require(receiver != address(0), "ERC2981: invalid receiver");
1072 
1073         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1074     }
1075 
1076     /**
1077      * @dev Removes default royalty information.
1078      */
1079     function _deleteDefaultRoyalty() internal virtual {
1080         delete _defaultRoyaltyInfo;
1081     }
1082 
1083     /**
1084      * @dev Sets the royalty information for a specific token id, overriding the global default.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must be already minted.
1089      * - `receiver` cannot be the zero address.
1090      * - `feeNumerator` cannot be greater than the fee denominator.
1091      */
1092     function _setTokenRoyalty(
1093         uint256 tokenId,
1094         address receiver,
1095         uint96 feeNumerator
1096     ) internal virtual {
1097         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1098         require(receiver != address(0), "ERC2981: Invalid parameters");
1099 
1100         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1101     }
1102 
1103     /**
1104      * @dev Resets royalty information for the token id back to the global default.
1105      */
1106     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1107         delete _tokenRoyaltyInfo[tokenId];
1108     }
1109 }
1110 
1111  
1112 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Royalty.sol)
1113 /**
1114  * @dev Extension of ERC721 with the ERC2981 NFT Royalty Standard, a standardized way to retrieve royalty payment
1115  * information.
1116  *
1117  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1118  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1119  *
1120  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1121  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1122  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1123  *
1124  * _Available since v4.5._
1125  */
1126 abstract contract ERC721Royalty is ERC2981, ERC721 {
1127     /**
1128      * @dev See {IERC165-supportsInterface}.
1129      */
1130     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
1131         return super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {ERC721-_burn}. This override additionally clears the royalty information for the token.
1136      */
1137     function _burn(uint256 tokenId) internal virtual override {
1138         super._burn(tokenId);
1139         _resetTokenRoyalty(tokenId);
1140     }
1141 }
1142 
1143  
1144 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1145 /**
1146  * @title Counters
1147  * @author Matt Condon (@shrugs)
1148  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1149  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1150  *
1151  * Include with `using Counters for Counters.Counter;`
1152  */
1153 library Counters {
1154     struct Counter {
1155         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1156         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1157         // this feature: see https://github.com/ethereum/solidity/issues/4637
1158         uint256 _value; // default: 0
1159     }
1160 
1161     function current(Counter storage counter) internal view returns (uint256) {
1162         return counter._value;
1163     }
1164 
1165     function increment(Counter storage counter) internal {
1166         unchecked {
1167             counter._value += 1;
1168         }
1169     }
1170 
1171     function decrement(Counter storage counter) internal {
1172         uint256 value = counter._value;
1173         require(value > 0, "Counter: decrement overflow");
1174         unchecked {
1175             counter._value = value - 1;
1176         }
1177     }
1178 
1179     function reset(Counter storage counter) internal {
1180         counter._value = 0;
1181     }
1182 }
1183 
1184  
1185 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1186 /**
1187  * @dev Contract module which provides a basic access control mechanism, where
1188  * there is an account (an owner) that can be granted exclusive access to
1189  * specific functions.
1190  *
1191  * By default, the owner account will be the one that deploys the contract. This
1192  * can later be changed with {transferOwnership}.
1193  *
1194  * This module is used through inheritance. It will make available the modifier
1195  * `onlyOwner`, which can be applied to your functions to restrict their use to
1196  * the owner.
1197  */
1198 abstract contract Ownable is Context {
1199     address private _owner;
1200 
1201     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1202 
1203     /**
1204      * @dev Initializes the contract setting the deployer as the initial owner.
1205      */
1206     constructor() {
1207         _transferOwnership(_msgSender());
1208     }
1209 
1210     /**
1211      * @dev Returns the address of the current owner.
1212      */
1213     function owner() public view virtual returns (address) {
1214         return _owner;
1215     }
1216 
1217     /**
1218      * @dev Throws if called by any account other than the owner.
1219      */
1220     modifier onlyOwner() {
1221         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1222         _;
1223     }
1224 
1225     /**
1226      * @dev Leaves the contract without owner. It will not be possible to call
1227      * `onlyOwner` functions anymore. Can only be called by the current owner.
1228      *
1229      * NOTE: Renouncing ownership will leave the contract without an owner,
1230      * thereby removing any functionality that is only available to the owner.
1231      */
1232     function renounceOwnership() public virtual onlyOwner {
1233         _transferOwnership(address(0));
1234     }
1235 
1236     /**
1237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1238      * Can only be called by the current owner.
1239      */
1240     function transferOwnership(address newOwner) public virtual onlyOwner {
1241         require(newOwner != address(0), "Ownable: new owner is the zero address");
1242         _transferOwnership(newOwner);
1243     }
1244 
1245     /**
1246      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1247      * Internal function without access restriction.
1248      */
1249     function _transferOwnership(address newOwner) internal virtual {
1250         address oldOwner = _owner;
1251         _owner = newOwner;
1252         emit OwnershipTransferred(oldOwner, newOwner);
1253     }
1254 }
1255 
1256 contract QUIK is ERC721Royalty, Ownable {
1257   using Counters for Counters.Counter;
1258   using Strings for uint256;
1259   Counters.Counter private _tokenIds;
1260   string public baseUri; //Base uri for metadata
1261 
1262 
1263   uint256 public mintingFee = 0.08 ether; //Minting Fee
1264   string public TLD; // TLD for domain
1265 
1266   // Mapping if certain name string has already been reserved
1267   mapping (string => bool) public registeredDomain;
1268   // Mapping for token id to Domain name
1269   mapping (uint256 => string) public tokenDomain;
1270   
1271   //whitelist Address for Pre-minting
1272   mapping (address=>bool) public whitelistedAddress;
1273   bool public isOnlyWhitelist = true;
1274 
1275   // quik marketplace
1276   address marketplaceContract;
1277   
1278   //event 
1279   event DomainMinted(uint256 tokenId,string domain, address minter);
1280 
1281   constructor(string memory _name, string memory _symbol, string memory _baseUri, string memory _tld, address _marketplaceContract) ERC721(_name, _symbol) {
1282     baseUri = _baseUri;
1283     TLD = _tld;
1284     marketplaceContract = _marketplaceContract;
1285   }
1286 
1287   function validateName(string memory str) internal pure returns (bool){
1288 		bytes memory b = bytes(str);
1289 		if(b.length < 1) return false;
1290 		if(b.length > 49) return false; // Cannot be longer than 49 characters
1291 		if(b[0] == 0x20) return false; // Leading space
1292 		if (b[b.length - 1] == 0x20) return false; // Trailing space
1293 
1294 		for(uint i; i<b.length; i++){
1295 			bytes1 char = b[i];
1296 
1297 			if (char == 0x20) return false; // Cannot contain  spaces
1298 
1299 			if(
1300 				!(char >= 0x30 && char <= 0x39) && //9-0
1301 				!(char >= 0x61 && char <= 0x7A) && //a-z
1302 				!(char == 0x2D) //- carriage return
1303 			)
1304 				return false;
1305 		}
1306 		return true;
1307 	}
1308 
1309     ///@notice Mints new token with given details
1310     ///@param _name domain name to mint
1311     function mintDomain(string memory _name) public payable{
1312         require(!isOnlyWhitelist || whitelistedAddress[msg.sender], "Not open for public minting!");
1313         
1314         if(!whitelistedAddress[msg.sender])
1315             require(msg.value >= mintingFee, "Not enough minting fee!");
1316         
1317         require(validateName(_name), "Not Valid Name!");
1318         require(!isdomainNameReserved(_name), "Already Registered!");
1319         
1320         if(!isApprovedForAll(msg.sender, marketplaceContract))
1321             _setApprovalForAll(msg.sender, marketplaceContract, true);
1322 
1323         registeredDomain[_name] = true;
1324 
1325         _tokenIds.increment();
1326         uint256 newTokenId = _tokenIds.current();
1327 
1328         tokenDomain[newTokenId] = _name;
1329         _mint(msg.sender, newTokenId);
1330         //500 royalty info 
1331         _setTokenRoyalty(newTokenId, msg.sender, 500);
1332         emit DomainMinted(newTokenId, _name, msg.sender);
1333     }
1334   
1335     ///@notice Token URI for metadata for token
1336     ///@param _tokenId token id 
1337     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1338         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1339         return bytes(baseUri).length > 0 ? string(abi.encodePacked(baseUri, _tokenId.toString(), ".json")) : "";
1340     }
1341 
1342     ///@notice Checks if domain name is registered or not 
1343     ///@param _nameString keccak256 hash for the domain
1344 	function isdomainNameReserved(string memory _nameString) public view returns (bool) {
1345 		return  registeredDomain[_nameString];
1346 	}
1347 
1348     ///@notice Get full domain name for the tokenId
1349     ///@param _tokenId token id
1350     function getDomainName(uint256 _tokenId) public view returns (string memory domain){
1351         domain = string(abi.encodePacked(tokenDomain[_tokenId],".",TLD));
1352     }
1353 
1354     ///@notice Change the public minting 
1355     ///@param _status status for public minting
1356     function onlyWhitelistAddressMintable(bool _status) external onlyOwner{
1357         isOnlyWhitelist = _status;
1358     }
1359 
1360     ///@notice Add the wallet for whitelisted address for free minting 
1361     ///@param _wallet wallet of user
1362     function addWhitelistedAddress(address _wallet) external onlyOwner{
1363         whitelistedAddress[_wallet] = true;
1364     }
1365 
1366     ///@notice Remove the wallet from whitelisted address for free minting 
1367     ///@param _wallet wallet of user
1368     function removeWhitelistedAddress(address _wallet) external onlyOwner{
1369         whitelistedAddress[_wallet] = false;
1370     }
1371 
1372     ///@notice Update Minting fee for token
1373     ///@param _mintFee Minitng fee to set
1374     function updateMintFee(uint256 _mintFee) external onlyOwner{
1375         mintingFee = _mintFee;
1376     }
1377 
1378     ///@notice Update address for marketplace contract
1379     ///@param _marketplaceContract marketplace contract address 
1380     function updateMarketplace(address _marketplaceContract) external onlyOwner{
1381         marketplaceContract = _marketplaceContract;
1382     }
1383 
1384     ///@notice Withdraw Ether in the contract by owner
1385     function withdraw() external payable onlyOwner {
1386         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1387         require(os);
1388     }
1389 
1390 
1391 }