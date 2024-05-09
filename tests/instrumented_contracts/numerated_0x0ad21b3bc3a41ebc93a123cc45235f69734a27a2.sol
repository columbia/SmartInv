1 /****************************************************************************
2  $$$$$$\             $$$$$$\         $$$$$$\                      $$$$$$$\
3 $$  __$$\    $$\    $$  __$$\       $$  __$$\                     $$  ____|
4 \__/  $$ |   $$ |   \__/  $$ |      $$ /  \__| $$$$$$\  $$$$$$$\  $$ |
5  $$$$$$  |$$$$$$$$\  $$$$$$  |      $$ |$$$$\ $$  __$$\ $$  __$$\ $$$$$$$\
6 $$  ____/ \__$$  __|$$  ____/       $$ |\_$$ |$$$$$$$$ |$$ |  $$ |\_____$$\
7 $$ |         $$ |   $$ |            $$ |  $$ |$$   ____|$$ |  $$ |$$\   $$ |
8 $$$$$$$$\    \__|   $$$$$$$$\       \$$$$$$  |\$$$$$$$\ $$ |  $$ |\$$$$$$  |
9 \________|          \________|       \______/  \_______|\__|  \__| \______/
10 ****************************************************************************/
11 
12 // Powered by NFT Artisans (nftartisans.io) - support@nftartisans.io
13 // Sources flattened with hardhat v2.6.8 https://hardhat.org
14 // SPDX-License-Identifier: MIT
15 
16 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.3
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
42 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.3
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
185 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.3
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
214 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.3
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
241 // File @openzeppelin/contracts/utils/Address.sol@v4.3.3
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
460 // File @openzeppelin/contracts/utils/Context.sol@v4.3.3
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
486 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.3
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
555 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.3
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
584 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.3
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
996 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.3
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
1025 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.3
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
1188 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.3
1189 
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 /**
1194  * @dev Contract module which provides a basic access control mechanism, where
1195  * there is an account (an owner) that can be granted exclusive access to
1196  * specific functions.
1197  *
1198  * By default, the owner account will be the one that deploys the contract. This
1199  * can later be changed with {transferOwnership}.
1200  *
1201  * This module is used through inheritance. It will make available the modifier
1202  * `onlyOwner`, which can be applied to your functions to restrict their use to
1203  * the owner.
1204  */
1205 abstract contract Ownable is Context {
1206     address private _owner;
1207 
1208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1209 
1210     /**
1211      * @dev Initializes the contract setting the deployer as the initial owner.
1212      */
1213     constructor() {
1214         _setOwner(_msgSender());
1215     }
1216 
1217     /**
1218      * @dev Returns the address of the current owner.
1219      */
1220     function owner() public view virtual returns (address) {
1221         return _owner;
1222     }
1223 
1224     /**
1225      * @dev Throws if called by any account other than the owner.
1226      */
1227     modifier onlyOwner() {
1228         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1229         _;
1230     }
1231 
1232     /**
1233      * @dev Leaves the contract without owner. It will not be possible to call
1234      * `onlyOwner` functions anymore. Can only be called by the current owner.
1235      *
1236      * NOTE: Renouncing ownership will leave the contract without an owner,
1237      * thereby removing any functionality that is only available to the owner.
1238      */
1239     function renounceOwnership() public virtual onlyOwner {
1240         _setOwner(address(0));
1241     }
1242 
1243     /**
1244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1245      * Can only be called by the current owner.
1246      */
1247     function transferOwnership(address newOwner) public virtual onlyOwner {
1248         require(newOwner != address(0), "Ownable: new owner is the zero address");
1249         _setOwner(newOwner);
1250     }
1251 
1252     function _setOwner(address newOwner) private {
1253         address oldOwner = _owner;
1254         _owner = newOwner;
1255         emit OwnershipTransferred(oldOwner, newOwner);
1256     }
1257 }
1258 
1259 
1260 // File contracts/TwoPlusTwoGen5.sol
1261 
1262 pragma solidity ^0.8.4;
1263 
1264 
1265 interface TPT {
1266     function balanceOf(address owner) external view returns (uint256);
1267     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1268 }
1269 
1270 interface PENCIL {
1271     function balanceOf(address owner) external view returns (uint256);
1272     function burn(address user, uint256 amount) external;
1273 }
1274 
1275 contract TwoPlusTwoGen5 is ERC721Enumerable, Ownable {
1276 
1277     TPT public TPTGen1; // Addition
1278     TPT public TPTGen3; // Multiplication
1279     PENCIL public PENCILToken; // Utility Token
1280 
1281     bool public isActive = false;
1282 
1283     uint256 public burnCost = 600 * 10 ** 18;
1284     uint256 public maxSupply = 1953;
1285     string private _baseURIPath;
1286 
1287     bool[1953] private _gen1Claimed;
1288     bool[1953] private _gen3Claimed;
1289 
1290     event Minted(uint256 gen1TokenId, uint256 gen3TokenId, uint256 burnCost, uint256 tokenId);
1291     event RolledOver(bool status);
1292 
1293     constructor(address gen1, address gen3, address pencil) ERC721("TwoPlusTwoGen5", "TPT5") {
1294         TPTGen1 = TPT(gen1);
1295         TPTGen3 = TPT(gen3);
1296         PENCILToken = PENCIL(pencil);
1297     }
1298 
1299     // Override the base URI path with our variable
1300     function _baseURI() internal view override returns (string memory) {
1301         return _baseURIPath;
1302     }
1303 
1304     function checkClaim(address recipient) external view returns (uint256) {
1305         require(isActive, "Minting not active");
1306 
1307         uint256 gen1Count = TPTGen1.balanceOf(recipient);
1308         require(gen1Count > 0, "Wallet must own a Genesis NFT");
1309 
1310         uint256 gen3Count = TPTGen3.balanceOf(recipient);
1311         require(gen3Count > 0, "Wallet must own a Gen3 NFT");
1312 
1313         uint256 pencilBalance = PENCILToken.balanceOf(recipient);
1314         require(pencilBalance >= burnCost, "Wallet must have sufficient $PENCIL to burn for minting");
1315 
1316         uint256 gen1Claimed;
1317         uint256 gen3Claimed;
1318 
1319         for (uint256 i; i < gen1Count; i++) {
1320             uint256 tokenId = TPTGen1.tokenOfOwnerByIndex(recipient, i);
1321             if (_gen1Claimed[tokenId] == true) {
1322                 gen1Claimed++;
1323             }
1324         }
1325 
1326         if (gen1Count - gen1Claimed == 0) {
1327             return 0;
1328         }
1329 
1330         for (uint256 i; i < gen3Count; i++) {
1331             uint256 tokenId = TPTGen3.tokenOfOwnerByIndex(recipient, i);
1332             if (_gen3Claimed[tokenId] == true) {
1333                 gen3Claimed++;
1334             }
1335         }
1336 
1337         if (gen3Count - gen3Claimed == 0) {
1338             return 0;
1339         }
1340 
1341         uint256 max = (gen1Count - gen1Claimed) < (gen3Count - gen3Claimed) ? gen1Count - gen1Claimed : gen3Count - gen3Claimed;
1342 
1343         if (max * burnCost > pencilBalance) {
1344             uint256 remainder = pencilBalance % burnCost;
1345             max = (pencilBalance - remainder) / burnCost;
1346         }
1347 
1348         return max;
1349     }
1350 
1351     function checkClaimByTokenId(uint256 nftId, uint8 gen) external view returns (bool) {
1352         require(nftId < 1953, "Invalid Token ID");
1353 
1354         if (gen == 1) {
1355             return _gen1Claimed[nftId];
1356         }
1357         return _gen3Claimed[nftId];
1358     }
1359 
1360     function claimForOwner(address recipient) external onlyOwner {
1361 
1362         uint256 gen1Count = TPTGen1.balanceOf(recipient);
1363         uint256 gen3Count = TPTGen3.balanceOf(recipient);
1364         require(gen1Count > 0 && gen3Count > 0, "Recipient has no unclaimed NFTs available");
1365 
1366         uint256[] memory gen3TokenIds = new uint256[](gen3Count);
1367         uint256 gen3TokenIdsLength;
1368 
1369         for (uint256 i; i < gen3Count; i++) {
1370             uint256 gen3TokenId = TPTGen3.tokenOfOwnerByIndex(recipient, i);
1371 
1372             if (_gen3Claimed[gen3TokenId] == false) {
1373                 gen3TokenIds[gen3TokenIdsLength] = gen3TokenId;
1374                 gen3TokenIdsLength++;
1375             }
1376         }
1377 
1378         require(gen3TokenIdsLength > 0, "No unclaimed Gen3 NFTs available");
1379         uint256 mintIndex;
1380 
1381         for (uint256 i; i < gen1Count; i++) {
1382             uint256 gen1TokenId = TPTGen1.tokenOfOwnerByIndex(recipient, i);
1383 
1384             if (_gen1Claimed[gen1TokenId] == false && gen3TokenIdsLength > 0) {
1385                 gen3TokenIdsLength--;
1386                 mintIndex = totalSupply();
1387                 _mint(recipient, mintIndex);
1388                 _gen1Claimed[gen1TokenId] = true;
1389                 _gen3Claimed[gen3TokenIds[gen3TokenIdsLength]] = true;
1390                 emit Minted(gen1TokenId, gen3TokenIds[gen3TokenIdsLength], 0, mintIndex);
1391             }
1392 
1393             if (gen3TokenIdsLength == 0) {
1394                 break;
1395             }
1396         }
1397     }
1398 
1399     function flipState() public onlyOwner {
1400         isActive = !isActive;
1401         emit RolledOver(isActive);
1402     }
1403 
1404     function mintTokens(uint256 limit) public {
1405         require(isActive, "Minting not active");
1406 
1407         uint256 gen1Count = TPTGen1.balanceOf(msg.sender);
1408         require(gen1Count > 0, "Wallet must own a Genesis NFT");
1409 
1410         uint256 gen3Count = TPTGen3.balanceOf(msg.sender);
1411         require(gen3Count > 0, "Wallet must own a Gen3 NFT");
1412 
1413         uint256 pencilBalance = PENCILToken.balanceOf(msg.sender);
1414         require(pencilBalance >= burnCost, "Wallet must have sufficient $PENCIL to burn for minting");
1415 
1416         if (limit < 1) {
1417             limit = 1;
1418         }
1419 
1420         uint256[] memory gen3TokenIds = new uint256[](gen3Count);
1421 
1422         uint256 gen3TokenIdsLength;
1423 
1424         for (uint256 i; i < gen3Count; i++) {
1425 
1426             uint256 gen3TokenId = TPTGen3.tokenOfOwnerByIndex(msg.sender, i);
1427 
1428             if (_gen3Claimed[gen3TokenId] == false) {
1429                 gen3TokenIds[gen3TokenIdsLength] = gen3TokenId;
1430                 gen3TokenIdsLength++;
1431             }
1432         }
1433 
1434         require(gen3TokenIdsLength > 0, "No unclaimed Gen3 NFTs available");
1435 
1436         uint256 minted;
1437         uint256 mintIndex;
1438 
1439         for (uint256 i; i < gen1Count; i++) {
1440 
1441             if (pencilBalance < burnCost) {
1442                 break;
1443             }
1444 
1445             uint256 gen1TokenId = TPTGen1.tokenOfOwnerByIndex(msg.sender, i);
1446 
1447             if (_gen1Claimed[gen1TokenId] == false && gen3TokenIdsLength > 0) {
1448                 gen3TokenIdsLength--;
1449                 mintIndex = totalSupply();
1450                 PENCILToken.burn(msg.sender, burnCost);
1451                 _mint(_msgSender(), mintIndex);
1452                 _gen1Claimed[gen1TokenId] = true;
1453                 _gen3Claimed[gen3TokenIds[gen3TokenIdsLength]] = true;
1454                 pencilBalance -= burnCost;
1455                 minted++;
1456 
1457                 emit Minted(gen1TokenId, gen3TokenIds[gen3TokenIdsLength], burnCost, mintIndex);
1458             }
1459 
1460             if (minted == limit || gen3TokenIdsLength == 0) {
1461                 break;
1462             }
1463         }
1464 
1465         require(minted > 0, "No unclaimed Gen1 NFTs available");
1466     }
1467 
1468     // Set the IPFS base URI
1469     function setBaseURI(string memory baseURI) public onlyOwner {
1470         _baseURIPath = baseURI;
1471     }
1472 
1473     // There should not be anything to withdraw, but just in case
1474     function withdraw() public onlyOwner {
1475         uint256 balance = address(this).balance;
1476         Address.sendValue(payable(_msgSender()), balance);
1477     }
1478 }