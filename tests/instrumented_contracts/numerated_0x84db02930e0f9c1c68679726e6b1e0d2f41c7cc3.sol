1 // Twisted Reality by Davbob
2 
3 // Twisted Papers will get burned.
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17     uint8 private constant _ADDRESS_LENGTH = 20;
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 
75     /**
76      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
77      */
78     function toHexString(address addr) internal pure returns (string memory) {
79         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
84 
85 
86 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 
91 /**
92  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
93  *
94  * These functions can be used to verify that a message was signed by the holder
95  * of the private keys of a given address.
96  */
97 library ECDSA {
98     enum RecoverError {
99         NoError,
100         InvalidSignature,
101         InvalidSignatureLength,
102         InvalidSignatureS,
103         InvalidSignatureV
104     }
105 
106     function _throwError(RecoverError error) private pure {
107         if (error == RecoverError.NoError) {
108             return; // no error: do nothing
109         } else if (error == RecoverError.InvalidSignature) {
110             revert("ECDSA: invalid signature");
111         } else if (error == RecoverError.InvalidSignatureLength) {
112             revert("ECDSA: invalid signature length");
113         } else if (error == RecoverError.InvalidSignatureS) {
114             revert("ECDSA: invalid signature 's' value");
115         } else if (error == RecoverError.InvalidSignatureV) {
116             revert("ECDSA: invalid signature 'v' value");
117         }
118     }
119 
120     /**
121      * @dev Returns the address that signed a hashed message (`hash`) with
122      * `signature` or error string. This address can then be used for verification purposes.
123      *
124      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
125      * this function rejects them by requiring the `s` value to be in the lower
126      * half order, and the `v` value to be either 27 or 28.
127      *
128      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
129      * verification to be secure: it is possible to craft signatures that
130      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
131      * this is by receiving a hash of the original message (which may otherwise
132      * be too long), and then calling {toEthSignedMessageHash} on it.
133      *
134      * Documentation for signature generation:
135      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
136      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
137      *
138      * _Available since v4.3._
139      */
140     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
141         // Check the signature length
142         // - case 65: r,s,v signature (standard)
143         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
144         if (signature.length == 65) {
145             bytes32 r;
146             bytes32 s;
147             uint8 v;
148             // ecrecover takes the signature parameters, and the only way to get them
149             // currently is to use assembly.
150             /// @solidity memory-safe-assembly
151             assembly {
152                 r := mload(add(signature, 0x20))
153                 s := mload(add(signature, 0x40))
154                 v := byte(0, mload(add(signature, 0x60)))
155             }
156             return tryRecover(hash, v, r, s);
157         } else if (signature.length == 64) {
158             bytes32 r;
159             bytes32 vs;
160             // ecrecover takes the signature parameters, and the only way to get them
161             // currently is to use assembly.
162             /// @solidity memory-safe-assembly
163             assembly {
164                 r := mload(add(signature, 0x20))
165                 vs := mload(add(signature, 0x40))
166             }
167             return tryRecover(hash, r, vs);
168         } else {
169             return (address(0), RecoverError.InvalidSignatureLength);
170         }
171     }
172 
173     /**
174      * @dev Returns the address that signed a hashed message (`hash`) with
175      * `signature`. This address can then be used for verification purposes.
176      *
177      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
178      * this function rejects them by requiring the `s` value to be in the lower
179      * half order, and the `v` value to be either 27 or 28.
180      *
181      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
182      * verification to be secure: it is possible to craft signatures that
183      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
184      * this is by receiving a hash of the original message (which may otherwise
185      * be too long), and then calling {toEthSignedMessageHash} on it.
186      */
187     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
188         (address recovered, RecoverError error) = tryRecover(hash, signature);
189         _throwError(error);
190         return recovered;
191     }
192 
193     /**
194      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
195      *
196      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
197      *
198      * _Available since v4.3._
199      */
200     function tryRecover(
201         bytes32 hash,
202         bytes32 r,
203         bytes32 vs
204     ) internal pure returns (address, RecoverError) {
205         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
206         uint8 v = uint8((uint256(vs) >> 255) + 27);
207         return tryRecover(hash, v, r, s);
208     }
209 
210     /**
211      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
212      *
213      * _Available since v4.2._
214      */
215     function recover(
216         bytes32 hash,
217         bytes32 r,
218         bytes32 vs
219     ) internal pure returns (address) {
220         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
221         _throwError(error);
222         return recovered;
223     }
224 
225     /**
226      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
227      * `r` and `s` signature fields separately.
228      *
229      * _Available since v4.3._
230      */
231     function tryRecover(
232         bytes32 hash,
233         uint8 v,
234         bytes32 r,
235         bytes32 s
236     ) internal pure returns (address, RecoverError) {
237         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
238         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
239         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
240         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
241         //
242         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
243         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
244         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
245         // these malleable signatures as well.
246         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
247             return (address(0), RecoverError.InvalidSignatureS);
248         }
249         if (v != 27 && v != 28) {
250             return (address(0), RecoverError.InvalidSignatureV);
251         }
252 
253         // If the signature is valid (and not malleable), return the signer address
254         address signer = ecrecover(hash, v, r, s);
255         if (signer == address(0)) {
256             return (address(0), RecoverError.InvalidSignature);
257         }
258 
259         return (signer, RecoverError.NoError);
260     }
261 
262     /**
263      * @dev Overload of {ECDSA-recover} that receives the `v`,
264      * `r` and `s` signature fields separately.
265      */
266     function recover(
267         bytes32 hash,
268         uint8 v,
269         bytes32 r,
270         bytes32 s
271     ) internal pure returns (address) {
272         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
273         _throwError(error);
274         return recovered;
275     }
276 
277     /**
278      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
279      * produces hash corresponding to the one signed with the
280      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
281      * JSON-RPC method as part of EIP-191.
282      *
283      * See {recover}.
284      */
285     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
286         // 32 is the length in bytes of hash,
287         // enforced by the type signature above
288         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
289     }
290 
291     /**
292      * @dev Returns an Ethereum Signed Message, created from `s`. This
293      * produces hash corresponding to the one signed with the
294      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
295      * JSON-RPC method as part of EIP-191.
296      *
297      * See {recover}.
298      */
299     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
300         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
301     }
302 
303     /**
304      * @dev Returns an Ethereum Signed Typed Data, created from a
305      * `domainSeparator` and a `structHash`. This produces hash corresponding
306      * to the one signed with the
307      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
308      * JSON-RPC method as part of EIP-712.
309      *
310      * See {recover}.
311      */
312     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
313         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
314     }
315 }
316 
317 // File: @openzeppelin/contracts/utils/Context.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev Provides information about the current execution context, including the
326  * sender of the transaction and its data. While these are generally available
327  * via msg.sender and msg.data, they should not be accessed in such a direct
328  * manner, since when dealing with meta-transactions the account sending and
329  * paying for execution may not be the actual sender (as far as an application
330  * is concerned).
331  *
332  * This contract is only required for intermediate, library-like contracts.
333  */
334 abstract contract Context {
335     function _msgSender() internal view virtual returns (address) {
336         return msg.sender;
337     }
338 
339     function _msgData() internal view virtual returns (bytes calldata) {
340         return msg.data;
341     }
342 }
343 
344 // File: @openzeppelin/contracts/access/Ownable.sol
345 
346 
347 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 
352 /**
353  * @dev Contract module which provides a basic access control mechanism, where
354  * there is an account (an owner) that can be granted exclusive access to
355  * specific functions.
356  *
357  * By default, the owner account will be the one that deploys the contract. This
358  * can later be changed with {transferOwnership}.
359  *
360  * This module is used through inheritance. It will make available the modifier
361  * `onlyOwner`, which can be applied to your functions to restrict their use to
362  * the owner.
363  */
364 abstract contract Ownable is Context {
365     address private _owner;
366 
367     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
368 
369     /**
370      * @dev Initializes the contract setting the deployer as the initial owner.
371      */
372     constructor() {
373         _transferOwnership(_msgSender());
374     }
375 
376     /**
377      * @dev Throws if called by any account other than the owner.
378      */
379     modifier onlyOwner() {
380         _checkOwner();
381         _;
382     }
383 
384     /**
385      * @dev Returns the address of the current owner.
386      */
387     function owner() public view virtual returns (address) {
388         return _owner;
389     }
390 
391     /**
392      * @dev Throws if the sender is not the owner.
393      */
394     function _checkOwner() internal view virtual {
395         require(owner() == _msgSender(), "Ownable: caller is not the owner");
396     }
397 
398     /**
399      * @dev Leaves the contract without owner. It will not be possible to call
400      * `onlyOwner` functions anymore. Can only be called by the current owner.
401      *
402      * NOTE: Renouncing ownership will leave the contract without an owner,
403      * thereby removing any functionality that is only available to the owner.
404      */
405     function renounceOwnership() public virtual onlyOwner {
406         _transferOwnership(address(0));
407     }
408 
409     /**
410      * @dev Transfers ownership of the contract to a new account (`newOwner`).
411      * Can only be called by the current owner.
412      */
413     function transferOwnership(address newOwner) public virtual onlyOwner {
414         require(newOwner != address(0), "Ownable: new owner is the zero address");
415         _transferOwnership(newOwner);
416     }
417 
418     /**
419      * @dev Transfers ownership of the contract to a new account (`newOwner`).
420      * Internal function without access restriction.
421      */
422     function _transferOwnership(address newOwner) internal virtual {
423         address oldOwner = _owner;
424         _owner = newOwner;
425         emit OwnershipTransferred(oldOwner, newOwner);
426     }
427 }
428 
429 // File: erc721a/contracts/IERC721A.sol
430 
431 
432 // ERC721A Contracts v4.2.0
433 // Creator: Chiru Labs
434 
435 pragma solidity ^0.8.4;
436 
437 /**
438  * @dev Interface of ERC721A.
439  */
440 interface IERC721A {
441     /**
442      * The caller must own the token or be an approved operator.
443      */
444     error ApprovalCallerNotOwnerNorApproved();
445 
446     /**
447      * The token does not exist.
448      */
449     error ApprovalQueryForNonexistentToken();
450 
451     /**
452      * The caller cannot approve to their own address.
453      */
454     error ApproveToCaller();
455 
456     /**
457      * Cannot query the balance for the zero address.
458      */
459     error BalanceQueryForZeroAddress();
460 
461     /**
462      * Cannot mint to the zero address.
463      */
464     error MintToZeroAddress();
465 
466     /**
467      * The quantity of tokens minted must be more than zero.
468      */
469     error MintZeroQuantity();
470 
471     /**
472      * The token does not exist.
473      */
474     error OwnerQueryForNonexistentToken();
475 
476     /**
477      * The caller must own the token or be an approved operator.
478      */
479     error TransferCallerNotOwnerNorApproved();
480 
481     /**
482      * The token must be owned by `from`.
483      */
484     error TransferFromIncorrectOwner();
485 
486     /**
487      * Cannot safely transfer to a contract that does not implement the
488      * ERC721Receiver interface.
489      */
490     error TransferToNonERC721ReceiverImplementer();
491 
492     /**
493      * Cannot transfer to the zero address.
494      */
495     error TransferToZeroAddress();
496 
497     /**
498      * The token does not exist.
499      */
500     error URIQueryForNonexistentToken();
501 
502     /**
503      * The `quantity` minted with ERC2309 exceeds the safety limit.
504      */
505     error MintERC2309QuantityExceedsLimit();
506 
507     /**
508      * The `extraData` cannot be set on an unintialized ownership slot.
509      */
510     error OwnershipNotInitializedForExtraData();
511 
512     // =============================================================
513     //                            STRUCTS
514     // =============================================================
515 
516     struct TokenOwnership {
517         // The address of the owner.
518         address addr;
519         // Stores the start time of ownership with minimal overhead for tokenomics.
520         uint64 startTimestamp;
521         // Whether the token has been burned.
522         bool burned;
523         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
524         uint24 extraData;
525     }
526 
527     // =============================================================
528     //                         TOKEN COUNTERS
529     // =============================================================
530 
531     /**
532      * @dev Returns the total number of tokens in existence.
533      * Burned tokens will reduce the count.
534      * To get the total number of tokens minted, please see {_totalMinted}.
535      */
536     function totalSupply() external view returns (uint256);
537 
538     // =============================================================
539     //                            IERC165
540     // =============================================================
541 
542     /**
543      * @dev Returns true if this contract implements the interface defined by
544      * `interfaceId`. See the corresponding
545      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
546      * to learn more about how these ids are created.
547      *
548      * This function call must use less than 30000 gas.
549      */
550     function supportsInterface(bytes4 interfaceId) external view returns (bool);
551 
552     // =============================================================
553     //                            IERC721
554     // =============================================================
555 
556     /**
557      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
558      */
559     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
563      */
564     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
565 
566     /**
567      * @dev Emitted when `owner` enables or disables
568      * (`approved`) `operator` to manage all of its assets.
569      */
570     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
571 
572     /**
573      * @dev Returns the number of tokens in `owner`'s account.
574      */
575     function balanceOf(address owner) external view returns (uint256 balance);
576 
577     /**
578      * @dev Returns the owner of the `tokenId` token.
579      *
580      * Requirements:
581      *
582      * - `tokenId` must exist.
583      */
584     function ownerOf(uint256 tokenId) external view returns (address owner);
585 
586     /**
587      * @dev Safely transfers `tokenId` token from `from` to `to`,
588      * checking first that contract recipients are aware of the ERC721 protocol
589      * to prevent tokens from being forever locked.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must exist and be owned by `from`.
596      * - If the caller is not `from`, it must be have been allowed to move
597      * this token by either {approve} or {setApprovalForAll}.
598      * - If `to` refers to a smart contract, it must implement
599      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
600      *
601      * Emits a {Transfer} event.
602      */
603     function safeTransferFrom(
604         address from,
605         address to,
606         uint256 tokenId,
607         bytes calldata data
608     ) external;
609 
610     /**
611      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external;
618 
619     /**
620      * @dev Transfers `tokenId` from `from` to `to`.
621      *
622      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
623      * whenever possible.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token
631      * by either {approve} or {setApprovalForAll}.
632      *
633      * Emits a {Transfer} event.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external;
640 
641     /**
642      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
643      * The approval is cleared when the token is transferred.
644      *
645      * Only a single account can be approved at a time, so approving the
646      * zero address clears previous approvals.
647      *
648      * Requirements:
649      *
650      * - The caller must own the token or be an approved operator.
651      * - `tokenId` must exist.
652      *
653      * Emits an {Approval} event.
654      */
655     function approve(address to, uint256 tokenId) external;
656 
657     /**
658      * @dev Approve or remove `operator` as an operator for the caller.
659      * Operators can call {transferFrom} or {safeTransferFrom}
660      * for any token owned by the caller.
661      *
662      * Requirements:
663      *
664      * - The `operator` cannot be the caller.
665      *
666      * Emits an {ApprovalForAll} event.
667      */
668     function setApprovalForAll(address operator, bool _approved) external;
669 
670     /**
671      * @dev Returns the account approved for `tokenId` token.
672      *
673      * Requirements:
674      *
675      * - `tokenId` must exist.
676      */
677     function getApproved(uint256 tokenId) external view returns (address operator);
678 
679     /**
680      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
681      *
682      * See {setApprovalForAll}.
683      */
684     function isApprovedForAll(address owner, address operator) external view returns (bool);
685 
686     // =============================================================
687     //                        IERC721Metadata
688     // =============================================================
689 
690     /**
691      * @dev Returns the token collection name.
692      */
693     function name() external view returns (string memory);
694 
695     /**
696      * @dev Returns the token collection symbol.
697      */
698     function symbol() external view returns (string memory);
699 
700     /**
701      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
702      */
703     function tokenURI(uint256 tokenId) external view returns (string memory);
704 
705     // =============================================================
706     //                           IERC2309
707     // =============================================================
708 
709     /**
710      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
711      * (inclusive) is transferred from `from` to `to`, as defined in the
712      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
713      *
714      * See {_mintERC2309} for more details.
715      */
716     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
717 }
718 
719 // File: erc721a/contracts/ERC721A.sol
720 
721 
722 // ERC721A Contracts v4.2.0
723 // Creator: Chiru Labs
724 
725 pragma solidity ^0.8.4;
726 
727 
728 /**
729  * @dev Interface of ERC721 token receiver.
730  */
731 interface ERC721A__IERC721Receiver {
732     function onERC721Received(
733         address operator,
734         address from,
735         uint256 tokenId,
736         bytes calldata data
737     ) external returns (bytes4);
738 }
739 
740 /**
741  * @title ERC721A
742  *
743  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
744  * Non-Fungible Token Standard, including the Metadata extension.
745  * Optimized for lower gas during batch mints.
746  *
747  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
748  * starting from `_startTokenId()`.
749  *
750  * Assumptions:
751  *
752  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
753  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
754  */
755 contract ERC721A is IERC721A {
756     // Reference type for token approval.
757     struct TokenApprovalRef {
758         address value;
759     }
760 
761     // =============================================================
762     //                           CONSTANTS
763     // =============================================================
764 
765     // Mask of an entry in packed address data.
766     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
767 
768     // The bit position of `numberMinted` in packed address data.
769     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
770 
771     // The bit position of `numberBurned` in packed address data.
772     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
773 
774     // The bit position of `aux` in packed address data.
775     uint256 private constant _BITPOS_AUX = 192;
776 
777     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
778     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
779 
780     // The bit position of `startTimestamp` in packed ownership.
781     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
782 
783     // The bit mask of the `burned` bit in packed ownership.
784     uint256 private constant _BITMASK_BURNED = 1 << 224;
785 
786     // The bit position of the `nextInitialized` bit in packed ownership.
787     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
788 
789     // The bit mask of the `nextInitialized` bit in packed ownership.
790     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
791 
792     // The bit position of `extraData` in packed ownership.
793     uint256 private constant _BITPOS_EXTRA_DATA = 232;
794 
795     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
796     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
797 
798     // The mask of the lower 160 bits for addresses.
799     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
800 
801     // The maximum `quantity` that can be minted with {_mintERC2309}.
802     // This limit is to prevent overflows on the address data entries.
803     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
804     // is required to cause an overflow, which is unrealistic.
805     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
806 
807     // The `Transfer` event signature is given by:
808     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
809     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
810         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
811 
812     // =============================================================
813     //                            STORAGE
814     // =============================================================
815 
816     // The next token ID to be minted.
817     uint256 private _currentIndex;
818 
819     // The number of tokens burned.
820     uint256 private _burnCounter;
821 
822     // Token name
823     string private _name;
824 
825     // Token symbol
826     string private _symbol;
827 
828     // Mapping from token ID to ownership details
829     // An empty struct value does not necessarily mean the token is unowned.
830     // See {_packedOwnershipOf} implementation for details.
831     //
832     // Bits Layout:
833     // - [0..159]   `addr`
834     // - [160..223] `startTimestamp`
835     // - [224]      `burned`
836     // - [225]      `nextInitialized`
837     // - [232..255] `extraData`
838     mapping(uint256 => uint256) private _packedOwnerships;
839 
840     // Mapping owner address to address data.
841     //
842     // Bits Layout:
843     // - [0..63]    `balance`
844     // - [64..127]  `numberMinted`
845     // - [128..191] `numberBurned`
846     // - [192..255] `aux`
847     mapping(address => uint256) private _packedAddressData;
848 
849     // Mapping from token ID to approved address.
850     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
851 
852     // Mapping from owner to operator approvals
853     mapping(address => mapping(address => bool)) private _operatorApprovals;
854 
855     // =============================================================
856     //                          CONSTRUCTOR
857     // =============================================================
858 
859     constructor(string memory name_, string memory symbol_) {
860         _name = name_;
861         _symbol = symbol_;
862         _currentIndex = _startTokenId();
863     }
864 
865     // =============================================================
866     //                   TOKEN COUNTING OPERATIONS
867     // =============================================================
868 
869     /**
870      * @dev Returns the starting token ID.
871      * To change the starting token ID, please override this function.
872      */
873     function _startTokenId() internal view virtual returns (uint256) {
874         return 0;
875     }
876 
877     /**
878      * @dev Returns the next token ID to be minted.
879      */
880     function _nextTokenId() internal view virtual returns (uint256) {
881         return _currentIndex;
882     }
883 
884     /**
885      * @dev Returns the total number of tokens in existence.
886      * Burned tokens will reduce the count.
887      * To get the total number of tokens minted, please see {_totalMinted}.
888      */
889     function totalSupply() public view virtual override returns (uint256) {
890         // Counter underflow is impossible as _burnCounter cannot be incremented
891         // more than `_currentIndex - _startTokenId()` times.
892         unchecked {
893             return _currentIndex - _burnCounter - _startTokenId();
894         }
895     }
896 
897     /**
898      * @dev Returns the total amount of tokens minted in the contract.
899      */
900     function _totalMinted() internal view virtual returns (uint256) {
901         // Counter underflow is impossible as `_currentIndex` does not decrement,
902         // and it is initialized to `_startTokenId()`.
903         unchecked {
904             return _currentIndex - _startTokenId();
905         }
906     }
907 
908     /**
909      * @dev Returns the total number of tokens burned.
910      */
911     function _totalBurned() internal view virtual returns (uint256) {
912         return _burnCounter;
913     }
914 
915     // =============================================================
916     //                    ADDRESS DATA OPERATIONS
917     // =============================================================
918 
919     /**
920      * @dev Returns the number of tokens in `owner`'s account.
921      */
922     function balanceOf(address owner) public view virtual override returns (uint256) {
923         if (owner == address(0)) revert BalanceQueryForZeroAddress();
924         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
925     }
926 
927     /**
928      * Returns the number of tokens minted by `owner`.
929      */
930     function _numberMinted(address owner) internal view returns (uint256) {
931         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
932     }
933 
934     /**
935      * Returns the number of tokens burned by or on behalf of `owner`.
936      */
937     function _numberBurned(address owner) internal view returns (uint256) {
938         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
939     }
940 
941     /**
942      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
943      */
944     function _getAux(address owner) internal view returns (uint64) {
945         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
946     }
947 
948     /**
949      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
950      * If there are multiple variables, please pack them into a uint64.
951      */
952     function _setAux(address owner, uint64 aux) internal virtual {
953         uint256 packed = _packedAddressData[owner];
954         uint256 auxCasted;
955         // Cast `aux` with assembly to avoid redundant masking.
956         assembly {
957             auxCasted := aux
958         }
959         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
960         _packedAddressData[owner] = packed;
961     }
962 
963     // =============================================================
964     //                            IERC165
965     // =============================================================
966 
967     /**
968      * @dev Returns true if this contract implements the interface defined by
969      * `interfaceId`. See the corresponding
970      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
971      * to learn more about how these ids are created.
972      *
973      * This function call must use less than 30000 gas.
974      */
975     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
976         // The interface IDs are constants representing the first 4 bytes
977         // of the XOR of all function selectors in the interface.
978         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
979         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
980         return
981             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
982             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
983             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
984     }
985 
986     // =============================================================
987     //                        IERC721Metadata
988     // =============================================================
989 
990     /**
991      * @dev Returns the token collection name.
992      */
993     function name() public view virtual override returns (string memory) {
994         return _name;
995     }
996 
997     /**
998      * @dev Returns the token collection symbol.
999      */
1000     function symbol() public view virtual override returns (string memory) {
1001         return _symbol;
1002     }
1003 
1004     /**
1005      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1006      */
1007     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1008         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1009 
1010         string memory baseURI = _baseURI();
1011         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1012     }
1013 
1014     /**
1015      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1016      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1017      * by default, it can be overridden in child contracts.
1018      */
1019     function _baseURI() internal view virtual returns (string memory) {
1020         return '';
1021     }
1022 
1023     // =============================================================
1024     //                     OWNERSHIPS OPERATIONS
1025     // =============================================================
1026 
1027     /**
1028      * @dev Returns the owner of the `tokenId` token.
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must exist.
1033      */
1034     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1035         return address(uint160(_packedOwnershipOf(tokenId)));
1036     }
1037 
1038     /**
1039      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1040      * It gradually moves to O(1) as tokens get transferred around over time.
1041      */
1042     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1043         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1044     }
1045 
1046     /**
1047      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1048      */
1049     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1050         return _unpackedOwnership(_packedOwnerships[index]);
1051     }
1052 
1053     /**
1054      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1055      */
1056     function _initializeOwnershipAt(uint256 index) internal virtual {
1057         if (_packedOwnerships[index] == 0) {
1058             _packedOwnerships[index] = _packedOwnershipOf(index);
1059         }
1060     }
1061 
1062     /**
1063      * Returns the packed ownership data of `tokenId`.
1064      */
1065     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1066         uint256 curr = tokenId;
1067 
1068         unchecked {
1069             if (_startTokenId() <= curr)
1070                 if (curr < _currentIndex) {
1071                     uint256 packed = _packedOwnerships[curr];
1072                     // If not burned.
1073                     if (packed & _BITMASK_BURNED == 0) {
1074                         // Invariant:
1075                         // There will always be an initialized ownership slot
1076                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1077                         // before an unintialized ownership slot
1078                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1079                         // Hence, `curr` will not underflow.
1080                         //
1081                         // We can directly compare the packed value.
1082                         // If the address is zero, packed will be zero.
1083                         while (packed == 0) {
1084                             packed = _packedOwnerships[--curr];
1085                         }
1086                         return packed;
1087                     }
1088                 }
1089         }
1090         revert OwnerQueryForNonexistentToken();
1091     }
1092 
1093     /**
1094      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1095      */
1096     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1097         ownership.addr = address(uint160(packed));
1098         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1099         ownership.burned = packed & _BITMASK_BURNED != 0;
1100         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1101     }
1102 
1103     /**
1104      * @dev Packs ownership data into a single uint256.
1105      */
1106     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1107         assembly {
1108             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1109             owner := and(owner, _BITMASK_ADDRESS)
1110             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1111             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1117      */
1118     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1119         // For branchless setting of the `nextInitialized` flag.
1120         assembly {
1121             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1122             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1123         }
1124     }
1125 
1126     // =============================================================
1127     //                      APPROVAL OPERATIONS
1128     // =============================================================
1129 
1130     /**
1131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1132      * The approval is cleared when the token is transferred.
1133      *
1134      * Only a single account can be approved at a time, so approving the
1135      * zero address clears previous approvals.
1136      *
1137      * Requirements:
1138      *
1139      * - The caller must own the token or be an approved operator.
1140      * - `tokenId` must exist.
1141      *
1142      * Emits an {Approval} event.
1143      */
1144     function approve(address to, uint256 tokenId) public virtual override {
1145         address owner = ownerOf(tokenId);
1146 
1147         if (_msgSenderERC721A() != owner)
1148             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1149                 revert ApprovalCallerNotOwnerNorApproved();
1150             }
1151 
1152         _tokenApprovals[tokenId].value = to;
1153         emit Approval(owner, to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev Returns the account approved for `tokenId` token.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must exist.
1162      */
1163     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1164         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1165 
1166         return _tokenApprovals[tokenId].value;
1167     }
1168 
1169     /**
1170      * @dev Approve or remove `operator` as an operator for the caller.
1171      * Operators can call {transferFrom} or {safeTransferFrom}
1172      * for any token owned by the caller.
1173      *
1174      * Requirements:
1175      *
1176      * - The `operator` cannot be the caller.
1177      *
1178      * Emits an {ApprovalForAll} event.
1179      */
1180     function setApprovalForAll(address operator, bool approved) public virtual override {
1181         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1182 
1183         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1184         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1185     }
1186 
1187     /**
1188      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1189      *
1190      * See {setApprovalForAll}.
1191      */
1192     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1193         return _operatorApprovals[owner][operator];
1194     }
1195 
1196     /**
1197      * @dev Returns whether `tokenId` exists.
1198      *
1199      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1200      *
1201      * Tokens start existing when they are minted. See {_mint}.
1202      */
1203     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1204         return
1205             _startTokenId() <= tokenId &&
1206             tokenId < _currentIndex && // If within bounds,
1207             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1208     }
1209 
1210     /**
1211      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1212      */
1213     function _isSenderApprovedOrOwner(
1214         address approvedAddress,
1215         address owner,
1216         address msgSender
1217     ) private pure returns (bool result) {
1218         assembly {
1219             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1220             owner := and(owner, _BITMASK_ADDRESS)
1221             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1222             msgSender := and(msgSender, _BITMASK_ADDRESS)
1223             // `msgSender == owner || msgSender == approvedAddress`.
1224             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1225         }
1226     }
1227 
1228     /**
1229      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1230      */
1231     function _getApprovedSlotAndAddress(uint256 tokenId)
1232         private
1233         view
1234         returns (uint256 approvedAddressSlot, address approvedAddress)
1235     {
1236         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1237         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1238         assembly {
1239             approvedAddressSlot := tokenApproval.slot
1240             approvedAddress := sload(approvedAddressSlot)
1241         }
1242     }
1243 
1244     // =============================================================
1245     //                      TRANSFER OPERATIONS
1246     // =============================================================
1247 
1248     /**
1249      * @dev Transfers `tokenId` from `from` to `to`.
1250      *
1251      * Requirements:
1252      *
1253      * - `from` cannot be the zero address.
1254      * - `to` cannot be the zero address.
1255      * - `tokenId` token must be owned by `from`.
1256      * - If the caller is not `from`, it must be approved to move this token
1257      * by either {approve} or {setApprovalForAll}.
1258      *
1259      * Emits a {Transfer} event.
1260      */
1261     function transferFrom(
1262         address from,
1263         address to,
1264         uint256 tokenId
1265     ) public virtual override {
1266         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1267 
1268         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1269 
1270         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1271 
1272         // The nested ifs save around 20+ gas over a compound boolean condition.
1273         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1274             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1275 
1276         if (to == address(0)) revert TransferToZeroAddress();
1277 
1278         _beforeTokenTransfers(from, to, tokenId, 1);
1279 
1280         // Clear approvals from the previous owner.
1281         assembly {
1282             if approvedAddress {
1283                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1284                 sstore(approvedAddressSlot, 0)
1285             }
1286         }
1287 
1288         // Underflow of the sender's balance is impossible because we check for
1289         // ownership above and the recipient's balance can't realistically overflow.
1290         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1291         unchecked {
1292             // We can directly increment and decrement the balances.
1293             --_packedAddressData[from]; // Updates: `balance -= 1`.
1294             ++_packedAddressData[to]; // Updates: `balance += 1`.
1295 
1296             // Updates:
1297             // - `address` to the next owner.
1298             // - `startTimestamp` to the timestamp of transfering.
1299             // - `burned` to `false`.
1300             // - `nextInitialized` to `true`.
1301             _packedOwnerships[tokenId] = _packOwnershipData(
1302                 to,
1303                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1304             );
1305 
1306             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1307             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1308                 uint256 nextTokenId = tokenId + 1;
1309                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1310                 if (_packedOwnerships[nextTokenId] == 0) {
1311                     // If the next slot is within bounds.
1312                     if (nextTokenId != _currentIndex) {
1313                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1314                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1315                     }
1316                 }
1317             }
1318         }
1319 
1320         emit Transfer(from, to, tokenId);
1321         _afterTokenTransfers(from, to, tokenId, 1);
1322     }
1323 
1324     /**
1325      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1326      */
1327     function safeTransferFrom(
1328         address from,
1329         address to,
1330         uint256 tokenId
1331     ) public virtual override {
1332         safeTransferFrom(from, to, tokenId, '');
1333     }
1334 
1335     /**
1336      * @dev Safely transfers `tokenId` token from `from` to `to`.
1337      *
1338      * Requirements:
1339      *
1340      * - `from` cannot be the zero address.
1341      * - `to` cannot be the zero address.
1342      * - `tokenId` token must exist and be owned by `from`.
1343      * - If the caller is not `from`, it must be approved to move this token
1344      * by either {approve} or {setApprovalForAll}.
1345      * - If `to` refers to a smart contract, it must implement
1346      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1347      *
1348      * Emits a {Transfer} event.
1349      */
1350     function safeTransferFrom(
1351         address from,
1352         address to,
1353         uint256 tokenId,
1354         bytes memory _data
1355     ) public virtual override {
1356         transferFrom(from, to, tokenId);
1357         if (to.code.length != 0)
1358             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1359                 revert TransferToNonERC721ReceiverImplementer();
1360             }
1361     }
1362 
1363     /**
1364      * @dev Hook that is called before a set of serially-ordered token IDs
1365      * are about to be transferred. This includes minting.
1366      * And also called before burning one token.
1367      *
1368      * `startTokenId` - the first token ID to be transferred.
1369      * `quantity` - the amount to be transferred.
1370      *
1371      * Calling conditions:
1372      *
1373      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1374      * transferred to `to`.
1375      * - When `from` is zero, `tokenId` will be minted for `to`.
1376      * - When `to` is zero, `tokenId` will be burned by `from`.
1377      * - `from` and `to` are never both zero.
1378      */
1379     function _beforeTokenTransfers(
1380         address from,
1381         address to,
1382         uint256 startTokenId,
1383         uint256 quantity
1384     ) internal virtual {}
1385 
1386     /**
1387      * @dev Hook that is called after a set of serially-ordered token IDs
1388      * have been transferred. This includes minting.
1389      * And also called after one token has been burned.
1390      *
1391      * `startTokenId` - the first token ID to be transferred.
1392      * `quantity` - the amount to be transferred.
1393      *
1394      * Calling conditions:
1395      *
1396      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1397      * transferred to `to`.
1398      * - When `from` is zero, `tokenId` has been minted for `to`.
1399      * - When `to` is zero, `tokenId` has been burned by `from`.
1400      * - `from` and `to` are never both zero.
1401      */
1402     function _afterTokenTransfers(
1403         address from,
1404         address to,
1405         uint256 startTokenId,
1406         uint256 quantity
1407     ) internal virtual {}
1408 
1409     /**
1410      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1411      *
1412      * `from` - Previous owner of the given token ID.
1413      * `to` - Target address that will receive the token.
1414      * `tokenId` - Token ID to be transferred.
1415      * `_data` - Optional data to send along with the call.
1416      *
1417      * Returns whether the call correctly returned the expected magic value.
1418      */
1419     function _checkContractOnERC721Received(
1420         address from,
1421         address to,
1422         uint256 tokenId,
1423         bytes memory _data
1424     ) private returns (bool) {
1425         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1426             bytes4 retval
1427         ) {
1428             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1429         } catch (bytes memory reason) {
1430             if (reason.length == 0) {
1431                 revert TransferToNonERC721ReceiverImplementer();
1432             } else {
1433                 assembly {
1434                     revert(add(32, reason), mload(reason))
1435                 }
1436             }
1437         }
1438     }
1439 
1440     // =============================================================
1441     //                        MINT OPERATIONS
1442     // =============================================================
1443 
1444     /**
1445      * @dev Mints `quantity` tokens and transfers them to `to`.
1446      *
1447      * Requirements:
1448      *
1449      * - `to` cannot be the zero address.
1450      * - `quantity` must be greater than 0.
1451      *
1452      * Emits a {Transfer} event for each mint.
1453      */
1454     function _mint(address to, uint256 quantity) internal virtual {
1455         uint256 startTokenId = _currentIndex;
1456         if (quantity == 0) revert MintZeroQuantity();
1457 
1458         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1459 
1460         // Overflows are incredibly unrealistic.
1461         // `balance` and `numberMinted` have a maximum limit of 2**64.
1462         // `tokenId` has a maximum limit of 2**256.
1463         unchecked {
1464             // Updates:
1465             // - `balance += quantity`.
1466             // - `numberMinted += quantity`.
1467             //
1468             // We can directly add to the `balance` and `numberMinted`.
1469             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1470 
1471             // Updates:
1472             // - `address` to the owner.
1473             // - `startTimestamp` to the timestamp of minting.
1474             // - `burned` to `false`.
1475             // - `nextInitialized` to `quantity == 1`.
1476             _packedOwnerships[startTokenId] = _packOwnershipData(
1477                 to,
1478                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1479             );
1480 
1481             uint256 toMasked;
1482             uint256 end = startTokenId + quantity;
1483 
1484             // Use assembly to loop and emit the `Transfer` event for gas savings.
1485             assembly {
1486                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1487                 toMasked := and(to, _BITMASK_ADDRESS)
1488                 // Emit the `Transfer` event.
1489                 log4(
1490                     0, // Start of data (0, since no data).
1491                     0, // End of data (0, since no data).
1492                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1493                     0, // `address(0)`.
1494                     toMasked, // `to`.
1495                     startTokenId // `tokenId`.
1496                 )
1497 
1498                 for {
1499                     let tokenId := add(startTokenId, 1)
1500                 } iszero(eq(tokenId, end)) {
1501                     tokenId := add(tokenId, 1)
1502                 } {
1503                     // Emit the `Transfer` event. Similar to above.
1504                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1505                 }
1506             }
1507             if (toMasked == 0) revert MintToZeroAddress();
1508 
1509             _currentIndex = end;
1510         }
1511         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1512     }
1513 
1514     /**
1515      * @dev Mints `quantity` tokens and transfers them to `to`.
1516      *
1517      * This function is intended for efficient minting only during contract creation.
1518      *
1519      * It emits only one {ConsecutiveTransfer} as defined in
1520      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1521      * instead of a sequence of {Transfer} event(s).
1522      *
1523      * Calling this function outside of contract creation WILL make your contract
1524      * non-compliant with the ERC721 standard.
1525      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1526      * {ConsecutiveTransfer} event is only permissible during contract creation.
1527      *
1528      * Requirements:
1529      *
1530      * - `to` cannot be the zero address.
1531      * - `quantity` must be greater than 0.
1532      *
1533      * Emits a {ConsecutiveTransfer} event.
1534      */
1535     function _mintERC2309(address to, uint256 quantity) internal virtual {
1536         uint256 startTokenId = _currentIndex;
1537         if (to == address(0)) revert MintToZeroAddress();
1538         if (quantity == 0) revert MintZeroQuantity();
1539         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1540 
1541         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1542 
1543         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1544         unchecked {
1545             // Updates:
1546             // - `balance += quantity`.
1547             // - `numberMinted += quantity`.
1548             //
1549             // We can directly add to the `balance` and `numberMinted`.
1550             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1551 
1552             // Updates:
1553             // - `address` to the owner.
1554             // - `startTimestamp` to the timestamp of minting.
1555             // - `burned` to `false`.
1556             // - `nextInitialized` to `quantity == 1`.
1557             _packedOwnerships[startTokenId] = _packOwnershipData(
1558                 to,
1559                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1560             );
1561 
1562             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1563 
1564             _currentIndex = startTokenId + quantity;
1565         }
1566         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1567     }
1568 
1569     /**
1570      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1571      *
1572      * Requirements:
1573      *
1574      * - If `to` refers to a smart contract, it must implement
1575      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1576      * - `quantity` must be greater than 0.
1577      *
1578      * See {_mint}.
1579      *
1580      * Emits a {Transfer} event for each mint.
1581      */
1582     function _safeMint(
1583         address to,
1584         uint256 quantity,
1585         bytes memory _data
1586     ) internal virtual {
1587         _mint(to, quantity);
1588 
1589         unchecked {
1590             if (to.code.length != 0) {
1591                 uint256 end = _currentIndex;
1592                 uint256 index = end - quantity;
1593                 do {
1594                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1595                         revert TransferToNonERC721ReceiverImplementer();
1596                     }
1597                 } while (index < end);
1598                 // Reentrancy protection.
1599                 if (_currentIndex != end) revert();
1600             }
1601         }
1602     }
1603 
1604     /**
1605      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1606      */
1607     function _safeMint(address to, uint256 quantity) internal virtual {
1608         _safeMint(to, quantity, '');
1609     }
1610 
1611     // =============================================================
1612     //                        BURN OPERATIONS
1613     // =============================================================
1614 
1615     /**
1616      * @dev Equivalent to `_burn(tokenId, false)`.
1617      */
1618     function _burn(uint256 tokenId) internal virtual {
1619         _burn(tokenId, false);
1620     }
1621 
1622     /**
1623      * @dev Destroys `tokenId`.
1624      * The approval is cleared when the token is burned.
1625      *
1626      * Requirements:
1627      *
1628      * - `tokenId` must exist.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1633         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1634 
1635         address from = address(uint160(prevOwnershipPacked));
1636 
1637         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1638 
1639         if (approvalCheck) {
1640             // The nested ifs save around 20+ gas over a compound boolean condition.
1641             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1642                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1643         }
1644 
1645         _beforeTokenTransfers(from, address(0), tokenId, 1);
1646 
1647         // Clear approvals from the previous owner.
1648         assembly {
1649             if approvedAddress {
1650                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1651                 sstore(approvedAddressSlot, 0)
1652             }
1653         }
1654 
1655         // Underflow of the sender's balance is impossible because we check for
1656         // ownership above and the recipient's balance can't realistically overflow.
1657         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1658         unchecked {
1659             // Updates:
1660             // - `balance -= 1`.
1661             // - `numberBurned += 1`.
1662             //
1663             // We can directly decrement the balance, and increment the number burned.
1664             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1665             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1666 
1667             // Updates:
1668             // - `address` to the last owner.
1669             // - `startTimestamp` to the timestamp of burning.
1670             // - `burned` to `true`.
1671             // - `nextInitialized` to `true`.
1672             _packedOwnerships[tokenId] = _packOwnershipData(
1673                 from,
1674                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1675             );
1676 
1677             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1678             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1679                 uint256 nextTokenId = tokenId + 1;
1680                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1681                 if (_packedOwnerships[nextTokenId] == 0) {
1682                     // If the next slot is within bounds.
1683                     if (nextTokenId != _currentIndex) {
1684                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1685                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1686                     }
1687                 }
1688             }
1689         }
1690 
1691         emit Transfer(from, address(0), tokenId);
1692         _afterTokenTransfers(from, address(0), tokenId, 1);
1693 
1694         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1695         unchecked {
1696             _burnCounter++;
1697         }
1698     }
1699 
1700     // =============================================================
1701     //                     EXTRA DATA OPERATIONS
1702     // =============================================================
1703 
1704     /**
1705      * @dev Directly sets the extra data for the ownership data `index`.
1706      */
1707     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1708         uint256 packed = _packedOwnerships[index];
1709         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1710         uint256 extraDataCasted;
1711         // Cast `extraData` with assembly to avoid redundant masking.
1712         assembly {
1713             extraDataCasted := extraData
1714         }
1715         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1716         _packedOwnerships[index] = packed;
1717     }
1718 
1719     /**
1720      * @dev Called during each token transfer to set the 24bit `extraData` field.
1721      * Intended to be overridden by the cosumer contract.
1722      *
1723      * `previousExtraData` - the value of `extraData` before transfer.
1724      *
1725      * Calling conditions:
1726      *
1727      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1728      * transferred to `to`.
1729      * - When `from` is zero, `tokenId` will be minted for `to`.
1730      * - When `to` is zero, `tokenId` will be burned by `from`.
1731      * - `from` and `to` are never both zero.
1732      */
1733     function _extraData(
1734         address from,
1735         address to,
1736         uint24 previousExtraData
1737     ) internal view virtual returns (uint24) {}
1738 
1739     /**
1740      * @dev Returns the next extra data for the packed ownership data.
1741      * The returned result is shifted into position.
1742      */
1743     function _nextExtraData(
1744         address from,
1745         address to,
1746         uint256 prevOwnershipPacked
1747     ) private view returns (uint256) {
1748         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1749         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1750     }
1751 
1752     // =============================================================
1753     //                       OTHER OPERATIONS
1754     // =============================================================
1755 
1756     /**
1757      * @dev Returns the message sender (defaults to `msg.sender`).
1758      *
1759      * If you are writing GSN compatible contracts, you need to override this function.
1760      */
1761     function _msgSenderERC721A() internal view virtual returns (address) {
1762         return msg.sender;
1763     }
1764 
1765     /**
1766      * @dev Converts a uint256 to its ASCII string decimal representation.
1767      */
1768     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1769         assembly {
1770             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1771             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1772             // We will need 1 32-byte word to store the length,
1773             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1774             ptr := add(mload(0x40), 128)
1775             // Update the free memory pointer to allocate.
1776             mstore(0x40, ptr)
1777 
1778             // Cache the end of the memory to calculate the length later.
1779             let end := ptr
1780 
1781             // We write the string from the rightmost digit to the leftmost digit.
1782             // The following is essentially a do-while loop that also handles the zero case.
1783             // Costs a bit more than early returning for the zero case,
1784             // but cheaper in terms of deployment and overall runtime costs.
1785             for {
1786                 // Initialize and perform the first pass without check.
1787                 let temp := value
1788                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1789                 ptr := sub(ptr, 1)
1790                 // Write the character to the pointer.
1791                 // The ASCII index of the '0' character is 48.
1792                 mstore8(ptr, add(48, mod(temp, 10)))
1793                 temp := div(temp, 10)
1794             } temp {
1795                 // Keep dividing `temp` until zero.
1796                 temp := div(temp, 10)
1797             } {
1798                 // Body of the for loop.
1799                 ptr := sub(ptr, 1)
1800                 mstore8(ptr, add(48, mod(temp, 10)))
1801             }
1802 
1803             let length := sub(end, ptr)
1804             // Move the pointer 32 bytes leftwards to make room for the length.
1805             ptr := sub(ptr, 32)
1806             // Store the length.
1807             mstore(ptr, length)
1808         }
1809     }
1810 }
1811 
1812 // File: contracts/TwistedReality.sol
1813 
1814 
1815 
1816 pragma solidity ^0.8.4;
1817 
1818 
1819 
1820 
1821 
1822 contract TwistedReality is ERC721A, Ownable {
1823 
1824   using Strings for uint256;
1825   using ECDSA for bytes32;
1826 
1827   address signer;
1828   error InvalidSignarure();
1829   
1830   uint256 MAX_SUPPLY = 999;
1831   uint256 MAX_PER_TRANSACTION = 5;
1832   uint256 PAID_PRICE = 0.003 ether;
1833   uint256 MAX_FREE_PER_WALLET = 1;
1834   string tokenBaseUri = "ipfs://bafybeiachleot5ddzvzxxl6yzhweg6vod5oazgyagemlcutrt3zrhcmyvu/";
1835 
1836   bool public paused = false;
1837   mapping(address => uint256) private _freeMintedCount;
1838  
1839   constructor() ERC721A("Twisted Reality by Davbob", "TR") {}
1840 
1841   function freeMint(uint256 _quantity) external payable {
1842     
1843       require(!paused, "Minting paused");
1844       require(_freeMintedCount[msg.sender] < MAX_FREE_PER_WALLET);
1845 
1846       uint256 _totalSupply = totalSupply();
1847 
1848       require(_totalSupply + _quantity < MAX_SUPPLY + 1, "SOLD OUT");
1849       require(_quantity < 2, "Max per transaction is 1");
1850 
1851 
1852       _freeMintedCount[msg.sender] += 1;
1853 
1854       _mint(msg.sender, _quantity);
1855     
1856   }
1857 
1858   function paidMint(uint256 _quantity) external payable {
1859       require(!paused, "Minting paused");
1860 
1861       uint256 _totalSupply = totalSupply();
1862 
1863       require(_totalSupply + _quantity < MAX_SUPPLY + 1, "SOLD OUT");
1864       require(_quantity < MAX_PER_TRANSACTION + 1, "Max per transaction paid is 5");
1865       require(msg.value >= _quantity * PAID_PRICE);
1866 
1867       _mint(msg.sender, _quantity);
1868   }
1869 
1870   function freeMintedCount(address owner) external view returns (uint256) {
1871     return _freeMintedCount[owner];
1872   }
1873 
1874   function _startTokenId() internal pure override returns (uint256) {
1875     return 1;
1876   }
1877 
1878   function _baseURI() internal view override returns (string memory) {
1879     return tokenBaseUri;
1880   }
1881 
1882   function setBaseURI(string calldata _newBaseUri) external onlyOwner {
1883     tokenBaseUri = _newBaseUri;
1884   }
1885 
1886   function flipSale(bool _state) external onlyOwner {
1887     paused = _state;
1888   }
1889 
1890   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1891     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1892 
1893     string memory currentBaseURI = _baseURI();
1894     return bytes(currentBaseURI).length > 0
1895         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1896         : '';
1897   }
1898 
1899 
1900   function withdraw() public onlyOwner {
1901     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1902     require(os);
1903   }
1904 
1905   function burn(
1906         uint256 tokenId,
1907         uint8 v,
1908         bytes32 r,
1909         bytes32 s
1910     ) external {
1911         if (keccak256(abi.encodePacked(msg.sender, tokenId)).toEthSignedMessageHash().recover(v, r, s) != signer) {
1912             revert InvalidSignarure();
1913         }
1914         _burn(tokenId);
1915     }
1916   function batchBurn(uint256[] memory tokenids) external onlyOwner {
1917         uint256 len = tokenids.length;
1918         for (uint256 i; i < len; i++) {
1919             uint256 tokenid = tokenids[i];
1920             _burn(tokenid);
1921         }
1922     }
1923 }