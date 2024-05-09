1 // SPDX-License-Identifier: MIT
2 
3 /**
4     ____  ___    _   ____ __ ____  ____  ___________ _________    _   _____    ____  ______
5    / __ \/   |  / | / / //_// __ )/ __ \/_  __/ ___// ____/   |  / | / /   |  / __ \/_  __/
6   / / / / /| | /  |/ / ,<  / __  / / / / / /  \__ \/ /_  / /| | /  |/ / /| | / /_/ / / /   
7  / /_/ / ___ |/ /|  / /| |/ /_/ / /_/ / / /  ___/ / __/ / ___ |/ /|  / ___ |/ _, _/ / /    
8 /_____/_/  |_/_/ |_/_/ |_/_____/\____/ /_/  /____/_/   /_/  |_/_/ |_/_/  |_/_/ |_| /_/     
9                                                                                               
10 by 0xd3ad
11 */
12 
13 
14 pragma solidity ^0.8.0;
15 /**
16  * @dev These functions deal with verification of Merkle Trees proofs.
17  *
18  * The proofs can be generated using the JavaScript library
19  * https://github.com/miguelmota/merkletreejs[merkletreejs].
20  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
21  *
22  * See `test/utils/cryptography/MerkleProof.test.js` fo
23 r some examples.
24  *
25  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
26  * hashing, or use a hash function other than keccak256 for hashing leaves.
27  * This is because the concatenation of a sorted pair of internal nodes in
28  * the merkle tree could be reinterpreted as a leaf value.
29  */
30 
31 library MerkleProof {
32     /**
33      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
34      * defined by `root`. For this, a `proof` must be provided, containing
35      * sibling hashes on the branch from the leaf to the root of the tree. Each
36      * pair of leaves and each pair of pre-images are assumed to be sorted.
37      */
38     function verify(
39         bytes32[] memory proof,
40         bytes32 root,
41         bytes32 leaf
42     ) internal pure returns (bool) {
43         return processProof(proof, leaf) == root;
44     }
45 
46     /**
47      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
48      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
49      * hash matches the root of the tree. When processing the proof, the pairs
50      * of leafs & pre-images are assumed to be sorted.
51      *
52      * _Available since v4.4._
53      */
54     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
55         bytes32 computedHash = leaf;
56         for (uint256 i = 0; i < proof.length; i++) {
57             bytes32 proofElement = proof[i];
58             if (computedHash <= proofElement) {
59                 // Hash(current computed hash + current element of the proof)
60                 computedHash = _efficientHash(computedHash, proofElement);
61             } else {
62                 // Hash(current element of the proof + current computed hash)
63                 computedHash = _efficientHash(proofElement, computedHash);
64             }
65         }
66         return computedHash;
67     }
68 
69     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
70         assembly {
71             mstore(0x00, a)
72             mstore(0x20, b)
73             value := keccak256(0x00, 0x40)
74         }
75     }
76 }
77 
78 
79 
80 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Interface of the ERC165 standard, as defined in the
85  * https://eips.ethereum.org/EIPS/eip-165[EIP].
86  *
87  * Implementers can declare support of contract interfaces, which can then be
88  * queried by others ({ERC165Checker}).
89  *
90  * For an implementation, see {ERC165}.
91  */
92 interface IERC165 {
93     /**
94      * @dev Returns true if this contract implements the interface defined by
95      * `interfaceId`. See the corresponding
96      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
97      * to learn more about how these ids are created.
98      *
99      * This function call must use less than 30 000 gas.
100      */
101     function supportsInterface(bytes4 interfaceId) external view returns (bool);
102 }
103 
104 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
105 /**
106  * @dev Required interface of an ERC721 compliant contract.
107  */
108 interface IERC721 is IERC165 {
109     /**
110      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
111      */
112     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
113 
114     /**
115      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
116      */
117     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
118 
119     /**
120      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
121      */
122     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
123 
124     /**
125      * @dev Returns the number of tokens in ``owner``'s account.
126      */
127     function balanceOf(address owner) external view returns (uint256 balance);
128 
129     /**
130      * @dev Returns the owner of the `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function ownerOf(uint256 tokenId) external view returns (address owner);
137 
138     /**
139      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
140      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
141      *
142      * Requirements:
143      *
144      * - `from` cannot be the zero address.
145      * - `to` cannot be the zero address.
146      * - `tokenId` token must exist and be owned by `from`.
147      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
148      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
149      *
150      * Emits a {Transfer} event.
151      */
152     function safeTransferFrom(address from, address to, uint256 tokenId) external;
153 
154     /**
155      * @dev Transfers `tokenId` token from `from` to `to`.
156      *
157      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must be owned by `from`.
164      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(address from, address to, uint256 tokenId) external;
169 
170     /**
171      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
172      * The approval is cleared when the token is transferred.
173      *
174      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
175      *
176      * Requirements:
177      *
178      * - The caller must own the token or be an approved operator.
179      * - `tokenId` must exist.
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address to, uint256 tokenId) external;
184 
185     /**
186      * @dev Returns the account approved for `tokenId` token.
187      *
188      * Requirements:
189      *
190      * - `tokenId` must exist.
191      */
192     function getApproved(uint256 tokenId) external view returns (address operator);
193 
194     /**
195      * @dev Approve or remove `operator` as an operator for the caller.
196      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
197      *
198      * Requirements:
199      *
200      * - The `operator` cannot be the caller.
201      *
202      * Emits an {ApprovalForAll} event.
203      */
204     function setApprovalForAll(address operator, bool _approved) external;
205 
206     /**
207      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
208      *
209      * See {setApprovalForAll}
210      */
211     function isApprovedForAll(address owner, address operator) external view returns (bool);
212 
213     /**
214       * @dev Safely transfers `tokenId` token from `from` to `to`.
215       *
216       * Requirements:
217       *
218       * - `from` cannot be the zero address.
219       * - `to` cannot be the zero address.
220       * - `tokenId` token must exist and be owned by `from`.
221       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
222       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
223       *
224       * Emits a {Transfer} event.
225       */
226     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
227 }
228 
229 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
230 /**
231  * @title ERC721 token receiver interface
232  * @dev Interface for any contract that wants to support safeTransfers
233  * from ERC721 asset contracts.
234  */
235 interface IERC721Receiver {
236     /**
237      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
238      * by `operator` from `from`, this function is called.
239      *
240      * It must return its Solidity selector to confirm the token transfer.
241      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
242      *
243      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
244      */
245     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
246 }
247 
248 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
249 /**
250  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
251  * @dev See https://eips.ethereum.org/EIPS/eip-721
252  */
253 interface IERC721Metadata is IERC721 {
254 
255     /**
256      * @dev Returns the token collection name.
257      */
258     function name() external view returns (string memory);
259 
260     /**
261      * @dev Returns the token collection symbol.
262      */
263     function symbol() external view returns (string memory);
264 
265     /**
266      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
267      */
268     function tokenURI(uint256 tokenId) external view returns (string memory);
269 }
270 
271 // File: @openzeppelin/contracts/utils/Address.sol
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies on extcodesize, which returns 0 for contracts in
296         // construction, since the code is only stored at the end of the
297         // constructor execution.
298 
299         uint256 size;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { size := extcodesize(account) }
302         return size > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
325         (bool success, ) = recipient.call{ value: amount }("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain`call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348       return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: value }(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
398         return functionStaticCall(target, data, "Address: low-level static call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
408         require(isContract(target), "Address: static call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.delegatecall(data);
436         return _verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 // solhint-disable-next-line no-inline-assembly
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
459 // File: @openzeppelin/contracts/utils/Context.sol
460 /*
461  * @dev Provides information about the current execution context, including the
462  * sender of the transaction and its data. While these are generally available
463  * via msg.sender and msg.data, they should not be accessed in such a direct
464  * manner, since when dealing with meta-transactions the account sending and
465  * paying for execution may not be the actual sender (as far as an application
466  * is concerned).
467  *
468  * This contract is only required for intermediate, library-like contracts.
469  */
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes calldata) {
476         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
477         return msg.data;
478     }
479 }
480 
481 /**
482  * @dev Contract module which provides a basic access control mechanism, where
483  * there is an account (an owner) that can be granted exclusive access to
484  * specific functions.
485  *
486  * By default, the owner account will be the one that deploys the contract. This
487  * can later be changed with {transferOwnership}.
488  *
489  * This module is used through inheritance. It will make available the modifier
490  * `onlyOwner`, which can be applied to your functions to restrict their use to
491  * the owner.
492  */
493 abstract contract Ownable is Context {
494     address private _owner;
495 
496     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
497 
498     /**
499      * @dev Initializes the contract setting the deployer as the initial owner.
500      */
501     constructor() {
502         _transferOwnership(_msgSender());
503     }
504 
505     /**
506      * @dev Returns the address of the current owner.
507      */
508     function owner() public view virtual returns (address) {
509         return _owner;
510     }
511 
512     /**
513      * @dev Throws if called by any account other than the owner.
514      */
515     modifier onlyOwner() {
516         require(owner() == _msgSender(), "Ownable: caller is not the owner");
517         _;
518     }
519 
520     /**
521      * @dev Leaves the contract without owner. It will not be possible to call
522      * `onlyOwner` functions anymore. Can only be called by the current owner.
523      *
524      * NOTE: Renouncing ownership will leave the contract without an owner,
525      * thereby removing any functionality that is only available to the owner.
526      */
527     function renounceOwnership() public virtual onlyOwner {
528         _transferOwnership(address(0));
529     }
530 
531     /**
532      * @dev Transfers ownership of the contract to a new account (`newOwner`).
533      * Can only be called by the current owner.
534      */
535     function transferOwnership(address newOwner) public virtual onlyOwner {
536         require(newOwner != address(0), "Ownable: new owner is the zero address");
537         _transferOwnership(newOwner);
538     }
539 
540     /**
541      * @dev Transfers ownership of the contract to a new account (`newOwner`).
542      * Internal function without access restriction.
543      */
544     function _transferOwnership(address newOwner) internal virtual {
545         address oldOwner = _owner;
546         _owner = newOwner;
547         emit OwnershipTransferred(oldOwner, newOwner);
548     }
549 }
550 
551 // File: @openzeppelin/contracts/utils/Strings.sol
552 /**
553  * @dev String operations.
554  */
555 library Strings {
556     bytes16 private constant alphabet = "0123456789abcdef";
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
560      */
561     function toString(uint256 value) internal pure returns (string memory) {
562         // Inspired by OraclizeAPI's implementation - MIT licence
563         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
564 
565         if (value == 0) {
566             return "0";
567         }
568         uint256 temp = value;
569         uint256 digits;
570         while (temp != 0) {
571             digits++;
572             temp /= 10;
573         }
574         bytes memory buffer = new bytes(digits);
575         while (value != 0) {
576             digits -= 1;
577             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
578             value /= 10;
579         }
580         return string(buffer);
581     }
582 
583     /**
584      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
585      */
586     function toHexString(uint256 value) internal pure returns (string memory) {
587         if (value == 0) {
588             return "0x00";
589         }
590         uint256 temp = value;
591         uint256 length = 0;
592         while (temp != 0) {
593             length++;
594             temp >>= 8;
595         }
596         return toHexString(value, length);
597     }
598 
599     /**
600      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
601      */
602     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
603         bytes memory buffer = new bytes(2 * length + 2);
604         buffer[0] = "0";
605         buffer[1] = "x";
606         for (uint256 i = 2 * length + 1; i > 1; --i) {
607             buffer[i] = alphabet[value & 0xf];
608             value >>= 4;
609         }
610         require(value == 0, "Strings: hex length insufficient");
611         return string(buffer);
612     }
613 
614 }
615 
616 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
617 /**
618  * @dev Implementation of the {IERC165} interface.
619  *
620  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
621  * for the additional interface id that will be supported. For example:
622  *
623  * ```solidity
624  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
625  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
626  * }
627  * ```
628  *
629  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
630  */
631 abstract contract ERC165 is IERC165 {
632     /**
633      * @dev See {IERC165-supportsInterface}.
634      */
635     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636         return interfaceId == type(IERC165).interfaceId;
637     }
638 }
639 
640 // File: contracts/DankbotsFanArt.sol
641 // Creator: Chiru Labs
642 
643 pragma solidity ^0.8.4;
644 
645 error ApprovalCallerNotOwnerNorApproved();
646 error ApprovalQueryForNonexistentToken();
647 error ApproveToCaller();
648 error ApprovalToCurrentOwner();
649 error BalanceQueryForZeroAddress();
650 error MintToZeroAddress();
651 error MintZeroQuantity();
652 error OwnerQueryForNonexistentToken();
653 error TransferCallerNotOwnerNorApproved();
654 error TransferFromIncorrectOwner();
655 error TransferToNonERC721ReceiverImplementer();
656 error TransferToZeroAddress();
657 error URIQueryForNonexistentToken();
658 
659 /**
660  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
661  * the Metadata extension. Built to optimize for lower gas during batch mints.
662  *
663  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
664  *
665  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
666  *
667  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
668  */
669 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
670     using Address for address;
671     using Strings for uint256;
672 
673     // Compiler will pack this into a single 256bit word.
674     struct TokenOwnership {
675         // The address of the owner.
676         address addr;
677         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
678         uint64 startTimestamp;
679         // Whether the token has been burned.
680         bool burned;
681     }
682 
683     // Compiler will pack this into a single 256bit word.
684     struct AddressData {
685         // Realistically, 2**64-1 is more than enough.
686         uint64 balance;
687         // Keeps track of mint count with minimal overhead for tokenomics.
688         uint64 numberMinted;
689         // Keeps track of burn count with minimal overhead for tokenomics.
690         uint64 numberBurned;
691         // For miscellaneous variable(s) pertaining to the address
692         // (e.g. number of whitelist mint slots used).
693         // If there are multiple variables, please pack them into a uint64.
694         uint64 aux;
695     }
696 
697     // The tokenId of the next token to be minted.
698     uint256 internal _currentIndex;
699 
700     // The number of tokens burned.
701     uint256 internal _burnCounter;
702 
703     // Token name
704     string private _name;
705 
706     // Token symbol
707     string private _symbol;
708 
709     // Mapping from token ID to ownership details
710     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
711     mapping(uint256 => TokenOwnership) internal _ownerships;
712 
713     // Mapping owner address to address data
714     mapping(address => AddressData) private _addressData;
715 
716     // Mapping from token ID to approved address
717     mapping(uint256 => address) private _tokenApprovals;
718 
719     // Mapping from owner to operator approvals
720     mapping(address => mapping(address => bool)) private _operatorApprovals;
721 
722     constructor(string memory name_, string memory symbol_) {
723         _name = name_;
724         _symbol = symbol_;
725         _currentIndex = _startTokenId();
726     }
727 
728     /**
729      * To change the starting tokenId, please override this function.
730      */
731     function _startTokenId() internal view virtual returns (uint256) {
732         return 0;
733     }
734 
735     /**
736      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
737      */
738     function totalSupply() public view returns (uint256) {
739         // Counter underflow is impossible as _burnCounter cannot be incremented
740         // more than _currentIndex - _startTokenId() times
741         unchecked {
742             return _currentIndex - _burnCounter - _startTokenId();
743         }
744     }
745 
746     /**
747      * Returns the total amount of tokens minted in the contract.
748      */
749     function _totalMinted() internal view returns (uint256) {
750         // Counter underflow is impossible as _currentIndex does not decrement,
751         // and it is initialized to _startTokenId()
752         unchecked {
753             return _currentIndex - _startTokenId();
754         }
755     }
756 
757     /**
758      * @dev See {IERC165-supportsInterface}.
759      */
760     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
761         return
762             interfaceId == type(IERC721).interfaceId ||
763             interfaceId == type(IERC721Metadata).interfaceId ||
764             super.supportsInterface(interfaceId);
765     }
766 
767     /**
768      * @dev See {IERC721-balanceOf}.
769      */
770     function balanceOf(address owner) public view override returns (uint256) {
771         if (owner == address(0)) revert BalanceQueryForZeroAddress();
772         return uint256(_addressData[owner].balance);
773     }
774 
775     /**
776      * Returns the number of tokens minted by `owner`.
777      */
778     function _numberMinted(address owner) internal view returns (uint256) {
779         return uint256(_addressData[owner].numberMinted);
780     }
781 
782     /**
783      * Returns the number of tokens burned by or on behalf of `owner`.
784      */
785     function _numberBurned(address owner) internal view returns (uint256) {
786         return uint256(_addressData[owner].numberBurned);
787     }
788 
789     /**
790      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
791      */
792     function _getAux(address owner) internal view returns (uint64) {
793         return _addressData[owner].aux;
794     }
795 
796     /**
797      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
798      * If there are multiple variables, please pack them into a uint64.
799      */
800     function _setAux(address owner, uint64 aux) internal {
801         _addressData[owner].aux = aux;
802     }
803 
804     /**
805      * Gas spent here starts off proportional to the maximum mint batch size.
806      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
807      */
808     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
809         uint256 curr = tokenId;
810 
811         unchecked {
812             if (_startTokenId() <= curr && curr < _currentIndex) {
813                 TokenOwnership memory ownership = _ownerships[curr];
814                 if (!ownership.burned) {
815                     if (ownership.addr != address(0)) {
816                         return ownership;
817                     }
818                     // Invariant:
819                     // There will always be an ownership that has an address and is not burned
820                     // before an ownership that does not have an address and is not burned.
821                     // Hence, curr will not underflow.
822                     while (true) {
823                         curr--;
824                         ownership = _ownerships[curr];
825                         if (ownership.addr != address(0)) {
826                             return ownership;
827                         }
828                     }
829                 }
830             }
831         }
832         revert OwnerQueryForNonexistentToken();
833     }
834 
835     /**
836      * @dev See {IERC721-ownerOf}.
837      */
838     function ownerOf(uint256 tokenId) public view override returns (address) {
839         return _ownershipOf(tokenId).addr;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-name}.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-symbol}.
851      */
852     function symbol() public view virtual override returns (string memory) {
853         return _symbol;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-tokenURI}.
858      */
859     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
860         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
861 
862         string memory baseURI = _baseURI();
863         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
864     }
865 
866     /**
867      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
868      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
869      * by default, can be overriden in child contracts.
870      */
871     function _baseURI() internal view virtual returns (string memory) {
872         return '';
873     }
874 
875     /**
876      * @dev See {IERC721-approve}.
877      */
878     function approve(address to, uint256 tokenId) public override {
879         address owner = ERC721A.ownerOf(tokenId);
880         if (to == owner) revert ApprovalToCurrentOwner();
881 
882         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
883             revert ApprovalCallerNotOwnerNorApproved();
884         }
885 
886         _approve(to, tokenId, owner);
887     }
888 
889     /**
890      * @dev See {IERC721-getApproved}.
891      */
892     function getApproved(uint256 tokenId) public view override returns (address) {
893         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
894 
895         return _tokenApprovals[tokenId];
896     }
897 
898     /**
899      * @dev See {IERC721-setApprovalForAll}.
900      */
901     function setApprovalForAll(address operator, bool approved) public virtual override {
902         if (operator == _msgSender()) revert ApproveToCaller();
903 
904         _operatorApprovals[_msgSender()][operator] = approved;
905         emit ApprovalForAll(_msgSender(), operator, approved);
906     }
907 
908     /**
909      * @dev See {IERC721-isApprovedForAll}.
910      */
911     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
912         return _operatorApprovals[owner][operator];
913     }
914 
915     /**
916      * @dev See {IERC721-transferFrom}.
917      */
918     function transferFrom(
919         address from,
920         address to,
921         uint256 tokenId
922     ) public virtual override {
923         _transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev See {IERC721-safeTransferFrom}.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public virtual override {
934         safeTransferFrom(from, to, tokenId, '');
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) public virtual override {
946         _transfer(from, to, tokenId);
947         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
948             revert TransferToNonERC721ReceiverImplementer();
949         }
950     }
951 
952     /**
953      * @dev Returns whether `tokenId` exists.
954      *
955      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
956      *
957      * Tokens start existing when they are minted (`_mint`),
958      */
959     function _exists(uint256 tokenId) internal view returns (bool) {
960         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
961             !_ownerships[tokenId].burned;
962     }
963 
964     function _safeMint(address to, uint256 quantity) internal {
965         _safeMint(to, quantity, '');
966     }
967 
968     /**
969      * @dev Safely mints `quantity` tokens and transfers them to `to`.
970      *
971      * Requirements:
972      *
973      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
974      * - `quantity` must be greater than 0.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _safeMint(
979         address to,
980         uint256 quantity,
981         bytes memory _data
982     ) internal {
983         _mint(to, quantity, _data, true);
984     }
985 
986     /**
987      * @dev Mints `quantity` tokens and transfers them to `to`.
988      *
989      * Requirements:
990      *
991      * - `to` cannot be the zero address.
992      * - `quantity` must be greater than 0.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _mint(
997         address to,
998         uint256 quantity,
999         bytes memory _data,
1000         bool safe
1001     ) internal {
1002         uint256 startTokenId = _currentIndex;
1003         if (to == address(0)) revert MintToZeroAddress();
1004         if (quantity == 0) revert MintZeroQuantity();
1005 
1006         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1007 
1008         // Overflows are incredibly unrealistic.
1009         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1010         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1011         unchecked {
1012             _addressData[to].balance += uint64(quantity);
1013             _addressData[to].numberMinted += uint64(quantity);
1014 
1015             _ownerships[startTokenId].addr = to;
1016             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1017 
1018             uint256 updatedIndex = startTokenId;
1019             uint256 end = updatedIndex + quantity;
1020 
1021             if (safe && to.isContract()) {
1022                 do {
1023                     emit Transfer(address(0), to, updatedIndex);
1024                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1025                         revert TransferToNonERC721ReceiverImplementer();
1026                     }
1027                 } while (updatedIndex != end);
1028                 // Reentrancy protection
1029                 if (_currentIndex != startTokenId) revert();
1030             } else {
1031                 do {
1032                     emit Transfer(address(0), to, updatedIndex++);
1033                 } while (updatedIndex != end);
1034             }
1035             _currentIndex = updatedIndex;
1036         }
1037         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1038     }
1039 
1040     /**
1041      * @dev Transfers `tokenId` from `from` to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must be owned by `from`.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _transfer(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) private {
1055         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1056 
1057         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1058 
1059         bool isApprovedOrOwner = (_msgSender() == from ||
1060             isApprovedForAll(from, _msgSender()) ||
1061             getApproved(tokenId) == _msgSender());
1062 
1063         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1064         if (to == address(0)) revert TransferToZeroAddress();
1065 
1066         _beforeTokenTransfers(from, to, tokenId, 1);
1067 
1068         // Clear approvals from the previous owner
1069         _approve(address(0), tokenId, from);
1070 
1071         // Underflow of the sender's balance is impossible because we check for
1072         // ownership above and the recipient's balance can't realistically overflow.
1073         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1074         unchecked {
1075             _addressData[from].balance -= 1;
1076             _addressData[to].balance += 1;
1077 
1078             TokenOwnership storage currSlot = _ownerships[tokenId];
1079             currSlot.addr = to;
1080             currSlot.startTimestamp = uint64(block.timestamp);
1081 
1082             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1083             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1084             uint256 nextTokenId = tokenId + 1;
1085             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1086             if (nextSlot.addr == address(0)) {
1087                 // This will suffice for checking _exists(nextTokenId),
1088                 // as a burned slot cannot contain the zero address.
1089                 if (nextTokenId != _currentIndex) {
1090                     nextSlot.addr = from;
1091                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1092                 }
1093             }
1094         }
1095 
1096         emit Transfer(from, to, tokenId);
1097         _afterTokenTransfers(from, to, tokenId, 1);
1098     }
1099 
1100     /**
1101      * @dev This is equivalent to _burn(tokenId, false)
1102      */
1103     function _burn(uint256 tokenId) internal virtual {
1104         _burn(tokenId, false);
1105     }
1106 
1107     /**
1108      * @dev Destroys `tokenId`.
1109      * The approval is cleared when the token is burned.
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must exist.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1118         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1119 
1120         address from = prevOwnership.addr;
1121 
1122         if (approvalCheck) {
1123             bool isApprovedOrOwner = (_msgSender() == from ||
1124                 isApprovedForAll(from, _msgSender()) ||
1125                 getApproved(tokenId) == _msgSender());
1126 
1127             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1128         }
1129 
1130         _beforeTokenTransfers(from, address(0), tokenId, 1);
1131 
1132         // Clear approvals from the previous owner
1133         _approve(address(0), tokenId, from);
1134 
1135         // Underflow of the sender's balance is impossible because we check for
1136         // ownership above and the recipient's balance can't realistically overflow.
1137         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1138         unchecked {
1139             AddressData storage addressData = _addressData[from];
1140             addressData.balance -= 1;
1141             addressData.numberBurned += 1;
1142 
1143             // Keep track of who burned the token, and the timestamp of burning.
1144             TokenOwnership storage currSlot = _ownerships[tokenId];
1145             currSlot.addr = from;
1146             currSlot.startTimestamp = uint64(block.timestamp);
1147             currSlot.burned = true;
1148 
1149             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1150             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1151             uint256 nextTokenId = tokenId + 1;
1152             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1153             if (nextSlot.addr == address(0)) {
1154                 // This will suffice for checking _exists(nextTokenId),
1155                 // as a burned slot cannot contain the zero address.
1156                 if (nextTokenId != _currentIndex) {
1157                     nextSlot.addr = from;
1158                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1159                 }
1160             }
1161         }
1162 
1163         emit Transfer(from, address(0), tokenId);
1164         _afterTokenTransfers(from, address(0), tokenId, 1);
1165 
1166         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1167         unchecked {
1168             _burnCounter++;
1169         }
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
1187      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1188      *
1189      * @param from address representing the previous owner of the given token ID
1190      * @param to target address that will receive the tokens
1191      * @param tokenId uint256 ID of the token to be transferred
1192      * @param _data bytes optional data to send along with the call
1193      * @return bool whether the call correctly returned the expected magic value
1194      */
1195     function _checkContractOnERC721Received(
1196         address from,
1197         address to,
1198         uint256 tokenId,
1199         bytes memory _data
1200     ) private returns (bool) {
1201         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1202             return retval == IERC721Receiver(to).onERC721Received.selector;
1203         } catch (bytes memory reason) {
1204             if (reason.length == 0) {
1205                 revert TransferToNonERC721ReceiverImplementer();
1206             } else {
1207                 assembly {
1208                     revert(add(32, reason), mload(reason))
1209                 }
1210             }
1211         }
1212     }
1213 
1214     /**
1215      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1216      * And also called before burning one token.
1217      *
1218      * startTokenId - the first token id to be transferred
1219      * quantity - the amount to be transferred
1220      *
1221      * Calling conditions:
1222      *
1223      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1224      * transferred to `to`.
1225      * - When `from` is zero, `tokenId` will be minted for `to`.
1226      * - When `to` is zero, `tokenId` will be burned by `from`.
1227      * - `from` and `to` are never both zero.
1228      */
1229     function _beforeTokenTransfers(
1230         address from,
1231         address to,
1232         uint256 startTokenId,
1233         uint256 quantity
1234     ) internal virtual {}
1235 
1236     /**
1237      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1238      * minting.
1239      * And also called after one token has been burned.
1240      *
1241      * startTokenId - the first token id to be transferred
1242      * quantity - the amount to be transferred
1243      *
1244      * Calling conditions:
1245      *
1246      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1247      * transferred to `to`.
1248      * - When `from` is zero, `tokenId` has been minted for `to`.
1249      * - When `to` is zero, `tokenId` has been burned by `from`.
1250      * - `from` and `to` are never both zero.
1251      */
1252     function _afterTokenTransfers(
1253         address from,
1254         address to,
1255         uint256 startTokenId,
1256         uint256 quantity
1257     ) internal virtual {}
1258 }
1259 
1260 
1261 
1262 contract DankbotsFanArt is ERC721A, Ownable {
1263 	using Strings for uint256;
1264 
1265 	event eventSetCost(uint256 _newCost );
1266 	event eventMint(uint256 _mintAmount);
1267 	event eventSetMaxMintAmount(uint256 _newMaxMintAmount);
1268 	event eventSetMaxSupply(uint256 _newmaxSupply);
1269 	event eventSetNotRevealedURI(string _notRevealedURI);
1270 	event eventSetBaseURI(string _newBaseURI);
1271 	event eventSetBaseExtension(string _newBaseExtension);
1272 	event eventPause(bool _state);
1273 	event eventReveal(bool _state);
1274 	event eventSetWithdrawalAddress( address _newAddress );
1275 	event eventWithdraw();
1276 	event eventSetWhitelistCost(uint256 _newCost );
1277 	event eventPauseWhitelist(bool _state);
1278 	event eventSetWhitelistRoot( bytes32 _newWhitelistRoot );
1279 	event eventMintWhitelist( bytes32[] _merkleProof, uint256 _mintAmount);
1280 
1281 	address public withdrawal_address = 0x405874F1Ce5778d5FFDf66f7aba14DA446564B6a;
1282 	string baseURI = "";
1283 	string public notRevealedUri = "";
1284 	string public baseExtension = ".json";
1285 
1286 	uint256 public cost = 0.01 ether;		// mint cost
1287 	bool public paused = true;			// paused at release
1288 	uint256 public maxSupply = 750;			// max supply
1289 	uint256 public maxMintAmount = 10;		// max amount anyone can mint
1290 
1291 	uint256 public whitelistCost = 0.0069 ether;	// whitelist mint cost
1292 	bool public whitelistPaused = true;		// paused at release
1293 	bytes32 public whitelistRoot = "";		// merkle root for whitelist
1294 	mapping( address => bool ) public whitelistClaimed;
1295 
1296 	bool public revealed = false;			// reveal images at purchase
1297 
1298 	string _name = "DANKBOTS ALL STARS";
1299 	string _symbol = "DBAS";
1300 
1301 	constructor() ERC721A(_name, _symbol) {
1302 	}
1303 
1304 	// set mint cost
1305 	function setCost(uint256 _newCost ) public onlyOwner {
1306 		cost = _newCost;
1307 		emit eventSetCost( _newCost );
1308 	}
1309 
1310 	// internal
1311 	function _baseURI() 
1312 	internal 
1313 	view 
1314 	virtual 
1315 	override 
1316 	returns (string memory) {
1317 		return baseURI;
1318 	}
1319 
1320 	// public
1321 	// minting functions
1322 	function mint(uint256 _mintAmount) 
1323 	public 
1324 	payable {
1325 		require(!paused, "Cannot mint while paused" );
1326 		require(_mintAmount > 0);
1327 		require(totalSupply() + _mintAmount <= maxSupply);
1328 
1329 		if (msg.sender != owner()) {
1330 			require(_mintAmount + _numberMinted( msg.sender ) <= maxMintAmount, "Exceeds max mint amount" );
1331 			require(msg.value >= cost * _mintAmount);
1332 		}
1333 
1334 		_safeMint(msg.sender, _mintAmount);
1335 		emit eventMint( _mintAmount );
1336 	}
1337 
1338 	function tokenURI(uint256 tokenId)
1339 	public
1340 	view
1341 	virtual
1342 	override
1343 	returns (string memory)
1344 	{
1345 		require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1346 
1347 		if(revealed == false) {
1348 			return notRevealedUri;
1349 		}
1350 
1351 		string memory currentBaseURI = _baseURI();
1352 		return bytes(currentBaseURI).length > 0
1353 			? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1354 			: "";
1355 	}
1356 
1357 	//only owner
1358 	function reveal( bool _state ) 
1359 	public 
1360 	onlyOwner {
1361 		revealed = _state;
1362 		emit eventReveal( _state );
1363 	}
1364 
1365 	// whitelist functions
1366 	// set whitelist mint cost
1367 	function setWhitelistCost(uint256 _newCost ) public onlyOwner {
1368 		whitelistCost = _newCost;
1369 		emit eventSetWhitelistCost( _newCost );
1370 	}
1371 
1372 	// whitelistPaused functions
1373 	function pauseWhitelist(bool _state) public onlyOwner {
1374 		whitelistPaused = _state;
1375 		emit eventPauseWhitelist( _state );
1376 	}
1377 
1378 	// set whitelistRoot
1379 	function setWhitelistRoot( bytes32 _newWhitelistRoot ) 
1380 	public 
1381 	onlyOwner {
1382 		whitelistRoot = _newWhitelistRoot;
1383 		emit eventSetWhitelistRoot( _newWhitelistRoot );
1384 	}
1385 
1386 	function mintWhitelist( bytes32[] calldata _merkleProof, uint256 _mintAmount) 
1387 	public 
1388 	payable {
1389 		require(!whitelistPaused, "Cannot mint while whitelist is paused" );
1390 		require(_mintAmount > 0);
1391 		require(totalSupply() + _mintAmount <= maxSupply);
1392 		require( ! whitelistClaimed[ msg.sender ], "Address has already claimed whitelist!" );
1393 
1394 		if (msg.sender != owner()) {
1395 			require(_mintAmount + _numberMinted( msg.sender ) <= maxMintAmount, "Exceeds max mint amount" );
1396 			bytes32 leaf = keccak256( abi.encodePacked( msg.sender ) );
1397 			require( MerkleProof.verify( _merkleProof, whitelistRoot, leaf ), "Invalid proof" );
1398 			require(msg.value >= whitelistCost * _mintAmount);
1399 			whitelistClaimed[ msg.sender ] = true;
1400 		}
1401 
1402 		_safeMint(msg.sender, _mintAmount);
1403 		emit eventMintWhitelist( _merkleProof, _mintAmount );
1404 	}
1405 
1406 
1407 	function setMaxMintAmount(uint256 _newMaxMintAmount) 
1408 	public 
1409 	onlyOwner {
1410 		maxMintAmount = _newMaxMintAmount;
1411 		emit eventSetMaxMintAmount( _newMaxMintAmount );
1412 	}
1413 
1414 	function setMaxSupply(uint256 _newmaxSupply) 
1415 	public 
1416 	onlyOwner {
1417 		maxSupply = _newmaxSupply;
1418 		emit eventSetMaxSupply(_newmaxSupply);
1419 	}
1420 
1421 	function setNotRevealedURI(string memory _notRevealedURI) 
1422 	public 
1423 	onlyOwner {
1424 		notRevealedUri = _notRevealedURI;
1425 		emit eventSetNotRevealedURI(_notRevealedURI);
1426 	}
1427 
1428 	function setBaseURI(string memory _newBaseURI) 
1429 	public 
1430 	onlyOwner {
1431 		baseURI = _newBaseURI;
1432 		emit eventSetBaseURI(_newBaseURI);
1433 	}
1434 
1435 	function setBaseExtension(string memory _newBaseExtension) 
1436 	public 
1437 	onlyOwner {
1438 		baseExtension = _newBaseExtension;
1439 		emit eventSetBaseExtension(_newBaseExtension);
1440 	}
1441 
1442 	function pause(bool _state) 
1443 	public 
1444 	onlyOwner {
1445 		paused = _state;
1446 		emit eventPause(_state);
1447 	}
1448 
1449 	function setWithdrawalAddress( address _newAddress ) 
1450 	public 
1451 	onlyOwner {
1452 		withdrawal_address = _newAddress;
1453 		emit eventSetWithdrawalAddress(_newAddress );
1454 	}
1455 
1456 	function withdraw() 
1457 	public 
1458 	payable 
1459 	onlyOwner {
1460 		//(bool os, ) = payable(owner()).call{value: address(this).balance}("");
1461 		(bool os, ) = payable( withdrawal_address ).call{value: address(this).balance}("");
1462 		require(os);
1463 		emit eventWithdraw();
1464 	}
1465 }