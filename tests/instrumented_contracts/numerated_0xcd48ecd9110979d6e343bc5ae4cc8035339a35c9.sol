1 // Sources flattened with hardhat v2.10.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.3
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.3
33 
34 
35 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId,
89         bytes calldata data
90     ) external;
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId) external view returns (address operator);
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.3
178 
179 
180 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.3
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
238 
239 
240 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
241 
242 pragma solidity ^0.8.1;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      *
265      * [IMPORTANT]
266      * ====
267      * You shouldn't rely on `isContract` to protect against flash loan attacks!
268      *
269      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
270      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
271      * constructor.
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize/address.code.length, which returns 0
276         // for contracts in construction, since the code is only stored at the end
277         // of the constructor execution.
278 
279         return account.code.length > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         require(isContract(target), "Address: call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.call{value: value}(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
386         return functionStaticCall(target, data, "Address: low-level static call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(isContract(target), "Address: delegate call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.delegatecall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
435      * revert reason using the provided one.
436      *
437      * _Available since v4.3._
438      */
439     function verifyCallResult(
440         bool success,
441         bytes memory returndata,
442         string memory errorMessage
443     ) internal pure returns (bytes memory) {
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450                 /// @solidity memory-safe-assembly
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 
463 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes calldata) {
486         return msg.data;
487     }
488 }
489 
490 
491 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.3
492 
493 
494 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev String operations.
500  */
501 library Strings {
502     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
503     uint8 private constant _ADDRESS_LENGTH = 20;
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
507      */
508     function toString(uint256 value) internal pure returns (string memory) {
509         // Inspired by OraclizeAPI's implementation - MIT licence
510         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
511 
512         if (value == 0) {
513             return "0";
514         }
515         uint256 temp = value;
516         uint256 digits;
517         while (temp != 0) {
518             digits++;
519             temp /= 10;
520         }
521         bytes memory buffer = new bytes(digits);
522         while (value != 0) {
523             digits -= 1;
524             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
525             value /= 10;
526         }
527         return string(buffer);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
532      */
533     function toHexString(uint256 value) internal pure returns (string memory) {
534         if (value == 0) {
535             return "0x00";
536         }
537         uint256 temp = value;
538         uint256 length = 0;
539         while (temp != 0) {
540             length++;
541             temp >>= 8;
542         }
543         return toHexString(value, length);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
548      */
549     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
550         bytes memory buffer = new bytes(2 * length + 2);
551         buffer[0] = "0";
552         buffer[1] = "x";
553         for (uint256 i = 2 * length + 1; i > 1; --i) {
554             buffer[i] = _HEX_SYMBOLS[value & 0xf];
555             value >>= 4;
556         }
557         require(value == 0, "Strings: hex length insufficient");
558         return string(buffer);
559     }
560 
561     /**
562      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
563      */
564     function toHexString(address addr) internal pure returns (string memory) {
565         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
566     }
567 }
568 
569 
570 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.3
571 
572 
573 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Implementation of the {IERC165} interface.
579  *
580  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
581  * for the additional interface id that will be supported. For example:
582  *
583  * ```solidity
584  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
586  * }
587  * ```
588  *
589  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
590  */
591 abstract contract ERC165 is IERC165 {
592     /**
593      * @dev See {IERC165-supportsInterface}.
594      */
595     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
596         return interfaceId == type(IERC165).interfaceId;
597     }
598 }
599 
600 
601 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.7.3
602 
603 
604 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 
609 
610 
611 
612 
613 
614 /**
615  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
616  * the Metadata extension, but not including the Enumerable extension, which is available separately as
617  * {ERC721Enumerable}.
618  */
619 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
620     using Address for address;
621     using Strings for uint256;
622 
623     // Token name
624     string private _name;
625 
626     // Token symbol
627     string private _symbol;
628 
629     // Mapping from token ID to owner address
630     mapping(uint256 => address) private _owners;
631 
632     // Mapping owner address to token count
633     mapping(address => uint256) private _balances;
634 
635     // Mapping from token ID to approved address
636     mapping(uint256 => address) private _tokenApprovals;
637 
638     // Mapping from owner to operator approvals
639     mapping(address => mapping(address => bool)) private _operatorApprovals;
640 
641     /**
642      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
643      */
644     constructor(string memory name_, string memory symbol_) {
645         _name = name_;
646         _symbol = symbol_;
647     }
648 
649     /**
650      * @dev See {IERC165-supportsInterface}.
651      */
652     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
653         return
654             interfaceId == type(IERC721).interfaceId ||
655             interfaceId == type(IERC721Metadata).interfaceId ||
656             super.supportsInterface(interfaceId);
657     }
658 
659     /**
660      * @dev See {IERC721-balanceOf}.
661      */
662     function balanceOf(address owner) public view virtual override returns (uint256) {
663         require(owner != address(0), "ERC721: address zero is not a valid owner");
664         return _balances[owner];
665     }
666 
667     /**
668      * @dev See {IERC721-ownerOf}.
669      */
670     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
671         address owner = _owners[tokenId];
672         require(owner != address(0), "ERC721: invalid token ID");
673         return owner;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-name}.
678      */
679     function name() public view virtual override returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-symbol}.
685      */
686     function symbol() public view virtual override returns (string memory) {
687         return _symbol;
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-tokenURI}.
692      */
693     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
694         _requireMinted(tokenId);
695 
696         string memory baseURI = _baseURI();
697         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
698     }
699 
700     /**
701      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
702      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
703      * by default, can be overridden in child contracts.
704      */
705     function _baseURI() internal view virtual returns (string memory) {
706         return "";
707     }
708 
709     /**
710      * @dev See {IERC721-approve}.
711      */
712     function approve(address to, uint256 tokenId) public virtual override {
713         address owner = ERC721.ownerOf(tokenId);
714         require(to != owner, "ERC721: approval to current owner");
715 
716         require(
717             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
718             "ERC721: approve caller is not token owner nor approved for all"
719         );
720 
721         _approve(to, tokenId);
722     }
723 
724     /**
725      * @dev See {IERC721-getApproved}.
726      */
727     function getApproved(uint256 tokenId) public view virtual override returns (address) {
728         _requireMinted(tokenId);
729 
730         return _tokenApprovals[tokenId];
731     }
732 
733     /**
734      * @dev See {IERC721-setApprovalForAll}.
735      */
736     function setApprovalForAll(address operator, bool approved) public virtual override {
737         _setApprovalForAll(_msgSender(), operator, approved);
738     }
739 
740     /**
741      * @dev See {IERC721-isApprovedForAll}.
742      */
743     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
744         return _operatorApprovals[owner][operator];
745     }
746 
747     /**
748      * @dev See {IERC721-transferFrom}.
749      */
750     function transferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) public virtual override {
755         //solhint-disable-next-line max-line-length
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
757 
758         _transfer(from, to, tokenId);
759     }
760 
761     /**
762      * @dev See {IERC721-safeTransferFrom}.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId
768     ) public virtual override {
769         safeTransferFrom(from, to, tokenId, "");
770     }
771 
772     /**
773      * @dev See {IERC721-safeTransferFrom}.
774      */
775     function safeTransferFrom(
776         address from,
777         address to,
778         uint256 tokenId,
779         bytes memory data
780     ) public virtual override {
781         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
782         _safeTransfer(from, to, tokenId, data);
783     }
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
787      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
788      *
789      * `data` is additional data, it has no specified format and it is sent in call to `to`.
790      *
791      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
792      * implement alternative mechanisms to perform token transfer, such as signature-based.
793      *
794      * Requirements:
795      *
796      * - `from` cannot be the zero address.
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must exist and be owned by `from`.
799      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
800      *
801      * Emits a {Transfer} event.
802      */
803     function _safeTransfer(
804         address from,
805         address to,
806         uint256 tokenId,
807         bytes memory data
808     ) internal virtual {
809         _transfer(from, to, tokenId);
810         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
811     }
812 
813     /**
814      * @dev Returns whether `tokenId` exists.
815      *
816      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
817      *
818      * Tokens start existing when they are minted (`_mint`),
819      * and stop existing when they are burned (`_burn`).
820      */
821     function _exists(uint256 tokenId) internal view virtual returns (bool) {
822         return _owners[tokenId] != address(0);
823     }
824 
825     /**
826      * @dev Returns whether `spender` is allowed to manage `tokenId`.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      */
832     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
833         address owner = ERC721.ownerOf(tokenId);
834         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
835     }
836 
837     /**
838      * @dev Safely mints `tokenId` and transfers it to `to`.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must not exist.
843      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _safeMint(address to, uint256 tokenId) internal virtual {
848         _safeMint(to, tokenId, "");
849     }
850 
851     /**
852      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
853      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
854      */
855     function _safeMint(
856         address to,
857         uint256 tokenId,
858         bytes memory data
859     ) internal virtual {
860         _mint(to, tokenId);
861         require(
862             _checkOnERC721Received(address(0), to, tokenId, data),
863             "ERC721: transfer to non ERC721Receiver implementer"
864         );
865     }
866 
867     /**
868      * @dev Mints `tokenId` and transfers it to `to`.
869      *
870      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
871      *
872      * Requirements:
873      *
874      * - `tokenId` must not exist.
875      * - `to` cannot be the zero address.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _mint(address to, uint256 tokenId) internal virtual {
880         require(to != address(0), "ERC721: mint to the zero address");
881         require(!_exists(tokenId), "ERC721: token already minted");
882 
883         _beforeTokenTransfer(address(0), to, tokenId);
884 
885         _balances[to] += 1;
886         _owners[tokenId] = to;
887 
888         emit Transfer(address(0), to, tokenId);
889 
890         _afterTokenTransfer(address(0), to, tokenId);
891     }
892 
893     /**
894      * @dev Destroys `tokenId`.
895      * The approval is cleared when the token is burned.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _burn(uint256 tokenId) internal virtual {
904         address owner = ERC721.ownerOf(tokenId);
905 
906         _beforeTokenTransfer(owner, address(0), tokenId);
907 
908         // Clear approvals
909         _approve(address(0), tokenId);
910 
911         _balances[owner] -= 1;
912         delete _owners[tokenId];
913 
914         emit Transfer(owner, address(0), tokenId);
915 
916         _afterTokenTransfer(owner, address(0), tokenId);
917     }
918 
919     /**
920      * @dev Transfers `tokenId` from `from` to `to`.
921      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
922      *
923      * Requirements:
924      *
925      * - `to` cannot be the zero address.
926      * - `tokenId` token must be owned by `from`.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _transfer(
931         address from,
932         address to,
933         uint256 tokenId
934     ) internal virtual {
935         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
936         require(to != address(0), "ERC721: transfer to the zero address");
937 
938         _beforeTokenTransfer(from, to, tokenId);
939 
940         // Clear approvals from the previous owner
941         _approve(address(0), tokenId);
942 
943         _balances[from] -= 1;
944         _balances[to] += 1;
945         _owners[tokenId] = to;
946 
947         emit Transfer(from, to, tokenId);
948 
949         _afterTokenTransfer(from, to, tokenId);
950     }
951 
952     /**
953      * @dev Approve `to` to operate on `tokenId`
954      *
955      * Emits an {Approval} event.
956      */
957     function _approve(address to, uint256 tokenId) internal virtual {
958         _tokenApprovals[tokenId] = to;
959         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
960     }
961 
962     /**
963      * @dev Approve `operator` to operate on all of `owner` tokens
964      *
965      * Emits an {ApprovalForAll} event.
966      */
967     function _setApprovalForAll(
968         address owner,
969         address operator,
970         bool approved
971     ) internal virtual {
972         require(owner != operator, "ERC721: approve to caller");
973         _operatorApprovals[owner][operator] = approved;
974         emit ApprovalForAll(owner, operator, approved);
975     }
976 
977     /**
978      * @dev Reverts if the `tokenId` has not been minted yet.
979      */
980     function _requireMinted(uint256 tokenId) internal view virtual {
981         require(_exists(tokenId), "ERC721: invalid token ID");
982     }
983 
984     /**
985      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
986      * The call is not executed if the target address is not a contract.
987      *
988      * @param from address representing the previous owner of the given token ID
989      * @param to target address that will receive the tokens
990      * @param tokenId uint256 ID of the token to be transferred
991      * @param data bytes optional data to send along with the call
992      * @return bool whether the call correctly returned the expected magic value
993      */
994     function _checkOnERC721Received(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory data
999     ) private returns (bool) {
1000         if (to.isContract()) {
1001             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1002                 return retval == IERC721Receiver.onERC721Received.selector;
1003             } catch (bytes memory reason) {
1004                 if (reason.length == 0) {
1005                     revert("ERC721: transfer to non ERC721Receiver implementer");
1006                 } else {
1007                     /// @solidity memory-safe-assembly
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
1056 
1057 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.7.3
1058 
1059 
1060 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1061 
1062 pragma solidity ^0.8.0;
1063 
1064 /**
1065  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1066  * @dev See https://eips.ethereum.org/EIPS/eip-721
1067  */
1068 interface IERC721Enumerable is IERC721 {
1069     /**
1070      * @dev Returns the total amount of tokens stored by the contract.
1071      */
1072     function totalSupply() external view returns (uint256);
1073 
1074     /**
1075      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1076      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1077      */
1078     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1079 
1080     /**
1081      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1082      * Use along with {totalSupply} to enumerate all tokens.
1083      */
1084     function tokenByIndex(uint256 index) external view returns (uint256);
1085 }
1086 
1087 
1088 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.7.3
1089 
1090 
1091 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 
1096 /**
1097  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1098  * enumerability of all the token ids in the contract as well as all token ids owned by each
1099  * account.
1100  */
1101 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1102     // Mapping from owner to list of owned token IDs
1103     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1104 
1105     // Mapping from token ID to index of the owner tokens list
1106     mapping(uint256 => uint256) private _ownedTokensIndex;
1107 
1108     // Array with all token ids, used for enumeration
1109     uint256[] private _allTokens;
1110 
1111     // Mapping from token id to position in the allTokens array
1112     mapping(uint256 => uint256) private _allTokensIndex;
1113 
1114     /**
1115      * @dev See {IERC165-supportsInterface}.
1116      */
1117     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1118         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1119     }
1120 
1121     /**
1122      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1123      */
1124     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1125         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1126         return _ownedTokens[owner][index];
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Enumerable-totalSupply}.
1131      */
1132     function totalSupply() public view virtual override returns (uint256) {
1133         return _allTokens.length;
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Enumerable-tokenByIndex}.
1138      */
1139     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1140         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1141         return _allTokens[index];
1142     }
1143 
1144     /**
1145      * @dev Hook that is called before any token transfer. This includes minting
1146      * and burning.
1147      *
1148      * Calling conditions:
1149      *
1150      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1151      * transferred to `to`.
1152      * - When `from` is zero, `tokenId` will be minted for `to`.
1153      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1154      * - `from` cannot be the zero address.
1155      * - `to` cannot be the zero address.
1156      *
1157      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1158      */
1159     function _beforeTokenTransfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual override {
1164         super._beforeTokenTransfer(from, to, tokenId);
1165 
1166         if (from == address(0)) {
1167             _addTokenToAllTokensEnumeration(tokenId);
1168         } else if (from != to) {
1169             _removeTokenFromOwnerEnumeration(from, tokenId);
1170         }
1171         if (to == address(0)) {
1172             _removeTokenFromAllTokensEnumeration(tokenId);
1173         } else if (to != from) {
1174             _addTokenToOwnerEnumeration(to, tokenId);
1175         }
1176     }
1177 
1178     /**
1179      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1180      * @param to address representing the new owner of the given token ID
1181      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1182      */
1183     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1184         uint256 length = ERC721.balanceOf(to);
1185         _ownedTokens[to][length] = tokenId;
1186         _ownedTokensIndex[tokenId] = length;
1187     }
1188 
1189     /**
1190      * @dev Private function to add a token to this extension's token tracking data structures.
1191      * @param tokenId uint256 ID of the token to be added to the tokens list
1192      */
1193     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1194         _allTokensIndex[tokenId] = _allTokens.length;
1195         _allTokens.push(tokenId);
1196     }
1197 
1198     /**
1199      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1200      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1201      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1202      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1203      * @param from address representing the previous owner of the given token ID
1204      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1205      */
1206     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1207         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1208         // then delete the last slot (swap and pop).
1209 
1210         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1211         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1212 
1213         // When the token to delete is the last token, the swap operation is unnecessary
1214         if (tokenIndex != lastTokenIndex) {
1215             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1216 
1217             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1218             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1219         }
1220 
1221         // This also deletes the contents at the last position of the array
1222         delete _ownedTokensIndex[tokenId];
1223         delete _ownedTokens[from][lastTokenIndex];
1224     }
1225 
1226     /**
1227      * @dev Private function to remove a token from this extension's token tracking data structures.
1228      * This has O(1) time complexity, but alters the order of the _allTokens array.
1229      * @param tokenId uint256 ID of the token to be removed from the tokens list
1230      */
1231     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1232         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1233         // then delete the last slot (swap and pop).
1234 
1235         uint256 lastTokenIndex = _allTokens.length - 1;
1236         uint256 tokenIndex = _allTokensIndex[tokenId];
1237 
1238         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1239         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1240         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1241         uint256 lastTokenId = _allTokens[lastTokenIndex];
1242 
1243         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1244         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1245 
1246         // This also deletes the contents at the last position of the array
1247         delete _allTokensIndex[tokenId];
1248         _allTokens.pop();
1249     }
1250 }
1251 
1252 
1253 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.7.3
1254 
1255 
1256 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 /**
1261  * @dev Interface for the NFT Royalty Standard.
1262  *
1263  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1264  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1265  *
1266  * _Available since v4.5._
1267  */
1268 interface IERC2981 is IERC165 {
1269     /**
1270      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1271      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1272      */
1273     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1274         external
1275         view
1276         returns (address receiver, uint256 royaltyAmount);
1277 }
1278 
1279 
1280 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.7.3
1281 
1282 
1283 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1284 
1285 pragma solidity ^0.8.0;
1286 
1287 
1288 /**
1289  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1290  *
1291  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1292  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1293  *
1294  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1295  * fee is specified in basis points by default.
1296  *
1297  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1298  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1299  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1300  *
1301  * _Available since v4.5._
1302  */
1303 abstract contract ERC2981 is IERC2981, ERC165 {
1304     struct RoyaltyInfo {
1305         address receiver;
1306         uint96 royaltyFraction;
1307     }
1308 
1309     RoyaltyInfo private _defaultRoyaltyInfo;
1310     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1311 
1312     /**
1313      * @dev See {IERC165-supportsInterface}.
1314      */
1315     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1316         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1317     }
1318 
1319     /**
1320      * @inheritdoc IERC2981
1321      */
1322     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1323         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1324 
1325         if (royalty.receiver == address(0)) {
1326             royalty = _defaultRoyaltyInfo;
1327         }
1328 
1329         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1330 
1331         return (royalty.receiver, royaltyAmount);
1332     }
1333 
1334     /**
1335      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1336      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1337      * override.
1338      */
1339     function _feeDenominator() internal pure virtual returns (uint96) {
1340         return 10000;
1341     }
1342 
1343     /**
1344      * @dev Sets the royalty information that all ids in this contract will default to.
1345      *
1346      * Requirements:
1347      *
1348      * - `receiver` cannot be the zero address.
1349      * - `feeNumerator` cannot be greater than the fee denominator.
1350      */
1351     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1352         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1353         require(receiver != address(0), "ERC2981: invalid receiver");
1354 
1355         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1356     }
1357 
1358     /**
1359      * @dev Removes default royalty information.
1360      */
1361     function _deleteDefaultRoyalty() internal virtual {
1362         delete _defaultRoyaltyInfo;
1363     }
1364 
1365     /**
1366      * @dev Sets the royalty information for a specific token id, overriding the global default.
1367      *
1368      * Requirements:
1369      *
1370      * - `receiver` cannot be the zero address.
1371      * - `feeNumerator` cannot be greater than the fee denominator.
1372      */
1373     function _setTokenRoyalty(
1374         uint256 tokenId,
1375         address receiver,
1376         uint96 feeNumerator
1377     ) internal virtual {
1378         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1379         require(receiver != address(0), "ERC2981: Invalid parameters");
1380 
1381         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1382     }
1383 
1384     /**
1385      * @dev Resets royalty information for the token id back to the global default.
1386      */
1387     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1388         delete _tokenRoyaltyInfo[tokenId];
1389     }
1390 }
1391 
1392 
1393 // File contracts/Manageable.sol
1394 
1395 
1396 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 /**
1401  * @dev Contract module which provides a basic access control mechanism, where
1402  * there are several accounts (managers) that can be granted exclusive access to
1403  * specific functions.
1404  *
1405  * By default the deployer of the contract will be added as the first manager.
1406  * 
1407  * This module is used through inheritance. It will make available the modifier
1408  * `onlyManagers`, which can be applied to your functions to restrict their use to
1409  * the managers.
1410  */
1411 abstract contract Manageable is Context {
1412     mapping (address => bool) public managers;
1413 
1414     event ManagersAdded(address[] indexed newManagers);
1415     event ManagersRemoved(address[] indexed oldManagers);
1416 
1417     /**
1418      * @dev Initializes the contract setting the deployer as the initial manager.
1419      */
1420     constructor() {
1421         managers[_msgSender()] = true;
1422     }
1423 
1424     /**
1425      * @dev Throws if called by any account other than the managers.
1426      */
1427     modifier onlyManagers() {
1428         _checkManager();
1429         _;
1430     }
1431 
1432     /**
1433      * @dev Throws if the sender is not a manager.
1434      */
1435     function _checkManager() internal view virtual {
1436         require(managers[_msgSender()], "Manageable: caller is not a manager");
1437     }
1438 
1439     /**
1440      * @dev Adds manager role to new accounts (`newManagers`).
1441      * Can only be called by a current manager.
1442      */
1443     function addManagers(address[] memory newManagers) public virtual onlyManagers {
1444         _addManagers(newManagers);
1445     }
1446 
1447     /**
1448      * @dev Remove manager role from old accounts (`oldManagers`).
1449      * Can only be called by a current manager.
1450      */
1451     function removeManagers(address[] memory oldManagers) public virtual onlyManagers {
1452         _removeManagers(oldManagers);
1453     }
1454 
1455     /**
1456      * @dev Adds new managers of the contract (`newManagers`).
1457      * Internal function without access restriction.
1458      */
1459     function _addManagers(address[] memory newManagers) internal virtual {
1460         _setManagersState(newManagers, true);
1461 
1462         emit ManagersAdded(newManagers);
1463     }
1464 
1465     /**
1466      * @dev Removes old managers of the contract (`oldManagers`).
1467      * Internal function without access restriction.
1468      */
1469     function _removeManagers(address[] memory oldManagers) internal virtual {
1470         _setManagersState(oldManagers, false);
1471 
1472         emit ManagersRemoved(oldManagers);
1473     }
1474 
1475     /**
1476      * @dev Changes managers of the contract state (`setManagers`).
1477      * Internal function without access restriction.
1478      */
1479     function _setManagersState(address[] memory setManagers, bool newState) internal virtual {
1480         for (uint i = 0; i < setManagers.length; i++) {
1481             managers[setManagers[i]] = newState;
1482         }
1483     }
1484 }
1485 
1486 
1487 // File contracts/GG.sol
1488 
1489 
1490 pragma solidity ^0.8.4;
1491 
1492 
1493 
1494 /// @custom:security-contact nacho@particlecollection.com
1495 /// @title GG
1496 /// @notice GG contract for Particle NFTs representing a surprise drop for LIITA holders
1497 /// @dev Using ERC721Enumerable from OpenZeppelin for ERC-721 standard
1498 contract GG is ERC721, ERC721Enumerable, ERC2981, Manageable {
1499     using Strings for uint256;
1500 
1501     string public GGBaseURI;
1502 
1503     constructor(string memory ggURI) ERC721("GG Particles", "PRTCLGG") {
1504         GGBaseURI = ggURI;
1505     }
1506 
1507     /// @dev Sets baseURI for GG
1508     /// @notice Only managers can call this function
1509     /// @param newURI new base URI for NFT metadata
1510     function setBaseGGURI(string memory newURI) external onlyManagers {
1511         GGBaseURI = newURI;
1512     }
1513 
1514     /// @dev Override base ERC-721 tokenURI function to retun URI depndent on the tokenId
1515     /// @notice Only managers can call this function
1516     /// @param tokenId the token id beig queried
1517     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1518         _requireMinted(tokenId);
1519 
1520         return bytes(GGBaseURI).length > 0 ? string(abi.encodePacked(GGBaseURI, tokenId.toString())) : "";
1521     }
1522 
1523     /// @dev Sets the default royalty info for both collections
1524     /// @notice Only managers can call this function
1525     /// @param receiver royalties receiver
1526     /// @param feeNumerator royalties fee numerator (has to be smaller than denominator: 10000)
1527     function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyManagers {
1528         _setDefaultRoyalty(receiver, feeNumerator);
1529     }
1530 
1531     /// @dev Mints new tokens bridged from old contract
1532     /// @notice Only managers can call this function
1533     /// @param owners new token owners
1534     /// @param tokenIds Array of arrays, where each array contains the tokenIds to be minted for the corresponding owner
1535     function mint(address[] calldata owners, uint256[][] calldata tokenIds) public onlyManagers {
1536         require(owners.length == tokenIds.length, "Mint: Owners and tokensIds length mismatch");
1537 
1538         for (uint i = 0; i < owners.length; i++) {
1539             for (uint j = 0; j < tokenIds[i].length; j++) {
1540                 // Mint GG Particle NFT
1541                 _safeMint(owners[i], tokenIds[i][j]);
1542             }
1543         }
1544     }
1545 
1546     // The following functions are overrides required by Solidity.
1547 
1548     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1549         internal
1550         override(ERC721, ERC721Enumerable)
1551     {
1552         super._beforeTokenTransfer(from, to, tokenId);
1553     }
1554 
1555     function supportsInterface(bytes4 interfaceId)
1556         public
1557         view
1558         override(ERC721, ERC721Enumerable, ERC2981)
1559         returns (bool)
1560     {
1561         return super.supportsInterface(interfaceId);
1562     }
1563 }