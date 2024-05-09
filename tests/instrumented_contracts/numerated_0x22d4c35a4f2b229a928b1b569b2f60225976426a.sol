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
727 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
728 
729 
730 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 
735 /**
736  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
737  * @dev See https://eips.ethereum.org/EIPS/eip-721
738  */
739 interface IERC721Enumerable is IERC721 {
740     /**
741      * @dev Returns the total amount of tokens stored by the contract.
742      */
743     function totalSupply() external view returns (uint256);
744 
745     /**
746      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
747      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
748      */
749     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
750 
751     /**
752      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
753      * Use along with {totalSupply} to enumerate all tokens.
754      */
755     function tokenByIndex(uint256 index) external view returns (uint256);
756 }
757 
758 // File: contracts/ERC721.sol
759 
760 
761 
762 pragma solidity ^0.8.0;
763 
764 
765 
766 
767 
768 
769 
770 
771 
772 /**
773  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
774  * the Metadata and Enumerable extensions
775  */
776 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
777   using Address for address;
778   using Strings for uint256;
779 
780   string private _name;
781   string private _symbol;
782 
783   // nft ownership + burns data
784   address[] public owners;
785   uint public burnedTokens;
786 
787   function totalSupply() public override view returns (uint256) {
788     return owners.length - burnedTokens;
789   }
790 
791   function tokenByIndex(uint256 id) public override pure returns (uint256) {
792     return id;
793   }
794   function tokenOfOwnerByIndex(address user, uint256 id) public override view returns (uint256) {
795     uint256 ownedCount = 0;
796     for(uint i = 0; i < owners.length; i++) {
797       if(owners[i] == user) {
798         if(ownedCount == id) {
799           return i;
800         } else {
801           ownedCount++;
802         }
803       }
804     }
805 
806     revert("ID_TOO_HIGH");
807   }
808 
809   // Mapping from token ID to approved address
810   mapping(uint256 => address) private _tokenApprovals;
811 
812   // Mapping from owner to operator approvals
813   mapping(address => mapping(address => bool)) private _operatorApprovals;
814 
815   /**
816   * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
817   */
818   constructor(string memory name_, string memory symbol_) {
819     _name = name_;
820     _symbol = symbol_;
821   }
822 
823   /**
824   * @dev See {IERC165-supportsInterface}.
825   */
826   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
827     return
828     interfaceId == type(IERC721).interfaceId ||
829       interfaceId == type(IERC721Metadata).interfaceId ||
830       super.supportsInterface(interfaceId);
831   }
832 
833   /**
834   * @dev See {IERC721-balanceOf}.
835   */
836   function balanceOf(address owner) public view virtual override returns (uint256) {
837     require(owner != address(0), "ERC721: balance query for the zero address");
838     uint count;
839     for(uint i = 0; i < owners.length; i++) {
840       if(owner == owners[i]) {
841         count++;
842       }
843     }
844     return count;
845   }
846 
847   /**
848   * @dev See {IERC721-ownerOf}.
849   */
850   function ownerOf(uint256 tokenId) public view virtual override returns (address) {
851     require(tokenId < owners.length, "ERC721: owner query for nonexistent token");
852     address owner = owners[tokenId];
853     return owner;
854   }
855 
856   /**
857   * @dev See {IERC721Metadata-name}.
858   */
859   function name() public view virtual override returns (string memory) {
860     return _name;
861   }
862 
863   /**
864   * @dev See {IERC721Metadata-symbol}.
865   */
866   function symbol() public view virtual override returns (string memory) {
867     return _symbol;
868   }
869 
870   /**
871   * @dev See {IERC721Metadata-tokenURI}.
872   */
873   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
874     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
875 
876     string memory baseURI = _baseURI();
877     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
878   }
879 
880   /**
881   * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
882   * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
883   * by default, can be overriden in child contracts.
884     */
885   function _baseURI() internal view virtual returns (string memory) {
886     return "";
887   }
888 
889   /**
890   * @dev See {IERC721-approve}.
891   */
892   function approve(address to, uint256 tokenId) public virtual override {
893     address owner = ERC721.ownerOf(tokenId);
894     require(to != owner, "ERC721: approval to current owner");
895 
896     require(
897       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
898       "ERC721: approve caller is not owner nor approved for all"
899     );
900 
901     _approve(to, tokenId);
902   }
903 
904   /**
905   * @dev See {IERC721-getApproved}.
906   */
907   function getApproved(uint256 tokenId) public view virtual override returns (address) {
908     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
909 
910     return _tokenApprovals[tokenId];
911   }
912 
913   /**
914   * @dev See {IERC721-setApprovalForAll}.
915   */
916   function setApprovalForAll(address operator, bool approved) public virtual override {
917     require(operator != _msgSender(), "ERC721: approve to caller");
918 
919     _operatorApprovals[_msgSender()][operator] = approved;
920     emit ApprovalForAll(_msgSender(), operator, approved);
921   }
922 
923   /**
924   * @dev See {IERC721-isApprovedForAll}.
925   */
926   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
927     return _operatorApprovals[owner][operator];
928   }
929 
930   /**
931   * @dev See {IERC721-transferFrom}.
932   */
933   function transferFrom(
934     address from,
935     address to,
936     uint256 tokenId
937   ) public virtual override {
938     //solhint-disable-next-line max-line-length
939     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
940 
941     _transfer(from, to, tokenId);
942   }
943 
944   /**
945   * @dev See {IERC721-safeTransferFrom}.
946   */
947   function safeTransferFrom(
948     address from,
949     address to,
950     uint256 tokenId
951   ) public virtual override {
952     safeTransferFrom(from, to, tokenId, "");
953   }
954 
955   /**
956   * @dev See {IERC721-safeTransferFrom}.
957   */
958   function safeTransferFrom(
959     address from,
960     address to,
961     uint256 tokenId,
962     bytes memory _data
963   ) public virtual override {
964     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
965     _safeTransfer(from, to, tokenId, _data);
966   }
967 
968   /**
969   * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
970   * are aware of the ERC721 protocol to prevent tokens from being forever locked.
971     *
972     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
973     *
974     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
975     * implement alternative mechanisms to perform token transfer, such as signature-based.
976     *
977     * Requirements:
978     *
979     * - `from` cannot be the zero address.
980     * - `to` cannot be the zero address.
981     * - `tokenId` token must exist and be owned by `from`.
982     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
983     *
984     * Emits a {Transfer} event.
985     */
986   function _safeTransfer(
987     address from,
988     address to,
989     uint256 tokenId,
990     bytes memory _data
991   ) internal virtual {
992     _transfer(from, to, tokenId);
993     require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
994   }
995 
996   /**
997   * @dev Returns whether `tokenId` exists.
998   *
999     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1000     *
1001     * Tokens start existing when they are minted (`_mint`),
1002   * and stop existing when they are burned (`_burn`).
1003     */
1004   function _exists(uint256 tokenId) internal view virtual returns (bool) {
1005     return owners.length > tokenId && owners[tokenId] != address(0);
1006   }
1007 
1008   /**
1009   * @dev Returns whether `spender` is allowed to manage `tokenId`.
1010   *
1011     * Requirements:
1012     *
1013     * - `tokenId` must exist.
1014     */
1015   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1016     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1017     address owner = ERC721.ownerOf(tokenId);
1018     return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1019   }
1020 
1021   /**
1022   * @dev Safely mints `tokenId` and transfers it to `to`.
1023   *
1024     * Requirements:
1025     *
1026     * - `tokenId` must not exist.
1027     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1028     *
1029     * Emits a {Transfer} event.
1030     */
1031   function _safeMint(address to, uint256 tokenId) internal virtual {
1032     _safeMint(to, tokenId, "");
1033   }
1034 
1035   /**
1036   * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1037   * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1038     */
1039   function _safeMint(
1040     address to,
1041     uint256 tokenId,
1042     bytes memory _data
1043   ) internal virtual {
1044     _mint(to, tokenId);
1045     require(
1046       _checkOnERC721Received(address(0), to, tokenId, _data),
1047       "ERC721: transfer to non ERC721Receiver implementer"
1048     );
1049   }
1050 
1051   /**
1052   * @dev Mints `tokenId` and transfers it to `to`.
1053   *
1054     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1055   *
1056     * Requirements:
1057     *
1058     * - `tokenId` must not exist.
1059     * - `to` cannot be the zero address.
1060     *
1061     * Emits a {Transfer} event.
1062     */
1063   function _mint(address to, uint256 tokenId) internal virtual {
1064     require(to != address(0), "ERC721: mint to the zero address");
1065     require(!_exists(tokenId), "ALREADY_MINTED");
1066 
1067     owners.push(to);
1068     emit Transfer(address(0), to, tokenId);
1069   }
1070 
1071   /**
1072   * @dev Destroys `tokenId`.
1073   * The approval is cleared when the token is burned.
1074     *
1075     * Requirements:
1076     *
1077     * - `tokenId` must exist.
1078     *
1079     * Emits a {Transfer} event.
1080     */
1081   function _burn(uint256 tokenId) internal virtual {
1082     address owner = ERC721.ownerOf(tokenId);
1083 
1084     require(
1085       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1086       "ERC721: approve caller is not owner nor approved for all"
1087     );
1088 
1089     // Clear approvals
1090     _approve(address(0), tokenId);
1091 
1092     // delete owners[tokenId];
1093     owners[tokenId] = address(0);
1094     burnedTokens++;
1095 
1096     emit Transfer(owner, address(0), tokenId);
1097   }
1098 
1099   /**
1100   * @dev Transfers `tokenId` from `from` to `to`.
1101   *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1102     *
1103     * Requirements:
1104     *
1105     * - `to` cannot be the zero address.
1106     * - `tokenId` token must be owned by `from`.
1107     *
1108     * Emits a {Transfer} event.
1109     */
1110   function _transfer(
1111     address from,
1112     address to,
1113     uint256 tokenId
1114   ) internal virtual {
1115     require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1116     require(to != address(0), "ERC721: transfer to the zero address");
1117 
1118     // Clear approvals from the previous owner
1119     _approve(address(0), tokenId);
1120 
1121     owners[tokenId] = to;
1122 
1123     emit Transfer(from, to, tokenId);
1124   }
1125 
1126   /**
1127   * @dev Approve `to` to operate on `tokenId`
1128   *
1129     * Emits a {Approval} event.
1130     */
1131   function _approve(address to, uint256 tokenId) internal virtual {
1132     _tokenApprovals[tokenId] = to;
1133     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1134   }
1135 
1136   /**
1137   * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1138   * The call is not executed if the target address is not a contract.
1139   *
1140   * @param from address representing the previous owner of the given token ID
1141   * @param to target address that will receive the tokens
1142   * @param tokenId uint256 ID of the token to be transferred
1143   * @param _data bytes optional data to send along with the call
1144   * @return bool whether the call correctly returned the expected magic value
1145   */
1146   function _checkOnERC721Received(
1147     address from,
1148     address to,
1149     uint256 tokenId,
1150     bytes memory _data
1151   ) private returns (bool) {
1152     if (to.isContract()) {
1153       try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1154         return retval == IERC721Receiver.onERC721Received.selector;
1155       } catch (bytes memory reason) {
1156         if (reason.length == 0) {
1157           revert("ERC721: transfer to non ERC721Receiver implementer");
1158         } else {
1159           assembly {
1160             revert(add(32, reason), mload(reason))
1161           }
1162         }
1163       }
1164     } else {
1165       return true;
1166     }
1167   }
1168 }
1169 
1170 
1171 // File: contracts/FroyoKittens.sol
1172 
1173 
1174 pragma solidity ^0.8.6;
1175 
1176 
1177 
1178 
1179 
1180 contract FroyoKittens is ERC721, Ownable {
1181 
1182   //---------------------------------------------------------------
1183   //  CONSTANTS
1184   //---------------------------------------------------------------
1185   uint256 public constant MAX_SUPPLY = 10000;
1186   uint256 public constant NFT_PRICE = 0.1 ether;
1187   uint256 public constant WHITELIST_PRICE = 0.1 ether;
1188   uint256 public mintStartTime;
1189   bool    public isRevealed;
1190 
1191   //---------------------------------------------------------------
1192   //  METADATA
1193   //---------------------------------------------------------------
1194   string public baseURI;
1195   string public coverURI;
1196 
1197   function tokenURI(uint256 id) public view virtual override returns (string memory) {
1198     require(_exists(id), "ERC721Metadata: URI query for nonexistent token");
1199     if(!isRevealed) {
1200       return coverURI;
1201     }
1202 
1203     return string(abi.encodePacked(baseURI, Strings.toString(id), ".json"));
1204   }
1205 
1206   //---------------------------------------------------------------
1207   //  CONSTRUCTOR
1208   //---------------------------------------------------------------
1209 
1210   constructor(string memory _coverURI) ERC721("FroyoKittens", "FroyoKitten") {
1211     coverURI = _coverURI;
1212     // Sunday, 10 April 2022 at 00:00 UTC
1213     mintStartTime = 1649563200;
1214   }
1215 
1216   function mint(uint256 amount) public payable {
1217     require(msg.value == (amount * NFT_PRICE), "WRONG_ETH_AMOUNT");
1218     require(owners.length + amount <= MAX_SUPPLY, "MAX_SUPPLY");
1219     require(block.timestamp >= mintStartTime, "NOT_LIVE");
1220 
1221     minters[msg.sender] += amount;
1222     require(minters[msg.sender] < 3, "ADDRESS_MAX_REACHED");
1223     for(uint256 i = 0; i < amount; i++) {
1224       _safeMint(msg.sender, owners.length);
1225     }
1226   }
1227 
1228   mapping (address => uint256) public minters;
1229 
1230   function burn(uint256 id) public {
1231     _burn(id);
1232   }
1233 
1234   //----------------------------------------------------------------
1235   //  WHITELISTS
1236   //----------------------------------------------------------------
1237 
1238   /// @dev - Merkle Tree root hash
1239   bytes32 public root;
1240 
1241   function setMerkleRoot(bytes32 merkleroot) public onlyOwner {
1242     root = merkleroot;
1243   }
1244 
1245   function premint(uint256 amount, bytes32[] calldata proof)
1246   external
1247   payable
1248   {
1249     address account = msg.sender;
1250     require(_verify(_leaf(account), proof), "INVALID_MERKLE_PROOF");
1251     require(msg.value == (amount * WHITELIST_PRICE), "WRONG_ETH_AMOUNT");
1252     require(owners.length + amount <= MAX_SUPPLY, "MAX_SUPPLY");
1253 
1254     minters[msg.sender] += amount;
1255     require(minters[account] < 3, "ADDRESS_MAX_REACHED");
1256 
1257     for(uint256 i = 0; i < amount; i++) {
1258       _safeMint(account, owners.length);
1259     }
1260   }
1261 
1262   function _leaf(address account)
1263   internal pure returns (bytes32)
1264   {
1265     return keccak256(abi.encodePacked(account));
1266   }
1267 
1268   function _verify(bytes32 leaf, bytes32[] memory proof)
1269   internal view returns (bool)
1270   {
1271     return MerkleProof.verify(proof, root, leaf);
1272   }
1273 
1274   //----------------------------------------------------------------
1275   //  ADMIN FUNCTIONS
1276   //----------------------------------------------------------------
1277 
1278   function setCoverURI(string memory uri) public onlyOwner {
1279     coverURI = uri;
1280   }
1281   function setBaseURI(string memory uri) public onlyOwner {
1282     baseURI = uri;
1283   }
1284   function setMintStartTime(uint256 _startTime) public onlyOwner {
1285     mintStartTime = _startTime;
1286   }
1287   function setIsRevealed(bool _isRevealed) public onlyOwner {
1288     isRevealed = _isRevealed;
1289   }
1290 
1291   //---------------------------------------------------------------
1292   // WITHDRAWAL
1293   //---------------------------------------------------------------
1294 
1295   function withdraw(address to, uint256 amount) public onlyOwner {
1296     (bool success,) = payable(to).call{ value: amount }("");
1297     require(success, "WITHDRAWAL_FAILED");
1298   }
1299 }