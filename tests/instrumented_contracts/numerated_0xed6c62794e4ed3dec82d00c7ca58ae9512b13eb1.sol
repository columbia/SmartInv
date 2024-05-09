1 /******************************
2  $$$$$$\             $$$$$$\
3 $$  __$$\    $$\    $$  __$$\
4 \__/  $$ |   $$ |   \__/  $$ |
5  $$$$$$  |$$$$$$$$\  $$$$$$  |
6 $$  ____/ \__$$  __|$$  ____/
7 $$ |         $$ |   $$ |
8 $$$$$$$$\    \__|   $$$$$$$$\
9 \________|          \________|
10 ******************************/
11 
12 // Powered by NFT Artisans (nftartisans.io) - support@nftartisans.io
13 // Sources flattened with hardhat v2.6.4 https://hardhat.org
14 // SPDX-License-Identifier: MIT
15 
16 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Interface of the ERC165 standard, as defined in the
22  * https://eips.ethereum.org/EIPS/eip-165[EIP].
23  *
24  * Implementers can declare support of contract interfaces, which can then be
25  * queried by others ({ERC165Checker}).
26  *
27  * For an implementation, see {ERC165}.
28  */
29 interface IERC165 {
30     /**
31      * @dev Returns true if this contract implements the interface defined by
32      * `interfaceId`. See the corresponding
33      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
34      * to learn more about how these ids are created.
35      *
36      * This function call must use less than 30 000 gas.
37      */
38     function supportsInterface(bytes4 interfaceId) external view returns (bool);
39 }
40 
41 
42 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
43 
44 
45 pragma solidity ^0.8.0;
46 
47 /**
48  * @dev Required interface of an ERC721 compliant contract.
49  */
50 interface IERC721 is IERC165 {
51     /**
52      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
53      */
54     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
55 
56     /**
57      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
58      */
59     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
60 
61     /**
62      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
63      */
64     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
65 
66     /**
67      * @dev Returns the number of tokens in ``owner``'s account.
68      */
69     function balanceOf(address owner) external view returns (uint256 balance);
70 
71     /**
72      * @dev Returns the owner of the `tokenId` token.
73      *
74      * Requirements:
75      *
76      * - `tokenId` must exist.
77      */
78     function ownerOf(uint256 tokenId) external view returns (address owner);
79 
80     /**
81      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
82      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must exist and be owned by `from`.
89      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
90      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
91      *
92      * Emits a {Transfer} event.
93      */
94     function safeTransferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Transfers `tokenId` token from `from` to `to`.
102      *
103      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must be owned by `from`.
110      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(
115         address from,
116         address to,
117         uint256 tokenId
118     ) external;
119 
120     /**
121      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
122      * The approval is cleared when the token is transferred.
123      *
124      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
125      *
126      * Requirements:
127      *
128      * - The caller must own the token or be an approved operator.
129      * - `tokenId` must exist.
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address to, uint256 tokenId) external;
134 
135     /**
136      * @dev Returns the account approved for `tokenId` token.
137      *
138      * Requirements:
139      *
140      * - `tokenId` must exist.
141      */
142     function getApproved(uint256 tokenId) external view returns (address operator);
143 
144     /**
145      * @dev Approve or remove `operator` as an operator for the caller.
146      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
147      *
148      * Requirements:
149      *
150      * - The `operator` cannot be the caller.
151      *
152      * Emits an {ApprovalForAll} event.
153      */
154     function setApprovalForAll(address operator, bool _approved) external;
155 
156     /**
157      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
158      *
159      * See {setApprovalForAll}
160      */
161     function isApprovedForAll(address owner, address operator) external view returns (bool);
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId,
180         bytes calldata data
181     ) external;
182 }
183 
184 
185 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
186 
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @title ERC721 token receiver interface
192  * @dev Interface for any contract that wants to support safeTransfers
193  * from ERC721 asset contracts.
194  */
195 interface IERC721Receiver {
196     /**
197      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
198      * by `operator` from `from`, this function is called.
199      *
200      * It must return its Solidity selector to confirm the token transfer.
201      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
202      *
203      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
204      */
205     function onERC721Received(
206         address operator,
207         address from,
208         uint256 tokenId,
209         bytes calldata data
210     ) external returns (bytes4);
211 }
212 
213 
214 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
215 
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
221  * @dev See https://eips.ethereum.org/EIPS/eip-721
222  */
223 interface IERC721Metadata is IERC721 {
224     /**
225      * @dev Returns the token collection name.
226      */
227     function name() external view returns (string memory);
228 
229     /**
230      * @dev Returns the token collection symbol.
231      */
232     function symbol() external view returns (string memory);
233 
234     /**
235      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
236      */
237     function tokenURI(uint256 tokenId) external view returns (string memory);
238 }
239 
240 
241 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
242 
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies on extcodesize, which returns 0 for contracts in
269         // construction, since the code is only stored at the end of the
270         // constructor execution.
271 
272         uint256 size;
273         assembly {
274             size := extcodesize(account)
275         }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain `call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.call{value: value}(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
383         return functionStaticCall(target, data, "Address: low-level static call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal view returns (bytes memory) {
397         require(isContract(target), "Address: static call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.staticcall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(isContract(target), "Address: delegate call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.delegatecall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
432      * revert reason using the provided one.
433      *
434      * _Available since v4.3._
435      */
436     function verifyCallResult(
437         bool success,
438         bytes memory returndata,
439         string memory errorMessage
440     ) internal pure returns (bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 
460 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
461 
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Provides information about the current execution context, including the
467  * sender of the transaction and its data. While these are generally available
468  * via msg.sender and msg.data, they should not be accessed in such a direct
469  * manner, since when dealing with meta-transactions the account sending and
470  * paying for execution may not be the actual sender (as far as an application
471  * is concerned).
472  *
473  * This contract is only required for intermediate, library-like contracts.
474  */
475 abstract contract Context {
476     function _msgSender() internal view virtual returns (address) {
477         return msg.sender;
478     }
479 
480     function _msgData() internal view virtual returns (bytes calldata) {
481         return msg.data;
482     }
483 }
484 
485 
486 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
487 
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @dev String operations.
493  */
494 library Strings {
495     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
496 
497     /**
498      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
499      */
500     function toString(uint256 value) internal pure returns (string memory) {
501         // Inspired by OraclizeAPI's implementation - MIT licence
502         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
503 
504         if (value == 0) {
505             return "0";
506         }
507         uint256 temp = value;
508         uint256 digits;
509         while (temp != 0) {
510             digits++;
511             temp /= 10;
512         }
513         bytes memory buffer = new bytes(digits);
514         while (value != 0) {
515             digits -= 1;
516             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
517             value /= 10;
518         }
519         return string(buffer);
520     }
521 
522     /**
523      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
524      */
525     function toHexString(uint256 value) internal pure returns (string memory) {
526         if (value == 0) {
527             return "0x00";
528         }
529         uint256 temp = value;
530         uint256 length = 0;
531         while (temp != 0) {
532             length++;
533             temp >>= 8;
534         }
535         return toHexString(value, length);
536     }
537 
538     /**
539      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
540      */
541     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
542         bytes memory buffer = new bytes(2 * length + 2);
543         buffer[0] = "0";
544         buffer[1] = "x";
545         for (uint256 i = 2 * length + 1; i > 1; --i) {
546             buffer[i] = _HEX_SYMBOLS[value & 0xf];
547             value >>= 4;
548         }
549         require(value == 0, "Strings: hex length insufficient");
550         return string(buffer);
551     }
552 }
553 
554 
555 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
556 
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Implementation of the {IERC165} interface.
562  *
563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
564  * for the additional interface id that will be supported. For example:
565  *
566  * ```solidity
567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
569  * }
570  * ```
571  *
572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
573  */
574 abstract contract ERC165 is IERC165 {
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
579         return interfaceId == type(IERC165).interfaceId;
580     }
581 }
582 
583 
584 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
585 
586 
587 pragma solidity ^0.8.0;
588 
589 
590 
591 
592 
593 
594 
595 /**
596  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
597  * the Metadata extension, but not including the Enumerable extension, which is available separately as
598  * {ERC721Enumerable}.
599  */
600 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
601     using Address for address;
602     using Strings for uint256;
603 
604     // Token name
605     string private _name;
606 
607     // Token symbol
608     string private _symbol;
609 
610     // Mapping from token ID to owner address
611     mapping(uint256 => address) private _owners;
612 
613     // Mapping owner address to token count
614     mapping(address => uint256) private _balances;
615 
616     // Mapping from token ID to approved address
617     mapping(uint256 => address) private _tokenApprovals;
618 
619     // Mapping from owner to operator approvals
620     mapping(address => mapping(address => bool)) private _operatorApprovals;
621 
622     /**
623      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
624      */
625     constructor(string memory name_, string memory symbol_) {
626         _name = name_;
627         _symbol = symbol_;
628     }
629 
630     /**
631      * @dev See {IERC165-supportsInterface}.
632      */
633     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
634         return
635             interfaceId == type(IERC721).interfaceId ||
636             interfaceId == type(IERC721Metadata).interfaceId ||
637             super.supportsInterface(interfaceId);
638     }
639 
640     /**
641      * @dev See {IERC721-balanceOf}.
642      */
643     function balanceOf(address owner) public view virtual override returns (uint256) {
644         require(owner != address(0), "ERC721: balance query for the zero address");
645         return _balances[owner];
646     }
647 
648     /**
649      * @dev See {IERC721-ownerOf}.
650      */
651     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
652         address owner = _owners[tokenId];
653         require(owner != address(0), "ERC721: owner query for nonexistent token");
654         return owner;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-name}.
659      */
660     function name() public view virtual override returns (string memory) {
661         return _name;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-symbol}.
666      */
667     function symbol() public view virtual override returns (string memory) {
668         return _symbol;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-tokenURI}.
673      */
674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
675         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
676 
677         string memory baseURI = _baseURI();
678         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
679     }
680 
681     /**
682      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
683      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
684      * by default, can be overriden in child contracts.
685      */
686     function _baseURI() internal view virtual returns (string memory) {
687         return "";
688     }
689 
690     /**
691      * @dev See {IERC721-approve}.
692      */
693     function approve(address to, uint256 tokenId) public virtual override {
694         address owner = ERC721.ownerOf(tokenId);
695         require(to != owner, "ERC721: approval to current owner");
696 
697         require(
698             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
699             "ERC721: approve caller is not owner nor approved for all"
700         );
701 
702         _approve(to, tokenId);
703     }
704 
705     /**
706      * @dev See {IERC721-getApproved}.
707      */
708     function getApproved(uint256 tokenId) public view virtual override returns (address) {
709         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
710 
711         return _tokenApprovals[tokenId];
712     }
713 
714     /**
715      * @dev See {IERC721-setApprovalForAll}.
716      */
717     function setApprovalForAll(address operator, bool approved) public virtual override {
718         require(operator != _msgSender(), "ERC721: approve to caller");
719 
720         _operatorApprovals[_msgSender()][operator] = approved;
721         emit ApprovalForAll(_msgSender(), operator, approved);
722     }
723 
724     /**
725      * @dev See {IERC721-isApprovedForAll}.
726      */
727     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
728         return _operatorApprovals[owner][operator];
729     }
730 
731     /**
732      * @dev See {IERC721-transferFrom}.
733      */
734     function transferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) public virtual override {
739         //solhint-disable-next-line max-line-length
740         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
741 
742         _transfer(from, to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-safeTransferFrom}.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId
752     ) public virtual override {
753         safeTransferFrom(from, to, tokenId, "");
754     }
755 
756     /**
757      * @dev See {IERC721-safeTransferFrom}.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) public virtual override {
765         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
766         _safeTransfer(from, to, tokenId, _data);
767     }
768 
769     /**
770      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
771      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
772      *
773      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
774      *
775      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
776      * implement alternative mechanisms to perform token transfer, such as signature-based.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must exist and be owned by `from`.
783      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _safeTransfer(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes memory _data
792     ) internal virtual {
793         _transfer(from, to, tokenId);
794         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
795     }
796 
797     /**
798      * @dev Returns whether `tokenId` exists.
799      *
800      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
801      *
802      * Tokens start existing when they are minted (`_mint`),
803      * and stop existing when they are burned (`_burn`).
804      */
805     function _exists(uint256 tokenId) internal view virtual returns (bool) {
806         return _owners[tokenId] != address(0);
807     }
808 
809     /**
810      * @dev Returns whether `spender` is allowed to manage `tokenId`.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must exist.
815      */
816     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
817         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
818         address owner = ERC721.ownerOf(tokenId);
819         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
820     }
821 
822     /**
823      * @dev Safely mints `tokenId` and transfers it to `to`.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must not exist.
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
829      *
830      * Emits a {Transfer} event.
831      */
832     function _safeMint(address to, uint256 tokenId) internal virtual {
833         _safeMint(to, tokenId, "");
834     }
835 
836     /**
837      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
838      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
839      */
840     function _safeMint(
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) internal virtual {
845         _mint(to, tokenId);
846         require(
847             _checkOnERC721Received(address(0), to, tokenId, _data),
848             "ERC721: transfer to non ERC721Receiver implementer"
849         );
850     }
851 
852     /**
853      * @dev Mints `tokenId` and transfers it to `to`.
854      *
855      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
856      *
857      * Requirements:
858      *
859      * - `tokenId` must not exist.
860      * - `to` cannot be the zero address.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _mint(address to, uint256 tokenId) internal virtual {
865         require(to != address(0), "ERC721: mint to the zero address");
866         require(!_exists(tokenId), "ERC721: token already minted");
867 
868         _beforeTokenTransfer(address(0), to, tokenId);
869 
870         _balances[to] += 1;
871         _owners[tokenId] = to;
872 
873         emit Transfer(address(0), to, tokenId);
874     }
875 
876     /**
877      * @dev Destroys `tokenId`.
878      * The approval is cleared when the token is burned.
879      *
880      * Requirements:
881      *
882      * - `tokenId` must exist.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _burn(uint256 tokenId) internal virtual {
887         address owner = ERC721.ownerOf(tokenId);
888 
889         _beforeTokenTransfer(owner, address(0), tokenId);
890 
891         // Clear approvals
892         _approve(address(0), tokenId);
893 
894         _balances[owner] -= 1;
895         delete _owners[tokenId];
896 
897         emit Transfer(owner, address(0), tokenId);
898     }
899 
900     /**
901      * @dev Transfers `tokenId` from `from` to `to`.
902      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
903      *
904      * Requirements:
905      *
906      * - `to` cannot be the zero address.
907      * - `tokenId` token must be owned by `from`.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _transfer(
912         address from,
913         address to,
914         uint256 tokenId
915     ) internal virtual {
916         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
917         require(to != address(0), "ERC721: transfer to the zero address");
918 
919         _beforeTokenTransfer(from, to, tokenId);
920 
921         // Clear approvals from the previous owner
922         _approve(address(0), tokenId);
923 
924         _balances[from] -= 1;
925         _balances[to] += 1;
926         _owners[tokenId] = to;
927 
928         emit Transfer(from, to, tokenId);
929     }
930 
931     /**
932      * @dev Approve `to` to operate on `tokenId`
933      *
934      * Emits a {Approval} event.
935      */
936     function _approve(address to, uint256 tokenId) internal virtual {
937         _tokenApprovals[tokenId] = to;
938         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
939     }
940 
941     /**
942      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
943      * The call is not executed if the target address is not a contract.
944      *
945      * @param from address representing the previous owner of the given token ID
946      * @param to target address that will receive the tokens
947      * @param tokenId uint256 ID of the token to be transferred
948      * @param _data bytes optional data to send along with the call
949      * @return bool whether the call correctly returned the expected magic value
950      */
951     function _checkOnERC721Received(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) private returns (bool) {
957         if (to.isContract()) {
958             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
959                 return retval == IERC721Receiver.onERC721Received.selector;
960             } catch (bytes memory reason) {
961                 if (reason.length == 0) {
962                     revert("ERC721: transfer to non ERC721Receiver implementer");
963                 } else {
964                     assembly {
965                         revert(add(32, reason), mload(reason))
966                     }
967                 }
968             }
969         } else {
970             return true;
971         }
972     }
973 
974     /**
975      * @dev Hook that is called before any token transfer. This includes minting
976      * and burning.
977      *
978      * Calling conditions:
979      *
980      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
981      * transferred to `to`.
982      * - When `from` is zero, `tokenId` will be minted for `to`.
983      * - When `to` is zero, ``from``'s `tokenId` will be burned.
984      * - `from` and `to` are never both zero.
985      *
986      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
987      */
988     function _beforeTokenTransfer(
989         address from,
990         address to,
991         uint256 tokenId
992     ) internal virtual {}
993 }
994 
995 
996 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
997 
998 
999 pragma solidity ^0.8.0;
1000 
1001 /**
1002  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1003  * @dev See https://eips.ethereum.org/EIPS/eip-721
1004  */
1005 interface IERC721Enumerable is IERC721 {
1006     /**
1007      * @dev Returns the total amount of tokens stored by the contract.
1008      */
1009     function totalSupply() external view returns (uint256);
1010 
1011     /**
1012      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1013      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1014      */
1015     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1016 
1017     /**
1018      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1019      * Use along with {totalSupply} to enumerate all tokens.
1020      */
1021     function tokenByIndex(uint256 index) external view returns (uint256);
1022 }
1023 
1024 
1025 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
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
1188 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
1189 
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 /**
1194  * @title Counters
1195  * @author Matt Condon (@shrugs)
1196  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1197  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1198  *
1199  * Include with `using Counters for Counters.Counter;`
1200  */
1201 library Counters {
1202     struct Counter {
1203         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1204         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1205         // this feature: see https://github.com/ethereum/solidity/issues/4637
1206         uint256 _value; // default: 0
1207     }
1208 
1209     function current(Counter storage counter) internal view returns (uint256) {
1210         return counter._value;
1211     }
1212 
1213     function increment(Counter storage counter) internal {
1214         unchecked {
1215             counter._value += 1;
1216         }
1217     }
1218 
1219     function decrement(Counter storage counter) internal {
1220         uint256 value = counter._value;
1221         require(value > 0, "Counter: decrement overflow");
1222         unchecked {
1223             counter._value = value - 1;
1224         }
1225     }
1226 
1227     function reset(Counter storage counter) internal {
1228         counter._value = 0;
1229     }
1230 }
1231 
1232 
1233 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1234 
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 /**
1239  * @dev Contract module which provides a basic access control mechanism, where
1240  * there is an account (an owner) that can be granted exclusive access to
1241  * specific functions.
1242  *
1243  * By default, the owner account will be the one that deploys the contract. This
1244  * can later be changed with {transferOwnership}.
1245  *
1246  * This module is used through inheritance. It will make available the modifier
1247  * `onlyOwner`, which can be applied to your functions to restrict their use to
1248  * the owner.
1249  */
1250 abstract contract Ownable is Context {
1251     address private _owner;
1252 
1253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1254 
1255     /**
1256      * @dev Initializes the contract setting the deployer as the initial owner.
1257      */
1258     constructor() {
1259         _setOwner(_msgSender());
1260     }
1261 
1262     /**
1263      * @dev Returns the address of the current owner.
1264      */
1265     function owner() public view virtual returns (address) {
1266         return _owner;
1267     }
1268 
1269     /**
1270      * @dev Throws if called by any account other than the owner.
1271      */
1272     modifier onlyOwner() {
1273         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1274         _;
1275     }
1276 
1277     /**
1278      * @dev Leaves the contract without owner. It will not be possible to call
1279      * `onlyOwner` functions anymore. Can only be called by the current owner.
1280      *
1281      * NOTE: Renouncing ownership will leave the contract without an owner,
1282      * thereby removing any functionality that is only available to the owner.
1283      */
1284     function renounceOwnership() public virtual onlyOwner {
1285         _setOwner(address(0));
1286     }
1287 
1288     /**
1289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1290      * Can only be called by the current owner.
1291      */
1292     function transferOwnership(address newOwner) public virtual onlyOwner {
1293         require(newOwner != address(0), "Ownable: new owner is the zero address");
1294         _setOwner(newOwner);
1295     }
1296 
1297     function _setOwner(address newOwner) private {
1298         address oldOwner = _owner;
1299         _owner = newOwner;
1300         emit OwnershipTransferred(oldOwner, newOwner);
1301     }
1302 }
1303 
1304 
1305 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.2
1306 
1307 
1308 pragma solidity ^0.8.0;
1309 
1310 // CAUTION
1311 // This version of SafeMath should only be used with Solidity 0.8 or later,
1312 // because it relies on the compiler's built in overflow checks.
1313 
1314 /**
1315  * @dev Wrappers over Solidity's arithmetic operations.
1316  *
1317  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1318  * now has built in overflow checking.
1319  */
1320 library SafeMath {
1321     /**
1322      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1323      *
1324      * _Available since v3.4._
1325      */
1326     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1327         unchecked {
1328             uint256 c = a + b;
1329             if (c < a) return (false, 0);
1330             return (true, c);
1331         }
1332     }
1333 
1334     /**
1335      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1336      *
1337      * _Available since v3.4._
1338      */
1339     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1340         unchecked {
1341             if (b > a) return (false, 0);
1342             return (true, a - b);
1343         }
1344     }
1345 
1346     /**
1347      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1348      *
1349      * _Available since v3.4._
1350      */
1351     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1352         unchecked {
1353             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1354             // benefit is lost if 'b' is also tested.
1355             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1356             if (a == 0) return (true, 0);
1357             uint256 c = a * b;
1358             if (c / a != b) return (false, 0);
1359             return (true, c);
1360         }
1361     }
1362 
1363     /**
1364      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1365      *
1366      * _Available since v3.4._
1367      */
1368     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1369         unchecked {
1370             if (b == 0) return (false, 0);
1371             return (true, a / b);
1372         }
1373     }
1374 
1375     /**
1376      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1377      *
1378      * _Available since v3.4._
1379      */
1380     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1381         unchecked {
1382             if (b == 0) return (false, 0);
1383             return (true, a % b);
1384         }
1385     }
1386 
1387     /**
1388      * @dev Returns the addition of two unsigned integers, reverting on
1389      * overflow.
1390      *
1391      * Counterpart to Solidity's `+` operator.
1392      *
1393      * Requirements:
1394      *
1395      * - Addition cannot overflow.
1396      */
1397     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1398         return a + b;
1399     }
1400 
1401     /**
1402      * @dev Returns the subtraction of two unsigned integers, reverting on
1403      * overflow (when the result is negative).
1404      *
1405      * Counterpart to Solidity's `-` operator.
1406      *
1407      * Requirements:
1408      *
1409      * - Subtraction cannot overflow.
1410      */
1411     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1412         return a - b;
1413     }
1414 
1415     /**
1416      * @dev Returns the multiplication of two unsigned integers, reverting on
1417      * overflow.
1418      *
1419      * Counterpart to Solidity's `*` operator.
1420      *
1421      * Requirements:
1422      *
1423      * - Multiplication cannot overflow.
1424      */
1425     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1426         return a * b;
1427     }
1428 
1429     /**
1430      * @dev Returns the integer division of two unsigned integers, reverting on
1431      * division by zero. The result is rounded towards zero.
1432      *
1433      * Counterpart to Solidity's `/` operator.
1434      *
1435      * Requirements:
1436      *
1437      * - The divisor cannot be zero.
1438      */
1439     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1440         return a / b;
1441     }
1442 
1443     /**
1444      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1445      * reverting when dividing by zero.
1446      *
1447      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1448      * opcode (which leaves remaining gas untouched) while Solidity uses an
1449      * invalid opcode to revert (consuming all remaining gas).
1450      *
1451      * Requirements:
1452      *
1453      * - The divisor cannot be zero.
1454      */
1455     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1456         return a % b;
1457     }
1458 
1459     /**
1460      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1461      * overflow (when the result is negative).
1462      *
1463      * CAUTION: This function is deprecated because it requires allocating memory for the error
1464      * message unnecessarily. For custom revert reasons use {trySub}.
1465      *
1466      * Counterpart to Solidity's `-` operator.
1467      *
1468      * Requirements:
1469      *
1470      * - Subtraction cannot overflow.
1471      */
1472     function sub(
1473         uint256 a,
1474         uint256 b,
1475         string memory errorMessage
1476     ) internal pure returns (uint256) {
1477         unchecked {
1478             require(b <= a, errorMessage);
1479             return a - b;
1480         }
1481     }
1482 
1483     /**
1484      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1485      * division by zero. The result is rounded towards zero.
1486      *
1487      * Counterpart to Solidity's `/` operator. Note: this function uses a
1488      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1489      * uses an invalid opcode to revert (consuming all remaining gas).
1490      *
1491      * Requirements:
1492      *
1493      * - The divisor cannot be zero.
1494      */
1495     function div(
1496         uint256 a,
1497         uint256 b,
1498         string memory errorMessage
1499     ) internal pure returns (uint256) {
1500         unchecked {
1501             require(b > 0, errorMessage);
1502             return a / b;
1503         }
1504     }
1505 
1506     /**
1507      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1508      * reverting with custom message when dividing by zero.
1509      *
1510      * CAUTION: This function is deprecated because it requires allocating memory for the error
1511      * message unnecessarily. For custom revert reasons use {tryMod}.
1512      *
1513      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1514      * opcode (which leaves remaining gas untouched) while Solidity uses an
1515      * invalid opcode to revert (consuming all remaining gas).
1516      *
1517      * Requirements:
1518      *
1519      * - The divisor cannot be zero.
1520      */
1521     function mod(
1522         uint256 a,
1523         uint256 b,
1524         string memory errorMessage
1525     ) internal pure returns (uint256) {
1526         unchecked {
1527             require(b > 0, errorMessage);
1528             return a % b;
1529         }
1530     }
1531 }
1532 
1533 
1534 pragma solidity ^0.8.0;
1535 
1536 /**
1537  * @title TwoPlusTwo contract
1538  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1539  */
1540 contract TwoPlusTwo is ERC721Enumerable, Ownable {
1541     using SafeMath for uint256;
1542 
1543     // project settings
1544     uint256 public ethPrice = 1000000000000000000; // 1 ETH
1545     uint256 public maxPurchase = 10;
1546     uint256 public maxSupply = 1953;
1547     uint256 public maxReserved = 83;
1548 
1549     // withdraw addresses
1550     address private t1;
1551     address private t2;
1552 
1553     // reserve addresses
1554     address private r1;
1555     address private r2;
1556     address private r3;
1557 
1558     bool public saleIsActive = false;
1559     bool public reserved = false;
1560 
1561     string private _baseURIPath;
1562 
1563     event TokenReserved();
1564     event RolledOver(bool status);
1565 
1566     constructor(address _t1, address _t2, address _r1, address _r2, address _r3) ERC721("TwoPlusTwo", "TPT") {
1567         t1 = _t1;
1568         t2 = _t2;
1569         r1 = _r1;
1570         r2 = _r2;
1571         r3 = _r3;
1572     }
1573 
1574     function flipSaleState() public onlyOwner {
1575         saleIsActive = !saleIsActive;
1576         emit RolledOver(saleIsActive);
1577     }
1578 
1579     function mintTokens(uint numberOfTokens) public payable {
1580         require(saleIsActive, "Sale is not active");
1581         require(numberOfTokens <= maxPurchase, "Exceeds max number of Tokens in one transaction");
1582         require(totalSupply().add(numberOfTokens) <= maxSupply, "Purchase would exceed max supply of Tokens");
1583         require(ethPrice.mul(numberOfTokens) == msg.value, "Ether value sent is not correct");
1584 
1585         uint i;
1586         uint mintIndex;
1587         for (i; i < numberOfTokens; i++) {
1588             mintIndex = totalSupply();
1589             if (totalSupply() < maxSupply) {
1590                 _safeMint(_msgSender(), mintIndex);
1591             }
1592         }
1593     }
1594 
1595     function reserveTokens() public onlyOwner onReserve {
1596         uint supply = totalSupply();
1597         uint i;
1598         for (i; i < maxReserved; i++) {
1599             if (i < 40) {
1600                 _safeMint(r1, supply + i);
1601             } else if (i < 80) {
1602                 _safeMint(r2, supply + i);
1603             } else {
1604                 _safeMint(r3, supply + i);
1605             }
1606         }
1607     }
1608 
1609     function setBaseURI(string memory baseURI) public onlyOwner {
1610         _baseURIPath = baseURI;
1611     }
1612 
1613     function withdraw() public onlyOwner {
1614         uint256 _split = address(this).balance / 2;
1615         Address.sendValue(payable(t1), _split);
1616         Address.sendValue(payable(t2), _split);
1617     }
1618 
1619     function _baseURI() internal view override returns (string memory) {
1620         return _baseURIPath;
1621     }
1622 
1623     modifier onReserve() {
1624         require(!reserved, "Tokens reserved");
1625         _;
1626         reserved = true;
1627         emit TokenReserved();
1628     }
1629 }