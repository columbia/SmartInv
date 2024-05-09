1 //  SPDX-License-Identifier: MIT
2 pragma solidity 0.8.13;
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
26 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
27 
28 //  
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
170 
171 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
172 
173 //  
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
201 
202 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
203 
204 //  
205 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
211  * @dev See https://eips.ethereum.org/EIPS/eip-721
212  */
213 interface IERC721Metadata is IERC721 {
214     /**
215      * @dev Returns the token collection name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the token collection symbol.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
226      */
227     function tokenURI(uint256 tokenId) external view returns (string memory);
228 }
229 
230 
231 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
232 
233 //  
234 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
235 
236 pragma solidity ^0.8.1;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      *
259      * [IMPORTANT]
260      * ====
261      * You shouldn't rely on `isContract` to protect against flash loan attacks!
262      *
263      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
264      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
265      * constructor.
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize/address.code.length, which returns 0
270         // for contracts in construction, since the code is only stored at the end
271         // of the constructor execution.
272 
273         return account.code.length > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         (bool success, ) = recipient.call{value: amount}("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain `call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         require(isContract(target), "Address: call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.call{value: value}(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
380         return functionStaticCall(target, data, "Address: low-level static call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal view returns (bytes memory) {
394         require(isContract(target), "Address: static call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.staticcall(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
407         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(isContract(target), "Address: delegate call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.delegatecall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
429      * revert reason using the provided one.
430      *
431      * _Available since v4.3._
432      */
433     function verifyCallResult(
434         bool success,
435         bytes memory returndata,
436         string memory errorMessage
437     ) internal pure returns (bytes memory) {
438         if (success) {
439             return returndata;
440         } else {
441             // Look for revert reason and bubble it up if present
442             if (returndata.length > 0) {
443                 // The easiest way to bubble the revert reason is using memory via assembly
444 
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 
457 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
458 
459 //  
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
484 
485 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
486 
487 //  
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
555 
556 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
557 
558 //  
559 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev Implementation of the {IERC165} interface.
565  *
566  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
567  * for the additional interface id that will be supported. For example:
568  *
569  * ```solidity
570  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
572  * }
573  * ```
574  *
575  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
576  */
577 abstract contract ERC165 is IERC165 {
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
582         return interfaceId == type(IERC165).interfaceId;
583     }
584 }
585 
586 
587 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
588 
589 //  
590 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 
596 
597 
598 
599 
600 /**
601  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
602  * the Metadata extension, but not including the Enumerable extension, which is available separately as
603  * {ERC721Enumerable}.
604  */
605 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
606     using Address for address;
607     using Strings for uint256;
608 
609     // Token name
610     string private _name;
611 
612     // Token symbol
613     string private _symbol;
614 
615     // Mapping from token ID to owner address
616     mapping(uint256 => address) private _owners;
617 
618     // Mapping owner address to token count
619     mapping(address => uint256) private _balances;
620 
621     // Mapping from token ID to approved address
622     mapping(uint256 => address) private _tokenApprovals;
623 
624     // Mapping from owner to operator approvals
625     mapping(address => mapping(address => bool)) private _operatorApprovals;
626 
627     /**
628      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
629      */
630     constructor(string memory name_, string memory symbol_) {
631         _name = name_;
632         _symbol = symbol_;
633     }
634 
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
639         return
640             interfaceId == type(IERC721).interfaceId ||
641             interfaceId == type(IERC721Metadata).interfaceId ||
642             super.supportsInterface(interfaceId);
643     }
644 
645     /**
646      * @dev See {IERC721-balanceOf}.
647      */
648     function balanceOf(address owner) public view virtual override returns (uint256) {
649         require(owner != address(0), "ERC721: balance query for the zero address");
650         return _balances[owner];
651     }
652 
653     /**
654      * @dev See {IERC721-ownerOf}.
655      */
656     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
657         address owner = _owners[tokenId];
658         require(owner != address(0), "ERC721: owner query for nonexistent token");
659         return owner;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-name}.
664      */
665     function name() public view virtual override returns (string memory) {
666         return _name;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-symbol}.
671      */
672     function symbol() public view virtual override returns (string memory) {
673         return _symbol;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-tokenURI}.
678      */
679     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
680         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
681 
682         string memory baseURI = _baseURI();
683         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
684     }
685 
686     /**
687      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
688      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
689      * by default, can be overriden in child contracts.
690      */
691     function _baseURI() internal view virtual returns (string memory) {
692         return "";
693     }
694 
695     /**
696      * @dev See {IERC721-approve}.
697      */
698     function approve(address to, uint256 tokenId) public virtual override {
699         address owner = ERC721.ownerOf(tokenId);
700         require(to != owner, "ERC721: approval to current owner");
701 
702         require(
703             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
704             "ERC721: approve caller is not owner nor approved for all"
705         );
706 
707         _approve(to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-getApproved}.
712      */
713     function getApproved(uint256 tokenId) public view virtual override returns (address) {
714         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
715 
716         return _tokenApprovals[tokenId];
717     }
718 
719     /**
720      * @dev See {IERC721-setApprovalForAll}.
721      */
722     function setApprovalForAll(address operator, bool approved) public virtual override {
723         _setApprovalForAll(_msgSender(), operator, approved);
724     }
725 
726     /**
727      * @dev See {IERC721-isApprovedForAll}.
728      */
729     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
730         return _operatorApprovals[owner][operator];
731     }
732 
733     /**
734      * @dev See {IERC721-transferFrom}.
735      */
736     function transferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public virtual override {
741         //solhint-disable-next-line max-line-length
742         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
743 
744         _transfer(from, to, tokenId);
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) public virtual override {
755         safeTransferFrom(from, to, tokenId, "");
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId,
765         bytes memory _data
766     ) public virtual override {
767         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
768         _safeTransfer(from, to, tokenId, _data);
769     }
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
773      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
774      *
775      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
776      *
777      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
778      * implement alternative mechanisms to perform token transfer, such as signature-based.
779      *
780      * Requirements:
781      *
782      * - `from` cannot be the zero address.
783      * - `to` cannot be the zero address.
784      * - `tokenId` token must exist and be owned by `from`.
785      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _safeTransfer(
790         address from,
791         address to,
792         uint256 tokenId,
793         bytes memory _data
794     ) internal virtual {
795         _transfer(from, to, tokenId);
796         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
797     }
798 
799     /**
800      * @dev Returns whether `tokenId` exists.
801      *
802      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
803      *
804      * Tokens start existing when they are minted (`_mint`),
805      * and stop existing when they are burned (`_burn`).
806      */
807     function _exists(uint256 tokenId) internal view virtual returns (bool) {
808         return _owners[tokenId] != address(0);
809     }
810 
811     /**
812      * @dev Returns whether `spender` is allowed to manage `tokenId`.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      */
818     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
819         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
820         address owner = ERC721.ownerOf(tokenId);
821         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
822     }
823 
824     /**
825      * @dev Safely mints `tokenId` and transfers it to `to`.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must not exist.
830      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _safeMint(address to, uint256 tokenId) internal virtual {
835         _safeMint(to, tokenId, "");
836     }
837 
838     /**
839      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
840      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
841      */
842     function _safeMint(
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) internal virtual {
847         _mint(to, tokenId);
848         require(
849             _checkOnERC721Received(address(0), to, tokenId, _data),
850             "ERC721: transfer to non ERC721Receiver implementer"
851         );
852     }
853 
854     /**
855      * @dev Mints `tokenId` and transfers it to `to`.
856      *
857      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
858      *
859      * Requirements:
860      *
861      * - `tokenId` must not exist.
862      * - `to` cannot be the zero address.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _mint(address to, uint256 tokenId) internal virtual {
867         require(to != address(0), "ERC721: mint to the zero address");
868         require(!_exists(tokenId), "ERC721: token already minted");
869 
870         _beforeTokenTransfer(address(0), to, tokenId);
871 
872         _balances[to] += 1;
873         _owners[tokenId] = to;
874 
875         emit Transfer(address(0), to, tokenId);
876 
877         _afterTokenTransfer(address(0), to, tokenId);
878     }
879 
880     /**
881      * @dev Destroys `tokenId`.
882      * The approval is cleared when the token is burned.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _burn(uint256 tokenId) internal virtual {
891         address owner = ERC721.ownerOf(tokenId);
892 
893         _beforeTokenTransfer(owner, address(0), tokenId);
894 
895         // Clear approvals
896         _approve(address(0), tokenId);
897 
898         _balances[owner] -= 1;
899         delete _owners[tokenId];
900 
901         emit Transfer(owner, address(0), tokenId);
902 
903         _afterTokenTransfer(owner, address(0), tokenId);
904     }
905 
906     /**
907      * @dev Transfers `tokenId` from `from` to `to`.
908      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
909      *
910      * Requirements:
911      *
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must be owned by `from`.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _transfer(
918         address from,
919         address to,
920         uint256 tokenId
921     ) internal virtual {
922         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
923         require(to != address(0), "ERC721: transfer to the zero address");
924 
925         _beforeTokenTransfer(from, to, tokenId);
926 
927         // Clear approvals from the previous owner
928         _approve(address(0), tokenId);
929 
930         _balances[from] -= 1;
931         _balances[to] += 1;
932         _owners[tokenId] = to;
933 
934         emit Transfer(from, to, tokenId);
935 
936         _afterTokenTransfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev Approve `to` to operate on `tokenId`
941      *
942      * Emits a {Approval} event.
943      */
944     function _approve(address to, uint256 tokenId) internal virtual {
945         _tokenApprovals[tokenId] = to;
946         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
947     }
948 
949     /**
950      * @dev Approve `operator` to operate on all of `owner` tokens
951      *
952      * Emits a {ApprovalForAll} event.
953      */
954     function _setApprovalForAll(
955         address owner,
956         address operator,
957         bool approved
958     ) internal virtual {
959         require(owner != operator, "ERC721: approve to caller");
960         _operatorApprovals[owner][operator] = approved;
961         emit ApprovalForAll(owner, operator, approved);
962     }
963 
964     /**
965      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
966      * The call is not executed if the target address is not a contract.
967      *
968      * @param from address representing the previous owner of the given token ID
969      * @param to target address that will receive the tokens
970      * @param tokenId uint256 ID of the token to be transferred
971      * @param _data bytes optional data to send along with the call
972      * @return bool whether the call correctly returned the expected magic value
973      */
974     function _checkOnERC721Received(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) private returns (bool) {
980         if (to.isContract()) {
981             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
982                 return retval == IERC721Receiver.onERC721Received.selector;
983             } catch (bytes memory reason) {
984                 if (reason.length == 0) {
985                     revert("ERC721: transfer to non ERC721Receiver implementer");
986                 } else {
987                     assembly {
988                         revert(add(32, reason), mload(reason))
989                     }
990                 }
991             }
992         } else {
993             return true;
994         }
995     }
996 
997     /**
998      * @dev Hook that is called before any token transfer. This includes minting
999      * and burning.
1000      *
1001      * Calling conditions:
1002      *
1003      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1004      * transferred to `to`.
1005      * - When `from` is zero, `tokenId` will be minted for `to`.
1006      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1007      * - `from` and `to` are never both zero.
1008      *
1009      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1010      */
1011     function _beforeTokenTransfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) internal virtual {}
1016 
1017     /**
1018      * @dev Hook that is called after any transfer of tokens. This includes
1019      * minting and burning.
1020      *
1021      * Calling conditions:
1022      *
1023      * - when `from` and `to` are both non-zero.
1024      * - `from` and `to` are never both zero.
1025      *
1026      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1027      */
1028     function _afterTokenTransfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) internal virtual {}
1033 }
1034 
1035 
1036 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
1037 
1038 //  
1039 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1040 
1041 pragma solidity ^0.8.0;
1042 
1043 /**
1044  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1045  * @dev See https://eips.ethereum.org/EIPS/eip-721
1046  */
1047 interface IERC721Enumerable is IERC721 {
1048     /**
1049      * @dev Returns the total amount of tokens stored by the contract.
1050      */
1051     function totalSupply() external view returns (uint256);
1052 
1053     /**
1054      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1055      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1056      */
1057     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1058 
1059     /**
1060      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1061      * Use along with {totalSupply} to enumerate all tokens.
1062      */
1063     function tokenByIndex(uint256 index) external view returns (uint256);
1064 }
1065 
1066 
1067 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.5.0
1068 
1069 //  
1070 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 
1075 /**
1076  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1077  * enumerability of all the token ids in the contract as well as all token ids owned by each
1078  * account.
1079  */
1080 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1081     // Mapping from owner to list of owned token IDs
1082     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1083 
1084     // Mapping from token ID to index of the owner tokens list
1085     mapping(uint256 => uint256) private _ownedTokensIndex;
1086 
1087     // Array with all token ids, used for enumeration
1088     uint256[] private _allTokens;
1089 
1090     // Mapping from token id to position in the allTokens array
1091     mapping(uint256 => uint256) private _allTokensIndex;
1092 
1093     /**
1094      * @dev See {IERC165-supportsInterface}.
1095      */
1096     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1097         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1102      */
1103     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1104         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1105         return _ownedTokens[owner][index];
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Enumerable-totalSupply}.
1110      */
1111     function totalSupply() public view virtual override returns (uint256) {
1112         return _allTokens.length;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-tokenByIndex}.
1117      */
1118     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1119         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1120         return _allTokens[index];
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before any token transfer. This includes minting
1125      * and burning.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1133      * - `from` cannot be the zero address.
1134      * - `to` cannot be the zero address.
1135      *
1136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1137      */
1138     function _beforeTokenTransfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) internal virtual override {
1143         super._beforeTokenTransfer(from, to, tokenId);
1144 
1145         if (from == address(0)) {
1146             _addTokenToAllTokensEnumeration(tokenId);
1147         } else if (from != to) {
1148             _removeTokenFromOwnerEnumeration(from, tokenId);
1149         }
1150         if (to == address(0)) {
1151             _removeTokenFromAllTokensEnumeration(tokenId);
1152         } else if (to != from) {
1153             _addTokenToOwnerEnumeration(to, tokenId);
1154         }
1155     }
1156 
1157     /**
1158      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1159      * @param to address representing the new owner of the given token ID
1160      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1161      */
1162     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1163         uint256 length = ERC721.balanceOf(to);
1164         _ownedTokens[to][length] = tokenId;
1165         _ownedTokensIndex[tokenId] = length;
1166     }
1167 
1168     /**
1169      * @dev Private function to add a token to this extension's token tracking data structures.
1170      * @param tokenId uint256 ID of the token to be added to the tokens list
1171      */
1172     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1173         _allTokensIndex[tokenId] = _allTokens.length;
1174         _allTokens.push(tokenId);
1175     }
1176 
1177     /**
1178      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1179      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1180      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1181      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1182      * @param from address representing the previous owner of the given token ID
1183      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1184      */
1185     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1186         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1187         // then delete the last slot (swap and pop).
1188 
1189         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1190         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1191 
1192         // When the token to delete is the last token, the swap operation is unnecessary
1193         if (tokenIndex != lastTokenIndex) {
1194             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1195 
1196             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1197             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1198         }
1199 
1200         // This also deletes the contents at the last position of the array
1201         delete _ownedTokensIndex[tokenId];
1202         delete _ownedTokens[from][lastTokenIndex];
1203     }
1204 
1205     /**
1206      * @dev Private function to remove a token from this extension's token tracking data structures.
1207      * This has O(1) time complexity, but alters the order of the _allTokens array.
1208      * @param tokenId uint256 ID of the token to be removed from the tokens list
1209      */
1210     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1211         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1212         // then delete the last slot (swap and pop).
1213 
1214         uint256 lastTokenIndex = _allTokens.length - 1;
1215         uint256 tokenIndex = _allTokensIndex[tokenId];
1216 
1217         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1218         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1219         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1220         uint256 lastTokenId = _allTokens[lastTokenIndex];
1221 
1222         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1223         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1224 
1225         // This also deletes the contents at the last position of the array
1226         delete _allTokensIndex[tokenId];
1227         _allTokens.pop();
1228     }
1229 }
1230 
1231 
1232 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
1233 
1234 //  
1235 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1236 
1237 pragma solidity ^0.8.0;
1238 
1239 /**
1240  * @dev Contract module which allows children to implement an emergency stop
1241  * mechanism that can be triggered by an authorized account.
1242  *
1243  * This module is used through inheritance. It will make available the
1244  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1245  * the functions of your contract. Note that they will not be pausable by
1246  * simply including this module, only once the modifiers are put in place.
1247  */
1248 abstract contract Pausable is Context {
1249     /**
1250      * @dev Emitted when the pause is triggered by `account`.
1251      */
1252     event Paused(address account);
1253 
1254     /**
1255      * @dev Emitted when the pause is lifted by `account`.
1256      */
1257     event Unpaused(address account);
1258 
1259     bool private _paused;
1260 
1261     /**
1262      * @dev Initializes the contract in unpaused state.
1263      */
1264     constructor() {
1265         _paused = false;
1266     }
1267 
1268     /**
1269      * @dev Returns true if the contract is paused, and false otherwise.
1270      */
1271     function paused() public view virtual returns (bool) {
1272         return _paused;
1273     }
1274 
1275     /**
1276      * @dev Modifier to make a function callable only when the contract is not paused.
1277      *
1278      * Requirements:
1279      *
1280      * - The contract must not be paused.
1281      */
1282     modifier whenNotPaused() {
1283         require(!paused(), "Pausable: paused");
1284         _;
1285     }
1286 
1287     /**
1288      * @dev Modifier to make a function callable only when the contract is paused.
1289      *
1290      * Requirements:
1291      *
1292      * - The contract must be paused.
1293      */
1294     modifier whenPaused() {
1295         require(paused(), "Pausable: not paused");
1296         _;
1297     }
1298 
1299     /**
1300      * @dev Triggers stopped state.
1301      *
1302      * Requirements:
1303      *
1304      * - The contract must not be paused.
1305      */
1306     function _pause() internal virtual whenNotPaused {
1307         _paused = true;
1308         emit Paused(_msgSender());
1309     }
1310 
1311     /**
1312      * @dev Returns to normal state.
1313      *
1314      * Requirements:
1315      *
1316      * - The contract must be paused.
1317      */
1318     function _unpause() internal virtual whenPaused {
1319         _paused = false;
1320         emit Unpaused(_msgSender());
1321     }
1322 }
1323 
1324 
1325 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1326 
1327 //  
1328 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1329 
1330 pragma solidity ^0.8.0;
1331 
1332 /**
1333  * @dev Contract module which provides a basic access control mechanism, where
1334  * there is an account (an owner) that can be granted exclusive access to
1335  * specific functions.
1336  *
1337  * By default, the owner account will be the one that deploys the contract. This
1338  * can later be changed with {transferOwnership}.
1339  *
1340  * This module is used through inheritance. It will make available the modifier
1341  * `onlyOwner`, which can be applied to your functions to restrict their use to
1342  * the owner.
1343  */
1344 abstract contract Ownable is Context {
1345     address private _owner;
1346 
1347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1348 
1349     /**
1350      * @dev Initializes the contract setting the deployer as the initial owner.
1351      */
1352     constructor() {
1353         _transferOwnership(_msgSender());
1354     }
1355 
1356     /**
1357      * @dev Returns the address of the current owner.
1358      */
1359     function owner() public view virtual returns (address) {
1360         return _owner;
1361     }
1362 
1363     /**
1364      * @dev Throws if called by any account other than the owner.
1365      */
1366     modifier onlyOwner() {
1367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1368         _;
1369     }
1370 
1371     /**
1372      * @dev Leaves the contract without owner. It will not be possible to call
1373      * `onlyOwner` functions anymore. Can only be called by the current owner.
1374      *
1375      * NOTE: Renouncing ownership will leave the contract without an owner,
1376      * thereby removing any functionality that is only available to the owner.
1377      */
1378     function renounceOwnership() public virtual onlyOwner {
1379         _transferOwnership(address(0));
1380     }
1381 
1382     /**
1383      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1384      * Can only be called by the current owner.
1385      */
1386     function transferOwnership(address newOwner) public virtual onlyOwner {
1387         require(newOwner != address(0), "Ownable: new owner is the zero address");
1388         _transferOwnership(newOwner);
1389     }
1390 
1391     /**
1392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1393      * Internal function without access restriction.
1394      */
1395     function _transferOwnership(address newOwner) internal virtual {
1396         address oldOwner = _owner;
1397         _owner = newOwner;
1398         emit OwnershipTransferred(oldOwner, newOwner);
1399     }
1400 }
1401 
1402 
1403 // File contracts/EvilWizards.sol
1404 
1405 //  
1406 pragma solidity ^0.8.4;
1407 contract WoFGameBall is ERC721, ERC721Enumerable, Pausable, Ownable {
1408     using Strings for uint256;
1409 
1410     string public baseURI =
1411         "https://gateway.pinata.cloud/ipfs/QmaKmT3kpsvfAgTN7U8Qg3qQ8XfaNRJQAhxiY6kA3humRC/";
1412     string public baseExtension = ".json";
1413     uint256 public cost = 0 ether;
1414     uint256 public maxSupply = 444;
1415     uint256 public maxMintPerAddress = 1;
1416     bool public revealed = true;
1417     bool private startSale = false;
1418     string public notRevealedUri =
1419         "ipfs://QmaKmT3kpsvfAgTN7U8Qg3qQ8XfaNRJQAhxiY6kA3humRC";
1420 
1421     mapping (address => uint256) private mintCountPerAddress;
1422 
1423     constructor() ERC721("WoF Game Ball", "WoFGB") {}
1424 
1425     fallback() external payable {}
1426 
1427     receive() external payable {}
1428 
1429     function _baseURI() internal view virtual override returns (string memory) {
1430         return baseURI;
1431     }
1432 
1433     function setBaseURI(string memory _baseuri) external onlyOwner {
1434         baseURI = _baseuri;
1435     }
1436 
1437     function tokenURI(uint256 tokenId)
1438         public
1439         view
1440         virtual
1441         override
1442         returns (string memory)
1443     {
1444         require(
1445             _exists(tokenId),
1446             "ERC721Metadata: URI query for nonexistent token"
1447         );
1448 
1449         if (!revealed) {
1450             return notRevealedUri;
1451         }
1452 
1453         string memory currentBaseURI = _baseURI();
1454         return
1455             bytes(currentBaseURI).length > 0
1456                 ? string(
1457                     abi.encodePacked(
1458                         currentBaseURI,
1459                         tokenId.toString(),
1460                         baseExtension
1461                     )
1462                 )
1463                 : "";
1464     }
1465 
1466     function reveal() public onlyOwner {
1467         revealed = true;
1468     }
1469 
1470     function setRevealed() external onlyOwner {
1471         revealed = !revealed;
1472     }
1473 
1474     function setNFTPrice(uint256 _newCost) public onlyOwner {
1475         cost = _newCost;
1476     }
1477 
1478     function getNFTPrice() external view returns(uint256) {
1479         return cost;
1480     }
1481 
1482     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1483         notRevealedUri = _notRevealedURI;
1484     }
1485 
1486     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1487         baseExtension = _newBaseExtension;
1488     }
1489 
1490     function pause() public onlyOwner {
1491         _pause();
1492     }
1493 
1494     function unpause() public onlyOwner {
1495         _unpause();
1496     }
1497 
1498     function _beforeTokenTransfer(
1499         address from,
1500         address to,
1501         uint256 tokenId
1502     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1503         super._beforeTokenTransfer(from, to, tokenId);
1504     }
1505 
1506     function supportsInterface(bytes4 interfaceId)
1507         public
1508         view
1509         override(ERC721, ERC721Enumerable)
1510         returns (bool)
1511     {
1512         return super.supportsInterface(interfaceId);
1513     }
1514 
1515     function withdraw() external onlyOwner whenNotPaused returns(uint256){
1516         uint balance = address(this).balance;
1517         require(balance > 0, "NFT: No ether left to withdraw");
1518 
1519         (bool success, ) = payable(owner()).call{ value: balance } ("");
1520         require(success, "NFT: Transfer failed.");
1521         return balance;
1522     }
1523 
1524     function lastTokenID() external view returns(uint256) {
1525         return totalSupply();
1526     }
1527 
1528     function contractBalance() external view returns(uint256) {
1529         return address(this).balance;
1530     }
1531 
1532     function mint(address _to, uint256 _mintAmount) public payable whenNotPaused {
1533       uint256 supply = totalSupply();
1534       require(_mintAmount > 0);
1535       require(supply + _mintAmount <= maxSupply);
1536       if (msg.sender != owner()) {
1537         require(msg.value >= cost * _mintAmount);
1538       }
1539 
1540       for (uint256 i = 1; i <= _mintAmount; i++) {
1541           mintCountPerAddress[_to] = mintCountPerAddress[_to] + 1;
1542           require(mintCountPerAddress[_to] <= maxMintPerAddress, "Minting Limit exceeds.");
1543         _safeMint(_to, supply + i);
1544       }
1545     }
1546 
1547     function walletOfOwner(address _owner)
1548       public
1549       view
1550       returns (uint256[] memory)
1551     {
1552       uint256 ownerTokenCount = balanceOf(_owner);
1553       uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1554       for (uint256 i; i < ownerTokenCount; i++) {
1555         tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1556       }
1557       return tokenIds;
1558     }
1559 
1560     function _maxSupply() external view returns(uint256) {
1561         return maxSupply;
1562     }
1563 
1564     function safeMint(address to, uint256 tokenId) public onlyOwner {
1565         _safeMint(to, tokenId);
1566     }
1567 
1568 }