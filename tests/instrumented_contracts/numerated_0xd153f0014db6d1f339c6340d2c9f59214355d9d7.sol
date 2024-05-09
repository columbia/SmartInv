1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.6.4 https://hardhat.org
3 
4 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
5 
6 
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
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
33 
34 
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
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
177 
178 
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC721 token receiver interface
184  * @dev Interface for any contract that wants to support safeTransfers
185  * from ERC721 asset contracts.
186  */
187 interface IERC721Receiver {
188     /**
189      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
190      * by `operator` from `from`, this function is called.
191      *
192      * It must return its Solidity selector to confirm the token transfer.
193      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
194      *
195      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
196      */
197     function onERC721Received(
198         address operator,
199         address from,
200         uint256 tokenId,
201         bytes calldata data
202     ) external returns (bytes4);
203 }
204 
205 
206 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
207 
208 
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Metadata is IERC721 {
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 
234 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
235 
236 
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
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
453 
454 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
455 
456 
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
480 
481 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
482 
483 
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
550 
551 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
552 
553 
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
580 
581 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
582 
583 
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
716         require(operator != _msgSender(), "ERC721: approve to caller");
717 
718         _operatorApprovals[_msgSender()][operator] = approved;
719         emit ApprovalForAll(_msgSender(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         //solhint-disable-next-line max-line-length
738         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
739 
740         _transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         safeTransferFrom(from, to, tokenId, "");
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) public virtual override {
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
764         _safeTransfer(from, to, tokenId, _data);
765     }
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
772      *
773      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
774      * implement alternative mechanisms to perform token transfer, such as signature-based.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must exist and be owned by `from`.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeTransfer(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) internal virtual {
791         _transfer(from, to, tokenId);
792         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
793     }
794 
795     /**
796      * @dev Returns whether `tokenId` exists.
797      *
798      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
799      *
800      * Tokens start existing when they are minted (`_mint`),
801      * and stop existing when they are burned (`_burn`).
802      */
803     function _exists(uint256 tokenId) internal view virtual returns (bool) {
804         return _owners[tokenId] != address(0);
805     }
806 
807     /**
808      * @dev Returns whether `spender` is allowed to manage `tokenId`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
815         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
816         address owner = ERC721.ownerOf(tokenId);
817         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
818     }
819 
820     /**
821      * @dev Safely mints `tokenId` and transfers it to `to`.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must not exist.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeMint(address to, uint256 tokenId) internal virtual {
831         _safeMint(to, tokenId, "");
832     }
833 
834     /**
835      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
836      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
837      */
838     function _safeMint(
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) internal virtual {
843         _mint(to, tokenId);
844         require(
845             _checkOnERC721Received(address(0), to, tokenId, _data),
846             "ERC721: transfer to non ERC721Receiver implementer"
847         );
848     }
849 
850     /**
851      * @dev Mints `tokenId` and transfers it to `to`.
852      *
853      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
854      *
855      * Requirements:
856      *
857      * - `tokenId` must not exist.
858      * - `to` cannot be the zero address.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _mint(address to, uint256 tokenId) internal virtual {
863         require(to != address(0), "ERC721: mint to the zero address");
864         require(!_exists(tokenId), "ERC721: token already minted");
865 
866         _beforeTokenTransfer(address(0), to, tokenId);
867 
868         _balances[to] += 1;
869         _owners[tokenId] = to;
870 
871         emit Transfer(address(0), to, tokenId);
872     }
873 
874     /**
875      * @dev Destroys `tokenId`.
876      * The approval is cleared when the token is burned.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _burn(uint256 tokenId) internal virtual {
885         address owner = ERC721.ownerOf(tokenId);
886 
887         _beforeTokenTransfer(owner, address(0), tokenId);
888 
889         // Clear approvals
890         _approve(address(0), tokenId);
891 
892         _balances[owner] -= 1;
893         delete _owners[tokenId];
894 
895         emit Transfer(owner, address(0), tokenId);
896     }
897 
898     /**
899      * @dev Transfers `tokenId` from `from` to `to`.
900      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must be owned by `from`.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _transfer(
910         address from,
911         address to,
912         uint256 tokenId
913     ) internal virtual {
914         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
915         require(to != address(0), "ERC721: transfer to the zero address");
916 
917         _beforeTokenTransfer(from, to, tokenId);
918 
919         // Clear approvals from the previous owner
920         _approve(address(0), tokenId);
921 
922         _balances[from] -= 1;
923         _balances[to] += 1;
924         _owners[tokenId] = to;
925 
926         emit Transfer(from, to, tokenId);
927     }
928 
929     /**
930      * @dev Approve `to` to operate on `tokenId`
931      *
932      * Emits a {Approval} event.
933      */
934     function _approve(address to, uint256 tokenId) internal virtual {
935         _tokenApprovals[tokenId] = to;
936         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
937     }
938 
939     /**
940      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
941      * The call is not executed if the target address is not a contract.
942      *
943      * @param from address representing the previous owner of the given token ID
944      * @param to target address that will receive the tokens
945      * @param tokenId uint256 ID of the token to be transferred
946      * @param _data bytes optional data to send along with the call
947      * @return bool whether the call correctly returned the expected magic value
948      */
949     function _checkOnERC721Received(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) private returns (bool) {
955         if (to.isContract()) {
956             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
957                 return retval == IERC721Receiver.onERC721Received.selector;
958             } catch (bytes memory reason) {
959                 if (reason.length == 0) {
960                     revert("ERC721: transfer to non ERC721Receiver implementer");
961                 } else {
962                     assembly {
963                         revert(add(32, reason), mload(reason))
964                     }
965                 }
966             }
967         } else {
968             return true;
969         }
970     }
971 
972     /**
973      * @dev Hook that is called before any token transfer. This includes minting
974      * and burning.
975      *
976      * Calling conditions:
977      *
978      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
979      * transferred to `to`.
980      * - When `from` is zero, `tokenId` will be minted for `to`.
981      * - When `to` is zero, ``from``'s `tokenId` will be burned.
982      * - `from` and `to` are never both zero.
983      *
984      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
985      */
986     function _beforeTokenTransfer(
987         address from,
988         address to,
989         uint256 tokenId
990     ) internal virtual {}
991 }
992 
993 
994 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
995 
996 
997 
998 pragma solidity ^0.8.0;
999 
1000 /**
1001  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1002  * @dev See https://eips.ethereum.org/EIPS/eip-721
1003  */
1004 interface IERC721Enumerable is IERC721 {
1005     /**
1006      * @dev Returns the total amount of tokens stored by the contract.
1007      */
1008     function totalSupply() external view returns (uint256);
1009 
1010     /**
1011      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1012      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1013      */
1014     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1015 
1016     /**
1017      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1018      * Use along with {totalSupply} to enumerate all tokens.
1019      */
1020     function tokenByIndex(uint256 index) external view returns (uint256);
1021 }
1022 
1023 
1024 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1025 
1026 
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 
1031 /**
1032  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1033  * enumerability of all the token ids in the contract as well as all token ids owned by each
1034  * account.
1035  */
1036 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1037     // Mapping from owner to list of owned token IDs
1038     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1039 
1040     // Mapping from token ID to index of the owner tokens list
1041     mapping(uint256 => uint256) private _ownedTokensIndex;
1042 
1043     // Array with all token ids, used for enumeration
1044     uint256[] private _allTokens;
1045 
1046     // Mapping from token id to position in the allTokens array
1047     mapping(uint256 => uint256) private _allTokensIndex;
1048 
1049     /**
1050      * @dev See {IERC165-supportsInterface}.
1051      */
1052     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1053         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1058      */
1059     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1060         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1061         return _ownedTokens[owner][index];
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Enumerable-totalSupply}.
1066      */
1067     function totalSupply() public view virtual override returns (uint256) {
1068         return _allTokens.length;
1069     }
1070 
1071     /**
1072      * @dev See {IERC721Enumerable-tokenByIndex}.
1073      */
1074     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1075         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1076         return _allTokens[index];
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any token transfer. This includes minting
1081      * and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1089      * - `from` cannot be the zero address.
1090      * - `to` cannot be the zero address.
1091      *
1092      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1093      */
1094     function _beforeTokenTransfer(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) internal virtual override {
1099         super._beforeTokenTransfer(from, to, tokenId);
1100 
1101         if (from == address(0)) {
1102             _addTokenToAllTokensEnumeration(tokenId);
1103         } else if (from != to) {
1104             _removeTokenFromOwnerEnumeration(from, tokenId);
1105         }
1106         if (to == address(0)) {
1107             _removeTokenFromAllTokensEnumeration(tokenId);
1108         } else if (to != from) {
1109             _addTokenToOwnerEnumeration(to, tokenId);
1110         }
1111     }
1112 
1113     /**
1114      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1115      * @param to address representing the new owner of the given token ID
1116      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1117      */
1118     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1119         uint256 length = ERC721.balanceOf(to);
1120         _ownedTokens[to][length] = tokenId;
1121         _ownedTokensIndex[tokenId] = length;
1122     }
1123 
1124     /**
1125      * @dev Private function to add a token to this extension's token tracking data structures.
1126      * @param tokenId uint256 ID of the token to be added to the tokens list
1127      */
1128     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1129         _allTokensIndex[tokenId] = _allTokens.length;
1130         _allTokens.push(tokenId);
1131     }
1132 
1133     /**
1134      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1135      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1136      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1137      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1138      * @param from address representing the previous owner of the given token ID
1139      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1140      */
1141     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1142         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1143         // then delete the last slot (swap and pop).
1144 
1145         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1146         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1147 
1148         // When the token to delete is the last token, the swap operation is unnecessary
1149         if (tokenIndex != lastTokenIndex) {
1150             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1151 
1152             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1153             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1154         }
1155 
1156         // This also deletes the contents at the last position of the array
1157         delete _ownedTokensIndex[tokenId];
1158         delete _ownedTokens[from][lastTokenIndex];
1159     }
1160 
1161     /**
1162      * @dev Private function to remove a token from this extension's token tracking data structures.
1163      * This has O(1) time complexity, but alters the order of the _allTokens array.
1164      * @param tokenId uint256 ID of the token to be removed from the tokens list
1165      */
1166     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1167         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1168         // then delete the last slot (swap and pop).
1169 
1170         uint256 lastTokenIndex = _allTokens.length - 1;
1171         uint256 tokenIndex = _allTokensIndex[tokenId];
1172 
1173         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1174         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1175         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1176         uint256 lastTokenId = _allTokens[lastTokenIndex];
1177 
1178         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1179         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1180 
1181         // This also deletes the contents at the last position of the array
1182         delete _allTokensIndex[tokenId];
1183         _allTokens.pop();
1184     }
1185 }
1186 
1187 
1188 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1189 
1190 
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 /**
1195  * @dev Contract module which provides a basic access control mechanism, where
1196  * there is an account (an owner) that can be granted exclusive access to
1197  * specific functions.
1198  *
1199  * By default, the owner account will be the one that deploys the contract. This
1200  * can later be changed with {transferOwnership}.
1201  *
1202  * This module is used through inheritance. It will make available the modifier
1203  * `onlyOwner`, which can be applied to your functions to restrict their use to
1204  * the owner.
1205  */
1206 abstract contract Ownable is Context {
1207     address private _owner;
1208 
1209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1210 
1211     /**
1212      * @dev Initializes the contract setting the deployer as the initial owner.
1213      */
1214     constructor() {
1215         _setOwner(_msgSender());
1216     }
1217 
1218     /**
1219      * @dev Returns the address of the current owner.
1220      */
1221     function owner() public view virtual returns (address) {
1222         return _owner;
1223     }
1224 
1225     /**
1226      * @dev Throws if called by any account other than the owner.
1227      */
1228     modifier onlyOwner() {
1229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1230         _;
1231     }
1232 
1233     /**
1234      * @dev Leaves the contract without owner. It will not be possible to call
1235      * `onlyOwner` functions anymore. Can only be called by the current owner.
1236      *
1237      * NOTE: Renouncing ownership will leave the contract without an owner,
1238      * thereby removing any functionality that is only available to the owner.
1239      */
1240     function renounceOwnership() public virtual onlyOwner {
1241         _setOwner(address(0));
1242     }
1243 
1244     /**
1245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1246      * Can only be called by the current owner.
1247      */
1248     function transferOwnership(address newOwner) public virtual onlyOwner {
1249         require(newOwner != address(0), "Ownable: new owner is the zero address");
1250         _setOwner(newOwner);
1251     }
1252 
1253     function _setOwner(address newOwner) private {
1254         address oldOwner = _owner;
1255         _owner = newOwner;
1256         emit OwnershipTransferred(oldOwner, newOwner);
1257     }
1258 }
1259 
1260 
1261 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
1262 
1263 
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 /**
1268  * @dev Contract module that helps prevent reentrant calls to a function.
1269  *
1270  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1271  * available, which can be applied to functions to make sure there are no nested
1272  * (reentrant) calls to them.
1273  *
1274  * Note that because there is a single `nonReentrant` guard, functions marked as
1275  * `nonReentrant` may not call one another. This can be worked around by making
1276  * those functions `private`, and then adding `external` `nonReentrant` entry
1277  * points to them.
1278  *
1279  * TIP: If you would like to learn more about reentrancy and alternative ways
1280  * to protect against it, check out our blog post
1281  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1282  */
1283 abstract contract ReentrancyGuard {
1284     // Booleans are more expensive than uint256 or any type that takes up a full
1285     // word because each write operation emits an extra SLOAD to first read the
1286     // slot's contents, replace the bits taken up by the boolean, and then write
1287     // back. This is the compiler's defense against contract upgrades and
1288     // pointer aliasing, and it cannot be disabled.
1289 
1290     // The values being non-zero value makes deployment a bit more expensive,
1291     // but in exchange the refund on every call to nonReentrant will be lower in
1292     // amount. Since refunds are capped to a percentage of the total
1293     // transaction's gas, it is best to keep them low in cases like this one, to
1294     // increase the likelihood of the full refund coming into effect.
1295     uint256 private constant _NOT_ENTERED = 1;
1296     uint256 private constant _ENTERED = 2;
1297 
1298     uint256 private _status;
1299 
1300     constructor() {
1301         _status = _NOT_ENTERED;
1302     }
1303 
1304     /**
1305      * @dev Prevents a contract from calling itself, directly or indirectly.
1306      * Calling a `nonReentrant` function from another `nonReentrant`
1307      * function is not supported. It is possible to prevent this from happening
1308      * by making the `nonReentrant` function external, and make it call a
1309      * `private` function that does the actual work.
1310      */
1311     modifier nonReentrant() {
1312         // On the first call to nonReentrant, _notEntered will be true
1313         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1314 
1315         // Any calls to nonReentrant after this point will fail
1316         _status = _ENTERED;
1317 
1318         _;
1319 
1320         // By storing the original value once again, a refund is triggered (see
1321         // https://eips.ethereum.org/EIPS/eip-2200)
1322         _status = _NOT_ENTERED;
1323     }
1324 }
1325 
1326 
1327 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.2
1328 
1329 
1330 
1331 pragma solidity ^0.8.0;
1332 
1333 // CAUTION
1334 // This version of SafeMath should only be used with Solidity 0.8 or later,
1335 // because it relies on the compiler's built in overflow checks.
1336 
1337 /**
1338  * @dev Wrappers over Solidity's arithmetic operations.
1339  *
1340  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1341  * now has built in overflow checking.
1342  */
1343 library SafeMath {
1344     /**
1345      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1346      *
1347      * _Available since v3.4._
1348      */
1349     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1350         unchecked {
1351             uint256 c = a + b;
1352             if (c < a) return (false, 0);
1353             return (true, c);
1354         }
1355     }
1356 
1357     /**
1358      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1359      *
1360      * _Available since v3.4._
1361      */
1362     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1363         unchecked {
1364             if (b > a) return (false, 0);
1365             return (true, a - b);
1366         }
1367     }
1368 
1369     /**
1370      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1371      *
1372      * _Available since v3.4._
1373      */
1374     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1375         unchecked {
1376             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1377             // benefit is lost if 'b' is also tested.
1378             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1379             if (a == 0) return (true, 0);
1380             uint256 c = a * b;
1381             if (c / a != b) return (false, 0);
1382             return (true, c);
1383         }
1384     }
1385 
1386     /**
1387      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1388      *
1389      * _Available since v3.4._
1390      */
1391     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1392         unchecked {
1393             if (b == 0) return (false, 0);
1394             return (true, a / b);
1395         }
1396     }
1397 
1398     /**
1399      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1400      *
1401      * _Available since v3.4._
1402      */
1403     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1404         unchecked {
1405             if (b == 0) return (false, 0);
1406             return (true, a % b);
1407         }
1408     }
1409 
1410     /**
1411      * @dev Returns the addition of two unsigned integers, reverting on
1412      * overflow.
1413      *
1414      * Counterpart to Solidity's `+` operator.
1415      *
1416      * Requirements:
1417      *
1418      * - Addition cannot overflow.
1419      */
1420     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1421         return a + b;
1422     }
1423 
1424     /**
1425      * @dev Returns the subtraction of two unsigned integers, reverting on
1426      * overflow (when the result is negative).
1427      *
1428      * Counterpart to Solidity's `-` operator.
1429      *
1430      * Requirements:
1431      *
1432      * - Subtraction cannot overflow.
1433      */
1434     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1435         return a - b;
1436     }
1437 
1438     /**
1439      * @dev Returns the multiplication of two unsigned integers, reverting on
1440      * overflow.
1441      *
1442      * Counterpart to Solidity's `*` operator.
1443      *
1444      * Requirements:
1445      *
1446      * - Multiplication cannot overflow.
1447      */
1448     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1449         return a * b;
1450     }
1451 
1452     /**
1453      * @dev Returns the integer division of two unsigned integers, reverting on
1454      * division by zero. The result is rounded towards zero.
1455      *
1456      * Counterpart to Solidity's `/` operator.
1457      *
1458      * Requirements:
1459      *
1460      * - The divisor cannot be zero.
1461      */
1462     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1463         return a / b;
1464     }
1465 
1466     /**
1467      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1468      * reverting when dividing by zero.
1469      *
1470      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1471      * opcode (which leaves remaining gas untouched) while Solidity uses an
1472      * invalid opcode to revert (consuming all remaining gas).
1473      *
1474      * Requirements:
1475      *
1476      * - The divisor cannot be zero.
1477      */
1478     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1479         return a % b;
1480     }
1481 
1482     /**
1483      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1484      * overflow (when the result is negative).
1485      *
1486      * CAUTION: This function is deprecated because it requires allocating memory for the error
1487      * message unnecessarily. For custom revert reasons use {trySub}.
1488      *
1489      * Counterpart to Solidity's `-` operator.
1490      *
1491      * Requirements:
1492      *
1493      * - Subtraction cannot overflow.
1494      */
1495     function sub(
1496         uint256 a,
1497         uint256 b,
1498         string memory errorMessage
1499     ) internal pure returns (uint256) {
1500         unchecked {
1501             require(b <= a, errorMessage);
1502             return a - b;
1503         }
1504     }
1505 
1506     /**
1507      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1508      * division by zero. The result is rounded towards zero.
1509      *
1510      * Counterpart to Solidity's `/` operator. Note: this function uses a
1511      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1512      * uses an invalid opcode to revert (consuming all remaining gas).
1513      *
1514      * Requirements:
1515      *
1516      * - The divisor cannot be zero.
1517      */
1518     function div(
1519         uint256 a,
1520         uint256 b,
1521         string memory errorMessage
1522     ) internal pure returns (uint256) {
1523         unchecked {
1524             require(b > 0, errorMessage);
1525             return a / b;
1526         }
1527     }
1528 
1529     /**
1530      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1531      * reverting with custom message when dividing by zero.
1532      *
1533      * CAUTION: This function is deprecated because it requires allocating memory for the error
1534      * message unnecessarily. For custom revert reasons use {tryMod}.
1535      *
1536      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1537      * opcode (which leaves remaining gas untouched) while Solidity uses an
1538      * invalid opcode to revert (consuming all remaining gas).
1539      *
1540      * Requirements:
1541      *
1542      * - The divisor cannot be zero.
1543      */
1544     function mod(
1545         uint256 a,
1546         uint256 b,
1547         string memory errorMessage
1548     ) internal pure returns (uint256) {
1549         unchecked {
1550             require(b > 0, errorMessage);
1551             return a % b;
1552         }
1553     }
1554 }
1555 
1556 
1557 // File contracts/Crypto Hobos.sol
1558 
1559 
1560 pragma solidity ^0.8.7;
1561 
1562 
1563 
1564 
1565 
1566 
1567 contract CryptoHobos is ERC721, ERC721Enumerable, Ownable, ReentrancyGuard {
1568     using SafeMath for uint256;
1569     using Strings for string;
1570 
1571     string private _baseUriString;
1572     bool public hasStarted = false;
1573     uint256 public maxTokens = 8000;
1574     uint256 public lastTokenId;
1575     uint256 public reservedTokensLeft = 100;
1576     uint256 public currentTokenPrice = 49000000000000000; //0.049E
1577     uint256 public constant MAX_MINTING_TOKENS_ON_TRANSACTION = 25;
1578 
1579     constructor(string memory baseUriString) ERC721("Crypto Hobos", "CryptoHobos") {
1580         setBaseUri(baseUriString);
1581     }
1582 
1583     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1584         return super.supportsInterface(interfaceId);
1585     }
1586 
1587     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1588     internal
1589     override(ERC721, ERC721Enumerable)
1590     {
1591         super._beforeTokenTransfer(from, to, tokenId);
1592     }
1593 
1594     function setBaseUri(string memory baseUriString) public onlyOwner {
1595         _baseUriString = baseUriString;
1596     }
1597 
1598     function _baseURI() internal view override returns (string memory) {
1599         return _baseUriString;
1600     }
1601 
1602     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1603         string memory _tokenURI = super.tokenURI(tokenId);
1604         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1605     }
1606 
1607     function _mintHobos(address to, uint256 count) private {
1608         uint256 _lastTokenId = lastTokenId;
1609         for (uint256 i = 0; i < count; i++) {
1610             _lastTokenId++;
1611             _safeMint(to, _lastTokenId);
1612         }
1613         lastTokenId = _lastTokenId;
1614     }
1615 
1616     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1617         uint256 tokenCount = balanceOf(_owner);
1618         if (tokenCount == 0) {
1619             // Return an empty array
1620             return new uint256[](0);
1621         } else {
1622             uint256[] memory result = new uint256[](tokenCount);
1623             uint256 index;
1624             for (index = 0; index < tokenCount; index++) {
1625                 result[index] = tokenOfOwnerByIndex(_owner, index);
1626             }
1627             return result;
1628         }
1629     }
1630 
1631     function mintReservedHoboTo(address to, uint256 count) public onlyOwner {
1632         if (to == address(0)) {
1633             to = msg.sender;
1634         }
1635         require(count > 0
1636             && count <= reservedTokensLeft
1637         );
1638         _mintHobos(to, count);
1639         reservedTokensLeft -= count;
1640     }
1641 
1642 
1643 
1644     function mintHobo(uint256 count) external payable nonReentrant {
1645         require(hasStarted == true
1646         && count > 0
1647         && count <= MAX_MINTING_TOKENS_ON_TRANSACTION
1648         && totalSupply().add(count) <= maxTokens.sub(reservedTokensLeft)
1649             && msg.value >= currentTokenPrice.mul(count),
1650             "Mint is impossible now");
1651         _mintHobos(msg.sender, count);
1652     }
1653     function pause() public onlyOwner {
1654         require(hasStarted == true);
1655         hasStarted = false;
1656     }
1657 
1658     function play() public onlyOwner {
1659         require(hasStarted == false);
1660         hasStarted = true;
1661     }
1662 
1663     function withdrawTo(address to, uint256 amount) public payable onlyOwner {
1664         if (to == address(0)) {
1665             to = msg.sender;
1666         }
1667         if (amount == 0) {
1668             amount = address(this).balance;
1669         }
1670         require(payable(to).send(amount));
1671     }
1672 
1673     function withdraw(uint256 amount) public payable onlyOwner {
1674         if (amount == 0) {
1675             amount = address(this).balance;
1676         }
1677         require(payable(owner()).send(amount));
1678     }
1679 
1680 
1681     function setPrice(uint256 price) public onlyOwner {
1682         currentTokenPrice = price;
1683     }
1684 
1685     function reduceSupply(uint256 supply) public onlyOwner {
1686         require(supply < maxTokens && supply > lastTokenId.add(reservedTokensLeft));
1687         maxTokens = supply;
1688     }
1689 }