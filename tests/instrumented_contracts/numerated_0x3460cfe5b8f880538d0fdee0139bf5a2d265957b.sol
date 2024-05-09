1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
205 
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216     /**
217      * @dev Returns the token collection name.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the token collection symbol.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
228      */
229     function tokenURI(uint256 tokenId) external view returns (string memory);
230 }
231 
232 // File: @openzeppelin/contracts/utils/Address.sol
233 
234 
235 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
236 
237 pragma solidity ^0.8.1;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      *
260      * [IMPORTANT]
261      * ====
262      * You shouldn't rely on `isContract` to protect against flash loan attacks!
263      *
264      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
265      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
266      * constructor.
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize/address.code.length, which returns 0
271         // for contracts in construction, since the code is only stored at the end
272         // of the constructor execution.
273 
274         return account.code.length > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         require(isContract(target), "Address: call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.call{value: value}(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
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
407     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(isContract(target), "Address: delegate call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.delegatecall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
430      * revert reason using the provided one.
431      *
432      * _Available since v4.3._
433      */
434     function verifyCallResult(
435         bool success,
436         bytes memory returndata,
437         string memory errorMessage
438     ) internal pure returns (bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445                 /// @solidity memory-safe-assembly
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 // File: @openzeppelin/contracts/utils/Context.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Provides information about the current execution context, including the
466  * sender of the transaction and its data. While these are generally available
467  * via msg.sender and msg.data, they should not be accessed in such a direct
468  * manner, since when dealing with meta-transactions the account sending and
469  * paying for execution may not be the actual sender (as far as an application
470  * is concerned).
471  *
472  * This contract is only required for intermediate, library-like contracts.
473  */
474 abstract contract Context {
475     function _msgSender() internal view virtual returns (address) {
476         return msg.sender;
477     }
478 
479     function _msgData() internal view virtual returns (bytes calldata) {
480         return msg.data;
481     }
482 }
483 
484 // File: @openzeppelin/contracts/utils/Strings.sol
485 
486 
487 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @dev String operations.
493  */
494 library Strings {
495     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
496     uint8 private constant _ADDRESS_LENGTH = 20;
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
553 
554     /**
555      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
556      */
557     function toHexString(address addr) internal pure returns (string memory) {
558         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
559     }
560 }
561 
562 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Implementation of the {IERC165} interface.
571  *
572  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
573  * for the additional interface id that will be supported. For example:
574  *
575  * ```solidity
576  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
577  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
578  * }
579  * ```
580  *
581  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
582  */
583 abstract contract ERC165 is IERC165 {
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588         return interfaceId == type(IERC165).interfaceId;
589     }
590 }
591 
592 // File: contracts/ERC721R.sol
593 
594 
595 
596 pragma solidity ^0.8.0;
597 
598 
599 
600 
601 
602 
603 
604 /**
605  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
606  * the Metadata extension, but not including the Enumerable extension. This does random batch minting.
607  */
608 contract ERC721r is Context, ERC165, IERC721, IERC721Metadata {
609     using Address for address;
610     using Strings for uint256;
611 
612     // Token name
613     string private _name;
614 
615     // Token symbol
616     string private _symbol;
617 
618     // BaseURI
619     string public baseURI = "";
620     
621     mapping(uint => uint) private _availableTokens;
622     uint256 private _numAvailableTokens;
623     uint256 immutable _maxSupply;
624     // Mapping from token ID to owner address
625     mapping(uint256 => address) private _owners;
626 
627     // Mapping owner address to token count
628     mapping(address => uint256) private _balances;
629 
630     // Mapping from token ID to approved address
631     mapping(uint256 => address) private _tokenApprovals;
632 
633     // Mapping from owner to operator approvals
634     mapping(address => mapping(address => bool)) private _operatorApprovals;
635     
636     /**
637      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
638      */
639     constructor(string memory name_, string memory symbol_, uint maxSupply_) {
640         _name = name_;
641         _symbol = symbol_;
642         _maxSupply = maxSupply_;
643         _numAvailableTokens = maxSupply_;
644     }
645     
646     /**
647      * @dev See {IERC165-supportsInterface}.
648      */
649     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
650         return
651             interfaceId == type(IERC721).interfaceId ||
652             interfaceId == type(IERC721Metadata).interfaceId ||
653             super.supportsInterface(interfaceId);
654     }
655     
656     function totalSupply() public view virtual returns (uint256) {
657         return _maxSupply - _numAvailableTokens;
658     }
659     
660     function maxSupply() public view virtual returns (uint256) {
661         return _maxSupply;
662     }
663 
664     /**
665      * @dev See {IERC721-balanceOf}.
666      */
667     function balanceOf(address owner) public view virtual override returns (uint256) {
668         require(owner != address(0), "ERC721: balance query for the zero address");
669         return _balances[owner];
670     }
671 
672     /**
673      * @dev See {IERC721-ownerOf}.
674      */
675     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
676         address owner = _owners[tokenId];
677         require(owner != address(0), "ERC721: owner query for nonexistent token");
678         return owner;
679     }
680 
681     /**
682      * @dev See {IERC721Metadata-name}.
683      */
684     function name() public view virtual override returns (string memory) {
685         return _name;
686     }
687 
688     /**
689      * @dev See {IERC721Metadata-symbol}.
690      */
691     function symbol() public view virtual override returns (string memory) {
692         return _symbol;
693     }
694 
695     /**
696      * @dev See {IERC721Metadata-tokenURI}.
697      */
698     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
699         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
700 
701         string memory uri = _baseURI();
702         return bytes(uri).length > 0 ? string(abi.encodePacked(uri, '/', tokenId.toString())) : "";
703     }
704 
705     /**
706      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
707      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
708      * by default, can be overridden in child contracts.
709      */
710     function _baseURI() internal view virtual returns (string memory) {
711         return baseURI;
712     }
713 
714     /**
715      * @dev See {IERC721-approve}.
716      */
717     function approve(address to, uint256 tokenId) public virtual override {
718         address owner = ERC721r.ownerOf(tokenId);
719         require(to != owner, "ERC721: approval to current owner");
720 
721         require(
722             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
723             "ERC721: approve caller is not owner nor approved for all"
724         );
725 
726         _approve(to, tokenId);
727     }
728 
729     /**
730      * @dev See {IERC721-getApproved}.
731      */
732     function getApproved(uint256 tokenId) public view virtual override returns (address) {
733         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
734 
735         return _tokenApprovals[tokenId];
736     }
737 
738     /**
739      * @dev See {IERC721-setApprovalForAll}.
740      */
741     function setApprovalForAll(address operator, bool approved) public virtual override {
742         _setApprovalForAll(_msgSender(), operator, approved);
743     }
744 
745     /**
746      * @dev See {IERC721-isApprovedForAll}.
747      */
748     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
749         return _operatorApprovals[owner][operator];
750     }
751 
752     /**
753      * @dev See {IERC721-transferFrom}.
754      */
755     function transferFrom(
756         address from,
757         address to,
758         uint256 tokenId
759     ) public virtual override {
760         //solhint-disable-next-line max-line-length
761         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
762 
763         _transfer(from, to, tokenId);
764     }
765 
766     /**
767      * @dev See {IERC721-safeTransferFrom}.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 tokenId
773     ) public virtual override {
774         safeTransferFrom(from, to, tokenId, "");
775     }
776 
777     /**
778      * @dev See {IERC721-safeTransferFrom}.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) public virtual override {
786         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
787         _safeTransfer(from, to, tokenId, _data);
788     }
789 
790     /**
791      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
792      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
793      *
794      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
795      *
796      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
797      * implement alternative mechanisms to perform token transfer, such as signature-based.
798      *
799      * Requirements:
800      *
801      * - `from` cannot be the zero address.
802      * - `to` cannot be the zero address.
803      * - `tokenId` token must exist and be owned by `from`.
804      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _safeTransfer(
809         address from,
810         address to,
811         uint256 tokenId,
812         bytes memory _data
813     ) internal virtual {
814         _transfer(from, to, tokenId);
815         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
816     }
817 
818     /**
819      * @dev Returns whether `tokenId` exists.
820      *
821      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
822      *
823      * Tokens start existing when they are minted (`_mint`),
824      * and stop existing when they are burned (`_burn`).
825      */
826     function _exists(uint256 tokenId) internal view virtual returns (bool) {
827         return _owners[tokenId] != address(0);
828     }
829 
830     /**
831      * @dev Returns whether `spender` is allowed to manage `tokenId`.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      */
837     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
838         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
839         address owner = ERC721r.ownerOf(tokenId);
840         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
841     }
842 
843     function _mintIdWithoutBalanceUpdate(address to, uint256 tokenId) private {
844         
845         _owners[tokenId] = to;
846         
847         emit Transfer(address(0), to, tokenId);
848         
849         _afterTokenTransfer(address(0), to, tokenId);
850     }
851 
852     function _mintRandom(address to, uint _numToMint) internal virtual {
853         require(_msgSender() == tx.origin, "Contracts cannot mint");
854         require(to != address(0), "ERC721: mint to the zero address");
855         require(_numToMint > 0, "ERC721r: need to mint at least one token");
856         
857         // TODO: Probably don't need this as it will underflow and revert automatically in this case
858         require(_numAvailableTokens >= _numToMint, "ERC721r: minting more tokens than available");
859 
860         uint updatedNumAvailableTokens = _numAvailableTokens;
861         uint256[] memory tokenIds = new uint256[](_numToMint);
862 
863         // gather all tokenIds in array
864         for (uint256 i; i < _numToMint; ++i) { // Do this ++ unchecked?
865             uint256 tokenId = getRandomAvailableTokenId(to, updatedNumAvailableTokens);
866             tokenIds[i] = tokenId;
867             --updatedNumAvailableTokens;
868         }
869 
870         _beforeTokenTransfer(address(0), to, tokenIds); // 0 placeholder for tokenId param
871 
872         // iterate through all tokenIds and mint
873         for (uint256 i; i < _numToMint; ++i) { // using _numToMint to avoid length() function call
874              _mintIdWithoutBalanceUpdate(to, tokenIds[i]);
875         }
876         
877         _numAvailableTokens = updatedNumAvailableTokens;
878         _balances[to] += _numToMint;
879     }
880         
881     function getRandomAvailableTokenId(address to, uint updatedNumAvailableTokens)
882         internal
883         returns (uint256)
884     {
885         uint256 randomNum = uint256(
886             keccak256(
887                 abi.encode(
888                     to,
889                     tx.gasprice,
890                     block.number,
891                     block.timestamp,
892                     block.difficulty,
893                     blockhash(block.number - 1),
894                     address(this),
895                     updatedNumAvailableTokens
896                 )
897             )
898         );
899         uint256 randomIndex = randomNum % updatedNumAvailableTokens;
900         return getAvailableTokenAtIndex(randomIndex, updatedNumAvailableTokens);
901     }
902 
903     // Implements https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle. Code taken from CryptoPhunksV2
904     function getAvailableTokenAtIndex(uint256 indexToUse, uint updatedNumAvailableTokens)
905         internal
906         returns (uint256)
907     {
908         uint256 valAtIndex = _availableTokens[indexToUse];
909         uint256 result;
910         if (valAtIndex == 0) {
911             // This means the index itself is still an available token
912             result = indexToUse;
913         } else {
914             // This means the index itself is not an available token, but the val at that index is.
915             result = valAtIndex;
916         }
917 
918         uint256 lastIndex = updatedNumAvailableTokens - 1;
919         if (indexToUse != lastIndex) {
920             // Replace the value at indexToUse, now that it's been used.
921             // Replace it with the data from the last index in the array, since we are going to decrease the array size afterwards.
922             uint256 lastValInArray = _availableTokens[lastIndex];
923             if (lastValInArray == 0) {
924                 // This means the index itself is still an available token
925                 _availableTokens[indexToUse] = lastIndex;
926             } else {
927                 // This means the index itself is not an available token, but the val at that index is.
928                 _availableTokens[indexToUse] = lastValInArray;
929                 // Gas refund courtsey of @dievardump
930                 delete _availableTokens[lastIndex];
931             }
932         }
933         
934         return result;
935     }
936     
937     // Not as good as minting a specific tokenId, but will behave the same at the start
938     // allowing you to explicitly mint some tokens at launch.
939     function _mintAtIndex(address to, uint index) internal virtual {
940         require(_msgSender() == tx.origin, "Contracts cannot mint");
941         require(to != address(0), "ERC721: mint to the zero address");
942         require(_numAvailableTokens >= 1, "ERC721r: minting more tokens than available");
943         
944         uint tokenId = getAvailableTokenAtIndex(index, _numAvailableTokens);
945         --_numAvailableTokens;
946         
947         uint256[] memory tokenIds = new uint256[](1);
948         tokenIds[0] = tokenId;
949 
950         _beforeTokenTransfer(address(0), to, tokenIds);
951 
952         _mintIdWithoutBalanceUpdate(to, tokenId);
953         
954         _balances[to] += 1;
955     }
956 
957     /**
958      * @dev Transfers `tokenId` from `from` to `to`.
959      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
960      *
961      * Requirements:
962      *
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must be owned by `from`.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _transfer(
969         address from,
970         address to,
971         uint256 tokenId
972     ) internal virtual {
973         require(ERC721r.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
974         require(to != address(0), "ERC721: transfer to the zero address");
975 
976         uint256[] memory tokenIds = new uint256[](1);
977         tokenIds[0] = tokenId;
978 
979         _beforeTokenTransfer(from, to, tokenIds);
980 
981         // Clear approvals from the previous owner
982         _approve(address(0), tokenId);
983 
984         _balances[from] -= 1;
985         _balances[to] += 1;
986         _owners[tokenId] = to;
987 
988         emit Transfer(from, to, tokenId);
989 
990         _afterTokenTransfer(from, to, tokenId);
991     }
992 
993     /**
994      * @dev Approve `to` to operate on `tokenId`
995      *
996      * Emits a {Approval} event.
997      */
998     function _approve(address to, uint256 tokenId) internal virtual {
999         _tokenApprovals[tokenId] = to;
1000         emit Approval(ERC721r.ownerOf(tokenId), to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Approve `operator` to operate on all of `owner` tokens
1005      *
1006      * Emits a {ApprovalForAll} event.
1007      */
1008     function _setApprovalForAll(
1009         address owner,
1010         address operator,
1011         bool approved
1012     ) internal virtual {
1013         require(owner != operator, "ERC721: approve to caller");
1014         _operatorApprovals[owner][operator] = approved;
1015         emit ApprovalForAll(owner, operator, approved);
1016     }
1017 
1018     /**
1019      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1020      * The call is not executed if the target address is not a contract.
1021      *
1022      * @param from address representing the previous owner of the given token ID
1023      * @param to target address that will receive the tokens
1024      * @param tokenId uint256 ID of the token to be transferred
1025      * @param _data bytes optional data to send along with the call
1026      * @return bool whether the call correctly returned the expected magic value
1027      */
1028     function _checkOnERC721Received(
1029         address from,
1030         address to,
1031         uint256 tokenId,
1032         bytes memory _data
1033     ) private returns (bool) {
1034         if (to.isContract()) {
1035             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1036                 return retval == IERC721Receiver.onERC721Received.selector;
1037             } catch (bytes memory reason) {
1038                 if (reason.length == 0) {
1039                     revert("ERC721: transfer to non ERC721Receiver implementer");
1040                 } else {
1041                     assembly {
1042                         revert(add(32, reason), mload(reason))
1043                     }
1044                 }
1045             }
1046         } else {
1047             return true;
1048         }
1049     }
1050 
1051     /**
1052      * @dev Hook that is called before any token transfer. This includes minting
1053      * and burning.
1054      *
1055      * Calling conditions:
1056      *
1057      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1058      * transferred to `to`.
1059      * - When `from` is zero, `tokenId` will be minted for `to`.
1060      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1061      * - `from` and `to` are never both zero.
1062      *
1063      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1064      */
1065     function _beforeTokenTransfer(
1066         address from,
1067         address to,
1068         uint256[] memory tokenIds
1069     ) internal virtual {}
1070 
1071     /**
1072      * @dev Hook that is called after any transfer of tokens. This includes
1073      * minting and burning.
1074      *
1075      * Calling conditions:
1076      *
1077      * - when `from` and `to` are both non-zero.
1078      * - `from` and `to` are never both zero.
1079      *
1080      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1081      */
1082     function _afterTokenTransfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) internal virtual {}
1087 }
1088 
1089 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1090 
1091 
1092 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 /**
1097  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1098  * @dev See https://eips.ethereum.org/EIPS/eip-721
1099  */
1100 interface IERC721Enumerable is IERC721 {
1101     /**
1102      * @dev Returns the total amount of tokens stored by the contract.
1103      */
1104     function totalSupply() external view returns (uint256);
1105 
1106     /**
1107      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1108      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1109      */
1110     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1111 
1112     /**
1113      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1114      * Use along with {totalSupply} to enumerate all tokens.
1115      */
1116     function tokenByIndex(uint256 index) external view returns (uint256);
1117 }
1118 
1119 // File: contracts/ERC721REnumerable.sol
1120 
1121 
1122 // Inspired by OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1123 // Modified by alpereira7
1124 
1125 pragma solidity ^0.8.0;
1126 
1127 
1128 /**
1129  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1130  * enumerability of all the token ids in the contract as well as all token ids owned by each
1131  * account.
1132  */
1133 abstract contract ERC721rEnumerable is ERC721r, IERC721Enumerable {
1134     // Mapping from owner to list of owned token IDs
1135     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1136 
1137     // Mapping from token ID to index of the owner tokens list
1138     mapping(uint256 => uint256) private _ownedTokensIndex;
1139 
1140     // Array with all token ids, used for enumeration
1141     uint256[] private _allTokens;
1142 
1143     // Mapping from token id to position in the allTokens array
1144     mapping(uint256 => uint256) private _allTokensIndex;
1145 
1146     /**
1147      * @dev See {IERC165-supportsInterface}.
1148      */
1149     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721r) returns (bool) {
1150         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1155      */
1156     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1157         require(index < ERC721r.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1158         return _ownedTokens[owner][index];
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Enumerable-totalSupply}.
1163      */
1164     function totalSupply() public view virtual override(ERC721r, IERC721Enumerable) returns (uint256) {
1165         return _allTokens.length;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Enumerable-tokenByIndex}.
1170      */
1171     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1172         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1173         return _allTokens[index];
1174     }
1175 
1176     /**
1177      * @dev Hook that is called before any token transfer. This includes minting
1178      * and burning.
1179      *
1180      * Calling conditions:
1181      *
1182      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1183      * transferred to `to`.
1184      * - When `from` is zero, `tokenId` will be minted for `to`.
1185      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1186      * - `from` cannot be the zero address.
1187      * - `to` cannot be the zero address.
1188      *
1189      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1190      */
1191     function _beforeTokenTransfer(
1192         address from,
1193         address to,
1194         uint256[] memory tokenIds
1195     ) internal virtual override {
1196 
1197         super._beforeTokenTransfer(from, to, tokenIds);
1198 
1199         if (from == address(0)) {
1200             _addTokenToAllTokensEnumeration(tokenIds);
1201         } else if (from != to) {
1202             _removeTokenFromOwnerEnumeration(from, tokenIds[0]);
1203         }
1204         if (to == address(0)) {
1205             _removeTokenFromAllTokensEnumeration(tokenIds[0]);
1206         } else if (to != from) {
1207             _addTokenToOwnerEnumeration(to, tokenIds);
1208         }
1209     }
1210 
1211     /**
1212      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1213      * @param to address representing the new owner of the given token ID
1214      * @param tokenIds uint256 ID of the token to be added to the tokens list of the given address
1215      */
1216     function _addTokenToOwnerEnumeration( address to, uint256[] memory tokenIds ) private {
1217         uint256 length = ERC721r.balanceOf(to);
1218 
1219         for( uint i=0; i<tokenIds.length; ++i){
1220             _ownedTokens[to][length+i] = tokenIds[i];
1221             _ownedTokensIndex[tokenIds[i]] = length+i;
1222         }
1223     }
1224 
1225     /**
1226      * @dev Private function to add a token to this extension's token tracking data structures.
1227      * @param tokenIds uint256 ID of the token to be added to the tokens list
1228      */
1229     function _addTokenToAllTokensEnumeration(uint256[] memory tokenIds) private {
1230         for( uint i=0; i<tokenIds.length; ++i){
1231             _allTokensIndex[tokenIds[i]] = _allTokens.length+i;
1232             _allTokens.push(tokenIds[i]);
1233         }        
1234     }
1235 
1236     /**
1237      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1238      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1239      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1240      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1241      * @param from address representing the previous owner of the given token ID
1242      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1243      */
1244     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1245         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1246         // then delete the last slot (swap and pop).
1247 
1248         uint256 lastTokenIndex = ERC721r.balanceOf(from) - 1;
1249         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1250 
1251         // When the token to delete is the last token, the swap operation is unnecessary
1252         if (tokenIndex != lastTokenIndex) {
1253             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1254 
1255             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1256             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1257         }
1258 
1259         // This also deletes the contents at the last position of the array
1260         delete _ownedTokensIndex[tokenId];
1261         delete _ownedTokens[from][lastTokenIndex];
1262     }
1263 
1264     /**
1265      * @dev Private function to remove a token from this extension's token tracking data structures.
1266      * This has O(1) time complexity, but alters the order of the _allTokens array.
1267      * @param tokenId uint256 ID of the token to be removed from the tokens list
1268      */
1269     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1270         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1271         // then delete the last slot (swap and pop).
1272 
1273         uint256 lastTokenIndex = _allTokens.length - 1;
1274         uint256 tokenIndex = _allTokensIndex[tokenId];
1275 
1276         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1277         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1278         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1279         uint256 lastTokenId = _allTokens[lastTokenIndex];
1280 
1281         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1282         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1283 
1284         // This also deletes the contents at the last position of the array
1285         delete _allTokensIndex[tokenId];
1286         _allTokens.pop();
1287     }
1288 }
1289 
1290 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1291 
1292 
1293 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1294 
1295 pragma solidity ^0.8.0;
1296 
1297 /**
1298  * @dev These functions deal with verification of Merkle Tree proofs.
1299  *
1300  * The proofs can be generated using the JavaScript library
1301  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1302  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1303  *
1304  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1305  *
1306  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1307  * hashing, or use a hash function other than keccak256 for hashing leaves.
1308  * This is because the concatenation of a sorted pair of internal nodes in
1309  * the merkle tree could be reinterpreted as a leaf value.
1310  */
1311 library MerkleProof {
1312     /**
1313      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1314      * defined by `root`. For this, a `proof` must be provided, containing
1315      * sibling hashes on the branch from the leaf to the root of the tree. Each
1316      * pair of leaves and each pair of pre-images are assumed to be sorted.
1317      */
1318     function verify(
1319         bytes32[] memory proof,
1320         bytes32 root,
1321         bytes32 leaf
1322     ) internal pure returns (bool) {
1323         return processProof(proof, leaf) == root;
1324     }
1325 
1326     /**
1327      * @dev Calldata version of {verify}
1328      *
1329      * _Available since v4.7._
1330      */
1331     function verifyCalldata(
1332         bytes32[] calldata proof,
1333         bytes32 root,
1334         bytes32 leaf
1335     ) internal pure returns (bool) {
1336         return processProofCalldata(proof, leaf) == root;
1337     }
1338 
1339     /**
1340      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1341      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1342      * hash matches the root of the tree. When processing the proof, the pairs
1343      * of leafs & pre-images are assumed to be sorted.
1344      *
1345      * _Available since v4.4._
1346      */
1347     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1348         bytes32 computedHash = leaf;
1349         for (uint256 i = 0; i < proof.length; i++) {
1350             computedHash = _hashPair(computedHash, proof[i]);
1351         }
1352         return computedHash;
1353     }
1354 
1355     /**
1356      * @dev Calldata version of {processProof}
1357      *
1358      * _Available since v4.7._
1359      */
1360     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1361         bytes32 computedHash = leaf;
1362         for (uint256 i = 0; i < proof.length; i++) {
1363             computedHash = _hashPair(computedHash, proof[i]);
1364         }
1365         return computedHash;
1366     }
1367 
1368     /**
1369      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1370      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1371      *
1372      * _Available since v4.7._
1373      */
1374     function multiProofVerify(
1375         bytes32[] memory proof,
1376         bool[] memory proofFlags,
1377         bytes32 root,
1378         bytes32[] memory leaves
1379     ) internal pure returns (bool) {
1380         return processMultiProof(proof, proofFlags, leaves) == root;
1381     }
1382 
1383     /**
1384      * @dev Calldata version of {multiProofVerify}
1385      *
1386      * _Available since v4.7._
1387      */
1388     function multiProofVerifyCalldata(
1389         bytes32[] calldata proof,
1390         bool[] calldata proofFlags,
1391         bytes32 root,
1392         bytes32[] memory leaves
1393     ) internal pure returns (bool) {
1394         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1395     }
1396 
1397     /**
1398      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1399      * consuming from one or the other at each step according to the instructions given by
1400      * `proofFlags`.
1401      *
1402      * _Available since v4.7._
1403      */
1404     function processMultiProof(
1405         bytes32[] memory proof,
1406         bool[] memory proofFlags,
1407         bytes32[] memory leaves
1408     ) internal pure returns (bytes32 merkleRoot) {
1409         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1410         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1411         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1412         // the merkle tree.
1413         uint256 leavesLen = leaves.length;
1414         uint256 totalHashes = proofFlags.length;
1415 
1416         // Check proof validity.
1417         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1418 
1419         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1420         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1421         bytes32[] memory hashes = new bytes32[](totalHashes);
1422         uint256 leafPos = 0;
1423         uint256 hashPos = 0;
1424         uint256 proofPos = 0;
1425         // At each step, we compute the next hash using two values:
1426         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1427         //   get the next hash.
1428         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1429         //   `proof` array.
1430         for (uint256 i = 0; i < totalHashes; i++) {
1431             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1432             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1433             hashes[i] = _hashPair(a, b);
1434         }
1435 
1436         if (totalHashes > 0) {
1437             return hashes[totalHashes - 1];
1438         } else if (leavesLen > 0) {
1439             return leaves[0];
1440         } else {
1441             return proof[0];
1442         }
1443     }
1444 
1445     /**
1446      * @dev Calldata version of {processMultiProof}
1447      *
1448      * _Available since v4.7._
1449      */
1450     function processMultiProofCalldata(
1451         bytes32[] calldata proof,
1452         bool[] calldata proofFlags,
1453         bytes32[] memory leaves
1454     ) internal pure returns (bytes32 merkleRoot) {
1455         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1456         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1457         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1458         // the merkle tree.
1459         uint256 leavesLen = leaves.length;
1460         uint256 totalHashes = proofFlags.length;
1461 
1462         // Check proof validity.
1463         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1464 
1465         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1466         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1467         bytes32[] memory hashes = new bytes32[](totalHashes);
1468         uint256 leafPos = 0;
1469         uint256 hashPos = 0;
1470         uint256 proofPos = 0;
1471         // At each step, we compute the next hash using two values:
1472         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1473         //   get the next hash.
1474         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1475         //   `proof` array.
1476         for (uint256 i = 0; i < totalHashes; i++) {
1477             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1478             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1479             hashes[i] = _hashPair(a, b);
1480         }
1481 
1482         if (totalHashes > 0) {
1483             return hashes[totalHashes - 1];
1484         } else if (leavesLen > 0) {
1485             return leaves[0];
1486         } else {
1487             return proof[0];
1488         }
1489     }
1490 
1491     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1492         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1493     }
1494 
1495     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1496         /// @solidity memory-safe-assembly
1497         assembly {
1498             mstore(0x00, a)
1499             mstore(0x20, b)
1500             value := keccak256(0x00, 0x40)
1501         }
1502     }
1503 }
1504 
1505 // File: @openzeppelin/contracts/access/Ownable.sol
1506 
1507 
1508 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1509 
1510 pragma solidity ^0.8.0;
1511 
1512 /**
1513  * @dev Contract module which provides a basic access control mechanism, where
1514  * there is an account (an owner) that can be granted exclusive access to
1515  * specific functions.
1516  *
1517  * By default, the owner account will be the one that deploys the contract. This
1518  * can later be changed with {transferOwnership}.
1519  *
1520  * This module is used through inheritance. It will make available the modifier
1521  * `onlyOwner`, which can be applied to your functions to restrict their use to
1522  * the owner.
1523  */
1524 abstract contract Ownable is Context {
1525     address private _owner;
1526 
1527     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1528 
1529     /**
1530      * @dev Initializes the contract setting the deployer as the initial owner.
1531      */
1532     constructor() {
1533         _transferOwnership(_msgSender());
1534     }
1535 
1536     /**
1537      * @dev Throws if called by any account other than the owner.
1538      */
1539     modifier onlyOwner() {
1540         _checkOwner();
1541         _;
1542     }
1543 
1544     /**
1545      * @dev Returns the address of the current owner.
1546      */
1547     function owner() public view virtual returns (address) {
1548         return _owner;
1549     }
1550 
1551     /**
1552      * @dev Throws if the sender is not the owner.
1553      */
1554     function _checkOwner() internal view virtual {
1555         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1556     }
1557 
1558     /**
1559      * @dev Leaves the contract without owner. It will not be possible to call
1560      * `onlyOwner` functions anymore. Can only be called by the current owner.
1561      *
1562      * NOTE: Renouncing ownership will leave the contract without an owner,
1563      * thereby removing any functionality that is only available to the owner.
1564      */
1565     function renounceOwnership() public virtual onlyOwner {
1566         _transferOwnership(address(0));
1567     }
1568 
1569     /**
1570      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1571      * Can only be called by the current owner.
1572      */
1573     function transferOwnership(address newOwner) public virtual onlyOwner {
1574         require(newOwner != address(0), "Ownable: new owner is the zero address");
1575         _transferOwnership(newOwner);
1576     }
1577 
1578     /**
1579      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1580      * Internal function without access restriction.
1581      */
1582     function _transferOwnership(address newOwner) internal virtual {
1583         address oldOwner = _owner;
1584         _owner = newOwner;
1585         emit OwnershipTransferred(oldOwner, newOwner);
1586     }
1587 }
1588 
1589 // File: contracts/EQLZ.sol
1590 
1591 
1592 
1593 pragma solidity ^0.8.0;
1594 
1595 
1596 
1597 
1598 contract EQLZ is ERC721r, ERC721rEnumerable, Ownable {     
1599 
1600     address payable client;
1601     struct Product {
1602         uint id;
1603         string name;
1604         uint openWindow;
1605         uint closeWindow;
1606     }    
1607     string public provenanceHash;
1608     mapping (uint => Product) public products;
1609     uint public productCount;
1610     uint maxTotalMints = 1;    
1611     bytes32 merkleroot;
1612     bool public saleIsActive = false;
1613 
1614     constructor(string memory name_, string memory symbol_, uint maxSupply_, address payable _client) ERC721r(name_, symbol_, maxSupply_) {
1615         client = _client;
1616     }
1617 
1618     function _beforeTokenTransfer(address from, address to, uint256[] memory tokenIdxs)    
1619         internal
1620         virtual
1621         override(ERC721r, ERC721rEnumerable)
1622     {
1623         super._beforeTokenTransfer(from, to, tokenIdxs);
1624     }
1625 
1626     function totalSupply()
1627         public 
1628         view        
1629         override(ERC721r, ERC721rEnumerable)
1630         returns (uint256)
1631     {
1632         return super.totalSupply();
1633     }
1634 
1635     function supportsInterface(bytes4 interfaceId)
1636         public
1637         view
1638         override(ERC721r, ERC721rEnumerable)
1639         returns (bool)
1640     {
1641         return super.supportsInterface(interfaceId);
1642     }    
1643 
1644     modifier onlyClient(){
1645         require(msg.sender == client);
1646         _;
1647     }
1648 
1649     modifier maxMintLimit(uint quantity){
1650         require(balanceOf(msg.sender) + quantity <= maxTotalMints, "Mint would exceed total allowance per wallet!");
1651         _;
1652     }
1653 
1654     function withdraw() external onlyClient {    
1655         require(address(this).balance > 0, "This contract has no balance");
1656 
1657         client.transfer(address(this).balance);
1658     }
1659 
1660     function updateClient(address payable _client) external onlyOwner {
1661         client = _client;
1662     }
1663 
1664     function setProvenanceHash(string memory _provenanceHash) external onlyOwner {
1665         require(bytes(provenanceHash).length==0, "Provenance Hash Has Already Been Set");
1666         provenanceHash = _provenanceHash;
1667     }
1668 
1669     function setMerkleroot(bytes32 _merkleroot) external onlyClient {
1670         merkleroot = _merkleroot;
1671     }
1672 
1673     function setBaseURI( string calldata _baseURI) external onlyClient {
1674         baseURI = _baseURI;
1675     }
1676 
1677     function setMaxTotalMints( uint _maxTotalMints) external onlyClient {
1678         maxTotalMints = _maxTotalMints;
1679     }
1680 
1681     function toggleSaleIsActive() external onlyClient {
1682         saleIsActive = !saleIsActive;
1683     }
1684 
1685      function verifyWhitelistMembership(bytes32[] calldata proof, address _address) internal view returns (bool){        
1686         bytes32 leaf = keccak256(abi.encodePacked(_address));        
1687         return MerkleProof.verify(proof, merkleroot, leaf);
1688     }
1689 
1690     function reserveMint(uint quantity) external onlyClient {
1691         _mintRandom(msg.sender, quantity);
1692     }
1693 
1694     function publicMint(uint quantity) public maxMintLimit(quantity){  
1695         require(saleIsActive, "Mint is closed.");      
1696         _mintRandom(msg.sender, quantity);
1697     }
1698 
1699     function presaleMint(bytes32[] calldata proof, uint quantity) public maxMintLimit(quantity){ 
1700         require(!saleIsActive, "Presale mint is closed.");
1701         require(verifyWhitelistMembership(proof, msg.sender), "You are not on the whitelist");               
1702         _mintRandom(msg.sender, quantity);
1703     }
1704 
1705     function addNewProduct( string calldata _name, uint _openWindow, uint _closeWindow) external onlyClient  {        
1706         products[productCount] = Product(productCount, _name, _openWindow, _closeWindow);
1707         productCount++;
1708     }
1709 
1710     function updateProductRedemptionWindows( string memory _name, uint _openWindow, uint _closeWindow ) external onlyClient {        
1711         for(uint i=0; i<productCount; ++i){
1712             string memory name = products[i].name;
1713             if( (keccak256(abi.encodePacked((name))) == keccak256(abi.encodePacked((_name))))){                
1714                 products[i].openWindow = _openWindow;
1715                 products[i].closeWindow = _closeWindow;      
1716             }
1717         }        
1718     }
1719 
1720     function getProductRedemptions() external view returns (Product[] memory){
1721         Product[] memory lProducts = new Product[](productCount);
1722         for (uint i = 0; i < productCount; i++) {
1723           Product storage lProduct = products[i];
1724           lProducts[i] = lProduct;
1725       }
1726       return lProducts;
1727     }
1728 
1729     function getAllTokensOfOwner(address _address) external view returns(uint256[] memory){
1730         uint numTokens = balanceOf(_address);
1731         uint256[] memory tokenIds = new uint256[](numTokens);
1732         for(uint i=0; i<numTokens; ++i){
1733             tokenIds[i] = tokenOfOwnerByIndex(_address, i);
1734         }
1735         return tokenIds;
1736     }
1737 
1738 }