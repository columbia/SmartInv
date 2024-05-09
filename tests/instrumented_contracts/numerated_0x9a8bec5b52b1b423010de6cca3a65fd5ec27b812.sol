1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Strings.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev String operations.
122  */
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125     uint8 private constant _ADDRESS_LENGTH = 20;
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
129      */
130     function toString(uint256 value) internal pure returns (string memory) {
131         // Inspired by OraclizeAPI's implementation - MIT licence
132         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
133 
134         if (value == 0) {
135             return "0";
136         }
137         uint256 temp = value;
138         uint256 digits;
139         while (temp != 0) {
140             digits++;
141             temp /= 10;
142         }
143         bytes memory buffer = new bytes(digits);
144         while (value != 0) {
145             digits -= 1;
146             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
147             value /= 10;
148         }
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
154      */
155     function toHexString(uint256 value) internal pure returns (string memory) {
156         if (value == 0) {
157             return "0x00";
158         }
159         uint256 temp = value;
160         uint256 length = 0;
161         while (temp != 0) {
162             length++;
163             temp >>= 8;
164         }
165         return toHexString(value, length);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
170      */
171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
172         bytes memory buffer = new bytes(2 * length + 2);
173         buffer[0] = "0";
174         buffer[1] = "x";
175         for (uint256 i = 2 * length + 1; i > 1; --i) {
176             buffer[i] = _HEX_SYMBOLS[value & 0xf];
177             value >>= 4;
178         }
179         require(value == 0, "Strings: hex length insufficient");
180         return string(buffer);
181     }
182 
183     /**
184      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
185      */
186     function toHexString(address addr) internal pure returns (string memory) {
187         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
201  *
202  * These functions can be used to verify that a message was signed by the holder
203  * of the private keys of a given address.
204  */
205 library ECDSA {
206     enum RecoverError {
207         NoError,
208         InvalidSignature,
209         InvalidSignatureLength,
210         InvalidSignatureS,
211         InvalidSignatureV
212     }
213 
214     function _throwError(RecoverError error) private pure {
215         if (error == RecoverError.NoError) {
216             return; // no error: do nothing
217         } else if (error == RecoverError.InvalidSignature) {
218             revert("ECDSA: invalid signature");
219         } else if (error == RecoverError.InvalidSignatureLength) {
220             revert("ECDSA: invalid signature length");
221         } else if (error == RecoverError.InvalidSignatureS) {
222             revert("ECDSA: invalid signature 's' value");
223         } else if (error == RecoverError.InvalidSignatureV) {
224             revert("ECDSA: invalid signature 'v' value");
225         }
226     }
227 
228     /**
229      * @dev Returns the address that signed a hashed message (`hash`) with
230      * `signature` or error string. This address can then be used for verification purposes.
231      *
232      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
233      * this function rejects them by requiring the `s` value to be in the lower
234      * half order, and the `v` value to be either 27 or 28.
235      *
236      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
237      * verification to be secure: it is possible to craft signatures that
238      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
239      * this is by receiving a hash of the original message (which may otherwise
240      * be too long), and then calling {toEthSignedMessageHash} on it.
241      *
242      * Documentation for signature generation:
243      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
244      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
245      *
246      * _Available since v4.3._
247      */
248     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
249         if (signature.length == 65) {
250             bytes32 r;
251             bytes32 s;
252             uint8 v;
253             // ecrecover takes the signature parameters, and the only way to get them
254             // currently is to use assembly.
255             /// @solidity memory-safe-assembly
256             assembly {
257                 r := mload(add(signature, 0x20))
258                 s := mload(add(signature, 0x40))
259                 v := byte(0, mload(add(signature, 0x60)))
260             }
261             return tryRecover(hash, v, r, s);
262         } else {
263             return (address(0), RecoverError.InvalidSignatureLength);
264         }
265     }
266 
267     /**
268      * @dev Returns the address that signed a hashed message (`hash`) with
269      * `signature`. This address can then be used for verification purposes.
270      *
271      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
272      * this function rejects them by requiring the `s` value to be in the lower
273      * half order, and the `v` value to be either 27 or 28.
274      *
275      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
276      * verification to be secure: it is possible to craft signatures that
277      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
278      * this is by receiving a hash of the original message (which may otherwise
279      * be too long), and then calling {toEthSignedMessageHash} on it.
280      */
281     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
282         (address recovered, RecoverError error) = tryRecover(hash, signature);
283         _throwError(error);
284         return recovered;
285     }
286 
287     /**
288      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
289      *
290      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
291      *
292      * _Available since v4.3._
293      */
294     function tryRecover(
295         bytes32 hash,
296         bytes32 r,
297         bytes32 vs
298     ) internal pure returns (address, RecoverError) {
299         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
300         uint8 v = uint8((uint256(vs) >> 255) + 27);
301         return tryRecover(hash, v, r, s);
302     }
303 
304     /**
305      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
306      *
307      * _Available since v4.2._
308      */
309     function recover(
310         bytes32 hash,
311         bytes32 r,
312         bytes32 vs
313     ) internal pure returns (address) {
314         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
315         _throwError(error);
316         return recovered;
317     }
318 
319     /**
320      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
321      * `r` and `s` signature fields separately.
322      *
323      * _Available since v4.3._
324      */
325     function tryRecover(
326         bytes32 hash,
327         uint8 v,
328         bytes32 r,
329         bytes32 s
330     ) internal pure returns (address, RecoverError) {
331         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
332         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
333         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
334         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
335         //
336         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
337         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
338         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
339         // these malleable signatures as well.
340         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
341             return (address(0), RecoverError.InvalidSignatureS);
342         }
343         if (v != 27 && v != 28) {
344             return (address(0), RecoverError.InvalidSignatureV);
345         }
346 
347         // If the signature is valid (and not malleable), return the signer address
348         address signer = ecrecover(hash, v, r, s);
349         if (signer == address(0)) {
350             return (address(0), RecoverError.InvalidSignature);
351         }
352 
353         return (signer, RecoverError.NoError);
354     }
355 
356     /**
357      * @dev Overload of {ECDSA-recover} that receives the `v`,
358      * `r` and `s` signature fields separately.
359      */
360     function recover(
361         bytes32 hash,
362         uint8 v,
363         bytes32 r,
364         bytes32 s
365     ) internal pure returns (address) {
366         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
367         _throwError(error);
368         return recovered;
369     }
370 
371     /**
372      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
373      * produces hash corresponding to the one signed with the
374      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
375      * JSON-RPC method as part of EIP-191.
376      *
377      * See {recover}.
378      */
379     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
380         // 32 is the length in bytes of hash,
381         // enforced by the type signature above
382         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
383     }
384 
385     /**
386      * @dev Returns an Ethereum Signed Message, created from `s`. This
387      * produces hash corresponding to the one signed with the
388      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
389      * JSON-RPC method as part of EIP-191.
390      *
391      * See {recover}.
392      */
393     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
394         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
395     }
396 
397     /**
398      * @dev Returns an Ethereum Signed Typed Data, created from a
399      * `domainSeparator` and a `structHash`. This produces hash corresponding
400      * to the one signed with the
401      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
402      * JSON-RPC method as part of EIP-712.
403      *
404      * See {recover}.
405      */
406     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
407         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
408     }
409 }
410 
411 // File: erc721a/contracts/IERC721A.sol
412 
413 
414 // ERC721A Contracts v4.2.2
415 // Creator: Chiru Labs
416 
417 pragma solidity ^0.8.4;
418 
419 /**
420  * @dev Interface of ERC721A.
421  */
422 interface IERC721A {
423     /**
424      * The caller must own the token or be an approved operator.
425      */
426     error ApprovalCallerNotOwnerNorApproved();
427 
428     /**
429      * The token does not exist.
430      */
431     error ApprovalQueryForNonexistentToken();
432 
433     /**
434      * The caller cannot approve to their own address.
435      */
436     error ApproveToCaller();
437 
438     /**
439      * Cannot query the balance for the zero address.
440      */
441     error BalanceQueryForZeroAddress();
442 
443     /**
444      * Cannot mint to the zero address.
445      */
446     error MintToZeroAddress();
447 
448     /**
449      * The quantity of tokens minted must be more than zero.
450      */
451     error MintZeroQuantity();
452 
453     /**
454      * The token does not exist.
455      */
456     error OwnerQueryForNonexistentToken();
457 
458     /**
459      * The caller must own the token or be an approved operator.
460      */
461     error TransferCallerNotOwnerNorApproved();
462 
463     /**
464      * The token must be owned by `from`.
465      */
466     error TransferFromIncorrectOwner();
467 
468     /**
469      * Cannot safely transfer to a contract that does not implement the
470      * ERC721Receiver interface.
471      */
472     error TransferToNonERC721ReceiverImplementer();
473 
474     /**
475      * Cannot transfer to the zero address.
476      */
477     error TransferToZeroAddress();
478 
479     /**
480      * The token does not exist.
481      */
482     error URIQueryForNonexistentToken();
483 
484     /**
485      * The `quantity` minted with ERC2309 exceeds the safety limit.
486      */
487     error MintERC2309QuantityExceedsLimit();
488 
489     /**
490      * The `extraData` cannot be set on an unintialized ownership slot.
491      */
492     error OwnershipNotInitializedForExtraData();
493 
494     // =============================================================
495     //                            STRUCTS
496     // =============================================================
497 
498     struct TokenOwnership {
499         // The address of the owner.
500         address addr;
501         // Stores the start time of ownership with minimal overhead for tokenomics.
502         uint64 startTimestamp;
503         // Whether the token has been burned.
504         bool burned;
505         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
506         uint24 extraData;
507     }
508 
509     // =============================================================
510     //                         TOKEN COUNTERS
511     // =============================================================
512 
513     /**
514      * @dev Returns the total number of tokens in existence.
515      * Burned tokens will reduce the count.
516      * To get the total number of tokens minted, please see {_totalMinted}.
517      */
518     function totalSupply() external view returns (uint256);
519 
520     // =============================================================
521     //                            IERC165
522     // =============================================================
523 
524     /**
525      * @dev Returns true if this contract implements the interface defined by
526      * `interfaceId`. See the corresponding
527      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
528      * to learn more about how these ids are created.
529      *
530      * This function call must use less than 30000 gas.
531      */
532     function supportsInterface(bytes4 interfaceId) external view returns (bool);
533 
534     // =============================================================
535     //                            IERC721
536     // =============================================================
537 
538     /**
539      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
540      */
541     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
542 
543     /**
544      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
545      */
546     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
547 
548     /**
549      * @dev Emitted when `owner` enables or disables
550      * (`approved`) `operator` to manage all of its assets.
551      */
552     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
553 
554     /**
555      * @dev Returns the number of tokens in `owner`'s account.
556      */
557     function balanceOf(address owner) external view returns (uint256 balance);
558 
559     /**
560      * @dev Returns the owner of the `tokenId` token.
561      *
562      * Requirements:
563      *
564      * - `tokenId` must exist.
565      */
566     function ownerOf(uint256 tokenId) external view returns (address owner);
567 
568     /**
569      * @dev Safely transfers `tokenId` token from `from` to `to`,
570      * checking first that contract recipients are aware of the ERC721 protocol
571      * to prevent tokens from being forever locked.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be have been allowed to move
579      * this token by either {approve} or {setApprovalForAll}.
580      * - If `to` refers to a smart contract, it must implement
581      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId,
589         bytes calldata data
590     ) external;
591 
592     /**
593      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Transfers `tokenId` from `from` to `to`.
603      *
604      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
605      * whenever possible.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must be owned by `from`.
612      * - If the caller is not `from`, it must be approved to move this token
613      * by either {approve} or {setApprovalForAll}.
614      *
615      * Emits a {Transfer} event.
616      */
617     function transferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external;
622 
623     /**
624      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
625      * The approval is cleared when the token is transferred.
626      *
627      * Only a single account can be approved at a time, so approving the
628      * zero address clears previous approvals.
629      *
630      * Requirements:
631      *
632      * - The caller must own the token or be an approved operator.
633      * - `tokenId` must exist.
634      *
635      * Emits an {Approval} event.
636      */
637     function approve(address to, uint256 tokenId) external;
638 
639     /**
640      * @dev Approve or remove `operator` as an operator for the caller.
641      * Operators can call {transferFrom} or {safeTransferFrom}
642      * for any token owned by the caller.
643      *
644      * Requirements:
645      *
646      * - The `operator` cannot be the caller.
647      *
648      * Emits an {ApprovalForAll} event.
649      */
650     function setApprovalForAll(address operator, bool _approved) external;
651 
652     /**
653      * @dev Returns the account approved for `tokenId` token.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      */
659     function getApproved(uint256 tokenId) external view returns (address operator);
660 
661     /**
662      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
663      *
664      * See {setApprovalForAll}.
665      */
666     function isApprovedForAll(address owner, address operator) external view returns (bool);
667 
668     // =============================================================
669     //                        IERC721Metadata
670     // =============================================================
671 
672     /**
673      * @dev Returns the token collection name.
674      */
675     function name() external view returns (string memory);
676 
677     /**
678      * @dev Returns the token collection symbol.
679      */
680     function symbol() external view returns (string memory);
681 
682     /**
683      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
684      */
685     function tokenURI(uint256 tokenId) external view returns (string memory);
686 
687     // =============================================================
688     //                           IERC2309
689     // =============================================================
690 
691     /**
692      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
693      * (inclusive) is transferred from `from` to `to`, as defined in the
694      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
695      *
696      * See {_mintERC2309} for more details.
697      */
698     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
699 }
700 
701 // File: erc721a/contracts/ERC721A.sol
702 
703 
704 // ERC721A Contracts v4.2.2
705 // Creator: Chiru Labs
706 
707 pragma solidity ^0.8.4;
708 
709 
710 /**
711  * @dev Interface of ERC721 token receiver.
712  */
713 interface ERC721A__IERC721Receiver {
714     function onERC721Received(
715         address operator,
716         address from,
717         uint256 tokenId,
718         bytes calldata data
719     ) external returns (bytes4);
720 }
721 
722 /**
723  * @title ERC721A
724  *
725  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
726  * Non-Fungible Token Standard, including the Metadata extension.
727  * Optimized for lower gas during batch mints.
728  *
729  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
730  * starting from `_startTokenId()`.
731  *
732  * Assumptions:
733  *
734  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
735  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
736  */
737 contract ERC721A is IERC721A {
738     // Reference type for token approval.
739     struct TokenApprovalRef {
740         address value;
741     }
742 
743     // =============================================================
744     //                           CONSTANTS
745     // =============================================================
746 
747     // Mask of an entry in packed address data.
748     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
749 
750     // The bit position of `numberMinted` in packed address data.
751     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
752 
753     // The bit position of `numberBurned` in packed address data.
754     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
755 
756     // The bit position of `aux` in packed address data.
757     uint256 private constant _BITPOS_AUX = 192;
758 
759     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
760     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
761 
762     // The bit position of `startTimestamp` in packed ownership.
763     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
764 
765     // The bit mask of the `burned` bit in packed ownership.
766     uint256 private constant _BITMASK_BURNED = 1 << 224;
767 
768     // The bit position of the `nextInitialized` bit in packed ownership.
769     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
770 
771     // The bit mask of the `nextInitialized` bit in packed ownership.
772     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
773 
774     // The bit position of `extraData` in packed ownership.
775     uint256 private constant _BITPOS_EXTRA_DATA = 232;
776 
777     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
778     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
779 
780     // The mask of the lower 160 bits for addresses.
781     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
782 
783     // The maximum `quantity` that can be minted with {_mintERC2309}.
784     // This limit is to prevent overflows on the address data entries.
785     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
786     // is required to cause an overflow, which is unrealistic.
787     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
788 
789     // The `Transfer` event signature is given by:
790     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
791     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
792         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
793 
794     // =============================================================
795     //                            STORAGE
796     // =============================================================
797 
798     // The next token ID to be minted.
799     uint256 private _currentIndex;
800 
801     // The number of tokens burned.
802     uint256 private _burnCounter;
803 
804     // Token name
805     string private _name;
806 
807     // Token symbol
808     string private _symbol;
809 
810     // Mapping from token ID to ownership details
811     // An empty struct value does not necessarily mean the token is unowned.
812     // See {_packedOwnershipOf} implementation for details.
813     //
814     // Bits Layout:
815     // - [0..159]   `addr`
816     // - [160..223] `startTimestamp`
817     // - [224]      `burned`
818     // - [225]      `nextInitialized`
819     // - [232..255] `extraData`
820     mapping(uint256 => uint256) private _packedOwnerships;
821 
822     // Mapping owner address to address data.
823     //
824     // Bits Layout:
825     // - [0..63]    `balance`
826     // - [64..127]  `numberMinted`
827     // - [128..191] `numberBurned`
828     // - [192..255] `aux`
829     mapping(address => uint256) private _packedAddressData;
830 
831     // Mapping from token ID to approved address.
832     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
833 
834     // Mapping from owner to operator approvals
835     mapping(address => mapping(address => bool)) private _operatorApprovals;
836 
837     // =============================================================
838     //                          CONSTRUCTOR
839     // =============================================================
840 
841     constructor(string memory name_, string memory symbol_) {
842         _name = name_;
843         _symbol = symbol_;
844         _currentIndex = _startTokenId();
845     }
846 
847     // =============================================================
848     //                   TOKEN COUNTING OPERATIONS
849     // =============================================================
850 
851     /**
852      * @dev Returns the starting token ID.
853      * To change the starting token ID, please override this function.
854      */
855     function _startTokenId() internal view virtual returns (uint256) {
856         return 0;
857     }
858 
859     /**
860      * @dev Returns the next token ID to be minted.
861      */
862     function _nextTokenId() internal view virtual returns (uint256) {
863         return _currentIndex;
864     }
865 
866     /**
867      * @dev Returns the total number of tokens in existence.
868      * Burned tokens will reduce the count.
869      * To get the total number of tokens minted, please see {_totalMinted}.
870      */
871     function totalSupply() public view virtual override returns (uint256) {
872         // Counter underflow is impossible as _burnCounter cannot be incremented
873         // more than `_currentIndex - _startTokenId()` times.
874         unchecked {
875             return _currentIndex - _burnCounter - _startTokenId();
876         }
877     }
878 
879     /**
880      * @dev Returns the total amount of tokens minted in the contract.
881      */
882     function _totalMinted() internal view virtual returns (uint256) {
883         // Counter underflow is impossible as `_currentIndex` does not decrement,
884         // and it is initialized to `_startTokenId()`.
885         unchecked {
886             return _currentIndex - _startTokenId();
887         }
888     }
889 
890     /**
891      * @dev Returns the total number of tokens burned.
892      */
893     function _totalBurned() internal view virtual returns (uint256) {
894         return _burnCounter;
895     }
896 
897     // =============================================================
898     //                    ADDRESS DATA OPERATIONS
899     // =============================================================
900 
901     /**
902      * @dev Returns the number of tokens in `owner`'s account.
903      */
904     function balanceOf(address owner) public view virtual override returns (uint256) {
905         if (owner == address(0)) revert BalanceQueryForZeroAddress();
906         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
907     }
908 
909     /**
910      * Returns the number of tokens minted by `owner`.
911      */
912     function _numberMinted(address owner) internal view returns (uint256) {
913         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
914     }
915 
916     /**
917      * Returns the number of tokens burned by or on behalf of `owner`.
918      */
919     function _numberBurned(address owner) internal view returns (uint256) {
920         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
921     }
922 
923     /**
924      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
925      */
926     function _getAux(address owner) internal view returns (uint64) {
927         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
928     }
929 
930     /**
931      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
932      * If there are multiple variables, please pack them into a uint64.
933      */
934     function _setAux(address owner, uint64 aux) internal virtual {
935         uint256 packed = _packedAddressData[owner];
936         uint256 auxCasted;
937         // Cast `aux` with assembly to avoid redundant masking.
938         assembly {
939             auxCasted := aux
940         }
941         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
942         _packedAddressData[owner] = packed;
943     }
944 
945     // =============================================================
946     //                            IERC165
947     // =============================================================
948 
949     /**
950      * @dev Returns true if this contract implements the interface defined by
951      * `interfaceId`. See the corresponding
952      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
953      * to learn more about how these ids are created.
954      *
955      * This function call must use less than 30000 gas.
956      */
957     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
958         // The interface IDs are constants representing the first 4 bytes
959         // of the XOR of all function selectors in the interface.
960         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
961         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
962         return
963             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
964             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
965             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
966     }
967 
968     // =============================================================
969     //                        IERC721Metadata
970     // =============================================================
971 
972     /**
973      * @dev Returns the token collection name.
974      */
975     function name() public view virtual override returns (string memory) {
976         return _name;
977     }
978 
979     /**
980      * @dev Returns the token collection symbol.
981      */
982     function symbol() public view virtual override returns (string memory) {
983         return _symbol;
984     }
985 
986     /**
987      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
988      */
989     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
990         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
991 
992         string memory baseURI = _baseURI();
993         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
994     }
995 
996     /**
997      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
998      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
999      * by default, it can be overridden in child contracts.
1000      */
1001     function _baseURI() internal view virtual returns (string memory) {
1002         return '';
1003     }
1004 
1005     // =============================================================
1006     //                     OWNERSHIPS OPERATIONS
1007     // =============================================================
1008 
1009     /**
1010      * @dev Returns the owner of the `tokenId` token.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      */
1016     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1017         return address(uint160(_packedOwnershipOf(tokenId)));
1018     }
1019 
1020     /**
1021      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1022      * It gradually moves to O(1) as tokens get transferred around over time.
1023      */
1024     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1025         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1026     }
1027 
1028     /**
1029      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1030      */
1031     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1032         return _unpackedOwnership(_packedOwnerships[index]);
1033     }
1034 
1035     /**
1036      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1037      */
1038     function _initializeOwnershipAt(uint256 index) internal virtual {
1039         if (_packedOwnerships[index] == 0) {
1040             _packedOwnerships[index] = _packedOwnershipOf(index);
1041         }
1042     }
1043 
1044     /**
1045      * Returns the packed ownership data of `tokenId`.
1046      */
1047     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1048         uint256 curr = tokenId;
1049 
1050         unchecked {
1051             if (_startTokenId() <= curr)
1052                 if (curr < _currentIndex) {
1053                     uint256 packed = _packedOwnerships[curr];
1054                     // If not burned.
1055                     if (packed & _BITMASK_BURNED == 0) {
1056                         // Invariant:
1057                         // There will always be an initialized ownership slot
1058                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1059                         // before an unintialized ownership slot
1060                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1061                         // Hence, `curr` will not underflow.
1062                         //
1063                         // We can directly compare the packed value.
1064                         // If the address is zero, packed will be zero.
1065                         while (packed == 0) {
1066                             packed = _packedOwnerships[--curr];
1067                         }
1068                         return packed;
1069                     }
1070                 }
1071         }
1072         revert OwnerQueryForNonexistentToken();
1073     }
1074 
1075     /**
1076      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1077      */
1078     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1079         ownership.addr = address(uint160(packed));
1080         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1081         ownership.burned = packed & _BITMASK_BURNED != 0;
1082         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1083     }
1084 
1085     /**
1086      * @dev Packs ownership data into a single uint256.
1087      */
1088     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1089         assembly {
1090             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1091             owner := and(owner, _BITMASK_ADDRESS)
1092             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1093             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1094         }
1095     }
1096 
1097     /**
1098      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1099      */
1100     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1101         // For branchless setting of the `nextInitialized` flag.
1102         assembly {
1103             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1104             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1105         }
1106     }
1107 
1108     // =============================================================
1109     //                      APPROVAL OPERATIONS
1110     // =============================================================
1111 
1112     /**
1113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1114      * The approval is cleared when the token is transferred.
1115      *
1116      * Only a single account can be approved at a time, so approving the
1117      * zero address clears previous approvals.
1118      *
1119      * Requirements:
1120      *
1121      * - The caller must own the token or be an approved operator.
1122      * - `tokenId` must exist.
1123      *
1124      * Emits an {Approval} event.
1125      */
1126     function approve(address to, uint256 tokenId) public virtual override {
1127         address owner = ownerOf(tokenId);
1128 
1129         if (_msgSenderERC721A() != owner)
1130             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1131                 revert ApprovalCallerNotOwnerNorApproved();
1132             }
1133 
1134         _tokenApprovals[tokenId].value = to;
1135         emit Approval(owner, to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Returns the account approved for `tokenId` token.
1140      *
1141      * Requirements:
1142      *
1143      * - `tokenId` must exist.
1144      */
1145     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1146         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1147 
1148         return _tokenApprovals[tokenId].value;
1149     }
1150 
1151     /**
1152      * @dev Approve or remove `operator` as an operator for the caller.
1153      * Operators can call {transferFrom} or {safeTransferFrom}
1154      * for any token owned by the caller.
1155      *
1156      * Requirements:
1157      *
1158      * - The `operator` cannot be the caller.
1159      *
1160      * Emits an {ApprovalForAll} event.
1161      */
1162     function setApprovalForAll(address operator, bool approved) public virtual override {
1163         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1164 
1165         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1166         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1167     }
1168 
1169     /**
1170      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1171      *
1172      * See {setApprovalForAll}.
1173      */
1174     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1175         return _operatorApprovals[owner][operator];
1176     }
1177 
1178     /**
1179      * @dev Returns whether `tokenId` exists.
1180      *
1181      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1182      *
1183      * Tokens start existing when they are minted. See {_mint}.
1184      */
1185     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1186         return
1187             _startTokenId() <= tokenId &&
1188             tokenId < _currentIndex && // If within bounds,
1189             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1190     }
1191 
1192     /**
1193      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1194      */
1195     function _isSenderApprovedOrOwner(
1196         address approvedAddress,
1197         address owner,
1198         address msgSender
1199     ) private pure returns (bool result) {
1200         assembly {
1201             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1202             owner := and(owner, _BITMASK_ADDRESS)
1203             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1204             msgSender := and(msgSender, _BITMASK_ADDRESS)
1205             // `msgSender == owner || msgSender == approvedAddress`.
1206             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1207         }
1208     }
1209 
1210     /**
1211      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1212      */
1213     function _getApprovedSlotAndAddress(uint256 tokenId)
1214         private
1215         view
1216         returns (uint256 approvedAddressSlot, address approvedAddress)
1217     {
1218         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1219         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1220         assembly {
1221             approvedAddressSlot := tokenApproval.slot
1222             approvedAddress := sload(approvedAddressSlot)
1223         }
1224     }
1225 
1226     // =============================================================
1227     //                      TRANSFER OPERATIONS
1228     // =============================================================
1229 
1230     /**
1231      * @dev Transfers `tokenId` from `from` to `to`.
1232      *
1233      * Requirements:
1234      *
1235      * - `from` cannot be the zero address.
1236      * - `to` cannot be the zero address.
1237      * - `tokenId` token must be owned by `from`.
1238      * - If the caller is not `from`, it must be approved to move this token
1239      * by either {approve} or {setApprovalForAll}.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function transferFrom(
1244         address from,
1245         address to,
1246         uint256 tokenId
1247     ) public virtual override {
1248         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1249 
1250         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1251 
1252         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1253 
1254         // The nested ifs save around 20+ gas over a compound boolean condition.
1255         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1256             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1257 
1258         if (to == address(0)) revert TransferToZeroAddress();
1259 
1260         _beforeTokenTransfers(from, to, tokenId, 1);
1261 
1262         // Clear approvals from the previous owner.
1263         assembly {
1264             if approvedAddress {
1265                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1266                 sstore(approvedAddressSlot, 0)
1267             }
1268         }
1269 
1270         // Underflow of the sender's balance is impossible because we check for
1271         // ownership above and the recipient's balance can't realistically overflow.
1272         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1273         unchecked {
1274             // We can directly increment and decrement the balances.
1275             --_packedAddressData[from]; // Updates: `balance -= 1`.
1276             ++_packedAddressData[to]; // Updates: `balance += 1`.
1277 
1278             // Updates:
1279             // - `address` to the next owner.
1280             // - `startTimestamp` to the timestamp of transfering.
1281             // - `burned` to `false`.
1282             // - `nextInitialized` to `true`.
1283             _packedOwnerships[tokenId] = _packOwnershipData(
1284                 to,
1285                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1286             );
1287 
1288             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1289             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1290                 uint256 nextTokenId = tokenId + 1;
1291                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1292                 if (_packedOwnerships[nextTokenId] == 0) {
1293                     // If the next slot is within bounds.
1294                     if (nextTokenId != _currentIndex) {
1295                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1296                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1297                     }
1298                 }
1299             }
1300         }
1301 
1302         emit Transfer(from, to, tokenId);
1303         _afterTokenTransfers(from, to, tokenId, 1);
1304     }
1305 
1306     /**
1307      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1308      */
1309     function safeTransferFrom(
1310         address from,
1311         address to,
1312         uint256 tokenId
1313     ) public virtual override {
1314         safeTransferFrom(from, to, tokenId, '');
1315     }
1316 
1317     /**
1318      * @dev Safely transfers `tokenId` token from `from` to `to`.
1319      *
1320      * Requirements:
1321      *
1322      * - `from` cannot be the zero address.
1323      * - `to` cannot be the zero address.
1324      * - `tokenId` token must exist and be owned by `from`.
1325      * - If the caller is not `from`, it must be approved to move this token
1326      * by either {approve} or {setApprovalForAll}.
1327      * - If `to` refers to a smart contract, it must implement
1328      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function safeTransferFrom(
1333         address from,
1334         address to,
1335         uint256 tokenId,
1336         bytes memory _data
1337     ) public virtual override {
1338         transferFrom(from, to, tokenId);
1339         if (to.code.length != 0)
1340             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1341                 revert TransferToNonERC721ReceiverImplementer();
1342             }
1343     }
1344 
1345     /**
1346      * @dev Hook that is called before a set of serially-ordered token IDs
1347      * are about to be transferred. This includes minting.
1348      * And also called before burning one token.
1349      *
1350      * `startTokenId` - the first token ID to be transferred.
1351      * `quantity` - the amount to be transferred.
1352      *
1353      * Calling conditions:
1354      *
1355      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1356      * transferred to `to`.
1357      * - When `from` is zero, `tokenId` will be minted for `to`.
1358      * - When `to` is zero, `tokenId` will be burned by `from`.
1359      * - `from` and `to` are never both zero.
1360      */
1361     function _beforeTokenTransfers(
1362         address from,
1363         address to,
1364         uint256 startTokenId,
1365         uint256 quantity
1366     ) internal virtual {}
1367 
1368     /**
1369      * @dev Hook that is called after a set of serially-ordered token IDs
1370      * have been transferred. This includes minting.
1371      * And also called after one token has been burned.
1372      *
1373      * `startTokenId` - the first token ID to be transferred.
1374      * `quantity` - the amount to be transferred.
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` has been minted for `to`.
1381      * - When `to` is zero, `tokenId` has been burned by `from`.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _afterTokenTransfers(
1385         address from,
1386         address to,
1387         uint256 startTokenId,
1388         uint256 quantity
1389     ) internal virtual {}
1390 
1391     /**
1392      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1393      *
1394      * `from` - Previous owner of the given token ID.
1395      * `to` - Target address that will receive the token.
1396      * `tokenId` - Token ID to be transferred.
1397      * `_data` - Optional data to send along with the call.
1398      *
1399      * Returns whether the call correctly returned the expected magic value.
1400      */
1401     function _checkContractOnERC721Received(
1402         address from,
1403         address to,
1404         uint256 tokenId,
1405         bytes memory _data
1406     ) private returns (bool) {
1407         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1408             bytes4 retval
1409         ) {
1410             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1411         } catch (bytes memory reason) {
1412             if (reason.length == 0) {
1413                 revert TransferToNonERC721ReceiverImplementer();
1414             } else {
1415                 assembly {
1416                     revert(add(32, reason), mload(reason))
1417                 }
1418             }
1419         }
1420     }
1421 
1422     // =============================================================
1423     //                        MINT OPERATIONS
1424     // =============================================================
1425 
1426     /**
1427      * @dev Mints `quantity` tokens and transfers them to `to`.
1428      *
1429      * Requirements:
1430      *
1431      * - `to` cannot be the zero address.
1432      * - `quantity` must be greater than 0.
1433      *
1434      * Emits a {Transfer} event for each mint.
1435      */
1436     function _mint(address to, uint256 quantity) internal virtual {
1437         uint256 startTokenId = _currentIndex;
1438         if (quantity == 0) revert MintZeroQuantity();
1439 
1440         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1441 
1442         // Overflows are incredibly unrealistic.
1443         // `balance` and `numberMinted` have a maximum limit of 2**64.
1444         // `tokenId` has a maximum limit of 2**256.
1445         unchecked {
1446             // Updates:
1447             // - `balance += quantity`.
1448             // - `numberMinted += quantity`.
1449             //
1450             // We can directly add to the `balance` and `numberMinted`.
1451             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1452 
1453             // Updates:
1454             // - `address` to the owner.
1455             // - `startTimestamp` to the timestamp of minting.
1456             // - `burned` to `false`.
1457             // - `nextInitialized` to `quantity == 1`.
1458             _packedOwnerships[startTokenId] = _packOwnershipData(
1459                 to,
1460                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1461             );
1462 
1463             uint256 toMasked;
1464             uint256 end = startTokenId + quantity;
1465 
1466             // Use assembly to loop and emit the `Transfer` event for gas savings.
1467             assembly {
1468                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1469                 toMasked := and(to, _BITMASK_ADDRESS)
1470                 // Emit the `Transfer` event.
1471                 log4(
1472                     0, // Start of data (0, since no data).
1473                     0, // End of data (0, since no data).
1474                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1475                     0, // `address(0)`.
1476                     toMasked, // `to`.
1477                     startTokenId // `tokenId`.
1478                 )
1479 
1480                 for {
1481                     let tokenId := add(startTokenId, 1)
1482                 } iszero(eq(tokenId, end)) {
1483                     tokenId := add(tokenId, 1)
1484                 } {
1485                     // Emit the `Transfer` event. Similar to above.
1486                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1487                 }
1488             }
1489             if (toMasked == 0) revert MintToZeroAddress();
1490 
1491             _currentIndex = end;
1492         }
1493         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1494     }
1495 
1496     /**
1497      * @dev Mints `quantity` tokens and transfers them to `to`.
1498      *
1499      * This function is intended for efficient minting only during contract creation.
1500      *
1501      * It emits only one {ConsecutiveTransfer} as defined in
1502      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1503      * instead of a sequence of {Transfer} event(s).
1504      *
1505      * Calling this function outside of contract creation WILL make your contract
1506      * non-compliant with the ERC721 standard.
1507      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1508      * {ConsecutiveTransfer} event is only permissible during contract creation.
1509      *
1510      * Requirements:
1511      *
1512      * - `to` cannot be the zero address.
1513      * - `quantity` must be greater than 0.
1514      *
1515      * Emits a {ConsecutiveTransfer} event.
1516      */
1517     function _mintERC2309(address to, uint256 quantity) internal virtual {
1518         uint256 startTokenId = _currentIndex;
1519         if (to == address(0)) revert MintToZeroAddress();
1520         if (quantity == 0) revert MintZeroQuantity();
1521         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1522 
1523         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1524 
1525         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1526         unchecked {
1527             // Updates:
1528             // - `balance += quantity`.
1529             // - `numberMinted += quantity`.
1530             //
1531             // We can directly add to the `balance` and `numberMinted`.
1532             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1533 
1534             // Updates:
1535             // - `address` to the owner.
1536             // - `startTimestamp` to the timestamp of minting.
1537             // - `burned` to `false`.
1538             // - `nextInitialized` to `quantity == 1`.
1539             _packedOwnerships[startTokenId] = _packOwnershipData(
1540                 to,
1541                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1542             );
1543 
1544             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1545 
1546             _currentIndex = startTokenId + quantity;
1547         }
1548         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1549     }
1550 
1551     /**
1552      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1553      *
1554      * Requirements:
1555      *
1556      * - If `to` refers to a smart contract, it must implement
1557      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1558      * - `quantity` must be greater than 0.
1559      *
1560      * See {_mint}.
1561      *
1562      * Emits a {Transfer} event for each mint.
1563      */
1564     function _safeMint(
1565         address to,
1566         uint256 quantity,
1567         bytes memory _data
1568     ) internal virtual {
1569         _mint(to, quantity);
1570 
1571         unchecked {
1572             if (to.code.length != 0) {
1573                 uint256 end = _currentIndex;
1574                 uint256 index = end - quantity;
1575                 do {
1576                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1577                         revert TransferToNonERC721ReceiverImplementer();
1578                     }
1579                 } while (index < end);
1580                 // Reentrancy protection.
1581                 if (_currentIndex != end) revert();
1582             }
1583         }
1584     }
1585 
1586     /**
1587      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1588      */
1589     function _safeMint(address to, uint256 quantity) internal virtual {
1590         _safeMint(to, quantity, '');
1591     }
1592 
1593     // =============================================================
1594     //                        BURN OPERATIONS
1595     // =============================================================
1596 
1597     /**
1598      * @dev Equivalent to `_burn(tokenId, false)`.
1599      */
1600     function _burn(uint256 tokenId) internal virtual {
1601         _burn(tokenId, false);
1602     }
1603 
1604     /**
1605      * @dev Destroys `tokenId`.
1606      * The approval is cleared when the token is burned.
1607      *
1608      * Requirements:
1609      *
1610      * - `tokenId` must exist.
1611      *
1612      * Emits a {Transfer} event.
1613      */
1614     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1615         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1616 
1617         address from = address(uint160(prevOwnershipPacked));
1618 
1619         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1620 
1621         if (approvalCheck) {
1622             // The nested ifs save around 20+ gas over a compound boolean condition.
1623             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1624                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1625         }
1626 
1627         _beforeTokenTransfers(from, address(0), tokenId, 1);
1628 
1629         // Clear approvals from the previous owner.
1630         assembly {
1631             if approvedAddress {
1632                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1633                 sstore(approvedAddressSlot, 0)
1634             }
1635         }
1636 
1637         // Underflow of the sender's balance is impossible because we check for
1638         // ownership above and the recipient's balance can't realistically overflow.
1639         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1640         unchecked {
1641             // Updates:
1642             // - `balance -= 1`.
1643             // - `numberBurned += 1`.
1644             //
1645             // We can directly decrement the balance, and increment the number burned.
1646             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1647             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1648 
1649             // Updates:
1650             // - `address` to the last owner.
1651             // - `startTimestamp` to the timestamp of burning.
1652             // - `burned` to `true`.
1653             // - `nextInitialized` to `true`.
1654             _packedOwnerships[tokenId] = _packOwnershipData(
1655                 from,
1656                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1657             );
1658 
1659             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1660             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1661                 uint256 nextTokenId = tokenId + 1;
1662                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1663                 if (_packedOwnerships[nextTokenId] == 0) {
1664                     // If the next slot is within bounds.
1665                     if (nextTokenId != _currentIndex) {
1666                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1667                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1668                     }
1669                 }
1670             }
1671         }
1672 
1673         emit Transfer(from, address(0), tokenId);
1674         _afterTokenTransfers(from, address(0), tokenId, 1);
1675 
1676         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1677         unchecked {
1678             _burnCounter++;
1679         }
1680     }
1681 
1682     // =============================================================
1683     //                     EXTRA DATA OPERATIONS
1684     // =============================================================
1685 
1686     /**
1687      * @dev Directly sets the extra data for the ownership data `index`.
1688      */
1689     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1690         uint256 packed = _packedOwnerships[index];
1691         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1692         uint256 extraDataCasted;
1693         // Cast `extraData` with assembly to avoid redundant masking.
1694         assembly {
1695             extraDataCasted := extraData
1696         }
1697         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1698         _packedOwnerships[index] = packed;
1699     }
1700 
1701     /**
1702      * @dev Called during each token transfer to set the 24bit `extraData` field.
1703      * Intended to be overridden by the cosumer contract.
1704      *
1705      * `previousExtraData` - the value of `extraData` before transfer.
1706      *
1707      * Calling conditions:
1708      *
1709      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1710      * transferred to `to`.
1711      * - When `from` is zero, `tokenId` will be minted for `to`.
1712      * - When `to` is zero, `tokenId` will be burned by `from`.
1713      * - `from` and `to` are never both zero.
1714      */
1715     function _extraData(
1716         address from,
1717         address to,
1718         uint24 previousExtraData
1719     ) internal view virtual returns (uint24) {}
1720 
1721     /**
1722      * @dev Returns the next extra data for the packed ownership data.
1723      * The returned result is shifted into position.
1724      */
1725     function _nextExtraData(
1726         address from,
1727         address to,
1728         uint256 prevOwnershipPacked
1729     ) private view returns (uint256) {
1730         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1731         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1732     }
1733 
1734     // =============================================================
1735     //                       OTHER OPERATIONS
1736     // =============================================================
1737 
1738     /**
1739      * @dev Returns the message sender (defaults to `msg.sender`).
1740      *
1741      * If you are writing GSN compatible contracts, you need to override this function.
1742      */
1743     function _msgSenderERC721A() internal view virtual returns (address) {
1744         return msg.sender;
1745     }
1746 
1747     /**
1748      * @dev Converts a uint256 to its ASCII string decimal representation.
1749      */
1750     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1751         assembly {
1752             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1753             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1754             // We will need 1 32-byte word to store the length,
1755             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1756             str := add(mload(0x40), 0x80)
1757             // Update the free memory pointer to allocate.
1758             mstore(0x40, str)
1759 
1760             // Cache the end of the memory to calculate the length later.
1761             let end := str
1762 
1763             // We write the string from rightmost digit to leftmost digit.
1764             // The following is essentially a do-while loop that also handles the zero case.
1765             // prettier-ignore
1766             for { let temp := value } 1 {} {
1767                 str := sub(str, 1)
1768                 // Write the character to the pointer.
1769                 // The ASCII index of the '0' character is 48.
1770                 mstore8(str, add(48, mod(temp, 10)))
1771                 // Keep dividing `temp` until zero.
1772                 temp := div(temp, 10)
1773                 // prettier-ignore
1774                 if iszero(temp) { break }
1775             }
1776 
1777             let length := sub(end, str)
1778             // Move the pointer 32 bytes leftwards to make room for the length.
1779             str := sub(str, 0x20)
1780             // Store the length.
1781             mstore(str, length)
1782         }
1783     }
1784 }
1785 
1786 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1787 
1788 
1789 // ERC721A Contracts v4.2.2
1790 // Creator: Chiru Labs
1791 
1792 pragma solidity ^0.8.4;
1793 
1794 
1795 /**
1796  * @dev Interface of ERC721AQueryable.
1797  */
1798 interface IERC721AQueryable is IERC721A {
1799     /**
1800      * Invalid query range (`start` >= `stop`).
1801      */
1802     error InvalidQueryRange();
1803 
1804     /**
1805      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1806      *
1807      * If the `tokenId` is out of bounds:
1808      *
1809      * - `addr = address(0)`
1810      * - `startTimestamp = 0`
1811      * - `burned = false`
1812      * - `extraData = 0`
1813      *
1814      * If the `tokenId` is burned:
1815      *
1816      * - `addr = <Address of owner before token was burned>`
1817      * - `startTimestamp = <Timestamp when token was burned>`
1818      * - `burned = true`
1819      * - `extraData = <Extra data when token was burned>`
1820      *
1821      * Otherwise:
1822      *
1823      * - `addr = <Address of owner>`
1824      * - `startTimestamp = <Timestamp of start of ownership>`
1825      * - `burned = false`
1826      * - `extraData = <Extra data at start of ownership>`
1827      */
1828     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1829 
1830     /**
1831      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1832      * See {ERC721AQueryable-explicitOwnershipOf}
1833      */
1834     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1835 
1836     /**
1837      * @dev Returns an array of token IDs owned by `owner`,
1838      * in the range [`start`, `stop`)
1839      * (i.e. `start <= tokenId < stop`).
1840      *
1841      * This function allows for tokens to be queried if the collection
1842      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1843      *
1844      * Requirements:
1845      *
1846      * - `start < stop`
1847      */
1848     function tokensOfOwnerIn(
1849         address owner,
1850         uint256 start,
1851         uint256 stop
1852     ) external view returns (uint256[] memory);
1853 
1854     /**
1855      * @dev Returns an array of token IDs owned by `owner`.
1856      *
1857      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1858      * It is meant to be called off-chain.
1859      *
1860      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1861      * multiple smaller scans if the collection is large enough to cause
1862      * an out-of-gas error (10K collections should be fine).
1863      */
1864     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1865 }
1866 
1867 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1868 
1869 
1870 // ERC721A Contracts v4.2.2
1871 // Creator: Chiru Labs
1872 
1873 pragma solidity ^0.8.4;
1874 
1875 
1876 
1877 /**
1878  * @title ERC721AQueryable.
1879  *
1880  * @dev ERC721A subclass with convenience query functions.
1881  */
1882 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1883     /**
1884      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1885      *
1886      * If the `tokenId` is out of bounds:
1887      *
1888      * - `addr = address(0)`
1889      * - `startTimestamp = 0`
1890      * - `burned = false`
1891      * - `extraData = 0`
1892      *
1893      * If the `tokenId` is burned:
1894      *
1895      * - `addr = <Address of owner before token was burned>`
1896      * - `startTimestamp = <Timestamp when token was burned>`
1897      * - `burned = true`
1898      * - `extraData = <Extra data when token was burned>`
1899      *
1900      * Otherwise:
1901      *
1902      * - `addr = <Address of owner>`
1903      * - `startTimestamp = <Timestamp of start of ownership>`
1904      * - `burned = false`
1905      * - `extraData = <Extra data at start of ownership>`
1906      */
1907     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1908         TokenOwnership memory ownership;
1909         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1910             return ownership;
1911         }
1912         ownership = _ownershipAt(tokenId);
1913         if (ownership.burned) {
1914             return ownership;
1915         }
1916         return _ownershipOf(tokenId);
1917     }
1918 
1919     /**
1920      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1921      * See {ERC721AQueryable-explicitOwnershipOf}
1922      */
1923     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1924         external
1925         view
1926         virtual
1927         override
1928         returns (TokenOwnership[] memory)
1929     {
1930         unchecked {
1931             uint256 tokenIdsLength = tokenIds.length;
1932             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1933             for (uint256 i; i != tokenIdsLength; ++i) {
1934                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1935             }
1936             return ownerships;
1937         }
1938     }
1939 
1940     /**
1941      * @dev Returns an array of token IDs owned by `owner`,
1942      * in the range [`start`, `stop`)
1943      * (i.e. `start <= tokenId < stop`).
1944      *
1945      * This function allows for tokens to be queried if the collection
1946      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1947      *
1948      * Requirements:
1949      *
1950      * - `start < stop`
1951      */
1952     function tokensOfOwnerIn(
1953         address owner,
1954         uint256 start,
1955         uint256 stop
1956     ) external view virtual override returns (uint256[] memory) {
1957         unchecked {
1958             if (start >= stop) revert InvalidQueryRange();
1959             uint256 tokenIdsIdx;
1960             uint256 stopLimit = _nextTokenId();
1961             // Set `start = max(start, _startTokenId())`.
1962             if (start < _startTokenId()) {
1963                 start = _startTokenId();
1964             }
1965             // Set `stop = min(stop, stopLimit)`.
1966             if (stop > stopLimit) {
1967                 stop = stopLimit;
1968             }
1969             uint256 tokenIdsMaxLength = balanceOf(owner);
1970             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1971             // to cater for cases where `balanceOf(owner)` is too big.
1972             if (start < stop) {
1973                 uint256 rangeLength = stop - start;
1974                 if (rangeLength < tokenIdsMaxLength) {
1975                     tokenIdsMaxLength = rangeLength;
1976                 }
1977             } else {
1978                 tokenIdsMaxLength = 0;
1979             }
1980             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1981             if (tokenIdsMaxLength == 0) {
1982                 return tokenIds;
1983             }
1984             // We need to call `explicitOwnershipOf(start)`,
1985             // because the slot at `start` may not be initialized.
1986             TokenOwnership memory ownership = explicitOwnershipOf(start);
1987             address currOwnershipAddr;
1988             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1989             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1990             if (!ownership.burned) {
1991                 currOwnershipAddr = ownership.addr;
1992             }
1993             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1994                 ownership = _ownershipAt(i);
1995                 if (ownership.burned) {
1996                     continue;
1997                 }
1998                 if (ownership.addr != address(0)) {
1999                     currOwnershipAddr = ownership.addr;
2000                 }
2001                 if (currOwnershipAddr == owner) {
2002                     tokenIds[tokenIdsIdx++] = i;
2003                 }
2004             }
2005             // Downsize the array to fit.
2006             assembly {
2007                 mstore(tokenIds, tokenIdsIdx)
2008             }
2009             return tokenIds;
2010         }
2011     }
2012 
2013     /**
2014      * @dev Returns an array of token IDs owned by `owner`.
2015      *
2016      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2017      * It is meant to be called off-chain.
2018      *
2019      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2020      * multiple smaller scans if the collection is large enough to cause
2021      * an out-of-gas error (10K collections should be fine).
2022      */
2023     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2024         unchecked {
2025             uint256 tokenIdsIdx;
2026             address currOwnershipAddr;
2027             uint256 tokenIdsLength = balanceOf(owner);
2028             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2029             TokenOwnership memory ownership;
2030             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2031                 ownership = _ownershipAt(i);
2032                 if (ownership.burned) {
2033                     continue;
2034                 }
2035                 if (ownership.addr != address(0)) {
2036                     currOwnershipAddr = ownership.addr;
2037                 }
2038                 if (currOwnershipAddr == owner) {
2039                     tokenIds[tokenIdsIdx++] = i;
2040                 }
2041             }
2042             return tokenIds;
2043         }
2044     }
2045 }
2046 
2047 // File: Catpocalypse.sol
2048 
2049 pragma solidity ^0.8.4;
2050 
2051 
2052 
2053 
2054 
2055 contract Catpocalypse is ERC721AQueryable, Ownable {
2056     using ECDSA for bytes32;
2057     using Strings for uint256;
2058 
2059     enum SaleState {
2060         NOT_LIVE,
2061         WHITELIST_SALE,
2062         PUBLIC_SALE
2063     }
2064 
2065     struct Slot {
2066         uint8 maxPerWallet;
2067         uint16 maxSupply;
2068         uint112 price;
2069     }
2070 
2071     SaleState public saleState;
2072     Slot public tokenInfo;
2073     
2074     address public signer = 0x96b79c2fb368b741bF32d118a0d858Ff46923639;
2075 
2076     string private _baseTokenURI;
2077 
2078     mapping(bytes => bool) public claimedSig;
2079 
2080     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
2081     address private _royaltyAddress;
2082     uint256 private _royaltyPercentage;
2083 
2084     constructor(uint8 maxPerWallet, uint16 maxSupply, uint112 price, address royaltyAddress, uint256 royaltyPercentage, string memory baseURI) ERC721A("Catpocalypse", "CATS") {
2085         tokenInfo = Slot(maxPerWallet, maxSupply, price);
2086         _royaltyAddress = royaltyAddress;
2087         _royaltyPercentage = royaltyPercentage;
2088         _baseTokenURI = baseURI;
2089     }
2090 
2091     function mint(uint256 quantity) external payable {
2092         require(saleState == SaleState.PUBLIC_SALE, "NOT_LIVE");
2093         Slot memory token = tokenInfo;
2094         require(totalSupply() + quantity <= token.maxSupply, "MAX_SUPPLY");
2095         require(quantity <= token.maxPerWallet, "MAX_PER_WALLET");
2096         uint256 cost = token.price * quantity;
2097         require(msg.value >= cost, "INSUFFICENT_ETH");
2098         _mint(msg.sender, quantity);
2099     }
2100 
2101     function whitelistMint(bytes calldata signature) external {
2102         require(saleState == SaleState.WHITELIST_SALE, "NOT_LIVE");
2103         Slot memory token = tokenInfo;
2104         require(totalSupply() + 1 <= token.maxSupply, "MAX_SUPPLY");
2105         require(!claimedSig[signature], "ALREADY_CLAIMED");
2106         require(keccak256(
2107             abi.encodePacked("\x19Ethereum Signed Message:\n32",
2108             keccak256(abi.encodePacked(msg.sender))
2109         )).recover(signature) == signer);
2110         claimedSig[signature] = true;
2111         _mint(msg.sender, 1);
2112     }
2113 
2114     function withdraw() external onlyOwner {
2115         (bool sent, ) = payable(msg.sender).call{value: address(this).balance }("");
2116         require(sent, "FAILED");
2117     }
2118 
2119 
2120     function editPrice(uint112 newPrice) external onlyOwner {
2121         tokenInfo.price = newPrice;
2122     }
2123 
2124     function editSupply(uint16 newSupply) external onlyOwner {
2125         tokenInfo.maxSupply = newSupply;
2126     }
2127 
2128     function editState(SaleState newState) external onlyOwner {
2129         saleState = newState;
2130     }
2131 
2132     function editURI(string memory newURI) external onlyOwner {
2133         _baseTokenURI = newURI;
2134     }
2135 
2136     function _baseURI() internal view virtual override returns (string memory) {
2137       return _baseTokenURI;
2138     }
2139 
2140     function tokenURI(uint256 tokenId) public view override(ERC721A, IERC721A) returns (string memory) {
2141         require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
2142         string memory currentBaseURI = _baseURI();
2143         return string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"));
2144     }
2145 
2146     function royaltyInfo(uint256, uint256 value) external view returns (address, uint256) {
2147         return (_royaltyAddress, value * _royaltyPercentage / 10000);
2148     }
2149     
2150     function _startTokenId() internal view virtual override returns (uint256) {
2151         return 1;
2152     }
2153 
2154 }