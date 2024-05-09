1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
36      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
37      * hash matches the root of the tree. When processing the proof, the pairs
38      * of leafs & pre-images are assumed to be sorted.
39      *
40      * _Available since v4.4._
41      */
42     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
43         bytes32 computedHash = leaf;
44         for (uint256 i = 0; i < proof.length; i++) {
45             bytes32 proofElement = proof[i];
46             if (computedHash <= proofElement) {
47                 // Hash(current computed hash + current element of the proof)
48                 computedHash = _efficientHash(computedHash, proofElement);
49             } else {
50                 // Hash(current element of the proof + current computed hash)
51                 computedHash = _efficientHash(proofElement, computedHash);
52             }
53         }
54         return computedHash;
55     }
56 
57     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
58         assembly {
59             mstore(0x00, a)
60             mstore(0x20, b)
61             value := keccak256(0x00, 0x40)
62         }
63     }
64 }
65 
66 
67 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
71 
72 
73 
74 /**
75  * @dev Interface of the ERC165 standard, as defined in the
76  * https://eips.ethereum.org/EIPS/eip-165[EIP].
77  *
78  * Implementers can declare support of contract interfaces, which can then be
79  * queried by others ({ERC165Checker}).
80  *
81  * For an implementation, see {ERC165}.
82  */
83 interface IERC165 {
84     /**
85      * @dev Returns true if this contract implements the interface defined by
86      * `interfaceId`. See the corresponding
87      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
88      * to learn more about how these ids are created.
89      *
90      * This function call must use less than 30 000 gas.
91      */
92     function supportsInterface(bytes4 interfaceId) external view returns (bool);
93 }
94 
95 
96 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
100 
101 
102 
103 /**
104  * @dev Required interface of an ERC721 compliant contract.
105  */
106 interface IERC721 is IERC165 {
107     /**
108      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
111 
112     /**
113      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
114      */
115     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
119      */
120     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
121 
122     /**
123      * @dev Returns the number of tokens in ``owner``'s account.
124      */
125     function balanceOf(address owner) external view returns (uint256 balance);
126 
127     /**
128      * @dev Returns the owner of the `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function ownerOf(uint256 tokenId) external view returns (address owner);
135 
136     /**
137      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
138      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
139      *
140      * Requirements:
141      *
142      * - `from` cannot be the zero address.
143      * - `to` cannot be the zero address.
144      * - `tokenId` token must exist and be owned by `from`.
145      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
146      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
147      *
148      * Emits a {Transfer} event.
149      */
150     function safeTransferFrom(
151         address from,
152         address to,
153         uint256 tokenId
154     ) external;
155 
156     /**
157      * @dev Transfers `tokenId` token from `from` to `to`.
158      *
159      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must be owned by `from`.
166      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
178      * The approval is cleared when the token is transferred.
179      *
180      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
181      *
182      * Requirements:
183      *
184      * - The caller must own the token or be an approved operator.
185      * - `tokenId` must exist.
186      *
187      * Emits an {Approval} event.
188      */
189     function approve(address to, uint256 tokenId) external;
190 
191     /**
192      * @dev Returns the account approved for `tokenId` token.
193      *
194      * Requirements:
195      *
196      * - `tokenId` must exist.
197      */
198     function getApproved(uint256 tokenId) external view returns (address operator);
199 
200     /**
201      * @dev Approve or remove `operator` as an operator for the caller.
202      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
203      *
204      * Requirements:
205      *
206      * - The `operator` cannot be the caller.
207      *
208      * Emits an {ApprovalForAll} event.
209      */
210     function setApprovalForAll(address operator, bool _approved) external;
211 
212     /**
213      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
214      *
215      * See {setApprovalForAll}
216      */
217     function isApprovedForAll(address owner, address operator) external view returns (bool);
218 
219     /**
220      * @dev Safely transfers `tokenId` token from `from` to `to`.
221      *
222      * Requirements:
223      *
224      * - `from` cannot be the zero address.
225      * - `to` cannot be the zero address.
226      * - `tokenId` token must exist and be owned by `from`.
227      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
228      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
229      *
230      * Emits a {Transfer} event.
231      */
232     function safeTransferFrom(
233         address from,
234         address to,
235         uint256 tokenId,
236         bytes calldata data
237     ) external;
238 }
239 
240 
241 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
242 
243 
244 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
245 
246 
247 
248 /**
249  * @title ERC721 token receiver interface
250  * @dev Interface for any contract that wants to support safeTransfers
251  * from ERC721 asset contracts.
252  */
253 interface IERC721Receiver {
254     /**
255      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
256      * by `operator` from `from`, this function is called.
257      *
258      * It must return its Solidity selector to confirm the token transfer.
259      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
260      *
261      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
262      */
263     function onERC721Received(
264         address operator,
265         address from,
266         uint256 tokenId,
267         bytes calldata data
268     ) external returns (bytes4);
269 }
270 
271 
272 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
276 
277 
278 
279 /**
280  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
281  * @dev See https://eips.ethereum.org/EIPS/eip-721
282  */
283 interface IERC721Metadata is IERC721 {
284     /**
285      * @dev Returns the token collection name.
286      */
287     function name() external view returns (string memory);
288 
289     /**
290      * @dev Returns the token collection symbol.
291      */
292     function symbol() external view returns (string memory);
293 
294     /**
295      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
296      */
297     function tokenURI(uint256 tokenId) external view returns (string memory);
298 }
299 
300 
301 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
302 
303 
304 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
305 
306 pragma solidity ^0.8.1;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      *
329      * [IMPORTANT]
330      * ====
331      * You shouldn't rely on `isContract` to protect against flash loan attacks!
332      *
333      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
334      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
335      * constructor.
336      * ====
337      */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies on extcodesize/address.code.length, which returns 0
340         // for contracts in construction, since the code is only stored at the end
341         // of the constructor execution.
342 
343         return account.code.length > 0;
344     }
345 
346     /**
347      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
348      * `recipient`, forwarding all available gas and reverting on errors.
349      *
350      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
351      * of certain opcodes, possibly making contracts go over the 2300 gas limit
352      * imposed by `transfer`, making them unable to receive funds via
353      * `transfer`. {sendValue} removes this limitation.
354      *
355      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
356      *
357      * IMPORTANT: because control is transferred to `recipient`, care must be
358      * taken to not create reentrancy vulnerabilities. Consider using
359      * {ReentrancyGuard} or the
360      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
361      */
362     function sendValue(address payable recipient, uint256 amount) internal {
363         require(address(this).balance >= amount, "Address: insufficient balance");
364 
365         (bool success, ) = recipient.call{value: amount}("");
366         require(success, "Address: unable to send value, recipient may have reverted");
367     }
368 
369     /**
370      * @dev Performs a Solidity function call using a low level `call`. A
371      * plain `call` is an unsafe replacement for a function call: use this
372      * function instead.
373      *
374      * If `target` reverts with a revert reason, it is bubbled up by this
375      * function (like regular Solidity function calls).
376      *
377      * Returns the raw returned data. To convert to the expected return value,
378      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
379      *
380      * Requirements:
381      *
382      * - `target` must be a contract.
383      * - calling `target` with `data` must not revert.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionCall(target, data, "Address: low-level call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
393      * `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, 0, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but also transferring `value` wei to `target`.
408      *
409      * Requirements:
410      *
411      * - the calling contract must have an ETH balance of at least `value`.
412      * - the called Solidity function must be `payable`.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         require(isContract(target), "Address: call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.call{value: value}(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
450         return functionStaticCall(target, data, "Address: low-level static call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal view returns (bytes memory) {
464         require(isContract(target), "Address: static call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.staticcall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
477         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(isContract(target), "Address: delegate call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
499      * revert reason using the provided one.
500      *
501      * _Available since v4.3._
502      */
503     function verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) internal pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 
527 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
531 
532 
533 
534 /**
535  * @dev Provides information about the current execution context, including the
536  * sender of the transaction and its data. While these are generally available
537  * via msg.sender and msg.data, they should not be accessed in such a direct
538  * manner, since when dealing with meta-transactions the account sending and
539  * paying for execution may not be the actual sender (as far as an application
540  * is concerned).
541  *
542  * This contract is only required for intermediate, library-like contracts.
543  */
544 abstract contract Context {
545     function _msgSender() internal view virtual returns (address) {
546         return msg.sender;
547     }
548 
549     function _msgData() internal view virtual returns (bytes calldata) {
550         return msg.data;
551     }
552 }
553 
554 
555 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
559 
560 
561 
562 /**
563  * @dev String operations.
564  */
565 library Strings {
566     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
567 
568     /**
569      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
570      */
571     function toString(uint256 value) internal pure returns (string memory) {
572         // Inspired by OraclizeAPI's implementation - MIT licence
573         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
574 
575         if (value == 0) {
576             return "0";
577         }
578         uint256 temp = value;
579         uint256 digits;
580         while (temp != 0) {
581             digits++;
582             temp /= 10;
583         }
584         bytes memory buffer = new bytes(digits);
585         while (value != 0) {
586             digits -= 1;
587             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
588             value /= 10;
589         }
590         return string(buffer);
591     }
592 
593     /**
594      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
595      */
596     function toHexString(uint256 value) internal pure returns (string memory) {
597         if (value == 0) {
598             return "0x00";
599         }
600         uint256 temp = value;
601         uint256 length = 0;
602         while (temp != 0) {
603             length++;
604             temp >>= 8;
605         }
606         return toHexString(value, length);
607     }
608 
609     /**
610      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
611      */
612     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
613         bytes memory buffer = new bytes(2 * length + 2);
614         buffer[0] = "0";
615         buffer[1] = "x";
616         for (uint256 i = 2 * length + 1; i > 1; --i) {
617             buffer[i] = _HEX_SYMBOLS[value & 0xf];
618             value >>= 4;
619         }
620         require(value == 0, "Strings: hex length insufficient");
621         return string(buffer);
622     }
623 }
624 
625 
626 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
630 
631 
632 
633 /**
634  * @dev Implementation of the {IERC165} interface.
635  *
636  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
637  * for the additional interface id that will be supported. For example:
638  *
639  * ```solidity
640  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
641  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
642  * }
643  * ```
644  *
645  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
646  */
647 abstract contract ERC165 is IERC165 {
648     /**
649      * @dev See {IERC165-supportsInterface}.
650      */
651     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
652         return interfaceId == type(IERC165).interfaceId;
653     }
654 }
655 
656 
657 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
658 
659 
660 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
661 
662 
663 
664 
665 
666 
667 
668 
669 
670 /**
671  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
672  * the Metadata extension, but not including the Enumerable extension, which is available separately as
673  * {ERC721Enumerable}.
674  */
675 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
676     using Address for address;
677     using Strings for uint256;
678 
679     // Token name
680     string private _name;
681 
682     // Token symbol
683     string private _symbol;
684 
685     // Mapping from token ID to owner address
686     mapping(uint256 => address) private _owners;
687 
688     // Mapping owner address to token count
689     mapping(address => uint256) private _balances;
690 
691     // Mapping from token ID to approved address
692     mapping(uint256 => address) private _tokenApprovals;
693 
694     // Mapping from owner to operator approvals
695     mapping(address => mapping(address => bool)) private _operatorApprovals;
696 
697     /**
698      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
699      */
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703     }
704 
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
709         return
710             interfaceId == type(IERC721).interfaceId ||
711             interfaceId == type(IERC721Metadata).interfaceId ||
712             super.supportsInterface(interfaceId);
713     }
714 
715     /**
716      * @dev See {IERC721-balanceOf}.
717      */
718     function balanceOf(address owner) public view virtual override returns (uint256) {
719         require(owner != address(0), "ERC721: balance query for the zero address");
720         return _balances[owner];
721     }
722 
723     /**
724      * @dev See {IERC721-ownerOf}.
725      */
726     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
727         address owner = _owners[tokenId];
728         require(owner != address(0), "ERC721: owner query for nonexistent token");
729         return owner;
730     }
731 
732     /**
733      * @dev See {IERC721Metadata-name}.
734      */
735     function name() public view virtual override returns (string memory) {
736         return _name;
737     }
738 
739     /**
740      * @dev See {IERC721Metadata-symbol}.
741      */
742     function symbol() public view virtual override returns (string memory) {
743         return _symbol;
744     }
745 
746     /**
747      * @dev See {IERC721Metadata-tokenURI}.
748      */
749     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
750         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
751 
752         string memory baseURI = _baseURI();
753         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
754     }
755 
756     /**
757      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
758      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
759      * by default, can be overriden in child contracts.
760      */
761     function _baseURI() internal view virtual returns (string memory) {
762         return "";
763     }
764 
765     /**
766      * @dev See {IERC721-approve}.
767      */
768     function approve(address to, uint256 tokenId) public virtual override {
769         address owner = ERC721.ownerOf(tokenId);
770         require(to != owner, "ERC721: approval to current owner");
771 
772         require(
773             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
774             "ERC721: approve caller is not owner nor approved for all"
775         );
776 
777         _approve(to, tokenId);
778     }
779 
780     /**
781      * @dev See {IERC721-getApproved}.
782      */
783     function getApproved(uint256 tokenId) public view virtual override returns (address) {
784         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
785 
786         return _tokenApprovals[tokenId];
787     }
788 
789     /**
790      * @dev See {IERC721-setApprovalForAll}.
791      */
792     function setApprovalForAll(address operator, bool approved) public virtual override {
793         _setApprovalForAll(_msgSender(), operator, approved);
794     }
795 
796     /**
797      * @dev See {IERC721-isApprovedForAll}.
798      */
799     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
800         return _operatorApprovals[owner][operator];
801     }
802 
803     /**
804      * @dev See {IERC721-transferFrom}.
805      */
806     function transferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) public virtual override {
811         //solhint-disable-next-line max-line-length
812         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
813 
814         _transfer(from, to, tokenId);
815     }
816 
817     /**
818      * @dev See {IERC721-safeTransferFrom}.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public virtual override {
825         safeTransferFrom(from, to, tokenId, "");
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) public virtual override {
837         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
838         _safeTransfer(from, to, tokenId, _data);
839     }
840 
841     /**
842      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
843      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
844      *
845      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
846      *
847      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
848      * implement alternative mechanisms to perform token transfer, such as signature-based.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must exist and be owned by `from`.
855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _safeTransfer(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) internal virtual {
865         _transfer(from, to, tokenId);
866         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
867     }
868 
869     /**
870      * @dev Returns whether `tokenId` exists.
871      *
872      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
873      *
874      * Tokens start existing when they are minted (`_mint`),
875      * and stop existing when they are burned (`_burn`).
876      */
877     function _exists(uint256 tokenId) internal view virtual returns (bool) {
878         return _owners[tokenId] != address(0);
879     }
880 
881     /**
882      * @dev Returns whether `spender` is allowed to manage `tokenId`.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      */
888     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
889         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
890         address owner = ERC721.ownerOf(tokenId);
891         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
892     }
893 
894     /**
895      * @dev Safely mints `tokenId` and transfers it to `to`.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must not exist.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _safeMint(address to, uint256 tokenId) internal virtual {
905         _safeMint(to, tokenId, "");
906     }
907 
908     /**
909      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
910      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
911      */
912     function _safeMint(
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) internal virtual {
917         _mint(to, tokenId);
918         require(
919             _checkOnERC721Received(address(0), to, tokenId, _data),
920             "ERC721: transfer to non ERC721Receiver implementer"
921         );
922     }
923 
924     /**
925      * @dev Mints `tokenId` and transfers it to `to`.
926      *
927      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - `to` cannot be the zero address.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _mint(address to, uint256 tokenId) internal virtual {
937         require(to != address(0), "ERC721: mint to the zero address");
938         require(!_exists(tokenId), "ERC721: token already minted");
939 
940         _beforeTokenTransfer(address(0), to, tokenId);
941 
942         _balances[to] += 1;
943         _owners[tokenId] = to;
944 
945         emit Transfer(address(0), to, tokenId);
946 
947         _afterTokenTransfer(address(0), to, tokenId);
948     }
949 
950     /**
951      * @dev Destroys `tokenId`.
952      * The approval is cleared when the token is burned.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _burn(uint256 tokenId) internal virtual {
961         address owner = ERC721.ownerOf(tokenId);
962 
963         _beforeTokenTransfer(owner, address(0), tokenId);
964 
965         // Clear approvals
966         _approve(address(0), tokenId);
967 
968         _balances[owner] -= 1;
969         delete _owners[tokenId];
970 
971         emit Transfer(owner, address(0), tokenId);
972 
973         _afterTokenTransfer(owner, address(0), tokenId);
974     }
975 
976     /**
977      * @dev Transfers `tokenId` from `from` to `to`.
978      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
979      *
980      * Requirements:
981      *
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must be owned by `from`.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _transfer(
988         address from,
989         address to,
990         uint256 tokenId
991     ) internal virtual {
992         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
993         require(to != address(0), "ERC721: transfer to the zero address");
994 
995         _beforeTokenTransfer(from, to, tokenId);
996 
997         // Clear approvals from the previous owner
998         _approve(address(0), tokenId);
999 
1000         _balances[from] -= 1;
1001         _balances[to] += 1;
1002         _owners[tokenId] = to;
1003 
1004         emit Transfer(from, to, tokenId);
1005 
1006         _afterTokenTransfer(from, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev Approve `to` to operate on `tokenId`
1011      *
1012      * Emits a {Approval} event.
1013      */
1014     function _approve(address to, uint256 tokenId) internal virtual {
1015         _tokenApprovals[tokenId] = to;
1016         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1017     }
1018 
1019     /**
1020      * @dev Approve `operator` to operate on all of `owner` tokens
1021      *
1022      * Emits a {ApprovalForAll} event.
1023      */
1024     function _setApprovalForAll(
1025         address owner,
1026         address operator,
1027         bool approved
1028     ) internal virtual {
1029         require(owner != operator, "ERC721: approve to caller");
1030         _operatorApprovals[owner][operator] = approved;
1031         emit ApprovalForAll(owner, operator, approved);
1032     }
1033 
1034     /**
1035      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1036      * The call is not executed if the target address is not a contract.
1037      *
1038      * @param from address representing the previous owner of the given token ID
1039      * @param to target address that will receive the tokens
1040      * @param tokenId uint256 ID of the token to be transferred
1041      * @param _data bytes optional data to send along with the call
1042      * @return bool whether the call correctly returned the expected magic value
1043      */
1044     function _checkOnERC721Received(
1045         address from,
1046         address to,
1047         uint256 tokenId,
1048         bytes memory _data
1049     ) private returns (bool) {
1050         if (to.isContract()) {
1051             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1052                 return retval == IERC721Receiver.onERC721Received.selector;
1053             } catch (bytes memory reason) {
1054                 if (reason.length == 0) {
1055                     revert("ERC721: transfer to non ERC721Receiver implementer");
1056                 } else {
1057                     assembly {
1058                         revert(add(32, reason), mload(reason))
1059                     }
1060                 }
1061             }
1062         } else {
1063             return true;
1064         }
1065     }
1066 
1067     /**
1068      * @dev Hook that is called before any token transfer. This includes minting
1069      * and burning.
1070      *
1071      * Calling conditions:
1072      *
1073      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1074      * transferred to `to`.
1075      * - When `from` is zero, `tokenId` will be minted for `to`.
1076      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1077      * - `from` and `to` are never both zero.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) internal virtual {}
1086 
1087     /**
1088      * @dev Hook that is called after any transfer of tokens. This includes
1089      * minting and burning.
1090      *
1091      * Calling conditions:
1092      *
1093      * - when `from` and `to` are both non-zero.
1094      * - `from` and `to` are never both zero.
1095      *
1096      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1097      */
1098     function _afterTokenTransfer(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) internal virtual {}
1103 }
1104 
1105 
1106 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1107 
1108 
1109 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1110 
1111 
1112 
1113 /**
1114  * @dev Contract module which provides a basic access control mechanism, where
1115  * there is an account (an owner) that can be granted exclusive access to
1116  * specific functions.
1117  *
1118  * By default, the owner account will be the one that deploys the contract. This
1119  * can later be changed with {transferOwnership}.
1120  *
1121  * This module is used through inheritance. It will make available the modifier
1122  * `onlyOwner`, which can be applied to your functions to restrict their use to
1123  * the owner.
1124  */
1125 abstract contract Ownable is Context {
1126     address private _owner;
1127 
1128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1129 
1130     /**
1131      * @dev Initializes the contract setting the deployer as the initial owner.
1132      */
1133     constructor() {
1134         _transferOwnership(_msgSender());
1135     }
1136 
1137     /**
1138      * @dev Returns the address of the current owner.
1139      */
1140     function owner() public view virtual returns (address) {
1141         return _owner;
1142     }
1143 
1144     /**
1145      * @dev Throws if called by any account other than the owner.
1146      */
1147     modifier onlyOwner() {
1148         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1149         _;
1150     }
1151 
1152     /**
1153      * @dev Leaves the contract without owner. It will not be possible to call
1154      * `onlyOwner` functions anymore. Can only be called by the current owner.
1155      *
1156      * NOTE: Renouncing ownership will leave the contract without an owner,
1157      * thereby removing any functionality that is only available to the owner.
1158      */
1159     function renounceOwnership() public virtual onlyOwner {
1160         _transferOwnership(address(0));
1161     }
1162 
1163     /**
1164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1165      * Can only be called by the current owner.
1166      */
1167     function transferOwnership(address newOwner) public virtual onlyOwner {
1168         require(newOwner != address(0), "Ownable: new owner is the zero address");
1169         _transferOwnership(newOwner);
1170     }
1171 
1172     /**
1173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1174      * Internal function without access restriction.
1175      */
1176     function _transferOwnership(address newOwner) internal virtual {
1177         address oldOwner = _owner;
1178         _owner = newOwner;
1179         emit OwnershipTransferred(oldOwner, newOwner);
1180     }
1181 }
1182 
1183 
1184 // File @openzeppelin/contracts/utils/Counters.sol@v4.5.0
1185 
1186 
1187 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1188 
1189 
1190 
1191 /**
1192  * @title Counters
1193  * @author Matt Condon (@shrugs)
1194  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1195  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1196  *
1197  * Include with `using Counters for Counters.Counter;`
1198  */
1199 library Counters {
1200     struct Counter {
1201         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1202         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1203         // this feature: see https://github.com/ethereum/solidity/issues/4637
1204         uint256 _value; // default: 0
1205     }
1206 
1207     function current(Counter storage counter) internal view returns (uint256) {
1208         return counter._value;
1209     }
1210 
1211     function increment(Counter storage counter) internal {
1212         unchecked {
1213             counter._value += 1;
1214         }
1215     }
1216 
1217     function decrement(Counter storage counter) internal {
1218         uint256 value = counter._value;
1219         require(value > 0, "Counter: decrement overflow");
1220         unchecked {
1221             counter._value = value - 1;
1222         }
1223     }
1224 
1225     function reset(Counter storage counter) internal {
1226         counter._value = 0;
1227     }
1228 }
1229 
1230 // File contracts/xmferpets.sol
1231 
1232 contract xmferspets is ERC721, Ownable {
1233     using Counters for Counters.Counter;
1234 
1235     string public baseURI;
1236     string public contractURI;
1237     string public constant baseExtension = ".json";
1238     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1239     bytes32 public merkleRoot = 0x7cccd35f224c6fbb86274f2e458d93423f1c4a773545381094d930d8bc34a199;
1240 
1241     Counters.Counter private _totalSupply;
1242     uint256 private _publicSupply;
1243     uint256 public MAX_SUPPLY_PUBLIC = 4200;
1244     uint256 public price = 0.024 ether;
1245     uint256 public holders_price = 0.0042 ether;
1246     uint256 public saleID;
1247     uint256 public constant MAX_PER_WALLET_PUBLIC = 2;
1248 
1249     bool public claimSale = false;
1250     bool public publicSale = false;
1251     bool public reveal = false;
1252 
1253     mapping(uint256 => bool) public petTypeAvailableToMint;
1254     mapping(uint256 => uint256) public petAsignToTokenID;
1255     mapping(uint256 => mapping(address => uint256)) public claimWalletsMinted;
1256     mapping(uint256 => mapping(address => uint256)) public hodlersMinted;
1257     mapping(uint256 => mapping(address => uint256)) public walletsMinted;
1258 
1259     IERC721 xmfers = IERC721(0xB156ADf8523FdC6152aFFdbA076a2143FD7e3c69);
1260 
1261     constructor() ERC721("xmferpets", "xmp") {
1262         petTypeAvailableToMint[0] = true;
1263         petTypeAvailableToMint[1] = true;
1264     }
1265 
1266     function claim(uint256 _amountToMint, uint256 _typeOfPet, uint256 _maxAmount, bytes32[] calldata _merkleProof) external payable {
1267         address _caller = _msgSender();
1268         require(claimSale, "Claim not active");
1269         require(xmfers.balanceOf(_caller) > 0, "Non believer");
1270         require(petTypeAvailableToMint[_typeOfPet], "Not allowed to mint this type of pet");
1271         require(claimWalletsMinted[saleID][_caller] + _amountToMint <= _maxAmount, "Not allow to mint more");
1272         require(_amountToMint > 0, "Not 0 mints");
1273         require(tx.origin == _caller, "No contracts");
1274 
1275         bytes32 leaf = keccak256(abi.encodePacked(_caller, _maxAmount));
1276         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof");
1277 
1278         claimWalletsMinted[saleID][_caller] += _amountToMint;
1279         for (uint256 i; i < _amountToMint; i++) {
1280             if(_typeOfPet > 0){
1281                 petAsignToTokenID[_totalSupply.current()] = _typeOfPet;
1282             }
1283             _safeMint(_caller, _totalSupply.current());
1284             _totalSupply.increment();
1285         }
1286     }
1287 
1288     function holders(uint256 _amountToMint, uint256 _typeOfPet) external payable {
1289         address _caller = _msgSender();
1290         require(MAX_SUPPLY_PUBLIC >= _publicSupply + _amountToMint, "Exceeds max supply");
1291         require(publicSale, "Public sale not active");
1292         require(xmfers.balanceOf(_caller) > 0, "Non believer");
1293         require(petTypeAvailableToMint[_typeOfPet], "Not allowed to mint this type of pet");
1294         require(hodlersMinted[saleID][_caller] + _amountToMint <= MAX_PER_WALLET_PUBLIC, "Not allow to mint more");
1295         require(_amountToMint > 0, "Not 0 mints");
1296         require(tx.origin == _caller, "No contracts");
1297         require(_amountToMint * holders_price == msg.value, "Invalid funds provided");
1298 
1299         hodlersMinted[saleID][_caller] += _amountToMint;
1300         unchecked { _publicSupply += _amountToMint; }
1301         for (uint256 i; i < _amountToMint; i++) {
1302             if(_typeOfPet > 0){
1303                 petAsignToTokenID[_totalSupply.current()] = _typeOfPet;
1304             }
1305             _safeMint(_caller, _totalSupply.current());
1306             _totalSupply.increment();
1307         }
1308     }
1309 
1310     function mint(uint256 _amountToMint, uint256 _typeOfPet) external payable {
1311         address _caller = _msgSender();
1312         require(MAX_SUPPLY_PUBLIC >= _publicSupply + _amountToMint, "Exceeds max supply");
1313         require(publicSale, "Public sale not active");
1314         require(petTypeAvailableToMint[_typeOfPet], "Not allowed to mint this type of pet");
1315         require(walletsMinted[saleID][_caller] + _amountToMint <= MAX_PER_WALLET_PUBLIC, "Not allow to mint more");
1316         require(_amountToMint > 0, "Not 0 mints");
1317         require(tx.origin == _caller, "No contracts");
1318         require(_amountToMint * price == msg.value, "Invalid funds provided");
1319 
1320         walletsMinted[saleID][_caller] += _amountToMint;
1321         unchecked { _publicSupply += _amountToMint; }
1322         for (uint256 i; i < _amountToMint; i++) {
1323             if(_typeOfPet > 0){
1324                 petAsignToTokenID[_totalSupply.current()] = _typeOfPet;
1325             }
1326             _safeMint(_caller, _totalSupply.current());
1327             _totalSupply.increment();
1328         }
1329     }
1330 
1331     function isApprovedForAll(address owner, address operator)
1332         override
1333         public
1334         view
1335         returns (bool)
1336     {
1337         // Whitelist OpenSea proxy contract for easy trading.
1338         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1339         if (address(proxyRegistry.proxies(owner)) == operator) {
1340             return true;
1341         }
1342 
1343         return super.isApprovedForAll(owner, operator);
1344     }
1345 
1346     function withdraw() external onlyOwner {
1347         uint256 balance = address(this).balance;
1348         (bool success, ) = _msgSender().call{value: balance}("");
1349         require(success, "Failed to send");
1350     }
1351 
1352     function changeSupply(uint256 _MAX_SUPPLY) external onlyOwner {
1353         require(_MAX_SUPPLY >= _totalSupply.current(), "Cant put less supply");
1354         MAX_SUPPLY_PUBLIC = _MAX_SUPPLY;
1355     }
1356 
1357     function mintingOnes(uint256 _amountToMint) external onlyOwner {
1358         for (uint256 i; i < _amountToMint; i++) {
1359             _safeMint(_msgSender(), _totalSupply.current());
1360             _totalSupply.increment();
1361         }
1362     }
1363 
1364     function resetPublicSupplyCounter() external onlyOwner {
1365         _publicSupply = 0;
1366     }
1367 
1368     function setBaseURI(string memory baseURI_) external onlyOwner {
1369         baseURI = baseURI_;
1370     }
1371 
1372     function setContractURI(string memory _contractURI) external onlyOwner {
1373         contractURI = _contractURI;
1374     }
1375 
1376     function setRoot(bytes32 _merkleRoot) external onlyOwner {
1377         merkleRoot = _merkleRoot;
1378     }
1379 
1380     function setSaleID(uint256 _saleID) external onlyOwner {
1381         saleID = _saleID;
1382     }
1383 
1384     function setPrices(uint256 _price, uint256 _holders_price) external onlyOwner {
1385         price = _price;
1386         holders_price = _holders_price;
1387     }
1388 
1389     function setSaleState(bool _claimSale, bool _publicSale) external onlyOwner {
1390         claimSale = _claimSale;
1391         publicSale = _publicSale;
1392     }
1393 
1394     function setRevealState(bool _reveal) external onlyOwner {
1395         reveal = _reveal;
1396     }
1397 
1398     function setPetAvailabilityState(uint256 _typeOfPet, bool _available) external onlyOwner {
1399         petTypeAvailableToMint[_typeOfPet] = _available;
1400     }
1401 
1402     function totalSupply() external view returns (uint256) {
1403         return _totalSupply.current();
1404     }
1405 
1406     function publicSupply() external view returns (uint256) {
1407         return _publicSupply;
1408     }
1409 
1410     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1411         require(_exists(_tokenId), "Token does not exist.");
1412         return bytes(baseURI).length > 0 ? string(
1413             abi.encodePacked(
1414               baseURI,
1415               reveal ? Strings.toString(_tokenId) : string(abi.encodePacked(Strings.toString(petAsignToTokenID[_tokenId]), "_holder")),
1416               baseExtension
1417             )
1418         ) : "";
1419     }
1420 }
1421 
1422 contract OwnableDelegateProxy { }
1423 contract ProxyRegistry {
1424     mapping(address => OwnableDelegateProxy) public proxies;
1425 }