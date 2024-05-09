1 // SPDX-License-Identifier: MIT
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      */
204     function isContract(address account) internal view returns (bool) {
205         // This method relies on extcodesize, which returns 0 for contracts in
206         // construction, since the code is only stored at the end of the
207         // constructor execution.
208 
209         uint256 size;
210         assembly {
211             size := extcodesize(account)
212         }
213         return size > 0;
214     }
215 
216     /**
217      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
218      * `recipient`, forwarding all available gas and reverting on errors.
219      *
220      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
221      * of certain opcodes, possibly making contracts go over the 2300 gas limit
222      * imposed by `transfer`, making them unable to receive funds via
223      * `transfer`. {sendValue} removes this limitation.
224      *
225      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
226      *
227      * IMPORTANT: because control is transferred to `recipient`, care must be
228      * taken to not create reentrancy vulnerabilities. Consider using
229      * {ReentrancyGuard} or the
230      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
231      */
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(address(this).balance >= amount, "Address: insufficient balance");
234 
235         (bool success, ) = recipient.call{value: amount}("");
236         require(success, "Address: unable to send value, recipient may have reverted");
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain `call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
263      * `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, 0, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but also transferring `value` wei to `target`.
278      *
279      * Requirements:
280      *
281      * - the calling contract must have an ETH balance of at least `value`.
282      * - the called Solidity function must be `payable`.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(
287         address target,
288         bytes memory data,
289         uint256 value
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
296      * with `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         require(address(this).balance >= value, "Address: insufficient balance for call");
307         require(isContract(target), "Address: call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.call{value: value}(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
320         return functionStaticCall(target, data, "Address: low-level static call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal view returns (bytes memory) {
334         require(isContract(target), "Address: static call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.staticcall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(isContract(target), "Address: delegate call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.delegatecall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
369      * revert reason using the provided one.
370      *
371      * _Available since v4.3._
372      */
373     function verifyCallResult(
374         bool success,
375         bytes memory returndata,
376         string memory errorMessage
377     ) internal pure returns (bytes memory) {
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @title ERC721 token receiver interface
405  * @dev Interface for any contract that wants to support safeTransfers
406  * from ERC721 asset contracts.
407  */
408 interface IERC721Receiver {
409     /**
410      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
411      * by `operator` from `from`, this function is called.
412      *
413      * It must return its Solidity selector to confirm the token transfer.
414      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
415      *
416      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
417      */
418     function onERC721Received(
419         address operator,
420         address from,
421         uint256 tokenId,
422         bytes calldata data
423     ) external returns (bytes4);
424 }
425 
426 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @dev Interface of the ERC165 standard, as defined in the
435  * https://eips.ethereum.org/EIPS/eip-165[EIP].
436  *
437  * Implementers can declare support of contract interfaces, which can then be
438  * queried by others ({ERC165Checker}).
439  *
440  * For an implementation, see {ERC165}.
441  */
442 interface IERC165 {
443     /**
444      * @dev Returns true if this contract implements the interface defined by
445      * `interfaceId`. See the corresponding
446      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
447      * to learn more about how these ids are created.
448      *
449      * This function call must use less than 30 000 gas.
450      */
451     function supportsInterface(bytes4 interfaceId) external view returns (bool);
452 }
453 
454 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 /**
463  * @dev Implementation of the {IERC165} interface.
464  *
465  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
466  * for the additional interface id that will be supported. For example:
467  *
468  * ```solidity
469  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
470  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
471  * }
472  * ```
473  *
474  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
475  */
476 abstract contract ERC165 is IERC165 {
477     /**
478      * @dev See {IERC165-supportsInterface}.
479      */
480     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481         return interfaceId == type(IERC165).interfaceId;
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 
493 /**
494  * @dev Required interface of an ERC721 compliant contract.
495  */
496 interface IERC721 is IERC165 {
497     /**
498      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
499      */
500     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
501 
502     /**
503      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
504      */
505     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
509      */
510     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
511 
512     /**
513      * @dev Returns the number of tokens in ``owner``'s account.
514      */
515     function balanceOf(address owner) external view returns (uint256 balance);
516 
517     /**
518      * @dev Returns the owner of the `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function ownerOf(uint256 tokenId) external view returns (address owner);
525 
526     /**
527      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
528      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must exist and be owned by `from`.
535      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
536      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
537      *
538      * Emits a {Transfer} event.
539      */
540     function safeTransferFrom(
541         address from,
542         address to,
543         uint256 tokenId
544     ) external;
545 
546     /**
547      * @dev Transfers `tokenId` token from `from` to `to`.
548      *
549      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must be owned by `from`.
556      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
557      *
558      * Emits a {Transfer} event.
559      */
560     function transferFrom(
561         address from,
562         address to,
563         uint256 tokenId
564     ) external;
565 
566     /**
567      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
568      * The approval is cleared when the token is transferred.
569      *
570      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
571      *
572      * Requirements:
573      *
574      * - The caller must own the token or be an approved operator.
575      * - `tokenId` must exist.
576      *
577      * Emits an {Approval} event.
578      */
579     function approve(address to, uint256 tokenId) external;
580 
581     /**
582      * @dev Returns the account approved for `tokenId` token.
583      *
584      * Requirements:
585      *
586      * - `tokenId` must exist.
587      */
588     function getApproved(uint256 tokenId) external view returns (address operator);
589 
590     /**
591      * @dev Approve or remove `operator` as an operator for the caller.
592      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
593      *
594      * Requirements:
595      *
596      * - The `operator` cannot be the caller.
597      *
598      * Emits an {ApprovalForAll} event.
599      */
600     function setApprovalForAll(address operator, bool _approved) external;
601 
602     /**
603      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
604      *
605      * See {setApprovalForAll}
606      */
607     function isApprovedForAll(address owner, address operator) external view returns (bool);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must exist and be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
619      *
620      * Emits a {Transfer} event.
621      */
622     function safeTransferFrom(
623         address from,
624         address to,
625         uint256 tokenId,
626         bytes calldata data
627     ) external;
628 }
629 
630 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
640  * @dev See https://eips.ethereum.org/EIPS/eip-721
641  */
642 interface IERC721Enumerable is IERC721 {
643     /**
644      * @dev Returns the total amount of tokens stored by the contract.
645      */
646     function totalSupply() external view returns (uint256);
647 
648     /**
649      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
650      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
651      */
652     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
653 
654     /**
655      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
656      * Use along with {totalSupply} to enumerate all tokens.
657      */
658     function tokenByIndex(uint256 index) external view returns (uint256);
659 }
660 
661 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 
669 /**
670  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
671  * @dev See https://eips.ethereum.org/EIPS/eip-721
672  */
673 interface IERC721Metadata is IERC721 {
674     /**
675      * @dev Returns the token collection name.
676      */
677     function name() external view returns (string memory);
678 
679     /**
680      * @dev Returns the token collection symbol.
681      */
682     function symbol() external view returns (string memory);
683 
684     /**
685      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
686      */
687     function tokenURI(uint256 tokenId) external view returns (string memory);
688 }
689 
690 // File: contracts/LowerGas.sol
691 
692 
693 // Creator: Chiru Labs
694 
695 
696 pragma solidity ^0.8.0;
697 
698 /**
699  * @dev These functions deal with verification of Merkle Trees proofs.
700  *
701  * The proofs can be generated using the JavaScript library
702  * https://github.com/miguelmota/merkletreejs[merkletreejs].
703  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
704  *
705  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
706  */
707 library MerkleProof {
708     /**
709      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
710      * defined by `root`. For this, a `proof` must be provided, containing
711      * sibling hashes on the branch from the leaf to the root of the tree. Each
712      * pair of leaves and each pair of pre-images are assumed to be sorted.
713      */
714     function verify(
715         bytes32[] memory proof,
716         bytes32 root,
717         bytes32 leaf
718     ) internal pure returns (bool) {
719         return processProof(proof, leaf) == root;
720     }
721 
722     /**
723      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
724      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
725      * hash matches the root of the tree. When processing the proof, the pairs
726      * of leafs & pre-images are assumed to be sorted.
727      *
728      * _Available since v4.4._
729      */
730     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
731         bytes32 computedHash = leaf;
732         for (uint256 i = 0; i < proof.length; i++) {
733             bytes32 proofElement = proof[i];
734             if (computedHash <= proofElement) {
735                 // Hash(current computed hash + current element of the proof)
736                 computedHash = _efficientHash(computedHash, proofElement);
737             } else {
738                 // Hash(current element of the proof + current computed hash)
739                 computedHash = _efficientHash(proofElement, computedHash);
740             }
741         }
742         return computedHash;
743     }
744 
745     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
746         assembly {
747             mstore(0x00, a)
748             mstore(0x20, b)
749             value := keccak256(0x00, 0x40)
750         }
751     }
752 }
753 
754 pragma solidity ^0.8.0;
755 
756 
757 
758 
759 
760 
761 
762 
763 
764 
765 /**
766  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
767  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
768  *
769  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
770  *
771  * Does not support burning tokens to address(0).
772  *
773  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
774  */
775 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
776     using Address for address;
777     using Strings for uint256;
778 
779     struct TokenOwnership {
780         address addr;
781         uint64 startTimestamp;
782     }
783 
784     struct AddressData {
785         uint128 balance;
786         uint128 numberMinted;
787     }
788 
789     uint256 internal currentIndex = 0;
790 
791     uint256 internal immutable maxBatchSize;
792 
793     // Token name
794     string private _name;
795 
796     // Token symbol
797     string private _symbol;
798 
799     // Mapping from token ID to ownership details
800     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
801     mapping(uint256 => TokenOwnership) internal _ownerships;
802 
803     // Mapping owner address to address data
804     mapping(address => AddressData) private _addressData;
805 
806     // Mapping from token ID to approved address
807     mapping(uint256 => address) private _tokenApprovals;
808 
809     // Mapping from owner to operator approvals
810     mapping(address => mapping(address => bool)) private _operatorApprovals;
811 
812     /**
813      * @dev
814      * `maxBatchSize` refers to how much a minter can mint at a time.
815      */
816     constructor(
817         string memory name_,
818         string memory symbol_,
819         uint256 maxBatchSize_
820     ) {
821         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
822         _name = name_;
823         _symbol = symbol_;
824         maxBatchSize = maxBatchSize_;
825     }
826 
827     /**
828      * @dev See {IERC721Enumerable-totalSupply}.
829      */
830     function totalSupply() public view override returns (uint256) {
831         return currentIndex;
832     }
833 
834     /**
835      * @dev See {IERC721Enumerable-tokenByIndex}.
836      */
837     function tokenByIndex(uint256 index) public view override returns (uint256) {
838         require(index < totalSupply(), 'ERC721A: global index out of bounds');
839         return index;
840     }
841 
842     /**
843      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
844      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
845      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
846      */
847     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
848         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
849         uint256 numMintedSoFar = totalSupply();
850         uint256 tokenIdsIdx = 0;
851         address currOwnershipAddr = address(0);
852         for (uint256 i = 0; i < numMintedSoFar; i++) {
853             TokenOwnership memory ownership = _ownerships[i];
854             if (ownership.addr != address(0)) {
855                 currOwnershipAddr = ownership.addr;
856             }
857             if (currOwnershipAddr == owner) {
858                 if (tokenIdsIdx == index) {
859                     return i;
860                 }
861                 tokenIdsIdx++;
862             }
863         }
864         revert('ERC721A: unable to get token of owner by index');
865     }
866 
867     /**
868      * @dev See {IERC165-supportsInterface}.
869      */
870     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
871         return
872             interfaceId == type(IERC721).interfaceId ||
873             interfaceId == type(IERC721Metadata).interfaceId ||
874             interfaceId == type(IERC721Enumerable).interfaceId ||
875             super.supportsInterface(interfaceId);
876     }
877 
878     /**
879      * @dev See {IERC721-balanceOf}.
880      */
881     function balanceOf(address owner) public view override returns (uint256) {
882         require(owner != address(0), 'ERC721A: balance query for the zero address');
883         return uint256(_addressData[owner].balance);
884     }
885 
886     function _numberMinted(address owner) internal view returns (uint256) {
887         require(owner != address(0), 'ERC721A: number minted query for the zero address');
888         return uint256(_addressData[owner].numberMinted);
889     }
890 
891     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
892         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
893 
894         uint256 lowestTokenToCheck;
895         if (tokenId >= maxBatchSize) {
896             lowestTokenToCheck = tokenId - maxBatchSize + 1;
897         }
898 
899         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
900             TokenOwnership memory ownership = _ownerships[curr];
901             if (ownership.addr != address(0)) {
902                 return ownership;
903             }
904         }
905 
906         revert('ERC721A: unable to determine the owner of token');
907     }
908 
909     /**
910      * @dev See {IERC721-ownerOf}.
911      */
912     function ownerOf(uint256 tokenId) public view override returns (address) {
913         return ownershipOf(tokenId).addr;
914     }
915 
916     /**
917      * @dev See {IERC721Metadata-name}.
918      */
919     function name() public view virtual override returns (string memory) {
920         return _name;
921     }
922 
923     /**
924      * @dev See {IERC721Metadata-symbol}.
925      */
926     function symbol() public view virtual override returns (string memory) {
927         return _symbol;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-tokenURI}.
932      */
933     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
934         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
935 
936         string memory baseURI = _baseURI();
937         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
938     }
939 
940     /**
941      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
942      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
943      * by default, can be overriden in child contracts.
944      */
945     function _baseURI() internal view virtual returns (string memory) {
946         return '';
947     }
948 
949     /**
950      * @dev See {IERC721-approve}.
951      */
952     function approve(address to, uint256 tokenId) public override {
953         address owner = ERC721A.ownerOf(tokenId);
954         require(to != owner, 'ERC721A: approval to current owner');
955 
956         require(
957             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
958             'ERC721A: approve caller is not owner nor approved for all'
959         );
960 
961         _approve(to, tokenId, owner);
962     }
963 
964     /**
965      * @dev See {IERC721-getApproved}.
966      */
967     function getApproved(uint256 tokenId) public view override returns (address) {
968         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
969 
970         return _tokenApprovals[tokenId];
971     }
972 
973     /**
974      * @dev See {IERC721-setApprovalForAll}.
975      */
976     function setApprovalForAll(address operator, bool approved) public override {
977         require(operator != _msgSender(), 'ERC721A: approve to caller');
978 
979         _operatorApprovals[_msgSender()][operator] = approved;
980         emit ApprovalForAll(_msgSender(), operator, approved);
981     }
982 
983     /**
984      * @dev See {IERC721-isApprovedForAll}.
985      */
986     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
987         return _operatorApprovals[owner][operator];
988     }
989 
990     /**
991      * @dev See {IERC721-transferFrom}.
992      */
993     function transferFrom(
994         address from,
995         address to,
996         uint256 tokenId
997     ) public override {
998         _transfer(from, to, tokenId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-safeTransferFrom}.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public override {
1009         safeTransferFrom(from, to, tokenId, '');
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-safeTransferFrom}.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) public override {
1021         _transfer(from, to, tokenId);
1022         require(
1023             _checkOnERC721Received(from, to, tokenId, _data),
1024             'ERC721A: transfer to non ERC721Receiver implementer'
1025         );
1026     }
1027 
1028     /**
1029      * @dev Returns whether `tokenId` exists.
1030      *
1031      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1032      *
1033      * Tokens start existing when they are minted (`_mint`),
1034      */
1035     function _exists(uint256 tokenId) internal view returns (bool) {
1036         return tokenId < currentIndex;
1037     }
1038 
1039     function _safeMint(address to, uint256 quantity) internal {
1040         _safeMint(to, quantity, '');
1041     }
1042 
1043     /**
1044      * @dev Mints `quantity` tokens and transfers them to `to`.
1045      *
1046      * Requirements:
1047      *
1048      * - `to` cannot be the zero address.
1049      * - `quantity` cannot be larger than the max batch size.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _safeMint(
1054         address to,
1055         uint256 quantity,
1056         bytes memory _data
1057     ) internal {
1058         uint256 startTokenId = currentIndex;
1059         require(to != address(0), 'ERC721A: mint to the zero address');
1060         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1061         require(!_exists(startTokenId), 'ERC721A: token already minted');
1062         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1063         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1064 
1065         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1066 
1067         AddressData memory addressData = _addressData[to];
1068         _addressData[to] = AddressData(
1069             addressData.balance + uint128(quantity),
1070             addressData.numberMinted + uint128(quantity)
1071         );
1072         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1073 
1074         uint256 updatedIndex = startTokenId;
1075 
1076         for (uint256 i = 0; i < quantity; i++) {
1077             emit Transfer(address(0), to, updatedIndex);
1078             require(
1079                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1080                 'ERC721A: transfer to non ERC721Receiver implementer'
1081             );
1082             updatedIndex++;
1083         }
1084 
1085         currentIndex = updatedIndex;
1086         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1087     }
1088 
1089     /**
1090      * @dev Transfers `tokenId` from `from` to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `to` cannot be the zero address.
1095      * - `tokenId` token must be owned by `from`.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _transfer(
1100         address from,
1101         address to,
1102         uint256 tokenId
1103     ) private {
1104         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1105 
1106         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1107             getApproved(tokenId) == _msgSender() ||
1108             isApprovedForAll(prevOwnership.addr, _msgSender()));
1109 
1110         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1111 
1112         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1113         require(to != address(0), 'ERC721A: transfer to the zero address');
1114 
1115         _beforeTokenTransfers(from, to, tokenId, 1);
1116 
1117         // Clear approvals from the previous owner
1118         _approve(address(0), tokenId, prevOwnership.addr);
1119 
1120         // Underflow of the sender's balance is impossible because we check for
1121         // ownership above and the recipient's balance can't realistically overflow.
1122         unchecked {
1123             _addressData[from].balance -= 1;
1124             _addressData[to].balance += 1;
1125         }
1126 
1127         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1128 
1129         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1130         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1131         uint256 nextTokenId = tokenId + 1;
1132         if (_ownerships[nextTokenId].addr == address(0)) {
1133             if (_exists(nextTokenId)) {
1134                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1135             }
1136         }
1137 
1138         emit Transfer(from, to, tokenId);
1139         _afterTokenTransfers(from, to, tokenId, 1);
1140     }
1141 
1142     /**
1143      * @dev Approve `to` to operate on `tokenId`
1144      *
1145      * Emits a {Approval} event.
1146      */
1147     function _approve(
1148         address to,
1149         uint256 tokenId,
1150         address owner
1151     ) private {
1152         _tokenApprovals[tokenId] = to;
1153         emit Approval(owner, to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1158      * The call is not executed if the target address is not a contract.
1159      *
1160      * @param from address representing the previous owner of the given token ID
1161      * @param to target address that will receive the tokens
1162      * @param tokenId uint256 ID of the token to be transferred
1163      * @param _data bytes optional data to send along with the call
1164      * @return bool whether the call correctly returned the expected magic value
1165      */
1166     function _checkOnERC721Received(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes memory _data
1171     ) private returns (bool) {
1172         if (to.isContract()) {
1173             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1174                 return retval == IERC721Receiver(to).onERC721Received.selector;
1175             } catch (bytes memory reason) {
1176                 if (reason.length == 0) {
1177                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1178                 } else {
1179                     assembly {
1180                         revert(add(32, reason), mload(reason))
1181                     }
1182                 }
1183             }
1184         } else {
1185             return true;
1186         }
1187     }
1188 
1189     /**
1190      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1191      *
1192      * startTokenId - the first token id to be transferred
1193      * quantity - the amount to be transferred
1194      *
1195      * Calling conditions:
1196      *
1197      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1198      * transferred to `to`.
1199      * - When `from` is zero, `tokenId` will be minted for `to`.
1200      */
1201     function _beforeTokenTransfers(
1202         address from,
1203         address to,
1204         uint256 startTokenId,
1205         uint256 quantity
1206     ) internal virtual {}
1207 
1208     /**
1209      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1210      * minting.
1211      *
1212      * startTokenId - the first token id to be transferred
1213      * quantity - the amount to be transferred
1214      *
1215      * Calling conditions:
1216      *
1217      * - when `from` and `to` are both non-zero.
1218      * - `from` and `to` are never both zero.
1219      */
1220     function _afterTokenTransfers(
1221         address from,
1222         address to,
1223         uint256 startTokenId,
1224         uint256 quantity
1225     ) internal virtual {}
1226 }
1227 
1228 interface HolderC {
1229     
1230     function balanceOf(address owner) external view returns (uint256 balance);
1231 }
1232 
1233 pragma solidity ^0.8.0;
1234 
1235 contract xCats is ERC721A, Ownable {
1236   using Strings for uint256;
1237 
1238   string public uriPrefix = "";
1239   string public uriSuffix = ".json";
1240   string public hiddenMetadataUri;
1241   
1242   uint256 public cost = 0.04 ether;
1243   uint256 public maxSupply = 9999;
1244   uint256 public maxMintAmountPerTx = 9;
1245   uint256 public nftPerAddressLimitWl = 9;
1246 
1247   bool public paused = true;
1248   bool public revealed = false;
1249   bool public onlyWhitelisted = true;
1250 
1251   bytes32 public whitelistMerkleRoot;
1252   mapping(address => uint256) public addressMintedBalance;
1253 
1254   HolderC public holderc;
1255 
1256   constructor() ERC721A("0xCats", "0xCat", maxMintAmountPerTx) {
1257     setHiddenMetadataUri("https://0xcats.mypinata.cloud/ipfs/QmQQJV8H66DKTwdHQCMw8wFuNxUo7qVmQQJjsg4nc7Fows/hidden.json");
1258   }
1259 
1260   /**
1261     * @dev validates merkleProof
1262     */
1263   modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1264     require(
1265         MerkleProof.verify(
1266             merkleProof,
1267             root,
1268             keccak256(abi.encodePacked(msg.sender))
1269         ),
1270         "Address does not exist in list"
1271     );
1272     _;
1273   }
1274 
1275   modifier mintCompliance(uint256 _mintAmount) {
1276     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1277     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1278     _;
1279   }
1280 
1281   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1282     require(!paused, "The contract is paused!");
1283     require(!onlyWhitelisted, "Presale is on");
1284     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1285 
1286     _safeMint(msg.sender, _mintAmount);
1287   }
1288 
1289   function mintHolder(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1290     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1291     require(!paused, "The contract is paused!");
1292     require(onlyWhitelisted, "Presale has ended");
1293     require(holderc.balanceOf(msg.sender) > 0 , "you are not a holder");
1294     require(ownerMintedCount + _mintAmount <= nftPerAddressLimitWl, "max NFT per address exceeded");
1295     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1296 
1297     addressMintedBalance[msg.sender]+=_mintAmount;
1298     _safeMint(msg.sender, _mintAmount);
1299   }
1300 
1301   function mintWhitelist(bytes32[] calldata merkleProof, uint256 _mintAmount) public payable isValidMerkleProof(merkleProof, whitelistMerkleRoot){
1302     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1303     require(!paused, "The contract is paused!");
1304     require(onlyWhitelisted, "Presale has ended");
1305     require(ownerMintedCount + _mintAmount <= nftPerAddressLimitWl, "max NFT per address exceeded");
1306     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1307     
1308     addressMintedBalance[msg.sender]+=_mintAmount;
1309     _safeMint(msg.sender, _mintAmount);
1310   }
1311   
1312   function mintOwner(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1313     _safeMint(_to, _mintAmount);
1314   }
1315 
1316   function walletOfOwner(address _owner)
1317     public
1318     view
1319     returns (uint256[] memory)
1320   {
1321     uint256 ownerTokenCount = balanceOf(_owner);
1322     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1323     uint256 currentTokenId = 0;
1324     uint256 ownedTokenIndex = 0;
1325 
1326     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1327       address currentTokenOwner = ownerOf(currentTokenId);
1328 
1329       if (currentTokenOwner == _owner) {
1330         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1331 
1332         ownedTokenIndex++;
1333       }
1334 
1335       currentTokenId++;
1336     }
1337 
1338     return ownedTokenIds;
1339   }
1340 
1341   function tokenURI(uint256 _tokenId)
1342     public
1343     view
1344     virtual
1345     override
1346     returns (string memory)
1347   {
1348     require(
1349       _exists(_tokenId),
1350       "ERC721Metadata: URI query for nonexistent token"
1351     );
1352 
1353     if (revealed == false) {
1354       return hiddenMetadataUri;
1355     }
1356 
1357     string memory currentBaseURI = _baseURI();
1358     return bytes(currentBaseURI).length > 0
1359         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1360         : "";
1361   }
1362 
1363   function setRevealed(bool _state) public onlyOwner {
1364     revealed = _state;
1365   }
1366 
1367   function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1368     whitelistMerkleRoot = merkleRoot;
1369   }
1370 
1371   function setOnlyWhitelisted(bool _state) public onlyOwner {
1372     onlyWhitelisted = _state;
1373   }
1374 
1375   function setCost(uint256 _cost) public onlyOwner {
1376     cost = _cost;
1377   }
1378 
1379   function setHolderC(address _address) public {
1380     holderc = HolderC(_address);
1381   }
1382 
1383   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1384     hiddenMetadataUri = _hiddenMetadataUri;
1385   }
1386 
1387   function setNftPerAddressLimitWl(uint256 _limit) public onlyOwner {
1388     nftPerAddressLimitWl = _limit;
1389   }
1390 
1391   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1392     uriPrefix = _uriPrefix;
1393   }
1394 
1395   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1396     uriSuffix = _uriSuffix;
1397   }
1398 
1399   function setPaused(bool _state) public onlyOwner {
1400     paused = _state;
1401   }
1402 
1403   function withdraw() public onlyOwner {
1404     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1405     require(os);
1406   }
1407 
1408   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1409       _safeMint(_receiver, _mintAmount);
1410   }
1411 
1412   function _baseURI() internal view virtual override returns (string memory) {
1413     return uriPrefix;
1414   }
1415 }