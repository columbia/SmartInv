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
33 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
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
175 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
176 
177 
178 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
205 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 
213 /**
214  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
215  * @dev See https://eips.ethereum.org/EIPS/eip-721
216  */
217 interface IERC721Metadata is IERC721 {
218     /**
219      * @dev Returns the token collection name.
220      */
221     function name() external view returns (string memory);
222 
223     /**
224      * @dev Returns the token collection symbol.
225      */
226     function symbol() external view returns (string memory);
227 
228     /**
229      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
230      */
231     function tokenURI(uint256 tokenId) external view returns (string memory);
232 }
233 
234 // File: @openzeppelin/contracts/utils/Address.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies on extcodesize, which returns 0 for contracts in
264         // construction, since the code is only stored at the end of the
265         // constructor execution.
266 
267         uint256 size;
268         assembly {
269             size := extcodesize(account)
270         }
271         return size > 0;
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         (bool success, ) = recipient.call{value: amount}("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain `call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         require(isContract(target), "Address: call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.call{value: value}(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
378         return functionStaticCall(target, data, "Address: low-level static call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal view returns (bytes memory) {
392         require(isContract(target), "Address: static call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.staticcall(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
405         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(isContract(target), "Address: delegate call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.delegatecall(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
427      * revert reason using the provided one.
428      *
429      * _Available since v4.3._
430      */
431     function verifyCallResult(
432         bool success,
433         bytes memory returndata,
434         string memory errorMessage
435     ) internal pure returns (bytes memory) {
436         if (success) {
437             return returndata;
438         } else {
439             // Look for revert reason and bubble it up if present
440             if (returndata.length > 0) {
441                 // The easiest way to bubble the revert reason is using memory via assembly
442 
443                 assembly {
444                     let returndata_size := mload(returndata)
445                     revert(add(32, returndata), returndata_size)
446                 }
447             } else {
448                 revert(errorMessage);
449             }
450         }
451     }
452 }
453 
454 // File: @openzeppelin/contracts/utils/Context.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @dev Provides information about the current execution context, including the
463  * sender of the transaction and its data. While these are generally available
464  * via msg.sender and msg.data, they should not be accessed in such a direct
465  * manner, since when dealing with meta-transactions the account sending and
466  * paying for execution may not be the actual sender (as far as an application
467  * is concerned).
468  *
469  * This contract is only required for intermediate, library-like contracts.
470  */
471 abstract contract Context {
472     function _msgSender() internal view virtual returns (address) {
473         return msg.sender;
474     }
475 
476     function _msgData() internal view virtual returns (bytes calldata) {
477         return msg.data;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/utils/Strings.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 /**
489  * @dev String operations.
490  */
491 library Strings {
492     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
493 
494     /**
495      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
496      */
497     function toString(uint256 value) internal pure returns (string memory) {
498         // Inspired by OraclizeAPI's implementation - MIT licence
499         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
500 
501         if (value == 0) {
502             return "0";
503         }
504         uint256 temp = value;
505         uint256 digits;
506         while (temp != 0) {
507             digits++;
508             temp /= 10;
509         }
510         bytes memory buffer = new bytes(digits);
511         while (value != 0) {
512             digits -= 1;
513             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
514             value /= 10;
515         }
516         return string(buffer);
517     }
518 
519     /**
520      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
521      */
522     function toHexString(uint256 value) internal pure returns (string memory) {
523         if (value == 0) {
524             return "0x00";
525         }
526         uint256 temp = value;
527         uint256 length = 0;
528         while (temp != 0) {
529             length++;
530             temp >>= 8;
531         }
532         return toHexString(value, length);
533     }
534 
535     /**
536      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
537      */
538     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
539         bytes memory buffer = new bytes(2 * length + 2);
540         buffer[0] = "0";
541         buffer[1] = "x";
542         for (uint256 i = 2 * length + 1; i > 1; --i) {
543             buffer[i] = _HEX_SYMBOLS[value & 0xf];
544             value >>= 4;
545         }
546         require(value == 0, "Strings: hex length insufficient");
547         return string(buffer);
548     }
549 }
550 
551 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @dev Implementation of the {IERC165} interface.
561  *
562  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
563  * for the additional interface id that will be supported. For example:
564  *
565  * ```solidity
566  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
567  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
568  * }
569  * ```
570  *
571  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
572  */
573 abstract contract ERC165 is IERC165 {
574     /**
575      * @dev See {IERC165-supportsInterface}.
576      */
577     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
578         return interfaceId == type(IERC165).interfaceId;
579     }
580 }
581 
582 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 
590 
591 
592 
593 
594 
595 
596 /**
597  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
598  * the Metadata extension, but not including the Enumerable extension, which is available separately as
599  * {ERC721Enumerable}.
600  */
601 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
602     using Address for address;
603     using Strings for uint256;
604 
605     // Token name
606     string private _name;
607 
608     // Token symbol
609     string private _symbol;
610 
611     // Mapping from token ID to owner address
612     mapping(uint256 => address) private _owners;
613 
614     // Mapping owner address to token count
615     mapping(address => uint256) private _balances;
616 
617     // Mapping from token ID to approved address
618     mapping(uint256 => address) private _tokenApprovals;
619 
620     // Mapping from owner to operator approvals
621     mapping(address => mapping(address => bool)) private _operatorApprovals;
622 
623     /**
624      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
625      */
626     constructor(string memory name_, string memory symbol_) {
627         _name = name_;
628         _symbol = symbol_;
629     }
630 
631     /**
632      * @dev See {IERC165-supportsInterface}.
633      */
634     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
635         return
636         interfaceId == type(IERC721).interfaceId ||
637         interfaceId == type(IERC721Metadata).interfaceId ||
638         super.supportsInterface(interfaceId);
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
679         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
680     }
681 
682     /**
683      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
684      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
685      * by default, can be overriden in child contracts.
686      */
687     function _baseURI() internal view virtual returns (string memory) {
688         return "";
689     }
690 
691     /**
692      * @dev See {IERC721-approve}.
693      */
694     function approve(address to, uint256 tokenId) public virtual override {
695         address owner = ERC721.ownerOf(tokenId);
696         require(to != owner, "ERC721: approval to current owner");
697 
698         require(
699             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
700             "ERC721: approve caller is not owner nor approved for all"
701         );
702 
703         _approve(to, tokenId);
704     }
705 
706     /**
707      * @dev See {IERC721-getApproved}.
708      */
709     function getApproved(uint256 tokenId) public view virtual override returns (address) {
710         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
711 
712         return _tokenApprovals[tokenId];
713     }
714 
715     /**
716      * @dev See {IERC721-setApprovalForAll}.
717      */
718     function setApprovalForAll(address operator, bool approved) public virtual override {
719         _setApprovalForAll(_msgSender(), operator, approved);
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
940      * @dev Approve `operator` to operate on all of `owner` tokens
941      *
942      * Emits a {ApprovalForAll} event.
943      */
944     function _setApprovalForAll(
945         address owner,
946         address operator,
947         bool approved
948     ) internal virtual {
949         require(owner != operator, "ERC721: approve to caller");
950         _operatorApprovals[owner][operator] = approved;
951         emit ApprovalForAll(owner, operator, approved);
952     }
953 
954     /**
955      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
956      * The call is not executed if the target address is not a contract.
957      *
958      * @param from address representing the previous owner of the given token ID
959      * @param to target address that will receive the tokens
960      * @param tokenId uint256 ID of the token to be transferred
961      * @param _data bytes optional data to send along with the call
962      * @return bool whether the call correctly returned the expected magic value
963      */
964     function _checkOnERC721Received(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) private returns (bool) {
970         if (to.isContract()) {
971             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
972                 return retval == IERC721Receiver.onERC721Received.selector;
973             } catch (bytes memory reason) {
974                 if (reason.length == 0) {
975                     revert("ERC721: transfer to non ERC721Receiver implementer");
976                 } else {
977                     assembly {
978                         revert(add(32, reason), mload(reason))
979                     }
980                 }
981             }
982         } else {
983             return true;
984         }
985     }
986 
987     /**
988      * @dev Hook that is called before any token transfer. This includes minting
989      * and burning.
990      *
991      * Calling conditions:
992      *
993      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
994      * transferred to `to`.
995      * - When `from` is zero, `tokenId` will be minted for `to`.
996      * - When `to` is zero, ``from``'s `tokenId` will be burned.
997      * - `from` and `to` are never both zero.
998      *
999      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1000      */
1001     function _beforeTokenTransfer(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) internal virtual {}
1006 }
1007 
1008 // File: @openzeppelin/contracts/access/Ownable.sol
1009 
1010 
1011 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1012 
1013 pragma solidity ^0.8.0;
1014 
1015 
1016 /**
1017  * @dev Contract module which provides a basic access control mechanism, where
1018  * there is an account (an owner) that can be granted exclusive access to
1019  * specific functions.
1020  *
1021  * By default, the owner account will be the one that deploys the contract. This
1022  * can later be changed with {transferOwnership}.
1023  *
1024  * This module is used through inheritance. It will make available the modifier
1025  * `onlyOwner`, which can be applied to your functions to restrict their use to
1026  * the owner.
1027  */
1028 abstract contract Ownable is Context {
1029     address private _owner;
1030 
1031     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1032 
1033     /**
1034      * @dev Initializes the contract setting the deployer as the initial owner.
1035      */
1036     constructor() {
1037         _transferOwnership(_msgSender());
1038     }
1039 
1040     /**
1041      * @dev Returns the address of the current owner.
1042      */
1043     function owner() public view virtual returns (address) {
1044         return _owner;
1045     }
1046 
1047     /**
1048      * @dev Throws if called by any account other than the owner.
1049      */
1050     modifier onlyOwner() {
1051         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1052         _;
1053     }
1054 
1055     /**
1056      * @dev Leaves the contract without owner. It will not be possible to call
1057      * `onlyOwner` functions anymore. Can only be called by the current owner.
1058      *
1059      * NOTE: Renouncing ownership will leave the contract without an owner,
1060      * thereby removing any functionality that is only available to the owner.
1061      */
1062     function renounceOwnership() public virtual onlyOwner {
1063         _transferOwnership(address(0));
1064     }
1065 
1066     /**
1067      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1068      * Can only be called by the current owner.
1069      */
1070     function transferOwnership(address newOwner) public virtual onlyOwner {
1071         require(newOwner != address(0), "Ownable: new owner is the zero address");
1072         _transferOwnership(newOwner);
1073     }
1074 
1075     /**
1076      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1077      * Internal function without access restriction.
1078      */
1079     function _transferOwnership(address newOwner) internal virtual {
1080         address oldOwner = _owner;
1081         _owner = newOwner;
1082         emit OwnershipTransferred(oldOwner, newOwner);
1083     }
1084 }
1085 
1086 // File: GhozaliOneDay.sol
1087 
1088 
1089 
1090 pragma solidity ^0.8.0;
1091 
1092 
1093 
1094 contract GhozaliOneDay is ERC721, Ownable {
1095 
1096     uint constant public MAX_SUPPLY = 10000;
1097     uint constant public PRICE = 0.01 ether;
1098 
1099     string public baseURI = "https://storage.googleapis.com/ghozali/meta/";
1100     uint public maxMintsPerWallet = 50;
1101     uint public freeMints = 2000;
1102 
1103     uint public totalSupply;
1104     mapping(address => uint) public mintedNFTs;
1105 
1106     constructor() ERC721("Ghozali One Day", "GOD") {
1107         _mint(msg.sender, ++totalSupply);
1108     }
1109 
1110     // Setters region
1111     function setBaseURI(string memory _baseURIArg) external onlyOwner {
1112         baseURI = _baseURIArg;
1113     }
1114 
1115     function setMaxMintsPerWallet(uint _maxMintsPerWallet) external onlyOwner {
1116         maxMintsPerWallet = _maxMintsPerWallet;
1117     }
1118 
1119     function setFreeMints(uint _freeMints) external onlyOwner {
1120         freeMints = _freeMints;
1121     }
1122     // endregion
1123 
1124     function _baseURI() internal view override returns (string memory) {
1125         return baseURI;
1126     }
1127 
1128     // Mint and Claim functions
1129     function mintPrice(uint amount) public view returns (uint) {
1130         uint remainingFreeMints = totalSupply < freeMints ? freeMints - totalSupply : 0;
1131         if (remainingFreeMints >= amount) {
1132             return 0;
1133         } else {
1134             return (amount - remainingFreeMints) * PRICE;
1135         }
1136     }
1137 
1138     function mint(uint amount) external payable {
1139         require(amount > 0 && amount <= 10, "Wrong amount");
1140         require(totalSupply + amount <= MAX_SUPPLY, "Tokens supply reached limit");
1141         require(mintedNFTs[msg.sender] + amount <= maxMintsPerWallet, "maxMintsPerWallet constraint violation");
1142         require(mintPrice(amount) == msg.value, "Wrong ethers value");
1143         mintedNFTs[msg.sender] += amount;
1144 
1145         uint fromToken = totalSupply + 1;
1146         totalSupply += amount;
1147         for (uint i = 0; i < amount; i++) {
1148             _mint(msg.sender, fromToken + i);
1149         }
1150     }
1151 
1152     receive() external payable {
1153 
1154     }
1155 
1156     function withdraw() external onlyOwner {
1157         uint balance = address(this).balance;
1158         // Ghozali contract
1159         payable(0xc1E05E98466908547F30fcFc34E405B9C84DFCb7).transfer(balance * 15 / 100);
1160         payable(0x39f527e945ac1c2f74dC5d049e1f67848652e7e7).transfer(balance / 10);
1161         payable(0x0d1c527539a8ADa2C490241DC2E47a9351E8b5EA).transfer(balance / 10);
1162         payable(0x612DBBe0f90373ec00cabaEED679122AF9C559BE).transfer(balance / 20);
1163         payable(0x216F2Cf67561ED5e9A2F31482158BFc4996037AE).transfer(balance * 60 / 100);
1164     }
1165 
1166 }