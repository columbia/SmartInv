1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev These functions deal with verification of Merkle Trees proofs.
76  *
77  * The proofs can be generated using the JavaScript library
78  * https://github.com/miguelmota/merkletreejs[merkletreejs].
79  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
80  *
81  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
82  */
83 library MerkleProof {
84     /**
85      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
86      * defined by `root`. For this, a `proof` must be provided, containing
87      * sibling hashes on the branch from the leaf to the root of the tree. Each
88      * pair of leaves and each pair of pre-images are assumed to be sorted.
89      */
90     function verify(
91         bytes32[] memory proof,
92         bytes32 root,
93         bytes32 leaf
94     ) internal pure returns (bool) {
95         return processProof(proof, leaf) == root;
96     }
97 
98     /**
99      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
100      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
101      * hash matches the root of the tree. When processing the proof, the pairs
102      * of leafs & pre-images are assumed to be sorted.
103      *
104      * _Available since v4.4._
105      */
106     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
107         bytes32 computedHash = leaf;
108         for (uint256 i = 0; i < proof.length; i++) {
109             bytes32 proofElement = proof[i];
110             if (computedHash <= proofElement) {
111                 // Hash(current computed hash + current element of the proof)
112                 computedHash = _efficientHash(computedHash, proofElement);
113             } else {
114                 // Hash(current element of the proof + current computed hash)
115                 computedHash = _efficientHash(proofElement, computedHash);
116             }
117         }
118         return computedHash;
119     }
120 
121     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
122         assembly {
123             mstore(0x00, a)
124             mstore(0x20, b)
125             value := keccak256(0x00, 0x40)
126         }
127     }
128 }
129 
130 // File: @openzeppelin/contracts/utils/Context.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Provides information about the current execution context, including the
139  * sender of the transaction and its data. While these are generally available
140  * via msg.sender and msg.data, they should not be accessed in such a direct
141  * manner, since when dealing with meta-transactions the account sending and
142  * paying for execution may not be the actual sender (as far as an application
143  * is concerned).
144  *
145  * This contract is only required for intermediate, library-like contracts.
146  */
147 abstract contract Context {
148     function _msgSender() internal view virtual returns (address) {
149         return msg.sender;
150     }
151 
152     function _msgData() internal view virtual returns (bytes calldata) {
153         return msg.data;
154     }
155 }
156 
157 // File: @openzeppelin/contracts/utils/Address.sol
158 
159 
160 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 /**
165  * @dev Collection of functions related to the address type
166  */
167 library Address {
168     /**
169      * @dev Returns true if `account` is a contract.
170      *
171      * [IMPORTANT]
172      * ====
173      * It is unsafe to assume that an address for which this function returns
174      * false is an externally-owned account (EOA) and not a contract.
175      *
176      * Among others, `isContract` will return false for the following
177      * types of addresses:
178      *
179      *  - an externally-owned account
180      *  - a contract in construction
181      *  - an address where a contract will be created
182      *  - an address where a contract lived, but was destroyed
183      * ====
184      */
185     function isContract(address account) internal view returns (bool) {
186         // This method relies on extcodesize, which returns 0 for contracts in
187         // construction, since the code is only stored at the end of the
188         // constructor execution.
189 
190         uint256 size;
191         assembly {
192             size := extcodesize(account)
193         }
194         return size > 0;
195     }
196 
197     /**
198      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
199      * `recipient`, forwarding all available gas and reverting on errors.
200      *
201      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
202      * of certain opcodes, possibly making contracts go over the 2300 gas limit
203      * imposed by `transfer`, making them unable to receive funds via
204      * `transfer`. {sendValue} removes this limitation.
205      *
206      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
207      *
208      * IMPORTANT: because control is transferred to `recipient`, care must be
209      * taken to not create reentrancy vulnerabilities. Consider using
210      * {ReentrancyGuard} or the
211      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
212      */
213     function sendValue(address payable recipient, uint256 amount) internal {
214         require(address(this).balance >= amount, "Address: insufficient balance");
215 
216         (bool success, ) = recipient.call{value: amount}("");
217         require(success, "Address: unable to send value, recipient may have reverted");
218     }
219 
220     /**
221      * @dev Performs a Solidity function call using a low level `call`. A
222      * plain `call` is an unsafe replacement for a function call: use this
223      * function instead.
224      *
225      * If `target` reverts with a revert reason, it is bubbled up by this
226      * function (like regular Solidity function calls).
227      *
228      * Returns the raw returned data. To convert to the expected return value,
229      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
230      *
231      * Requirements:
232      *
233      * - `target` must be a contract.
234      * - calling `target` with `data` must not revert.
235      *
236      * _Available since v3.1._
237      */
238     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionCall(target, data, "Address: low-level call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
244      * `errorMessage` as a fallback revert reason when `target` reverts.
245      *
246      * _Available since v3.1._
247      */
248     function functionCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         return functionCallWithValue(target, data, 0, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but also transferring `value` wei to `target`.
259      *
260      * Requirements:
261      *
262      * - the calling contract must have an ETH balance of at least `value`.
263      * - the called Solidity function must be `payable`.
264      *
265      * _Available since v3.1._
266      */
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
277      * with `errorMessage` as a fallback revert reason when `target` reverts.
278      *
279      * _Available since v3.1._
280      */
281     function functionCallWithValue(
282         address target,
283         bytes memory data,
284         uint256 value,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         require(address(this).balance >= value, "Address: insufficient balance for call");
288         require(isContract(target), "Address: call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.call{value: value}(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a static call.
297      *
298      * _Available since v3.3._
299      */
300     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
301         return functionStaticCall(target, data, "Address: low-level static call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
306      * but performing a static call.
307      *
308      * _Available since v3.3._
309      */
310     function functionStaticCall(
311         address target,
312         bytes memory data,
313         string memory errorMessage
314     ) internal view returns (bytes memory) {
315         require(isContract(target), "Address: static call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.staticcall(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a delegate call.
324      *
325      * _Available since v3.4._
326      */
327     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a delegate call.
334      *
335      * _Available since v3.4._
336      */
337     function functionDelegateCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         require(isContract(target), "Address: delegate call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.delegatecall(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
350      * revert reason using the provided one.
351      *
352      * _Available since v4.3._
353      */
354     function verifyCallResult(
355         bool success,
356         bytes memory returndata,
357         string memory errorMessage
358     ) internal pure returns (bytes memory) {
359         if (success) {
360             return returndata;
361         } else {
362             // Look for revert reason and bubble it up if present
363             if (returndata.length > 0) {
364                 // The easiest way to bubble the revert reason is using memory via assembly
365 
366                 assembly {
367                     let returndata_size := mload(returndata)
368                     revert(add(32, returndata), returndata_size)
369                 }
370             } else {
371                 revert(errorMessage);
372             }
373         }
374     }
375 }
376 
377 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 /**
385  * @title ERC721 token receiver interface
386  * @dev Interface for any contract that wants to support safeTransfers
387  * from ERC721 asset contracts.
388  */
389 interface IERC721Receiver {
390     /**
391      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
392      * by `operator` from `from`, this function is called.
393      *
394      * It must return its Solidity selector to confirm the token transfer.
395      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
396      *
397      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
398      */
399     function onERC721Received(
400         address operator,
401         address from,
402         uint256 tokenId,
403         bytes calldata data
404     ) external returns (bytes4);
405 }
406 
407 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @dev Interface of the ERC165 standard, as defined in the
416  * https://eips.ethereum.org/EIPS/eip-165[EIP].
417  *
418  * Implementers can declare support of contract interfaces, which can then be
419  * queried by others ({ERC165Checker}).
420  *
421  * For an implementation, see {ERC165}.
422  */
423 interface IERC165 {
424     /**
425      * @dev Returns true if this contract implements the interface defined by
426      * `interfaceId`. See the corresponding
427      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
428      * to learn more about how these ids are created.
429      *
430      * This function call must use less than 30 000 gas.
431      */
432     function supportsInterface(bytes4 interfaceId) external view returns (bool);
433 }
434 
435 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 
443 /**
444  * @dev Implementation of the {IERC165} interface.
445  *
446  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
447  * for the additional interface id that will be supported. For example:
448  *
449  * ```solidity
450  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
451  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
452  * }
453  * ```
454  *
455  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
456  */
457 abstract contract ERC165 is IERC165 {
458     /**
459      * @dev See {IERC165-supportsInterface}.
460      */
461     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
462         return interfaceId == type(IERC165).interfaceId;
463     }
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 
474 /**
475  * @dev Required interface of an ERC721 compliant contract.
476  */
477 interface IERC721 is IERC165 {
478     /**
479      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
480      */
481     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
485      */
486     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
487 
488     /**
489      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
490      */
491     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
492 
493     /**
494      * @dev Returns the number of tokens in ``owner``'s account.
495      */
496     function balanceOf(address owner) external view returns (uint256 balance);
497 
498     /**
499      * @dev Returns the owner of the `tokenId` token.
500      *
501      * Requirements:
502      *
503      * - `tokenId` must exist.
504      */
505     function ownerOf(uint256 tokenId) external view returns (address owner);
506 
507     /**
508      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
509      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must exist and be owned by `from`.
516      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
518      *
519      * Emits a {Transfer} event.
520      */
521     function safeTransferFrom(
522         address from,
523         address to,
524         uint256 tokenId
525     ) external;
526 
527     /**
528      * @dev Transfers `tokenId` token from `from` to `to`.
529      *
530      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must be owned by `from`.
537      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
538      *
539      * Emits a {Transfer} event.
540      */
541     function transferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external;
546 
547     /**
548      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
549      * The approval is cleared when the token is transferred.
550      *
551      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
552      *
553      * Requirements:
554      *
555      * - The caller must own the token or be an approved operator.
556      * - `tokenId` must exist.
557      *
558      * Emits an {Approval} event.
559      */
560     function approve(address to, uint256 tokenId) external;
561 
562     /**
563      * @dev Returns the account approved for `tokenId` token.
564      *
565      * Requirements:
566      *
567      * - `tokenId` must exist.
568      */
569     function getApproved(uint256 tokenId) external view returns (address operator);
570 
571     /**
572      * @dev Approve or remove `operator` as an operator for the caller.
573      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
574      *
575      * Requirements:
576      *
577      * - The `operator` cannot be the caller.
578      *
579      * Emits an {ApprovalForAll} event.
580      */
581     function setApprovalForAll(address operator, bool _approved) external;
582 
583     /**
584      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
585      *
586      * See {setApprovalForAll}
587      */
588     function isApprovedForAll(address owner, address operator) external view returns (bool);
589 
590     /**
591      * @dev Safely transfers `tokenId` token from `from` to `to`.
592      *
593      * Requirements:
594      *
595      * - `from` cannot be the zero address.
596      * - `to` cannot be the zero address.
597      * - `tokenId` token must exist and be owned by `from`.
598      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
599      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
600      *
601      * Emits a {Transfer} event.
602      */
603     function safeTransferFrom(
604         address from,
605         address to,
606         uint256 tokenId,
607         bytes calldata data
608     ) external;
609 }
610 
611 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
612 
613 
614 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
621  * @dev See https://eips.ethereum.org/EIPS/eip-721
622  */
623 interface IERC721Enumerable is IERC721 {
624     /**
625      * @dev Returns the total amount of tokens stored by the contract.
626      */
627     function totalSupply() external view returns (uint256);
628 
629     /**
630      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
631      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
632      */
633     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
634 
635     /**
636      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
637      * Use along with {totalSupply} to enumerate all tokens.
638      */
639     function tokenByIndex(uint256 index) external view returns (uint256);
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
643 
644 
645 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 
650 /**
651  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
652  * @dev See https://eips.ethereum.org/EIPS/eip-721
653  */
654 interface IERC721Metadata is IERC721 {
655     /**
656      * @dev Returns the token collection name.
657      */
658     function name() external view returns (string memory);
659 
660     /**
661      * @dev Returns the token collection symbol.
662      */
663     function symbol() external view returns (string memory);
664 
665     /**
666      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
667      */
668     function tokenURI(uint256 tokenId) external view returns (string memory);
669 }
670 
671 // File: @openzeppelin/contracts/utils/Strings.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @dev String operations.
680  */
681 library Strings {
682     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
683 
684     /**
685      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
686      */
687     function toString(uint256 value) internal pure returns (string memory) {
688         // Inspired by OraclizeAPI's implementation - MIT licence
689         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
690 
691         if (value == 0) {
692             return "0";
693         }
694         uint256 temp = value;
695         uint256 digits;
696         while (temp != 0) {
697             digits++;
698             temp /= 10;
699         }
700         bytes memory buffer = new bytes(digits);
701         while (value != 0) {
702             digits -= 1;
703             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
704             value /= 10;
705         }
706         return string(buffer);
707     }
708 
709     /**
710      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
711      */
712     function toHexString(uint256 value) internal pure returns (string memory) {
713         if (value == 0) {
714             return "0x00";
715         }
716         uint256 temp = value;
717         uint256 length = 0;
718         while (temp != 0) {
719             length++;
720             temp >>= 8;
721         }
722         return toHexString(value, length);
723     }
724 
725     /**
726      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
727      */
728     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
729         bytes memory buffer = new bytes(2 * length + 2);
730         buffer[0] = "0";
731         buffer[1] = "x";
732         for (uint256 i = 2 * length + 1; i > 1; --i) {
733             buffer[i] = _HEX_SYMBOLS[value & 0xf];
734             value >>= 4;
735         }
736         require(value == 0, "Strings: hex length insufficient");
737         return string(buffer);
738     }
739 }
740 
741 // File: contracts/ERC721A.sol
742 
743 
744 // Creator: Chiru Labs
745 // commit e03a377 - 2/26/2022
746 pragma solidity ^0.8.4;
747 
748 
749 
750 
751 
752 
753 
754 
755 
756 error ApprovalCallerNotOwnerNorApproved();
757 error ApprovalQueryForNonexistentToken();
758 error ApproveToCaller();
759 error ApprovalToCurrentOwner();
760 error BalanceQueryForZeroAddress();
761 error MintedQueryForZeroAddress();
762 error BurnedQueryForZeroAddress();
763 error AuxQueryForZeroAddress();
764 error MintToZeroAddress();
765 error MintZeroQuantity();
766 error OwnerIndexOutOfBounds();
767 error OwnerQueryForNonexistentToken();
768 error TokenIndexOutOfBounds();
769 error TransferCallerNotOwnerNorApproved();
770 error TransferFromIncorrectOwner();
771 error TransferToNonERC721ReceiverImplementer();
772 error TransferToZeroAddress();
773 error URIQueryForNonexistentToken();
774 
775 /**
776  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
777  * the Metadata extension. Built to optimize for lower gas during batch mints.
778  *
779  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
780  *
781  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
782  *
783  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
784  */
785 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
786     using Address for address;
787     using Strings for uint256;
788 
789     // Compiler will pack this into a single 256bit word.
790     struct TokenOwnership {
791         // The address of the owner.
792         address addr;
793         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
794         uint64 startTimestamp;
795         // Whether the token has been burned.
796         bool burned;
797     }
798 
799     // Compiler will pack this into a single 256bit word.
800     struct AddressData {
801         // Realistically, 2**64-1 is more than enough.
802         uint64 balance;
803         // Keeps track of mint count with minimal overhead for tokenomics.
804         uint64 numberMinted;
805         // Keeps track of burn count with minimal overhead for tokenomics.
806         uint64 numberBurned;
807         // For miscellaneous variable(s) pertaining to the address
808         // (e.g. number of whitelist mint slots used).
809         // If there are multiple variables, please pack them into a uint64.
810         uint64 aux;
811     }
812 
813     // The tokenId of the next token to be minted.
814     uint256 internal _currentIndex;
815 
816     // The number of tokens burned.
817     uint256 internal _burnCounter;
818 
819     // Token name
820     string private _name;
821 
822     // Token symbol
823     string private _symbol;
824 
825     // Mapping from token ID to ownership details
826     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
827     mapping(uint256 => TokenOwnership) internal _ownerships;
828 
829     // Mapping owner address to address data
830     mapping(address => AddressData) private _addressData;
831 
832     // Mapping from token ID to approved address
833     mapping(uint256 => address) private _tokenApprovals;
834 
835     // Mapping from owner to operator approvals
836     mapping(address => mapping(address => bool)) private _operatorApprovals;
837 
838     constructor(string memory name_, string memory symbol_)  {
839         _name = name_;
840         _symbol = symbol_;
841         _currentIndex = _startTokenId();
842     }
843 
844     /**
845      * To change the starting tokenId, please override this function.
846      */
847     function _startTokenId() internal view virtual returns (uint256) {
848         return 0;
849     }
850 
851     /**
852      * @dev See {IERC721Enumerable-totalSupply}.
853      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
854      */
855     function totalSupply() public view returns (uint256) {
856         // Counter underflow is impossible as _burnCounter cannot be incremented
857         // more than _currentIndex - _startTokenId() times
858         unchecked {
859             return _currentIndex - _burnCounter - _startTokenId();
860         }
861     }
862 
863     /**
864      * Returns the total amount of tokens minted in the contract.
865      */
866     function _totalMinted() internal view returns (uint256) {
867         // Counter underflow is impossible as _currentIndex does not decrement,
868         // and it is initialized to _startTokenId()
869         unchecked {
870             return _currentIndex - _startTokenId();
871         }
872     }
873 
874     /**
875      * @dev See {IERC165-supportsInterface}.
876      */
877     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
878         return
879             interfaceId == type(IERC721).interfaceId ||
880             interfaceId == type(IERC721Metadata).interfaceId ||
881             super.supportsInterface(interfaceId);
882     }
883 
884     /**
885      * @dev See {IERC721-balanceOf}.
886      */
887     function balanceOf(address owner) public view override returns (uint256) {
888         if (owner == address(0)) revert BalanceQueryForZeroAddress();
889         return uint256(_addressData[owner].balance);
890     }
891 
892     /**
893      * Returns the number of tokens minted by `owner`.
894      */
895     function _numberMinted(address owner) internal view returns (uint256) {
896         if (owner == address(0)) revert MintedQueryForZeroAddress();
897         return uint256(_addressData[owner].numberMinted);
898     }
899 
900     /**
901      * Returns the number of tokens burned by or on behalf of `owner`.
902      */
903     function _numberBurned(address owner) internal view returns (uint256) {
904         if (owner == address(0)) revert BurnedQueryForZeroAddress();
905         return uint256(_addressData[owner].numberBurned);
906     }
907 
908     /**
909      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
910      */
911     function _getAux(address owner) internal view returns (uint64) {
912         if (owner == address(0)) revert AuxQueryForZeroAddress();
913         return _addressData[owner].aux;
914     }
915 
916     /**
917      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
918      * If there are multiple variables, please pack them into a uint64.
919      */
920     function _setAux(address owner, uint64 aux) internal {
921         if (owner == address(0)) revert AuxQueryForZeroAddress();
922         _addressData[owner].aux = aux;
923     }
924 
925     /**
926      * Gas spent here starts off proportional to the maximum mint batch size.
927      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
928      */
929     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
930         uint256 curr = tokenId;
931 
932         unchecked {
933             if (_startTokenId() <= curr && curr < _currentIndex) {
934                 TokenOwnership memory ownership = _ownerships[curr];
935                 if (!ownership.burned) {
936                     if (ownership.addr != address(0)) {
937                         return ownership;
938                     }
939                     // Invariant:
940                     // There will always be an ownership that has an address and is not burned
941                     // before an ownership that does not have an address and is not burned.
942                     // Hence, curr will not underflow.
943                     while (true) {
944                         curr--;
945                         ownership = _ownerships[curr];
946                         if (ownership.addr != address(0)) {
947                             return ownership;
948                         }
949                     }
950                 }
951             }
952         }
953         revert OwnerQueryForNonexistentToken();
954     }
955 
956     /**
957      * @dev See {IERC721-ownerOf}.
958      */
959     function ownerOf(uint256 tokenId) public view override returns (address) {
960         return ownershipOf(tokenId).addr;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-name}.
965      */
966     function name() public view virtual override returns (string memory) {
967         return _name;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-symbol}.
972      */
973     function symbol() public view virtual override returns (string memory) {
974         return _symbol;
975     }
976 
977     /**
978      * @dev See {IERC721Metadata-tokenURI}.
979      */
980     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
981         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
982 
983         string memory baseURI = _baseURI();
984         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
985     }
986 
987     /**
988      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
989      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
990      * by default, can be overriden in child contracts.
991      */
992     function _baseURI() internal view virtual returns (string memory) {
993         return '';
994     }
995 
996     /**
997      * @dev See {IERC721-approve}.
998      */
999     function approve(address to, uint256 tokenId) public override {
1000         address owner = ERC721A.ownerOf(tokenId);
1001         if (to == owner) revert ApprovalToCurrentOwner();
1002 
1003         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1004             revert ApprovalCallerNotOwnerNorApproved();
1005         }
1006 
1007         _approve(to, tokenId, owner);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-getApproved}.
1012      */
1013     function getApproved(uint256 tokenId) public view override returns (address) {
1014         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1015 
1016         return _tokenApprovals[tokenId];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-setApprovalForAll}.
1021      */
1022     function setApprovalForAll(address operator, bool approved) public override {
1023         if (operator == _msgSender()) revert ApproveToCaller();
1024 
1025         _operatorApprovals[_msgSender()][operator] = approved;
1026         emit ApprovalForAll(_msgSender(), operator, approved);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-isApprovedForAll}.
1031      */
1032     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1033         return _operatorApprovals[owner][operator];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-transferFrom}.
1038      */
1039     function transferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) public virtual override {
1055         safeTransferFrom(from, to, tokenId, '');
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-safeTransferFrom}.
1060      */
1061     function safeTransferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) public virtual override {
1067         _transfer(from, to, tokenId);
1068         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1069             revert TransferToNonERC721ReceiverImplementer();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns whether `tokenId` exists.
1075      *
1076      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1077      *
1078      * Tokens start existing when they are minted (`_mint`),
1079      */
1080     function _exists(uint256 tokenId) internal view returns (bool) {
1081         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1082             !_ownerships[tokenId].burned;
1083     }
1084 
1085     function _safeMint(address to, uint256 quantity) internal {
1086         _safeMint(to, quantity, '');
1087     }
1088 
1089     /**
1090      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _safeMint(
1100         address to,
1101         uint256 quantity,
1102         bytes memory _data
1103     ) internal {
1104         _mint(to, quantity, _data, true);
1105     }
1106 
1107     /**
1108      * @dev Mints `quantity` tokens and transfers them to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `quantity` must be greater than 0.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _mint(
1118         address to,
1119         uint256 quantity,
1120         bytes memory _data,
1121         bool safe
1122     ) internal {
1123         uint256 startTokenId = _currentIndex;
1124         if (to == address(0)) revert MintToZeroAddress();
1125         if (quantity == 0) revert MintZeroQuantity();
1126 
1127         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129         // Overflows are incredibly unrealistic.
1130         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1131         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1132         unchecked {
1133             _addressData[to].balance += uint64(quantity);
1134             _addressData[to].numberMinted += uint64(quantity);
1135 
1136             _ownerships[startTokenId].addr = to;
1137             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1138 
1139             uint256 updatedIndex = startTokenId;
1140             uint256 end = updatedIndex + quantity;
1141 
1142             if (safe && to.isContract()) {
1143                 do {
1144                     emit Transfer(address(0), to, updatedIndex);
1145                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1146                         revert TransferToNonERC721ReceiverImplementer();
1147                     }
1148                 } while (updatedIndex != end);
1149                 // Reentrancy protection
1150                 if (_currentIndex != startTokenId) revert();
1151             } else {
1152                 do {
1153                     emit Transfer(address(0), to, updatedIndex++);
1154                 } while (updatedIndex != end);
1155             }
1156             _currentIndex = updatedIndex;
1157         }
1158         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1159     }
1160 
1161     /**
1162      * @dev Transfers `tokenId` from `from` to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _transfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) private {
1176         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1177 
1178         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1179             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1180             getApproved(tokenId) == _msgSender());
1181 
1182         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1183         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1184         if (to == address(0)) revert TransferToZeroAddress();
1185 
1186         _beforeTokenTransfers(from, to, tokenId, 1);
1187 
1188         // Clear approvals from the previous owner
1189         _approve(address(0), tokenId, prevOwnership.addr);
1190 
1191         // Underflow of the sender's balance is impossible because we check for
1192         // ownership above and the recipient's balance can't realistically overflow.
1193         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1194         unchecked {
1195             _addressData[from].balance -= 1;
1196             _addressData[to].balance += 1;
1197 
1198             _ownerships[tokenId].addr = to;
1199             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1200 
1201             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1202             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1203             uint256 nextTokenId = tokenId + 1;
1204             if (_ownerships[nextTokenId].addr == address(0)) {
1205                 // This will suffice for checking _exists(nextTokenId),
1206                 // as a burned slot cannot contain the zero address.
1207                 if (nextTokenId < _currentIndex) {
1208                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1209                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1210                 }
1211             }
1212         }
1213 
1214         emit Transfer(from, to, tokenId);
1215         _afterTokenTransfers(from, to, tokenId, 1);
1216     }
1217 
1218     /**
1219      * @dev Destroys `tokenId`.
1220      * The approval is cleared when the token is burned.
1221      *
1222      * Requirements:
1223      *
1224      * - `tokenId` must exist.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _burn(uint256 tokenId) internal virtual {
1229         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1230 
1231         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1232 
1233         // Clear approvals from the previous owner
1234         _approve(address(0), tokenId, prevOwnership.addr);
1235 
1236         // Underflow of the sender's balance is impossible because we check for
1237         // ownership above and the recipient's balance can't realistically overflow.
1238         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1239         unchecked {
1240             _addressData[prevOwnership.addr].balance -= 1;
1241             _addressData[prevOwnership.addr].numberBurned += 1;
1242 
1243             // Keep track of who burned the token, and the timestamp of burning.
1244             _ownerships[tokenId].addr = prevOwnership.addr;
1245             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1246             _ownerships[tokenId].burned = true;
1247 
1248             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1249             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1250             uint256 nextTokenId = tokenId + 1;
1251             if (_ownerships[nextTokenId].addr == address(0)) {
1252                 // This will suffice for checking _exists(nextTokenId),
1253                 // as a burned slot cannot contain the zero address.
1254                 if (nextTokenId < _currentIndex) {
1255                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1256                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(prevOwnership.addr, address(0), tokenId);
1262         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
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
1357 // File: contracts/HungoverApes.sol
1358 
1359 
1360 // Authored by NoahN w/ Metavate ✌️
1361 pragma solidity ^0.8.11;
1362 
1363 
1364 
1365 
1366 
1367 
1368 contract HungoverApes is ERC721A, ReentrancyGuard{ 
1369   	using Strings for uint256;
1370 
1371     uint256 public cost = 0.08 ether;
1372     uint256 public discountCost = cost - 0.02 ether;
1373     uint256 public maxSupply = 7777;
1374 
1375     bool public sale = false;
1376 	bool public presale = false;
1377 
1378 	string public baseURI;
1379 
1380 	bytes32 public merkleRoot;
1381 
1382 	address private owner;
1383 	address private admin = 0x8DFdD0FF4661abd44B06b1204C6334eACc8575af;
1384 
1385 	mapping (address => uint256) public discountMints;
1386 
1387 
1388 	constructor(string memory _name, string memory _symbol)
1389     ERC721A(_name, _symbol){
1390 	    owner = msg.sender;
1391     }
1392 
1393 	 modifier onlyTeam {
1394         require(msg.sender == owner || msg.sender == admin, "Not team" );
1395         _;
1396     }
1397 
1398     function mint(uint256 mintQty) external payable {
1399         require(sale, "Sale");
1400         require(mintQty < 11, "Too many");
1401         require(mintQty + _totalMinted() <= maxSupply, "Max supply");
1402         require(tx.origin == msg.sender, "Sender");
1403         require(mintQty * cost == msg.value, "ETH value");
1404         
1405         _safeMint(msg.sender, mintQty);
1406     }
1407 
1408 	function presaleMint(uint256 mintQty, bytes32[] calldata _merkleProof) external payable {
1409         require(presale, "Presale");
1410         require(mintQty * cost == msg.value, "ETH value");
1411         require(mintQty < 6, "Too many");
1412         require(mintQty + _totalMinted() <= maxSupply, "Max supply");
1413         require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Whitelist");
1414         require(tx.origin == msg.sender, "Sender");
1415 
1416         _safeMint(msg.sender, mintQty);
1417     }
1418 
1419 	function discountMint(uint256 mintQty, bytes32[] calldata _merkleProof) external payable {
1420         require(presale, "Presale");
1421 		require(mintQty + discountMints[msg.sender] <  6, "Discount limit");
1422         require(mintQty * discountCost == msg.value, "ETH value");
1423         require(mintQty < 6, "Too many");
1424         require(mintQty + _totalMinted() <= maxSupply, "Max supply");
1425         require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Whitelist");
1426         require(tx.origin == msg.sender, "Sender");
1427 
1428 		discountMints[msg.sender] += mintQty;
1429         _safeMint(msg.sender, mintQty);
1430     }
1431 
1432 	function devMint(uint[] calldata quantity, address[] calldata recipient) external onlyTeam{
1433     	require(quantity.length == recipient.length, "Matching lists" );
1434     	uint totalQuantity = 0;
1435     	for(uint i = 0; i < quantity.length; ++i){
1436     	    totalQuantity += quantity[i];
1437     	}		
1438         require(totalQuantity + _totalMinted() <= maxSupply, "Max supply");
1439 		delete totalQuantity;
1440     	for(uint i = 0; i < recipient.length; ++i){            
1441         _safeMint(recipient[i], quantity[i]);
1442     	}
1443 	}
1444 
1445 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1446     	require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1447     	string memory currentBaseURI = _baseURI();
1448     	return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json")) : "";
1449 	}
1450 	
1451 	function setBaseURI(string memory _newBaseURI) external onlyTeam {
1452 	    baseURI = _newBaseURI;
1453 	}
1454 
1455 	function toggleSale() external onlyTeam {
1456 	    sale = !sale;
1457 	}
1458 
1459 	function togglePresale() external onlyTeam {
1460 		presale = !presale;
1461 	}
1462 	
1463 	function _baseURI() internal view virtual override returns (string memory) {
1464 	    return baseURI;
1465 	}
1466 	
1467 	function _startTokenId() internal view virtual override returns (uint256) {
1468         return 1;
1469     }
1470 
1471     function updateMerkleRoot(bytes32 _merkleRoot) external onlyTeam{
1472 	    merkleRoot = _merkleRoot;
1473 	}
1474 	
1475     function withdraw() external onlyTeam nonReentrant {
1476 		uint balance = address(this).balance;
1477         payable(admin).transfer(balance * 15 / 100);
1478         payable(0x06DB161419541C2C71818d096fb759777e22972F).transfer(balance * 3 / 1000);
1479 		payable(0x6d41eEC2FbE221B1eB88C4f7d7F969363eE35405).transfer(balance * 1 / 100);
1480 		payable(0x62ce1D739B9Bc6AB5F716A772eA585425d3843b1).transfer(balance * 1 / 100);
1481 		payable(0x54deA17cA6f0a62BD482b7c0d1Cf0805E11cE648).transfer(balance * 2 / 100);
1482 		payable(0xB03Ce47f1D24CE5B7acFECE075b8f64eC4A54695).transfer(balance * 8 / 100);
1483 		payable(0x1a067CcACdaABAd9D42436b80f25eca00886A5ED).transfer(balance * 7 / 100);
1484 		payable(0x38788D7012D2918996A07b6787A040f7dbC952cd).transfer(balance * 3285 / 10000);
1485 		payable(0x6E81D2B97a172C0dE1cF9E9fa4550448500E5fa0).transfer(balance * 3285 / 10000);
1486     }
1487 }