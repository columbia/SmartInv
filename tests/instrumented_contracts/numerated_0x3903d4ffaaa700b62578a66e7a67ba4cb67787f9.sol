1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev Contract module that helps prevent reentrant calls to a function.
65  *
66  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
67  * available, which can be applied to functions to make sure there are no nested
68  * (reentrant) calls to them.
69  *
70  * Note that because there is a single `nonReentrant` guard, functions marked as
71  * `nonReentrant` may not call one another. This can be worked around by making
72  * those functions `private`, and then adding `external` `nonReentrant` entry
73  * points to them.
74  *
75  * TIP: If you would like to learn more about reentrancy and alternative ways
76  * to protect against it, check out our blog post
77  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
78  */
79 abstract contract ReentrancyGuard {
80     // Booleans are more expensive than uint256 or any type that takes up a full
81     // word because each write operation emits an extra SLOAD to first read the
82     // slot's contents, replace the bits taken up by the boolean, and then write
83     // back. This is the compiler's defense against contract upgrades and
84     // pointer aliasing, and it cannot be disabled.
85 
86     // The values being non-zero value makes deployment a bit more expensive,
87     // but in exchange the refund on every call to nonReentrant will be lower in
88     // amount. Since refunds are capped to a percentage of the total
89     // transaction's gas, it is best to keep them low in cases like this one, to
90     // increase the likelihood of the full refund coming into effect.
91     uint256 private constant _NOT_ENTERED = 1;
92     uint256 private constant _ENTERED = 2;
93 
94     uint256 private _status;
95 
96     constructor() {
97         _status = _NOT_ENTERED;
98     }
99 
100     /**
101      * @dev Prevents a contract from calling itself, directly or indirectly.
102      * Calling a `nonReentrant` function from another `nonReentrant`
103      * function is not supported. It is possible to prevent this from happening
104      * by making the `nonReentrant` function external, and making it call a
105      * `private` function that does the actual work.
106      */
107     modifier nonReentrant() {
108         // On the first call to nonReentrant, _notEntered will be true
109         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
110 
111         // Any calls to nonReentrant after this point will fail
112         _status = _ENTERED;
113 
114         _;
115 
116         // By storing the original value once again, a refund is triggered (see
117         // https://eips.ethereum.org/EIPS/eip-2200)
118         _status = _NOT_ENTERED;
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Strings.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev String operations.
131  */
132 library Strings {
133     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
137      */
138     function toString(uint256 value) internal pure returns (string memory) {
139         // Inspired by OraclizeAPI's implementation - MIT licence
140         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
141 
142         if (value == 0) {
143             return "0";
144         }
145         uint256 temp = value;
146         uint256 digits;
147         while (temp != 0) {
148             digits++;
149             temp /= 10;
150         }
151         bytes memory buffer = new bytes(digits);
152         while (value != 0) {
153             digits -= 1;
154             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
155             value /= 10;
156         }
157         return string(buffer);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
162      */
163     function toHexString(uint256 value) internal pure returns (string memory) {
164         if (value == 0) {
165             return "0x00";
166         }
167         uint256 temp = value;
168         uint256 length = 0;
169         while (temp != 0) {
170             length++;
171             temp >>= 8;
172         }
173         return toHexString(value, length);
174     }
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
178      */
179     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
180         bytes memory buffer = new bytes(2 * length + 2);
181         buffer[0] = "0";
182         buffer[1] = "x";
183         for (uint256 i = 2 * length + 1; i > 1; --i) {
184             buffer[i] = _HEX_SYMBOLS[value & 0xf];
185             value >>= 4;
186         }
187         require(value == 0, "Strings: hex length insufficient");
188         return string(buffer);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Address.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Collection of functions related to the address type
201  */
202 library Address {
203     /**
204      * @dev Returns true if `account` is a contract.
205      *
206      * [IMPORTANT]
207      * ====
208      * It is unsafe to assume that an address for which this function returns
209      * false is an externally-owned account (EOA) and not a contract.
210      *
211      * Among others, `isContract` will return false for the following
212      * types of addresses:
213      *
214      *  - an externally-owned account
215      *  - a contract in construction
216      *  - an address where a contract will be created
217      *  - an address where a contract lived, but was destroyed
218      * ====
219      */
220     function isContract(address account) internal view returns (bool) {
221         // This method relies on extcodesize, which returns 0 for contracts in
222         // construction, since the code is only stored at the end of the
223         // constructor execution.
224 
225         uint256 size;
226         assembly {
227             size := extcodesize(account)
228         }
229         return size > 0;
230     }
231 
232     /**
233      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
234      * `recipient`, forwarding all available gas and reverting on errors.
235      *
236      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
237      * of certain opcodes, possibly making contracts go over the 2300 gas limit
238      * imposed by `transfer`, making them unable to receive funds via
239      * `transfer`. {sendValue} removes this limitation.
240      *
241      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
242      *
243      * IMPORTANT: because control is transferred to `recipient`, care must be
244      * taken to not create reentrancy vulnerabilities. Consider using
245      * {ReentrancyGuard} or the
246      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
247      */
248     function sendValue(address payable recipient, uint256 amount) internal {
249         require(address(this).balance >= amount, "Address: insufficient balance");
250 
251         (bool success, ) = recipient.call{value: amount}("");
252         require(success, "Address: unable to send value, recipient may have reverted");
253     }
254 
255     /**
256      * @dev Performs a Solidity function call using a low level `call`. A
257      * plain `call` is an unsafe replacement for a function call: use this
258      * function instead.
259      *
260      * If `target` reverts with a revert reason, it is bubbled up by this
261      * function (like regular Solidity function calls).
262      *
263      * Returns the raw returned data. To convert to the expected return value,
264      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
265      *
266      * Requirements:
267      *
268      * - `target` must be a contract.
269      * - calling `target` with `data` must not revert.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionCall(target, data, "Address: low-level call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
279      * `errorMessage` as a fallback revert reason when `target` reverts.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, 0, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but also transferring `value` wei to `target`.
294      *
295      * Requirements:
296      *
297      * - the calling contract must have an ETH balance of at least `value`.
298      * - the called Solidity function must be `payable`.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(
303         address target,
304         bytes memory data,
305         uint256 value
306     ) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
312      * with `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(address(this).balance >= value, "Address: insufficient balance for call");
323         require(isContract(target), "Address: call to non-contract");
324 
325         (bool success, bytes memory returndata) = target.call{value: value}(data);
326         return verifyCallResult(success, returndata, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
336         return functionStaticCall(target, data, "Address: low-level static call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal view returns (bytes memory) {
350         require(isContract(target), "Address: static call to non-contract");
351 
352         (bool success, bytes memory returndata) = target.staticcall(data);
353         return verifyCallResult(success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(isContract(target), "Address: delegate call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.delegatecall(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
385      * revert reason using the provided one.
386      *
387      * _Available since v4.3._
388      */
389     function verifyCallResult(
390         bool success,
391         bytes memory returndata,
392         string memory errorMessage
393     ) internal pure returns (bytes memory) {
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 /**
420  * @title ERC721 token receiver interface
421  * @dev Interface for any contract that wants to support safeTransfers
422  * from ERC721 asset contracts.
423  */
424 interface IERC721Receiver {
425     /**
426      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
427      * by `operator` from `from`, this function is called.
428      *
429      * It must return its Solidity selector to confirm the token transfer.
430      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
431      *
432      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
433      */
434     function onERC721Received(
435         address operator,
436         address from,
437         uint256 tokenId,
438         bytes calldata data
439     ) external returns (bytes4);
440 }
441 
442 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Interface of the ERC165 standard, as defined in the
451  * https://eips.ethereum.org/EIPS/eip-165[EIP].
452  *
453  * Implementers can declare support of contract interfaces, which can then be
454  * queried by others ({ERC165Checker}).
455  *
456  * For an implementation, see {ERC165}.
457  */
458 interface IERC165 {
459     /**
460      * @dev Returns true if this contract implements the interface defined by
461      * `interfaceId`. See the corresponding
462      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
463      * to learn more about how these ids are created.
464      *
465      * This function call must use less than 30 000 gas.
466      */
467     function supportsInterface(bytes4 interfaceId) external view returns (bool);
468 }
469 
470 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Implementation of the {IERC165} interface.
480  *
481  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
482  * for the additional interface id that will be supported. For example:
483  *
484  * ```solidity
485  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
487  * }
488  * ```
489  *
490  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
491  */
492 abstract contract ERC165 is IERC165 {
493     /**
494      * @dev See {IERC165-supportsInterface}.
495      */
496     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497         return interfaceId == type(IERC165).interfaceId;
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Required interface of an ERC721 compliant contract.
511  */
512 interface IERC721 is IERC165 {
513     /**
514      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
515      */
516     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
520      */
521     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
522 
523     /**
524      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
525      */
526     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
527 
528     /**
529      * @dev Returns the number of tokens in ``owner``'s account.
530      */
531     function balanceOf(address owner) external view returns (uint256 balance);
532 
533     /**
534      * @dev Returns the owner of the `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function ownerOf(uint256 tokenId) external view returns (address owner);
541 
542     /**
543      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
544      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
545      *
546      * Requirements:
547      *
548      * - `from` cannot be the zero address.
549      * - `to` cannot be the zero address.
550      * - `tokenId` token must exist and be owned by `from`.
551      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
553      *
554      * Emits a {Transfer} event.
555      */
556     function safeTransferFrom(
557         address from,
558         address to,
559         uint256 tokenId
560     ) external;
561 
562     /**
563      * @dev Transfers `tokenId` token from `from` to `to`.
564      *
565      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must be owned by `from`.
572      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
573      *
574      * Emits a {Transfer} event.
575      */
576     function transferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) external;
581 
582     /**
583      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
584      * The approval is cleared when the token is transferred.
585      *
586      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
587      *
588      * Requirements:
589      *
590      * - The caller must own the token or be an approved operator.
591      * - `tokenId` must exist.
592      *
593      * Emits an {Approval} event.
594      */
595     function approve(address to, uint256 tokenId) external;
596 
597     /**
598      * @dev Returns the account approved for `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function getApproved(uint256 tokenId) external view returns (address operator);
605 
606     /**
607      * @dev Approve or remove `operator` as an operator for the caller.
608      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
609      *
610      * Requirements:
611      *
612      * - The `operator` cannot be the caller.
613      *
614      * Emits an {ApprovalForAll} event.
615      */
616     function setApprovalForAll(address operator, bool _approved) external;
617 
618     /**
619      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
620      *
621      * See {setApprovalForAll}
622      */
623     function isApprovedForAll(address owner, address operator) external view returns (bool);
624 
625     /**
626      * @dev Safely transfers `tokenId` token from `from` to `to`.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must exist and be owned by `from`.
633      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
634      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
635      *
636      * Emits a {Transfer} event.
637      */
638     function safeTransferFrom(
639         address from,
640         address to,
641         uint256 tokenId,
642         bytes calldata data
643     ) external;
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
647 
648 
649 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 
654 /**
655  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
656  * @dev See https://eips.ethereum.org/EIPS/eip-721
657  */
658 interface IERC721Metadata is IERC721 {
659     /**
660      * @dev Returns the token collection name.
661      */
662     function name() external view returns (string memory);
663 
664     /**
665      * @dev Returns the token collection symbol.
666      */
667     function symbol() external view returns (string memory);
668 
669     /**
670      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
671      */
672     function tokenURI(uint256 tokenId) external view returns (string memory);
673 }
674 
675 // File: @openzeppelin/contracts/utils/Context.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @dev Provides information about the current execution context, including the
684  * sender of the transaction and its data. While these are generally available
685  * via msg.sender and msg.data, they should not be accessed in such a direct
686  * manner, since when dealing with meta-transactions the account sending and
687  * paying for execution may not be the actual sender (as far as an application
688  * is concerned).
689  *
690  * This contract is only required for intermediate, library-like contracts.
691  */
692 abstract contract Context {
693     function _msgSender() internal view virtual returns (address) {
694         return msg.sender;
695     }
696 
697     function _msgData() internal view virtual returns (bytes calldata) {
698         return msg.data;
699     }
700 }
701 
702 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 
711 
712 
713 
714 
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata extension, but not including the Enumerable extension, which is available separately as
719  * {ERC721Enumerable}.
720  */
721 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
722     using Address for address;
723     using Strings for uint256;
724 
725     // Token name
726     string private _name;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Mapping from token ID to owner address
732     mapping(uint256 => address) private _owners;
733 
734     // Mapping owner address to token count
735     mapping(address => uint256) private _balances;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     /**
744      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
745      */
746     constructor(string memory name_, string memory symbol_) {
747         _name = name_;
748         _symbol = symbol_;
749     }
750 
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      */
754     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
755         return
756             interfaceId == type(IERC721).interfaceId ||
757             interfaceId == type(IERC721Metadata).interfaceId ||
758             super.supportsInterface(interfaceId);
759     }
760 
761     /**
762      * @dev See {IERC721-balanceOf}.
763      */
764     function balanceOf(address owner) public view virtual override returns (uint256) {
765         require(owner != address(0), "ERC721: balance query for the zero address");
766         return _balances[owner];
767     }
768 
769     /**
770      * @dev See {IERC721-ownerOf}.
771      */
772     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
773         address owner = _owners[tokenId];
774         require(owner != address(0), "ERC721: owner query for nonexistent token");
775         return owner;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-name}.
780      */
781     function name() public view virtual override returns (string memory) {
782         return _name;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-symbol}.
787      */
788     function symbol() public view virtual override returns (string memory) {
789         return _symbol;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-tokenURI}.
794      */
795     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
796         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
797 
798         string memory baseURI = _baseURI();
799         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
800     }
801 
802     /**
803      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
804      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
805      * by default, can be overriden in child contracts.
806      */
807     function _baseURI() internal view virtual returns (string memory) {
808         return "";
809     }
810 
811     /**
812      * @dev See {IERC721-approve}.
813      */
814     function approve(address to, uint256 tokenId) public virtual override {
815         address owner = ERC721.ownerOf(tokenId);
816         require(to != owner, "ERC721: approval to current owner");
817 
818         require(
819             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
820             "ERC721: approve caller is not owner nor approved for all"
821         );
822 
823         _approve(to, tokenId);
824     }
825 
826     /**
827      * @dev See {IERC721-getApproved}.
828      */
829     function getApproved(uint256 tokenId) public view virtual override returns (address) {
830         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
831 
832         return _tokenApprovals[tokenId];
833     }
834 
835     /**
836      * @dev See {IERC721-setApprovalForAll}.
837      */
838     function setApprovalForAll(address operator, bool approved) public virtual override {
839         _setApprovalForAll(_msgSender(), operator, approved);
840     }
841 
842     /**
843      * @dev See {IERC721-isApprovedForAll}.
844      */
845     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
846         return _operatorApprovals[owner][operator];
847     }
848 
849     /**
850      * @dev See {IERC721-transferFrom}.
851      */
852     function transferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         //solhint-disable-next-line max-line-length
858         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
859 
860         _transfer(from, to, tokenId);
861     }
862 
863     /**
864      * @dev See {IERC721-safeTransferFrom}.
865      */
866     function safeTransferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         safeTransferFrom(from, to, tokenId, "");
872     }
873 
874     /**
875      * @dev See {IERC721-safeTransferFrom}.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes memory _data
882     ) public virtual override {
883         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
884         _safeTransfer(from, to, tokenId, _data);
885     }
886 
887     /**
888      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
889      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
890      *
891      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
892      *
893      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
894      * implement alternative mechanisms to perform token transfer, such as signature-based.
895      *
896      * Requirements:
897      *
898      * - `from` cannot be the zero address.
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must exist and be owned by `from`.
901      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _safeTransfer(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) internal virtual {
911         _transfer(from, to, tokenId);
912         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
913     }
914 
915     /**
916      * @dev Returns whether `tokenId` exists.
917      *
918      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
919      *
920      * Tokens start existing when they are minted (`_mint`),
921      * and stop existing when they are burned (`_burn`).
922      */
923     function _exists(uint256 tokenId) internal view virtual returns (bool) {
924         return _owners[tokenId] != address(0);
925     }
926 
927     /**
928      * @dev Returns whether `spender` is allowed to manage `tokenId`.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must exist.
933      */
934     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
935         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
936         address owner = ERC721.ownerOf(tokenId);
937         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
938     }
939 
940     /**
941      * @dev Safely mints `tokenId` and transfers it to `to`.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must not exist.
946      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _safeMint(address to, uint256 tokenId) internal virtual {
951         _safeMint(to, tokenId, "");
952     }
953 
954     /**
955      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
956      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
957      */
958     function _safeMint(
959         address to,
960         uint256 tokenId,
961         bytes memory _data
962     ) internal virtual {
963         _mint(to, tokenId);
964         require(
965             _checkOnERC721Received(address(0), to, tokenId, _data),
966             "ERC721: transfer to non ERC721Receiver implementer"
967         );
968     }
969 
970     /**
971      * @dev Mints `tokenId` and transfers it to `to`.
972      *
973      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
974      *
975      * Requirements:
976      *
977      * - `tokenId` must not exist.
978      * - `to` cannot be the zero address.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _mint(address to, uint256 tokenId) internal virtual {
983         require(to != address(0), "ERC721: mint to the zero address");
984         require(!_exists(tokenId), "ERC721: token already minted");
985 
986         _beforeTokenTransfer(address(0), to, tokenId);
987 
988         _balances[to] += 1;
989         _owners[tokenId] = to;
990 
991         emit Transfer(address(0), to, tokenId);
992     }
993 
994     /**
995      * @dev Destroys `tokenId`.
996      * The approval is cleared when the token is burned.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _burn(uint256 tokenId) internal virtual {
1005         address owner = ERC721.ownerOf(tokenId);
1006 
1007         _beforeTokenTransfer(owner, address(0), tokenId);
1008 
1009         // Clear approvals
1010         _approve(address(0), tokenId);
1011 
1012         _balances[owner] -= 1;
1013         delete _owners[tokenId];
1014 
1015         emit Transfer(owner, address(0), tokenId);
1016     }
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must be owned by `from`.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _transfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) internal virtual {
1034         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1035         require(to != address(0), "ERC721: transfer to the zero address");
1036 
1037         _beforeTokenTransfer(from, to, tokenId);
1038 
1039         // Clear approvals from the previous owner
1040         _approve(address(0), tokenId);
1041 
1042         _balances[from] -= 1;
1043         _balances[to] += 1;
1044         _owners[tokenId] = to;
1045 
1046         emit Transfer(from, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Approve `to` to operate on `tokenId`
1051      *
1052      * Emits a {Approval} event.
1053      */
1054     function _approve(address to, uint256 tokenId) internal virtual {
1055         _tokenApprovals[tokenId] = to;
1056         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev Approve `operator` to operate on all of `owner` tokens
1061      *
1062      * Emits a {ApprovalForAll} event.
1063      */
1064     function _setApprovalForAll(
1065         address owner,
1066         address operator,
1067         bool approved
1068     ) internal virtual {
1069         require(owner != operator, "ERC721: approve to caller");
1070         _operatorApprovals[owner][operator] = approved;
1071         emit ApprovalForAll(owner, operator, approved);
1072     }
1073 
1074     /**
1075      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1076      * The call is not executed if the target address is not a contract.
1077      *
1078      * @param from address representing the previous owner of the given token ID
1079      * @param to target address that will receive the tokens
1080      * @param tokenId uint256 ID of the token to be transferred
1081      * @param _data bytes optional data to send along with the call
1082      * @return bool whether the call correctly returned the expected magic value
1083      */
1084     function _checkOnERC721Received(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) private returns (bool) {
1090         if (to.isContract()) {
1091             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1092                 return retval == IERC721Receiver.onERC721Received.selector;
1093             } catch (bytes memory reason) {
1094                 if (reason.length == 0) {
1095                     revert("ERC721: transfer to non ERC721Receiver implementer");
1096                 } else {
1097                     assembly {
1098                         revert(add(32, reason), mload(reason))
1099                     }
1100                 }
1101             }
1102         } else {
1103             return true;
1104         }
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before any token transfer. This includes minting
1109      * and burning.
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` will be minted for `to`.
1116      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1117      * - `from` and `to` are never both zero.
1118      *
1119      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1120      */
1121     function _beforeTokenTransfer(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) internal virtual {}
1126 }
1127 
1128 // File: @openzeppelin/contracts/access/Ownable.sol
1129 
1130 
1131 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1132 
1133 pragma solidity ^0.8.0;
1134 
1135 
1136 /**
1137  * @dev Contract module which provides a basic access control mechanism, where
1138  * there is an account (an owner) that can be granted exclusive access to
1139  * specific functions.
1140  *
1141  * By default, the owner account will be the one that deploys the contract. This
1142  * can later be changed with {transferOwnership}.
1143  *
1144  * This module is used through inheritance. It will make available the modifier
1145  * `onlyOwner`, which can be applied to your functions to restrict their use to
1146  * the owner.
1147  */
1148 abstract contract Ownable is Context {
1149     address private _owner;
1150 
1151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1152 
1153     /**
1154      * @dev Initializes the contract setting the deployer as the initial owner.
1155      */
1156     constructor() {
1157         _transferOwnership(_msgSender());
1158     }
1159 
1160     /**
1161      * @dev Returns the address of the current owner.
1162      */
1163     function owner() public view virtual returns (address) {
1164         return _owner;
1165     }
1166 
1167     /**
1168      * @dev Throws if called by any account other than the owner.
1169      */
1170     modifier onlyOwner() {
1171         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1172         _;
1173     }
1174 
1175     /**
1176      * @dev Leaves the contract without owner. It will not be possible to call
1177      * `onlyOwner` functions anymore. Can only be called by the current owner.
1178      *
1179      * NOTE: Renouncing ownership will leave the contract without an owner,
1180      * thereby removing any functionality that is only available to the owner.
1181      */
1182     function renounceOwnership() public virtual onlyOwner {
1183         _transferOwnership(address(0));
1184     }
1185 
1186     /**
1187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1188      * Can only be called by the current owner.
1189      */
1190     function transferOwnership(address newOwner) public virtual onlyOwner {
1191         require(newOwner != address(0), "Ownable: new owner is the zero address");
1192         _transferOwnership(newOwner);
1193     }
1194 
1195     /**
1196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1197      * Internal function without access restriction.
1198      */
1199     function _transferOwnership(address newOwner) internal virtual {
1200         address oldOwner = _owner;
1201         _owner = newOwner;
1202         emit OwnershipTransferred(oldOwner, newOwner);
1203     }
1204 }
1205 
1206 // File: Quirkies.sol
1207 
1208 
1209 pragma solidity 0.8.11;
1210 
1211 
1212 
1213 
1214 
1215 contract Quirkies is Ownable, ERC721, ReentrancyGuard {
1216     uint256 public nftPrice = 0.05 ether;
1217     uint256 public totalSupply = 0;
1218 
1219     uint256 public nftLimit = 5000;
1220     uint256 public reserved = 50;
1221     uint256 public capWhitelist = 2;
1222     uint256 public capPublic = 5;
1223 
1224     bool public saleWhitelist = false;
1225     bool public salePublic = false;
1226 
1227     bytes32 public merkleRoot;
1228 
1229     string public baseURI = "";
1230 
1231     mapping(address => uint256) public presaleAddresses;
1232 
1233     constructor(string memory _initURI, bytes32 _merkleRoot)
1234         ERC721("Quirkies", "QRKS")
1235     {
1236         baseURI = _initURI;
1237         merkleRoot = _merkleRoot;
1238     }
1239 
1240     function mint(uint256 _amount) public payable nonReentrant {
1241         require(salePublic == true, "Quirkies: Not Started");
1242         require(_amount <= capPublic, "Quirkies: Amount Limit");
1243         require(
1244             totalSupply + _amount <= (nftLimit - reserved),
1245             "Quirkies: Sold Out"
1246         );
1247         _mint(_amount);
1248     }
1249 
1250     function mintWhitelist(uint256 _amount, bytes32[] calldata proof)
1251         public
1252         payable
1253         nonReentrant
1254     {
1255         require(saleWhitelist == true, "Quirkies: Not Started");
1256         require(
1257             MerkleProof.verify(
1258                 proof,
1259                 merkleRoot,
1260                 keccak256(abi.encodePacked(_msgSender()))
1261             ),
1262             "Quirkies: Not Whitelisted"
1263         );
1264         require(
1265             presaleAddresses[_msgSender()] + _amount <= capWhitelist,
1266             "Quirkies: Amount Limit"
1267         );
1268         _mint(_amount);
1269         presaleAddresses[_msgSender()] += _amount;
1270     }
1271 
1272     function _mint(uint256 _amount) internal {
1273         require(tx.origin == msg.sender, "Quirkies: Self Mint Only");
1274         require(
1275             totalSupply + _amount <= (nftLimit - reserved),
1276             "Quirkies: Sold Out"
1277         );
1278         require(msg.value == nftPrice * _amount, "Quirkies: Incorrect Value");
1279         for (uint256 i = 0; i < _amount; i++) {
1280             _safeMint(_msgSender(), totalSupply);
1281             totalSupply++;
1282         }
1283     }
1284 
1285     function reserve(address[] calldata _tos) external onlyOwner nonReentrant {
1286         require(totalSupply + _tos.length <= nftLimit, "Quirkies: Sold Out");
1287         for (uint256 i = 0; i < _tos.length; i++) {
1288             _safeMint(_tos[i], totalSupply);
1289             totalSupply++;
1290             if (reserved > 0) {
1291                 reserved--;
1292             }
1293         }
1294     }
1295 
1296     function tokensOfOwnerByIndex(address _owner, uint256 _index)
1297         public
1298         view
1299         returns (uint256)
1300     {
1301         return tokensOfOwner(_owner)[_index];
1302     }
1303 
1304     function tokensOfOwner(address _owner)
1305         public
1306         view
1307         returns (uint256[] memory)
1308     {
1309         uint256 _tokenCount = balanceOf(_owner);
1310         uint256[] memory _tokenIds = new uint256[](_tokenCount);
1311         uint256 _tokenIndex = 0;
1312         for (uint256 i = 0; i < totalSupply; i++) {
1313             if (ownerOf(i) == _owner) {
1314                 _tokenIds[_tokenIndex] = i;
1315                 _tokenIndex++;
1316             }
1317         }
1318         return _tokenIds;
1319     }
1320 
1321     function withdraw() public payable onlyOwner {
1322         uint256 _balance = address(this).balance;
1323         address TEAM5 = 0x1350BAA348fC0139999C40e5b80FdC26617E3F67;
1324         address TEAM4 = 0xec19a74D69329C531B133b6Ad752F5EdebDbdBC5;
1325         address TEAM3 = 0x74faad5e1f9a5B8427F33D5c8924870c949488f7;
1326         address TEAM2 = 0x761C9BDE27449415C924C64528BFaA01fbC68A6D;
1327         address TEAM1 = 0x816639f88d7f5405b0CCB0582908b388a1e2c8Bd;
1328 
1329         (bool t5tx, ) = payable(TEAM5).call{value: (_balance * 10) / 100}("");
1330         require(t5tx, "Quirkies: Transfer 5 Failed");
1331 
1332         (bool t4tx, ) = payable(TEAM4).call{value: (_balance * 5) / 100}("");
1333         require(t4tx, "Quirkies: Transfer 4 Failed");
1334 
1335         (bool team3tx, ) = payable(TEAM3).call{value: (_balance * 5) / 100}("");
1336         require(team3tx, "Quirkies: Transfer 3 Failed");
1337 
1338         (bool team2tx, ) = payable(TEAM2).call{value: (_balance * 5) / 100}("");
1339         require(team2tx, "Quirkies: Transfer 2 Failed");
1340 
1341         (bool _team1tx, ) = payable(TEAM1).call{value: address(this).balance}(
1342             ""
1343         );
1344         require(_team1tx, "Quirkies: Transfer 1 Failed");
1345     }
1346 
1347     function toggleSaleWhitelist() public onlyOwner {
1348         saleWhitelist = !saleWhitelist;
1349     }
1350 
1351     function toggleSalePublic() public onlyOwner {
1352         salePublic = !salePublic;
1353     }
1354 
1355     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1356         baseURI = _newBaseURI;
1357     }
1358 
1359     function setNftPrice(uint256 _nftPrice) public onlyOwner {
1360         nftPrice = _nftPrice;
1361     }
1362 
1363     function setNftLimit(uint256 _nftLimit) public onlyOwner {
1364         nftLimit = _nftLimit;
1365     }
1366 
1367     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1368         merkleRoot = _merkleRoot;
1369     }
1370 
1371     function _baseURI() internal view virtual override returns (string memory) {
1372         return baseURI;
1373     }
1374 
1375     function contractURI() public view returns (string memory) {
1376         return string(abi.encodePacked(baseURI, "contract"));
1377     }
1378 }