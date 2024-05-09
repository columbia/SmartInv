1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 
125 /**
126  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
127  *
128  * These functions can be used to verify that a message was signed by the holder
129  * of the private keys of a given address.
130  */
131 library ECDSA {
132     enum RecoverError {
133         NoError,
134         InvalidSignature,
135         InvalidSignatureLength,
136         InvalidSignatureS,
137         InvalidSignatureV
138     }
139 
140     function _throwError(RecoverError error) private pure {
141         if (error == RecoverError.NoError) {
142             return; // no error: do nothing
143         } else if (error == RecoverError.InvalidSignature) {
144             revert("ECDSA: invalid signature");
145         } else if (error == RecoverError.InvalidSignatureLength) {
146             revert("ECDSA: invalid signature length");
147         } else if (error == RecoverError.InvalidSignatureS) {
148             revert("ECDSA: invalid signature 's' value");
149         } else if (error == RecoverError.InvalidSignatureV) {
150             revert("ECDSA: invalid signature 'v' value");
151         }
152     }
153 
154     /**
155      * @dev Returns the address that signed a hashed message (`hash`) with
156      * `signature` or error string. This address can then be used for verification purposes.
157      *
158      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
159      * this function rejects them by requiring the `s` value to be in the lower
160      * half order, and the `v` value to be either 27 or 28.
161      *
162      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
163      * verification to be secure: it is possible to craft signatures that
164      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
165      * this is by receiving a hash of the original message (which may otherwise
166      * be too long), and then calling {toEthSignedMessageHash} on it.
167      *
168      * Documentation for signature generation:
169      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
170      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
171      *
172      * _Available since v4.3._
173      */
174     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
175         // Check the signature length
176         // - case 65: r,s,v signature (standard)
177         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
178         if (signature.length == 65) {
179             bytes32 r;
180             bytes32 s;
181             uint8 v;
182             // ecrecover takes the signature parameters, and the only way to get them
183             // currently is to use assembly.
184             assembly {
185                 r := mload(add(signature, 0x20))
186                 s := mload(add(signature, 0x40))
187                 v := byte(0, mload(add(signature, 0x60)))
188             }
189             return tryRecover(hash, v, r, s);
190         } else if (signature.length == 64) {
191             bytes32 r;
192             bytes32 vs;
193             // ecrecover takes the signature parameters, and the only way to get them
194             // currently is to use assembly.
195             assembly {
196                 r := mload(add(signature, 0x20))
197                 vs := mload(add(signature, 0x40))
198             }
199             return tryRecover(hash, r, vs);
200         } else {
201             return (address(0), RecoverError.InvalidSignatureLength);
202         }
203     }
204 
205     /**
206      * @dev Returns the address that signed a hashed message (`hash`) with
207      * `signature`. This address can then be used for verification purposes.
208      *
209      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
210      * this function rejects them by requiring the `s` value to be in the lower
211      * half order, and the `v` value to be either 27 or 28.
212      *
213      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
214      * verification to be secure: it is possible to craft signatures that
215      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
216      * this is by receiving a hash of the original message (which may otherwise
217      * be too long), and then calling {toEthSignedMessageHash} on it.
218      */
219     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
220         (address recovered, RecoverError error) = tryRecover(hash, signature);
221         _throwError(error);
222         return recovered;
223     }
224 
225     /**
226      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
227      *
228      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
229      *
230      * _Available since v4.3._
231      */
232     function tryRecover(
233         bytes32 hash,
234         bytes32 r,
235         bytes32 vs
236     ) internal pure returns (address, RecoverError) {
237         bytes32 s;
238         uint8 v;
239         assembly {
240             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
241             v := add(shr(255, vs), 27)
242         }
243         return tryRecover(hash, v, r, s);
244     }
245 
246     /**
247      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
248      *
249      * _Available since v4.2._
250      */
251     function recover(
252         bytes32 hash,
253         bytes32 r,
254         bytes32 vs
255     ) internal pure returns (address) {
256         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
257         _throwError(error);
258         return recovered;
259     }
260 
261     /**
262      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
263      * `r` and `s` signature fields separately.
264      *
265      * _Available since v4.3._
266      */
267     function tryRecover(
268         bytes32 hash,
269         uint8 v,
270         bytes32 r,
271         bytes32 s
272     ) internal pure returns (address, RecoverError) {
273         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
274         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
275         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
276         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
277         //
278         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
279         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
280         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
281         // these malleable signatures as well.
282         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
283             return (address(0), RecoverError.InvalidSignatureS);
284         }
285         if (v != 27 && v != 28) {
286             return (address(0), RecoverError.InvalidSignatureV);
287         }
288 
289         // If the signature is valid (and not malleable), return the signer address
290         address signer = ecrecover(hash, v, r, s);
291         if (signer == address(0)) {
292             return (address(0), RecoverError.InvalidSignature);
293         }
294 
295         return (signer, RecoverError.NoError);
296     }
297 
298     /**
299      * @dev Overload of {ECDSA-recover} that receives the `v`,
300      * `r` and `s` signature fields separately.
301      */
302     function recover(
303         bytes32 hash,
304         uint8 v,
305         bytes32 r,
306         bytes32 s
307     ) internal pure returns (address) {
308         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
309         _throwError(error);
310         return recovered;
311     }
312 
313     /**
314      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
315      * produces hash corresponding to the one signed with the
316      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
317      * JSON-RPC method as part of EIP-191.
318      *
319      * See {recover}.
320      */
321     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
322         // 32 is the length in bytes of hash,
323         // enforced by the type signature above
324         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
325     }
326 
327     /**
328      * @dev Returns an Ethereum Signed Message, created from `s`. This
329      * produces hash corresponding to the one signed with the
330      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
331      * JSON-RPC method as part of EIP-191.
332      *
333      * See {recover}.
334      */
335     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
336         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
337     }
338 
339     /**
340      * @dev Returns an Ethereum Signed Typed Data, created from a
341      * `domainSeparator` and a `structHash`. This produces hash corresponding
342      * to the one signed with the
343      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
344      * JSON-RPC method as part of EIP-712.
345      *
346      * See {recover}.
347      */
348     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
349         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
350     }
351 }
352 
353 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @title ERC721 token receiver interface
362  * @dev Interface for any contract that wants to support safeTransfers
363  * from ERC721 asset contracts.
364  */
365 interface IERC721Receiver {
366     /**
367      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
368      * by `operator` from `from`, this function is called.
369      *
370      * It must return its Solidity selector to confirm the token transfer.
371      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
372      *
373      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
374      */
375     function onERC721Received(
376         address operator,
377         address from,
378         uint256 tokenId,
379         bytes calldata data
380     ) external returns (bytes4);
381 }
382 
383 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 /**
391  * @dev Interface of the ERC165 standard, as defined in the
392  * https://eips.ethereum.org/EIPS/eip-165[EIP].
393  *
394  * Implementers can declare support of contract interfaces, which can then be
395  * queried by others ({ERC165Checker}).
396  *
397  * For an implementation, see {ERC165}.
398  */
399 interface IERC165 {
400     /**
401      * @dev Returns true if this contract implements the interface defined by
402      * `interfaceId`. See the corresponding
403      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
404      * to learn more about how these ids are created.
405      *
406      * This function call must use less than 30 000 gas.
407      */
408     function supportsInterface(bytes4 interfaceId) external view returns (bool);
409 }
410 
411 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
412 
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
444 
445 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 
450 /**
451  * @dev Required interface of an ERC721 compliant contract.
452  */
453 interface IERC721 is IERC165 {
454     /**
455      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
456      */
457     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
458 
459     /**
460      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
461      */
462     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
463 
464     /**
465      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
466      */
467     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
468 
469     /**
470      * @dev Returns the number of tokens in ``owner``'s account.
471      */
472     function balanceOf(address owner) external view returns (uint256 balance);
473 
474     /**
475      * @dev Returns the owner of the `tokenId` token.
476      *
477      * Requirements:
478      *
479      * - `tokenId` must exist.
480      */
481     function ownerOf(uint256 tokenId) external view returns (address owner);
482 
483     /**
484      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
485      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must exist and be owned by `from`.
492      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
493      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
494      *
495      * Emits a {Transfer} event.
496      */
497     function safeTransferFrom(
498         address from,
499         address to,
500         uint256 tokenId
501     ) external;
502 
503     /**
504      * @dev Transfers `tokenId` token from `from` to `to`.
505      *
506      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
507      *
508      * Requirements:
509      *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512      * - `tokenId` token must be owned by `from`.
513      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
514      *
515      * Emits a {Transfer} event.
516      */
517     function transferFrom(
518         address from,
519         address to,
520         uint256 tokenId
521     ) external;
522 
523     /**
524      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
525      * The approval is cleared when the token is transferred.
526      *
527      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
528      *
529      * Requirements:
530      *
531      * - The caller must own the token or be an approved operator.
532      * - `tokenId` must exist.
533      *
534      * Emits an {Approval} event.
535      */
536     function approve(address to, uint256 tokenId) external;
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
548      * @dev Approve or remove `operator` as an operator for the caller.
549      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
550      *
551      * Requirements:
552      *
553      * - The `operator` cannot be the caller.
554      *
555      * Emits an {ApprovalForAll} event.
556      */
557     function setApprovalForAll(address operator, bool _approved) external;
558 
559     /**
560      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
561      *
562      * See {setApprovalForAll}
563      */
564     function isApprovedForAll(address owner, address operator) external view returns (bool);
565 
566     /**
567      * @dev Safely transfers `tokenId` token from `from` to `to`.
568      *
569      * Requirements:
570      *
571      * - `from` cannot be the zero address.
572      * - `to` cannot be the zero address.
573      * - `tokenId` token must exist and be owned by `from`.
574      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
575      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
576      *
577      * Emits a {Transfer} event.
578      */
579     function safeTransferFrom(
580         address from,
581         address to,
582         uint256 tokenId,
583         bytes calldata data
584     ) external;
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
597  * @dev See https://eips.ethereum.org/EIPS/eip-721
598  */
599 interface IERC721Metadata is IERC721 {
600     /**
601      * @dev Returns the token collection name.
602      */
603     function name() external view returns (string memory);
604 
605     /**
606      * @dev Returns the token collection symbol.
607      */
608     function symbol() external view returns (string memory);
609 
610     /**
611      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
612      */
613     function tokenURI(uint256 tokenId) external view returns (string memory);
614 }
615 
616 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 /**
624  * @dev Contract module that helps prevent reentrant calls to a function.
625  *
626  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
627  * available, which can be applied to functions to make sure there are no nested
628  * (reentrant) calls to them.
629  *
630  * Note that because there is a single `nonReentrant` guard, functions marked as
631  * `nonReentrant` may not call one another. This can be worked around by making
632  * those functions `private`, and then adding `external` `nonReentrant` entry
633  * points to them.
634  *
635  * TIP: If you would like to learn more about reentrancy and alternative ways
636  * to protect against it, check out our blog post
637  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
638  */
639 abstract contract ReentrancyGuard {
640     // Booleans are more expensive than uint256 or any type that takes up a full
641     // word because each write operation emits an extra SLOAD to first read the
642     // slot's contents, replace the bits taken up by the boolean, and then write
643     // back. This is the compiler's defense against contract upgrades and
644     // pointer aliasing, and it cannot be disabled.
645 
646     // The values being non-zero value makes deployment a bit more expensive,
647     // but in exchange the refund on every call to nonReentrant will be lower in
648     // amount. Since refunds are capped to a percentage of the total
649     // transaction's gas, it is best to keep them low in cases like this one, to
650     // increase the likelihood of the full refund coming into effect.
651     uint256 private constant _NOT_ENTERED = 1;
652     uint256 private constant _ENTERED = 2;
653 
654     uint256 private _status;
655 
656     constructor() {
657         _status = _NOT_ENTERED;
658     }
659 
660     /**
661      * @dev Prevents a contract from calling itself, directly or indirectly.
662      * Calling a `nonReentrant` function from another `nonReentrant`
663      * function is not supported. It is possible to prevent this from happening
664      * by making the `nonReentrant` function external, and making it call a
665      * `private` function that does the actual work.
666      */
667     modifier nonReentrant() {
668         // On the first call to nonReentrant, _notEntered will be true
669         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
670 
671         // Any calls to nonReentrant after this point will fail
672         _status = _ENTERED;
673 
674         _;
675 
676         // By storing the original value once again, a refund is triggered (see
677         // https://eips.ethereum.org/EIPS/eip-2200)
678         _status = _NOT_ENTERED;
679     }
680 }
681 
682 // File: @openzeppelin/contracts/utils/Address.sol
683 
684 
685 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 /**
690  * @dev Collection of functions related to the address type
691  */
692 library Address {
693     /**
694      * @dev Returns true if `account` is a contract.
695      *
696      * [IMPORTANT]
697      * ====
698      * It is unsafe to assume that an address for which this function returns
699      * false is an externally-owned account (EOA) and not a contract.
700      *
701      * Among others, `isContract` will return false for the following
702      * types of addresses:
703      *
704      *  - an externally-owned account
705      *  - a contract in construction
706      *  - an address where a contract will be created
707      *  - an address where a contract lived, but was destroyed
708      * ====
709      */
710     function isContract(address account) internal view returns (bool) {
711         // This method relies on extcodesize, which returns 0 for contracts in
712         // construction, since the code is only stored at the end of the
713         // constructor execution.
714 
715         uint256 size;
716         assembly {
717             size := extcodesize(account)
718         }
719         return size > 0;
720     }
721 
722     /**
723      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
724      * `recipient`, forwarding all available gas and reverting on errors.
725      *
726      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
727      * of certain opcodes, possibly making contracts go over the 2300 gas limit
728      * imposed by `transfer`, making them unable to receive funds via
729      * `transfer`. {sendValue} removes this limitation.
730      *
731      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
732      *
733      * IMPORTANT: because control is transferred to `recipient`, care must be
734      * taken to not create reentrancy vulnerabilities. Consider using
735      * {ReentrancyGuard} or the
736      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
737      */
738     function sendValue(address payable recipient, uint256 amount) internal {
739         require(address(this).balance >= amount, "Address: insufficient balance");
740 
741         (bool success, ) = recipient.call{value: amount}("");
742         require(success, "Address: unable to send value, recipient may have reverted");
743     }
744 
745     /**
746      * @dev Performs a Solidity function call using a low level `call`. A
747      * plain `call` is an unsafe replacement for a function call: use this
748      * function instead.
749      *
750      * If `target` reverts with a revert reason, it is bubbled up by this
751      * function (like regular Solidity function calls).
752      *
753      * Returns the raw returned data. To convert to the expected return value,
754      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
755      *
756      * Requirements:
757      *
758      * - `target` must be a contract.
759      * - calling `target` with `data` must not revert.
760      *
761      * _Available since v3.1._
762      */
763     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
764         return functionCall(target, data, "Address: low-level call failed");
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
769      * `errorMessage` as a fallback revert reason when `target` reverts.
770      *
771      * _Available since v3.1._
772      */
773     function functionCall(
774         address target,
775         bytes memory data,
776         string memory errorMessage
777     ) internal returns (bytes memory) {
778         return functionCallWithValue(target, data, 0, errorMessage);
779     }
780 
781     /**
782      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
783      * but also transferring `value` wei to `target`.
784      *
785      * Requirements:
786      *
787      * - the calling contract must have an ETH balance of at least `value`.
788      * - the called Solidity function must be `payable`.
789      *
790      * _Available since v3.1._
791      */
792     function functionCallWithValue(
793         address target,
794         bytes memory data,
795         uint256 value
796     ) internal returns (bytes memory) {
797         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
802      * with `errorMessage` as a fallback revert reason when `target` reverts.
803      *
804      * _Available since v3.1._
805      */
806     function functionCallWithValue(
807         address target,
808         bytes memory data,
809         uint256 value,
810         string memory errorMessage
811     ) internal returns (bytes memory) {
812         require(address(this).balance >= value, "Address: insufficient balance for call");
813         require(isContract(target), "Address: call to non-contract");
814 
815         (bool success, bytes memory returndata) = target.call{value: value}(data);
816         return verifyCallResult(success, returndata, errorMessage);
817     }
818 
819     /**
820      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
821      * but performing a static call.
822      *
823      * _Available since v3.3._
824      */
825     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
826         return functionStaticCall(target, data, "Address: low-level static call failed");
827     }
828 
829     /**
830      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
831      * but performing a static call.
832      *
833      * _Available since v3.3._
834      */
835     function functionStaticCall(
836         address target,
837         bytes memory data,
838         string memory errorMessage
839     ) internal view returns (bytes memory) {
840         require(isContract(target), "Address: static call to non-contract");
841 
842         (bool success, bytes memory returndata) = target.staticcall(data);
843         return verifyCallResult(success, returndata, errorMessage);
844     }
845 
846     /**
847      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
848      * but performing a delegate call.
849      *
850      * _Available since v3.4._
851      */
852     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
853         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
854     }
855 
856     /**
857      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
858      * but performing a delegate call.
859      *
860      * _Available since v3.4._
861      */
862     function functionDelegateCall(
863         address target,
864         bytes memory data,
865         string memory errorMessage
866     ) internal returns (bytes memory) {
867         require(isContract(target), "Address: delegate call to non-contract");
868 
869         (bool success, bytes memory returndata) = target.delegatecall(data);
870         return verifyCallResult(success, returndata, errorMessage);
871     }
872 
873     /**
874      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
875      * revert reason using the provided one.
876      *
877      * _Available since v4.3._
878      */
879     function verifyCallResult(
880         bool success,
881         bytes memory returndata,
882         string memory errorMessage
883     ) internal pure returns (bytes memory) {
884         if (success) {
885             return returndata;
886         } else {
887             // Look for revert reason and bubble it up if present
888             if (returndata.length > 0) {
889                 // The easiest way to bubble the revert reason is using memory via assembly
890 
891                 assembly {
892                     let returndata_size := mload(returndata)
893                     revert(add(32, returndata), returndata_size)
894                 }
895             } else {
896                 revert(errorMessage);
897             }
898         }
899     }
900 }
901 
902 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
903 
904 
905 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
906 
907 pragma solidity ^0.8.0;
908 
909 /**
910  * @dev Interface of the ERC20 standard as defined in the EIP.
911  */
912 interface IERC20 {
913     /**
914      * @dev Returns the amount of tokens in existence.
915      */
916     function totalSupply() external view returns (uint256);
917 
918     /**
919      * @dev Returns the amount of tokens owned by `account`.
920      */
921     function balanceOf(address account) external view returns (uint256);
922 
923     /**
924      * @dev Moves `amount` tokens from the caller's account to `recipient`.
925      *
926      * Returns a boolean value indicating whether the operation succeeded.
927      *
928      * Emits a {Transfer} event.
929      */
930     function transfer(address recipient, uint256 amount) external returns (bool);
931 
932     /**
933      * @dev Returns the remaining number of tokens that `spender` will be
934      * allowed to spend on behalf of `owner` through {transferFrom}. This is
935      * zero by default.
936      *
937      * This value changes when {approve} or {transferFrom} are called.
938      */
939     function allowance(address owner, address spender) external view returns (uint256);
940 
941     /**
942      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
943      *
944      * Returns a boolean value indicating whether the operation succeeded.
945      *
946      * IMPORTANT: Beware that changing an allowance with this method brings the risk
947      * that someone may use both the old and the new allowance by unfortunate
948      * transaction ordering. One possible solution to mitigate this race
949      * condition is to first reduce the spender's allowance to 0 and set the
950      * desired value afterwards:
951      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
952      *
953      * Emits an {Approval} event.
954      */
955     function approve(address spender, uint256 amount) external returns (bool);
956 
957     /**
958      * @dev Moves `amount` tokens from `sender` to `recipient` using the
959      * allowance mechanism. `amount` is then deducted from the caller's
960      * allowance.
961      *
962      * Returns a boolean value indicating whether the operation succeeded.
963      *
964      * Emits a {Transfer} event.
965      */
966     function transferFrom(
967         address sender,
968         address recipient,
969         uint256 amount
970     ) external returns (bool);
971 
972     /**
973      * @dev Emitted when `value` tokens are moved from one account (`from`) to
974      * another (`to`).
975      *
976      * Note that `value` may be zero.
977      */
978     event Transfer(address indexed from, address indexed to, uint256 value);
979 
980     /**
981      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
982      * a call to {approve}. `value` is the new allowance.
983      */
984     event Approval(address indexed owner, address indexed spender, uint256 value);
985 }
986 
987 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
988 
989 
990 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
991 
992 pragma solidity ^0.8.0;
993 
994 
995 
996 /**
997  * @title SafeERC20
998  * @dev Wrappers around ERC20 operations that throw on failure (when the token
999  * contract returns false). Tokens that return no value (and instead revert or
1000  * throw on failure) are also supported, non-reverting calls are assumed to be
1001  * successful.
1002  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1003  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1004  */
1005 library SafeERC20 {
1006     using Address for address;
1007 
1008     function safeTransfer(
1009         IERC20 token,
1010         address to,
1011         uint256 value
1012     ) internal {
1013         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1014     }
1015 
1016     function safeTransferFrom(
1017         IERC20 token,
1018         address from,
1019         address to,
1020         uint256 value
1021     ) internal {
1022         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1023     }
1024 
1025     /**
1026      * @dev Deprecated. This function has issues similar to the ones found in
1027      * {IERC20-approve}, and its usage is discouraged.
1028      *
1029      * Whenever possible, use {safeIncreaseAllowance} and
1030      * {safeDecreaseAllowance} instead.
1031      */
1032     function safeApprove(
1033         IERC20 token,
1034         address spender,
1035         uint256 value
1036     ) internal {
1037         // safeApprove should only be called when setting an initial allowance,
1038         // or when resetting it to zero. To increase and decrease it, use
1039         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1040         require(
1041             (value == 0) || (token.allowance(address(this), spender) == 0),
1042             "SafeERC20: approve from non-zero to non-zero allowance"
1043         );
1044         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1045     }
1046 
1047     function safeIncreaseAllowance(
1048         IERC20 token,
1049         address spender,
1050         uint256 value
1051     ) internal {
1052         uint256 newAllowance = token.allowance(address(this), spender) + value;
1053         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1054     }
1055 
1056     function safeDecreaseAllowance(
1057         IERC20 token,
1058         address spender,
1059         uint256 value
1060     ) internal {
1061         unchecked {
1062             uint256 oldAllowance = token.allowance(address(this), spender);
1063             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1064             uint256 newAllowance = oldAllowance - value;
1065             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1066         }
1067     }
1068 
1069     /**
1070      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1071      * on the return value: the return value is optional (but if data is returned, it must not be false).
1072      * @param token The token targeted by the call.
1073      * @param data The call data (encoded using abi.encode or one of its variants).
1074      */
1075     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1076         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1077         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1078         // the target address contains contract code and also asserts for success in the low-level call.
1079 
1080         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1081         if (returndata.length > 0) {
1082             // Return data is optional
1083             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1084         }
1085     }
1086 }
1087 
1088 // File: @openzeppelin/contracts/utils/Context.sol
1089 
1090 
1091 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 /**
1096  * @dev Provides information about the current execution context, including the
1097  * sender of the transaction and its data. While these are generally available
1098  * via msg.sender and msg.data, they should not be accessed in such a direct
1099  * manner, since when dealing with meta-transactions the account sending and
1100  * paying for execution may not be the actual sender (as far as an application
1101  * is concerned).
1102  *
1103  * This contract is only required for intermediate, library-like contracts.
1104  */
1105 abstract contract Context {
1106     function _msgSender() internal view virtual returns (address) {
1107         return msg.sender;
1108     }
1109 
1110     function _msgData() internal view virtual returns (bytes calldata) {
1111         return msg.data;
1112     }
1113 }
1114 
1115 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1116 
1117 
1118 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 
1123 
1124 
1125 
1126 
1127 
1128 
1129 /**
1130  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1131  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1132  * {ERC721Enumerable}.
1133  */
1134 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1135     using Address for address;
1136     using Strings for uint256;
1137 
1138     // Token name
1139     string private _name;
1140 
1141     // Token symbol
1142     string private _symbol;
1143 
1144     // Mapping from token ID to owner address
1145     mapping(uint256 => address) private _owners;
1146 
1147     // Mapping owner address to token count
1148     mapping(address => uint256) private _balances;
1149 
1150     // Mapping from token ID to approved address
1151     mapping(uint256 => address) private _tokenApprovals;
1152 
1153     // Mapping from owner to operator approvals
1154     mapping(address => mapping(address => bool)) private _operatorApprovals;
1155 
1156     /**
1157      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1158      */
1159     constructor(string memory name_, string memory symbol_) {
1160         _name = name_;
1161         _symbol = symbol_;
1162     }
1163 
1164     /**
1165      * @dev See {IERC165-supportsInterface}.
1166      */
1167     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1168         return
1169             interfaceId == type(IERC721).interfaceId ||
1170             interfaceId == type(IERC721Metadata).interfaceId ||
1171             super.supportsInterface(interfaceId);
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-balanceOf}.
1176      */
1177     function balanceOf(address owner) public view virtual override returns (uint256) {
1178         require(owner != address(0), "ERC721: balance query for the zero address");
1179         return _balances[owner];
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-ownerOf}.
1184      */
1185     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1186         address owner = _owners[tokenId];
1187         require(owner != address(0), "ERC721: owner query for nonexistent token");
1188         return owner;
1189     }
1190 
1191     /**
1192      * @dev See {IERC721Metadata-name}.
1193      */
1194     function name() public view virtual override returns (string memory) {
1195         return _name;
1196     }
1197 
1198     /**
1199      * @dev See {IERC721Metadata-symbol}.
1200      */
1201     function symbol() public view virtual override returns (string memory) {
1202         return _symbol;
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Metadata-tokenURI}.
1207      */
1208     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1209         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1210 
1211         string memory baseURI = _baseURI();
1212         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1213     }
1214 
1215     /**
1216      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1217      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1218      * by default, can be overriden in child contracts.
1219      */
1220     function _baseURI() internal view virtual returns (string memory) {
1221         return "";
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-approve}.
1226      */
1227     function approve(address to, uint256 tokenId) public virtual override {
1228         address owner = ERC721.ownerOf(tokenId);
1229         require(to != owner, "ERC721: approval to current owner");
1230 
1231         require(
1232             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1233             "ERC721: approve caller is not owner nor approved for all"
1234         );
1235 
1236         _approve(to, tokenId);
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-getApproved}.
1241      */
1242     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1243         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1244 
1245         return _tokenApprovals[tokenId];
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-setApprovalForAll}.
1250      */
1251     function setApprovalForAll(address operator, bool approved) public virtual override {
1252         _setApprovalForAll(_msgSender(), operator, approved);
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-isApprovedForAll}.
1257      */
1258     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1259         return _operatorApprovals[owner][operator];
1260     }
1261 
1262     /**
1263      * @dev See {IERC721-transferFrom}.
1264      */
1265     function transferFrom(
1266         address from,
1267         address to,
1268         uint256 tokenId
1269     ) public virtual override {
1270         //solhint-disable-next-line max-line-length
1271         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1272 
1273         _transfer(from, to, tokenId);
1274     }
1275 
1276     /**
1277      * @dev See {IERC721-safeTransferFrom}.
1278      */
1279     function safeTransferFrom(
1280         address from,
1281         address to,
1282         uint256 tokenId
1283     ) public virtual override {
1284         safeTransferFrom(from, to, tokenId, "");
1285     }
1286 
1287     /**
1288      * @dev See {IERC721-safeTransferFrom}.
1289      */
1290     function safeTransferFrom(
1291         address from,
1292         address to,
1293         uint256 tokenId,
1294         bytes memory _data
1295     ) public virtual override {
1296         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1297         _safeTransfer(from, to, tokenId, _data);
1298     }
1299 
1300     /**
1301      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1302      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1303      *
1304      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1305      *
1306      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1307      * implement alternative mechanisms to perform token transfer, such as signature-based.
1308      *
1309      * Requirements:
1310      *
1311      * - `from` cannot be the zero address.
1312      * - `to` cannot be the zero address.
1313      * - `tokenId` token must exist and be owned by `from`.
1314      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1315      *
1316      * Emits a {Transfer} event.
1317      */
1318     function _safeTransfer(
1319         address from,
1320         address to,
1321         uint256 tokenId,
1322         bytes memory _data
1323     ) internal virtual {
1324         _transfer(from, to, tokenId);
1325         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1326     }
1327 
1328     /**
1329      * @dev Returns whether `tokenId` exists.
1330      *
1331      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1332      *
1333      * Tokens start existing when they are minted (`_mint`),
1334      * and stop existing when they are burned (`_burn`).
1335      */
1336     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1337         return _owners[tokenId] != address(0);
1338     }
1339 
1340     /**
1341      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1342      *
1343      * Requirements:
1344      *
1345      * - `tokenId` must exist.
1346      */
1347     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1348         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1349         address owner = ERC721.ownerOf(tokenId);
1350         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1351     }
1352 
1353     /**
1354      * @dev Safely mints `tokenId` and transfers it to `to`.
1355      *
1356      * Requirements:
1357      *
1358      * - `tokenId` must not exist.
1359      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1360      *
1361      * Emits a {Transfer} event.
1362      */
1363     function _safeMint(address to, uint256 tokenId) internal virtual {
1364         _safeMint(to, tokenId, "");
1365     }
1366 
1367     /**
1368      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1369      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1370      */
1371     function _safeMint(
1372         address to,
1373         uint256 tokenId,
1374         bytes memory _data
1375     ) internal virtual {
1376         _mint(to, tokenId);
1377         require(
1378             _checkOnERC721Received(address(0), to, tokenId, _data),
1379             "ERC721: transfer to non ERC721Receiver implementer"
1380         );
1381     }
1382 
1383     /**
1384      * @dev Mints `tokenId` and transfers it to `to`.
1385      *
1386      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1387      *
1388      * Requirements:
1389      *
1390      * - `tokenId` must not exist.
1391      * - `to` cannot be the zero address.
1392      *
1393      * Emits a {Transfer} event.
1394      */
1395     function _mint(address to, uint256 tokenId) internal virtual {
1396         require(to != address(0), "ERC721: mint to the zero address");
1397         require(!_exists(tokenId), "ERC721: token already minted");
1398 
1399         _beforeTokenTransfer(address(0), to, tokenId);
1400 
1401         _balances[to] += 1;
1402         _owners[tokenId] = to;
1403 
1404         emit Transfer(address(0), to, tokenId);
1405     }
1406 
1407     /**
1408      * @dev Destroys `tokenId`.
1409      * The approval is cleared when the token is burned.
1410      *
1411      * Requirements:
1412      *
1413      * - `tokenId` must exist.
1414      *
1415      * Emits a {Transfer} event.
1416      */
1417     function _burn(uint256 tokenId) internal virtual {
1418         address owner = ERC721.ownerOf(tokenId);
1419 
1420         _beforeTokenTransfer(owner, address(0), tokenId);
1421 
1422         // Clear approvals
1423         _approve(address(0), tokenId);
1424 
1425         _balances[owner] -= 1;
1426         delete _owners[tokenId];
1427 
1428         emit Transfer(owner, address(0), tokenId);
1429     }
1430 
1431     /**
1432      * @dev Transfers `tokenId` from `from` to `to`.
1433      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1434      *
1435      * Requirements:
1436      *
1437      * - `to` cannot be the zero address.
1438      * - `tokenId` token must be owned by `from`.
1439      *
1440      * Emits a {Transfer} event.
1441      */
1442     function _transfer(
1443         address from,
1444         address to,
1445         uint256 tokenId
1446     ) internal virtual {
1447         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1448         require(to != address(0), "ERC721: transfer to the zero address");
1449 
1450         _beforeTokenTransfer(from, to, tokenId);
1451 
1452         // Clear approvals from the previous owner
1453         _approve(address(0), tokenId);
1454 
1455         _balances[from] -= 1;
1456         _balances[to] += 1;
1457         _owners[tokenId] = to;
1458 
1459         emit Transfer(from, to, tokenId);
1460     }
1461 
1462     /**
1463      * @dev Approve `to` to operate on `tokenId`
1464      *
1465      * Emits a {Approval} event.
1466      */
1467     function _approve(address to, uint256 tokenId) internal virtual {
1468         _tokenApprovals[tokenId] = to;
1469         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1470     }
1471 
1472     /**
1473      * @dev Approve `operator` to operate on all of `owner` tokens
1474      *
1475      * Emits a {ApprovalForAll} event.
1476      */
1477     function _setApprovalForAll(
1478         address owner,
1479         address operator,
1480         bool approved
1481     ) internal virtual {
1482         require(owner != operator, "ERC721: approve to caller");
1483         _operatorApprovals[owner][operator] = approved;
1484         emit ApprovalForAll(owner, operator, approved);
1485     }
1486 
1487     /**
1488      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1489      * The call is not executed if the target address is not a contract.
1490      *
1491      * @param from address representing the previous owner of the given token ID
1492      * @param to target address that will receive the tokens
1493      * @param tokenId uint256 ID of the token to be transferred
1494      * @param _data bytes optional data to send along with the call
1495      * @return bool whether the call correctly returned the expected magic value
1496      */
1497     function _checkOnERC721Received(
1498         address from,
1499         address to,
1500         uint256 tokenId,
1501         bytes memory _data
1502     ) private returns (bool) {
1503         if (to.isContract()) {
1504             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1505                 return retval == IERC721Receiver.onERC721Received.selector;
1506             } catch (bytes memory reason) {
1507                 if (reason.length == 0) {
1508                     revert("ERC721: transfer to non ERC721Receiver implementer");
1509                 } else {
1510                     assembly {
1511                         revert(add(32, reason), mload(reason))
1512                     }
1513                 }
1514             }
1515         } else {
1516             return true;
1517         }
1518     }
1519 
1520     /**
1521      * @dev Hook that is called before any token transfer. This includes minting
1522      * and burning.
1523      *
1524      * Calling conditions:
1525      *
1526      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1527      * transferred to `to`.
1528      * - When `from` is zero, `tokenId` will be minted for `to`.
1529      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1530      * - `from` and `to` are never both zero.
1531      *
1532      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1533      */
1534     function _beforeTokenTransfer(
1535         address from,
1536         address to,
1537         uint256 tokenId
1538     ) internal virtual {}
1539 }
1540 
1541 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1542 
1543 
1544 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1545 
1546 pragma solidity ^0.8.0;
1547 
1548 
1549 
1550 
1551 /**
1552  * @title PaymentSplitter
1553  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1554  * that the Ether will be split in this way, since it is handled transparently by the contract.
1555  *
1556  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1557  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1558  * an amount proportional to the percentage of total shares they were assigned.
1559  *
1560  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1561  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1562  * function.
1563  *
1564  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1565  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1566  * to run tests before sending real value to this contract.
1567  */
1568 contract PaymentSplitter is Context {
1569     event PayeeAdded(address account, uint256 shares);
1570     event PaymentReleased(address to, uint256 amount);
1571     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1572     event PaymentReceived(address from, uint256 amount);
1573 
1574     uint256 private _totalShares;
1575     uint256 private _totalReleased;
1576 
1577     mapping(address => uint256) private _shares;
1578     mapping(address => uint256) private _released;
1579     address[] private _payees;
1580 
1581     mapping(IERC20 => uint256) private _erc20TotalReleased;
1582     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1583 
1584     /**
1585      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1586      * the matching position in the `shares` array.
1587      *
1588      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1589      * duplicates in `payees`.
1590      */
1591     constructor(address[] memory payees, uint256[] memory shares_) payable {
1592         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1593         require(payees.length > 0, "PaymentSplitter: no payees");
1594 
1595         for (uint256 i = 0; i < payees.length; i++) {
1596             _addPayee(payees[i], shares_[i]);
1597         }
1598     }
1599 
1600     /**
1601      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1602      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1603      * reliability of the events, and not the actual splitting of Ether.
1604      *
1605      * To learn more about this see the Solidity documentation for
1606      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1607      * functions].
1608      */
1609     receive() external payable virtual {
1610         emit PaymentReceived(_msgSender(), msg.value);
1611     }
1612 
1613     /**
1614      * @dev Getter for the total shares held by payees.
1615      */
1616     function totalShares() public view returns (uint256) {
1617         return _totalShares;
1618     }
1619 
1620     /**
1621      * @dev Getter for the total amount of Ether already released.
1622      */
1623     function totalReleased() public view returns (uint256) {
1624         return _totalReleased;
1625     }
1626 
1627     /**
1628      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1629      * contract.
1630      */
1631     function totalReleased(IERC20 token) public view returns (uint256) {
1632         return _erc20TotalReleased[token];
1633     }
1634 
1635     /**
1636      * @dev Getter for the amount of shares held by an account.
1637      */
1638     function shares(address account) public view returns (uint256) {
1639         return _shares[account];
1640     }
1641 
1642     /**
1643      * @dev Getter for the amount of Ether already released to a payee.
1644      */
1645     function released(address account) public view returns (uint256) {
1646         return _released[account];
1647     }
1648 
1649     /**
1650      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1651      * IERC20 contract.
1652      */
1653     function released(IERC20 token, address account) public view returns (uint256) {
1654         return _erc20Released[token][account];
1655     }
1656 
1657     /**
1658      * @dev Getter for the address of the payee number `index`.
1659      */
1660     function payee(uint256 index) public view returns (address) {
1661         return _payees[index];
1662     }
1663 
1664     /**
1665      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1666      * total shares and their previous withdrawals.
1667      */
1668     function release(address payable account) public virtual {
1669         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1670 
1671         uint256 totalReceived = address(this).balance + totalReleased();
1672         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1673 
1674         require(payment != 0, "PaymentSplitter: account is not due payment");
1675 
1676         _released[account] += payment;
1677         _totalReleased += payment;
1678 
1679         Address.sendValue(account, payment);
1680         emit PaymentReleased(account, payment);
1681     }
1682 
1683     /**
1684      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1685      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1686      * contract.
1687      */
1688     function release(IERC20 token, address account) public virtual {
1689         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1690 
1691         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1692         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1693 
1694         require(payment != 0, "PaymentSplitter: account is not due payment");
1695 
1696         _erc20Released[token][account] += payment;
1697         _erc20TotalReleased[token] += payment;
1698 
1699         SafeERC20.safeTransfer(token, account, payment);
1700         emit ERC20PaymentReleased(token, account, payment);
1701     }
1702 
1703     /**
1704      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1705      * already released amounts.
1706      */
1707     function _pendingPayment(
1708         address account,
1709         uint256 totalReceived,
1710         uint256 alreadyReleased
1711     ) private view returns (uint256) {
1712         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1713     }
1714 
1715     /**
1716      * @dev Add a new payee to the contract.
1717      * @param account The address of the payee to add.
1718      * @param shares_ The number of shares owned by the payee.
1719      */
1720     function _addPayee(address account, uint256 shares_) private {
1721         require(account != address(0), "PaymentSplitter: account is the zero address");
1722         require(shares_ > 0, "PaymentSplitter: shares are 0");
1723         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1724 
1725         _payees.push(account);
1726         _shares[account] = shares_;
1727         _totalShares = _totalShares + shares_;
1728         emit PayeeAdded(account, shares_);
1729     }
1730 }
1731 
1732 // File: @openzeppelin/contracts/access/Ownable.sol
1733 
1734 
1735 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1736 
1737 pragma solidity ^0.8.0;
1738 
1739 
1740 /**
1741  * @dev Contract module which provides a basic access control mechanism, where
1742  * there is an account (an owner) that can be granted exclusive access to
1743  * specific functions.
1744  *
1745  * By default, the owner account will be the one that deploys the contract. This
1746  * can later be changed with {transferOwnership}.
1747  *
1748  * This module is used through inheritance. It will make available the modifier
1749  * `onlyOwner`, which can be applied to your functions to restrict their use to
1750  * the owner.
1751  */
1752 abstract contract Ownable is Context {
1753     address private _owner;
1754 
1755     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1756 
1757     /**
1758      * @dev Initializes the contract setting the deployer as the initial owner.
1759      */
1760     constructor() {
1761         _transferOwnership(_msgSender());
1762     }
1763 
1764     /**
1765      * @dev Returns the address of the current owner.
1766      */
1767     function owner() public view virtual returns (address) {
1768         return _owner;
1769     }
1770 
1771     /**
1772      * @dev Throws if called by any account other than the owner.
1773      */
1774     modifier onlyOwner() {
1775         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1776         _;
1777     }
1778 
1779     /**
1780      * @dev Leaves the contract without owner. It will not be possible to call
1781      * `onlyOwner` functions anymore. Can only be called by the current owner.
1782      *
1783      * NOTE: Renouncing ownership will leave the contract without an owner,
1784      * thereby removing any functionality that is only available to the owner.
1785      */
1786     function renounceOwnership() public virtual onlyOwner {
1787         _transferOwnership(address(0));
1788     }
1789 
1790     /**
1791      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1792      * Can only be called by the current owner.
1793      */
1794     function transferOwnership(address newOwner) public virtual onlyOwner {
1795         require(newOwner != address(0), "Ownable: new owner is the zero address");
1796         _transferOwnership(newOwner);
1797     }
1798 
1799     /**
1800      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1801      * Internal function without access restriction.
1802      */
1803     function _transferOwnership(address newOwner) internal virtual {
1804         address oldOwner = _owner;
1805         _owner = newOwner;
1806         emit OwnershipTransferred(oldOwner, newOwner);
1807     }
1808 }
1809 
1810 // File: contracts/EIP712Claimable.sol
1811 
1812 //SPDX-License-Identifier: Unlicense
1813 pragma solidity ^0.8.0;
1814 
1815 
1816 
1817 
1818 contract EIP712Claimable is Ownable {
1819     using ECDSA for bytes32;
1820 
1821     // The key used to sign whitelist signatures.
1822     // We will check to ensure that the key that signed the signature
1823     // is this one that we expect.
1824     address claimSigningKey = address(0);
1825 
1826     // Domain Separator is the EIP-712 defined structure that defines what contract
1827     // and chain these signatures can be used for.  This ensures people can't take
1828     // a signature used to mint on one contract and use it for another, or a signature
1829     // from testnet to replay on mainnet.
1830     // It has to be created in the constructor so we can dynamically grab the chainId.
1831     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md#definition-of-domainseparator
1832     bytes32 public DOMAIN_SEPARATOR;
1833 
1834     // The typehash for the data type specified in the structured data
1835     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md#rationale-for-typehash
1836     // This should match whats in the client side whitelist signing code
1837     // https://github.com/msfeldstein/EIP712-whitelisting/blob/main/test/signWhitelist.ts#L22
1838     bytes32 public constant MINTER_TYPEHASH =
1839         keccak256("Minter(address wallet,uint256 count)");
1840 
1841     constructor() {
1842         // This should match whats in the client side whitelist signing code
1843         // https://github.com/msfeldstein/EIP712-whitelisting/blob/main/test/signWhitelist.ts#L12
1844         DOMAIN_SEPARATOR = keccak256(
1845             abi.encode(
1846                 keccak256(
1847                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1848                 ),
1849                 // This should match the domain you set in your client side signing.
1850                 keccak256(bytes("ClaimToken")),
1851                 keccak256(bytes("1")),
1852                 block.chainid,
1853                 address(this)
1854             )
1855         );
1856     }
1857 
1858     function setClaimSigningAddress(address newSigningKey) public onlyOwner {
1859         claimSigningKey = newSigningKey;
1860     }
1861 
1862     modifier requiresClaim(bytes calldata signature, uint256 count) {
1863         require(claimSigningKey != address(0), "claiming not enabled");
1864         // Verify EIP-712 signature by recreating the data structure
1865         // that we signed on the client side, and then using that to recover
1866         // the address that signed the signature for this data.
1867         bytes32 digest = keccak256(
1868             abi.encodePacked(
1869                 "\x19\x01",
1870                 DOMAIN_SEPARATOR,
1871                 keccak256(abi.encode(
1872                     MINTER_TYPEHASH,
1873                     msg.sender,
1874                     count))
1875             )
1876         );
1877         // Use the recover method to see what address was used to create
1878         // the signature on this data.
1879         // Note that if the digest doesn't exactly match what was signed we'll
1880         // get a random recovered address.
1881         address recoveredAddress = digest.recover(signature);
1882         require(recoveredAddress == claimSigningKey, "Invalid Signature");
1883         _;
1884     }
1885 }
1886 
1887 // File: contracts/floor_gen3.sol
1888 
1889 
1890 
1891 // ███╗   ███╗ █████╗ ██████╗ ███████╗    ██╗    ██╗██╗████████╗██╗  ██╗    ███╗   ███╗ █████╗ ███████╗ ██████╗ ███╗   ██╗
1892 // ████╗ ████║██╔══██╗██╔══██╗██╔════╝    ██║    ██║██║╚══██╔══╝██║  ██║    ████╗ ████║██╔══██╗██╔════╝██╔═══██╗████╗  ██║
1893 // ██╔████╔██║███████║██║  ██║█████╗      ██║ █╗ ██║██║   ██║   ███████║    ██╔████╔██║███████║███████╗██║   ██║██╔██╗ ██║
1894 // ██║╚██╔╝██║██╔══██║██║  ██║██╔══╝      ██║███╗██║██║   ██║   ██╔══██║    ██║╚██╔╝██║██╔══██║╚════██║██║   ██║██║╚██╗██║
1895 // ██║ ╚═╝ ██║██║  ██║██████╔╝███████╗    ╚███╔███╔╝██║   ██║   ██║  ██║    ██║ ╚═╝ ██║██║  ██║███████║╚██████╔╝██║ ╚████║
1896 // ╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝     ╚══╝╚══╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝
1897 
1898 pragma solidity ^0.8.9;
1899 
1900 
1901 
1902 
1903 
1904 
1905 
1906 
1907 contract FloorGen3 is ERC721, ReentrancyGuard, Ownable, EIP712Claimable{
1908   using Counters for Counters.Counter;
1909 
1910   uint256 public PRICE;
1911   uint256 public MAX_SUPPLY;
1912   uint256 public MAX_RESERVED_SUPPLY;
1913   uint256 public MAX_PUBLIC_SUPPLY;
1914   uint256 public MAX_PER_WALLET;
1915   uint256 public MAX_MULTIMINT;
1916 
1917   Counters.Counter private supplyCounter;
1918   Counters.Counter private reservedSupplyCounter;
1919 
1920   PaymentSplitter private _splitter;
1921 
1922   constructor (
1923     string memory tokenName,
1924     string memory tokenSymbol,
1925     string memory customBaseURI_,
1926     address[] memory payees,
1927     uint256[] memory shares,
1928     uint256 _tokenPrice,
1929     uint256 _tokensForSale,
1930     uint256 _tokensReserved) ERC721(tokenName, tokenSymbol) {
1931     customBaseURI = customBaseURI_;
1932 
1933     PRICE = _tokenPrice;
1934     MAX_SUPPLY = _tokensForSale;
1935     MAX_RESERVED_SUPPLY = _tokensReserved;
1936     MAX_PUBLIC_SUPPLY = MAX_SUPPLY - MAX_RESERVED_SUPPLY;
1937 
1938     MAX_PER_WALLET = 20;
1939     MAX_MULTIMINT = 5;
1940 
1941     _splitter = new PaymentSplitter(payees, shares);
1942   }
1943 
1944   /** MINTING **/
1945 
1946   function mint(uint256 count) public payable nonReentrant {
1947     require(saleIsActive, "Sale not active");
1948     require(totalPublicSupply() + count - 1 < MAX_PUBLIC_SUPPLY, "Exceeds max supply");
1949     require(count - 1 < MAX_MULTIMINT, "Trying to mint too many at a time");
1950     require(
1951       msg.value >= PRICE * count, "Insufficient payment"
1952     );
1953 
1954     if (allowedMintCount(msg.sender) > count) {
1955       updateMintCount(msg.sender, count);
1956     } else {
1957       revert("Minting limit exceeded");
1958     }
1959 
1960     for (uint256 i = 0; i < count; i++) {
1961       supplyCounter.increment();
1962       _safeMint(msg.sender, totalSupply());
1963     }
1964 
1965     payable(_splitter).transfer(msg.value);
1966   }
1967 
1968   function ownerMint(uint256 count, address recipient) external onlyOwner() {
1969     require(totalReservedSupply() + count - 1 < MAX_RESERVED_SUPPLY, "Exceeds max reserved supply");
1970     require(totalSupply() + count - 1 < MAX_SUPPLY , "Exceeds max supply");
1971 
1972     for (uint256 i = 0; i < count; i++) {
1973       reservedSupplyCounter.increment();
1974       _safeMint(recipient, totalSupply());
1975     }
1976   }
1977 
1978   function totalSupply() public view returns (uint256) {
1979     return supplyCounter.current() + reservedSupplyCounter.current();
1980   }
1981 
1982   function totalPublicSupply() public view returns (uint256) {
1983     return supplyCounter.current();
1984   }
1985 
1986   function totalReservedSupply() public view returns (uint256) {
1987     return reservedSupplyCounter.current();
1988   }
1989 
1990   /** ACTIVATION **/
1991 
1992   bool public saleIsActive = true;
1993 
1994   function flipSaleState() external onlyOwner {
1995     saleIsActive = !saleIsActive;
1996   }
1997 
1998   /** ADMIN **/
1999 
2000   function setPrice(uint256 _tokenPrice) external onlyOwner {
2001     PRICE = _tokenPrice;
2002   }
2003 
2004   function setMultiMint(uint256 _maxMultimint) external onlyOwner {
2005     MAX_MULTIMINT = _maxMultimint;
2006   }
2007 
2008   function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
2009     MAX_PER_WALLET = _maxPerWallet;
2010   }
2011 
2012   /** MINTING LIMITS **/
2013 
2014   mapping(address => uint256) private mintCountMap;
2015 
2016   function allowedMintCount(address minter) public view returns (uint256) {
2017     return MAX_PER_WALLET - mintCountMap[minter];
2018   }
2019 
2020   function updateMintCount(address minter, uint256 count) private {
2021     mintCountMap[minter] += count;
2022   }
2023 
2024 
2025   /** Claiming **/
2026 
2027   mapping(address => uint256) private claimCounts;
2028 
2029   bool public claimingIsActive = true;
2030 
2031   function flipClaimState() external onlyOwner {
2032     claimingIsActive = !claimingIsActive;
2033   }
2034 
2035   function tokensClaimed(address minter) public view returns (uint256) {
2036     return claimCounts[minter];
2037   }
2038 
2039   function checkClaimlist(uint256 count, bytes calldata signature) public view requiresClaim(signature, count) returns (bool) {
2040     return true;
2041   }
2042 
2043   function hasUnclaimedTokens(address minter) public view returns (bool) {
2044     return claimCounts[minter] == 0;
2045   }
2046 
2047   function updateClaimCount(address minter, uint256 count) private {
2048     claimCounts[minter] += count;
2049   }
2050 
2051   function claimTokens(uint256 count, bytes calldata signature) public payable requiresClaim(signature, count) nonReentrant  {
2052     require(claimingIsActive, "Claiming not active");
2053     require(totalReservedSupply() + count - 1 < MAX_RESERVED_SUPPLY, "Exceeds max reserved supply");
2054     require(totalSupply() + count - 1 < MAX_SUPPLY , "Exceeds max supply");
2055 
2056     if (hasUnclaimedTokens(msg.sender)) {
2057       updateClaimCount(msg.sender, count);
2058     } else {
2059       revert("You have already claimed all your tokens");
2060     }
2061 
2062     for (uint256 i = 0; i < count; i++) {
2063       reservedSupplyCounter.increment();
2064       _safeMint(msg.sender, totalSupply());
2065     }
2066   }
2067 
2068   /** OWNERSHIP  **/
2069 
2070   // WARNING: This function is not expensive, it should not be called from within the contract!!!
2071   function tokensOfOwner(address _owner) external view returns(uint256[] memory ownerTokens) {
2072     uint256 tokenCount = balanceOf(_owner);
2073 
2074     if (tokenCount == 0) {
2075       return new uint256[](1);
2076     } else {
2077       uint256[] memory result = new uint256[](tokenCount);
2078       uint256 totalTokens = totalSupply();
2079       uint256 resultIndex = 0;
2080 
2081       uint256 tokenId;
2082       for (tokenId = 1; tokenId <= totalTokens; tokenId++) {
2083           if (ownerOf(tokenId) == _owner) {
2084             result[resultIndex] = tokenId;
2085               resultIndex++;
2086           }
2087       }
2088 
2089       return result;
2090     }
2091   }
2092 
2093   /** URI HANDLING **/
2094 
2095   string private customBaseURI;
2096 
2097   function baseTokenURI() public view returns (string memory) {
2098     return customBaseURI;
2099   }
2100 
2101   function setBaseURI(string memory customBaseURI_) external onlyOwner {
2102     customBaseURI = customBaseURI_;
2103   }
2104 
2105   function _baseURI() internal view virtual override returns (string memory) {
2106     return customBaseURI;
2107   }
2108 
2109   /** PAYOUT **/
2110 
2111   function release(address payable account) public virtual onlyOwner {
2112     _splitter.release(account);
2113   }
2114 }