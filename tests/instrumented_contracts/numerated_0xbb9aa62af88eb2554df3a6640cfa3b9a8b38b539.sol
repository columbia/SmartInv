1 // SPDX-License-Identifier: MIT
2 // Creator: Chiru Labs
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: @openzeppelin/contracts/utils/Address.sol
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      */
205     function isContract(address account) internal view returns (bool) {
206         // This method relies on extcodesize, which returns 0 for contracts in
207         // construction, since the code is only stored at the end of the
208         // constructor execution.
209 
210         uint256 size;
211         assembly {
212             size := extcodesize(account)
213         }
214         return size > 0;
215     }
216 
217     /**
218      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
219      * `recipient`, forwarding all available gas and reverting on errors.
220      *
221      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
222      * of certain opcodes, possibly making contracts go over the 2300 gas limit
223      * imposed by `transfer`, making them unable to receive funds via
224      * `transfer`. {sendValue} removes this limitation.
225      *
226      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
227      *
228      * IMPORTANT: because control is transferred to `recipient`, care must be
229      * taken to not create reentrancy vulnerabilities. Consider using
230      * {ReentrancyGuard} or the
231      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
232      */
233     function sendValue(address payable recipient, uint256 amount) internal {
234         require(address(this).balance >= amount, "Address: insufficient balance");
235 
236         (bool success, ) = recipient.call{value: amount}("");
237         require(success, "Address: unable to send value, recipient may have reverted");
238     }
239 
240     /**
241      * @dev Performs a Solidity function call using a low level `call`. A
242      * plain `call` is an unsafe replacement for a function call: use this
243      * function instead.
244      *
245      * If `target` reverts with a revert reason, it is bubbled up by this
246      * function (like regular Solidity function calls).
247      *
248      * Returns the raw returned data. To convert to the expected return value,
249      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
250      *
251      * Requirements:
252      *
253      * - `target` must be a contract.
254      * - calling `target` with `data` must not revert.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionCall(target, data, "Address: low-level call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
264      * `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, 0, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but also transferring `value` wei to `target`.
279      *
280      * Requirements:
281      *
282      * - the calling contract must have an ETH balance of at least `value`.
283      * - the called Solidity function must be `payable`.
284      *
285      * _Available since v3.1._
286      */
287     function functionCallWithValue(
288         address target,
289         bytes memory data,
290         uint256 value
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
297      * with `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(address(this).balance >= value, "Address: insufficient balance for call");
308         require(isContract(target), "Address: call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.call{value: value}(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
321         return functionStaticCall(target, data, "Address: low-level static call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal view returns (bytes memory) {
335         require(isContract(target), "Address: static call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.staticcall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a delegate call.
344      *
345      * _Available since v3.4._
346      */
347     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(isContract(target), "Address: delegate call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.delegatecall(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
370      * revert reason using the provided one.
371      *
372      * _Available since v4.3._
373      */
374     function verifyCallResult(
375         bool success,
376         bytes memory returndata,
377         string memory errorMessage
378     ) internal pure returns (bytes memory) {
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
398 
399 
400 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @title ERC721 token receiver interface
406  * @dev Interface for any contract that wants to support safeTransfers
407  * from ERC721 asset contracts.
408  */
409 interface IERC721Receiver {
410     /**
411      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
412      * by `operator` from `from`, this function is called.
413      *
414      * It must return its Solidity selector to confirm the token transfer.
415      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
416      *
417      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
418      */
419     function onERC721Received(
420         address operator,
421         address from,
422         uint256 tokenId,
423         bytes calldata data
424     ) external returns (bytes4);
425 }
426 
427 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
428 
429 
430 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
431 
432 pragma solidity ^0.8.0;
433 
434 /**
435  * @dev Interface of the ERC165 standard, as defined in the
436  * https://eips.ethereum.org/EIPS/eip-165[EIP].
437  *
438  * Implementers can declare support of contract interfaces, which can then be
439  * queried by others ({ERC165Checker}).
440  *
441  * For an implementation, see {ERC165}.
442  */
443 interface IERC165 {
444     /**
445      * @dev Returns true if this contract implements the interface defined by
446      * `interfaceId`. See the corresponding
447      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
448      * to learn more about how these ids are created.
449      *
450      * This function call must use less than 30 000 gas.
451      */
452     function supportsInterface(bytes4 interfaceId) external view returns (bool);
453 }
454 
455 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 
463 /**
464  * @dev Implementation of the {IERC165} interface.
465  *
466  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
467  * for the additional interface id that will be supported. For example:
468  *
469  * ```solidity
470  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
472  * }
473  * ```
474  *
475  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
476  */
477 abstract contract ERC165 is IERC165 {
478     /**
479      * @dev See {IERC165-supportsInterface}.
480      */
481     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482         return interfaceId == type(IERC165).interfaceId;
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @dev Required interface of an ERC721 compliant contract.
496  */
497 interface IERC721 is IERC165 {
498     /**
499      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
500      */
501     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
502 
503     /**
504      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
505      */
506     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
510      */
511     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
512 
513     /**
514      * @dev Returns the number of tokens in ``owner``'s account.
515      */
516     function balanceOf(address owner) external view returns (uint256 balance);
517 
518     /**
519      * @dev Returns the owner of the `tokenId` token.
520      *
521      * Requirements:
522      *
523      * - `tokenId` must exist.
524      */
525     function ownerOf(uint256 tokenId) external view returns (address owner);
526 
527     /**
528      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
529      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
537      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
538      *
539      * Emits a {Transfer} event.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external;
546 
547     /**
548      * @dev Transfers `tokenId` token from `from` to `to`.
549      *
550      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) external;
566 
567     /**
568      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
569      * The approval is cleared when the token is transferred.
570      *
571      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
572      *
573      * Requirements:
574      *
575      * - The caller must own the token or be an approved operator.
576      * - `tokenId` must exist.
577      *
578      * Emits an {Approval} event.
579      */
580     function approve(address to, uint256 tokenId) external;
581 
582     /**
583      * @dev Returns the account approved for `tokenId` token.
584      *
585      * Requirements:
586      *
587      * - `tokenId` must exist.
588      */
589     function getApproved(uint256 tokenId) external view returns (address operator);
590 
591     /**
592      * @dev Approve or remove `operator` as an operator for the caller.
593      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
594      *
595      * Requirements:
596      *
597      * - The `operator` cannot be the caller.
598      *
599      * Emits an {ApprovalForAll} event.
600      */
601     function setApprovalForAll(address operator, bool _approved) external;
602 
603     /**
604      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
605      *
606      * See {setApprovalForAll}
607      */
608     function isApprovedForAll(address owner, address operator) external view returns (bool);
609 
610     /**
611      * @dev Safely transfers `tokenId` token from `from` to `to`.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId,
627         bytes calldata data
628     ) external;
629 }
630 
631 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 /**
640  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
641  * @dev See https://eips.ethereum.org/EIPS/eip-721
642  */
643 interface IERC721Enumerable is IERC721 {
644     /**
645      * @dev Returns the total amount of tokens stored by the contract.
646      */
647     function totalSupply() external view returns (uint256);
648 
649     /**
650      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
651      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
652      */
653     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
654 
655     /**
656      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
657      * Use along with {totalSupply} to enumerate all tokens.
658      */
659     function tokenByIndex(uint256 index) external view returns (uint256);
660 }
661 
662 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
672  * @dev See https://eips.ethereum.org/EIPS/eip-721
673  */
674 interface IERC721Metadata is IERC721 {
675     /**
676      * @dev Returns the token collection name.
677      */
678     function name() external view returns (string memory);
679 
680     /**
681      * @dev Returns the token collection symbol.
682      */
683     function symbol() external view returns (string memory);
684 
685     /**
686      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
687      */
688     function tokenURI(uint256 tokenId) external view returns (string memory);
689 }
690 
691 // File: contracts/LowerGas.sol
692 
693 
694 // Creator: Chiru Labs
695 
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev These functions deal with verification of Merkle Trees proofs.
701  *
702  * The proofs can be generated using the JavaScript library
703  * https://github.com/miguelmota/merkletreejs[merkletreejs].
704  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
705  *
706  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
707  */
708 library MerkleProof {
709     /**
710      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
711      * defined by `root`. For this, a `proof` must be provided, containing
712      * sibling hashes on the branch from the leaf to the root of the tree. Each
713      * pair of leaves and each pair of pre-images are assumed to be sorted.
714      */
715     function verify(
716         bytes32[] memory proof,
717         bytes32 root,
718         bytes32 leaf
719     ) internal pure returns (bool) {
720         return processProof(proof, leaf) == root;
721     }
722 
723     /**
724      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
725      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
726      * hash matches the root of the tree. When processing the proof, the pairs
727      * of leafs & pre-images are assumed to be sorted.
728      *
729      * _Available since v4.4._
730      */
731     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
732         bytes32 computedHash = leaf;
733         for (uint256 i = 0; i < proof.length; i++) {
734             bytes32 proofElement = proof[i];
735             if (computedHash <= proofElement) {
736                 // Hash(current computed hash + current element of the proof)
737                 computedHash = _efficientHash(computedHash, proofElement);
738             } else {
739                 // Hash(current element of the proof + current computed hash)
740                 computedHash = _efficientHash(proofElement, computedHash);
741             }
742         }
743         return computedHash;
744     }
745 
746     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
747         assembly {
748             mstore(0x00, a)
749             mstore(0x20, b)
750             value := keccak256(0x00, 0x40)
751         }
752     }
753 }
754 
755 pragma solidity ^0.8.0;
756 
757 
758 
759 
760 
761 
762 
763 
764 
765 
766 /**
767  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
768  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
769  *
770  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
771  *
772  * Does not support burning tokens to address(0).
773  *
774  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
775  */
776 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
777     using Address for address;
778     using Strings for uint256;
779 
780     struct TokenOwnership {
781         address addr;
782         uint64 startTimestamp;
783     }
784 
785     struct AddressData {
786         uint128 balance;
787         uint128 numberMinted;
788     }
789 
790     uint256 internal currentIndex = 0;
791 
792     uint256 internal immutable maxBatchSize;
793 
794     // Token name
795     string private _name;
796 
797     // Token symbol
798     string private _symbol;
799 
800     // Mapping from token ID to ownership details
801     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
802     mapping(uint256 => TokenOwnership) internal _ownerships;
803 
804     // Mapping owner address to address data
805     mapping(address => AddressData) private _addressData;
806 
807     // Mapping from token ID to approved address
808     mapping(uint256 => address) private _tokenApprovals;
809 
810     // Mapping from owner to operator approvals
811     mapping(address => mapping(address => bool)) private _operatorApprovals;
812 
813     /**
814      * @dev
815      * `maxBatchSize` refers to how much a minter can mint at a time.
816      */
817     constructor(
818         string memory name_,
819         string memory symbol_,
820         uint256 maxBatchSize_
821     ) {
822         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
823         _name = name_;
824         _symbol = symbol_;
825         maxBatchSize = maxBatchSize_;
826     }
827 
828     /**
829      * @dev See {IERC721Enumerable-totalSupply}.
830      */
831     function totalSupply() public view override returns (uint256) {
832         return currentIndex;
833     }
834 
835     /**
836      * @dev See {IERC721Enumerable-tokenByIndex}.
837      */
838     function tokenByIndex(uint256 index) public view override returns (uint256) {
839         require(index < totalSupply(), 'ERC721A: global index out of bounds');
840         return index;
841     }
842 
843     /**
844      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
845      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
846      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
847      */
848     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
849         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
850         uint256 numMintedSoFar = totalSupply();
851         uint256 tokenIdsIdx = 0;
852         address currOwnershipAddr = address(0);
853         for (uint256 i = 0; i < numMintedSoFar; i++) {
854             TokenOwnership memory ownership = _ownerships[i];
855             if (ownership.addr != address(0)) {
856                 currOwnershipAddr = ownership.addr;
857             }
858             if (currOwnershipAddr == owner) {
859                 if (tokenIdsIdx == index) {
860                     return i;
861                 }
862                 tokenIdsIdx++;
863             }
864         }
865         revert('ERC721A: unable to get token of owner by index');
866     }
867 
868     /**
869      * @dev See {IERC165-supportsInterface}.
870      */
871     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
872         return
873             interfaceId == type(IERC721).interfaceId ||
874             interfaceId == type(IERC721Metadata).interfaceId ||
875             interfaceId == type(IERC721Enumerable).interfaceId ||
876             super.supportsInterface(interfaceId);
877     }
878 
879     /**
880      * @dev See {IERC721-balanceOf}.
881      */
882     function balanceOf(address owner) public view override returns (uint256) {
883         require(owner != address(0), 'ERC721A: balance query for the zero address');
884         return uint256(_addressData[owner].balance);
885     }
886 
887     function _numberMinted(address owner) internal view returns (uint256) {
888         require(owner != address(0), 'ERC721A: number minted query for the zero address');
889         return uint256(_addressData[owner].numberMinted);
890     }
891 
892     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
893         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
894 
895         uint256 lowestTokenToCheck;
896         if (tokenId >= maxBatchSize) {
897             lowestTokenToCheck = tokenId - maxBatchSize + 1;
898         }
899 
900         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
901             TokenOwnership memory ownership = _ownerships[curr];
902             if (ownership.addr != address(0)) {
903                 return ownership;
904             }
905         }
906 
907         revert('ERC721A: unable to determine the owner of token');
908     }
909 
910     /**
911      * @dev See {IERC721-ownerOf}.
912      */
913     function ownerOf(uint256 tokenId) public view override returns (address) {
914         return ownershipOf(tokenId).addr;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-name}.
919      */
920     function name() public view virtual override returns (string memory) {
921         return _name;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-symbol}.
926      */
927     function symbol() public view virtual override returns (string memory) {
928         return _symbol;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-tokenURI}.
933      */
934     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
935         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
936 
937         string memory baseURI = _baseURI();
938         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
939     }
940 
941     /**
942      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
943      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
944      * by default, can be overriden in child contracts.
945      */
946     function _baseURI() internal view virtual returns (string memory) {
947         return '';
948     }
949 
950     /**
951      * @dev See {IERC721-approve}.
952      */
953     function approve(address to, uint256 tokenId) public override {
954         address owner = ERC721A.ownerOf(tokenId);
955         require(to != owner, 'ERC721A: approval to current owner');
956 
957         require(
958             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
959             'ERC721A: approve caller is not owner nor approved for all'
960         );
961 
962         _approve(to, tokenId, owner);
963     }
964 
965     /**
966      * @dev See {IERC721-getApproved}.
967      */
968     function getApproved(uint256 tokenId) public view override returns (address) {
969         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
970 
971         return _tokenApprovals[tokenId];
972     }
973 
974     /**
975      * @dev See {IERC721-setApprovalForAll}.
976      */
977     function setApprovalForAll(address operator, bool approved) public override {
978         require(operator != _msgSender(), 'ERC721A: approve to caller');
979 
980         _operatorApprovals[_msgSender()][operator] = approved;
981         emit ApprovalForAll(_msgSender(), operator, approved);
982     }
983 
984     /**
985      * @dev See {IERC721-isApprovedForAll}.
986      */
987     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev See {IERC721-transferFrom}.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public override {
999         _transfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-safeTransferFrom}.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public override {
1010         safeTransferFrom(from, to, tokenId, '');
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) public override {
1022         _transfer(from, to, tokenId);
1023         require(
1024             _checkOnERC721Received(from, to, tokenId, _data),
1025             'ERC721A: transfer to non ERC721Receiver implementer'
1026         );
1027     }
1028 
1029     /**
1030      * @dev Returns whether `tokenId` exists.
1031      *
1032      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1033      *
1034      * Tokens start existing when they are minted (`_mint`),
1035      */
1036     function _exists(uint256 tokenId) internal view returns (bool) {
1037         return tokenId < currentIndex;
1038     }
1039 
1040     function _safeMint(address to, uint256 quantity) internal {
1041         _safeMint(to, quantity, '');
1042     }
1043 
1044     /**
1045      * @dev Mints `quantity` tokens and transfers them to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `to` cannot be the zero address.
1050      * - `quantity` cannot be larger than the max batch size.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _safeMint(
1055         address to,
1056         uint256 quantity,
1057         bytes memory _data
1058     ) internal {
1059         uint256 startTokenId = currentIndex;
1060         require(to != address(0), 'ERC721A: mint to the zero address');
1061         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1062         require(!_exists(startTokenId), 'ERC721A: token already minted');
1063         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1064         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1065 
1066         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1067 
1068         AddressData memory addressData = _addressData[to];
1069         _addressData[to] = AddressData(
1070             addressData.balance + uint128(quantity),
1071             addressData.numberMinted + uint128(quantity)
1072         );
1073         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1074 
1075         uint256 updatedIndex = startTokenId;
1076 
1077         for (uint256 i = 0; i < quantity; i++) {
1078             emit Transfer(address(0), to, updatedIndex);
1079             require(
1080                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1081                 'ERC721A: transfer to non ERC721Receiver implementer'
1082             );
1083             updatedIndex++;
1084         }
1085 
1086         currentIndex = updatedIndex;
1087         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1088     }
1089 
1090     /**
1091      * @dev Transfers `tokenId` from `from` to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must be owned by `from`.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _transfer(
1101         address from,
1102         address to,
1103         uint256 tokenId
1104     ) private {
1105         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1106 
1107         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1108             getApproved(tokenId) == _msgSender() ||
1109             isApprovedForAll(prevOwnership.addr, _msgSender()));
1110 
1111         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1112 
1113         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1114         require(to != address(0), 'ERC721A: transfer to the zero address');
1115 
1116         _beforeTokenTransfers(from, to, tokenId, 1);
1117 
1118         // Clear approvals from the previous owner
1119         _approve(address(0), tokenId, prevOwnership.addr);
1120 
1121         // Underflow of the sender's balance is impossible because we check for
1122         // ownership above and the recipient's balance can't realistically overflow.
1123         unchecked {
1124             _addressData[from].balance -= 1;
1125             _addressData[to].balance += 1;
1126         }
1127 
1128         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1129 
1130         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1131         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1132         uint256 nextTokenId = tokenId + 1;
1133         if (_ownerships[nextTokenId].addr == address(0)) {
1134             if (_exists(nextTokenId)) {
1135                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1136             }
1137         }
1138 
1139         emit Transfer(from, to, tokenId);
1140         _afterTokenTransfers(from, to, tokenId, 1);
1141     }
1142 
1143     /**
1144      * @dev Approve `to` to operate on `tokenId`
1145      *
1146      * Emits a {Approval} event.
1147      */
1148     function _approve(
1149         address to,
1150         uint256 tokenId,
1151         address owner
1152     ) private {
1153         _tokenApprovals[tokenId] = to;
1154         emit Approval(owner, to, tokenId);
1155     }
1156 
1157     /**
1158      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1159      * The call is not executed if the target address is not a contract.
1160      *
1161      * @param from address representing the previous owner of the given token ID
1162      * @param to target address that will receive the tokens
1163      * @param tokenId uint256 ID of the token to be transferred
1164      * @param _data bytes optional data to send along with the call
1165      * @return bool whether the call correctly returned the expected magic value
1166      */
1167     function _checkOnERC721Received(
1168         address from,
1169         address to,
1170         uint256 tokenId,
1171         bytes memory _data
1172     ) private returns (bool) {
1173         if (to.isContract()) {
1174             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1175                 return retval == IERC721Receiver(to).onERC721Received.selector;
1176             } catch (bytes memory reason) {
1177                 if (reason.length == 0) {
1178                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1179                 } else {
1180                     assembly {
1181                         revert(add(32, reason), mload(reason))
1182                     }
1183                 }
1184             }
1185         } else {
1186             return true;
1187         }
1188     }
1189 
1190     /**
1191      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1192      *
1193      * startTokenId - the first token id to be transferred
1194      * quantity - the amount to be transferred
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      */
1202     function _beforeTokenTransfers(
1203         address from,
1204         address to,
1205         uint256 startTokenId,
1206         uint256 quantity
1207     ) internal virtual {}
1208 
1209     /**
1210      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1211      * minting.
1212      *
1213      * startTokenId - the first token id to be transferred
1214      * quantity - the amount to be transferred
1215      *
1216      * Calling conditions:
1217      *
1218      * - when `from` and `to` are both non-zero.
1219      * - `from` and `to` are never both zero.
1220      */
1221     function _afterTokenTransfers(
1222         address from,
1223         address to,
1224         uint256 startTokenId,
1225         uint256 quantity
1226     ) internal virtual {}
1227 }
1228 
1229 pragma solidity ^0.8.0;
1230 
1231 contract Inari is ERC721A, Ownable {
1232   using Strings for uint256;
1233 
1234   string public uriPrefix = "";
1235   string public uriSuffix = ".json";
1236   string public hiddenMetadataUri;
1237   
1238   uint256 public cost = 0.057 ether;
1239   uint256 public maxSupply = 8778;
1240   uint256 public maxMintAmountPerTx = 3;
1241   uint256 public nftPerAddressLimitWl = 3;
1242   uint256 public noFreeNft = 200;
1243 
1244   bool public paused = true;
1245   bool public revealed = false;
1246   bool public onlyWhitelisted = true;
1247 
1248   bytes32 public whitelistMerkleRoot;
1249   mapping(address => uint256) public addressMintedBalance;
1250 
1251   constructor() ERC721A("Inari", "INARI", 100) {
1252     setHiddenMetadataUri("ipfs://Qmaq7DtwL4FKJua5HMKAsK7QXHcKgyXyvYiAQJ1j9veyn2/hidden.json");
1253   }
1254 
1255   /**
1256     * @dev validates merkleProof
1257     */
1258   modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1259     require(
1260         MerkleProof.verify(
1261             merkleProof,
1262             root,
1263             keccak256(abi.encodePacked(msg.sender))
1264         ),
1265         "Address does not exist in list"
1266     );
1267     _;
1268   }
1269 
1270   modifier mintCompliance(uint256 _mintAmount) {
1271     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1272     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1273     _;
1274   }
1275 
1276   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1277     require(!paused, "The contract is paused!");
1278     require(!onlyWhitelisted, "Presale is on");
1279     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1280 
1281     _safeMint(msg.sender, _mintAmount);
1282   }
1283 
1284   function mintWhitelist(bytes32[] calldata merkleProof, uint256 _mintAmount) public payable isValidMerkleProof(merkleProof, whitelistMerkleRoot){
1285     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1286     require(!paused, "The contract is paused!");
1287     require(onlyWhitelisted, "Presale has ended");
1288     require(ownerMintedCount + _mintAmount <= nftPerAddressLimitWl, "max NFT per address exceeded");
1289 
1290     if(currentIndex + _mintAmount > noFreeNft){
1291         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1292     }
1293     
1294     addressMintedBalance[msg.sender]+=_mintAmount;
1295     _safeMint(msg.sender, _mintAmount);
1296   }
1297   
1298   function mintOwner(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1299     _safeMint(_to, _mintAmount);
1300   }
1301 
1302   function reserveCitizens(uint256 _mintAmount) public onlyOwner {
1303     require(_mintAmount > 0 , "Invalid mint amount!");
1304     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1305 
1306     _safeMint(msg.sender, _mintAmount);
1307   }
1308 
1309   function walletOfOwner(address _owner)
1310     public
1311     view
1312     returns (uint256[] memory)
1313   {
1314     uint256 ownerTokenCount = balanceOf(_owner);
1315     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1316     uint256 currentTokenId = 0;
1317     uint256 ownedTokenIndex = 0;
1318 
1319     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1320       address currentTokenOwner = ownerOf(currentTokenId);
1321 
1322       if (currentTokenOwner == _owner) {
1323         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1324 
1325         ownedTokenIndex++;
1326       }
1327 
1328       currentTokenId++;
1329     }
1330 
1331     return ownedTokenIds;
1332   }
1333 
1334   function tokenURI(uint256 _tokenId)
1335     public
1336     view
1337     virtual
1338     override
1339     returns (string memory)
1340   {
1341     require(
1342       _exists(_tokenId),
1343       "ERC721Metadata: URI query for nonexistent token"
1344     );
1345 
1346     if (revealed == false) {
1347       return hiddenMetadataUri;
1348     }
1349 
1350     string memory currentBaseURI = _baseURI();
1351     return bytes(currentBaseURI).length > 0
1352         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1353         : "";
1354   }
1355 
1356   function setRevealed(bool _state) public onlyOwner {
1357     revealed = _state;
1358   }
1359 
1360   function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1361     whitelistMerkleRoot = merkleRoot;
1362   }
1363 
1364   function setOnlyWhitelisted(bool _state) public onlyOwner {
1365     onlyWhitelisted = _state;
1366   }
1367 
1368   function setCost(uint256 _cost) public onlyOwner {
1369     cost = _cost;
1370   }
1371 
1372   function setNoFreeNft(uint128 _noOfFree) public onlyOwner {
1373     noFreeNft = _noOfFree;
1374   }
1375 
1376   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1377     hiddenMetadataUri = _hiddenMetadataUri;
1378   }
1379 
1380   function setNftPerAddressLimitWl(uint256 _limit) public onlyOwner {
1381     nftPerAddressLimitWl = _limit;
1382   }
1383 
1384   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1385     uriPrefix = _uriPrefix;
1386   }
1387 
1388   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1389     uriSuffix = _uriSuffix;
1390   }
1391 
1392   function setPaused(bool _state) public onlyOwner {
1393     paused = _state;
1394   }
1395 
1396   function withdraw() public onlyOwner {
1397     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1398     require(os);
1399   }
1400 
1401   function _baseURI() internal view virtual override returns (string memory) {
1402     return uriPrefix;
1403   }
1404 }