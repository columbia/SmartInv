1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.9;
4 
5 /* This contract is a subsidiary of the Hedron contract. The Hedron      *
6  *  contract can be found at 0x3819f64f282bf135d62168C1e513280dAF905e06. */
7 
8 /* Hedron is a collection of Ethereum / PulseChain smart contracts that  *
9  * build upon the HEX smart contract to provide additional functionality */
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
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
192 /**
193  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
194  * @dev See https://eips.ethereum.org/EIPS/eip-721
195  */
196 interface IERC721Metadata is IERC721 {
197     /**
198      * @dev Returns the token collection name.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the token collection symbol.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
209      */
210     function tokenURI(uint256 tokenId) external view returns (string memory);
211 }
212 
213 /**
214  * @dev Collection of functions related to the address type
215  */
216 library Address {
217     /**
218      * @dev Returns true if `account` is a contract.
219      *
220      * [IMPORTANT]
221      * ====
222      * It is unsafe to assume that an address for which this function returns
223      * false is an externally-owned account (EOA) and not a contract.
224      *
225      * Among others, `isContract` will return false for the following
226      * types of addresses:
227      *
228      *  - an externally-owned account
229      *  - a contract in construction
230      *  - an address where a contract will be created
231      *  - an address where a contract lived, but was destroyed
232      * ====
233      */
234     function isContract(address account) internal view returns (bool) {
235         // This method relies on extcodesize, which returns 0 for contracts in
236         // construction, since the code is only stored at the end of the
237         // constructor execution.
238 
239         uint256 size;
240         assembly {
241             size := extcodesize(account)
242         }
243         return size > 0;
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
581         require(owner != address(0), "ERC721: balance query for the zero address");
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
621      * by default, can be overriden in child contracts.
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
753         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
808     }
809 
810     /**
811      * @dev Destroys `tokenId`.
812      * The approval is cleared when the token is burned.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _burn(uint256 tokenId) internal virtual {
821         address owner = ERC721.ownerOf(tokenId);
822 
823         _beforeTokenTransfer(owner, address(0), tokenId);
824 
825         // Clear approvals
826         _approve(address(0), tokenId);
827 
828         _balances[owner] -= 1;
829         delete _owners[tokenId];
830 
831         emit Transfer(owner, address(0), tokenId);
832     }
833 
834     /**
835      * @dev Transfers `tokenId` from `from` to `to`.
836      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
837      *
838      * Requirements:
839      *
840      * - `to` cannot be the zero address.
841      * - `tokenId` token must be owned by `from`.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _transfer(
846         address from,
847         address to,
848         uint256 tokenId
849     ) internal virtual {
850         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
851         require(to != address(0), "ERC721: transfer to the zero address");
852 
853         _beforeTokenTransfer(from, to, tokenId);
854 
855         // Clear approvals from the previous owner
856         _approve(address(0), tokenId);
857 
858         _balances[from] -= 1;
859         _balances[to] += 1;
860         _owners[tokenId] = to;
861 
862         emit Transfer(from, to, tokenId);
863     }
864 
865     /**
866      * @dev Approve `to` to operate on `tokenId`
867      *
868      * Emits a {Approval} event.
869      */
870     function _approve(address to, uint256 tokenId) internal virtual {
871         _tokenApprovals[tokenId] = to;
872         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
873     }
874 
875     /**
876      * @dev Approve `operator` to operate on all of `owner` tokens
877      *
878      * Emits a {ApprovalForAll} event.
879      */
880     function _setApprovalForAll(
881         address owner,
882         address operator,
883         bool approved
884     ) internal virtual {
885         require(owner != operator, "ERC721: approve to caller");
886         _operatorApprovals[owner][operator] = approved;
887         emit ApprovalForAll(owner, operator, approved);
888     }
889 
890     /**
891      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
892      * The call is not executed if the target address is not a contract.
893      *
894      * @param from address representing the previous owner of the given token ID
895      * @param to target address that will receive the tokens
896      * @param tokenId uint256 ID of the token to be transferred
897      * @param _data bytes optional data to send along with the call
898      * @return bool whether the call correctly returned the expected magic value
899      */
900     function _checkOnERC721Received(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) private returns (bool) {
906         if (to.isContract()) {
907             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
908                 return retval == IERC721Receiver.onERC721Received.selector;
909             } catch (bytes memory reason) {
910                 if (reason.length == 0) {
911                     revert("ERC721: transfer to non ERC721Receiver implementer");
912                 } else {
913                     assembly {
914                         revert(add(32, reason), mload(reason))
915                     }
916                 }
917             }
918         } else {
919             return true;
920         }
921     }
922 
923     /**
924      * @dev Hook that is called before any token transfer. This includes minting
925      * and burning.
926      *
927      * Calling conditions:
928      *
929      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
930      * transferred to `to`.
931      * - When `from` is zero, `tokenId` will be minted for `to`.
932      * - When `to` is zero, ``from``'s `tokenId` will be burned.
933      * - `from` and `to` are never both zero.
934      *
935      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
936      */
937     function _beforeTokenTransfer(
938         address from,
939         address to,
940         uint256 tokenId
941     ) internal virtual {}
942 }
943 
944 /**
945  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
946  * @dev See https://eips.ethereum.org/EIPS/eip-721
947  */
948 interface IERC721Enumerable is IERC721 {
949     /**
950      * @dev Returns the total amount of tokens stored by the contract.
951      */
952     function totalSupply() external view returns (uint256);
953 
954     /**
955      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
956      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
957      */
958     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
959 
960     /**
961      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
962      * Use along with {totalSupply} to enumerate all tokens.
963      */
964     function tokenByIndex(uint256 index) external view returns (uint256);
965 }
966 
967 /**
968  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
969  * enumerability of all the token ids in the contract as well as all token ids owned by each
970  * account.
971  */
972 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
973     // Mapping from owner to list of owned token IDs
974     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
975 
976     // Mapping from token ID to index of the owner tokens list
977     mapping(uint256 => uint256) private _ownedTokensIndex;
978 
979     // Array with all token ids, used for enumeration
980     uint256[] private _allTokens;
981 
982     // Mapping from token id to position in the allTokens array
983     mapping(uint256 => uint256) private _allTokensIndex;
984 
985     /**
986      * @dev See {IERC165-supportsInterface}.
987      */
988     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
989         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
990     }
991 
992     /**
993      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
994      */
995     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
996         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
997         return _ownedTokens[owner][index];
998     }
999 
1000     /**
1001      * @dev See {IERC721Enumerable-totalSupply}.
1002      */
1003     function totalSupply() public view virtual override returns (uint256) {
1004         return _allTokens.length;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Enumerable-tokenByIndex}.
1009      */
1010     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1011         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1012         return _allTokens[index];
1013     }
1014 
1015     /**
1016      * @dev Hook that is called before any token transfer. This includes minting
1017      * and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1022      * transferred to `to`.
1023      * - When `from` is zero, `tokenId` will be minted for `to`.
1024      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      *
1028      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1029      */
1030     function _beforeTokenTransfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) internal virtual override {
1035         super._beforeTokenTransfer(from, to, tokenId);
1036 
1037         if (from == address(0)) {
1038             _addTokenToAllTokensEnumeration(tokenId);
1039         } else if (from != to) {
1040             _removeTokenFromOwnerEnumeration(from, tokenId);
1041         }
1042         if (to == address(0)) {
1043             _removeTokenFromAllTokensEnumeration(tokenId);
1044         } else if (to != from) {
1045             _addTokenToOwnerEnumeration(to, tokenId);
1046         }
1047     }
1048 
1049     /**
1050      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1051      * @param to address representing the new owner of the given token ID
1052      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1053      */
1054     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1055         uint256 length = ERC721.balanceOf(to);
1056         _ownedTokens[to][length] = tokenId;
1057         _ownedTokensIndex[tokenId] = length;
1058     }
1059 
1060     /**
1061      * @dev Private function to add a token to this extension's token tracking data structures.
1062      * @param tokenId uint256 ID of the token to be added to the tokens list
1063      */
1064     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1065         _allTokensIndex[tokenId] = _allTokens.length;
1066         _allTokens.push(tokenId);
1067     }
1068 
1069     /**
1070      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1071      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1072      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1073      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1074      * @param from address representing the previous owner of the given token ID
1075      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1076      */
1077     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1078         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1079         // then delete the last slot (swap and pop).
1080 
1081         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1082         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1083 
1084         // When the token to delete is the last token, the swap operation is unnecessary
1085         if (tokenIndex != lastTokenIndex) {
1086             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1087 
1088             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1089             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1090         }
1091 
1092         // This also deletes the contents at the last position of the array
1093         delete _ownedTokensIndex[tokenId];
1094         delete _ownedTokens[from][lastTokenIndex];
1095     }
1096 
1097     /**
1098      * @dev Private function to remove a token from this extension's token tracking data structures.
1099      * This has O(1) time complexity, but alters the order of the _allTokens array.
1100      * @param tokenId uint256 ID of the token to be removed from the tokens list
1101      */
1102     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1103         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1104         // then delete the last slot (swap and pop).
1105 
1106         uint256 lastTokenIndex = _allTokens.length - 1;
1107         uint256 tokenIndex = _allTokensIndex[tokenId];
1108 
1109         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1110         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1111         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1112         uint256 lastTokenId = _allTokens[lastTokenIndex];
1113 
1114         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1115         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1116 
1117         // This also deletes the contents at the last position of the array
1118         delete _allTokensIndex[tokenId];
1119         _allTokens.pop();
1120     }
1121 }
1122 
1123 /**
1124  * @title Counters
1125  * @author Matt Condon (@shrugs)
1126  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1127  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1128  *
1129  * Include with `using Counters for Counters.Counter;`
1130  */
1131 library Counters {
1132     struct Counter {
1133         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1134         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1135         // this feature: see https://github.com/ethereum/solidity/issues/4637
1136         uint256 _value; // default: 0
1137     }
1138 
1139     function current(Counter storage counter) internal view returns (uint256) {
1140         return counter._value;
1141     }
1142 
1143     function increment(Counter storage counter) internal {
1144         unchecked {
1145             counter._value += 1;
1146         }
1147     }
1148 
1149     function decrement(Counter storage counter) internal {
1150         uint256 value = counter._value;
1151         require(value > 0, "Counter: decrement overflow");
1152         unchecked {
1153             counter._value = value - 1;
1154         }
1155     }
1156 
1157     function reset(Counter storage counter) internal {
1158         counter._value = 0;
1159     }
1160 }
1161 
1162 /**
1163  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
1164  * deploying minimal proxy contracts, also known as "clones".
1165  *
1166  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
1167  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
1168  *
1169  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
1170  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
1171  * deterministic method.
1172  *
1173  * _Available since v3.4._
1174  */
1175 library Clones {
1176     /**
1177      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
1178      *
1179      * This function uses the create opcode, which should never revert.
1180      */
1181     function clone(address implementation) internal returns (address instance) {
1182         assembly {
1183             let ptr := mload(0x40)
1184             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1185             mstore(add(ptr, 0x14), shl(0x60, implementation))
1186             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1187             instance := create(0, ptr, 0x37)
1188         }
1189         require(instance != address(0), "ERC1167: create failed");
1190     }
1191 
1192     /**
1193      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
1194      *
1195      * This function uses the create2 opcode and a `salt` to deterministically deploy
1196      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
1197      * the clones cannot be deployed twice at the same address.
1198      */
1199     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
1200         assembly {
1201             let ptr := mload(0x40)
1202             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1203             mstore(add(ptr, 0x14), shl(0x60, implementation))
1204             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1205             instance := create2(0, ptr, 0x37, salt)
1206         }
1207         require(instance != address(0), "ERC1167: create2 failed");
1208     }
1209 
1210     /**
1211      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
1212      */
1213     function predictDeterministicAddress(
1214         address implementation,
1215         bytes32 salt,
1216         address deployer
1217     ) internal pure returns (address predicted) {
1218         assembly {
1219             let ptr := mload(0x40)
1220             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1221             mstore(add(ptr, 0x14), shl(0x60, implementation))
1222             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
1223             mstore(add(ptr, 0x38), shl(0x60, deployer))
1224             mstore(add(ptr, 0x4c), salt)
1225             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
1226             predicted := keccak256(add(ptr, 0x37), 0x55)
1227         }
1228     }
1229 
1230     /**
1231      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
1232      */
1233     function predictDeterministicAddress(address implementation, bytes32 salt)
1234         internal
1235         view
1236         returns (address predicted)
1237     {
1238         return predictDeterministicAddress(implementation, salt, address(this));
1239     }
1240 }
1241 
1242 interface IHEX {
1243     event Approval(
1244         address indexed owner,
1245         address indexed spender,
1246         uint256 value
1247     );
1248     event Claim(
1249         uint256 data0,
1250         uint256 data1,
1251         bytes20 indexed btcAddr,
1252         address indexed claimToAddr,
1253         address indexed referrerAddr
1254     );
1255     event ClaimAssist(
1256         uint256 data0,
1257         uint256 data1,
1258         uint256 data2,
1259         address indexed senderAddr
1260     );
1261     event DailyDataUpdate(uint256 data0, address indexed updaterAddr);
1262     event ShareRateChange(uint256 data0, uint40 indexed stakeId);
1263     event StakeEnd(
1264         uint256 data0,
1265         uint256 data1,
1266         address indexed stakerAddr,
1267         uint40 indexed stakeId
1268     );
1269     event StakeGoodAccounting(
1270         uint256 data0,
1271         uint256 data1,
1272         address indexed stakerAddr,
1273         uint40 indexed stakeId,
1274         address indexed senderAddr
1275     );
1276     event StakeStart(
1277         uint256 data0,
1278         address indexed stakerAddr,
1279         uint40 indexed stakeId
1280     );
1281     event Transfer(address indexed from, address indexed to, uint256 value);
1282     event XfLobbyEnter(
1283         uint256 data0,
1284         address indexed memberAddr,
1285         uint256 indexed entryId,
1286         address indexed referrerAddr
1287     );
1288     event XfLobbyExit(
1289         uint256 data0,
1290         address indexed memberAddr,
1291         uint256 indexed entryId,
1292         address indexed referrerAddr
1293     );
1294 
1295     fallback() external payable;
1296 
1297     function allocatedSupply() external view returns (uint256);
1298 
1299     function allowance(address owner, address spender)
1300         external
1301         view
1302         returns (uint256);
1303 
1304     function approve(address spender, uint256 amount) external returns (bool);
1305 
1306     function balanceOf(address account) external view returns (uint256);
1307 
1308     function btcAddressClaim(
1309         uint256 rawSatoshis,
1310         bytes32[] memory proof,
1311         address claimToAddr,
1312         bytes32 pubKeyX,
1313         bytes32 pubKeyY,
1314         uint8 claimFlags,
1315         uint8 v,
1316         bytes32 r,
1317         bytes32 s,
1318         uint256 autoStakeDays,
1319         address referrerAddr
1320     ) external returns (uint256);
1321 
1322     function btcAddressClaims(bytes20) external view returns (bool);
1323 
1324     function btcAddressIsClaimable(
1325         bytes20 btcAddr,
1326         uint256 rawSatoshis,
1327         bytes32[] memory proof
1328     ) external view returns (bool);
1329 
1330     function btcAddressIsValid(
1331         bytes20 btcAddr,
1332         uint256 rawSatoshis,
1333         bytes32[] memory proof
1334     ) external pure returns (bool);
1335 
1336     function claimMessageMatchesSignature(
1337         address claimToAddr,
1338         bytes32 claimParamHash,
1339         bytes32 pubKeyX,
1340         bytes32 pubKeyY,
1341         uint8 claimFlags,
1342         uint8 v,
1343         bytes32 r,
1344         bytes32 s
1345     ) external pure returns (bool);
1346 
1347     function currentDay() external view returns (uint256);
1348 
1349     function dailyData(uint256)
1350         external
1351         view
1352         returns (
1353             uint72 dayPayoutTotal,
1354             uint72 dayStakeSharesTotal,
1355             uint56 dayUnclaimedSatoshisTotal
1356         );
1357 
1358     function dailyDataRange(uint256 beginDay, uint256 endDay)
1359         external
1360         view
1361         returns (uint256[] memory list);
1362 
1363     function dailyDataUpdate(uint256 beforeDay) external;
1364 
1365     function decimals() external view returns (uint8);
1366 
1367     function decreaseAllowance(address spender, uint256 subtractedValue)
1368         external
1369         returns (bool);
1370 
1371     function globalInfo() external view returns (uint256[13] memory);
1372 
1373     function globals()
1374         external
1375         view
1376         returns (
1377             uint72 lockedHeartsTotal,
1378             uint72 nextStakeSharesTotal,
1379             uint40 shareRate,
1380             uint72 stakePenaltyTotal,
1381             uint16 dailyDataCount,
1382             uint72 stakeSharesTotal,
1383             uint40 latestStakeId,
1384             uint128 claimStats
1385         );
1386 
1387     function increaseAllowance(address spender, uint256 addedValue)
1388         external
1389         returns (bool);
1390 
1391     function merkleProofIsValid(bytes32 merkleLeaf, bytes32[] memory proof)
1392         external
1393         pure
1394         returns (bool);
1395 
1396     function name() external view returns (string memory);
1397 
1398     function pubKeyToBtcAddress(
1399         bytes32 pubKeyX,
1400         bytes32 pubKeyY,
1401         uint8 claimFlags
1402     ) external pure returns (bytes20);
1403 
1404     function pubKeyToEthAddress(bytes32 pubKeyX, bytes32 pubKeyY)
1405         external
1406         pure
1407         returns (address);
1408 
1409     function stakeCount(address stakerAddr) external view returns (uint256);
1410 
1411     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external;
1412 
1413     function stakeGoodAccounting(
1414         address stakerAddr,
1415         uint256 stakeIndex,
1416         uint40 stakeIdParam
1417     ) external;
1418 
1419     function stakeLists(address, uint256)
1420         external
1421         view
1422         returns (
1423             uint40 stakeId,
1424             uint72 stakedHearts,
1425             uint72 stakeShares,
1426             uint16 lockedDay,
1427             uint16 stakedDays,
1428             uint16 unlockedDay,
1429             bool isAutoStake
1430         );
1431 
1432     function stakeStart(uint256 newStakedHearts, uint256 newStakedDays)
1433         external;
1434 
1435     function symbol() external view returns (string memory);
1436 
1437     function totalSupply() external view returns (uint256);
1438 
1439     function transfer(address recipient, uint256 amount)
1440         external
1441         returns (bool);
1442 
1443     function transferFrom(
1444         address sender,
1445         address recipient,
1446         uint256 amount
1447     ) external returns (bool);
1448 
1449     function xfLobby(uint256) external view returns (uint256);
1450 
1451     function xfLobbyEnter(address referrerAddr) external payable;
1452 
1453     function xfLobbyEntry(address memberAddr, uint256 entryId)
1454         external
1455         view
1456         returns (uint256 rawAmount, address referrerAddr);
1457 
1458     function xfLobbyExit(uint256 enterDay, uint256 count) external;
1459 
1460     function xfLobbyFlush() external;
1461 
1462     function xfLobbyMembers(uint256, address)
1463         external
1464         view
1465         returns (uint40 headIndex, uint40 tailIndex);
1466 
1467     function xfLobbyPendingDays(address memberAddr)
1468         external
1469         view
1470         returns (uint256[2] memory words);
1471 
1472     function xfLobbyRange(uint256 beginDay, uint256 endDay)
1473         external
1474         view
1475         returns (uint256[] memory list);
1476 }
1477 
1478 struct HEXDailyData {
1479     uint72 dayPayoutTotal;
1480     uint72 dayStakeSharesTotal;
1481     uint56 dayUnclaimedSatoshisTotal;
1482 }
1483 
1484 struct HEXGlobals {
1485     uint72 lockedHeartsTotal;
1486     uint72 nextStakeSharesTotal;
1487     uint40 shareRate;
1488     uint72 stakePenaltyTotal;
1489     uint16 dailyDataCount;
1490     uint72 stakeSharesTotal;
1491     uint40 latestStakeId;
1492     uint128 claimStats;
1493 }
1494 
1495 struct HEXStake {
1496     uint40 stakeId;
1497     uint72 stakedHearts;
1498     uint72 stakeShares;
1499     uint16 lockedDay;
1500     uint16 stakedDays;
1501     uint16 unlockedDay;
1502     bool   isAutoStake;
1503 }
1504 
1505 struct HEXStakeMinimal {
1506     uint40 stakeId;
1507     uint72 stakeShares;
1508     uint16 lockedDay;
1509     uint16 stakedDays;
1510 }
1511 
1512 struct ShareStore {
1513     HEXStakeMinimal stake;
1514     uint16          mintedDays;
1515     uint8           launchBonus;
1516     uint16          loanStart;
1517     uint16          loanedDays;
1518     uint32          interestRate;
1519     uint8           paymentsMade;
1520     bool            isLoaned;
1521 }
1522 
1523 struct ShareCache {
1524     HEXStakeMinimal _stake;
1525     uint256         _mintedDays;
1526     uint256         _launchBonus;
1527     uint256         _loanStart;
1528     uint256         _loanedDays;
1529     uint256         _interestRate;
1530     uint256         _paymentsMade;
1531     bool            _isLoaned;
1532 }
1533 
1534 address constant _hdrnSourceAddress = address(0x9d73Ced2e36C89E5d167151809eeE218a189f801);
1535 address constant _hdrnFlowAddress   = address(0xF447BE386164dADfB5d1e7622613f289F17024D8);
1536 uint256 constant _hdrnLaunch        = 1645833600;
1537 
1538 contract HEXStakeInstance {
1539     
1540     IHEX       private _hx;
1541     address    private _creator;
1542     ShareStore public  share;
1543 
1544     /**
1545      * @dev Updates the HSI's internal HEX stake data.
1546      */
1547     function _stakeDataUpdate(
1548     )
1549         internal
1550     {
1551         uint40 stakeId;
1552         uint72 stakedHearts;
1553         uint72 stakeShares;
1554         uint16 lockedDay;
1555         uint16 stakedDays;
1556         uint16 unlockedDay;
1557         bool   isAutoStake;
1558         
1559         (stakeId,
1560          stakedHearts,
1561          stakeShares,
1562          lockedDay,
1563          stakedDays,
1564          unlockedDay,
1565          isAutoStake
1566         ) = _hx.stakeLists(address(this), 0);
1567 
1568         share.stake.stakeId = stakeId;
1569         share.stake.stakeShares = stakeShares;
1570         share.stake.lockedDay = lockedDay;
1571         share.stake.stakedDays = stakedDays;
1572     }
1573 
1574     function initialize(
1575         address hexAddress
1576     ) 
1577         external 
1578     {
1579         require(_creator == address(0),
1580             "HSI: Initialization already performed");
1581 
1582         /* _creator is not an admin key. It is set at contsruction to be a link
1583            to the parent contract. In this case HSIM */
1584         _creator = msg.sender;
1585 
1586         // set HEX contract address
1587         _hx = IHEX(payable(hexAddress));
1588     }
1589 
1590     /**
1591      * @dev Creates a new HEX stake using all HEX ERC20 tokens assigned
1592      *      to the HSI's contract address. This is a privileged operation only
1593      *      HEXStakeInstanceManager.sol can call.
1594      * @param stakeLength Number of days the HEX ERC20 tokens will be staked.
1595      */
1596     function create(
1597         uint256 stakeLength
1598     )
1599         external
1600     {
1601         uint256 hexBalance = _hx.balanceOf(address(this));
1602 
1603         require(msg.sender == _creator,
1604             "HSI: Caller must be contract creator");
1605         require(share.stake.stakedDays == 0,
1606             "HSI: Creation already performed");
1607         require(hexBalance > 0,
1608             "HSI: Creation requires a non-zero HEX balance");
1609 
1610         _hx.stakeStart(
1611             hexBalance,
1612             stakeLength
1613         );
1614 
1615         _stakeDataUpdate();
1616     }
1617 
1618     /**
1619      * @dev Calls the HEX function "stakeGoodAccounting" against the
1620      *      HEX stake held within the HSI.
1621      */
1622     function goodAccounting(
1623     )
1624         external
1625     {
1626         require(share.stake.stakedDays > 0,
1627             "HSI: Creation not yet performed");
1628 
1629         _hx.stakeGoodAccounting(address(this), 0, share.stake.stakeId);
1630 
1631         _stakeDataUpdate();
1632     }
1633 
1634     /**
1635      * @dev Ends the HEX stake, approves the "_creator" address to transfer
1636      *      all HEX ERC20 tokens, and self-destructs the HSI. This is a 
1637      *      privileged operation only HEXStakeInstanceManager.sol can call.
1638      */
1639     function destroy(
1640     )
1641         external
1642     {
1643         require(msg.sender == _creator,
1644             "HSI: Caller must be contract creator");
1645         require(share.stake.stakedDays > 0,
1646             "HSI: Creation not yet performed");
1647 
1648         _hx.stakeEnd(0, share.stake.stakeId);
1649         
1650         uint256 hexBalance = _hx.balanceOf(address(this));
1651 
1652         if (_hx.approve(_creator, hexBalance)) {
1653             selfdestruct(payable(_creator));
1654         }
1655         else {
1656             revert();
1657         }
1658     }
1659 
1660     /**
1661      * @dev Updates the HSI's internal share data. This is a privileged 
1662      *      operation only HEXStakeInstanceManager.sol can call.
1663      * @param _share "ShareCache" object containing updated share data.
1664      */
1665     function update(
1666         ShareCache memory _share
1667     )
1668         external 
1669     {
1670         require(msg.sender == _creator,
1671             "HSI: Caller must be contract creator");
1672 
1673         share.mintedDays   = uint16(_share._mintedDays);
1674         share.launchBonus  = uint8 (_share._launchBonus);
1675         share.loanStart    = uint16(_share._loanStart);
1676         share.loanedDays   = uint16(_share._loanedDays);
1677         share.interestRate = uint32(_share._interestRate);
1678         share.paymentsMade = uint8 (_share._paymentsMade);
1679         share.isLoaned     = _share._isLoaned;
1680     }
1681 
1682     /**
1683      * @dev Fetches stake data from the HEX contract.
1684      * @return A "HEXStake" object containg the HEX stake data. 
1685      */
1686     function stakeDataFetch(
1687     ) 
1688         external
1689         view
1690         returns(HEXStake memory)
1691     {
1692         uint40 stakeId;
1693         uint72 stakedHearts;
1694         uint72 stakeShares;
1695         uint16 lockedDay;
1696         uint16 stakedDays;
1697         uint16 unlockedDay;
1698         bool   isAutoStake;
1699         
1700         (stakeId,
1701          stakedHearts,
1702          stakeShares,
1703          lockedDay,
1704          stakedDays,
1705          unlockedDay,
1706          isAutoStake
1707         ) = _hx.stakeLists(address(this), 0);
1708 
1709         return HEXStake(
1710             stakeId,
1711             stakedHearts,
1712             stakeShares,
1713             lockedDay,
1714             stakedDays,
1715             unlockedDay,
1716             isAutoStake
1717         );
1718     }
1719 }
1720 
1721 interface IHedron {
1722     event Approval(
1723         address indexed owner,
1724         address indexed spender,
1725         uint256 value
1726     );
1727     event Claim(uint256 data, address indexed claimant, uint40 indexed stakeId);
1728     event LoanEnd(
1729         uint256 data,
1730         address indexed borrower,
1731         uint40 indexed stakeId
1732     );
1733     event LoanLiquidateBid(
1734         uint256 data,
1735         address indexed bidder,
1736         uint40 indexed stakeId,
1737         uint40 indexed liquidationId
1738     );
1739     event LoanLiquidateExit(
1740         uint256 data,
1741         address indexed liquidator,
1742         uint40 indexed stakeId,
1743         uint40 indexed liquidationId
1744     );
1745     event LoanLiquidateStart(
1746         uint256 data,
1747         address indexed borrower,
1748         uint40 indexed stakeId,
1749         uint40 indexed liquidationId
1750     );
1751     event LoanPayment(
1752         uint256 data,
1753         address indexed borrower,
1754         uint40 indexed stakeId
1755     );
1756     event LoanStart(
1757         uint256 data,
1758         address indexed borrower,
1759         uint40 indexed stakeId
1760     );
1761     event Mint(uint256 data, address indexed minter, uint40 indexed stakeId);
1762     event Transfer(address indexed from, address indexed to, uint256 value);
1763 
1764     function allowance(address owner, address spender)
1765         external
1766         view
1767         returns (uint256);
1768 
1769     function approve(address spender, uint256 amount) external returns (bool);
1770 
1771     function balanceOf(address account) external view returns (uint256);
1772 
1773     function calcLoanPayment(
1774         address borrower,
1775         uint256 hsiIndex,
1776         address hsiAddress
1777     ) external view returns (uint256, uint256);
1778 
1779     function calcLoanPayoff(
1780         address borrower,
1781         uint256 hsiIndex,
1782         address hsiAddress
1783     ) external view returns (uint256, uint256);
1784 
1785     function claimInstanced(
1786         uint256 hsiIndex,
1787         address hsiAddress,
1788         address hsiStarterAddress
1789     ) external;
1790 
1791     function claimNative(uint256 stakeIndex, uint40 stakeId)
1792         external
1793         returns (uint256);
1794 
1795     function currentDay() external view returns (uint256);
1796 
1797     function dailyDataList(uint256)
1798         external
1799         view
1800         returns (
1801             uint72 dayMintedTotal,
1802             uint72 dayLoanedTotal,
1803             uint72 dayBurntTotal,
1804             uint32 dayInterestRate,
1805             uint8 dayMintMultiplier
1806         );
1807 
1808     function decimals() external view returns (uint8);
1809 
1810     function decreaseAllowance(address spender, uint256 subtractedValue)
1811         external
1812         returns (bool);
1813 
1814     function hsim() external view returns (address);
1815 
1816     function increaseAllowance(address spender, uint256 addedValue)
1817         external
1818         returns (bool);
1819 
1820     function liquidationList(uint256)
1821         external
1822         view
1823         returns (
1824             uint256 liquidationStart,
1825             address hsiAddress,
1826             uint96 bidAmount,
1827             address liquidator,
1828             uint88 endOffset,
1829             bool isActive
1830         );
1831 
1832     function loanInstanced(uint256 hsiIndex, address hsiAddress)
1833         external
1834         returns (uint256);
1835 
1836     function loanLiquidate(
1837         address owner,
1838         uint256 hsiIndex,
1839         address hsiAddress
1840     ) external returns (uint256);
1841 
1842     function loanLiquidateBid(uint256 liquidationId, uint256 liquidationBid)
1843         external
1844         returns (uint256);
1845 
1846     function loanLiquidateExit(uint256 hsiIndex, uint256 liquidationId)
1847         external
1848         returns (address);
1849 
1850     function loanPayment(uint256 hsiIndex, address hsiAddress)
1851         external
1852         returns (uint256);
1853 
1854     function loanPayoff(uint256 hsiIndex, address hsiAddress)
1855         external
1856         returns (uint256);
1857 
1858     function loanedSupply() external view returns (uint256);
1859 
1860     function mintInstanced(uint256 hsiIndex, address hsiAddress)
1861         external
1862         returns (uint256);
1863 
1864     function mintNative(uint256 stakeIndex, uint40 stakeId)
1865         external
1866         returns (uint256);
1867 
1868     function name() external view returns (string memory);
1869 
1870     function proofOfBenevolence(uint256 amount) external;
1871 
1872     function shareList(uint256)
1873         external
1874         view
1875         returns (
1876             HEXStakeMinimal memory stake,
1877             uint16 mintedDays,
1878             uint8 launchBonus,
1879             uint16 loanStart,
1880             uint16 loanedDays,
1881             uint32 interestRate,
1882             uint8 paymentsMade,
1883             bool isLoaned
1884         );
1885 
1886     function symbol() external view returns (string memory);
1887 
1888     function totalSupply() external view returns (uint256);
1889 
1890     function transfer(address recipient, uint256 amount)
1891         external
1892         returns (bool);
1893 
1894     function transferFrom(
1895         address sender,
1896         address recipient,
1897         uint256 amount
1898     ) external returns (bool);
1899 }
1900 
1901 library LibPart {
1902     bytes32 public constant TYPE_HASH = keccak256("Part(address account,uint96 value)");
1903 
1904     struct Part {
1905         address payable account;
1906         uint96 value;
1907     }
1908 
1909     function hash(Part memory part) internal pure returns (bytes32) {
1910         return keccak256(abi.encode(TYPE_HASH, part.account, part.value));
1911     }
1912 }
1913 
1914 abstract contract AbstractRoyalties {
1915     mapping (uint256 => LibPart.Part[]) internal royalties;
1916 
1917     function _saveRoyalties(uint256 id, LibPart.Part[] memory _royalties) internal {
1918         uint256 totalValue;
1919         for (uint i = 0; i < _royalties.length; i++) {
1920             require(_royalties[i].account != address(0x0), "Recipient should be present");
1921             require(_royalties[i].value != 0, "Royalty value should be positive");
1922             totalValue += _royalties[i].value;
1923             royalties[id].push(_royalties[i]);
1924         }
1925         require(totalValue < 10000, "Royalty total value should be < 10000");
1926         _onRoyaltiesSet(id, _royalties);
1927     }
1928 
1929     function _updateAccount(uint256 _id, address _from, address _to) internal {
1930         uint length = royalties[_id].length;
1931         for(uint i = 0; i < length; i++) {
1932             if (royalties[_id][i].account == _from) {
1933                 royalties[_id][i].account = payable(address(uint160(_to)));
1934             }
1935         }
1936     }
1937 
1938     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) virtual internal;
1939 }
1940 
1941 interface RoyaltiesV2 {
1942     event RoyaltiesSet(uint256 tokenId, LibPart.Part[] royalties);
1943 
1944     function getRaribleV2Royalties(uint256 id) external view returns (LibPart.Part[] memory);
1945 }
1946 
1947 contract RoyaltiesV2Impl is AbstractRoyalties, RoyaltiesV2 {
1948 
1949     function getRaribleV2Royalties(uint256 id) override external view returns (LibPart.Part[] memory) {
1950         return royalties[id];
1951     }
1952 
1953     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) override internal {
1954         emit RoyaltiesSet(id, _royalties);
1955     }
1956 }
1957 
1958 library LibRoyaltiesV2 {
1959     /*
1960      * bytes4(keccak256('getRaribleV2Royalties(uint256)')) == 0xcad96cca
1961      */
1962     bytes4 constant _INTERFACE_ID_ROYALTIES = 0xcad96cca;
1963 }
1964 
1965 contract HEXStakeInstanceManager is ERC721, ERC721Enumerable, RoyaltiesV2Impl {
1966 
1967     using Counters for Counters.Counter;
1968 
1969     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1970     uint96 private constant _hsimRoyaltyBasis = 15; // Rarible V2 royalty basis
1971     string private constant _hostname = "https://api.hedron.pro/";
1972     string private constant _endpoint = "/hsi/";
1973     
1974     Counters.Counter private _tokenIds;
1975     address          private _creator;
1976     IHEX             private _hx;
1977     address          private _hxAddress;
1978     address          private _hsiImplementation;
1979 
1980     mapping(address => address[]) public  hsiLists;
1981     mapping(uint256 => address)   public  hsiToken;
1982  
1983     constructor(
1984         address hexAddress
1985     )
1986         ERC721("HEX Stake Instance", "HSI")
1987     {
1988         /* _creator is not an admin key. It is set at contsruction to be a link
1989            to the parent contract. In this case Hedron */
1990         _creator = msg.sender;
1991 
1992         // set HEX contract address
1993         _hx = IHEX(payable(hexAddress));
1994         _hxAddress = hexAddress;
1995 
1996         // create HSI implementation
1997         _hsiImplementation = address(new HEXStakeInstance());
1998         
1999         // initialize the HSI just in case
2000         HEXStakeInstance hsi = HEXStakeInstance(_hsiImplementation);
2001         hsi.initialize(hexAddress);
2002     }
2003 
2004     function _baseURI(
2005     )
2006         internal
2007         view
2008         virtual
2009         override
2010         returns (string memory)
2011     {
2012         string memory chainid = Strings.toString(block.chainid);
2013         return string(abi.encodePacked(_hostname, chainid, _endpoint));
2014     }
2015 
2016     function _beforeTokenTransfer(
2017         address from,
2018         address to,
2019         uint256 tokenId
2020     )
2021         internal
2022         override(ERC721, ERC721Enumerable) 
2023     {
2024         super._beforeTokenTransfer(from, to, tokenId);
2025     }
2026 
2027     event HSIStart(
2028         uint256         timestamp,
2029         address indexed hsiAddress,
2030         address indexed staker
2031     );
2032 
2033     event HSIEnd(
2034         uint256         timestamp,
2035         address indexed hsiAddress,
2036         address indexed staker
2037     );
2038 
2039     event HSITransfer(
2040         uint256         timestamp,
2041         address indexed hsiAddress,
2042         address indexed oldStaker,
2043         address indexed newStaker
2044     );
2045 
2046     event HSITokenize(
2047         uint256         timestamp,
2048         uint256 indexed hsiTokenId,
2049         address indexed hsiAddress,
2050         address indexed staker
2051     );
2052 
2053     event HSIDetokenize(
2054         uint256         timestamp,
2055         uint256 indexed hsiTokenId,
2056         address indexed hsiAddress,
2057         address indexed staker
2058     );
2059 
2060     /**
2061      * @dev Removes a HEX stake instance (HSI) contract address from an address mapping.
2062      * @param hsiList A mapped list of HSI contract addresses.
2063      * @param hsiIndex The index of the HSI contract address which will be removed.
2064      */
2065     function _pruneHSI(
2066         address[] storage hsiList,
2067         uint256 hsiIndex
2068     )
2069         internal
2070     {
2071         uint256 lastIndex = hsiList.length - 1;
2072 
2073         if (hsiIndex != lastIndex) {
2074             hsiList[hsiIndex] = hsiList[lastIndex];
2075         }
2076 
2077         hsiList.pop();
2078     }
2079 
2080     /**
2081      * @dev Loads share data from a HEX stake instance (HSI) into a "ShareCache" object.
2082      * @param hsi A HSI contract object from which share data will be loaded.
2083      * @return "ShareCache" object containing the loaded share data.
2084      */
2085     function _hsiLoad(
2086         HEXStakeInstance hsi
2087     ) 
2088         internal
2089         view
2090         returns (ShareCache memory)
2091     {
2092         HEXStakeMinimal memory stake;
2093         uint16                 mintedDays;
2094         uint8                  launchBonus;
2095         uint16                 loanStart;
2096         uint16                 loanedDays;
2097         uint32                 interestRate;
2098         uint8                  paymentsMade;
2099         bool                   isLoaned;
2100 
2101         (stake,
2102          mintedDays,
2103          launchBonus,
2104          loanStart,
2105          loanedDays,
2106          interestRate,
2107          paymentsMade,
2108          isLoaned) = hsi.share();
2109 
2110         return ShareCache(
2111             stake,
2112             mintedDays,
2113             launchBonus,
2114             loanStart,
2115             loanedDays,
2116             interestRate,
2117             paymentsMade,
2118             isLoaned
2119         );
2120     }
2121 
2122     // Internal NFT Marketplace Glue
2123 
2124     /** @dev Sets the Rarible V2 royalties on a specific token
2125      *  @param tokenId Unique ID of the HSI NFT token.
2126      */
2127     function _setRoyalties(
2128         uint256 tokenId
2129     )
2130         internal
2131     {
2132         LibPart.Part[] memory _royalties = new LibPart.Part[](1);
2133         _royalties[0].value = _hsimRoyaltyBasis;
2134         _royalties[0].account = payable(_hdrnFlowAddress);
2135         _saveRoyalties(tokenId, _royalties);
2136     }
2137 
2138     /**
2139      * @dev Retreives the number of HSI elements in an addresses HSI list.
2140      * @param user Address to retrieve the HSI list for.
2141      * @return Number of HSI elements found within the HSI list.
2142      */
2143     function hsiCount(
2144         address user
2145     )
2146         public
2147         view
2148         returns (uint256)
2149     {
2150         return hsiLists[user].length;
2151     }
2152 
2153     /**
2154      * @dev Wrapper function for hsiCount to allow HEX based applications to pull stake data.
2155      * @param user Address to retrieve the HSI list for.
2156      * @return Number of HSI elements found within the HSI list. 
2157      */
2158     function stakeCount(
2159         address user
2160     )
2161         external
2162         view
2163         returns (uint256)
2164     {
2165         return hsiCount(user);
2166     }
2167 
2168     /**
2169      * @dev Wrapper function for hsiLists to allow HEX based applications to pull stake data.
2170      * @param user Address to retrieve the HSI list for.
2171      * @param hsiIndex The index of the HSI contract address which will returned. 
2172      * @return "HEXStake" object containing HEX stake data. 
2173      */
2174     function stakeLists(
2175         address user,
2176         uint256 hsiIndex
2177     )
2178         external
2179         view
2180         returns (HEXStake memory)
2181     {
2182         address[] storage hsiList = hsiLists[user];
2183 
2184         HEXStakeInstance hsi = HEXStakeInstance(hsiList[hsiIndex]);
2185 
2186         return hsi.stakeDataFetch();
2187     }
2188 
2189     /**
2190      * @dev Creates a new HEX stake instance (HSI), transfers HEX ERC20 tokens to the
2191      *      HSI's contract address, and calls the "initialize" function.
2192      * @param amount Number of HEX ERC20 tokens to be staked.
2193      * @param length Number of days the HEX ERC20 tokens will be staked.
2194      * @return Address of the newly created HSI contract.
2195      */
2196     function hexStakeStart (
2197         uint256 amount,
2198         uint256 length
2199     )
2200         external
2201         returns (address)
2202     {
2203         require(amount <= _hx.balanceOf(msg.sender),
2204             "HSIM: Insufficient HEX to facilitate stake");
2205 
2206         address[] storage hsiList = hsiLists[msg.sender];
2207 
2208         address hsiAddress = Clones.clone(_hsiImplementation);
2209         HEXStakeInstance hsi = HEXStakeInstance(hsiAddress);
2210         hsi.initialize(_hxAddress);
2211 
2212         hsiList.push(hsiAddress);
2213         uint256 hsiIndex = hsiList.length - 1;
2214 
2215         require(_hx.transferFrom(msg.sender, hsiAddress, amount),
2216             "HSIM: HEX transfer from message sender to HSIM failed");
2217 
2218         hsi.create(length);
2219 
2220         IHedron hedron = IHedron(_creator);
2221         hedron.claimInstanced(hsiIndex, hsiAddress, msg.sender);
2222 
2223         emit HSIStart(block.timestamp, hsiAddress, msg.sender);
2224 
2225         return hsiAddress;
2226     }
2227 
2228     /**
2229      * @dev Calls the HEX stake instance (HSI) function "destroy", transfers HEX ERC20 tokens
2230      *      from the HSI's contract address to the senders address.
2231      * @param hsiIndex Index of the HSI contract's address in the caller's HSI list.
2232      * @param hsiAddress Address of the HSI contract in which to call the "destroy" function.
2233      * @return Amount of HEX ERC20 tokens awarded via ending the HEX stake.
2234      */
2235     function hexStakeEnd (
2236         uint256 hsiIndex,
2237         address hsiAddress
2238     )
2239         external
2240         returns (uint256)
2241     {
2242         address[] storage hsiList = hsiLists[msg.sender];
2243 
2244         require(hsiAddress == hsiList[hsiIndex],
2245             "HSIM: HSI index address mismatch");
2246 
2247         HEXStakeInstance hsi = HEXStakeInstance(hsiAddress);
2248         ShareCache memory share = _hsiLoad(hsi);
2249 
2250         require (share._isLoaned == false,
2251             "HSIM: Cannot call stakeEnd against a loaned stake");
2252 
2253         hsi.destroy();
2254 
2255         emit HSIEnd(block.timestamp, hsiAddress, msg.sender);
2256 
2257         uint256 hsiBalance = _hx.balanceOf(hsiAddress);
2258 
2259         if (hsiBalance > 0) {
2260             require(_hx.transferFrom(hsiAddress, msg.sender, hsiBalance),
2261                 "HSIM: HEX transfer from HSI failed");
2262         }
2263 
2264         _pruneHSI(hsiList, hsiIndex);
2265 
2266         return hsiBalance;
2267     }
2268 
2269     /**
2270      * @dev Converts a HEX stake instance (HSI) contract address mapping into a
2271      *      HSI ERC721 token.
2272      * @param hsiIndex Index of the HSI contract's address in the caller's HSI list.
2273      * @param hsiAddress Address of the HSI contract to be converted.
2274      * @return Token ID of the newly minted HSI ERC721 token.
2275      */
2276     function hexStakeTokenize (
2277         uint256 hsiIndex,
2278         address hsiAddress
2279     )
2280         external
2281         returns (uint256)
2282     {
2283         address[] storage hsiList = hsiLists[msg.sender];
2284 
2285         require(hsiAddress == hsiList[hsiIndex],
2286             "HSIM: HSI index address mismatch");
2287 
2288         HEXStakeInstance hsi = HEXStakeInstance(hsiAddress);
2289         ShareCache memory share = _hsiLoad(hsi);
2290 
2291         require (share._isLoaned == false,
2292             "HSIM: Cannot tokenize a loaned stake");
2293 
2294         _tokenIds.increment();
2295 
2296         uint256 newTokenId = _tokenIds.current();
2297 
2298         _mint(msg.sender, newTokenId);
2299          hsiToken[newTokenId] = hsiAddress;
2300 
2301         _setRoyalties(newTokenId);
2302 
2303         _pruneHSI(hsiList, hsiIndex);
2304 
2305         emit HSITokenize(
2306             block.timestamp,
2307             newTokenId,
2308             hsiAddress,
2309             msg.sender
2310         );
2311 
2312         return newTokenId;
2313     }
2314 
2315     /**
2316      * @dev Converts a HEX stake instance (HSI) ERC721 token into an address mapping.
2317      * @param tokenId ID of the HSI ERC721 token to be converted.
2318      * @return Address of the detokenized HSI contract.
2319      */
2320     function hexStakeDetokenize (
2321         uint256 tokenId
2322     )
2323         external
2324         returns (address)
2325     {
2326         require(ownerOf(tokenId) == msg.sender,
2327             "HSIM: Detokenization requires token ownership");
2328 
2329         address hsiAddress = hsiToken[tokenId];
2330         address[] storage hsiList = hsiLists[msg.sender];
2331 
2332         hsiList.push(hsiAddress);
2333         hsiToken[tokenId] = address(0);
2334 
2335         _burn(tokenId);
2336 
2337         emit HSIDetokenize(
2338             block.timestamp,
2339             tokenId, 
2340             hsiAddress,
2341             msg.sender
2342         );
2343 
2344         return hsiAddress;
2345     }
2346 
2347     /**
2348      * @dev Updates the share data of a HEX stake instance (HSI) contract.
2349      *      This is a pivileged operation only Hedron.sol can call.
2350      * @param holder Address of the HSI contract owner.
2351      * @param hsiIndex Index of the HSI contract's address in the holder's HSI list.
2352      * @param hsiAddress Address of the HSI contract to be updated.
2353      * @param share "ShareCache" object containing updated share data.
2354      */
2355     function hsiUpdate (
2356         address holder,
2357         uint256 hsiIndex,
2358         address hsiAddress,
2359         ShareCache memory share
2360     )
2361         external
2362     {
2363         require(msg.sender == _creator,
2364             "HSIM: Caller must be contract creator");
2365 
2366         address[] storage hsiList = hsiLists[holder];
2367 
2368         require(hsiAddress == hsiList[hsiIndex],
2369             "HSIM: HSI index address mismatch");
2370 
2371         HEXStakeInstance hsi = HEXStakeInstance(hsiAddress);
2372         hsi.update(share);
2373     }
2374 
2375     /**
2376      * @dev Transfers ownership of a HEX stake instance (HSI) contract to a new address.
2377      *      This is a pivileged operation only Hedron.sol can call. End users can use
2378      *      the NFT tokenize / detokenize to handle HSI transfers.
2379      * @param currentHolder Address to transfer the HSI contract from.
2380      * @param hsiIndex Index of the HSI contract's address in the currentHolder's HSI list.
2381      * @param hsiAddress Address of the HSI contract to be transfered.
2382      * @param newHolder Address to transfer to HSI contract to.
2383      */
2384     function hsiTransfer (
2385         address currentHolder,
2386         uint256 hsiIndex,
2387         address hsiAddress,
2388         address newHolder
2389     )
2390         external
2391     {
2392         require(msg.sender == _creator,
2393             "HSIM: Caller must be contract creator");
2394 
2395         address[] storage hsiListCurrent = hsiLists[currentHolder];
2396         address[] storage hsiListNew = hsiLists[newHolder];
2397 
2398         require(hsiAddress == hsiListCurrent[hsiIndex],
2399             "HSIM: HSI index address mismatch");
2400 
2401         hsiListNew.push(hsiAddress);
2402         _pruneHSI(hsiListCurrent, hsiIndex);
2403 
2404         emit HSITransfer(
2405                     block.timestamp,
2406                     hsiAddress,
2407                     currentHolder,
2408                     newHolder
2409                 );
2410     }
2411 
2412     // External NFT Marketplace Glue
2413 
2414     /**
2415      * @dev Implements ERC2981 royalty functionality. We just read the royalty data from
2416      *      the Rarible V2 implementation. 
2417      * @param tokenId Unique ID of the HSI NFT token.
2418      * @param salePrice Price the HSI NFT token was sold for.
2419      * @return receiver address to send the royalties to as well as the royalty amount.
2420      */
2421     function royaltyInfo(
2422         uint256 tokenId,
2423         uint256 salePrice
2424     )
2425         external
2426         view
2427         returns (address receiver, uint256 royaltyAmount)
2428     {
2429         LibPart.Part[] memory _royalties = royalties[tokenId];
2430         
2431         if (_royalties.length > 0) {
2432             return (_royalties[0].account, (salePrice * _royalties[0].value) / 10000);
2433         }
2434 
2435         return (address(0), 0);
2436     }
2437 
2438     /**
2439      * @dev returns _hdrnFlowAddress, needed for some NFT marketplaces. This is not
2440      *       an admin key.
2441      * @return _hdrnFlowAddress
2442      */
2443     function owner(
2444     )
2445         external
2446         pure
2447         returns (address) 
2448     {
2449         return _hdrnFlowAddress;
2450     }
2451 
2452     /**
2453      * @dev Adds Rarible V2 and ERC2981 interface support.
2454      * @param interfaceId Unique contract interface identifier.
2455      * @return True if the interface is supported, false if not.
2456      */
2457     function supportsInterface(
2458         bytes4 interfaceId
2459     )
2460         public
2461         view
2462         virtual
2463         override(ERC721, ERC721Enumerable)
2464         returns (bool)
2465     {
2466         if (interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
2467             return true;
2468         }
2469 
2470         if (interfaceId == _INTERFACE_ID_ERC2981) {
2471             return true;
2472         }
2473 
2474         return super.supportsInterface(interfaceId);
2475     }
2476 }