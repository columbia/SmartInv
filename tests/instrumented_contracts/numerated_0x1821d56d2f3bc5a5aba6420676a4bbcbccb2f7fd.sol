1 // SPDX-License-Identifier: MIT
2 
3 /**
4  ____    _    _   _ _  ______   ___ _____ ____  
5 |  _ \  / \  | \ | | |/ / __ ) / _ \_   _/ ___| 
6 | | | |/ _ \ |  \| | ' /|  _ \| | | || | \___ \ 
7 | |_| / ___ \| |\  | . \| |_) | |_| || |  ___) |
8 |____/_/   \_\_| \_|_|\_\____/ \___/ |_| |____/ 
9                                                                                               
10 */
11 
12 pragma solidity ^0.8.0;
13 /**
14  * @dev These functions deal with verification of Merkle Trees proofs.
15  *
16  * The proofs can be generated using the JavaScript library
17  * https://github.com/miguelmota/merkletreejs[merkletreejs].
18  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
19  *
20  * See `test/utils/cryptography/MerkleProof.test.js` fo
21 r some examples.
22  *
23  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
24  * hashing, or use a hash function other than keccak256 for hashing leaves.
25  * This is because the concatenation of a sorted pair of internal nodes in
26  * the merkle tree could be reinterpreted as a leaf value.
27  */
28 
29 library MerkleProof {
30     /**
31      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
32      * defined by `root`. For this, a `proof` must be provided, containing
33      * sibling hashes on the branch from the leaf to the root of the tree. Each
34      * pair of leaves and each pair of pre-images are assumed to be sorted.
35      */
36     function verify(
37         bytes32[] memory proof,
38         bytes32 root,
39         bytes32 leaf
40     ) internal pure returns (bool) {
41         return processProof(proof, leaf) == root;
42     }
43 
44     /**
45      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
46      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
47      * hash matches the root of the tree. When processing the proof, the pairs
48      * of leafs & pre-images are assumed to be sorted.
49      *
50      * _Available since v4.4._
51      */
52     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
53         bytes32 computedHash = leaf;
54         for (uint256 i = 0; i < proof.length; i++) {
55             bytes32 proofElement = proof[i];
56             if (computedHash <= proofElement) {
57                 // Hash(current computed hash + current element of the proof)
58                 computedHash = _efficientHash(computedHash, proofElement);
59             } else {
60                 // Hash(current element of the proof + current computed hash)
61                 computedHash = _efficientHash(proofElement, computedHash);
62             }
63         }
64         return computedHash;
65     }
66 
67     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
68         assembly {
69             mstore(0x00, a)
70             mstore(0x20, b)
71             value := keccak256(0x00, 0x40)
72         }
73     }
74 }
75 
76 
77 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Interface of the ERC165 standard, as defined in the
82  * https://eips.ethereum.org/EIPS/eip-165[EIP].
83  *
84  * Implementers can declare support of contract interfaces, which can then be
85  * queried by others ({ERC165Checker}).
86  *
87  * For an implementation, see {ERC165}.
88  */
89 interface IERC165 {
90     /**
91      * @dev Returns true if this contract implements the interface defined by
92      * `interfaceId`. See the corresponding
93      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
94      * to learn more about how these ids are created.
95      *
96      * This function call must use less than 30 000 gas.
97      */
98     function supportsInterface(bytes4 interfaceId) external view returns (bool);
99 }
100 
101 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
102 /**
103  * @dev Required interface of an ERC721 compliant contract.
104  */
105 interface IERC721 is IERC165 {
106     /**
107      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
110 
111     /**
112      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
113      */
114     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
115 
116     /**
117      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
118      */
119     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
120 
121     /**
122      * @dev Returns the number of tokens in ``owner``'s account.
123      */
124     function balanceOf(address owner) external view returns (uint256 balance);
125 
126     /**
127      * @dev Returns the owner of the `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function ownerOf(uint256 tokenId) external view returns (address owner);
134 
135     /**
136      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
137      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
138      *
139      * Requirements:
140      *
141      * - `from` cannot be the zero address.
142      * - `to` cannot be the zero address.
143      * - `tokenId` token must exist and be owned by `from`.
144      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
146      *
147      * Emits a {Transfer} event.
148      */
149     function safeTransferFrom(address from, address to, uint256 tokenId) external;
150 
151     /**
152      * @dev Transfers `tokenId` token from `from` to `to`.
153      *
154      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(address from, address to, uint256 tokenId) external;
166 
167     /**
168      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
169      * The approval is cleared when the token is transferred.
170      *
171      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
172      *
173      * Requirements:
174      *
175      * - The caller must own the token or be an approved operator.
176      * - `tokenId` must exist.
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address to, uint256 tokenId) external;
181 
182     /**
183      * @dev Returns the account approved for `tokenId` token.
184      *
185      * Requirements:
186      *
187      * - `tokenId` must exist.
188      */
189     function getApproved(uint256 tokenId) external view returns (address operator);
190 
191     /**
192      * @dev Approve or remove `operator` as an operator for the caller.
193      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
194      *
195      * Requirements:
196      *
197      * - The `operator` cannot be the caller.
198      *
199      * Emits an {ApprovalForAll} event.
200      */
201     function setApprovalForAll(address operator, bool _approved) external;
202 
203     /**
204      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
205      *
206      * See {setApprovalForAll}
207      */
208     function isApprovedForAll(address owner, address operator) external view returns (bool);
209 
210     /**
211       * @dev Safely transfers `tokenId` token from `from` to `to`.
212       *
213       * Requirements:
214       *
215       * - `from` cannot be the zero address.
216       * - `to` cannot be the zero address.
217       * - `tokenId` token must exist and be owned by `from`.
218       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
219       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
220       *
221       * Emits a {Transfer} event.
222       */
223     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 /**
228  * @title ERC721 token receiver interface
229  * @dev Interface for any contract that wants to support safeTransfers
230  * from ERC721 asset contracts.
231  */
232 interface IERC721Receiver {
233     /**
234      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
235      * by `operator` from `from`, this function is called.
236      *
237      * It must return its Solidity selector to confirm the token transfer.
238      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
239      *
240      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
241      */
242     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
246 /**
247  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
248  * @dev See https://eips.ethereum.org/EIPS/eip-721
249  */
250 interface IERC721Metadata is IERC721 {
251 
252     /**
253      * @dev Returns the token collection name.
254      */
255     function name() external view returns (string memory);
256 
257     /**
258      * @dev Returns the token collection symbol.
259      */
260     function symbol() external view returns (string memory);
261 
262     /**
263      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
264      */
265     function tokenURI(uint256 tokenId) external view returns (string memory);
266 }
267 
268 // File: @openzeppelin/contracts/utils/Address.sol
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize, which returns 0 for contracts in
293         // construction, since the code is only stored at the end of the
294         // constructor execution.
295 
296         uint256 size;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { size := extcodesize(account) }
299         return size > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{ value: amount }("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain`call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345       return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         require(isContract(target), "Address: call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.call{ value: value }(data);
385         return _verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
395         return functionStaticCall(target, data, "Address: low-level static call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         // solhint-disable-next-line avoid-low-level-calls
408         (bool success, bytes memory returndata) = target.staticcall(data);
409         return _verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
419         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a delegate call.
425      *
426      * _Available since v3.4._
427      */
428     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
429         require(isContract(target), "Address: delegate call to non-contract");
430 
431         // solhint-disable-next-line avoid-low-level-calls
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return _verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
437         if (success) {
438             return returndata;
439         } else {
440             // Look for revert reason and bubble it up if present
441             if (returndata.length > 0) {
442                 // The easiest way to bubble the revert reason is using memory via assembly
443 
444                 // solhint-disable-next-line no-inline-assembly
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 // File: @openzeppelin/contracts/utils/Context.sol
457 /*
458  * @dev Provides information about the current execution context, including the
459  * sender of the transaction and its data. While these are generally available
460  * via msg.sender and msg.data, they should not be accessed in such a direct
461  * manner, since when dealing with meta-transactions the account sending and
462  * paying for execution may not be the actual sender (as far as an application
463  * is concerned).
464  *
465  * This contract is only required for intermediate, library-like contracts.
466  */
467 abstract contract Context {
468     function _msgSender() internal view virtual returns (address) {
469         return msg.sender;
470     }
471 
472     function _msgData() internal view virtual returns (bytes calldata) {
473         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
474         return msg.data;
475     }
476 }
477 
478 /**
479  * @dev Contract module which provides a basic access control mechanism, where
480  * there is an account (an owner) that can be granted exclusive access to
481  * specific functions.
482  *
483  * By default, the owner account will be the one that deploys the contract. This
484  * can later be changed with {transferOwnership}.
485  *
486  * This module is used through inheritance. It will make available the modifier
487  * `onlyOwner`, which can be applied to your functions to restrict their use to
488  * the owner.
489  */
490 abstract contract Ownable is Context {
491     address private _owner;
492 
493     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
494 
495     /**
496      * @dev Initializes the contract setting the deployer as the initial owner.
497      */
498     constructor() {
499         _transferOwnership(_msgSender());
500     }
501 
502     /**
503      * @dev Returns the address of the current owner.
504      */
505     function owner() public view virtual returns (address) {
506         return _owner;
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         require(owner() == _msgSender(), "Ownable: caller is not the owner");
514         _;
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions anymore. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby removing any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public virtual onlyOwner {
525         _transferOwnership(address(0));
526     }
527 
528     /**
529      * @dev Transfers ownership of the contract to a new account (`newOwner`).
530      * Can only be called by the current owner.
531      */
532     function transferOwnership(address newOwner) public virtual onlyOwner {
533         require(newOwner != address(0), "Ownable: new owner is the zero address");
534         _transferOwnership(newOwner);
535     }
536 
537     /**
538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
539      * Internal function without access restriction.
540      */
541     function _transferOwnership(address newOwner) internal virtual {
542         address oldOwner = _owner;
543         _owner = newOwner;
544         emit OwnershipTransferred(oldOwner, newOwner);
545     }
546 }
547 
548 // File: @openzeppelin/contracts/utils/Strings.sol
549 /**
550  * @dev String operations.
551  */
552 library Strings {
553     bytes16 private constant alphabet = "0123456789abcdef";
554 
555     /**
556      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
557      */
558     function toString(uint256 value) internal pure returns (string memory) {
559         // Inspired by OraclizeAPI's implementation - MIT licence
560         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
561 
562         if (value == 0) {
563             return "0";
564         }
565         uint256 temp = value;
566         uint256 digits;
567         while (temp != 0) {
568             digits++;
569             temp /= 10;
570         }
571         bytes memory buffer = new bytes(digits);
572         while (value != 0) {
573             digits -= 1;
574             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
575             value /= 10;
576         }
577         return string(buffer);
578     }
579 
580     /**
581      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
582      */
583     function toHexString(uint256 value) internal pure returns (string memory) {
584         if (value == 0) {
585             return "0x00";
586         }
587         uint256 temp = value;
588         uint256 length = 0;
589         while (temp != 0) {
590             length++;
591             temp >>= 8;
592         }
593         return toHexString(value, length);
594     }
595 
596     /**
597      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
598      */
599     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
600         bytes memory buffer = new bytes(2 * length + 2);
601         buffer[0] = "0";
602         buffer[1] = "x";
603         for (uint256 i = 2 * length + 1; i > 1; --i) {
604             buffer[i] = alphabet[value & 0xf];
605             value >>= 4;
606         }
607         require(value == 0, "Strings: hex length insufficient");
608         return string(buffer);
609     }
610 
611 }
612 
613 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
614 /**
615  * @dev Implementation of the {IERC165} interface.
616  *
617  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
618  * for the additional interface id that will be supported. For example:
619  *
620  * ```solidity
621  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
623  * }
624  * ```
625  *
626  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
627  */
628 abstract contract ERC165 is IERC165 {
629     /**
630      * @dev See {IERC165-supportsInterface}.
631      */
632     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
633         return interfaceId == type(IERC165).interfaceId;
634     }
635 }
636 
637 // File: contracts/DankBots.sol
638 // Creator: Chiru Labs
639 
640 pragma solidity ^0.8.4;
641 
642 error ApprovalCallerNotOwnerNorApproved();
643 error ApprovalQueryForNonexistentToken();
644 error ApproveToCaller();
645 error ApprovalToCurrentOwner();
646 error BalanceQueryForZeroAddress();
647 error MintToZeroAddress();
648 error MintZeroQuantity();
649 error OwnerQueryForNonexistentToken();
650 error TransferCallerNotOwnerNorApproved();
651 error TransferFromIncorrectOwner();
652 error TransferToNonERC721ReceiverImplementer();
653 error TransferToZeroAddress();
654 error URIQueryForNonexistentToken();
655 
656 /**
657  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
658  * the Metadata extension. Built to optimize for lower gas during batch mints.
659  *
660  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
661  *
662  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
663  *
664  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
665  */
666 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
667     using Address for address;
668     using Strings for uint256;
669 
670     // Compiler will pack this into a single 256bit word.
671     struct TokenOwnership {
672         // The address of the owner.
673         address addr;
674         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
675         uint64 startTimestamp;
676         // Whether the token has been burned.
677         bool burned;
678     }
679 
680     // Compiler will pack this into a single 256bit word.
681     struct AddressData {
682         // Realistically, 2**64-1 is more than enough.
683         uint64 balance;
684         // Keeps track of mint count with minimal overhead for tokenomics.
685         uint64 numberMinted;
686         // Keeps track of burn count with minimal overhead for tokenomics.
687         uint64 numberBurned;
688         // For miscellaneous variable(s) pertaining to the address
689         // (e.g. number of whitelist mint slots used).
690         // If there are multiple variables, please pack them into a uint64.
691         uint64 aux;
692     }
693 
694     // The tokenId of the next token to be minted.
695     uint256 internal _currentIndex;
696 
697     // The number of tokens burned.
698     uint256 internal _burnCounter;
699 
700     // Token name
701     string private _name;
702 
703     // Token symbol
704     string private _symbol;
705 
706     // Mapping from token ID to ownership details
707     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
708     mapping(uint256 => TokenOwnership) internal _ownerships;
709 
710     // Mapping owner address to address data
711     mapping(address => AddressData) private _addressData;
712 
713     // Mapping from token ID to approved address
714     mapping(uint256 => address) private _tokenApprovals;
715 
716     // Mapping from owner to operator approvals
717     mapping(address => mapping(address => bool)) private _operatorApprovals;
718 
719     constructor(string memory name_, string memory symbol_) {
720         _name = name_;
721         _symbol = symbol_;
722         _currentIndex = _startTokenId();
723     }
724 
725     /**
726      * To change the starting tokenId, please override this function.
727      */
728     function _startTokenId() internal view virtual returns (uint256) {
729         return 0;
730     }
731 
732     /**
733      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
734      */
735     function totalSupply() public view returns (uint256) {
736         // Counter underflow is impossible as _burnCounter cannot be incremented
737         // more than _currentIndex - _startTokenId() times
738         unchecked {
739             return _currentIndex - _burnCounter - _startTokenId();
740         }
741     }
742 
743     /**
744      * Returns the total amount of tokens minted in the contract.
745      */
746     function _totalMinted() internal view returns (uint256) {
747         // Counter underflow is impossible as _currentIndex does not decrement,
748         // and it is initialized to _startTokenId()
749         unchecked {
750             return _currentIndex - _startTokenId();
751         }
752     }
753 
754     /**
755      * @dev See {IERC165-supportsInterface}.
756      */
757     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
758         return
759             interfaceId == type(IERC721).interfaceId ||
760             interfaceId == type(IERC721Metadata).interfaceId ||
761             super.supportsInterface(interfaceId);
762     }
763 
764     /**
765      * @dev See {IERC721-balanceOf}.
766      */
767     function balanceOf(address owner) public view override returns (uint256) {
768         if (owner == address(0)) revert BalanceQueryForZeroAddress();
769         return uint256(_addressData[owner].balance);
770     }
771 
772     /**
773      * Returns the number of tokens minted by `owner`.
774      */
775     function _numberMinted(address owner) internal view returns (uint256) {
776         return uint256(_addressData[owner].numberMinted);
777     }
778 
779     /**
780      * Returns the number of tokens burned by or on behalf of `owner`.
781      */
782     function _numberBurned(address owner) internal view returns (uint256) {
783         return uint256(_addressData[owner].numberBurned);
784     }
785 
786     /**
787      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
788      */
789     function _getAux(address owner) internal view returns (uint64) {
790         return _addressData[owner].aux;
791     }
792 
793     /**
794      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
795      * If there are multiple variables, please pack them into a uint64.
796      */
797     function _setAux(address owner, uint64 aux) internal {
798         _addressData[owner].aux = aux;
799     }
800 
801     /**
802      * Gas spent here starts off proportional to the maximum mint batch size.
803      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
804      */
805     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
806         uint256 curr = tokenId;
807 
808         unchecked {
809             if (_startTokenId() <= curr && curr < _currentIndex) {
810                 TokenOwnership memory ownership = _ownerships[curr];
811                 if (!ownership.burned) {
812                     if (ownership.addr != address(0)) {
813                         return ownership;
814                     }
815                     // Invariant:
816                     // There will always be an ownership that has an address and is not burned
817                     // before an ownership that does not have an address and is not burned.
818                     // Hence, curr will not underflow.
819                     while (true) {
820                         curr--;
821                         ownership = _ownerships[curr];
822                         if (ownership.addr != address(0)) {
823                             return ownership;
824                         }
825                     }
826                 }
827             }
828         }
829         revert OwnerQueryForNonexistentToken();
830     }
831 
832     /**
833      * @dev See {IERC721-ownerOf}.
834      */
835     function ownerOf(uint256 tokenId) public view override returns (address) {
836         return _ownershipOf(tokenId).addr;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-name}.
841      */
842     function name() public view virtual override returns (string memory) {
843         return _name;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-symbol}.
848      */
849     function symbol() public view virtual override returns (string memory) {
850         return _symbol;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-tokenURI}.
855      */
856     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
857         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
858 
859         string memory baseURI = _baseURI();
860         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
861     }
862 
863     /**
864      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
865      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
866      * by default, can be overriden in child contracts.
867      */
868     function _baseURI() internal view virtual returns (string memory) {
869         return '';
870     }
871 
872     /**
873      * @dev See {IERC721-approve}.
874      */
875     function approve(address to, uint256 tokenId) public override {
876         address owner = ERC721A.ownerOf(tokenId);
877         if (to == owner) revert ApprovalToCurrentOwner();
878 
879         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
880             revert ApprovalCallerNotOwnerNorApproved();
881         }
882 
883         _approve(to, tokenId, owner);
884     }
885 
886     /**
887      * @dev See {IERC721-getApproved}.
888      */
889     function getApproved(uint256 tokenId) public view override returns (address) {
890         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
891 
892         return _tokenApprovals[tokenId];
893     }
894 
895     /**
896      * @dev See {IERC721-setApprovalForAll}.
897      */
898     function setApprovalForAll(address operator, bool approved) public virtual override {
899         if (operator == _msgSender()) revert ApproveToCaller();
900 
901         _operatorApprovals[_msgSender()][operator] = approved;
902         emit ApprovalForAll(_msgSender(), operator, approved);
903     }
904 
905     /**
906      * @dev See {IERC721-isApprovedForAll}.
907      */
908     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
909         return _operatorApprovals[owner][operator];
910     }
911 
912     /**
913      * @dev See {IERC721-transferFrom}.
914      */
915     function transferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         _transfer(from, to, tokenId);
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public virtual override {
931         safeTransferFrom(from, to, tokenId, '');
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) public virtual override {
943         _transfer(from, to, tokenId);
944         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
945             revert TransferToNonERC721ReceiverImplementer();
946         }
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      */
956     function _exists(uint256 tokenId) internal view returns (bool) {
957         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
958             !_ownerships[tokenId].burned;
959     }
960 
961     function _safeMint(address to, uint256 quantity) internal {
962         _safeMint(to, quantity, '');
963     }
964 
965     /**
966      * @dev Safely mints `quantity` tokens and transfers them to `to`.
967      *
968      * Requirements:
969      *
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
971      * - `quantity` must be greater than 0.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _safeMint(
976         address to,
977         uint256 quantity,
978         bytes memory _data
979     ) internal {
980         _mint(to, quantity, _data, true);
981     }
982 
983     /**
984      * @dev Mints `quantity` tokens and transfers them to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `quantity` must be greater than 0.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _mint(
994         address to,
995         uint256 quantity,
996         bytes memory _data,
997         bool safe
998     ) internal {
999         uint256 startTokenId = _currentIndex;
1000         if (to == address(0)) revert MintToZeroAddress();
1001         if (quantity == 0) revert MintZeroQuantity();
1002 
1003         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1004 
1005         // Overflows are incredibly unrealistic.
1006         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1007         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1008         unchecked {
1009             _addressData[to].balance += uint64(quantity);
1010             _addressData[to].numberMinted += uint64(quantity);
1011 
1012             _ownerships[startTokenId].addr = to;
1013             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1014 
1015             uint256 updatedIndex = startTokenId;
1016             uint256 end = updatedIndex + quantity;
1017 
1018             if (safe && to.isContract()) {
1019                 do {
1020                     emit Transfer(address(0), to, updatedIndex);
1021                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1022                         revert TransferToNonERC721ReceiverImplementer();
1023                     }
1024                 } while (updatedIndex != end);
1025                 // Reentrancy protection
1026                 if (_currentIndex != startTokenId) revert();
1027             } else {
1028                 do {
1029                     emit Transfer(address(0), to, updatedIndex++);
1030                 } while (updatedIndex != end);
1031             }
1032             _currentIndex = updatedIndex;
1033         }
1034         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *
1040      * Requirements:
1041      *
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must be owned by `from`.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _transfer(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) private {
1052         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1053 
1054         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1055 
1056         bool isApprovedOrOwner = (_msgSender() == from ||
1057             isApprovedForAll(from, _msgSender()) ||
1058             getApproved(tokenId) == _msgSender());
1059 
1060         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1061         if (to == address(0)) revert TransferToZeroAddress();
1062 
1063         _beforeTokenTransfers(from, to, tokenId, 1);
1064 
1065         // Clear approvals from the previous owner
1066         _approve(address(0), tokenId, from);
1067 
1068         // Underflow of the sender's balance is impossible because we check for
1069         // ownership above and the recipient's balance can't realistically overflow.
1070         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1071         unchecked {
1072             _addressData[from].balance -= 1;
1073             _addressData[to].balance += 1;
1074 
1075             TokenOwnership storage currSlot = _ownerships[tokenId];
1076             currSlot.addr = to;
1077             currSlot.startTimestamp = uint64(block.timestamp);
1078 
1079             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1080             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1081             uint256 nextTokenId = tokenId + 1;
1082             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1083             if (nextSlot.addr == address(0)) {
1084                 // This will suffice for checking _exists(nextTokenId),
1085                 // as a burned slot cannot contain the zero address.
1086                 if (nextTokenId != _currentIndex) {
1087                     nextSlot.addr = from;
1088                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1089                 }
1090             }
1091         }
1092 
1093         emit Transfer(from, to, tokenId);
1094         _afterTokenTransfers(from, to, tokenId, 1);
1095     }
1096 
1097     /**
1098      * @dev This is equivalent to _burn(tokenId, false)
1099      */
1100     function _burn(uint256 tokenId) internal virtual {
1101         _burn(tokenId, false);
1102     }
1103 
1104     /**
1105      * @dev Destroys `tokenId`.
1106      * The approval is cleared when the token is burned.
1107      *
1108      * Requirements:
1109      *
1110      * - `tokenId` must exist.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1115         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1116 
1117         address from = prevOwnership.addr;
1118 
1119         if (approvalCheck) {
1120             bool isApprovedOrOwner = (_msgSender() == from ||
1121                 isApprovedForAll(from, _msgSender()) ||
1122                 getApproved(tokenId) == _msgSender());
1123 
1124             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1125         }
1126 
1127         _beforeTokenTransfers(from, address(0), tokenId, 1);
1128 
1129         // Clear approvals from the previous owner
1130         _approve(address(0), tokenId, from);
1131 
1132         // Underflow of the sender's balance is impossible because we check for
1133         // ownership above and the recipient's balance can't realistically overflow.
1134         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1135         unchecked {
1136             AddressData storage addressData = _addressData[from];
1137             addressData.balance -= 1;
1138             addressData.numberBurned += 1;
1139 
1140             // Keep track of who burned the token, and the timestamp of burning.
1141             TokenOwnership storage currSlot = _ownerships[tokenId];
1142             currSlot.addr = from;
1143             currSlot.startTimestamp = uint64(block.timestamp);
1144             currSlot.burned = true;
1145 
1146             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1147             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1148             uint256 nextTokenId = tokenId + 1;
1149             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1150             if (nextSlot.addr == address(0)) {
1151                 // This will suffice for checking _exists(nextTokenId),
1152                 // as a burned slot cannot contain the zero address.
1153                 if (nextTokenId != _currentIndex) {
1154                     nextSlot.addr = from;
1155                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1156                 }
1157             }
1158         }
1159 
1160         emit Transfer(from, address(0), tokenId);
1161         _afterTokenTransfers(from, address(0), tokenId, 1);
1162 
1163         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1164         unchecked {
1165             _burnCounter++;
1166         }
1167     }
1168 
1169     /**
1170      * @dev Approve `to` to operate on `tokenId`
1171      *
1172      * Emits a {Approval} event.
1173      */
1174     function _approve(
1175         address to,
1176         uint256 tokenId,
1177         address owner
1178     ) private {
1179         _tokenApprovals[tokenId] = to;
1180         emit Approval(owner, to, tokenId);
1181     }
1182 
1183     /**
1184      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1185      *
1186      * @param from address representing the previous owner of the given token ID
1187      * @param to target address that will receive the tokens
1188      * @param tokenId uint256 ID of the token to be transferred
1189      * @param _data bytes optional data to send along with the call
1190      * @return bool whether the call correctly returned the expected magic value
1191      */
1192     function _checkContractOnERC721Received(
1193         address from,
1194         address to,
1195         uint256 tokenId,
1196         bytes memory _data
1197     ) private returns (bool) {
1198         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1199             return retval == IERC721Receiver(to).onERC721Received.selector;
1200         } catch (bytes memory reason) {
1201             if (reason.length == 0) {
1202                 revert TransferToNonERC721ReceiverImplementer();
1203             } else {
1204                 assembly {
1205                     revert(add(32, reason), mload(reason))
1206                 }
1207             }
1208         }
1209     }
1210 
1211     /**
1212      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1213      * And also called before burning one token.
1214      *
1215      * startTokenId - the first token id to be transferred
1216      * quantity - the amount to be transferred
1217      *
1218      * Calling conditions:
1219      *
1220      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1221      * transferred to `to`.
1222      * - When `from` is zero, `tokenId` will be minted for `to`.
1223      * - When `to` is zero, `tokenId` will be burned by `from`.
1224      * - `from` and `to` are never both zero.
1225      */
1226     function _beforeTokenTransfers(
1227         address from,
1228         address to,
1229         uint256 startTokenId,
1230         uint256 quantity
1231     ) internal virtual {}
1232 
1233     /**
1234      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1235      * minting.
1236      * And also called after one token has been burned.
1237      *
1238      * startTokenId - the first token id to be transferred
1239      * quantity - the amount to be transferred
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` has been minted for `to`.
1246      * - When `to` is zero, `tokenId` has been burned by `from`.
1247      * - `from` and `to` are never both zero.
1248      */
1249     function _afterTokenTransfers(
1250         address from,
1251         address to,
1252         uint256 startTokenId,
1253         uint256 quantity
1254     ) internal virtual {}
1255 }
1256 
1257 
1258 
1259 contract DankBots is ERC721A, Ownable {
1260 	using Strings for uint256;
1261 
1262 	address public withdrawal_address = 0x405874F1Ce5778d5FFDf66f7aba14DA446564B6a;
1263 	string baseURI = "";
1264 	string public notRevealedUri = "";
1265 	string public baseExtension = ".json";
1266 
1267 	uint256 public cost = 0.08 ether;		// mint cost
1268 	uint256 public maxSupply = 7777;		// max supply
1269 	uint256 public maxMintAmount = 10;		// max amount anyone can mint
1270 	uint256 public maxFreeMintAmount = 1;		// max amount free mint can mint
1271 	bool public paused = true;			// paused at release
1272 	bool public revealed = false;			// reveal images at purchase
1273 
1274 	uint256 public whitelistCost = 0.06 ether;	// whitelist mint cost
1275 	bool public whitelistPaused = true;		// paused at release
1276 	bytes32 public whitelistRoot = "";		// merkle root for whitelist
1277 	mapping( address => bool ) public whitelistClaimed;
1278 
1279 	bool public freePaused = true;			// paused at release
1280 	bytes32 public freeRoot = "";			// merkle root for free whitelist
1281 	mapping( address => bool ) public freeClaimed;
1282 
1283 	string _name = "DANKBOTS";
1284 	string _symbol = "DB";
1285 
1286 	constructor() ERC721A(_name, _symbol) {
1287 	}
1288 
1289 	// set mint cost
1290 	function setCost(uint256 _newCost ) public onlyOwner {
1291 		cost = _newCost;
1292 	}
1293 
1294 	// whitelist functions
1295 	// set whitelist mint cost
1296 	function setWhitelistCost(uint256 _newCost ) public onlyOwner {
1297 		whitelistCost = _newCost;
1298 	}
1299 
1300 	// whitelistPaused functions
1301 	function pauseWhitelist(bool _state) public onlyOwner {
1302 		whitelistPaused = _state;
1303 	}
1304 
1305 	// set whitelistRoot
1306 	function setWhitelistRoot( bytes32 _newWhitelistRoot ) 
1307 	public 
1308 	onlyOwner {
1309 		whitelistRoot = _newWhitelistRoot;
1310 	}
1311 
1312 	// free mint functions
1313 	// freePaused functions
1314 	function pauseFree(bool _state) 
1315 	public 
1316 	onlyOwner {
1317 		freePaused = _state;
1318 	}
1319 
1320 	// set freeRoot
1321 	function setFreeRoot( bytes32 _newFreeRoot ) 
1322 	public 
1323 	onlyOwner {
1324 		freeRoot = _newFreeRoot;
1325 	}
1326 
1327 	// internal
1328 	function _baseURI() 
1329 	internal 
1330 	view 
1331 	virtual 
1332 	override 
1333 	returns (string memory) {
1334 		return baseURI;
1335 	}
1336 
1337 	// public
1338 	// minting functions
1339 	function mint(uint256 _mintAmount) 
1340 	public 
1341 	payable {
1342 		require(!paused, "Cannot mint while paused" );
1343 		require(_mintAmount > 0);
1344 		require(totalSupply() + _mintAmount <= maxSupply);
1345 
1346 		if (msg.sender != owner()) {
1347 			require(_mintAmount + _numberMinted( msg.sender ) <= maxMintAmount, "Exceeds max mint amount" );
1348 			require(msg.value >= cost * _mintAmount);
1349 		}
1350 
1351 		_safeMint(msg.sender, _mintAmount);
1352 	}
1353 
1354 	function isWhitelisted( bytes32[] calldata _merkleProof, bytes32 _address ) 
1355 	public 
1356 	view
1357 	returns ( bool )
1358 	{
1359 		return MerkleProof.verify( _merkleProof, whitelistRoot, _address );
1360 	}
1361 
1362 	function mintWhitelist( bytes32[] calldata _merkleProof, uint256 _mintAmount) 
1363 	public 
1364 	payable {
1365 		require(!whitelistPaused, "Cannot mint while whitelist is paused" );
1366 		require(_mintAmount > 0);
1367 		require(totalSupply() + _mintAmount <= maxSupply);
1368 		require( ! whitelistClaimed[ msg.sender ], "Address has already claimed whitelist!" );
1369 
1370 		if (msg.sender != owner()) {
1371 			require(_mintAmount + _numberMinted( msg.sender ) <= maxMintAmount, "Exceeds max mint amount" );
1372 			bytes32 leaf = keccak256( abi.encodePacked( msg.sender ) );
1373 			require( MerkleProof.verify( _merkleProof, whitelistRoot, leaf ), "Invalid proof" );
1374 			require(msg.value >= whitelistCost * _mintAmount);
1375 		}
1376 
1377 		_safeMint(msg.sender, _mintAmount);
1378 	}
1379 
1380 	function isFreelisted( bytes32[] calldata _merkleProof, bytes32 _address ) 
1381 	public 
1382 	view
1383 	returns ( bool )
1384 	{
1385 		return MerkleProof.verify( _merkleProof, freeRoot, _address );
1386 	}
1387 
1388 	function mintFree( bytes32[] calldata _merkleProof, uint256 _mintAmount) 
1389 	public 
1390 	payable {
1391 		require(!freePaused, "Cannot mint while free mint list is paused" );
1392 		require(_mintAmount > 0);
1393 		require(totalSupply() + _mintAmount <= maxSupply);
1394 		require( ! freeClaimed[ msg.sender ], "Address has already claimed freelist!" );
1395 
1396 		if (msg.sender != owner()) {
1397 			require(_mintAmount + _numberMinted( msg.sender ) <= maxMintAmount, "Exceeds max free mint amount" );
1398 			bytes32 leaf = keccak256( abi.encodePacked( msg.sender ) );
1399 			require( MerkleProof.verify( _merkleProof, freeRoot, leaf ), "Invalid proof" );
1400 			require( msg.value >= whitelistCost * ( _mintAmount - maxFreeMintAmount ) );
1401 		}
1402 
1403 		_safeMint(msg.sender, _mintAmount);
1404 	}
1405 
1406 	function tokenURI(uint256 tokenId)
1407 	public
1408 	view
1409 	virtual
1410 	override
1411 	returns (string memory)
1412 	{
1413 		require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1414 
1415 		if(revealed == false) {
1416 			return notRevealedUri;
1417 		}
1418 
1419 		string memory currentBaseURI = _baseURI();
1420 		return bytes(currentBaseURI).length > 0
1421 			? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1422 			: "";
1423 	}
1424 
1425 	//only owner
1426 	function reveal() 
1427 	public 
1428 	onlyOwner {
1429 		revealed = true;
1430 	}
1431 
1432 	function setmaxMintAmount(uint256 _newmaxMintAmount) 
1433 	public 
1434 	onlyOwner {
1435 		maxMintAmount = _newmaxMintAmount;
1436 	}
1437 
1438 	function setMaxSupply(uint256 _newmaxSupply) 
1439 	public 
1440 	onlyOwner {
1441 		maxSupply = _newmaxSupply;
1442 	}
1443 
1444 	function setNotRevealedURI(string memory _notRevealedURI) 
1445 	public 
1446 	onlyOwner {
1447 		notRevealedUri = _notRevealedURI;
1448 	}
1449 
1450 	function setBaseURI(string memory _newBaseURI) 
1451 	public 
1452 	onlyOwner {
1453 		baseURI = _newBaseURI;
1454 	}
1455 
1456 	function setBaseExtension(string memory _newBaseExtension) 
1457 	public 
1458 	onlyOwner {
1459 		baseExtension = _newBaseExtension;
1460 	}
1461 
1462 	function pause(bool _state) 
1463 	public 
1464 	onlyOwner {
1465 		paused = _state;
1466 	}
1467 
1468 	function setWithdrawalAddress( address _newAddress ) 
1469 	public 
1470 	onlyOwner {
1471 		withdrawal_address = _newAddress;
1472 	}
1473 
1474 	function withdraw() 
1475 	public 
1476 	payable 
1477 	onlyOwner {
1478 		//(bool os, ) = payable(owner()).call{value: address(this).balance}("");
1479 		(bool os, ) = payable( withdrawal_address ).call{value: address(this).balance}("");
1480 		require(os);
1481 	}
1482 }