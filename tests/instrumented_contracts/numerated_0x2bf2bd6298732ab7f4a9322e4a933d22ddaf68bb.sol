1 // Sources flattened with hardhat v2.7.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
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
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.0
33 
34 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
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
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.0
177 
178 
179 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @title ERC721 token receiver interface
185  * @dev Interface for any contract that wants to support safeTransfers
186  * from ERC721 asset contracts.
187  */
188 interface IERC721Receiver {
189     /**
190      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
191      * by `operator` from `from`, this function is called.
192      *
193      * It must return its Solidity selector to confirm the token transfer.
194      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
195      *
196      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
197      */
198     function onERC721Received(
199         address operator,
200         address from,
201         uint256 tokenId,
202         bytes calldata data
203     ) external returns (bytes4);
204 }
205 
206 
207 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.0
208 
209 
210 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Metadata is IERC721 {
219     /**
220      * @dev Returns the token collection name.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the token collection symbol.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
231      */
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 
236 // File @openzeppelin/contracts/utils/Address.sol@v4.4.0
237 
238 
239 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         assembly {
271             size := extcodesize(account)
272         }
273         return size > 0;
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
457 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
458 
459 
460 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
485 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.0
486 
487 
488 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
556 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.0
557 
558 
559 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
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
587 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.0
588 
589 
590 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
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
876     }
877 
878     /**
879      * @dev Destroys `tokenId`.
880      * The approval is cleared when the token is burned.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _burn(uint256 tokenId) internal virtual {
889         address owner = ERC721.ownerOf(tokenId);
890 
891         _beforeTokenTransfer(owner, address(0), tokenId);
892 
893         // Clear approvals
894         _approve(address(0), tokenId);
895 
896         _balances[owner] -= 1;
897         delete _owners[tokenId];
898 
899         emit Transfer(owner, address(0), tokenId);
900     }
901 
902     /**
903      * @dev Transfers `tokenId` from `from` to `to`.
904      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
905      *
906      * Requirements:
907      *
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must be owned by `from`.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _transfer(
914         address from,
915         address to,
916         uint256 tokenId
917     ) internal virtual {
918         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
919         require(to != address(0), "ERC721: transfer to the zero address");
920 
921         _beforeTokenTransfer(from, to, tokenId);
922 
923         // Clear approvals from the previous owner
924         _approve(address(0), tokenId);
925 
926         _balances[from] -= 1;
927         _balances[to] += 1;
928         _owners[tokenId] = to;
929 
930         emit Transfer(from, to, tokenId);
931     }
932 
933     /**
934      * @dev Approve `to` to operate on `tokenId`
935      *
936      * Emits a {Approval} event.
937      */
938     function _approve(address to, uint256 tokenId) internal virtual {
939         _tokenApprovals[tokenId] = to;
940         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
941     }
942 
943     /**
944      * @dev Approve `operator` to operate on all of `owner` tokens
945      *
946      * Emits a {ApprovalForAll} event.
947      */
948     function _setApprovalForAll(
949         address owner,
950         address operator,
951         bool approved
952     ) internal virtual {
953         require(owner != operator, "ERC721: approve to caller");
954         _operatorApprovals[owner][operator] = approved;
955         emit ApprovalForAll(owner, operator, approved);
956     }
957 
958     /**
959      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
960      * The call is not executed if the target address is not a contract.
961      *
962      * @param from address representing the previous owner of the given token ID
963      * @param to target address that will receive the tokens
964      * @param tokenId uint256 ID of the token to be transferred
965      * @param _data bytes optional data to send along with the call
966      * @return bool whether the call correctly returned the expected magic value
967      */
968     function _checkOnERC721Received(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) private returns (bool) {
974         if (to.isContract()) {
975             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
976                 return retval == IERC721Receiver.onERC721Received.selector;
977             } catch (bytes memory reason) {
978                 if (reason.length == 0) {
979                     revert("ERC721: transfer to non ERC721Receiver implementer");
980                 } else {
981                     assembly {
982                         revert(add(32, reason), mload(reason))
983                     }
984                 }
985             }
986         } else {
987             return true;
988         }
989     }
990 
991     /**
992      * @dev Hook that is called before any token transfer. This includes minting
993      * and burning.
994      *
995      * Calling conditions:
996      *
997      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
998      * transferred to `to`.
999      * - When `from` is zero, `tokenId` will be minted for `to`.
1000      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1001      * - `from` and `to` are never both zero.
1002      *
1003      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1004      */
1005     function _beforeTokenTransfer(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) internal virtual {}
1010 }
1011 
1012 
1013 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.0
1014 
1015 
1016 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1017 
1018 pragma solidity ^0.8.0;
1019 
1020 /**
1021  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1022  * @dev See https://eips.ethereum.org/EIPS/eip-721
1023  */
1024 interface IERC721Enumerable is IERC721 {
1025     /**
1026      * @dev Returns the total amount of tokens stored by the contract.
1027      */
1028     function totalSupply() external view returns (uint256);
1029 
1030     /**
1031      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1032      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1033      */
1034     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1035 
1036     /**
1037      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1038      * Use along with {totalSupply} to enumerate all tokens.
1039      */
1040     function tokenByIndex(uint256 index) external view returns (uint256);
1041 }
1042 
1043 
1044 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.4.0
1045 
1046 
1047 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1048 
1049 pragma solidity ^0.8.0;
1050 
1051 
1052 /**
1053  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1054  * enumerability of all the token ids in the contract as well as all token ids owned by each
1055  * account.
1056  */
1057 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1058     // Mapping from owner to list of owned token IDs
1059     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1060 
1061     // Mapping from token ID to index of the owner tokens list
1062     mapping(uint256 => uint256) private _ownedTokensIndex;
1063 
1064     // Array with all token ids, used for enumeration
1065     uint256[] private _allTokens;
1066 
1067     // Mapping from token id to position in the allTokens array
1068     mapping(uint256 => uint256) private _allTokensIndex;
1069 
1070     /**
1071      * @dev See {IERC165-supportsInterface}.
1072      */
1073     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1074         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1075     }
1076 
1077     /**
1078      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1079      */
1080     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1081         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1082         return _ownedTokens[owner][index];
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Enumerable-totalSupply}.
1087      */
1088     function totalSupply() public view virtual override returns (uint256) {
1089         return _allTokens.length;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Enumerable-tokenByIndex}.
1094      */
1095     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1096         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1097         return _allTokens[index];
1098     }
1099 
1100     /**
1101      * @dev Hook that is called before any token transfer. This includes minting
1102      * and burning.
1103      *
1104      * Calling conditions:
1105      *
1106      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1107      * transferred to `to`.
1108      * - When `from` is zero, `tokenId` will be minted for `to`.
1109      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1110      * - `from` cannot be the zero address.
1111      * - `to` cannot be the zero address.
1112      *
1113      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1114      */
1115     function _beforeTokenTransfer(
1116         address from,
1117         address to,
1118         uint256 tokenId
1119     ) internal virtual override {
1120         super._beforeTokenTransfer(from, to, tokenId);
1121 
1122         if (from == address(0)) {
1123             _addTokenToAllTokensEnumeration(tokenId);
1124         } else if (from != to) {
1125             _removeTokenFromOwnerEnumeration(from, tokenId);
1126         }
1127         if (to == address(0)) {
1128             _removeTokenFromAllTokensEnumeration(tokenId);
1129         } else if (to != from) {
1130             _addTokenToOwnerEnumeration(to, tokenId);
1131         }
1132     }
1133 
1134     /**
1135      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1136      * @param to address representing the new owner of the given token ID
1137      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1138      */
1139     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1140         uint256 length = ERC721.balanceOf(to);
1141         _ownedTokens[to][length] = tokenId;
1142         _ownedTokensIndex[tokenId] = length;
1143     }
1144 
1145     /**
1146      * @dev Private function to add a token to this extension's token tracking data structures.
1147      * @param tokenId uint256 ID of the token to be added to the tokens list
1148      */
1149     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1150         _allTokensIndex[tokenId] = _allTokens.length;
1151         _allTokens.push(tokenId);
1152     }
1153 
1154     /**
1155      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1156      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1157      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1158      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1159      * @param from address representing the previous owner of the given token ID
1160      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1161      */
1162     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1163         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1164         // then delete the last slot (swap and pop).
1165 
1166         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1167         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1168 
1169         // When the token to delete is the last token, the swap operation is unnecessary
1170         if (tokenIndex != lastTokenIndex) {
1171             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1172 
1173             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1174             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1175         }
1176 
1177         // This also deletes the contents at the last position of the array
1178         delete _ownedTokensIndex[tokenId];
1179         delete _ownedTokens[from][lastTokenIndex];
1180     }
1181 
1182     /**
1183      * @dev Private function to remove a token from this extension's token tracking data structures.
1184      * This has O(1) time complexity, but alters the order of the _allTokens array.
1185      * @param tokenId uint256 ID of the token to be removed from the tokens list
1186      */
1187     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1188         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1189         // then delete the last slot (swap and pop).
1190 
1191         uint256 lastTokenIndex = _allTokens.length - 1;
1192         uint256 tokenIndex = _allTokensIndex[tokenId];
1193 
1194         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1195         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1196         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1197         uint256 lastTokenId = _allTokens[lastTokenIndex];
1198 
1199         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1200         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1201 
1202         // This also deletes the contents at the last position of the array
1203         delete _allTokensIndex[tokenId];
1204         _allTokens.pop();
1205     }
1206 }
1207 
1208 
1209 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
1210 
1211 
1212 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1213 
1214 pragma solidity ^0.8.0;
1215 
1216 /**
1217  * @dev Contract module which provides a basic access control mechanism, where
1218  * there is an account (an owner) that can be granted exclusive access to
1219  * specific functions.
1220  *
1221  * By default, the owner account will be the one that deploys the contract. This
1222  * can later be changed with {transferOwnership}.
1223  *
1224  * This module is used through inheritance. It will make available the modifier
1225  * `onlyOwner`, which can be applied to your functions to restrict their use to
1226  * the owner.
1227  */
1228 abstract contract Ownable is Context {
1229     address private _owner;
1230 
1231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1232 
1233     /**
1234      * @dev Initializes the contract setting the deployer as the initial owner.
1235      */
1236     constructor() {
1237         _transferOwnership(_msgSender());
1238     }
1239 
1240     /**
1241      * @dev Returns the address of the current owner.
1242      */
1243     function owner() public view virtual returns (address) {
1244         return _owner;
1245     }
1246 
1247     /**
1248      * @dev Throws if called by any account other than the owner.
1249      */
1250     modifier onlyOwner() {
1251         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1252         _;
1253     }
1254 
1255     /**
1256      * @dev Leaves the contract without owner. It will not be possible to call
1257      * `onlyOwner` functions anymore. Can only be called by the current owner.
1258      *
1259      * NOTE: Renouncing ownership will leave the contract without an owner,
1260      * thereby removing any functionality that is only available to the owner.
1261      */
1262     function renounceOwnership() public virtual onlyOwner {
1263         _transferOwnership(address(0));
1264     }
1265 
1266     /**
1267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1268      * Can only be called by the current owner.
1269      */
1270     function transferOwnership(address newOwner) public virtual onlyOwner {
1271         require(newOwner != address(0), "Ownable: new owner is the zero address");
1272         _transferOwnership(newOwner);
1273     }
1274 
1275     /**
1276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1277      * Internal function without access restriction.
1278      */
1279     function _transferOwnership(address newOwner) internal virtual {
1280         address oldOwner = _owner;
1281         _owner = newOwner;
1282         emit OwnershipTransferred(oldOwner, newOwner);
1283     }
1284 }
1285 
1286 
1287 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.4.0
1288 
1289 
1290 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
1291 
1292 pragma solidity ^0.8.0;
1293 
1294 // CAUTION
1295 // This version of SafeMath should only be used with Solidity 0.8 or later,
1296 // because it relies on the compiler's built in overflow checks.
1297 
1298 /**
1299  * @dev Wrappers over Solidity's arithmetic operations.
1300  *
1301  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1302  * now has built in overflow checking.
1303  */
1304 library SafeMath {
1305     /**
1306      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1307      *
1308      * _Available since v3.4._
1309      */
1310     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1311         unchecked {
1312             uint256 c = a + b;
1313             if (c < a) return (false, 0);
1314             return (true, c);
1315         }
1316     }
1317 
1318     /**
1319      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1320      *
1321      * _Available since v3.4._
1322      */
1323     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1324         unchecked {
1325             if (b > a) return (false, 0);
1326             return (true, a - b);
1327         }
1328     }
1329 
1330     /**
1331      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1332      *
1333      * _Available since v3.4._
1334      */
1335     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1336         unchecked {
1337             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1338             // benefit is lost if 'b' is also tested.
1339             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1340             if (a == 0) return (true, 0);
1341             uint256 c = a * b;
1342             if (c / a != b) return (false, 0);
1343             return (true, c);
1344         }
1345     }
1346 
1347     /**
1348      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1349      *
1350      * _Available since v3.4._
1351      */
1352     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1353         unchecked {
1354             if (b == 0) return (false, 0);
1355             return (true, a / b);
1356         }
1357     }
1358 
1359     /**
1360      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1361      *
1362      * _Available since v3.4._
1363      */
1364     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1365         unchecked {
1366             if (b == 0) return (false, 0);
1367             return (true, a % b);
1368         }
1369     }
1370 
1371     /**
1372      * @dev Returns the addition of two unsigned integers, reverting on
1373      * overflow.
1374      *
1375      * Counterpart to Solidity's `+` operator.
1376      *
1377      * Requirements:
1378      *
1379      * - Addition cannot overflow.
1380      */
1381     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1382         return a + b;
1383     }
1384 
1385     /**
1386      * @dev Returns the subtraction of two unsigned integers, reverting on
1387      * overflow (when the result is negative).
1388      *
1389      * Counterpart to Solidity's `-` operator.
1390      *
1391      * Requirements:
1392      *
1393      * - Subtraction cannot overflow.
1394      */
1395     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1396         return a - b;
1397     }
1398 
1399     /**
1400      * @dev Returns the multiplication of two unsigned integers, reverting on
1401      * overflow.
1402      *
1403      * Counterpart to Solidity's `*` operator.
1404      *
1405      * Requirements:
1406      *
1407      * - Multiplication cannot overflow.
1408      */
1409     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1410         return a * b;
1411     }
1412 
1413     /**
1414      * @dev Returns the integer division of two unsigned integers, reverting on
1415      * division by zero. The result is rounded towards zero.
1416      *
1417      * Counterpart to Solidity's `/` operator.
1418      *
1419      * Requirements:
1420      *
1421      * - The divisor cannot be zero.
1422      */
1423     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1424         return a / b;
1425     }
1426 
1427     /**
1428      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1429      * reverting when dividing by zero.
1430      *
1431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1432      * opcode (which leaves remaining gas untouched) while Solidity uses an
1433      * invalid opcode to revert (consuming all remaining gas).
1434      *
1435      * Requirements:
1436      *
1437      * - The divisor cannot be zero.
1438      */
1439     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1440         return a % b;
1441     }
1442 
1443     /**
1444      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1445      * overflow (when the result is negative).
1446      *
1447      * CAUTION: This function is deprecated because it requires allocating memory for the error
1448      * message unnecessarily. For custom revert reasons use {trySub}.
1449      *
1450      * Counterpart to Solidity's `-` operator.
1451      *
1452      * Requirements:
1453      *
1454      * - Subtraction cannot overflow.
1455      */
1456     function sub(
1457         uint256 a,
1458         uint256 b,
1459         string memory errorMessage
1460     ) internal pure returns (uint256) {
1461         unchecked {
1462             require(b <= a, errorMessage);
1463             return a - b;
1464         }
1465     }
1466 
1467     /**
1468      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1469      * division by zero. The result is rounded towards zero.
1470      *
1471      * Counterpart to Solidity's `/` operator. Note: this function uses a
1472      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1473      * uses an invalid opcode to revert (consuming all remaining gas).
1474      *
1475      * Requirements:
1476      *
1477      * - The divisor cannot be zero.
1478      */
1479     function div(
1480         uint256 a,
1481         uint256 b,
1482         string memory errorMessage
1483     ) internal pure returns (uint256) {
1484         unchecked {
1485             require(b > 0, errorMessage);
1486             return a / b;
1487         }
1488     }
1489 
1490     /**
1491      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1492      * reverting with custom message when dividing by zero.
1493      *
1494      * CAUTION: This function is deprecated because it requires allocating memory for the error
1495      * message unnecessarily. For custom revert reasons use {tryMod}.
1496      *
1497      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1498      * opcode (which leaves remaining gas untouched) while Solidity uses an
1499      * invalid opcode to revert (consuming all remaining gas).
1500      *
1501      * Requirements:
1502      *
1503      * - The divisor cannot be zero.
1504      */
1505     function mod(
1506         uint256 a,
1507         uint256 b,
1508         string memory errorMessage
1509     ) internal pure returns (uint256) {
1510         unchecked {
1511             require(b > 0, errorMessage);
1512             return a % b;
1513         }
1514     }
1515 }
1516 
1517 
1518 // File contracts/DAPEYC.sol
1519 
1520 
1521 
1522 pragma solidity >=0.8.0;
1523 
1524 
1525 
1526 contract DAPEYC is ERC721Enumerable, Ownable {
1527   using Strings for uint256;
1528   using SafeMath for uint;
1529 
1530 
1531   string public baseURI;
1532   string public baseExtension = ".json";
1533   string public notRevealedUri;
1534   uint256 public cost = 0.055 ether;
1535   uint256 public maxSupply = 3333;
1536   uint256 public maxMintAmount = 10;
1537   uint256 public nftPerAddressLimit = 3;
1538   bool public paused = false;
1539   bool public revealed = false;
1540   bool public onlyWhitelisted = true;
1541   address[] public whitelistedAddresses;
1542   mapping(address => uint256) public addressMintedBalance;
1543 
1544 
1545   constructor(
1546     string memory _name,
1547     string memory _symbol,
1548     string memory _initBaseURI,
1549     string memory _initNotRevealedUri
1550   ) ERC721(_name, _symbol) {
1551     setBaseURI(_initBaseURI);
1552     setNotRevealedURI(_initNotRevealedUri);
1553   }
1554 
1555   // internal
1556   function _baseURI() internal view virtual override returns (string memory) {
1557     return baseURI;
1558   }
1559 
1560   // public
1561   function mintDape(uint256 _mintAmount) public payable {
1562     require(!paused, "The contract is paused");
1563     uint256 supply = totalSupply();
1564     require(_mintAmount > 0, "You need to mint at least 1 NFT");
1565     require(_mintAmount <= maxMintAmount, "You've exceeded the max mint amount for this session");
1566     require(supply.add( _mintAmount) <= maxSupply, "Max NFT limit exceeded");
1567 
1568     if (msg.sender != owner()) {
1569         if(onlyWhitelisted == true) {
1570             require(isWhitelisted(msg.sender), "User is not whitelisted");
1571             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1572             require(ownerMintedCount.add(_mintAmount) <= nftPerAddressLimit, "Max NFT per address exceeded");
1573 
1574         }
1575 
1576        
1577        require(msg.value >= cost.mul(_mintAmount), "Insufficient funds");
1578 
1579     }
1580     
1581     for (uint256 i = 1; i <= _mintAmount; i++) {
1582         addressMintedBalance[msg.sender]++;
1583       _safeMint(msg.sender, supply.add(i) );
1584     }
1585   }
1586   
1587   function isWhitelisted(address _user) public view returns (bool) {
1588     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1589       if (whitelistedAddresses[i] == _user) {
1590           return true;
1591       }
1592     }
1593     return false;
1594   }
1595 
1596   function walletOfOwner(address _owner)
1597     public
1598     view
1599     returns (uint256[] memory)
1600   {
1601     uint256 ownerTokenCount = balanceOf(_owner);
1602     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1603     for (uint256 i; i < ownerTokenCount; i++) {
1604       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1605     }
1606     return tokenIds;
1607   }
1608 
1609   function tokenURI(uint256 tokenId)
1610     public
1611     view
1612     virtual
1613     override
1614     returns (string memory)
1615   {
1616     require(
1617       _exists(tokenId),
1618       "ERC721Metadata: URI query for nonexistent token"
1619     );
1620     
1621     if(revealed == false) {
1622         return notRevealedUri;
1623     }
1624 
1625     string memory currentBaseURI = _baseURI();
1626     return bytes(currentBaseURI).length > 0
1627         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1628         : "";
1629   }
1630 
1631   //only owner
1632 
1633 
1634     function giftDape(uint256 _mintAmount, address destination) public onlyOwner {
1635         require(_mintAmount > 0, "Need to mint at least 1 NFT");
1636         uint256 supply = totalSupply();
1637         require(supply.add(_mintAmount) <= maxSupply, "Max NFT limit exceeded");
1638 
1639         for (uint256 i = 1; i <= _mintAmount; i++) {
1640             addressMintedBalance[destination]++;
1641             _safeMint(destination, supply.add(i));
1642         }
1643     }
1644 
1645 
1646   function reveal() public onlyOwner {
1647       revealed = true;
1648   }
1649   
1650   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1651     nftPerAddressLimit = _limit;
1652   }
1653   
1654   function setCost(uint256 _newCost) public onlyOwner {
1655     cost = _newCost;
1656   }
1657 
1658   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1659     maxMintAmount = _newmaxMintAmount;
1660   }
1661 
1662   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1663     baseURI = _newBaseURI;
1664   }
1665 
1666   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1667     baseExtension = _newBaseExtension;
1668   }
1669   
1670   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1671     notRevealedUri = _notRevealedURI;
1672   }
1673 
1674   function pause(bool _state) public onlyOwner {
1675     paused = _state;
1676   }
1677   
1678   function setOnlyWhitelisted(bool _state) public onlyOwner {
1679     onlyWhitelisted = _state;
1680   }
1681   
1682   function whitelistUsers(address[] calldata _users) public onlyOwner {
1683     delete whitelistedAddresses;
1684     whitelistedAddresses = _users;
1685   }
1686  
1687   function withdraw() public payable onlyOwner {
1688 
1689     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1690     require(os);
1691   }
1692 }