1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
5 
6 pragma solidity ^0.8.0;
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
28      */
29     function isContract(address account) internal view returns (bool) {
30         // This method relies on extcodesize, which returns 0 for contracts in
31         // construction, since the code is only stored at the end of the
32         // constructor execution.
33 
34         uint256 size;
35         assembly {
36             size := extcodesize(account)
37         }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         (bool success, ) = recipient.call{value: amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain `call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
121      * with `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{value: value}(data);
135         return verifyCallResult(success, returndata, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
145         return functionStaticCall(target, data, "Address: low-level static call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal view returns (bytes memory) {
159         require(isContract(target), "Address: static call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.staticcall(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         require(isContract(target), "Address: delegate call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
194      * revert reason using the provided one.
195      *
196      * _Available since v4.3._
197      */
198     function verifyCallResult(
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal pure returns (bytes memory) {
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @title ERC721 token receiver interface
230  * @dev Interface for any contract that wants to support safeTransfers
231  * from ERC721 asset contracts.
232  */
233 interface IERC721Receiver {
234     /**
235      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
236      * by `operator` from `from`, this function is called.
237      *
238      * It must return its Solidity selector to confirm the token transfer.
239      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
240      *
241      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
242      */
243     function onERC721Received(
244         address operator,
245         address from,
246         uint256 tokenId,
247         bytes calldata data
248     ) external returns (bytes4);
249 }
250 
251 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Interface of the ERC165 standard, as defined in the
260  * https://eips.ethereum.org/EIPS/eip-165[EIP].
261  *
262  * Implementers can declare support of contract interfaces, which can then be
263  * queried by others ({ERC165Checker}).
264  *
265  * For an implementation, see {ERC165}.
266  */
267 interface IERC165 {
268     /**
269      * @dev Returns true if this contract implements the interface defined by
270      * `interfaceId`. See the corresponding
271      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
272      * to learn more about how these ids are created.
273      *
274      * This function call must use less than 30 000 gas.
275      */
276     function supportsInterface(bytes4 interfaceId) external view returns (bool);
277 }
278 
279 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
280 
281 
282 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 
287 /**
288  * @dev Implementation of the {IERC165} interface.
289  *
290  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
291  * for the additional interface id that will be supported. For example:
292  *
293  * ```solidity
294  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
295  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
296  * }
297  * ```
298  *
299  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
300  */
301 abstract contract ERC165 is IERC165 {
302     /**
303      * @dev See {IERC165-supportsInterface}.
304      */
305     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
306         return interfaceId == type(IERC165).interfaceId;
307     }
308 }
309 
310 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 
318 /**
319  * @dev Required interface of an ERC721 compliant contract.
320  */
321 interface IERC721 is IERC165 {
322     /**
323      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
324      */
325     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
326 
327     /**
328      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
329      */
330     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
334      */
335     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
336 
337     /**
338      * @dev Returns the number of tokens in ``owner``'s account.
339      */
340     function balanceOf(address owner) external view returns (uint256 balance);
341 
342     /**
343      * @dev Returns the owner of the `tokenId` token.
344      *
345      * Requirements:
346      *
347      * - `tokenId` must exist.
348      */
349     function ownerOf(uint256 tokenId) external view returns (address owner);
350 
351     /**
352      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
353      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `tokenId` token must exist and be owned by `from`.
360      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
362      *
363      * Emits a {Transfer} event.
364      */
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId
369     ) external;
370 
371     /**
372      * @dev Transfers `tokenId` token from `from` to `to`.
373      *
374      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `tokenId` token must be owned by `from`.
381      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transferFrom(
386         address from,
387         address to,
388         uint256 tokenId
389     ) external;
390 
391     /**
392      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
393      * The approval is cleared when the token is transferred.
394      *
395      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
396      *
397      * Requirements:
398      *
399      * - The caller must own the token or be an approved operator.
400      * - `tokenId` must exist.
401      *
402      * Emits an {Approval} event.
403      */
404     function approve(address to, uint256 tokenId) external;
405 
406     /**
407      * @dev Returns the account approved for `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function getApproved(uint256 tokenId) external view returns (address operator);
414 
415     /**
416      * @dev Approve or remove `operator` as an operator for the caller.
417      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
418      *
419      * Requirements:
420      *
421      * - The `operator` cannot be the caller.
422      *
423      * Emits an {ApprovalForAll} event.
424      */
425     function setApprovalForAll(address operator, bool _approved) external;
426 
427     /**
428      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
429      *
430      * See {setApprovalForAll}
431      */
432     function isApprovedForAll(address owner, address operator) external view returns (bool);
433 
434     /**
435      * @dev Safely transfers `tokenId` token from `from` to `to`.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId,
451         bytes calldata data
452     ) external;
453 }
454 
455 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 
463 /**
464  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
465  * @dev See https://eips.ethereum.org/EIPS/eip-721
466  */
467 interface IERC721Enumerable is IERC721 {
468     /**
469      * @dev Returns the total amount of tokens stored by the contract.
470      */
471     function totalSupply() external view returns (uint256);
472 
473     /**
474      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
475      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
476      */
477     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
478 
479     /**
480      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
481      * Use along with {totalSupply} to enumerate all tokens.
482      */
483     function tokenByIndex(uint256 index) external view returns (uint256);
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
496  * @dev See https://eips.ethereum.org/EIPS/eip-721
497  */
498 interface IERC721Metadata is IERC721 {
499     /**
500      * @dev Returns the token collection name.
501      */
502     function name() external view returns (string memory);
503 
504     /**
505      * @dev Returns the token collection symbol.
506      */
507     function symbol() external view returns (string memory);
508 
509     /**
510      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
511      */
512     function tokenURI(uint256 tokenId) external view returns (string memory);
513 }
514 
515 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev These functions deal with verification of Merkle Trees proofs.
524  *
525  * The proofs can be generated using the JavaScript library
526  * https://github.com/miguelmota/merkletreejs[merkletreejs].
527  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
528  *
529  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
530  */
531 library MerkleProof {
532     /**
533      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
534      * defined by `root`. For this, a `proof` must be provided, containing
535      * sibling hashes on the branch from the leaf to the root of the tree. Each
536      * pair of leaves and each pair of pre-images are assumed to be sorted.
537      */
538     function verify(
539         bytes32[] memory proof,
540         bytes32 root,
541         bytes32 leaf
542     ) internal pure returns (bool) {
543         return processProof(proof, leaf) == root;
544     }
545 
546     /**
547      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
548      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
549      * hash matches the root of the tree. When processing the proof, the pairs
550      * of leafs & pre-images are assumed to be sorted.
551      *
552      * _Available since v4.4._
553      */
554     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
555         bytes32 computedHash = leaf;
556         for (uint256 i = 0; i < proof.length; i++) {
557             bytes32 proofElement = proof[i];
558             if (computedHash <= proofElement) {
559                 // Hash(current computed hash + current element of the proof)
560                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
561             } else {
562                 // Hash(current element of the proof + current computed hash)
563                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
564             }
565         }
566         return computedHash;
567     }
568 }
569 
570 // File: @openzeppelin/contracts/utils/Strings.sol
571 
572 
573 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev String operations.
579  */
580 library Strings {
581     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
582 
583     /**
584      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
585      */
586     function toString(uint256 value) internal pure returns (string memory) {
587         // Inspired by OraclizeAPI's implementation - MIT licence
588         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
589 
590         if (value == 0) {
591             return "0";
592         }
593         uint256 temp = value;
594         uint256 digits;
595         while (temp != 0) {
596             digits++;
597             temp /= 10;
598         }
599         bytes memory buffer = new bytes(digits);
600         while (value != 0) {
601             digits -= 1;
602             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
603             value /= 10;
604         }
605         return string(buffer);
606     }
607 
608     /**
609      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
610      */
611     function toHexString(uint256 value) internal pure returns (string memory) {
612         if (value == 0) {
613             return "0x00";
614         }
615         uint256 temp = value;
616         uint256 length = 0;
617         while (temp != 0) {
618             length++;
619             temp >>= 8;
620         }
621         return toHexString(value, length);
622     }
623 
624     /**
625      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
626      */
627     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
628         bytes memory buffer = new bytes(2 * length + 2);
629         buffer[0] = "0";
630         buffer[1] = "x";
631         for (uint256 i = 2 * length + 1; i > 1; --i) {
632             buffer[i] = _HEX_SYMBOLS[value & 0xf];
633             value >>= 4;
634         }
635         require(value == 0, "Strings: hex length insufficient");
636         return string(buffer);
637     }
638 }
639 
640 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
641 
642 
643 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
650  *
651  * These functions can be used to verify that a message was signed by the holder
652  * of the private keys of a given address.
653  */
654 library ECDSA {
655     enum RecoverError {
656         NoError,
657         InvalidSignature,
658         InvalidSignatureLength,
659         InvalidSignatureS,
660         InvalidSignatureV
661     }
662 
663     function _throwError(RecoverError error) private pure {
664         if (error == RecoverError.NoError) {
665             return; // no error: do nothing
666         } else if (error == RecoverError.InvalidSignature) {
667             revert("ECDSA: invalid signature");
668         } else if (error == RecoverError.InvalidSignatureLength) {
669             revert("ECDSA: invalid signature length");
670         } else if (error == RecoverError.InvalidSignatureS) {
671             revert("ECDSA: invalid signature 's' value");
672         } else if (error == RecoverError.InvalidSignatureV) {
673             revert("ECDSA: invalid signature 'v' value");
674         }
675     }
676 
677     /**
678      * @dev Returns the address that signed a hashed message (`hash`) with
679      * `signature` or error string. This address can then be used for verification purposes.
680      *
681      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
682      * this function rejects them by requiring the `s` value to be in the lower
683      * half order, and the `v` value to be either 27 or 28.
684      *
685      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
686      * verification to be secure: it is possible to craft signatures that
687      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
688      * this is by receiving a hash of the original message (which may otherwise
689      * be too long), and then calling {toEthSignedMessageHash} on it.
690      *
691      * Documentation for signature generation:
692      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
693      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
694      *
695      * _Available since v4.3._
696      */
697     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
698         // Check the signature length
699         // - case 65: r,s,v signature (standard)
700         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
701         if (signature.length == 65) {
702             bytes32 r;
703             bytes32 s;
704             uint8 v;
705             // ecrecover takes the signature parameters, and the only way to get them
706             // currently is to use assembly.
707             assembly {
708                 r := mload(add(signature, 0x20))
709                 s := mload(add(signature, 0x40))
710                 v := byte(0, mload(add(signature, 0x60)))
711             }
712             return tryRecover(hash, v, r, s);
713         } else if (signature.length == 64) {
714             bytes32 r;
715             bytes32 vs;
716             // ecrecover takes the signature parameters, and the only way to get them
717             // currently is to use assembly.
718             assembly {
719                 r := mload(add(signature, 0x20))
720                 vs := mload(add(signature, 0x40))
721             }
722             return tryRecover(hash, r, vs);
723         } else {
724             return (address(0), RecoverError.InvalidSignatureLength);
725         }
726     }
727 
728     /**
729      * @dev Returns the address that signed a hashed message (`hash`) with
730      * `signature`. This address can then be used for verification purposes.
731      *
732      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
733      * this function rejects them by requiring the `s` value to be in the lower
734      * half order, and the `v` value to be either 27 or 28.
735      *
736      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
737      * verification to be secure: it is possible to craft signatures that
738      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
739      * this is by receiving a hash of the original message (which may otherwise
740      * be too long), and then calling {toEthSignedMessageHash} on it.
741      */
742     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
743         (address recovered, RecoverError error) = tryRecover(hash, signature);
744         _throwError(error);
745         return recovered;
746     }
747 
748     /**
749      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
750      *
751      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
752      *
753      * _Available since v4.3._
754      */
755     function tryRecover(
756         bytes32 hash,
757         bytes32 r,
758         bytes32 vs
759     ) internal pure returns (address, RecoverError) {
760         bytes32 s;
761         uint8 v;
762         assembly {
763             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
764             v := add(shr(255, vs), 27)
765         }
766         return tryRecover(hash, v, r, s);
767     }
768 
769     /**
770      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
771      *
772      * _Available since v4.2._
773      */
774     function recover(
775         bytes32 hash,
776         bytes32 r,
777         bytes32 vs
778     ) internal pure returns (address) {
779         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
780         _throwError(error);
781         return recovered;
782     }
783 
784     /**
785      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
786      * `r` and `s` signature fields separately.
787      *
788      * _Available since v4.3._
789      */
790     function tryRecover(
791         bytes32 hash,
792         uint8 v,
793         bytes32 r,
794         bytes32 s
795     ) internal pure returns (address, RecoverError) {
796         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
797         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
798         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
799         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
800         //
801         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
802         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
803         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
804         // these malleable signatures as well.
805         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
806             return (address(0), RecoverError.InvalidSignatureS);
807         }
808         if (v != 27 && v != 28) {
809             return (address(0), RecoverError.InvalidSignatureV);
810         }
811 
812         // If the signature is valid (and not malleable), return the signer address
813         address signer = ecrecover(hash, v, r, s);
814         if (signer == address(0)) {
815             return (address(0), RecoverError.InvalidSignature);
816         }
817 
818         return (signer, RecoverError.NoError);
819     }
820 
821     /**
822      * @dev Overload of {ECDSA-recover} that receives the `v`,
823      * `r` and `s` signature fields separately.
824      */
825     function recover(
826         bytes32 hash,
827         uint8 v,
828         bytes32 r,
829         bytes32 s
830     ) internal pure returns (address) {
831         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
832         _throwError(error);
833         return recovered;
834     }
835 
836     /**
837      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
838      * produces hash corresponding to the one signed with the
839      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
840      * JSON-RPC method as part of EIP-191.
841      *
842      * See {recover}.
843      */
844     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
845         // 32 is the length in bytes of hash,
846         // enforced by the type signature above
847         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
848     }
849 
850     /**
851      * @dev Returns an Ethereum Signed Message, created from `s`. This
852      * produces hash corresponding to the one signed with the
853      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
854      * JSON-RPC method as part of EIP-191.
855      *
856      * See {recover}.
857      */
858     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
859         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
860     }
861 
862     /**
863      * @dev Returns an Ethereum Signed Typed Data, created from a
864      * `domainSeparator` and a `structHash`. This produces hash corresponding
865      * to the one signed with the
866      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
867      * JSON-RPC method as part of EIP-712.
868      *
869      * See {recover}.
870      */
871     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
872         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
873     }
874 }
875 
876 // File: @openzeppelin/contracts/utils/Context.sol
877 
878 
879 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 /**
884  * @dev Provides information about the current execution context, including the
885  * sender of the transaction and its data. While these are generally available
886  * via msg.sender and msg.data, they should not be accessed in such a direct
887  * manner, since when dealing with meta-transactions the account sending and
888  * paying for execution may not be the actual sender (as far as an application
889  * is concerned).
890  *
891  * This contract is only required for intermediate, library-like contracts.
892  */
893 abstract contract Context {
894     function _msgSender() internal view virtual returns (address) {
895         return msg.sender;
896     }
897 
898     function _msgData() internal view virtual returns (bytes calldata) {
899         return msg.data;
900     }
901 }
902 
903 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
904 
905 
906 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
907 
908 pragma solidity ^0.8.0;
909 
910 
911 
912 
913 
914 
915 
916 
917 /**
918  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
919  * the Metadata extension, but not including the Enumerable extension, which is available separately as
920  * {ERC721Enumerable}.
921  */
922 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
923     using Address for address;
924     using Strings for uint256;
925 
926     // Token name
927     string private _name;
928 
929     // Token symbol
930     string private _symbol;
931 
932     // Mapping from token ID to owner address
933     mapping(uint256 => address) private _owners;
934 
935     // Mapping owner address to token count
936     mapping(address => uint256) private _balances;
937 
938     // Mapping from token ID to approved address
939     mapping(uint256 => address) private _tokenApprovals;
940 
941     // Mapping from owner to operator approvals
942     mapping(address => mapping(address => bool)) private _operatorApprovals;
943 
944     /**
945      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
946      */
947     constructor(string memory name_, string memory symbol_) {
948         _name = name_;
949         _symbol = symbol_;
950     }
951 
952     /**
953      * @dev See {IERC165-supportsInterface}.
954      */
955     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
956         return
957             interfaceId == type(IERC721).interfaceId ||
958             interfaceId == type(IERC721Metadata).interfaceId ||
959             super.supportsInterface(interfaceId);
960     }
961 
962     /**
963      * @dev See {IERC721-balanceOf}.
964      */
965     function balanceOf(address owner) public view virtual override returns (uint256) {
966         require(owner != address(0), "ERC721: balance query for the zero address");
967         return _balances[owner];
968     }
969 
970     /**
971      * @dev See {IERC721-ownerOf}.
972      */
973     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
974         address owner = _owners[tokenId];
975         require(owner != address(0), "ERC721: owner query for nonexistent token");
976         return owner;
977     }
978 
979     /**
980      * @dev See {IERC721Metadata-name}.
981      */
982     function name() public view virtual override returns (string memory) {
983         return _name;
984     }
985 
986     /**
987      * @dev See {IERC721Metadata-symbol}.
988      */
989     function symbol() public view virtual override returns (string memory) {
990         return _symbol;
991     }
992 
993     /**
994      * @dev See {IERC721Metadata-tokenURI}.
995      */
996     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
997         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
998 
999         string memory baseURI = _baseURI();
1000         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1001     }
1002 
1003     /**
1004      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1005      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1006      * by default, can be overriden in child contracts.
1007      */
1008     function _baseURI() internal view virtual returns (string memory) {
1009         return "";
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-approve}.
1014      */
1015     function approve(address to, uint256 tokenId) public virtual override {
1016         address owner = ERC721.ownerOf(tokenId);
1017         require(to != owner, "ERC721: approval to current owner");
1018 
1019         require(
1020             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1021             "ERC721: approve caller is not owner nor approved for all"
1022         );
1023 
1024         _approve(to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-getApproved}.
1029      */
1030     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1031         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1032 
1033         return _tokenApprovals[tokenId];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-setApprovalForAll}.
1038      */
1039     function setApprovalForAll(address operator, bool approved) public virtual override {
1040         _setApprovalForAll(_msgSender(), operator, approved);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-isApprovedForAll}.
1045      */
1046     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1047         return _operatorApprovals[owner][operator];
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-transferFrom}.
1052      */
1053     function transferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) public virtual override {
1058         //solhint-disable-next-line max-line-length
1059         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1060 
1061         _transfer(from, to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-safeTransferFrom}.
1066      */
1067     function safeTransferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) public virtual override {
1072         safeTransferFrom(from, to, tokenId, "");
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-safeTransferFrom}.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId,
1082         bytes memory _data
1083     ) public virtual override {
1084         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1085         _safeTransfer(from, to, tokenId, _data);
1086     }
1087 
1088     /**
1089      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1090      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1091      *
1092      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1093      *
1094      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1095      * implement alternative mechanisms to perform token transfer, such as signature-based.
1096      *
1097      * Requirements:
1098      *
1099      * - `from` cannot be the zero address.
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must exist and be owned by `from`.
1102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _safeTransfer(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) internal virtual {
1112         _transfer(from, to, tokenId);
1113         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1114     }
1115 
1116     /**
1117      * @dev Returns whether `tokenId` exists.
1118      *
1119      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1120      *
1121      * Tokens start existing when they are minted (`_mint`),
1122      * and stop existing when they are burned (`_burn`).
1123      */
1124     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1125         return _owners[tokenId] != address(0);
1126     }
1127 
1128     /**
1129      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1130      *
1131      * Requirements:
1132      *
1133      * - `tokenId` must exist.
1134      */
1135     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1136         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1137         address owner = ERC721.ownerOf(tokenId);
1138         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1139     }
1140 
1141     /**
1142      * @dev Safely mints `tokenId` and transfers it to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must not exist.
1147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _safeMint(address to, uint256 tokenId) internal virtual {
1152         _safeMint(to, tokenId, "");
1153     }
1154 
1155     /**
1156      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1157      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1158      */
1159     function _safeMint(
1160         address to,
1161         uint256 tokenId,
1162         bytes memory _data
1163     ) internal virtual {
1164         _mint(to, tokenId);
1165         require(
1166             _checkOnERC721Received(address(0), to, tokenId, _data),
1167             "ERC721: transfer to non ERC721Receiver implementer"
1168         );
1169     }
1170 
1171     /**
1172      * @dev Mints `tokenId` and transfers it to `to`.
1173      *
1174      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1175      *
1176      * Requirements:
1177      *
1178      * - `tokenId` must not exist.
1179      * - `to` cannot be the zero address.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _mint(address to, uint256 tokenId) internal virtual {
1184         require(to != address(0), "ERC721: mint to the zero address");
1185         require(!_exists(tokenId), "ERC721: token already minted");
1186 
1187         _beforeTokenTransfer(address(0), to, tokenId);
1188 
1189         _balances[to] += 1;
1190         _owners[tokenId] = to;
1191 
1192         emit Transfer(address(0), to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Destroys `tokenId`.
1197      * The approval is cleared when the token is burned.
1198      *
1199      * Requirements:
1200      *
1201      * - `tokenId` must exist.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _burn(uint256 tokenId) internal virtual {
1206         address owner = ERC721.ownerOf(tokenId);
1207 
1208         _beforeTokenTransfer(owner, address(0), tokenId);
1209 
1210         // Clear approvals
1211         _approve(address(0), tokenId);
1212 
1213         _balances[owner] -= 1;
1214         delete _owners[tokenId];
1215 
1216         emit Transfer(owner, address(0), tokenId);
1217     }
1218 
1219     /**
1220      * @dev Transfers `tokenId` from `from` to `to`.
1221      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1222      *
1223      * Requirements:
1224      *
1225      * - `to` cannot be the zero address.
1226      * - `tokenId` token must be owned by `from`.
1227      *
1228      * Emits a {Transfer} event.
1229      */
1230     function _transfer(
1231         address from,
1232         address to,
1233         uint256 tokenId
1234     ) internal virtual {
1235         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1236         require(to != address(0), "ERC721: transfer to the zero address");
1237 
1238         _beforeTokenTransfer(from, to, tokenId);
1239 
1240         // Clear approvals from the previous owner
1241         _approve(address(0), tokenId);
1242 
1243         _balances[from] -= 1;
1244         _balances[to] += 1;
1245         _owners[tokenId] = to;
1246 
1247         emit Transfer(from, to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev Approve `to` to operate on `tokenId`
1252      *
1253      * Emits a {Approval} event.
1254      */
1255     function _approve(address to, uint256 tokenId) internal virtual {
1256         _tokenApprovals[tokenId] = to;
1257         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1258     }
1259 
1260     /**
1261      * @dev Approve `operator` to operate on all of `owner` tokens
1262      *
1263      * Emits a {ApprovalForAll} event.
1264      */
1265     function _setApprovalForAll(
1266         address owner,
1267         address operator,
1268         bool approved
1269     ) internal virtual {
1270         require(owner != operator, "ERC721: approve to caller");
1271         _operatorApprovals[owner][operator] = approved;
1272         emit ApprovalForAll(owner, operator, approved);
1273     }
1274 
1275     /**
1276      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1277      * The call is not executed if the target address is not a contract.
1278      *
1279      * @param from address representing the previous owner of the given token ID
1280      * @param to target address that will receive the tokens
1281      * @param tokenId uint256 ID of the token to be transferred
1282      * @param _data bytes optional data to send along with the call
1283      * @return bool whether the call correctly returned the expected magic value
1284      */
1285     function _checkOnERC721Received(
1286         address from,
1287         address to,
1288         uint256 tokenId,
1289         bytes memory _data
1290     ) private returns (bool) {
1291         if (to.isContract()) {
1292             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1293                 return retval == IERC721Receiver.onERC721Received.selector;
1294             } catch (bytes memory reason) {
1295                 if (reason.length == 0) {
1296                     revert("ERC721: transfer to non ERC721Receiver implementer");
1297                 } else {
1298                     assembly {
1299                         revert(add(32, reason), mload(reason))
1300                     }
1301                 }
1302             }
1303         } else {
1304             return true;
1305         }
1306     }
1307 
1308     /**
1309      * @dev Hook that is called before any token transfer. This includes minting
1310      * and burning.
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` will be minted for `to`.
1317      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1318      * - `from` and `to` are never both zero.
1319      *
1320      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1321      */
1322     function _beforeTokenTransfer(
1323         address from,
1324         address to,
1325         uint256 tokenId
1326     ) internal virtual {}
1327 }
1328 
1329 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1330 
1331 
1332 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1333 
1334 pragma solidity ^0.8.0;
1335 
1336 
1337 
1338 /**
1339  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1340  * enumerability of all the token ids in the contract as well as all token ids owned by each
1341  * account.
1342  */
1343 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1344     // Mapping from owner to list of owned token IDs
1345     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1346 
1347     // Mapping from token ID to index of the owner tokens list
1348     mapping(uint256 => uint256) private _ownedTokensIndex;
1349 
1350     // Array with all token ids, used for enumeration
1351     uint256[] private _allTokens;
1352 
1353     // Mapping from token id to position in the allTokens array
1354     mapping(uint256 => uint256) private _allTokensIndex;
1355 
1356     /**
1357      * @dev See {IERC165-supportsInterface}.
1358      */
1359     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1360         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1361     }
1362 
1363     /**
1364      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1365      */
1366     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1367         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1368         return _ownedTokens[owner][index];
1369     }
1370 
1371     /**
1372      * @dev See {IERC721Enumerable-totalSupply}.
1373      */
1374     function totalSupply() public view virtual override returns (uint256) {
1375         return _allTokens.length;
1376     }
1377 
1378     /**
1379      * @dev See {IERC721Enumerable-tokenByIndex}.
1380      */
1381     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1382         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1383         return _allTokens[index];
1384     }
1385 
1386     /**
1387      * @dev Hook that is called before any token transfer. This includes minting
1388      * and burning.
1389      *
1390      * Calling conditions:
1391      *
1392      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1393      * transferred to `to`.
1394      * - When `from` is zero, `tokenId` will be minted for `to`.
1395      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1396      * - `from` cannot be the zero address.
1397      * - `to` cannot be the zero address.
1398      *
1399      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1400      */
1401     function _beforeTokenTransfer(
1402         address from,
1403         address to,
1404         uint256 tokenId
1405     ) internal virtual override {
1406         super._beforeTokenTransfer(from, to, tokenId);
1407 
1408         if (from == address(0)) {
1409             _addTokenToAllTokensEnumeration(tokenId);
1410         } else if (from != to) {
1411             _removeTokenFromOwnerEnumeration(from, tokenId);
1412         }
1413         if (to == address(0)) {
1414             _removeTokenFromAllTokensEnumeration(tokenId);
1415         } else if (to != from) {
1416             _addTokenToOwnerEnumeration(to, tokenId);
1417         }
1418     }
1419 
1420     /**
1421      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1422      * @param to address representing the new owner of the given token ID
1423      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1424      */
1425     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1426         uint256 length = ERC721.balanceOf(to);
1427         _ownedTokens[to][length] = tokenId;
1428         _ownedTokensIndex[tokenId] = length;
1429     }
1430 
1431     /**
1432      * @dev Private function to add a token to this extension's token tracking data structures.
1433      * @param tokenId uint256 ID of the token to be added to the tokens list
1434      */
1435     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1436         _allTokensIndex[tokenId] = _allTokens.length;
1437         _allTokens.push(tokenId);
1438     }
1439 
1440     /**
1441      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1442      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1443      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1444      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1445      * @param from address representing the previous owner of the given token ID
1446      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1447      */
1448     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1449         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1450         // then delete the last slot (swap and pop).
1451 
1452         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1453         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1454 
1455         // When the token to delete is the last token, the swap operation is unnecessary
1456         if (tokenIndex != lastTokenIndex) {
1457             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1458 
1459             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1460             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1461         }
1462 
1463         // This also deletes the contents at the last position of the array
1464         delete _ownedTokensIndex[tokenId];
1465         delete _ownedTokens[from][lastTokenIndex];
1466     }
1467 
1468     /**
1469      * @dev Private function to remove a token from this extension's token tracking data structures.
1470      * This has O(1) time complexity, but alters the order of the _allTokens array.
1471      * @param tokenId uint256 ID of the token to be removed from the tokens list
1472      */
1473     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1474         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1475         // then delete the last slot (swap and pop).
1476 
1477         uint256 lastTokenIndex = _allTokens.length - 1;
1478         uint256 tokenIndex = _allTokensIndex[tokenId];
1479 
1480         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1481         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1482         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1483         uint256 lastTokenId = _allTokens[lastTokenIndex];
1484 
1485         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1486         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1487 
1488         // This also deletes the contents at the last position of the array
1489         delete _allTokensIndex[tokenId];
1490         _allTokens.pop();
1491     }
1492 }
1493 
1494 // File: @openzeppelin/contracts/access/Ownable.sol
1495 
1496 
1497 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1498 
1499 pragma solidity ^0.8.0;
1500 
1501 
1502 /**
1503  * @dev Contract module which provides a basic access control mechanism, where
1504  * there is an account (an owner) that can be granted exclusive access to
1505  * specific functions.
1506  *
1507  * By default, the owner account will be the one that deploys the contract. This
1508  * can later be changed with {transferOwnership}.
1509  *
1510  * This module is used through inheritance. It will make available the modifier
1511  * `onlyOwner`, which can be applied to your functions to restrict their use to
1512  * the owner.
1513  */
1514 abstract contract Ownable is Context {
1515     address private _owner;
1516 
1517     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1518 
1519     /**
1520      * @dev Initializes the contract setting the deployer as the initial owner.
1521      */
1522     constructor() {
1523         _transferOwnership(_msgSender());
1524     }
1525 
1526     /**
1527      * @dev Returns the address of the current owner.
1528      */
1529     function owner() public view virtual returns (address) {
1530         return _owner;
1531     }
1532 
1533     /**
1534      * @dev Throws if called by any account other than the owner.
1535      */
1536     modifier onlyOwner() {
1537         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1538         _;
1539     }
1540 
1541     /**
1542      * @dev Leaves the contract without owner. It will not be possible to call
1543      * `onlyOwner` functions anymore. Can only be called by the current owner.
1544      *
1545      * NOTE: Renouncing ownership will leave the contract without an owner,
1546      * thereby removing any functionality that is only available to the owner.
1547      */
1548     function renounceOwnership() public virtual onlyOwner {
1549         _transferOwnership(address(0));
1550     }
1551 
1552     /**
1553      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1554      * Can only be called by the current owner.
1555      */
1556     function transferOwnership(address newOwner) public virtual onlyOwner {
1557         require(newOwner != address(0), "Ownable: new owner is the zero address");
1558         _transferOwnership(newOwner);
1559     }
1560 
1561     /**
1562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1563      * Internal function without access restriction.
1564      */
1565     function _transferOwnership(address newOwner) internal virtual {
1566         address oldOwner = _owner;
1567         _owner = newOwner;
1568         emit OwnershipTransferred(oldOwner, newOwner);
1569     }
1570 }
1571 
1572 // File: contracts/DinoBabies.sol
1573 
1574 
1575 pragma solidity ^0.8.0;
1576 
1577 
1578 
1579 
1580 
1581 contract DinoBabies is ERC721Enumerable, Ownable {
1582   string public baseTokenURI;
1583   string public provenanceHash = "";
1584 
1585   uint256 private _price = 0.05 ether;
1586   uint256 private _reserved = 50;
1587   uint256 public _seed = 0;
1588 
1589   bool public publicMintPaused = true;
1590   bool public whitelistMintPaused = true;
1591 
1592   bytes32 private _merkleRoot;
1593 
1594   mapping(address => uint256) public walletCount;
1595 
1596   address private _verifier = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
1597 
1598   constructor(string memory baseURI) ERC721("DinoBabies", "DINOBABIES") {
1599     setBaseURI(baseURI);
1600   }
1601 
1602   function _recoverWallet(
1603     address _wallet,
1604     uint256 _num,
1605     bytes memory _signature
1606   ) internal pure returns (address) {
1607     return
1608       ECDSA.recover(
1609         ECDSA.toEthSignedMessageHash(
1610           keccak256(abi.encodePacked(_wallet, _num))
1611         ),
1612         _signature
1613       );
1614   }
1615 
1616   function mint(uint256 _num, bytes calldata _signature) external payable {
1617     uint256 totalSupply = totalSupply();
1618 
1619     require(!publicMintPaused, "Minting paused");
1620     require(
1621       tx.origin == msg.sender,
1622       "Purchase cannot be called from another contract"
1623     );
1624     require(totalSupply + _num <= 5500 - _reserved, "Exceeds maximum supply");
1625     require(walletCount[_msgSender()] + _num < 5, "Max mint per account is 4");
1626     require(msg.value >= _price * _num, "Ether sent is not correct");
1627 
1628     address signer = _recoverWallet(_msgSender(), _num, _signature);
1629 
1630     require(signer == _verifier, "Unverified transaction");
1631 
1632     walletCount[_msgSender()] += _num;
1633 
1634     for (uint256 i = 1; i <= _num; i++) {
1635       _safeMint(_msgSender(), totalSupply + i);
1636     }
1637 
1638     if (_seed == 0 && totalSupply == 5500) {
1639       _seed = uint256(
1640         keccak256(abi.encodePacked(block.difficulty, block.timestamp))
1641       );
1642     }
1643   }
1644 
1645   function whitelistMint(uint256 _num, bytes32[] calldata _merkleProof)
1646     external
1647     payable
1648   {
1649     uint256 totalSupply = totalSupply();
1650 
1651     require(!whitelistMintPaused, "Minting paused");
1652     require(
1653       tx.origin == msg.sender,
1654       "Purchase cannot be called from another contract"
1655     );
1656     require(totalSupply + _num <= 5500 - _reserved, "Exceeds maximum supply");
1657     require(walletCount[_msgSender()] + _num < 3, "Max mint per account is 2");
1658     require(msg.value >= _price * _num, "Ether sent is not correct");
1659 
1660     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1661 
1662     require(
1663       MerkleProof.verify(_merkleProof, _merkleRoot, leaf),
1664       "Address is not whitelisted"
1665     );
1666 
1667     walletCount[_msgSender()] += _num;
1668 
1669     for (uint256 i = 1; i <= _num; i++) {
1670       _safeMint(_msgSender(), totalSupply + i);
1671     }
1672 
1673     if (_seed == 0 && totalSupply == 5500) {
1674       _seed = uint256(
1675         keccak256(abi.encodePacked(block.difficulty, block.timestamp))
1676       );
1677     }
1678   }
1679 
1680   function _baseURI() internal view virtual override returns (string memory) {
1681     return baseTokenURI;
1682   }
1683 
1684   function giveAway(address _to, uint256 _amount) external payable onlyOwner {
1685     require(_amount <= _reserved, "Exceeds reserved supply");
1686     require(msg.value >= _price * _amount, "Ether sent is not correct");
1687 
1688     uint256 totalSupply = totalSupply();
1689 
1690     for (uint256 i = 1; i <= _amount; i++) {
1691       _safeMint(_to, totalSupply + i);
1692     }
1693 
1694     _reserved -= _amount;
1695   }
1696 
1697   function walletOfOwner(address owner)
1698     external
1699     view
1700     returns (uint256[] memory)
1701   {
1702     uint256 tokenCount = balanceOf(owner);
1703     uint256[] memory tokensId = new uint256[](tokenCount);
1704 
1705     for (uint256 i; i < tokenCount; i++) {
1706       tokensId[i] = tokenOfOwnerByIndex(owner, i);
1707     }
1708 
1709     return tokensId;
1710   }
1711 
1712   function whitelistMintPause(bool _state) public onlyOwner {
1713     whitelistMintPaused = _state;
1714   }
1715 
1716   function publicMintPause(bool _state) public onlyOwner {
1717     publicMintPaused = _state;
1718   }
1719 
1720   function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1721     baseTokenURI = _baseTokenURI;
1722   }
1723 
1724   function setMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
1725     _merkleRoot = _newMerkleRoot;
1726   }
1727 
1728   function setVerifier(address _newVerifier) public onlyOwner {
1729     _verifier = _newVerifier;
1730   }
1731 
1732   function setPrice(uint256 _newPrice) public onlyOwner {
1733     _price = _newPrice;
1734   }
1735 
1736   function setProvenanceHash(string memory _provenanceHash) public onlyOwner {
1737     provenanceHash = _provenanceHash;
1738   }
1739 
1740   function emergencySetSeed() public onlyOwner {
1741     require(_seed == 0, "Seed is already set");
1742 
1743     _seed = uint256(
1744       keccak256(abi.encodePacked(block.difficulty, block.timestamp))
1745     );
1746   }
1747 
1748   function withdraw() public onlyOwner {
1749     require(
1750       payable(owner()).send(address(this).balance),
1751       "Withdraw unsuccessful"
1752     );
1753   }
1754 }