1 // Cranky Crocz
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16     uint8 private constant _ADDRESS_LENGTH = 20;
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 
74     /**
75      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
76      */
77     function toHexString(address addr) internal pure returns (string memory) {
78         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
83 
84 
85 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 
90 /**
91  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
92  *
93  * These functions can be used to verify that a message was signed by the holder
94  * of the private keys of a given address.
95  */
96 library ECDSA {
97     enum RecoverError {
98         NoError,
99         InvalidSignature,
100         InvalidSignatureLength,
101         InvalidSignatureS,
102         InvalidSignatureV
103     }
104 
105     function _throwError(RecoverError error) private pure {
106         if (error == RecoverError.NoError) {
107             return; // no error: do nothing
108         } else if (error == RecoverError.InvalidSignature) {
109             revert("ECDSA: invalid signature");
110         } else if (error == RecoverError.InvalidSignatureLength) {
111             revert("ECDSA: invalid signature length");
112         } else if (error == RecoverError.InvalidSignatureS) {
113             revert("ECDSA: invalid signature 's' value");
114         } else if (error == RecoverError.InvalidSignatureV) {
115             revert("ECDSA: invalid signature 'v' value");
116         }
117     }
118 
119     /**
120      * @dev Returns the address that signed a hashed message (`hash`) with
121      * `signature` or error string. This address can then be used for verification purposes.
122      *
123      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
124      * this function rejects them by requiring the `s` value to be in the lower
125      * half order, and the `v` value to be either 27 or 28.
126      *
127      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
128      * verification to be secure: it is possible to craft signatures that
129      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
130      * this is by receiving a hash of the original message (which may otherwise
131      * be too long), and then calling {toEthSignedMessageHash} on it.
132      *
133      * Documentation for signature generation:
134      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
135      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
136      *
137      * _Available since v4.3._
138      */
139     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
140         // Check the signature length
141         // - case 65: r,s,v signature (standard)
142         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
143         if (signature.length == 65) {
144             bytes32 r;
145             bytes32 s;
146             uint8 v;
147             // ecrecover takes the signature parameters, and the only way to get them
148             // currently is to use assembly.
149             /// @solidity memory-safe-assembly
150             assembly {
151                 r := mload(add(signature, 0x20))
152                 s := mload(add(signature, 0x40))
153                 v := byte(0, mload(add(signature, 0x60)))
154             }
155             return tryRecover(hash, v, r, s);
156         } else if (signature.length == 64) {
157             bytes32 r;
158             bytes32 vs;
159             // ecrecover takes the signature parameters, and the only way to get them
160             // currently is to use assembly.
161             /// @solidity memory-safe-assembly
162             assembly {
163                 r := mload(add(signature, 0x20))
164                 vs := mload(add(signature, 0x40))
165             }
166             return tryRecover(hash, r, vs);
167         } else {
168             return (address(0), RecoverError.InvalidSignatureLength);
169         }
170     }
171 
172     /**
173      * @dev Returns the address that signed a hashed message (`hash`) with
174      * `signature`. This address can then be used for verification purposes.
175      *
176      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
177      * this function rejects them by requiring the `s` value to be in the lower
178      * half order, and the `v` value to be either 27 or 28.
179      *
180      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
181      * verification to be secure: it is possible to craft signatures that
182      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
183      * this is by receiving a hash of the original message (which may otherwise
184      * be too long), and then calling {toEthSignedMessageHash} on it.
185      */
186     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
187         (address recovered, RecoverError error) = tryRecover(hash, signature);
188         _throwError(error);
189         return recovered;
190     }
191 
192     /**
193      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
194      *
195      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
196      *
197      * _Available since v4.3._
198      */
199     function tryRecover(
200         bytes32 hash,
201         bytes32 r,
202         bytes32 vs
203     ) internal pure returns (address, RecoverError) {
204         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
205         uint8 v = uint8((uint256(vs) >> 255) + 27);
206         return tryRecover(hash, v, r, s);
207     }
208 
209     /**
210      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
211      *
212      * _Available since v4.2._
213      */
214     function recover(
215         bytes32 hash,
216         bytes32 r,
217         bytes32 vs
218     ) internal pure returns (address) {
219         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
220         _throwError(error);
221         return recovered;
222     }
223 
224     /**
225      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
226      * `r` and `s` signature fields separately.
227      *
228      * _Available since v4.3._
229      */
230     function tryRecover(
231         bytes32 hash,
232         uint8 v,
233         bytes32 r,
234         bytes32 s
235     ) internal pure returns (address, RecoverError) {
236         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
237         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
238         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
239         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
240         //
241         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
242         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
243         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
244         // these malleable signatures as well.
245         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
246             return (address(0), RecoverError.InvalidSignatureS);
247         }
248         if (v != 27 && v != 28) {
249             return (address(0), RecoverError.InvalidSignatureV);
250         }
251 
252         // If the signature is valid (and not malleable), return the signer address
253         address signer = ecrecover(hash, v, r, s);
254         if (signer == address(0)) {
255             return (address(0), RecoverError.InvalidSignature);
256         }
257 
258         return (signer, RecoverError.NoError);
259     }
260 
261     /**
262      * @dev Overload of {ECDSA-recover} that receives the `v`,
263      * `r` and `s` signature fields separately.
264      */
265     function recover(
266         bytes32 hash,
267         uint8 v,
268         bytes32 r,
269         bytes32 s
270     ) internal pure returns (address) {
271         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
272         _throwError(error);
273         return recovered;
274     }
275 
276     /**
277      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
278      * produces hash corresponding to the one signed with the
279      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
280      * JSON-RPC method as part of EIP-191.
281      *
282      * See {recover}.
283      */
284     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
285         // 32 is the length in bytes of hash,
286         // enforced by the type signature above
287         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
288     }
289 
290     /**
291      * @dev Returns an Ethereum Signed Message, created from `s`. This
292      * produces hash corresponding to the one signed with the
293      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
294      * JSON-RPC method as part of EIP-191.
295      *
296      * See {recover}.
297      */
298     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
299         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
300     }
301 
302     /**
303      * @dev Returns an Ethereum Signed Typed Data, created from a
304      * `domainSeparator` and a `structHash`. This produces hash corresponding
305      * to the one signed with the
306      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
307      * JSON-RPC method as part of EIP-712.
308      *
309      * See {recover}.
310      */
311     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
312         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
313     }
314 }
315 
316 // File: @openzeppelin/contracts/utils/Context.sol
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Provides information about the current execution context, including the
325  * sender of the transaction and its data. While these are generally available
326  * via msg.sender and msg.data, they should not be accessed in such a direct
327  * manner, since when dealing with meta-transactions the account sending and
328  * paying for execution may not be the actual sender (as far as an application
329  * is concerned).
330  *
331  * This contract is only required for intermediate, library-like contracts.
332  */
333 abstract contract Context {
334     function _msgSender() internal view virtual returns (address) {
335         return msg.sender;
336     }
337 
338     function _msgData() internal view virtual returns (bytes calldata) {
339         return msg.data;
340     }
341 }
342 
343 // File: @openzeppelin/contracts/access/Ownable.sol
344 
345 
346 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 
351 /**
352  * @dev Contract module which provides a basic access control mechanism, where
353  * there is an account (an owner) that can be granted exclusive access to
354  * specific functions.
355  *
356  * By default, the owner account will be the one that deploys the contract. This
357  * can later be changed with {transferOwnership}.
358  *
359  * This module is used through inheritance. It will make available the modifier
360  * `onlyOwner`, which can be applied to your functions to restrict their use to
361  * the owner.
362  */
363 abstract contract Ownable is Context {
364     address private _owner;
365 
366     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
367 
368     /**
369      * @dev Initializes the contract setting the deployer as the initial owner.
370      */
371     constructor() {
372         _transferOwnership(_msgSender());
373     }
374 
375     /**
376      * @dev Throws if called by any account other than the owner.
377      */
378     modifier onlyOwner() {
379         _checkOwner();
380         _;
381     }
382 
383     /**
384      * @dev Returns the address of the current owner.
385      */
386     function owner() public view virtual returns (address) {
387         return _owner;
388     }
389 
390     /**
391      * @dev Throws if the sender is not the owner.
392      */
393     function _checkOwner() internal view virtual {
394         require(owner() == _msgSender(), "Ownable: caller is not the owner");
395     }
396 
397     /**
398      * @dev Leaves the contract without owner. It will not be possible to call
399      * `onlyOwner` functions anymore. Can only be called by the current owner.
400      *
401      * NOTE: Renouncing ownership will leave the contract without an owner,
402      * thereby removing any functionality that is only available to the owner.
403      */
404     function renounceOwnership() public virtual onlyOwner {
405         _transferOwnership(address(0));
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(newOwner != address(0), "Ownable: new owner is the zero address");
414         _transferOwnership(newOwner);
415     }
416 
417     /**
418      * @dev Transfers ownership of the contract to a new account (`newOwner`).
419      * Internal function without access restriction.
420      */
421     function _transferOwnership(address newOwner) internal virtual {
422         address oldOwner = _owner;
423         _owner = newOwner;
424         emit OwnershipTransferred(oldOwner, newOwner);
425     }
426 }
427 
428 // File: erc721a/contracts/IERC721A.sol
429 
430 
431 // ERC721A Contracts v4.2.0
432 // Creator: Chiru Labs
433 
434 pragma solidity ^0.8.4;
435 
436 /**
437  * @dev Interface of ERC721A.
438  */
439 interface IERC721A {
440     /**
441      * The caller must own the token or be an approved operator.
442      */
443     error ApprovalCallerNotOwnerNorApproved();
444 
445     /**
446      * The token does not exist.
447      */
448     error ApprovalQueryForNonexistentToken();
449 
450     /**
451      * The caller cannot approve to their own address.
452      */
453     error ApproveToCaller();
454 
455     /**
456      * Cannot query the balance for the zero address.
457      */
458     error BalanceQueryForZeroAddress();
459 
460     /**
461      * Cannot mint to the zero address.
462      */
463     error MintToZeroAddress();
464 
465     /**
466      * The quantity of tokens minted must be more than zero.
467      */
468     error MintZeroQuantity();
469 
470     /**
471      * The token does not exist.
472      */
473     error OwnerQueryForNonexistentToken();
474 
475     /**
476      * The caller must own the token or be an approved operator.
477      */
478     error TransferCallerNotOwnerNorApproved();
479 
480     /**
481      * The token must be owned by `from`.
482      */
483     error TransferFromIncorrectOwner();
484 
485     /**
486      * Cannot safely transfer to a contract that does not implement the
487      * ERC721Receiver interface.
488      */
489     error TransferToNonERC721ReceiverImplementer();
490 
491     /**
492      * Cannot transfer to the zero address.
493      */
494     error TransferToZeroAddress();
495 
496     /**
497      * The token does not exist.
498      */
499     error URIQueryForNonexistentToken();
500 
501     /**
502      * The `quantity` minted with ERC2309 exceeds the safety limit.
503      */
504     error MintERC2309QuantityExceedsLimit();
505 
506     /**
507      * The `extraData` cannot be set on an unintialized ownership slot.
508      */
509     error OwnershipNotInitializedForExtraData();
510 
511     // =============================================================
512     //                            STRUCTS
513     // =============================================================
514 
515     struct TokenOwnership {
516         // The address of the owner.
517         address addr;
518         // Stores the start time of ownership with minimal overhead for tokenomics.
519         uint64 startTimestamp;
520         // Whether the token has been burned.
521         bool burned;
522         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
523         uint24 extraData;
524     }
525 
526     // =============================================================
527     //                         TOKEN COUNTERS
528     // =============================================================
529 
530     /**
531      * @dev Returns the total number of tokens in existence.
532      * Burned tokens will reduce the count.
533      * To get the total number of tokens minted, please see {_totalMinted}.
534      */
535     function totalSupply() external view returns (uint256);
536 
537     // =============================================================
538     //                            IERC165
539     // =============================================================
540 
541     /**
542      * @dev Returns true if this contract implements the interface defined by
543      * `interfaceId`. See the corresponding
544      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
545      * to learn more about how these ids are created.
546      *
547      * This function call must use less than 30000 gas.
548      */
549     function supportsInterface(bytes4 interfaceId) external view returns (bool);
550 
551     // =============================================================
552     //                            IERC721
553     // =============================================================
554 
555     /**
556      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
557      */
558     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
562      */
563     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables or disables
567      * (`approved`) `operator` to manage all of its assets.
568      */
569     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
570 
571     /**
572      * @dev Returns the number of tokens in `owner`'s account.
573      */
574     function balanceOf(address owner) external view returns (uint256 balance);
575 
576     /**
577      * @dev Returns the owner of the `tokenId` token.
578      *
579      * Requirements:
580      *
581      * - `tokenId` must exist.
582      */
583     function ownerOf(uint256 tokenId) external view returns (address owner);
584 
585     /**
586      * @dev Safely transfers `tokenId` token from `from` to `to`,
587      * checking first that contract recipients are aware of the ERC721 protocol
588      * to prevent tokens from being forever locked.
589      *
590      * Requirements:
591      *
592      * - `from` cannot be the zero address.
593      * - `to` cannot be the zero address.
594      * - `tokenId` token must exist and be owned by `from`.
595      * - If the caller is not `from`, it must be have been allowed to move
596      * this token by either {approve} or {setApprovalForAll}.
597      * - If `to` refers to a smart contract, it must implement
598      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
599      *
600      * Emits a {Transfer} event.
601      */
602     function safeTransferFrom(
603         address from,
604         address to,
605         uint256 tokenId,
606         bytes calldata data
607     ) external;
608 
609     /**
610      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) external;
617 
618     /**
619      * @dev Transfers `tokenId` from `from` to `to`.
620      *
621      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
622      * whenever possible.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must be owned by `from`.
629      * - If the caller is not `from`, it must be approved to move this token
630      * by either {approve} or {setApprovalForAll}.
631      *
632      * Emits a {Transfer} event.
633      */
634     function transferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
642      * The approval is cleared when the token is transferred.
643      *
644      * Only a single account can be approved at a time, so approving the
645      * zero address clears previous approvals.
646      *
647      * Requirements:
648      *
649      * - The caller must own the token or be an approved operator.
650      * - `tokenId` must exist.
651      *
652      * Emits an {Approval} event.
653      */
654     function approve(address to, uint256 tokenId) external;
655 
656     /**
657      * @dev Approve or remove `operator` as an operator for the caller.
658      * Operators can call {transferFrom} or {safeTransferFrom}
659      * for any token owned by the caller.
660      *
661      * Requirements:
662      *
663      * - The `operator` cannot be the caller.
664      *
665      * Emits an {ApprovalForAll} event.
666      */
667     function setApprovalForAll(address operator, bool _approved) external;
668 
669     /**
670      * @dev Returns the account approved for `tokenId` token.
671      *
672      * Requirements:
673      *
674      * - `tokenId` must exist.
675      */
676     function getApproved(uint256 tokenId) external view returns (address operator);
677 
678     /**
679      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
680      *
681      * See {setApprovalForAll}.
682      */
683     function isApprovedForAll(address owner, address operator) external view returns (bool);
684 
685     // =============================================================
686     //                        IERC721Metadata
687     // =============================================================
688 
689     /**
690      * @dev Returns the token collection name.
691      */
692     function name() external view returns (string memory);
693 
694     /**
695      * @dev Returns the token collection symbol.
696      */
697     function symbol() external view returns (string memory);
698 
699     /**
700      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
701      */
702     function tokenURI(uint256 tokenId) external view returns (string memory);
703 
704     // =============================================================
705     //                           IERC2309
706     // =============================================================
707 
708     /**
709      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
710      * (inclusive) is transferred from `from` to `to`, as defined in the
711      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
712      *
713      * See {_mintERC2309} for more details.
714      */
715     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
716 }
717 
718 // File: erc721a/contracts/ERC721A.sol
719 
720 
721 // ERC721A Contracts v4.2.0
722 // Creator: Chiru Labs
723 
724 pragma solidity ^0.8.4;
725 
726 
727 /**
728  * @dev Interface of ERC721 token receiver.
729  */
730 interface ERC721A__IERC721Receiver {
731     function onERC721Received(
732         address operator,
733         address from,
734         uint256 tokenId,
735         bytes calldata data
736     ) external returns (bytes4);
737 }
738 
739 /**
740  * @title ERC721A
741  *
742  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
743  * Non-Fungible Token Standard, including the Metadata extension.
744  * Optimized for lower gas during batch mints.
745  *
746  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
747  * starting from `_startTokenId()`.
748  *
749  * Assumptions:
750  *
751  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
752  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
753  */
754 contract ERC721A is IERC721A {
755     // Reference type for token approval.
756     struct TokenApprovalRef {
757         address value;
758     }
759 
760     // =============================================================
761     //                           CONSTANTS
762     // =============================================================
763 
764     // Mask of an entry in packed address data.
765     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
766 
767     // The bit position of `numberMinted` in packed address data.
768     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
769 
770     // The bit position of `numberBurned` in packed address data.
771     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
772 
773     // The bit position of `aux` in packed address data.
774     uint256 private constant _BITPOS_AUX = 192;
775 
776     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
777     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
778 
779     // The bit position of `startTimestamp` in packed ownership.
780     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
781 
782     // The bit mask of the `burned` bit in packed ownership.
783     uint256 private constant _BITMASK_BURNED = 1 << 224;
784 
785     // The bit position of the `nextInitialized` bit in packed ownership.
786     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
787 
788     // The bit mask of the `nextInitialized` bit in packed ownership.
789     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
790 
791     // The bit position of `extraData` in packed ownership.
792     uint256 private constant _BITPOS_EXTRA_DATA = 232;
793 
794     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
795     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
796 
797     // The mask of the lower 160 bits for addresses.
798     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
799 
800     // The maximum `quantity` that can be minted with {_mintERC2309}.
801     // This limit is to prevent overflows on the address data entries.
802     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
803     // is required to cause an overflow, which is unrealistic.
804     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
805 
806     // The `Transfer` event signature is given by:
807     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
808     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
809         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
810 
811     // =============================================================
812     //                            STORAGE
813     // =============================================================
814 
815     // The next token ID to be minted.
816     uint256 private _currentIndex;
817 
818     // The number of tokens burned.
819     uint256 private _burnCounter;
820 
821     // Token name
822     string private _name;
823 
824     // Token symbol
825     string private _symbol;
826 
827     // Mapping from token ID to ownership details
828     // An empty struct value does not necessarily mean the token is unowned.
829     // See {_packedOwnershipOf} implementation for details.
830     //
831     // Bits Layout:
832     // - [0..159]   `addr`
833     // - [160..223] `startTimestamp`
834     // - [224]      `burned`
835     // - [225]      `nextInitialized`
836     // - [232..255] `extraData`
837     mapping(uint256 => uint256) private _packedOwnerships;
838 
839     // Mapping owner address to address data.
840     //
841     // Bits Layout:
842     // - [0..63]    `balance`
843     // - [64..127]  `numberMinted`
844     // - [128..191] `numberBurned`
845     // - [192..255] `aux`
846     mapping(address => uint256) private _packedAddressData;
847 
848     // Mapping from token ID to approved address.
849     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
850 
851     // Mapping from owner to operator approvals
852     mapping(address => mapping(address => bool)) private _operatorApprovals;
853 
854     // =============================================================
855     //                          CONSTRUCTOR
856     // =============================================================
857 
858     constructor(string memory name_, string memory symbol_) {
859         _name = name_;
860         _symbol = symbol_;
861         _currentIndex = _startTokenId();
862     }
863 
864     // =============================================================
865     //                   TOKEN COUNTING OPERATIONS
866     // =============================================================
867 
868     /**
869      * @dev Returns the starting token ID.
870      * To change the starting token ID, please override this function.
871      */
872     function _startTokenId() internal view virtual returns (uint256) {
873         return 0;
874     }
875 
876     /**
877      * @dev Returns the next token ID to be minted.
878      */
879     function _nextTokenId() internal view virtual returns (uint256) {
880         return _currentIndex;
881     }
882 
883     /**
884      * @dev Returns the total number of tokens in existence.
885      * Burned tokens will reduce the count.
886      * To get the total number of tokens minted, please see {_totalMinted}.
887      */
888     function totalSupply() public view virtual override returns (uint256) {
889         // Counter underflow is impossible as _burnCounter cannot be incremented
890         // more than `_currentIndex - _startTokenId()` times.
891         unchecked {
892             return _currentIndex - _burnCounter - _startTokenId();
893         }
894     }
895 
896     /**
897      * @dev Returns the total amount of tokens minted in the contract.
898      */
899     function _totalMinted() internal view virtual returns (uint256) {
900         // Counter underflow is impossible as `_currentIndex` does not decrement,
901         // and it is initialized to `_startTokenId()`.
902         unchecked {
903             return _currentIndex - _startTokenId();
904         }
905     }
906 
907     /**
908      * @dev Returns the total number of tokens burned.
909      */
910     function _totalBurned() internal view virtual returns (uint256) {
911         return _burnCounter;
912     }
913 
914     // =============================================================
915     //                    ADDRESS DATA OPERATIONS
916     // =============================================================
917 
918     /**
919      * @dev Returns the number of tokens in `owner`'s account.
920      */
921     function balanceOf(address owner) public view virtual override returns (uint256) {
922         if (owner == address(0)) revert BalanceQueryForZeroAddress();
923         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
924     }
925 
926     /**
927      * Returns the number of tokens minted by `owner`.
928      */
929     function _numberMinted(address owner) internal view returns (uint256) {
930         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
931     }
932 
933     /**
934      * Returns the number of tokens burned by or on behalf of `owner`.
935      */
936     function _numberBurned(address owner) internal view returns (uint256) {
937         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
938     }
939 
940     /**
941      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
942      */
943     function _getAux(address owner) internal view returns (uint64) {
944         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
945     }
946 
947     /**
948      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
949      * If there are multiple variables, please pack them into a uint64.
950      */
951     function _setAux(address owner, uint64 aux) internal virtual {
952         uint256 packed = _packedAddressData[owner];
953         uint256 auxCasted;
954         // Cast `aux` with assembly to avoid redundant masking.
955         assembly {
956             auxCasted := aux
957         }
958         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
959         _packedAddressData[owner] = packed;
960     }
961 
962     // =============================================================
963     //                            IERC165
964     // =============================================================
965 
966     /**
967      * @dev Returns true if this contract implements the interface defined by
968      * `interfaceId`. See the corresponding
969      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
970      * to learn more about how these ids are created.
971      *
972      * This function call must use less than 30000 gas.
973      */
974     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
975         // The interface IDs are constants representing the first 4 bytes
976         // of the XOR of all function selectors in the interface.
977         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
978         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
979         return
980             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
981             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
982             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
983     }
984 
985     // =============================================================
986     //                        IERC721Metadata
987     // =============================================================
988 
989     /**
990      * @dev Returns the token collection name.
991      */
992     function name() public view virtual override returns (string memory) {
993         return _name;
994     }
995 
996     /**
997      * @dev Returns the token collection symbol.
998      */
999     function symbol() public view virtual override returns (string memory) {
1000         return _symbol;
1001     }
1002 
1003     /**
1004      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1005      */
1006     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1007         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1008 
1009         string memory baseURI = _baseURI();
1010         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1011     }
1012 
1013     /**
1014      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1015      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1016      * by default, it can be overridden in child contracts.
1017      */
1018     function _baseURI() internal view virtual returns (string memory) {
1019         return '';
1020     }
1021 
1022     // =============================================================
1023     //                     OWNERSHIPS OPERATIONS
1024     // =============================================================
1025 
1026     /**
1027      * @dev Returns the owner of the `tokenId` token.
1028      *
1029      * Requirements:
1030      *
1031      * - `tokenId` must exist.
1032      */
1033     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1034         return address(uint160(_packedOwnershipOf(tokenId)));
1035     }
1036 
1037     /**
1038      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1039      * It gradually moves to O(1) as tokens get transferred around over time.
1040      */
1041     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1042         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1043     }
1044 
1045     /**
1046      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1047      */
1048     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1049         return _unpackedOwnership(_packedOwnerships[index]);
1050     }
1051 
1052     /**
1053      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1054      */
1055     function _initializeOwnershipAt(uint256 index) internal virtual {
1056         if (_packedOwnerships[index] == 0) {
1057             _packedOwnerships[index] = _packedOwnershipOf(index);
1058         }
1059     }
1060 
1061     /**
1062      * Returns the packed ownership data of `tokenId`.
1063      */
1064     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1065         uint256 curr = tokenId;
1066 
1067         unchecked {
1068             if (_startTokenId() <= curr)
1069                 if (curr < _currentIndex) {
1070                     uint256 packed = _packedOwnerships[curr];
1071                     // If not burned.
1072                     if (packed & _BITMASK_BURNED == 0) {
1073                         // Invariant:
1074                         // There will always be an initialized ownership slot
1075                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1076                         // before an unintialized ownership slot
1077                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1078                         // Hence, `curr` will not underflow.
1079                         //
1080                         // We can directly compare the packed value.
1081                         // If the address is zero, packed will be zero.
1082                         while (packed == 0) {
1083                             packed = _packedOwnerships[--curr];
1084                         }
1085                         return packed;
1086                     }
1087                 }
1088         }
1089         revert OwnerQueryForNonexistentToken();
1090     }
1091 
1092     /**
1093      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1094      */
1095     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1096         ownership.addr = address(uint160(packed));
1097         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1098         ownership.burned = packed & _BITMASK_BURNED != 0;
1099         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1100     }
1101 
1102     /**
1103      * @dev Packs ownership data into a single uint256.
1104      */
1105     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1106         assembly {
1107             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1108             owner := and(owner, _BITMASK_ADDRESS)
1109             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1110             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1111         }
1112     }
1113 
1114     /**
1115      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1116      */
1117     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1118         // For branchless setting of the `nextInitialized` flag.
1119         assembly {
1120             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1121             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1122         }
1123     }
1124 
1125     // =============================================================
1126     //                      APPROVAL OPERATIONS
1127     // =============================================================
1128 
1129     /**
1130      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1131      * The approval is cleared when the token is transferred.
1132      *
1133      * Only a single account can be approved at a time, so approving the
1134      * zero address clears previous approvals.
1135      *
1136      * Requirements:
1137      *
1138      * - The caller must own the token or be an approved operator.
1139      * - `tokenId` must exist.
1140      *
1141      * Emits an {Approval} event.
1142      */
1143     function approve(address to, uint256 tokenId) public virtual override {
1144         address owner = ownerOf(tokenId);
1145 
1146         if (_msgSenderERC721A() != owner)
1147             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1148                 revert ApprovalCallerNotOwnerNorApproved();
1149             }
1150 
1151         _tokenApprovals[tokenId].value = to;
1152         emit Approval(owner, to, tokenId);
1153     }
1154 
1155     /**
1156      * @dev Returns the account approved for `tokenId` token.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must exist.
1161      */
1162     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1163         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1164 
1165         return _tokenApprovals[tokenId].value;
1166     }
1167 
1168     /**
1169      * @dev Approve or remove `operator` as an operator for the caller.
1170      * Operators can call {transferFrom} or {safeTransferFrom}
1171      * for any token owned by the caller.
1172      *
1173      * Requirements:
1174      *
1175      * - The `operator` cannot be the caller.
1176      *
1177      * Emits an {ApprovalForAll} event.
1178      */
1179     function setApprovalForAll(address operator, bool approved) public virtual override {
1180         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1181 
1182         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1183         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1184     }
1185 
1186     /**
1187      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1188      *
1189      * See {setApprovalForAll}.
1190      */
1191     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1192         return _operatorApprovals[owner][operator];
1193     }
1194 
1195     /**
1196      * @dev Returns whether `tokenId` exists.
1197      *
1198      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1199      *
1200      * Tokens start existing when they are minted. See {_mint}.
1201      */
1202     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1203         return
1204             _startTokenId() <= tokenId &&
1205             tokenId < _currentIndex && // If within bounds,
1206             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1207     }
1208 
1209     /**
1210      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1211      */
1212     function _isSenderApprovedOrOwner(
1213         address approvedAddress,
1214         address owner,
1215         address msgSender
1216     ) private pure returns (bool result) {
1217         assembly {
1218             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1219             owner := and(owner, _BITMASK_ADDRESS)
1220             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1221             msgSender := and(msgSender, _BITMASK_ADDRESS)
1222             // `msgSender == owner || msgSender == approvedAddress`.
1223             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1224         }
1225     }
1226 
1227     /**
1228      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1229      */
1230     function _getApprovedSlotAndAddress(uint256 tokenId)
1231         private
1232         view
1233         returns (uint256 approvedAddressSlot, address approvedAddress)
1234     {
1235         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1236         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1237         assembly {
1238             approvedAddressSlot := tokenApproval.slot
1239             approvedAddress := sload(approvedAddressSlot)
1240         }
1241     }
1242 
1243     // =============================================================
1244     //                      TRANSFER OPERATIONS
1245     // =============================================================
1246 
1247     /**
1248      * @dev Transfers `tokenId` from `from` to `to`.
1249      *
1250      * Requirements:
1251      *
1252      * - `from` cannot be the zero address.
1253      * - `to` cannot be the zero address.
1254      * - `tokenId` token must be owned by `from`.
1255      * - If the caller is not `from`, it must be approved to move this token
1256      * by either {approve} or {setApprovalForAll}.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function transferFrom(
1261         address from,
1262         address to,
1263         uint256 tokenId
1264     ) public virtual override {
1265         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1266 
1267         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1268 
1269         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1270 
1271         // The nested ifs save around 20+ gas over a compound boolean condition.
1272         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1273             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1274 
1275         if (to == address(0)) revert TransferToZeroAddress();
1276 
1277         _beforeTokenTransfers(from, to, tokenId, 1);
1278 
1279         // Clear approvals from the previous owner.
1280         assembly {
1281             if approvedAddress {
1282                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1283                 sstore(approvedAddressSlot, 0)
1284             }
1285         }
1286 
1287         // Underflow of the sender's balance is impossible because we check for
1288         // ownership above and the recipient's balance can't realistically overflow.
1289         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1290         unchecked {
1291             // We can directly increment and decrement the balances.
1292             --_packedAddressData[from]; // Updates: `balance -= 1`.
1293             ++_packedAddressData[to]; // Updates: `balance += 1`.
1294 
1295             // Updates:
1296             // - `address` to the next owner.
1297             // - `startTimestamp` to the timestamp of transfering.
1298             // - `burned` to `false`.
1299             // - `nextInitialized` to `true`.
1300             _packedOwnerships[tokenId] = _packOwnershipData(
1301                 to,
1302                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1303             );
1304 
1305             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1306             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1307                 uint256 nextTokenId = tokenId + 1;
1308                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1309                 if (_packedOwnerships[nextTokenId] == 0) {
1310                     // If the next slot is within bounds.
1311                     if (nextTokenId != _currentIndex) {
1312                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1313                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1314                     }
1315                 }
1316             }
1317         }
1318 
1319         emit Transfer(from, to, tokenId);
1320         _afterTokenTransfers(from, to, tokenId, 1);
1321     }
1322 
1323     /**
1324      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1325      */
1326     function safeTransferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) public virtual override {
1331         safeTransferFrom(from, to, tokenId, '');
1332     }
1333 
1334     /**
1335      * @dev Safely transfers `tokenId` token from `from` to `to`.
1336      *
1337      * Requirements:
1338      *
1339      * - `from` cannot be the zero address.
1340      * - `to` cannot be the zero address.
1341      * - `tokenId` token must exist and be owned by `from`.
1342      * - If the caller is not `from`, it must be approved to move this token
1343      * by either {approve} or {setApprovalForAll}.
1344      * - If `to` refers to a smart contract, it must implement
1345      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1346      *
1347      * Emits a {Transfer} event.
1348      */
1349     function safeTransferFrom(
1350         address from,
1351         address to,
1352         uint256 tokenId,
1353         bytes memory _data
1354     ) public virtual override {
1355         transferFrom(from, to, tokenId);
1356         if (to.code.length != 0)
1357             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1358                 revert TransferToNonERC721ReceiverImplementer();
1359             }
1360     }
1361 
1362     /**
1363      * @dev Hook that is called before a set of serially-ordered token IDs
1364      * are about to be transferred. This includes minting.
1365      * And also called before burning one token.
1366      *
1367      * `startTokenId` - the first token ID to be transferred.
1368      * `quantity` - the amount to be transferred.
1369      *
1370      * Calling conditions:
1371      *
1372      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1373      * transferred to `to`.
1374      * - When `from` is zero, `tokenId` will be minted for `to`.
1375      * - When `to` is zero, `tokenId` will be burned by `from`.
1376      * - `from` and `to` are never both zero.
1377      */
1378     function _beforeTokenTransfers(
1379         address from,
1380         address to,
1381         uint256 startTokenId,
1382         uint256 quantity
1383     ) internal virtual {}
1384 
1385     /**
1386      * @dev Hook that is called after a set of serially-ordered token IDs
1387      * have been transferred. This includes minting.
1388      * And also called after one token has been burned.
1389      *
1390      * `startTokenId` - the first token ID to be transferred.
1391      * `quantity` - the amount to be transferred.
1392      *
1393      * Calling conditions:
1394      *
1395      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1396      * transferred to `to`.
1397      * - When `from` is zero, `tokenId` has been minted for `to`.
1398      * - When `to` is zero, `tokenId` has been burned by `from`.
1399      * - `from` and `to` are never both zero.
1400      */
1401     function _afterTokenTransfers(
1402         address from,
1403         address to,
1404         uint256 startTokenId,
1405         uint256 quantity
1406     ) internal virtual {}
1407 
1408     /**
1409      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1410      *
1411      * `from` - Previous owner of the given token ID.
1412      * `to` - Target address that will receive the token.
1413      * `tokenId` - Token ID to be transferred.
1414      * `_data` - Optional data to send along with the call.
1415      *
1416      * Returns whether the call correctly returned the expected magic value.
1417      */
1418     function _checkContractOnERC721Received(
1419         address from,
1420         address to,
1421         uint256 tokenId,
1422         bytes memory _data
1423     ) private returns (bool) {
1424         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1425             bytes4 retval
1426         ) {
1427             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1428         } catch (bytes memory reason) {
1429             if (reason.length == 0) {
1430                 revert TransferToNonERC721ReceiverImplementer();
1431             } else {
1432                 assembly {
1433                     revert(add(32, reason), mload(reason))
1434                 }
1435             }
1436         }
1437     }
1438 
1439     // =============================================================
1440     //                        MINT OPERATIONS
1441     // =============================================================
1442 
1443     /**
1444      * @dev Mints `quantity` tokens and transfers them to `to`.
1445      *
1446      * Requirements:
1447      *
1448      * - `to` cannot be the zero address.
1449      * - `quantity` must be greater than 0.
1450      *
1451      * Emits a {Transfer} event for each mint.
1452      */
1453     function _mint(address to, uint256 quantity) internal virtual {
1454         uint256 startTokenId = _currentIndex;
1455         if (quantity == 0) revert MintZeroQuantity();
1456 
1457         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1458 
1459         // Overflows are incredibly unrealistic.
1460         // `balance` and `numberMinted` have a maximum limit of 2**64.
1461         // `tokenId` has a maximum limit of 2**256.
1462         unchecked {
1463             // Updates:
1464             // - `balance += quantity`.
1465             // - `numberMinted += quantity`.
1466             //
1467             // We can directly add to the `balance` and `numberMinted`.
1468             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1469 
1470             // Updates:
1471             // - `address` to the owner.
1472             // - `startTimestamp` to the timestamp of minting.
1473             // - `burned` to `false`.
1474             // - `nextInitialized` to `quantity == 1`.
1475             _packedOwnerships[startTokenId] = _packOwnershipData(
1476                 to,
1477                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1478             );
1479 
1480             uint256 toMasked;
1481             uint256 end = startTokenId + quantity;
1482 
1483             // Use assembly to loop and emit the `Transfer` event for gas savings.
1484             assembly {
1485                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1486                 toMasked := and(to, _BITMASK_ADDRESS)
1487                 // Emit the `Transfer` event.
1488                 log4(
1489                     0, // Start of data (0, since no data).
1490                     0, // End of data (0, since no data).
1491                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1492                     0, // `address(0)`.
1493                     toMasked, // `to`.
1494                     startTokenId // `tokenId`.
1495                 )
1496 
1497                 for {
1498                     let tokenId := add(startTokenId, 1)
1499                 } iszero(eq(tokenId, end)) {
1500                     tokenId := add(tokenId, 1)
1501                 } {
1502                     // Emit the `Transfer` event. Similar to above.
1503                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1504                 }
1505             }
1506             if (toMasked == 0) revert MintToZeroAddress();
1507 
1508             _currentIndex = end;
1509         }
1510         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1511     }
1512 
1513     /**
1514      * @dev Mints `quantity` tokens and transfers them to `to`.
1515      *
1516      * This function is intended for efficient minting only during contract creation.
1517      *
1518      * It emits only one {ConsecutiveTransfer} as defined in
1519      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1520      * instead of a sequence of {Transfer} event(s).
1521      *
1522      * Calling this function outside of contract creation WILL make your contract
1523      * non-compliant with the ERC721 standard.
1524      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1525      * {ConsecutiveTransfer} event is only permissible during contract creation.
1526      *
1527      * Requirements:
1528      *
1529      * - `to` cannot be the zero address.
1530      * - `quantity` must be greater than 0.
1531      *
1532      * Emits a {ConsecutiveTransfer} event.
1533      */
1534     function _mintERC2309(address to, uint256 quantity) internal virtual {
1535         uint256 startTokenId = _currentIndex;
1536         if (to == address(0)) revert MintToZeroAddress();
1537         if (quantity == 0) revert MintZeroQuantity();
1538         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1539 
1540         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1541 
1542         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1543         unchecked {
1544             // Updates:
1545             // - `balance += quantity`.
1546             // - `numberMinted += quantity`.
1547             //
1548             // We can directly add to the `balance` and `numberMinted`.
1549             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1550 
1551             // Updates:
1552             // - `address` to the owner.
1553             // - `startTimestamp` to the timestamp of minting.
1554             // - `burned` to `false`.
1555             // - `nextInitialized` to `quantity == 1`.
1556             _packedOwnerships[startTokenId] = _packOwnershipData(
1557                 to,
1558                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1559             );
1560 
1561             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1562 
1563             _currentIndex = startTokenId + quantity;
1564         }
1565         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1566     }
1567 
1568     /**
1569      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1570      *
1571      * Requirements:
1572      *
1573      * - If `to` refers to a smart contract, it must implement
1574      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1575      * - `quantity` must be greater than 0.
1576      *
1577      * See {_mint}.
1578      *
1579      * Emits a {Transfer} event for each mint.
1580      */
1581     function _safeMint(
1582         address to,
1583         uint256 quantity,
1584         bytes memory _data
1585     ) internal virtual {
1586         _mint(to, quantity);
1587 
1588         unchecked {
1589             if (to.code.length != 0) {
1590                 uint256 end = _currentIndex;
1591                 uint256 index = end - quantity;
1592                 do {
1593                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1594                         revert TransferToNonERC721ReceiverImplementer();
1595                     }
1596                 } while (index < end);
1597                 // Reentrancy protection.
1598                 if (_currentIndex != end) revert();
1599             }
1600         }
1601     }
1602 
1603     /**
1604      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1605      */
1606     function _safeMint(address to, uint256 quantity) internal virtual {
1607         _safeMint(to, quantity, '');
1608     }
1609 
1610     // =============================================================
1611     //                        BURN OPERATIONS
1612     // =============================================================
1613 
1614     /**
1615      * @dev Equivalent to `_burn(tokenId, false)`.
1616      */
1617     function _burn(uint256 tokenId) internal virtual {
1618         _burn(tokenId, false);
1619     }
1620 
1621     /**
1622      * @dev Destroys `tokenId`.
1623      * The approval is cleared when the token is burned.
1624      *
1625      * Requirements:
1626      *
1627      * - `tokenId` must exist.
1628      *
1629      * Emits a {Transfer} event.
1630      */
1631     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1632         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1633 
1634         address from = address(uint160(prevOwnershipPacked));
1635 
1636         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1637 
1638         if (approvalCheck) {
1639             // The nested ifs save around 20+ gas over a compound boolean condition.
1640             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1641                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1642         }
1643 
1644         _beforeTokenTransfers(from, address(0), tokenId, 1);
1645 
1646         // Clear approvals from the previous owner.
1647         assembly {
1648             if approvedAddress {
1649                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1650                 sstore(approvedAddressSlot, 0)
1651             }
1652         }
1653 
1654         // Underflow of the sender's balance is impossible because we check for
1655         // ownership above and the recipient's balance can't realistically overflow.
1656         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1657         unchecked {
1658             // Updates:
1659             // - `balance -= 1`.
1660             // - `numberBurned += 1`.
1661             //
1662             // We can directly decrement the balance, and increment the number burned.
1663             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1664             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1665 
1666             // Updates:
1667             // - `address` to the last owner.
1668             // - `startTimestamp` to the timestamp of burning.
1669             // - `burned` to `true`.
1670             // - `nextInitialized` to `true`.
1671             _packedOwnerships[tokenId] = _packOwnershipData(
1672                 from,
1673                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1674             );
1675 
1676             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1677             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1678                 uint256 nextTokenId = tokenId + 1;
1679                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1680                 if (_packedOwnerships[nextTokenId] == 0) {
1681                     // If the next slot is within bounds.
1682                     if (nextTokenId != _currentIndex) {
1683                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1684                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1685                     }
1686                 }
1687             }
1688         }
1689 
1690         emit Transfer(from, address(0), tokenId);
1691         _afterTokenTransfers(from, address(0), tokenId, 1);
1692 
1693         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1694         unchecked {
1695             _burnCounter++;
1696         }
1697     }
1698 
1699     // =============================================================
1700     //                     EXTRA DATA OPERATIONS
1701     // =============================================================
1702 
1703     /**
1704      * @dev Directly sets the extra data for the ownership data `index`.
1705      */
1706     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1707         uint256 packed = _packedOwnerships[index];
1708         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1709         uint256 extraDataCasted;
1710         // Cast `extraData` with assembly to avoid redundant masking.
1711         assembly {
1712             extraDataCasted := extraData
1713         }
1714         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1715         _packedOwnerships[index] = packed;
1716     }
1717 
1718     /**
1719      * @dev Called during each token transfer to set the 24bit `extraData` field.
1720      * Intended to be overridden by the cosumer contract.
1721      *
1722      * `previousExtraData` - the value of `extraData` before transfer.
1723      *
1724      * Calling conditions:
1725      *
1726      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1727      * transferred to `to`.
1728      * - When `from` is zero, `tokenId` will be minted for `to`.
1729      * - When `to` is zero, `tokenId` will be burned by `from`.
1730      * - `from` and `to` are never both zero.
1731      */
1732     function _extraData(
1733         address from,
1734         address to,
1735         uint24 previousExtraData
1736     ) internal view virtual returns (uint24) {}
1737 
1738     /**
1739      * @dev Returns the next extra data for the packed ownership data.
1740      * The returned result is shifted into position.
1741      */
1742     function _nextExtraData(
1743         address from,
1744         address to,
1745         uint256 prevOwnershipPacked
1746     ) private view returns (uint256) {
1747         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1748         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1749     }
1750 
1751     // =============================================================
1752     //                       OTHER OPERATIONS
1753     // =============================================================
1754 
1755     /**
1756      * @dev Returns the message sender (defaults to `msg.sender`).
1757      *
1758      * If you are writing GSN compatible contracts, you need to override this function.
1759      */
1760     function _msgSenderERC721A() internal view virtual returns (address) {
1761         return msg.sender;
1762     }
1763 
1764     /**
1765      * @dev Converts a uint256 to its ASCII string decimal representation.
1766      */
1767     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1768         assembly {
1769             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1770             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1771             // We will need 1 32-byte word to store the length,
1772             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1773             ptr := add(mload(0x40), 128)
1774             // Update the free memory pointer to allocate.
1775             mstore(0x40, ptr)
1776 
1777             // Cache the end of the memory to calculate the length later.
1778             let end := ptr
1779 
1780             // We write the string from the rightmost digit to the leftmost digit.
1781             // The following is essentially a do-while loop that also handles the zero case.
1782             // Costs a bit more than early returning for the zero case,
1783             // but cheaper in terms of deployment and overall runtime costs.
1784             for {
1785                 // Initialize and perform the first pass without check.
1786                 let temp := value
1787                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1788                 ptr := sub(ptr, 1)
1789                 // Write the character to the pointer.
1790                 // The ASCII index of the '0' character is 48.
1791                 mstore8(ptr, add(48, mod(temp, 10)))
1792                 temp := div(temp, 10)
1793             } temp {
1794                 // Keep dividing `temp` until zero.
1795                 temp := div(temp, 10)
1796             } {
1797                 // Body of the for loop.
1798                 ptr := sub(ptr, 1)
1799                 mstore8(ptr, add(48, mod(temp, 10)))
1800             }
1801 
1802             let length := sub(end, ptr)
1803             // Move the pointer 32 bytes leftwards to make room for the length.
1804             ptr := sub(ptr, 32)
1805             // Store the length.
1806             mstore(ptr, length)
1807         }
1808     }
1809 }
1810 
1811 // File: contracts/CrankyCrocz.sol
1812 
1813 
1814 
1815 pragma solidity ^0.8.4;
1816 
1817 
1818 
1819 
1820 
1821 contract CrankyCrocz is ERC721A, Ownable {
1822 
1823   using Strings for uint256;
1824   using ECDSA for bytes32;
1825 
1826   address signer;
1827   error InvalidSignarure();
1828   
1829   uint public maxSupply = 888;
1830   // 88 reserved for team & giveaways
1831   uint public maxMintable = 800;
1832 
1833   string tokenBaseUri = "https://bafybeibljilzb7bgwzuzivb4sulife7ktiggmeo4nfhacwzrr4fhyny2xy.ipfs.nftstorage.link/";
1834 
1835   bool public paused = false;
1836   mapping(address => uint256) private _freeMintedCount;
1837  
1838   constructor() ERC721A("Cranky Crocz", "CCROCZ") {}
1839 
1840   function freeMint() external {
1841     
1842       require(!paused, "Minting paused");
1843       require(_freeMintedCount[msg.sender] < 1);
1844 
1845       uint256 _totalSupply = totalSupply();
1846 
1847       require(_totalSupply + 1 < maxMintable + 1, "SOLD OUT");
1848 
1849 
1850       _freeMintedCount[msg.sender] += 1;
1851 
1852       _mint(msg.sender, 1);
1853     
1854   }
1855 
1856   function devMint(uint256 _mintAmount, address _receiver) public onlyOwner {
1857     _safeMint(_receiver, _mintAmount);
1858   }
1859 
1860   function freeMintedCount(address owner) external view returns (uint256) {
1861     return _freeMintedCount[owner];
1862   }
1863 
1864   function _startTokenId() internal pure override returns (uint256) {
1865     return 1;
1866   }
1867 
1868   function _baseURI() internal view override returns (string memory) {
1869     return tokenBaseUri;
1870   }
1871 
1872   function setBaseURI(string calldata _newBaseUri) external onlyOwner {
1873     tokenBaseUri = _newBaseUri;
1874   }
1875 
1876   function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1877     maxSupply = _maxSupply;
1878   }
1879 
1880   function setMaxMintable(uint256 _maxMintable) external onlyOwner {
1881     maxMintable = _maxMintable;
1882   }
1883 
1884   function flipSale(bool _state) external onlyOwner {
1885     paused = _state;
1886   }
1887 
1888   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1889     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1890 
1891     string memory currentBaseURI = _baseURI();
1892     return bytes(currentBaseURI).length > 0
1893         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1894         : '';
1895   }
1896 
1897 
1898   function withdraw() public onlyOwner {
1899     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1900     require(os);
1901   }
1902 
1903   function burn(
1904         uint256 tokenId,
1905         uint8 v,
1906         bytes32 r,
1907         bytes32 s
1908     ) external {
1909         if (keccak256(abi.encodePacked(msg.sender, tokenId)).toEthSignedMessageHash().recover(v, r, s) != signer) {
1910             revert InvalidSignarure();
1911         }
1912         _burn(tokenId);
1913     }
1914   function batchBurn(uint256[] memory tokenids) external onlyOwner {
1915         uint256 len = tokenids.length;
1916         for (uint256 i; i < len; i++) {
1917             uint256 tokenid = tokenids[i];
1918             _burn(tokenid);
1919         }
1920     }
1921 }