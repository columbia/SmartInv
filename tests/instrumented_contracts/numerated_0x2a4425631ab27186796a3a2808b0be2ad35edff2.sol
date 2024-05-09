1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
30 
31 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
173 
174 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @title ERC721 token receiver interface
180  * @dev Interface for any contract that wants to support safeTransfers
181  * from ERC721 asset contracts.
182  */
183 interface IERC721Receiver {
184     /**
185      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
186      * by `operator` from `from`, this function is called.
187      *
188      * It must return its Solidity selector to confirm the token transfer.
189      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
190      *
191      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
192      */
193     function onERC721Received(
194         address operator,
195         address from,
196         uint256 tokenId,
197         bytes calldata data
198     ) external returns (bytes4);
199 }
200 
201 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
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
228 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
229 
230 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
231 
232 pragma solidity ^0.8.1;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      *
255      * [IMPORTANT]
256      * ====
257      * You shouldn't rely on `isContract` to protect against flash loan attacks!
258      *
259      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
260      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
261      * constructor.
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize/address.code.length, which returns 0
266         // for contracts in construction, since the code is only stored at the end
267         // of the constructor execution.
268 
269         return account.code.length > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return
348             functionCallWithValue(target, data, value, "Address: low-level call with value failed");
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
376     function functionStaticCall(address target, bytes memory data)
377         internal
378         view
379         returns (bytes memory)
380     {
381         return functionStaticCall(target, data, "Address: low-level static call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal view returns (bytes memory) {
395         require(isContract(target), "Address: static call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(address target, bytes memory data)
408         internal
409         returns (bytes memory)
410     {
411         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
416      * but performing a delegate call.
417      *
418      * _Available since v3.4._
419      */
420     function functionDelegateCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(isContract(target), "Address: delegate call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.delegatecall(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
433      * revert reason using the provided one.
434      *
435      * _Available since v4.3._
436      */
437     function verifyCallResult(
438         bool success,
439         bytes memory returndata,
440         string memory errorMessage
441     ) internal pure returns (bytes memory) {
442         if (success) {
443             return returndata;
444         } else {
445             // Look for revert reason and bubble it up if present
446             if (returndata.length > 0) {
447                 // The easiest way to bubble the revert reason is using memory via assembly
448 
449                 assembly {
450                     let returndata_size := mload(returndata)
451                     revert(add(32, returndata), returndata_size)
452                 }
453             } else {
454                 revert(errorMessage);
455             }
456         }
457     }
458 }
459 
460 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @dev Provides information about the current execution context, including the
468  * sender of the transaction and its data. While these are generally available
469  * via msg.sender and msg.data, they should not be accessed in such a direct
470  * manner, since when dealing with meta-transactions the account sending and
471  * paying for execution may not be the actual sender (as far as an application
472  * is concerned).
473  *
474  * This contract is only required for intermediate, library-like contracts.
475  */
476 abstract contract Context {
477     function _msgSender() internal view virtual returns (address) {
478         return msg.sender;
479     }
480 
481     function _msgData() internal view virtual returns (bytes calldata) {
482         return msg.data;
483     }
484 }
485 
486 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @dev String operations.
494  */
495 library Strings {
496     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
497 
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
500      */
501     function toString(uint256 value) internal pure returns (string memory) {
502         // Inspired by OraclizeAPI's implementation - MIT licence
503         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
504 
505         if (value == 0) {
506             return "0";
507         }
508         uint256 temp = value;
509         uint256 digits;
510         while (temp != 0) {
511             digits++;
512             temp /= 10;
513         }
514         bytes memory buffer = new bytes(digits);
515         while (value != 0) {
516             digits -= 1;
517             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
518             value /= 10;
519         }
520         return string(buffer);
521     }
522 
523     /**
524      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
525      */
526     function toHexString(uint256 value) internal pure returns (string memory) {
527         if (value == 0) {
528             return "0x00";
529         }
530         uint256 temp = value;
531         uint256 length = 0;
532         while (temp != 0) {
533             length++;
534             temp >>= 8;
535         }
536         return toHexString(value, length);
537     }
538 
539     /**
540      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
541      */
542     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
543         bytes memory buffer = new bytes(2 * length + 2);
544         buffer[0] = "0";
545         buffer[1] = "x";
546         for (uint256 i = 2 * length + 1; i > 1; --i) {
547             buffer[i] = _HEX_SYMBOLS[value & 0xf];
548             value >>= 4;
549         }
550         require(value == 0, "Strings: hex length insufficient");
551         return string(buffer);
552     }
553 }
554 
555 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
556 
557 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @dev Implementation of the {IERC165} interface.
563  *
564  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
565  * for the additional interface id that will be supported. For example:
566  *
567  * ```solidity
568  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
570  * }
571  * ```
572  *
573  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
574  */
575 abstract contract ERC165 is IERC165 {
576     /**
577      * @dev See {IERC165-supportsInterface}.
578      */
579     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580         return interfaceId == type(IERC165).interfaceId;
581     }
582 }
583 
584 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
585 
586 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
592  * the Metadata extension, but not including the Enumerable extension, which is available separately as
593  * {ERC721Enumerable}.
594  */
595 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
596     using Address for address;
597     using Strings for uint256;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to owner address
606     mapping(uint256 => address) private _owners;
607 
608     // Mapping owner address to token count
609     mapping(address => uint256) private _balances;
610 
611     // Mapping from token ID to approved address
612     mapping(uint256 => address) private _tokenApprovals;
613 
614     // Mapping from owner to operator approvals
615     mapping(address => mapping(address => bool)) private _operatorApprovals;
616 
617     /**
618      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
619      */
620     constructor(string memory name_, string memory symbol_) {
621         _name = name_;
622         _symbol = symbol_;
623     }
624 
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId)
629         public
630         view
631         virtual
632         override(ERC165, IERC165)
633         returns (bool)
634     {
635         return
636             interfaceId == type(IERC721).interfaceId ||
637             interfaceId == type(IERC721Metadata).interfaceId ||
638             super.supportsInterface(interfaceId);
639     }
640 
641     /**
642      * @dev See {IERC721-balanceOf}.
643      */
644     function balanceOf(address owner) public view virtual override returns (uint256) {
645         require(owner != address(0), "ERC721: balance query for the zero address");
646         return _balances[owner];
647     }
648 
649     /**
650      * @dev See {IERC721-ownerOf}.
651      */
652     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
653         address owner = _owners[tokenId];
654         require(owner != address(0), "ERC721: owner query for nonexistent token");
655         return owner;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-name}.
660      */
661     function name() public view virtual override returns (string memory) {
662         return _name;
663     }
664 
665     /**
666      * @dev See {IERC721Metadata-symbol}.
667      */
668     function symbol() public view virtual override returns (string memory) {
669         return _symbol;
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-tokenURI}.
674      */
675     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
676         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
677 
678         string memory baseURI = _baseURI();
679         return
680             bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
681     }
682 
683     /**
684      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
685      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
686      * by default, can be overriden in child contracts.
687      */
688     function _baseURI() internal view virtual returns (string memory) {
689         return "";
690     }
691 
692     /**
693      * @dev See {IERC721-approve}.
694      */
695     function approve(address to, uint256 tokenId) public virtual override {
696         address owner = ERC721.ownerOf(tokenId);
697         require(to != owner, "ERC721: approval to current owner");
698 
699         require(
700             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
701             "ERC721: approve caller is not owner nor approved for all"
702         );
703 
704         _approve(to, tokenId);
705     }
706 
707     /**
708      * @dev See {IERC721-getApproved}.
709      */
710     function getApproved(uint256 tokenId) public view virtual override returns (address) {
711         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
712 
713         return _tokenApprovals[tokenId];
714     }
715 
716     /**
717      * @dev See {IERC721-setApprovalForAll}.
718      */
719     function setApprovalForAll(address operator, bool approved) public virtual override {
720         _setApprovalForAll(_msgSender(), operator, approved);
721     }
722 
723     /**
724      * @dev See {IERC721-isApprovedForAll}.
725      */
726     function isApprovedForAll(address owner, address operator)
727         public
728         view
729         virtual
730         override
731         returns (bool)
732     {
733         return _operatorApprovals[owner][operator];
734     }
735 
736     /**
737      * @dev See {IERC721-transferFrom}.
738      */
739     function transferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         //solhint-disable-next-line max-line-length
745         require(
746             _isApprovedOrOwner(_msgSender(), tokenId),
747             "ERC721: transfer caller is not owner nor approved"
748         );
749 
750         _transfer(from, to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) public virtual override {
761         safeTransferFrom(from, to, tokenId, "");
762     }
763 
764     /**
765      * @dev See {IERC721-safeTransferFrom}.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) public virtual override {
773         require(
774             _isApprovedOrOwner(_msgSender(), tokenId),
775             "ERC721: transfer caller is not owner nor approved"
776         );
777         _safeTransfer(from, to, tokenId, _data);
778     }
779 
780     /**
781      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
782      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
783      *
784      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
785      *
786      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
787      * implement alternative mechanisms to perform token transfer, such as signature-based.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must exist and be owned by `from`.
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _safeTransfer(
799         address from,
800         address to,
801         uint256 tokenId,
802         bytes memory _data
803     ) internal virtual {
804         _transfer(from, to, tokenId);
805         require(
806             _checkOnERC721Received(from, to, tokenId, _data),
807             "ERC721: transfer to non ERC721Receiver implementer"
808         );
809     }
810 
811     /**
812      * @dev Returns whether `tokenId` exists.
813      *
814      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
815      *
816      * Tokens start existing when they are minted (`_mint`),
817      * and stop existing when they are burned (`_burn`).
818      */
819     function _exists(uint256 tokenId) internal view virtual returns (bool) {
820         return _owners[tokenId] != address(0);
821     }
822 
823     /**
824      * @dev Returns whether `spender` is allowed to manage `tokenId`.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function _isApprovedOrOwner(address spender, uint256 tokenId)
831         internal
832         view
833         virtual
834         returns (bool)
835     {
836         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
837         address owner = ERC721.ownerOf(tokenId);
838         return (spender == owner ||
839             getApproved(tokenId) == spender ||
840             isApprovedForAll(owner, spender));
841     }
842 
843     /**
844      * @dev Safely mints `tokenId` and transfers it to `to`.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must not exist.
849      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _safeMint(address to, uint256 tokenId) internal virtual {
854         _safeMint(to, tokenId, "");
855     }
856 
857     /**
858      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
859      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
860      */
861     function _safeMint(
862         address to,
863         uint256 tokenId,
864         bytes memory _data
865     ) internal virtual {
866         _mint(to, tokenId);
867         require(
868             _checkOnERC721Received(address(0), to, tokenId, _data),
869             "ERC721: transfer to non ERC721Receiver implementer"
870         );
871     }
872 
873     /**
874      * @dev Mints `tokenId` and transfers it to `to`.
875      *
876      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
877      *
878      * Requirements:
879      *
880      * - `tokenId` must not exist.
881      * - `to` cannot be the zero address.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _mint(address to, uint256 tokenId) internal virtual {
886         require(to != address(0), "ERC721: mint to the zero address");
887         require(!_exists(tokenId), "ERC721: token already minted");
888 
889         _beforeTokenTransfer(address(0), to, tokenId);
890 
891         _balances[to] += 1;
892         _owners[tokenId] = to;
893 
894         emit Transfer(address(0), to, tokenId);
895 
896         _afterTokenTransfer(address(0), to, tokenId);
897     }
898 
899     /**
900      * @dev Destroys `tokenId`.
901      * The approval is cleared when the token is burned.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _burn(uint256 tokenId) internal virtual {
910         address owner = ERC721.ownerOf(tokenId);
911 
912         _beforeTokenTransfer(owner, address(0), tokenId);
913 
914         // Clear approvals
915         _approve(address(0), tokenId);
916 
917         _balances[owner] -= 1;
918         delete _owners[tokenId];
919 
920         emit Transfer(owner, address(0), tokenId);
921 
922         _afterTokenTransfer(owner, address(0), tokenId);
923     }
924 
925     /**
926      * @dev Transfers `tokenId` from `from` to `to`.
927      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
928      *
929      * Requirements:
930      *
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must be owned by `from`.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _transfer(
937         address from,
938         address to,
939         uint256 tokenId
940     ) internal virtual {
941         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
942         require(to != address(0), "ERC721: transfer to the zero address");
943 
944         _beforeTokenTransfer(from, to, tokenId);
945 
946         // Clear approvals from the previous owner
947         _approve(address(0), tokenId);
948 
949         _balances[from] -= 1;
950         _balances[to] += 1;
951         _owners[tokenId] = to;
952 
953         emit Transfer(from, to, tokenId);
954 
955         _afterTokenTransfer(from, to, tokenId);
956     }
957 
958     /**
959      * @dev Approve `to` to operate on `tokenId`
960      *
961      * Emits a {Approval} event.
962      */
963     function _approve(address to, uint256 tokenId) internal virtual {
964         _tokenApprovals[tokenId] = to;
965         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
966     }
967 
968     /**
969      * @dev Approve `operator` to operate on all of `owner` tokens
970      *
971      * Emits a {ApprovalForAll} event.
972      */
973     function _setApprovalForAll(
974         address owner,
975         address operator,
976         bool approved
977     ) internal virtual {
978         require(owner != operator, "ERC721: approve to caller");
979         _operatorApprovals[owner][operator] = approved;
980         emit ApprovalForAll(owner, operator, approved);
981     }
982 
983     /**
984      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
985      * The call is not executed if the target address is not a contract.
986      *
987      * @param from address representing the previous owner of the given token ID
988      * @param to target address that will receive the tokens
989      * @param tokenId uint256 ID of the token to be transferred
990      * @param _data bytes optional data to send along with the call
991      * @return bool whether the call correctly returned the expected magic value
992      */
993     function _checkOnERC721Received(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) private returns (bool) {
999         if (to.isContract()) {
1000             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (
1001                 bytes4 retval
1002             ) {
1003                 return retval == IERC721Receiver.onERC721Received.selector;
1004             } catch (bytes memory reason) {
1005                 if (reason.length == 0) {
1006                     revert("ERC721: transfer to non ERC721Receiver implementer");
1007                 } else {
1008                     assembly {
1009                         revert(add(32, reason), mload(reason))
1010                     }
1011                 }
1012             }
1013         } else {
1014             return true;
1015         }
1016     }
1017 
1018     /**
1019      * @dev Hook that is called before any token transfer. This includes minting
1020      * and burning.
1021      *
1022      * Calling conditions:
1023      *
1024      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1025      * transferred to `to`.
1026      * - When `from` is zero, `tokenId` will be minted for `to`.
1027      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1028      * - `from` and `to` are never both zero.
1029      *
1030      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1031      */
1032     function _beforeTokenTransfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) internal virtual {}
1037 
1038     /**
1039      * @dev Hook that is called after any transfer of tokens. This includes
1040      * minting and burning.
1041      *
1042      * Calling conditions:
1043      *
1044      * - when `from` and `to` are both non-zero.
1045      * - `from` and `to` are never both zero.
1046      *
1047      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1048      */
1049     function _afterTokenTransfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) internal virtual {}
1054 }
1055 
1056 // File @openzeppelin/contracts/utils/Counters.sol@v4.5.0
1057 
1058 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1059 
1060 pragma solidity ^0.8.0;
1061 
1062 /**
1063  * @title Counters
1064  * @author Matt Condon (@shrugs)
1065  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1066  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1067  *
1068  * Include with `using Counters for Counters.Counter;`
1069  */
1070 library Counters {
1071     struct Counter {
1072         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1073         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1074         // this feature: see https://github.com/ethereum/solidity/issues/4637
1075         uint256 _value; // default: 0
1076     }
1077 
1078     function current(Counter storage counter) internal view returns (uint256) {
1079         return counter._value;
1080     }
1081 
1082     function increment(Counter storage counter) internal {
1083         unchecked {
1084             counter._value += 1;
1085         }
1086     }
1087 
1088     function decrement(Counter storage counter) internal {
1089         uint256 value = counter._value;
1090         require(value > 0, "Counter: decrement overflow");
1091         unchecked {
1092             counter._value = value - 1;
1093         }
1094     }
1095 
1096     function reset(Counter storage counter) internal {
1097         counter._value = 0;
1098     }
1099 }
1100 
1101 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1102 
1103 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 /**
1108  * @dev These functions deal with verification of Merkle Trees proofs.
1109  *
1110  * The proofs can be generated using the JavaScript library
1111  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1112  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1113  *
1114  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1115  */
1116 library MerkleProof {
1117     /**
1118      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1119      * defined by `root`. For this, a `proof` must be provided, containing
1120      * sibling hashes on the branch from the leaf to the root of the tree. Each
1121      * pair of leaves and each pair of pre-images are assumed to be sorted.
1122      */
1123     function verify(
1124         bytes32[] memory proof,
1125         bytes32 root,
1126         bytes32 leaf
1127     ) internal pure returns (bool) {
1128         return processProof(proof, leaf) == root;
1129     }
1130 
1131     /**
1132      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1133      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1134      * hash matches the root of the tree. When processing the proof, the pairs
1135      * of leafs & pre-images are assumed to be sorted.
1136      *
1137      * _Available since v4.4._
1138      */
1139     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1140         bytes32 computedHash = leaf;
1141         for (uint256 i = 0; i < proof.length; i++) {
1142             bytes32 proofElement = proof[i];
1143             if (computedHash <= proofElement) {
1144                 // Hash(current computed hash + current element of the proof)
1145                 computedHash = _efficientHash(computedHash, proofElement);
1146             } else {
1147                 // Hash(current element of the proof + current computed hash)
1148                 computedHash = _efficientHash(proofElement, computedHash);
1149             }
1150         }
1151         return computedHash;
1152     }
1153 
1154     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1155         assembly {
1156             mstore(0x00, a)
1157             mstore(0x20, b)
1158             value := keccak256(0x00, 0x40)
1159         }
1160     }
1161 }
1162 
1163 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1164 
1165 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 /**
1170  * @dev Contract module which provides a basic access control mechanism, where
1171  * there is an account (an owner) that can be granted exclusive access to
1172  * specific functions.
1173  *
1174  * By default, the owner account will be the one that deploys the contract. This
1175  * can later be changed with {transferOwnership}.
1176  *
1177  * This module is used through inheritance. It will make available the modifier
1178  * `onlyOwner`, which can be applied to your functions to restrict their use to
1179  * the owner.
1180  */
1181 abstract contract Ownable is Context {
1182     address private _owner;
1183 
1184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1185 
1186     /**
1187      * @dev Initializes the contract setting the deployer as the initial owner.
1188      */
1189     constructor() {
1190         _transferOwnership(_msgSender());
1191     }
1192 
1193     /**
1194      * @dev Returns the address of the current owner.
1195      */
1196     function owner() public view virtual returns (address) {
1197         return _owner;
1198     }
1199 
1200     /**
1201      * @dev Throws if called by any account other than the owner.
1202      */
1203     modifier onlyOwner() {
1204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1205         _;
1206     }
1207 
1208     /**
1209      * @dev Leaves the contract without owner. It will not be possible to call
1210      * `onlyOwner` functions anymore. Can only be called by the current owner.
1211      *
1212      * NOTE: Renouncing ownership will leave the contract without an owner,
1213      * thereby removing any functionality that is only available to the owner.
1214      */
1215     function renounceOwnership() public virtual onlyOwner {
1216         _transferOwnership(address(0));
1217     }
1218 
1219     /**
1220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1221      * Can only be called by the current owner.
1222      */
1223     function transferOwnership(address newOwner) public virtual onlyOwner {
1224         require(newOwner != address(0), "Ownable: new owner is the zero address");
1225         _transferOwnership(newOwner);
1226     }
1227 
1228     /**
1229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1230      * Internal function without access restriction.
1231      */
1232     function _transferOwnership(address newOwner) internal virtual {
1233         address oldOwner = _owner;
1234         _owner = newOwner;
1235         emit OwnershipTransferred(oldOwner, newOwner);
1236     }
1237 }
1238 
1239 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
1240 
1241 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1242 
1243 pragma solidity ^0.8.0;
1244 
1245 /**
1246  * @dev Contract module that helps prevent reentrant calls to a function.
1247  *
1248  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1249  * available, which can be applied to functions to make sure there are no nested
1250  * (reentrant) calls to them.
1251  *
1252  * Note that because there is a single `nonReentrant` guard, functions marked as
1253  * `nonReentrant` may not call one another. This can be worked around by making
1254  * those functions `private`, and then adding `external` `nonReentrant` entry
1255  * points to them.
1256  *
1257  * TIP: If you would like to learn more about reentrancy and alternative ways
1258  * to protect against it, check out our blog post
1259  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1260  */
1261 abstract contract ReentrancyGuard {
1262     // Booleans are more expensive than uint256 or any type that takes up a full
1263     // word because each write operation emits an extra SLOAD to first read the
1264     // slot's contents, replace the bits taken up by the boolean, and then write
1265     // back. This is the compiler's defense against contract upgrades and
1266     // pointer aliasing, and it cannot be disabled.
1267 
1268     // The values being non-zero value makes deployment a bit more expensive,
1269     // but in exchange the refund on every call to nonReentrant will be lower in
1270     // amount. Since refunds are capped to a percentage of the total
1271     // transaction's gas, it is best to keep them low in cases like this one, to
1272     // increase the likelihood of the full refund coming into effect.
1273     uint256 private constant _NOT_ENTERED = 1;
1274     uint256 private constant _ENTERED = 2;
1275 
1276     uint256 private _status;
1277 
1278     constructor() {
1279         _status = _NOT_ENTERED;
1280     }
1281 
1282     /**
1283      * @dev Prevents a contract from calling itself, directly or indirectly.
1284      * Calling a `nonReentrant` function from another `nonReentrant`
1285      * function is not supported. It is possible to prevent this from happening
1286      * by making the `nonReentrant` function external, and making it call a
1287      * `private` function that does the actual work.
1288      */
1289     modifier nonReentrant() {
1290         // On the first call to nonReentrant, _notEntered will be true
1291         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1292 
1293         // Any calls to nonReentrant after this point will fail
1294         _status = _ENTERED;
1295 
1296         _;
1297 
1298         // By storing the original value once again, a refund is triggered (see
1299         // https://eips.ethereum.org/EIPS/eip-2200)
1300         _status = _NOT_ENTERED;
1301     }
1302 }
1303 
1304 // File contracts/SOG.sol
1305 
1306 pragma solidity ^0.8.0; // solhint-disable-line
1307 
1308 contract SOG is ERC721, Ownable, ReentrancyGuard {
1309     // Using counters diminish gasfees consumption 👉 https://shiny.mirror.xyz/OUampBbIz9ebEicfGnQf5At_ReMHlZy0tB4glb9xQ0E
1310     using Counters for Counters.Counter;
1311 
1312     // MerkleRoot is used in order to check the allowList
1313     bytes32 public merkleRoot;
1314     bool public isAllowListActive;
1315     mapping(address => uint256) public allowListClaimed;
1316 
1317     bool public isPublicSaleActive;
1318     bool public reserveClaimed = false;
1319     uint256 public constant MAX_SUPPLY = 250;
1320     uint256 public constant RESERVE_SUPPLY = 30;
1321     uint256 public constant PRICE_PER_TOKEN = 0.2 ether;
1322     string private _baseURIextended;
1323     Counters.Counter private _tokenSupply;
1324 
1325     constructor() ERC721("Societhy OG Pass", "SOG") {}
1326 
1327     function totalSupply() public view returns (uint256) {
1328         return _tokenSupply.current();
1329     }
1330 
1331     function setAllowList(bytes32 merkleRoot_) external onlyOwner {
1332         merkleRoot = merkleRoot_;
1333     }
1334 
1335     function setAllowListActive(bool isAllowListActive_) external onlyOwner {
1336         isAllowListActive = isAllowListActive_;
1337     }
1338 
1339     /**
1340      * onAllowList: Check if the 'claimer' address is present in the allow list.
1341      * In other words, check if a leaf with the 'claimer' value
1342      * is present in the stored merkle tree.
1343      *
1344      * See Open Zeppelin's 'MerkleProof' library implementation.
1345      */
1346     function onAllowList(address claimer, bytes32[] memory proof) public view returns (bool) {
1347         bytes32 leaf = keccak256(abi.encodePacked(claimer));
1348         return MerkleProof.verify(proof, merkleRoot, leaf);
1349     }
1350 
1351     function mintAllowList(bytes32[] calldata merkleProof) external payable nonReentrant {
1352         require(isAllowListActive, "Allow list is not active");
1353         require(onAllowList(msg.sender, merkleProof), "Address not in allow list");
1354         require(allowListClaimed[msg.sender] == 0, "Token already claimed");
1355 
1356         uint256 mintIndex = _tokenSupply.current() + 1;
1357         require(mintIndex <= MAX_SUPPLY, "Purchase would exceed max tokens");
1358         require(PRICE_PER_TOKEN <= msg.value, "Not enough ETH sent; check price!");
1359 
1360         _tokenSupply.increment();
1361         allowListClaimed[msg.sender] += 1;
1362         _safeMint(msg.sender, mintIndex);
1363     }
1364 
1365     function reserve() external onlyOwner {
1366         require(!reserveClaimed, "Reserve already claimed");
1367         reserveClaimed = true;
1368 
1369         uint256 i;
1370         for (i = 1; i <= RESERVE_SUPPLY; i++) {
1371             _tokenSupply.increment();
1372             _safeMint(msg.sender, _tokenSupply.current());
1373         }
1374     }
1375 
1376     function setPublicSaleActive(bool isPublicSaleActive_) external onlyOwner {
1377         isPublicSaleActive = isPublicSaleActive_;
1378     }
1379 
1380     function mint(uint256 numberOfTokens) external payable nonReentrant {
1381         uint256 ts = _tokenSupply.current();
1382         require(isPublicSaleActive, "Public sale is not open yet");
1383         require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
1384         require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");
1385 
1386         for (uint256 i = 1; i <= numberOfTokens; i++) {
1387             _tokenSupply.increment();
1388             _safeMint(msg.sender, _tokenSupply.current());
1389         }
1390     }
1391 
1392     function setBaseURI(string memory baseURI_) external onlyOwner {
1393         _baseURIextended = baseURI_;
1394     }
1395 
1396     function _baseURI() internal view virtual override returns (string memory) {
1397         return _baseURIextended;
1398     }
1399 
1400     /**
1401      * Optional override for modifying the token URI before return.
1402      */
1403     function tokenURI(uint256 tokenId)
1404         public
1405         view
1406         virtual
1407         override(ERC721)
1408         returns (string memory)
1409     {
1410         string memory uri = super.tokenURI(tokenId);
1411         return bytes(uri).length > 0 ? string(abi.encodePacked(uri, ".json")) : "";
1412     }
1413 
1414     function withdraw(address payable to) external onlyOwner nonReentrant {
1415         uint256 balance = address(this).balance;
1416         Address.sendValue(to, balance);
1417     }
1418 }