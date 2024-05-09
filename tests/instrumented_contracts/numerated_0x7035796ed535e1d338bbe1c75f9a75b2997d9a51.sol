1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129 
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141 
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 }
169 
170 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @title ERC721 token receiver interface
179  * @dev Interface for any contract that wants to support safeTransfers
180  * from ERC721 asset contracts.
181  */
182 interface IERC721Receiver {
183     /**
184      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
185      * by `operator` from `from`, this function is called.
186      *
187      * It must return its Solidity selector to confirm the token transfer.
188      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
189      *
190      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
191      */
192     function onERC721Received(
193         address operator,
194         address from,
195         uint256 tokenId,
196         bytes calldata data
197     ) external returns (bytes4);
198 }
199 
200 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
209  * @dev See https://eips.ethereum.org/EIPS/eip-721
210  */
211 interface IERC721Metadata is IERC721 {
212     /**
213      * @dev Returns the token collection name.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the token collection symbol.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
224      */
225     function tokenURI(uint256 tokenId) external view returns (string memory);
226 }
227 
228 // File: @openzeppelin/contracts/utils/Address.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
232 
233 pragma solidity ^0.8.1;
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      *
256      * [IMPORTANT]
257      * ====
258      * You shouldn't rely on `isContract` to protect against flash loan attacks!
259      *
260      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
261      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
262      * constructor.
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize/address.code.length, which returns 0
267         // for contracts in construction, since the code is only stored at the end
268         // of the constructor execution.
269 
270         return account.code.length > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 // File: @openzeppelin/contracts/utils/Context.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev Provides information about the current execution context, including the
462  * sender of the transaction and its data. While these are generally available
463  * via msg.sender and msg.data, they should not be accessed in such a direct
464  * manner, since when dealing with meta-transactions the account sending and
465  * paying for execution may not be the actual sender (as far as an application
466  * is concerned).
467  *
468  * This contract is only required for intermediate, library-like contracts.
469  */
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes calldata) {
476         return msg.data;
477     }
478 }
479 
480 // File: @openzeppelin/contracts/utils/Strings.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev String operations.
489  */
490 library Strings {
491     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
495      */
496     function toString(uint256 value) internal pure returns (string memory) {
497         // Inspired by OraclizeAPI's implementation - MIT licence
498         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
499 
500         if (value == 0) {
501             return "0";
502         }
503         uint256 temp = value;
504         uint256 digits;
505         while (temp != 0) {
506             digits++;
507             temp /= 10;
508         }
509         bytes memory buffer = new bytes(digits);
510         while (value != 0) {
511             digits -= 1;
512             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
513             value /= 10;
514         }
515         return string(buffer);
516     }
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
520      */
521     function toHexString(uint256 value) internal pure returns (string memory) {
522         if (value == 0) {
523             return "0x00";
524         }
525         uint256 temp = value;
526         uint256 length = 0;
527         while (temp != 0) {
528             length++;
529             temp >>= 8;
530         }
531         return toHexString(value, length);
532     }
533 
534     /**
535      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
536      */
537     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
538         bytes memory buffer = new bytes(2 * length + 2);
539         buffer[0] = "0";
540         buffer[1] = "x";
541         for (uint256 i = 2 * length + 1; i > 1; --i) {
542             buffer[i] = _HEX_SYMBOLS[value & 0xf];
543             value >>= 4;
544         }
545         require(value == 0, "Strings: hex length insufficient");
546         return string(buffer);
547     }
548 }
549 
550 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev Implementation of the {IERC165} interface.
559  *
560  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
561  * for the additional interface id that will be supported. For example:
562  *
563  * ```solidity
564  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
566  * }
567  * ```
568  *
569  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
570  */
571 abstract contract ERC165 is IERC165 {
572     /**
573      * @dev See {IERC165-supportsInterface}.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576         return interfaceId == type(IERC165).interfaceId;
577     }
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 
589 
590 
591 
592 
593 /**
594  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
595  * the Metadata extension, but not including the Enumerable extension, which is available separately as
596  * {ERC721Enumerable}.
597  */
598 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
599     using Address for address;
600     using Strings for uint256;
601 
602     // Token name
603     string private _name;
604 
605     // Token symbol
606     string private _symbol;
607 
608     // Mapping from token ID to owner address
609     mapping(uint256 => address) private _owners;
610 
611     // Mapping owner address to token count
612     mapping(address => uint256) private _balances;
613 
614     // Mapping from token ID to approved address
615     mapping(uint256 => address) private _tokenApprovals;
616 
617     // Mapping from owner to operator approvals
618     mapping(address => mapping(address => bool)) private _operatorApprovals;
619 
620     /**
621      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
622      */
623     constructor(string memory name_, string memory symbol_) {
624         _name = name_;
625         _symbol = symbol_;
626     }
627 
628     /**
629      * @dev See {IERC165-supportsInterface}.
630      */
631     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
632         return
633             interfaceId == type(IERC721).interfaceId ||
634             interfaceId == type(IERC721Metadata).interfaceId ||
635             super.supportsInterface(interfaceId);
636     }
637 
638     /**
639      * @dev See {IERC721-balanceOf}.
640      */
641     function balanceOf(address owner) public view virtual override returns (uint256) {
642         require(owner != address(0), "ERC721: balance query for the zero address");
643         return _balances[owner];
644     }
645 
646     /**
647      * @dev See {IERC721-ownerOf}.
648      */
649     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
650         address owner = _owners[tokenId];
651         require(owner != address(0), "ERC721: owner query for nonexistent token");
652         return owner;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-name}.
657      */
658     function name() public view virtual override returns (string memory) {
659         return _name;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-symbol}.
664      */
665     function symbol() public view virtual override returns (string memory) {
666         return _symbol;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-tokenURI}.
671      */
672     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
673         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
674 
675         string memory baseURI = _baseURI();
676         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
677     }
678 
679     /**
680      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
681      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
682      * by default, can be overriden in child contracts.
683      */
684     function _baseURI() internal view virtual returns (string memory) {
685         return "";
686     }
687 
688     /**
689      * @dev See {IERC721-approve}.
690      */
691     function approve(address to, uint256 tokenId) public virtual override {
692         address owner = ERC721.ownerOf(tokenId);
693         require(to != owner, "ERC721: approval to current owner");
694 
695         require(
696             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
697             "ERC721: approve caller is not owner nor approved for all"
698         );
699 
700         _approve(to, tokenId);
701     }
702 
703     /**
704      * @dev See {IERC721-getApproved}.
705      */
706     function getApproved(uint256 tokenId) public view virtual override returns (address) {
707         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
708 
709         return _tokenApprovals[tokenId];
710     }
711 
712     /**
713      * @dev See {IERC721-setApprovalForAll}.
714      */
715     function setApprovalForAll(address operator, bool approved) public virtual override {
716         _setApprovalForAll(_msgSender(), operator, approved);
717     }
718 
719     /**
720      * @dev See {IERC721-isApprovedForAll}.
721      */
722     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
723         return _operatorApprovals[owner][operator];
724     }
725 
726     /**
727      * @dev See {IERC721-transferFrom}.
728      */
729     function transferFrom(
730         address from,
731         address to,
732         uint256 tokenId
733     ) public virtual override {
734         //solhint-disable-next-line max-line-length
735         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
736 
737         _transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         safeTransferFrom(from, to, tokenId, "");
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) public virtual override {
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761         _safeTransfer(from, to, tokenId, _data);
762     }
763 
764     /**
765      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
766      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
767      *
768      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
769      *
770      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
771      * implement alternative mechanisms to perform token transfer, such as signature-based.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must exist and be owned by `from`.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _safeTransfer(
783         address from,
784         address to,
785         uint256 tokenId,
786         bytes memory _data
787     ) internal virtual {
788         _transfer(from, to, tokenId);
789         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
790     }
791 
792     /**
793      * @dev Returns whether `tokenId` exists.
794      *
795      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
796      *
797      * Tokens start existing when they are minted (`_mint`),
798      * and stop existing when they are burned (`_burn`).
799      */
800     function _exists(uint256 tokenId) internal view virtual returns (bool) {
801         return _owners[tokenId] != address(0);
802     }
803 
804     /**
805      * @dev Returns whether `spender` is allowed to manage `tokenId`.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
812         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
813         address owner = ERC721.ownerOf(tokenId);
814         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
815     }
816 
817     /**
818      * @dev Safely mints `tokenId` and transfers it to `to`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must not exist.
823      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _safeMint(address to, uint256 tokenId) internal virtual {
828         _safeMint(to, tokenId, "");
829     }
830 
831     /**
832      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
833      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
834      */
835     function _safeMint(
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) internal virtual {
840         _mint(to, tokenId);
841         require(
842             _checkOnERC721Received(address(0), to, tokenId, _data),
843             "ERC721: transfer to non ERC721Receiver implementer"
844         );
845     }
846 
847     /**
848      * @dev Mints `tokenId` and transfers it to `to`.
849      *
850      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
851      *
852      * Requirements:
853      *
854      * - `tokenId` must not exist.
855      * - `to` cannot be the zero address.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _mint(address to, uint256 tokenId) internal virtual {
860         require(to != address(0), "ERC721: mint to the zero address");
861         require(!_exists(tokenId), "ERC721: token already minted");
862 
863         _beforeTokenTransfer(address(0), to, tokenId);
864 
865         _balances[to] += 1;
866         _owners[tokenId] = to;
867 
868         emit Transfer(address(0), to, tokenId);
869 
870         _afterTokenTransfer(address(0), to, tokenId);
871     }
872 
873     /**
874      * @dev Destroys `tokenId`.
875      * The approval is cleared when the token is burned.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must exist.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _burn(uint256 tokenId) internal virtual {
884         address owner = ERC721.ownerOf(tokenId);
885 
886         _beforeTokenTransfer(owner, address(0), tokenId);
887 
888         // Clear approvals
889         _approve(address(0), tokenId);
890 
891         _balances[owner] -= 1;
892         delete _owners[tokenId];
893 
894         emit Transfer(owner, address(0), tokenId);
895 
896         _afterTokenTransfer(owner, address(0), tokenId);
897     }
898 
899     /**
900      * @dev Transfers `tokenId` from `from` to `to`.
901      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
902      *
903      * Requirements:
904      *
905      * - `to` cannot be the zero address.
906      * - `tokenId` token must be owned by `from`.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _transfer(
911         address from,
912         address to,
913         uint256 tokenId
914     ) internal virtual {
915         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
916         require(to != address(0), "ERC721: transfer to the zero address");
917 
918         _beforeTokenTransfer(from, to, tokenId);
919 
920         // Clear approvals from the previous owner
921         _approve(address(0), tokenId);
922 
923         _balances[from] -= 1;
924         _balances[to] += 1;
925         _owners[tokenId] = to;
926 
927         emit Transfer(from, to, tokenId);
928 
929         _afterTokenTransfer(from, to, tokenId);
930     }
931 
932     /**
933      * @dev Approve `to` to operate on `tokenId`
934      *
935      * Emits a {Approval} event.
936      */
937     function _approve(address to, uint256 tokenId) internal virtual {
938         _tokenApprovals[tokenId] = to;
939         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
940     }
941 
942     /**
943      * @dev Approve `operator` to operate on all of `owner` tokens
944      *
945      * Emits a {ApprovalForAll} event.
946      */
947     function _setApprovalForAll(
948         address owner,
949         address operator,
950         bool approved
951     ) internal virtual {
952         require(owner != operator, "ERC721: approve to caller");
953         _operatorApprovals[owner][operator] = approved;
954         emit ApprovalForAll(owner, operator, approved);
955     }
956 
957     /**
958      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
959      * The call is not executed if the target address is not a contract.
960      *
961      * @param from address representing the previous owner of the given token ID
962      * @param to target address that will receive the tokens
963      * @param tokenId uint256 ID of the token to be transferred
964      * @param _data bytes optional data to send along with the call
965      * @return bool whether the call correctly returned the expected magic value
966      */
967     function _checkOnERC721Received(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) private returns (bool) {
973         if (to.isContract()) {
974             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
975                 return retval == IERC721Receiver.onERC721Received.selector;
976             } catch (bytes memory reason) {
977                 if (reason.length == 0) {
978                     revert("ERC721: transfer to non ERC721Receiver implementer");
979                 } else {
980                     assembly {
981                         revert(add(32, reason), mload(reason))
982                     }
983                 }
984             }
985         } else {
986             return true;
987         }
988     }
989 
990     /**
991      * @dev Hook that is called before any token transfer. This includes minting
992      * and burning.
993      *
994      * Calling conditions:
995      *
996      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
997      * transferred to `to`.
998      * - When `from` is zero, `tokenId` will be minted for `to`.
999      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1000      * - `from` and `to` are never both zero.
1001      *
1002      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1003      */
1004     function _beforeTokenTransfer(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) internal virtual {}
1009 
1010     /**
1011      * @dev Hook that is called after any transfer of tokens. This includes
1012      * minting and burning.
1013      *
1014      * Calling conditions:
1015      *
1016      * - when `from` and `to` are both non-zero.
1017      * - `from` and `to` are never both zero.
1018      *
1019      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1020      */
1021     function _afterTokenTransfer(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) internal virtual {}
1026 }
1027 
1028 // File: @openzeppelin/contracts/access/Ownable.sol
1029 
1030 
1031 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1032 
1033 pragma solidity ^0.8.0;
1034 
1035 /**
1036  * @dev Contract module which provides a basic access control mechanism, where
1037  * there is an account (an owner) that can be granted exclusive access to
1038  * specific functions.
1039  *
1040  * By default, the owner account will be the one that deploys the contract. This
1041  * can later be changed with {transferOwnership}.
1042  *
1043  * This module is used through inheritance. It will make available the modifier
1044  * `onlyOwner`, which can be applied to your functions to restrict their use to
1045  * the owner.
1046  */
1047 abstract contract Ownable is Context {
1048     address private _owner;
1049 
1050     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1051 
1052     /**
1053      * @dev Initializes the contract setting the deployer as the initial owner.
1054      */
1055     constructor() {
1056         _transferOwnership(_msgSender());
1057     }
1058 
1059     /**
1060      * @dev Returns the address of the current owner.
1061      */
1062     function owner() public view virtual returns (address) {
1063         return _owner;
1064     }
1065 
1066     /**
1067      * @dev Throws if called by any account other than the owner.
1068      */
1069     modifier onlyOwner() {
1070         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1071         _;
1072     }
1073 
1074     /**
1075      * @dev Leaves the contract without owner. It will not be possible to call
1076      * `onlyOwner` functions anymore. Can only be called by the current owner.
1077      *
1078      * NOTE: Renouncing ownership will leave the contract without an owner,
1079      * thereby removing any functionality that is only available to the owner.
1080      */
1081     function renounceOwnership() public virtual onlyOwner {
1082         _transferOwnership(address(0));
1083     }
1084 
1085     /**
1086      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1087      * Can only be called by the current owner.
1088      */
1089     function transferOwnership(address newOwner) public virtual onlyOwner {
1090         require(newOwner != address(0), "Ownable: new owner is the zero address");
1091         _transferOwnership(newOwner);
1092     }
1093 
1094     /**
1095      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1096      * Internal function without access restriction.
1097      */
1098     function _transferOwnership(address newOwner) internal virtual {
1099         address oldOwner = _owner;
1100         _owner = newOwner;
1101         emit OwnershipTransferred(oldOwner, newOwner);
1102     }
1103 }
1104 
1105 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1106 
1107 
1108 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1109 
1110 pragma solidity ^0.8.0;
1111 
1112 /**
1113  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1114  *
1115  * These functions can be used to verify that a message was signed by the holder
1116  * of the private keys of a given address.
1117  */
1118 library ECDSA {
1119     enum RecoverError {
1120         NoError,
1121         InvalidSignature,
1122         InvalidSignatureLength,
1123         InvalidSignatureS,
1124         InvalidSignatureV
1125     }
1126 
1127     function _throwError(RecoverError error) private pure {
1128         if (error == RecoverError.NoError) {
1129             return; // no error: do nothing
1130         } else if (error == RecoverError.InvalidSignature) {
1131             revert("ECDSA: invalid signature");
1132         } else if (error == RecoverError.InvalidSignatureLength) {
1133             revert("ECDSA: invalid signature length");
1134         } else if (error == RecoverError.InvalidSignatureS) {
1135             revert("ECDSA: invalid signature 's' value");
1136         } else if (error == RecoverError.InvalidSignatureV) {
1137             revert("ECDSA: invalid signature 'v' value");
1138         }
1139     }
1140 
1141     /**
1142      * @dev Returns the address that signed a hashed message (`hash`) with
1143      * `signature` or error string. This address can then be used for verification purposes.
1144      *
1145      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1146      * this function rejects them by requiring the `s` value to be in the lower
1147      * half order, and the `v` value to be either 27 or 28.
1148      *
1149      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1150      * verification to be secure: it is possible to craft signatures that
1151      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1152      * this is by receiving a hash of the original message (which may otherwise
1153      * be too long), and then calling {toEthSignedMessageHash} on it.
1154      *
1155      * Documentation for signature generation:
1156      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1157      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1158      *
1159      * _Available since v4.3._
1160      */
1161     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1162         // Check the signature length
1163         // - case 65: r,s,v signature (standard)
1164         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1165         if (signature.length == 65) {
1166             bytes32 r;
1167             bytes32 s;
1168             uint8 v;
1169             // ecrecover takes the signature parameters, and the only way to get them
1170             // currently is to use assembly.
1171             assembly {
1172                 r := mload(add(signature, 0x20))
1173                 s := mload(add(signature, 0x40))
1174                 v := byte(0, mload(add(signature, 0x60)))
1175             }
1176             return tryRecover(hash, v, r, s);
1177         } else if (signature.length == 64) {
1178             bytes32 r;
1179             bytes32 vs;
1180             // ecrecover takes the signature parameters, and the only way to get them
1181             // currently is to use assembly.
1182             assembly {
1183                 r := mload(add(signature, 0x20))
1184                 vs := mload(add(signature, 0x40))
1185             }
1186             return tryRecover(hash, r, vs);
1187         } else {
1188             return (address(0), RecoverError.InvalidSignatureLength);
1189         }
1190     }
1191 
1192     /**
1193      * @dev Returns the address that signed a hashed message (`hash`) with
1194      * `signature`. This address can then be used for verification purposes.
1195      *
1196      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1197      * this function rejects them by requiring the `s` value to be in the lower
1198      * half order, and the `v` value to be either 27 or 28.
1199      *
1200      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1201      * verification to be secure: it is possible to craft signatures that
1202      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1203      * this is by receiving a hash of the original message (which may otherwise
1204      * be too long), and then calling {toEthSignedMessageHash} on it.
1205      */
1206     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1207         (address recovered, RecoverError error) = tryRecover(hash, signature);
1208         _throwError(error);
1209         return recovered;
1210     }
1211 
1212     /**
1213      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1214      *
1215      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1216      *
1217      * _Available since v4.3._
1218      */
1219     function tryRecover(
1220         bytes32 hash,
1221         bytes32 r,
1222         bytes32 vs
1223     ) internal pure returns (address, RecoverError) {
1224         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1225         uint8 v = uint8((uint256(vs) >> 255) + 27);
1226         return tryRecover(hash, v, r, s);
1227     }
1228 
1229     /**
1230      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1231      *
1232      * _Available since v4.2._
1233      */
1234     function recover(
1235         bytes32 hash,
1236         bytes32 r,
1237         bytes32 vs
1238     ) internal pure returns (address) {
1239         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1240         _throwError(error);
1241         return recovered;
1242     }
1243 
1244     /**
1245      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1246      * `r` and `s` signature fields separately.
1247      *
1248      * _Available since v4.3._
1249      */
1250     function tryRecover(
1251         bytes32 hash,
1252         uint8 v,
1253         bytes32 r,
1254         bytes32 s
1255     ) internal pure returns (address, RecoverError) {
1256         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1257         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1258         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1259         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1260         //
1261         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1262         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1263         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1264         // these malleable signatures as well.
1265         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1266             return (address(0), RecoverError.InvalidSignatureS);
1267         }
1268         if (v != 27 && v != 28) {
1269             return (address(0), RecoverError.InvalidSignatureV);
1270         }
1271 
1272         // If the signature is valid (and not malleable), return the signer address
1273         address signer = ecrecover(hash, v, r, s);
1274         if (signer == address(0)) {
1275             return (address(0), RecoverError.InvalidSignature);
1276         }
1277 
1278         return (signer, RecoverError.NoError);
1279     }
1280 
1281     /**
1282      * @dev Overload of {ECDSA-recover} that receives the `v`,
1283      * `r` and `s` signature fields separately.
1284      */
1285     function recover(
1286         bytes32 hash,
1287         uint8 v,
1288         bytes32 r,
1289         bytes32 s
1290     ) internal pure returns (address) {
1291         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1292         _throwError(error);
1293         return recovered;
1294     }
1295 
1296     /**
1297      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1298      * produces hash corresponding to the one signed with the
1299      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1300      * JSON-RPC method as part of EIP-191.
1301      *
1302      * See {recover}.
1303      */
1304     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1305         // 32 is the length in bytes of hash,
1306         // enforced by the type signature above
1307         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1308     }
1309 
1310     /**
1311      * @dev Returns an Ethereum Signed Message, created from `s`. This
1312      * produces hash corresponding to the one signed with the
1313      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1314      * JSON-RPC method as part of EIP-191.
1315      *
1316      * See {recover}.
1317      */
1318     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1319         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1320     }
1321 
1322     /**
1323      * @dev Returns an Ethereum Signed Typed Data, created from a
1324      * `domainSeparator` and a `structHash`. This produces hash corresponding
1325      * to the one signed with the
1326      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1327      * JSON-RPC method as part of EIP-712.
1328      *
1329      * See {recover}.
1330      */
1331     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1332         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1333     }
1334 }
1335 
1336 // File: contracts/tt_treasures_v2_final.sol
1337 
1338 
1339 pragma solidity ^0.8.0;
1340 
1341 
1342 
1343 contract ttTreasures is ERC721, Ownable {
1344   using Strings for uint256;
1345   using ECDSA for bytes32;
1346 
1347   //NFT params
1348   string public baseURI;
1349   string public defaultURI;
1350   string public mycontractURI;
1351   uint256 private currentSupply;
1352 
1353   //mint structure
1354   struct StageSettingStr { 
1355     uint256 price;
1356     uint256 stageLimit;
1357     uint256 addrLimit;
1358     uint8 usePrevMintCountOffset;
1359   }
1360 
1361   //mint parameters
1362   uint256 public nextId = 1;
1363   uint8 public stage;
1364   mapping(uint8 => StageSettingStr) public stageSettings;  //stageSettings
1365   mapping(uint8 => mapping(address => uint256)) public mintCount;
1366   address public signer;     //WL signing key
1367   bool public mintDisabled;
1368 
1369   //contract state
1370   bool public paused = false;
1371   bool public finalizeBaseUri;
1372 
1373   //royalty
1374   address public royaltyAddr;
1375   uint256 public royaltyBasis;
1376 
1377   //sale holders
1378   address[] public fundRecipients = [
1379     0x9cEC6EAc6c5421B64516221a65223734Ab130952,
1380     0x1dac58aFEA554a46EA01704acDa519EdE00ad088,
1381     0x357cA9C566D60C93087207AB2419b05E2a953a53,
1382     0xb5fF9ffa5De8184a8D886A2bFc80bdbCE5959cbF,
1383     0x4624B143a154846468fb9Bf78c01abe37829dfF9,
1384     0x3D957720AD5F6489b670F591C83083dD00a4a584,
1385     0x1e5bac841a352EFe5e6B274B27DCffA9102ec50E,
1386     0x557189EC711Eea9a6d95db347016BAb5A6bf1B10,
1387     0xa671041Fd8058De2Cde34250dfAc7E3a858B50f1,
1388     0x044c4DfC95d6F15C1ba0aD90BcCEAd931e8073dE,
1389     0xA9CB2e9b0F760Df088A5Cf3480ebE3B70f10Dc8A,
1390     0x533e72F8570f41b772B470891a487fa180a9b7c3 ];  //fund recipients
1391   uint256[] public receivePercentagePt = [ 1500, 1500, 1000, 1200, 1000, 1000, 750, 750, 500, 500, 200, 100];   //distribution in basis points
1392 
1393   //stage2 withdraw
1394   address public constant TREASURY = 0x662FcE3F30Df2c9DBC40f87792876C818f50cAd8;
1395   uint256 public constant TREASURYPT = 8000;
1396   uint256 public constant INITWITHDRAWLIMIT = 6 ether;
1397   bool public isWithdrawStage2;
1398   uint256 public withdrawnBal;
1399 
1400   constructor(
1401     string memory _name,
1402     string memory _symbol,
1403     string memory _initBaseURI,
1404     string memory _defaultURI,
1405     address _signer,
1406     address _royaltyAddr,
1407     uint256 _royaltyBasis
1408 ) ERC721(_name, _symbol) {
1409     setBaseURI(_initBaseURI);
1410     defaultURI = _defaultURI;
1411     stageSettings[1] = StageSettingStr(0.1 ether, 800, 0, 0);
1412     stageSettings[2] = StageSettingStr(0.1 ether, 888, 2, 0);
1413     signer = _signer;
1414     royaltyAddr = _royaltyAddr;
1415     royaltyBasis = _royaltyBasis;
1416 }
1417 
1418   // internal
1419   function _baseURI() internal view virtual override returns (string memory) {
1420     return baseURI;
1421   }
1422 
1423   // public
1424   function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
1425       return interfaceId == 0xe8a3d485 /* contractURI() */ ||
1426       interfaceId == 0x2a55205a /* ERC-2981 royaltyInfo() */ ||
1427       super.supportsInterface(interfaceId);
1428   }
1429 
1430   function mint(uint8 _mint_num, uint8 _wl_max, bytes memory _signature) public payable {
1431     require(!paused, "Contract paused");
1432     require(!mintDisabled, "Minting disabled");
1433     require(stage > 0, "Invalid stage");
1434     uint256 supply = totalSupply();
1435     require(supply + _mint_num <= stageSettings[stage].stageLimit, "Hit stage limit");
1436     require(msg.value >= _mint_num * stageSettings[stage].price, "Insufficient eth");
1437     require(_mint_num > 0,"at least 1 mint");
1438     uint8 prevMintCountOffset = stageSettings[stage].usePrevMintCountOffset;
1439     //check WL condition
1440     if(_signature.length > 0){
1441       //mint via WL
1442       require(checkSig(msg.sender, _wl_max, _signature), "Invalid _signature");
1443       require(_mint_num + mintCount[stage-prevMintCountOffset][msg.sender] <= _wl_max, "Exceed WL limit");
1444     } else {
1445       //public mint
1446       require(_mint_num + mintCount[stage-prevMintCountOffset][msg.sender] <= stageSettings[stage].addrLimit, "Exceed address mint limit");
1447 
1448     }
1449 
1450     //increment mintCount
1451     mintCount[stage-prevMintCountOffset][msg.sender] += _mint_num;
1452 
1453     //mint
1454     currentSupply += _mint_num;
1455     for (uint256 i = 0; i < _mint_num; i++) {
1456       _safeMint(msg.sender, nextId + i);
1457     }
1458     nextId += _mint_num;
1459   }
1460 
1461 
1462   function checkSig(address _addr, uint8 _wl_max, bytes memory _signature) public view returns(bool){
1463     return signer == keccak256(abi.encodePacked(address(this), _addr, _wl_max, stage)).recover(_signature);
1464   }
1465 
1466   function disableMint() public onlyOwner {
1467     mintDisabled = true;
1468   }
1469 
1470 
1471   function tokensOfOwner(address _owner, uint startId, uint endId) external view returns(uint256[] memory ) {
1472     uint256 tokenCount = balanceOf(_owner);
1473     if (tokenCount == 0) {
1474         return new uint256[](0);
1475     } else {
1476         uint256[] memory result = new uint256[](tokenCount);
1477         uint256 index = 0;
1478 
1479         for (uint256 tokenId = startId; tokenId <= endId; tokenId++) {
1480             if (index == tokenCount) break;
1481 
1482             if (ownerOf(tokenId) == _owner) {
1483                 result[index] = tokenId;
1484                 index++;
1485             }
1486         }
1487         return result;
1488     }
1489   }function totalSupply() public view returns (uint256) {
1490     return currentSupply;
1491   }
1492 
1493   function tokenURI(uint256 tokenId)
1494     public
1495     view
1496     virtual
1497     override
1498     returns (string memory)
1499   {
1500     require(
1501       _exists(tokenId),
1502       "ERC721Metadata: URI query for nonexistent token"
1503     );
1504 
1505     string memory currentBaseURI = _baseURI();
1506     return bytes(currentBaseURI).length > 0
1507         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1508         : defaultURI;
1509   }
1510 
1511   function contractURI() public view returns (string memory) {
1512     return string(abi.encodePacked(mycontractURI));
1513   }
1514 
1515 
1516   //ERC-2981
1517   function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view 
1518   returns (address receiver, uint256 royaltyAmount){
1519     return (royaltyAddr, _salePrice * royaltyBasis / 10000);
1520   }
1521 
1522   function setRoyalty(address _royaltyAddr, uint256 _royaltyBasis) public onlyOwner {
1523     royaltyAddr = _royaltyAddr;
1524     royaltyBasis = _royaltyBasis;
1525   }
1526 
1527 
1528   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1529     require(!finalizeBaseUri, "BaseURI already finalized");
1530     baseURI = _newBaseURI;
1531   }
1532 
1533 
1534   function finalizeBaseURI() public onlyOwner {
1535     finalizeBaseUri = true;
1536   }
1537 
1538 
1539   function setContractURI(string memory _contractURI) public onlyOwner {
1540     mycontractURI = _contractURI;
1541   }
1542 
1543   function nextStage() public onlyOwner {
1544     require(stageSettings[stage+1].stageLimit != 0, "Stage not initialized");
1545     stage++;
1546   }
1547   function setStageSettings(uint8 _newStage, uint256 _price, uint256 _supplyLimit, uint8 _addrLimit, uint8 _usePrevMintCountOffset) public onlyOwner {
1548     require(_newStage > stage, "Cannot modify stage");
1549     require(_newStage - _usePrevMintCountOffset >= 0, "Offset cannot go negative");
1550     stageSettings[_newStage].price = _price;
1551     stageSettings[_newStage].stageLimit = _supplyLimit;
1552     stageSettings[_newStage].addrLimit = _addrLimit;
1553     stageSettings[_newStage].usePrevMintCountOffset = _usePrevMintCountOffset;
1554   }
1555 
1556 
1557   function pause(bool _state) public onlyOwner {
1558     paused = _state;
1559   }
1560   function reserveMint(uint256 _mintAmount, address _to) public onlyOwner {    
1561     currentSupply += _mintAmount;
1562     for (uint256 i = 0; i < _mintAmount; i++) {
1563       _safeMint(_to, nextId + i);
1564     }
1565     nextId += _mintAmount;
1566   }
1567 
1568   //fund withdraw functions ---
1569 
1570   function withdrawFund() public onlyOwner {
1571     uint256 currentBal = address(this).balance;
1572     require(currentBal > 0, "No balance left");
1573 
1574     if(!isWithdrawStage2){
1575       //stage1 withdraw
1576       if(currentBal + withdrawnBal >= INITWITHDRAWLIMIT){
1577         isWithdrawStage2 = true; //next withdraw TX will be stage2
1578         currentBal = INITWITHDRAWLIMIT - withdrawnBal;    //split only first 6eth for this current TX
1579 
1580       }else{
1581         //stage1 withdrawal before 6eth
1582         withdrawnBal += currentBal;
1583       }
1584     }else{
1585       //stage2 withdraw
1586       uint256 treasuryWithdraw = currentBal * TREASURYPT / 10000;  //treasury takes 80%
1587 
1588       _withdraw(TREASURY, treasuryWithdraw);
1589       currentBal -= treasuryWithdraw;  //team splits the rest of 20%
1590     }
1591 
1592     for (uint256 i = 0; i < fundRecipients.length; i++) {
1593       _withdraw(fundRecipients[i], currentBal * receivePercentagePt[i] / 10000);
1594     }
1595   }
1596 
1597   function _withdraw(address _addr, uint256 _amt) private {
1598     (bool success,) = _addr.call{value: _amt}("");
1599     require(success, "Transfer failed");
1600   }
1601 }