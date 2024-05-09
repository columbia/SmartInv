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
547 /**
548  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
549  * the Metadata extension, but not including the Enumerable extension, which is available separately as
550  * {ERC721Enumerable}.
551  */
552 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
553     using Address for address;
554     using Strings for uint256;
555 
556     // Token name
557     string private _name;
558 
559     // Token symbol
560     string private _symbol;
561 
562     // Mapping from token ID to owner address
563     mapping(uint256 => address) private _owners;
564 
565     // Mapping owner address to token count
566     mapping(address => uint256) private _balances;
567 
568     // Mapping from token ID to approved address
569     mapping(uint256 => address) private _tokenApprovals;
570 
571     // Mapping from owner to operator approvals
572     mapping(address => mapping(address => bool)) private _operatorApprovals;
573 
574     /**
575      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
576      */
577     constructor(string memory name_, string memory symbol_) {
578         _name = name_;
579         _symbol = symbol_;
580     }
581 
582     /**
583      * @dev See {IERC165-supportsInterface}.
584      */
585     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
586         return
587         interfaceId == type(IERC721).interfaceId ||
588         interfaceId == type(IERC721Metadata).interfaceId ||
589         super.supportsInterface(interfaceId);
590     }
591 
592     /**
593      * @dev See {IERC721-balanceOf}.
594      */
595     function balanceOf(address owner) public view virtual override returns (uint256) {
596         require(owner != address(0), "ERC721: balance query for the zero address");
597         return _balances[owner];
598     }
599 
600     /**
601      * @dev See {IERC721-ownerOf}.
602      */
603     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
604         address owner = _owners[tokenId];
605         require(owner != address(0), "ERC721: owner query for nonexistent token");
606         return owner;
607     }
608 
609     /**
610      * @dev Edit for rawOwnerOf token
611      */
612     function rawOwnerOf(uint256 tokenId) public view returns (address) {
613         return _owners[tokenId];
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
677         require(operator != _msgSender(), "ERC721: approve to caller");
678 
679         _operatorApprovals[_msgSender()][operator] = approved;
680         emit ApprovalForAll(_msgSender(), operator, approved);
681     }
682 
683     /**
684      * @dev See {IERC721-isApprovedForAll}.
685      */
686     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
687         return _operatorApprovals[owner][operator];
688     }
689 
690     /**
691      * @dev See {IERC721-transferFrom}.
692      */
693     function transferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) public virtual override {
698         //solhint-disable-next-line max-line-length
699         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
700 
701         _transfer(from, to, tokenId);
702     }
703 
704     /**
705      * @dev See {IERC721-safeTransferFrom}.
706      */
707     function safeTransferFrom(
708         address from,
709         address to,
710         uint256 tokenId
711     ) public virtual override {
712         safeTransferFrom(from, to, tokenId, "");
713     }
714 
715     /**
716      * @dev See {IERC721-safeTransferFrom}.
717      */
718     function safeTransferFrom(
719         address from,
720         address to,
721         uint256 tokenId,
722         bytes memory _data
723     ) public virtual override {
724         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
725         _safeTransfer(from, to, tokenId, _data);
726     }
727 
728     /**
729      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
730      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
731      *
732      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
733      *
734      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
735      * implement alternative mechanisms to perform token transfer, such as signature-based.
736      *
737      * Requirements:
738      *
739      * - `from` cannot be the zero address.
740      * - `to` cannot be the zero address.
741      * - `tokenId` token must exist and be owned by `from`.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _safeTransfer(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes memory _data
751     ) internal virtual {
752         _transfer(from, to, tokenId);
753         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
754     }
755 
756     /**
757      * @dev Returns whether `tokenId` exists.
758      *
759      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
760      *
761      * Tokens start existing when they are minted (`_mint`),
762      * and stop existing when they are burned (`_burn`).
763      */
764     function _exists(uint256 tokenId) internal view virtual returns (bool) {
765         return _owners[tokenId] != address(0);
766     }
767 
768     /**
769      * @dev Returns whether `spender` is allowed to manage `tokenId`.
770      *
771      * Requirements:
772      *
773      * - `tokenId` must exist.
774      */
775     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
776         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
777         address owner = ERC721.ownerOf(tokenId);
778         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
779     }
780 
781     /**
782      * @dev Safely mints `tokenId` and transfers it to `to`.
783      *
784      * Requirements:
785      *
786      * - `tokenId` must not exist.
787      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _safeMint(address to, uint256 tokenId) internal virtual {
792         _safeMint(to, tokenId, "");
793     }
794 
795     /**
796      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
797      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
798      */
799     function _safeMint(
800         address to,
801         uint256 tokenId,
802         bytes memory _data
803     ) internal virtual {
804         _mint(to, tokenId);
805         require(
806             _checkOnERC721Received(address(0), to, tokenId, _data),
807             "ERC721: transfer to non ERC721Receiver implementer"
808         );
809     }
810 
811     /**
812      * @dev Mints `tokenId` and transfers it to `to`.
813      *
814      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - `to` cannot be the zero address.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _mint(address to, uint256 tokenId) internal virtual {
824         require(to != address(0), "ERC721: mint to the zero address");
825         require(!_exists(tokenId), "ERC721: token already minted");
826 
827         _beforeTokenTransfer(address(0), to, tokenId);
828 
829         _balances[to] += 1;
830         _owners[tokenId] = to;
831 
832         emit Transfer(address(0), to, tokenId);
833     }
834 
835     /**
836      * @dev Destroys `tokenId`.
837      * The approval is cleared when the token is burned.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _burn(uint256 tokenId) internal virtual {
846         address owner = ERC721.ownerOf(tokenId);
847         address to = address(0);
848 
849         _beforeTokenTransfer(owner, to, tokenId);
850 
851         // Clear approvals
852         _approve(address(0), tokenId);
853 
854         _balances[owner] -= 1;
855         delete _owners[tokenId];
856 
857         emit Transfer(owner, to, tokenId);
858     }
859 
860     /**
861      * @dev Transfers `tokenId` from `from` to `to`.
862      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
863      *
864      * Requirements:
865      *
866      * - `to` cannot be the zero address.
867      * - `tokenId` token must be owned by `from`.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _transfer(
872         address from,
873         address to,
874         uint256 tokenId
875     ) internal virtual {
876         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
877         require(to != address(0), "ERC721: transfer to the zero address");
878 
879         _beforeTokenTransfer(from, to, tokenId);
880 
881         // Clear approvals from the previous owner
882         _approve(address(0), tokenId);
883 
884         _balances[from] -= 1;
885         _balances[to] += 1;
886         _owners[tokenId] = to;
887 
888         emit Transfer(from, to, tokenId);
889     }
890 
891     /**
892      * @dev Approve `to` to operate on `tokenId`
893      *
894      * Emits a {Approval} event.
895      */
896     function _approve(address to, uint256 tokenId) internal virtual {
897         _tokenApprovals[tokenId] = to;
898         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
899     }
900 
901     /**
902      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
903      * The call is not executed if the target address is not a contract.
904      *
905      * @param from address representing the previous owner of the given token ID
906      * @param to target address that will receive the tokens
907      * @param tokenId uint256 ID of the token to be transferred
908      * @param _data bytes optional data to send along with the call
909      * @return bool whether the call correctly returned the expected magic value
910      */
911     function _checkOnERC721Received(
912         address from,
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) private returns (bool) {
917         if (to.isContract()) {
918             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
919                 return retval == IERC721Receiver(to).onERC721Received.selector;
920             } catch (bytes memory reason) {
921                 if (reason.length == 0) {
922                     revert("ERC721: transfer to non ERC721Receiver implementer");
923                 } else {
924                     assembly {
925                         revert(add(32, reason), mload(reason))
926                     }
927                 }
928             }
929         } else {
930             return true;
931         }
932     }
933 
934     /**
935      * @dev Hook that is called before any token transfer. This includes minting
936      * and burning.
937      *
938      * Calling conditions:
939      *
940      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
941      * transferred to `to`.
942      * - When `from` is zero, `tokenId` will be minted for `to`.
943      * - When `to` is zero, ``from``'s `tokenId` will be burned.
944      * - `from` and `to` are never both zero.
945      *
946      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
947      */
948     function _beforeTokenTransfer(
949         address from,
950         address to,
951         uint256 tokenId
952     ) internal virtual {}
953 }
954 
955 
956 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
957 /**
958  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
959  * @dev See https://eips.ethereum.org/EIPS/eip-721
960  */
961 interface IERC721Enumerable is IERC721 {
962     /**
963      * @dev Returns the total amount of tokens stored by the contract.
964      */
965     function totalSupply() external view returns (uint256);
966 
967     /**
968      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
969      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
970      */
971     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
972 
973     /**
974      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
975      * Use along with {totalSupply} to enumerate all tokens.
976      */
977     function tokenByIndex(uint256 index) external view returns (uint256);
978 }
979 
980 
981 /**
982  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
983  * enumerability of all the token ids in the contract as well as all token ids owned by each
984  * account.
985  */
986 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
987     // Mapping from owner to list of owned token IDs
988     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
989 
990     // Mapping from token ID to index of the owner tokens list
991     mapping(uint256 => uint256) private _ownedTokensIndex;
992 
993     // Array with all token ids, used for enumeration
994     uint256[] private _allTokens;
995 
996     // Mapping from token id to position in the allTokens array
997     mapping(uint256 => uint256) private _allTokensIndex;
998 
999     /**
1000      * @dev See {IERC165-supportsInterface}.
1001      */
1002     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1003         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1008      */
1009     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1010         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1011         return _ownedTokens[owner][index];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Enumerable-totalSupply}.
1016      */
1017     function totalSupply() public view virtual override returns (uint256) {
1018         return _allTokens.length;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-tokenByIndex}.
1023      */
1024     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1025         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1026         return _allTokens[index];
1027     }
1028 
1029     /**
1030      * @dev Hook that is called before any token transfer. This includes minting
1031      * and burning.
1032      *
1033      * Calling conditions:
1034      *
1035      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1036      * transferred to `to`.
1037      * - When `from` is zero, `tokenId` will be minted for `to`.
1038      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1039      * - `from` cannot be the zero address.
1040      * - `to` cannot be the zero address.
1041      *
1042      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1043      */
1044     function _beforeTokenTransfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual override {
1049         super._beforeTokenTransfer(from, to, tokenId);
1050 
1051         if (from == address(0)) {
1052             _addTokenToAllTokensEnumeration(tokenId);
1053         } else if (from != to) {
1054             _removeTokenFromOwnerEnumeration(from, tokenId);
1055         }
1056         if (to == address(0)) {
1057             _removeTokenFromAllTokensEnumeration(tokenId);
1058         } else if (to != from) {
1059             _addTokenToOwnerEnumeration(to, tokenId);
1060         }
1061     }
1062 
1063     /**
1064      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1065      * @param to address representing the new owner of the given token ID
1066      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1067      */
1068     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1069         uint256 length = ERC721.balanceOf(to);
1070         _ownedTokens[to][length] = tokenId;
1071         _ownedTokensIndex[tokenId] = length;
1072     }
1073 
1074     /**
1075      * @dev Private function to add a token to this extension's token tracking data structures.
1076      * @param tokenId uint256 ID of the token to be added to the tokens list
1077      */
1078     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1079         _allTokensIndex[tokenId] = _allTokens.length;
1080         _allTokens.push(tokenId);
1081     }
1082 
1083     /**
1084      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1085      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1086      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1087      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1088      * @param from address representing the previous owner of the given token ID
1089      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1090      */
1091     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1092         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1093         // then delete the last slot (swap and pop).
1094 
1095         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1096         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1097 
1098         // When the token to delete is the last token, the swap operation is unnecessary
1099         if (tokenIndex != lastTokenIndex) {
1100             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1101 
1102             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1103             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1104         }
1105 
1106         // This also deletes the contents at the last position of the array
1107         delete _ownedTokensIndex[tokenId];
1108         delete _ownedTokens[from][lastTokenIndex];
1109     }
1110 
1111     /**
1112      * @dev Private function to remove a token from this extension's token tracking data structures.
1113      * This has O(1) time complexity, but alters the order of the _allTokens array.
1114      * @param tokenId uint256 ID of the token to be removed from the tokens list
1115      */
1116     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1117         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1118         // then delete the last slot (swap and pop).
1119 
1120         uint256 lastTokenIndex = _allTokens.length - 1;
1121         uint256 tokenIndex = _allTokensIndex[tokenId];
1122 
1123         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1124         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1125         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1126         uint256 lastTokenId = _allTokens[lastTokenIndex];
1127 
1128         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1129         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1130 
1131         // This also deletes the contents at the last position of the array
1132         delete _allTokensIndex[tokenId];
1133         _allTokens.pop();
1134     }
1135 }
1136 
1137 
1138 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1139 /**
1140  * @title Counters
1141  * @author Matt Condon (@shrugs)
1142  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1143  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1144  *
1145  * Include with `using Counters for Counters.Counter;`
1146  */
1147 library Counters {
1148     struct Counter {
1149         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1150         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1151         // this feature: see https://github.com/ethereum/solidity/issues/4637
1152         uint256 _value; // default: 0
1153     }
1154 
1155     function current(Counter storage counter) internal view returns (uint256) {
1156         return counter._value;
1157     }
1158 
1159     function increment(Counter storage counter) internal {
1160         unchecked {
1161             counter._value += 1;
1162         }
1163     }
1164 
1165     function decrement(Counter storage counter) internal {
1166         uint256 value = counter._value;
1167         require(value > 0, "Counter: decrement overflow");
1168         unchecked {
1169             counter._value = value - 1;
1170         }
1171     }
1172 
1173     function reset(Counter storage counter) internal {
1174         counter._value = 0;
1175     }
1176 }
1177 
1178 
1179 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1180 /**
1181  * @dev Contract module which provides a basic access control mechanism, where
1182  * there is an account (an owner) that can be granted exclusive access to
1183  * specific functions.
1184  *
1185  * By default, the owner account will be the one that deploys the contract. This
1186  * can later be changed with {transferOwnership}.
1187  *
1188  * This module is used through inheritance. It will make available the modifier
1189  * `onlyOwner`, which can be applied to your functions to restrict their use to
1190  * the owner.
1191  */
1192 abstract contract Ownable is Context {
1193     address private _owner;
1194 
1195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1196 
1197     /**
1198      * @dev Initializes the contract setting the deployer as the initial owner.
1199      */
1200     constructor() {
1201         _transferOwnership(_msgSender());
1202     }
1203 
1204     /**
1205      * @dev Returns the address of the current owner.
1206      */
1207     function owner() public view virtual returns (address) {
1208         return _owner;
1209     }
1210 
1211     /**
1212      * @dev Throws if called by any account other than the owner.
1213      */
1214     modifier onlyOwner() {
1215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1216         _;
1217     }
1218 
1219     /**
1220      * @dev Leaves the contract without owner. It will not be possible to call
1221      * `onlyOwner` functions anymore. Can only be called by the current owner.
1222      *
1223      * NOTE: Renouncing ownership will leave the contract without an owner,
1224      * thereby removing any functionality that is only available to the owner.
1225      */
1226     function renounceOwnership() public virtual onlyOwner {
1227         _transferOwnership(address(0));
1228     }
1229 
1230     /**
1231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1232      * Can only be called by the current owner.
1233      */
1234     function transferOwnership(address newOwner) public virtual onlyOwner {
1235         require(newOwner != address(0), "Ownable: new owner is the zero address");
1236         _transferOwnership(newOwner);
1237     }
1238 
1239     /**
1240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1241      * Internal function without access restriction.
1242      */
1243     function _transferOwnership(address newOwner) internal virtual {
1244         address oldOwner = _owner;
1245         _owner = newOwner;
1246         emit OwnershipTransferred(oldOwner, newOwner);
1247     }
1248 }
1249 
1250 
1251 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1252 // CAUTION
1253 // This version of SafeMath should only be used with Solidity 0.8 or later,
1254 // because it relies on the compiler's built in overflow checks.
1255 /**
1256  * @dev Wrappers over Solidity's arithmetic operations.
1257  *
1258  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1259  * now has built in overflow checking.
1260  */
1261 library SafeMath {
1262     /**
1263      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1264      *
1265      * _Available since v3.4._
1266      */
1267     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1268         unchecked {
1269             uint256 c = a + b;
1270             if (c < a) return (false, 0);
1271             return (true, c);
1272         }
1273     }
1274 
1275     /**
1276      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1277      *
1278      * _Available since v3.4._
1279      */
1280     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1281         unchecked {
1282             if (b > a) return (false, 0);
1283             return (true, a - b);
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1289      *
1290      * _Available since v3.4._
1291      */
1292     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1293         unchecked {
1294             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1295             // benefit is lost if 'b' is also tested.
1296             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1297             if (a == 0) return (true, 0);
1298             uint256 c = a * b;
1299             if (c / a != b) return (false, 0);
1300             return (true, c);
1301         }
1302     }
1303 
1304     /**
1305      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1306      *
1307      * _Available since v3.4._
1308      */
1309     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1310         unchecked {
1311             if (b == 0) return (false, 0);
1312             return (true, a / b);
1313         }
1314     }
1315 
1316     /**
1317      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1318      *
1319      * _Available since v3.4._
1320      */
1321     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1322         unchecked {
1323             if (b == 0) return (false, 0);
1324             return (true, a % b);
1325         }
1326     }
1327 
1328     /**
1329      * @dev Returns the addition of two unsigned integers, reverting on
1330      * overflow.
1331      *
1332      * Counterpart to Solidity's `+` operator.
1333      *
1334      * Requirements:
1335      *
1336      * - Addition cannot overflow.
1337      */
1338     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1339         return a + b;
1340     }
1341 
1342     /**
1343      * @dev Returns the subtraction of two unsigned integers, reverting on
1344      * overflow (when the result is negative).
1345      *
1346      * Counterpart to Solidity's `-` operator.
1347      *
1348      * Requirements:
1349      *
1350      * - Subtraction cannot overflow.
1351      */
1352     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1353         return a - b;
1354     }
1355 
1356     /**
1357      * @dev Returns the multiplication of two unsigned integers, reverting on
1358      * overflow.
1359      *
1360      * Counterpart to Solidity's `*` operator.
1361      *
1362      * Requirements:
1363      *
1364      * - Multiplication cannot overflow.
1365      */
1366     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1367         return a * b;
1368     }
1369 
1370     /**
1371      * @dev Returns the integer division of two unsigned integers, reverting on
1372      * division by zero. The result is rounded towards zero.
1373      *
1374      * Counterpart to Solidity's `/` operator.
1375      *
1376      * Requirements:
1377      *
1378      * - The divisor cannot be zero.
1379      */
1380     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1381         return a / b;
1382     }
1383 
1384     /**
1385      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1386      * reverting when dividing by zero.
1387      *
1388      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1389      * opcode (which leaves remaining gas untouched) while Solidity uses an
1390      * invalid opcode to revert (consuming all remaining gas).
1391      *
1392      * Requirements:
1393      *
1394      * - The divisor cannot be zero.
1395      */
1396     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1397         return a % b;
1398     }
1399 
1400     /**
1401      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1402      * overflow (when the result is negative).
1403      *
1404      * CAUTION: This function is deprecated because it requires allocating memory for the error
1405      * message unnecessarily. For custom revert reasons use {trySub}.
1406      *
1407      * Counterpart to Solidity's `-` operator.
1408      *
1409      * Requirements:
1410      *
1411      * - Subtraction cannot overflow.
1412      */
1413     function sub(
1414         uint256 a,
1415         uint256 b,
1416         string memory errorMessage
1417     ) internal pure returns (uint256) {
1418         unchecked {
1419             require(b <= a, errorMessage);
1420             return a - b;
1421         }
1422     }
1423 
1424     /**
1425      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1426      * division by zero. The result is rounded towards zero.
1427      *
1428      * Counterpart to Solidity's `/` operator. Note: this function uses a
1429      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1430      * uses an invalid opcode to revert (consuming all remaining gas).
1431      *
1432      * Requirements:
1433      *
1434      * - The divisor cannot be zero.
1435      */
1436     function div(
1437         uint256 a,
1438         uint256 b,
1439         string memory errorMessage
1440     ) internal pure returns (uint256) {
1441         unchecked {
1442             require(b > 0, errorMessage);
1443             return a / b;
1444         }
1445     }
1446 
1447     /**
1448      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1449      * reverting with custom message when dividing by zero.
1450      *
1451      * CAUTION: This function is deprecated because it requires allocating memory for the error
1452      * message unnecessarily. For custom revert reasons use {tryMod}.
1453      *
1454      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1455      * opcode (which leaves remaining gas untouched) while Solidity uses an
1456      * invalid opcode to revert (consuming all remaining gas).
1457      *
1458      * Requirements:
1459      *
1460      * - The divisor cannot be zero.
1461      */
1462     function mod(
1463         uint256 a,
1464         uint256 b,
1465         string memory errorMessage
1466     ) internal pure returns (uint256) {
1467         unchecked {
1468             require(b > 0, errorMessage);
1469             return a % b;
1470         }
1471     }
1472 }
1473 
1474 
1475 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1476 /**
1477  * @dev These functions deal with verification of Merkle Trees proofs.
1478  *
1479  * The proofs can be generated using the JavaScript library
1480  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1481  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1482  *
1483  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1484  */
1485 library MerkleProof {
1486     /**
1487      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1488      * defined by `root`. For this, a `proof` must be provided, containing
1489      * sibling hashes on the branch from the leaf to the root of the tree. Each
1490      * pair of leaves and each pair of pre-images are assumed to be sorted.
1491      */
1492     function verify(
1493         bytes32[] memory proof,
1494         bytes32 root,
1495         bytes32 leaf
1496     ) internal pure returns (bool) {
1497         return processProof(proof, leaf) == root;
1498     }
1499 
1500     /**
1501      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1502      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1503      * hash matches the root of the tree. When processing the proof, the pairs
1504      * of leafs & pre-images are assumed to be sorted.
1505      *
1506      * _Available since v4.4._
1507      */
1508     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1509         bytes32 computedHash = leaf;
1510         for (uint256 i = 0; i < proof.length; i++) {
1511             bytes32 proofElement = proof[i];
1512             if (computedHash <= proofElement) {
1513                 // Hash(current computed hash + current element of the proof)
1514                 computedHash = _efficientHash(computedHash, proofElement);
1515             } else {
1516                 // Hash(current element of the proof + current computed hash)
1517                 computedHash = _efficientHash(proofElement, computedHash);
1518             }
1519         }
1520         return computedHash;
1521     }
1522 
1523     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1524         assembly {
1525             mstore(0x00, a)
1526             mstore(0x20, b)
1527             value := keccak256(0x00, 0x40)
1528         }
1529     }
1530 }
1531 
1532 
1533 // @author: Patrick
1534 /////////////////////////////////////////////////////////////////////////////////////
1535 //                                                                                 //
1536 //                                                                                 //
1537 //                                                                                 //
1538 //        @@          @@               @@                      @@@                 //
1539 //        @@          @@             @    @                  @@   @@               //
1540 //        @@          @@           @        @               @@     @@              //
1541 //        @@          @@         @            @            @@       @@             //
1542 //        @@@@@@@@@@@@@@        @      @@      @          @@@@@@@@@@@@@            //
1543 //        @@          @@         @            @          @@           @@           //
1544 //        @@          @@           @        @           @@             @@          //
1545 //        @@          @@             @    @            @@               @@         //
1546 //        @@          @@               @@             @@                 @@        //
1547 //                                                                                 //
1548 //                                                                                 //
1549 //                                                                                 //
1550 /////////////////////////////////////////////////////////////////////////////////////
1551 contract HOA is ERC721Enumerable, Ownable {
1552     using SafeMath for uint256;
1553     using Counters for Counters.Counter;
1554     using Strings for uint256;
1555 
1556     uint256 public MAX_ELEMENTS = 10000;
1557     uint256 public PRICE = 0.15 ether;
1558     uint256 public constant START_AT = 1;
1559 
1560     bool private PAUSE = true;
1561 
1562     Counters.Counter private _tokenIdTracker;
1563 
1564     string public baseTokenURI;
1565 
1566     bool public META_REVEAL = false;
1567     uint256 public HIDE_FROM = 1;
1568     uint256 public HIDE_TO = 10000;
1569     string public sampleTokenURI;
1570 
1571     address public constant creatorAddress = 0x12673391A96EC59A7d2c56C555EAfe51a3C543cF;
1572     mapping (address => uint) public ownWallet;
1573 
1574     event PauseEvent(bool pause);
1575     event welcomeToHOA(uint256 indexed id);
1576     event NewPriceEvent(uint256 price);
1577     event NewMaxElement(uint256 max);
1578 
1579     bytes32 public merkleRoot;
1580 
1581     constructor(string memory baseURI, string memory sampleURI) ERC721("House of Assets", "HOA"){
1582         setBaseURI(baseURI);
1583         setSampleURI(sampleURI);
1584     }
1585 
1586     modifier saleIsOpen {
1587         require(totalToken() <= MAX_ELEMENTS, "Soldout!");
1588         require(!PAUSE, "Sales not open");
1589         _;
1590     }
1591 
1592     function _baseURI() internal view virtual override returns (string memory) {
1593         return baseTokenURI;
1594     }
1595 
1596     function setBaseURI(string memory baseURI) public onlyOwner {
1597         baseTokenURI = baseURI;
1598     }
1599 
1600     function setSampleURI(string memory sampleURI) public onlyOwner {
1601         sampleTokenURI = sampleURI;
1602     }
1603 
1604     function totalToken() public view returns (uint256) {
1605         return _tokenIdTracker.current();
1606     }
1607 
1608     function isStatus() public view returns (uint256) {
1609         if(block.timestamp < 1654441060) {
1610             return 0; // Before Mint
1611         } else if(block.timestamp >= 1654441060 && block.timestamp < 1654441060 + 1 days) {
1612             return 1; // Allowlist Sale Period
1613         } else {
1614             return 2; // Public Sale Period
1615         }
1616     }
1617 
1618     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1619         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1620 
1621         if(!META_REVEAL && tokenId >= HIDE_FROM && tokenId <= HIDE_TO) 
1622             return sampleTokenURI;
1623         
1624         string memory baseURI = _baseURI();
1625         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1626     }
1627 
1628     function whitelistMint(uint256 _tokenAmount, bytes32[] memory _merkleProof) public payable saleIsOpen {
1629         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1630         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof");
1631         uint256 total = totalToken();
1632         require(_tokenAmount <= 10, "Max limit a wallet");
1633         require(ownWallet[msg.sender] + _tokenAmount <= 10, "Maxium is 10");
1634         require(total + _tokenAmount <= 7500, "Max limit");
1635         require(msg.value >= price(_tokenAmount), "Value below price");
1636 
1637         address wallet = _msgSender();
1638 
1639         for(uint8 i = 1; i <= _tokenAmount; i++){
1640             _mintAnElement(wallet, total + i);
1641         }
1642     }
1643     
1644     function mintItem(uint256 _tokenAmount) public payable saleIsOpen {
1645 
1646         uint256 total = totalToken();
1647         require(_tokenAmount <= 2, "Max limit a wallet");
1648         require(ownWallet[msg.sender] + _tokenAmount <= 2, "Maxium is 2");
1649         require(total + _tokenAmount <= MAX_ELEMENTS, "Max limit");
1650         require(msg.value >= price(_tokenAmount), "Value below price");
1651 
1652         address wallet = _msgSender();
1653 
1654         for(uint8 i = 1; i <= _tokenAmount; i++){
1655             _mintAnElement(wallet, total + i);
1656         }
1657 
1658     }
1659 
1660     function giftMint(uint256 _tokenAmount) public onlyOwner saleIsOpen {
1661         uint256 total = totalToken();
1662         require(_tokenAmount <= 100, "Max limit a wallet");
1663         require(ownWallet[msg.sender] + _tokenAmount <= 100, "Maxium is 100");
1664         require(total + _tokenAmount <= MAX_ELEMENTS, "Max limit");
1665 
1666         address wallet = _msgSender();
1667 
1668         for(uint8 i = 1; i <= _tokenAmount; i++){
1669             _mintAnElement(wallet, total + i);
1670         }
1671     }
1672 
1673     function _mintAnElement(address _to, uint256 _tokenId) private {
1674 
1675         _tokenIdTracker.increment();
1676         ownWallet[_to]++;
1677         _safeMint(_to, _tokenId);
1678 
1679         emit welcomeToHOA(_tokenId);
1680     }
1681 
1682     function price(uint256 _count) public view returns (uint256) {
1683         return PRICE.mul(_count);
1684     }
1685 
1686     function setPause(bool _pause) public onlyOwner{
1687         PAUSE = _pause;
1688         emit PauseEvent(PAUSE);
1689     }
1690 
1691     function setPrice(uint256 _price) public onlyOwner{
1692         PRICE = _price;
1693         emit NewPriceEvent(PRICE);
1694     }
1695 
1696     function setMaxElement(uint256 _max) public onlyOwner{
1697         MAX_ELEMENTS = _max;
1698         emit NewMaxElement(MAX_ELEMENTS);
1699     }
1700 
1701     function setMetaReveal(bool _reveal, uint256 _from, uint256 _to) public onlyOwner{
1702         META_REVEAL = _reveal;
1703         HIDE_FROM = _from;
1704         HIDE_TO = _to;
1705     }
1706 
1707     function withdrawAll() public onlyOwner {
1708         uint256 balance = address(this).balance;
1709         require(balance > 0);
1710         _widthdraw(creatorAddress, address(this).balance);
1711     }
1712 
1713     function _widthdraw(address _address, uint256 _amount) private {
1714         (bool success, ) = _address.call{value: _amount}("");
1715         require(success, "Transfer failed.");
1716     }
1717 
1718     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1719         merkleRoot = _merkleRoot;
1720     }
1721 
1722     function isWhitelist(bytes32[] memory _merkleProof) public view returns (bool) {
1723        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1724        return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1725     }
1726 
1727 }