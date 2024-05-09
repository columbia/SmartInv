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
84 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
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
139         if (signature.length == 65) {
140             bytes32 r;
141             bytes32 s;
142             uint8 v;
143             // ecrecover takes the signature parameters, and the only way to get them
144             // currently is to use assembly.
145             /// @solidity memory-safe-assembly
146             assembly {
147                 r := mload(add(signature, 0x20))
148                 s := mload(add(signature, 0x40))
149                 v := byte(0, mload(add(signature, 0x60)))
150             }
151             return tryRecover(hash, v, r, s);
152         } else {
153             return (address(0), RecoverError.InvalidSignatureLength);
154         }
155     }
156 
157     /**
158      * @dev Returns the address that signed a hashed message (`hash`) with
159      * `signature`. This address can then be used for verification purposes.
160      *
161      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
162      * this function rejects them by requiring the `s` value to be in the lower
163      * half order, and the `v` value to be either 27 or 28.
164      *
165      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
166      * verification to be secure: it is possible to craft signatures that
167      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
168      * this is by receiving a hash of the original message (which may otherwise
169      * be too long), and then calling {toEthSignedMessageHash} on it.
170      */
171     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
172         (address recovered, RecoverError error) = tryRecover(hash, signature);
173         _throwError(error);
174         return recovered;
175     }
176 
177     /**
178      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
179      *
180      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
181      *
182      * _Available since v4.3._
183      */
184     function tryRecover(
185         bytes32 hash,
186         bytes32 r,
187         bytes32 vs
188     ) internal pure returns (address, RecoverError) {
189         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
190         uint8 v = uint8((uint256(vs) >> 255) + 27);
191         return tryRecover(hash, v, r, s);
192     }
193 
194     /**
195      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
196      *
197      * _Available since v4.2._
198      */
199     function recover(
200         bytes32 hash,
201         bytes32 r,
202         bytes32 vs
203     ) internal pure returns (address) {
204         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
205         _throwError(error);
206         return recovered;
207     }
208 
209     /**
210      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
211      * `r` and `s` signature fields separately.
212      *
213      * _Available since v4.3._
214      */
215     function tryRecover(
216         bytes32 hash,
217         uint8 v,
218         bytes32 r,
219         bytes32 s
220     ) internal pure returns (address, RecoverError) {
221         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
222         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
223         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
224         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
225         //
226         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
227         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
228         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
229         // these malleable signatures as well.
230         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
231             return (address(0), RecoverError.InvalidSignatureS);
232         }
233         if (v != 27 && v != 28) {
234             return (address(0), RecoverError.InvalidSignatureV);
235         }
236 
237         // If the signature is valid (and not malleable), return the signer address
238         address signer = ecrecover(hash, v, r, s);
239         if (signer == address(0)) {
240             return (address(0), RecoverError.InvalidSignature);
241         }
242 
243         return (signer, RecoverError.NoError);
244     }
245 
246     /**
247      * @dev Overload of {ECDSA-recover} that receives the `v`,
248      * `r` and `s` signature fields separately.
249      */
250     function recover(
251         bytes32 hash,
252         uint8 v,
253         bytes32 r,
254         bytes32 s
255     ) internal pure returns (address) {
256         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
257         _throwError(error);
258         return recovered;
259     }
260 
261     /**
262      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
263      * produces hash corresponding to the one signed with the
264      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
265      * JSON-RPC method as part of EIP-191.
266      *
267      * See {recover}.
268      */
269     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
270         // 32 is the length in bytes of hash,
271         // enforced by the type signature above
272         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
273     }
274 
275     /**
276      * @dev Returns an Ethereum Signed Message, created from `s`. This
277      * produces hash corresponding to the one signed with the
278      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
279      * JSON-RPC method as part of EIP-191.
280      *
281      * See {recover}.
282      */
283     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
284         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
285     }
286 
287     /**
288      * @dev Returns an Ethereum Signed Typed Data, created from a
289      * `domainSeparator` and a `structHash`. This produces hash corresponding
290      * to the one signed with the
291      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
292      * JSON-RPC method as part of EIP-712.
293      *
294      * See {recover}.
295      */
296     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
297         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
298     }
299 }
300 
301 // File: digiminer.sol
302 
303 
304 
305 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Interface of the ERC165 standard, as defined in the
314  * https://eips.ethereum.org/EIPS/eip-165[EIP].
315  *
316  * Implementers can declare support of contract interfaces, which can then be
317  * queried by others ({ERC165Checker}).
318  *
319  * For an implementation, see {ERC165}.
320  */
321 interface IERC165 {
322     /**
323      * @dev Returns true if this contract implements the interface defined by
324      * `interfaceId`. See the corresponding
325      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
326      * to learn more about how these ids are created.
327      *
328      * This function call must use less than 30 000 gas.
329      */
330     function supportsInterface(bytes4 interfaceId) external view returns (bool);
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
334 
335 
336 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Required interface of an ERC721 compliant contract.
343  */
344 interface IERC721 is IERC165 {
345     /**
346      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
347      */
348     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
349 
350     /**
351      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
352      */
353     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
354 
355     /**
356      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
357      */
358     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
359 
360     /**
361      * @dev Returns the number of tokens in ``owner``'s account.
362      */
363     function balanceOf(address owner) external view returns (uint256 balance);
364 
365     /**
366      * @dev Returns the owner of the `tokenId` token.
367      *
368      * Requirements:
369      *
370      * - `tokenId` must exist.
371      */
372     function ownerOf(uint256 tokenId) external view returns (address owner);
373 
374     /**
375      * @dev Safely transfers `tokenId` token from `from` to `to`.
376      *
377      * Requirements:
378      *
379      * - `from` cannot be the zero address.
380      * - `to` cannot be the zero address.
381      * - `tokenId` token must exist and be owned by `from`.
382      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
383      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
384      *
385      * Emits a {Transfer} event.
386      */
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 tokenId,
391         bytes calldata data
392     ) external;
393 
394     /**
395      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
396      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
397      *
398      * Requirements:
399      *
400      * - `from` cannot be the zero address.
401      * - `to` cannot be the zero address.
402      * - `tokenId` token must exist and be owned by `from`.
403      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
404      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
405      *
406      * Emits a {Transfer} event.
407      */
408     function safeTransferFrom(
409         address from,
410         address to,
411         uint256 tokenId
412     ) external;
413 
414     /**
415      * @dev Transfers `tokenId` token from `from` to `to`.
416      *
417      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must be owned by `from`.
424      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
425      *
426      * Emits a {Transfer} event.
427      */
428     function transferFrom(
429         address from,
430         address to,
431         uint256 tokenId
432     ) external;
433 
434     /**
435      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
436      * The approval is cleared when the token is transferred.
437      *
438      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
439      *
440      * Requirements:
441      *
442      * - The caller must own the token or be an approved operator.
443      * - `tokenId` must exist.
444      *
445      * Emits an {Approval} event.
446      */
447     function approve(address to, uint256 tokenId) external;
448 
449     /**
450      * @dev Approve or remove `operator` as an operator for the caller.
451      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
452      *
453      * Requirements:
454      *
455      * - The `operator` cannot be the caller.
456      *
457      * Emits an {ApprovalForAll} event.
458      */
459     function setApprovalForAll(address operator, bool _approved) external;
460 
461     /**
462      * @dev Returns the account approved for `tokenId` token.
463      *
464      * Requirements:
465      *
466      * - `tokenId` must exist.
467      */
468     function getApproved(uint256 tokenId) external view returns (address operator);
469 
470     /**
471      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
472      *
473      * See {setApprovalForAll}
474      */
475     function isApprovedForAll(address owner, address operator) external view returns (bool);
476 }
477 
478 // File: @openzeppelin/contracts/interfaces/IERC721.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 
486 // File: @openzeppelin/contracts/utils/Context.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Provides information about the current execution context, including the
495  * sender of the transaction and its data. While these are generally available
496  * via msg.sender and msg.data, they should not be accessed in such a direct
497  * manner, since when dealing with meta-transactions the account sending and
498  * paying for execution may not be the actual sender (as far as an application
499  * is concerned).
500  *
501  * This contract is only required for intermediate, library-like contracts.
502  */
503 abstract contract Context {
504     function _msgSender() internal view virtual returns (address) {
505         return msg.sender;
506     }
507 
508     function _msgData() internal view virtual returns (bytes calldata) {
509         return msg.data;
510     }
511 }
512 
513 // File: @openzeppelin/contracts/access/Ownable.sol
514 
515 
516 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 
521 /**
522  * @dev Contract module which provides a basic access control mechanism, where
523  * there is an account (an owner) that can be granted exclusive access to
524  * specific functions.
525  *
526  * By default, the owner account will be the one that deploys the contract. This
527  * can later be changed with {transferOwnership}.
528  *
529  * This module is used through inheritance. It will make available the modifier
530  * `onlyOwner`, which can be applied to your functions to restrict their use to
531  * the owner.
532  */
533 abstract contract Ownable is Context {
534     address private _owner;
535 
536     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
537 
538     /**
539      * @dev Initializes the contract setting the deployer as the initial owner.
540      */
541     constructor() {
542         _transferOwnership(_msgSender());
543     }
544 
545     /**
546      * @dev Throws if called by any account other than the owner.
547      */
548     modifier onlyOwner() {
549         _checkOwner();
550         _;
551     }
552 
553     /**
554      * @dev Returns the address of the current owner.
555      */
556     function owner() public view virtual returns (address) {
557         return _owner;
558     }
559 
560     /**
561      * @dev Throws if the sender is not the owner.
562      */
563     function _checkOwner() internal view virtual {
564         require(owner() == _msgSender(), "Ownable: caller is not the owner");
565     }
566 
567     /**
568      * @dev Leaves the contract without owner. It will not be possible to call
569      * `onlyOwner` functions anymore. Can only be called by the current owner.
570      *
571      * NOTE: Renouncing ownership will leave the contract without an owner,
572      * thereby removing any functionality that is only available to the owner.
573      */
574     function renounceOwnership() public virtual onlyOwner {
575         _transferOwnership(address(0));
576     }
577 
578     /**
579      * @dev Transfers ownership of the contract to a new account (`newOwner`).
580      * Can only be called by the current owner.
581      */
582     function transferOwnership(address newOwner) public virtual onlyOwner {
583         require(newOwner != address(0), "Ownable: new owner is the zero address");
584         _transferOwnership(newOwner);
585     }
586 
587     /**
588      * @dev Transfers ownership of the contract to a new account (`newOwner`).
589      * Internal function without access restriction.
590      */
591     function _transferOwnership(address newOwner) internal virtual {
592         address oldOwner = _owner;
593         _owner = newOwner;
594         emit OwnershipTransferred(oldOwner, newOwner);
595     }
596 }
597 
598 // File: digiminer.sol
599 
600 
601 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
602 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
603 
604 pragma solidity ^0.8.0;
605 
606 
607 
608 /**
609  * @dev Library for managing
610  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
611  * types.
612  *
613  * Sets have the following properties:
614  *
615  * - Elements are added, removed, and checked for existence in constant time
616  * (O(1)).
617  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
618  *
619  * ```
620  * contract Example {
621  *     // Add the library methods
622  *     using EnumerableSet for EnumerableSet.AddressSet;
623  *
624  *     // Declare a set state variable
625  *     EnumerableSet.AddressSet private mySet;
626  * }
627  * ```
628  *
629  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
630  * and `uint256` (`UintSet`) are supported.
631  *
632  * [WARNING]
633  * ====
634  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
635  * unusable.
636  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
637  *
638  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
639  * array of EnumerableSet.
640  * ====
641  */
642 library EnumerableSet {
643     // To implement this library for multiple types with as little code
644     // repetition as possible, we write it in terms of a generic Set type with
645     // bytes32 values.
646     // The Set implementation uses private functions, and user-facing
647     // implementations (such as AddressSet) are just wrappers around the
648     // underlying Set.
649     // This means that we can only create new EnumerableSets for types that fit
650     // in bytes32.
651 
652     struct Set {
653         // Storage of set values
654         bytes32[] _values;
655         // Position of the value in the `values` array, plus 1 because index 0
656         // means a value is not in the set.
657         mapping(bytes32 => uint256) _indexes;
658     }
659 
660     /**
661      * @dev Add a value to a set. O(1).
662      *
663      * Returns true if the value was added to the set, that is if it was not
664      * already present.
665      */
666     function _add(Set storage set, bytes32 value) private returns (bool) {
667         if (!_contains(set, value)) {
668             set._values.push(value);
669             // The value is stored at length-1, but we add 1 to all indexes
670             // and use 0 as a sentinel value
671             set._indexes[value] = set._values.length;
672             return true;
673         } else {
674             return false;
675         }
676     }
677 
678     /**
679      * @dev Removes a value from a set. O(1).
680      *
681      * Returns true if the value was removed from the set, that is if it was
682      * present.
683      */
684     function _remove(Set storage set, bytes32 value) private returns (bool) {
685         // We read and store the value's index to prevent multiple reads from the same storage slot
686         uint256 valueIndex = set._indexes[value];
687 
688         if (valueIndex != 0) {
689             // Equivalent to contains(set, value)
690             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
691             // the array, and then remove the last element (sometimes called as 'swap and pop').
692             // This modifies the order of the array, as noted in {at}.
693 
694             uint256 toDeleteIndex = valueIndex - 1;
695             uint256 lastIndex = set._values.length - 1;
696 
697             if (lastIndex != toDeleteIndex) {
698                 bytes32 lastValue = set._values[lastIndex];
699 
700                 // Move the last value to the index where the value to delete is
701                 set._values[toDeleteIndex] = lastValue;
702                 // Update the index for the moved value
703                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
704             }
705 
706             // Delete the slot where the moved value was stored
707             set._values.pop();
708 
709             // Delete the index for the deleted slot
710             delete set._indexes[value];
711 
712             return true;
713         } else {
714             return false;
715         }
716     }
717 
718     /**
719      * @dev Returns true if the value is in the set. O(1).
720      */
721     function _contains(Set storage set, bytes32 value) private view returns (bool) {
722         return set._indexes[value] != 0;
723     }
724 
725     /**
726      * @dev Returns the number of values on the set. O(1).
727      */
728     function _length(Set storage set) private view returns (uint256) {
729         return set._values.length;
730     }
731 
732     /**
733      * @dev Returns the value stored at position `index` in the set. O(1).
734      *
735      * Note that there are no guarantees on the ordering of values inside the
736      * array, and it may change when more values are added or removed.
737      *
738      * Requirements:
739      *
740      * - `index` must be strictly less than {length}.
741      */
742     function _at(Set storage set, uint256 index) private view returns (bytes32) {
743         return set._values[index];
744     }
745 
746     /**
747      * @dev Return the entire set in an array
748      *
749      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
750      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
751      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
752      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
753      */
754     function _values(Set storage set) private view returns (bytes32[] memory) {
755         return set._values;
756     }
757 
758     // Bytes32Set
759 
760     struct Bytes32Set {
761         Set _inner;
762     }
763 
764     /**
765      * @dev Add a value to a set. O(1).
766      *
767      * Returns true if the value was added to the set, that is if it was not
768      * already present.
769      */
770     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
771         return _add(set._inner, value);
772     }
773 
774     /**
775      * @dev Removes a value from a set. O(1).
776      *
777      * Returns true if the value was removed from the set, that is if it was
778      * present.
779      */
780     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
781         return _remove(set._inner, value);
782     }
783 
784     /**
785      * @dev Returns true if the value is in the set. O(1).
786      */
787     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
788         return _contains(set._inner, value);
789     }
790 
791     /**
792      * @dev Returns the number of values in the set. O(1).
793      */
794     function length(Bytes32Set storage set) internal view returns (uint256) {
795         return _length(set._inner);
796     }
797 
798     /**
799      * @dev Returns the value stored at position `index` in the set. O(1).
800      *
801      * Note that there are no guarantees on the ordering of values inside the
802      * array, and it may change when more values are added or removed.
803      *
804      * Requirements:
805      *
806      * - `index` must be strictly less than {length}.
807      */
808     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
809         return _at(set._inner, index);
810     }
811 
812     /**
813      * @dev Return the entire set in an array
814      *
815      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
816      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
817      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
818      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
819      */
820     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
821         bytes32[] memory store = _values(set._inner);
822         bytes32[] memory result;
823 
824         /// @solidity memory-safe-assembly
825         assembly {
826             result := store
827         }
828 
829         return result;
830     }
831 
832     // AddressSet
833 
834     struct AddressSet {
835         Set _inner;
836     }
837 
838     /**
839      * @dev Add a value to a set. O(1).
840      *
841      * Returns true if the value was added to the set, that is if it was not
842      * already present.
843      */
844     function add(AddressSet storage set, address value) internal returns (bool) {
845         return _add(set._inner, bytes32(uint256(uint160(value))));
846     }
847 
848     /**
849      * @dev Removes a value from a set. O(1).
850      *
851      * Returns true if the value was removed from the set, that is if it was
852      * present.
853      */
854     function remove(AddressSet storage set, address value) internal returns (bool) {
855         return _remove(set._inner, bytes32(uint256(uint160(value))));
856     }
857 
858     /**
859      * @dev Returns true if the value is in the set. O(1).
860      */
861     function contains(AddressSet storage set, address value) internal view returns (bool) {
862         return _contains(set._inner, bytes32(uint256(uint160(value))));
863     }
864 
865     /**
866      * @dev Returns the number of values in the set. O(1).
867      */
868     function length(AddressSet storage set) internal view returns (uint256) {
869         return _length(set._inner);
870     }
871 
872     /**
873      * @dev Returns the value stored at position `index` in the set. O(1).
874      *
875      * Note that there are no guarantees on the ordering of values inside the
876      * array, and it may change when more values are added or removed.
877      *
878      * Requirements:
879      *
880      * - `index` must be strictly less than {length}.
881      */
882     function at(AddressSet storage set, uint256 index) internal view returns (address) {
883         return address(uint160(uint256(_at(set._inner, index))));
884     }
885 
886     /**
887      * @dev Return the entire set in an array
888      *
889      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
890      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
891      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
892      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
893      */
894     function values(AddressSet storage set) internal view returns (address[] memory) {
895         bytes32[] memory store = _values(set._inner);
896         address[] memory result;
897 
898         /// @solidity memory-safe-assembly
899         assembly {
900             result := store
901         }
902 
903         return result;
904     }
905 
906     // UintSet
907 
908     struct UintSet {
909         Set _inner;
910     }
911 
912     /**
913      * @dev Add a value to a set. O(1).
914      *
915      * Returns true if the value was added to the set, that is if it was not
916      * already present.
917      */
918     function add(UintSet storage set, uint256 value) internal returns (bool) {
919         return _add(set._inner, bytes32(value));
920     }
921 
922     /**
923      * @dev Removes a value from a set. O(1).
924      *
925      * Returns true if the value was removed from the set, that is if it was
926      * present.
927      */
928     function remove(UintSet storage set, uint256 value) internal returns (bool) {
929         return _remove(set._inner, bytes32(value));
930     }
931 
932     /**
933      * @dev Returns true if the value is in the set. O(1).
934      */
935     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
936         return _contains(set._inner, bytes32(value));
937     }
938 
939     /**
940      * @dev Returns the number of values in the set. O(1).
941      */
942     function length(UintSet storage set) internal view returns (uint256) {
943         return _length(set._inner);
944     }
945 
946     /**
947      * @dev Returns the value stored at position `index` in the set. O(1).
948      *
949      * Note that there are no guarantees on the ordering of values inside the
950      * array, and it may change when more values are added or removed.
951      *
952      * Requirements:
953      *
954      * - `index` must be strictly less than {length}.
955      */
956     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
957         return uint256(_at(set._inner, index));
958     }
959 
960     /**
961      * @dev Return the entire set in an array
962      *
963      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
964      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
965      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
966      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
967      */
968     function values(UintSet storage set) internal view returns (uint256[] memory) {
969         bytes32[] memory store = _values(set._inner);
970         uint256[] memory result;
971 
972         /// @solidity memory-safe-assembly
973         assembly {
974             result := store
975         }
976 
977         return result;
978     }
979 }
980 abstract contract ReentrancyGuard {
981     // Booleans are more expensive than uint256 or any type that takes up a full
982     // word because each write operation emits an extra SLOAD to first read the
983     // slot's contents, replace the bits taken up by the boolean, and then write
984     // back. This is the compiler's defense against contract upgrades and
985     // pointer aliasing, and it cannot be disabled.
986 
987     // The values being non-zero value makes deployment a bit more expensive,
988     // but in exchange the refund on every call to nonReentrant will be lower in
989     // amount. Since refunds are capped to a percentage of the total
990     // transaction's gas, it is best to keep them low in cases like this one, to
991     // increase the likelihood of the full refund coming into effect.
992     uint256 private constant _NOT_ENTERED = 1;
993     uint256 private constant _ENTERED = 2;
994 
995     uint256 private _status;
996 
997     constructor() {
998         _status = _NOT_ENTERED;
999     }
1000 
1001     /**
1002      * @dev Prevents a contract from calling itself, directly or indirectly.
1003      * Calling a `nonReentrant` function from another `nonReentrant`
1004      * function is not supported. It is possible to prevent this from happening
1005      * by making the `nonReentrant` function external, and making it call a
1006      * `private` function that does the actual work.
1007      */
1008     modifier nonReentrant() {
1009         // On the first call to nonReentrant, _notEntered will be true
1010         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1011 
1012         // Any calls to nonReentrant after this point will fail
1013         _status = _ENTERED;
1014 
1015         _;
1016 
1017         // By storing the original value once again, a refund is triggered (see
1018         // https://eips.ethereum.org/EIPS/eip-2200)
1019         _status = _NOT_ENTERED;
1020     }
1021 }
1022 library SafeMath {
1023     /**
1024      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1025      *
1026      * _Available since v3.4._
1027      */
1028     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1029         uint256 c = a + b;
1030         if (c < a) return (false, 0);
1031         return (true, c);
1032     }
1033 
1034     /**
1035      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1036      *
1037      * _Available since v3.4._
1038      */
1039     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1040         if (b > a) return (false, 0);
1041         return (true, a - b);
1042     }
1043 
1044     /**
1045      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1046      *
1047      * _Available since v3.4._
1048      */
1049     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1050         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1051         // benefit is lost if 'b' is also tested.
1052         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1053         if (a == 0) return (true, 0);
1054         uint256 c = a * b;
1055         if (c / a != b) return (false, 0);
1056         return (true, c);
1057     }
1058 
1059     /**
1060      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1061      *
1062      * _Available since v3.4._
1063      */
1064     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1065         if (b == 0) return (false, 0);
1066         return (true, a / b);
1067     }
1068 
1069     /**
1070      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1071      *
1072      * _Available since v3.4._
1073      */
1074     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1075         if (b == 0) return (false, 0);
1076         return (true, a % b);
1077     }
1078 
1079     /**
1080      * @dev Returns the addition of two unsigned integers, reverting on
1081      * overflow.
1082      *
1083      * Counterpart to Solidity's `+` operator.
1084      *
1085      * Requirements:
1086      *
1087      * - Addition cannot overflow.
1088      */
1089     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1090         uint256 c = a + b;
1091         require(c >= a, "SafeMath: addition overflow");
1092         return c;
1093     }
1094 
1095     /**
1096      * @dev Returns the subtraction of two unsigned integers, reverting on
1097      * overflow (when the result is negative).
1098      *
1099      * Counterpart to Solidity's `-` operator.
1100      *
1101      * Requirements:
1102      *
1103      * - Subtraction cannot overflow.
1104      */
1105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1106         require(b <= a, "SafeMath: subtraction overflow");
1107         return a - b;
1108     }
1109 
1110     /**
1111      * @dev Returns the multiplication of two unsigned integers, reverting on
1112      * overflow.
1113      
1114      * Counterpart to Solidity's `*` operator.
1115      *
1116      * Requirements:
1117      *
1118      * - Multiplication cannot overflow.
1119      */
1120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1121         if (a == 0) return 0;
1122         uint256 c = a * b;
1123         require(c / a == b, "SafeMath: multiplication overflow");
1124         return c;
1125     }
1126 
1127     /**
1128      * @dev Returns the integer division of two unsigned integers, reverting on
1129      * division by zero. The result is rounded towards zero.
1130      *
1131      * Counterpart to Solidity's `/` operator. Note: this function uses a
1132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1133      * uses an invalid opcode to revert (consuming all remaining gas).
1134      *
1135      * Requirements:
1136      *
1137      * - The divisor cannot be zero.
1138      */
1139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1140         require(b > 0, "SafeMath: division by zero");
1141         return a / b;
1142     }
1143 
1144     /**
1145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1146      * reverting when dividing by zero.
1147      *
1148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1149      * opcode (which leaves remaining gas untouched) while Solidity uses an
1150      * invalid opcode to revert (consuming all remaining gas).
1151      *
1152      * Requirements:
1153      *
1154      * - The divisor cannot be zero.
1155      */
1156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1157         require(b > 0, "SafeMath: modulo by zero");
1158         return a % b;
1159     }
1160 
1161     /**
1162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1163      * overflow (when the result is negative).
1164      *
1165      * CAUTION: This function is deprecated because it requires allocating memory for the error
1166      * message unnecessarily. For custom revert reasons use {trySub}.
1167      *
1168      * Counterpart to Solidity's `-` operator.
1169      *
1170      * Requirements:
1171      *
1172      * - Subtraction cannot overflow.
1173      */
1174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1175         require(b <= a, errorMessage);
1176         return a - b;
1177     }
1178 
1179     /**
1180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1181      * division by zero. The result is rounded towards zero.
1182      *
1183      * CAUTION: This function is deprecated because it requires allocating memory for the error
1184      * message unnecessarily. For custom revert reasons use {tryDiv}.
1185      *
1186      * Counterpart to Solidity's `/` operator. Note: this function uses a
1187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1188      * uses an invalid opcode to revert (consuming all remaining gas).
1189      *
1190      * Requirements:
1191      *
1192      * - The divisor cannot be zero.
1193      */
1194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1195         require(b > 0, errorMessage);
1196         return a / b;
1197     }
1198 
1199     /**
1200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1201      * reverting with custom message when dividing by zero.
1202      *
1203      * CAUTION: This function is deprecated because it requires allocating memory for the error
1204      * message unnecessarily. For custom revert reasons use {tryMod}.
1205      *
1206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1207      * opcode (which leaves remaining gas untouched) while Solidity uses an
1208      * invalid opcode to revert (consuming all remaining gas).
1209      *
1210      * Requirements:
1211      *
1212      * - The divisor cannot be zero.
1213      */
1214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1215         require(b > 0, errorMessage);
1216         return a % b;
1217     }
1218 
1219 }
1220 library TransferHelper {
1221     function safeApprove(
1222         address token,
1223         address to,
1224         uint256 value
1225     ) internal {
1226         // bytes4(keccak256(bytes('approve(address,uint256)')));
1227         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
1228         require(
1229             success && (data.length == 0 || abi.decode(data, (bool))),
1230             'TransferHelper::safeApprove: approve failed'
1231         );
1232     }
1233 
1234     function safeTransfer(
1235         address token,
1236         address to,
1237         uint256 value
1238     ) internal {
1239         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1240         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
1241         require(
1242             success && (data.length == 0 || abi.decode(data, (bool))),
1243             'TransferHelper::safeTransfer: transfer failed'
1244         );
1245     }
1246 
1247     function safeTransferFrom(
1248         address token,
1249         address from,
1250         address to,
1251         uint256 value
1252     ) internal {
1253         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1254         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
1255         require(
1256             success && (data.length == 0 || abi.decode(data, (bool))),
1257             'TransferHelper::transferFrom: transferFrom failed'
1258         );
1259     }
1260 
1261     function safeTransferETH(address to, uint256 value) internal {
1262         (bool success, ) = to.call{value: value}(new bytes(0));
1263         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
1264     }
1265 }
1266 
1267 contract DigiMinersLottery is Ownable, ReentrancyGuard {
1268     using SafeMath for uint256;
1269     using ECDSA for bytes32;
1270 
1271     address private signerWallet;
1272 
1273     struct LotteryRound {
1274         uint256 RoundId; //round id
1275         uint256 startTime; //startTime of lottery
1276         uint256 endTime; //endTime of lottery 
1277         uint256 ticketsSold; //tickets sold in this round
1278         uint256 priceClaimed;
1279     } 
1280 
1281     struct Ticket {
1282         address holder; //owner of the ticket (non transferrable)
1283         Ores winningOre;
1284     }
1285 
1286     /* Contract address of DIGI NFT */
1287     IERC721 public DIGI_NFT; 
1288    
1289     /* Current Round of Lottery */
1290     uint256 public LotteryRounds;
1291 
1292     /* Price for Each Ticket */
1293     uint256 public immutable ticketPrice = 0.01 ether;
1294 
1295     // The mask of the lower 160 bits for addresses.
1296     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1297 
1298     // The `PURCHASE` event signature is given by:
1299     //"TicketPurchased(uint256,uint256,address)".
1300     bytes32 private constant _PURCHASE_EVENT_SIGNATURE =
1301     0x94c5953e15f54d38b82a662bdd5739fc91af3a23d3ef7e67269dfaeee71a813c;
1302 
1303 
1304     /* Winning Amount*/
1305     uint256 public constant Vortexia = 0.5 ether;
1306     uint256 public constant Diamond = 0.1 ether;
1307     uint256 public constant Gold = 0.02 ether;
1308     uint256 public constant Emerald = 0.01 ether;
1309     uint256 public constant Bronze = 0.002 ether;
1310     uint256 public constant Iron = 0.001 ether;
1311     
1312     address public manager;
1313 
1314     struct BulkClaim {
1315         uint256 roundId;
1316         uint256[] ticketIds;
1317     }
1318 
1319     struct TicketClaimed {
1320         uint256 ticketId;
1321         address holder;
1322         Ores winningOre;
1323         bool claimed;
1324     }
1325     enum Ores {
1326         Vortexia,
1327         Diamond,
1328         Gold,
1329         Emerald,
1330         Bronze,
1331         Iron
1332     }
1333     /* 
1334     Mapping of Lottery round to nft id which returns uint256 to check how many tickets an NFT has bought;
1335     */
1336     mapping(uint256=>mapping(uint256=>uint256)) public nftUsed;
1337 
1338     mapping(Ores=>uint256) public price;
1339     /* Ticket counter for each round of NFT */
1340     mapping(uint256=>LotteryRound) public RoundDetails;
1341 
1342     /* Mapping of Lottery round to its winning key */
1343     mapping(uint256=>uint256) public winningKey;
1344 
1345     mapping(uint256=>mapping(uint256=>Ticket)) public TicketKey;  
1346 
1347     mapping(uint256=>mapping(uint256=>bool)) public claimed;  
1348 
1349     mapping(Ores=>uint256) private Distributelimit;
1350 
1351     mapping(uint256=>Ores) private checkore;
1352 
1353     mapping(uint256=>mapping(Ores=>uint256)) private claimCounter;
1354 
1355 
1356     event WinningClaimed(uint256 indexed roundId, address indexed wallet);
1357 
1358     /* Ticket Fees is not correct */
1359     error BadFees();
1360     
1361     /* Not owner of the NFT */
1362     error NotOwner();
1363 
1364     /* Fake Signature */
1365     error FakeSignature();
1366 
1367     /* NFT used enough */
1368     error nftConsumed();
1369 
1370     /* Lottery has ended */
1371     error LotteryEnded();
1372 
1373     /* All tickets sold */
1374     error TicketsSold();
1375 
1376     /* Not holder of ticket */
1377     error NotHolder();
1378 
1379     /* Ticket Claimed */
1380 
1381     error AlreadyClaimed();
1382 
1383     /* Caller is contract */
1384     error ContractCall();
1385 
1386     /* Round not ended */
1387     error RoundNotEnded();
1388 
1389     constructor(){
1390         price[Ores.Vortexia]= Vortexia;
1391         price[Ores.Diamond]= Diamond;
1392         price[Ores.Gold]= Gold;
1393         price[Ores.Emerald]= Emerald;
1394         price[Ores.Bronze]= Bronze;
1395         price[Ores.Iron]= Iron;
1396         
1397         checkore[0]=Ores.Vortexia;
1398         checkore[1]=Ores.Diamond;
1399         checkore[2]=Ores.Gold;
1400         checkore[3]=Ores.Emerald;
1401         checkore[4]=Ores.Bronze;
1402         checkore[5]=Ores.Iron;
1403 
1404         Distributelimit[Ores.Vortexia] = 194;
1405         Distributelimit[Ores.Diamond] = 583;
1406         Distributelimit[Ores.Gold] = 3110;
1407         Distributelimit[Ores.Emerald] = 15554;
1408         Distributelimit[Ores.Bronze] = 19442;
1409         Distributelimit[Ores.Iron] = 38888;
1410         startRound(block.timestamp, block.timestamp + 7 days);
1411         signerWallet=0xd2149d74486e2C1b1c8d5a35984835F2b6184f5C;
1412         DIGI_NFT=IERC721(0xEcA22C0FD4ac62D81a5633eB547e6797C9579462);
1413     }
1414 
1415     function isContract(address _addr) private view returns (bool){
1416         uint32 size;
1417         assembly {
1418             size := extcodesize(_addr)
1419     }
1420         return (size > 0);
1421     }
1422 
1423     modifier callerIsWallet {
1424         if(isContract(_msgSender()) && msg.sender == tx.origin) revert ContractCall();
1425         _;
1426     }
1427     
1428     modifier onlyAuth {
1429         require(msg.sender == manager || msg.sender == owner(), "Not Auth");
1430         _;
1431     }
1432 
1433     function setManager(address manager_) public onlyOwner {
1434         manager = manager_;
1435     }
1436 
1437     function random() private view returns(uint){
1438         return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, block.number))) % 10**10;
1439     }
1440 
1441     function getTicketDetails(uint256 roundId, uint256 ticketId) public view returns(Ticket memory){
1442         return TicketKey[roundId][ticketId];
1443     }
1444 
1445     function changeSignerwallet(address _signerWallet) public onlyOwner {
1446         signerWallet = _signerWallet;
1447     }
1448 
1449     function getPrice(Ores ore) public view returns(uint256){
1450         return price[ore];
1451     }
1452 
1453     function currentRound() public view returns(uint256){
1454         return LotteryRounds;
1455     }
1456 
1457     function startRound(uint256 startTime, uint256 endTime) public onlyOwner {
1458         require(block.timestamp > RoundDetails[currentRound()].endTime, "DIGI: Last Round has not ended");
1459         LotteryRounds++;
1460         RoundDetails[LotteryRounds] = LotteryRound(LotteryRounds, startTime, endTime, 0,0);
1461         setKey();
1462     }
1463 
1464     function startRoundbyManager(uint256 startTime, uint256 endTime) public onlyAuth {
1465         require(block.timestamp > RoundDetails[currentRound()].endTime, "DIGI: Last Round has not ended");
1466         LotteryRounds++;
1467         RoundDetails[LotteryRounds] = LotteryRound(LotteryRounds, startTime, endTime, 0,0);
1468         setKey();
1469     }
1470 
1471     function setDIGI_NFT(IERC721 nft_) public onlyOwner {
1472         DIGI_NFT = nft_;
1473     }
1474 
1475     function buyTickets( bytes calldata signature,   uint256 quantity,  uint256 tokenIdHolding,  uint256 multiplier) public payable callerIsWallet nonReentrant {
1476         //require(msg.value == ticketPrice.mul(quantity), "DIGI: Send proper ticket fees");
1477         if(msg.value != ticketPrice.mul(quantity)) revert BadFees();
1478 
1479         //require(DIGI_NFT.ownerOf(tokenIdHolding) == msg.sender, "You are not owner of NFT");        
1480         if(msg.sender != DIGI_NFT.ownerOf(tokenIdHolding)) revert NotOwner();
1481 
1482         uint256 roundId = currentRound();
1483 
1484         //require(checkSign(signature, quantity, tokenIdHolding, miningLevel, _msgSender(), roundId)==signerWallet, "DIGI: Fake signature");
1485         if(checkSign(signature, quantity, tokenIdHolding, multiplier, _msgSender(), roundId) != signerWallet) revert FakeSignature();
1486 
1487         nftUsed[roundId][tokenIdHolding] += quantity;
1488 
1489         //require(nftUsed[roundId][tokenIdHolding] <= 10, "DIGI: NFT used enough");
1490         if(nftUsed[roundId][tokenIdHolding] > 10) revert nftConsumed();
1491 
1492         LotteryRound storage round = RoundDetails[roundId];
1493 
1494         //require(round.endTime>block.timestamp, "DIGI: Lottery has been ended");
1495         if(round.endTime < block.timestamp) revert LotteryEnded();
1496 
1497         uint256 startTicketIndex = round.ticketsSold + 1;
1498         round.ticketsSold += quantity;
1499 
1500         uint256 winningKey_ = getWinningKey(roundId);
1501 
1502         //uint256 multiplier = getMultiplier(miningLevel);
1503         address buyer = _msgSender();
1504 
1505         for(uint256 i= 0;i<quantity;){
1506             uint256 ticketId = startTicketIndex + i;
1507             uint256 ticketKey = getTicketKey(ticketId);
1508             Ores winningOre = getWinningOre(winningKey_, roundId, ticketKey, multiplier);
1509             TicketKey[roundId][ticketId] = Ticket(buyer, winningOre);
1510             emitPurchase(ticketId, roundId, buyer);
1511             unchecked {
1512              ++claimCounter[roundId][winningOre];               
1513 	         ++i;
1514 	        }
1515         }
1516     }
1517 
1518     
1519    
1520 
1521 
1522     function emitPurchase(uint256 ticketId, uint256 roundId, address buyer) internal {
1523          assembly {   
1524         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1525             buyer := and(buyer, _BITMASK_ADDRESS)
1526             // Emit the `Transfer` event.
1527             log4(
1528             0, // Start of data (0, since no data).
1529             0, // End of data (0, since no data).
1530             _PURCHASE_EVENT_SIGNATURE, // Signature.
1531             ticketId, // `startTicketId(0)`.
1532             roundId, // `to`.
1533             buyer // `tokenId`.
1534             )  
1535         }
1536     }
1537 
1538 
1539     function checkSign(bytes calldata signature, uint256 quantity, uint256 tokenIdHolding, uint256 multipler, address wallet, uint256 roundId) private pure returns(address){
1540         return keccak256(
1541             abi.encodePacked(
1542                "\x19Ethereum Signed Message:\n32",
1543                 getSignData(quantity, tokenIdHolding, multipler, wallet, roundId)   
1544             )
1545         ).recover(signature);
1546     }
1547 
1548     function getSignData(uint256 quantity, uint256 tokenIdHolding, uint256 multiplier, address wallet, uint256 roundId) public pure returns(bytes32) {
1549         return (
1550         keccak256(abi.encodePacked(keccak256(abi.encodePacked(wallet)), keccak256(abi.encodePacked(quantity, tokenIdHolding, multiplier, roundId))))
1551         );
1552     }
1553 
1554     function setKey() private {
1555         uint256 roundId = currentRound();
1556         uint256 key = random(); /* will use chainlink in real contract */
1557         winningKey[roundId] = key;
1558     }    
1559 
1560     function distributionLimit(Ores ore) public view returns(uint256){
1561         return Distributelimit[ore];
1562     }
1563 
1564     function SetdistributionLimit(Ores ore, uint256 limit) public onlyOwner {
1565         Distributelimit[ore] = limit;
1566     }
1567 
1568     function checkDistribution(uint256 roundId, Ores ore) public view returns(uint256){
1569         return claimCounter[roundId][ore];
1570     }
1571 
1572     function getTicketKey(uint256 ticketId) private view returns(uint256){
1573         return uint(keccak256(abi.encodePacked(msg.sender, ticketId, block.timestamp, block.difficulty, block.number))) % 10**7;
1574     }
1575 
1576     function getWinningKey(uint256 roundId) public view returns(uint256){
1577         return winningKey[roundId];
1578     }
1579 
1580     function getTicketWinning(uint256 roundId, uint256 ticketId) public view returns(Ores ore){
1581         return TicketKey[roundId][ticketId].winningOre;
1582     }
1583 
1584     function getTicketHolding(address wallet, uint256 roundId) public view returns(TicketClaimed[] memory){
1585         uint256 len;
1586         for(uint256 i = 1; i< RoundDetails[roundId].ticketsSold;i++){
1587             address holder = TicketKey[roundId][i].holder;
1588             if(holder == wallet){
1589                 len++;
1590             }
1591         }
1592 
1593         TicketClaimed[] memory tickets = new TicketClaimed[](len);
1594         uint256 index;
1595         for(uint256 i = 1; i< RoundDetails[roundId].ticketsSold;i++){
1596             address holder = TicketKey[roundId][i].holder;
1597             if(holder == wallet){
1598                 tickets[index] = TicketClaimed(i, TicketKey[roundId][i].holder,TicketKey[roundId][i].winningOre, claimed[roundId][i] );
1599                 index++;
1600             }
1601         }
1602         return tickets;
1603     }
1604 
1605     function getWinningOre(uint256 winningKey_, uint256 roundId, uint256 TicketKey_, uint256 multiplier) private view returns(Ores Ore){
1606        // Ores previousOre = Ores.Iron; //starting from lowest
1607         uint256 mlResult = 99999;
1608         for(uint256 i = 1; i<=multiplier;) {
1609         uint256 multiplierResult= ticketKeyFactory(TicketKey_, i).add(winningKey_) % 10**5 ;
1610             if(mlResult > multiplierResult){
1611                 mlResult = multiplierResult;
1612             }
1613             unchecked {
1614                 ++i;
1615             }
1616         }
1617         Ores previousOre = _getWinningOre(roundId, mlResult);
1618         return previousOre;
1619     }
1620 
1621     function getOreNew(uint256 num) public pure returns(Ores ore) {
1622         require(num <= 100000, "INVALID");
1623         if(45000 <= num && num <= 100000) {
1624             return Ores.Iron;
1625         }
1626         if(10000 <= num && num < 45000) {
1627             return Ores.Bronze;
1628         }
1629         if(4500 <= num && num < 10000) {
1630             return Ores.Emerald;
1631         }                    
1632         if(800 <= num && num < 4500) {
1633             return Ores.Gold;
1634         }
1635         if(200 <= num && num < 800) {
1636             return Ores.Diamond;
1637         } 
1638         if(0 <= num && num < 200) {
1639             return Ores.Vortexia;
1640         }
1641     }
1642     
1643     function _getWinningOre(uint256 roundId, uint256 number) private view returns(Ores){
1644         Ores ore = getOreNew(number);
1645         uint256 nextNum;
1646         if(OreclaimAvailable(roundId, ore) == true){
1647             return ore;
1648         } else {
1649             nextNum = nextOre(roundId);
1650         }
1651         return numberToOre(nextNum);
1652     }
1653 
1654 
1655     function nextOre(uint256 roundId) private view returns(uint256 num){
1656         for(uint256 i = 5; i>=0;){
1657             if(claimAvailable(roundId, i)){
1658                 return i;
1659             }
1660             unchecked {
1661                 ++i;
1662             }
1663         }
1664     }
1665 
1666     function oreToNumber(Ores ore) public pure returns(uint256 num){
1667             return uint256(ore);
1668     }
1669 
1670     function numberToOre(uint256 number) public view returns(Ores ore){
1671         return checkore[number];
1672     }
1673 
1674     function claimAvailable(uint256 roundId, uint256 ore) private view returns(bool){
1675         Ores ore_ = numberToOre(ore);
1676         if(Distributelimit[ore_]>claimCounter[roundId][ore_]){
1677             return true;
1678         }
1679         return false;
1680     }
1681     
1682     function OreclaimAvailable(uint256 roundId, Ores ore_) private view returns(bool){
1683         if(Distributelimit[ore_]>claimCounter[roundId][ore_]){
1684             return true;
1685         }
1686         return false;
1687     }
1688     
1689     function ticketKeyFactory(uint256 ticketKey, uint256 multiplier) public pure returns(uint256){
1690         return (ticketKey.add(multiplier));
1691     }
1692 
1693     function claimAllWinning(uint256 roundId, uint256[] calldata ticketIds) public nonReentrant callerIsWallet {
1694         _claim(roundId, ticketIds);            
1695     }
1696 
1697     function bulkClaim(BulkClaim[] calldata data) public nonReentrant callerIsWallet {
1698         for(uint256 i=0;i<data.length;++i){
1699             uint256 roundId = data[i].roundId;
1700                 _claim(roundId, data[i].ticketIds);
1701         }
1702     }
1703 
1704     function _claim(uint256 roundId, uint256[] calldata ticketIds) private {
1705         if(roundId == currentRound()) revert RoundNotEnded();
1706         uint256 totalWinning;
1707         for(uint256 i=0;i<ticketIds.length;i++){
1708             uint256 winning = preClaim(roundId, ticketIds[i]);
1709             totalWinning += winning;
1710         }
1711         LotteryRound storage round = RoundDetails[roundId];
1712         round.priceClaimed += totalWinning;
1713         TransferHelper.safeTransferETH(_msgSender(), totalWinning);
1714         emit WinningClaimed(totalWinning, _msgSender());
1715     }
1716 
1717     function preClaim(uint256 roundId, uint256 ticketId) private returns(uint256) {
1718         Ticket storage ticket = TicketKey[roundId][ticketId];
1719         if(claimed[roundId][ticketId] == true) revert AlreadyClaimed();
1720         claimed[roundId][ticketId] = true;
1721         if(ticket.holder != _msgSender()) revert NotHolder();
1722         uint256 winning = getPrice(ticket.winningOre);
1723         return winning;
1724     }
1725 
1726     function withdraw(uint256 amount) external onlyOwner {
1727         TransferHelper.safeTransferETH(owner(), amount);
1728     }
1729 
1730     receive() external payable {}
1731 }