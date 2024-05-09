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
698 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
699 
700 
701 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
708  * @dev See https://eips.ethereum.org/EIPS/eip-721
709  */
710 interface IERC721Enumerable is IERC721 {
711     /**
712      * @dev Returns the total amount of tokens stored by the contract.
713      */
714     function totalSupply() external view returns (uint256);
715 
716     /**
717      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
718      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
719      */
720     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
721 
722     /**
723      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
724      * Use along with {totalSupply} to enumerate all tokens.
725      */
726     function tokenByIndex(uint256 index) external view returns (uint256);
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
739  * @dev See https://eips.ethereum.org/EIPS/eip-721
740  */
741 interface IERC721Metadata is IERC721 {
742     /**
743      * @dev Returns the token collection name.
744      */
745     function name() external view returns (string memory);
746 
747     /**
748      * @dev Returns the token collection symbol.
749      */
750     function symbol() external view returns (string memory);
751 
752     /**
753      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
754      */
755     function tokenURI(uint256 tokenId) external view returns (string memory);
756 }
757 
758 // File: contracts/ERC721A.sol
759 
760 
761 // Creator: Chiru Labs
762 
763 pragma solidity ^0.8.0;
764 
765 
766 
767 
768 
769 
770 
771 
772 
773 
774 /**
775  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
776  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
777  *
778  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
779  *
780  * Does not support burning tokens to address(0).
781  *
782  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
783  */
784 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
785     using Address for address;
786     using Strings for uint256;
787 
788     struct TokenOwnership {
789         address addr;
790         uint64 startTimestamp;
791     }
792 
793     struct AddressData {
794         uint128 balance;
795         uint128 numberMinted;
796     }
797 
798     uint256 internal currentIndex;
799 
800     // Token name
801     string private _name;
802 
803     // Token symbol
804     string private _symbol;
805 
806     // Mapping from token ID to ownership details
807     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
808     mapping(uint256 => TokenOwnership) internal _ownerships;
809 
810     // Mapping owner address to address data
811     mapping(address => AddressData) private _addressData;
812 
813     // Mapping from token ID to approved address
814     mapping(uint256 => address) private _tokenApprovals;
815 
816     // Mapping from owner to operator approvals
817     mapping(address => mapping(address => bool)) private _operatorApprovals;
818 
819     constructor(string memory name_, string memory symbol_) {
820         _name = name_;
821         _symbol = symbol_;
822     }
823 
824     /**
825      * @dev See {IERC721Enumerable-totalSupply}.
826      */
827     function totalSupply() public view override returns (uint256) {
828         return currentIndex;
829     }
830 
831     /**
832      * @dev See {IERC721Enumerable-tokenByIndex}.
833      */
834     function tokenByIndex(uint256 index) public view override returns (uint256) {
835         require(index < totalSupply(), 'ERC721A: global index out of bounds');
836         return index;
837     }
838 
839     /**
840      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
841      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
842      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
843      */
844     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
845         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
846         uint256 numMintedSoFar = totalSupply();
847         uint256 tokenIdsIdx;
848         address currOwnershipAddr;
849 
850         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
851         unchecked {
852             for (uint256 i; i < numMintedSoFar; i++) {
853                 TokenOwnership memory ownership = _ownerships[i];
854                 if (ownership.addr != address(0)) {
855                     currOwnershipAddr = ownership.addr;
856                 }
857                 if (currOwnershipAddr == owner) {
858                     if (tokenIdsIdx == index) {
859                         return i;
860                     }
861                     tokenIdsIdx++;
862                 }
863             }
864         }
865 
866         revert('ERC721A: unable to get token of owner by index');
867     }
868 
869     /**
870      * @dev See {IERC165-supportsInterface}.
871      */
872     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
873         return
874             interfaceId == type(IERC721).interfaceId ||
875             interfaceId == type(IERC721Metadata).interfaceId ||
876             interfaceId == type(IERC721Enumerable).interfaceId ||
877             super.supportsInterface(interfaceId);
878     }
879 
880     /**
881      * @dev See {IERC721-balanceOf}.
882      */
883     function balanceOf(address owner) public view override returns (uint256) {
884         require(owner != address(0), 'ERC721A: balance query for the zero address');
885         return uint256(_addressData[owner].balance);
886     }
887 
888     function _numberMinted(address owner) internal view returns (uint256) {
889         require(owner != address(0), 'ERC721A: number minted query for the zero address');
890         return uint256(_addressData[owner].numberMinted);
891     }
892 
893     /**
894      * Gas spent here starts off proportional to the maximum mint batch size.
895      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
896      */
897     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
898         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
899 
900         unchecked {
901             for (uint256 curr = tokenId; curr >= 0; curr--) {
902                 TokenOwnership memory ownership = _ownerships[curr];
903                 if (ownership.addr != address(0)) {
904                     return ownership;
905                 }
906             }
907         }
908 
909         revert('ERC721A: unable to determine the owner of token');
910     }
911 
912     /**
913      * @dev See {IERC721-ownerOf}.
914      */
915     function ownerOf(uint256 tokenId) public view override returns (address) {
916         return ownershipOf(tokenId).addr;
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-name}.
921      */
922     function name() public view virtual override returns (string memory) {
923         return _name;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-symbol}.
928      */
929     function symbol() public view virtual override returns (string memory) {
930         return _symbol;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-tokenURI}.
935      */
936     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
937         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
938 
939         string memory baseURI = _baseURI();
940         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
941     }
942 
943     /**
944      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
945      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
946      * by default, can be overriden in child contracts.
947      */
948     function _baseURI() internal view virtual returns (string memory) {
949         return '';
950     }
951 
952     /**
953      * @dev See {IERC721-approve}.
954      */
955     function approve(address to, uint256 tokenId) public override {
956         address owner = ERC721A.ownerOf(tokenId);
957         require(to != owner, 'ERC721A: approval to current owner');
958 
959         require(
960             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
961             'ERC721A: approve caller is not owner nor approved for all'
962         );
963 
964         _approve(to, tokenId, owner);
965     }
966 
967     /**
968      * @dev See {IERC721-getApproved}.
969      */
970     function getApproved(uint256 tokenId) public view override returns (address) {
971         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
972 
973         return _tokenApprovals[tokenId];
974     }
975 
976     /**
977      * @dev See {IERC721-setApprovalForAll}.
978      */
979     function setApprovalForAll(address operator, bool approved) public override {
980         require(operator != _msgSender(), 'ERC721A: approve to caller');
981 
982         _operatorApprovals[_msgSender()][operator] = approved;
983         emit ApprovalForAll(_msgSender(), operator, approved);
984     }
985 
986     /**
987      * @dev See {IERC721-isApprovedForAll}.
988      */
989     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
990         return _operatorApprovals[owner][operator];
991     }
992 
993     /**
994      * @dev See {IERC721-transferFrom}.
995      */
996     function transferFrom(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) public virtual override {
1001         _transfer(from, to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-safeTransferFrom}.
1006      */
1007     function safeTransferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         safeTransferFrom(from, to, tokenId, '');
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) public override {
1024         _transfer(from, to, tokenId);
1025         require(
1026             _checkOnERC721Received(from, to, tokenId, _data),
1027             'ERC721A: transfer to non ERC721Receiver implementer'
1028         );
1029     }
1030 
1031     /**
1032      * @dev Returns whether `tokenId` exists.
1033      *
1034      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1035      *
1036      * Tokens start existing when they are minted (`_mint`),
1037      */
1038     function _exists(uint256 tokenId) internal view returns (bool) {
1039         return tokenId < currentIndex;
1040     }
1041 
1042     function _safeMint(address to, uint256 quantity) internal {
1043         _safeMint(to, quantity, '');
1044     }
1045 
1046     /**
1047      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1052      * - `quantity` must be greater than 0.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _safeMint(
1057         address to,
1058         uint256 quantity,
1059         bytes memory _data
1060     ) internal {
1061         _mint(to, quantity, _data, true);
1062     }
1063 
1064     /**
1065      * @dev Mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `to` cannot be the zero address.
1070      * - `quantity` must be greater than 0.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _mint(
1075         address to,
1076         uint256 quantity,
1077         bytes memory _data,
1078         bool safe
1079     ) internal {
1080         uint256 startTokenId = currentIndex;
1081         require(to != address(0), 'ERC721A: mint to the zero address');
1082         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1083 
1084         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1085 
1086         // Overflows are incredibly unrealistic.
1087         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1088         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1089         unchecked {
1090             _addressData[to].balance += uint128(quantity);
1091             _addressData[to].numberMinted += uint128(quantity);
1092 
1093             _ownerships[startTokenId].addr = to;
1094             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1095 
1096             uint256 updatedIndex = startTokenId;
1097 
1098             for (uint256 i; i < quantity; i++) {
1099                 emit Transfer(address(0), to, updatedIndex);
1100                 if (safe) {
1101                     require(
1102                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1103                         'ERC721A: transfer to non ERC721Receiver implementer'
1104                     );
1105                 }
1106 
1107                 updatedIndex++;
1108             }
1109 
1110             currentIndex = updatedIndex;
1111         }
1112 
1113         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1114     }
1115 
1116     /**
1117      * @dev Transfers `tokenId` from `from` to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must be owned by `from`.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _transfer(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) private {
1131         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1132 
1133         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1134             getApproved(tokenId) == _msgSender() ||
1135             isApprovedForAll(prevOwnership.addr, _msgSender()));
1136 
1137         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1138 
1139         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1140         require(to != address(0), 'ERC721A: transfer to the zero address');
1141 
1142         _beforeTokenTransfers(from, to, tokenId, 1);
1143 
1144         // Clear approvals from the previous owner
1145         _approve(address(0), tokenId, prevOwnership.addr);
1146 
1147         // Underflow of the sender's balance is impossible because we check for
1148         // ownership above and the recipient's balance can't realistically overflow.
1149         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1150         unchecked {
1151             _addressData[from].balance -= 1;
1152             _addressData[to].balance += 1;
1153 
1154             _ownerships[tokenId].addr = to;
1155             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1156 
1157             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1158             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1159             uint256 nextTokenId = tokenId + 1;
1160             if (_ownerships[nextTokenId].addr == address(0)) {
1161                 if (_exists(nextTokenId)) {
1162                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1163                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1164                 }
1165             }
1166         }
1167 
1168         emit Transfer(from, to, tokenId);
1169         _afterTokenTransfers(from, to, tokenId, 1);
1170     }
1171 
1172     /**
1173      * @dev Approve `to` to operate on `tokenId`
1174      *
1175      * Emits a {Approval} event.
1176      */
1177     function _approve(
1178         address to,
1179         uint256 tokenId,
1180         address owner
1181     ) private {
1182         _tokenApprovals[tokenId] = to;
1183         emit Approval(owner, to, tokenId);
1184     }
1185 
1186     /**
1187      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1188      * The call is not executed if the target address is not a contract.
1189      *
1190      * @param from address representing the previous owner of the given token ID
1191      * @param to target address that will receive the tokens
1192      * @param tokenId uint256 ID of the token to be transferred
1193      * @param _data bytes optional data to send along with the call
1194      * @return bool whether the call correctly returned the expected magic value
1195      */
1196     function _checkOnERC721Received(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) private returns (bool) {
1202         if (to.isContract()) {
1203             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1204                 return retval == IERC721Receiver(to).onERC721Received.selector;
1205             } catch (bytes memory reason) {
1206                 if (reason.length == 0) {
1207                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1208                 } else {
1209                     assembly {
1210                         revert(add(32, reason), mload(reason))
1211                     }
1212                 }
1213             }
1214         } else {
1215             return true;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1221      *
1222      * startTokenId - the first token id to be transferred
1223      * quantity - the amount to be transferred
1224      *
1225      * Calling conditions:
1226      *
1227      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1228      * transferred to `to`.
1229      * - When `from` is zero, `tokenId` will be minted for `to`.
1230      */
1231     function _beforeTokenTransfers(
1232         address from,
1233         address to,
1234         uint256 startTokenId,
1235         uint256 quantity
1236     ) internal virtual {}
1237 
1238     /**
1239      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1240      * minting.
1241      *
1242      * startTokenId - the first token id to be transferred
1243      * quantity - the amount to be transferred
1244      *
1245      * Calling conditions:
1246      *
1247      * - when `from` and `to` are both non-zero.
1248      * - `from` and `to` are never both zero.
1249      */
1250     function _afterTokenTransfers(
1251         address from,
1252         address to,
1253         uint256 startTokenId,
1254         uint256 quantity
1255     ) internal virtual {}
1256 }
1257 // File: contracts/FreakyLabs.sol
1258 
1259 
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 
1264 
1265 contract FreakyLabs is ERC721A, Ownable {
1266     using Strings for uint256;
1267     
1268     bool public public_sale_running = false;
1269     bool public private_sale_running = false;
1270 
1271     uint public MINT_PRICE = 0.08 ether;
1272     uint public MAX_SUPPLY = 3333;
1273     uint public MAX_PER_TX = 5;
1274 
1275     bytes32 public exec_merkle_root;
1276     bytes32 public partial_free_mint_root;
1277     bytes32 public merkle_root;
1278     mapping(address => bool) public whitelist_claimed;
1279     mapping(address => uint) public total_claimed;
1280 
1281     
1282     constructor () ERC721A("Freaky Labs", "CUBS") {
1283         _safeMint(0x8E05Dd1aA83Ddd84dc54160766bE2DFCCD244C9B, 100);
1284     }
1285     
1286     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1287         return string(abi.encodePacked("https://freakylabs.io/metadata/", (tokenId + 1).toString()));
1288     }   
1289 
1290     function isLabExec(bytes32 [] calldata _merkleProof) public view returns(bool) {
1291         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1292         return MerkleProof.verify(_merkleProof, exec_merkle_root, leaf);
1293     }
1294 
1295     function isPartialFreeMintWhitelisted(bytes32 [] calldata _merkleProof) public view returns(bool) {
1296         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1297         return MerkleProof.verify(_merkleProof, partial_free_mint_root, leaf);
1298     }
1299 
1300     function isStandardWhitelisted(bytes32 [] calldata _merkleProof) public view returns(bool) {
1301         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1302         return MerkleProof.verify(_merkleProof, merkle_root, leaf);
1303     }
1304 
1305     function freakyLabExecMint(bytes32 [] calldata _merkleProof) external {
1306         require(tx.origin == msg.sender);
1307         require(private_sale_running || public_sale_running, "Sale is not running");
1308         require(!whitelist_claimed[msg.sender], "No whitelist allocation remaining");
1309         require(total_claimed[msg.sender] == 0, "Cannot claim more");
1310         require(totalSupply() + 3 <= MAX_SUPPLY, "Not enough tokens left to mint");
1311         require(isLabExec(_merkleProof), "Invalid proof");
1312 
1313         whitelist_claimed[msg.sender] = true;
1314         _safeMint(msg.sender, 3);
1315     }
1316 
1317     function partialFreeMint(bytes32 [] calldata _merkleProof) external payable {
1318         require(tx.origin == msg.sender);
1319         require(private_sale_running, "Private sale is not running");
1320         require(!whitelist_claimed[msg.sender], "No whitelist allocation remaining");
1321         require(total_claimed[msg.sender] == 0, "Cannot claim more");
1322         require(msg.value == MINT_PRICE, "Incorrect ETH sent to mint");
1323         require(totalSupply() < MAX_SUPPLY, "Not enough tokens left to mint");
1324         require(isPartialFreeMintWhitelisted(_merkleProof), "Invalid proof");
1325 
1326         whitelist_claimed[msg.sender] = true;
1327         _safeMint(msg.sender, 2);
1328     }
1329     
1330     function whitelistMint(bytes32 [] calldata _merkleProof, uint _quantity) external payable {
1331         require(tx.origin == msg.sender);
1332         require(private_sale_running, "Private sale is not running");
1333         require(!whitelist_claimed[msg.sender], "No whitelist allocation remaining");
1334         require(total_claimed[msg.sender] + _quantity <= 2, "Can't claim more than 2 total");
1335         require(msg.value == MINT_PRICE * _quantity, "Incorrect ETH sent to mint");
1336         require(totalSupply() + _quantity <= MAX_SUPPLY, "Not enough tokens left to mint");
1337         require(isStandardWhitelisted(_merkleProof), "Invalid proof");
1338 
1339         total_claimed[msg.sender] += _quantity;
1340         _safeMint(msg.sender, _quantity);
1341     }
1342 
1343     function publicMint(uint _quantity) external payable {
1344         require(tx.origin == msg.sender);
1345         require(public_sale_running, "Public sale is not running");
1346         require(_quantity <= MAX_PER_TX, "Invalid number of tokens queries for minting");
1347         require(msg.value == MINT_PRICE * _quantity, "Incorrect ETH sent to mint");
1348         require(totalSupply() + _quantity <= MAX_SUPPLY, "Not enough tokens left to mint");
1349         
1350         _safeMint(msg.sender, _quantity);
1351     }
1352 
1353     function burn(uint _token_id) external {
1354         address burn_address = 0x000000000000000000000000000000000000dEaD;
1355         safeTransferFrom(msg.sender, burn_address, _token_id);
1356     }
1357     
1358     function togglePublicSale() external onlyOwner {
1359         public_sale_running = !public_sale_running;
1360     }
1361 
1362     function togglePrivateSale() external onlyOwner {
1363         private_sale_running = !private_sale_running;
1364     }
1365 
1366     function adminMint(address _destination, uint _quantity) external onlyOwner {
1367         require(totalSupply() + _quantity <= MAX_SUPPLY, "Not enough tokens left to mint");
1368         _safeMint(_destination, _quantity);
1369     }
1370 
1371     function updateLabExecMerkleRoot(bytes32 _new_root) external onlyOwner {
1372         exec_merkle_root = _new_root;
1373     }
1374 
1375     function updatePartialFreeMintRoot(bytes32 _new_root) external onlyOwner {
1376         partial_free_mint_root = _new_root;
1377     } 
1378 
1379     function updateWhitelistMerkleRoot(bytes32 _new_root) external onlyOwner {
1380         merkle_root = _new_root;
1381     }
1382 
1383     function updateMaxSupply(uint _new_supply) external onlyOwner {
1384         require(_new_supply < MAX_SUPPLY, "Cannot increase supply");
1385         MAX_SUPPLY = _new_supply;
1386     }
1387 
1388     function updateMintingPrice(uint _new_price) external onlyOwner {
1389         MINT_PRICE = _new_price;
1390     }
1391 
1392     function updateMaxPerTransaction(uint _new_amount) external onlyOwner {
1393         MAX_PER_TX = _new_amount;
1394     }
1395     
1396     function withdraw() external onlyOwner {
1397         payable(0x8E05Dd1aA83Ddd84dc54160766bE2DFCCD244C9B).transfer(address(this).balance);
1398     }
1399 }