1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
79      */
80     function toString(uint256 value) internal pure returns (string memory) {
81         // Inspired by OraclizeAPI's implementation - MIT licence
82         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
83 
84         if (value == 0) {
85             return "0";
86         }
87         uint256 temp = value;
88         uint256 digits;
89         while (temp != 0) {
90             digits++;
91             temp /= 10;
92         }
93         bytes memory buffer = new bytes(digits);
94         while (value != 0) {
95             digits -= 1;
96             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
97             value /= 10;
98         }
99         return string(buffer);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
104      */
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
120      */
121     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
122         bytes memory buffer = new bytes(2 * length + 2);
123         buffer[0] = "0";
124         buffer[1] = "x";
125         for (uint256 i = 2 * length + 1; i > 1; --i) {
126             buffer[i] = _HEX_SYMBOLS[value & 0xf];
127             value >>= 4;
128         }
129         require(value == 0, "Strings: hex length insufficient");
130         return string(buffer);
131     }
132 }
133 
134 // File: @openzeppelin/contracts/utils/Address.sol
135 
136 
137 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
138 
139 pragma solidity ^0.8.1;
140 
141 /**
142  * @dev Collection of functions related to the address type
143  */
144 library Address {
145     /**
146      * @dev Returns true if `account` is a contract.
147      *
148      * [IMPORTANT]
149      * ====
150      * It is unsafe to assume that an address for which this function returns
151      * false is an externally-owned account (EOA) and not a contract.
152      *
153      * Among others, `isContract` will return false for the following
154      * types of addresses:
155      *
156      *  - an externally-owned account
157      *  - a contract in construction
158      *  - an address where a contract will be created
159      *  - an address where a contract lived, but was destroyed
160      * ====
161      *
162      * [IMPORTANT]
163      * ====
164      * You shouldn't rely on `isContract` to protect against flash loan attacks!
165      *
166      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
167      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
168      * constructor.
169      * ====
170      */
171     function isContract(address account) internal view returns (bool) {
172         // This method relies on extcodesize/address.code.length, which returns 0
173         // for contracts in construction, since the code is only stored at the end
174         // of the constructor execution.
175 
176         return account.code.length > 0;
177     }
178 
179     /**
180      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
181      * `recipient`, forwarding all available gas and reverting on errors.
182      *
183      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
184      * of certain opcodes, possibly making contracts go over the 2300 gas limit
185      * imposed by `transfer`, making them unable to receive funds via
186      * `transfer`. {sendValue} removes this limitation.
187      *
188      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
189      *
190      * IMPORTANT: because control is transferred to `recipient`, care must be
191      * taken to not create reentrancy vulnerabilities. Consider using
192      * {ReentrancyGuard} or the
193      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
194      */
195     function sendValue(address payable recipient, uint256 amount) internal {
196         require(address(this).balance >= amount, "Address: insufficient balance");
197 
198         (bool success, ) = recipient.call{value: amount}("");
199         require(success, "Address: unable to send value, recipient may have reverted");
200     }
201 
202     /**
203      * @dev Performs a Solidity function call using a low level `call`. A
204      * plain `call` is an unsafe replacement for a function call: use this
205      * function instead.
206      *
207      * If `target` reverts with a revert reason, it is bubbled up by this
208      * function (like regular Solidity function calls).
209      *
210      * Returns the raw returned data. To convert to the expected return value,
211      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
212      *
213      * Requirements:
214      *
215      * - `target` must be a contract.
216      * - calling `target` with `data` must not revert.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
221         return functionCall(target, data, "Address: low-level call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
226      * `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         return functionCallWithValue(target, data, 0, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but also transferring `value` wei to `target`.
241      *
242      * Requirements:
243      *
244      * - the calling contract must have an ETH balance of at least `value`.
245      * - the called Solidity function must be `payable`.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value
253     ) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
259      * with `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCallWithValue(
264         address target,
265         bytes memory data,
266         uint256 value,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(address(this).balance >= value, "Address: insufficient balance for call");
270         require(isContract(target), "Address: call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.call{value: value}(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
283         return functionStaticCall(target, data, "Address: low-level static call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a static call.
289      *
290      * _Available since v3.3._
291      */
292     function functionStaticCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal view returns (bytes memory) {
297         require(isContract(target), "Address: static call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a delegate call.
316      *
317      * _Available since v3.4._
318      */
319     function functionDelegateCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         require(isContract(target), "Address: delegate call to non-contract");
325 
326         (bool success, bytes memory returndata) = target.delegatecall(data);
327         return verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
332      * revert reason using the provided one.
333      *
334      * _Available since v4.3._
335      */
336     function verifyCallResult(
337         bool success,
338         bytes memory returndata,
339         string memory errorMessage
340     ) internal pure returns (bytes memory) {
341         if (success) {
342             return returndata;
343         } else {
344             // Look for revert reason and bubble it up if present
345             if (returndata.length > 0) {
346                 // The easiest way to bubble the revert reason is using memory via assembly
347 
348                 assembly {
349                     let returndata_size := mload(returndata)
350                     revert(add(32, returndata), returndata_size)
351                 }
352             } else {
353                 revert(errorMessage);
354             }
355         }
356     }
357 }
358 
359 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @title ERC721 token receiver interface
368  * @dev Interface for any contract that wants to support safeTransfers
369  * from ERC721 asset contracts.
370  */
371 interface IERC721Receiver {
372     /**
373      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
374      * by `operator` from `from`, this function is called.
375      *
376      * It must return its Solidity selector to confirm the token transfer.
377      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
378      *
379      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
380      */
381     function onERC721Received(
382         address operator,
383         address from,
384         uint256 tokenId,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Interface of the ERC165 standard, as defined in the
398  * https://eips.ethereum.org/EIPS/eip-165[EIP].
399  *
400  * Implementers can declare support of contract interfaces, which can then be
401  * queried by others ({ERC165Checker}).
402  *
403  * For an implementation, see {ERC165}.
404  */
405 interface IERC165 {
406     /**
407      * @dev Returns true if this contract implements the interface defined by
408      * `interfaceId`. See the corresponding
409      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
410      * to learn more about how these ids are created.
411      *
412      * This function call must use less than 30 000 gas.
413      */
414     function supportsInterface(bytes4 interfaceId) external view returns (bool);
415 }
416 
417 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
418 
419 
420 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 
425 /**
426  * @dev Implementation of the {IERC165} interface.
427  *
428  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
429  * for the additional interface id that will be supported. For example:
430  *
431  * ```solidity
432  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
433  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
434  * }
435  * ```
436  *
437  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
438  */
439 abstract contract ERC165 is IERC165 {
440     /**
441      * @dev See {IERC165-supportsInterface}.
442      */
443     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
444         return interfaceId == type(IERC165).interfaceId;
445     }
446 }
447 
448 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 
456 /**
457  * @dev Required interface of an ERC721 compliant contract.
458  */
459 interface IERC721 is IERC165 {
460     /**
461      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
462      */
463     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
464 
465     /**
466      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
467      */
468     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
469 
470     /**
471      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
472      */
473     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
474 
475     /**
476      * @dev Returns the number of tokens in ``owner``'s account.
477      */
478     function balanceOf(address owner) external view returns (uint256 balance);
479 
480     /**
481      * @dev Returns the owner of the `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function ownerOf(uint256 tokenId) external view returns (address owner);
488 
489     /**
490      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
491      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function safeTransferFrom(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external;
508 
509     /**
510      * @dev Transfers `tokenId` token from `from` to `to`.
511      *
512      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must be owned by `from`.
519      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
520      *
521      * Emits a {Transfer} event.
522      */
523     function transferFrom(
524         address from,
525         address to,
526         uint256 tokenId
527     ) external;
528 
529     /**
530      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
531      * The approval is cleared when the token is transferred.
532      *
533      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
534      *
535      * Requirements:
536      *
537      * - The caller must own the token or be an approved operator.
538      * - `tokenId` must exist.
539      *
540      * Emits an {Approval} event.
541      */
542     function approve(address to, uint256 tokenId) external;
543 
544     /**
545      * @dev Returns the account approved for `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function getApproved(uint256 tokenId) external view returns (address operator);
552 
553     /**
554      * @dev Approve or remove `operator` as an operator for the caller.
555      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
556      *
557      * Requirements:
558      *
559      * - The `operator` cannot be the caller.
560      *
561      * Emits an {ApprovalForAll} event.
562      */
563     function setApprovalForAll(address operator, bool _approved) external;
564 
565     /**
566      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
567      *
568      * See {setApprovalForAll}
569      */
570     function isApprovedForAll(address owner, address operator) external view returns (bool);
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId,
589         bytes calldata data
590     ) external;
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
603  * @dev See https://eips.ethereum.org/EIPS/eip-721
604  */
605 interface IERC721Metadata is IERC721 {
606     /**
607      * @dev Returns the token collection name.
608      */
609     function name() external view returns (string memory);
610 
611     /**
612      * @dev Returns the token collection symbol.
613      */
614     function symbol() external view returns (string memory);
615 
616     /**
617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
618      */
619     function tokenURI(uint256 tokenId) external view returns (string memory);
620 }
621 
622 // File: @openzeppelin/contracts/utils/Context.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Provides information about the current execution context, including the
631  * sender of the transaction and its data. While these are generally available
632  * via msg.sender and msg.data, they should not be accessed in such a direct
633  * manner, since when dealing with meta-transactions the account sending and
634  * paying for execution may not be the actual sender (as far as an application
635  * is concerned).
636  *
637  * This contract is only required for intermediate, library-like contracts.
638  */
639 abstract contract Context {
640     function _msgSender() internal view virtual returns (address) {
641         return msg.sender;
642     }
643 
644     function _msgData() internal view virtual returns (bytes calldata) {
645         return msg.data;
646     }
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
650 
651 
652 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 
657 
658 
659 
660 
661 
662 
663 /**
664  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
665  * the Metadata extension, but not including the Enumerable extension, which is available separately as
666  * {ERC721Enumerable}.
667  */
668 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
669     using Address for address;
670     using Strings for uint256;
671 
672     // Token name
673     string private _name;
674 
675     // Token symbol
676     string private _symbol;
677 
678     // Mapping from token ID to owner address
679     mapping(uint256 => address) private _owners;
680 
681     // Mapping owner address to token count
682     mapping(address => uint256) private _balances;
683 
684     // Mapping from token ID to approved address
685     mapping(uint256 => address) private _tokenApprovals;
686 
687     // Mapping from owner to operator approvals
688     mapping(address => mapping(address => bool)) private _operatorApprovals;
689 
690     /**
691      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
692      */
693     constructor(string memory name_, string memory symbol_) {
694         _name = name_;
695         _symbol = symbol_;
696     }
697 
698     /**
699      * @dev See {IERC165-supportsInterface}.
700      */
701     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
702         return
703             interfaceId == type(IERC721).interfaceId ||
704             interfaceId == type(IERC721Metadata).interfaceId ||
705             super.supportsInterface(interfaceId);
706     }
707 
708     /**
709      * @dev See {IERC721-balanceOf}.
710      */
711     function balanceOf(address owner) public view virtual override returns (uint256) {
712         require(owner != address(0), "ERC721: balance query for the zero address");
713         return _balances[owner];
714     }
715 
716     /**
717      * @dev See {IERC721-ownerOf}.
718      */
719     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
720         address owner = _owners[tokenId];
721         require(owner != address(0), "ERC721: owner query for nonexistent token");
722         return owner;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-name}.
727      */
728     function name() public view virtual override returns (string memory) {
729         return _name;
730     }
731 
732     /**
733      * @dev See {IERC721Metadata-symbol}.
734      */
735     function symbol() public view virtual override returns (string memory) {
736         return _symbol;
737     }
738 
739     /**
740      * @dev See {IERC721Metadata-tokenURI}.
741      */
742     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
743         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
744 
745         string memory baseURI = _baseURI();
746         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
747     }
748 
749     /**
750      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
751      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
752      * by default, can be overriden in child contracts.
753      */
754     function _baseURI() internal view virtual returns (string memory) {
755         return "";
756     }
757 
758     /**
759      * @dev See {IERC721-approve}.
760      */
761     function approve(address to, uint256 tokenId) public virtual override {
762         address owner = ERC721.ownerOf(tokenId);
763         require(to != owner, "ERC721: approval to current owner");
764 
765         require(
766             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
767             "ERC721: approve caller is not owner nor approved for all"
768         );
769 
770         _approve(to, tokenId);
771     }
772 
773     /**
774      * @dev See {IERC721-getApproved}.
775      */
776     function getApproved(uint256 tokenId) public view virtual override returns (address) {
777         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
778 
779         return _tokenApprovals[tokenId];
780     }
781 
782     /**
783      * @dev See {IERC721-setApprovalForAll}.
784      */
785     function setApprovalForAll(address operator, bool approved) public virtual override {
786         _setApprovalForAll(_msgSender(), operator, approved);
787     }
788 
789     /**
790      * @dev See {IERC721-isApprovedForAll}.
791      */
792     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
793         return _operatorApprovals[owner][operator];
794     }
795 
796     /**
797      * @dev See {IERC721-transferFrom}.
798      */
799     function transferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) public virtual override {
804         //solhint-disable-next-line max-line-length
805         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
806 
807         _transfer(from, to, tokenId);
808     }
809 
810     /**
811      * @dev See {IERC721-safeTransferFrom}.
812      */
813     function safeTransferFrom(
814         address from,
815         address to,
816         uint256 tokenId
817     ) public virtual override {
818         safeTransferFrom(from, to, tokenId, "");
819     }
820 
821     /**
822      * @dev See {IERC721-safeTransferFrom}.
823      */
824     function safeTransferFrom(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) public virtual override {
830         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
831         _safeTransfer(from, to, tokenId, _data);
832     }
833 
834     /**
835      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
836      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
837      *
838      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
839      *
840      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
841      * implement alternative mechanisms to perform token transfer, such as signature-based.
842      *
843      * Requirements:
844      *
845      * - `from` cannot be the zero address.
846      * - `to` cannot be the zero address.
847      * - `tokenId` token must exist and be owned by `from`.
848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _safeTransfer(
853         address from,
854         address to,
855         uint256 tokenId,
856         bytes memory _data
857     ) internal virtual {
858         _transfer(from, to, tokenId);
859         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
860     }
861 
862     /**
863      * @dev Returns whether `tokenId` exists.
864      *
865      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
866      *
867      * Tokens start existing when they are minted (`_mint`),
868      * and stop existing when they are burned (`_burn`).
869      */
870     function _exists(uint256 tokenId) internal view virtual returns (bool) {
871         return _owners[tokenId] != address(0);
872     }
873 
874     /**
875      * @dev Returns whether `spender` is allowed to manage `tokenId`.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must exist.
880      */
881     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
882         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
883         address owner = ERC721.ownerOf(tokenId);
884         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
885     }
886 
887     /**
888      * @dev Safely mints `tokenId` and transfers it to `to`.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must not exist.
893      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
894      *
895      * Emits a {Transfer} event.
896      */
897     function _safeMint(address to, uint256 tokenId) internal virtual {
898         _safeMint(to, tokenId, "");
899     }
900 
901     /**
902      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
903      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
904      */
905     function _safeMint(
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) internal virtual {
910         _mint(to, tokenId);
911         require(
912             _checkOnERC721Received(address(0), to, tokenId, _data),
913             "ERC721: transfer to non ERC721Receiver implementer"
914         );
915     }
916 
917     /**
918      * @dev Mints `tokenId` and transfers it to `to`.
919      *
920      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
921      *
922      * Requirements:
923      *
924      * - `tokenId` must not exist.
925      * - `to` cannot be the zero address.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _mint(address to, uint256 tokenId) internal virtual {
930         require(to != address(0), "ERC721: mint to the zero address");
931         require(!_exists(tokenId), "ERC721: token already minted");
932 
933         _beforeTokenTransfer(address(0), to, tokenId);
934 
935         _balances[to] += 1;
936         _owners[tokenId] = to;
937 
938         emit Transfer(address(0), to, tokenId);
939 
940         _afterTokenTransfer(address(0), to, tokenId);
941     }
942 
943     /**
944      * @dev Destroys `tokenId`.
945      * The approval is cleared when the token is burned.
946      *
947      * Requirements:
948      *
949      * - `tokenId` must exist.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _burn(uint256 tokenId) internal virtual {
954         address owner = ERC721.ownerOf(tokenId);
955 
956         _beforeTokenTransfer(owner, address(0), tokenId);
957 
958         // Clear approvals
959         _approve(address(0), tokenId);
960 
961         _balances[owner] -= 1;
962         delete _owners[tokenId];
963 
964         emit Transfer(owner, address(0), tokenId);
965 
966         _afterTokenTransfer(owner, address(0), tokenId);
967     }
968 
969     /**
970      * @dev Transfers `tokenId` from `from` to `to`.
971      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
972      *
973      * Requirements:
974      *
975      * - `to` cannot be the zero address.
976      * - `tokenId` token must be owned by `from`.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _transfer(
981         address from,
982         address to,
983         uint256 tokenId
984     ) internal virtual {
985         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
986         require(to != address(0), "ERC721: transfer to the zero address");
987 
988         _beforeTokenTransfer(from, to, tokenId);
989 
990         // Clear approvals from the previous owner
991         _approve(address(0), tokenId);
992 
993         _balances[from] -= 1;
994         _balances[to] += 1;
995         _owners[tokenId] = to;
996 
997         emit Transfer(from, to, tokenId);
998 
999         _afterTokenTransfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev Approve `to` to operate on `tokenId`
1004      *
1005      * Emits a {Approval} event.
1006      */
1007     function _approve(address to, uint256 tokenId) internal virtual {
1008         _tokenApprovals[tokenId] = to;
1009         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Approve `operator` to operate on all of `owner` tokens
1014      *
1015      * Emits a {ApprovalForAll} event.
1016      */
1017     function _setApprovalForAll(
1018         address owner,
1019         address operator,
1020         bool approved
1021     ) internal virtual {
1022         require(owner != operator, "ERC721: approve to caller");
1023         _operatorApprovals[owner][operator] = approved;
1024         emit ApprovalForAll(owner, operator, approved);
1025     }
1026 
1027     /**
1028      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1029      * The call is not executed if the target address is not a contract.
1030      *
1031      * @param from address representing the previous owner of the given token ID
1032      * @param to target address that will receive the tokens
1033      * @param tokenId uint256 ID of the token to be transferred
1034      * @param _data bytes optional data to send along with the call
1035      * @return bool whether the call correctly returned the expected magic value
1036      */
1037     function _checkOnERC721Received(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) private returns (bool) {
1043         if (to.isContract()) {
1044             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1045                 return retval == IERC721Receiver.onERC721Received.selector;
1046             } catch (bytes memory reason) {
1047                 if (reason.length == 0) {
1048                     revert("ERC721: transfer to non ERC721Receiver implementer");
1049                 } else {
1050                     assembly {
1051                         revert(add(32, reason), mload(reason))
1052                     }
1053                 }
1054             }
1055         } else {
1056             return true;
1057         }
1058     }
1059 
1060     /**
1061      * @dev Hook that is called before any token transfer. This includes minting
1062      * and burning.
1063      *
1064      * Calling conditions:
1065      *
1066      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1067      * transferred to `to`.
1068      * - When `from` is zero, `tokenId` will be minted for `to`.
1069      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1070      * - `from` and `to` are never both zero.
1071      *
1072      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1073      */
1074     function _beforeTokenTransfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) internal virtual {}
1079 
1080     /**
1081      * @dev Hook that is called after any transfer of tokens. This includes
1082      * minting and burning.
1083      *
1084      * Calling conditions:
1085      *
1086      * - when `from` and `to` are both non-zero.
1087      * - `from` and `to` are never both zero.
1088      *
1089      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1090      */
1091     function _afterTokenTransfer(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) internal virtual {}
1096 }
1097 
1098 // File: @openzeppelin/contracts/access/Ownable.sol
1099 
1100 
1101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 
1106 /**
1107  * @dev Contract module which provides a basic access control mechanism, where
1108  * there is an account (an owner) that can be granted exclusive access to
1109  * specific functions.
1110  *
1111  * By default, the owner account will be the one that deploys the contract. This
1112  * can later be changed with {transferOwnership}.
1113  *
1114  * This module is used through inheritance. It will make available the modifier
1115  * `onlyOwner`, which can be applied to your functions to restrict their use to
1116  * the owner.
1117  */
1118 abstract contract Ownable is Context {
1119     address private _owner;
1120 
1121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1122 
1123     /**
1124      * @dev Initializes the contract setting the deployer as the initial owner.
1125      */
1126     constructor() {
1127         _transferOwnership(_msgSender());
1128     }
1129 
1130     /**
1131      * @dev Returns the address of the current owner.
1132      */
1133     function owner() public view virtual returns (address) {
1134         return _owner;
1135     }
1136 
1137     /**
1138      * @dev Throws if called by any account other than the owner.
1139      */
1140     modifier onlyOwner() {
1141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1142         _;
1143     }
1144 
1145     /**
1146      * @dev Leaves the contract without owner. It will not be possible to call
1147      * `onlyOwner` functions anymore. Can only be called by the current owner.
1148      *
1149      * NOTE: Renouncing ownership will leave the contract without an owner,
1150      * thereby removing any functionality that is only available to the owner.
1151      */
1152     function renounceOwnership() public virtual onlyOwner {
1153         _transferOwnership(address(0));
1154     }
1155 
1156     /**
1157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1158      * Can only be called by the current owner.
1159      */
1160     function transferOwnership(address newOwner) public virtual onlyOwner {
1161         require(newOwner != address(0), "Ownable: new owner is the zero address");
1162         _transferOwnership(newOwner);
1163     }
1164 
1165     /**
1166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1167      * Internal function without access restriction.
1168      */
1169     function _transferOwnership(address newOwner) internal virtual {
1170         address oldOwner = _owner;
1171         _owner = newOwner;
1172         emit OwnershipTransferred(oldOwner, newOwner);
1173     }
1174 }
1175 
1176 // File: contracts/Production.sol
1177 
1178 
1179 pragma solidity ^0.8.7;
1180 
1181 /**
1182  * @dev Modifier 'onlyOwner' becomes available, where owner is the contract deployer
1183  */
1184 
1185 
1186 /**
1187  * @dev ERC721 token standard
1188  */
1189 
1190 
1191 
1192 /**
1193  * @dev Merkle tree
1194  */
1195 
1196 
1197 
1198 // change contract name
1199 contract ForeverBots is Ownable, ERC721 { 
1200 
1201   
1202     uint256 public totalSupply;
1203     uint256 public maxSupply = 5000;
1204 
1205     uint256 public cost = 0.15 ether;
1206     uint256 public mintsPerWallet = 1;
1207 
1208     bool public preSaleStatus;
1209     bool public publicSaleStatus;
1210 
1211     string public baseTokenURI;
1212 
1213     bytes32 public root;
1214     
1215 
1216     constructor( 
1217         string memory _preRevealURI
1218     ) ERC721("ForeverBots", "BOTS") { 
1219         baseTokenURI = _preRevealURI;
1220     }
1221     
1222     
1223     // --- EVENTS --- //
1224     
1225     event TokenMinted(uint256 tokenId, address indexed recipient);
1226 
1227 
1228     // --- MAPPINGS --- //
1229 
1230     mapping(address => uint) public hasMinted;
1231         
1232     
1233     // --- PUBLIC --- //
1234     
1235     
1236     /**
1237      * @dev Mint tokens through public sale
1238      */
1239     function mint(uint _amount) external payable returns(bool) {
1240     
1241         require(publicSaleStatus, "Public sale not live");
1242         require(hasMinted[msg.sender] + _amount <= mintsPerWallet, "Would exceed mints per wallet limit");
1243         require(msg.value == cost * _amount, "Incorrect funds supplied"); // mint cost
1244         require(totalSupply + _amount <= maxSupply, "All tokens have been minted");
1245         
1246         mintAmount(msg.sender, _amount);
1247         return true;
1248     }
1249 
1250     /**
1251      * @dev Mint tokens through pre sale
1252      */
1253     function whitelistMint(uint _amount, bytes32[] memory _proof) external payable returns(bool) {
1254 
1255         require(hasMinted[msg.sender] + _amount <= mintsPerWallet, "Would exceed mints per wallet limit");
1256         require(msg.value == cost * _amount, "Incorrect funds supplied"); // mint cost
1257         require(totalSupply + _amount <= maxSupply, "All tokens have been minted");
1258         require(preSaleStatus, "Presale not live");
1259         require(MerkleProof.verify(_proof, root, keccak256(abi.encodePacked(msg.sender))) == true, "Not on whitelist");
1260 
1261         mintAmount(msg.sender, _amount);
1262         return true;
1263     }
1264     
1265 
1266     // --- INTERNAL --- //
1267     
1268     function mintAmount(address _user, uint _amount) internal {
1269         hasMinted[_user] += _amount;
1270         for (uint i=0; i<_amount; i++) {
1271             uint tokenId = totalSupply + (i+1);
1272             _mint(_user, tokenId);
1273             emit TokenMinted(tokenId, _user);
1274         }
1275         totalSupply += _amount;
1276     }
1277     
1278     
1279     // --- VIEW --- //
1280     
1281     
1282     /**
1283      * @dev Returns tokenURI, which, if revealedStatus = true, is comprised of the baseURI concatenated with the tokenId
1284      */
1285     function tokenURI(uint256 _tokenId) public view override returns(string memory) {
1286 
1287         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1288 
1289         return string(abi.encodePacked(baseTokenURI, Strings.toString(_tokenId), ".json"));
1290     }
1291 
1292 
1293     /**
1294      * @dev Returns boolean of whether '_address' has minted
1295      */
1296     function hasMintedGetter(address _address) external view returns(uint) {
1297         return hasMinted[_address];
1298     }
1299 
1300 
1301 
1302     // --- ONLY OWNER ---
1303 
1304     
1305     /**
1306      * @dev Withdraw all ether from smart contract. Only contract owner can call.
1307      * @param _to - address ether will be sent to
1308      */
1309     function withdrawAllFunds(address payable _to) external onlyOwner {
1310         require(address(this).balance > 0, "No funds to withdraw");
1311         _to.transfer(address(this).balance);
1312     }
1313 
1314     /**
1315      * @dev Set the baseURI string.
1316      * @param _newBaseUri - new base URI of metadata (Example:   ipfs://cid/)
1317      */
1318     function setBaseUri(string memory _newBaseUri) external onlyOwner {
1319         baseTokenURI = _newBaseUri;
1320     }
1321     
1322     
1323     /**
1324      * @dev Set the cost of minting a token
1325      * @param _newCost in Wei. Where 1 Wei = 10^-18 ether
1326      */
1327     function setCost(uint _newCost) external onlyOwner {
1328         cost = _newCost;
1329     }
1330 
1331     /**
1332      * @dev Set the number of mints per wallet
1333      */
1334     function setMintsPerWallet(uint _newMintsPerWallet) external onlyOwner {
1335         mintsPerWallet = _newMintsPerWallet;
1336     }
1337     
1338     
1339     /**
1340      * @dev Set the status of the pre sale.
1341      */
1342     function setPreSaleStatus(bool _status) external onlyOwner {
1343         preSaleStatus = _status;
1344     }
1345     
1346     
1347     /**
1348      * @dev Set the status of the public sale.
1349      */
1350     function setPublicSaleStatus(bool _status) external onlyOwner {
1351         publicSaleStatus = _status;
1352     }
1353 
1354 
1355     /**
1356      * @dev Set the root for Merkle Proof
1357      */
1358     function setRoot(bytes32 _newRoot) external onlyOwner {
1359         root = _newRoot;
1360     }
1361 
1362 
1363     /**
1364      * @dev Airdrop 1 token to each address in array '_to'
1365      * @param _to - array of address' that tokens will be sent to
1366      */
1367     function airDrop(address[] calldata _to) external onlyOwner {
1368 
1369         require(totalSupply + _to.length <= maxSupply, "Minting this many would exceed the max supply");
1370 
1371         for (uint i=0; i<_to.length; i++) {
1372             uint tokenId = totalSupply + 1;
1373             totalSupply++;
1374             _mint(_to[i], tokenId);
1375             emit TokenMinted(tokenId, _to[i]);
1376         }
1377     }
1378 
1379     
1380 }