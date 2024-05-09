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
56 // File: @openzeppelin/contracts/utils/Strings.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev String operations.
65  */
66 library Strings {
67     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
71      */
72     function toString(uint256 value) internal pure returns (string memory) {
73         // Inspired by OraclizeAPI's implementation - MIT licence
74         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
75 
76         if (value == 0) {
77             return "0";
78         }
79         uint256 temp = value;
80         uint256 digits;
81         while (temp != 0) {
82             digits++;
83             temp /= 10;
84         }
85         bytes memory buffer = new bytes(digits);
86         while (value != 0) {
87             digits -= 1;
88             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
89             value /= 10;
90         }
91         return string(buffer);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
96      */
97     function toHexString(uint256 value) internal pure returns (string memory) {
98         if (value == 0) {
99             return "0x00";
100         }
101         uint256 temp = value;
102         uint256 length = 0;
103         while (temp != 0) {
104             length++;
105             temp >>= 8;
106         }
107         return toHexString(value, length);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
112      */
113     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
114         bytes memory buffer = new bytes(2 * length + 2);
115         buffer[0] = "0";
116         buffer[1] = "x";
117         for (uint256 i = 2 * length + 1; i > 1; --i) {
118             buffer[i] = _HEX_SYMBOLS[value & 0xf];
119             value >>= 4;
120         }
121         require(value == 0, "Strings: hex length insufficient");
122         return string(buffer);
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Address.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Collection of functions related to the address type
135  */
136 library Address {
137     /**
138      * @dev Returns true if `account` is a contract.
139      *
140      * [IMPORTANT]
141      * ====
142      * It is unsafe to assume that an address for which this function returns
143      * false is an externally-owned account (EOA) and not a contract.
144      *
145      * Among others, `isContract` will return false for the following
146      * types of addresses:
147      *
148      *  - an externally-owned account
149      *  - a contract in construction
150      *  - an address where a contract will be created
151      *  - an address where a contract lived, but was destroyed
152      * ====
153      */
154     function isContract(address account) internal view returns (bool) {
155         // This method relies on extcodesize, which returns 0 for contracts in
156         // construction, since the code is only stored at the end of the
157         // constructor execution.
158 
159         uint256 size;
160         assembly {
161             size := extcodesize(account)
162         }
163         return size > 0;
164     }
165 
166     /**
167      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
168      * `recipient`, forwarding all available gas and reverting on errors.
169      *
170      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
171      * of certain opcodes, possibly making contracts go over the 2300 gas limit
172      * imposed by `transfer`, making them unable to receive funds via
173      * `transfer`. {sendValue} removes this limitation.
174      *
175      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
176      *
177      * IMPORTANT: because control is transferred to `recipient`, care must be
178      * taken to not create reentrancy vulnerabilities. Consider using
179      * {ReentrancyGuard} or the
180      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
181      */
182     function sendValue(address payable recipient, uint256 amount) internal {
183         require(address(this).balance >= amount, "Address: insufficient balance");
184 
185         (bool success, ) = recipient.call{value: amount}("");
186         require(success, "Address: unable to send value, recipient may have reverted");
187     }
188 
189     /**
190      * @dev Performs a Solidity function call using a low level `call`. A
191      * plain `call` is an unsafe replacement for a function call: use this
192      * function instead.
193      *
194      * If `target` reverts with a revert reason, it is bubbled up by this
195      * function (like regular Solidity function calls).
196      *
197      * Returns the raw returned data. To convert to the expected return value,
198      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
199      *
200      * Requirements:
201      *
202      * - `target` must be a contract.
203      * - calling `target` with `data` must not revert.
204      *
205      * _Available since v3.1._
206      */
207     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
208         return functionCall(target, data, "Address: low-level call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
213      * `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         return functionCallWithValue(target, data, 0, errorMessage);
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227      * but also transferring `value` wei to `target`.
228      *
229      * Requirements:
230      *
231      * - the calling contract must have an ETH balance of at least `value`.
232      * - the called Solidity function must be `payable`.
233      *
234      * _Available since v3.1._
235      */
236     function functionCallWithValue(
237         address target,
238         bytes memory data,
239         uint256 value
240     ) internal returns (bytes memory) {
241         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
246      * with `errorMessage` as a fallback revert reason when `target` reverts.
247      *
248      * _Available since v3.1._
249      */
250     function functionCallWithValue(
251         address target,
252         bytes memory data,
253         uint256 value,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(address(this).balance >= value, "Address: insufficient balance for call");
257         require(isContract(target), "Address: call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.call{value: value}(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
270         return functionStaticCall(target, data, "Address: low-level static call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
275      * but performing a static call.
276      *
277      * _Available since v3.3._
278      */
279     function functionStaticCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal view returns (bytes memory) {
284         require(isContract(target), "Address: static call to non-contract");
285 
286         (bool success, bytes memory returndata) = target.staticcall(data);
287         return verifyCallResult(success, returndata, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but performing a delegate call.
293      *
294      * _Available since v3.4._
295      */
296     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
297         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
302      * but performing a delegate call.
303      *
304      * _Available since v3.4._
305      */
306     function functionDelegateCall(
307         address target,
308         bytes memory data,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(isContract(target), "Address: delegate call to non-contract");
312 
313         (bool success, bytes memory returndata) = target.delegatecall(data);
314         return verifyCallResult(success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
319      * revert reason using the provided one.
320      *
321      * _Available since v4.3._
322      */
323     function verifyCallResult(
324         bool success,
325         bytes memory returndata,
326         string memory errorMessage
327     ) internal pure returns (bytes memory) {
328         if (success) {
329             return returndata;
330         } else {
331             // Look for revert reason and bubble it up if present
332             if (returndata.length > 0) {
333                 // The easiest way to bubble the revert reason is using memory via assembly
334 
335                 assembly {
336                     let returndata_size := mload(returndata)
337                     revert(add(32, returndata), returndata_size)
338                 }
339             } else {
340                 revert(errorMessage);
341             }
342         }
343     }
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @title ERC721 token receiver interface
355  * @dev Interface for any contract that wants to support safeTransfers
356  * from ERC721 asset contracts.
357  */
358 interface IERC721Receiver {
359     /**
360      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
361      * by `operator` from `from`, this function is called.
362      *
363      * It must return its Solidity selector to confirm the token transfer.
364      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
365      *
366      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
367      */
368     function onERC721Received(
369         address operator,
370         address from,
371         uint256 tokenId,
372         bytes calldata data
373     ) external returns (bytes4);
374 }
375 
376 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 /**
384  * @dev Interface of the ERC165 standard, as defined in the
385  * https://eips.ethereum.org/EIPS/eip-165[EIP].
386  *
387  * Implementers can declare support of contract interfaces, which can then be
388  * queried by others ({ERC165Checker}).
389  *
390  * For an implementation, see {ERC165}.
391  */
392 interface IERC165 {
393     /**
394      * @dev Returns true if this contract implements the interface defined by
395      * `interfaceId`. See the corresponding
396      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
397      * to learn more about how these ids are created.
398      *
399      * This function call must use less than 30 000 gas.
400      */
401     function supportsInterface(bytes4 interfaceId) external view returns (bool);
402 }
403 
404 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 
412 /**
413  * @dev Implementation of the {IERC165} interface.
414  *
415  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
416  * for the additional interface id that will be supported. For example:
417  *
418  * ```solidity
419  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
420  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
421  * }
422  * ```
423  *
424  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
425  */
426 abstract contract ERC165 is IERC165 {
427     /**
428      * @dev See {IERC165-supportsInterface}.
429      */
430     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431         return interfaceId == type(IERC165).interfaceId;
432     }
433 }
434 
435 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 
443 /**
444  * @dev Required interface of an ERC721 compliant contract.
445  */
446 interface IERC721 is IERC165 {
447     /**
448      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
449      */
450     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
451 
452     /**
453      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
454      */
455     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
456 
457     /**
458      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
459      */
460     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
461 
462     /**
463      * @dev Returns the number of tokens in ``owner``'s account.
464      */
465     function balanceOf(address owner) external view returns (uint256 balance);
466 
467     /**
468      * @dev Returns the owner of the `tokenId` token.
469      *
470      * Requirements:
471      *
472      * - `tokenId` must exist.
473      */
474     function ownerOf(uint256 tokenId) external view returns (address owner);
475 
476     /**
477      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
478      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must exist and be owned by `from`.
485      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
486      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
487      *
488      * Emits a {Transfer} event.
489      */
490     function safeTransferFrom(
491         address from,
492         address to,
493         uint256 tokenId
494     ) external;
495 
496     /**
497      * @dev Transfers `tokenId` token from `from` to `to`.
498      *
499      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
507      *
508      * Emits a {Transfer} event.
509      */
510     function transferFrom(
511         address from,
512         address to,
513         uint256 tokenId
514     ) external;
515 
516     /**
517      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
518      * The approval is cleared when the token is transferred.
519      *
520      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
521      *
522      * Requirements:
523      *
524      * - The caller must own the token or be an approved operator.
525      * - `tokenId` must exist.
526      *
527      * Emits an {Approval} event.
528      */
529     function approve(address to, uint256 tokenId) external;
530 
531     /**
532      * @dev Returns the account approved for `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function getApproved(uint256 tokenId) external view returns (address operator);
539 
540     /**
541      * @dev Approve or remove `operator` as an operator for the caller.
542      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
543      *
544      * Requirements:
545      *
546      * - The `operator` cannot be the caller.
547      *
548      * Emits an {ApprovalForAll} event.
549      */
550     function setApprovalForAll(address operator, bool _approved) external;
551 
552     /**
553      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
554      *
555      * See {setApprovalForAll}
556      */
557     function isApprovedForAll(address owner, address operator) external view returns (bool);
558 
559     /**
560      * @dev Safely transfers `tokenId` token from `from` to `to`.
561      *
562      * Requirements:
563      *
564      * - `from` cannot be the zero address.
565      * - `to` cannot be the zero address.
566      * - `tokenId` token must exist and be owned by `from`.
567      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 tokenId,
576         bytes calldata data
577     ) external;
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
581 
582 
583 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 /**
589  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
590  * @dev See https://eips.ethereum.org/EIPS/eip-721
591  */
592 interface IERC721Enumerable is IERC721 {
593     /**
594      * @dev Returns the total amount of tokens stored by the contract.
595      */
596     function totalSupply() external view returns (uint256);
597 
598     /**
599      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
600      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
601      */
602     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
603 
604     /**
605      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
606      * Use along with {totalSupply} to enumerate all tokens.
607      */
608     function tokenByIndex(uint256 index) external view returns (uint256);
609 }
610 
611 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
612 
613 
614 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
621  * @dev See https://eips.ethereum.org/EIPS/eip-721
622  */
623 interface IERC721Metadata is IERC721 {
624     /**
625      * @dev Returns the token collection name.
626      */
627     function name() external view returns (string memory);
628 
629     /**
630      * @dev Returns the token collection symbol.
631      */
632     function symbol() external view returns (string memory);
633 
634     /**
635      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
636      */
637     function tokenURI(uint256 tokenId) external view returns (string memory);
638 }
639 
640 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
641 
642 
643 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 /**
648  * @dev Contract module that helps prevent reentrant calls to a function.
649  *
650  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
651  * available, which can be applied to functions to make sure there are no nested
652  * (reentrant) calls to them.
653  *
654  * Note that because there is a single `nonReentrant` guard, functions marked as
655  * `nonReentrant` may not call one another. This can be worked around by making
656  * those functions `private`, and then adding `external` `nonReentrant` entry
657  * points to them.
658  *
659  * TIP: If you would like to learn more about reentrancy and alternative ways
660  * to protect against it, check out our blog post
661  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
662  */
663 abstract contract ReentrancyGuard {
664     // Booleans are more expensive than uint256 or any type that takes up a full
665     // word because each write operation emits an extra SLOAD to first read the
666     // slot's contents, replace the bits taken up by the boolean, and then write
667     // back. This is the compiler's defense against contract upgrades and
668     // pointer aliasing, and it cannot be disabled.
669 
670     // The values being non-zero value makes deployment a bit more expensive,
671     // but in exchange the refund on every call to nonReentrant will be lower in
672     // amount. Since refunds are capped to a percentage of the total
673     // transaction's gas, it is best to keep them low in cases like this one, to
674     // increase the likelihood of the full refund coming into effect.
675     uint256 private constant _NOT_ENTERED = 1;
676     uint256 private constant _ENTERED = 2;
677 
678     uint256 private _status;
679 
680     constructor() {
681         _status = _NOT_ENTERED;
682     }
683 
684     /**
685      * @dev Prevents a contract from calling itself, directly or indirectly.
686      * Calling a `nonReentrant` function from another `nonReentrant`
687      * function is not supported. It is possible to prevent this from happening
688      * by making the `nonReentrant` function external, and making it call a
689      * `private` function that does the actual work.
690      */
691     modifier nonReentrant() {
692         // On the first call to nonReentrant, _notEntered will be true
693         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
694 
695         // Any calls to nonReentrant after this point will fail
696         _status = _ENTERED;
697 
698         _;
699 
700         // By storing the original value once again, a refund is triggered (see
701         // https://eips.ethereum.org/EIPS/eip-2200)
702         _status = _NOT_ENTERED;
703     }
704 }
705 
706 // File: @openzeppelin/contracts/utils/Context.sol
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
710 
711 pragma solidity ^0.8.0;
712 
713 /**
714  * @dev Provides information about the current execution context, including the
715  * sender of the transaction and its data. While these are generally available
716  * via msg.sender and msg.data, they should not be accessed in such a direct
717  * manner, since when dealing with meta-transactions the account sending and
718  * paying for execution may not be the actual sender (as far as an application
719  * is concerned).
720  *
721  * This contract is only required for intermediate, library-like contracts.
722  */
723 abstract contract Context {
724     function _msgSender() internal view virtual returns (address) {
725         return msg.sender;
726     }
727 
728     function _msgData() internal view virtual returns (bytes calldata) {
729         return msg.data;
730     }
731 }
732 
733 // File: ERC721A.sol
734 
735 
736 
737 pragma solidity ^0.8.0;
738 
739 
740 
741 
742 
743 
744 
745 
746 
747 /**
748  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
749  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
750  *
751  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
752  *
753  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
754  *
755  * Does not support burning tokens to address(0).
756  */
757 contract ERC721A is
758   Context,
759   ERC165,
760   IERC721,
761   IERC721Metadata,
762   IERC721Enumerable
763 {
764   using Address for address;
765   using Strings for uint256;
766 
767   struct TokenOwnership {
768     address addr;
769     uint64 startTimestamp;
770   }
771 
772   struct AddressData {
773     uint128 balance;
774     uint128 numberMinted;
775   }
776 
777   uint256 private currentIndex = 0;
778 
779   uint256 internal immutable collectionSize;
780   uint256 internal immutable maxBatchSize;
781 
782   // Token name
783   string private _name;
784 
785   // Token symbol
786   string private _symbol;
787 
788   // Mapping from token ID to ownership details
789   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
790   mapping(uint256 => TokenOwnership) private _ownerships;
791 
792   // Mapping owner address to address data
793   mapping(address => AddressData) private _addressData;
794 
795   // Mapping from token ID to approved address
796   mapping(uint256 => address) private _tokenApprovals;
797 
798   // Mapping from owner to operator approvals
799   mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801   /**
802    * @dev
803    * `maxBatchSize` refers to how much a minter can mint at a time.
804    * `collectionSize_` refers to how many tokens are in the collection.
805    */
806   constructor(
807     string memory name_,
808     string memory symbol_,
809     uint256 maxBatchSize_,
810     uint256 collectionSize_
811   ) {
812     require(
813       collectionSize_ > 0,
814       "ERC721A: collection must have a nonzero supply"
815     );
816     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
817     _name = name_;
818     _symbol = symbol_;
819     maxBatchSize = maxBatchSize_;
820     collectionSize = collectionSize_;
821   }
822 
823   /**
824    * @dev See {IERC721Enumerable-totalSupply}.
825    */
826   function totalSupply() public view override returns (uint256) {
827     return currentIndex;
828   }
829 
830   /**
831    * @dev See {IERC721Enumerable-tokenByIndex}.
832    */
833   function tokenByIndex(uint256 index) public view override returns (uint256) {
834     require(index < totalSupply(), "ERC721A: global index out of bounds");
835     return index;
836   }
837 
838   /**
839    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
840    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
841    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
842    */
843   function tokenOfOwnerByIndex(address owner, uint256 index)
844     public
845     view
846     override
847     returns (uint256)
848   {
849     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
850     uint256 numMintedSoFar = totalSupply();
851     uint256 tokenIdsIdx = 0;
852     address currOwnershipAddr = address(0);
853     for (uint256 i = 0; i < numMintedSoFar; i++) {
854       TokenOwnership memory ownership = _ownerships[i];
855       if (ownership.addr != address(0)) {
856         currOwnershipAddr = ownership.addr;
857       }
858       if (currOwnershipAddr == owner) {
859         if (tokenIdsIdx == index) {
860           return i;
861         }
862         tokenIdsIdx++;
863       }
864     }
865     revert("ERC721A: unable to get token of owner by index");
866   }
867 
868   /**
869    * @dev See {IERC165-supportsInterface}.
870    */
871   function supportsInterface(bytes4 interfaceId)
872     public
873     view
874     virtual
875     override(ERC165, IERC165)
876     returns (bool)
877   {
878     return
879       interfaceId == type(IERC721).interfaceId ||
880       interfaceId == type(IERC721Metadata).interfaceId ||
881       interfaceId == type(IERC721Enumerable).interfaceId ||
882       super.supportsInterface(interfaceId);
883   }
884 
885   /**
886    * @dev See {IERC721-balanceOf}.
887    */
888   function balanceOf(address owner) public view override returns (uint256) {
889     require(owner != address(0), "ERC721A: balance query for the zero address");
890     return uint256(_addressData[owner].balance);
891   }
892 
893   function _numberMinted(address owner) internal view returns (uint256) {
894     require(
895       owner != address(0),
896       "ERC721A: number minted query for the zero address"
897     );
898     return uint256(_addressData[owner].numberMinted);
899   }
900 
901   function ownershipOf(uint256 tokenId)
902     internal
903     view
904     returns (TokenOwnership memory)
905   {
906     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
907 
908     uint256 lowestTokenToCheck;
909     if (tokenId >= maxBatchSize) {
910       lowestTokenToCheck = tokenId - maxBatchSize + 1;
911     }
912 
913     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
914       TokenOwnership memory ownership = _ownerships[curr];
915       if (ownership.addr != address(0)) {
916         return ownership;
917       }
918     }
919 
920     revert("ERC721A: unable to determine the owner of token");
921   }
922 
923   /**
924    * @dev See {IERC721-ownerOf}.
925    */
926   function ownerOf(uint256 tokenId) public view override returns (address) {
927     return ownershipOf(tokenId).addr;
928   }
929 
930   /**
931    * @dev See {IERC721Metadata-name}.
932    */
933   function name() public view virtual override returns (string memory) {
934     return _name;
935   }
936 
937   /**
938    * @dev See {IERC721Metadata-symbol}.
939    */
940   function symbol() public view virtual override returns (string memory) {
941     return _symbol;
942   }
943 
944   /**
945    * @dev See {IERC721Metadata-tokenURI}.
946    */
947   function tokenURI(uint256 tokenId)
948     public
949     view
950     virtual
951     override
952     returns (string memory)
953   {
954     require(
955       _exists(tokenId),
956       "ERC721Metadata: URI query for nonexistent token"
957     );
958 
959     string memory baseURI = _baseURI();
960     return
961       bytes(baseURI).length > 0
962         ? string(abi.encodePacked(baseURI, tokenId.toString()))
963         : "";
964   }
965 
966   /**
967    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969    * by default, can be overriden in child contracts.
970    */
971   function _baseURI() internal view virtual returns (string memory) {
972     return "";
973   }
974 
975   /**
976    * @dev See {IERC721-approve}.
977    */
978   function approve(address to, uint256 tokenId) public override {
979     address owner = ERC721A.ownerOf(tokenId);
980     require(to != owner, "ERC721A: approval to current owner");
981 
982     require(
983       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
984       "ERC721A: approve caller is not owner nor approved for all"
985     );
986 
987     _approve(to, tokenId, owner);
988   }
989 
990   /**
991    * @dev See {IERC721-getApproved}.
992    */
993   function getApproved(uint256 tokenId) public view override returns (address) {
994     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
995 
996     return _tokenApprovals[tokenId];
997   }
998 
999   /**
1000    * @dev See {IERC721-setApprovalForAll}.
1001    */
1002   function setApprovalForAll(address operator, bool approved) public override {
1003     require(operator != _msgSender(), "ERC721A: approve to caller");
1004 
1005     _operatorApprovals[_msgSender()][operator] = approved;
1006     emit ApprovalForAll(_msgSender(), operator, approved);
1007   }
1008 
1009   /**
1010    * @dev See {IERC721-isApprovedForAll}.
1011    */
1012   function isApprovedForAll(address owner, address operator)
1013     public
1014     view
1015     virtual
1016     override
1017     returns (bool)
1018   {
1019     return _operatorApprovals[owner][operator];
1020   }
1021 
1022   /**
1023    * @dev See {IERC721-transferFrom}.
1024    */
1025   function transferFrom(
1026     address from,
1027     address to,
1028     uint256 tokenId
1029   ) public override {
1030     _transfer(from, to, tokenId);
1031   }
1032 
1033   /**
1034    * @dev See {IERC721-safeTransferFrom}.
1035    */
1036   function safeTransferFrom(
1037     address from,
1038     address to,
1039     uint256 tokenId
1040   ) public override {
1041     safeTransferFrom(from, to, tokenId, "");
1042   }
1043 
1044   /**
1045    * @dev See {IERC721-safeTransferFrom}.
1046    */
1047   function safeTransferFrom(
1048     address from,
1049     address to,
1050     uint256 tokenId,
1051     bytes memory _data
1052   ) public override {
1053     _transfer(from, to, tokenId);
1054     require(
1055       _checkOnERC721Received(from, to, tokenId, _data),
1056       "ERC721A: transfer to non ERC721Receiver implementer"
1057     );
1058   }
1059 
1060   /**
1061    * @dev Returns whether `tokenId` exists.
1062    *
1063    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1064    *
1065    * Tokens start existing when they are minted (`_mint`),
1066    */
1067   function _exists(uint256 tokenId) internal view returns (bool) {
1068     return tokenId < currentIndex;
1069   }
1070 
1071   function _safeMint(address to, uint256 quantity) internal {
1072     _safeMint(to, quantity, "");
1073   }
1074 
1075   /**
1076    * @dev Mints `quantity` tokens and transfers them to `to`.
1077    *
1078    * Requirements:
1079    *
1080    * - there must be `quantity` tokens remaining unminted in the total collection.
1081    * - `to` cannot be the zero address.
1082    * - `quantity` cannot be larger than the max batch size.
1083    *
1084    * Emits a {Transfer} event.
1085    */
1086   function _safeMint(
1087     address to,
1088     uint256 quantity,
1089     bytes memory _data
1090   ) internal {
1091     uint256 startTokenId = currentIndex;
1092     require(to != address(0), "ERC721A: mint to the zero address");
1093     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1094     require(!_exists(startTokenId), "ERC721A: token already minted");
1095     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1096 
1097     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099     AddressData memory addressData = _addressData[to];
1100     _addressData[to] = AddressData(
1101       addressData.balance + uint128(quantity),
1102       addressData.numberMinted + uint128(quantity)
1103     );
1104     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1105 
1106     uint256 updatedIndex = startTokenId;
1107 
1108     for (uint256 i = 0; i < quantity; i++) {
1109       emit Transfer(address(0), to, updatedIndex);
1110       require(
1111         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1112         "ERC721A: transfer to non ERC721Receiver implementer"
1113       );
1114       updatedIndex++;
1115     }
1116 
1117     currentIndex = updatedIndex;
1118     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1119   }
1120 
1121   /**
1122    * @dev Transfers `tokenId` from `from` to `to`.
1123    *
1124    * Requirements:
1125    *
1126    * - `to` cannot be the zero address.
1127    * - `tokenId` token must be owned by `from`.
1128    *
1129    * Emits a {Transfer} event.
1130    */
1131   function _transfer(
1132     address from,
1133     address to,
1134     uint256 tokenId
1135   ) private {
1136     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1137 
1138     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1139       getApproved(tokenId) == _msgSender() ||
1140       isApprovedForAll(prevOwnership.addr, _msgSender()));
1141 
1142     require(
1143       isApprovedOrOwner,
1144       "ERC721A: transfer caller is not owner nor approved"
1145     );
1146 
1147     require(
1148       prevOwnership.addr == from,
1149       "ERC721A: transfer from incorrect owner"
1150     );
1151     require(to != address(0), "ERC721A: transfer to the zero address");
1152 
1153     _beforeTokenTransfers(from, to, tokenId, 1);
1154 
1155     // Clear approvals from the previous owner
1156     _approve(address(0), tokenId, prevOwnership.addr);
1157 
1158     _addressData[from].balance -= 1;
1159     _addressData[to].balance += 1;
1160     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1161 
1162     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1163     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1164     uint256 nextTokenId = tokenId + 1;
1165     if (_ownerships[nextTokenId].addr == address(0)) {
1166       if (_exists(nextTokenId)) {
1167         _ownerships[nextTokenId] = TokenOwnership(
1168           prevOwnership.addr,
1169           prevOwnership.startTimestamp
1170         );
1171       }
1172     }
1173 
1174     emit Transfer(from, to, tokenId);
1175     _afterTokenTransfers(from, to, tokenId, 1);
1176   }
1177 
1178   /**
1179    * @dev Approve `to` to operate on `tokenId`
1180    *
1181    * Emits a {Approval} event.
1182    */
1183   function _approve(
1184     address to,
1185     uint256 tokenId,
1186     address owner
1187   ) private {
1188     _tokenApprovals[tokenId] = to;
1189     emit Approval(owner, to, tokenId);
1190   }
1191 
1192   uint256 public nextOwnerToExplicitlySet = 0;
1193 
1194   /**
1195    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1196    */
1197   function _setOwnersExplicit(uint256 quantity) internal {
1198     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1199     require(quantity > 0, "quantity must be nonzero");
1200     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1201     if (endIndex > collectionSize - 1) {
1202       endIndex = collectionSize - 1;
1203     }
1204     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1205     require(_exists(endIndex), "not enough minted yet for this cleanup");
1206     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1207       if (_ownerships[i].addr == address(0)) {
1208         TokenOwnership memory ownership = ownershipOf(i);
1209         _ownerships[i] = TokenOwnership(
1210           ownership.addr,
1211           ownership.startTimestamp
1212         );
1213       }
1214     }
1215     nextOwnerToExplicitlySet = endIndex + 1;
1216   }
1217 
1218   /**
1219    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1220    * The call is not executed if the target address is not a contract.
1221    *
1222    * @param from address representing the previous owner of the given token ID
1223    * @param to target address that will receive the tokens
1224    * @param tokenId uint256 ID of the token to be transferred
1225    * @param _data bytes optional data to send along with the call
1226    * @return bool whether the call correctly returned the expected magic value
1227    */
1228   function _checkOnERC721Received(
1229     address from,
1230     address to,
1231     uint256 tokenId,
1232     bytes memory _data
1233   ) private returns (bool) {
1234     if (to.isContract()) {
1235       try
1236         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1237       returns (bytes4 retval) {
1238         return retval == IERC721Receiver(to).onERC721Received.selector;
1239       } catch (bytes memory reason) {
1240         if (reason.length == 0) {
1241           revert("ERC721A: transfer to non ERC721Receiver implementer");
1242         } else {
1243           assembly {
1244             revert(add(32, reason), mload(reason))
1245           }
1246         }
1247       }
1248     } else {
1249       return true;
1250     }
1251   }
1252 
1253   /**
1254    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1255    *
1256    * startTokenId - the first token id to be transferred
1257    * quantity - the amount to be transferred
1258    *
1259    * Calling conditions:
1260    *
1261    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1262    * transferred to `to`.
1263    * - When `from` is zero, `tokenId` will be minted for `to`.
1264    */
1265   function _beforeTokenTransfers(
1266     address from,
1267     address to,
1268     uint256 startTokenId,
1269     uint256 quantity
1270   ) internal virtual {}
1271 
1272   /**
1273    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1274    * minting.
1275    *
1276    * startTokenId - the first token id to be transferred
1277    * quantity - the amount to be transferred
1278    *
1279    * Calling conditions:
1280    *
1281    * - when `from` and `to` are both non-zero.
1282    * - `from` and `to` are never both zero.
1283    */
1284   function _afterTokenTransfers(
1285     address from,
1286     address to,
1287     uint256 startTokenId,
1288     uint256 quantity
1289   ) internal virtual {}
1290 }
1291 // File: @openzeppelin/contracts/access/Ownable.sol
1292 
1293 
1294 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1295 
1296 pragma solidity ^0.8.0;
1297 
1298 
1299 /**
1300  * @dev Contract module which provides a basic access control mechanism, where
1301  * there is an account (an owner) that can be granted exclusive access to
1302  * specific functions.
1303  *
1304  * By default, the owner account will be the one that deploys the contract. This
1305  * can later be changed with {transferOwnership}.
1306  *
1307  * This module is used through inheritance. It will make available the modifier
1308  * `onlyOwner`, which can be applied to your functions to restrict their use to
1309  * the owner.
1310  */
1311 abstract contract Ownable is Context {
1312     address private _owner;
1313 
1314     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1315 
1316     /**
1317      * @dev Initializes the contract setting the deployer as the initial owner.
1318      */
1319     constructor() {
1320         _transferOwnership(_msgSender());
1321     }
1322 
1323     /**
1324      * @dev Returns the address of the current owner.
1325      */
1326     function owner() public view virtual returns (address) {
1327         return _owner;
1328     }
1329 
1330     /**
1331      * @dev Throws if called by any account other than the owner.
1332      */
1333     modifier onlyOwner() {
1334         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1335         _;
1336     }
1337 
1338     /**
1339      * @dev Leaves the contract without owner. It will not be possible to call
1340      * `onlyOwner` functions anymore. Can only be called by the current owner.
1341      *
1342      * NOTE: Renouncing ownership will leave the contract without an owner,
1343      * thereby removing any functionality that is only available to the owner.
1344      */
1345     function renounceOwnership() public virtual onlyOwner {
1346         _transferOwnership(address(0));
1347     }
1348 
1349     /**
1350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1351      * Can only be called by the current owner.
1352      */
1353     function transferOwnership(address newOwner) public virtual onlyOwner {
1354         require(newOwner != address(0), "Ownable: new owner is the zero address");
1355         _transferOwnership(newOwner);
1356     }
1357 
1358     /**
1359      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1360      * Internal function without access restriction.
1361      */
1362     function _transferOwnership(address newOwner) internal virtual {
1363         address oldOwner = _owner;
1364         _owner = newOwner;
1365         emit OwnershipTransferred(oldOwner, newOwner);
1366     }
1367 }
1368 
1369 // File: TastyToastys.sol
1370 
1371 
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 
1376 
1377 
1378 
1379 
1380 contract TastyToastys is Ownable, ERC721A, ReentrancyGuard {
1381   using Strings for uint256;
1382   uint256 public immutable maxPerAddressDuringMint;
1383   uint256 public immutable amountForDevs;
1384     // Provenance
1385   string public TastyToastys_HASH = "";
1386   uint256 public publicMintStartBlock =
1387     0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
1388   uint256 public allowlistMintStartBlock =
1389     0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
1390   uint256 public allowOGlistMintStartBlock =
1391     0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
1392   uint256 public publicPrice = 20000000000000000;
1393   bytes32 public allowlistMerkleRoot;
1394   bytes32 public allowOGlistMerkleRoot;
1395   uint256 public maxAllowListMint = 2;
1396   uint256 public maxOGAllowListMint = 5;
1397   mapping(address => bool) public allowlistClaimed;
1398   mapping(address => bool) public OGallowlistClaimed;
1399   constructor(
1400     uint256 maxBatchSize_,
1401     uint256 collectionSize_,
1402     uint256 amountForDevs_
1403   ) ERC721A("TastyToastys", "TASTYTOASTYS", maxBatchSize_, collectionSize_) {
1404     maxPerAddressDuringMint = maxBatchSize_;
1405     amountForDevs = amountForDevs_;
1406     require(
1407       amountForDevs_ <= collectionSize_,
1408       "larger collection size needed"
1409     );
1410   }
1411 
1412   modifier callerIsUser() {
1413     require(tx.origin == msg.sender, "The caller is another contract");
1414     _;
1415   }
1416 
1417   function mintStarted() public view returns (bool) {
1418     return block.number >= publicMintStartBlock;
1419   }
1420 
1421   function allowlistMintStarted() public view returns (bool) {
1422     return block.number >= allowlistMintStartBlock;
1423   }
1424 
1425   function allowOGlistMintStarted() public view returns (bool) {
1426     return block.number >= allowOGlistMintStartBlock;
1427   }
1428 
1429   function allowlistMint(bytes32 [] calldata _merkleProof, uint256 quantity) public {
1430     //Basic data validation to ensure the wallet hasn't already claimed
1431     require(allowlistMintStarted(), 'Allowlist not started');
1432     require(!allowlistClaimed[msg.sender], "Address has already claimed.");
1433     require(quantity <= maxAllowListMint, "Cannot claim this many");
1434     
1435     //Verify the provided _merkleProof, given to us through the API call on the website.
1436     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1437     require(MerkleProof.verify(_merkleProof, allowlistMerkleRoot, leaf), "Invalid proof.");
1438 
1439     //Mark address as having claimed their token.
1440     allowlistClaimed[msg.sender] = true;
1441 
1442     // Mint the reserved token here
1443     _safeMint(msg.sender, quantity); 
1444     }
1445 
1446   function OGallowlistMint(bytes32 [] calldata _merkleProof, uint256 quantity) public {
1447     //Basic data validation to ensure the wallet hasn't already claimed
1448     require(allowOGlistMintStarted(), 'OGAllowlist not started');
1449     require(!OGallowlistClaimed[msg.sender], "Address has already claimed.");
1450     require(quantity <= maxOGAllowListMint, "Cannot claim this many");
1451     
1452     //Verify the provided _merkleProof, given to us through the API call on the website.
1453     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1454     require(MerkleProof.verify(_merkleProof, allowOGlistMerkleRoot, leaf), "Invalid proof.");
1455 
1456     //Mark address as having claimed their token.
1457     OGallowlistClaimed[msg.sender] = true;
1458 
1459     // Mint the reserved token here
1460     _safeMint(msg.sender, quantity); 
1461     }
1462 
1463   function mint(uint256 quantity) public payable nonReentrant {
1464     require(mintStarted(), 'Mint not started');
1465     publicSaleMint(quantity);
1466   }
1467 
1468   function publicSaleMint(uint256 quantity)
1469     private
1470     callerIsUser
1471   {
1472     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1473     require(msg.value >= (publicPrice * quantity), "Need to send more ETH.");
1474     require(msg.value <= (publicPrice * quantity), "You have tried to send too much ETH");
1475     _safeMint(msg.sender, quantity);
1476   }
1477 
1478 
1479   // To replace OG Tokens
1480   function devMint(uint256 quantity) external onlyOwner {
1481     require(
1482       totalSupply() + quantity <= amountForDevs,
1483       "too many already minted before dev mint"
1484     );
1485     require(
1486       quantity % maxBatchSize == 0,
1487       "can only mint a multiple of the maxBatchSize"
1488     );
1489     uint256 numChunks = quantity / maxBatchSize;
1490     for (uint256 i = 0; i < numChunks; i++) {
1491       _safeMint(msg.sender, maxBatchSize);
1492     }
1493   }
1494 
1495   // // metadata URI
1496   string private _baseTokenURI;
1497 
1498   function _baseURI() internal view virtual override returns (string memory) {
1499     return _baseTokenURI;
1500   }
1501 
1502   function setBaseURI(string calldata baseURI) external onlyOwner nonReentrant{
1503     _baseTokenURI = baseURI;
1504   }
1505 
1506   function setMerkleRoot(bytes32 newMerkleRoot) public onlyOwner nonReentrant{
1507     allowlistMerkleRoot = newMerkleRoot; 
1508   }
1509 
1510   function setOGMerkleRoot(bytes32 newOGMerkleRoot) public onlyOwner nonReentrant{
1511     allowOGlistMerkleRoot = newOGMerkleRoot; 
1512   }
1513 
1514   function setPublicMintStartBlock(uint256 _newPublicMintStartBlock)
1515     external
1516     onlyOwner
1517   {
1518     publicMintStartBlock = _newPublicMintStartBlock;
1519   }
1520 
1521   function setAllowListMintStartBlock(uint256 _newAllowlistMintStartBlock)
1522     external
1523     onlyOwner
1524     nonReentrant
1525   {
1526     allowlistMintStartBlock = _newAllowlistMintStartBlock;
1527   }
1528 
1529   function setAllowOGListMintStartBlock(uint256 _newAllowOGlistMintStartBlock)
1530     external
1531     onlyOwner
1532     nonReentrant
1533   {
1534     allowOGlistMintStartBlock = _newAllowOGlistMintStartBlock;
1535   }
1536 
1537   function setPublicPrice(uint64 _newPublicPrice)
1538     external
1539     onlyOwner
1540     nonReentrant
1541   {
1542     publicPrice = _newPublicPrice;
1543   }
1544 
1545   function setMaxAllowListMint(uint256 _newMaxAllowListMint)
1546     external
1547     onlyOwner
1548     nonReentrant
1549   {
1550     maxAllowListMint = _newMaxAllowListMint;
1551   }
1552 
1553   function setMaxOGAllowListMint(uint256 _newMaxOGAllowListMint)
1554     external
1555     onlyOwner
1556     nonReentrant
1557   {
1558     maxOGAllowListMint = _newMaxOGAllowListMint;
1559   }
1560 
1561   function withdrawMoney() external onlyOwner nonReentrant {
1562     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1563     require(success, "Transfer failed.");
1564   }
1565 
1566   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1567     _setOwnersExplicit(quantity);
1568   }
1569 
1570   function numberMinted(address owner) public view returns (uint256) {
1571     return _numberMinted(owner);
1572   }
1573 
1574   function getOwnershipData(uint256 tokenId)
1575     external
1576     view
1577     returns (TokenOwnership memory)
1578   {
1579     return ownershipOf(tokenId);
1580   }
1581 
1582 
1583   function setProvenanceHash(string memory provenanceHash) external onlyOwner nonReentrant {
1584     TastyToastys_HASH = provenanceHash;
1585   }
1586 
1587 }