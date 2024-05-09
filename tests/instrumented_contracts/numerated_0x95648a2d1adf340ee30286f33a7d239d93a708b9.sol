1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev These functions deal with verification of Merkle Trees proofs.
9  *
10  * The proofs can be generated using the JavaScript library
11  * https://github.com/miguelmota/merkletreejs[merkletreejs].
12  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
13  *
14  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
15  */
16 library MerkleProof {
17     /**
18      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
19      * defined by `root`. For this, a `proof` must be provided, containing
20      * sibling hashes on the branch from the leaf to the root of the tree. Each
21      * pair of leaves and each pair of pre-images are assumed to be sorted.
22      */
23     function verify(
24         bytes32[] memory proof,
25         bytes32 root,
26         bytes32 leaf
27     ) internal pure returns (bool) {
28         return processProof(proof, leaf) == root;
29     }
30 
31     /**
32      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
33      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
34      * hash matches the root of the tree. When processing the proof, the pairs
35      * of leafs & pre-images are assumed to be sorted.
36      *
37      * _Available since v4.4._
38      */
39     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
40         bytes32 computedHash = leaf;
41         for (uint256 i = 0; i < proof.length; i++) {
42             bytes32 proofElement = proof[i];
43             if (computedHash <= proofElement) {
44                 // Hash(current computed hash + current element of the proof)
45                 computedHash = _efficientHash(computedHash, proofElement);
46             } else {
47                 // Hash(current element of the proof + current computed hash)
48                 computedHash = _efficientHash(proofElement, computedHash);
49             }
50         }
51         return computedHash;
52     }
53 
54     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
55         assembly {
56             mstore(0x00, a)
57             mstore(0x20, b)
58             value := keccak256(0x00, 0x40)
59         }
60     }
61 }
62 
63 // File: @openzeppelin/contracts/utils/Strings.sol
64 
65 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
66 
67 pragma solidity ^0.8.0;
68 
69 /**
70  * @dev String operations.
71  */
72 library Strings {
73     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
77      */
78     function toString(uint256 value) internal pure returns (string memory) {
79         // Inspired by OraclizeAPI's implementation - MIT licence
80         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
81 
82         if (value == 0) {
83             return "0";
84         }
85         uint256 temp = value;
86         uint256 digits;
87         while (temp != 0) {
88             digits++;
89             temp /= 10;
90         }
91         bytes memory buffer = new bytes(digits);
92         while (value != 0) {
93             digits -= 1;
94             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
95             value /= 10;
96         }
97         return string(buffer);
98     }
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
102      */
103     function toHexString(uint256 value) internal pure returns (string memory) {
104         if (value == 0) {
105             return "0x00";
106         }
107         uint256 temp = value;
108         uint256 length = 0;
109         while (temp != 0) {
110             length++;
111             temp >>= 8;
112         }
113         return toHexString(value, length);
114     }
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
118      */
119     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
120         bytes memory buffer = new bytes(2 * length + 2);
121         buffer[0] = "0";
122         buffer[1] = "x";
123         for (uint256 i = 2 * length + 1; i > 1; --i) {
124             buffer[i] = _HEX_SYMBOLS[value & 0xf];
125             value >>= 4;
126         }
127         require(value == 0, "Strings: hex length insufficient");
128         return string(buffer);
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/Address.sol
133 
134 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
135 
136 pragma solidity ^0.8.1;
137 
138 /**
139  * @dev Collection of functions related to the address type
140  */
141 library Address {
142     /**
143      * @dev Returns true if `account` is a contract.
144      *
145      * [IMPORTANT]
146      * ====
147      * It is unsafe to assume that an address for which this function returns
148      * false is an externally-owned account (EOA) and not a contract.
149      *
150      * Among others, `isContract` will return false for the following
151      * types of addresses:
152      *
153      *  - an externally-owned account
154      *  - a contract in construction
155      *  - an address where a contract will be created
156      *  - an address where a contract lived, but was destroyed
157      * ====
158      *
159      * [IMPORTANT]
160      * ====
161      * You shouldn't rely on `isContract` to protect against flash loan attacks!
162      *
163      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
164      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
165      * constructor.
166      * ====
167      */
168     function isContract(address account) internal view returns (bool) {
169         // This method relies on extcodesize/address.code.length, which returns 0
170         // for contracts in construction, since the code is only stored at the end
171         // of the constructor execution.
172 
173         return account.code.length > 0;
174     }
175 
176     /**
177      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
178      * `recipient`, forwarding all available gas and reverting on errors.
179      *
180      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
181      * of certain opcodes, possibly making contracts go over the 2300 gas limit
182      * imposed by `transfer`, making them unable to receive funds via
183      * `transfer`. {sendValue} removes this limitation.
184      *
185      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
186      *
187      * IMPORTANT: because control is transferred to `recipient`, care must be
188      * taken to not create reentrancy vulnerabilities. Consider using
189      * {ReentrancyGuard} or the
190      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
191      */
192     function sendValue(address payable recipient, uint256 amount) internal {
193         require(address(this).balance >= amount, "Address: insufficient balance");
194 
195         (bool success, ) = recipient.call{value: amount}("");
196         require(success, "Address: unable to send value, recipient may have reverted");
197     }
198 
199     /**
200      * @dev Performs a Solidity function call using a low level `call`. A
201      * plain `call` is an unsafe replacement for a function call: use this
202      * function instead.
203      *
204      * If `target` reverts with a revert reason, it is bubbled up by this
205      * function (like regular Solidity function calls).
206      *
207      * Returns the raw returned data. To convert to the expected return value,
208      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
209      *
210      * Requirements:
211      *
212      * - `target` must be a contract.
213      * - calling `target` with `data` must not revert.
214      *
215      * _Available since v3.1._
216      */
217     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
218         return functionCall(target, data, "Address: low-level call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
223      * `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         return functionCallWithValue(target, data, 0, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but also transferring `value` wei to `target`.
238      *
239      * Requirements:
240      *
241      * - the calling contract must have an ETH balance of at least `value`.
242      * - the called Solidity function must be `payable`.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
256      * with `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(address(this).balance >= value, "Address: insufficient balance for call");
267         require(isContract(target), "Address: call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.call{value: value}(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
275      * but performing a static call.
276      *
277      * _Available since v3.3._
278      */
279     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
280         return functionStaticCall(target, data, "Address: low-level static call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
285      * but performing a static call.
286      *
287      * _Available since v3.3._
288      */
289     function functionStaticCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal view returns (bytes memory) {
294         require(isContract(target), "Address: static call to non-contract");
295 
296         (bool success, bytes memory returndata) = target.staticcall(data);
297         return verifyCallResult(success, returndata, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but performing a delegate call.
303      *
304      * _Available since v3.4._
305      */
306     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
312      * but performing a delegate call.
313      *
314      * _Available since v3.4._
315      */
316     function functionDelegateCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         require(isContract(target), "Address: delegate call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.delegatecall(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
329      * revert reason using the provided one.
330      *
331      * _Available since v4.3._
332      */
333     function verifyCallResult(
334         bool success,
335         bytes memory returndata,
336         string memory errorMessage
337     ) internal pure returns (bytes memory) {
338         if (success) {
339             return returndata;
340         } else {
341             // Look for revert reason and bubble it up if present
342             if (returndata.length > 0) {
343                 // The easiest way to bubble the revert reason is using memory via assembly
344 
345                 assembly {
346                     let returndata_size := mload(returndata)
347                     revert(add(32, returndata), returndata_size)
348                 }
349             } else {
350                 revert(errorMessage);
351             }
352         }
353     }
354 }
355 
356 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
357 
358 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @title ERC721 token receiver interface
364  * @dev Interface for any contract that wants to support safeTransfers
365  * from ERC721 asset contracts.
366  */
367 interface IERC721Receiver {
368     /**
369      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
370      * by `operator` from `from`, this function is called.
371      *
372      * It must return its Solidity selector to confirm the token transfer.
373      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
374      *
375      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
376      */
377     function onERC721Received(
378         address operator,
379         address from,
380         uint256 tokenId,
381         bytes calldata data
382     ) external returns (bytes4);
383 }
384 
385 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
386 
387 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @dev Interface of the ERC165 standard, as defined in the
393  * https://eips.ethereum.org/EIPS/eip-165[EIP].
394  *
395  * Implementers can declare support of contract interfaces, which can then be
396  * queried by others ({ERC165Checker}).
397  *
398  * For an implementation, see {ERC165}.
399  */
400 interface IERC165 {
401     /**
402      * @dev Returns true if this contract implements the interface defined by
403      * `interfaceId`. See the corresponding
404      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
405      * to learn more about how these ids are created.
406      *
407      * This function call must use less than 30 000 gas.
408      */
409     function supportsInterface(bytes4 interfaceId) external view returns (bool);
410 }
411 
412 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
413 
414 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 
419 /**
420  * @dev Implementation of the {IERC165} interface.
421  *
422  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
423  * for the additional interface id that will be supported. For example:
424  *
425  * ```solidity
426  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
427  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
428  * }
429  * ```
430  *
431  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
432  */
433 abstract contract ERC165 is IERC165 {
434     /**
435      * @dev See {IERC165-supportsInterface}.
436      */
437     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
438         return interfaceId == type(IERC165).interfaceId;
439     }
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
443 
444 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Required interface of an ERC721 compliant contract.
450  */
451 interface IERC721 is IERC165 {
452     /**
453      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
454      */
455     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
456 
457     /**
458      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
459      */
460     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
461 
462     /**
463      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
464      */
465     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
466 
467     /**
468      * @dev Returns the number of tokens in ``owner``'s account.
469      */
470     function balanceOf(address owner) external view returns (uint256 balance);
471 
472     /**
473      * @dev Returns the owner of the `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function ownerOf(uint256 tokenId) external view returns (address owner);
480 
481     /**
482      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
483      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
484      *
485      * Requirements:
486      *
487      * - `from` cannot be the zero address.
488      * - `to` cannot be the zero address.
489      * - `tokenId` token must exist and be owned by `from`.
490      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
491      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
492      *
493      * Emits a {Transfer} event.
494      */
495     function safeTransferFrom(
496         address from,
497         address to,
498         uint256 tokenId
499     ) external;
500 
501     /**
502      * @dev Transfers `tokenId` token from `from` to `to`.
503      *
504      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `tokenId` token must be owned by `from`.
511      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
512      *
513      * Emits a {Transfer} event.
514      */
515     function transferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external;
520 
521     /**
522      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
523      * The approval is cleared when the token is transferred.
524      *
525      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
526      *
527      * Requirements:
528      *
529      * - The caller must own the token or be an approved operator.
530      * - `tokenId` must exist.
531      *
532      * Emits an {Approval} event.
533      */
534     function approve(address to, uint256 tokenId) external;
535 
536     /**
537      * @dev Returns the account approved for `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function getApproved(uint256 tokenId) external view returns (address operator);
544 
545     /**
546      * @dev Approve or remove `operator` as an operator for the caller.
547      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
548      *
549      * Requirements:
550      *
551      * - The `operator` cannot be the caller.
552      *
553      * Emits an {ApprovalForAll} event.
554      */
555     function setApprovalForAll(address operator, bool _approved) external;
556 
557     /**
558      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
559      *
560      * See {setApprovalForAll}
561      */
562     function isApprovedForAll(address owner, address operator) external view returns (bool);
563 
564     /**
565      * @dev Safely transfers `tokenId` token from `from` to `to`.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must exist and be owned by `from`.
572      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
574      *
575      * Emits a {Transfer} event.
576      */
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId,
581         bytes calldata data
582     ) external;
583 }
584 
585 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
586 
587 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
593  * @dev See https://eips.ethereum.org/EIPS/eip-721
594  */
595 interface IERC721Enumerable is IERC721 {
596     /**
597      * @dev Returns the total amount of tokens stored by the contract.
598      */
599     function totalSupply() external view returns (uint256);
600 
601     /**
602      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
603      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
604      */
605     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
606 
607     /**
608      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
609      * Use along with {totalSupply} to enumerate all tokens.
610      */
611     function tokenByIndex(uint256 index) external view returns (uint256);
612 }
613 
614 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
615 
616 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
622  * @dev See https://eips.ethereum.org/EIPS/eip-721
623  */
624 interface IERC721Metadata is IERC721 {
625     /**
626      * @dev Returns the token collection name.
627      */
628     function name() external view returns (string memory);
629 
630     /**
631      * @dev Returns the token collection symbol.
632      */
633     function symbol() external view returns (string memory);
634 
635     /**
636      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
637      */
638     function tokenURI(uint256 tokenId) external view returns (string memory);
639 }
640 
641 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
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
708 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 /**
713  * @dev Provides information about the current execution context, including the
714  * sender of the transaction and its data. While these are generally available
715  * via msg.sender and msg.data, they should not be accessed in such a direct
716  * manner, since when dealing with meta-transactions the account sending and
717  * paying for execution may not be the actual sender (as far as an application
718  * is concerned).
719  *
720  * This contract is only required for intermediate, library-like contracts.
721  */
722 abstract contract Context {
723     function _msgSender() internal view virtual returns (address) {
724         return msg.sender;
725     }
726 
727     function _msgData() internal view virtual returns (bytes calldata) {
728         return msg.data;
729     }
730 }
731 
732 // File: contracts/ERC721A.sol
733 
734 pragma solidity ^0.8.4;
735 
736 error ApprovalCallerNotOwnerNorApproved();
737 error ApprovalQueryForNonexistentToken();
738 error ApproveToCaller();
739 error ApprovalToCurrentOwner();
740 error BalanceQueryForZeroAddress();
741 error MintedQueryForZeroAddress();
742 error BurnedQueryForZeroAddress();
743 error AuxQueryForZeroAddress();
744 error MintToZeroAddress();
745 error MintZeroQuantity();
746 error OwnerIndexOutOfBounds();
747 error OwnerQueryForNonexistentToken();
748 error TokenIndexOutOfBounds();
749 error TransferCallerNotOwnerNorApproved();
750 error TransferFromIncorrectOwner();
751 error TransferToNonERC721ReceiverImplementer();
752 error TransferToZeroAddress();
753 error URIQueryForNonexistentToken();
754 
755 /**
756  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
757  * the Metadata extension. Built to optimize for lower gas during batch mints.
758  *
759  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
760  *
761  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
762  *
763  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
764  */
765 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
766     using Address for address;
767     using Strings for uint256;
768 
769     // Compiler will pack this into a single 256bit word.
770     struct TokenOwnership {
771         // The address of the owner.
772         address addr;
773         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
774         uint64 startTimestamp;
775         // Whether the token has been burned.
776         bool burned;
777     }
778 
779     // Compiler will pack this into a single 256bit word.
780     struct AddressData {
781         // Realistically, 2**64-1 is more than enough.
782         uint64 balance;
783         // Keeps track of mint count with minimal overhead for tokenomics.
784         uint64 numberMinted;
785         // Keeps track of burn count with minimal overhead for tokenomics.
786         uint64 numberBurned;
787         // For miscellaneous variable(s) pertaining to the address
788         // (e.g. number of whitelist mint slots used).
789         // If there are multiple variables, please pack them into a uint64.
790         uint64 aux;
791     }
792 
793     // The tokenId of the next token to be minted.
794     uint256 internal _currentIndex;
795 
796     // The number of tokens burned.
797     uint256 internal _burnCounter;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to ownership details
806     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
807     mapping(uint256 => TokenOwnership) internal _ownerships;
808 
809     // Mapping owner address to address data
810     mapping(address => AddressData) private _addressData;
811 
812     // Mapping from token ID to approved address
813     mapping(uint256 => address) private _tokenApprovals;
814 
815     // Mapping from owner to operator approvals
816     mapping(address => mapping(address => bool)) private _operatorApprovals;
817 
818     constructor(string memory name_, string memory symbol_) {
819         _name = name_;
820         _symbol = symbol_;
821         _currentIndex = _startTokenId();
822     }
823 
824     /**
825      * To change the starting tokenId, please override this function.
826      */
827     function _startTokenId() internal view virtual returns (uint256) {
828         return 0;
829     }
830 
831     /**
832      * @dev See {IERC721Enumerable-totalSupply}.
833      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
834      */
835     function totalSupply() public view returns (uint256) {
836         // Counter underflow is impossible as _burnCounter cannot be incremented
837         // more than _currentIndex - _startTokenId() times
838         unchecked {
839             return _currentIndex - _burnCounter - _startTokenId();
840         }
841     }
842 
843     /**
844      * Returns the total amount of tokens minted in the contract.
845      */
846     function _totalMinted() internal view returns (uint256) {
847         // Counter underflow is impossible as _currentIndex does not decrement,
848         // and it is initialized to _startTokenId()
849         unchecked {
850             return _currentIndex - _startTokenId();
851         }
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
858         return
859             interfaceId == type(IERC721).interfaceId ||
860             interfaceId == type(IERC721Metadata).interfaceId ||
861             super.supportsInterface(interfaceId);
862     }
863 
864     /**
865      * @dev See {IERC721-balanceOf}.
866      */
867     function balanceOf(address owner) public view override returns (uint256) {
868         if (owner == address(0)) revert BalanceQueryForZeroAddress();
869         return uint256(_addressData[owner].balance);
870     }
871 
872     /**
873      * Returns the number of tokens minted by `owner`.
874      */
875     function _numberMinted(address owner) internal view returns (uint256) {
876         if (owner == address(0)) revert MintedQueryForZeroAddress();
877         return uint256(_addressData[owner].numberMinted);
878     }
879 
880     /**
881      * Returns the number of tokens burned by or on behalf of `owner`.
882      */
883     function _numberBurned(address owner) internal view returns (uint256) {
884         if (owner == address(0)) revert BurnedQueryForZeroAddress();
885         return uint256(_addressData[owner].numberBurned);
886     }
887 
888     /**
889      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
890      */
891     function _getAux(address owner) internal view returns (uint64) {
892         if (owner == address(0)) revert AuxQueryForZeroAddress();
893         return _addressData[owner].aux;
894     }
895 
896     /**
897      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
898      * If there are multiple variables, please pack them into a uint64.
899      */
900     function _setAux(address owner, uint64 aux) internal {
901         if (owner == address(0)) revert AuxQueryForZeroAddress();
902         _addressData[owner].aux = aux;
903     }
904 
905     /**
906      * Gas spent here starts off proportional to the maximum mint batch size.
907      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
908      */
909     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
910         uint256 curr = tokenId;
911 
912         unchecked {
913             if (_startTokenId() <= curr && curr < _currentIndex) {
914                 TokenOwnership memory ownership = _ownerships[curr];
915                 if (!ownership.burned) {
916                     if (ownership.addr != address(0)) {
917                         return ownership;
918                     }
919                     // Invariant:
920                     // There will always be an ownership that has an address and is not burned
921                     // before an ownership that does not have an address and is not burned.
922                     // Hence, curr will not underflow.
923                     while (true) {
924                         curr--;
925                         ownership = _ownerships[curr];
926                         if (ownership.addr != address(0)) {
927                             return ownership;
928                         }
929                     }
930                 }
931             }
932         }
933         revert OwnerQueryForNonexistentToken();
934     }
935 
936     /**
937      * @dev See {IERC721-ownerOf}.
938      */
939     function ownerOf(uint256 tokenId) public view override returns (address) {
940         return ownershipOf(tokenId).addr;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-name}.
945      */
946     function name() public view virtual override returns (string memory) {
947         return _name;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-symbol}.
952      */
953     function symbol() public view virtual override returns (string memory) {
954         return _symbol;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-tokenURI}.
959      */
960     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
961         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
962 
963         string memory baseURI = _baseURI();
964         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
965     }
966 
967     /**
968      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
969      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
970      * by default, can be overriden in child contracts.
971      */
972     function _baseURI() internal view virtual returns (string memory) {
973         return '';
974     }
975 
976     /**
977      * @dev See {IERC721-approve}.
978      */
979     function approve(address to, uint256 tokenId) public override {
980         address owner = ERC721A.ownerOf(tokenId);
981         if (to == owner) revert ApprovalToCurrentOwner();
982 
983         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
984             revert ApprovalCallerNotOwnerNorApproved();
985         }
986 
987         _approve(to, tokenId, owner);
988     }
989 
990     /**
991      * @dev See {IERC721-getApproved}.
992      */
993     function getApproved(uint256 tokenId) public view override returns (address) {
994         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
995 
996         return _tokenApprovals[tokenId];
997     }
998 
999     /**
1000      * @dev See {IERC721-setApprovalForAll}.
1001      */
1002     function setApprovalForAll(address operator, bool approved) public virtual override {
1003         if (operator == _msgSender()) revert ApproveToCaller();
1004 
1005         _operatorApprovals[_msgSender()][operator] = approved;
1006         emit ApprovalForAll(_msgSender(), operator, approved);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-isApprovedForAll}.
1011      */
1012     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1013         return _operatorApprovals[owner][operator];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-transferFrom}.
1018      */
1019     function transferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         _transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         safeTransferFrom(from, to, tokenId, '');
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) public virtual override {
1047         _transfer(from, to, tokenId);
1048         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1049             revert TransferToNonERC721ReceiverImplementer();
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns whether `tokenId` exists.
1055      *
1056      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1057      *
1058      * Tokens start existing when they are minted (`_mint`),
1059      */
1060     function _exists(uint256 tokenId) internal view returns (bool) {
1061         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1062             !_ownerships[tokenId].burned;
1063     }
1064 
1065     function _safeMint(address to, uint256 quantity) internal {
1066         _safeMint(to, quantity, '');
1067     }
1068 
1069     /**
1070      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1075      * - `quantity` must be greater than 0.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _safeMint(
1080         address to,
1081         uint256 quantity,
1082         bytes memory _data
1083     ) internal {
1084         _mint(to, quantity, _data, true);
1085     }
1086 
1087     /**
1088      * @dev Mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _mint(
1098         address to,
1099         uint256 quantity,
1100         bytes memory _data,
1101         bool safe
1102     ) internal {
1103         uint256 startTokenId = _currentIndex;
1104         if (to == address(0)) revert MintToZeroAddress();
1105         if (quantity == 0) revert MintZeroQuantity();
1106 
1107         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1108 
1109         // Overflows are incredibly unrealistic.
1110         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1111         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1112         unchecked {
1113             _addressData[to].balance += uint64(quantity);
1114             _addressData[to].numberMinted += uint64(quantity);
1115 
1116             _ownerships[startTokenId].addr = to;
1117             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1118 
1119             uint256 updatedIndex = startTokenId;
1120             uint256 end = updatedIndex + quantity;
1121 
1122             if (safe && to.isContract()) {
1123                 do {
1124                     emit Transfer(address(0), to, updatedIndex);
1125                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1126                         revert TransferToNonERC721ReceiverImplementer();
1127                     }
1128                 } while (updatedIndex != end);
1129                 // Reentrancy protection
1130                 if (_currentIndex != startTokenId) revert();
1131             } else {
1132                 do {
1133                     emit Transfer(address(0), to, updatedIndex++);
1134                 } while (updatedIndex != end);
1135             }
1136             _currentIndex = updatedIndex;
1137         }
1138         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1139     }
1140 
1141     /**
1142      * @dev Transfers `tokenId` from `from` to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - `to` cannot be the zero address.
1147      * - `tokenId` token must be owned by `from`.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _transfer(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) private {
1156         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1157 
1158         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1159             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1160             getApproved(tokenId) == _msgSender());
1161 
1162         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1163         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1164         if (to == address(0)) revert TransferToZeroAddress();
1165 
1166         _beforeTokenTransfers(from, to, tokenId, 1);
1167 
1168         // Clear approvals from the previous owner
1169         _approve(address(0), tokenId, prevOwnership.addr);
1170 
1171         // Underflow of the sender's balance is impossible because we check for
1172         // ownership above and the recipient's balance can't realistically overflow.
1173         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1174         unchecked {
1175             _addressData[from].balance -= 1;
1176             _addressData[to].balance += 1;
1177 
1178             _ownerships[tokenId].addr = to;
1179             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1180 
1181             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1182             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1183             uint256 nextTokenId = tokenId + 1;
1184             if (_ownerships[nextTokenId].addr == address(0)) {
1185                 // This will suffice for checking _exists(nextTokenId),
1186                 // as a burned slot cannot contain the zero address.
1187                 if (nextTokenId < _currentIndex) {
1188                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1189                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1190                 }
1191             }
1192         }
1193 
1194         emit Transfer(from, to, tokenId);
1195         _afterTokenTransfers(from, to, tokenId, 1);
1196     }
1197 
1198     /**
1199      * @dev Destroys `tokenId`.
1200      * The approval is cleared when the token is burned.
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must exist.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _burn(uint256 tokenId) internal virtual {
1209         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1210 
1211         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1212 
1213         // Clear approvals from the previous owner
1214         _approve(address(0), tokenId, prevOwnership.addr);
1215 
1216         // Underflow of the sender's balance is impossible because we check for
1217         // ownership above and the recipient's balance can't realistically overflow.
1218         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1219         unchecked {
1220             _addressData[prevOwnership.addr].balance -= 1;
1221             _addressData[prevOwnership.addr].numberBurned += 1;
1222 
1223             // Keep track of who burned the token, and the timestamp of burning.
1224             _ownerships[tokenId].addr = prevOwnership.addr;
1225             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1226             _ownerships[tokenId].burned = true;
1227 
1228             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1229             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1230             uint256 nextTokenId = tokenId + 1;
1231             if (_ownerships[nextTokenId].addr == address(0)) {
1232                 // This will suffice for checking _exists(nextTokenId),
1233                 // as a burned slot cannot contain the zero address.
1234                 if (nextTokenId < _currentIndex) {
1235                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1236                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1237                 }
1238             }
1239         }
1240 
1241         emit Transfer(prevOwnership.addr, address(0), tokenId);
1242         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1243 
1244         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1245         unchecked {
1246             _burnCounter++;
1247         }
1248     }
1249 
1250     /**
1251      * @dev Approve `to` to operate on `tokenId`
1252      *
1253      * Emits a {Approval} event.
1254      */
1255     function _approve(
1256         address to,
1257         uint256 tokenId,
1258         address owner
1259     ) private {
1260         _tokenApprovals[tokenId] = to;
1261         emit Approval(owner, to, tokenId);
1262     }
1263 
1264     /**
1265      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1266      *
1267      * @param from address representing the previous owner of the given token ID
1268      * @param to target address that will receive the tokens
1269      * @param tokenId uint256 ID of the token to be transferred
1270      * @param _data bytes optional data to send along with the call
1271      * @return bool whether the call correctly returned the expected magic value
1272      */
1273     function _checkContractOnERC721Received(
1274         address from,
1275         address to,
1276         uint256 tokenId,
1277         bytes memory _data
1278     ) private returns (bool) {
1279         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1280             return retval == IERC721Receiver(to).onERC721Received.selector;
1281         } catch (bytes memory reason) {
1282             if (reason.length == 0) {
1283                 revert TransferToNonERC721ReceiverImplementer();
1284             } else {
1285                 assembly {
1286                     revert(add(32, reason), mload(reason))
1287                 }
1288             }
1289         }
1290     }
1291 
1292     /**
1293      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1294      * And also called before burning one token.
1295      *
1296      * startTokenId - the first token id to be transferred
1297      * quantity - the amount to be transferred
1298      *
1299      * Calling conditions:
1300      *
1301      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1302      * transferred to `to`.
1303      * - When `from` is zero, `tokenId` will be minted for `to`.
1304      * - When `to` is zero, `tokenId` will be burned by `from`.
1305      * - `from` and `to` are never both zero.
1306      */
1307     function _beforeTokenTransfers(
1308         address from,
1309         address to,
1310         uint256 startTokenId,
1311         uint256 quantity
1312     ) internal virtual {}
1313 
1314     /**
1315      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1316      * minting.
1317      * And also called after one token has been burned.
1318      *
1319      * startTokenId - the first token id to be transferred
1320      * quantity - the amount to be transferred
1321      *
1322      * Calling conditions:
1323      *
1324      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1325      * transferred to `to`.
1326      * - When `from` is zero, `tokenId` has been minted for `to`.
1327      * - When `to` is zero, `tokenId` has been burned by `from`.
1328      * - `from` and `to` are never both zero.
1329      */
1330     function _afterTokenTransfers(
1331         address from,
1332         address to,
1333         uint256 startTokenId,
1334         uint256 quantity
1335     ) internal virtual {}
1336 }
1337 // File: @openzeppelin/contracts/access/Ownable.sol
1338 
1339 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1340 
1341 pragma solidity ^0.8.0;
1342 
1343 /**
1344  * @dev Contract module which provides a basic access control mechanism, where
1345  * there is an account (an owner) that can be granted exclusive access to
1346  * specific functions.
1347  *
1348  * By default, the owner account will be the one that deploys the contract. This
1349  * can later be changed with {transferOwnership}.
1350  *
1351  * This module is used through inheritance. It will make available the modifier
1352  * `onlyOwner`, which can be applied to your functions to restrict their use to
1353  * the owner.
1354  */
1355 abstract contract Ownable is Context {
1356     address private _owner;
1357 
1358     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1359 
1360     /**
1361      * @dev Initializes the contract setting the deployer as the initial owner.
1362      */
1363     constructor() {
1364         _transferOwnership(_msgSender());
1365     }
1366 
1367     /**
1368      * @dev Returns the address of the current owner.
1369      */
1370     function owner() public view virtual returns (address) {
1371         return _owner;
1372     }
1373 
1374     /**
1375      * @dev Throws if called by any account other than the owner.
1376      */
1377     modifier onlyOwner() {
1378         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1379         _;
1380     }
1381 
1382     /**
1383      * @dev Leaves the contract without owner. It will not be possible to call
1384      * `onlyOwner` functions anymore. Can only be called by the current owner.
1385      *
1386      * NOTE: Renouncing ownership will leave the contract without an owner,
1387      * thereby removing any functionality that is only available to the owner.
1388      */
1389     function renounceOwnership() public virtual onlyOwner {
1390         _transferOwnership(address(0));
1391     }
1392 
1393     /**
1394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1395      * Can only be called by the current owner.
1396      */
1397     function transferOwnership(address newOwner) public virtual onlyOwner {
1398         require(newOwner != address(0), "Ownable: new owner is the zero address");
1399         _transferOwnership(newOwner);
1400     }
1401 
1402     /**
1403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1404      * Internal function without access restriction.
1405      */
1406     function _transferOwnership(address newOwner) internal virtual {
1407         address oldOwner = _owner;
1408         _owner = newOwner;
1409         emit OwnershipTransferred(oldOwner, newOwner);
1410     }
1411 }
1412 
1413 // File: contracts/NekkidAccessPass.sol
1414 
1415 pragma solidity ^0.8.0;
1416 
1417 contract NekkidAccessPass is Ownable, ERC721A, ReentrancyGuard {
1418     uint private MAX_SUPPLY = 2000;
1419     uint private constant MAX_PER_WALLET = 20;
1420     bytes32 public firstSaleMerkleRoot;
1421     mapping(address => uint256) public firstSaleClaimed;
1422     mapping(address => bool) public firstSaleClaimedChecker;
1423     bytes32 public secondSaleMerkleRoot;
1424     mapping(address => uint256) public secondSaleClaimed;
1425     mapping(address => bool) public secondSaleClaimedChecker;
1426 
1427     struct SaleConfig {
1428         uint32 publicSaleStartTime;
1429         uint64 firstSalePrice;
1430         uint64 secondSalePrice;
1431         uint64 publicPrice;
1432         uint32 publicSaleKey;
1433     }
1434 
1435     SaleConfig public saleConfig;
1436 
1437     constructor() ERC721A("Nekkid Access Pass", "NEKKID") {}
1438 
1439     modifier callerIsUser() {
1440         require(tx.origin == msg.sender, "The caller is another contract");
1441         _;
1442     }
1443 
1444     function gift(address[] calldata receivers) external onlyOwner {
1445         require(totalSupply() + receivers.length <= MAX_SUPPLY, "MAX_MINT");
1446         for (uint256 i = 0; i < receivers.length; i++) {
1447             _safeMint(receivers[i], 1);
1448         }
1449     }
1450 
1451     function reserveGiveaway(uint256 num, address walletAddress)
1452         public
1453         onlyOwner
1454     {
1455         require(totalSupply() + num <= MAX_SUPPLY, "Exceeds total supply");
1456         _safeMint(walletAddress, num);
1457     }
1458 
1459     function firstSaleMint(bytes32[] calldata _merkleProof, uint256 quantity) external payable callerIsUser {
1460         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1461         require(MerkleProof.verify(_merkleProof, firstSaleMerkleRoot, leaf),
1462             "Invalid Merkle Proof.");
1463         uint256 price = uint256(saleConfig.firstSalePrice);
1464         if (!firstSaleClaimedChecker[msg.sender]) {
1465             firstSaleClaimedChecker[msg.sender] = true;
1466             firstSaleClaimed[msg.sender] = 1;
1467         }
1468         require(firstSaleClaimed[msg.sender] > 0, "Address already minted num of tokens allowed");
1469         firstSaleClaimed[msg.sender] = firstSaleClaimed[msg.sender] - quantity;
1470         _safeMint(msg.sender, quantity);
1471         refundIfOver(price * quantity);
1472     }
1473 
1474     function secondSaleMint(bytes32[] calldata _merkleProof, uint256 quantity) external payable callerIsUser {
1475         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1476         require(MerkleProof.verify(_merkleProof, secondSaleMerkleRoot, leaf),
1477             "Invalid Merkle Proof.");
1478         uint256 price = uint256(saleConfig.secondSalePrice);
1479         require(price != 0, "sale has not begun yet");
1480         if (!secondSaleClaimedChecker[msg.sender]) {
1481             secondSaleClaimedChecker[msg.sender] = true;
1482             secondSaleClaimed[msg.sender] = 5;
1483         }
1484         require(secondSaleClaimed[msg.sender] > 0, "Address already minted num of tokens allowed");
1485         secondSaleClaimed[msg.sender] = secondSaleClaimed[msg.sender] - quantity;
1486         _safeMint(msg.sender, quantity);
1487         refundIfOver(price * quantity);
1488     }
1489 
1490     function publicSaleMint(uint256 quantity, uint256 callerPublicSaleKey)
1491         external
1492         payable
1493         callerIsUser
1494     {
1495         SaleConfig memory config = saleConfig;
1496         uint256 publicSaleKey = uint256(config.publicSaleKey);
1497         uint256 publicPrice = uint256(config.publicPrice);
1498         uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1499         require(
1500             publicSaleKey == callerPublicSaleKey,
1501             "called with incorrect public sale key"
1502         );
1503 
1504         require(
1505             isPublicSaleOn(publicPrice, publicSaleKey, publicSaleStartTime),
1506             "public sale has not begun yet"
1507         );
1508         require(
1509             totalSupply() + quantity <= MAX_SUPPLY,
1510             "reached max supply"
1511         );
1512         require(
1513             numberMinted(msg.sender) + quantity <= MAX_PER_WALLET,
1514             "this wallet cannot mint any more"
1515         );
1516         _safeMint(msg.sender, quantity);
1517         refundIfOver(publicPrice * quantity);
1518     }
1519 
1520     function refundIfOver(uint256 price) private {
1521         require(msg.value >= price, "Need to send more ETH.");
1522         if (msg.value > price) {
1523             payable(msg.sender).transfer(msg.value - price);
1524         }
1525     }
1526 
1527     function isPublicSaleOn(
1528         uint256 publicPriceWei,
1529         uint256 publicSaleKey,
1530         uint256 publicSaleStartTime
1531     ) public view returns (bool) {
1532         return
1533             publicPriceWei != 0 &&
1534             publicSaleKey != 0 &&
1535             block.timestamp >= publicSaleStartTime;
1536     }
1537 
1538     function setupSaleInfo(
1539         uint64 firstSalePriceWei,
1540         uint64 secondSalePriceWei,
1541         uint64 publicPriceWei,
1542         uint32 publicSaleStartTime
1543     ) external onlyOwner {
1544         saleConfig = SaleConfig(
1545             publicSaleStartTime,
1546             firstSalePriceWei,
1547             secondSalePriceWei,
1548             publicPriceWei,
1549             saleConfig.publicSaleKey
1550         );
1551     }
1552 
1553     function setPublicSaleKey(uint32 key) external onlyOwner {
1554         saleConfig.publicSaleKey = key;
1555     }
1556 
1557     function setPublicPrice(uint64 price) external onlyOwner {
1558         saleConfig.publicPrice = price;
1559     }
1560 
1561     function setFirstSalePrice(uint64 price) external onlyOwner {
1562         saleConfig.firstSalePrice = price;
1563     }
1564 
1565     function setSecondSalePrice(uint64 price) external onlyOwner {
1566         saleConfig.secondSalePrice = price;
1567     }
1568 
1569     function setPublicSaleStartTime(uint32 time) external onlyOwner {
1570         saleConfig.publicSaleStartTime = time;
1571     }
1572 
1573     function setFirstSaleMerkleRoot(bytes32 merkle_root) external onlyOwner {
1574         firstSaleMerkleRoot = merkle_root;
1575     }
1576 
1577     function setSecondSaleMerkleRoot(bytes32 merkle_root) external onlyOwner {
1578         secondSaleMerkleRoot = merkle_root;
1579     }
1580 
1581     function setMaxSupply(uint number) external onlyOwner {
1582         MAX_SUPPLY = number;
1583     }
1584 
1585     string private _baseTokenURI;
1586 
1587     function _baseURI() internal view virtual override returns (string memory) {
1588         return _baseTokenURI;
1589     }
1590 
1591     function setBaseURI(string calldata baseURI) external onlyOwner {
1592         _baseTokenURI = baseURI;
1593     }
1594 
1595     function withdrawMoney() external nonReentrant {
1596         uint256 balance = address(this).balance;
1597         payable(0x9e4A358854fE92d9bf17af6672503c38C52561D5).transfer(
1598             (balance * 20) / 100
1599         );
1600         payable(0x136B152606143F5069E1C9cDdf1B023403c8445d).transfer(
1601             (balance * 80) / 100
1602         );
1603     }
1604 
1605     function numberMinted(address owner) public view returns (uint256) {
1606         return _numberMinted(owner);
1607     }
1608 
1609     function getOwnershipData(uint256 tokenId)
1610         external
1611         view
1612         returns (TokenOwnership memory)
1613     {
1614         return ownershipOf(tokenId);
1615     }
1616 }