1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
48                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
49             } else {
50                 // Hash(current element of the proof + current computed hash)
51                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
52             }
53         }
54         return computedHash;
55     }
56 }
57 
58 // File: @openzeppelin/contracts/utils/Strings.sol
59 
60 
61 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev String operations.
67  */
68 library Strings {
69     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
70 
71     /**
72      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
73      */
74     function toString(uint256 value) internal pure returns (string memory) {
75         // Inspired by OraclizeAPI's implementation - MIT licence
76         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
77 
78         if (value == 0) {
79             return "0";
80         }
81         uint256 temp = value;
82         uint256 digits;
83         while (temp != 0) {
84             digits++;
85             temp /= 10;
86         }
87         bytes memory buffer = new bytes(digits);
88         while (value != 0) {
89             digits -= 1;
90             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
91             value /= 10;
92         }
93         return string(buffer);
94     }
95 
96     /**
97      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
98      */
99     function toHexString(uint256 value) internal pure returns (string memory) {
100         if (value == 0) {
101             return "0x00";
102         }
103         uint256 temp = value;
104         uint256 length = 0;
105         while (temp != 0) {
106             length++;
107             temp >>= 8;
108         }
109         return toHexString(value, length);
110     }
111 
112     /**
113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
114      */
115     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
116         bytes memory buffer = new bytes(2 * length + 2);
117         buffer[0] = "0";
118         buffer[1] = "x";
119         for (uint256 i = 2 * length + 1; i > 1; --i) {
120             buffer[i] = _HEX_SYMBOLS[value & 0xf];
121             value >>= 4;
122         }
123         require(value == 0, "Strings: hex length insufficient");
124         return string(buffer);
125     }
126 }
127 
128 // File: @openzeppelin/contracts/utils/Context.sol
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev Provides information about the current execution context, including the
137  * sender of the transaction and its data. While these are generally available
138  * via msg.sender and msg.data, they should not be accessed in such a direct
139  * manner, since when dealing with meta-transactions the account sending and
140  * paying for execution may not be the actual sender (as far as an application
141  * is concerned).
142  *
143  * This contract is only required for intermediate, library-like contracts.
144  */
145 abstract contract Context {
146     function _msgSender() internal view virtual returns (address) {
147         return msg.sender;
148     }
149 
150     function _msgData() internal view virtual returns (bytes calldata) {
151         return msg.data;
152     }
153 }
154 
155 // File: @openzeppelin/contracts/access/Ownable.sol
156 
157 
158 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
159 
160 pragma solidity ^0.8.0;
161 
162 
163 /**
164  * @dev Contract module which provides a basic access control mechanism, where
165  * there is an account (an owner) that can be granted exclusive access to
166  * specific functions.
167  *
168  * By default, the owner account will be the one that deploys the contract. This
169  * can later be changed with {transferOwnership}.
170  *
171  * This module is used through inheritance. It will make available the modifier
172  * `onlyOwner`, which can be applied to your functions to restrict their use to
173  * the owner.
174  */
175 abstract contract Ownable is Context {
176     address private _owner;
177 
178     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
179 
180     /**
181      * @dev Initializes the contract setting the deployer as the initial owner.
182      */
183     constructor() {
184         _transferOwnership(_msgSender());
185     }
186 
187     /**
188      * @dev Returns the address of the current owner.
189      */
190     function owner() public view virtual returns (address) {
191         return _owner;
192     }
193 
194     /**
195      * @dev Throws if called by any account other than the owner.
196      */
197     modifier onlyOwner() {
198         require(owner() == _msgSender(), "Ownable: caller is not the owner");
199         _;
200     }
201 
202     /**
203      * @dev Leaves the contract without owner. It will not be possible to call
204      * `onlyOwner` functions anymore. Can only be called by the current owner.
205      *
206      * NOTE: Renouncing ownership will leave the contract without an owner,
207      * thereby removing any functionality that is only available to the owner.
208      */
209     function renounceOwnership() public virtual onlyOwner {
210         _transferOwnership(address(0));
211     }
212 
213     /**
214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
215      * Can only be called by the current owner.
216      */
217     function transferOwnership(address newOwner) public virtual onlyOwner {
218         require(newOwner != address(0), "Ownable: new owner is the zero address");
219         _transferOwnership(newOwner);
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Internal function without access restriction.
225      */
226     function _transferOwnership(address newOwner) internal virtual {
227         address oldOwner = _owner;
228         _owner = newOwner;
229         emit OwnershipTransferred(oldOwner, newOwner);
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/Address.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @title ERC721 token receiver interface
462  * @dev Interface for any contract that wants to support safeTransfers
463  * from ERC721 asset contracts.
464  */
465 interface IERC721Receiver {
466     /**
467      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
468      * by `operator` from `from`, this function is called.
469      *
470      * It must return its Solidity selector to confirm the token transfer.
471      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
472      *
473      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
474      */
475     function onERC721Received(
476         address operator,
477         address from,
478         uint256 tokenId,
479         bytes calldata data
480     ) external returns (bytes4);
481 }
482 
483 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Interface of the ERC165 standard, as defined in the
492  * https://eips.ethereum.org/EIPS/eip-165[EIP].
493  *
494  * Implementers can declare support of contract interfaces, which can then be
495  * queried by others ({ERC165Checker}).
496  *
497  * For an implementation, see {ERC165}.
498  */
499 interface IERC165 {
500     /**
501      * @dev Returns true if this contract implements the interface defined by
502      * `interfaceId`. See the corresponding
503      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
504      * to learn more about how these ids are created.
505      *
506      * This function call must use less than 30 000 gas.
507      */
508     function supportsInterface(bytes4 interfaceId) external view returns (bool);
509 }
510 
511 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @dev Implementation of the {IERC165} interface.
521  *
522  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
523  * for the additional interface id that will be supported. For example:
524  *
525  * ```solidity
526  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
528  * }
529  * ```
530  *
531  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
532  */
533 abstract contract ERC165 is IERC165 {
534     /**
535      * @dev See {IERC165-supportsInterface}.
536      */
537     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538         return interfaceId == type(IERC165).interfaceId;
539     }
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
543 
544 
545 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Required interface of an ERC721 compliant contract.
552  */
553 interface IERC721 is IERC165 {
554     /**
555      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
556      */
557     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
558 
559     /**
560      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
561      */
562     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
566      */
567     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
568 
569     /**
570      * @dev Returns the number of tokens in ``owner``'s account.
571      */
572     function balanceOf(address owner) external view returns (uint256 balance);
573 
574     /**
575      * @dev Returns the owner of the `tokenId` token.
576      *
577      * Requirements:
578      *
579      * - `tokenId` must exist.
580      */
581     function ownerOf(uint256 tokenId) external view returns (address owner);
582 
583     /**
584      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
585      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must exist and be owned by `from`.
592      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594      *
595      * Emits a {Transfer} event.
596      */
597     function safeTransferFrom(
598         address from,
599         address to,
600         uint256 tokenId
601     ) external;
602 
603     /**
604      * @dev Transfers `tokenId` token from `from` to `to`.
605      *
606      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must be owned by `from`.
613      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
614      *
615      * Emits a {Transfer} event.
616      */
617     function transferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external;
622 
623     /**
624      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
625      * The approval is cleared when the token is transferred.
626      *
627      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
628      *
629      * Requirements:
630      *
631      * - The caller must own the token or be an approved operator.
632      * - `tokenId` must exist.
633      *
634      * Emits an {Approval} event.
635      */
636     function approve(address to, uint256 tokenId) external;
637 
638     /**
639      * @dev Returns the account approved for `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function getApproved(uint256 tokenId) external view returns (address operator);
646 
647     /**
648      * @dev Approve or remove `operator` as an operator for the caller.
649      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
650      *
651      * Requirements:
652      *
653      * - The `operator` cannot be the caller.
654      *
655      * Emits an {ApprovalForAll} event.
656      */
657     function setApprovalForAll(address operator, bool _approved) external;
658 
659     /**
660      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
661      *
662      * See {setApprovalForAll}
663      */
664     function isApprovedForAll(address owner, address operator) external view returns (bool);
665 
666     /**
667      * @dev Safely transfers `tokenId` token from `from` to `to`.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must exist and be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676      *
677      * Emits a {Transfer} event.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes calldata data
684     ) external;
685 }
686 
687 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
697  * @dev See https://eips.ethereum.org/EIPS/eip-721
698  */
699 interface IERC721Enumerable is IERC721 {
700     /**
701      * @dev Returns the total amount of tokens stored by the contract.
702      */
703     function totalSupply() external view returns (uint256);
704 
705     /**
706      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
707      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
708      */
709     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
710 
711     /**
712      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
713      * Use along with {totalSupply} to enumerate all tokens.
714      */
715     function tokenByIndex(uint256 index) external view returns (uint256);
716 }
717 
718 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
719 
720 
721 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 
726 /**
727  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
728  * @dev See https://eips.ethereum.org/EIPS/eip-721
729  */
730 interface IERC721Metadata is IERC721 {
731     /**
732      * @dev Returns the token collection name.
733      */
734     function name() external view returns (string memory);
735 
736     /**
737      * @dev Returns the token collection symbol.
738      */
739     function symbol() external view returns (string memory);
740 
741     /**
742      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
743      */
744     function tokenURI(uint256 tokenId) external view returns (string memory);
745 }
746 
747 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
748 
749 
750 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 
755 
756 
757 
758 
759 
760 
761 /**
762  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
763  * the Metadata extension, but not including the Enumerable extension, which is available separately as
764  * {ERC721Enumerable}.
765  */
766 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
767     using Address for address;
768     using Strings for uint256;
769 
770     // Token name
771     string private _name;
772 
773     // Token symbol
774     string private _symbol;
775 
776     // Mapping from token ID to owner address
777     mapping(uint256 => address) private _owners;
778 
779     // Mapping owner address to token count
780     mapping(address => uint256) private _balances;
781 
782     // Mapping from token ID to approved address
783     mapping(uint256 => address) private _tokenApprovals;
784 
785     // Mapping from owner to operator approvals
786     mapping(address => mapping(address => bool)) private _operatorApprovals;
787 
788     /**
789      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
790      */
791     constructor(string memory name_, string memory symbol_) {
792         _name = name_;
793         _symbol = symbol_;
794     }
795 
796     /**
797      * @dev See {IERC165-supportsInterface}.
798      */
799     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
800         return
801             interfaceId == type(IERC721).interfaceId ||
802             interfaceId == type(IERC721Metadata).interfaceId ||
803             super.supportsInterface(interfaceId);
804     }
805 
806     /**
807      * @dev See {IERC721-balanceOf}.
808      */
809     function balanceOf(address owner) public view virtual override returns (uint256) {
810         require(owner != address(0), "ERC721: balance query for the zero address");
811         return _balances[owner];
812     }
813 
814     /**
815      * @dev See {IERC721-ownerOf}.
816      */
817     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
818         address owner = _owners[tokenId];
819         require(owner != address(0), "ERC721: owner query for nonexistent token");
820         return owner;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-name}.
825      */
826     function name() public view virtual override returns (string memory) {
827         return _name;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-symbol}.
832      */
833     function symbol() public view virtual override returns (string memory) {
834         return _symbol;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-tokenURI}.
839      */
840     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
841         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
842 
843         string memory baseURI = _baseURI();
844         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
845     }
846 
847     /**
848      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
849      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
850      * by default, can be overriden in child contracts.
851      */
852     function _baseURI() internal view virtual returns (string memory) {
853         return "";
854     }
855 
856     /**
857      * @dev See {IERC721-approve}.
858      */
859     function approve(address to, uint256 tokenId) public virtual override {
860         address owner = ERC721.ownerOf(tokenId);
861         require(to != owner, "ERC721: approval to current owner");
862 
863         require(
864             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
865             "ERC721: approve caller is not owner nor approved for all"
866         );
867 
868         _approve(to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-getApproved}.
873      */
874     function getApproved(uint256 tokenId) public view virtual override returns (address) {
875         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
876 
877         return _tokenApprovals[tokenId];
878     }
879 
880     /**
881      * @dev See {IERC721-setApprovalForAll}.
882      */
883     function setApprovalForAll(address operator, bool approved) public virtual override {
884         _setApprovalForAll(_msgSender(), operator, approved);
885     }
886 
887     /**
888      * @dev See {IERC721-isApprovedForAll}.
889      */
890     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
891         return _operatorApprovals[owner][operator];
892     }
893 
894     /**
895      * @dev See {IERC721-transferFrom}.
896      */
897     function transferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public virtual override {
902         //solhint-disable-next-line max-line-length
903         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
904 
905         _transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) public virtual override {
916         safeTransferFrom(from, to, tokenId, "");
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) public virtual override {
928         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
929         _safeTransfer(from, to, tokenId, _data);
930     }
931 
932     /**
933      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
934      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
935      *
936      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
937      *
938      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
939      * implement alternative mechanisms to perform token transfer, such as signature-based.
940      *
941      * Requirements:
942      *
943      * - `from` cannot be the zero address.
944      * - `to` cannot be the zero address.
945      * - `tokenId` token must exist and be owned by `from`.
946      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _safeTransfer(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) internal virtual {
956         _transfer(from, to, tokenId);
957         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
958     }
959 
960     /**
961      * @dev Returns whether `tokenId` exists.
962      *
963      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
964      *
965      * Tokens start existing when they are minted (`_mint`),
966      * and stop existing when they are burned (`_burn`).
967      */
968     function _exists(uint256 tokenId) internal view virtual returns (bool) {
969         return _owners[tokenId] != address(0);
970     }
971 
972     /**
973      * @dev Returns whether `spender` is allowed to manage `tokenId`.
974      *
975      * Requirements:
976      *
977      * - `tokenId` must exist.
978      */
979     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
980         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
981         address owner = ERC721.ownerOf(tokenId);
982         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
983     }
984 
985     /**
986      * @dev Safely mints `tokenId` and transfers it to `to`.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must not exist.
991      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _safeMint(address to, uint256 tokenId) internal virtual {
996         _safeMint(to, tokenId, "");
997     }
998 
999     /**
1000      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1001      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1002      */
1003     function _safeMint(
1004         address to,
1005         uint256 tokenId,
1006         bytes memory _data
1007     ) internal virtual {
1008         _mint(to, tokenId);
1009         require(
1010             _checkOnERC721Received(address(0), to, tokenId, _data),
1011             "ERC721: transfer to non ERC721Receiver implementer"
1012         );
1013     }
1014 
1015     /**
1016      * @dev Mints `tokenId` and transfers it to `to`.
1017      *
1018      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must not exist.
1023      * - `to` cannot be the zero address.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _mint(address to, uint256 tokenId) internal virtual {
1028         require(to != address(0), "ERC721: mint to the zero address");
1029         require(!_exists(tokenId), "ERC721: token already minted");
1030 
1031         _beforeTokenTransfer(address(0), to, tokenId);
1032 
1033         _balances[to] += 1;
1034         _owners[tokenId] = to;
1035 
1036         emit Transfer(address(0), to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Destroys `tokenId`.
1041      * The approval is cleared when the token is burned.
1042      *
1043      * Requirements:
1044      *
1045      * - `tokenId` must exist.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _burn(uint256 tokenId) internal virtual {
1050         address owner = ERC721.ownerOf(tokenId);
1051 
1052         _beforeTokenTransfer(owner, address(0), tokenId);
1053 
1054         // Clear approvals
1055         _approve(address(0), tokenId);
1056 
1057         _balances[owner] -= 1;
1058         delete _owners[tokenId];
1059 
1060         emit Transfer(owner, address(0), tokenId);
1061     }
1062 
1063     /**
1064      * @dev Transfers `tokenId` from `from` to `to`.
1065      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1066      *
1067      * Requirements:
1068      *
1069      * - `to` cannot be the zero address.
1070      * - `tokenId` token must be owned by `from`.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _transfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) internal virtual {
1079         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1080         require(to != address(0), "ERC721: transfer to the zero address");
1081 
1082         _beforeTokenTransfer(from, to, tokenId);
1083 
1084         // Clear approvals from the previous owner
1085         _approve(address(0), tokenId);
1086 
1087         _balances[from] -= 1;
1088         _balances[to] += 1;
1089         _owners[tokenId] = to;
1090 
1091         emit Transfer(from, to, tokenId);
1092     }
1093 
1094     /**
1095      * @dev Approve `to` to operate on `tokenId`
1096      *
1097      * Emits a {Approval} event.
1098      */
1099     function _approve(address to, uint256 tokenId) internal virtual {
1100         _tokenApprovals[tokenId] = to;
1101         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Approve `operator` to operate on all of `owner` tokens
1106      *
1107      * Emits a {ApprovalForAll} event.
1108      */
1109     function _setApprovalForAll(
1110         address owner,
1111         address operator,
1112         bool approved
1113     ) internal virtual {
1114         require(owner != operator, "ERC721: approve to caller");
1115         _operatorApprovals[owner][operator] = approved;
1116         emit ApprovalForAll(owner, operator, approved);
1117     }
1118 
1119     /**
1120      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1121      * The call is not executed if the target address is not a contract.
1122      *
1123      * @param from address representing the previous owner of the given token ID
1124      * @param to target address that will receive the tokens
1125      * @param tokenId uint256 ID of the token to be transferred
1126      * @param _data bytes optional data to send along with the call
1127      * @return bool whether the call correctly returned the expected magic value
1128      */
1129     function _checkOnERC721Received(
1130         address from,
1131         address to,
1132         uint256 tokenId,
1133         bytes memory _data
1134     ) private returns (bool) {
1135         if (to.isContract()) {
1136             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1137                 return retval == IERC721Receiver.onERC721Received.selector;
1138             } catch (bytes memory reason) {
1139                 if (reason.length == 0) {
1140                     revert("ERC721: transfer to non ERC721Receiver implementer");
1141                 } else {
1142                     assembly {
1143                         revert(add(32, reason), mload(reason))
1144                     }
1145                 }
1146             }
1147         } else {
1148             return true;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Hook that is called before any token transfer. This includes minting
1154      * and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1159      * transferred to `to`.
1160      * - When `from` is zero, `tokenId` will be minted for `to`.
1161      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1162      * - `from` and `to` are never both zero.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _beforeTokenTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) internal virtual {}
1171 }
1172 
1173 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1174 
1175 
1176 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 
1182 /**
1183  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1184  * enumerability of all the token ids in the contract as well as all token ids owned by each
1185  * account.
1186  */
1187 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1188     // Mapping from owner to list of owned token IDs
1189     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1190 
1191     // Mapping from token ID to index of the owner tokens list
1192     mapping(uint256 => uint256) private _ownedTokensIndex;
1193 
1194     // Array with all token ids, used for enumeration
1195     uint256[] private _allTokens;
1196 
1197     // Mapping from token id to position in the allTokens array
1198     mapping(uint256 => uint256) private _allTokensIndex;
1199 
1200     /**
1201      * @dev See {IERC165-supportsInterface}.
1202      */
1203     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1204         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1205     }
1206 
1207     /**
1208      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1209      */
1210     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1211         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1212         return _ownedTokens[owner][index];
1213     }
1214 
1215     /**
1216      * @dev See {IERC721Enumerable-totalSupply}.
1217      */
1218     function totalSupply() public view virtual override returns (uint256) {
1219         return _allTokens.length;
1220     }
1221 
1222     /**
1223      * @dev See {IERC721Enumerable-tokenByIndex}.
1224      */
1225     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1226         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1227         return _allTokens[index];
1228     }
1229 
1230     /**
1231      * @dev Hook that is called before any token transfer. This includes minting
1232      * and burning.
1233      *
1234      * Calling conditions:
1235      *
1236      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1237      * transferred to `to`.
1238      * - When `from` is zero, `tokenId` will be minted for `to`.
1239      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1240      * - `from` cannot be the zero address.
1241      * - `to` cannot be the zero address.
1242      *
1243      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1244      */
1245     function _beforeTokenTransfer(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) internal virtual override {
1250         super._beforeTokenTransfer(from, to, tokenId);
1251 
1252         if (from == address(0)) {
1253             _addTokenToAllTokensEnumeration(tokenId);
1254         } else if (from != to) {
1255             _removeTokenFromOwnerEnumeration(from, tokenId);
1256         }
1257         if (to == address(0)) {
1258             _removeTokenFromAllTokensEnumeration(tokenId);
1259         } else if (to != from) {
1260             _addTokenToOwnerEnumeration(to, tokenId);
1261         }
1262     }
1263 
1264     /**
1265      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1266      * @param to address representing the new owner of the given token ID
1267      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1268      */
1269     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1270         uint256 length = ERC721.balanceOf(to);
1271         _ownedTokens[to][length] = tokenId;
1272         _ownedTokensIndex[tokenId] = length;
1273     }
1274 
1275     /**
1276      * @dev Private function to add a token to this extension's token tracking data structures.
1277      * @param tokenId uint256 ID of the token to be added to the tokens list
1278      */
1279     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1280         _allTokensIndex[tokenId] = _allTokens.length;
1281         _allTokens.push(tokenId);
1282     }
1283 
1284     /**
1285      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1286      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1287      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1288      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1289      * @param from address representing the previous owner of the given token ID
1290      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1291      */
1292     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1293         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1294         // then delete the last slot (swap and pop).
1295 
1296         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1297         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1298 
1299         // When the token to delete is the last token, the swap operation is unnecessary
1300         if (tokenIndex != lastTokenIndex) {
1301             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1302 
1303             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1304             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1305         }
1306 
1307         // This also deletes the contents at the last position of the array
1308         delete _ownedTokensIndex[tokenId];
1309         delete _ownedTokens[from][lastTokenIndex];
1310     }
1311 
1312     /**
1313      * @dev Private function to remove a token from this extension's token tracking data structures.
1314      * This has O(1) time complexity, but alters the order of the _allTokens array.
1315      * @param tokenId uint256 ID of the token to be removed from the tokens list
1316      */
1317     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1318         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1319         // then delete the last slot (swap and pop).
1320 
1321         uint256 lastTokenIndex = _allTokens.length - 1;
1322         uint256 tokenIndex = _allTokensIndex[tokenId];
1323 
1324         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1325         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1326         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1327         uint256 lastTokenId = _allTokens[lastTokenIndex];
1328 
1329         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1330         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1331 
1332         // This also deletes the contents at the last position of the array
1333         delete _allTokensIndex[tokenId];
1334         _allTokens.pop();
1335     }
1336 }
1337 
1338 // File: SpaceWarriorsSpaceships.sol
1339 
1340 
1341 pragma solidity ^0.8.7;
1342 
1343 /**
1344  * @title Mint Space warrior collection
1345  * @notice This contract mint NFT linked to an IPFS file
1346 */
1347 contract SpaceWarriorsSpaceships is ERC721Enumerable, Ownable {
1348     using Strings for uint256;
1349 
1350     // Merkle root of the whitelist
1351     bytes32 public _merkleRoot1;
1352     bytes32 public _merkleRoot2;
1353 
1354     // Max supply 
1355     uint public _maxSupply = 3700;
1356 
1357     // Price token in ether
1358     uint public _price = 0.0 ether; 
1359      
1360     // Contract status. If paused, no one can mint
1361     bool public _paused = true; 
1362     
1363     // Sell status. Presale if true and public sale if false
1364     bool public _presale = true;
1365     // Address of the team wallet
1366 
1367     //Flag allowing the set of the base URI only once
1368     bool public _baseURIset = false;
1369     /**
1370      * @dev NFT configuration
1371      * _revealed: Lock/Unlock the final URI. Link to the hidden URI if false
1372      * baseURI : URI of the revealed NFT
1373      * _hideURI : URI of the non revealed NFT
1374      */
1375     string public baseURI;
1376 
1377     bool _requireWhitelist = true;
1378 
1379     /**
1380      * @dev Modifier isWhitelisted to check if the caller is on the whitelist
1381      */
1382     modifier isWhitelisted(bytes32 [] calldata  merkleProof, bytes32 root){
1383         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1384         if (_requireWhitelist) {
1385             require(MerkleProof.verify(merkleProof, root, leaf), "Not in the whitelist");
1386         }
1387         _;
1388     }
1389 
1390     /**
1391      * @dev Initializes tbe contract with: 
1392      * initURI: the final URI after reveal in a format eg: "ipfs://QmdsxxxxxxxxxxxxxxxxxxepJF/"
1393      * merkleRoot: the merkle root of the whitelist
1394      * team: Address of the team wallet
1395      */
1396     constructor (bytes32 merkleRoot1, bytes32 merkleRoot2) ERC721("SpaceWarriors Spaceships", "SPW-S"){
1397         _merkleRoot1 = merkleRoot1;
1398         _merkleRoot2 = merkleRoot2;
1399         _mintNFT(1);
1400     }
1401 
1402     function setRequireWhitelist(bool flag) external onlyOwner {
1403         _requireWhitelist = flag;
1404     }
1405 
1406     /**
1407      * @dev Switch the status of the contract
1408      *
1409      * In pause state if `_paused` is true, no one can mint but the owner 
1410      *
1411      */
1412     function switchPauseStatus() external onlyOwner (){
1413         _paused = !_paused;
1414     }
1415 
1416     mapping(address => bool) mintedSWCS;
1417 
1418      function giveAway(uint256 amount) external onlyOwner {
1419         _mintNFT(amount);
1420      }
1421        
1422 
1423     /**
1424      * @dev Minting for whitelisted addresses
1425      *
1426      * Requirements:
1427      * 
1428      * Contract must be unpaused
1429      * The presale must be going on
1430      * The caller must request less than the max by address authorized
1431      * The amount of token must be superior to 0
1432      * The supply must not be empty
1433      * The price must be correct
1434      * 
1435      * @param merkleProof for the wallet address 
1436      * 
1437      */
1438     function mintOne(bytes32[] calldata merkleProof) external isWhitelisted(merkleProof, _merkleRoot1) {
1439         require(!_paused, "Contract paused");
1440         require(!mintedSWCS[msg.sender], "You already have your spaceship");
1441         require(totalSupply() + 1 <= _maxSupply, "Max supply reached !");
1442 
1443         mintedSWCS[msg.sender] = true;
1444         _mintNFT(1);
1445     }
1446 
1447     function mintTwo(bytes32[] calldata merkleProof) external isWhitelisted(merkleProof, _merkleRoot2) {
1448         require(!_paused, "Contract paused");
1449         require(!mintedSWCS[msg.sender], "You already have your spaceship");
1450         require(totalSupply() + 2 <= _maxSupply, "Max supply reached !");
1451 
1452         mintedSWCS[msg.sender] = true;
1453         _mintNFT(2);
1454     }
1455 
1456     function setMintedSWCS(bool value, address target) external onlyOwner {
1457         mintedSWCS[target] = value;
1458     }
1459 
1460     /**
1461      * @dev Updating the merkle root
1462      *
1463      * @param newMerkleRoot must start with 0x  
1464      * 
1465      */
1466     function updateMerkleRoot1(bytes32 newMerkleRoot) external onlyOwner {
1467          _merkleRoot1 = newMerkleRoot;
1468     }
1469 
1470     function updateMerkleRoot2(bytes32 newMerkleRoot) external onlyOwner {
1471          _merkleRoot2 = newMerkleRoot;
1472     }
1473             
1474     /**
1475      * @dev Mint the amount of NFT requested
1476      */
1477     function _mintNFT(uint _amountToMint) internal {
1478         uint currentSupply = totalSupply();   
1479          for (uint i; i < _amountToMint ; i++) {
1480             _safeMint(msg.sender, currentSupply + i);
1481         }         
1482     }
1483      
1484     /**
1485      * @dev Return an array of token Id owned by `owner`
1486      */
1487     function getWallet(address _owner) public view returns(uint [] memory) {
1488         uint numberOwned = balanceOf(_owner);
1489         uint [] memory idItems = new uint[](numberOwned);
1490         
1491         for (uint i = 0; i < numberOwned; i++){
1492             idItems[i] = tokenOfOwnerByIndex(_owner,i);
1493         }
1494         
1495         return idItems;
1496     }
1497     
1498     /**
1499      * @dev ERC721 standard
1500      * @return baseURI value
1501      */
1502     function _baseURI() internal view virtual override returns (string memory) {
1503         return baseURI;
1504     }
1505 
1506     /**
1507      * @dev Set the base URI
1508      * 
1509      * The owner set the base URI only once !
1510      * The style MUST BE as follow : "ipfs://QmdsaXXXXXXXXXXXXXXXXXXXX7epJF/"
1511      */
1512     function setBaseURI(string memory newBaseURI) public onlyOwner {
1513         require (!_baseURIset, "Base URI has already be set");
1514         _baseURIset = true;
1515         baseURI = newBaseURI;
1516     }
1517     
1518     /**
1519      * @dev Return the URI of the NFT
1520      * @notice return the hidden URI then the Revealed JSON when the Revealed param is true
1521      */
1522     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1523         require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1524 
1525         string memory URI = _baseURI();
1526         return bytes(URI).length > 0 ? string(abi.encodePacked(URI, tokenId.toString(), ".json")) : "";
1527     }    
1528 }