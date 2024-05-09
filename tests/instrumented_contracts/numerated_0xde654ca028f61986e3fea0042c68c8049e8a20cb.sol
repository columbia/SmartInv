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
1056         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1057     }
1058 
1059     /**
1060      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1061      */
1062     function _safeMint(address to, uint256 quantity) internal {
1063         _safeMint(to, quantity, '');
1064     }
1065 
1066     /**
1067      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - If `to` refers to a smart contract, it must implement 
1072      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _safeMint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data
1081     ) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1090         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1091         unchecked {
1092             _addressData[to].balance += uint64(quantity);
1093             _addressData[to].numberMinted += uint64(quantity);
1094 
1095             _ownerships[startTokenId].addr = to;
1096             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1097 
1098             uint256 updatedIndex = startTokenId;
1099             uint256 end = updatedIndex + quantity;
1100 
1101             if (to.isContract()) {
1102                 do {
1103                     emit Transfer(address(0), to, updatedIndex);
1104                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1105                         revert TransferToNonERC721ReceiverImplementer();
1106                     }
1107                 } while (updatedIndex != end);
1108                 // Reentrancy protection
1109                 if (_currentIndex != startTokenId) revert();
1110             } else {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex++);
1113                 } while (updatedIndex != end);
1114             }
1115             _currentIndex = updatedIndex;
1116         }
1117         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1118     }
1119 
1120     /**
1121      * @dev Mints `quantity` tokens and transfers them to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `quantity` must be greater than 0.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _mint(address to, uint256 quantity) internal {
1131         uint256 startTokenId = _currentIndex;
1132         if (to == address(0)) revert MintToZeroAddress();
1133         if (quantity == 0) revert MintZeroQuantity();
1134 
1135         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1136 
1137         // Overflows are incredibly unrealistic.
1138         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1139         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1140         unchecked {
1141             _addressData[to].balance += uint64(quantity);
1142             _addressData[to].numberMinted += uint64(quantity);
1143 
1144             _ownerships[startTokenId].addr = to;
1145             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1146 
1147             uint256 updatedIndex = startTokenId;
1148             uint256 end = updatedIndex + quantity;
1149 
1150             do {
1151                 emit Transfer(address(0), to, updatedIndex++);
1152             } while (updatedIndex != end);
1153 
1154             _currentIndex = updatedIndex;
1155         }
1156         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1157     }
1158 
1159     /**
1160      * @dev Transfers `tokenId` from `from` to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - `to` cannot be the zero address.
1165      * - `tokenId` token must be owned by `from`.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _transfer(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) private {
1174         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1175 
1176         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1177 
1178         bool isApprovedOrOwner = (_msgSender() == from ||
1179             isApprovedForAll(from, _msgSender()) ||
1180             getApproved(tokenId) == _msgSender());
1181 
1182         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1183         if (to == address(0)) revert TransferToZeroAddress();
1184 
1185         _beforeTokenTransfers(from, to, tokenId, 1);
1186 
1187         // Clear approvals from the previous owner
1188         _approve(address(0), tokenId, from);
1189 
1190         // Underflow of the sender's balance is impossible because we check for
1191         // ownership above and the recipient's balance can't realistically overflow.
1192         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1193         unchecked {
1194             _addressData[from].balance -= 1;
1195             _addressData[to].balance += 1;
1196 
1197             TokenOwnership storage currSlot = _ownerships[tokenId];
1198             currSlot.addr = to;
1199             currSlot.startTimestamp = uint64(block.timestamp);
1200 
1201             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1202             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1203             uint256 nextTokenId = tokenId + 1;
1204             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1205             if (nextSlot.addr == address(0)) {
1206                 // This will suffice for checking _exists(nextTokenId),
1207                 // as a burned slot cannot contain the zero address.
1208                 if (nextTokenId != _currentIndex) {
1209                     nextSlot.addr = from;
1210                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1211                 }
1212             }
1213         }
1214 
1215         emit Transfer(from, to, tokenId);
1216         _afterTokenTransfers(from, to, tokenId, 1);
1217     }
1218 
1219     /**
1220      * @dev Equivalent to `_burn(tokenId, false)`.
1221      */
1222     function _burn(uint256 tokenId) internal virtual {
1223         _burn(tokenId, false);
1224     }
1225 
1226     /**
1227      * @dev Destroys `tokenId`.
1228      * The approval is cleared when the token is burned.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1237         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1238 
1239         address from = prevOwnership.addr;
1240 
1241         if (approvalCheck) {
1242             bool isApprovedOrOwner = (_msgSender() == from ||
1243                 isApprovedForAll(from, _msgSender()) ||
1244                 getApproved(tokenId) == _msgSender());
1245 
1246             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1247         }
1248 
1249         _beforeTokenTransfers(from, address(0), tokenId, 1);
1250 
1251         // Clear approvals from the previous owner
1252         _approve(address(0), tokenId, from);
1253 
1254         // Underflow of the sender's balance is impossible because we check for
1255         // ownership above and the recipient's balance can't realistically overflow.
1256         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1257         unchecked {
1258             AddressData storage addressData = _addressData[from];
1259             addressData.balance -= 1;
1260             addressData.numberBurned += 1;
1261 
1262             // Keep track of who burned the token, and the timestamp of burning.
1263             TokenOwnership storage currSlot = _ownerships[tokenId];
1264             currSlot.addr = from;
1265             currSlot.startTimestamp = uint64(block.timestamp);
1266             currSlot.burned = true;
1267 
1268             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1269             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1270             uint256 nextTokenId = tokenId + 1;
1271             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1272             if (nextSlot.addr == address(0)) {
1273                 // This will suffice for checking _exists(nextTokenId),
1274                 // as a burned slot cannot contain the zero address.
1275                 if (nextTokenId != _currentIndex) {
1276                     nextSlot.addr = from;
1277                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1278                 }
1279             }
1280         }
1281 
1282         emit Transfer(from, address(0), tokenId);
1283         _afterTokenTransfers(from, address(0), tokenId, 1);
1284 
1285         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1286         unchecked {
1287             _burnCounter++;
1288         }
1289     }
1290 
1291     /**
1292      * @dev Approve `to` to operate on `tokenId`
1293      *
1294      * Emits a {Approval} event.
1295      */
1296     function _approve(
1297         address to,
1298         uint256 tokenId,
1299         address owner
1300     ) private {
1301         _tokenApprovals[tokenId] = to;
1302         emit Approval(owner, to, tokenId);
1303     }
1304 
1305     /**
1306      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1307      *
1308      * @param from address representing the previous owner of the given token ID
1309      * @param to target address that will receive the tokens
1310      * @param tokenId uint256 ID of the token to be transferred
1311      * @param _data bytes optional data to send along with the call
1312      * @return bool whether the call correctly returned the expected magic value
1313      */
1314     function _checkContractOnERC721Received(
1315         address from,
1316         address to,
1317         uint256 tokenId,
1318         bytes memory _data
1319     ) private returns (bool) {
1320         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1321             return retval == IERC721Receiver(to).onERC721Received.selector;
1322         } catch (bytes memory reason) {
1323             if (reason.length == 0) {
1324                 revert TransferToNonERC721ReceiverImplementer();
1325             } else {
1326                 assembly {
1327                     revert(add(32, reason), mload(reason))
1328                 }
1329             }
1330         }
1331     }
1332 
1333     /**
1334      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1335      * And also called before burning one token.
1336      *
1337      * startTokenId - the first token id to be transferred
1338      * quantity - the amount to be transferred
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` will be minted for `to`.
1345      * - When `to` is zero, `tokenId` will be burned by `from`.
1346      * - `from` and `to` are never both zero.
1347      */
1348     function _beforeTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 
1355     /**
1356      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1357      * minting.
1358      * And also called after one token has been burned.
1359      *
1360      * startTokenId - the first token id to be transferred
1361      * quantity - the amount to be transferred
1362      *
1363      * Calling conditions:
1364      *
1365      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1366      * transferred to `to`.
1367      * - When `from` is zero, `tokenId` has been minted for `to`.
1368      * - When `to` is zero, `tokenId` has been burned by `from`.
1369      * - `from` and `to` are never both zero.
1370      */
1371     function _afterTokenTransfers(
1372         address from,
1373         address to,
1374         uint256 startTokenId,
1375         uint256 quantity
1376     ) internal virtual {}
1377 }
1378 
1379 // File: contracts/Toons/Toons721.sol
1380 
1381 
1382 pragma solidity ^0.8.7;
1383 
1384 
1385 
1386 
1387 contract ToonsOG is ERC721A, Ownable {
1388     using Strings for uint256;
1389     address breedingContract;
1390 
1391     string public baseApiURI;
1392     
1393   
1394 
1395     //General Settings
1396     uint16 public maxMintAmountPerTransaction = 5;
1397     uint16 public maxMintAmountPerWallet = 5;
1398 
1399     //whitelisting Settings
1400     uint16 public maxMintAmountPerWhitelist = 5;
1401     uint16 public maxMintAmountPerOgWhitelist = 5;
1402    
1403 
1404     //Inventory
1405     uint256 public maxSupply = 4444;
1406 
1407     //Prices
1408     uint256 public cost = 0.5 ether;
1409     uint256 public ogWhitelistCost = 0.04 ether;
1410     uint256 public whitelistCost = 0.05 ether;
1411 
1412     //Utility
1413     bool public paused = true;
1414     bool public whiteListingSale = false;
1415     bool public claimable = false;
1416 
1417     //roots 
1418     bytes32 private genesisClaimRoot;
1419     bytes32 private ogWlroot;
1420     bytes32 private wlRoot;
1421 
1422 
1423     //mapping
1424     mapping(address => uint256) public whitelistedMints;
1425     mapping(address => bool) public claims;
1426 
1427 
1428     constructor(string memory _baseUrl) ERC721A("ToonsCollection", "TOONS") {
1429         baseApiURI = _baseUrl;
1430     }
1431 
1432     //This function will be used to extend the project with more capabilities 
1433     function setBreedingContractAddress(address _bAddress) public onlyOwner {
1434         breedingContract = _bAddress;
1435     }
1436 
1437    
1438 
1439     //this function can be called only from the extending contract
1440     function mintExternal(address _address, uint256 _mintAmount) external {
1441         require(
1442             msg.sender == breedingContract,
1443             "Sorry you dont have permission to mint"
1444         );
1445         _safeMint(_address, _mintAmount);
1446     }
1447 
1448 
1449 
1450     //Merkle Tree 
1451 
1452     function setWhitelistingRoot(bytes32 _root) public onlyOwner {
1453         wlRoot = _root;
1454     }
1455 
1456     function setOgWhitelistingRoot(bytes32 _root) public onlyOwner {
1457         ogWlroot = _root;
1458     }
1459 
1460     // Verify that a given leaf is in the tree.
1461     function _verify(
1462         bool _isOg,
1463         bytes32 _leafNode,
1464         bytes32[] memory proof
1465     ) internal view returns (bool) {
1466         return MerkleProof.verify(proof, _isOg?ogWlroot:wlRoot, _leafNode);
1467     }
1468 
1469     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1470     function _leaf(address account) internal pure returns (bytes32) {
1471         return keccak256(abi.encodePacked(account));
1472     }
1473 
1474 
1475 
1476     function setGenesisRoot(bytes32 _root) public onlyOwner {
1477         genesisClaimRoot = _root;
1478     }
1479 
1480     function _verifyGenesisClaim(
1481         bytes32 _leafNode,
1482         bytes32[] memory proof
1483     ) internal view returns (bool) {
1484         return MerkleProof.verify(proof, genesisClaimRoot, _leafNode);
1485     }
1486 
1487     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1488     function _leafGenesis(address account, uint256 _amount) internal pure returns (bytes32) {
1489         return keccak256(abi.encodePacked(account, _amount));
1490     }
1491 
1492    
1493 
1494     //genesis Claim
1495      function claimGenesisToons(
1496         uint256 _amount,
1497         bytes32[] calldata proof
1498     ) public payable {
1499                 //verification
1500 
1501                 require(claimable, "Claim not enabled");
1502                 require(
1503                     _verifyGenesisClaim(_leafGenesis(msg.sender, _amount), proof),
1504                     "Invalid proof"
1505                 );
1506 
1507                 require(!claims[msg.sender], "Already Claimed");
1508                 //END 
1509 
1510                 //Mint
1511                 _mintLoop(msg.sender, _amount);
1512                 claims[msg.sender] = true;
1513                 
1514     }
1515 
1516     //whitelist mint
1517     function mintWhitelist(
1518         bool isOg,
1519         bytes32[] calldata proof,
1520         uint256 _mintAmount
1521     ) public payable {
1522                 //verification
1523                 require(
1524                     _verify(isOg, _leaf(msg.sender), proof),
1525                     "Invalid proof"
1526                 );
1527                 
1528                 if(isOg){
1529                     require(
1530                     (whitelistedMints[msg.sender] + _mintAmount) <=
1531                         maxMintAmountPerOgWhitelist,
1532                     "Exceeds Max Mint amount"
1533                 );
1534 
1535                 require(
1536                     msg.value >= (ogWhitelistCost * _mintAmount),
1537                     "Insuffient funds"
1538                 );
1539                 }else{
1540                     require(
1541                     (whitelistedMints[msg.sender] + _mintAmount) <=
1542                         maxMintAmountPerWhitelist,
1543                     "Exceeds Max Mint amount"
1544                 );
1545 
1546                 require(
1547                     msg.value >= (whitelistCost * _mintAmount),
1548                     "Insuffient funds"
1549                 );
1550                 }
1551 
1552                 
1553 
1554                 //END WL Verifications
1555 
1556                 //Mint
1557                 _mintLoop(msg.sender, _mintAmount);
1558                 whitelistedMints[msg.sender] =
1559                     whitelistedMints[msg.sender] +
1560                     _mintAmount;
1561     }
1562 
1563 
1564     function numberMinted(address owner) public view returns (uint256) {
1565         return _numberMinted(owner);
1566     }
1567 
1568     // public
1569     function mint(uint256 _mintAmount) public payable {
1570         if (msg.sender != owner()) {
1571             uint256 ownerTokenCount = balanceOf(msg.sender);
1572 
1573             require(!paused);
1574             require(!whiteListingSale, "You cant mint on Presale");
1575             require(_mintAmount > 0, "Mint amount should be greater than 0");
1576             require(
1577                 _mintAmount <= maxMintAmountPerTransaction,
1578                 "Sorry you cant mint this amount at once"
1579             );
1580             require(
1581                 totalSupply() + _mintAmount <= maxSupply,
1582                 "Exceeds Max Supply"
1583             );
1584             require(
1585                 (ownerTokenCount + _mintAmount) <= maxMintAmountPerWallet,
1586                 "Sorry you cant mint more"
1587             );
1588 
1589             require(msg.value >= cost * _mintAmount, "Insuffient funds");
1590         }
1591 
1592         _mintLoop(msg.sender, _mintAmount);
1593     }
1594 
1595     function gift(address _to, uint256 _mintAmount) public onlyOwner {
1596         _mintLoop(_to, _mintAmount);
1597     }
1598 
1599     function airdrop(address[] memory _airdropAddresses, uint256 _amount) public onlyOwner {
1600         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1601             address to = _airdropAddresses[i];
1602             _mintLoop(to, _amount);
1603         }
1604     }
1605 
1606     function _baseURI() internal view virtual override returns (string memory) {
1607         return baseApiURI;
1608     }
1609 
1610     function tokenURI(uint256 tokenId)
1611         public
1612         view
1613         virtual
1614         override
1615         returns (string memory)
1616     {
1617         require(
1618             _exists(tokenId),
1619             "ERC721Metadata: URI query for nonexistent token"
1620         );
1621         string memory currentBaseURI = _baseURI();
1622         return
1623             bytes(currentBaseURI).length > 0
1624                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1625                 : "";
1626     }
1627 
1628     function setCost(uint256 _newCost) public onlyOwner {
1629         cost = _newCost;
1630     }
1631 
1632     function setWhitelistingCost(uint256 _newCost) public onlyOwner {
1633         whitelistCost = _newCost;
1634     }
1635 
1636     function setOgwhitelistingCost(uint256 _newCost) public onlyOwner {
1637         ogWhitelistCost = _newCost;
1638     }
1639 
1640     function setmaxMintAmountPerTransaction(uint16 _amount) public onlyOwner {
1641         maxMintAmountPerTransaction = _amount;
1642     }
1643 
1644     function setMaxMintAmountPerWallet(uint16 _amount) public onlyOwner {
1645         maxMintAmountPerWallet = _amount;
1646     }
1647 
1648     function setMaxMintAmountPerWhitelist(uint16 _amount) public onlyOwner {
1649         maxMintAmountPerWhitelist = _amount;
1650     }
1651 
1652     function setMaxAmountPerOgWhitelist(uint16 _amount) public onlyOwner {
1653         maxMintAmountPerOgWhitelist = _amount;
1654     }
1655 
1656     function setMaxSupply(uint256 _supply) public onlyOwner {
1657         maxSupply = _supply;
1658     }
1659 
1660     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1661         baseApiURI = _newBaseURI;
1662     }
1663 
1664     function togglePause() public onlyOwner {
1665         paused = !paused;
1666     }
1667 
1668     function toggleclaim() public onlyOwner{
1669         claimable = !claimable;
1670     }
1671 
1672     function toggleWhiteSale() public onlyOwner {
1673         whiteListingSale = !whiteListingSale;
1674     }
1675 
1676     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1677         _safeMint(_receiver, _mintAmount);
1678     }
1679 
1680   
1681 
1682     function withdraw() public payable onlyOwner {
1683         (bool hq, ) = payable(0xe600648Ce025cC8F80A41Dc2953309783289C23C).call{value: address(this).balance}("");
1684         require(hq);
1685     }
1686 }