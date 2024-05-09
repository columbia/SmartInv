1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
49 
50 
51 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev These functions deal with verification of Merkle Trees proofs.
57  *
58  * The proofs can be generated using the JavaScript library
59  * https://github.com/miguelmota/merkletreejs[merkletreejs].
60  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
61  *
62  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
63  */
64 library MerkleProof {
65     /**
66      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
67      * defined by `root`. For this, a `proof` must be provided, containing
68      * sibling hashes on the branch from the leaf to the root of the tree. Each
69      * pair of leaves and each pair of pre-images are assumed to be sorted.
70      */
71     function verify(
72         bytes32[] memory proof,
73         bytes32 root,
74         bytes32 leaf
75     ) internal pure returns (bool) {
76         return processProof(proof, leaf) == root;
77     }
78 
79     /**
80      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
81      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
82      * hash matches the root of the tree. When processing the proof, the pairs
83      * of leafs & pre-images are assumed to be sorted.
84      *
85      * _Available since v4.4._
86      */
87     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
88         bytes32 computedHash = leaf;
89         for (uint256 i = 0; i < proof.length; i++) {
90             bytes32 proofElement = proof[i];
91             if (computedHash <= proofElement) {
92                 // Hash(current computed hash + current element of the proof)
93                 computedHash = _efficientHash(computedHash, proofElement);
94             } else {
95                 // Hash(current element of the proof + current computed hash)
96                 computedHash = _efficientHash(proofElement, computedHash);
97             }
98         }
99         return computedHash;
100     }
101 
102     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
103         assembly {
104             mstore(0x00, a)
105             mstore(0x20, b)
106             value := keccak256(0x00, 0x40)
107         }
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/Strings.sol
112 
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev String operations.
120  */
121 library Strings {
122     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
126      */
127     function toString(uint256 value) internal pure returns (string memory) {
128         // Inspired by OraclizeAPI's implementation - MIT licence
129         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
130 
131         if (value == 0) {
132             return "0";
133         }
134         uint256 temp = value;
135         uint256 digits;
136         while (temp != 0) {
137             digits++;
138             temp /= 10;
139         }
140         bytes memory buffer = new bytes(digits);
141         while (value != 0) {
142             digits -= 1;
143             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
144             value /= 10;
145         }
146         return string(buffer);
147     }
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
151      */
152     function toHexString(uint256 value) internal pure returns (string memory) {
153         if (value == 0) {
154             return "0x00";
155         }
156         uint256 temp = value;
157         uint256 length = 0;
158         while (temp != 0) {
159             length++;
160             temp >>= 8;
161         }
162         return toHexString(value, length);
163     }
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
167      */
168     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
169         bytes memory buffer = new bytes(2 * length + 2);
170         buffer[0] = "0";
171         buffer[1] = "x";
172         for (uint256 i = 2 * length + 1; i > 1; --i) {
173             buffer[i] = _HEX_SYMBOLS[value & 0xf];
174             value >>= 4;
175         }
176         require(value == 0, "Strings: hex length insufficient");
177         return string(buffer);
178     }
179 }
180 
181 // File: @openzeppelin/contracts/utils/Address.sol
182 
183 
184 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
185 
186 pragma solidity ^0.8.1;
187 
188 /**
189  * @dev Collection of functions related to the address type
190  */
191 library Address {
192     /**
193      * @dev Returns true if `account` is a contract.
194      *
195      * [IMPORTANT]
196      * ====
197      * It is unsafe to assume that an address for which this function returns
198      * false is an externally-owned account (EOA) and not a contract.
199      *
200      * Among others, `isContract` will return false for the following
201      * types of addresses:
202      *
203      *  - an externally-owned account
204      *  - a contract in construction
205      *  - an address where a contract will be created
206      *  - an address where a contract lived, but was destroyed
207      * ====
208      *
209      * [IMPORTANT]
210      * ====
211      * You shouldn't rely on `isContract` to protect against flash loan attacks!
212      *
213      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
214      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
215      * constructor.
216      * ====
217      */
218     function isContract(address account) internal view returns (bool) {
219         // This method relies on extcodesize/address.code.length, which returns 0
220         // for contracts in construction, since the code is only stored at the end
221         // of the constructor execution.
222 
223         return account.code.length > 0;
224     }
225 
226     /**
227      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
228      * `recipient`, forwarding all available gas and reverting on errors.
229      *
230      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
231      * of certain opcodes, possibly making contracts go over the 2300 gas limit
232      * imposed by `transfer`, making them unable to receive funds via
233      * `transfer`. {sendValue} removes this limitation.
234      *
235      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
236      *
237      * IMPORTANT: because control is transferred to `recipient`, care must be
238      * taken to not create reentrancy vulnerabilities. Consider using
239      * {ReentrancyGuard} or the
240      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
241      */
242     function sendValue(address payable recipient, uint256 amount) internal {
243         require(address(this).balance >= amount, "Address: insufficient balance");
244 
245         (bool success, ) = recipient.call{value: amount}("");
246         require(success, "Address: unable to send value, recipient may have reverted");
247     }
248 
249     /**
250      * @dev Performs a Solidity function call using a low level `call`. A
251      * plain `call` is an unsafe replacement for a function call: use this
252      * function instead.
253      *
254      * If `target` reverts with a revert reason, it is bubbled up by this
255      * function (like regular Solidity function calls).
256      *
257      * Returns the raw returned data. To convert to the expected return value,
258      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
259      *
260      * Requirements:
261      *
262      * - `target` must be a contract.
263      * - calling `target` with `data` must not revert.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionCall(target, data, "Address: low-level call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
273      * `errorMessage` as a fallback revert reason when `target` reverts.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, 0, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but also transferring `value` wei to `target`.
288      *
289      * Requirements:
290      *
291      * - the calling contract must have an ETH balance of at least `value`.
292      * - the called Solidity function must be `payable`.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value
300     ) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
306      * with `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(address(this).balance >= value, "Address: insufficient balance for call");
317         require(isContract(target), "Address: call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.call{value: value}(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
330         return functionStaticCall(target, data, "Address: low-level static call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal view returns (bytes memory) {
344         require(isContract(target), "Address: static call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.staticcall(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(isContract(target), "Address: delegate call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.delegatecall(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
379      * revert reason using the provided one.
380      *
381      * _Available since v4.3._
382      */
383     function verifyCallResult(
384         bool success,
385         bytes memory returndata,
386         string memory errorMessage
387     ) internal pure returns (bytes memory) {
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
407 
408 
409 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @title ERC721 token receiver interface
415  * @dev Interface for any contract that wants to support safeTransfers
416  * from ERC721 asset contracts.
417  */
418 interface IERC721Receiver {
419     /**
420      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
421      * by `operator` from `from`, this function is called.
422      *
423      * It must return its Solidity selector to confirm the token transfer.
424      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
425      *
426      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
427      */
428     function onERC721Received(
429         address operator,
430         address from,
431         uint256 tokenId,
432         bytes calldata data
433     ) external returns (bytes4);
434 }
435 
436 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
437 
438 
439 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 /**
444  * @dev Interface of the ERC165 standard, as defined in the
445  * https://eips.ethereum.org/EIPS/eip-165[EIP].
446  *
447  * Implementers can declare support of contract interfaces, which can then be
448  * queried by others ({ERC165Checker}).
449  *
450  * For an implementation, see {ERC165}.
451  */
452 interface IERC165 {
453     /**
454      * @dev Returns true if this contract implements the interface defined by
455      * `interfaceId`. See the corresponding
456      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
457      * to learn more about how these ids are created.
458      *
459      * This function call must use less than 30 000 gas.
460      */
461     function supportsInterface(bytes4 interfaceId) external view returns (bool);
462 }
463 
464 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @dev Implementation of the {IERC165} interface.
474  *
475  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
476  * for the additional interface id that will be supported. For example:
477  *
478  * ```solidity
479  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
481  * }
482  * ```
483  *
484  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
485  */
486 abstract contract ERC165 is IERC165 {
487     /**
488      * @dev See {IERC165-supportsInterface}.
489      */
490     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491         return interfaceId == type(IERC165).interfaceId;
492     }
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Required interface of an ERC721 compliant contract.
505  */
506 interface IERC721 is IERC165 {
507     /**
508      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
509      */
510     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
514      */
515     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
516 
517     /**
518      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
519      */
520     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
521 
522     /**
523      * @dev Returns the number of tokens in ``owner``'s account.
524      */
525     function balanceOf(address owner) external view returns (uint256 balance);
526 
527     /**
528      * @dev Returns the owner of the `tokenId` token.
529      *
530      * Requirements:
531      *
532      * - `tokenId` must exist.
533      */
534     function ownerOf(uint256 tokenId) external view returns (address owner);
535 
536     /**
537      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
538      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must exist and be owned by `from`.
545      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
546      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
547      *
548      * Emits a {Transfer} event.
549      */
550     function safeTransferFrom(
551         address from,
552         address to,
553         uint256 tokenId
554     ) external;
555 
556     /**
557      * @dev Transfers `tokenId` token from `from` to `to`.
558      *
559      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
560      *
561      * Requirements:
562      *
563      * - `from` cannot be the zero address.
564      * - `to` cannot be the zero address.
565      * - `tokenId` token must be owned by `from`.
566      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
567      *
568      * Emits a {Transfer} event.
569      */
570     function transferFrom(
571         address from,
572         address to,
573         uint256 tokenId
574     ) external;
575 
576     /**
577      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
578      * The approval is cleared when the token is transferred.
579      *
580      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
581      *
582      * Requirements:
583      *
584      * - The caller must own the token or be an approved operator.
585      * - `tokenId` must exist.
586      *
587      * Emits an {Approval} event.
588      */
589     function approve(address to, uint256 tokenId) external;
590 
591     /**
592      * @dev Returns the account approved for `tokenId` token.
593      *
594      * Requirements:
595      *
596      * - `tokenId` must exist.
597      */
598     function getApproved(uint256 tokenId) external view returns (address operator);
599 
600     /**
601      * @dev Approve or remove `operator` as an operator for the caller.
602      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
603      *
604      * Requirements:
605      *
606      * - The `operator` cannot be the caller.
607      *
608      * Emits an {ApprovalForAll} event.
609      */
610     function setApprovalForAll(address operator, bool _approved) external;
611 
612     /**
613      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
614      *
615      * See {setApprovalForAll}
616      */
617     function isApprovedForAll(address owner, address operator) external view returns (bool);
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must exist and be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
629      *
630      * Emits a {Transfer} event.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId,
636         bytes calldata data
637     ) external;
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
641 
642 
643 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
650  * @dev See https://eips.ethereum.org/EIPS/eip-721
651  */
652 interface IERC721Enumerable is IERC721 {
653     /**
654      * @dev Returns the total amount of tokens stored by the contract.
655      */
656     function totalSupply() external view returns (uint256);
657 
658     /**
659      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
660      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
661      */
662     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
663 
664     /**
665      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
666      * Use along with {totalSupply} to enumerate all tokens.
667      */
668     function tokenByIndex(uint256 index) external view returns (uint256);
669 }
670 
671 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 
679 /**
680  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
681  * @dev See https://eips.ethereum.org/EIPS/eip-721
682  */
683 interface IERC721Metadata is IERC721 {
684     /**
685      * @dev Returns the token collection name.
686      */
687     function name() external view returns (string memory);
688 
689     /**
690      * @dev Returns the token collection symbol.
691      */
692     function symbol() external view returns (string memory);
693 
694     /**
695      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
696      */
697     function tokenURI(uint256 tokenId) external view returns (string memory);
698 }
699 
700 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 /**
708  * @dev Contract module that helps prevent reentrant calls to a function.
709  *
710  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
711  * available, which can be applied to functions to make sure there are no nested
712  * (reentrant) calls to them.
713  *
714  * Note that because there is a single `nonReentrant` guard, functions marked as
715  * `nonReentrant` may not call one another. This can be worked around by making
716  * those functions `private`, and then adding `external` `nonReentrant` entry
717  * points to them.
718  *
719  * TIP: If you would like to learn more about reentrancy and alternative ways
720  * to protect against it, check out our blog post
721  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
722  */
723 abstract contract ReentrancyGuard {
724     // Booleans are more expensive than uint256 or any type that takes up a full
725     // word because each write operation emits an extra SLOAD to first read the
726     // slot's contents, replace the bits taken up by the boolean, and then write
727     // back. This is the compiler's defense against contract upgrades and
728     // pointer aliasing, and it cannot be disabled.
729 
730     // The values being non-zero value makes deployment a bit more expensive,
731     // but in exchange the refund on every call to nonReentrant will be lower in
732     // amount. Since refunds are capped to a percentage of the total
733     // transaction's gas, it is best to keep them low in cases like this one, to
734     // increase the likelihood of the full refund coming into effect.
735     uint256 private constant _NOT_ENTERED = 1;
736     uint256 private constant _ENTERED = 2;
737 
738     uint256 private _status;
739 
740     constructor() {
741         _status = _NOT_ENTERED;
742     }
743 
744     /**
745      * @dev Prevents a contract from calling itself, directly or indirectly.
746      * Calling a `nonReentrant` function from another `nonReentrant`
747      * function is not supported. It is possible to prevent this from happening
748      * by making the `nonReentrant` function external, and making it call a
749      * `private` function that does the actual work.
750      */
751     modifier nonReentrant() {
752         // On the first call to nonReentrant, _notEntered will be true
753         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
754 
755         // Any calls to nonReentrant after this point will fail
756         _status = _ENTERED;
757 
758         _;
759 
760         // By storing the original value once again, a refund is triggered (see
761         // https://eips.ethereum.org/EIPS/eip-2200)
762         _status = _NOT_ENTERED;
763     }
764 }
765 
766 // File: @openzeppelin/contracts/utils/Context.sol
767 
768 
769 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 /**
774  * @dev Provides information about the current execution context, including the
775  * sender of the transaction and its data. While these are generally available
776  * via msg.sender and msg.data, they should not be accessed in such a direct
777  * manner, since when dealing with meta-transactions the account sending and
778  * paying for execution may not be the actual sender (as far as an application
779  * is concerned).
780  *
781  * This contract is only required for intermediate, library-like contracts.
782  */
783 abstract contract Context {
784     function _msgSender() internal view virtual returns (address) {
785         return msg.sender;
786     }
787 
788     function _msgData() internal view virtual returns (bytes calldata) {
789         return msg.data;
790     }
791 }
792 
793 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
794 
795 
796 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
797 
798 pragma solidity ^0.8.0;
799 
800 
801 
802 
803 
804 
805 
806 
807 /**
808  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
809  * the Metadata extension, but not including the Enumerable extension, which is available separately as
810  * {ERC721Enumerable}.
811  */
812 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
813     using Address for address;
814     using Strings for uint256;
815 
816     // Token name
817     string private _name;
818 
819     // Token symbol
820     string private _symbol;
821 
822     // Mapping from token ID to owner address
823     mapping(uint256 => address) private _owners;
824 
825     // Mapping owner address to token count
826     mapping(address => uint256) private _balances;
827 
828     // Mapping from token ID to approved address
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     /**
835      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
836      */
837     constructor(string memory name_, string memory symbol_) {
838         _name = name_;
839         _symbol = symbol_;
840     }
841 
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
846         return
847             interfaceId == type(IERC721).interfaceId ||
848             interfaceId == type(IERC721Metadata).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev See {IERC721-balanceOf}.
854      */
855     function balanceOf(address owner) public view virtual override returns (uint256) {
856         require(owner != address(0), "ERC721: balance query for the zero address");
857         return _balances[owner];
858     }
859 
860     /**
861      * @dev See {IERC721-ownerOf}.
862      */
863     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
864         address owner = _owners[tokenId];
865         require(owner != address(0), "ERC721: owner query for nonexistent token");
866         return owner;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-name}.
871      */
872     function name() public view virtual override returns (string memory) {
873         return _name;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-symbol}.
878      */
879     function symbol() public view virtual override returns (string memory) {
880         return _symbol;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-tokenURI}.
885      */
886     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
887         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
888 
889         string memory baseURI = _baseURI();
890         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
891     }
892 
893     /**
894      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
895      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
896      * by default, can be overriden in child contracts.
897      */
898     function _baseURI() internal view virtual returns (string memory) {
899         return "";
900     }
901 
902     /**
903      * @dev See {IERC721-approve}.
904      */
905     function approve(address to, uint256 tokenId) public virtual override {
906         address owner = ERC721.ownerOf(tokenId);
907         require(to != owner, "ERC721: approval to current owner");
908 
909         require(
910             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
911             "ERC721: approve caller is not owner nor approved for all"
912         );
913 
914         _approve(to, tokenId);
915     }
916 
917     /**
918      * @dev See {IERC721-getApproved}.
919      */
920     function getApproved(uint256 tokenId) public view virtual override returns (address) {
921         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
922 
923         return _tokenApprovals[tokenId];
924     }
925 
926     /**
927      * @dev See {IERC721-setApprovalForAll}.
928      */
929     function setApprovalForAll(address operator, bool approved) public virtual override {
930         _setApprovalForAll(_msgSender(), operator, approved);
931     }
932 
933     /**
934      * @dev See {IERC721-isApprovedForAll}.
935      */
936     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev See {IERC721-transferFrom}.
942      */
943     function transferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         //solhint-disable-next-line max-line-length
949         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
950 
951         _transfer(from, to, tokenId);
952     }
953 
954     /**
955      * @dev See {IERC721-safeTransferFrom}.
956      */
957     function safeTransferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         safeTransferFrom(from, to, tokenId, "");
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) public virtual override {
974         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
975         _safeTransfer(from, to, tokenId, _data);
976     }
977 
978     /**
979      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
980      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
981      *
982      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
983      *
984      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
985      * implement alternative mechanisms to perform token transfer, such as signature-based.
986      *
987      * Requirements:
988      *
989      * - `from` cannot be the zero address.
990      * - `to` cannot be the zero address.
991      * - `tokenId` token must exist and be owned by `from`.
992      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _safeTransfer(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) internal virtual {
1002         _transfer(from, to, tokenId);
1003         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1004     }
1005 
1006     /**
1007      * @dev Returns whether `tokenId` exists.
1008      *
1009      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1010      *
1011      * Tokens start existing when they are minted (`_mint`),
1012      * and stop existing when they are burned (`_burn`).
1013      */
1014     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1015         return _owners[tokenId] != address(0);
1016     }
1017 
1018     /**
1019      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must exist.
1024      */
1025     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1026         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1027         address owner = ERC721.ownerOf(tokenId);
1028         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1029     }
1030 
1031     /**
1032      * @dev Safely mints `tokenId` and transfers it to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must not exist.
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _safeMint(address to, uint256 tokenId) internal virtual {
1042         _safeMint(to, tokenId, "");
1043     }
1044 
1045     /**
1046      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1047      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1048      */
1049     function _safeMint(
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) internal virtual {
1054         _mint(to, tokenId);
1055         require(
1056             _checkOnERC721Received(address(0), to, tokenId, _data),
1057             "ERC721: transfer to non ERC721Receiver implementer"
1058         );
1059     }
1060 
1061     /**
1062      * @dev Mints `tokenId` and transfers it to `to`.
1063      *
1064      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must not exist.
1069      * - `to` cannot be the zero address.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(address to, uint256 tokenId) internal virtual {
1074         require(to != address(0), "ERC721: mint to the zero address");
1075         require(!_exists(tokenId), "ERC721: token already minted");
1076 
1077         _beforeTokenTransfer(address(0), to, tokenId);
1078 
1079         _balances[to] += 1;
1080         _owners[tokenId] = to;
1081 
1082         emit Transfer(address(0), to, tokenId);
1083 
1084         _afterTokenTransfer(address(0), to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev Destroys `tokenId`.
1089      * The approval is cleared when the token is burned.
1090      *
1091      * Requirements:
1092      *
1093      * - `tokenId` must exist.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _burn(uint256 tokenId) internal virtual {
1098         address owner = ERC721.ownerOf(tokenId);
1099 
1100         _beforeTokenTransfer(owner, address(0), tokenId);
1101 
1102         // Clear approvals
1103         _approve(address(0), tokenId);
1104 
1105         _balances[owner] -= 1;
1106         delete _owners[tokenId];
1107 
1108         emit Transfer(owner, address(0), tokenId);
1109 
1110         _afterTokenTransfer(owner, address(0), tokenId);
1111     }
1112 
1113     /**
1114      * @dev Transfers `tokenId` from `from` to `to`.
1115      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1116      *
1117      * Requirements:
1118      *
1119      * - `to` cannot be the zero address.
1120      * - `tokenId` token must be owned by `from`.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _transfer(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) internal virtual {
1129         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1130         require(to != address(0), "ERC721: transfer to the zero address");
1131 
1132         _beforeTokenTransfer(from, to, tokenId);
1133 
1134         // Clear approvals from the previous owner
1135         _approve(address(0), tokenId);
1136 
1137         _balances[from] -= 1;
1138         _balances[to] += 1;
1139         _owners[tokenId] = to;
1140 
1141         emit Transfer(from, to, tokenId);
1142 
1143         _afterTokenTransfer(from, to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev Approve `to` to operate on `tokenId`
1148      *
1149      * Emits a {Approval} event.
1150      */
1151     function _approve(address to, uint256 tokenId) internal virtual {
1152         _tokenApprovals[tokenId] = to;
1153         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev Approve `operator` to operate on all of `owner` tokens
1158      *
1159      * Emits a {ApprovalForAll} event.
1160      */
1161     function _setApprovalForAll(
1162         address owner,
1163         address operator,
1164         bool approved
1165     ) internal virtual {
1166         require(owner != operator, "ERC721: approve to caller");
1167         _operatorApprovals[owner][operator] = approved;
1168         emit ApprovalForAll(owner, operator, approved);
1169     }
1170 
1171     /**
1172      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1173      * The call is not executed if the target address is not a contract.
1174      *
1175      * @param from address representing the previous owner of the given token ID
1176      * @param to target address that will receive the tokens
1177      * @param tokenId uint256 ID of the token to be transferred
1178      * @param _data bytes optional data to send along with the call
1179      * @return bool whether the call correctly returned the expected magic value
1180      */
1181     function _checkOnERC721Received(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes memory _data
1186     ) private returns (bool) {
1187         if (to.isContract()) {
1188             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1189                 return retval == IERC721Receiver.onERC721Received.selector;
1190             } catch (bytes memory reason) {
1191                 if (reason.length == 0) {
1192                     revert("ERC721: transfer to non ERC721Receiver implementer");
1193                 } else {
1194                     assembly {
1195                         revert(add(32, reason), mload(reason))
1196                     }
1197                 }
1198             }
1199         } else {
1200             return true;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Hook that is called before any token transfer. This includes minting
1206      * and burning.
1207      *
1208      * Calling conditions:
1209      *
1210      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1211      * transferred to `to`.
1212      * - When `from` is zero, `tokenId` will be minted for `to`.
1213      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1214      * - `from` and `to` are never both zero.
1215      *
1216      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1217      */
1218     function _beforeTokenTransfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) internal virtual {}
1223 
1224     /**
1225      * @dev Hook that is called after any transfer of tokens. This includes
1226      * minting and burning.
1227      *
1228      * Calling conditions:
1229      *
1230      * - when `from` and `to` are both non-zero.
1231      * - `from` and `to` are never both zero.
1232      *
1233      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1234      */
1235     function _afterTokenTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) internal virtual {}
1240 }
1241 
1242 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1243 
1244 
1245 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 
1250 
1251 /**
1252  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1253  * enumerability of all the token ids in the contract as well as all token ids owned by each
1254  * account.
1255  */
1256 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1257     // Mapping from owner to list of owned token IDs
1258     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1259 
1260     // Mapping from token ID to index of the owner tokens list
1261     mapping(uint256 => uint256) private _ownedTokensIndex;
1262 
1263     // Array with all token ids, used for enumeration
1264     uint256[] private _allTokens;
1265 
1266     // Mapping from token id to position in the allTokens array
1267     mapping(uint256 => uint256) private _allTokensIndex;
1268 
1269     /**
1270      * @dev See {IERC165-supportsInterface}.
1271      */
1272     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1273         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1274     }
1275 
1276     /**
1277      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1278      */
1279     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1280         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1281         return _ownedTokens[owner][index];
1282     }
1283 
1284     /**
1285      * @dev See {IERC721Enumerable-totalSupply}.
1286      */
1287     function totalSupply() public view virtual override returns (uint256) {
1288         return _allTokens.length;
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Enumerable-tokenByIndex}.
1293      */
1294     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1295         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1296         return _allTokens[index];
1297     }
1298 
1299     /**
1300      * @dev Hook that is called before any token transfer. This includes minting
1301      * and burning.
1302      *
1303      * Calling conditions:
1304      *
1305      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1306      * transferred to `to`.
1307      * - When `from` is zero, `tokenId` will be minted for `to`.
1308      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1309      * - `from` cannot be the zero address.
1310      * - `to` cannot be the zero address.
1311      *
1312      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1313      */
1314     function _beforeTokenTransfer(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) internal virtual override {
1319         super._beforeTokenTransfer(from, to, tokenId);
1320 
1321         if (from == address(0)) {
1322             _addTokenToAllTokensEnumeration(tokenId);
1323         } else if (from != to) {
1324             _removeTokenFromOwnerEnumeration(from, tokenId);
1325         }
1326         if (to == address(0)) {
1327             _removeTokenFromAllTokensEnumeration(tokenId);
1328         } else if (to != from) {
1329             _addTokenToOwnerEnumeration(to, tokenId);
1330         }
1331     }
1332 
1333     /**
1334      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1335      * @param to address representing the new owner of the given token ID
1336      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1337      */
1338     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1339         uint256 length = ERC721.balanceOf(to);
1340         _ownedTokens[to][length] = tokenId;
1341         _ownedTokensIndex[tokenId] = length;
1342     }
1343 
1344     /**
1345      * @dev Private function to add a token to this extension's token tracking data structures.
1346      * @param tokenId uint256 ID of the token to be added to the tokens list
1347      */
1348     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1349         _allTokensIndex[tokenId] = _allTokens.length;
1350         _allTokens.push(tokenId);
1351     }
1352 
1353     /**
1354      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1355      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1356      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1357      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1358      * @param from address representing the previous owner of the given token ID
1359      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1360      */
1361     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1362         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1363         // then delete the last slot (swap and pop).
1364 
1365         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1366         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1367 
1368         // When the token to delete is the last token, the swap operation is unnecessary
1369         if (tokenIndex != lastTokenIndex) {
1370             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1371 
1372             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1373             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1374         }
1375 
1376         // This also deletes the contents at the last position of the array
1377         delete _ownedTokensIndex[tokenId];
1378         delete _ownedTokens[from][lastTokenIndex];
1379     }
1380 
1381     /**
1382      * @dev Private function to remove a token from this extension's token tracking data structures.
1383      * This has O(1) time complexity, but alters the order of the _allTokens array.
1384      * @param tokenId uint256 ID of the token to be removed from the tokens list
1385      */
1386     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1387         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1388         // then delete the last slot (swap and pop).
1389 
1390         uint256 lastTokenIndex = _allTokens.length - 1;
1391         uint256 tokenIndex = _allTokensIndex[tokenId];
1392 
1393         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1394         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1395         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1396         uint256 lastTokenId = _allTokens[lastTokenIndex];
1397 
1398         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1399         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1400 
1401         // This also deletes the contents at the last position of the array
1402         delete _allTokensIndex[tokenId];
1403         _allTokens.pop();
1404     }
1405 }
1406 
1407 // File: @openzeppelin/contracts/access/Ownable.sol
1408 
1409 
1410 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 
1415 /**
1416  * @dev Contract module which provides a basic access control mechanism, where
1417  * there is an account (an owner) that can be granted exclusive access to
1418  * specific functions.
1419  *
1420  * By default, the owner account will be the one that deploys the contract. This
1421  * can later be changed with {transferOwnership}.
1422  *
1423  * This module is used through inheritance. It will make available the modifier
1424  * `onlyOwner`, which can be applied to your functions to restrict their use to
1425  * the owner.
1426  */
1427 abstract contract Ownable is Context {
1428     address private _owner;
1429 
1430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1431 
1432     /**
1433      * @dev Initializes the contract setting the deployer as the initial owner.
1434      */
1435     constructor() {
1436         _transferOwnership(_msgSender());
1437     }
1438 
1439     /**
1440      * @dev Returns the address of the current owner.
1441      */
1442     function owner() public view virtual returns (address) {
1443         return _owner;
1444     }
1445 
1446     /**
1447      * @dev Throws if called by any account other than the owner.
1448      */
1449     modifier onlyOwner() {
1450         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1451         _;
1452     }
1453 
1454     /**
1455      * @dev Leaves the contract without owner. It will not be possible to call
1456      * `onlyOwner` functions anymore. Can only be called by the current owner.
1457      *
1458      * NOTE: Renouncing ownership will leave the contract without an owner,
1459      * thereby removing any functionality that is only available to the owner.
1460      */
1461     function renounceOwnership() public virtual onlyOwner {
1462         _transferOwnership(address(0));
1463     }
1464 
1465     /**
1466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1467      * Can only be called by the current owner.
1468      */
1469     function transferOwnership(address newOwner) public virtual onlyOwner {
1470         require(newOwner != address(0), "Ownable: new owner is the zero address");
1471         _transferOwnership(newOwner);
1472     }
1473 
1474     /**
1475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1476      * Internal function without access restriction.
1477      */
1478     function _transferOwnership(address newOwner) internal virtual {
1479         address oldOwner = _owner;
1480         _owner = newOwner;
1481         emit OwnershipTransferred(oldOwner, newOwner);
1482     }
1483 }
1484 
1485 // File: contracts/Ethereal.sol
1486 
1487 
1488 pragma solidity ^0.8.0;
1489 
1490 contract ETHEREAL is ERC721Enumerable, Ownable, ReentrancyGuard {
1491     using Counters for Counters.Counter;
1492     using Strings for uint256;
1493 
1494     uint256 public ETHEREAL_PUBLIC = 10000;
1495     uint256 public PURCHASE_LIMIT = 2;
1496     uint256 public PRICE = 0.2 ether;
1497     uint256 public allowListMaxMint = 2;
1498     string public notRevealedUri;
1499     string public baseExtension = ".json";
1500     string private _tokenBaseURI = "";
1501     bool private _isActive = false;
1502     bool public isAllowListActive = false;
1503     bool public revealed = false;
1504     bytes32 public merkleRoot;
1505 
1506     mapping(address => uint256) private _allowListClaimed;
1507 
1508     Counters.Counter private _publicETHEREAL;
1509 
1510     constructor(
1511         string memory _name,
1512         string memory _symbol,
1513         string memory _initNotRevealedUri
1514     ) ERC721(_name, _symbol) {
1515         setNotRevealedURI(_initNotRevealedUri);
1516         ownerMinting(msg.sender, 192);
1517     }
1518 
1519     function allowListClaimedBy(address owner) external view returns (uint256){
1520         require(owner != address(0), "Zero address not on Allow List");
1521         return _allowListClaimed[owner];
1522     }
1523     
1524     function purchaseAllowList(uint256 numberOfTokens, bytes32[] calldata _merkleProof) external payable {
1525 
1526         require(
1527             numberOfTokens <= PURCHASE_LIMIT,
1528             "Can only mint up to 2 token"
1529         );
1530         
1531         require(isAllowListActive, "Allow List is not active");
1532         require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "INVALID_WHITELIST_PROOF");
1533         require(
1534             _publicETHEREAL.current() < ETHEREAL_PUBLIC,
1535             "Purchase would exceed max"
1536         );
1537         require(numberOfTokens <= allowListMaxMint, "Cannot purchase this many tokens");
1538         require(_allowListClaimed[msg.sender] + numberOfTokens <= allowListMaxMint, "Purchase exceeds max allowed");
1539         require(PRICE * numberOfTokens <= msg.value, "ETH amount is not sufficient");
1540         require(
1541             _publicETHEREAL.current() < ETHEREAL_PUBLIC,
1542             "Purchase would exceed ETHEREAL_PUBLIC"
1543         );
1544         for (uint256 i = 0; i < numberOfTokens; i++) {
1545             uint256 tokenId = _publicETHEREAL.current();
1546 
1547             if (_publicETHEREAL.current() < ETHEREAL_PUBLIC) {
1548                 _publicETHEREAL.increment();
1549                 _allowListClaimed[msg.sender] += 1;
1550                 _safeMint(msg.sender, tokenId +1);
1551             }
1552         }
1553     }
1554 
1555     function purchase(uint256 numberOfTokens) external payable nonReentrant {
1556         require(_isActive, "Contract is not active");
1557         require(
1558             numberOfTokens <= PURCHASE_LIMIT,
1559             "Can only mint up to 2 tokens"
1560         );
1561         require(
1562             _publicETHEREAL.current() < ETHEREAL_PUBLIC,
1563             "Purchase would exceed ETHEREAL_PUBLIC"
1564         );
1565 
1566         require(_allowListClaimed[msg.sender] + numberOfTokens <= allowListMaxMint, "Purchase exceeds max allowed");
1567         require(
1568             PRICE * numberOfTokens <= msg.value,
1569             "ETH amount is not sufficient"
1570         );
1571 
1572         for (uint256 i = 0; i < numberOfTokens; i++) {
1573             uint256 tokenId = _publicETHEREAL.current();
1574 
1575             if (_publicETHEREAL.current() < ETHEREAL_PUBLIC) {
1576                 _publicETHEREAL.increment();
1577                 _allowListClaimed[msg.sender] += 1;
1578                 _safeMint(msg.sender, tokenId +1);
1579             }
1580         }
1581     }
1582 
1583     function tokenURI(uint256 tokenId)
1584         public
1585         view
1586         virtual
1587         override(ERC721)
1588         returns (string memory)
1589     {
1590         require(_exists(tokenId), "Token does not exist");
1591 
1592         if(revealed == false) {
1593             return notRevealedUri;
1594         }
1595 
1596         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString(), baseExtension));
1597     }
1598 
1599     // ONLY OWNER FUNCTIONS
1600     function ownerMinting(address to, uint256 numberOfTokens)
1601         public
1602         payable
1603         onlyOwner
1604     {
1605         require(
1606             _publicETHEREAL.current() < ETHEREAL_PUBLIC,
1607             "Purchase would exceed ETHEREAL_PUBLIC"
1608         );
1609 
1610         for (uint256 i = 0; i < numberOfTokens; i++) {
1611             uint256 tokenId = _publicETHEREAL.current();
1612 
1613             if (_publicETHEREAL.current() < ETHEREAL_PUBLIC) {
1614                 _publicETHEREAL.increment();
1615                 _safeMint(to, tokenId +1);
1616             }
1617         }
1618     }
1619 
1620     function setActive(bool isActive) external onlyOwner {
1621         _isActive = isActive;
1622     }
1623 
1624     function setBaseURI(string memory URI) external onlyOwner {
1625         _tokenBaseURI = URI;
1626     }
1627 
1628     function reveal() public onlyOwner() {
1629       revealed = true;
1630     }
1631 
1632     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1633         notRevealedUri = _notRevealedURI;
1634     }
1635 
1636     function setMerkleRoot (bytes32 _newMerkleRoot) external onlyOwner {
1637         merkleRoot = _newMerkleRoot;
1638     }
1639 
1640     function setIsAllowListActive(bool _isAllowListActive) external onlyOwner {
1641         isAllowListActive = _isAllowListActive;
1642     }
1643 
1644     function setAllowListMaxMint(uint256 maxMint) external onlyOwner {
1645         allowListMaxMint = maxMint;
1646     }
1647 
1648     function setPublicMax(uint256 _newMax) public onlyOwner() {
1649         ETHEREAL_PUBLIC = _newMax;
1650     }
1651 
1652     function setPurchaseLimit(uint256 _newPurchaseMax) public onlyOwner() {
1653         PURCHASE_LIMIT = _newPurchaseMax;
1654     }
1655 
1656     function setPrice(uint256 _newPrice) public onlyOwner() {
1657         PRICE = _newPrice;
1658     }
1659   
1660     function withdraw() external onlyOwner {
1661         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1662         require(success);
1663     }
1664 }