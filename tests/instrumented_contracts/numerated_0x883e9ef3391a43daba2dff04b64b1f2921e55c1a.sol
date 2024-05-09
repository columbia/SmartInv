1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
358      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Transfers `tokenId` token from `from` to `to`.
378      *
379      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
398      * The approval is cleared when the token is transferred.
399      *
400      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
401      *
402      * Requirements:
403      *
404      * - The caller must own the token or be an approved operator.
405      * - `tokenId` must exist.
406      *
407      * Emits an {Approval} event.
408      */
409     function approve(address to, uint256 tokenId) external;
410 
411     /**
412      * @dev Returns the account approved for `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function getApproved(uint256 tokenId) external view returns (address operator);
419 
420     /**
421      * @dev Approve or remove `operator` as an operator for the caller.
422      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
423      *
424      * Requirements:
425      *
426      * - The `operator` cannot be the caller.
427      *
428      * Emits an {ApprovalForAll} event.
429      */
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432     /**
433      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
434      *
435      * See {setApprovalForAll}
436      */
437     function isApprovedForAll(address owner, address operator) external view returns (bool);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Enumerable is IERC721 {
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     /**
479      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
480      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
481      */
482     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
483 
484     /**
485      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
486      * Use along with {totalSupply} to enumerate all tokens.
487      */
488     function tokenByIndex(uint256 index) external view returns (uint256);
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
521 
522 
523 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev These functions deal with verification of Merkle Trees proofs.
529  *
530  * The proofs can be generated using the JavaScript library
531  * https://github.com/miguelmota/merkletreejs[merkletreejs].
532  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
533  *
534  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
535  *
536  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
537  * hashing, or use a hash function other than keccak256 for hashing leaves.
538  * This is because the concatenation of a sorted pair of internal nodes in
539  * the merkle tree could be reinterpreted as a leaf value.
540  */
541 library MerkleProof {
542     /**
543      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
544      * defined by `root`. For this, a `proof` must be provided, containing
545      * sibling hashes on the branch from the leaf to the root of the tree. Each
546      * pair of leaves and each pair of pre-images are assumed to be sorted.
547      */
548     function verify(
549         bytes32[] memory proof,
550         bytes32 root,
551         bytes32 leaf
552     ) internal pure returns (bool) {
553         return processProof(proof, leaf) == root;
554     }
555 
556     /**
557      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
558      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
559      * hash matches the root of the tree. When processing the proof, the pairs
560      * of leafs & pre-images are assumed to be sorted.
561      *
562      * _Available since v4.4._
563      */
564     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
565         bytes32 computedHash = leaf;
566         for (uint256 i = 0; i < proof.length; i++) {
567             bytes32 proofElement = proof[i];
568             if (computedHash <= proofElement) {
569                 // Hash(current computed hash + current element of the proof)
570                 computedHash = _efficientHash(computedHash, proofElement);
571             } else {
572                 // Hash(current element of the proof + current computed hash)
573                 computedHash = _efficientHash(proofElement, computedHash);
574             }
575         }
576         return computedHash;
577     }
578 
579     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
580         assembly {
581             mstore(0x00, a)
582             mstore(0x20, b)
583             value := keccak256(0x00, 0x40)
584         }
585     }
586 }
587 
588 // File: @openzeppelin/contracts/utils/Strings.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 /**
596  * @dev String operations.
597  */
598 library Strings {
599     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
600 
601     /**
602      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
603      */
604     function toString(uint256 value) internal pure returns (string memory) {
605         // Inspired by OraclizeAPI's implementation - MIT licence
606         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
607 
608         if (value == 0) {
609             return "0";
610         }
611         uint256 temp = value;
612         uint256 digits;
613         while (temp != 0) {
614             digits++;
615             temp /= 10;
616         }
617         bytes memory buffer = new bytes(digits);
618         while (value != 0) {
619             digits -= 1;
620             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
621             value /= 10;
622         }
623         return string(buffer);
624     }
625 
626     /**
627      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
628      */
629     function toHexString(uint256 value) internal pure returns (string memory) {
630         if (value == 0) {
631             return "0x00";
632         }
633         uint256 temp = value;
634         uint256 length = 0;
635         while (temp != 0) {
636             length++;
637             temp >>= 8;
638         }
639         return toHexString(value, length);
640     }
641 
642     /**
643      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
644      */
645     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
646         bytes memory buffer = new bytes(2 * length + 2);
647         buffer[0] = "0";
648         buffer[1] = "x";
649         for (uint256 i = 2 * length + 1; i > 1; --i) {
650             buffer[i] = _HEX_SYMBOLS[value & 0xf];
651             value >>= 4;
652         }
653         require(value == 0, "Strings: hex length insufficient");
654         return string(buffer);
655     }
656 }
657 
658 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
659 
660 
661 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
668  *
669  * These functions can be used to verify that a message was signed by the holder
670  * of the private keys of a given address.
671  */
672 library ECDSA {
673     enum RecoverError {
674         NoError,
675         InvalidSignature,
676         InvalidSignatureLength,
677         InvalidSignatureS,
678         InvalidSignatureV
679     }
680 
681     function _throwError(RecoverError error) private pure {
682         if (error == RecoverError.NoError) {
683             return; // no error: do nothing
684         } else if (error == RecoverError.InvalidSignature) {
685             revert("ECDSA: invalid signature");
686         } else if (error == RecoverError.InvalidSignatureLength) {
687             revert("ECDSA: invalid signature length");
688         } else if (error == RecoverError.InvalidSignatureS) {
689             revert("ECDSA: invalid signature 's' value");
690         } else if (error == RecoverError.InvalidSignatureV) {
691             revert("ECDSA: invalid signature 'v' value");
692         }
693     }
694 
695     /**
696      * @dev Returns the address that signed a hashed message (`hash`) with
697      * `signature` or error string. This address can then be used for verification purposes.
698      *
699      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
700      * this function rejects them by requiring the `s` value to be in the lower
701      * half order, and the `v` value to be either 27 or 28.
702      *
703      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
704      * verification to be secure: it is possible to craft signatures that
705      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
706      * this is by receiving a hash of the original message (which may otherwise
707      * be too long), and then calling {toEthSignedMessageHash} on it.
708      *
709      * Documentation for signature generation:
710      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
711      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
712      *
713      * _Available since v4.3._
714      */
715     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
716         // Check the signature length
717         // - case 65: r,s,v signature (standard)
718         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
719         if (signature.length == 65) {
720             bytes32 r;
721             bytes32 s;
722             uint8 v;
723             // ecrecover takes the signature parameters, and the only way to get them
724             // currently is to use assembly.
725             assembly {
726                 r := mload(add(signature, 0x20))
727                 s := mload(add(signature, 0x40))
728                 v := byte(0, mload(add(signature, 0x60)))
729             }
730             return tryRecover(hash, v, r, s);
731         } else if (signature.length == 64) {
732             bytes32 r;
733             bytes32 vs;
734             // ecrecover takes the signature parameters, and the only way to get them
735             // currently is to use assembly.
736             assembly {
737                 r := mload(add(signature, 0x20))
738                 vs := mload(add(signature, 0x40))
739             }
740             return tryRecover(hash, r, vs);
741         } else {
742             return (address(0), RecoverError.InvalidSignatureLength);
743         }
744     }
745 
746     /**
747      * @dev Returns the address that signed a hashed message (`hash`) with
748      * `signature`. This address can then be used for verification purposes.
749      *
750      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
751      * this function rejects them by requiring the `s` value to be in the lower
752      * half order, and the `v` value to be either 27 or 28.
753      *
754      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
755      * verification to be secure: it is possible to craft signatures that
756      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
757      * this is by receiving a hash of the original message (which may otherwise
758      * be too long), and then calling {toEthSignedMessageHash} on it.
759      */
760     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
761         (address recovered, RecoverError error) = tryRecover(hash, signature);
762         _throwError(error);
763         return recovered;
764     }
765 
766     /**
767      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
768      *
769      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
770      *
771      * _Available since v4.3._
772      */
773     function tryRecover(
774         bytes32 hash,
775         bytes32 r,
776         bytes32 vs
777     ) internal pure returns (address, RecoverError) {
778         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
779         uint8 v = uint8((uint256(vs) >> 255) + 27);
780         return tryRecover(hash, v, r, s);
781     }
782 
783     /**
784      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
785      *
786      * _Available since v4.2._
787      */
788     function recover(
789         bytes32 hash,
790         bytes32 r,
791         bytes32 vs
792     ) internal pure returns (address) {
793         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
794         _throwError(error);
795         return recovered;
796     }
797 
798     /**
799      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
800      * `r` and `s` signature fields separately.
801      *
802      * _Available since v4.3._
803      */
804     function tryRecover(
805         bytes32 hash,
806         uint8 v,
807         bytes32 r,
808         bytes32 s
809     ) internal pure returns (address, RecoverError) {
810         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
811         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
812         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
813         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
814         //
815         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
816         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
817         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
818         // these malleable signatures as well.
819         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
820             return (address(0), RecoverError.InvalidSignatureS);
821         }
822         if (v != 27 && v != 28) {
823             return (address(0), RecoverError.InvalidSignatureV);
824         }
825 
826         // If the signature is valid (and not malleable), return the signer address
827         address signer = ecrecover(hash, v, r, s);
828         if (signer == address(0)) {
829             return (address(0), RecoverError.InvalidSignature);
830         }
831 
832         return (signer, RecoverError.NoError);
833     }
834 
835     /**
836      * @dev Overload of {ECDSA-recover} that receives the `v`,
837      * `r` and `s` signature fields separately.
838      */
839     function recover(
840         bytes32 hash,
841         uint8 v,
842         bytes32 r,
843         bytes32 s
844     ) internal pure returns (address) {
845         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
846         _throwError(error);
847         return recovered;
848     }
849 
850     /**
851      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
852      * produces hash corresponding to the one signed with the
853      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
854      * JSON-RPC method as part of EIP-191.
855      *
856      * See {recover}.
857      */
858     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
859         // 32 is the length in bytes of hash,
860         // enforced by the type signature above
861         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
862     }
863 
864     /**
865      * @dev Returns an Ethereum Signed Message, created from `s`. This
866      * produces hash corresponding to the one signed with the
867      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
868      * JSON-RPC method as part of EIP-191.
869      *
870      * See {recover}.
871      */
872     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
873         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
874     }
875 
876     /**
877      * @dev Returns an Ethereum Signed Typed Data, created from a
878      * `domainSeparator` and a `structHash`. This produces hash corresponding
879      * to the one signed with the
880      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
881      * JSON-RPC method as part of EIP-712.
882      *
883      * See {recover}.
884      */
885     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
886         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
887     }
888 }
889 
890 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
891 
892 
893 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
894 
895 pragma solidity ^0.8.0;
896 
897 /**
898  * @dev Contract module that helps prevent reentrant calls to a function.
899  *
900  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
901  * available, which can be applied to functions to make sure there are no nested
902  * (reentrant) calls to them.
903  *
904  * Note that because there is a single `nonReentrant` guard, functions marked as
905  * `nonReentrant` may not call one another. This can be worked around by making
906  * those functions `private`, and then adding `external` `nonReentrant` entry
907  * points to them.
908  *
909  * TIP: If you would like to learn more about reentrancy and alternative ways
910  * to protect against it, check out our blog post
911  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
912  */
913 abstract contract ReentrancyGuard {
914     // Booleans are more expensive than uint256 or any type that takes up a full
915     // word because each write operation emits an extra SLOAD to first read the
916     // slot's contents, replace the bits taken up by the boolean, and then write
917     // back. This is the compiler's defense against contract upgrades and
918     // pointer aliasing, and it cannot be disabled.
919 
920     // The values being non-zero value makes deployment a bit more expensive,
921     // but in exchange the refund on every call to nonReentrant will be lower in
922     // amount. Since refunds are capped to a percentage of the total
923     // transaction's gas, it is best to keep them low in cases like this one, to
924     // increase the likelihood of the full refund coming into effect.
925     uint256 private constant _NOT_ENTERED = 1;
926     uint256 private constant _ENTERED = 2;
927 
928     uint256 private _status;
929 
930     constructor() {
931         _status = _NOT_ENTERED;
932     }
933 
934     /**
935      * @dev Prevents a contract from calling itself, directly or indirectly.
936      * Calling a `nonReentrant` function from another `nonReentrant`
937      * function is not supported. It is possible to prevent this from happening
938      * by making the `nonReentrant` function external, and making it call a
939      * `private` function that does the actual work.
940      */
941     modifier nonReentrant() {
942         // On the first call to nonReentrant, _notEntered will be true
943         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
944 
945         // Any calls to nonReentrant after this point will fail
946         _status = _ENTERED;
947 
948         _;
949 
950         // By storing the original value once again, a refund is triggered (see
951         // https://eips.ethereum.org/EIPS/eip-2200)
952         _status = _NOT_ENTERED;
953     }
954 }
955 
956 // File: @openzeppelin/contracts/utils/Context.sol
957 
958 
959 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
960 
961 pragma solidity ^0.8.0;
962 
963 /**
964  * @dev Provides information about the current execution context, including the
965  * sender of the transaction and its data. While these are generally available
966  * via msg.sender and msg.data, they should not be accessed in such a direct
967  * manner, since when dealing with meta-transactions the account sending and
968  * paying for execution may not be the actual sender (as far as an application
969  * is concerned).
970  *
971  * This contract is only required for intermediate, library-like contracts.
972  */
973 abstract contract Context {
974     function _msgSender() internal view virtual returns (address) {
975         return msg.sender;
976     }
977 
978     function _msgData() internal view virtual returns (bytes calldata) {
979         return msg.data;
980     }
981 }
982 
983 // File: contracts/ERC721A.sol
984 
985 
986 
987 pragma solidity ^0.8.0;
988 
989 
990 
991 
992 
993 
994 
995 
996 
997 /**
998  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
999  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1000  *
1001  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1002  *
1003  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1004  *
1005  * Does not support burning tokens to address(0).
1006  */
1007 contract ERC721A is
1008   Context,
1009   ERC165,
1010   IERC721,
1011   IERC721Metadata,
1012   IERC721Enumerable
1013 {
1014   using Address for address;
1015   using Strings for uint256;
1016 
1017   struct TokenOwnership {
1018     address addr;
1019     uint64 startTimestamp;
1020   }
1021 
1022   struct AddressData {
1023     uint128 balance;
1024     uint128 numberMinted;
1025   }
1026 
1027   uint256 private currentIndex = 0;
1028 
1029   uint256 internal immutable collectionSize;
1030   uint256 internal immutable maxBatchSize;
1031 
1032   // Token name
1033   string private _name;
1034 
1035   // Token symbol
1036   string private _symbol;
1037 
1038   // Mapping from token ID to ownership details
1039   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1040   mapping(uint256 => TokenOwnership) private _ownerships;
1041 
1042   // Mapping owner address to address data
1043   mapping(address => AddressData) private _addressData;
1044 
1045   // Mapping from token ID to approved address
1046   mapping(uint256 => address) private _tokenApprovals;
1047 
1048   // Mapping from owner to operator approvals
1049   mapping(address => mapping(address => bool)) private _operatorApprovals;
1050 
1051   /**
1052    * @dev
1053    * `maxBatchSize` refers to how much a minter can mint at a time.
1054    * `collectionSize_` refers to how many tokens are in the collection.
1055    */
1056   constructor(
1057     string memory name_,
1058     string memory symbol_,
1059     uint256 maxBatchSize_,
1060     uint256 collectionSize_
1061   ) {
1062     require(
1063       collectionSize_ > 0,
1064       "ERC721A: collection must have a nonzero supply"
1065     );
1066     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1067     _name = name_;
1068     _symbol = symbol_;
1069     maxBatchSize = maxBatchSize_;
1070     collectionSize = collectionSize_;
1071   }
1072 
1073   /**
1074    * @dev See {IERC721Enumerable-totalSupply}.
1075    */
1076   function totalSupply() public view override returns (uint256) {
1077     return currentIndex;
1078   }
1079 
1080   /**
1081    * @dev See {IERC721Enumerable-tokenByIndex}.
1082    */
1083   function tokenByIndex(uint256 index) public view override returns (uint256) {
1084     require(index < totalSupply(), "ERC721A: global index out of bounds");
1085     return index;
1086   }
1087 
1088   /**
1089    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1090    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1091    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1092    */
1093   function tokenOfOwnerByIndex(address owner, uint256 index)
1094     public
1095     view
1096     override
1097     returns (uint256)
1098   {
1099     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1100     uint256 numMintedSoFar = totalSupply();
1101     uint256 tokenIdsIdx = 0;
1102     address currOwnershipAddr = address(0);
1103     for (uint256 i = 0; i < numMintedSoFar; i++) {
1104       TokenOwnership memory ownership = _ownerships[i];
1105       if (ownership.addr != address(0)) {
1106         currOwnershipAddr = ownership.addr;
1107       }
1108       if (currOwnershipAddr == owner) {
1109         if (tokenIdsIdx == index) {
1110           return i;
1111         }
1112         tokenIdsIdx++;
1113       }
1114     }
1115     revert("ERC721A: unable to get token of owner by index");
1116   }
1117 
1118   /**
1119    * @dev See {IERC165-supportsInterface}.
1120    */
1121   function supportsInterface(bytes4 interfaceId)
1122     public
1123     view
1124     virtual
1125     override(ERC165, IERC165)
1126     returns (bool)
1127   {
1128     return
1129       interfaceId == type(IERC721).interfaceId ||
1130       interfaceId == type(IERC721Metadata).interfaceId ||
1131       interfaceId == type(IERC721Enumerable).interfaceId ||
1132       super.supportsInterface(interfaceId);
1133   }
1134 
1135   /**
1136    * @dev See {IERC721-balanceOf}.
1137    */
1138   function balanceOf(address owner) public view override returns (uint256) {
1139     require(owner != address(0), "ERC721A: balance query for the zero address");
1140     return uint256(_addressData[owner].balance);
1141   }
1142 
1143   function _numberMinted(address owner) internal view returns (uint256) {
1144     require(
1145       owner != address(0),
1146       "ERC721A: number minted query for the zero address"
1147     );
1148     return uint256(_addressData[owner].numberMinted);
1149   }
1150 
1151   function ownershipOf(uint256 tokenId)
1152     internal
1153     view
1154     returns (TokenOwnership memory)
1155   {
1156     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1157 
1158     uint256 lowestTokenToCheck;
1159     if (tokenId >= maxBatchSize) {
1160       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1161     }
1162 
1163     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1164       TokenOwnership memory ownership = _ownerships[curr];
1165       if (ownership.addr != address(0)) {
1166         return ownership;
1167       }
1168     }
1169 
1170     revert("ERC721A: unable to determine the owner of token");
1171   }
1172 
1173   /**
1174    * @dev See {IERC721-ownerOf}.
1175    */
1176   function ownerOf(uint256 tokenId) public view override returns (address) {
1177     return ownershipOf(tokenId).addr;
1178   }
1179 
1180   /**
1181    * @dev See {IERC721Metadata-name}.
1182    */
1183   function name() public view virtual override returns (string memory) {
1184     return _name;
1185   }
1186 
1187   /**
1188    * @dev See {IERC721Metadata-symbol}.
1189    */
1190   function symbol() public view virtual override returns (string memory) {
1191     return _symbol;
1192   }
1193 
1194   /**
1195    * @dev See {IERC721Metadata-tokenURI}.
1196    */
1197   function tokenURI(uint256 tokenId)
1198     public
1199     view
1200     virtual
1201     override
1202     returns (string memory)
1203   {
1204     require(
1205       _exists(tokenId),
1206       "ERC721Metadata: URI query for nonexistent token"
1207     );
1208 
1209     string memory baseURI = _baseURI();
1210     return
1211       bytes(baseURI).length > 0
1212         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1213         : "";
1214   }
1215 
1216   /**
1217    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1218    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1219    * by default, can be overriden in child contracts.
1220    */
1221   function _baseURI() internal view virtual returns (string memory) {
1222     return "";
1223   }
1224 
1225   /**
1226    * @dev See {IERC721-approve}.
1227    */
1228   function approve(address to, uint256 tokenId) public override {
1229     address owner = ERC721A.ownerOf(tokenId);
1230     require(to != owner, "ERC721A: approval to current owner");
1231 
1232     require(
1233       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1234       "ERC721A: approve caller is not owner nor approved for all"
1235     );
1236 
1237     _approve(to, tokenId, owner);
1238   }
1239 
1240   /**
1241    * @dev See {IERC721-getApproved}.
1242    */
1243   function getApproved(uint256 tokenId) public view override returns (address) {
1244     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1245 
1246     return _tokenApprovals[tokenId];
1247   }
1248 
1249   /**
1250    * @dev See {IERC721-setApprovalForAll}.
1251    */
1252   function setApprovalForAll(address operator, bool approved) public override {
1253     require(operator != _msgSender(), "ERC721A: approve to caller");
1254 
1255     _operatorApprovals[_msgSender()][operator] = approved;
1256     emit ApprovalForAll(_msgSender(), operator, approved);
1257   }
1258 
1259   /**
1260    * @dev See {IERC721-isApprovedForAll}.
1261    */
1262   function isApprovedForAll(address owner, address operator)
1263     public
1264     view
1265     virtual
1266     override
1267     returns (bool)
1268   {
1269     return _operatorApprovals[owner][operator];
1270   }
1271 
1272   /**
1273    * @dev See {IERC721-transferFrom}.
1274    */
1275   function transferFrom(
1276     address from,
1277     address to,
1278     uint256 tokenId
1279   ) public override {
1280     _transfer(from, to, tokenId);
1281   }
1282 
1283   /**
1284    * @dev See {IERC721-safeTransferFrom}.
1285    */
1286   function safeTransferFrom(
1287     address from,
1288     address to,
1289     uint256 tokenId
1290   ) public override {
1291     safeTransferFrom(from, to, tokenId, "");
1292   }
1293 
1294   /**
1295    * @dev See {IERC721-safeTransferFrom}.
1296    */
1297   function safeTransferFrom(
1298     address from,
1299     address to,
1300     uint256 tokenId,
1301     bytes memory _data
1302   ) public override {
1303     _transfer(from, to, tokenId);
1304     require(
1305       _checkOnERC721Received(from, to, tokenId, _data),
1306       "ERC721A: transfer to non ERC721Receiver implementer"
1307     );
1308   }
1309 
1310   /**
1311    * @dev Returns whether `tokenId` exists.
1312    *
1313    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1314    *
1315    * Tokens start existing when they are minted (`_mint`),
1316    */
1317   function _exists(uint256 tokenId) internal view returns (bool) {
1318     return tokenId < currentIndex;
1319   }
1320 
1321   function _safeMint(address to, uint256 quantity) internal {
1322     _safeMint(to, quantity, "");
1323   }
1324 
1325   /**
1326    * @dev Mints `quantity` tokens and transfers them to `to`.
1327    *
1328    * Requirements:
1329    *
1330    * - there must be `quantity` tokens remaining unminted in the total collection.
1331    * - `to` cannot be the zero address.
1332    * - `quantity` cannot be larger than the max batch size.
1333    *
1334    * Emits a {Transfer} event.
1335    */
1336   function _safeMint(
1337     address to,
1338     uint256 quantity,
1339     bytes memory _data
1340   ) internal {
1341     uint256 startTokenId = currentIndex;
1342     require(to != address(0), "ERC721A: mint to the zero address");
1343     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1344     require(!_exists(startTokenId), "ERC721A: token already minted");
1345     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1346 
1347     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1348 
1349     AddressData memory addressData = _addressData[to];
1350     _addressData[to] = AddressData(
1351       addressData.balance + uint128(quantity),
1352       addressData.numberMinted + uint128(quantity)
1353     );
1354     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1355 
1356     uint256 updatedIndex = startTokenId;
1357 
1358     for (uint256 i = 0; i < quantity; i++) {
1359       emit Transfer(address(0), to, updatedIndex);
1360       require(
1361         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1362         "ERC721A: transfer to non ERC721Receiver implementer"
1363       );
1364       updatedIndex++;
1365     }
1366 
1367     currentIndex = updatedIndex;
1368     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1369   }
1370 
1371   /**
1372    * @dev Transfers `tokenId` from `from` to `to`.
1373    *
1374    * Requirements:
1375    *
1376    * - `to` cannot be the zero address.
1377    * - `tokenId` token must be owned by `from`.
1378    *
1379    * Emits a {Transfer} event.
1380    */
1381   function _transfer(
1382     address from,
1383     address to,
1384     uint256 tokenId
1385   ) private {
1386     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1387 
1388     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1389       getApproved(tokenId) == _msgSender() ||
1390       isApprovedForAll(prevOwnership.addr, _msgSender()));
1391 
1392     require(
1393       isApprovedOrOwner,
1394       "ERC721A: transfer caller is not owner nor approved"
1395     );
1396 
1397     require(
1398       prevOwnership.addr == from,
1399       "ERC721A: transfer from incorrect owner"
1400     );
1401     require(to != address(0), "ERC721A: transfer to the zero address");
1402 
1403     _beforeTokenTransfers(from, to, tokenId, 1);
1404 
1405     // Clear approvals from the previous owner
1406     _approve(address(0), tokenId, prevOwnership.addr);
1407 
1408     _addressData[from].balance -= 1;
1409     _addressData[to].balance += 1;
1410     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1411 
1412     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1413     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1414     uint256 nextTokenId = tokenId + 1;
1415     if (_ownerships[nextTokenId].addr == address(0)) {
1416       if (_exists(nextTokenId)) {
1417         _ownerships[nextTokenId] = TokenOwnership(
1418           prevOwnership.addr,
1419           prevOwnership.startTimestamp
1420         );
1421       }
1422     }
1423 
1424     emit Transfer(from, to, tokenId);
1425     _afterTokenTransfers(from, to, tokenId, 1);
1426   }
1427 
1428   /**
1429    * @dev Approve `to` to operate on `tokenId`
1430    *
1431    * Emits a {Approval} event.
1432    */
1433   function _approve(
1434     address to,
1435     uint256 tokenId,
1436     address owner
1437   ) private {
1438     _tokenApprovals[tokenId] = to;
1439     emit Approval(owner, to, tokenId);
1440   }
1441 
1442   uint256 public nextOwnerToExplicitlySet = 0;
1443 
1444   /**
1445    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1446    */
1447   function _setOwnersExplicit(uint256 quantity) internal {
1448     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1449     require(quantity > 0, "quantity must be nonzero");
1450     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1451     if (endIndex > collectionSize - 1) {
1452       endIndex = collectionSize - 1;
1453     }
1454     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1455     require(_exists(endIndex), "not enough minted yet for this cleanup");
1456     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1457       if (_ownerships[i].addr == address(0)) {
1458         TokenOwnership memory ownership = ownershipOf(i);
1459         _ownerships[i] = TokenOwnership(
1460           ownership.addr,
1461           ownership.startTimestamp
1462         );
1463       }
1464     }
1465     nextOwnerToExplicitlySet = endIndex + 1;
1466   }
1467 
1468   /**
1469    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1470    * The call is not executed if the target address is not a contract.
1471    *
1472    * @param from address representing the previous owner of the given token ID
1473    * @param to target address that will receive the tokens
1474    * @param tokenId uint256 ID of the token to be transferred
1475    * @param _data bytes optional data to send along with the call
1476    * @return bool whether the call correctly returned the expected magic value
1477    */
1478   function _checkOnERC721Received(
1479     address from,
1480     address to,
1481     uint256 tokenId,
1482     bytes memory _data
1483   ) private returns (bool) {
1484     if (to.isContract()) {
1485       try
1486         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1487       returns (bytes4 retval) {
1488         return retval == IERC721Receiver(to).onERC721Received.selector;
1489       } catch (bytes memory reason) {
1490         if (reason.length == 0) {
1491           revert("ERC721A: transfer to non ERC721Receiver implementer");
1492         } else {
1493           assembly {
1494             revert(add(32, reason), mload(reason))
1495           }
1496         }
1497       }
1498     } else {
1499       return true;
1500     }
1501   }
1502 
1503   /**
1504    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1505    *
1506    * startTokenId - the first token id to be transferred
1507    * quantity - the amount to be transferred
1508    *
1509    * Calling conditions:
1510    *
1511    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1512    * transferred to `to`.
1513    * - When `from` is zero, `tokenId` will be minted for `to`.
1514    */
1515   function _beforeTokenTransfers(
1516     address from,
1517     address to,
1518     uint256 startTokenId,
1519     uint256 quantity
1520   ) internal virtual {}
1521 
1522   /**
1523    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1524    * minting.
1525    *
1526    * startTokenId - the first token id to be transferred
1527    * quantity - the amount to be transferred
1528    *
1529    * Calling conditions:
1530    *
1531    * - when `from` and `to` are both non-zero.
1532    * - `from` and `to` are never both zero.
1533    */
1534   function _afterTokenTransfers(
1535     address from,
1536     address to,
1537     uint256 startTokenId,
1538     uint256 quantity
1539   ) internal virtual {}
1540 }
1541 // File: @openzeppelin/contracts/access/Ownable.sol
1542 
1543 
1544 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1545 
1546 pragma solidity ^0.8.0;
1547 
1548 
1549 /**
1550  * @dev Contract module which provides a basic access control mechanism, where
1551  * there is an account (an owner) that can be granted exclusive access to
1552  * specific functions.
1553  *
1554  * By default, the owner account will be the one that deploys the contract. This
1555  * can later be changed with {transferOwnership}.
1556  *
1557  * This module is used through inheritance. It will make available the modifier
1558  * `onlyOwner`, which can be applied to your functions to restrict their use to
1559  * the owner.
1560  */
1561 abstract contract Ownable is Context {
1562     address private _owner;
1563 
1564     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1565 
1566     /**
1567      * @dev Initializes the contract setting the deployer as the initial owner.
1568      */
1569     constructor() {
1570         _transferOwnership(_msgSender());
1571     }
1572 
1573     /**
1574      * @dev Returns the address of the current owner.
1575      */
1576     function owner() public view virtual returns (address) {
1577         return _owner;
1578     }
1579 
1580     /**
1581      * @dev Throws if called by any account other than the owner.
1582      */
1583     modifier onlyOwner() {
1584         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1585         _;
1586     }
1587 
1588     /**
1589      * @dev Leaves the contract without owner. It will not be possible to call
1590      * `onlyOwner` functions anymore. Can only be called by the current owner.
1591      *
1592      * NOTE: Renouncing ownership will leave the contract without an owner,
1593      * thereby removing any functionality that is only available to the owner.
1594      */
1595     function renounceOwnership() public virtual onlyOwner {
1596         _transferOwnership(address(0));
1597     }
1598 
1599     /**
1600      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1601      * Can only be called by the current owner.
1602      */
1603     function transferOwnership(address newOwner) public virtual onlyOwner {
1604         require(newOwner != address(0), "Ownable: new owner is the zero address");
1605         _transferOwnership(newOwner);
1606     }
1607 
1608     /**
1609      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1610      * Internal function without access restriction.
1611      */
1612     function _transferOwnership(address newOwner) internal virtual {
1613         address oldOwner = _owner;
1614         _owner = newOwner;
1615         emit OwnershipTransferred(oldOwner, newOwner);
1616     }
1617 }
1618 
1619 // File: contracts/MenderNFT.sol
1620 
1621 
1622 pragma solidity ^0.8.0;
1623 
1624 
1625 
1626 
1627 
1628 
1629 
1630 contract MenderNFT is Ownable, ERC721A, ReentrancyGuard {
1631   using ECDSA for bytes32;
1632   uint256 private constant MAX_PERADDRESS_DURING_MINT = 6;
1633   uint256 private constant MAX_CONTRIBUTOR = 3000;
1634   uint256 private constant MAX_TEAMER = 1000;
1635   uint256 private constant COLLECTTION_SIZE = 10000;
1636 
1637   uint256 private contriMintCounter = 0;
1638   uint256 private teamMintCounter = 0;
1639 
1640   mapping(address => uint256) private allowlistMinted;
1641   mapping(address => bool) private contriMinted;
1642   mapping(address => uint256) private teamlistMinted;
1643   mapping(address => bool) private publicMinted;
1644 
1645   bytes32 private merkleRootRole2;
1646   bytes32 private merkleRootRole3;
1647   bytes32 private merkleRootRole4;
1648   bytes32 private merkleRootRole6;
1649 
1650   address private contriSigner;
1651   address private teamSigner;
1652 
1653 
1654   struct SaleConfig {
1655     uint32 allowlistSaleStartTime;
1656     uint32 allowlistSaleEndTime;
1657     uint32 publicSaleStartTime;
1658     uint32 publicSaleKey;
1659   }
1660   SaleConfig public saleConfig;
1661 
1662   string private _baseTokenURI = "";
1663 
1664   constructor(
1665     bytes32 merkleRootRole2_,
1666     bytes32 merkleRootRole3_,
1667     bytes32 merkleRootRole4_,
1668     bytes32 merkleRootRole6_,
1669     uint32 allowlistSaleStartTime_,
1670     uint32 allowlistSaleEndTime_,
1671     uint32 publicSaleStartTime_,
1672     uint32 publicSaleKey_,
1673     string memory baseURI_
1674   ) ERC721A("MenderNFT", "MenderNFT", MAX_PERADDRESS_DURING_MINT, COLLECTTION_SIZE) {
1675     merkleRootRole2 = merkleRootRole2_;
1676     merkleRootRole3 = merkleRootRole3_;
1677     merkleRootRole4 = merkleRootRole4_;
1678     merkleRootRole6 = merkleRootRole6_;
1679 
1680     saleConfig.allowlistSaleStartTime = allowlistSaleStartTime_;
1681     saleConfig.allowlistSaleEndTime = allowlistSaleEndTime_;
1682     saleConfig.publicSaleStartTime = publicSaleStartTime_;
1683     saleConfig.publicSaleKey = publicSaleKey_;
1684 
1685     _baseTokenURI = baseURI_;
1686   }
1687 
1688   modifier callerIsUser() {
1689     require(tx.origin == msg.sender, "the caller is another contract");
1690     _;
1691   }
1692 
1693   function isAllowlisted(
1694     address _account,
1695     bytes32[] calldata _proof,
1696     uint256 _role
1697   ) internal view returns (bool) {
1698     bytes32 _leaf = leaf(_account);
1699     if (_role == 2) {
1700       return MerkleProof.verify(_proof, merkleRootRole2, _leaf);
1701     } else if (_role == 3) {
1702       return MerkleProof.verify(_proof, merkleRootRole3, _leaf);
1703     } else if (_role == 4) {
1704       return MerkleProof.verify(_proof, merkleRootRole4, _leaf);
1705     } else if (_role == 6) {
1706       return MerkleProof.verify(_proof, merkleRootRole6, _leaf);
1707     } else {
1708       return false;
1709     }
1710   }
1711 
1712 
1713   function leaf(address _account) internal pure returns (bytes32) {
1714     return keccak256(abi.encodePacked(_account));
1715   }
1716 
1717   function allowlistMint(
1718     uint256 _quantity,
1719     bytes32[] calldata _proof,
1720     uint256 _role
1721   ) external callerIsUser {
1722     uint256 allowlistSaleStartTime = uint256(saleConfig.allowlistSaleStartTime);
1723     uint256 allowlistSaleEndTime = uint256(saleConfig.allowlistSaleEndTime);
1724 
1725     require(
1726       allowlistSaleStartTime != 0 && block.timestamp >= allowlistSaleStartTime,
1727       "allowlist sale has not begun yet"
1728     );
1729     require(block.timestamp <= allowlistSaleEndTime,"allowlist sale has ended");
1730     require(_quantity > 0, "invalid mint quantity");
1731     require(allowlistMinted[msg.sender] + _quantity <= _role, "reached role limit");
1732     require(MAX_CONTRIBUTOR - contriMintCounter + MAX_TEAMER - teamMintCounter + totalSupply() + _quantity <= COLLECTTION_SIZE, "reached max supply");
1733     require(isAllowlisted(msg.sender, _proof, _role), "not allowlisted");
1734 
1735     allowlistMinted[msg.sender] += _quantity;
1736     _safeMint(msg.sender, _quantity);
1737   }
1738 
1739   function contriMint(bytes calldata signature) external callerIsUser {
1740     require(contriMinted[msg.sender] != true, "already minted");
1741     require(
1742         contriSigner==
1743             keccak256(
1744                 abi.encodePacked(
1745                     "\x19Ethereum Signed Message:\n32",
1746                     bytes32(uint256(uint160(msg.sender)))
1747                 )
1748             ).recover(signature),
1749         "Signer address mismatch."
1750     );
1751     require(contriMintCounter + 1 <= MAX_CONTRIBUTOR, "reached max contributor supply");
1752     contriMinted[msg.sender] = true;
1753     contriMintCounter += 1;
1754     _safeMint(msg.sender, 1);
1755   }
1756 
1757   function teamMint(uint256 _quantity,bytes calldata signature) external callerIsUser {
1758     require(teamlistMinted[msg.sender] + _quantity <= 5, "reached  limit");
1759     require(
1760         teamSigner==
1761             keccak256(
1762                 abi.encodePacked(
1763                     "\x19Ethereum Signed Message:\n32",
1764                     bytes32(uint256(uint160(msg.sender)))
1765                 )
1766             ).recover(signature),
1767         "Signer address mismatch."
1768     );
1769     require(teamMintCounter + _quantity <= MAX_TEAMER, "reached max team supply");
1770     teamlistMinted[msg.sender] += _quantity;
1771     teamMintCounter += _quantity;
1772     _safeMint(msg.sender, _quantity);
1773   }
1774 
1775   function publicMint(uint256 _callerPublicSaleKey) external callerIsUser {
1776     SaleConfig memory config = saleConfig;
1777     uint256 publicSaleKey = uint256(config.publicSaleKey);
1778     uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1779     require(publicMinted[msg.sender] != true, "already minted");
1780     require(publicSaleKey == _callerPublicSaleKey, "called with incorrect public sale key");
1781     require(isPublicSaleOn(publicSaleKey, publicSaleStartTime), "public sale has not begun yet");
1782     require(MAX_CONTRIBUTOR - contriMintCounter + MAX_TEAMER - teamMintCounter + totalSupply() + 1 <= COLLECTTION_SIZE, "reached max supply");
1783     require(numberMinted(msg.sender) + 1 <= MAX_PERADDRESS_DURING_MINT, "can not mint this many");
1784     publicMinted[msg.sender] = true;
1785     _safeMint(msg.sender, 1);
1786   }
1787 
1788   function isPublicSaleOn(uint256 publicSaleKey, uint256 publicSaleStartTime) public view returns (bool) {
1789     return publicSaleKey != 0 && publicSaleStartTime != 0 && block.timestamp >= publicSaleStartTime;
1790   }
1791 
1792   function setMerkleRoot(uint256 role, bytes32 _merkleRoot) external onlyOwner {
1793     if (role == 2) {
1794       merkleRootRole2 = _merkleRoot;
1795     } else if (role == 3) {
1796       merkleRootRole3 = _merkleRoot;
1797     } else if (role == 4) {
1798       merkleRootRole4 = _merkleRoot;
1799     } else if (role == 6) {
1800       merkleRootRole6 = _merkleRoot;
1801     }
1802   }
1803 
1804   function setMerkleRootAll(
1805     bytes32 _merkleRootRole2,
1806     bytes32 _merkleRootRole3,
1807     bytes32 _merkleRootRole4,
1808     bytes32 _merkleRootRole6
1809   ) external onlyOwner {
1810     merkleRootRole2 = _merkleRootRole2;
1811     merkleRootRole3 = _merkleRootRole3;
1812     merkleRootRole4 = _merkleRootRole4;
1813     merkleRootRole6 = _merkleRootRole6;
1814   }
1815 
1816   function setAllowlistSaleStartTime(uint32 timestamp) external onlyOwner {
1817     saleConfig.allowlistSaleStartTime = timestamp;
1818   }
1819 
1820   function setAllowlistSaleEndTime(uint32 timestamp) external onlyOwner {
1821     saleConfig.allowlistSaleEndTime = timestamp;
1822   }
1823 
1824   function setPublicSaleStartTime(uint32 timestamp) external onlyOwner {
1825     saleConfig.publicSaleStartTime = timestamp;
1826   }
1827 
1828   function setPublicSaleKey(uint32 key) external onlyOwner {
1829     saleConfig.publicSaleKey = key;
1830   }
1831 
1832   function setBaseURI(string calldata baseURI) external onlyOwner {
1833     _baseTokenURI = baseURI;
1834   }
1835 
1836   function _baseURI() internal view virtual override returns (string memory) {
1837     return _baseTokenURI;
1838   }
1839 
1840   function setSigner(address contriSigner_,address teamSigner_) external onlyOwner {
1841     contriSigner = contriSigner_;
1842     teamSigner = teamSigner_;
1843   }
1844 
1845   function withdrawMoney() external onlyOwner nonReentrant {
1846     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1847     require(success, "transfer failed");
1848   }
1849 
1850   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1851     _setOwnersExplicit(quantity);
1852   }
1853 
1854   function numberMinted(address owner) public view returns (uint256) {
1855     return _numberMinted(owner);
1856   }
1857 
1858   function numberAllowlistMinted(address owner) public view returns (uint256) {
1859     return allowlistMinted[owner];
1860   }
1861 
1862   function isContriMinted(address owner) public view returns (bool) {
1863     return contriMinted[owner];
1864   }
1865 
1866   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1867     return ownershipOf(tokenId);
1868   }
1869 }