1 /****************************************************************************
2  $$$$$$\             $$$$$$\         $$$$$$\                      $$\   $$\
3 $$  __$$\    $$\    $$  __$$\       $$  __$$\                     $$ |  $$ |
4 \__/  $$ |   $$ |   \__/  $$ |      $$ /  \__| $$$$$$\  $$$$$$$\  $$ |  $$ |
5  $$$$$$  |$$$$$$$$\  $$$$$$  |      $$ |$$$$\ $$  __$$\ $$  __$$\ $$$$$$$$ |
6 $$  ____/ \__$$  __|$$  ____/       $$ |\_$$ |$$$$$$$$ |$$ |  $$ |\_____$$ |
7 $$ |         $$ |   $$ |            $$ |  $$ |$$   ____|$$ |  $$ |      $$ |
8 $$$$$$$$\    \__|   $$$$$$$$\       \$$$$$$  |\$$$$$$$\ $$ |  $$ |      $$ |
9 \________|          \________|       \______/  \_______|\__|  \__|      \__|
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
628     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
629         return
630             interfaceId == type(IERC721).interfaceId ||
631             interfaceId == type(IERC721Metadata).interfaceId ||
632             super.supportsInterface(interfaceId);
633     }
634 
635     /**
636      * @dev See {IERC721-balanceOf}.
637      */
638     function balanceOf(address owner) public view virtual override returns (uint256) {
639         require(owner != address(0), "ERC721: balance query for the zero address");
640         return _balances[owner];
641     }
642 
643     /**
644      * @dev See {IERC721-ownerOf}.
645      */
646     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
647         address owner = _owners[tokenId];
648         require(owner != address(0), "ERC721: owner query for nonexistent token");
649         return owner;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-name}.
654      */
655     function name() public view virtual override returns (string memory) {
656         return _name;
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-symbol}.
661      */
662     function symbol() public view virtual override returns (string memory) {
663         return _symbol;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-tokenURI}.
668      */
669     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
670         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
671 
672         string memory baseURI = _baseURI();
673         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
674     }
675 
676     /**
677      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
678      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
679      * by default, can be overriden in child contracts.
680      */
681     function _baseURI() internal view virtual returns (string memory) {
682         return "";
683     }
684 
685     /**
686      * @dev See {IERC721-approve}.
687      */
688     function approve(address to, uint256 tokenId) public virtual override {
689         address owner = ERC721.ownerOf(tokenId);
690         require(to != owner, "ERC721: approval to current owner");
691 
692         require(
693             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
694             "ERC721: approve caller is not owner nor approved for all"
695         );
696 
697         _approve(to, tokenId);
698     }
699 
700     /**
701      * @dev See {IERC721-getApproved}.
702      */
703     function getApproved(uint256 tokenId) public view virtual override returns (address) {
704         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
705 
706         return _tokenApprovals[tokenId];
707     }
708 
709     /**
710      * @dev See {IERC721-setApprovalForAll}.
711      */
712     function setApprovalForAll(address operator, bool approved) public virtual override {
713         require(operator != _msgSender(), "ERC721: approve to caller");
714 
715         _operatorApprovals[_msgSender()][operator] = approved;
716         emit ApprovalForAll(_msgSender(), operator, approved);
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
869     }
870 
871     /**
872      * @dev Destroys `tokenId`.
873      * The approval is cleared when the token is burned.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _burn(uint256 tokenId) internal virtual {
882         address owner = ERC721.ownerOf(tokenId);
883 
884         _beforeTokenTransfer(owner, address(0), tokenId);
885 
886         // Clear approvals
887         _approve(address(0), tokenId);
888 
889         _balances[owner] -= 1;
890         delete _owners[tokenId];
891 
892         emit Transfer(owner, address(0), tokenId);
893     }
894 
895     /**
896      * @dev Transfers `tokenId` from `from` to `to`.
897      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
898      *
899      * Requirements:
900      *
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must be owned by `from`.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _transfer(
907         address from,
908         address to,
909         uint256 tokenId
910     ) internal virtual {
911         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
912         require(to != address(0), "ERC721: transfer to the zero address");
913 
914         _beforeTokenTransfer(from, to, tokenId);
915 
916         // Clear approvals from the previous owner
917         _approve(address(0), tokenId);
918 
919         _balances[from] -= 1;
920         _balances[to] += 1;
921         _owners[tokenId] = to;
922 
923         emit Transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev Approve `to` to operate on `tokenId`
928      *
929      * Emits a {Approval} event.
930      */
931     function _approve(address to, uint256 tokenId) internal virtual {
932         _tokenApprovals[tokenId] = to;
933         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
934     }
935 
936     /**
937      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
938      * The call is not executed if the target address is not a contract.
939      *
940      * @param from address representing the previous owner of the given token ID
941      * @param to target address that will receive the tokens
942      * @param tokenId uint256 ID of the token to be transferred
943      * @param _data bytes optional data to send along with the call
944      * @return bool whether the call correctly returned the expected magic value
945      */
946     function _checkOnERC721Received(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) private returns (bool) {
952         if (to.isContract()) {
953             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
954                 return retval == IERC721Receiver.onERC721Received.selector;
955             } catch (bytes memory reason) {
956                 if (reason.length == 0) {
957                     revert("ERC721: transfer to non ERC721Receiver implementer");
958                 } else {
959                     assembly {
960                         revert(add(32, reason), mload(reason))
961                     }
962                 }
963             }
964         } else {
965             return true;
966         }
967     }
968 
969     /**
970      * @dev Hook that is called before any token transfer. This includes minting
971      * and burning.
972      *
973      * Calling conditions:
974      *
975      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
976      * transferred to `to`.
977      * - When `from` is zero, `tokenId` will be minted for `to`.
978      * - When `to` is zero, ``from``'s `tokenId` will be burned.
979      * - `from` and `to` are never both zero.
980      *
981      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
982      */
983     function _beforeTokenTransfer(
984         address from,
985         address to,
986         uint256 tokenId
987     ) internal virtual {}
988 }
989 
990 
991 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.3
992 
993 
994 pragma solidity ^0.8.0;
995 
996 /**
997  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
998  * @dev See https://eips.ethereum.org/EIPS/eip-721
999  */
1000 interface IERC721Enumerable is IERC721 {
1001     /**
1002      * @dev Returns the total amount of tokens stored by the contract.
1003      */
1004     function totalSupply() external view returns (uint256);
1005 
1006     /**
1007      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1008      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1009      */
1010     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1011 
1012     /**
1013      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1014      * Use along with {totalSupply} to enumerate all tokens.
1015      */
1016     function tokenByIndex(uint256 index) external view returns (uint256);
1017 }
1018 
1019 
1020 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.3
1021 
1022 
1023 pragma solidity ^0.8.0;
1024 
1025 
1026 /**
1027  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1028  * enumerability of all the token ids in the contract as well as all token ids owned by each
1029  * account.
1030  */
1031 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1032     // Mapping from owner to list of owned token IDs
1033     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1034 
1035     // Mapping from token ID to index of the owner tokens list
1036     mapping(uint256 => uint256) private _ownedTokensIndex;
1037 
1038     // Array with all token ids, used for enumeration
1039     uint256[] private _allTokens;
1040 
1041     // Mapping from token id to position in the allTokens array
1042     mapping(uint256 => uint256) private _allTokensIndex;
1043 
1044     /**
1045      * @dev See {IERC165-supportsInterface}.
1046      */
1047     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1048         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1053      */
1054     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1055         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1056         return _ownedTokens[owner][index];
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-totalSupply}.
1061      */
1062     function totalSupply() public view virtual override returns (uint256) {
1063         return _allTokens.length;
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Enumerable-tokenByIndex}.
1068      */
1069     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1070         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1071         return _allTokens[index];
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before any token transfer. This includes minting
1076      * and burning.
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` will be minted for `to`.
1083      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1084      * - `from` cannot be the zero address.
1085      * - `to` cannot be the zero address.
1086      *
1087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088      */
1089     function _beforeTokenTransfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual override {
1094         super._beforeTokenTransfer(from, to, tokenId);
1095 
1096         if (from == address(0)) {
1097             _addTokenToAllTokensEnumeration(tokenId);
1098         } else if (from != to) {
1099             _removeTokenFromOwnerEnumeration(from, tokenId);
1100         }
1101         if (to == address(0)) {
1102             _removeTokenFromAllTokensEnumeration(tokenId);
1103         } else if (to != from) {
1104             _addTokenToOwnerEnumeration(to, tokenId);
1105         }
1106     }
1107 
1108     /**
1109      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1110      * @param to address representing the new owner of the given token ID
1111      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1112      */
1113     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1114         uint256 length = ERC721.balanceOf(to);
1115         _ownedTokens[to][length] = tokenId;
1116         _ownedTokensIndex[tokenId] = length;
1117     }
1118 
1119     /**
1120      * @dev Private function to add a token to this extension's token tracking data structures.
1121      * @param tokenId uint256 ID of the token to be added to the tokens list
1122      */
1123     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1124         _allTokensIndex[tokenId] = _allTokens.length;
1125         _allTokens.push(tokenId);
1126     }
1127 
1128     /**
1129      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1130      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1131      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1132      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1133      * @param from address representing the previous owner of the given token ID
1134      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1135      */
1136     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1137         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1138         // then delete the last slot (swap and pop).
1139 
1140         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1141         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1142 
1143         // When the token to delete is the last token, the swap operation is unnecessary
1144         if (tokenIndex != lastTokenIndex) {
1145             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1146 
1147             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1148             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1149         }
1150 
1151         // This also deletes the contents at the last position of the array
1152         delete _ownedTokensIndex[tokenId];
1153         delete _ownedTokens[from][lastTokenIndex];
1154     }
1155 
1156     /**
1157      * @dev Private function to remove a token from this extension's token tracking data structures.
1158      * This has O(1) time complexity, but alters the order of the _allTokens array.
1159      * @param tokenId uint256 ID of the token to be removed from the tokens list
1160      */
1161     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1162         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1163         // then delete the last slot (swap and pop).
1164 
1165         uint256 lastTokenIndex = _allTokens.length - 1;
1166         uint256 tokenIndex = _allTokensIndex[tokenId];
1167 
1168         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1169         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1170         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1171         uint256 lastTokenId = _allTokens[lastTokenIndex];
1172 
1173         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1174         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1175 
1176         // This also deletes the contents at the last position of the array
1177         delete _allTokensIndex[tokenId];
1178         _allTokens.pop();
1179     }
1180 }
1181 
1182 
1183 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.3
1184 
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 /**
1189  * @dev Contract module which provides a basic access control mechanism, where
1190  * there is an account (an owner) that can be granted exclusive access to
1191  * specific functions.
1192  *
1193  * By default, the owner account will be the one that deploys the contract. This
1194  * can later be changed with {transferOwnership}.
1195  *
1196  * This module is used through inheritance. It will make available the modifier
1197  * `onlyOwner`, which can be applied to your functions to restrict their use to
1198  * the owner.
1199  */
1200 abstract contract Ownable is Context {
1201     address private _owner;
1202 
1203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1204 
1205     /**
1206      * @dev Initializes the contract setting the deployer as the initial owner.
1207      */
1208     constructor() {
1209         _setOwner(_msgSender());
1210     }
1211 
1212     /**
1213      * @dev Returns the address of the current owner.
1214      */
1215     function owner() public view virtual returns (address) {
1216         return _owner;
1217     }
1218 
1219     /**
1220      * @dev Throws if called by any account other than the owner.
1221      */
1222     modifier onlyOwner() {
1223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1224         _;
1225     }
1226 
1227     /**
1228      * @dev Leaves the contract without owner. It will not be possible to call
1229      * `onlyOwner` functions anymore. Can only be called by the current owner.
1230      *
1231      * NOTE: Renouncing ownership will leave the contract without an owner,
1232      * thereby removing any functionality that is only available to the owner.
1233      */
1234     function renounceOwnership() public virtual onlyOwner {
1235         _setOwner(address(0));
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Can only be called by the current owner.
1241      */
1242     function transferOwnership(address newOwner) public virtual onlyOwner {
1243         require(newOwner != address(0), "Ownable: new owner is the zero address");
1244         _setOwner(newOwner);
1245     }
1246 
1247     function _setOwner(address newOwner) private {
1248         address oldOwner = _owner;
1249         _owner = newOwner;
1250         emit OwnershipTransferred(oldOwner, newOwner);
1251     }
1252 }
1253 
1254 
1255 // File contracts/TwoPlusTwoGen4.sol
1256 
1257 pragma solidity ^0.8.4;
1258 
1259 
1260 interface TPT {
1261     function balanceOf(address owner) external view returns (uint256);
1262     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1263 }
1264 
1265 interface PENCIL {
1266     function balanceOf(address owner) external view returns (uint256);
1267     function burn(address user, uint256 amount) external;
1268 }
1269 
1270 contract TwoPlusTwoGen4 is ERC721Enumerable, Ownable {
1271 
1272     TPT public TPTGen1; // Addition
1273     TPT public TPTGen2; // Subtraction
1274     PENCIL public PENCILToken; // Utility Token
1275 
1276     bool public isActive = false;
1277 
1278     uint256 public burnCost = 500 * 10 ** 18;
1279     uint256 public maxSupply = 1953;
1280     string private _baseURIPath;
1281 
1282     bool[1953] private _gen1Claimed;
1283     bool[1953] private _gen2Claimed;
1284 
1285     event Minted(uint256 gen1TokenId, uint256 gen2TokenId, uint256 burnCost, uint256 tokenId);
1286     event RolledOver(bool status);
1287 
1288     constructor(address gen1, address gen2, address pencil) ERC721("TwoPlusTwoGen4", "TPT4") {
1289         TPTGen1 = TPT(gen1);
1290         TPTGen2 = TPT(gen2);
1291         PENCILToken = PENCIL(pencil);
1292     }
1293 
1294     // Override the base URI path with our variable
1295     function _baseURI() internal view override returns (string memory) {
1296         return _baseURIPath;
1297     }
1298 
1299     function checkClaim(address recipient) external view returns (uint256) {
1300         require(isActive, "Minting not active");
1301 
1302         uint256 gen1Count = TPTGen1.balanceOf(recipient);
1303         require(gen1Count > 0, "Wallet must own a Genesis NFT");
1304 
1305         uint256 gen2Count = TPTGen2.balanceOf(recipient);
1306         require(gen2Count > 0, "Wallet must own a Gen2 NFT");
1307 
1308         uint256 pencilBalance = PENCILToken.balanceOf(recipient);
1309         require(pencilBalance >= burnCost, "Wallet must have sufficient $PENCIL to burn for minting");
1310 
1311         uint256 gen1Claimed;
1312         uint256 gen2Claimed;
1313 
1314         for (uint256 i; i < gen1Count; i++) {
1315             uint256 tokenId = TPTGen1.tokenOfOwnerByIndex(recipient, i);
1316             if (_gen1Claimed[tokenId] == true) {
1317                 gen1Claimed++;
1318             }
1319         }
1320 
1321         if (gen1Count - gen1Claimed == 0) {
1322             return 0;
1323         }
1324 
1325         for (uint256 i; i < gen2Count; i++) {
1326             uint256 tokenId = TPTGen2.tokenOfOwnerByIndex(recipient, i);
1327             if (_gen2Claimed[tokenId] == true) {
1328                 gen2Claimed++;
1329             }
1330         }
1331 
1332         if (gen2Count - gen2Claimed == 0) {
1333             return 0;
1334         }
1335 
1336         uint256 max = (gen1Count - gen1Claimed) < (gen2Count - gen2Claimed) ? gen1Count - gen1Claimed : gen2Count - gen2Claimed;
1337 
1338         if (max * burnCost > pencilBalance) {
1339             uint256 remainder = pencilBalance % burnCost;
1340             max = (pencilBalance - remainder) / burnCost;
1341         }
1342 
1343         return max;
1344     }
1345 
1346     function checkClaimByTokenId(uint256 nftId, uint8 gen) external view returns (bool) {
1347         require(nftId < 1953, "Invalid Token ID");
1348 
1349         if (gen == 1) {
1350             return _gen1Claimed[nftId];
1351         }
1352         return _gen2Claimed[nftId];
1353     }
1354 
1355     function claimForOwner(address recipient) external onlyOwner {
1356 
1357         uint256 gen1Count = TPTGen1.balanceOf(recipient);
1358         uint256 gen2Count = TPTGen2.balanceOf(recipient);
1359         require(gen1Count > 0 && gen2Count > 0, "Recipient has no unclaimed NFTs available");
1360 
1361         uint256[] memory gen2TokenIds = new uint256[](gen2Count);
1362         uint256 gen2TokenIdsLength;
1363 
1364         for (uint256 i; i < gen2Count; i++) {
1365             uint256 gen2TokenId = TPTGen2.tokenOfOwnerByIndex(recipient, i);
1366 
1367             if (_gen2Claimed[gen2TokenId] == false) {
1368                 gen2TokenIds[gen2TokenIdsLength] = gen2TokenId;
1369                 gen2TokenIdsLength++;
1370             }
1371         }
1372 
1373         require(gen2TokenIdsLength > 0, "No unclaimed Gen2 NFTs available");
1374         uint256 mintIndex;
1375 
1376         for (uint256 i; i < gen1Count; i++) {
1377             uint256 gen1TokenId = TPTGen1.tokenOfOwnerByIndex(recipient, i);
1378 
1379             if (_gen1Claimed[gen1TokenId] == false && gen2TokenIdsLength > 0) {
1380                 gen2TokenIdsLength--;
1381                 mintIndex = totalSupply();
1382                 _mint(recipient, mintIndex);
1383                 _gen1Claimed[gen1TokenId] = true;
1384                 _gen2Claimed[gen2TokenIds[gen2TokenIdsLength]] = true;
1385                 emit Minted(gen1TokenId, gen2TokenIds[gen2TokenIdsLength], 0, mintIndex);
1386             }
1387 
1388             if (gen2TokenIdsLength == 0) {
1389                 break;
1390             }
1391         }
1392     }
1393 
1394     function flipState() public onlyOwner {
1395         isActive = !isActive;
1396         emit RolledOver(isActive);
1397     }
1398 
1399     function mintTokens(uint256 limit) public {
1400         require(isActive, "Minting not active");
1401 
1402         uint256 gen1Count = TPTGen1.balanceOf(msg.sender);
1403         require(gen1Count > 0, "Wallet must own a Genesis NFT");
1404 
1405         uint256 gen2Count = TPTGen2.balanceOf(msg.sender);
1406         require(gen2Count > 0, "Wallet must own a Gen2 NFT");
1407 
1408         uint256 pencilBalance = PENCILToken.balanceOf(msg.sender);
1409         require(pencilBalance >= burnCost, "Wallet must have sufficient $PENCIL to burn for minting");
1410 
1411         if (limit < 1) {
1412             limit = 1;
1413         }
1414 
1415         uint256[] memory gen2TokenIds = new uint256[](gen2Count);
1416         uint256 gen2TokenIdsLength;
1417 
1418         for (uint256 i; i < gen2Count; i++) {
1419 
1420             uint256 gen2TokenId = TPTGen2.tokenOfOwnerByIndex(msg.sender, i);
1421 
1422             if (_gen2Claimed[gen2TokenId] == false) {
1423                 gen2TokenIds[gen2TokenIdsLength] = gen2TokenId;
1424                 gen2TokenIdsLength++;
1425             }
1426         }
1427 
1428         require(gen2TokenIdsLength > 0, "No unclaimed Gen2 NFTs available");
1429 
1430         uint256 minted;
1431         uint256 mintIndex;
1432 
1433         for (uint256 i; i < gen1Count; i++) {
1434 
1435             if (pencilBalance < burnCost) {
1436                 break;
1437             }
1438 
1439             uint256 gen1TokenId = TPTGen1.tokenOfOwnerByIndex(msg.sender, i);
1440 
1441             if (_gen1Claimed[gen1TokenId] == false && gen2TokenIdsLength > 0) {
1442                 gen2TokenIdsLength--;
1443                 mintIndex = totalSupply();
1444                 PENCILToken.burn(msg.sender, burnCost);
1445                 _mint(_msgSender(), mintIndex);
1446                 _gen1Claimed[gen1TokenId] = true;
1447                 _gen2Claimed[gen2TokenIds[gen2TokenIdsLength]] = true;
1448                 pencilBalance -= burnCost;
1449                 minted++;
1450 
1451                 emit Minted(gen1TokenId, gen2TokenIds[gen2TokenIdsLength], burnCost, mintIndex);
1452             }
1453 
1454             if (minted == limit || gen2TokenIdsLength == 0) {
1455                 break;
1456             }
1457         }
1458 
1459         require(minted > 0, "No unclaimed Gen1 NFTs available");
1460     }
1461 
1462     // Set the IPFS base URI
1463     function setBaseURI(string memory baseURI) public onlyOwner {
1464         _baseURIPath = baseURI;
1465     }
1466 
1467     // There should not be anything to withdraw, but just in case
1468     function withdraw() public onlyOwner {
1469         uint256 balance = address(this).balance;
1470         Address.sendValue(payable(_msgSender()), balance);
1471     }
1472 }