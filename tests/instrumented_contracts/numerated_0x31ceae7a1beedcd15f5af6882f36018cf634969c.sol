1 //                                                                            .*@@#-             .*@@#:
2 //                                                                              .*@@%-         .*@@#:  
3 // .::::::::::::..      ::::::::::::::::   :               .     .:::::::::::::.  .*@@%-     .*@@#:    
4 // =@@@@@@@@@@@@@@@*.   +@@@@@@@@@@@@@@@:  @@*           +@@.  #@@@@@@@@@@@@@@@:    .*@@%- .*@@#:      
5 //  :::..........-#@@-   :::::::::::::::   @@#           *@@. +@@=:::::::::::..       .*@@%@@#:        
6 //  @@#            @@#  @@@@@@@@@@@@@@@@:  @@#           *@@. .%@@@@@@@@@@@@@%+        .#@@@@-         
7 //  @@#           +@@+  @@%-------------   @@%           *@@.   .-----------+@@=     .*@@#-*@@%-       
8 //  @@@%%%%%%%%%@@@@=   @@@%%%%%%%%%%%%%:  =@@@%%%%%%%%%@@@*  .%%%%%%%%%%%%%@@@:   .*@@#:   .*@@%-     
9 //  =============-:     =+++++++++++++++.   .-===========-.   :==============-   .*@@#:       .*@@%-   
10 //                                                                             .*@@#:           .*@@%-
11 //
12 // Choose your fate. Become a legend.
13 //
14 
15 
16 
17 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.3.2
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev These functions deal with verification of Merkle Trees proofs.
25  *
26  * The proofs can be generated using the JavaScript library
27  * https://github.com/miguelmota/merkletreejs[merkletreejs].
28  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
29  *
30  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
31  */
32 library MerkleProof {
33     /**
34      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
35      * defined by `root`. For this, a `proof` must be provided, containing
36      * sibling hashes on the branch from the leaf to the root of the tree. Each
37      * pair of leaves and each pair of pre-images are assumed to be sorted.
38      */
39     function verify(
40         bytes32[] memory proof,
41         bytes32 root,
42         bytes32 leaf
43     ) internal pure returns (bool) {
44         bytes32 computedHash = leaf;
45 
46         for (uint256 i = 0; i < proof.length; i++) {
47             bytes32 proofElement = proof[i];
48 
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
55             }
56         }
57 
58         // Check if the computed hash (root) is equal to the provided root
59         return computedHash == root;
60     }
61 }
62 
63 
64 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
65 
66 /**
67  * @dev Interface of the ERC165 standard, as defined in the
68  * https://eips.ethereum.org/EIPS/eip-165[EIP].
69  *
70  * Implementers can declare support of contract interfaces, which can then be
71  * queried by others ({ERC165Checker}).
72  *
73  * For an implementation, see {ERC165}.
74  */
75 interface IERC165 {
76     /**
77      * @dev Returns true if this contract implements the interface defined by
78      * `interfaceId`. See the corresponding
79      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
80      * to learn more about how these ids are created.
81      *
82      * This function call must use less than 30 000 gas.
83      */
84     function supportsInterface(bytes4 interfaceId) external view returns (bool);
85 }
86 
87 
88 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
89 
90 /**
91  * @dev Required interface of an ERC721 compliant contract.
92  */
93 interface IERC721 is IERC165 {
94     /**
95      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
98 
99     /**
100      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
101      */
102     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
103 
104     /**
105      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
106      */
107     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
108 
109     /**
110      * @dev Returns the number of tokens in ``owner``'s account.
111      */
112     function balanceOf(address owner) external view returns (uint256 balance);
113 
114     /**
115      * @dev Returns the owner of the `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function ownerOf(uint256 tokenId) external view returns (address owner);
122 
123     /**
124      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
125      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
126      *
127      * Requirements:
128      *
129      * - `from` cannot be the zero address.
130      * - `to` cannot be the zero address.
131      * - `tokenId` token must exist and be owned by `from`.
132      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
133      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
134      *
135      * Emits a {Transfer} event.
136      */
137     function safeTransferFrom(
138         address from,
139         address to,
140         uint256 tokenId
141     ) external;
142 
143     /**
144      * @dev Transfers `tokenId` token from `from` to `to`.
145      *
146      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(
158         address from,
159         address to,
160         uint256 tokenId
161     ) external;
162 
163     /**
164      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
165      * The approval is cleared when the token is transferred.
166      *
167      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
168      *
169      * Requirements:
170      *
171      * - The caller must own the token or be an approved operator.
172      * - `tokenId` must exist.
173      *
174      * Emits an {Approval} event.
175      */
176     function approve(address to, uint256 tokenId) external;
177 
178     /**
179      * @dev Returns the account approved for `tokenId` token.
180      *
181      * Requirements:
182      *
183      * - `tokenId` must exist.
184      */
185     function getApproved(uint256 tokenId) external view returns (address operator);
186 
187     /**
188      * @dev Approve or remove `operator` as an operator for the caller.
189      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
190      *
191      * Requirements:
192      *
193      * - The `operator` cannot be the caller.
194      *
195      * Emits an {ApprovalForAll} event.
196      */
197     function setApprovalForAll(address operator, bool _approved) external;
198 
199     /**
200      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
201      *
202      * See {setApprovalForAll}
203      */
204     function isApprovedForAll(address owner, address operator) external view returns (bool);
205 
206     /**
207      * @dev Safely transfers `tokenId` token from `from` to `to`.
208      *
209      * Requirements:
210      *
211      * - `from` cannot be the zero address.
212      * - `to` cannot be the zero address.
213      * - `tokenId` token must exist and be owned by `from`.
214      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
215      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
216      *
217      * Emits a {Transfer} event.
218      */
219     function safeTransferFrom(
220         address from,
221         address to,
222         uint256 tokenId,
223         bytes calldata data
224     ) external;
225 }
226 
227 
228 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
229 
230 /**
231  * @title ERC721 token receiver interface
232  * @dev Interface for any contract that wants to support safeTransfers
233  * from ERC721 asset contracts.
234  */
235 interface IERC721Receiver {
236     /**
237      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
238      * by `operator` from `from`, this function is called.
239      *
240      * It must return its Solidity selector to confirm the token transfer.
241      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
242      *
243      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
244      */
245     function onERC721Received(
246         address operator,
247         address from,
248         uint256 tokenId,
249         bytes calldata data
250     ) external returns (bytes4);
251 }
252 
253 
254 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
255 
256 /**
257  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
258  * @dev See https://eips.ethereum.org/EIPS/eip-721
259  */
260 interface IERC721Metadata is IERC721 {
261     /**
262      * @dev Returns the token collection name.
263      */
264     function name() external view returns (string memory);
265 
266     /**
267      * @dev Returns the token collection symbol.
268      */
269     function symbol() external view returns (string memory);
270 
271     /**
272      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
273      */
274     function tokenURI(uint256 tokenId) external view returns (string memory);
275 }
276 
277 
278 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies on extcodesize, which returns 0 for contracts in
303         // construction, since the code is only stored at the end of the
304         // constructor execution.
305 
306         uint256 size;
307         assembly {
308             size := extcodesize(account)
309         }
310         return size > 0;
311     }
312 
313     /**
314      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
315      * `recipient`, forwarding all available gas and reverting on errors.
316      *
317      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
318      * of certain opcodes, possibly making contracts go over the 2300 gas limit
319      * imposed by `transfer`, making them unable to receive funds via
320      * `transfer`. {sendValue} removes this limitation.
321      *
322      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
323      *
324      * IMPORTANT: because control is transferred to `recipient`, care must be
325      * taken to not create reentrancy vulnerabilities. Consider using
326      * {ReentrancyGuard} or the
327      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
328      */
329     function sendValue(address payable recipient, uint256 amount) internal {
330         require(address(this).balance >= amount, "Address: insufficient balance");
331 
332         (bool success, ) = recipient.call{value: amount}("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain `call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value
387     ) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
393      * with `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 value,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         require(isContract(target), "Address: call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.call{value: value}(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
417         return functionStaticCall(target, data, "Address: low-level static call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal view returns (bytes memory) {
431         require(isContract(target), "Address: static call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.staticcall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.delegatecall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
466      * revert reason using the provided one.
467      *
468      * _Available since v4.3._
469      */
470     function verifyCallResult(
471         bool success,
472         bytes memory returndata,
473         string memory errorMessage
474     ) internal pure returns (bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 assembly {
483                     let returndata_size := mload(returndata)
484                     revert(add(32, returndata), returndata_size)
485                 }
486             } else {
487                 revert(errorMessage);
488             }
489         }
490     }
491 }
492 
493 
494 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
495 
496 /**
497  * @dev Provides information about the current execution context, including the
498  * sender of the transaction and its data. While these are generally available
499  * via msg.sender and msg.data, they should not be accessed in such a direct
500  * manner, since when dealing with meta-transactions the account sending and
501  * paying for execution may not be the actual sender (as far as an application
502  * is concerned).
503  *
504  * This contract is only required for intermediate, library-like contracts.
505  */
506 abstract contract Context {
507     function _msgSender() internal view virtual returns (address) {
508         return msg.sender;
509     }
510 
511     function _msgData() internal view virtual returns (bytes calldata) {
512         return msg.data;
513     }
514 }
515 
516 
517 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
518 
519 /**
520  * @dev String operations.
521  */
522 library Strings {
523     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
527      */
528     function toString(uint256 value) internal pure returns (string memory) {
529         // Inspired by OraclizeAPI's implementation - MIT licence
530         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
531 
532         if (value == 0) {
533             return "0";
534         }
535         uint256 temp = value;
536         uint256 digits;
537         while (temp != 0) {
538             digits++;
539             temp /= 10;
540         }
541         bytes memory buffer = new bytes(digits);
542         while (value != 0) {
543             digits -= 1;
544             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
545             value /= 10;
546         }
547         return string(buffer);
548     }
549 
550     /**
551      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
552      */
553     function toHexString(uint256 value) internal pure returns (string memory) {
554         if (value == 0) {
555             return "0x00";
556         }
557         uint256 temp = value;
558         uint256 length = 0;
559         while (temp != 0) {
560             length++;
561             temp >>= 8;
562         }
563         return toHexString(value, length);
564     }
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
568      */
569     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
570         bytes memory buffer = new bytes(2 * length + 2);
571         buffer[0] = "0";
572         buffer[1] = "x";
573         for (uint256 i = 2 * length + 1; i > 1; --i) {
574             buffer[i] = _HEX_SYMBOLS[value & 0xf];
575             value >>= 4;
576         }
577         require(value == 0, "Strings: hex length insufficient");
578         return string(buffer);
579     }
580 }
581 
582 
583 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
584 
585 /**
586  * @dev Implementation of the {IERC165} interface.
587  *
588  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
589  * for the additional interface id that will be supported. For example:
590  *
591  * ```solidity
592  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
593  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
594  * }
595  * ```
596  *
597  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
598  */
599 abstract contract ERC165 is IERC165 {
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
604         return interfaceId == type(IERC165).interfaceId;
605     }
606 }
607 
608 
609 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
610 
611 /**
612  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
613  * the Metadata extension, but not including the Enumerable extension, which is available separately as
614  * {ERC721Enumerable}.
615  */
616 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
617     using Address for address;
618     using Strings for uint256;
619 
620     // Token name
621     string private _name;
622 
623     // Token symbol
624     string private _symbol;
625 
626     // Mapping from token ID to owner address
627     mapping(uint256 => address) private _owners;
628 
629     // Mapping owner address to token count
630     mapping(address => uint256) private _balances;
631 
632     // Mapping from token ID to approved address
633     mapping(uint256 => address) private _tokenApprovals;
634 
635     // Mapping from owner to operator approvals
636     mapping(address => mapping(address => bool)) private _operatorApprovals;
637 
638     /**
639      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
640      */
641     constructor(string memory name_, string memory symbol_) {
642         _name = name_;
643         _symbol = symbol_;
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
656     /**
657      * @dev See {IERC721-balanceOf}.
658      */
659     function balanceOf(address owner) public view virtual override returns (uint256) {
660         require(owner != address(0), "ERC721: balance query for the zero address");
661         return _balances[owner];
662     }
663 
664     /**
665      * @dev See {IERC721-ownerOf}.
666      */
667     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
668         address owner = _owners[tokenId];
669         require(owner != address(0), "ERC721: owner query for nonexistent token");
670         return owner;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-name}.
675      */
676     function name() public view virtual override returns (string memory) {
677         return _name;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-symbol}.
682      */
683     function symbol() public view virtual override returns (string memory) {
684         return _symbol;
685     }
686 
687     /**
688      * @dev See {IERC721Metadata-tokenURI}.
689      */
690     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
691         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
692 
693         string memory baseURI = _baseURI();
694         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
695     }
696 
697     /**
698      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
699      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
700      * by default, can be overriden in child contracts.
701      */
702     function _baseURI() internal view virtual returns (string memory) {
703         return "";
704     }
705 
706     /**
707      * @dev See {IERC721-approve}.
708      */
709     function approve(address to, uint256 tokenId) public virtual override {
710         address owner = ERC721.ownerOf(tokenId);
711         require(to != owner, "ERC721: approval to current owner");
712 
713         require(
714             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
715             "ERC721: approve caller is not owner nor approved for all"
716         );
717 
718         _approve(to, tokenId);
719     }
720 
721     /**
722      * @dev See {IERC721-getApproved}.
723      */
724     function getApproved(uint256 tokenId) public view virtual override returns (address) {
725         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
726 
727         return _tokenApprovals[tokenId];
728     }
729 
730     /**
731      * @dev See {IERC721-setApprovalForAll}.
732      */
733     function setApprovalForAll(address operator, bool approved) public virtual override {
734         require(operator != _msgSender(), "ERC721: approve to caller");
735 
736         _operatorApprovals[_msgSender()][operator] = approved;
737         emit ApprovalForAll(_msgSender(), operator, approved);
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
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
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
779         bytes memory _data
780     ) public virtual override {
781         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
782         _safeTransfer(from, to, tokenId, _data);
783     }
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
787      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
788      *
789      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
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
807         bytes memory _data
808     ) internal virtual {
809         _transfer(from, to, tokenId);
810         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
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
833         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
834         address owner = ERC721.ownerOf(tokenId);
835         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
836     }
837 
838     /**
839      * @dev Safely mints `tokenId` and transfers it to `to`.
840      *
841      * Requirements:
842      *
843      * - `tokenId` must not exist.
844      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _safeMint(address to, uint256 tokenId) internal virtual {
849         _safeMint(to, tokenId, "");
850     }
851 
852     /**
853      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
854      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
855      */
856     function _safeMint(
857         address to,
858         uint256 tokenId,
859         bytes memory _data
860     ) internal virtual {
861         _mint(to, tokenId);
862         require(
863             _checkOnERC721Received(address(0), to, tokenId, _data),
864             "ERC721: transfer to non ERC721Receiver implementer"
865         );
866     }
867 
868     /**
869      * @dev Mints `tokenId` and transfers it to `to`.
870      *
871      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
872      *
873      * Requirements:
874      *
875      * - `tokenId` must not exist.
876      * - `to` cannot be the zero address.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _mint(address to, uint256 tokenId) internal virtual {
881         require(to != address(0), "ERC721: mint to the zero address");
882         require(!_exists(tokenId), "ERC721: token already minted");
883 
884         _beforeTokenTransfer(address(0), to, tokenId);
885 
886         _balances[to] += 1;
887         _owners[tokenId] = to;
888 
889         emit Transfer(address(0), to, tokenId);
890     }
891 
892     /**
893      * @dev Destroys `tokenId`.
894      * The approval is cleared when the token is burned.
895      *
896      * Requirements:
897      *
898      * - `tokenId` must exist.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _burn(uint256 tokenId) internal virtual {
903         address owner = ERC721.ownerOf(tokenId);
904 
905         _beforeTokenTransfer(owner, address(0), tokenId);
906 
907         // Clear approvals
908         _approve(address(0), tokenId);
909 
910         _balances[owner] -= 1;
911         delete _owners[tokenId];
912 
913         emit Transfer(owner, address(0), tokenId);
914     }
915 
916     /**
917      * @dev Transfers `tokenId` from `from` to `to`.
918      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
919      *
920      * Requirements:
921      *
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must be owned by `from`.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _transfer(
928         address from,
929         address to,
930         uint256 tokenId
931     ) internal virtual {
932         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
933         require(to != address(0), "ERC721: transfer to the zero address");
934 
935         _beforeTokenTransfer(from, to, tokenId);
936 
937         // Clear approvals from the previous owner
938         _approve(address(0), tokenId);
939 
940         _balances[from] -= 1;
941         _balances[to] += 1;
942         _owners[tokenId] = to;
943 
944         emit Transfer(from, to, tokenId);
945     }
946 
947     /**
948      * @dev Approve `to` to operate on `tokenId`
949      *
950      * Emits a {Approval} event.
951      */
952     function _approve(address to, uint256 tokenId) internal virtual {
953         _tokenApprovals[tokenId] = to;
954         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
955     }
956 
957     /**
958      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
959      * The call is not executed if the target address is not a contract.
960      *
961      * @param from address representing the previous owner of the given token ID
962      * @param to target address that will receive the tokens
963      * @param tokenId uint256 ID of the token to be transferred
964      * @param _data bytes optional data to send along with the call
965      * @return bool whether the call correctly returned the expected magic value
966      */
967     function _checkOnERC721Received(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) private returns (bool) {
973         if (to.isContract()) {
974             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
975                 return retval == IERC721Receiver.onERC721Received.selector;
976             } catch (bytes memory reason) {
977                 if (reason.length == 0) {
978                     revert("ERC721: transfer to non ERC721Receiver implementer");
979                 } else {
980                     assembly {
981                         revert(add(32, reason), mload(reason))
982                     }
983                 }
984             }
985         } else {
986             return true;
987         }
988     }
989 
990     /**
991      * @dev Hook that is called before any token transfer. This includes minting
992      * and burning.
993      *
994      * Calling conditions:
995      *
996      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
997      * transferred to `to`.
998      * - When `from` is zero, `tokenId` will be minted for `to`.
999      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1000      * - `from` and `to` are never both zero.
1001      *
1002      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1003      */
1004     function _beforeTokenTransfer(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) internal virtual {}
1009 }
1010 
1011 
1012 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
1013 
1014 /**
1015  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1016  * @dev See https://eips.ethereum.org/EIPS/eip-721
1017  */
1018 interface IERC721Enumerable is IERC721 {
1019     /**
1020      * @dev Returns the total amount of tokens stored by the contract.
1021      */
1022     function totalSupply() external view returns (uint256);
1023 
1024     /**
1025      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1026      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1027      */
1028     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1029 
1030     /**
1031      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1032      * Use along with {totalSupply} to enumerate all tokens.
1033      */
1034     function tokenByIndex(uint256 index) external view returns (uint256);
1035 }
1036 
1037 
1038 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1039 
1040 /**
1041  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1042  * enumerability of all the token ids in the contract as well as all token ids owned by each
1043  * account.
1044  */
1045 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1046     // Mapping from owner to list of owned token IDs
1047     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1048 
1049     // Mapping from token ID to index of the owner tokens list
1050     mapping(uint256 => uint256) private _ownedTokensIndex;
1051 
1052     // Array with all token ids, used for enumeration
1053     uint256[] private _allTokens;
1054 
1055     // Mapping from token id to position in the allTokens array
1056     mapping(uint256 => uint256) private _allTokensIndex;
1057 
1058     /**
1059      * @dev See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1062         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1067      */
1068     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1069         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1070         return _ownedTokens[owner][index];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Enumerable-totalSupply}.
1075      */
1076     function totalSupply() public view virtual override returns (uint256) {
1077         return _allTokens.length;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Enumerable-tokenByIndex}.
1082      */
1083     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1084         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1085         return _allTokens[index];
1086     }
1087 
1088     /**
1089      * @dev Hook that is called before any token transfer. This includes minting
1090      * and burning.
1091      *
1092      * Calling conditions:
1093      *
1094      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1095      * transferred to `to`.
1096      * - When `from` is zero, `tokenId` will be minted for `to`.
1097      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1098      * - `from` cannot be the zero address.
1099      * - `to` cannot be the zero address.
1100      *
1101      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1102      */
1103     function _beforeTokenTransfer(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) internal virtual override {
1108         super._beforeTokenTransfer(from, to, tokenId);
1109 
1110         if (from == address(0)) {
1111             _addTokenToAllTokensEnumeration(tokenId);
1112         } else if (from != to) {
1113             _removeTokenFromOwnerEnumeration(from, tokenId);
1114         }
1115         if (to == address(0)) {
1116             _removeTokenFromAllTokensEnumeration(tokenId);
1117         } else if (to != from) {
1118             _addTokenToOwnerEnumeration(to, tokenId);
1119         }
1120     }
1121 
1122     /**
1123      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1124      * @param to address representing the new owner of the given token ID
1125      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1126      */
1127     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1128         uint256 length = ERC721.balanceOf(to);
1129         _ownedTokens[to][length] = tokenId;
1130         _ownedTokensIndex[tokenId] = length;
1131     }
1132 
1133     /**
1134      * @dev Private function to add a token to this extension's token tracking data structures.
1135      * @param tokenId uint256 ID of the token to be added to the tokens list
1136      */
1137     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1138         _allTokensIndex[tokenId] = _allTokens.length;
1139         _allTokens.push(tokenId);
1140     }
1141 
1142     /**
1143      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1144      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1145      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1146      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1147      * @param from address representing the previous owner of the given token ID
1148      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1149      */
1150     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1151         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1152         // then delete the last slot (swap and pop).
1153 
1154         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1155         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1156 
1157         // When the token to delete is the last token, the swap operation is unnecessary
1158         if (tokenIndex != lastTokenIndex) {
1159             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1160 
1161             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1162             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1163         }
1164 
1165         // This also deletes the contents at the last position of the array
1166         delete _ownedTokensIndex[tokenId];
1167         delete _ownedTokens[from][lastTokenIndex];
1168     }
1169 
1170     /**
1171      * @dev Private function to remove a token from this extension's token tracking data structures.
1172      * This has O(1) time complexity, but alters the order of the _allTokens array.
1173      * @param tokenId uint256 ID of the token to be removed from the tokens list
1174      */
1175     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1176         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1177         // then delete the last slot (swap and pop).
1178 
1179         uint256 lastTokenIndex = _allTokens.length - 1;
1180         uint256 tokenIndex = _allTokensIndex[tokenId];
1181 
1182         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1183         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1184         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1185         uint256 lastTokenId = _allTokens[lastTokenIndex];
1186 
1187         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1188         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1189 
1190         // This also deletes the contents at the last position of the array
1191         delete _allTokensIndex[tokenId];
1192         _allTokens.pop();
1193     }
1194 }
1195 
1196 
1197 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1198 
1199 /**
1200  * @dev Contract module which provides a basic access control mechanism, where
1201  * there is an account (an owner) that can be granted exclusive access to
1202  * specific functions.
1203  *
1204  * By default, the owner account will be the one that deploys the contract. This
1205  * can later be changed with {transferOwnership}.
1206  *
1207  * This module is used through inheritance. It will make available the modifier
1208  * `onlyOwner`, which can be applied to your functions to restrict their use to
1209  * the owner.
1210  */
1211 abstract contract Ownable is Context {
1212     address private _owner;
1213 
1214     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1215 
1216     /**
1217      * @dev Initializes the contract setting the deployer as the initial owner.
1218      */
1219     constructor() {
1220         _setOwner(_msgSender());
1221     }
1222 
1223     /**
1224      * @dev Returns the address of the current owner.
1225      */
1226     function owner() public view virtual returns (address) {
1227         return _owner;
1228     }
1229 
1230     /**
1231      * @dev Throws if called by any account other than the owner.
1232      */
1233     modifier onlyOwner() {
1234         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1235         _;
1236     }
1237 
1238     /**
1239      * @dev Leaves the contract without owner. It will not be possible to call
1240      * `onlyOwner` functions anymore. Can only be called by the current owner.
1241      *
1242      * NOTE: Renouncing ownership will leave the contract without an owner,
1243      * thereby removing any functionality that is only available to the owner.
1244      */
1245     function renounceOwnership() public virtual onlyOwner {
1246         _setOwner(address(0));
1247     }
1248 
1249     /**
1250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1251      * Can only be called by the current owner.
1252      */
1253     function transferOwnership(address newOwner) public virtual onlyOwner {
1254         require(newOwner != address(0), "Ownable: new owner is the zero address");
1255         _setOwner(newOwner);
1256     }
1257 
1258     function _setOwner(address newOwner) private {
1259         address oldOwner = _owner;
1260         _owner = newOwner;
1261         emit OwnershipTransferred(oldOwner, newOwner);
1262     }
1263 }
1264 
1265 
1266 // File contracts/DeusX.sol
1267 
1268 contract DeusX is ERC721Enumerable, Ownable {
1269   using Strings for uint256;
1270 
1271   uint256 public constant DEUSX_GIFT = 101;
1272   uint256 public constant DEUSX_PUBLIC = 10000; 
1273   uint256 public constant DEUSX_MAX = DEUSX_GIFT + DEUSX_PUBLIC; 
1274   uint256 public constant PURCHASE_LIMIT = 10; // per tx, contracts can still recursively call 
1275   uint256 public constant PRICE = 0.08 ether;
1276 
1277   string[] public FACTION_NAMES = [
1278     'None',
1279     'Valks',
1280     'Roks',
1281     'Monsters'
1282   ];
1283   
1284   address[] TEAM_ADDRESSES = [
1285     0x9cc35B5bB5c4fC544eeC96a33baa7BB5c5966095,
1286     0xa2E9986C8936E9Ff788B167e85Ef92ae309ecc4C,
1287     0x64ac893a59096Fc13dBD39c35Ce894833db62b7a,
1288     0x0e6596a739FCEb57fCA595b78EF0F6e586e8938c,
1289     0xa55033bFB357eFDd804f2391E30a52291C77dD51,
1290     0x5B1212FE9b20D32688F5f02973087f828b0a4824,
1291     0x31C5327974f02406b698DB4a51eA860Aa411E8A1,
1292     0x78eEb89ae305cCc774516546b43a11fc74794222,
1293     0xb34C812501bCb190Cf21ed7623F89924549970fb,
1294     0xa096F2F973b91F5E148301f9C4f5BC56165E0865
1295   ];
1296 
1297   uint256[] TEAM_PCTS = [
1298     0.25e18,
1299     0.25e18,
1300     0.20e18,
1301     0.08e18,	
1302     0.06e18,	
1303     0.0501e18,
1304     0.04e18,
1305     0.01e18,
1306     0.01e18,
1307     0.0499e18
1308   ];
1309 
1310   uint256 constant UNIT = 1e18;
1311 
1312   bool public isActive = true;
1313 
1314   string public provenanceHash;
1315 
1316   uint256 public allowListMaxMint = 2;
1317 
1318   uint256 public totalGiftSupply;
1319   uint256 public totalPublicSupply;
1320 
1321   /**
1322   * 0 - presale batch 1
1323   * 1 - presale batch 2
1324   * 2 - waitlist 
1325   * 3 - public sale
1326   */
1327 
1328   bytes32[] public roots;
1329   uint256[] public startTimes;
1330 
1331   mapping(uint256 => uint256) public factionOf;
1332   mapping(address => uint256) public allowListClaimed;
1333   mapping(uint256 => uint256) private factionNumbers;
1334 
1335   string public contractURI = '';
1336   string public tokenBaseURI = '';
1337   string public tokenRevealedBaseURI = '';
1338   constructor(string memory _name, string memory _symbol, string memory _contractURI, string memory _tokenBaseURI, bytes32[] memory _roots, uint256[] memory _startTimes) ERC721(_name, _symbol) {
1339     contractURI = _contractURI;
1340     tokenBaseURI = _tokenBaseURI;
1341     roots = _roots;
1342     startTimes = _startTimes;
1343   }
1344 
1345   function purchase(uint256 numberOfTokens, uint256[] calldata factions) external payable {
1346     require(isActive, 'Inactive');
1347     require(block.timestamp > startTimes[2], 'Not started');
1348     require(totalPublicSupply < DEUSX_PUBLIC, 'Exceeds supply');
1349     require(numberOfTokens <= PURCHASE_LIMIT, 'Exceeds limit');
1350     require(numberOfTokens == factions.length, 'Invalid factions');
1351 
1352     /**
1353     * The last person to purchase might overpay, but this prevents them
1354     * from getting sniped. 
1355     * If this happens, we'll refund the ETH for the unavailable tokens.
1356     */
1357 
1358     require(numberOfTokens * PRICE <= msg.value, 'Insufficient ETH');
1359 
1360     for (uint256 i = 0; i < numberOfTokens; i++) {
1361       if (totalPublicSupply < DEUSX_PUBLIC) { 
1362 
1363         /**
1364         * Public token numbering starts after DEUSX_GIFT.
1365         * Token numbers should start at 1
1366         */
1367 
1368         totalPublicSupply += 1;
1369         uint256 tokenId = DEUSX_GIFT + totalPublicSupply;
1370         _safeMint(msg.sender, tokenId);
1371 
1372         uint256 _faction = factions[i];
1373         require(_faction < FACTION_NAMES.length, 'Invalid faction'); 
1374         factionOf[tokenId] = _faction;
1375         factionNumbers[_faction] += 1;
1376         emit SetFaction(tokenId, _faction);
1377       }
1378     }
1379   }
1380 
1381   function purchaseAllowList(uint256 numberOfTokens, uint256[] calldata factions, bytes32[] memory merkleProof) external payable {
1382     require(isActive, 'Inactive');
1383     require(block.timestamp < startTimes[3], 'Public sale started');
1384 
1385     bytes32 root;
1386     if (block.timestamp > startTimes[2]) {
1387       root = roots[2];
1388     } else if (block.timestamp > startTimes[1]) {
1389       root = roots[1];
1390     }  else if (block.timestamp > startTimes[0]) {
1391       root = roots[0];
1392     } else {
1393       revert('Not started');
1394     }
1395 
1396     require(numberOfTokens == factions.length, 'Invalid params');
1397     require(totalPublicSupply + numberOfTokens <= DEUSX_PUBLIC, 'Exceeds supply limit');
1398     require(allowListClaimed[msg.sender] + numberOfTokens <= allowListMaxMint, 'Exceeds max allowed');
1399     require(numberOfTokens * PRICE <= msg.value, 'Insufficient ETH'); 
1400 
1401     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1402 
1403     require(MerkleProof.verify(merkleProof, root, leaf), 'Invalid proof');
1404 
1405     allowListClaimed[msg.sender] += numberOfTokens;
1406 
1407     for (uint256 i = 0; i < numberOfTokens; i++) {
1408 
1409       /*
1410       * Public token numbering starts after DEUSX_GIFT.
1411       * Tokens IDs start at 1.
1412       */
1413 
1414       totalPublicSupply += 1;
1415       uint256 tokenId = DEUSX_GIFT + totalPublicSupply;
1416 
1417       _safeMint(msg.sender, tokenId);
1418 
1419       uint256 _faction = factions[i];
1420       require(_faction < FACTION_NAMES.length, 'Invalid faction'); 
1421       factionOf[tokenId] = _faction;
1422       factionNumbers[_faction] += 1;
1423       emit SetFaction(tokenId, _faction);
1424     }
1425   }
1426 
1427   function setFactions(uint256[] calldata _tokenIds, uint256[] calldata _factions) external {
1428       require(_tokenIds.length == _factions.length, 'Invalid params');
1429       
1430       for(uint256 i = 0; i < _tokenIds.length; i++) {
1431         require(msg.sender == ownerOf(_tokenIds[i]), 'Invalid caller');
1432         require(factionOf[_tokenIds[i]] == 0, 'Faction already set');
1433         require(_factions[i] < FACTION_NAMES.length, 'Invalid faction'); 
1434         
1435         factionOf[_tokenIds[i]] = _factions[i];
1436         factionNumbers[_factions[i]] += 1;
1437         emit SetFaction(_tokenIds[i], _factions[i]);
1438       }
1439   }
1440 
1441   function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1442     require(_exists(tokenId), 'Token does not exist');
1443 
1444     string memory revealedBaseURI = tokenRevealedBaseURI;
1445     
1446     if (bytes(revealedBaseURI).length > 0) {
1447       uint256 faction = factionOf[tokenId];
1448       if(faction > 0) {
1449         return string(abi.encodePacked(revealedBaseURI, tokenId.toString(), '-', FACTION_NAMES[faction]));
1450       } else {
1451         return string(abi.encodePacked(revealedBaseURI, tokenId.toString()));
1452       }
1453     } else {
1454       return tokenBaseURI;
1455     }
1456   }
1457 
1458   function totalInFaction(uint256 _faction) external view returns (uint256) {
1459     if(_faction == 0) {
1460       return DEUSX_MAX - factionNumbers[1] - factionNumbers[2] - factionNumbers[3];
1461     } else {
1462       return factionNumbers[_faction];
1463     }
1464   }
1465 
1466   function onAccesslist(bytes32[] memory _proof, uint256 _rootIndex, address _address) external view returns (bool) {
1467     return MerkleProof.verify(_proof, roots[_rootIndex], keccak256(abi.encodePacked(_address)));
1468   }
1469 
1470   function gift(address[] calldata to) external onlyOwner {
1471     require(totalGiftSupply + to.length <= DEUSX_GIFT, 'Gifts finished');
1472 
1473     for(uint256 i = 0; i < to.length; i++) {
1474 
1475        // Tokens IDs start at 1.
1476       totalGiftSupply += 1;
1477       uint256 tokenId = totalGiftSupply;
1478       
1479       _safeMint(to[i], tokenId);
1480     }
1481   }
1482 
1483   function withdraw() external {
1484     uint256 balance = address(this).balance;
1485     for(uint256 i = 0; i < TEAM_ADDRESSES.length; i++) {
1486       payable(TEAM_ADDRESSES[i]).transfer(balance*TEAM_PCTS[i]/UNIT);
1487     }
1488   }
1489 
1490   function emergencyWithdrawal() external onlyOwner {
1491     require(block.timestamp > startTimes[3] + 10*24*60*60, 'Cannot withdraw yet'); // if there's a problem with the payout, allow an emergency release after 10 days 
1492     uint256 balance = address(this).balance;
1493     (bool success, ) = payable(msg.sender).call{value: balance}('');
1494     require(success, 'Transfer failed.');
1495   }
1496 
1497   function setStartTimes(uint256[] calldata _startTimes) external onlyOwner {
1498       require(block.timestamp < startTimes[0], 'Sale started'); // prevent owner from rugging emergency withdrawal
1499       startTimes = _startTimes;
1500   }
1501 
1502   function setAllowListMaxMint(uint256 maxMint) external onlyOwner {
1503     allowListMaxMint = maxMint;
1504   }
1505 
1506   function setContractURI(string calldata URI) external onlyOwner {
1507     contractURI = URI;
1508   }
1509 
1510   function setBaseURI(string calldata URI) external onlyOwner {
1511     tokenBaseURI = URI;
1512   }
1513 
1514   function setRevealedBaseURI(string calldata revealedBaseURI) external onlyOwner {
1515     tokenRevealedBaseURI = revealedBaseURI;
1516   }
1517 
1518   function setRoots(bytes32[] calldata _roots) external onlyOwner {
1519       roots = _roots;
1520   }
1521 
1522   function setIsActive(bool _isActive) external onlyOwner {
1523       isActive = _isActive;
1524   }
1525 
1526   function setProvenanceHash(string memory _provenanceHash) external onlyOwner {
1527       provenanceHash = _provenanceHash;
1528       emit SetProvenanceHash(_provenanceHash);
1529   }
1530 
1531   event SetProvenanceHash(string provenanceHash);
1532   event SetFaction(uint256 indexed tokenId, uint256 faction); 
1533 }