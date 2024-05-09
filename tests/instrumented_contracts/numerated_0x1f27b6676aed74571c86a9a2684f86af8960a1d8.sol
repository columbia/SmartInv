1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
48                 computedHash = _efficientHash(computedHash, proofElement);
49             } else {
50                 // Hash(current element of the proof + current computed hash)
51                 computedHash = _efficientHash(proofElement, computedHash);
52             }
53         }
54         return computedHash;
55     }
56 
57     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
58         assembly {
59             mstore(0x00, a)
60             mstore(0x20, b)
61             value := keccak256(0x00, 0x40)
62         }
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/Strings.sol
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev String operations.
75  */
76 library Strings {
77     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
81      */
82     function toString(uint256 value) internal pure returns (string memory) {
83         // Inspired by OraclizeAPI's implementation - MIT licence
84         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
85 
86         if (value == 0) {
87             return "0";
88         }
89         uint256 temp = value;
90         uint256 digits;
91         while (temp != 0) {
92             digits++;
93             temp /= 10;
94         }
95         bytes memory buffer = new bytes(digits);
96         while (value != 0) {
97             digits -= 1;
98             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
99             value /= 10;
100         }
101         return string(buffer);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
106      */
107     function toHexString(uint256 value) internal pure returns (string memory) {
108         if (value == 0) {
109             return "0x00";
110         }
111         uint256 temp = value;
112         uint256 length = 0;
113         while (temp != 0) {
114             length++;
115             temp >>= 8;
116         }
117         return toHexString(value, length);
118     }
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
122      */
123     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
124         bytes memory buffer = new bytes(2 * length + 2);
125         buffer[0] = "0";
126         buffer[1] = "x";
127         for (uint256 i = 2 * length + 1; i > 1; --i) {
128             buffer[i] = _HEX_SYMBOLS[value & 0xf];
129             value >>= 4;
130         }
131         require(value == 0, "Strings: hex length insufficient");
132         return string(buffer);
133     }
134 }
135 
136 // File: @openzeppelin/contracts/utils/Context.sol
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev Provides information about the current execution context, including the
145  * sender of the transaction and its data. While these are generally available
146  * via msg.sender and msg.data, they should not be accessed in such a direct
147  * manner, since when dealing with meta-transactions the account sending and
148  * paying for execution may not be the actual sender (as far as an application
149  * is concerned).
150  *
151  * This contract is only required for intermediate, library-like contracts.
152  */
153 abstract contract Context {
154     function _msgSender() internal view virtual returns (address) {
155         return msg.sender;
156     }
157 
158     function _msgData() internal view virtual returns (bytes calldata) {
159         return msg.data;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/access/Ownable.sol
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 
171 /**
172  * @dev Contract module which provides a basic access control mechanism, where
173  * there is an account (an owner) that can be granted exclusive access to
174  * specific functions.
175  *
176  * By default, the owner account will be the one that deploys the contract. This
177  * can later be changed with {transferOwnership}.
178  *
179  * This module is used through inheritance. It will make available the modifier
180  * `onlyOwner`, which can be applied to your functions to restrict their use to
181  * the owner.
182  */
183 abstract contract Ownable is Context {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     /**
189      * @dev Initializes the contract setting the deployer as the initial owner.
190      */
191     constructor() {
192         _transferOwnership(_msgSender());
193     }
194 
195     /**
196      * @dev Returns the address of the current owner.
197      */
198     function owner() public view virtual returns (address) {
199         return _owner;
200     }
201 
202     /**
203      * @dev Throws if called by any account other than the owner.
204      */
205     modifier onlyOwner() {
206         require(owner() == _msgSender(), "Ownable: caller is not the owner");
207         _;
208     }
209 
210     /**
211      * @dev Leaves the contract without owner. It will not be possible to call
212      * `onlyOwner` functions anymore. Can only be called by the current owner.
213      *
214      * NOTE: Renouncing ownership will leave the contract without an owner,
215      * thereby removing any functionality that is only available to the owner.
216      */
217     function renounceOwnership() public virtual onlyOwner {
218         _transferOwnership(address(0));
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
223      * Can only be called by the current owner.
224      */
225     function transferOwnership(address newOwner) public virtual onlyOwner {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         _transferOwnership(newOwner);
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Internal function without access restriction.
233      */
234     function _transferOwnership(address newOwner) internal virtual {
235         address oldOwner = _owner;
236         _owner = newOwner;
237         emit OwnershipTransferred(oldOwner, newOwner);
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 
244 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
245 
246 pragma solidity ^0.8.1;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      *
269      * [IMPORTANT]
270      * ====
271      * You shouldn't rely on `isContract` to protect against flash loan attacks!
272      *
273      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
274      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
275      * constructor.
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies on extcodesize/address.code.length, which returns 0
280         // for contracts in construction, since the code is only stored at the end
281         // of the constructor execution.
282 
283         return account.code.length > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         (bool success, ) = recipient.call{value: amount}("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain `call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         require(isContract(target), "Address: call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.call{value: value}(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
390         return functionStaticCall(target, data, "Address: low-level static call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal view returns (bytes memory) {
404         require(isContract(target), "Address: static call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.staticcall(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         require(isContract(target), "Address: delegate call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.delegatecall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
439      * revert reason using the provided one.
440      *
441      * _Available since v4.3._
442      */
443     function verifyCallResult(
444         bool success,
445         bytes memory returndata,
446         string memory errorMessage
447     ) internal pure returns (bytes memory) {
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454 
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @title ERC721 token receiver interface
475  * @dev Interface for any contract that wants to support safeTransfers
476  * from ERC721 asset contracts.
477  */
478 interface IERC721Receiver {
479     /**
480      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
481      * by `operator` from `from`, this function is called.
482      *
483      * It must return its Solidity selector to confirm the token transfer.
484      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
485      *
486      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
487      */
488     function onERC721Received(
489         address operator,
490         address from,
491         uint256 tokenId,
492         bytes calldata data
493     ) external returns (bytes4);
494 }
495 
496 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
497 
498 
499 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Interface of the ERC165 standard, as defined in the
505  * https://eips.ethereum.org/EIPS/eip-165[EIP].
506  *
507  * Implementers can declare support of contract interfaces, which can then be
508  * queried by others ({ERC165Checker}).
509  *
510  * For an implementation, see {ERC165}.
511  */
512 interface IERC165 {
513     /**
514      * @dev Returns true if this contract implements the interface defined by
515      * `interfaceId`. See the corresponding
516      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
517      * to learn more about how these ids are created.
518      *
519      * This function call must use less than 30 000 gas.
520      */
521     function supportsInterface(bytes4 interfaceId) external view returns (bool);
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 
532 /**
533  * @dev Implementation of the {IERC165} interface.
534  *
535  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
536  * for the additional interface id that will be supported. For example:
537  *
538  * ```solidity
539  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
541  * }
542  * ```
543  *
544  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
545  */
546 abstract contract ERC165 is IERC165 {
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         return interfaceId == type(IERC165).interfaceId;
552     }
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @dev Required interface of an ERC721 compliant contract.
565  */
566 interface IERC721 is IERC165 {
567     /**
568      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
569      */
570     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
571 
572     /**
573      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
574      */
575     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
576 
577     /**
578      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
579      */
580     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
581 
582     /**
583      * @dev Returns the number of tokens in ``owner``'s account.
584      */
585     function balanceOf(address owner) external view returns (uint256 balance);
586 
587     /**
588      * @dev Returns the owner of the `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function ownerOf(uint256 tokenId) external view returns (address owner);
595 
596     /**
597      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
598      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Transfers `tokenId` token from `from` to `to`.
618      *
619      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must be owned by `from`.
626      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
627      *
628      * Emits a {Transfer} event.
629      */
630     function transferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external;
635 
636     /**
637      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
638      * The approval is cleared when the token is transferred.
639      *
640      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
641      *
642      * Requirements:
643      *
644      * - The caller must own the token or be an approved operator.
645      * - `tokenId` must exist.
646      *
647      * Emits an {Approval} event.
648      */
649     function approve(address to, uint256 tokenId) external;
650 
651     /**
652      * @dev Returns the account approved for `tokenId` token.
653      *
654      * Requirements:
655      *
656      * - `tokenId` must exist.
657      */
658     function getApproved(uint256 tokenId) external view returns (address operator);
659 
660     /**
661      * @dev Approve or remove `operator` as an operator for the caller.
662      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
663      *
664      * Requirements:
665      *
666      * - The `operator` cannot be the caller.
667      *
668      * Emits an {ApprovalForAll} event.
669      */
670     function setApprovalForAll(address operator, bool _approved) external;
671 
672     /**
673      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
674      *
675      * See {setApprovalForAll}
676      */
677     function isApprovedForAll(address owner, address operator) external view returns (bool);
678 
679     /**
680      * @dev Safely transfers `tokenId` token from `from` to `to`.
681      *
682      * Requirements:
683      *
684      * - `from` cannot be the zero address.
685      * - `to` cannot be the zero address.
686      * - `tokenId` token must exist and be owned by `from`.
687      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
688      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
689      *
690      * Emits a {Transfer} event.
691      */
692     function safeTransferFrom(
693         address from,
694         address to,
695         uint256 tokenId,
696         bytes calldata data
697     ) external;
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
710  * @dev See https://eips.ethereum.org/EIPS/eip-721
711  */
712 interface IERC721Metadata is IERC721 {
713     /**
714      * @dev Returns the token collection name.
715      */
716     function name() external view returns (string memory);
717 
718     /**
719      * @dev Returns the token collection symbol.
720      */
721     function symbol() external view returns (string memory);
722 
723     /**
724      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
725      */
726     function tokenURI(uint256 tokenId) external view returns (string memory);
727 }
728 
729 // File: erc721a/contracts/ERC721A.sol
730 
731 
732 // Creator: Chiru Labs
733 
734 pragma solidity ^0.8.4;
735 
736 
737 
738 
739 
740 
741 
742 
743 error ApprovalCallerNotOwnerNorApproved();
744 error ApprovalQueryForNonexistentToken();
745 error ApproveToCaller();
746 error ApprovalToCurrentOwner();
747 error BalanceQueryForZeroAddress();
748 error MintToZeroAddress();
749 error MintZeroQuantity();
750 error OwnerQueryForNonexistentToken();
751 error TransferCallerNotOwnerNorApproved();
752 error TransferFromIncorrectOwner();
753 error TransferToNonERC721ReceiverImplementer();
754 error TransferToZeroAddress();
755 error URIQueryForNonexistentToken();
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata extension. Built to optimize for lower gas during batch mints.
760  *
761  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
762  *
763  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
764  *
765  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
766  */
767 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
768     using Address for address;
769     using Strings for uint256;
770 
771     // Compiler will pack this into a single 256bit word.
772     struct TokenOwnership {
773         // The address of the owner.
774         address addr;
775         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
776         uint64 startTimestamp;
777         // Whether the token has been burned.
778         bool burned;
779     }
780 
781     // Compiler will pack this into a single 256bit word.
782     struct AddressData {
783         // Realistically, 2**64-1 is more than enough.
784         uint64 balance;
785         // Keeps track of mint count with minimal overhead for tokenomics.
786         uint64 numberMinted;
787         // Keeps track of burn count with minimal overhead for tokenomics.
788         uint64 numberBurned;
789         // For miscellaneous variable(s) pertaining to the address
790         // (e.g. number of whitelist mint slots used).
791         // If there are multiple variables, please pack them into a uint64.
792         uint64 aux;
793     }
794 
795     // The tokenId of the next token to be minted.
796     uint256 internal _currentIndex;
797 
798     // The number of tokens burned.
799     uint256 internal _burnCounter;
800 
801     // Token name
802     string private _name;
803 
804     // Token symbol
805     string private _symbol;
806 
807     // Mapping from token ID to ownership details
808     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
809     mapping(uint256 => TokenOwnership) internal _ownerships;
810 
811     // Mapping owner address to address data
812     mapping(address => AddressData) private _addressData;
813 
814     // Mapping from token ID to approved address
815     mapping(uint256 => address) private _tokenApprovals;
816 
817     // Mapping from owner to operator approvals
818     mapping(address => mapping(address => bool)) private _operatorApprovals;
819 
820     constructor(string memory name_, string memory symbol_) {
821         _name = name_;
822         _symbol = symbol_;
823         _currentIndex = _startTokenId();
824     }
825 
826     /**
827      * To change the starting tokenId, please override this function.
828      */
829     function _startTokenId() internal view virtual returns (uint256) {
830         return 0;
831     }
832 
833     /**
834      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
835      */
836     function totalSupply() public view returns (uint256) {
837         // Counter underflow is impossible as _burnCounter cannot be incremented
838         // more than _currentIndex - _startTokenId() times
839         unchecked {
840             return _currentIndex - _burnCounter - _startTokenId();
841         }
842     }
843 
844     /**
845      * Returns the total amount of tokens minted in the contract.
846      */
847     function _totalMinted() internal view returns (uint256) {
848         // Counter underflow is impossible as _currentIndex does not decrement,
849         // and it is initialized to _startTokenId()
850         unchecked {
851             return _currentIndex - _startTokenId();
852         }
853     }
854 
855     /**
856      * @dev See {IERC165-supportsInterface}.
857      */
858     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
859         return
860             interfaceId == type(IERC721).interfaceId ||
861             interfaceId == type(IERC721Metadata).interfaceId ||
862             super.supportsInterface(interfaceId);
863     }
864 
865     /**
866      * @dev See {IERC721-balanceOf}.
867      */
868     function balanceOf(address owner) public view override returns (uint256) {
869         if (owner == address(0)) revert BalanceQueryForZeroAddress();
870         return uint256(_addressData[owner].balance);
871     }
872 
873     /**
874      * Returns the number of tokens minted by `owner`.
875      */
876     function _numberMinted(address owner) internal view returns (uint256) {
877         return uint256(_addressData[owner].numberMinted);
878     }
879 
880     /**
881      * Returns the number of tokens burned by or on behalf of `owner`.
882      */
883     function _numberBurned(address owner) internal view returns (uint256) {
884         return uint256(_addressData[owner].numberBurned);
885     }
886 
887     /**
888      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
889      */
890     function _getAux(address owner) internal view returns (uint64) {
891         return _addressData[owner].aux;
892     }
893 
894     /**
895      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
896      * If there are multiple variables, please pack them into a uint64.
897      */
898     function _setAux(address owner, uint64 aux) internal {
899         _addressData[owner].aux = aux;
900     }
901 
902     /**
903      * Gas spent here starts off proportional to the maximum mint batch size.
904      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
905      */
906     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
907         uint256 curr = tokenId;
908 
909         unchecked {
910             if (_startTokenId() <= curr && curr < _currentIndex) {
911                 TokenOwnership memory ownership = _ownerships[curr];
912                 if (!ownership.burned) {
913                     if (ownership.addr != address(0)) {
914                         return ownership;
915                     }
916                     // Invariant:
917                     // There will always be an ownership that has an address and is not burned
918                     // before an ownership that does not have an address and is not burned.
919                     // Hence, curr will not underflow.
920                     while (true) {
921                         curr--;
922                         ownership = _ownerships[curr];
923                         if (ownership.addr != address(0)) {
924                             return ownership;
925                         }
926                     }
927                 }
928             }
929         }
930         revert OwnerQueryForNonexistentToken();
931     }
932 
933     /**
934      * @dev See {IERC721-ownerOf}.
935      */
936     function ownerOf(uint256 tokenId) public view override returns (address) {
937         return _ownershipOf(tokenId).addr;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-name}.
942      */
943     function name() public view virtual override returns (string memory) {
944         return _name;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-symbol}.
949      */
950     function symbol() public view virtual override returns (string memory) {
951         return _symbol;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-tokenURI}.
956      */
957     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
958         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
959 
960         string memory baseURI = _baseURI();
961         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
962     }
963 
964     /**
965      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
966      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
967      * by default, can be overriden in child contracts.
968      */
969     function _baseURI() internal view virtual returns (string memory) {
970         return '';
971     }
972 
973     /**
974      * @dev See {IERC721-approve}.
975      */
976     function approve(address to, uint256 tokenId) public override {
977         address owner = ERC721A.ownerOf(tokenId);
978         if (to == owner) revert ApprovalToCurrentOwner();
979 
980         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
981             revert ApprovalCallerNotOwnerNorApproved();
982         }
983 
984         _approve(to, tokenId, owner);
985     }
986 
987     /**
988      * @dev See {IERC721-getApproved}.
989      */
990     function getApproved(uint256 tokenId) public view override returns (address) {
991         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
992 
993         return _tokenApprovals[tokenId];
994     }
995 
996     /**
997      * @dev See {IERC721-setApprovalForAll}.
998      */
999     function setApprovalForAll(address operator, bool approved) public virtual override {
1000         if (operator == _msgSender()) revert ApproveToCaller();
1001 
1002         _operatorApprovals[_msgSender()][operator] = approved;
1003         emit ApprovalForAll(_msgSender(), operator, approved);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-isApprovedForAll}.
1008      */
1009     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1010         return _operatorApprovals[owner][operator];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-transferFrom}.
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         safeTransferFrom(from, to, tokenId, '');
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1046             revert TransferToNonERC721ReceiverImplementer();
1047         }
1048     }
1049 
1050     /**
1051      * @dev Returns whether `tokenId` exists.
1052      *
1053      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1054      *
1055      * Tokens start existing when they are minted (`_mint`),
1056      */
1057     function _exists(uint256 tokenId) internal view returns (bool) {
1058         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1059             !_ownerships[tokenId].burned;
1060     }
1061 
1062     function _safeMint(address to, uint256 quantity) internal {
1063         _safeMint(to, quantity, '');
1064     }
1065 
1066     /**
1067      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _safeMint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data
1080     ) internal {
1081         _mint(to, quantity, _data, true);
1082     }
1083 
1084     /**
1085      * @dev Mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - `to` cannot be the zero address.
1090      * - `quantity` must be greater than 0.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _mint(
1095         address to,
1096         uint256 quantity,
1097         bytes memory _data,
1098         bool safe
1099     ) internal {
1100         uint256 startTokenId = _currentIndex;
1101         if (to == address(0)) revert MintToZeroAddress();
1102         if (quantity == 0) revert MintZeroQuantity();
1103 
1104         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1105 
1106         // Overflows are incredibly unrealistic.
1107         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1108         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1109         unchecked {
1110             _addressData[to].balance += uint64(quantity);
1111             _addressData[to].numberMinted += uint64(quantity);
1112 
1113             _ownerships[startTokenId].addr = to;
1114             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1115 
1116             uint256 updatedIndex = startTokenId;
1117             uint256 end = updatedIndex + quantity;
1118 
1119             if (safe && to.isContract()) {
1120                 do {
1121                     emit Transfer(address(0), to, updatedIndex);
1122                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1123                         revert TransferToNonERC721ReceiverImplementer();
1124                     }
1125                 } while (updatedIndex != end);
1126                 // Reentrancy protection
1127                 if (_currentIndex != startTokenId) revert();
1128             } else {
1129                 do {
1130                     emit Transfer(address(0), to, updatedIndex++);
1131                 } while (updatedIndex != end);
1132             }
1133             _currentIndex = updatedIndex;
1134         }
1135         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1136     }
1137 
1138     /**
1139      * @dev Transfers `tokenId` from `from` to `to`.
1140      *
1141      * Requirements:
1142      *
1143      * - `to` cannot be the zero address.
1144      * - `tokenId` token must be owned by `from`.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _transfer(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) private {
1153         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1154 
1155         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1156 
1157         bool isApprovedOrOwner = (_msgSender() == from ||
1158             isApprovedForAll(from, _msgSender()) ||
1159             getApproved(tokenId) == _msgSender());
1160 
1161         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1162         if (to == address(0)) revert TransferToZeroAddress();
1163 
1164         _beforeTokenTransfers(from, to, tokenId, 1);
1165 
1166         // Clear approvals from the previous owner
1167         _approve(address(0), tokenId, from);
1168 
1169         // Underflow of the sender's balance is impossible because we check for
1170         // ownership above and the recipient's balance can't realistically overflow.
1171         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1172         unchecked {
1173             _addressData[from].balance -= 1;
1174             _addressData[to].balance += 1;
1175 
1176             TokenOwnership storage currSlot = _ownerships[tokenId];
1177             currSlot.addr = to;
1178             currSlot.startTimestamp = uint64(block.timestamp);
1179 
1180             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1181             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1182             uint256 nextTokenId = tokenId + 1;
1183             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1184             if (nextSlot.addr == address(0)) {
1185                 // This will suffice for checking _exists(nextTokenId),
1186                 // as a burned slot cannot contain the zero address.
1187                 if (nextTokenId != _currentIndex) {
1188                     nextSlot.addr = from;
1189                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1190                 }
1191             }
1192         }
1193 
1194         emit Transfer(from, to, tokenId);
1195         _afterTokenTransfers(from, to, tokenId, 1);
1196     }
1197 
1198     /**
1199      * @dev This is equivalent to _burn(tokenId, false)
1200      */
1201     function _burn(uint256 tokenId) internal virtual {
1202         _burn(tokenId, false);
1203     }
1204 
1205     /**
1206      * @dev Destroys `tokenId`.
1207      * The approval is cleared when the token is burned.
1208      *
1209      * Requirements:
1210      *
1211      * - `tokenId` must exist.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1216         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1217 
1218         address from = prevOwnership.addr;
1219 
1220         if (approvalCheck) {
1221             bool isApprovedOrOwner = (_msgSender() == from ||
1222                 isApprovedForAll(from, _msgSender()) ||
1223                 getApproved(tokenId) == _msgSender());
1224 
1225             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1226         }
1227 
1228         _beforeTokenTransfers(from, address(0), tokenId, 1);
1229 
1230         // Clear approvals from the previous owner
1231         _approve(address(0), tokenId, from);
1232 
1233         // Underflow of the sender's balance is impossible because we check for
1234         // ownership above and the recipient's balance can't realistically overflow.
1235         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1236         unchecked {
1237             AddressData storage addressData = _addressData[from];
1238             addressData.balance -= 1;
1239             addressData.numberBurned += 1;
1240 
1241             // Keep track of who burned the token, and the timestamp of burning.
1242             TokenOwnership storage currSlot = _ownerships[tokenId];
1243             currSlot.addr = from;
1244             currSlot.startTimestamp = uint64(block.timestamp);
1245             currSlot.burned = true;
1246 
1247             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1248             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1249             uint256 nextTokenId = tokenId + 1;
1250             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1251             if (nextSlot.addr == address(0)) {
1252                 // This will suffice for checking _exists(nextTokenId),
1253                 // as a burned slot cannot contain the zero address.
1254                 if (nextTokenId != _currentIndex) {
1255                     nextSlot.addr = from;
1256                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(from, address(0), tokenId);
1262         _afterTokenTransfers(from, address(0), tokenId, 1);
1263 
1264         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1265         unchecked {
1266             _burnCounter++;
1267         }
1268     }
1269 
1270     /**
1271      * @dev Approve `to` to operate on `tokenId`
1272      *
1273      * Emits a {Approval} event.
1274      */
1275     function _approve(
1276         address to,
1277         uint256 tokenId,
1278         address owner
1279     ) private {
1280         _tokenApprovals[tokenId] = to;
1281         emit Approval(owner, to, tokenId);
1282     }
1283 
1284     /**
1285      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1286      *
1287      * @param from address representing the previous owner of the given token ID
1288      * @param to target address that will receive the tokens
1289      * @param tokenId uint256 ID of the token to be transferred
1290      * @param _data bytes optional data to send along with the call
1291      * @return bool whether the call correctly returned the expected magic value
1292      */
1293     function _checkContractOnERC721Received(
1294         address from,
1295         address to,
1296         uint256 tokenId,
1297         bytes memory _data
1298     ) private returns (bool) {
1299         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1300             return retval == IERC721Receiver(to).onERC721Received.selector;
1301         } catch (bytes memory reason) {
1302             if (reason.length == 0) {
1303                 revert TransferToNonERC721ReceiverImplementer();
1304             } else {
1305                 assembly {
1306                     revert(add(32, reason), mload(reason))
1307                 }
1308             }
1309         }
1310     }
1311 
1312     /**
1313      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1314      * And also called before burning one token.
1315      *
1316      * startTokenId - the first token id to be transferred
1317      * quantity - the amount to be transferred
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, `tokenId` will be burned by `from`.
1325      * - `from` and `to` are never both zero.
1326      */
1327     function _beforeTokenTransfers(
1328         address from,
1329         address to,
1330         uint256 startTokenId,
1331         uint256 quantity
1332     ) internal virtual {}
1333 
1334     /**
1335      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1336      * minting.
1337      * And also called after one token has been burned.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` has been minted for `to`.
1347      * - When `to` is zero, `tokenId` has been burned by `from`.
1348      * - `from` and `to` are never both zero.
1349      */
1350     function _afterTokenTransfers(
1351         address from,
1352         address to,
1353         uint256 startTokenId,
1354         uint256 quantity
1355     ) internal virtual {}
1356 }
1357 
1358 // File: contracts/TAS.sol
1359 
1360 
1361 
1362 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
1363 
1364 pragma solidity >=0.7.0 <0.9.0;
1365 
1366 
1367 
1368 
1369 
1370 contract TimepieceApeSociety is ERC721A, Ownable {
1371   using Strings for uint256;
1372 
1373   string public baseURI;
1374   string public baseExtension = ".json";
1375   string public notRevealedUri;
1376   uint256 public cost = 0.25 ether;
1377   uint256 public wlcost = 0.2 ether;
1378   uint256 public maxSupply = 3333;
1379   uint256 public MaxperWallet = 100;
1380   uint256 public MaxperWalletWl = 2;
1381   uint256 public MaxperTxWl = 2;
1382   uint256 public maxpertx = 50 ; // max mint per tx
1383   bool public paused = true;
1384   bool public revealed = false;
1385   bool public preSale = false;
1386   bool public publicSale = false;
1387   bytes32 public merkleRoot = 0x7d47dd9d8fd212164c3a9e8d23f89077455d468a3e287590d7f66b9c5ed8dcfd;
1388 
1389   constructor(
1390     string memory _initBaseURI,
1391     string memory _initNotRevealedUri
1392   ) ERC721A("Timepiece Ape Society", "TAS") {
1393     setBaseURI(_initBaseURI);
1394     setNotRevealedURI(_initNotRevealedUri);
1395   }
1396 
1397   // internal
1398   function _baseURI() internal view virtual override returns (string memory) {
1399     return baseURI;
1400   }
1401       function _startTokenId() internal view virtual override returns (uint256) {
1402         return 1;
1403     }
1404 
1405   // public
1406   function mint(uint256 tokens) public payable {
1407     require(!paused, "TAS: oops contract is paused");
1408     require(publicSale, "TAS: Sale Hasn't started yet");
1409     uint256 supply = totalSupply();
1410     uint256 ownerTokenCount = balanceOf(_msgSender());
1411     require(tokens > 0, "TAS: need to mint at least 1 NFT");
1412     require(tokens <= maxpertx, "TAS: max mint amount per tx exceeded");
1413     require(supply + tokens <= maxSupply, "TAS: We Soldout");
1414     require(ownerTokenCount + tokens <= MaxperWallet, "TAS: Max NFT Per Wallet exceeded");
1415     require(msg.value >= cost * tokens, "TAS: insufficient funds");
1416 
1417       _safeMint(_msgSender(), tokens);
1418     
1419   }
1420 /// @dev presale mint for whitelisted
1421     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable  {
1422     require(!paused, "TAS: oops contract is paused");
1423     require(preSale, "TAS: Presale Hasn't started yet");
1424     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "TAS: You are not Whitelisted");
1425     uint256 supply = totalSupply();
1426     uint256 ownerTokenCount = balanceOf(_msgSender());
1427     require(ownerTokenCount + tokens <= MaxperWalletWl, "TAS: Max NFT Per Wallet exceeded");
1428     require(tokens > 0, "TAS: need to mint at least 1 NFT");
1429     require(tokens <= MaxperTxWl, "TAS: max mint per Tx exceeded");
1430     require(supply + tokens <= maxSupply, "TAS: Whitelist MaxSupply exceeded");
1431     require(msg.value >= wlcost * tokens, "TAS: insufficient funds");
1432 
1433       _safeMint(_msgSender(), tokens);
1434     
1435   }
1436 
1437 
1438 
1439 
1440   /// @dev use it for giveaway and mint for yourself
1441      function gift(uint256 _mintAmount, address destination) public onlyOwner {
1442     require(_mintAmount > 0, "need to mint at least 1 NFT");
1443     uint256 supply = totalSupply();
1444     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1445 
1446       _safeMint(destination, _mintAmount);
1447     
1448   }
1449 
1450   
1451 
1452 
1453   function tokenURI(uint256 tokenId)
1454     public
1455     view
1456     virtual
1457     override
1458     returns (string memory)
1459   {
1460     require(
1461       _exists(tokenId),
1462       "ERC721AMetadata: URI query for nonexistent token"
1463     );
1464     
1465     if(revealed == false) {
1466         return notRevealedUri;
1467     }
1468 
1469     string memory currentBaseURI = _baseURI();
1470     return bytes(currentBaseURI).length > 0
1471         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1472         : "";
1473   }
1474 
1475   //only owner
1476   function reveal(bool _state) public onlyOwner {
1477       revealed = _state;
1478   }
1479 
1480   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1481         merkleRoot = _merkleRoot;
1482     }
1483   
1484   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1485     MaxperWallet = _limit;
1486   }
1487 
1488     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
1489     MaxperWalletWl = _limit;
1490   }
1491 
1492   function setmaxpertx(uint256 _maxpertx) public onlyOwner {
1493     maxpertx = _maxpertx;
1494   }
1495 
1496     function setWLMaxpertx(uint256 _wlmaxpertx) public onlyOwner {
1497     MaxperTxWl = _wlmaxpertx;
1498   }
1499   
1500   function setCost(uint256 _newCost) public onlyOwner {
1501     cost = _newCost;
1502   }
1503 
1504     function setWlCost(uint256 _newWlCost) public onlyOwner {
1505     wlcost = _newWlCost;
1506   }
1507 
1508     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1509     maxSupply = _newsupply;
1510   }
1511 
1512   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1513     baseURI = _newBaseURI;
1514   }
1515 
1516   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1517     baseExtension = _newBaseExtension;
1518   }
1519   
1520   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1521     notRevealedUri = _notRevealedURI;
1522   }
1523 
1524   function pause(bool _state) public onlyOwner {
1525     paused = _state;
1526   }
1527 
1528     function togglepreSale(bool _state) external onlyOwner {
1529         preSale = _state;
1530     }
1531 
1532     function togglepublicSale(bool _state) external onlyOwner {
1533         publicSale = _state;
1534     }
1535   
1536  
1537   function withdraw() public payable onlyOwner {
1538     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1539     require(success);
1540   }
1541 }