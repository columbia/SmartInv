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
727 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
728 
729 
730 // Creator: Chiru Labs
731 
732 pragma solidity ^0.8.4;
733 
734 
735 
736 
737 
738 
739 
740 
741 error ApprovalCallerNotOwnerNorApproved();
742 error ApprovalQueryForNonexistentToken();
743 error ApproveToCaller();
744 error ApprovalToCurrentOwner();
745 error BalanceQueryForZeroAddress();
746 error MintToZeroAddress();
747 error MintZeroQuantity();
748 error OwnerQueryForNonexistentToken();
749 error TransferCallerNotOwnerNorApproved();
750 error TransferFromIncorrectOwner();
751 error TransferToNonERC721ReceiverImplementer();
752 error TransferToZeroAddress();
753 error URIQueryForNonexistentToken();
754 
755 /**
756  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
757  * the Metadata extension. Built to optimize for lower gas during batch mints.
758  *
759  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
760  *
761  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
762  *
763  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
764  */
765 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
766     using Address for address;
767     using Strings for uint256;
768 
769     // Compiler will pack this into a single 256bit word.
770     struct TokenOwnership {
771         // The address of the owner.
772         address addr;
773         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
774         uint64 startTimestamp;
775         // Whether the token has been burned.
776         bool burned;
777     }
778 
779     // Compiler will pack this into a single 256bit word.
780     struct AddressData {
781         // Realistically, 2**64-1 is more than enough.
782         uint64 balance;
783         // Keeps track of mint count with minimal overhead for tokenomics.
784         uint64 numberMinted;
785         // Keeps track of burn count with minimal overhead for tokenomics.
786         uint64 numberBurned;
787         // For miscellaneous variable(s) pertaining to the address
788         // (e.g. number of whitelist mint slots used).
789         // If there are multiple variables, please pack them into a uint64.
790         uint64 aux;
791     }
792 
793     // The tokenId of the next token to be minted.
794     uint256 internal _currentIndex;
795 
796     // The number of tokens burned.
797     uint256 internal _burnCounter;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to ownership details
806     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
807     mapping(uint256 => TokenOwnership) internal _ownerships;
808 
809     // Mapping owner address to address data
810     mapping(address => AddressData) private _addressData;
811 
812     // Mapping from token ID to approved address
813     mapping(uint256 => address) private _tokenApprovals;
814 
815     // Mapping from owner to operator approvals
816     mapping(address => mapping(address => bool)) private _operatorApprovals;
817 
818     constructor(string memory name_, string memory symbol_) {
819         _name = name_;
820         _symbol = symbol_;
821         _currentIndex = _startTokenId();
822     }
823 
824     /**
825      * To change the starting tokenId, please override this function.
826      */
827     function _startTokenId() internal view virtual returns (uint256) {
828         return 0;
829     }
830 
831     /**
832      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
833      */
834     function totalSupply() public view returns (uint256) {
835         // Counter underflow is impossible as _burnCounter cannot be incremented
836         // more than _currentIndex - _startTokenId() times
837         unchecked {
838             return _currentIndex - _burnCounter - _startTokenId();
839         }
840     }
841 
842     /**
843      * Returns the total amount of tokens minted in the contract.
844      */
845     function _totalMinted() internal view returns (uint256) {
846         // Counter underflow is impossible as _currentIndex does not decrement,
847         // and it is initialized to _startTokenId()
848         unchecked {
849             return _currentIndex - _startTokenId();
850         }
851     }
852 
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
857         return
858             interfaceId == type(IERC721).interfaceId ||
859             interfaceId == type(IERC721Metadata).interfaceId ||
860             super.supportsInterface(interfaceId);
861     }
862 
863     /**
864      * @dev See {IERC721-balanceOf}.
865      */
866     function balanceOf(address owner) public view override returns (uint256) {
867         if (owner == address(0)) revert BalanceQueryForZeroAddress();
868         return uint256(_addressData[owner].balance);
869     }
870 
871     /**
872      * Returns the number of tokens minted by `owner`.
873      */
874     function _numberMinted(address owner) internal view returns (uint256) {
875         return uint256(_addressData[owner].numberMinted);
876     }
877 
878     /**
879      * Returns the number of tokens burned by or on behalf of `owner`.
880      */
881     function _numberBurned(address owner) internal view returns (uint256) {
882         return uint256(_addressData[owner].numberBurned);
883     }
884 
885     /**
886      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
887      */
888     function _getAux(address owner) internal view returns (uint64) {
889         return _addressData[owner].aux;
890     }
891 
892     /**
893      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
894      * If there are multiple variables, please pack them into a uint64.
895      */
896     function _setAux(address owner, uint64 aux) internal {
897         _addressData[owner].aux = aux;
898     }
899 
900     /**
901      * Gas spent here starts off proportional to the maximum mint batch size.
902      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
903      */
904     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
905         uint256 curr = tokenId;
906 
907         unchecked {
908             if (_startTokenId() <= curr && curr < _currentIndex) {
909                 TokenOwnership memory ownership = _ownerships[curr];
910                 if (!ownership.burned) {
911                     if (ownership.addr != address(0)) {
912                         return ownership;
913                     }
914                     // Invariant:
915                     // There will always be an ownership that has an address and is not burned
916                     // before an ownership that does not have an address and is not burned.
917                     // Hence, curr will not underflow.
918                     while (true) {
919                         curr--;
920                         ownership = _ownerships[curr];
921                         if (ownership.addr != address(0)) {
922                             return ownership;
923                         }
924                     }
925                 }
926             }
927         }
928         revert OwnerQueryForNonexistentToken();
929     }
930 
931     /**
932      * @dev See {IERC721-ownerOf}.
933      */
934     function ownerOf(uint256 tokenId) public view override returns (address) {
935         return _ownershipOf(tokenId).addr;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-name}.
940      */
941     function name() public view virtual override returns (string memory) {
942         return _name;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-symbol}.
947      */
948     function symbol() public view virtual override returns (string memory) {
949         return _symbol;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-tokenURI}.
954      */
955     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
956         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
957 
958         string memory baseURI = _baseURI();
959         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
960     }
961 
962     /**
963      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
964      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
965      * by default, can be overriden in child contracts.
966      */
967     function _baseURI() internal view virtual returns (string memory) {
968         return '';
969     }
970 
971     /**
972      * @dev See {IERC721-approve}.
973      */
974     function approve(address to, uint256 tokenId) public override {
975         address owner = ERC721A.ownerOf(tokenId);
976         if (to == owner) revert ApprovalToCurrentOwner();
977 
978         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
979             revert ApprovalCallerNotOwnerNorApproved();
980         }
981 
982         _approve(to, tokenId, owner);
983     }
984 
985     /**
986      * @dev See {IERC721-getApproved}.
987      */
988     function getApproved(uint256 tokenId) public view override returns (address) {
989         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
990 
991         return _tokenApprovals[tokenId];
992     }
993 
994     /**
995      * @dev See {IERC721-setApprovalForAll}.
996      */
997     function setApprovalForAll(address operator, bool approved) public virtual override {
998         if (operator == _msgSender()) revert ApproveToCaller();
999 
1000         _operatorApprovals[_msgSender()][operator] = approved;
1001         emit ApprovalForAll(_msgSender(), operator, approved);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-isApprovedForAll}.
1006      */
1007     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1008         return _operatorApprovals[owner][operator];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-transferFrom}.
1013      */
1014     function transferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         _transfer(from, to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         safeTransferFrom(from, to, tokenId, '');
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId,
1040         bytes memory _data
1041     ) public virtual override {
1042         _transfer(from, to, tokenId);
1043         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1044             revert TransferToNonERC721ReceiverImplementer();
1045         }
1046     }
1047 
1048     /**
1049      * @dev Returns whether `tokenId` exists.
1050      *
1051      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1052      *
1053      * Tokens start existing when they are minted (`_mint`),
1054      */
1055     function _exists(uint256 tokenId) internal view returns (bool) {
1056         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1057             !_ownerships[tokenId].burned;
1058     }
1059 
1060     function _safeMint(address to, uint256 quantity) internal {
1061         _safeMint(to, quantity, '');
1062     }
1063 
1064     /**
1065      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1070      * - `quantity` must be greater than 0.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeMint(
1075         address to,
1076         uint256 quantity,
1077         bytes memory _data
1078     ) internal {
1079         _mint(to, quantity, _data, true);
1080     }
1081 
1082     /**
1083      * @dev Mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _mint(
1093         address to,
1094         uint256 quantity,
1095         bytes memory _data,
1096         bool safe
1097     ) internal {
1098         uint256 startTokenId = _currentIndex;
1099         if (to == address(0)) revert MintToZeroAddress();
1100         if (quantity == 0) revert MintZeroQuantity();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1106         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1107         unchecked {
1108             _addressData[to].balance += uint64(quantity);
1109             _addressData[to].numberMinted += uint64(quantity);
1110 
1111             _ownerships[startTokenId].addr = to;
1112             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1113 
1114             uint256 updatedIndex = startTokenId;
1115             uint256 end = updatedIndex + quantity;
1116 
1117             if (safe && to.isContract()) {
1118                 do {
1119                     emit Transfer(address(0), to, updatedIndex);
1120                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1121                         revert TransferToNonERC721ReceiverImplementer();
1122                     }
1123                 } while (updatedIndex != end);
1124                 // Reentrancy protection
1125                 if (_currentIndex != startTokenId) revert();
1126             } else {
1127                 do {
1128                     emit Transfer(address(0), to, updatedIndex++);
1129                 } while (updatedIndex != end);
1130             }
1131             _currentIndex = updatedIndex;
1132         }
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Transfers `tokenId` from `from` to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must be owned by `from`.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _transfer(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) private {
1151         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1152 
1153         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1154 
1155         bool isApprovedOrOwner = (_msgSender() == from ||
1156             isApprovedForAll(from, _msgSender()) ||
1157             getApproved(tokenId) == _msgSender());
1158 
1159         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1160         if (to == address(0)) revert TransferToZeroAddress();
1161 
1162         _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164         // Clear approvals from the previous owner
1165         _approve(address(0), tokenId, from);
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             _addressData[from].balance -= 1;
1172             _addressData[to].balance += 1;
1173 
1174             TokenOwnership storage currSlot = _ownerships[tokenId];
1175             currSlot.addr = to;
1176             currSlot.startTimestamp = uint64(block.timestamp);
1177 
1178             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1179             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1180             uint256 nextTokenId = tokenId + 1;
1181             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1182             if (nextSlot.addr == address(0)) {
1183                 // This will suffice for checking _exists(nextTokenId),
1184                 // as a burned slot cannot contain the zero address.
1185                 if (nextTokenId != _currentIndex) {
1186                     nextSlot.addr = from;
1187                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1188                 }
1189             }
1190         }
1191 
1192         emit Transfer(from, to, tokenId);
1193         _afterTokenTransfers(from, to, tokenId, 1);
1194     }
1195 
1196     /**
1197      * @dev This is equivalent to _burn(tokenId, false)
1198      */
1199     function _burn(uint256 tokenId) internal virtual {
1200         _burn(tokenId, false);
1201     }
1202 
1203     /**
1204      * @dev Destroys `tokenId`.
1205      * The approval is cleared when the token is burned.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1214         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1215 
1216         address from = prevOwnership.addr;
1217 
1218         if (approvalCheck) {
1219             bool isApprovedOrOwner = (_msgSender() == from ||
1220                 isApprovedForAll(from, _msgSender()) ||
1221                 getApproved(tokenId) == _msgSender());
1222 
1223             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1224         }
1225 
1226         _beforeTokenTransfers(from, address(0), tokenId, 1);
1227 
1228         // Clear approvals from the previous owner
1229         _approve(address(0), tokenId, from);
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1234         unchecked {
1235             AddressData storage addressData = _addressData[from];
1236             addressData.balance -= 1;
1237             addressData.numberBurned += 1;
1238 
1239             // Keep track of who burned the token, and the timestamp of burning.
1240             TokenOwnership storage currSlot = _ownerships[tokenId];
1241             currSlot.addr = from;
1242             currSlot.startTimestamp = uint64(block.timestamp);
1243             currSlot.burned = true;
1244 
1245             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1246             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1247             uint256 nextTokenId = tokenId + 1;
1248             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1249             if (nextSlot.addr == address(0)) {
1250                 // This will suffice for checking _exists(nextTokenId),
1251                 // as a burned slot cannot contain the zero address.
1252                 if (nextTokenId != _currentIndex) {
1253                     nextSlot.addr = from;
1254                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1255                 }
1256             }
1257         }
1258 
1259         emit Transfer(from, address(0), tokenId);
1260         _afterTokenTransfers(from, address(0), tokenId, 1);
1261 
1262         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1263         unchecked {
1264             _burnCounter++;
1265         }
1266     }
1267 
1268     /**
1269      * @dev Approve `to` to operate on `tokenId`
1270      *
1271      * Emits a {Approval} event.
1272      */
1273     function _approve(
1274         address to,
1275         uint256 tokenId,
1276         address owner
1277     ) private {
1278         _tokenApprovals[tokenId] = to;
1279         emit Approval(owner, to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1284      *
1285      * @param from address representing the previous owner of the given token ID
1286      * @param to target address that will receive the tokens
1287      * @param tokenId uint256 ID of the token to be transferred
1288      * @param _data bytes optional data to send along with the call
1289      * @return bool whether the call correctly returned the expected magic value
1290      */
1291     function _checkContractOnERC721Received(
1292         address from,
1293         address to,
1294         uint256 tokenId,
1295         bytes memory _data
1296     ) private returns (bool) {
1297         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1298             return retval == IERC721Receiver(to).onERC721Received.selector;
1299         } catch (bytes memory reason) {
1300             if (reason.length == 0) {
1301                 revert TransferToNonERC721ReceiverImplementer();
1302             } else {
1303                 assembly {
1304                     revert(add(32, reason), mload(reason))
1305                 }
1306             }
1307         }
1308     }
1309 
1310     /**
1311      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1312      * And also called before burning one token.
1313      *
1314      * startTokenId - the first token id to be transferred
1315      * quantity - the amount to be transferred
1316      *
1317      * Calling conditions:
1318      *
1319      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1320      * transferred to `to`.
1321      * - When `from` is zero, `tokenId` will be minted for `to`.
1322      * - When `to` is zero, `tokenId` will be burned by `from`.
1323      * - `from` and `to` are never both zero.
1324      */
1325     function _beforeTokenTransfers(
1326         address from,
1327         address to,
1328         uint256 startTokenId,
1329         uint256 quantity
1330     ) internal virtual {}
1331 
1332     /**
1333      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1334      * minting.
1335      * And also called after one token has been burned.
1336      *
1337      * startTokenId - the first token id to be transferred
1338      * quantity - the amount to be transferred
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` has been minted for `to`.
1345      * - When `to` is zero, `tokenId` has been burned by `from`.
1346      * - `from` and `to` are never both zero.
1347      */
1348     function _afterTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 }
1355 
1356 // File: contracts/elontusks/ElontuskNFt.sol
1357 
1358 
1359 pragma solidity ^0.8.7;
1360 
1361 
1362 
1363 
1364 
1365 interface IToken {
1366 	function updateRewardOnMint(address _user, uint256 _amount) external;
1367     function updateReward(address _from, address _to) external;
1368     function getReward(address _to) external;
1369     function burn(address _from, uint256 _amount) external;
1370     function getTotalClaimable(address _user) external view returns(uint256);
1371 }
1372 
1373 
1374 contract ELONTUSKS is ERC721A, Ownable {
1375     using Strings for uint256;
1376     address breedingContract;
1377     IToken public yieldToken;
1378 
1379     string public baseApiURI;
1380     bytes32 private whitelistRoot;
1381   
1382 
1383     //General Settings
1384     uint16 public maxMintAmountPerTransaction = 1;
1385     uint16 public maxMintAmountPerWallet = 1;
1386 
1387    
1388 
1389     //Inventory
1390     uint256 public maxSupply = 500;
1391     uint256 public freeLimit = 500;
1392 
1393     //Prices
1394     uint256 public cost = 0.015 ether;
1395 
1396     //Utility
1397     bool public paused = false;
1398 
1399     //mapping
1400 	mapping(address => uint256) public balanceOG;
1401 
1402     
1403 
1404     constructor(string memory _baseUrl, address  _tokenAddress) ERC721A("ELONTUSK", "ELONTUSK") {   
1405         baseApiURI = _baseUrl;
1406          yieldToken = IToken(_tokenAddress);
1407     }
1408 
1409      function setFreeLimit(uint256 _limit) public onlyOwner{
1410         freeLimit = _limit;
1411     }
1412 
1413     //This function will be used to extend the project with more capabilities 
1414     function setBreedingContractAddress(address _bAddress) public onlyOwner {
1415         breedingContract = _bAddress;
1416     }
1417 
1418     //set yield token 
1419     function setYieldToken(address _address) public onlyOwner {
1420         yieldToken = IToken(_address);
1421     }
1422 
1423 
1424     //this function can be called only from the extending contract
1425     function mintExternal(address _address, uint256 _mintAmount) external {
1426         require(
1427             msg.sender == breedingContract,
1428             "Sorry you dont have permission to mint"
1429         );
1430         _safeMint(_address, _mintAmount);
1431         yieldToken.updateRewardOnMint(_address, _mintAmount);
1432 		balanceOG[_address] += _mintAmount;
1433     }
1434 
1435    
1436    
1437     function numberMinted(address owner) public view returns (uint256) {
1438         return _numberMinted(owner);
1439     }
1440 
1441     // public
1442     function mint(uint256 _mintAmount) public payable {
1443         if (msg.sender != owner()) {
1444             uint256 ownerTokenCount = balanceOf(msg.sender);
1445 
1446             require(!paused);
1447             require(_mintAmount > 0, "Mint amount should be greater than 0");
1448             require(
1449                 _mintAmount <= maxMintAmountPerTransaction,
1450                 "Sorry you cant mint this amount at once"
1451             );
1452             require(
1453                 totalSupply() + _mintAmount <= maxSupply,
1454                 "Exceeds Max Supply"
1455             );
1456             require(
1457                 (ownerTokenCount + _mintAmount) <= maxMintAmountPerWallet,
1458                 "Sorry you cant mint more"
1459             );
1460 
1461               if(totalSupply() > freeLimit){
1462                 //not free
1463                 require(msg.value >= cost * _mintAmount, "Insuffient funds");
1464             }else{
1465                 uint256 a = freeLimit - totalSupply();
1466                 
1467                 if(_mintAmount > a){
1468                    uint256 c = _mintAmount - a; 
1469                    //pay only for A 
1470                     require(msg.value >= cost * c, "Insuffient funds");
1471                 }
1472 
1473             }
1474         }
1475 
1476         _mintLoop(msg.sender, _mintAmount);
1477         yieldToken.updateRewardOnMint(msg.sender, _mintAmount);
1478 		balanceOG[msg.sender] += _mintAmount;
1479     }
1480 
1481     function gift(address _to, uint256 _mintAmount) public onlyOwner {
1482         _mintLoop(_to, _mintAmount);
1483         yieldToken.updateRewardOnMint(_to, _mintAmount);
1484 		balanceOG[_to] += _mintAmount;
1485     }
1486 
1487     function airdrop(address[] memory _airdropAddresses) public onlyOwner {
1488         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1489             address to = _airdropAddresses[i];
1490             _mintLoop(to, 1);
1491             yieldToken.updateRewardOnMint(to, 1);
1492 		    balanceOG[to]++;
1493         }
1494     }
1495 
1496     function _baseURI() internal view virtual override returns (string memory) {
1497         return baseApiURI;
1498     }
1499 
1500     function tokenURI(uint256 tokenId)
1501         public
1502         view
1503         virtual
1504         override
1505         returns (string memory)
1506     {
1507         require(
1508             _exists(tokenId),
1509             "ERC721Metadata: URI query for nonexistent token"
1510         );
1511         string memory currentBaseURI = _baseURI();
1512         return
1513             bytes(currentBaseURI).length > 0
1514                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1515                 : "";
1516     }
1517 
1518     	function getReward() external {
1519 		yieldToken.updateReward(msg.sender, address(0));
1520 		yieldToken.getReward(msg.sender);
1521 	}
1522 
1523 
1524     //overides
1525    function transferFrom(address from, address to, uint256 tokenId) public override {
1526 		yieldToken.updateReward(from, to);
1527 		balanceOG[from]--;
1528 		balanceOG[to]++;
1529 		ERC721A.transferFrom(from, to, tokenId);
1530 	}
1531 
1532     	function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
1533 		yieldToken.updateReward(from, to);
1534 			balanceOG[from]--;
1535 			balanceOG[to]++;
1536 		ERC721A.safeTransferFrom(from, to, tokenId, _data);
1537 	}
1538 
1539 
1540     function setCost(uint256 _newCost) public onlyOwner {
1541         cost = _newCost;
1542     }
1543 
1544     function setmaxMintAmountPerTransaction(uint16 _amount) public onlyOwner {
1545         maxMintAmountPerTransaction = _amount;
1546     }
1547 
1548     function setMaxMintAmountPerWallet(uint16 _amount) public onlyOwner {
1549         maxMintAmountPerWallet = _amount;
1550     }
1551 
1552 
1553     function setMaxSupply(uint256 _supply) public onlyOwner {
1554         maxSupply = _supply;
1555     }
1556 
1557     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1558         baseApiURI = _newBaseURI;
1559     }
1560 
1561     function togglePause() public onlyOwner {
1562         paused = !paused;
1563     }
1564 
1565     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1566         _safeMint(_receiver, _mintAmount);
1567     }
1568 
1569     //Burn them paperhands
1570     function batchBurn(uint256[] memory _nftIds) public onlyOwner {
1571             for(uint256 i = 0; i < _nftIds.length; i++){
1572                  address tokenOwner = ownerOf(_nftIds[i]);
1573                  yieldToken.updateReward(tokenOwner, address(this));
1574 		        balanceOG[tokenOwner]--;
1575                 _burn(_nftIds[i]);
1576             }
1577     }
1578 
1579     function burn(uint256 _nftId) public onlyOwner{
1580        
1581         address tokenOwner = ownerOf(_nftId);
1582         yieldToken.updateReward(tokenOwner, address(this));
1583 		balanceOG[tokenOwner]--;
1584         _burn(_nftId);
1585     }
1586    
1587 
1588     
1589 
1590     function withdraw() public payable onlyOwner {
1591         (bool hq, ) = payable(owner()).call{value: address(this).balance}("");
1592         require(hq);
1593 
1594     }
1595 }