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
758 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
759 
760 
761 // Creator: Chiru Labs
762 
763 pragma solidity ^0.8.4;
764 
765 
766 
767 
768 
769 
770 
771 
772 
773 error ApprovalCallerNotOwnerNorApproved();
774 error ApprovalQueryForNonexistentToken();
775 error ApproveToCaller();
776 error ApprovalToCurrentOwner();
777 error BalanceQueryForZeroAddress();
778 error MintedQueryForZeroAddress();
779 error BurnedQueryForZeroAddress();
780 error AuxQueryForZeroAddress();
781 error MintToZeroAddress();
782 error MintZeroQuantity();
783 error OwnerIndexOutOfBounds();
784 error OwnerQueryForNonexistentToken();
785 error TokenIndexOutOfBounds();
786 error TransferCallerNotOwnerNorApproved();
787 error TransferFromIncorrectOwner();
788 error TransferToNonERC721ReceiverImplementer();
789 error TransferToZeroAddress();
790 error URIQueryForNonexistentToken();
791 
792 /**
793  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
794  * the Metadata extension. Built to optimize for lower gas during batch mints.
795  *
796  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
797  *
798  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
799  *
800  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
801  */
802 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
803     using Address for address;
804     using Strings for uint256;
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
830     // The tokenId of the next token to be minted.
831     uint256 internal _currentIndex;
832 
833     // The number of tokens burned.
834     uint256 internal _burnCounter;
835 
836     // Token name
837     string private _name;
838 
839     // Token symbol
840     string private _symbol;
841 
842     // Mapping from token ID to ownership details
843     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
844     mapping(uint256 => TokenOwnership) internal _ownerships;
845 
846     // Mapping owner address to address data
847     mapping(address => AddressData) private _addressData;
848 
849     // Mapping from token ID to approved address
850     mapping(uint256 => address) private _tokenApprovals;
851 
852     // Mapping from owner to operator approvals
853     mapping(address => mapping(address => bool)) private _operatorApprovals;
854 
855     constructor(string memory name_, string memory symbol_) {
856         _name = name_;
857         _symbol = symbol_;
858         _currentIndex = _startTokenId();
859     }
860 
861     /**
862      * To change the starting tokenId, please override this function.
863      */
864     function _startTokenId() internal view virtual returns (uint256) {
865         return 0;
866     }
867 
868     /**
869      * @dev See {IERC721Enumerable-totalSupply}.
870      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
871      */
872     function totalSupply() public view returns (uint256) {
873         // Counter underflow is impossible as _burnCounter cannot be incremented
874         // more than _currentIndex - _startTokenId() times
875         unchecked {
876             return _currentIndex - _burnCounter - _startTokenId();
877         }
878     }
879 
880     /**
881      * Returns the total amount of tokens minted in the contract.
882      */
883     function _totalMinted() internal view returns (uint256) {
884         // Counter underflow is impossible as _currentIndex does not decrement,
885         // and it is initialized to _startTokenId()
886         unchecked {
887             return _currentIndex - _startTokenId();
888         }
889     }
890 
891     /**
892      * @dev See {IERC165-supportsInterface}.
893      */
894     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
895         return
896             interfaceId == type(IERC721).interfaceId ||
897             interfaceId == type(IERC721Metadata).interfaceId ||
898             super.supportsInterface(interfaceId);
899     }
900 
901     /**
902      * @dev See {IERC721-balanceOf}.
903      */
904     function balanceOf(address owner) public view override returns (uint256) {
905         if (owner == address(0)) revert BalanceQueryForZeroAddress();
906         return uint256(_addressData[owner].balance);
907     }
908 
909     /**
910      * Returns the number of tokens minted by `owner`.
911      */
912     function _numberMinted(address owner) internal view returns (uint256) {
913         if (owner == address(0)) revert MintedQueryForZeroAddress();
914         return uint256(_addressData[owner].numberMinted);
915     }
916 
917     /**
918      * Returns the number of tokens burned by or on behalf of `owner`.
919      */
920     function _numberBurned(address owner) internal view returns (uint256) {
921         if (owner == address(0)) revert BurnedQueryForZeroAddress();
922         return uint256(_addressData[owner].numberBurned);
923     }
924 
925     /**
926      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
927      */
928     function _getAux(address owner) internal view returns (uint64) {
929         if (owner == address(0)) revert AuxQueryForZeroAddress();
930         return _addressData[owner].aux;
931     }
932 
933     /**
934      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
935      * If there are multiple variables, please pack them into a uint64.
936      */
937     function _setAux(address owner, uint64 aux) internal {
938         if (owner == address(0)) revert AuxQueryForZeroAddress();
939         _addressData[owner].aux = aux;
940     }
941 
942     /**
943      * Gas spent here starts off proportional to the maximum mint batch size.
944      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
945      */
946     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
947         uint256 curr = tokenId;
948 
949         unchecked {
950             if (_startTokenId() <= curr && curr < _currentIndex) {
951                 TokenOwnership memory ownership = _ownerships[curr];
952                 if (!ownership.burned) {
953                     if (ownership.addr != address(0)) {
954                         return ownership;
955                     }
956                     // Invariant:
957                     // There will always be an ownership that has an address and is not burned
958                     // before an ownership that does not have an address and is not burned.
959                     // Hence, curr will not underflow.
960                     while (true) {
961                         curr--;
962                         ownership = _ownerships[curr];
963                         if (ownership.addr != address(0)) {
964                             return ownership;
965                         }
966                     }
967                 }
968             }
969         }
970         revert OwnerQueryForNonexistentToken();
971     }
972 
973     /**
974      * @dev See {IERC721-ownerOf}.
975      */
976     function ownerOf(uint256 tokenId) public view override returns (address) {
977         return ownershipOf(tokenId).addr;
978     }
979 
980     /**
981      * @dev See {IERC721Metadata-name}.
982      */
983     function name() public view virtual override returns (string memory) {
984         return _name;
985     }
986 
987     /**
988      * @dev See {IERC721Metadata-symbol}.
989      */
990     function symbol() public view virtual override returns (string memory) {
991         return _symbol;
992     }
993 
994     /**
995      * @dev See {IERC721Metadata-tokenURI}.
996      */
997     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
998         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
999 
1000         string memory baseURI = _baseURI();
1001         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1002     }
1003 
1004     /**
1005      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1006      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1007      * by default, can be overriden in child contracts.
1008      */
1009     function _baseURI() internal view virtual returns (string memory) {
1010         return '';
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-approve}.
1015      */
1016     function approve(address to, uint256 tokenId) public override {
1017         address owner = ERC721A.ownerOf(tokenId);
1018         if (to == owner) revert ApprovalToCurrentOwner();
1019 
1020         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1021             revert ApprovalCallerNotOwnerNorApproved();
1022         }
1023 
1024         _approve(to, tokenId, owner);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-getApproved}.
1029      */
1030     function getApproved(uint256 tokenId) public view override returns (address) {
1031         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1032 
1033         return _tokenApprovals[tokenId];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-setApprovalForAll}.
1038      */
1039     function setApprovalForAll(address operator, bool approved) public override {
1040         if (operator == _msgSender()) revert ApproveToCaller();
1041 
1042         _operatorApprovals[_msgSender()][operator] = approved;
1043         emit ApprovalForAll(_msgSender(), operator, approved);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-isApprovedForAll}.
1048      */
1049     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1050         return _operatorApprovals[owner][operator];
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-transferFrom}.
1055      */
1056     function transferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) public virtual override {
1061         _transfer(from, to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-safeTransferFrom}.
1066      */
1067     function safeTransferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) public virtual override {
1072         safeTransferFrom(from, to, tokenId, '');
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-safeTransferFrom}.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId,
1082         bytes memory _data
1083     ) public virtual override {
1084         _transfer(from, to, tokenId);
1085         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1086             revert TransferToNonERC721ReceiverImplementer();
1087         }
1088     }
1089 
1090     /**
1091      * @dev Returns whether `tokenId` exists.
1092      *
1093      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1094      *
1095      * Tokens start existing when they are minted (`_mint`),
1096      */
1097     function _exists(uint256 tokenId) internal view returns (bool) {
1098         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1099             !_ownerships[tokenId].burned;
1100     }
1101 
1102     function _safeMint(address to, uint256 quantity) internal {
1103         _safeMint(to, quantity, '');
1104     }
1105 
1106     /**
1107      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1112      * - `quantity` must be greater than 0.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _safeMint(
1117         address to,
1118         uint256 quantity,
1119         bytes memory _data
1120     ) internal {
1121         _mint(to, quantity, _data, true);
1122     }
1123 
1124     /**
1125      * @dev Mints `quantity` tokens and transfers them to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `quantity` must be greater than 0.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _mint(
1135         address to,
1136         uint256 quantity,
1137         bytes memory _data,
1138         bool safe
1139     ) internal {
1140         uint256 startTokenId = _currentIndex;
1141         if (to == address(0)) revert MintToZeroAddress();
1142         if (quantity == 0) revert MintZeroQuantity();
1143 
1144         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1145 
1146         // Overflows are incredibly unrealistic.
1147         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1148         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1149         unchecked {
1150             _addressData[to].balance += uint64(quantity);
1151             _addressData[to].numberMinted += uint64(quantity);
1152 
1153             _ownerships[startTokenId].addr = to;
1154             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1155 
1156             uint256 updatedIndex = startTokenId;
1157             uint256 end = updatedIndex + quantity;
1158 
1159             if (safe && to.isContract()) {
1160                 do {
1161                     emit Transfer(address(0), to, updatedIndex);
1162                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1163                         revert TransferToNonERC721ReceiverImplementer();
1164                     }
1165                 } while (updatedIndex != end);
1166                 // Reentrancy protection
1167                 if (_currentIndex != startTokenId) revert();
1168             } else {
1169                 do {
1170                     emit Transfer(address(0), to, updatedIndex++);
1171                 } while (updatedIndex != end);
1172             }
1173             _currentIndex = updatedIndex;
1174         }
1175         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1176     }
1177 
1178     /**
1179      * @dev Transfers `tokenId` from `from` to `to`.
1180      *
1181      * Requirements:
1182      *
1183      * - `to` cannot be the zero address.
1184      * - `tokenId` token must be owned by `from`.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _transfer(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) private {
1193         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1194 
1195         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1196             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1197             getApproved(tokenId) == _msgSender());
1198 
1199         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1200         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1201         if (to == address(0)) revert TransferToZeroAddress();
1202 
1203         _beforeTokenTransfers(from, to, tokenId, 1);
1204 
1205         // Clear approvals from the previous owner
1206         _approve(address(0), tokenId, prevOwnership.addr);
1207 
1208         // Underflow of the sender's balance is impossible because we check for
1209         // ownership above and the recipient's balance can't realistically overflow.
1210         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1211         unchecked {
1212             _addressData[from].balance -= 1;
1213             _addressData[to].balance += 1;
1214 
1215             _ownerships[tokenId].addr = to;
1216             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1217 
1218             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1219             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1220             uint256 nextTokenId = tokenId + 1;
1221             if (_ownerships[nextTokenId].addr == address(0)) {
1222                 // This will suffice for checking _exists(nextTokenId),
1223                 // as a burned slot cannot contain the zero address.
1224                 if (nextTokenId < _currentIndex) {
1225                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1226                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(from, to, tokenId);
1232         _afterTokenTransfers(from, to, tokenId, 1);
1233     }
1234 
1235     /**
1236      * @dev Destroys `tokenId`.
1237      * The approval is cleared when the token is burned.
1238      *
1239      * Requirements:
1240      *
1241      * - `tokenId` must exist.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _burn(uint256 tokenId) internal virtual {
1246         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1247 
1248         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1249 
1250         // Clear approvals from the previous owner
1251         _approve(address(0), tokenId, prevOwnership.addr);
1252 
1253         // Underflow of the sender's balance is impossible because we check for
1254         // ownership above and the recipient's balance can't realistically overflow.
1255         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1256         unchecked {
1257             _addressData[prevOwnership.addr].balance -= 1;
1258             _addressData[prevOwnership.addr].numberBurned += 1;
1259 
1260             // Keep track of who burned the token, and the timestamp of burning.
1261             _ownerships[tokenId].addr = prevOwnership.addr;
1262             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1263             _ownerships[tokenId].burned = true;
1264 
1265             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1266             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1267             uint256 nextTokenId = tokenId + 1;
1268             if (_ownerships[nextTokenId].addr == address(0)) {
1269                 // This will suffice for checking _exists(nextTokenId),
1270                 // as a burned slot cannot contain the zero address.
1271                 if (nextTokenId < _currentIndex) {
1272                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1273                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1274                 }
1275             }
1276         }
1277 
1278         emit Transfer(prevOwnership.addr, address(0), tokenId);
1279         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1280 
1281         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1282         unchecked {
1283             _burnCounter++;
1284         }
1285     }
1286 
1287     /**
1288      * @dev Approve `to` to operate on `tokenId`
1289      *
1290      * Emits a {Approval} event.
1291      */
1292     function _approve(
1293         address to,
1294         uint256 tokenId,
1295         address owner
1296     ) private {
1297         _tokenApprovals[tokenId] = to;
1298         emit Approval(owner, to, tokenId);
1299     }
1300 
1301     /**
1302      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1303      *
1304      * @param from address representing the previous owner of the given token ID
1305      * @param to target address that will receive the tokens
1306      * @param tokenId uint256 ID of the token to be transferred
1307      * @param _data bytes optional data to send along with the call
1308      * @return bool whether the call correctly returned the expected magic value
1309      */
1310     function _checkContractOnERC721Received(
1311         address from,
1312         address to,
1313         uint256 tokenId,
1314         bytes memory _data
1315     ) private returns (bool) {
1316         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1317             return retval == IERC721Receiver(to).onERC721Received.selector;
1318         } catch (bytes memory reason) {
1319             if (reason.length == 0) {
1320                 revert TransferToNonERC721ReceiverImplementer();
1321             } else {
1322                 assembly {
1323                     revert(add(32, reason), mload(reason))
1324                 }
1325             }
1326         }
1327     }
1328 
1329     /**
1330      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1331      * And also called before burning one token.
1332      *
1333      * startTokenId - the first token id to be transferred
1334      * quantity - the amount to be transferred
1335      *
1336      * Calling conditions:
1337      *
1338      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1339      * transferred to `to`.
1340      * - When `from` is zero, `tokenId` will be minted for `to`.
1341      * - When `to` is zero, `tokenId` will be burned by `from`.
1342      * - `from` and `to` are never both zero.
1343      */
1344     function _beforeTokenTransfers(
1345         address from,
1346         address to,
1347         uint256 startTokenId,
1348         uint256 quantity
1349     ) internal virtual {}
1350 
1351     /**
1352      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1353      * minting.
1354      * And also called after one token has been burned.
1355      *
1356      * startTokenId - the first token id to be transferred
1357      * quantity - the amount to be transferred
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` has been minted for `to`.
1364      * - When `to` is zero, `tokenId` has been burned by `from`.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _afterTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 }
1374 
1375 // File: contracts/Sloodle.sol
1376 
1377 
1378 pragma solidity ^0.8.7;
1379 
1380 
1381 
1382 
1383 contract Sloodles is ERC721A, Ownable {
1384     using Strings for uint256;
1385     address breedingContract;
1386 
1387     string public baseApiURI;
1388     bytes32 private whitelistRoot;
1389   
1390 
1391     //General Settings
1392     uint16 public maxMintAmountPerTransaction = 5;
1393     uint16 public maxMintAmountPerWallet = 5;
1394 
1395     //whitelisting Settings
1396     uint16 public maxMintAmountPerWhitelist = 3;
1397    
1398 
1399     //Inventory
1400     uint256 public maxSupply = 5555;
1401 
1402     //Prices
1403     uint256 public cost = 0.042 ether;
1404     uint256 public whitelistCost = 0.042 ether;
1405 
1406     //Utility
1407     bool public paused = false;
1408     bool public whiteListingSale = true;
1409 
1410     //mapping
1411     mapping(address => uint256) private whitelistedMints;
1412 
1413     constructor(string memory _baseUrl) ERC721A("Sloodles", "Sloodles") {
1414         baseApiURI = _baseUrl;
1415     }
1416 
1417     //This function will be used to extend the project with more capabilities 
1418     function setBreedingContractAddress(address _bAddress) public onlyOwner {
1419         breedingContract = _bAddress;
1420     }
1421 
1422     //this function can be called only from the extending contract
1423     function mintExternal(address _address, uint256 _mintAmount) external {
1424         require(
1425             msg.sender == breedingContract,
1426             "Sorry you dont have permission to mint"
1427         );
1428         _safeMint(_address, _mintAmount);
1429     }
1430 
1431     function setWhitelistingRoot(bytes32 _root) public onlyOwner {
1432         whitelistRoot = _root;
1433     }
1434 
1435    
1436 
1437  
1438     // Verify that a given leaf is in the tree.
1439     function _verify(
1440         bytes32 _leafNode,
1441         bytes32[] memory proof
1442     ) internal view returns (bool) {
1443         return MerkleProof.verify(proof, whitelistRoot, _leafNode);
1444     }
1445 
1446     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1447     function _leaf(address account) internal pure returns (bytes32) {
1448         return keccak256(abi.encodePacked(account));
1449     }
1450 
1451     //whitelist mint
1452     function mintWhitelist(
1453         bytes32[] calldata proof,
1454         uint256 _mintAmount
1455     ) public payable {
1456      
1457 
1458                 
1459                 //Normal WL Verifications
1460                  require(
1461                 totalSupply() + _mintAmount <= maxSupply,
1462                 "Exceeds Max Supply"
1463             );
1464 
1465                 require(
1466                     _verify(_leaf(msg.sender), proof),
1467                     "Invalid proof"
1468                 );
1469                 require(
1470                     (whitelistedMints[msg.sender] + _mintAmount) <=
1471                         maxMintAmountPerWhitelist,
1472                     "Exceeds Max Mint amount"
1473                 );
1474 
1475                 require(
1476                     msg.value >= (whitelistCost * _mintAmount),
1477                     "Insuffient funds"
1478                 );
1479 
1480                 //END WL Verifications
1481 
1482                 //Mint
1483                 _mintLoop(msg.sender, _mintAmount);
1484                 whitelistedMints[msg.sender] =
1485                     whitelistedMints[msg.sender] +
1486                     _mintAmount;
1487     }
1488 
1489     function numberMinted(address owner) public view returns (uint256) {
1490         return _numberMinted(owner);
1491     }
1492 
1493     // public
1494     function mint(uint256 _mintAmount) public payable {
1495         if (msg.sender != owner()) {
1496             uint256 ownerTokenCount = balanceOf(msg.sender);
1497 
1498             require(!paused);
1499             require(!whiteListingSale, "You cant mint on Presale");
1500             require(_mintAmount > 0, "Mint amount should be greater than 0");
1501             require(
1502                 _mintAmount <= maxMintAmountPerTransaction,
1503                 "Sorry you cant mint this amount at once"
1504             );
1505             require(
1506                 totalSupply() + _mintAmount <= maxSupply,
1507                 "Exceeds Max Supply"
1508             );
1509             require(
1510                 (ownerTokenCount + _mintAmount) <= maxMintAmountPerWallet,
1511                 "Sorry you cant mint more"
1512             );
1513 
1514             require(msg.value >= cost * _mintAmount, "Insuffient funds");
1515         }
1516 
1517         _mintLoop(msg.sender, _mintAmount);
1518     }
1519 
1520     function gift(address _to, uint256 _mintAmount) public onlyOwner {
1521         _mintLoop(_to, _mintAmount);
1522     }
1523 
1524     function airdrop(address[] memory _airdropAddresses) public onlyOwner {
1525         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1526             address to = _airdropAddresses[i];
1527             _mintLoop(to, 1);
1528         }
1529     }
1530 
1531     function _baseURI() internal view virtual override returns (string memory) {
1532         return baseApiURI;
1533     }
1534 
1535     function tokenURI(uint256 tokenId)
1536         public
1537         view
1538         virtual
1539         override
1540         returns (string memory)
1541     {
1542         require(
1543             _exists(tokenId),
1544             "ERC721Metadata: URI query for nonexistent token"
1545         );
1546         string memory currentBaseURI = _baseURI();
1547         return
1548             bytes(currentBaseURI).length > 0
1549                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1550                 : "";
1551     }
1552 
1553     function setCost(uint256 _newCost) public onlyOwner {
1554         cost = _newCost;
1555     }
1556 
1557     function setWhitelistingCost(uint256 _newCost) public onlyOwner {
1558         whitelistCost = _newCost;
1559     }
1560 
1561     function setmaxMintAmountPerTransaction(uint16 _amount) public onlyOwner {
1562         maxMintAmountPerTransaction = _amount;
1563     }
1564 
1565     function setMaxMintAmountPerWallet(uint16 _amount) public onlyOwner {
1566         maxMintAmountPerWallet = _amount;
1567     }
1568 
1569     function setMaxMintAmountPerWhitelist(uint16 _amount) public onlyOwner {
1570         maxMintAmountPerWhitelist = _amount;
1571     }
1572 
1573     function setMaxSupply(uint256 _supply) public onlyOwner {
1574         maxSupply = _supply;
1575     }
1576 
1577     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1578         baseApiURI = _newBaseURI;
1579     }
1580 
1581     function togglePause() public onlyOwner {
1582         paused = !paused;
1583     }
1584 
1585     function toggleWhiteSale() public onlyOwner {
1586         whiteListingSale = !whiteListingSale;
1587     }
1588 
1589     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1590         _safeMint(_receiver, _mintAmount);
1591     }
1592 
1593     function getOwnershipData(uint256 tokenId)
1594         external
1595         view
1596         returns (TokenOwnership memory)
1597     {
1598         return ownershipOf(tokenId);
1599     }
1600 
1601     function withdraw() public payable onlyOwner {
1602 
1603          uint256 balance = address(this).balance;
1604          uint256 share1 = (balance * 5) / 100;
1605 
1606           (bool shareholder1, ) = payable(
1607             0x16c7Fbd3D3f4d212624ba005D25B4e7Bcd1A65c7
1608         ).call{value: share1}("");
1609         require(shareholder1);
1610 
1611         (bool hq, ) = payable(owner()).call{value: address(this).balance}("");
1612         require(hq);
1613     }
1614 }