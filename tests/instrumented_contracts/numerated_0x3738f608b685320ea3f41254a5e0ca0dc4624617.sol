1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
73 
74 
75 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 
80 /**
81  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
82  *
83  * These functions can be used to verify that a message was signed by the holder
84  * of the private keys of a given address.
85  */
86 library ECDSA {
87     enum RecoverError {
88         NoError,
89         InvalidSignature,
90         InvalidSignatureLength,
91         InvalidSignatureS,
92         InvalidSignatureV
93     }
94 
95     function _throwError(RecoverError error) private pure {
96         if (error == RecoverError.NoError) {
97             return; // no error: do nothing
98         } else if (error == RecoverError.InvalidSignature) {
99             revert("ECDSA: invalid signature");
100         } else if (error == RecoverError.InvalidSignatureLength) {
101             revert("ECDSA: invalid signature length");
102         } else if (error == RecoverError.InvalidSignatureS) {
103             revert("ECDSA: invalid signature 's' value");
104         } else if (error == RecoverError.InvalidSignatureV) {
105             revert("ECDSA: invalid signature 'v' value");
106         }
107     }
108 
109     /**
110      * @dev Returns the address that signed a hashed message (`hash`) with
111      * `signature` or error string. This address can then be used for verification purposes.
112      *
113      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
114      * this function rejects them by requiring the `s` value to be in the lower
115      * half order, and the `v` value to be either 27 or 28.
116      *
117      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
118      * verification to be secure: it is possible to craft signatures that
119      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
120      * this is by receiving a hash of the original message (which may otherwise
121      * be too long), and then calling {toEthSignedMessageHash} on it.
122      *
123      * Documentation for signature generation:
124      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
125      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
126      *
127      * _Available since v4.3._
128      */
129     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
130         // Check the signature length
131         // - case 65: r,s,v signature (standard)
132         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
133         if (signature.length == 65) {
134             bytes32 r;
135             bytes32 s;
136             uint8 v;
137             // ecrecover takes the signature parameters, and the only way to get them
138             // currently is to use assembly.
139             assembly {
140                 r := mload(add(signature, 0x20))
141                 s := mload(add(signature, 0x40))
142                 v := byte(0, mload(add(signature, 0x60)))
143             }
144             return tryRecover(hash, v, r, s);
145         } else if (signature.length == 64) {
146             bytes32 r;
147             bytes32 vs;
148             // ecrecover takes the signature parameters, and the only way to get them
149             // currently is to use assembly.
150             assembly {
151                 r := mload(add(signature, 0x20))
152                 vs := mload(add(signature, 0x40))
153             }
154             return tryRecover(hash, r, vs);
155         } else {
156             return (address(0), RecoverError.InvalidSignatureLength);
157         }
158     }
159 
160     /**
161      * @dev Returns the address that signed a hashed message (`hash`) with
162      * `signature`. This address can then be used for verification purposes.
163      *
164      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
165      * this function rejects them by requiring the `s` value to be in the lower
166      * half order, and the `v` value to be either 27 or 28.
167      *
168      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
169      * verification to be secure: it is possible to craft signatures that
170      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
171      * this is by receiving a hash of the original message (which may otherwise
172      * be too long), and then calling {toEthSignedMessageHash} on it.
173      */
174     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
175         (address recovered, RecoverError error) = tryRecover(hash, signature);
176         _throwError(error);
177         return recovered;
178     }
179 
180     /**
181      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
182      *
183      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
184      *
185      * _Available since v4.3._
186      */
187     function tryRecover(
188         bytes32 hash,
189         bytes32 r,
190         bytes32 vs
191     ) internal pure returns (address, RecoverError) {
192         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
193         uint8 v = uint8((uint256(vs) >> 255) + 27);
194         return tryRecover(hash, v, r, s);
195     }
196 
197     /**
198      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
199      *
200      * _Available since v4.2._
201      */
202     function recover(
203         bytes32 hash,
204         bytes32 r,
205         bytes32 vs
206     ) internal pure returns (address) {
207         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
208         _throwError(error);
209         return recovered;
210     }
211 
212     /**
213      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
214      * `r` and `s` signature fields separately.
215      *
216      * _Available since v4.3._
217      */
218     function tryRecover(
219         bytes32 hash,
220         uint8 v,
221         bytes32 r,
222         bytes32 s
223     ) internal pure returns (address, RecoverError) {
224         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
225         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
226         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
227         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
228         //
229         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
230         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
231         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
232         // these malleable signatures as well.
233         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
234             return (address(0), RecoverError.InvalidSignatureS);
235         }
236         if (v != 27 && v != 28) {
237             return (address(0), RecoverError.InvalidSignatureV);
238         }
239 
240         // If the signature is valid (and not malleable), return the signer address
241         address signer = ecrecover(hash, v, r, s);
242         if (signer == address(0)) {
243             return (address(0), RecoverError.InvalidSignature);
244         }
245 
246         return (signer, RecoverError.NoError);
247     }
248 
249     /**
250      * @dev Overload of {ECDSA-recover} that receives the `v`,
251      * `r` and `s` signature fields separately.
252      */
253     function recover(
254         bytes32 hash,
255         uint8 v,
256         bytes32 r,
257         bytes32 s
258     ) internal pure returns (address) {
259         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
260         _throwError(error);
261         return recovered;
262     }
263 
264     /**
265      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
266      * produces hash corresponding to the one signed with the
267      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
268      * JSON-RPC method as part of EIP-191.
269      *
270      * See {recover}.
271      */
272     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
273         // 32 is the length in bytes of hash,
274         // enforced by the type signature above
275         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
276     }
277 
278     /**
279      * @dev Returns an Ethereum Signed Message, created from `s`. This
280      * produces hash corresponding to the one signed with the
281      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
282      * JSON-RPC method as part of EIP-191.
283      *
284      * See {recover}.
285      */
286     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
287         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
288     }
289 
290     /**
291      * @dev Returns an Ethereum Signed Typed Data, created from a
292      * `domainSeparator` and a `structHash`. This produces hash corresponding
293      * to the one signed with the
294      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
295      * JSON-RPC method as part of EIP-712.
296      *
297      * See {recover}.
298      */
299     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
300         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
301     }
302 }
303 
304 // File: erc721a/contracts/IERC721A.sol
305 
306 
307 // ERC721A Contracts v4.1.0
308 // Creator: Chiru Labs
309 
310 pragma solidity ^0.8.4;
311 
312 /**
313  * @dev Interface of an ERC721A compliant contract.
314  */
315 interface IERC721A {
316     /**
317      * The caller must own the token or be an approved operator.
318      */
319     error ApprovalCallerNotOwnerNorApproved();
320 
321     /**
322      * The token does not exist.
323      */
324     error ApprovalQueryForNonexistentToken();
325 
326     /**
327      * The caller cannot approve to their own address.
328      */
329     error ApproveToCaller();
330 
331     /**
332      * Cannot query the balance for the zero address.
333      */
334     error BalanceQueryForZeroAddress();
335 
336     /**
337      * Cannot mint to the zero address.
338      */
339     error MintToZeroAddress();
340 
341     /**
342      * The quantity of tokens minted must be more than zero.
343      */
344     error MintZeroQuantity();
345 
346     /**
347      * The token does not exist.
348      */
349     error OwnerQueryForNonexistentToken();
350 
351     /**
352      * The caller must own the token or be an approved operator.
353      */
354     error TransferCallerNotOwnerNorApproved();
355 
356     /**
357      * The token must be owned by `from`.
358      */
359     error TransferFromIncorrectOwner();
360 
361     /**
362      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
363      */
364     error TransferToNonERC721ReceiverImplementer();
365 
366     /**
367      * Cannot transfer to the zero address.
368      */
369     error TransferToZeroAddress();
370 
371     /**
372      * The token does not exist.
373      */
374     error URIQueryForNonexistentToken();
375 
376     /**
377      * The `quantity` minted with ERC2309 exceeds the safety limit.
378      */
379     error MintERC2309QuantityExceedsLimit();
380 
381     /**
382      * The `extraData` cannot be set on an unintialized ownership slot.
383      */
384     error OwnershipNotInitializedForExtraData();
385 
386     struct TokenOwnership {
387         // The address of the owner.
388         address addr;
389         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
390         uint64 startTimestamp;
391         // Whether the token has been burned.
392         bool burned;
393         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
394         uint24 extraData;
395     }
396 
397     /**
398      * @dev Returns the total amount of tokens stored by the contract.
399      *
400      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
401      */
402     function totalSupply() external view returns (uint256);
403 
404     // ==============================
405     //            IERC165
406     // ==============================
407 
408     /**
409      * @dev Returns true if this contract implements the interface defined by
410      * `interfaceId`. See the corresponding
411      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
412      * to learn more about how these ids are created.
413      *
414      * This function call must use less than 30 000 gas.
415      */
416     function supportsInterface(bytes4 interfaceId) external view returns (bool);
417 
418     // ==============================
419     //            IERC721
420     // ==============================
421 
422     /**
423      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
424      */
425     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
426 
427     /**
428      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
429      */
430     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
431 
432     /**
433      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
434      */
435     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
436 
437     /**
438      * @dev Returns the number of tokens in ``owner``'s account.
439      */
440     function balanceOf(address owner) external view returns (uint256 balance);
441 
442     /**
443      * @dev Returns the owner of the `tokenId` token.
444      *
445      * Requirements:
446      *
447      * - `tokenId` must exist.
448      */
449     function ownerOf(uint256 tokenId) external view returns (address owner);
450 
451     /**
452      * @dev Safely transfers `tokenId` token from `from` to `to`.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must exist and be owned by `from`.
459      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId,
468         bytes calldata data
469     ) external;
470 
471     /**
472      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
473      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must exist and be owned by `from`.
480      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
481      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
482      *
483      * Emits a {Transfer} event.
484      */
485     function safeTransferFrom(
486         address from,
487         address to,
488         uint256 tokenId
489     ) external;
490 
491     /**
492      * @dev Transfers `tokenId` token from `from` to `to`.
493      *
494      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must be owned by `from`.
501      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
502      *
503      * Emits a {Transfer} event.
504      */
505     function transferFrom(
506         address from,
507         address to,
508         uint256 tokenId
509     ) external;
510 
511     /**
512      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
513      * The approval is cleared when the token is transferred.
514      *
515      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
516      *
517      * Requirements:
518      *
519      * - The caller must own the token or be an approved operator.
520      * - `tokenId` must exist.
521      *
522      * Emits an {Approval} event.
523      */
524     function approve(address to, uint256 tokenId) external;
525 
526     /**
527      * @dev Approve or remove `operator` as an operator for the caller.
528      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
529      *
530      * Requirements:
531      *
532      * - The `operator` cannot be the caller.
533      *
534      * Emits an {ApprovalForAll} event.
535      */
536     function setApprovalForAll(address operator, bool _approved) external;
537 
538     /**
539      * @dev Returns the account approved for `tokenId` token.
540      *
541      * Requirements:
542      *
543      * - `tokenId` must exist.
544      */
545     function getApproved(uint256 tokenId) external view returns (address operator);
546 
547     /**
548      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
549      *
550      * See {setApprovalForAll}
551      */
552     function isApprovedForAll(address owner, address operator) external view returns (bool);
553 
554     // ==============================
555     //        IERC721Metadata
556     // ==============================
557 
558     /**
559      * @dev Returns the token collection name.
560      */
561     function name() external view returns (string memory);
562 
563     /**
564      * @dev Returns the token collection symbol.
565      */
566     function symbol() external view returns (string memory);
567 
568     /**
569      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
570      */
571     function tokenURI(uint256 tokenId) external view returns (string memory);
572 
573     // ==============================
574     //            IERC2309
575     // ==============================
576 
577     /**
578      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
579      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
580      */
581     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
582 }
583 
584 // File: erc721a/contracts/ERC721A.sol
585 
586 
587 // ERC721A Contracts v4.1.0
588 // Creator: Chiru Labs
589 
590 pragma solidity ^0.8.4;
591 
592 
593 /**
594  * @dev ERC721 token receiver interface.
595  */
596 interface ERC721A__IERC721Receiver {
597     function onERC721Received(
598         address operator,
599         address from,
600         uint256 tokenId,
601         bytes calldata data
602     ) external returns (bytes4);
603 }
604 
605 /**
606  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
607  * including the Metadata extension. Built to optimize for lower gas during batch mints.
608  *
609  * Assumes serials are sequentially minted starting at `_startTokenId()`
610  * (defaults to 0, e.g. 0, 1, 2, 3..).
611  *
612  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
613  *
614  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
615  */
616 contract ERC721A is IERC721A {
617     // Mask of an entry in packed address data.
618     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
619 
620     // The bit position of `numberMinted` in packed address data.
621     uint256 private constant BITPOS_NUMBER_MINTED = 64;
622 
623     // The bit position of `numberBurned` in packed address data.
624     uint256 private constant BITPOS_NUMBER_BURNED = 128;
625 
626     // The bit position of `aux` in packed address data.
627     uint256 private constant BITPOS_AUX = 192;
628 
629     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
630     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
631 
632     // The bit position of `startTimestamp` in packed ownership.
633     uint256 private constant BITPOS_START_TIMESTAMP = 160;
634 
635     // The bit mask of the `burned` bit in packed ownership.
636     uint256 private constant BITMASK_BURNED = 1 << 224;
637 
638     // The bit position of the `nextInitialized` bit in packed ownership.
639     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
640 
641     // The bit mask of the `nextInitialized` bit in packed ownership.
642     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
643 
644     // The bit position of `extraData` in packed ownership.
645     uint256 private constant BITPOS_EXTRA_DATA = 232;
646 
647     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
648     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
649 
650     // The mask of the lower 160 bits for addresses.
651     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
652 
653     // The maximum `quantity` that can be minted with `_mintERC2309`.
654     // This limit is to prevent overflows on the address data entries.
655     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
656     // is required to cause an overflow, which is unrealistic.
657     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
658 
659     // The tokenId of the next token to be minted.
660     uint256 private _currentIndex;
661 
662     // The number of tokens burned.
663     uint256 private _burnCounter;
664 
665     // Token name
666     string private _name;
667 
668     // Token symbol
669     string private _symbol;
670 
671     // Mapping from token ID to ownership details
672     // An empty struct value does not necessarily mean the token is unowned.
673     // See `_packedOwnershipOf` implementation for details.
674     //
675     // Bits Layout:
676     // - [0..159]   `addr`
677     // - [160..223] `startTimestamp`
678     // - [224]      `burned`
679     // - [225]      `nextInitialized`
680     // - [232..255] `extraData`
681     mapping(uint256 => uint256) private _packedOwnerships;
682 
683     // Mapping owner address to address data.
684     //
685     // Bits Layout:
686     // - [0..63]    `balance`
687     // - [64..127]  `numberMinted`
688     // - [128..191] `numberBurned`
689     // - [192..255] `aux`
690     mapping(address => uint256) private _packedAddressData;
691 
692     // Mapping from token ID to approved address.
693     mapping(uint256 => address) private _tokenApprovals;
694 
695     // Mapping from owner to operator approvals
696     mapping(address => mapping(address => bool)) private _operatorApprovals;
697 
698     constructor(string memory name_, string memory symbol_) {
699         _name = name_;
700         _symbol = symbol_;
701         _currentIndex = _startTokenId();
702     }
703 
704     /**
705      * @dev Returns the starting token ID.
706      * To change the starting token ID, please override this function.
707      */
708     function _startTokenId() internal view virtual returns (uint256) {
709         return 0;
710     }
711 
712     /**
713      * @dev Returns the next token ID to be minted.
714      */
715     function _nextTokenId() internal view returns (uint256) {
716         return _currentIndex;
717     }
718 
719     /**
720      * @dev Returns the total number of tokens in existence.
721      * Burned tokens will reduce the count.
722      * To get the total number of tokens minted, please see `_totalMinted`.
723      */
724     function totalSupply() public view override returns (uint256) {
725         // Counter underflow is impossible as _burnCounter cannot be incremented
726         // more than `_currentIndex - _startTokenId()` times.
727         unchecked {
728             return _currentIndex - _burnCounter - _startTokenId();
729         }
730     }
731 
732     /**
733      * @dev Returns the total amount of tokens minted in the contract.
734      */
735     function _totalMinted() internal view returns (uint256) {
736         // Counter underflow is impossible as _currentIndex does not decrement,
737         // and it is initialized to `_startTokenId()`
738         unchecked {
739             return _currentIndex - _startTokenId();
740         }
741     }
742 
743     /**
744      * @dev Returns the total number of tokens burned.
745      */
746     function _totalBurned() internal view returns (uint256) {
747         return _burnCounter;
748     }
749 
750     /**
751      * @dev See {IERC165-supportsInterface}.
752      */
753     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
754         // The interface IDs are constants representing the first 4 bytes of the XOR of
755         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
756         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
757         return
758             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
759             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
760             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
761     }
762 
763     /**
764      * @dev See {IERC721-balanceOf}.
765      */
766     function balanceOf(address owner) public view override returns (uint256) {
767         if (owner == address(0)) revert BalanceQueryForZeroAddress();
768         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
769     }
770 
771     /**
772      * Returns the number of tokens minted by `owner`.
773      */
774     function _numberMinted(address owner) internal view returns (uint256) {
775         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
776     }
777 
778     /**
779      * Returns the number of tokens burned by or on behalf of `owner`.
780      */
781     function _numberBurned(address owner) internal view returns (uint256) {
782         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
783     }
784 
785     /**
786      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
787      */
788     function _getAux(address owner) internal view returns (uint64) {
789         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
790     }
791 
792     /**
793      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
794      * If there are multiple variables, please pack them into a uint64.
795      */
796     function _setAux(address owner, uint64 aux) internal {
797         uint256 packed = _packedAddressData[owner];
798         uint256 auxCasted;
799         // Cast `aux` with assembly to avoid redundant masking.
800         assembly {
801             auxCasted := aux
802         }
803         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
804         _packedAddressData[owner] = packed;
805     }
806 
807     /**
808      * Returns the packed ownership data of `tokenId`.
809      */
810     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
811         uint256 curr = tokenId;
812 
813         unchecked {
814             if (_startTokenId() <= curr)
815                 if (curr < _currentIndex) {
816                     uint256 packed = _packedOwnerships[curr];
817                     // If not burned.
818                     if (packed & BITMASK_BURNED == 0) {
819                         // Invariant:
820                         // There will always be an ownership that has an address and is not burned
821                         // before an ownership that does not have an address and is not burned.
822                         // Hence, curr will not underflow.
823                         //
824                         // We can directly compare the packed value.
825                         // If the address is zero, packed is zero.
826                         while (packed == 0) {
827                             packed = _packedOwnerships[--curr];
828                         }
829                         return packed;
830                     }
831                 }
832         }
833         revert OwnerQueryForNonexistentToken();
834     }
835 
836     /**
837      * Returns the unpacked `TokenOwnership` struct from `packed`.
838      */
839     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
840         ownership.addr = address(uint160(packed));
841         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
842         ownership.burned = packed & BITMASK_BURNED != 0;
843         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
844     }
845 
846     /**
847      * Returns the unpacked `TokenOwnership` struct at `index`.
848      */
849     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
850         return _unpackedOwnership(_packedOwnerships[index]);
851     }
852 
853     /**
854      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
855      */
856     function _initializeOwnershipAt(uint256 index) internal {
857         if (_packedOwnerships[index] == 0) {
858             _packedOwnerships[index] = _packedOwnershipOf(index);
859         }
860     }
861 
862     /**
863      * Gas spent here starts off proportional to the maximum mint batch size.
864      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
865      */
866     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
867         return _unpackedOwnership(_packedOwnershipOf(tokenId));
868     }
869 
870     /**
871      * @dev Packs ownership data into a single uint256.
872      */
873     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
874         assembly {
875             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
876             owner := and(owner, BITMASK_ADDRESS)
877             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
878             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
879         }
880     }
881 
882     /**
883      * @dev See {IERC721-ownerOf}.
884      */
885     function ownerOf(uint256 tokenId) public view override returns (address) {
886         return address(uint160(_packedOwnershipOf(tokenId)));
887     }
888 
889     /**
890      * @dev See {IERC721Metadata-name}.
891      */
892     function name() public view virtual override returns (string memory) {
893         return _name;
894     }
895 
896     /**
897      * @dev See {IERC721Metadata-symbol}.
898      */
899     function symbol() public view virtual override returns (string memory) {
900         return _symbol;
901     }
902 
903     /**
904      * @dev See {IERC721Metadata-tokenURI}.
905      */
906     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
907         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
908 
909         string memory baseURI = _baseURI();
910         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
911     }
912 
913     /**
914      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
915      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
916      * by default, it can be overridden in child contracts.
917      */
918     function _baseURI() internal view virtual returns (string memory) {
919         return '';
920     }
921 
922     /**
923      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
924      */
925     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
926         // For branchless setting of the `nextInitialized` flag.
927         assembly {
928             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
929             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
930         }
931     }
932 
933     /**
934      * @dev See {IERC721-approve}.
935      */
936     function approve(address to, uint256 tokenId) public override {
937         address owner = ownerOf(tokenId);
938 
939         if (_msgSenderERC721A() != owner)
940             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
941                 revert ApprovalCallerNotOwnerNorApproved();
942             }
943 
944         _tokenApprovals[tokenId] = to;
945         emit Approval(owner, to, tokenId);
946     }
947 
948     /**
949      * @dev See {IERC721-getApproved}.
950      */
951     function getApproved(uint256 tokenId) public view override returns (address) {
952         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
953 
954         return _tokenApprovals[tokenId];
955     }
956 
957     /**
958      * @dev See {IERC721-setApprovalForAll}.
959      */
960     function setApprovalForAll(address operator, bool approved) public virtual override {
961         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
962 
963         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
964         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
965     }
966 
967     /**
968      * @dev See {IERC721-isApprovedForAll}.
969      */
970     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
971         return _operatorApprovals[owner][operator];
972     }
973 
974     /**
975      * @dev See {IERC721-safeTransferFrom}.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId
981     ) public virtual override {
982         safeTransferFrom(from, to, tokenId, '');
983     }
984 
985     /**
986      * @dev See {IERC721-safeTransferFrom}.
987      */
988     function safeTransferFrom(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) public virtual override {
994         transferFrom(from, to, tokenId);
995         if (to.code.length != 0)
996             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
997                 revert TransferToNonERC721ReceiverImplementer();
998             }
999     }
1000 
1001     /**
1002      * @dev Returns whether `tokenId` exists.
1003      *
1004      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1005      *
1006      * Tokens start existing when they are minted (`_mint`),
1007      */
1008     function _exists(uint256 tokenId) internal view returns (bool) {
1009         return
1010             _startTokenId() <= tokenId &&
1011             tokenId < _currentIndex && // If within bounds,
1012             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1013     }
1014 
1015     /**
1016      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1017      */
1018     function _safeMint(address to, uint256 quantity) internal {
1019         _safeMint(to, quantity, '');
1020     }
1021 
1022     /**
1023      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - If `to` refers to a smart contract, it must implement
1028      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1029      * - `quantity` must be greater than 0.
1030      *
1031      * See {_mint}.
1032      *
1033      * Emits a {Transfer} event for each mint.
1034      */
1035     function _safeMint(
1036         address to,
1037         uint256 quantity,
1038         bytes memory _data
1039     ) internal {
1040         _mint(to, quantity);
1041 
1042         unchecked {
1043             if (to.code.length != 0) {
1044                 uint256 end = _currentIndex;
1045                 uint256 index = end - quantity;
1046                 do {
1047                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1048                         revert TransferToNonERC721ReceiverImplementer();
1049                     }
1050                 } while (index < end);
1051                 // Reentrancy protection.
1052                 if (_currentIndex != end) revert();
1053             }
1054         }
1055     }
1056 
1057     /**
1058      * @dev Mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `quantity` must be greater than 0.
1064      *
1065      * Emits a {Transfer} event for each mint.
1066      */
1067     function _mint(address to, uint256 quantity) internal {
1068         uint256 startTokenId = _currentIndex;
1069         if (to == address(0)) revert MintToZeroAddress();
1070         if (quantity == 0) revert MintZeroQuantity();
1071 
1072         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1073 
1074         // Overflows are incredibly unrealistic.
1075         // `balance` and `numberMinted` have a maximum limit of 2**64.
1076         // `tokenId` has a maximum limit of 2**256.
1077         unchecked {
1078             // Updates:
1079             // - `balance += quantity`.
1080             // - `numberMinted += quantity`.
1081             //
1082             // We can directly add to the `balance` and `numberMinted`.
1083             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1084 
1085             // Updates:
1086             // - `address` to the owner.
1087             // - `startTimestamp` to the timestamp of minting.
1088             // - `burned` to `false`.
1089             // - `nextInitialized` to `quantity == 1`.
1090             _packedOwnerships[startTokenId] = _packOwnershipData(
1091                 to,
1092                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1093             );
1094 
1095             uint256 tokenId = startTokenId;
1096             uint256 end = startTokenId + quantity;
1097             do {
1098                 emit Transfer(address(0), to, tokenId++);
1099             } while (tokenId < end);
1100 
1101             _currentIndex = end;
1102         }
1103         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1104     }
1105 
1106     /**
1107      * @dev Mints `quantity` tokens and transfers them to `to`.
1108      *
1109      * This function is intended for efficient minting only during contract creation.
1110      *
1111      * It emits only one {ConsecutiveTransfer} as defined in
1112      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1113      * instead of a sequence of {Transfer} event(s).
1114      *
1115      * Calling this function outside of contract creation WILL make your contract
1116      * non-compliant with the ERC721 standard.
1117      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1118      * {ConsecutiveTransfer} event is only permissible during contract creation.
1119      *
1120      * Requirements:
1121      *
1122      * - `to` cannot be the zero address.
1123      * - `quantity` must be greater than 0.
1124      *
1125      * Emits a {ConsecutiveTransfer} event.
1126      */
1127     function _mintERC2309(address to, uint256 quantity) internal {
1128         uint256 startTokenId = _currentIndex;
1129         if (to == address(0)) revert MintToZeroAddress();
1130         if (quantity == 0) revert MintZeroQuantity();
1131         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1132 
1133         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1134 
1135         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1136         unchecked {
1137             // Updates:
1138             // - `balance += quantity`.
1139             // - `numberMinted += quantity`.
1140             //
1141             // We can directly add to the `balance` and `numberMinted`.
1142             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1143 
1144             // Updates:
1145             // - `address` to the owner.
1146             // - `startTimestamp` to the timestamp of minting.
1147             // - `burned` to `false`.
1148             // - `nextInitialized` to `quantity == 1`.
1149             _packedOwnerships[startTokenId] = _packOwnershipData(
1150                 to,
1151                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1152             );
1153 
1154             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1155 
1156             _currentIndex = startTokenId + quantity;
1157         }
1158         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1159     }
1160 
1161     /**
1162      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1163      */
1164     function _getApprovedAddress(uint256 tokenId)
1165         private
1166         view
1167         returns (uint256 approvedAddressSlot, address approvedAddress)
1168     {
1169         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1170         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1171         assembly {
1172             // Compute the slot.
1173             mstore(0x00, tokenId)
1174             mstore(0x20, tokenApprovalsPtr.slot)
1175             approvedAddressSlot := keccak256(0x00, 0x40)
1176             // Load the slot's value from storage.
1177             approvedAddress := sload(approvedAddressSlot)
1178         }
1179     }
1180 
1181     /**
1182      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1183      */
1184     function _isOwnerOrApproved(
1185         address approvedAddress,
1186         address from,
1187         address msgSender
1188     ) private pure returns (bool result) {
1189         assembly {
1190             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1191             from := and(from, BITMASK_ADDRESS)
1192             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1193             msgSender := and(msgSender, BITMASK_ADDRESS)
1194             // `msgSender == from || msgSender == approvedAddress`.
1195             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1196         }
1197     }
1198 
1199     /**
1200      * @dev Transfers `tokenId` from `from` to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - `to` cannot be the zero address.
1205      * - `tokenId` token must be owned by `from`.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function transferFrom(
1210         address from,
1211         address to,
1212         uint256 tokenId
1213     ) public virtual override {
1214         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1215 
1216         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1217 
1218         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1219 
1220         // The nested ifs save around 20+ gas over a compound boolean condition.
1221         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1222             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1223 
1224         if (to == address(0)) revert TransferToZeroAddress();
1225 
1226         _beforeTokenTransfers(from, to, tokenId, 1);
1227 
1228         // Clear approvals from the previous owner.
1229         assembly {
1230             if approvedAddress {
1231                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1232                 sstore(approvedAddressSlot, 0)
1233             }
1234         }
1235 
1236         // Underflow of the sender's balance is impossible because we check for
1237         // ownership above and the recipient's balance can't realistically overflow.
1238         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1239         unchecked {
1240             // We can directly increment and decrement the balances.
1241             --_packedAddressData[from]; // Updates: `balance -= 1`.
1242             ++_packedAddressData[to]; // Updates: `balance += 1`.
1243 
1244             // Updates:
1245             // - `address` to the next owner.
1246             // - `startTimestamp` to the timestamp of transfering.
1247             // - `burned` to `false`.
1248             // - `nextInitialized` to `true`.
1249             _packedOwnerships[tokenId] = _packOwnershipData(
1250                 to,
1251                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1252             );
1253 
1254             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1255             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1256                 uint256 nextTokenId = tokenId + 1;
1257                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1258                 if (_packedOwnerships[nextTokenId] == 0) {
1259                     // If the next slot is within bounds.
1260                     if (nextTokenId != _currentIndex) {
1261                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1262                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1263                     }
1264                 }
1265             }
1266         }
1267 
1268         emit Transfer(from, to, tokenId);
1269         _afterTokenTransfers(from, to, tokenId, 1);
1270     }
1271 
1272     /**
1273      * @dev Equivalent to `_burn(tokenId, false)`.
1274      */
1275     function _burn(uint256 tokenId) internal virtual {
1276         _burn(tokenId, false);
1277     }
1278 
1279     /**
1280      * @dev Destroys `tokenId`.
1281      * The approval is cleared when the token is burned.
1282      *
1283      * Requirements:
1284      *
1285      * - `tokenId` must exist.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1290         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1291 
1292         address from = address(uint160(prevOwnershipPacked));
1293 
1294         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1295 
1296         if (approvalCheck) {
1297             // The nested ifs save around 20+ gas over a compound boolean condition.
1298             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1299                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1300         }
1301 
1302         _beforeTokenTransfers(from, address(0), tokenId, 1);
1303 
1304         // Clear approvals from the previous owner.
1305         assembly {
1306             if approvedAddress {
1307                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1308                 sstore(approvedAddressSlot, 0)
1309             }
1310         }
1311 
1312         // Underflow of the sender's balance is impossible because we check for
1313         // ownership above and the recipient's balance can't realistically overflow.
1314         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1315         unchecked {
1316             // Updates:
1317             // - `balance -= 1`.
1318             // - `numberBurned += 1`.
1319             //
1320             // We can directly decrement the balance, and increment the number burned.
1321             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1322             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1323 
1324             // Updates:
1325             // - `address` to the last owner.
1326             // - `startTimestamp` to the timestamp of burning.
1327             // - `burned` to `true`.
1328             // - `nextInitialized` to `true`.
1329             _packedOwnerships[tokenId] = _packOwnershipData(
1330                 from,
1331                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1332             );
1333 
1334             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1335             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1336                 uint256 nextTokenId = tokenId + 1;
1337                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1338                 if (_packedOwnerships[nextTokenId] == 0) {
1339                     // If the next slot is within bounds.
1340                     if (nextTokenId != _currentIndex) {
1341                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1342                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1343                     }
1344                 }
1345             }
1346         }
1347 
1348         emit Transfer(from, address(0), tokenId);
1349         _afterTokenTransfers(from, address(0), tokenId, 1);
1350 
1351         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1352         unchecked {
1353             _burnCounter++;
1354         }
1355     }
1356 
1357     /**
1358      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1359      *
1360      * @param from address representing the previous owner of the given token ID
1361      * @param to target address that will receive the tokens
1362      * @param tokenId uint256 ID of the token to be transferred
1363      * @param _data bytes optional data to send along with the call
1364      * @return bool whether the call correctly returned the expected magic value
1365      */
1366     function _checkContractOnERC721Received(
1367         address from,
1368         address to,
1369         uint256 tokenId,
1370         bytes memory _data
1371     ) private returns (bool) {
1372         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1373             bytes4 retval
1374         ) {
1375             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1376         } catch (bytes memory reason) {
1377             if (reason.length == 0) {
1378                 revert TransferToNonERC721ReceiverImplementer();
1379             } else {
1380                 assembly {
1381                     revert(add(32, reason), mload(reason))
1382                 }
1383             }
1384         }
1385     }
1386 
1387     /**
1388      * @dev Directly sets the extra data for the ownership data `index`.
1389      */
1390     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1391         uint256 packed = _packedOwnerships[index];
1392         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1393         uint256 extraDataCasted;
1394         // Cast `extraData` with assembly to avoid redundant masking.
1395         assembly {
1396             extraDataCasted := extraData
1397         }
1398         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1399         _packedOwnerships[index] = packed;
1400     }
1401 
1402     /**
1403      * @dev Returns the next extra data for the packed ownership data.
1404      * The returned result is shifted into position.
1405      */
1406     function _nextExtraData(
1407         address from,
1408         address to,
1409         uint256 prevOwnershipPacked
1410     ) private view returns (uint256) {
1411         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1412         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1413     }
1414 
1415     /**
1416      * @dev Called during each token transfer to set the 24bit `extraData` field.
1417      * Intended to be overridden by the cosumer contract.
1418      *
1419      * `previousExtraData` - the value of `extraData` before transfer.
1420      *
1421      * Calling conditions:
1422      *
1423      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1424      * transferred to `to`.
1425      * - When `from` is zero, `tokenId` will be minted for `to`.
1426      * - When `to` is zero, `tokenId` will be burned by `from`.
1427      * - `from` and `to` are never both zero.
1428      */
1429     function _extraData(
1430         address from,
1431         address to,
1432         uint24 previousExtraData
1433     ) internal view virtual returns (uint24) {}
1434 
1435     /**
1436      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1437      * This includes minting.
1438      * And also called before burning one token.
1439      *
1440      * startTokenId - the first token id to be transferred
1441      * quantity - the amount to be transferred
1442      *
1443      * Calling conditions:
1444      *
1445      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1446      * transferred to `to`.
1447      * - When `from` is zero, `tokenId` will be minted for `to`.
1448      * - When `to` is zero, `tokenId` will be burned by `from`.
1449      * - `from` and `to` are never both zero.
1450      */
1451     function _beforeTokenTransfers(
1452         address from,
1453         address to,
1454         uint256 startTokenId,
1455         uint256 quantity
1456     ) internal virtual {}
1457 
1458     /**
1459      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1460      * This includes minting.
1461      * And also called after one token has been burned.
1462      *
1463      * startTokenId - the first token id to be transferred
1464      * quantity - the amount to be transferred
1465      *
1466      * Calling conditions:
1467      *
1468      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1469      * transferred to `to`.
1470      * - When `from` is zero, `tokenId` has been minted for `to`.
1471      * - When `to` is zero, `tokenId` has been burned by `from`.
1472      * - `from` and `to` are never both zero.
1473      */
1474     function _afterTokenTransfers(
1475         address from,
1476         address to,
1477         uint256 startTokenId,
1478         uint256 quantity
1479     ) internal virtual {}
1480 
1481     /**
1482      * @dev Returns the message sender (defaults to `msg.sender`).
1483      *
1484      * If you are writing GSN compatible contracts, you need to override this function.
1485      */
1486     function _msgSenderERC721A() internal view virtual returns (address) {
1487         return msg.sender;
1488     }
1489 
1490     /**
1491      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1492      */
1493     function _toString(uint256 value) internal pure returns (string memory ptr) {
1494         assembly {
1495             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1496             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1497             // We will need 1 32-byte word to store the length,
1498             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1499             ptr := add(mload(0x40), 128)
1500             // Update the free memory pointer to allocate.
1501             mstore(0x40, ptr)
1502 
1503             // Cache the end of the memory to calculate the length later.
1504             let end := ptr
1505 
1506             // We write the string from the rightmost digit to the leftmost digit.
1507             // The following is essentially a do-while loop that also handles the zero case.
1508             // Costs a bit more than early returning for the zero case,
1509             // but cheaper in terms of deployment and overall runtime costs.
1510             for {
1511                 // Initialize and perform the first pass without check.
1512                 let temp := value
1513                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1514                 ptr := sub(ptr, 1)
1515                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1516                 mstore8(ptr, add(48, mod(temp, 10)))
1517                 temp := div(temp, 10)
1518             } temp {
1519                 // Keep dividing `temp` until zero.
1520                 temp := div(temp, 10)
1521             } {
1522                 // Body of the for loop.
1523                 ptr := sub(ptr, 1)
1524                 mstore8(ptr, add(48, mod(temp, 10)))
1525             }
1526 
1527             let length := sub(end, ptr)
1528             // Move the pointer 32 bytes leftwards to make room for the length.
1529             ptr := sub(ptr, 32)
1530             // Store the length.
1531             mstore(ptr, length)
1532         }
1533     }
1534 }
1535 
1536 // File: @openzeppelin/contracts/utils/Context.sol
1537 
1538 
1539 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1540 
1541 pragma solidity ^0.8.0;
1542 
1543 /**
1544  * @dev Provides information about the current execution context, including the
1545  * sender of the transaction and its data. While these are generally available
1546  * via msg.sender and msg.data, they should not be accessed in such a direct
1547  * manner, since when dealing with meta-transactions the account sending and
1548  * paying for execution may not be the actual sender (as far as an application
1549  * is concerned).
1550  *
1551  * This contract is only required for intermediate, library-like contracts.
1552  */
1553 abstract contract Context {
1554     function _msgSender() internal view virtual returns (address) {
1555         return msg.sender;
1556     }
1557 
1558     function _msgData() internal view virtual returns (bytes calldata) {
1559         return msg.data;
1560     }
1561 }
1562 
1563 // File: @openzeppelin/contracts/access/Ownable.sol
1564 
1565 
1566 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1567 
1568 pragma solidity ^0.8.0;
1569 
1570 
1571 /**
1572  * @dev Contract module which provides a basic access control mechanism, where
1573  * there is an account (an owner) that can be granted exclusive access to
1574  * specific functions.
1575  *
1576  * By default, the owner account will be the one that deploys the contract. This
1577  * can later be changed with {transferOwnership}.
1578  *
1579  * This module is used through inheritance. It will make available the modifier
1580  * `onlyOwner`, which can be applied to your functions to restrict their use to
1581  * the owner.
1582  */
1583 abstract contract Ownable is Context {
1584     address private _owner;
1585 
1586     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1587 
1588     /**
1589      * @dev Initializes the contract setting the deployer as the initial owner.
1590      */
1591     constructor() {
1592         _transferOwnership(_msgSender());
1593     }
1594 
1595     /**
1596      * @dev Returns the address of the current owner.
1597      */
1598     function owner() public view virtual returns (address) {
1599         return _owner;
1600     }
1601 
1602     /**
1603      * @dev Throws if called by any account other than the owner.
1604      */
1605     modifier onlyOwner() {
1606         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1607         _;
1608     }
1609 
1610     /**
1611      * @dev Leaves the contract without owner. It will not be possible to call
1612      * `onlyOwner` functions anymore. Can only be called by the current owner.
1613      *
1614      * NOTE: Renouncing ownership will leave the contract without an owner,
1615      * thereby removing any functionality that is only available to the owner.
1616      */
1617     function renounceOwnership() public virtual onlyOwner {
1618         _transferOwnership(address(0));
1619     }
1620 
1621     /**
1622      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1623      * Can only be called by the current owner.
1624      */
1625     function transferOwnership(address newOwner) public virtual onlyOwner {
1626         require(newOwner != address(0), "Ownable: new owner is the zero address");
1627         _transferOwnership(newOwner);
1628     }
1629 
1630     /**
1631      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1632      * Internal function without access restriction.
1633      */
1634     function _transferOwnership(address newOwner) internal virtual {
1635         address oldOwner = _owner;
1636         _owner = newOwner;
1637         emit OwnershipTransferred(oldOwner, newOwner);
1638     }
1639 }
1640 
1641 // File: development/CloudyMe.sol
1642 
1643 
1644 pragma solidity ^0.8.7;
1645 
1646 
1647 
1648 
1649 contract CloudyMe is ERC721A, Ownable{
1650     uint256 public MAX_SUPPLY = 5555;
1651     uint256 public FREE_MINT = 2;
1652     uint256 public MINT_LIMIT = 10;
1653     uint256 public MINT_PRICE = 0.0055 ether;
1654     string public baseTokenURI;
1655     bool public isOpenMint = false;
1656     address public signAddress;
1657     mapping(address=>uint256) public mintedAmount;
1658 
1659     constructor(string memory _baseTokenUri,address _signAddress) ERC721A("Cloudy Me", "CM"){
1660         baseTokenURI = _baseTokenUri;
1661         signAddress=_signAddress;
1662     }
1663 
1664     function mint(address to,uint256 amount) external payable{
1665         require(isOpenMint,"Not during open hours");
1666         require(totalSupply() + amount <= MAX_SUPPLY,"Minted completed");
1667         require(mintedAmount[to] + amount <= MINT_LIMIT,"Limit exceeded");
1668         if(mintedAmount[to] >= FREE_MINT){
1669             require(msg.value >= amount * MINT_PRICE,"Not paying enough fees");
1670         }else if(mintedAmount[to] + amount > FREE_MINT){
1671             require(msg.value >= (mintedAmount[to] + amount - FREE_MINT) * MINT_PRICE,"Not paying enough fees");
1672         }
1673         mintedAmount[to]+=amount;
1674         _mint(to,amount);
1675     }
1676 
1677     function wlMint(address to,uint256 amount,bytes memory _singature)external payable{
1678         require(ECDSA.recover(ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(to, amount))),_singature) == signAddress,"You're not on the whitelist");
1679         require(totalSupply() + amount <= MAX_SUPPLY,"Minted completed");
1680         require(mintedAmount[to] + amount <= MINT_LIMIT,"Limit exceeded");
1681         if(mintedAmount[to] >= FREE_MINT){
1682             require(msg.value >= amount * MINT_PRICE,"Not paying enough fees");
1683         }else if(mintedAmount[to] + amount > FREE_MINT){
1684             require(msg.value >= (mintedAmount[to] + amount - FREE_MINT) * MINT_PRICE,"Not paying enough fees");
1685         }
1686         mintedAmount[to]+=amount;
1687         _mint(to,amount);
1688     }
1689 
1690     function ownerMint(address to ,uint256 amount)external onlyOwner{
1691         require(amount + totalSupply() <= MAX_SUPPLY, "Minted completed");
1692         _mint(to,amount);
1693     }
1694 
1695     function setFreeMint(uint256 _freeMint)external onlyOwner{
1696         FREE_MINT=_freeMint;
1697     }
1698 
1699     function setOpenMint(bool _isOpenMint) external onlyOwner{
1700         isOpenMint = _isOpenMint;
1701     }
1702 
1703     function setMaxSupply(uint256 _MAX_SUPPLY)external onlyOwner{
1704         MAX_SUPPLY=_MAX_SUPPLY;
1705     }
1706 
1707     function setSignedAddress(address _signAddress)external onlyOwner{
1708          signAddress=_signAddress;
1709     }
1710 
1711     function setBaseTokenURI(string calldata _uri) external onlyOwner {
1712         baseTokenURI = _uri;
1713     }
1714 
1715     function withdrawMoney() external onlyOwner{
1716         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1717         require(success, "Transfer failed.");
1718     }
1719 
1720     function _baseURI() internal override view returns (string memory) {
1721         return baseTokenURI;
1722     }
1723 
1724     function tokenURI(uint256 tokenId) public view override returns (string memory)
1725 	{
1726         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1727         string memory baseURI = _baseURI();
1728         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
1729 	}
1730 
1731     function _startTokenId() internal pure override returns (uint256) {
1732         return 1;
1733     }
1734 }