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
134 // File: @openzeppelin/contracts/utils/Context.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Provides information about the current execution context, including the
143  * sender of the transaction and its data. While these are generally available
144  * via msg.sender and msg.data, they should not be accessed in such a direct
145  * manner, since when dealing with meta-transactions the account sending and
146  * paying for execution may not be the actual sender (as far as an application
147  * is concerned).
148  *
149  * This contract is only required for intermediate, library-like contracts.
150  */
151 abstract contract Context {
152     function _msgSender() internal view virtual returns (address) {
153         return msg.sender;
154     }
155 
156     function _msgData() internal view virtual returns (bytes calldata) {
157         return msg.data;
158     }
159 }
160 
161 // File: @openzeppelin/contracts/access/Ownable.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 
169 /**
170  * @dev Contract module which provides a basic access control mechanism, where
171  * there is an account (an owner) that can be granted exclusive access to
172  * specific functions.
173  *
174  * By default, the owner account will be the one that deploys the contract. This
175  * can later be changed with {transferOwnership}.
176  *
177  * This module is used through inheritance. It will make available the modifier
178  * `onlyOwner`, which can be applied to your functions to restrict their use to
179  * the owner.
180  */
181 abstract contract Ownable is Context {
182     address private _owner;
183 
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186     /**
187      * @dev Initializes the contract setting the deployer as the initial owner.
188      */
189     constructor() {
190         _transferOwnership(_msgSender());
191     }
192 
193     /**
194      * @dev Returns the address of the current owner.
195      */
196     function owner() public view virtual returns (address) {
197         return _owner;
198     }
199 
200     /**
201      * @dev Throws if called by any account other than the owner.
202      */
203     modifier onlyOwner() {
204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
205         _;
206     }
207 
208     /**
209      * @dev Leaves the contract without owner. It will not be possible to call
210      * `onlyOwner` functions anymore. Can only be called by the current owner.
211      *
212      * NOTE: Renouncing ownership will leave the contract without an owner,
213      * thereby removing any functionality that is only available to the owner.
214      */
215     function renounceOwnership() public virtual onlyOwner {
216         _transferOwnership(address(0));
217     }
218 
219     /**
220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
221      * Can only be called by the current owner.
222      */
223     function transferOwnership(address newOwner) public virtual onlyOwner {
224         require(newOwner != address(0), "Ownable: new owner is the zero address");
225         _transferOwnership(newOwner);
226     }
227 
228     /**
229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
230      * Internal function without access restriction.
231      */
232     function _transferOwnership(address newOwner) internal virtual {
233         address oldOwner = _owner;
234         _owner = newOwner;
235         emit OwnershipTransferred(oldOwner, newOwner);
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 
242 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
243 
244 pragma solidity ^0.8.1;
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
266      *
267      * [IMPORTANT]
268      * ====
269      * You shouldn't rely on `isContract` to protect against flash loan attacks!
270      *
271      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
272      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
273      * constructor.
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // This method relies on extcodesize/address.code.length, which returns 0
278         // for contracts in construction, since the code is only stored at the end
279         // of the constructor execution.
280 
281         return account.code.length > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         (bool success, ) = recipient.call{value: amount}("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain `call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but also transferring `value` wei to `target`.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least `value`.
350      * - the called Solidity function must be `payable`.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         require(isContract(target), "Address: call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.call{value: value}(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
388         return functionStaticCall(target, data, "Address: low-level static call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal view returns (bytes memory) {
402         require(isContract(target), "Address: static call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.staticcall(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
415         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(isContract(target), "Address: delegate call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.delegatecall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
437      * revert reason using the provided one.
438      *
439      * _Available since v4.3._
440      */
441     function verifyCallResult(
442         bool success,
443         bytes memory returndata,
444         string memory errorMessage
445     ) internal pure returns (bytes memory) {
446         if (success) {
447             return returndata;
448         } else {
449             // Look for revert reason and bubble it up if present
450             if (returndata.length > 0) {
451                 // The easiest way to bubble the revert reason is using memory via assembly
452 
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @title ERC721 token receiver interface
473  * @dev Interface for any contract that wants to support safeTransfers
474  * from ERC721 asset contracts.
475  */
476 interface IERC721Receiver {
477     /**
478      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
479      * by `operator` from `from`, this function is called.
480      *
481      * It must return its Solidity selector to confirm the token transfer.
482      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
483      *
484      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
485      */
486     function onERC721Received(
487         address operator,
488         address from,
489         uint256 tokenId,
490         bytes calldata data
491     ) external returns (bytes4);
492 }
493 
494 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Interface of the ERC165 standard, as defined in the
503  * https://eips.ethereum.org/EIPS/eip-165[EIP].
504  *
505  * Implementers can declare support of contract interfaces, which can then be
506  * queried by others ({ERC165Checker}).
507  *
508  * For an implementation, see {ERC165}.
509  */
510 interface IERC165 {
511     /**
512      * @dev Returns true if this contract implements the interface defined by
513      * `interfaceId`. See the corresponding
514      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
515      * to learn more about how these ids are created.
516      *
517      * This function call must use less than 30 000 gas.
518      */
519     function supportsInterface(bytes4 interfaceId) external view returns (bool);
520 }
521 
522 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Implementation of the {IERC165} interface.
532  *
533  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
534  * for the additional interface id that will be supported. For example:
535  *
536  * ```solidity
537  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
539  * }
540  * ```
541  *
542  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
543  */
544 abstract contract ERC165 is IERC165 {
545     /**
546      * @dev See {IERC165-supportsInterface}.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549         return interfaceId == type(IERC165).interfaceId;
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @dev Required interface of an ERC721 compliant contract.
563  */
564 interface IERC721 is IERC165 {
565     /**
566      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
567      */
568     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
569 
570     /**
571      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
572      */
573     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
574 
575     /**
576      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
577      */
578     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
579 
580     /**
581      * @dev Returns the number of tokens in ``owner``'s account.
582      */
583     function balanceOf(address owner) external view returns (uint256 balance);
584 
585     /**
586      * @dev Returns the owner of the `tokenId` token.
587      *
588      * Requirements:
589      *
590      * - `tokenId` must exist.
591      */
592     function ownerOf(uint256 tokenId) external view returns (address owner);
593 
594     /**
595      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
596      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must exist and be owned by `from`.
603      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
604      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
605      *
606      * Emits a {Transfer} event.
607      */
608     function safeTransferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) external;
613 
614     /**
615      * @dev Transfers `tokenId` token from `from` to `to`.
616      *
617      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must be owned by `from`.
624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      *
626      * Emits a {Transfer} event.
627      */
628     function transferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
636      * The approval is cleared when the token is transferred.
637      *
638      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
639      *
640      * Requirements:
641      *
642      * - The caller must own the token or be an approved operator.
643      * - `tokenId` must exist.
644      *
645      * Emits an {Approval} event.
646      */
647     function approve(address to, uint256 tokenId) external;
648 
649     /**
650      * @dev Returns the account approved for `tokenId` token.
651      *
652      * Requirements:
653      *
654      * - `tokenId` must exist.
655      */
656     function getApproved(uint256 tokenId) external view returns (address operator);
657 
658     /**
659      * @dev Approve or remove `operator` as an operator for the caller.
660      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
661      *
662      * Requirements:
663      *
664      * - The `operator` cannot be the caller.
665      *
666      * Emits an {ApprovalForAll} event.
667      */
668     function setApprovalForAll(address operator, bool _approved) external;
669 
670     /**
671      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
672      *
673      * See {setApprovalForAll}
674      */
675     function isApprovedForAll(address owner, address operator) external view returns (bool);
676 
677     /**
678      * @dev Safely transfers `tokenId` token from `from` to `to`.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must exist and be owned by `from`.
685      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
687      *
688      * Emits a {Transfer} event.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId,
694         bytes calldata data
695     ) external;
696 }
697 
698 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
708  * @dev See https://eips.ethereum.org/EIPS/eip-721
709  */
710 interface IERC721Metadata is IERC721 {
711     /**
712      * @dev Returns the token collection name.
713      */
714     function name() external view returns (string memory);
715 
716     /**
717      * @dev Returns the token collection symbol.
718      */
719     function symbol() external view returns (string memory);
720 
721     /**
722      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
723      */
724     function tokenURI(uint256 tokenId) external view returns (string memory);
725 }
726 
727 // File: erc721a@3.3.0/contracts/IERC721A.sol
728 
729 
730 // ERC721A Contracts v3.3.0
731 // Creator: Chiru Labs
732 
733 pragma solidity ^0.8.4;
734 
735 
736 
737 /**
738  * @dev Interface of an ERC721A compliant contract.
739  */
740 interface IERC721A is IERC721, IERC721Metadata {
741     /**
742      * The caller must own the token or be an approved operator.
743      */
744     error ApprovalCallerNotOwnerNorApproved();
745 
746     /**
747      * The token does not exist.
748      */
749     error ApprovalQueryForNonexistentToken();
750 
751     /**
752      * The caller cannot approve to their own address.
753      */
754     error ApproveToCaller();
755 
756     /**
757      * The caller cannot approve to the current owner.
758      */
759     error ApprovalToCurrentOwner();
760 
761     /**
762      * Cannot query the balance for the zero address.
763      */
764     error BalanceQueryForZeroAddress();
765 
766     /**
767      * Cannot mint to the zero address.
768      */
769     error MintToZeroAddress();
770 
771     /**
772      * The quantity of tokens minted must be more than zero.
773      */
774     error MintZeroQuantity();
775 
776     /**
777      * The token does not exist.
778      */
779     error OwnerQueryForNonexistentToken();
780 
781     /**
782      * The caller must own the token or be an approved operator.
783      */
784     error TransferCallerNotOwnerNorApproved();
785 
786     /**
787      * The token must be owned by `from`.
788      */
789     error TransferFromIncorrectOwner();
790 
791     /**
792      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
793      */
794     error TransferToNonERC721ReceiverImplementer();
795 
796     /**
797      * Cannot transfer to the zero address.
798      */
799     error TransferToZeroAddress();
800 
801     /**
802      * The token does not exist.
803      */
804     error URIQueryForNonexistentToken();
805 
806     // Compiler will pack this into a single 256bit word.
807     struct TokenOwnership {
808         // The address of the owner.
809         address addr;
810         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
811         uint64 startTimestamp;
812         // Whether the token has been burned.
813         bool burned;
814     }
815 
816     // Compiler will pack this into a single 256bit word.
817     struct AddressData {
818         // Realistically, 2**64-1 is more than enough.
819         uint64 balance;
820         // Keeps track of mint count with minimal overhead for tokenomics.
821         uint64 numberMinted;
822         // Keeps track of burn count with minimal overhead for tokenomics.
823         uint64 numberBurned;
824         // For miscellaneous variable(s) pertaining to the address
825         // (e.g. number of whitelist mint slots used).
826         // If there are multiple variables, please pack them into a uint64.
827         uint64 aux;
828     }
829 
830     /**
831      * @dev Returns the total amount of tokens stored by the contract.
832      * 
833      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
834      */
835     function totalSupply() external view returns (uint256);
836 }
837 
838 // File: erc721a@3.3.0/contracts/ERC721A.sol
839 
840 
841 // ERC721A Contracts v3.3.0
842 // Creator: Chiru Labs
843 
844 pragma solidity ^0.8.4;
845 
846 
847 
848 
849 
850 
851 
852 /**
853  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
854  * the Metadata extension. Built to optimize for lower gas during batch mints.
855  *
856  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
857  *
858  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
859  *
860  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
861  */
862 contract ERC721A is Context, ERC165, IERC721A {
863     using Address for address;
864     using Strings for uint256;
865 
866     // The tokenId of the next token to be minted.
867     uint256 internal _currentIndex;
868 
869     // The number of tokens burned.
870     uint256 internal _burnCounter;
871 
872     // Token name
873     string private _name;
874 
875     // Token symbol
876     string private _symbol;
877 
878     // Mapping from token ID to ownership details
879     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
880     mapping(uint256 => TokenOwnership) internal _ownerships;
881 
882     // Mapping owner address to address data
883     mapping(address => AddressData) private _addressData;
884 
885     // Mapping from token ID to approved address
886     mapping(uint256 => address) private _tokenApprovals;
887 
888     // Mapping from owner to operator approvals
889     mapping(address => mapping(address => bool)) private _operatorApprovals;
890 
891     constructor(string memory name_, string memory symbol_) {
892         _name = name_;
893         _symbol = symbol_;
894         _currentIndex = _startTokenId();
895     }
896 
897     /**
898      * To change the starting tokenId, please override this function.
899      */
900     function _startTokenId() internal view virtual returns (uint256) {
901         return 0;
902     }
903 
904     /**
905      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
906      */
907     function totalSupply() public view override returns (uint256) {
908         // Counter underflow is impossible as _burnCounter cannot be incremented
909         // more than _currentIndex - _startTokenId() times
910         unchecked {
911             return _currentIndex - _burnCounter - _startTokenId();
912         }
913     }
914 
915     /**
916      * Returns the total amount of tokens minted in the contract.
917      */
918     function _totalMinted() internal view returns (uint256) {
919         // Counter underflow is impossible as _currentIndex does not decrement,
920         // and it is initialized to _startTokenId()
921         unchecked {
922             return _currentIndex - _startTokenId();
923         }
924     }
925 
926     /**
927      * @dev See {IERC165-supportsInterface}.
928      */
929     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
930         return
931             interfaceId == type(IERC721).interfaceId ||
932             interfaceId == type(IERC721Metadata).interfaceId ||
933             super.supportsInterface(interfaceId);
934     }
935 
936     /**
937      * @dev See {IERC721-balanceOf}.
938      */
939     function balanceOf(address owner) public view override returns (uint256) {
940         if (owner == address(0)) revert BalanceQueryForZeroAddress();
941         return uint256(_addressData[owner].balance);
942     }
943 
944     /**
945      * Returns the number of tokens minted by `owner`.
946      */
947     function _numberMinted(address owner) internal view returns (uint256) {
948         return uint256(_addressData[owner].numberMinted);
949     }
950 
951     /**
952      * Returns the number of tokens burned by or on behalf of `owner`.
953      */
954     function _numberBurned(address owner) internal view returns (uint256) {
955         return uint256(_addressData[owner].numberBurned);
956     }
957 
958     /**
959      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
960      */
961     function _getAux(address owner) internal view returns (uint64) {
962         return _addressData[owner].aux;
963     }
964 
965     /**
966      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
967      * If there are multiple variables, please pack them into a uint64.
968      */
969     function _setAux(address owner, uint64 aux) internal {
970         _addressData[owner].aux = aux;
971     }
972 
973     /**
974      * Gas spent here starts off proportional to the maximum mint batch size.
975      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
976      */
977     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
978         uint256 curr = tokenId;
979 
980         unchecked {
981             if (_startTokenId() <= curr) if (curr < _currentIndex) {
982                 TokenOwnership memory ownership = _ownerships[curr];
983                 if (!ownership.burned) {
984                     if (ownership.addr != address(0)) {
985                         return ownership;
986                     }
987                     // Invariant:
988                     // There will always be an ownership that has an address and is not burned
989                     // before an ownership that does not have an address and is not burned.
990                     // Hence, curr will not underflow.
991                     while (true) {
992                         curr--;
993                         ownership = _ownerships[curr];
994                         if (ownership.addr != address(0)) {
995                             return ownership;
996                         }
997                     }
998                 }
999             }
1000         }
1001         revert OwnerQueryForNonexistentToken();
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-ownerOf}.
1006      */
1007     function ownerOf(uint256 tokenId) public view override returns (address) {
1008         return _ownershipOf(tokenId).addr;
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-name}.
1013      */
1014     function name() public view virtual override returns (string memory) {
1015         return _name;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-symbol}.
1020      */
1021     function symbol() public view virtual override returns (string memory) {
1022         return _symbol;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Metadata-tokenURI}.
1027      */
1028     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1029         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1030 
1031         string memory baseURI = _baseURI();
1032         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1033     }
1034 
1035     /**
1036      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1037      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1038      * by default, can be overriden in child contracts.
1039      */
1040     function _baseURI() internal view virtual returns (string memory) {
1041         return '';
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-approve}.
1046      */
1047     function approve(address to, uint256 tokenId) public override {
1048         address owner = ERC721A.ownerOf(tokenId);
1049         if (to == owner) revert ApprovalToCurrentOwner();
1050 
1051         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1052             revert ApprovalCallerNotOwnerNorApproved();
1053         }
1054 
1055         _approve(to, tokenId, owner);
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-getApproved}.
1060      */
1061     function getApproved(uint256 tokenId) public view override returns (address) {
1062         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1063 
1064         return _tokenApprovals[tokenId];
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-setApprovalForAll}.
1069      */
1070     function setApprovalForAll(address operator, bool approved) public virtual override {
1071         if (operator == _msgSender()) revert ApproveToCaller();
1072 
1073         _operatorApprovals[_msgSender()][operator] = approved;
1074         emit ApprovalForAll(_msgSender(), operator, approved);
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-isApprovedForAll}.
1079      */
1080     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1081         return _operatorApprovals[owner][operator];
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-transferFrom}.
1086      */
1087     function transferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) public virtual override {
1092         _transfer(from, to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-safeTransferFrom}.
1097      */
1098     function safeTransferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) public virtual override {
1103         safeTransferFrom(from, to, tokenId, '');
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-safeTransferFrom}.
1108      */
1109     function safeTransferFrom(
1110         address from,
1111         address to,
1112         uint256 tokenId,
1113         bytes memory _data
1114     ) public virtual override {
1115         _transfer(from, to, tokenId);
1116         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1117             revert TransferToNonERC721ReceiverImplementer();
1118         }
1119     }
1120 
1121     /**
1122      * @dev Returns whether `tokenId` exists.
1123      *
1124      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1125      *
1126      * Tokens start existing when they are minted (`_mint`),
1127      */
1128     function _exists(uint256 tokenId) internal view returns (bool) {
1129         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1130     }
1131 
1132     /**
1133      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1134      */
1135     function _safeMint(address to, uint256 quantity) internal {
1136         _safeMint(to, quantity, '');
1137     }
1138 
1139     /**
1140      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - If `to` refers to a smart contract, it must implement
1145      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _safeMint(
1151         address to,
1152         uint256 quantity,
1153         bytes memory _data
1154     ) internal {
1155         uint256 startTokenId = _currentIndex;
1156         if (to == address(0)) revert MintToZeroAddress();
1157         if (quantity == 0) revert MintZeroQuantity();
1158 
1159         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1160 
1161         // Overflows are incredibly unrealistic.
1162         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1163         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1164         unchecked {
1165             _addressData[to].balance += uint64(quantity);
1166             _addressData[to].numberMinted += uint64(quantity);
1167 
1168             _ownerships[startTokenId].addr = to;
1169             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1170 
1171             uint256 updatedIndex = startTokenId;
1172             uint256 end = updatedIndex + quantity;
1173 
1174             if (to.isContract()) {
1175                 do {
1176                     emit Transfer(address(0), to, updatedIndex);
1177                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1178                         revert TransferToNonERC721ReceiverImplementer();
1179                     }
1180                 } while (updatedIndex < end);
1181                 // Reentrancy protection
1182                 if (_currentIndex != startTokenId) revert();
1183             } else {
1184                 do {
1185                     emit Transfer(address(0), to, updatedIndex++);
1186                 } while (updatedIndex < end);
1187             }
1188             _currentIndex = updatedIndex;
1189         }
1190         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1191     }
1192 
1193     /**
1194      * @dev Mints `quantity` tokens and transfers them to `to`.
1195      *
1196      * Requirements:
1197      *
1198      * - `to` cannot be the zero address.
1199      * - `quantity` must be greater than 0.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function _mint(address to, uint256 quantity) internal {
1204         uint256 startTokenId = _currentIndex;
1205         if (to == address(0)) revert MintToZeroAddress();
1206         if (quantity == 0) revert MintZeroQuantity();
1207 
1208         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1209 
1210         // Overflows are incredibly unrealistic.
1211         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1212         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1213         unchecked {
1214             _addressData[to].balance += uint64(quantity);
1215             _addressData[to].numberMinted += uint64(quantity);
1216 
1217             _ownerships[startTokenId].addr = to;
1218             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1219 
1220             uint256 updatedIndex = startTokenId;
1221             uint256 end = updatedIndex + quantity;
1222 
1223             do {
1224                 emit Transfer(address(0), to, updatedIndex++);
1225             } while (updatedIndex < end);
1226 
1227             _currentIndex = updatedIndex;
1228         }
1229         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1230     }
1231 
1232     /**
1233      * @dev Transfers `tokenId` from `from` to `to`.
1234      *
1235      * Requirements:
1236      *
1237      * - `to` cannot be the zero address.
1238      * - `tokenId` token must be owned by `from`.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function _transfer(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) private {
1247         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1248 
1249         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1250 
1251         bool isApprovedOrOwner = (_msgSender() == from ||
1252             isApprovedForAll(from, _msgSender()) ||
1253             getApproved(tokenId) == _msgSender());
1254 
1255         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1256         if (to == address(0)) revert TransferToZeroAddress();
1257 
1258         _beforeTokenTransfers(from, to, tokenId, 1);
1259 
1260         // Clear approvals from the previous owner
1261         _approve(address(0), tokenId, from);
1262 
1263         // Underflow of the sender's balance is impossible because we check for
1264         // ownership above and the recipient's balance can't realistically overflow.
1265         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1266         unchecked {
1267             _addressData[from].balance -= 1;
1268             _addressData[to].balance += 1;
1269 
1270             TokenOwnership storage currSlot = _ownerships[tokenId];
1271             currSlot.addr = to;
1272             currSlot.startTimestamp = uint64(block.timestamp);
1273 
1274             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1275             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1276             uint256 nextTokenId = tokenId + 1;
1277             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1278             if (nextSlot.addr == address(0)) {
1279                 // This will suffice for checking _exists(nextTokenId),
1280                 // as a burned slot cannot contain the zero address.
1281                 if (nextTokenId != _currentIndex) {
1282                     nextSlot.addr = from;
1283                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1284                 }
1285             }
1286         }
1287 
1288         emit Transfer(from, to, tokenId);
1289         _afterTokenTransfers(from, to, tokenId, 1);
1290     }
1291 
1292     /**
1293      * @dev Equivalent to `_burn(tokenId, false)`.
1294      */
1295     function _burn(uint256 tokenId) internal virtual {
1296         _burn(tokenId, false);
1297     }
1298 
1299     /**
1300      * @dev Destroys `tokenId`.
1301      * The approval is cleared when the token is burned.
1302      *
1303      * Requirements:
1304      *
1305      * - `tokenId` must exist.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1310         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1311 
1312         address from = prevOwnership.addr;
1313 
1314         if (approvalCheck) {
1315             bool isApprovedOrOwner = (_msgSender() == from ||
1316                 isApprovedForAll(from, _msgSender()) ||
1317                 getApproved(tokenId) == _msgSender());
1318 
1319             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1320         }
1321 
1322         _beforeTokenTransfers(from, address(0), tokenId, 1);
1323 
1324         // Clear approvals from the previous owner
1325         _approve(address(0), tokenId, from);
1326 
1327         // Underflow of the sender's balance is impossible because we check for
1328         // ownership above and the recipient's balance can't realistically overflow.
1329         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1330         unchecked {
1331             AddressData storage addressData = _addressData[from];
1332             addressData.balance -= 1;
1333             addressData.numberBurned += 1;
1334 
1335             // Keep track of who burned the token, and the timestamp of burning.
1336             TokenOwnership storage currSlot = _ownerships[tokenId];
1337             currSlot.addr = from;
1338             currSlot.startTimestamp = uint64(block.timestamp);
1339             currSlot.burned = true;
1340 
1341             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1342             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1343             uint256 nextTokenId = tokenId + 1;
1344             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1345             if (nextSlot.addr == address(0)) {
1346                 // This will suffice for checking _exists(nextTokenId),
1347                 // as a burned slot cannot contain the zero address.
1348                 if (nextTokenId != _currentIndex) {
1349                     nextSlot.addr = from;
1350                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1351                 }
1352             }
1353         }
1354 
1355         emit Transfer(from, address(0), tokenId);
1356         _afterTokenTransfers(from, address(0), tokenId, 1);
1357 
1358         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1359         unchecked {
1360             _burnCounter++;
1361         }
1362     }
1363 
1364     /**
1365      * @dev Approve `to` to operate on `tokenId`
1366      *
1367      * Emits a {Approval} event.
1368      */
1369     function _approve(
1370         address to,
1371         uint256 tokenId,
1372         address owner
1373     ) private {
1374         _tokenApprovals[tokenId] = to;
1375         emit Approval(owner, to, tokenId);
1376     }
1377 
1378     /**
1379      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1380      *
1381      * @param from address representing the previous owner of the given token ID
1382      * @param to target address that will receive the tokens
1383      * @param tokenId uint256 ID of the token to be transferred
1384      * @param _data bytes optional data to send along with the call
1385      * @return bool whether the call correctly returned the expected magic value
1386      */
1387     function _checkContractOnERC721Received(
1388         address from,
1389         address to,
1390         uint256 tokenId,
1391         bytes memory _data
1392     ) private returns (bool) {
1393         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1394             return retval == IERC721Receiver(to).onERC721Received.selector;
1395         } catch (bytes memory reason) {
1396             if (reason.length == 0) {
1397                 revert TransferToNonERC721ReceiverImplementer();
1398             } else {
1399                 assembly {
1400                     revert(add(32, reason), mload(reason))
1401                 }
1402             }
1403         }
1404     }
1405 
1406     /**
1407      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1408      * And also called before burning one token.
1409      *
1410      * startTokenId - the first token id to be transferred
1411      * quantity - the amount to be transferred
1412      *
1413      * Calling conditions:
1414      *
1415      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1416      * transferred to `to`.
1417      * - When `from` is zero, `tokenId` will be minted for `to`.
1418      * - When `to` is zero, `tokenId` will be burned by `from`.
1419      * - `from` and `to` are never both zero.
1420      */
1421     function _beforeTokenTransfers(
1422         address from,
1423         address to,
1424         uint256 startTokenId,
1425         uint256 quantity
1426     ) internal virtual {}
1427 
1428     /**
1429      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1430      * minting.
1431      * And also called after one token has been burned.
1432      *
1433      * startTokenId - the first token id to be transferred
1434      * quantity - the amount to be transferred
1435      *
1436      * Calling conditions:
1437      *
1438      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1439      * transferred to `to`.
1440      * - When `from` is zero, `tokenId` has been minted for `to`.
1441      * - When `to` is zero, `tokenId` has been burned by `from`.
1442      * - `from` and `to` are never both zero.
1443      */
1444     function _afterTokenTransfers(
1445         address from,
1446         address to,
1447         uint256 startTokenId,
1448         uint256 quantity
1449     ) internal virtual {}
1450 }
1451 
1452 // File: erc721a@3.3.0/contracts/extensions/IERC721AQueryable.sol
1453 
1454 
1455 // ERC721A Contracts v3.3.0
1456 // Creator: Chiru Labs
1457 
1458 pragma solidity ^0.8.4;
1459 
1460 
1461 /**
1462  * @dev Interface of an ERC721AQueryable compliant contract.
1463  */
1464 interface IERC721AQueryable is IERC721A {
1465     /**
1466      * Invalid query range (`start` >= `stop`).
1467      */
1468     error InvalidQueryRange();
1469 
1470     /**
1471      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1472      *
1473      * If the `tokenId` is out of bounds:
1474      *   - `addr` = `address(0)`
1475      *   - `startTimestamp` = `0`
1476      *   - `burned` = `false`
1477      *
1478      * If the `tokenId` is burned:
1479      *   - `addr` = `<Address of owner before token was burned>`
1480      *   - `startTimestamp` = `<Timestamp when token was burned>`
1481      *   - `burned = `true`
1482      *
1483      * Otherwise:
1484      *   - `addr` = `<Address of owner>`
1485      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1486      *   - `burned = `false`
1487      */
1488     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1489 
1490     /**
1491      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1492      * See {ERC721AQueryable-explicitOwnershipOf}
1493      */
1494     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1495 
1496     /**
1497      * @dev Returns an array of token IDs owned by `owner`,
1498      * in the range [`start`, `stop`)
1499      * (i.e. `start <= tokenId < stop`).
1500      *
1501      * This function allows for tokens to be queried if the collection
1502      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1503      *
1504      * Requirements:
1505      *
1506      * - `start` < `stop`
1507      */
1508     function tokensOfOwnerIn(
1509         address owner,
1510         uint256 start,
1511         uint256 stop
1512     ) external view returns (uint256[] memory);
1513 
1514     /**
1515      * @dev Returns an array of token IDs owned by `owner`.
1516      *
1517      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1518      * It is meant to be called off-chain.
1519      *
1520      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1521      * multiple smaller scans if the collection is large enough to cause
1522      * an out-of-gas error (10K pfp collections should be fine).
1523      */
1524     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1525 }
1526 
1527 // File: erc721a@3.3.0/contracts/extensions/ERC721AQueryable.sol
1528 
1529 
1530 // ERC721A Contracts v3.3.0
1531 // Creator: Chiru Labs
1532 
1533 pragma solidity ^0.8.4;
1534 
1535 
1536 
1537 /**
1538  * @title ERC721A Queryable
1539  * @dev ERC721A subclass with convenience query functions.
1540  */
1541 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1542     /**
1543      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1544      *
1545      * If the `tokenId` is out of bounds:
1546      *   - `addr` = `address(0)`
1547      *   - `startTimestamp` = `0`
1548      *   - `burned` = `false`
1549      *
1550      * If the `tokenId` is burned:
1551      *   - `addr` = `<Address of owner before token was burned>`
1552      *   - `startTimestamp` = `<Timestamp when token was burned>`
1553      *   - `burned = `true`
1554      *
1555      * Otherwise:
1556      *   - `addr` = `<Address of owner>`
1557      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1558      *   - `burned = `false`
1559      */
1560     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1561         TokenOwnership memory ownership;
1562         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1563             return ownership;
1564         }
1565         ownership = _ownerships[tokenId];
1566         if (ownership.burned) {
1567             return ownership;
1568         }
1569         return _ownershipOf(tokenId);
1570     }
1571 
1572     /**
1573      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1574      * See {ERC721AQueryable-explicitOwnershipOf}
1575      */
1576     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1577         unchecked {
1578             uint256 tokenIdsLength = tokenIds.length;
1579             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1580             for (uint256 i; i != tokenIdsLength; ++i) {
1581                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1582             }
1583             return ownerships;
1584         }
1585     }
1586 
1587     /**
1588      * @dev Returns an array of token IDs owned by `owner`,
1589      * in the range [`start`, `stop`)
1590      * (i.e. `start <= tokenId < stop`).
1591      *
1592      * This function allows for tokens to be queried if the collection
1593      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1594      *
1595      * Requirements:
1596      *
1597      * - `start` < `stop`
1598      */
1599     function tokensOfOwnerIn(
1600         address owner,
1601         uint256 start,
1602         uint256 stop
1603     ) external view override returns (uint256[] memory) {
1604         unchecked {
1605             if (start >= stop) revert InvalidQueryRange();
1606             uint256 tokenIdsIdx;
1607             uint256 stopLimit = _currentIndex;
1608             // Set `start = max(start, _startTokenId())`.
1609             if (start < _startTokenId()) {
1610                 start = _startTokenId();
1611             }
1612             // Set `stop = min(stop, _currentIndex)`.
1613             if (stop > stopLimit) {
1614                 stop = stopLimit;
1615             }
1616             uint256 tokenIdsMaxLength = balanceOf(owner);
1617             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1618             // to cater for cases where `balanceOf(owner)` is too big.
1619             if (start < stop) {
1620                 uint256 rangeLength = stop - start;
1621                 if (rangeLength < tokenIdsMaxLength) {
1622                     tokenIdsMaxLength = rangeLength;
1623                 }
1624             } else {
1625                 tokenIdsMaxLength = 0;
1626             }
1627             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1628             if (tokenIdsMaxLength == 0) {
1629                 return tokenIds;
1630             }
1631             // We need to call `explicitOwnershipOf(start)`,
1632             // because the slot at `start` may not be initialized.
1633             TokenOwnership memory ownership = explicitOwnershipOf(start);
1634             address currOwnershipAddr;
1635             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1636             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1637             if (!ownership.burned) {
1638                 currOwnershipAddr = ownership.addr;
1639             }
1640             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1641                 ownership = _ownerships[i];
1642                 if (ownership.burned) {
1643                     continue;
1644                 }
1645                 if (ownership.addr != address(0)) {
1646                     currOwnershipAddr = ownership.addr;
1647                 }
1648                 if (currOwnershipAddr == owner) {
1649                     tokenIds[tokenIdsIdx++] = i;
1650                 }
1651             }
1652             // Downsize the array to fit.
1653             assembly {
1654                 mstore(tokenIds, tokenIdsIdx)
1655             }
1656             return tokenIds;
1657         }
1658     }
1659 
1660     /**
1661      * @dev Returns an array of token IDs owned by `owner`.
1662      *
1663      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1664      * It is meant to be called off-chain.
1665      *
1666      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1667      * multiple smaller scans if the collection is large enough to cause
1668      * an out-of-gas error (10K pfp collections should be fine).
1669      */
1670     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1671         unchecked {
1672             uint256 tokenIdsIdx;
1673             address currOwnershipAddr;
1674             uint256 tokenIdsLength = balanceOf(owner);
1675             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1676             TokenOwnership memory ownership;
1677             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1678                 ownership = _ownerships[i];
1679                 if (ownership.burned) {
1680                     continue;
1681                 }
1682                 if (ownership.addr != address(0)) {
1683                     currOwnershipAddr = ownership.addr;
1684                 }
1685                 if (currOwnershipAddr == owner) {
1686                     tokenIds[tokenIdsIdx++] = i;
1687                 }
1688             }
1689             return tokenIds;
1690         }
1691     }
1692 }
1693 
1694 // File: contracts/Deskheads.sol
1695 
1696 
1697 
1698 pragma solidity ^0.8.7;
1699 
1700 
1701 
1702 
1703 
1704 
1705 
1706 
1707 contract Deskheads is ERC721AQueryable, Ownable, IERC721Receiver {
1708 
1709     uint public immutable MAX_PER_WALLET_CL = 2; // Collabs
1710     uint public immutable MAX_PER_WALLET_DL = 2; // Desklist
1711     uint public immutable MAX_PER_WALLET_PB = 3; // Public
1712     uint public immutable MAX_SUPPLY = 5555;
1713     uint public immutable PRICE = 0.069 ether;
1714 
1715     using Strings for uint256;
1716     // SALES
1717 
1718     // address to amount
1719     mapping(address => uint256) private minters;
1720 
1721     enum SaleState { 
1722       DISABLED, WHITELIST, PUBLIC 
1723     }
1724     SaleState public saleState;
1725 
1726     bytes32 public merkleRootCL;
1727     bytes32 public merkleRootDL;
1728 
1729     // REVEAL 
1730     bool public isRevealed;
1731     uint256 public tokenOffset;
1732     string public baseURI;
1733     string public preRevealURI = "ipfs://QmQ9xAqaRMootJMxdCdjDSvwJ8H4ZshNKmvtqWhHJCC7Ev";
1734 
1735     // STAKING
1736 
1737     // token to time
1738     mapping(uint => uint) private cumulativeWorkTime;
1739 
1740     struct Worker {
1741       address owner;
1742       uint64 startWorkTime;
1743     }
1744 
1745     // token to worker
1746     mapping(uint => Worker) private workplaceVault; 
1747 
1748     constructor() ERC721A("DESKHEADS", "DSKHD") {
1749       saleState = SaleState.DISABLED;
1750     }
1751 
1752 
1753     modifier isMerkleProofValid(bytes32[] calldata merkleProof, bytes32 root) {
1754         require(MerkleProof.verify(merkleProof,root,keccak256(abi.encodePacked(msg.sender))),"Address not whitelisted");
1755         _;
1756     }
1757 
1758     modifier isSupplyExceeded(uint quantity) {
1759         require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");
1760         _;
1761     }
1762 
1763     // ============ MINT METHODS ============
1764 
1765     function mintDeskhead(uint quantity, bool stake) internal {
1766 
1767         minters[msg.sender] += quantity;
1768 
1769         if(stake)
1770         {
1771           uint startingTokenId = _currentIndex;
1772           _mint(address(this), quantity);
1773 
1774           for (uint i = 0; i < quantity; i++) {
1775             addToVault(startingTokenId + i, msg.sender);
1776           }
1777         }
1778         else
1779         {
1780           _mint(msg.sender, quantity);
1781         }
1782     }
1783 
1784     function mintCL(bytes32[] calldata merkleProof, uint quantity, bool stake) external payable isMerkleProofValid(merkleProof, merkleRootCL) isSupplyExceeded(quantity) {
1785         require(saleState == SaleState.WHITELIST, "WL sale disabled");
1786         require(quantity + minters[msg.sender] <= MAX_PER_WALLET_CL, "Exceeds MAX_PER_WALLET_CL");
1787         require(msg.value >= (PRICE * quantity), "Insufficient funds");
1788 
1789         mintDeskhead(quantity,stake);
1790     }
1791 
1792     function mintDL(bytes32[] calldata merkleProof, uint quantity, bool stake) external payable isMerkleProofValid(merkleProof, merkleRootDL) isSupplyExceeded(quantity) {
1793         require(saleState == SaleState.WHITELIST, "WL sale disabled");
1794         require(quantity + minters[msg.sender] <= MAX_PER_WALLET_DL, "Exceeds MAX_PER_WALLET_DL");
1795         require(msg.value >= (PRICE * quantity), "Insufficient funds");
1796 
1797         mintDeskhead(quantity,stake);
1798     }
1799 
1800     function mintPublic(uint quantity, bool stake) external payable isSupplyExceeded(quantity) {
1801         require(saleState == SaleState.PUBLIC, "Public sale disabled");
1802         require(quantity + minters[msg.sender] <= MAX_PER_WALLET_PB, "Exceeds MAX_PER_WALLET_PB");
1803         require(msg.value >= (PRICE * quantity), "Insufficient funds");
1804 
1805         mintDeskhead(quantity,stake);
1806     }
1807 
1808     // ============ OVERRIDES ============
1809 
1810     function _startTokenId() internal view virtual override returns (uint256) {
1811         return 1;
1812     }
1813 
1814     function _baseURI() internal view override returns (string memory) {
1815         return baseURI;
1816     }
1817 
1818     function onERC721Received(address, address from, uint, bytes calldata) external pure override returns (bytes4) {
1819         return this.onERC721Received.selector;
1820     }
1821 
1822     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1823       require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1824       if (!isRevealed) return preRevealURI;
1825       uint256 finalTokenId = ((_tokenId - 1) + tokenOffset) % totalSupply() + 1;
1826       return string(abi.encodePacked(baseURI, finalTokenId.toString()));
1827     }
1828     // ============ STAKING METHODS ============
1829 
1830     function addToVault(uint tokenId, address holder) internal
1831     {
1832         workplaceVault[tokenId] = Worker({owner: holder,startWorkTime: uint64(block.timestamp)});
1833     }
1834 
1835     function removeFromVault(uint tokenId) internal
1836     {
1837         delete workplaceVault[tokenId];
1838     }
1839 
1840     function sendToWork(uint[] calldata tokenIds) external
1841     {
1842       for (uint i = 0; i < tokenIds.length; i++) {
1843         uint tokenId = tokenIds[i];
1844         require(workplaceVault[tokenId].owner == address(0), "Token already at work");
1845         require(ownerOf(tokenId) == msg.sender, "Token not owned by msg.sender");
1846         
1847         this.transferFrom(msg.sender, address(this), tokenId); 
1848 
1849         addToVault(tokenId, msg.sender); 
1850       }
1851     }
1852 
1853     function backFromWork(uint[] calldata tokenIds) external
1854     {
1855       for (uint i = 0; i < tokenIds.length; i++) {
1856         uint tokenId = tokenIds[i];
1857         require(workplaceVault[tokenId].owner != address(0), "Token not at work");
1858         require(workplaceVault[tokenId].owner == msg.sender, "Token not owned by msg.sender");
1859 
1860         cumulativeWorkTime[tokenId] = cumulativeWorkTime[tokenId] + (block.timestamp - workplaceVault[tokenId].startWorkTime);
1861         
1862         removeFromVault(tokenId); 
1863 
1864         this.transferFrom(address(this), msg.sender, tokenId);
1865       }
1866     }
1867 
1868     function getWorkTime(uint256 tokenId) external view returns (bool working, uint current, uint cumulative)
1869     {
1870         if (workplaceVault[tokenId].owner != address(0)) {
1871             working = true;
1872             current = block.timestamp - workplaceVault[tokenId].startWorkTime;
1873         }
1874         
1875         cumulative = current + cumulativeWorkTime[tokenId];
1876     }
1877 
1878     function getWorkerOwner(uint256 tokenId) external view returns (address owner)
1879     {
1880       return workplaceVault[tokenId].owner;
1881     }
1882 
1883 
1884     function listWorkers(address account) public view returns(uint256[] memory ){
1885         uint256 totalTokens = getWorkerBalance(account);
1886         uint256[] memory tokenIds = new uint256[](totalTokens);
1887         
1888         uint256 j;
1889         for (uint i = 1; j != totalTokens; i++) {
1890             if(workplaceVault[i].owner==account){
1891                 tokenIds[j] = i;
1892                 j++;
1893             }
1894         }
1895 
1896         return tokenIds;
1897     }
1898 
1899 
1900     function getWorkerBalance(address account) public view returns (uint) {
1901       uint balance;
1902       for(uint i = 1; i <= totalSupply(); i++) {
1903         if (workplaceVault[i].owner == account) {
1904           balance += 1;
1905         }
1906       }
1907       return balance;
1908     }
1909 
1910     
1911     // ============ OWNER METHODS ============
1912 
1913     function mintPrivate(address _to,uint quantity) external onlyOwner isSupplyExceeded(quantity) {
1914       _safeMint(_to, quantity);
1915     }
1916 
1917     function setMerkleRootCL(bytes32 merkleRoot) external onlyOwner {
1918         merkleRootCL = merkleRoot;
1919     }
1920 
1921     function setMerkleRootDL(bytes32 merkleRoot) external onlyOwner {
1922         merkleRootDL = merkleRoot;
1923     }
1924     
1925     function setPreRevealURI(string memory _uri) external onlyOwner {
1926         preRevealURI = _uri;
1927     }
1928 
1929     function setBaseURI(string memory _uri) external onlyOwner {
1930         baseURI = _uri;
1931     }
1932 
1933     function reveal() external onlyOwner {
1934       require(!isRevealed, "Cannot reveal more than once");
1935       tokenOffset = uint256(blockhash(block.number - 1));
1936       isRevealed = true;
1937     }
1938 
1939     // TOGGLE SALES : 0 - DISABLED, 1 - WHITELIST, 2 - PUBLIC
1940     function setSaleState(uint state) external onlyOwner {
1941       require(state <= uint256(SaleState.PUBLIC), "Invalid state");
1942       saleState = SaleState(state);
1943     }
1944 
1945     function withdraw() public onlyOwner {
1946         payable(msg.sender).transfer(address(this).balance);
1947     }
1948 }