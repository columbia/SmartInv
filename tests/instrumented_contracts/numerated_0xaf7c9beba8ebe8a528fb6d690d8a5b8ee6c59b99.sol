1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15     uint8 private constant _ADDRESS_LENGTH = 20;
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
75      */
76     function toHexString(address addr) internal pure returns (string memory) {
77         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 
89 /**
90  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
91  *
92  * These functions can be used to verify that a message was signed by the holder
93  * of the private keys of a given address.
94  */
95 library ECDSA {
96     enum RecoverError {
97         NoError,
98         InvalidSignature,
99         InvalidSignatureLength,
100         InvalidSignatureS,
101         InvalidSignatureV
102     }
103 
104     function _throwError(RecoverError error) private pure {
105         if (error == RecoverError.NoError) {
106             return; // no error: do nothing
107         } else if (error == RecoverError.InvalidSignature) {
108             revert("ECDSA: invalid signature");
109         } else if (error == RecoverError.InvalidSignatureLength) {
110             revert("ECDSA: invalid signature length");
111         } else if (error == RecoverError.InvalidSignatureS) {
112             revert("ECDSA: invalid signature 's' value");
113         } else if (error == RecoverError.InvalidSignatureV) {
114             revert("ECDSA: invalid signature 'v' value");
115         }
116     }
117 
118     /**
119      * @dev Returns the address that signed a hashed message (`hash`) with
120      * `signature` or error string. This address can then be used for verification purposes.
121      *
122      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
123      * this function rejects them by requiring the `s` value to be in the lower
124      * half order, and the `v` value to be either 27 or 28.
125      *
126      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
127      * verification to be secure: it is possible to craft signatures that
128      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
129      * this is by receiving a hash of the original message (which may otherwise
130      * be too long), and then calling {toEthSignedMessageHash} on it.
131      *
132      * Documentation for signature generation:
133      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
134      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
135      *
136      * _Available since v4.3._
137      */
138     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
139         // Check the signature length
140         // - case 65: r,s,v signature (standard)
141         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
142         if (signature.length == 65) {
143             bytes32 r;
144             bytes32 s;
145             uint8 v;
146             // ecrecover takes the signature parameters, and the only way to get them
147             // currently is to use assembly.
148             /// @solidity memory-safe-assembly
149             assembly {
150                 r := mload(add(signature, 0x20))
151                 s := mload(add(signature, 0x40))
152                 v := byte(0, mload(add(signature, 0x60)))
153             }
154             return tryRecover(hash, v, r, s);
155         } else if (signature.length == 64) {
156             bytes32 r;
157             bytes32 vs;
158             // ecrecover takes the signature parameters, and the only way to get them
159             // currently is to use assembly.
160             /// @solidity memory-safe-assembly
161             assembly {
162                 r := mload(add(signature, 0x20))
163                 vs := mload(add(signature, 0x40))
164             }
165             return tryRecover(hash, r, vs);
166         } else {
167             return (address(0), RecoverError.InvalidSignatureLength);
168         }
169     }
170 
171     /**
172      * @dev Returns the address that signed a hashed message (`hash`) with
173      * `signature`. This address can then be used for verification purposes.
174      *
175      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
176      * this function rejects them by requiring the `s` value to be in the lower
177      * half order, and the `v` value to be either 27 or 28.
178      *
179      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
180      * verification to be secure: it is possible to craft signatures that
181      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
182      * this is by receiving a hash of the original message (which may otherwise
183      * be too long), and then calling {toEthSignedMessageHash} on it.
184      */
185     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
186         (address recovered, RecoverError error) = tryRecover(hash, signature);
187         _throwError(error);
188         return recovered;
189     }
190 
191     /**
192      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
193      *
194      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
195      *
196      * _Available since v4.3._
197      */
198     function tryRecover(
199         bytes32 hash,
200         bytes32 r,
201         bytes32 vs
202     ) internal pure returns (address, RecoverError) {
203         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
204         uint8 v = uint8((uint256(vs) >> 255) + 27);
205         return tryRecover(hash, v, r, s);
206     }
207 
208     /**
209      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
210      *
211      * _Available since v4.2._
212      */
213     function recover(
214         bytes32 hash,
215         bytes32 r,
216         bytes32 vs
217     ) internal pure returns (address) {
218         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
219         _throwError(error);
220         return recovered;
221     }
222 
223     /**
224      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
225      * `r` and `s` signature fields separately.
226      *
227      * _Available since v4.3._
228      */
229     function tryRecover(
230         bytes32 hash,
231         uint8 v,
232         bytes32 r,
233         bytes32 s
234     ) internal pure returns (address, RecoverError) {
235         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
236         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
237         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
238         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
239         //
240         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
241         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
242         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
243         // these malleable signatures as well.
244         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
245             return (address(0), RecoverError.InvalidSignatureS);
246         }
247         if (v != 27 && v != 28) {
248             return (address(0), RecoverError.InvalidSignatureV);
249         }
250 
251         // If the signature is valid (and not malleable), return the signer address
252         address signer = ecrecover(hash, v, r, s);
253         if (signer == address(0)) {
254             return (address(0), RecoverError.InvalidSignature);
255         }
256 
257         return (signer, RecoverError.NoError);
258     }
259 
260     /**
261      * @dev Overload of {ECDSA-recover} that receives the `v`,
262      * `r` and `s` signature fields separately.
263      */
264     function recover(
265         bytes32 hash,
266         uint8 v,
267         bytes32 r,
268         bytes32 s
269     ) internal pure returns (address) {
270         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
271         _throwError(error);
272         return recovered;
273     }
274 
275     /**
276      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
277      * produces hash corresponding to the one signed with the
278      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
279      * JSON-RPC method as part of EIP-191.
280      *
281      * See {recover}.
282      */
283     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
284         // 32 is the length in bytes of hash,
285         // enforced by the type signature above
286         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
287     }
288 
289     /**
290      * @dev Returns an Ethereum Signed Message, created from `s`. This
291      * produces hash corresponding to the one signed with the
292      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
293      * JSON-RPC method as part of EIP-191.
294      *
295      * See {recover}.
296      */
297     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
298         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
299     }
300 
301     /**
302      * @dev Returns an Ethereum Signed Typed Data, created from a
303      * `domainSeparator` and a `structHash`. This produces hash corresponding
304      * to the one signed with the
305      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
306      * JSON-RPC method as part of EIP-712.
307      *
308      * See {recover}.
309      */
310     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
311         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
312     }
313 }
314 
315 // File: @openzeppelin/contracts/utils/Context.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev Provides information about the current execution context, including the
324  * sender of the transaction and its data. While these are generally available
325  * via msg.sender and msg.data, they should not be accessed in such a direct
326  * manner, since when dealing with meta-transactions the account sending and
327  * paying for execution may not be the actual sender (as far as an application
328  * is concerned).
329  *
330  * This contract is only required for intermediate, library-like contracts.
331  */
332 abstract contract Context {
333     function _msgSender() internal view virtual returns (address) {
334         return msg.sender;
335     }
336 
337     function _msgData() internal view virtual returns (bytes calldata) {
338         return msg.data;
339     }
340 }
341 
342 // File: @openzeppelin/contracts/access/Ownable.sol
343 
344 
345 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
346 
347 pragma solidity ^0.8.0;
348 
349 
350 /**
351  * @dev Contract module which provides a basic access control mechanism, where
352  * there is an account (an owner) that can be granted exclusive access to
353  * specific functions.
354  *
355  * By default, the owner account will be the one that deploys the contract. This
356  * can later be changed with {transferOwnership}.
357  *
358  * This module is used through inheritance. It will make available the modifier
359  * `onlyOwner`, which can be applied to your functions to restrict their use to
360  * the owner.
361  */
362 abstract contract Ownable is Context {
363     address private _owner;
364 
365     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
366 
367     /**
368      * @dev Initializes the contract setting the deployer as the initial owner.
369      */
370     constructor() {
371         _transferOwnership(_msgSender());
372     }
373 
374     /**
375      * @dev Throws if called by any account other than the owner.
376      */
377     modifier onlyOwner() {
378         _checkOwner();
379         _;
380     }
381 
382     /**
383      * @dev Returns the address of the current owner.
384      */
385     function owner() public view virtual returns (address) {
386         return _owner;
387     }
388 
389     /**
390      * @dev Throws if the sender is not the owner.
391      */
392     function _checkOwner() internal view virtual {
393         require(owner() == _msgSender(), "Ownable: caller is not the owner");
394     }
395 
396     /**
397      * @dev Leaves the contract without owner. It will not be possible to call
398      * `onlyOwner` functions anymore. Can only be called by the current owner.
399      *
400      * NOTE: Renouncing ownership will leave the contract without an owner,
401      * thereby removing any functionality that is only available to the owner.
402      */
403     function renounceOwnership() public virtual onlyOwner {
404         _transferOwnership(address(0));
405     }
406 
407     /**
408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
409      * Can only be called by the current owner.
410      */
411     function transferOwnership(address newOwner) public virtual onlyOwner {
412         require(newOwner != address(0), "Ownable: new owner is the zero address");
413         _transferOwnership(newOwner);
414     }
415 
416     /**
417      * @dev Transfers ownership of the contract to a new account (`newOwner`).
418      * Internal function without access restriction.
419      */
420     function _transferOwnership(address newOwner) internal virtual {
421         address oldOwner = _owner;
422         _owner = newOwner;
423         emit OwnershipTransferred(oldOwner, newOwner);
424     }
425 }
426 
427 // File: erc721a/contracts/IERC721A.sol
428 
429 
430 // ERC721A Contracts v4.2.2
431 // Creator: Chiru Labs
432 
433 pragma solidity ^0.8.4;
434 
435 /**
436  * @dev Interface of ERC721A.
437  */
438 interface IERC721A {
439     /**
440      * The caller must own the token or be an approved operator.
441      */
442     error ApprovalCallerNotOwnerNorApproved();
443 
444     /**
445      * The token does not exist.
446      */
447     error ApprovalQueryForNonexistentToken();
448 
449     /**
450      * The caller cannot approve to their own address.
451      */
452     error ApproveToCaller();
453 
454     /**
455      * Cannot query the balance for the zero address.
456      */
457     error BalanceQueryForZeroAddress();
458 
459     /**
460      * Cannot mint to the zero address.
461      */
462     error MintToZeroAddress();
463 
464     /**
465      * The quantity of tokens minted must be more than zero.
466      */
467     error MintZeroQuantity();
468 
469     /**
470      * The token does not exist.
471      */
472     error OwnerQueryForNonexistentToken();
473 
474     /**
475      * The caller must own the token or be an approved operator.
476      */
477     error TransferCallerNotOwnerNorApproved();
478 
479     /**
480      * The token must be owned by `from`.
481      */
482     error TransferFromIncorrectOwner();
483 
484     /**
485      * Cannot safely transfer to a contract that does not implement the
486      * ERC721Receiver interface.
487      */
488     error TransferToNonERC721ReceiverImplementer();
489 
490     /**
491      * Cannot transfer to the zero address.
492      */
493     error TransferToZeroAddress();
494 
495     /**
496      * The token does not exist.
497      */
498     error URIQueryForNonexistentToken();
499 
500     /**
501      * The `quantity` minted with ERC2309 exceeds the safety limit.
502      */
503     error MintERC2309QuantityExceedsLimit();
504 
505     /**
506      * The `extraData` cannot be set on an unintialized ownership slot.
507      */
508     error OwnershipNotInitializedForExtraData();
509 
510     // =============================================================
511     //                            STRUCTS
512     // =============================================================
513 
514     struct TokenOwnership {
515         // The address of the owner.
516         address addr;
517         // Stores the start time of ownership with minimal overhead for tokenomics.
518         uint64 startTimestamp;
519         // Whether the token has been burned.
520         bool burned;
521         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
522         uint24 extraData;
523     }
524 
525     // =============================================================
526     //                         TOKEN COUNTERS
527     // =============================================================
528 
529     /**
530      * @dev Returns the total number of tokens in existence.
531      * Burned tokens will reduce the count.
532      * To get the total number of tokens minted, please see {_totalMinted}.
533      */
534     function totalSupply() external view returns (uint256);
535 
536     // =============================================================
537     //                            IERC165
538     // =============================================================
539 
540     /**
541      * @dev Returns true if this contract implements the interface defined by
542      * `interfaceId`. See the corresponding
543      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
544      * to learn more about how these ids are created.
545      *
546      * This function call must use less than 30000 gas.
547      */
548     function supportsInterface(bytes4 interfaceId) external view returns (bool);
549 
550     // =============================================================
551     //                            IERC721
552     // =============================================================
553 
554     /**
555      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
556      */
557     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
558 
559     /**
560      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
561      */
562     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when `owner` enables or disables
566      * (`approved`) `operator` to manage all of its assets.
567      */
568     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
569 
570     /**
571      * @dev Returns the number of tokens in `owner`'s account.
572      */
573     function balanceOf(address owner) external view returns (uint256 balance);
574 
575     /**
576      * @dev Returns the owner of the `tokenId` token.
577      *
578      * Requirements:
579      *
580      * - `tokenId` must exist.
581      */
582     function ownerOf(uint256 tokenId) external view returns (address owner);
583 
584     /**
585      * @dev Safely transfers `tokenId` token from `from` to `to`,
586      * checking first that contract recipients are aware of the ERC721 protocol
587      * to prevent tokens from being forever locked.
588      *
589      * Requirements:
590      *
591      * - `from` cannot be the zero address.
592      * - `to` cannot be the zero address.
593      * - `tokenId` token must exist and be owned by `from`.
594      * - If the caller is not `from`, it must be have been allowed to move
595      * this token by either {approve} or {setApprovalForAll}.
596      * - If `to` refers to a smart contract, it must implement
597      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
598      *
599      * Emits a {Transfer} event.
600      */
601     function safeTransferFrom(
602         address from,
603         address to,
604         uint256 tokenId,
605         bytes calldata data
606     ) external;
607 
608     /**
609      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Transfers `tokenId` from `from` to `to`.
619      *
620      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
621      * whenever possible.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must be owned by `from`.
628      * - If the caller is not `from`, it must be approved to move this token
629      * by either {approve} or {setApprovalForAll}.
630      *
631      * Emits a {Transfer} event.
632      */
633     function transferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
641      * The approval is cleared when the token is transferred.
642      *
643      * Only a single account can be approved at a time, so approving the
644      * zero address clears previous approvals.
645      *
646      * Requirements:
647      *
648      * - The caller must own the token or be an approved operator.
649      * - `tokenId` must exist.
650      *
651      * Emits an {Approval} event.
652      */
653     function approve(address to, uint256 tokenId) external;
654 
655     /**
656      * @dev Approve or remove `operator` as an operator for the caller.
657      * Operators can call {transferFrom} or {safeTransferFrom}
658      * for any token owned by the caller.
659      *
660      * Requirements:
661      *
662      * - The `operator` cannot be the caller.
663      *
664      * Emits an {ApprovalForAll} event.
665      */
666     function setApprovalForAll(address operator, bool _approved) external;
667 
668     /**
669      * @dev Returns the account approved for `tokenId` token.
670      *
671      * Requirements:
672      *
673      * - `tokenId` must exist.
674      */
675     function getApproved(uint256 tokenId) external view returns (address operator);
676 
677     /**
678      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
679      *
680      * See {setApprovalForAll}.
681      */
682     function isApprovedForAll(address owner, address operator) external view returns (bool);
683 
684     // =============================================================
685     //                        IERC721Metadata
686     // =============================================================
687 
688     /**
689      * @dev Returns the token collection name.
690      */
691     function name() external view returns (string memory);
692 
693     /**
694      * @dev Returns the token collection symbol.
695      */
696     function symbol() external view returns (string memory);
697 
698     /**
699      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
700      */
701     function tokenURI(uint256 tokenId) external view returns (string memory);
702 
703     // =============================================================
704     //                           IERC2309
705     // =============================================================
706 
707     /**
708      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
709      * (inclusive) is transferred from `from` to `to`, as defined in the
710      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
711      *
712      * See {_mintERC2309} for more details.
713      */
714     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
715 }
716 
717 // File: erc721a/contracts/ERC721A.sol
718 
719 
720 // ERC721A Contracts v4.2.2
721 // Creator: Chiru Labs
722 
723 pragma solidity ^0.8.4;
724 
725 
726 /**
727  * @dev Interface of ERC721 token receiver.
728  */
729 interface ERC721A__IERC721Receiver {
730     function onERC721Received(
731         address operator,
732         address from,
733         uint256 tokenId,
734         bytes calldata data
735     ) external returns (bytes4);
736 }
737 
738 /**
739  * @title ERC721A
740  *
741  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
742  * Non-Fungible Token Standard, including the Metadata extension.
743  * Optimized for lower gas during batch mints.
744  *
745  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
746  * starting from `_startTokenId()`.
747  *
748  * Assumptions:
749  *
750  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
751  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
752  */
753 contract ERC721A is IERC721A {
754     // Reference type for token approval.
755     struct TokenApprovalRef {
756         address value;
757     }
758 
759     // =============================================================
760     //                           CONSTANTS
761     // =============================================================
762 
763     // Mask of an entry in packed address data.
764     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
765 
766     // The bit position of `numberMinted` in packed address data.
767     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
768 
769     // The bit position of `numberBurned` in packed address data.
770     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
771 
772     // The bit position of `aux` in packed address data.
773     uint256 private constant _BITPOS_AUX = 192;
774 
775     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
776     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
777 
778     // The bit position of `startTimestamp` in packed ownership.
779     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
780 
781     // The bit mask of the `burned` bit in packed ownership.
782     uint256 private constant _BITMASK_BURNED = 1 << 224;
783 
784     // The bit position of the `nextInitialized` bit in packed ownership.
785     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
786 
787     // The bit mask of the `nextInitialized` bit in packed ownership.
788     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
789 
790     // The bit position of `extraData` in packed ownership.
791     uint256 private constant _BITPOS_EXTRA_DATA = 232;
792 
793     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
794     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
795 
796     // The mask of the lower 160 bits for addresses.
797     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
798 
799     // The maximum `quantity` that can be minted with {_mintERC2309}.
800     // This limit is to prevent overflows on the address data entries.
801     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
802     // is required to cause an overflow, which is unrealistic.
803     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
804 
805     // The `Transfer` event signature is given by:
806     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
807     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
808         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
809 
810     // =============================================================
811     //                            STORAGE
812     // =============================================================
813 
814     // The next token ID to be minted.
815     uint256 private _currentIndex;
816 
817     // The number of tokens burned.
818     uint256 private _burnCounter;
819 
820     // Token name
821     string private _name;
822 
823     // Token symbol
824     string private _symbol;
825 
826     // Mapping from token ID to ownership details
827     // An empty struct value does not necessarily mean the token is unowned.
828     // See {_packedOwnershipOf} implementation for details.
829     //
830     // Bits Layout:
831     // - [0..159]   `addr`
832     // - [160..223] `startTimestamp`
833     // - [224]      `burned`
834     // - [225]      `nextInitialized`
835     // - [232..255] `extraData`
836     mapping(uint256 => uint256) private _packedOwnerships;
837 
838     // Mapping owner address to address data.
839     //
840     // Bits Layout:
841     // - [0..63]    `balance`
842     // - [64..127]  `numberMinted`
843     // - [128..191] `numberBurned`
844     // - [192..255] `aux`
845     mapping(address => uint256) private _packedAddressData;
846 
847     // Mapping from token ID to approved address.
848     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
849 
850     // Mapping from owner to operator approvals
851     mapping(address => mapping(address => bool)) private _operatorApprovals;
852 
853     // =============================================================
854     //                          CONSTRUCTOR
855     // =============================================================
856 
857     constructor(string memory name_, string memory symbol_) {
858         _name = name_;
859         _symbol = symbol_;
860         _currentIndex = _startTokenId();
861     }
862 
863     // =============================================================
864     //                   TOKEN COUNTING OPERATIONS
865     // =============================================================
866 
867     /**
868      * @dev Returns the starting token ID.
869      * To change the starting token ID, please override this function.
870      */
871     function _startTokenId() internal view virtual returns (uint256) {
872         return 0;
873     }
874 
875     /**
876      * @dev Returns the next token ID to be minted.
877      */
878     function _nextTokenId() internal view virtual returns (uint256) {
879         return _currentIndex;
880     }
881 
882     /**
883      * @dev Returns the total number of tokens in existence.
884      * Burned tokens will reduce the count.
885      * To get the total number of tokens minted, please see {_totalMinted}.
886      */
887     function totalSupply() public view virtual override returns (uint256) {
888         // Counter underflow is impossible as _burnCounter cannot be incremented
889         // more than `_currentIndex - _startTokenId()` times.
890         unchecked {
891             return _currentIndex - _burnCounter - _startTokenId();
892         }
893     }
894 
895     /**
896      * @dev Returns the total amount of tokens minted in the contract.
897      */
898     function _totalMinted() internal view virtual returns (uint256) {
899         // Counter underflow is impossible as `_currentIndex` does not decrement,
900         // and it is initialized to `_startTokenId()`.
901         unchecked {
902             return _currentIndex - _startTokenId();
903         }
904     }
905 
906     /**
907      * @dev Returns the total number of tokens burned.
908      */
909     function _totalBurned() internal view virtual returns (uint256) {
910         return _burnCounter;
911     }
912 
913     // =============================================================
914     //                    ADDRESS DATA OPERATIONS
915     // =============================================================
916 
917     /**
918      * @dev Returns the number of tokens in `owner`'s account.
919      */
920     function balanceOf(address owner) public view virtual override returns (uint256) {
921         if (owner == address(0)) revert BalanceQueryForZeroAddress();
922         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
923     }
924 
925     /**
926      * Returns the number of tokens minted by `owner`.
927      */
928     function _numberMinted(address owner) internal view returns (uint256) {
929         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
930     }
931 
932     /**
933      * Returns the number of tokens burned by or on behalf of `owner`.
934      */
935     function _numberBurned(address owner) internal view returns (uint256) {
936         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
937     }
938 
939     /**
940      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
941      */
942     function _getAux(address owner) internal view returns (uint64) {
943         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
944     }
945 
946     /**
947      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
948      * If there are multiple variables, please pack them into a uint64.
949      */
950     function _setAux(address owner, uint64 aux) internal virtual {
951         uint256 packed = _packedAddressData[owner];
952         uint256 auxCasted;
953         // Cast `aux` with assembly to avoid redundant masking.
954         assembly {
955             auxCasted := aux
956         }
957         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
958         _packedAddressData[owner] = packed;
959     }
960 
961     // =============================================================
962     //                            IERC165
963     // =============================================================
964 
965     /**
966      * @dev Returns true if this contract implements the interface defined by
967      * `interfaceId`. See the corresponding
968      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
969      * to learn more about how these ids are created.
970      *
971      * This function call must use less than 30000 gas.
972      */
973     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
974         // The interface IDs are constants representing the first 4 bytes
975         // of the XOR of all function selectors in the interface.
976         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
977         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
978         return
979             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
980             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
981             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
982     }
983 
984     // =============================================================
985     //                        IERC721Metadata
986     // =============================================================
987 
988     /**
989      * @dev Returns the token collection name.
990      */
991     function name() public view virtual override returns (string memory) {
992         return _name;
993     }
994 
995     /**
996      * @dev Returns the token collection symbol.
997      */
998     function symbol() public view virtual override returns (string memory) {
999         return _symbol;
1000     }
1001 
1002     /**
1003      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1004      */
1005     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1006         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1007 
1008         string memory baseURI = _baseURI();
1009         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1010     }
1011 
1012     /**
1013      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1014      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1015      * by default, it can be overridden in child contracts.
1016      */
1017     function _baseURI() internal view virtual returns (string memory) {
1018         return '';
1019     }
1020 
1021     // =============================================================
1022     //                     OWNERSHIPS OPERATIONS
1023     // =============================================================
1024 
1025     /**
1026      * @dev Returns the owner of the `tokenId` token.
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must exist.
1031      */
1032     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1033         return address(uint160(_packedOwnershipOf(tokenId)));
1034     }
1035 
1036     /**
1037      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1038      * It gradually moves to O(1) as tokens get transferred around over time.
1039      */
1040     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1041         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1042     }
1043 
1044     /**
1045      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1046      */
1047     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1048         return _unpackedOwnership(_packedOwnerships[index]);
1049     }
1050 
1051     /**
1052      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1053      */
1054     function _initializeOwnershipAt(uint256 index) internal virtual {
1055         if (_packedOwnerships[index] == 0) {
1056             _packedOwnerships[index] = _packedOwnershipOf(index);
1057         }
1058     }
1059 
1060     /**
1061      * Returns the packed ownership data of `tokenId`.
1062      */
1063     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1064         uint256 curr = tokenId;
1065 
1066         unchecked {
1067             if (_startTokenId() <= curr)
1068                 if (curr < _currentIndex) {
1069                     uint256 packed = _packedOwnerships[curr];
1070                     // If not burned.
1071                     if (packed & _BITMASK_BURNED == 0) {
1072                         // Invariant:
1073                         // There will always be an initialized ownership slot
1074                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1075                         // before an unintialized ownership slot
1076                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1077                         // Hence, `curr` will not underflow.
1078                         //
1079                         // We can directly compare the packed value.
1080                         // If the address is zero, packed will be zero.
1081                         while (packed == 0) {
1082                             packed = _packedOwnerships[--curr];
1083                         }
1084                         return packed;
1085                     }
1086                 }
1087         }
1088         revert OwnerQueryForNonexistentToken();
1089     }
1090 
1091     /**
1092      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1093      */
1094     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1095         ownership.addr = address(uint160(packed));
1096         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1097         ownership.burned = packed & _BITMASK_BURNED != 0;
1098         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1099     }
1100 
1101     /**
1102      * @dev Packs ownership data into a single uint256.
1103      */
1104     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1105         assembly {
1106             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1107             owner := and(owner, _BITMASK_ADDRESS)
1108             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1109             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1110         }
1111     }
1112 
1113     /**
1114      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1115      */
1116     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1117         // For branchless setting of the `nextInitialized` flag.
1118         assembly {
1119             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1120             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1121         }
1122     }
1123 
1124     // =============================================================
1125     //                      APPROVAL OPERATIONS
1126     // =============================================================
1127 
1128     /**
1129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1130      * The approval is cleared when the token is transferred.
1131      *
1132      * Only a single account can be approved at a time, so approving the
1133      * zero address clears previous approvals.
1134      *
1135      * Requirements:
1136      *
1137      * - The caller must own the token or be an approved operator.
1138      * - `tokenId` must exist.
1139      *
1140      * Emits an {Approval} event.
1141      */
1142     function approve(address to, uint256 tokenId) public virtual override {
1143         address owner = ownerOf(tokenId);
1144 
1145         if (_msgSenderERC721A() != owner)
1146             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1147                 revert ApprovalCallerNotOwnerNorApproved();
1148             }
1149 
1150         _tokenApprovals[tokenId].value = to;
1151         emit Approval(owner, to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev Returns the account approved for `tokenId` token.
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must exist.
1160      */
1161     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1162         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1163 
1164         return _tokenApprovals[tokenId].value;
1165     }
1166 
1167     /**
1168      * @dev Approve or remove `operator` as an operator for the caller.
1169      * Operators can call {transferFrom} or {safeTransferFrom}
1170      * for any token owned by the caller.
1171      *
1172      * Requirements:
1173      *
1174      * - The `operator` cannot be the caller.
1175      *
1176      * Emits an {ApprovalForAll} event.
1177      */
1178     function setApprovalForAll(address operator, bool approved) public virtual override {
1179         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1180 
1181         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1182         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1183     }
1184 
1185     /**
1186      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1187      *
1188      * See {setApprovalForAll}.
1189      */
1190     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1191         return _operatorApprovals[owner][operator];
1192     }
1193 
1194     /**
1195      * @dev Returns whether `tokenId` exists.
1196      *
1197      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1198      *
1199      * Tokens start existing when they are minted. See {_mint}.
1200      */
1201     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1202         return
1203             _startTokenId() <= tokenId &&
1204             tokenId < _currentIndex && // If within bounds,
1205             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1206     }
1207 
1208     /**
1209      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1210      */
1211     function _isSenderApprovedOrOwner(
1212         address approvedAddress,
1213         address owner,
1214         address msgSender
1215     ) private pure returns (bool result) {
1216         assembly {
1217             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1218             owner := and(owner, _BITMASK_ADDRESS)
1219             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1220             msgSender := and(msgSender, _BITMASK_ADDRESS)
1221             // `msgSender == owner || msgSender == approvedAddress`.
1222             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1223         }
1224     }
1225 
1226     /**
1227      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1228      */
1229     function _getApprovedSlotAndAddress(uint256 tokenId)
1230         private
1231         view
1232         returns (uint256 approvedAddressSlot, address approvedAddress)
1233     {
1234         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1235         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1236         assembly {
1237             approvedAddressSlot := tokenApproval.slot
1238             approvedAddress := sload(approvedAddressSlot)
1239         }
1240     }
1241 
1242     // =============================================================
1243     //                      TRANSFER OPERATIONS
1244     // =============================================================
1245 
1246     /**
1247      * @dev Transfers `tokenId` from `from` to `to`.
1248      *
1249      * Requirements:
1250      *
1251      * - `from` cannot be the zero address.
1252      * - `to` cannot be the zero address.
1253      * - `tokenId` token must be owned by `from`.
1254      * - If the caller is not `from`, it must be approved to move this token
1255      * by either {approve} or {setApprovalForAll}.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function transferFrom(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) public virtual override {
1264         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1265 
1266         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1267 
1268         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1269 
1270         // The nested ifs save around 20+ gas over a compound boolean condition.
1271         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1272             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1273 
1274         if (to == address(0)) revert TransferToZeroAddress();
1275 
1276         _beforeTokenTransfers(from, to, tokenId, 1);
1277 
1278         // Clear approvals from the previous owner.
1279         assembly {
1280             if approvedAddress {
1281                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1282                 sstore(approvedAddressSlot, 0)
1283             }
1284         }
1285 
1286         // Underflow of the sender's balance is impossible because we check for
1287         // ownership above and the recipient's balance can't realistically overflow.
1288         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1289         unchecked {
1290             // We can directly increment and decrement the balances.
1291             --_packedAddressData[from]; // Updates: `balance -= 1`.
1292             ++_packedAddressData[to]; // Updates: `balance += 1`.
1293 
1294             // Updates:
1295             // - `address` to the next owner.
1296             // - `startTimestamp` to the timestamp of transfering.
1297             // - `burned` to `false`.
1298             // - `nextInitialized` to `true`.
1299             _packedOwnerships[tokenId] = _packOwnershipData(
1300                 to,
1301                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1302             );
1303 
1304             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1305             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1306                 uint256 nextTokenId = tokenId + 1;
1307                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1308                 if (_packedOwnerships[nextTokenId] == 0) {
1309                     // If the next slot is within bounds.
1310                     if (nextTokenId != _currentIndex) {
1311                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1312                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1313                     }
1314                 }
1315             }
1316         }
1317 
1318         emit Transfer(from, to, tokenId);
1319         _afterTokenTransfers(from, to, tokenId, 1);
1320     }
1321 
1322     /**
1323      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1324      */
1325     function safeTransferFrom(
1326         address from,
1327         address to,
1328         uint256 tokenId
1329     ) public virtual override {
1330         safeTransferFrom(from, to, tokenId, '');
1331     }
1332 
1333     /**
1334      * @dev Safely transfers `tokenId` token from `from` to `to`.
1335      *
1336      * Requirements:
1337      *
1338      * - `from` cannot be the zero address.
1339      * - `to` cannot be the zero address.
1340      * - `tokenId` token must exist and be owned by `from`.
1341      * - If the caller is not `from`, it must be approved to move this token
1342      * by either {approve} or {setApprovalForAll}.
1343      * - If `to` refers to a smart contract, it must implement
1344      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1345      *
1346      * Emits a {Transfer} event.
1347      */
1348     function safeTransferFrom(
1349         address from,
1350         address to,
1351         uint256 tokenId,
1352         bytes memory _data
1353     ) public virtual override {
1354         transferFrom(from, to, tokenId);
1355         if (to.code.length != 0)
1356             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1357                 revert TransferToNonERC721ReceiverImplementer();
1358             }
1359     }
1360 
1361     /**
1362      * @dev Hook that is called before a set of serially-ordered token IDs
1363      * are about to be transferred. This includes minting.
1364      * And also called before burning one token.
1365      *
1366      * `startTokenId` - the first token ID to be transferred.
1367      * `quantity` - the amount to be transferred.
1368      *
1369      * Calling conditions:
1370      *
1371      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1372      * transferred to `to`.
1373      * - When `from` is zero, `tokenId` will be minted for `to`.
1374      * - When `to` is zero, `tokenId` will be burned by `from`.
1375      * - `from` and `to` are never both zero.
1376      */
1377     function _beforeTokenTransfers(
1378         address from,
1379         address to,
1380         uint256 startTokenId,
1381         uint256 quantity
1382     ) internal virtual {}
1383 
1384     /**
1385      * @dev Hook that is called after a set of serially-ordered token IDs
1386      * have been transferred. This includes minting.
1387      * And also called after one token has been burned.
1388      *
1389      * `startTokenId` - the first token ID to be transferred.
1390      * `quantity` - the amount to be transferred.
1391      *
1392      * Calling conditions:
1393      *
1394      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1395      * transferred to `to`.
1396      * - When `from` is zero, `tokenId` has been minted for `to`.
1397      * - When `to` is zero, `tokenId` has been burned by `from`.
1398      * - `from` and `to` are never both zero.
1399      */
1400     function _afterTokenTransfers(
1401         address from,
1402         address to,
1403         uint256 startTokenId,
1404         uint256 quantity
1405     ) internal virtual {}
1406 
1407     /**
1408      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1409      *
1410      * `from` - Previous owner of the given token ID.
1411      * `to` - Target address that will receive the token.
1412      * `tokenId` - Token ID to be transferred.
1413      * `_data` - Optional data to send along with the call.
1414      *
1415      * Returns whether the call correctly returned the expected magic value.
1416      */
1417     function _checkContractOnERC721Received(
1418         address from,
1419         address to,
1420         uint256 tokenId,
1421         bytes memory _data
1422     ) private returns (bool) {
1423         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1424             bytes4 retval
1425         ) {
1426             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1427         } catch (bytes memory reason) {
1428             if (reason.length == 0) {
1429                 revert TransferToNonERC721ReceiverImplementer();
1430             } else {
1431                 assembly {
1432                     revert(add(32, reason), mload(reason))
1433                 }
1434             }
1435         }
1436     }
1437 
1438     // =============================================================
1439     //                        MINT OPERATIONS
1440     // =============================================================
1441 
1442     /**
1443      * @dev Mints `quantity` tokens and transfers them to `to`.
1444      *
1445      * Requirements:
1446      *
1447      * - `to` cannot be the zero address.
1448      * - `quantity` must be greater than 0.
1449      *
1450      * Emits a {Transfer} event for each mint.
1451      */
1452     function _mint(address to, uint256 quantity) internal virtual {
1453         uint256 startTokenId = _currentIndex;
1454         if (quantity == 0) revert MintZeroQuantity();
1455 
1456         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1457 
1458         // Overflows are incredibly unrealistic.
1459         // `balance` and `numberMinted` have a maximum limit of 2**64.
1460         // `tokenId` has a maximum limit of 2**256.
1461         unchecked {
1462             // Updates:
1463             // - `balance += quantity`.
1464             // - `numberMinted += quantity`.
1465             //
1466             // We can directly add to the `balance` and `numberMinted`.
1467             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1468 
1469             // Updates:
1470             // - `address` to the owner.
1471             // - `startTimestamp` to the timestamp of minting.
1472             // - `burned` to `false`.
1473             // - `nextInitialized` to `quantity == 1`.
1474             _packedOwnerships[startTokenId] = _packOwnershipData(
1475                 to,
1476                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1477             );
1478 
1479             uint256 toMasked;
1480             uint256 end = startTokenId + quantity;
1481 
1482             // Use assembly to loop and emit the `Transfer` event for gas savings.
1483             assembly {
1484                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1485                 toMasked := and(to, _BITMASK_ADDRESS)
1486                 // Emit the `Transfer` event.
1487                 log4(
1488                     0, // Start of data (0, since no data).
1489                     0, // End of data (0, since no data).
1490                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1491                     0, // `address(0)`.
1492                     toMasked, // `to`.
1493                     startTokenId // `tokenId`.
1494                 )
1495 
1496                 for {
1497                     let tokenId := add(startTokenId, 1)
1498                 } iszero(eq(tokenId, end)) {
1499                     tokenId := add(tokenId, 1)
1500                 } {
1501                     // Emit the `Transfer` event. Similar to above.
1502                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1503                 }
1504             }
1505             if (toMasked == 0) revert MintToZeroAddress();
1506 
1507             _currentIndex = end;
1508         }
1509         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1510     }
1511 
1512     /**
1513      * @dev Mints `quantity` tokens and transfers them to `to`.
1514      *
1515      * This function is intended for efficient minting only during contract creation.
1516      *
1517      * It emits only one {ConsecutiveTransfer} as defined in
1518      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1519      * instead of a sequence of {Transfer} event(s).
1520      *
1521      * Calling this function outside of contract creation WILL make your contract
1522      * non-compliant with the ERC721 standard.
1523      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1524      * {ConsecutiveTransfer} event is only permissible during contract creation.
1525      *
1526      * Requirements:
1527      *
1528      * - `to` cannot be the zero address.
1529      * - `quantity` must be greater than 0.
1530      *
1531      * Emits a {ConsecutiveTransfer} event.
1532      */
1533     function _mintERC2309(address to, uint256 quantity) internal virtual {
1534         uint256 startTokenId = _currentIndex;
1535         if (to == address(0)) revert MintToZeroAddress();
1536         if (quantity == 0) revert MintZeroQuantity();
1537         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1538 
1539         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1540 
1541         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1542         unchecked {
1543             // Updates:
1544             // - `balance += quantity`.
1545             // - `numberMinted += quantity`.
1546             //
1547             // We can directly add to the `balance` and `numberMinted`.
1548             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1549 
1550             // Updates:
1551             // - `address` to the owner.
1552             // - `startTimestamp` to the timestamp of minting.
1553             // - `burned` to `false`.
1554             // - `nextInitialized` to `quantity == 1`.
1555             _packedOwnerships[startTokenId] = _packOwnershipData(
1556                 to,
1557                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1558             );
1559 
1560             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1561 
1562             _currentIndex = startTokenId + quantity;
1563         }
1564         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1565     }
1566 
1567     /**
1568      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1569      *
1570      * Requirements:
1571      *
1572      * - If `to` refers to a smart contract, it must implement
1573      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1574      * - `quantity` must be greater than 0.
1575      *
1576      * See {_mint}.
1577      *
1578      * Emits a {Transfer} event for each mint.
1579      */
1580     function _safeMint(
1581         address to,
1582         uint256 quantity,
1583         bytes memory _data
1584     ) internal virtual {
1585         _mint(to, quantity);
1586 
1587         unchecked {
1588             if (to.code.length != 0) {
1589                 uint256 end = _currentIndex;
1590                 uint256 index = end - quantity;
1591                 do {
1592                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1593                         revert TransferToNonERC721ReceiverImplementer();
1594                     }
1595                 } while (index < end);
1596                 // Reentrancy protection.
1597                 if (_currentIndex != end) revert();
1598             }
1599         }
1600     }
1601 
1602     /**
1603      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1604      */
1605     function _safeMint(address to, uint256 quantity) internal virtual {
1606         _safeMint(to, quantity, '');
1607     }
1608 
1609     // =============================================================
1610     //                        BURN OPERATIONS
1611     // =============================================================
1612 
1613     /**
1614      * @dev Equivalent to `_burn(tokenId, false)`.
1615      */
1616     function _burn(uint256 tokenId) internal virtual {
1617         _burn(tokenId, false);
1618     }
1619 
1620     /**
1621      * @dev Destroys `tokenId`.
1622      * The approval is cleared when the token is burned.
1623      *
1624      * Requirements:
1625      *
1626      * - `tokenId` must exist.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1631         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1632 
1633         address from = address(uint160(prevOwnershipPacked));
1634 
1635         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1636 
1637         if (approvalCheck) {
1638             // The nested ifs save around 20+ gas over a compound boolean condition.
1639             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1640                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1641         }
1642 
1643         _beforeTokenTransfers(from, address(0), tokenId, 1);
1644 
1645         // Clear approvals from the previous owner.
1646         assembly {
1647             if approvedAddress {
1648                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1649                 sstore(approvedAddressSlot, 0)
1650             }
1651         }
1652 
1653         // Underflow of the sender's balance is impossible because we check for
1654         // ownership above and the recipient's balance can't realistically overflow.
1655         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1656         unchecked {
1657             // Updates:
1658             // - `balance -= 1`.
1659             // - `numberBurned += 1`.
1660             //
1661             // We can directly decrement the balance, and increment the number burned.
1662             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1663             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1664 
1665             // Updates:
1666             // - `address` to the last owner.
1667             // - `startTimestamp` to the timestamp of burning.
1668             // - `burned` to `true`.
1669             // - `nextInitialized` to `true`.
1670             _packedOwnerships[tokenId] = _packOwnershipData(
1671                 from,
1672                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1673             );
1674 
1675             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1676             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1677                 uint256 nextTokenId = tokenId + 1;
1678                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1679                 if (_packedOwnerships[nextTokenId] == 0) {
1680                     // If the next slot is within bounds.
1681                     if (nextTokenId != _currentIndex) {
1682                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1683                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1684                     }
1685                 }
1686             }
1687         }
1688 
1689         emit Transfer(from, address(0), tokenId);
1690         _afterTokenTransfers(from, address(0), tokenId, 1);
1691 
1692         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1693         unchecked {
1694             _burnCounter++;
1695         }
1696     }
1697 
1698     // =============================================================
1699     //                     EXTRA DATA OPERATIONS
1700     // =============================================================
1701 
1702     /**
1703      * @dev Directly sets the extra data for the ownership data `index`.
1704      */
1705     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1706         uint256 packed = _packedOwnerships[index];
1707         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1708         uint256 extraDataCasted;
1709         // Cast `extraData` with assembly to avoid redundant masking.
1710         assembly {
1711             extraDataCasted := extraData
1712         }
1713         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1714         _packedOwnerships[index] = packed;
1715     }
1716 
1717     /**
1718      * @dev Called during each token transfer to set the 24bit `extraData` field.
1719      * Intended to be overridden by the cosumer contract.
1720      *
1721      * `previousExtraData` - the value of `extraData` before transfer.
1722      *
1723      * Calling conditions:
1724      *
1725      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1726      * transferred to `to`.
1727      * - When `from` is zero, `tokenId` will be minted for `to`.
1728      * - When `to` is zero, `tokenId` will be burned by `from`.
1729      * - `from` and `to` are never both zero.
1730      */
1731     function _extraData(
1732         address from,
1733         address to,
1734         uint24 previousExtraData
1735     ) internal view virtual returns (uint24) {}
1736 
1737     /**
1738      * @dev Returns the next extra data for the packed ownership data.
1739      * The returned result is shifted into position.
1740      */
1741     function _nextExtraData(
1742         address from,
1743         address to,
1744         uint256 prevOwnershipPacked
1745     ) private view returns (uint256) {
1746         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1747         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1748     }
1749 
1750     // =============================================================
1751     //                       OTHER OPERATIONS
1752     // =============================================================
1753 
1754     /**
1755      * @dev Returns the message sender (defaults to `msg.sender`).
1756      *
1757      * If you are writing GSN compatible contracts, you need to override this function.
1758      */
1759     function _msgSenderERC721A() internal view virtual returns (address) {
1760         return msg.sender;
1761     }
1762 
1763     /**
1764      * @dev Converts a uint256 to its ASCII string decimal representation.
1765      */
1766     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1767         assembly {
1768             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1769             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1770             // We will need 1 32-byte word to store the length,
1771             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1772             str := add(mload(0x40), 0x80)
1773             // Update the free memory pointer to allocate.
1774             mstore(0x40, str)
1775 
1776             // Cache the end of the memory to calculate the length later.
1777             let end := str
1778 
1779             // We write the string from rightmost digit to leftmost digit.
1780             // The following is essentially a do-while loop that also handles the zero case.
1781             // prettier-ignore
1782             for { let temp := value } 1 {} {
1783                 str := sub(str, 1)
1784                 // Write the character to the pointer.
1785                 // The ASCII index of the '0' character is 48.
1786                 mstore8(str, add(48, mod(temp, 10)))
1787                 // Keep dividing `temp` until zero.
1788                 temp := div(temp, 10)
1789                 // prettier-ignore
1790                 if iszero(temp) { break }
1791             }
1792 
1793             let length := sub(end, str)
1794             // Move the pointer 32 bytes leftwards to make room for the length.
1795             str := sub(str, 0x20)
1796             // Store the length.
1797             mstore(str, length)
1798         }
1799     }
1800 }
1801 
1802 // File: contracts/NFTPickerPass.sol
1803 
1804 
1805 
1806 pragma solidity >= 0.0.5 < 0.8.16;
1807 
1808 
1809 
1810 
1811 contract FreePickerPass is ERC721A, Ownable {
1812     using Strings for uint256;
1813 
1814     uint256 MAX_SUPPLY = 3000;
1815     uint256 public constant MINT_PER_WALLET = 1;
1816     uint256 public PUBLIC_MINT_PRICE = 0.03 ether;
1817     
1818     string public tokenBaseUrl = "https://dweb.link/ipfs/bafybeigrf2i7dk5zb3szg5uo6rznqu5ksfm62fxjkbi3wxkeh2imierfsi/assets/";
1819     string public tokenUrlSuffix = ".json";
1820 
1821     constructor () ERC721A("FREEPickerPass", "FREEPICKPass") {
1822     }
1823 
1824     function _baseURI() internal view virtual override returns (string memory) {
1825         return tokenBaseUrl;
1826     }
1827 
1828     function _suffix() internal view virtual returns (string memory) {
1829         return tokenUrlSuffix;
1830     }
1831 
1832     function setMintPrice(uint256 _mintPrice) external onlyOwner {
1833         PUBLIC_MINT_PRICE = _mintPrice;
1834     }
1835     
1836     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1837         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1838         
1839         string memory baseURI = _baseURI();
1840         string memory suffix = _suffix();
1841         
1842         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), suffix)) : '';
1843     }
1844 
1845     function mint(uint256 numTokens) external payable onlyOrigin mintCompliance(numTokens) {
1846         if(500 > totalSupply()){
1847             require(msg.value == 0,"Value supplied is incorrect");
1848         }else{
1849             require(msg.value == PUBLIC_MINT_PRICE, "Value supplied is incorrect");
1850         }
1851         _safeMint(msg.sender, numTokens);
1852     }
1853 
1854     function setTokenBaseUrl(string memory _tokenBaseUrl) public onlyOwner {
1855         tokenBaseUrl = _tokenBaseUrl;
1856     }
1857 
1858     function setTokenSuffix(string memory _tokenUrlSuffix) public onlyOwner {
1859         tokenUrlSuffix = _tokenUrlSuffix;
1860     }
1861     
1862     function drain(address payable to) external onlyOwner {
1863         to.transfer(address(this).balance);
1864     }
1865 
1866     // - modifiers
1867 
1868     modifier onlyOrigin() {
1869         // disallow access from contracts
1870         require(msg.sender == tx.origin, "Come on!!!");
1871         _;
1872     }
1873 
1874     modifier mintCompliance(uint256 _numTokens) {
1875         require(_numTokens > 0, "You must mint at least one token.");
1876         require(totalSupply() + _numTokens < MAX_SUPPLY, "Max supply exceeded!");
1877         require(_numberMinted(msg.sender) + _numTokens < MINT_PER_WALLET + 1,"You are exceeding your minting limit");
1878         _;
1879     }
1880 }