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
242 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
243 
244 pragma solidity ^0.8.0;
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
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies on extcodesize, which returns 0 for contracts in
269         // construction, since the code is only stored at the end of the
270         // constructor execution.
271 
272         uint256 size;
273         assembly {
274             size := extcodesize(account)
275         }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain `call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.call{value: value}(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
383         return functionStaticCall(target, data, "Address: low-level static call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal view returns (bytes memory) {
397         require(isContract(target), "Address: static call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.staticcall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(isContract(target), "Address: delegate call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.delegatecall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
432      * revert reason using the provided one.
433      *
434      * _Available since v4.3._
435      */
436     function verifyCallResult(
437         bool success,
438         bytes memory returndata,
439         string memory errorMessage
440     ) internal pure returns (bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @title ERC721 token receiver interface
468  * @dev Interface for any contract that wants to support safeTransfers
469  * from ERC721 asset contracts.
470  */
471 interface IERC721Receiver {
472     /**
473      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
474      * by `operator` from `from`, this function is called.
475      *
476      * It must return its Solidity selector to confirm the token transfer.
477      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
478      *
479      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
480      */
481     function onERC721Received(
482         address operator,
483         address from,
484         uint256 tokenId,
485         bytes calldata data
486     ) external returns (bytes4);
487 }
488 
489 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Interface of the ERC165 standard, as defined in the
498  * https://eips.ethereum.org/EIPS/eip-165[EIP].
499  *
500  * Implementers can declare support of contract interfaces, which can then be
501  * queried by others ({ERC165Checker}).
502  *
503  * For an implementation, see {ERC165}.
504  */
505 interface IERC165 {
506     /**
507      * @dev Returns true if this contract implements the interface defined by
508      * `interfaceId`. See the corresponding
509      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
510      * to learn more about how these ids are created.
511      *
512      * This function call must use less than 30 000 gas.
513      */
514     function supportsInterface(bytes4 interfaceId) external view returns (bool);
515 }
516 
517 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Implementation of the {IERC165} interface.
527  *
528  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
529  * for the additional interface id that will be supported. For example:
530  *
531  * ```solidity
532  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
534  * }
535  * ```
536  *
537  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
538  */
539 abstract contract ERC165 is IERC165 {
540     /**
541      * @dev See {IERC165-supportsInterface}.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544         return interfaceId == type(IERC165).interfaceId;
545     }
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Required interface of an ERC721 compliant contract.
558  */
559 interface IERC721 is IERC165 {
560     /**
561      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
562      */
563     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
567      */
568     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
569 
570     /**
571      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
572      */
573     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
574 
575     /**
576      * @dev Returns the number of tokens in ``owner``'s account.
577      */
578     function balanceOf(address owner) external view returns (uint256 balance);
579 
580     /**
581      * @dev Returns the owner of the `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function ownerOf(uint256 tokenId) external view returns (address owner);
588 
589     /**
590      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
591      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
592      *
593      * Requirements:
594      *
595      * - `from` cannot be the zero address.
596      * - `to` cannot be the zero address.
597      * - `tokenId` token must exist and be owned by `from`.
598      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
599      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
600      *
601      * Emits a {Transfer} event.
602      */
603     function safeTransferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) external;
608 
609     /**
610      * @dev Transfers `tokenId` token from `from` to `to`.
611      *
612      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
620      *
621      * Emits a {Transfer} event.
622      */
623     function transferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
631      * The approval is cleared when the token is transferred.
632      *
633      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
634      *
635      * Requirements:
636      *
637      * - The caller must own the token or be an approved operator.
638      * - `tokenId` must exist.
639      *
640      * Emits an {Approval} event.
641      */
642     function approve(address to, uint256 tokenId) external;
643 
644     /**
645      * @dev Returns the account approved for `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function getApproved(uint256 tokenId) external view returns (address operator);
652 
653     /**
654      * @dev Approve or remove `operator` as an operator for the caller.
655      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
656      *
657      * Requirements:
658      *
659      * - The `operator` cannot be the caller.
660      *
661      * Emits an {ApprovalForAll} event.
662      */
663     function setApprovalForAll(address operator, bool _approved) external;
664 
665     /**
666      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
667      *
668      * See {setApprovalForAll}
669      */
670     function isApprovedForAll(address owner, address operator) external view returns (bool);
671 
672     /**
673      * @dev Safely transfers `tokenId` token from `from` to `to`.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must exist and be owned by `from`.
680      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
681      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
682      *
683      * Emits a {Transfer} event.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId,
689         bytes calldata data
690     ) external;
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
703  * @dev See https://eips.ethereum.org/EIPS/eip-721
704  */
705 interface IERC721Enumerable is IERC721 {
706     /**
707      * @dev Returns the total amount of tokens stored by the contract.
708      */
709     function totalSupply() external view returns (uint256);
710 
711     /**
712      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
713      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
714      */
715     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
716 
717     /**
718      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
719      * Use along with {totalSupply} to enumerate all tokens.
720      */
721     function tokenByIndex(uint256 index) external view returns (uint256);
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
734  * @dev See https://eips.ethereum.org/EIPS/eip-721
735  */
736 interface IERC721Metadata is IERC721 {
737     /**
738      * @dev Returns the token collection name.
739      */
740     function name() external view returns (string memory);
741 
742     /**
743      * @dev Returns the token collection symbol.
744      */
745     function symbol() external view returns (string memory);
746 
747     /**
748      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
749      */
750     function tokenURI(uint256 tokenId) external view returns (string memory);
751 }
752 
753 // File: erc721a/contracts/ERC721A.sol
754 
755 
756 // Creator: Chiru Labs
757 
758 pragma solidity ^0.8.4;
759 
760 
761 
762 
763 
764 
765 
766 
767 
768 error ApprovalCallerNotOwnerNorApproved();
769 error ApprovalQueryForNonexistentToken();
770 error ApproveToCaller();
771 error ApprovalToCurrentOwner();
772 error BalanceQueryForZeroAddress();
773 error MintedQueryForZeroAddress();
774 error BurnedQueryForZeroAddress();
775 error AuxQueryForZeroAddress();
776 error MintToZeroAddress();
777 error MintZeroQuantity();
778 error OwnerIndexOutOfBounds();
779 error OwnerQueryForNonexistentToken();
780 error TokenIndexOutOfBounds();
781 error TransferCallerNotOwnerNorApproved();
782 error TransferFromIncorrectOwner();
783 error TransferToNonERC721ReceiverImplementer();
784 error TransferToZeroAddress();
785 error URIQueryForNonexistentToken();
786 
787 /**
788  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
789  * the Metadata extension. Built to optimize for lower gas during batch mints.
790  *
791  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
792  *
793  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
794  *
795  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
796  */
797 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
798     using Address for address;
799     using Strings for uint256;
800 
801     // Compiler will pack this into a single 256bit word.
802     struct TokenOwnership {
803         // The address of the owner.
804         address addr;
805         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
806         uint64 startTimestamp;
807         // Whether the token has been burned.
808         bool burned;
809     }
810 
811     // Compiler will pack this into a single 256bit word.
812     struct AddressData {
813         // Realistically, 2**64-1 is more than enough.
814         uint64 balance;
815         // Keeps track of mint count with minimal overhead for tokenomics.
816         uint64 numberMinted;
817         // Keeps track of burn count with minimal overhead for tokenomics.
818         uint64 numberBurned;
819         // For miscellaneous variable(s) pertaining to the address
820         // (e.g. number of whitelist mint slots used).
821         // If there are multiple variables, please pack them into a uint64.
822         uint64 aux;
823     }
824 
825     // The tokenId of the next token to be minted.
826     uint256 internal _currentIndex;
827 
828     // The number of tokens burned.
829     uint256 internal _burnCounter;
830 
831     // Token name
832     string private _name;
833 
834     // Token symbol
835     string private _symbol;
836 
837     // Mapping from token ID to ownership details
838     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
839     mapping(uint256 => TokenOwnership) internal _ownerships;
840 
841     // Mapping owner address to address data
842     mapping(address => AddressData) private _addressData;
843 
844     // Mapping from token ID to approved address
845     mapping(uint256 => address) private _tokenApprovals;
846 
847     // Mapping from owner to operator approvals
848     mapping(address => mapping(address => bool)) private _operatorApprovals;
849 
850     constructor(string memory name_, string memory symbol_) {
851         _name = name_;
852         _symbol = symbol_;
853         _currentIndex = _startTokenId();
854     }
855 
856     /**
857      * To change the starting tokenId, please override this function.
858      */
859     function _startTokenId() internal view virtual returns (uint256) {
860         return 0;
861     }
862 
863     /**
864      * @dev See {IERC721Enumerable-totalSupply}.
865      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
866      */
867     function totalSupply() public view returns (uint256) {
868         // Counter underflow is impossible as _burnCounter cannot be incremented
869         // more than _currentIndex - _startTokenId() times
870         unchecked {
871             return _currentIndex - _burnCounter - _startTokenId();
872         }
873     }
874 
875     /**
876      * Returns the total amount of tokens minted in the contract.
877      */
878     function _totalMinted() internal view returns (uint256) {
879         // Counter underflow is impossible as _currentIndex does not decrement,
880         // and it is initialized to _startTokenId()
881         unchecked {
882             return _currentIndex - _startTokenId();
883         }
884     }
885 
886     /**
887      * @dev See {IERC165-supportsInterface}.
888      */
889     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
890         return
891             interfaceId == type(IERC721).interfaceId ||
892             interfaceId == type(IERC721Metadata).interfaceId ||
893             super.supportsInterface(interfaceId);
894     }
895 
896     /**
897      * @dev See {IERC721-balanceOf}.
898      */
899     function balanceOf(address owner) public view override returns (uint256) {
900         if (owner == address(0)) revert BalanceQueryForZeroAddress();
901         return uint256(_addressData[owner].balance);
902     }
903 
904     /**
905      * Returns the number of tokens minted by `owner`.
906      */
907     function _numberMinted(address owner) internal view returns (uint256) {
908         if (owner == address(0)) revert MintedQueryForZeroAddress();
909         return uint256(_addressData[owner].numberMinted);
910     }
911 
912     /**
913      * Returns the number of tokens burned by or on behalf of `owner`.
914      */
915     function _numberBurned(address owner) internal view returns (uint256) {
916         if (owner == address(0)) revert BurnedQueryForZeroAddress();
917         return uint256(_addressData[owner].numberBurned);
918     }
919 
920     /**
921      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
922      */
923     function _getAux(address owner) internal view returns (uint64) {
924         if (owner == address(0)) revert AuxQueryForZeroAddress();
925         return _addressData[owner].aux;
926     }
927 
928     /**
929      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
930      * If there are multiple variables, please pack them into a uint64.
931      */
932     function _setAux(address owner, uint64 aux) internal {
933         if (owner == address(0)) revert AuxQueryForZeroAddress();
934         _addressData[owner].aux = aux;
935     }
936 
937     /**
938      * Gas spent here starts off proportional to the maximum mint batch size.
939      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
940      */
941     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
942         uint256 curr = tokenId;
943 
944         unchecked {
945             if (_startTokenId() <= curr && curr < _currentIndex) {
946                 TokenOwnership memory ownership = _ownerships[curr];
947                 if (!ownership.burned) {
948                     if (ownership.addr != address(0)) {
949                         return ownership;
950                     }
951                     // Invariant:
952                     // There will always be an ownership that has an address and is not burned
953                     // before an ownership that does not have an address and is not burned.
954                     // Hence, curr will not underflow.
955                     while (true) {
956                         curr--;
957                         ownership = _ownerships[curr];
958                         if (ownership.addr != address(0)) {
959                             return ownership;
960                         }
961                     }
962                 }
963             }
964         }
965         revert OwnerQueryForNonexistentToken();
966     }
967 
968     /**
969      * @dev See {IERC721-ownerOf}.
970      */
971     function ownerOf(uint256 tokenId) public view override returns (address) {
972         return ownershipOf(tokenId).addr;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-name}.
977      */
978     function name() public view virtual override returns (string memory) {
979         return _name;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-symbol}.
984      */
985     function symbol() public view virtual override returns (string memory) {
986         return _symbol;
987     }
988 
989     /**
990      * @dev See {IERC721Metadata-tokenURI}.
991      */
992     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
993         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
994 
995         string memory baseURI = _baseURI();
996         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
997     }
998 
999     /**
1000      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1001      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1002      * by default, can be overriden in child contracts.
1003      */
1004     function _baseURI() internal view virtual returns (string memory) {
1005         return '';
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-approve}.
1010      */
1011     function approve(address to, uint256 tokenId) public override {
1012         address owner = ERC721A.ownerOf(tokenId);
1013         if (to == owner) revert ApprovalToCurrentOwner();
1014 
1015         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1016             revert ApprovalCallerNotOwnerNorApproved();
1017         }
1018 
1019         _approve(to, tokenId, owner);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-getApproved}.
1024      */
1025     function getApproved(uint256 tokenId) public view override returns (address) {
1026         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1027 
1028         return _tokenApprovals[tokenId];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-setApprovalForAll}.
1033      */
1034     function setApprovalForAll(address operator, bool approved) public override {
1035         if (operator == _msgSender()) revert ApproveToCaller();
1036 
1037         _operatorApprovals[_msgSender()][operator] = approved;
1038         emit ApprovalForAll(_msgSender(), operator, approved);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-isApprovedForAll}.
1043      */
1044     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1045         return _operatorApprovals[owner][operator];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-transferFrom}.
1050      */
1051     function transferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public virtual override {
1056         _transfer(from, to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-safeTransferFrom}.
1061      */
1062     function safeTransferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) public virtual override {
1067         safeTransferFrom(from, to, tokenId, '');
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-safeTransferFrom}.
1072      */
1073     function safeTransferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId,
1077         bytes memory _data
1078     ) public virtual override {
1079         _transfer(from, to, tokenId);
1080         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1081             revert TransferToNonERC721ReceiverImplementer();
1082         }
1083     }
1084 
1085     /**
1086      * @dev Returns whether `tokenId` exists.
1087      *
1088      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1089      *
1090      * Tokens start existing when they are minted (`_mint`),
1091      */
1092     function _exists(uint256 tokenId) internal view returns (bool) {
1093         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1094             !_ownerships[tokenId].burned;
1095     }
1096 
1097     function _safeMint(address to, uint256 quantity) internal {
1098         _safeMint(to, quantity, '');
1099     }
1100 
1101     /**
1102      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _safeMint(
1112         address to,
1113         uint256 quantity,
1114         bytes memory _data
1115     ) internal {
1116         _mint(to, quantity, _data, true);
1117     }
1118 
1119     /**
1120      * @dev Mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _mint(
1130         address to,
1131         uint256 quantity,
1132         bytes memory _data,
1133         bool safe
1134     ) internal {
1135         uint256 startTokenId = _currentIndex;
1136         if (to == address(0)) revert MintToZeroAddress();
1137         if (quantity == 0) revert MintZeroQuantity();
1138 
1139         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1140 
1141         // Overflows are incredibly unrealistic.
1142         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1143         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1144         unchecked {
1145             _addressData[to].balance += uint64(quantity);
1146             _addressData[to].numberMinted += uint64(quantity);
1147 
1148             _ownerships[startTokenId].addr = to;
1149             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1150 
1151             uint256 updatedIndex = startTokenId;
1152             uint256 end = updatedIndex + quantity;
1153 
1154             if (safe && to.isContract()) {
1155                 do {
1156                     emit Transfer(address(0), to, updatedIndex);
1157                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1158                         revert TransferToNonERC721ReceiverImplementer();
1159                     }
1160                 } while (updatedIndex != end);
1161                 // Reentrancy protection
1162                 if (_currentIndex != startTokenId) revert();
1163             } else {
1164                 do {
1165                     emit Transfer(address(0), to, updatedIndex++);
1166                 } while (updatedIndex != end);
1167             }
1168             _currentIndex = updatedIndex;
1169         }
1170         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1171     }
1172 
1173     /**
1174      * @dev Transfers `tokenId` from `from` to `to`.
1175      *
1176      * Requirements:
1177      *
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must be owned by `from`.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _transfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) private {
1188         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1189 
1190         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1191             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1192             getApproved(tokenId) == _msgSender());
1193 
1194         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1195         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1196         if (to == address(0)) revert TransferToZeroAddress();
1197 
1198         _beforeTokenTransfers(from, to, tokenId, 1);
1199 
1200         // Clear approvals from the previous owner
1201         _approve(address(0), tokenId, prevOwnership.addr);
1202 
1203         // Underflow of the sender's balance is impossible because we check for
1204         // ownership above and the recipient's balance can't realistically overflow.
1205         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1206         unchecked {
1207             _addressData[from].balance -= 1;
1208             _addressData[to].balance += 1;
1209 
1210             _ownerships[tokenId].addr = to;
1211             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1212 
1213             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1214             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1215             uint256 nextTokenId = tokenId + 1;
1216             if (_ownerships[nextTokenId].addr == address(0)) {
1217                 // This will suffice for checking _exists(nextTokenId),
1218                 // as a burned slot cannot contain the zero address.
1219                 if (nextTokenId < _currentIndex) {
1220                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1221                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1222                 }
1223             }
1224         }
1225 
1226         emit Transfer(from, to, tokenId);
1227         _afterTokenTransfers(from, to, tokenId, 1);
1228     }
1229 
1230     /**
1231      * @dev Destroys `tokenId`.
1232      * The approval is cleared when the token is burned.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must exist.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _burn(uint256 tokenId) internal virtual {
1241         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1242 
1243         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1244 
1245         // Clear approvals from the previous owner
1246         _approve(address(0), tokenId, prevOwnership.addr);
1247 
1248         // Underflow of the sender's balance is impossible because we check for
1249         // ownership above and the recipient's balance can't realistically overflow.
1250         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1251         unchecked {
1252             _addressData[prevOwnership.addr].balance -= 1;
1253             _addressData[prevOwnership.addr].numberBurned += 1;
1254 
1255             // Keep track of who burned the token, and the timestamp of burning.
1256             _ownerships[tokenId].addr = prevOwnership.addr;
1257             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1258             _ownerships[tokenId].burned = true;
1259 
1260             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1261             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1262             uint256 nextTokenId = tokenId + 1;
1263             if (_ownerships[nextTokenId].addr == address(0)) {
1264                 // This will suffice for checking _exists(nextTokenId),
1265                 // as a burned slot cannot contain the zero address.
1266                 if (nextTokenId < _currentIndex) {
1267                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1268                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1269                 }
1270             }
1271         }
1272 
1273         emit Transfer(prevOwnership.addr, address(0), tokenId);
1274         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1275 
1276         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1277         unchecked {
1278             _burnCounter++;
1279         }
1280     }
1281 
1282     /**
1283      * @dev Approve `to` to operate on `tokenId`
1284      *
1285      * Emits a {Approval} event.
1286      */
1287     function _approve(
1288         address to,
1289         uint256 tokenId,
1290         address owner
1291     ) private {
1292         _tokenApprovals[tokenId] = to;
1293         emit Approval(owner, to, tokenId);
1294     }
1295 
1296     /**
1297      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1298      *
1299      * @param from address representing the previous owner of the given token ID
1300      * @param to target address that will receive the tokens
1301      * @param tokenId uint256 ID of the token to be transferred
1302      * @param _data bytes optional data to send along with the call
1303      * @return bool whether the call correctly returned the expected magic value
1304      */
1305     function _checkContractOnERC721Received(
1306         address from,
1307         address to,
1308         uint256 tokenId,
1309         bytes memory _data
1310     ) private returns (bool) {
1311         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1312             return retval == IERC721Receiver(to).onERC721Received.selector;
1313         } catch (bytes memory reason) {
1314             if (reason.length == 0) {
1315                 revert TransferToNonERC721ReceiverImplementer();
1316             } else {
1317                 assembly {
1318                     revert(add(32, reason), mload(reason))
1319                 }
1320             }
1321         }
1322     }
1323 
1324     /**
1325      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1326      * And also called before burning one token.
1327      *
1328      * startTokenId - the first token id to be transferred
1329      * quantity - the amount to be transferred
1330      *
1331      * Calling conditions:
1332      *
1333      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1334      * transferred to `to`.
1335      * - When `from` is zero, `tokenId` will be minted for `to`.
1336      * - When `to` is zero, `tokenId` will be burned by `from`.
1337      * - `from` and `to` are never both zero.
1338      */
1339     function _beforeTokenTransfers(
1340         address from,
1341         address to,
1342         uint256 startTokenId,
1343         uint256 quantity
1344     ) internal virtual {}
1345 
1346     /**
1347      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1348      * minting.
1349      * And also called after one token has been burned.
1350      *
1351      * startTokenId - the first token id to be transferred
1352      * quantity - the amount to be transferred
1353      *
1354      * Calling conditions:
1355      *
1356      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1357      * transferred to `to`.
1358      * - When `from` is zero, `tokenId` has been minted for `to`.
1359      * - When `to` is zero, `tokenId` has been burned by `from`.
1360      * - `from` and `to` are never both zero.
1361      */
1362     function _afterTokenTransfers(
1363         address from,
1364         address to,
1365         uint256 startTokenId,
1366         uint256 quantity
1367     ) internal virtual {}
1368 }
1369 
1370 // File: contracts/DMMC.sol
1371 
1372 
1373 
1374 pragma solidity >=0.8.4 <0.9.0;
1375 
1376 
1377 
1378 
1379 contract DMMC is ERC721A, Ownable {
1380   using Strings for uint256;
1381   
1382   string public baseURI;
1383   string public baseExtension = ".json";
1384   string public provenanceHash = "";
1385   bytes32 public whitelistMerkleRoot = "";
1386 
1387   uint256 public privateMintCost = 0.1 ether;
1388   uint256 public whitelistMintCost = 0.5 ether;
1389   uint256 public publicMintCost = 1 ether;
1390 
1391   uint256 public constant PRIVATE_MINT_SUPPLY = 1050;
1392   uint256 public constant WHITELIST_MINT_MAX_SUPPLY = 4000;
1393   uint256 public constant PUBLIC_MINT_MAX_SUPPLY = 9995;
1394 
1395   bool public isPrivateMintActive = false;
1396   bool public isWhitelistMintActive = false;
1397   bool public isPublicMintActive = false;
1398 
1399   uint256 public maxMintPerTx = 5;
1400 
1401   constructor(
1402     string memory _name,
1403     string memory _symbol,
1404     string memory _initBaseURI
1405   ) ERC721A(_name, _symbol) {
1406     setBaseURI(_initBaseURI);
1407   }
1408 
1409   modifier privatePausedCompliance() {
1410     require(isPrivateMintActive, "Private minting is currently paused");
1411     _;
1412   }
1413 
1414   modifier whitelistPausedCompliance() {
1415     require(isWhitelistMintActive, "Whitelist minting is currently paused");
1416     _;
1417   }
1418 
1419   modifier publicPausedCompliance() {
1420     require(isPublicMintActive, "Public minting is currently paused");
1421     _;
1422   }
1423 
1424   modifier privateAmountCompliance(uint256 _value, uint256 _amount) {
1425     require(_value >= _amount * privateMintCost, "Insufficient funds sent");
1426     _;
1427   }
1428 
1429   modifier whitelistAmountCompliance(uint256 _value, uint256 _amount) {
1430     require(_value >= _amount * whitelistMintCost, "Insufficient funds sent");
1431     _;
1432   }
1433 
1434   modifier publicAmountCompliance(uint256 _value, uint256 _amount) {
1435     require(_value >= _amount * publicMintCost, "Insufficient funds sent");
1436     _;
1437   }
1438 
1439   modifier maxAmountPerTxCompliance(uint256 _amount) {
1440     require(_amount <= maxMintPerTx, "Amount exceeds limit per transaction");
1441     _;
1442   }
1443 
1444   modifier isValidMerkleProof(bytes32[] calldata _merkleProof, bytes32 _root) {
1445     require(
1446       MerkleProof.verify(
1447         _merkleProof,
1448         _root,
1449         keccak256(abi.encodePacked(msg.sender))
1450       ),
1451       "Whitelist merkle proof is invalid"
1452     );
1453     _;
1454   }
1455 
1456   function reserve(uint256 _amount, address _address) public onlyOwner {
1457     uint256 supply = totalSupply();
1458     require(supply + _amount <= PUBLIC_MINT_MAX_SUPPLY, "Insufficient supply remaining");
1459 
1460     _safeMint(_address, _amount);
1461   }
1462 
1463   function privateMint(
1464     uint256 _amount
1465   )
1466     public
1467     payable
1468     privatePausedCompliance
1469     privateAmountCompliance(msg.value, _amount)
1470     maxAmountPerTxCompliance(_amount)
1471   {
1472     uint256 supply = totalSupply();
1473     require(supply + _amount <= PRIVATE_MINT_SUPPLY, "Insufficient supply remaining");
1474     _safeMint(msg.sender, _amount);
1475   }
1476 
1477   function whitelistMint(
1478     uint256 _amount,
1479     bytes32[] calldata _merkleProof
1480   )
1481     public
1482     payable
1483     whitelistPausedCompliance
1484     whitelistAmountCompliance(msg.value, _amount)
1485     maxAmountPerTxCompliance(_amount)
1486     isValidMerkleProof(_merkleProof, whitelistMerkleRoot)
1487   {
1488     uint256 supply = totalSupply();
1489     require(supply + _amount <= WHITELIST_MINT_MAX_SUPPLY, "Insufficient supply remaining");
1490     _safeMint(msg.sender, _amount);
1491   }
1492 
1493   function publicMint(
1494     uint256 _amount
1495   )
1496     public
1497     payable
1498     publicPausedCompliance
1499     publicAmountCompliance(msg.value, _amount)
1500     maxAmountPerTxCompliance(_amount)
1501   {
1502     uint256 supply = totalSupply();
1503     require(supply + _amount <= PUBLIC_MINT_MAX_SUPPLY, "Insufficient supply remaining");
1504     _safeMint(msg.sender, _amount);
1505   }
1506 
1507   function tokenURI(uint256 _tokenId)
1508     public
1509     view
1510     virtual
1511     override
1512     returns (string memory)
1513   {
1514     require(
1515       _exists(_tokenId),
1516       "ERC721Metadata: URI query for nonexistent token"
1517     );
1518 
1519     string memory currentBaseURI = _baseURI();
1520     return
1521       bytes(currentBaseURI).length > 0
1522         ? string(
1523           abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)
1524         )
1525         : "";
1526   }
1527 
1528   function _startTokenId() internal view virtual override returns (uint256) {
1529     return 1;
1530   }
1531 
1532   function _baseURI() internal view virtual override returns (string memory) {
1533     return baseURI;
1534   }
1535 
1536   function setIsPrivateMintActive(bool _isPrivateMintActive) public onlyOwner {
1537     isPrivateMintActive = _isPrivateMintActive;
1538   }
1539 
1540   function setIsWhitelistMintActive(bool _isWhitelistMintActive) public onlyOwner {
1541     isWhitelistMintActive = _isWhitelistMintActive;
1542   }
1543 
1544   function setIsPublicMintActive(bool _isPublicMintActive) public onlyOwner {
1545     isPublicMintActive = _isPublicMintActive;
1546   }
1547 
1548   function setPrivateMintCost(uint256 _privateMintCost) public onlyOwner {
1549     privateMintCost = _privateMintCost;
1550   }
1551 
1552   function setSeedMintCost(uint256 _whitelistMintCost) public onlyOwner {
1553     whitelistMintCost = _whitelistMintCost;
1554   }
1555 
1556   function setPublicMintCost(uint256 _publicMintCost) public onlyOwner {
1557     publicMintCost = _publicMintCost;
1558   }
1559 
1560   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1561     baseURI = _newBaseURI;
1562   }
1563 
1564   function setBaseExtension(string memory _baseExtension) public onlyOwner {
1565     baseExtension = _baseExtension;
1566   }
1567 
1568   function setMaxMintPerTx(uint256 _maxMintPerTx) public onlyOwner {
1569     maxMintPerTx = _maxMintPerTx;
1570   }
1571 
1572   function setSeedMerkleRoot(bytes32 _whitelistMerkleRoot) public onlyOwner {
1573     whitelistMerkleRoot = _whitelistMerkleRoot;
1574   }
1575 
1576   function withdraw() public payable onlyOwner {
1577     (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1578     require(success);
1579   }
1580 }