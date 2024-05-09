1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/access/Ownable.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _transferOwnership(_msgSender());
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view virtual returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         _transferOwnership(address(0));
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _transferOwnership(newOwner);
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Internal function without access restriction.
167      */
168     function _transferOwnership(address newOwner) internal virtual {
169         address oldOwner = _owner;
170         _owner = newOwner;
171         emit OwnershipTransferred(oldOwner, newOwner);
172     }
173 }
174 
175 // File: @openzeppelin/contracts/utils/Address.sol
176 
177 
178 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev Collection of functions related to the address type
184  */
185 library Address {
186     /**
187      * @dev Returns true if `account` is a contract.
188      *
189      * [IMPORTANT]
190      * ====
191      * It is unsafe to assume that an address for which this function returns
192      * false is an externally-owned account (EOA) and not a contract.
193      *
194      * Among others, `isContract` will return false for the following
195      * types of addresses:
196      *
197      *  - an externally-owned account
198      *  - a contract in construction
199      *  - an address where a contract will be created
200      *  - an address where a contract lived, but was destroyed
201      * ====
202      */
203     function isContract(address account) internal view returns (bool) {
204         // This method relies on extcodesize, which returns 0 for contracts in
205         // construction, since the code is only stored at the end of the
206         // constructor execution.
207 
208         uint256 size;
209         assembly {
210             size := extcodesize(account)
211         }
212         return size > 0;
213     }
214 
215     /**
216      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
217      * `recipient`, forwarding all available gas and reverting on errors.
218      *
219      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
220      * of certain opcodes, possibly making contracts go over the 2300 gas limit
221      * imposed by `transfer`, making them unable to receive funds via
222      * `transfer`. {sendValue} removes this limitation.
223      *
224      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
225      *
226      * IMPORTANT: because control is transferred to `recipient`, care must be
227      * taken to not create reentrancy vulnerabilities. Consider using
228      * {ReentrancyGuard} or the
229      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
230      */
231     function sendValue(address payable recipient, uint256 amount) internal {
232         require(address(this).balance >= amount, "Address: insufficient balance");
233 
234         (bool success, ) = recipient.call{value: amount}("");
235         require(success, "Address: unable to send value, recipient may have reverted");
236     }
237 
238     /**
239      * @dev Performs a Solidity function call using a low level `call`. A
240      * plain `call` is an unsafe replacement for a function call: use this
241      * function instead.
242      *
243      * If `target` reverts with a revert reason, it is bubbled up by this
244      * function (like regular Solidity function calls).
245      *
246      * Returns the raw returned data. To convert to the expected return value,
247      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
248      *
249      * Requirements:
250      *
251      * - `target` must be a contract.
252      * - calling `target` with `data` must not revert.
253      *
254      * _Available since v3.1._
255      */
256     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionCall(target, data, "Address: low-level call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
262      * `errorMessage` as a fallback revert reason when `target` reverts.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         return functionCallWithValue(target, data, 0, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but also transferring `value` wei to `target`.
277      *
278      * Requirements:
279      *
280      * - the calling contract must have an ETH balance of at least `value`.
281      * - the called Solidity function must be `payable`.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value
289     ) internal returns (bytes memory) {
290         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
295      * with `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         require(address(this).balance >= value, "Address: insufficient balance for call");
306         require(isContract(target), "Address: call to non-contract");
307 
308         (bool success, bytes memory returndata) = target.call{value: value}(data);
309         return verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a static call.
315      *
316      * _Available since v3.3._
317      */
318     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
319         return functionStaticCall(target, data, "Address: low-level static call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal view returns (bytes memory) {
333         require(isContract(target), "Address: static call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.staticcall(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a delegate call.
342      *
343      * _Available since v3.4._
344      */
345     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(isContract(target), "Address: delegate call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.delegatecall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
368      * revert reason using the provided one.
369      *
370      * _Available since v4.3._
371      */
372     function verifyCallResult(
373         bool success,
374         bytes memory returndata,
375         string memory errorMessage
376     ) internal pure returns (bytes memory) {
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383 
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @title ERC721 token receiver interface
404  * @dev Interface for any contract that wants to support safeTransfers
405  * from ERC721 asset contracts.
406  */
407 interface IERC721Receiver {
408     /**
409      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
410      * by `operator` from `from`, this function is called.
411      *
412      * It must return its Solidity selector to confirm the token transfer.
413      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
414      *
415      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
416      */
417     function onERC721Received(
418         address operator,
419         address from,
420         uint256 tokenId,
421         bytes calldata data
422     ) external returns (bytes4);
423 }
424 
425 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
426 
427 
428 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Interface of the ERC165 standard, as defined in the
434  * https://eips.ethereum.org/EIPS/eip-165[EIP].
435  *
436  * Implementers can declare support of contract interfaces, which can then be
437  * queried by others ({ERC165Checker}).
438  *
439  * For an implementation, see {ERC165}.
440  */
441 interface IERC165 {
442     /**
443      * @dev Returns true if this contract implements the interface defined by
444      * `interfaceId`. See the corresponding
445      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
446      * to learn more about how these ids are created.
447      *
448      * This function call must use less than 30 000 gas.
449      */
450     function supportsInterface(bytes4 interfaceId) external view returns (bool);
451 }
452 
453 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 
461 /**
462  * @dev Implementation of the {IERC165} interface.
463  *
464  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
465  * for the additional interface id that will be supported. For example:
466  *
467  * ```solidity
468  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
469  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
470  * }
471  * ```
472  *
473  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
474  */
475 abstract contract ERC165 is IERC165 {
476     /**
477      * @dev See {IERC165-supportsInterface}.
478      */
479     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480         return interfaceId == type(IERC165).interfaceId;
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Required interface of an ERC721 compliant contract.
494  */
495 interface IERC721 is IERC165 {
496     /**
497      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
498      */
499     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
500 
501     /**
502      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
503      */
504     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
505 
506     /**
507      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
508      */
509     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
510 
511     /**
512      * @dev Returns the number of tokens in ``owner``'s account.
513      */
514     function balanceOf(address owner) external view returns (uint256 balance);
515 
516     /**
517      * @dev Returns the owner of the `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function ownerOf(uint256 tokenId) external view returns (address owner);
524 
525     /**
526      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
527      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
528      *
529      * Requirements:
530      *
531      * - `from` cannot be the zero address.
532      * - `to` cannot be the zero address.
533      * - `tokenId` token must exist and be owned by `from`.
534      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
535      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
536      *
537      * Emits a {Transfer} event.
538      */
539     function safeTransferFrom(
540         address from,
541         address to,
542         uint256 tokenId
543     ) external;
544 
545     /**
546      * @dev Transfers `tokenId` token from `from` to `to`.
547      *
548      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must be owned by `from`.
555      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556      *
557      * Emits a {Transfer} event.
558      */
559     function transferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) external;
564 
565     /**
566      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
567      * The approval is cleared when the token is transferred.
568      *
569      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
570      *
571      * Requirements:
572      *
573      * - The caller must own the token or be an approved operator.
574      * - `tokenId` must exist.
575      *
576      * Emits an {Approval} event.
577      */
578     function approve(address to, uint256 tokenId) external;
579 
580     /**
581      * @dev Returns the account approved for `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function getApproved(uint256 tokenId) external view returns (address operator);
588 
589     /**
590      * @dev Approve or remove `operator` as an operator for the caller.
591      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
592      *
593      * Requirements:
594      *
595      * - The `operator` cannot be the caller.
596      *
597      * Emits an {ApprovalForAll} event.
598      */
599     function setApprovalForAll(address operator, bool _approved) external;
600 
601     /**
602      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
603      *
604      * See {setApprovalForAll}
605      */
606     function isApprovedForAll(address owner, address operator) external view returns (bool);
607 
608     /**
609      * @dev Safely transfers `tokenId` token from `from` to `to`.
610      *
611      * Requirements:
612      *
613      * - `from` cannot be the zero address.
614      * - `to` cannot be the zero address.
615      * - `tokenId` token must exist and be owned by `from`.
616      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
618      *
619      * Emits a {Transfer} event.
620      */
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId,
625         bytes calldata data
626     ) external;
627 }
628 
629 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
630 
631 
632 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 
637 /**
638  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
639  * @dev See https://eips.ethereum.org/EIPS/eip-721
640  */
641 interface IERC721Enumerable is IERC721 {
642     /**
643      * @dev Returns the total amount of tokens stored by the contract.
644      */
645     function totalSupply() external view returns (uint256);
646 
647     /**
648      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
649      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
650      */
651     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
652 
653     /**
654      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
655      * Use along with {totalSupply} to enumerate all tokens.
656      */
657     function tokenByIndex(uint256 index) external view returns (uint256);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
670  * @dev See https://eips.ethereum.org/EIPS/eip-721
671  */
672 interface IERC721Metadata is IERC721 {
673     /**
674      * @dev Returns the token collection name.
675      */
676     function name() external view returns (string memory);
677 
678     /**
679      * @dev Returns the token collection symbol.
680      */
681     function symbol() external view returns (string memory);
682 
683     /**
684      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
685      */
686     function tokenURI(uint256 tokenId) external view returns (string memory);
687 }
688 
689 // File: contracts/tgc1.sol
690 
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev These functions deal with verification of Merkle Trees proofs.
696  *
697  * The proofs can be generated using the JavaScript library
698  * https://github.com/miguelmota/merkletreejs[merkletreejs].
699  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
700  *
701  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
702  */
703 library MerkleProof {
704     /**
705      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
706      * defined by `root`. For this, a `proof` must be provided, containing
707      * sibling hashes on the branch from the leaf to the root of the tree. Each
708      * pair of leaves and each pair of pre-images are assumed to be sorted.
709      */
710     function verify(
711         bytes32[] memory proof,
712         bytes32 root,
713         bytes32 leaf
714     ) internal pure returns (bool) {
715         return processProof(proof, leaf) == root;
716     }
717 
718     /**
719      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
720      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
721      * hash matches the root of the tree. When processing the proof, the pairs
722      * of leafs & pre-images are assumed to be sorted.
723      *
724      * _Available since v4.4._
725      */
726     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
727         bytes32 computedHash = leaf;
728         for (uint256 i = 0; i < proof.length; i++) {
729             bytes32 proofElement = proof[i];
730             if (computedHash <= proofElement) {
731                 // Hash(current computed hash + current element of the proof)
732                 computedHash = _efficientHash(computedHash, proofElement);
733             } else {
734                 // Hash(current element of the proof + current computed hash)
735                 computedHash = _efficientHash(proofElement, computedHash);
736             }
737         }
738         return computedHash;
739     }
740 
741     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
742         assembly {
743             mstore(0x00, a)
744             mstore(0x20, b)
745             value := keccak256(0x00, 0x40)
746         }
747     }
748 }
749 
750 // Creator: Chiru Labs
751 
752 pragma solidity ^0.8.4;
753 
754 
755 
756 
757 
758 
759 
760 
761 
762 
763 
764 error ApprovalCallerNotOwnerNorApproved();
765 error ApprovalQueryForNonexistentToken();
766 error ApproveToCaller();
767 error ApprovalToCurrentOwner();
768 error BalanceQueryForZeroAddress();
769 error MintedQueryForZeroAddress();
770 error BurnedQueryForZeroAddress();
771 error MintToZeroAddress();
772 error MintZeroQuantity();
773 error OwnerIndexOutOfBounds();
774 error OwnerQueryForNonexistentToken();
775 error TokenIndexOutOfBounds();
776 error TransferCallerNotOwnerNorApproved();
777 error TransferFromIncorrectOwner();
778 error TransferToNonERC721ReceiverImplementer();
779 error TransferToZeroAddress();
780 error URIQueryForNonexistentToken();
781 
782 /**
783  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
784  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
785  *
786  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
787  *
788  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
789  *
790  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
791  */
792 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
793     using Address for address;
794     using Strings for uint256;
795 
796     // Compiler will pack this into a single 256bit word.
797     struct TokenOwnership {
798         // The address of the owner.
799         address addr;
800         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
801         uint64 startTimestamp;
802         // Whether the token has been burned.
803         bool burned;
804     }
805 
806     // Compiler will pack this into a single 256bit word.
807     struct AddressData {
808         // Realistically, 2**64-1 is more than enough.
809         uint64 balance;
810         // Keeps track of mint count with minimal overhead for tokenomics.
811         uint64 numberMinted;
812         // Keeps track of burn count with minimal overhead for tokenomics.
813         uint64 numberBurned;
814     }
815 
816     // Compiler will pack the following 
817     // _currentIndex and _burnCounter into a single 256bit word.
818     
819     // The tokenId of the next token to be minted.
820     uint128 internal _currentIndex;
821 
822     // The number of tokens burned.
823     uint128 internal _burnCounter;
824 
825     // Token name
826     string private _name;
827 
828     // Token symbol
829     string private _symbol;
830 
831     // Mapping from token ID to ownership details
832     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
833     mapping(uint256 => TokenOwnership) internal _ownerships;
834 
835     // Mapping owner address to address data
836     mapping(address => AddressData) private _addressData;
837 
838     // Mapping from token ID to approved address
839     mapping(uint256 => address) private _tokenApprovals;
840 
841     // Mapping from owner to operator approvals
842     mapping(address => mapping(address => bool)) private _operatorApprovals;
843 
844     constructor(string memory name_, string memory symbol_) {
845         _name = name_;
846         _symbol = symbol_;
847     }
848 
849     /**
850      * @dev See {IERC721Enumerable-totalSupply}.
851      */
852     function totalSupply() public view override returns (uint256) {
853         // Counter underflow is impossible as _burnCounter cannot be incremented
854         // more than _currentIndex times
855         unchecked {
856             return _currentIndex - _burnCounter;    
857         }
858     }
859 
860     /**
861      * @dev See {IERC721Enumerable-tokenByIndex}.
862      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
863      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
864      */
865     function tokenByIndex(uint256 index) public view override returns (uint256) {
866         uint256 numMintedSoFar = _currentIndex;
867         uint256 tokenIdsIdx;
868 
869         // Counter overflow is impossible as the loop breaks when
870         // uint256 i is equal to another uint256 numMintedSoFar.
871         unchecked {
872             for (uint256 i; i < numMintedSoFar; i++) {
873                 TokenOwnership memory ownership = _ownerships[i];
874                 if (!ownership.burned) {
875                     if (tokenIdsIdx == index) {
876                         return i;
877                     }
878                     tokenIdsIdx++;
879                 }
880             }
881         }
882         revert TokenIndexOutOfBounds();
883     }
884 
885     /**
886      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
887      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
888      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
889      */
890     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
891         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
892         uint256 numMintedSoFar = _currentIndex;
893         uint256 tokenIdsIdx;
894         address currOwnershipAddr;
895 
896         // Counter overflow is impossible as the loop breaks when
897         // uint256 i is equal to another uint256 numMintedSoFar.
898         unchecked {
899             for (uint256 i; i < numMintedSoFar; i++) {
900                 TokenOwnership memory ownership = _ownerships[i];
901                 if (ownership.burned) {
902                     continue;
903                 }
904                 if (ownership.addr != address(0)) {
905                     currOwnershipAddr = ownership.addr;
906                 }
907                 if (currOwnershipAddr == owner) {
908                     if (tokenIdsIdx == index) {
909                         return i;
910                     }
911                     tokenIdsIdx++;
912                 }
913             }
914         }
915 
916         // Execution should never reach this point.
917         revert();
918     }
919 
920     /**
921      * @dev See {IERC165-supportsInterface}.
922      */
923     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
924         return
925             interfaceId == type(IERC721).interfaceId ||
926             interfaceId == type(IERC721Metadata).interfaceId ||
927             interfaceId == type(IERC721Enumerable).interfaceId ||
928             super.supportsInterface(interfaceId);
929     }
930 
931     /**
932      * @dev See {IERC721-balanceOf}.
933      */
934     function balanceOf(address owner) public view override returns (uint256) {
935         if (owner == address(0)) revert BalanceQueryForZeroAddress();
936         return uint256(_addressData[owner].balance);
937     }
938 
939     function _numberMinted(address owner) internal view returns (uint256) {
940         if (owner == address(0)) revert MintedQueryForZeroAddress();
941         return uint256(_addressData[owner].numberMinted);
942     }
943 
944     function _numberBurned(address owner) internal view returns (uint256) {
945         if (owner == address(0)) revert BurnedQueryForZeroAddress();
946         return uint256(_addressData[owner].numberBurned);
947     }
948 
949     /**
950      * Gas spent here starts off proportional to the maximum mint batch size.
951      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
952      */
953     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
954         uint256 curr = tokenId;
955 
956         unchecked {
957             if (curr < _currentIndex) {
958                 TokenOwnership memory ownership = _ownerships[curr];
959                 if (!ownership.burned) {
960                     if (ownership.addr != address(0)) {
961                         return ownership;
962                     }
963                     // Invariant: 
964                     // There will always be an ownership that has an address and is not burned 
965                     // before an ownership that does not have an address and is not burned.
966                     // Hence, curr will not underflow.
967                     while (true) {
968                         curr--;
969                         ownership = _ownerships[curr];
970                         if (ownership.addr != address(0)) {
971                             return ownership;
972                         }
973                     }
974                 }
975             }
976         }
977         revert OwnerQueryForNonexistentToken();
978     }
979 
980     /**
981      * @dev See {IERC721-ownerOf}.
982      */
983     function ownerOf(uint256 tokenId) public view override returns (address) {
984         return ownershipOf(tokenId).addr;
985     }
986 
987     /**
988      * @dev See {IERC721Metadata-name}.
989      */
990     function name() public view virtual override returns (string memory) {
991         return _name;
992     }
993 
994     /**
995      * @dev See {IERC721Metadata-symbol}.
996      */
997     function symbol() public view virtual override returns (string memory) {
998         return _symbol;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-tokenURI}.
1003      */
1004     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1005         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1006 
1007         string memory baseURI = _baseURI();
1008         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1009     }
1010 
1011     /**
1012      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1013      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1014      * by default, can be overriden in child contracts.
1015      */
1016     function _baseURI() internal view virtual returns (string memory) {
1017         return '';
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-approve}.
1022      */
1023     function approve(address to, uint256 tokenId) public override {
1024         address owner = ERC721.ownerOf(tokenId);
1025         if (to == owner) revert ApprovalToCurrentOwner();
1026 
1027         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1028             revert ApprovalCallerNotOwnerNorApproved();
1029         }
1030 
1031         _approve(to, tokenId, owner);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-getApproved}.
1036      */
1037     function getApproved(uint256 tokenId) public view override returns (address) {
1038         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1039 
1040         return _tokenApprovals[tokenId];
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-setApprovalForAll}.
1045      */
1046     function setApprovalForAll(address operator, bool approved) public override {
1047         if (operator == _msgSender()) revert ApproveToCaller();
1048 
1049         _operatorApprovals[_msgSender()][operator] = approved;
1050         emit ApprovalForAll(_msgSender(), operator, approved);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-isApprovedForAll}.
1055      */
1056     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1057         return _operatorApprovals[owner][operator];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-transferFrom}.
1062      */
1063     function transferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) public virtual override {
1068         _transfer(from, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-safeTransferFrom}.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) public virtual override {
1079         safeTransferFrom(from, to, tokenId, '');
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-safeTransferFrom}.
1084      */
1085     function safeTransferFrom(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) public virtual override {
1091         _transfer(from, to, tokenId);
1092         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1093             revert TransferToNonERC721ReceiverImplementer();
1094         }
1095     }
1096 
1097     /**
1098      * @dev Returns whether `tokenId` exists.
1099      *
1100      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1101      *
1102      * Tokens start existing when they are minted (`_mint`),
1103      */
1104     function _exists(uint256 tokenId) internal view returns (bool) {
1105         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1106     }
1107 
1108     function _safeMint(address to, uint256 quantity) internal {
1109         _safeMint(to, quantity, '');
1110     }
1111 
1112     /**
1113      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1118      * - `quantity` must be greater than 0.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _safeMint(
1123         address to,
1124         uint256 quantity,
1125         bytes memory _data
1126     ) internal {
1127         _mint(to, quantity, _data, true);
1128     }
1129 
1130     /**
1131      * @dev Mints `quantity` tokens and transfers them to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - `to` cannot be the zero address.
1136      * - `quantity` must be greater than 0.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _mint(
1141         address to,
1142         uint256 quantity,
1143         bytes memory _data,
1144         bool safe
1145     ) internal {
1146         uint256 startTokenId = _currentIndex;
1147         if (to == address(0)) revert MintToZeroAddress();
1148         if (quantity == 0) revert MintZeroQuantity();
1149 
1150         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1151 
1152         // Overflows are incredibly unrealistic.
1153         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1154         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1155         unchecked {
1156             _addressData[to].balance += uint64(quantity);
1157             _addressData[to].numberMinted += uint64(quantity);
1158 
1159             _ownerships[startTokenId].addr = to;
1160             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1161 
1162             uint256 updatedIndex = startTokenId;
1163 
1164             for (uint256 i; i < quantity; i++) {
1165                 emit Transfer(address(0), to, updatedIndex);
1166                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1167                     revert TransferToNonERC721ReceiverImplementer();
1168                 }
1169                 updatedIndex++;
1170             }
1171 
1172             _currentIndex = uint128(updatedIndex);
1173         }
1174         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1175     }
1176 
1177     /**
1178      * @dev Transfers `tokenId` from `from` to `to`.
1179      *
1180      * Requirements:
1181      *
1182      * - `to` cannot be the zero address.
1183      * - `tokenId` token must be owned by `from`.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _transfer(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) private {
1192         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1193 
1194         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1195             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1196             getApproved(tokenId) == _msgSender());
1197 
1198         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1199         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1200         if (to == address(0)) revert TransferToZeroAddress();
1201 
1202         _beforeTokenTransfers(from, to, tokenId, 1);
1203 
1204         // Clear approvals from the previous owner
1205         _approve(address(0), tokenId, prevOwnership.addr);
1206 
1207         // Underflow of the sender's balance is impossible because we check for
1208         // ownership above and the recipient's balance can't realistically overflow.
1209         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1210         unchecked {
1211             _addressData[from].balance -= 1;
1212             _addressData[to].balance += 1;
1213 
1214             _ownerships[tokenId].addr = to;
1215             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1216 
1217             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1218             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1219             uint256 nextTokenId = tokenId + 1;
1220             if (_ownerships[nextTokenId].addr == address(0)) {
1221                 // This will suffice for checking _exists(nextTokenId),
1222                 // as a burned slot cannot contain the zero address.
1223                 if (nextTokenId < _currentIndex) {
1224                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1225                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1226                 }
1227             }
1228         }
1229 
1230         emit Transfer(from, to, tokenId);
1231         _afterTokenTransfers(from, to, tokenId, 1);
1232     }
1233 
1234     /**
1235      * @dev Destroys `tokenId`.
1236      * The approval is cleared when the token is burned.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _burn(uint256 tokenId) internal virtual {
1245         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1246 
1247         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1248 
1249         // Clear approvals from the previous owner
1250         _approve(address(0), tokenId, prevOwnership.addr);
1251 
1252         // Underflow of the sender's balance is impossible because we check for
1253         // ownership above and the recipient's balance can't realistically overflow.
1254         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1255         unchecked {
1256             _addressData[prevOwnership.addr].balance -= 1;
1257             _addressData[prevOwnership.addr].numberBurned += 1;
1258 
1259             // Keep track of who burned the token, and the timestamp of burning.
1260             _ownerships[tokenId].addr = prevOwnership.addr;
1261             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1262             _ownerships[tokenId].burned = true;
1263 
1264             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1265             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1266             uint256 nextTokenId = tokenId + 1;
1267             if (_ownerships[nextTokenId].addr == address(0)) {
1268                 // This will suffice for checking _exists(nextTokenId),
1269                 // as a burned slot cannot contain the zero address.
1270                 if (nextTokenId < _currentIndex) {
1271                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1272                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1273                 }
1274             }
1275         }
1276 
1277         emit Transfer(prevOwnership.addr, address(0), tokenId);
1278         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1279 
1280         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1281         unchecked { 
1282             _burnCounter++;
1283         }
1284     }
1285 
1286     /**
1287      * @dev Approve `to` to operate on `tokenId`
1288      *
1289      * Emits a {Approval} event.
1290      */
1291     function _approve(
1292         address to,
1293         uint256 tokenId,
1294         address owner
1295     ) private {
1296         _tokenApprovals[tokenId] = to;
1297         emit Approval(owner, to, tokenId);
1298     }
1299 
1300     /**
1301      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1302      * The call is not executed if the target address is not a contract.
1303      *
1304      * @param from address representing the previous owner of the given token ID
1305      * @param to target address that will receive the tokens
1306      * @param tokenId uint256 ID of the token to be transferred
1307      * @param _data bytes optional data to send along with the call
1308      * @return bool whether the call correctly returned the expected magic value
1309      */
1310     function _checkOnERC721Received(
1311         address from,
1312         address to,
1313         uint256 tokenId,
1314         bytes memory _data
1315     ) private returns (bool) {
1316         if (to.isContract()) {
1317             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1318                 return retval == IERC721Receiver(to).onERC721Received.selector;
1319             } catch (bytes memory reason) {
1320                 if (reason.length == 0) {
1321                     revert TransferToNonERC721ReceiverImplementer();
1322                 } else {
1323                     assembly {
1324                         revert(add(32, reason), mload(reason))
1325                     }
1326                 }
1327             }
1328         } else {
1329             return true;
1330         }
1331     }
1332 
1333     /**
1334      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1335      * And also called before burning one token.
1336      *
1337      * startTokenId - the first token id to be transferred
1338      * quantity - the amount to be transferred
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` will be minted for `to`.
1345      * - When `to` is zero, `tokenId` will be burned by `from`.
1346      * - `from` and `to` are never both zero.
1347      */
1348     function _beforeTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 
1355     /**
1356      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1357      * minting.
1358      * And also called after one token has been burned.
1359      *
1360      * startTokenId - the first token id to be transferred
1361      * quantity - the amount to be transferred
1362      *
1363      * Calling conditions:
1364      *
1365      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1366      * transferred to `to`.
1367      * - When `from` is zero, `tokenId` has been minted for `to`.
1368      * - When `to` is zero, `tokenId` has been burned by `from`.
1369      * - `from` and `to` are never both zero.
1370      */
1371     function _afterTokenTransfers(
1372         address from,
1373         address to,
1374         uint256 startTokenId,
1375         uint256 quantity
1376     ) internal virtual {}
1377 }
1378 
1379     pragma solidity ^0.8.7;
1380     contract Nubbies is ERC721,  Ownable {
1381     using Strings for uint256;
1382 
1383 
1384   string private uriPrefix = "";
1385   string private uriSuffix = ".json";
1386   string public hiddenMetadataUri;
1387 
1388   
1389   
1390 
1391   uint256 public cost = 0.098 ether;
1392   uint256 public whiteListCost = 0.098 ether;
1393 
1394   uint8 public maxWLMintAmountPerWallet = 1;  
1395  
1396   mapping (address => uint8) public txPerAddress;
1397   uint16 public constant maxSupply = 999;
1398   uint8 public maxMintAmountPerTx = 1;
1399                                                              
1400   bool public WLpaused = true;
1401   bool public paused = true;
1402   bool public reveal = false;
1403 
1404 
1405   
1406   bytes32 public whitelistMerkleRoot = 0x0;
1407   
1408 
1409   constructor() ERC721("Nubbies", "NS") {
1410 
1411   }
1412  
1413   function mint(uint8 _mintAmount) external payable  {
1414     uint totalSupply = totalSupply();
1415     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1416     require (txPerAddress[msg.sender] + _mintAmount <= maxMintAmountPerTx, "Exceeds max tx per address");
1417 
1418     require(!paused, "The contract is paused!");
1419     require(msg.value == cost * _mintAmount, "Insufficient funds!");
1420 
1421     _safeMint(msg.sender , _mintAmount);
1422       txPerAddress[msg.sender] += _mintAmount;
1423      
1424      delete totalSupply;
1425      delete _mintAmount;
1426   }
1427   
1428   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1429     uint totalSupply = totalSupply();
1430     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1431      _safeMint(msg.sender , _mintAmount);
1432      delete _mintAmount;
1433      delete _receiver;
1434      delete totalSupply;
1435   }
1436  
1437 
1438   function burn(uint _tokenID) external onlyOwner {
1439       _burn(_tokenID);
1440   }
1441 
1442 
1443    
1444   function tokenURI(uint256 _tokenId)
1445     public
1446     view
1447     virtual
1448     override
1449     returns (string memory)
1450   {
1451     require(
1452       _exists(_tokenId),
1453       "ERC721Metadata: URI query for nonexistent token"
1454     );
1455     
1456   
1457      if (reveal == false)
1458      {
1459         return hiddenMetadataUri;
1460      }
1461     
1462 
1463     string memory currentBaseURI = _baseURI();
1464     return bytes(currentBaseURI).length > 0
1465         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1466         : "";
1467   }
1468  
1469    function setWLPaused() external onlyOwner {
1470     WLpaused = !WLpaused;
1471   }
1472    function setReveal() external onlyOwner {
1473     reveal = !reveal;
1474   }
1475   function setWLCost(uint256 _cost) external onlyOwner {
1476     whiteListCost = _cost;
1477     delete _cost;
1478   }
1479   function setMaxTxPerWlAddress(uint8 _limit) external onlyOwner{
1480     maxWLMintAmountPerWallet = _limit;
1481    delete _limit;
1482 
1483 }
1484 function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1485         whitelistMerkleRoot = _whitelistMerkleRoot;
1486     }
1487 
1488     
1489     function getLeafNode(address _leaf) internal pure returns (bytes32 temp)
1490     {
1491         return keccak256(abi.encodePacked(_leaf));
1492     }
1493     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1494         return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1495     }
1496 
1497 function whitelistMint(uint8 _mintAmount, bytes32[] calldata merkleProof) external payable {
1498         
1499        bytes32  leafnode = getLeafNode(msg.sender);
1500        require(_verify(leafnode ,   merkleProof   ),  "Invalid merkle proof");
1501        require (txPerAddress[msg.sender] + _mintAmount <= maxWLMintAmountPerWallet, "Exceeds max tx per address");
1502       
1503 
1504 
1505     require(!WLpaused, "Whitelist minting is over!");
1506     require(msg.value == whiteListCost * _mintAmount, "Insufficient funds!");
1507 
1508       uint totalSupply = totalSupply();
1509      _safeMint(msg.sender , _mintAmount);
1510       txPerAddress[msg.sender] += _mintAmount;
1511       delete totalSupply;
1512       delete _mintAmount;
1513       
1514     
1515     }
1516 
1517   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1518     uriPrefix = _uriPrefix;
1519   }
1520   function setHiddenMetaDataUri(string memory _uri) external onlyOwner {
1521     hiddenMetadataUri = _uri;
1522   }
1523 
1524 
1525   function setPaused() external onlyOwner {
1526     paused = !paused;
1527   }
1528 
1529   function setCost(uint _cost) external onlyOwner{
1530       cost = _cost;
1531 
1532   }
1533 
1534 
1535   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1536       maxMintAmountPerTx = _maxtx;
1537 
1538   }
1539 
1540  
1541 
1542   function withdraw() external onlyOwner {
1543   uint _balance = address(this).balance;
1544      payable(0xb4E1B31Ea2395353A92c787fC0b591D6eD1E9E61).transfer(_balance * 70/100);
1545      payable(0x82418494Ab7F2fd60DA242D336a160CcAF4B2e2C).transfer(_balance * 30/100);
1546   }
1547 
1548 
1549   function _baseURI() internal view  override returns (string memory) {
1550     return uriPrefix;
1551   }
1552 }