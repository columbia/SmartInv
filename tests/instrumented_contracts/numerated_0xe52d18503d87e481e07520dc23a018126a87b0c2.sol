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
780 error MintToZeroAddress();
781 error MintZeroQuantity();
782 error OwnerIndexOutOfBounds();
783 error OwnerQueryForNonexistentToken();
784 error TokenIndexOutOfBounds();
785 error TransferCallerNotOwnerNorApproved();
786 error TransferFromIncorrectOwner();
787 error TransferToNonERC721ReceiverImplementer();
788 error TransferToZeroAddress();
789 error URIQueryForNonexistentToken();
790 
791 /**
792  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
793  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
794  *
795  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
796  *
797  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
798  *
799  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
800  */
801 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
802     using Address for address;
803     using Strings for uint256;
804 
805     // Compiler will pack this into a single 256bit word.
806     struct TokenOwnership {
807         // The address of the owner.
808         address addr;
809         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
810         uint64 startTimestamp;
811         // Whether the token has been burned.
812         bool burned;
813     }
814 
815     // Compiler will pack this into a single 256bit word.
816     struct AddressData {
817         // Realistically, 2**64-1 is more than enough.
818         uint64 balance;
819         // Keeps track of mint count with minimal overhead for tokenomics.
820         uint64 numberMinted;
821         // Keeps track of burn count with minimal overhead for tokenomics.
822         uint64 numberBurned;
823     }
824 
825     // Compiler will pack the following 
826     // _currentIndex and _burnCounter into a single 256bit word.
827     
828     // The tokenId of the next token to be minted.
829     uint128 internal _currentIndex;
830 
831     // The number of tokens burned.
832     uint128 internal _burnCounter;
833 
834     // Token name
835     string private _name;
836 
837     // Token symbol
838     string private _symbol;
839 
840     // Mapping from token ID to ownership details
841     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
842     mapping(uint256 => TokenOwnership) internal _ownerships;
843 
844     // Mapping owner address to address data
845     mapping(address => AddressData) private _addressData;
846 
847     // Mapping from token ID to approved address
848     mapping(uint256 => address) private _tokenApprovals;
849 
850     // Mapping from owner to operator approvals
851     mapping(address => mapping(address => bool)) private _operatorApprovals;
852 
853     constructor(string memory name_, string memory symbol_) {
854         _name = name_;
855         _symbol = symbol_;
856     }
857 
858     /**
859      * @dev See {IERC721Enumerable-totalSupply}.
860      */
861     function totalSupply() public view override returns (uint256) {
862         // Counter underflow is impossible as _burnCounter cannot be incremented
863         // more than _currentIndex times
864         unchecked {
865             return _currentIndex - _burnCounter;    
866         }
867     }
868 
869     /**
870      * @dev See {IERC721Enumerable-tokenByIndex}.
871      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
872      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
873      */
874     function tokenByIndex(uint256 index) public view override returns (uint256) {
875         uint256 numMintedSoFar = _currentIndex;
876         uint256 tokenIdsIdx;
877 
878         // Counter overflow is impossible as the loop breaks when
879         // uint256 i is equal to another uint256 numMintedSoFar.
880         unchecked {
881             for (uint256 i; i < numMintedSoFar; i++) {
882                 TokenOwnership memory ownership = _ownerships[i];
883                 if (!ownership.burned) {
884                     if (tokenIdsIdx == index) {
885                         return i;
886                     }
887                     tokenIdsIdx++;
888                 }
889             }
890         }
891         revert TokenIndexOutOfBounds();
892     }
893 
894     /**
895      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
896      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
897      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
898      */
899     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
900         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
901         uint256 numMintedSoFar = _currentIndex;
902         uint256 tokenIdsIdx;
903         address currOwnershipAddr;
904 
905         // Counter overflow is impossible as the loop breaks when
906         // uint256 i is equal to another uint256 numMintedSoFar.
907         unchecked {
908             for (uint256 i; i < numMintedSoFar; i++) {
909                 TokenOwnership memory ownership = _ownerships[i];
910                 if (ownership.burned) {
911                     continue;
912                 }
913                 if (ownership.addr != address(0)) {
914                     currOwnershipAddr = ownership.addr;
915                 }
916                 if (currOwnershipAddr == owner) {
917                     if (tokenIdsIdx == index) {
918                         return i;
919                     }
920                     tokenIdsIdx++;
921                 }
922             }
923         }
924 
925         // Execution should never reach this point.
926         revert();
927     }
928 
929     /**
930      * @dev See {IERC165-supportsInterface}.
931      */
932     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
933         return
934             interfaceId == type(IERC721).interfaceId ||
935             interfaceId == type(IERC721Metadata).interfaceId ||
936             interfaceId == type(IERC721Enumerable).interfaceId ||
937             super.supportsInterface(interfaceId);
938     }
939 
940     /**
941      * @dev See {IERC721-balanceOf}.
942      */
943     function balanceOf(address owner) public view override returns (uint256) {
944         if (owner == address(0)) revert BalanceQueryForZeroAddress();
945         return uint256(_addressData[owner].balance);
946     }
947 
948     function _numberMinted(address owner) internal view returns (uint256) {
949         if (owner == address(0)) revert MintedQueryForZeroAddress();
950         return uint256(_addressData[owner].numberMinted);
951     }
952 
953     function _numberBurned(address owner) internal view returns (uint256) {
954         if (owner == address(0)) revert BurnedQueryForZeroAddress();
955         return uint256(_addressData[owner].numberBurned);
956     }
957 
958     /**
959      * Gas spent here starts off proportional to the maximum mint batch size.
960      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
961      */
962     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
963         uint256 curr = tokenId;
964 
965         unchecked {
966             if (curr < _currentIndex) {
967                 TokenOwnership memory ownership = _ownerships[curr];
968                 if (!ownership.burned) {
969                     if (ownership.addr != address(0)) {
970                         return ownership;
971                     }
972                     // Invariant: 
973                     // There will always be an ownership that has an address and is not burned 
974                     // before an ownership that does not have an address and is not burned.
975                     // Hence, curr will not underflow.
976                     while (true) {
977                         curr--;
978                         ownership = _ownerships[curr];
979                         if (ownership.addr != address(0)) {
980                             return ownership;
981                         }
982                     }
983                 }
984             }
985         }
986         revert OwnerQueryForNonexistentToken();
987     }
988 
989     /**
990      * @dev See {IERC721-ownerOf}.
991      */
992     function ownerOf(uint256 tokenId) public view override returns (address) {
993         return ownershipOf(tokenId).addr;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-name}.
998      */
999     function name() public view virtual override returns (string memory) {
1000         return _name;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-symbol}.
1005      */
1006     function symbol() public view virtual override returns (string memory) {
1007         return _symbol;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-tokenURI}.
1012      */
1013     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1014         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1015 
1016         string memory baseURI = _baseURI();
1017         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1018     }
1019 
1020     /**
1021      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1022      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1023      * by default, can be overriden in child contracts.
1024      */
1025     function _baseURI() internal view virtual returns (string memory) {
1026         return '';
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-approve}.
1031      */
1032     function approve(address to, uint256 tokenId) public override {
1033         address owner = ERC721A.ownerOf(tokenId);
1034         if (to == owner) revert ApprovalToCurrentOwner();
1035 
1036         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1037             revert ApprovalCallerNotOwnerNorApproved();
1038         }
1039 
1040         _approve(to, tokenId, owner);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-getApproved}.
1045      */
1046     function getApproved(uint256 tokenId) public view override returns (address) {
1047         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1048 
1049         return _tokenApprovals[tokenId];
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-setApprovalForAll}.
1054      */
1055     function setApprovalForAll(address operator, bool approved) public override {
1056         if (operator == _msgSender()) revert ApproveToCaller();
1057 
1058         _operatorApprovals[_msgSender()][operator] = approved;
1059         emit ApprovalForAll(_msgSender(), operator, approved);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-isApprovedForAll}.
1064      */
1065     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1066         return _operatorApprovals[owner][operator];
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-transferFrom}.
1071      */
1072     function transferFrom(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) public virtual override {
1077         _transfer(from, to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-safeTransferFrom}.
1082      */
1083     function safeTransferFrom(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) public virtual override {
1088         safeTransferFrom(from, to, tokenId, '');
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-safeTransferFrom}.
1093      */
1094     function safeTransferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId,
1098         bytes memory _data
1099     ) public virtual override {
1100         _transfer(from, to, tokenId);
1101         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1102             revert TransferToNonERC721ReceiverImplementer();
1103         }
1104     }
1105 
1106     /**
1107      * @dev Returns whether `tokenId` exists.
1108      *
1109      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1110      *
1111      * Tokens start existing when they are minted (`_mint`),
1112      */
1113     function _exists(uint256 tokenId) internal view returns (bool) {
1114         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1115     }
1116 
1117     function _safeMint(address to, uint256 quantity) internal {
1118         _safeMint(to, quantity, '');
1119     }
1120 
1121     /**
1122      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1127      * - `quantity` must be greater than 0.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _safeMint(
1132         address to,
1133         uint256 quantity,
1134         bytes memory _data
1135     ) internal {
1136         _mint(to, quantity, _data, true);
1137     }
1138 
1139     /**
1140      * @dev Mints `quantity` tokens and transfers them to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `to` cannot be the zero address.
1145      * - `quantity` must be greater than 0.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _mint(
1150         address to,
1151         uint256 quantity,
1152         bytes memory _data,
1153         bool safe
1154     ) internal {
1155         uint256 startTokenId = _currentIndex;
1156         if (to == address(0)) revert MintToZeroAddress();
1157         if (quantity == 0) revert MintZeroQuantity();
1158 
1159         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1160 
1161         // Overflows are incredibly unrealistic.
1162         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1163         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1164         unchecked {
1165             _addressData[to].balance += uint64(quantity);
1166             _addressData[to].numberMinted += uint64(quantity);
1167 
1168             _ownerships[startTokenId].addr = to;
1169             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1170 
1171             uint256 updatedIndex = startTokenId;
1172 
1173             for (uint256 i; i < quantity; i++) {
1174                 emit Transfer(address(0), to, updatedIndex);
1175                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1176                     revert TransferToNonERC721ReceiverImplementer();
1177                 }
1178                 updatedIndex++;
1179             }
1180 
1181             _currentIndex = uint128(updatedIndex);
1182         }
1183         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1184     }
1185 
1186     /**
1187      * @dev Transfers `tokenId` from `from` to `to`.
1188      *
1189      * Requirements:
1190      *
1191      * - `to` cannot be the zero address.
1192      * - `tokenId` token must be owned by `from`.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _transfer(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) private {
1201         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1202 
1203         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1204             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1205             getApproved(tokenId) == _msgSender());
1206 
1207         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1208         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1209         if (to == address(0)) revert TransferToZeroAddress();
1210 
1211         _beforeTokenTransfers(from, to, tokenId, 1);
1212 
1213         // Clear approvals from the previous owner
1214         _approve(address(0), tokenId, prevOwnership.addr);
1215 
1216         // Underflow of the sender's balance is impossible because we check for
1217         // ownership above and the recipient's balance can't realistically overflow.
1218         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1219         unchecked {
1220             _addressData[from].balance -= 1;
1221             _addressData[to].balance += 1;
1222 
1223             _ownerships[tokenId].addr = to;
1224             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1225 
1226             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1227             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1228             uint256 nextTokenId = tokenId + 1;
1229             if (_ownerships[nextTokenId].addr == address(0)) {
1230                 // This will suffice for checking _exists(nextTokenId),
1231                 // as a burned slot cannot contain the zero address.
1232                 if (nextTokenId < _currentIndex) {
1233                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1234                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1235                 }
1236             }
1237         }
1238 
1239         emit Transfer(from, to, tokenId);
1240         _afterTokenTransfers(from, to, tokenId, 1);
1241     }
1242 
1243     /**
1244      * @dev Destroys `tokenId`.
1245      * The approval is cleared when the token is burned.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must exist.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _burn(uint256 tokenId) internal virtual {
1254         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1255 
1256         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1257 
1258         // Clear approvals from the previous owner
1259         _approve(address(0), tokenId, prevOwnership.addr);
1260 
1261         // Underflow of the sender's balance is impossible because we check for
1262         // ownership above and the recipient's balance can't realistically overflow.
1263         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1264         unchecked {
1265             _addressData[prevOwnership.addr].balance -= 1;
1266             _addressData[prevOwnership.addr].numberBurned += 1;
1267 
1268             // Keep track of who burned the token, and the timestamp of burning.
1269             _ownerships[tokenId].addr = prevOwnership.addr;
1270             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1271             _ownerships[tokenId].burned = true;
1272 
1273             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1274             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1275             uint256 nextTokenId = tokenId + 1;
1276             if (_ownerships[nextTokenId].addr == address(0)) {
1277                 // This will suffice for checking _exists(nextTokenId),
1278                 // as a burned slot cannot contain the zero address.
1279                 if (nextTokenId < _currentIndex) {
1280                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1281                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1282                 }
1283             }
1284         }
1285 
1286         emit Transfer(prevOwnership.addr, address(0), tokenId);
1287         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1288 
1289         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1290         unchecked { 
1291             _burnCounter++;
1292         }
1293     }
1294 
1295     /**
1296      * @dev Approve `to` to operate on `tokenId`
1297      *
1298      * Emits a {Approval} event.
1299      */
1300     function _approve(
1301         address to,
1302         uint256 tokenId,
1303         address owner
1304     ) private {
1305         _tokenApprovals[tokenId] = to;
1306         emit Approval(owner, to, tokenId);
1307     }
1308 
1309     /**
1310      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1311      * The call is not executed if the target address is not a contract.
1312      *
1313      * @param from address representing the previous owner of the given token ID
1314      * @param to target address that will receive the tokens
1315      * @param tokenId uint256 ID of the token to be transferred
1316      * @param _data bytes optional data to send along with the call
1317      * @return bool whether the call correctly returned the expected magic value
1318      */
1319     function _checkOnERC721Received(
1320         address from,
1321         address to,
1322         uint256 tokenId,
1323         bytes memory _data
1324     ) private returns (bool) {
1325         if (to.isContract()) {
1326             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1327                 return retval == IERC721Receiver(to).onERC721Received.selector;
1328             } catch (bytes memory reason) {
1329                 if (reason.length == 0) {
1330                     revert TransferToNonERC721ReceiverImplementer();
1331                 } else {
1332                     assembly {
1333                         revert(add(32, reason), mload(reason))
1334                     }
1335                 }
1336             }
1337         } else {
1338             return true;
1339         }
1340     }
1341 
1342     /**
1343      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1344      * And also called before burning one token.
1345      *
1346      * startTokenId - the first token id to be transferred
1347      * quantity - the amount to be transferred
1348      *
1349      * Calling conditions:
1350      *
1351      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1352      * transferred to `to`.
1353      * - When `from` is zero, `tokenId` will be minted for `to`.
1354      * - When `to` is zero, `tokenId` will be burned by `from`.
1355      * - `from` and `to` are never both zero.
1356      */
1357     function _beforeTokenTransfers(
1358         address from,
1359         address to,
1360         uint256 startTokenId,
1361         uint256 quantity
1362     ) internal virtual {}
1363 
1364     /**
1365      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1366      * minting.
1367      * And also called after one token has been burned.
1368      *
1369      * startTokenId - the first token id to be transferred
1370      * quantity - the amount to be transferred
1371      *
1372      * Calling conditions:
1373      *
1374      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1375      * transferred to `to`.
1376      * - When `from` is zero, `tokenId` has been minted for `to`.
1377      * - When `to` is zero, `tokenId` has been burned by `from`.
1378      * - `from` and `to` are never both zero.
1379      */
1380     function _afterTokenTransfers(
1381         address from,
1382         address to,
1383         uint256 startTokenId,
1384         uint256 quantity
1385     ) internal virtual {}
1386 }
1387 
1388 // File: contracts/HijabiQueens.sol
1389 
1390 
1391 pragma solidity ^0.8.7;
1392 
1393 
1394 
1395 
1396 contract HijabiQueens is ERC721A, Ownable {
1397     using Strings for uint256;
1398     address breedingContract;
1399 
1400     string public baseApiURI;
1401     bytes32 private whitelistRoot;
1402   
1403 
1404     //General Settings
1405     uint16 public maxMintAmountPerTransaction = 5;
1406     uint16 public maxMintAmountPerWallet = 5;
1407 
1408     //whitelisting Settings
1409     uint16 public maxMintAmountPerWhitelist = 2;
1410    
1411 
1412     //Inventory
1413     uint256 public maxSupply = 10001;
1414 
1415     //Prices
1416     uint256 public cost = 0.09 ether;
1417     uint256 public whitelistCost = 0.09 ether;
1418 
1419     //Utility
1420     bool public paused = true;
1421     bool public whiteListingSale = false;
1422 
1423     //mapping
1424     mapping(address => uint256) private whitelistedMints;
1425 
1426     constructor(string memory _baseUrl) ERC721A("HijabiQueens", "HQ") {
1427         baseApiURI = _baseUrl;
1428     }
1429 
1430     //This function will be used to extend the project with more capabilities 
1431     function setBreedingContractAddress(address _bAddress) public onlyOwner {
1432         breedingContract = _bAddress;
1433     }
1434 
1435     function walletOfOwner(address _owner)
1436         public
1437         view
1438         returns (uint256[] memory)
1439     {
1440         uint256 ownerTokenCount = _numberMinted(_owner);
1441         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1442         for (uint256 i; i < ownerTokenCount; i++) {
1443             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1444         }
1445         return tokenIds;
1446     }
1447 
1448     //this function can be called only from the extending contract
1449     function mintExternal(address _address, uint256 _mintAmount) external {
1450         require(
1451             msg.sender == breedingContract,
1452             "Sorry you dont have permission to mint"
1453         );
1454         _safeMint(_address, _mintAmount);
1455     }
1456 
1457     function setWhitelistingRoot(bytes32 _root) public onlyOwner {
1458         whitelistRoot = _root;
1459     }
1460 
1461    
1462 
1463  
1464     // Verify that a given leaf is in the tree.
1465     function _verify(
1466         bytes32 _leafNode,
1467         bytes32[] memory proof
1468     ) internal view returns (bool) {
1469         return MerkleProof.verify(proof, whitelistRoot, _leafNode);
1470     }
1471 
1472     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1473     function _leaf(address account) internal pure returns (bytes32) {
1474         return keccak256(abi.encodePacked(account));
1475     }
1476 
1477     //whitelist mint
1478     function mintWhitelist(
1479         bytes32[] calldata proof,
1480         uint256 _mintAmount
1481     ) public payable {
1482      
1483 
1484      
1485                 //Normal WL Verifications
1486                 require(
1487                     _verify(_leaf(msg.sender), proof),
1488                     "Invalid proof"
1489                 );
1490                 require(
1491                     (whitelistedMints[msg.sender] + _mintAmount) <=
1492                         maxMintAmountPerWhitelist,
1493                     "Exceeds Max Mint amount"
1494                 );
1495 
1496                 require(
1497                     msg.value >= (whitelistCost * _mintAmount),
1498                     "Insuffient funds"
1499                 );
1500 
1501                 //END WL Verifications
1502 
1503                 //Mint
1504                 _mintLoop(msg.sender, _mintAmount);
1505                 whitelistedMints[msg.sender] =
1506                     whitelistedMints[msg.sender] +
1507                     _mintAmount;
1508     }
1509 
1510     function numberMinted(address owner) public view returns (uint256) {
1511         return _numberMinted(owner);
1512     }
1513 
1514     // public
1515     function mint(uint256 _mintAmount) public payable {
1516         if (msg.sender != owner()) {
1517             uint256 ownerTokenCount = balanceOf(msg.sender);
1518 
1519             require(!paused);
1520             require(!whiteListingSale, "You cant mint on Presale");
1521             require(_mintAmount > 0, "Mint amount should be greater than 0");
1522             require(
1523                 _mintAmount <= maxMintAmountPerTransaction,
1524                 "Sorry you cant mint this amount at once"
1525             );
1526             require(
1527                 totalSupply() + _mintAmount <= maxSupply,
1528                 "Exceeds Max Supply"
1529             );
1530             require(
1531                 (ownerTokenCount + _mintAmount) <= maxMintAmountPerWallet,
1532                 "Sorry you cant mint more"
1533             );
1534 
1535             require(msg.value >= cost * _mintAmount, "Insuffient funds");
1536         }
1537 
1538         _mintLoop(msg.sender, _mintAmount);
1539     }
1540 
1541     function gift(address _to, uint256 _mintAmount) public onlyOwner {
1542         _mintLoop(_to, _mintAmount);
1543     }
1544 
1545     function airdrop(address[] memory _airdropAddresses) public onlyOwner {
1546         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1547             address to = _airdropAddresses[i];
1548             _mintLoop(to, 1);
1549         }
1550     }
1551 
1552     function _baseURI() internal view virtual override returns (string memory) {
1553         return baseApiURI;
1554     }
1555 
1556     function tokenURI(uint256 tokenId)
1557         public
1558         view
1559         virtual
1560         override
1561         returns (string memory)
1562     {
1563         require(
1564             _exists(tokenId),
1565             "ERC721Metadata: URI query for nonexistent token"
1566         );
1567         string memory currentBaseURI = _baseURI();
1568         return
1569             bytes(currentBaseURI).length > 0
1570                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1571                 : "";
1572     }
1573 
1574     function setCost(uint256 _newCost) public onlyOwner {
1575         cost = _newCost;
1576     }
1577 
1578     function setWhitelistingCost(uint256 _newCost) public onlyOwner {
1579         whitelistCost = _newCost;
1580     }
1581 
1582     function setmaxMintAmountPerTransaction(uint16 _amount) public onlyOwner {
1583         maxMintAmountPerTransaction = _amount;
1584     }
1585 
1586     function setMaxMintAmountPerWallet(uint16 _amount) public onlyOwner {
1587         maxMintAmountPerWallet = _amount;
1588     }
1589 
1590     function setMaxMintAmountPerWhitelist(uint16 _amount) public onlyOwner {
1591         maxMintAmountPerWhitelist = _amount;
1592     }
1593 
1594     function setMaxSupply(uint256 _supply) public onlyOwner {
1595         maxSupply = _supply;
1596     }
1597 
1598     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1599         baseApiURI = _newBaseURI;
1600     }
1601 
1602     function togglePause() public onlyOwner {
1603         paused = !paused;
1604     }
1605 
1606     function toggleWhiteSale() public onlyOwner {
1607         whiteListingSale = !whiteListingSale;
1608     }
1609 
1610     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1611         _safeMint(_receiver, _mintAmount);
1612     }
1613 
1614     function getOwnershipData(uint256 tokenId)
1615         external
1616         view
1617         returns (TokenOwnership memory)
1618     {
1619         return ownershipOf(tokenId);
1620     }
1621 
1622     function withdraw() public payable onlyOwner {
1623         (bool hq, ) = payable(owner()).call{value: address(this).balance}("");
1624         require(hq);
1625 
1626     }
1627 }