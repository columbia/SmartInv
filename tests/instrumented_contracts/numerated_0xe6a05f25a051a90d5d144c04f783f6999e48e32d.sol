1 // SPDX-License-Identifier: MIT
2 // File: WS/R0.sol
3 
4 /**                                         .         .
5 8 888888888o.   8 8888888888            ,8.       ,8.                   .8.            d888888o. 8888888 8888888888 8 8888888888   8 888888888o.
6 8 8888    `88.  8 8888                 ,888.     ,888.                 .888.         .`8888:' `88.     8 8888       8 8888         8 8888    `88.
7 8 8888     `88  8 8888                .`8888.   .`8888.               :88888.        8.`8888.   Y8     8 8888       8 8888         8 8888     `88
8 8 8888     ,88  8 8888               ,8.`8888. ,8.`8888.             . `88888.       `8.`8888.         8 8888       8 8888         8 8888     ,88
9 8 8888.   ,88'  8 888888888888      ,8'8.`8888,8^8.`8888.           .8. `88888.       `8.`8888.        8 8888       8 888888888888 8 8888.   ,88'
10 8 888888888P'   8 8888             ,8' `8.`8888' `8.`8888.         .8`8. `88888.       `8.`8888.       8 8888       8 8888         8 888888888P'
11 8 8888`8b       8 8888            ,8'   `8.`88'   `8.`8888.       .8' `8. `88888.       `8.`8888.      8 8888       8 8888         8 8888`8b
12 8 8888 `8b.     8 8888           ,8'     `8.`'     `8.`8888.     .8'   `8. `88888.  8b   `8.`8888.     8 8888       8 8888         8 8888 `8b.
13 8 8888   `8b.   8 8888          ,8'       `8        `8.`8888.   .888888888. `88888. `8b.  ;8.`8888     8 8888       8 8888         8 8888   `8b.
14 8 8888     `88. 8 888888888888 ,8'         `         `8.`8888. .8'       `8. `88888. `Y8888P ,88P'     8 8888       8 888888888888 8 8888     `88.
15 */
16 
17 pragma solidity ^0.8.0;
18 
19 interface R0 {
20     // R2 Functions
21     function signedUpdateOwnership(
22         uint256 _tokenId,
23         address _owner,
24         bytes memory readSignature,
25         bool _signed
26     ) external;
27 
28     function getNFTContract() external view returns (address);
29 
30     function emitLicenseOwnerChange(
31         uint8 _licenseId,
32         uint256 _tokenId,
33         address _from,
34         address _to,
35         bytes memory _licenseHash,
36         uint256 _expiry
37     ) external;
38 
39     function getR3Address(uint8 _licenseId, uint256 _tokenId)
40         external
41         view
42         returns (address);
43 
44     function contractHash() external view returns (string memory);
45 
46     function signBlock() external view returns (uint256);
47 
48     function getLicenseIssuedHash(uint256 _tokenId)
49         external
50         view
51         returns (bytes32);
52 
53     function r2Transfer(
54         address from,
55         address to,
56         uint256 tokenId
57     ) external;
58 
59     function getLicenseHash(uint8 _licenseId, uint256 _tokenId)
60         external
61         view
62         returns (bytes memory);
63 
64     function escrow() external view returns (address);
65 
66     function getAllParties()
67         external
68         view
69         returns (
70             address,
71             uint16,
72             address,
73             uint16,
74             address,
75             uint16,
76             address,
77             uint16
78         );
79 
80     function getBaseSigners() external view returns (address, address);
81 
82     // IERC721 functions:
83     function ownerOf(uint256 tokenId) external view returns (address owner);
84 
85     // IERC20 functions:
86     function balanceOf(address account) external view returns (uint256);
87 
88     function transfer(address to, uint256 amount) external returns (bool);
89 
90     // R3 Functions
91     function getR3EscrowElements()
92         external
93         view
94         returns (
95             uint16,
96             uint16,
97             uint16,
98             address,
99             uint16
100         );
101 
102     function getR2AddressFromR3() external returns (address);
103 
104     // Escrow Functions
105     function receieveTo(address _to) external payable;
106 
107     function payCommission() external payable;
108 
109     function withdraw() external;
110 
111     // Ownable
112     function owner() external returns (address);
113 }
114 
115 // File: @openzeppelin/contracts/interfaces/IERC1271.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1271.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Interface of the ERC1271 standard signature validation method for
124  * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
125  *
126  * _Available since v4.1._
127  */
128 interface IERC1271 {
129     /**
130      * @dev Should return whether the signature provided is valid for the provided data
131      * @param hash      Hash of the data to be signed
132      * @param signature Signature byte array associated with _data
133      */
134     function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
135 }
136 
137 // File: @openzeppelin/contracts/utils/Strings.sol
138 
139 
140 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev String operations.
146  */
147 library Strings {
148     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
149     uint8 private constant _ADDRESS_LENGTH = 20;
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
153      */
154     function toString(uint256 value) internal pure returns (string memory) {
155         // Inspired by OraclizeAPI's implementation - MIT licence
156         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
157 
158         if (value == 0) {
159             return "0";
160         }
161         uint256 temp = value;
162         uint256 digits;
163         while (temp != 0) {
164             digits++;
165             temp /= 10;
166         }
167         bytes memory buffer = new bytes(digits);
168         while (value != 0) {
169             digits -= 1;
170             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
171             value /= 10;
172         }
173         return string(buffer);
174     }
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
178      */
179     function toHexString(uint256 value) internal pure returns (string memory) {
180         if (value == 0) {
181             return "0x00";
182         }
183         uint256 temp = value;
184         uint256 length = 0;
185         while (temp != 0) {
186             length++;
187             temp >>= 8;
188         }
189         return toHexString(value, length);
190     }
191 
192     /**
193      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
194      */
195     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
196         bytes memory buffer = new bytes(2 * length + 2);
197         buffer[0] = "0";
198         buffer[1] = "x";
199         for (uint256 i = 2 * length + 1; i > 1; --i) {
200             buffer[i] = _HEX_SYMBOLS[value & 0xf];
201             value >>= 4;
202         }
203         require(value == 0, "Strings: hex length insufficient");
204         return string(buffer);
205     }
206 
207     /**
208      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
209      */
210     function toHexString(address addr) internal pure returns (string memory) {
211         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
216 
217 
218 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 
223 /**
224  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
225  *
226  * These functions can be used to verify that a message was signed by the holder
227  * of the private keys of a given address.
228  */
229 library ECDSA {
230     enum RecoverError {
231         NoError,
232         InvalidSignature,
233         InvalidSignatureLength,
234         InvalidSignatureS,
235         InvalidSignatureV
236     }
237 
238     function _throwError(RecoverError error) private pure {
239         if (error == RecoverError.NoError) {
240             return; // no error: do nothing
241         } else if (error == RecoverError.InvalidSignature) {
242             revert("ECDSA: invalid signature");
243         } else if (error == RecoverError.InvalidSignatureLength) {
244             revert("ECDSA: invalid signature length");
245         } else if (error == RecoverError.InvalidSignatureS) {
246             revert("ECDSA: invalid signature 's' value");
247         } else if (error == RecoverError.InvalidSignatureV) {
248             revert("ECDSA: invalid signature 'v' value");
249         }
250     }
251 
252     /**
253      * @dev Returns the address that signed a hashed message (`hash`) with
254      * `signature` or error string. This address can then be used for verification purposes.
255      *
256      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
257      * this function rejects them by requiring the `s` value to be in the lower
258      * half order, and the `v` value to be either 27 or 28.
259      *
260      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
261      * verification to be secure: it is possible to craft signatures that
262      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
263      * this is by receiving a hash of the original message (which may otherwise
264      * be too long), and then calling {toEthSignedMessageHash} on it.
265      *
266      * Documentation for signature generation:
267      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
268      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
269      *
270      * _Available since v4.3._
271      */
272     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
273         if (signature.length == 65) {
274             bytes32 r;
275             bytes32 s;
276             uint8 v;
277             // ecrecover takes the signature parameters, and the only way to get them
278             // currently is to use assembly.
279             /// @solidity memory-safe-assembly
280             assembly {
281                 r := mload(add(signature, 0x20))
282                 s := mload(add(signature, 0x40))
283                 v := byte(0, mload(add(signature, 0x60)))
284             }
285             return tryRecover(hash, v, r, s);
286         } else {
287             return (address(0), RecoverError.InvalidSignatureLength);
288         }
289     }
290 
291     /**
292      * @dev Returns the address that signed a hashed message (`hash`) with
293      * `signature`. This address can then be used for verification purposes.
294      *
295      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
296      * this function rejects them by requiring the `s` value to be in the lower
297      * half order, and the `v` value to be either 27 or 28.
298      *
299      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
300      * verification to be secure: it is possible to craft signatures that
301      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
302      * this is by receiving a hash of the original message (which may otherwise
303      * be too long), and then calling {toEthSignedMessageHash} on it.
304      */
305     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
306         (address recovered, RecoverError error) = tryRecover(hash, signature);
307         _throwError(error);
308         return recovered;
309     }
310 
311     /**
312      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
313      *
314      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
315      *
316      * _Available since v4.3._
317      */
318     function tryRecover(
319         bytes32 hash,
320         bytes32 r,
321         bytes32 vs
322     ) internal pure returns (address, RecoverError) {
323         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
324         uint8 v = uint8((uint256(vs) >> 255) + 27);
325         return tryRecover(hash, v, r, s);
326     }
327 
328     /**
329      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
330      *
331      * _Available since v4.2._
332      */
333     function recover(
334         bytes32 hash,
335         bytes32 r,
336         bytes32 vs
337     ) internal pure returns (address) {
338         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
339         _throwError(error);
340         return recovered;
341     }
342 
343     /**
344      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
345      * `r` and `s` signature fields separately.
346      *
347      * _Available since v4.3._
348      */
349     function tryRecover(
350         bytes32 hash,
351         uint8 v,
352         bytes32 r,
353         bytes32 s
354     ) internal pure returns (address, RecoverError) {
355         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
356         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
357         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
358         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
359         //
360         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
361         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
362         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
363         // these malleable signatures as well.
364         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
365             return (address(0), RecoverError.InvalidSignatureS);
366         }
367         if (v != 27 && v != 28) {
368             return (address(0), RecoverError.InvalidSignatureV);
369         }
370 
371         // If the signature is valid (and not malleable), return the signer address
372         address signer = ecrecover(hash, v, r, s);
373         if (signer == address(0)) {
374             return (address(0), RecoverError.InvalidSignature);
375         }
376 
377         return (signer, RecoverError.NoError);
378     }
379 
380     /**
381      * @dev Overload of {ECDSA-recover} that receives the `v`,
382      * `r` and `s` signature fields separately.
383      */
384     function recover(
385         bytes32 hash,
386         uint8 v,
387         bytes32 r,
388         bytes32 s
389     ) internal pure returns (address) {
390         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
391         _throwError(error);
392         return recovered;
393     }
394 
395     /**
396      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
397      * produces hash corresponding to the one signed with the
398      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
399      * JSON-RPC method as part of EIP-191.
400      *
401      * See {recover}.
402      */
403     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
404         // 32 is the length in bytes of hash,
405         // enforced by the type signature above
406         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
407     }
408 
409     /**
410      * @dev Returns an Ethereum Signed Message, created from `s`. This
411      * produces hash corresponding to the one signed with the
412      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
413      * JSON-RPC method as part of EIP-191.
414      *
415      * See {recover}.
416      */
417     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
418         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
419     }
420 
421     /**
422      * @dev Returns an Ethereum Signed Typed Data, created from a
423      * `domainSeparator` and a `structHash`. This produces hash corresponding
424      * to the one signed with the
425      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
426      * JSON-RPC method as part of EIP-712.
427      *
428      * See {recover}.
429      */
430     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
431         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
432     }
433 }
434 
435 // File: @openzeppelin/contracts/utils/Context.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Provides information about the current execution context, including the
444  * sender of the transaction and its data. While these are generally available
445  * via msg.sender and msg.data, they should not be accessed in such a direct
446  * manner, since when dealing with meta-transactions the account sending and
447  * paying for execution may not be the actual sender (as far as an application
448  * is concerned).
449  *
450  * This contract is only required for intermediate, library-like contracts.
451  */
452 abstract contract Context {
453     function _msgSender() internal view virtual returns (address) {
454         return msg.sender;
455     }
456 
457     function _msgData() internal view virtual returns (bytes calldata) {
458         return msg.data;
459     }
460 }
461 
462 // File: @openzeppelin/contracts/access/Ownable.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Contract module which provides a basic access control mechanism, where
472  * there is an account (an owner) that can be granted exclusive access to
473  * specific functions.
474  *
475  * By default, the owner account will be the one that deploys the contract. This
476  * can later be changed with {transferOwnership}.
477  *
478  * This module is used through inheritance. It will make available the modifier
479  * `onlyOwner`, which can be applied to your functions to restrict their use to
480  * the owner.
481  */
482 abstract contract Ownable is Context {
483     address private _owner;
484 
485     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
486 
487     /**
488      * @dev Initializes the contract setting the deployer as the initial owner.
489      */
490     constructor() {
491         _transferOwnership(_msgSender());
492     }
493 
494     /**
495      * @dev Throws if called by any account other than the owner.
496      */
497     modifier onlyOwner() {
498         _checkOwner();
499         _;
500     }
501 
502     /**
503      * @dev Returns the address of the current owner.
504      */
505     function owner() public view virtual returns (address) {
506         return _owner;
507     }
508 
509     /**
510      * @dev Throws if the sender is not the owner.
511      */
512     function _checkOwner() internal view virtual {
513         require(owner() == _msgSender(), "Ownable: caller is not the owner");
514     }
515 
516     /**
517      * @dev Leaves the contract without owner. It will not be possible to call
518      * `onlyOwner` functions anymore. Can only be called by the current owner.
519      *
520      * NOTE: Renouncing ownership will leave the contract without an owner,
521      * thereby removing any functionality that is only available to the owner.
522      */
523     function renounceOwnership() public virtual onlyOwner {
524         _transferOwnership(address(0));
525     }
526 
527     /**
528      * @dev Transfers ownership of the contract to a new account (`newOwner`).
529      * Can only be called by the current owner.
530      */
531     function transferOwnership(address newOwner) public virtual onlyOwner {
532         require(newOwner != address(0), "Ownable: new owner is the zero address");
533         _transferOwnership(newOwner);
534     }
535 
536     /**
537      * @dev Transfers ownership of the contract to a new account (`newOwner`).
538      * Internal function without access restriction.
539      */
540     function _transferOwnership(address newOwner) internal virtual {
541         address oldOwner = _owner;
542         _owner = newOwner;
543         emit OwnershipTransferred(oldOwner, newOwner);
544     }
545 }
546 
547 // File: @openzeppelin/contracts/security/Pausable.sol
548 
549 
550 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Contract module which allows children to implement an emergency stop
557  * mechanism that can be triggered by an authorized account.
558  *
559  * This module is used through inheritance. It will make available the
560  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
561  * the functions of your contract. Note that they will not be pausable by
562  * simply including this module, only once the modifiers are put in place.
563  */
564 abstract contract Pausable is Context {
565     /**
566      * @dev Emitted when the pause is triggered by `account`.
567      */
568     event Paused(address account);
569 
570     /**
571      * @dev Emitted when the pause is lifted by `account`.
572      */
573     event Unpaused(address account);
574 
575     bool private _paused;
576 
577     /**
578      * @dev Initializes the contract in unpaused state.
579      */
580     constructor() {
581         _paused = false;
582     }
583 
584     /**
585      * @dev Modifier to make a function callable only when the contract is not paused.
586      *
587      * Requirements:
588      *
589      * - The contract must not be paused.
590      */
591     modifier whenNotPaused() {
592         _requireNotPaused();
593         _;
594     }
595 
596     /**
597      * @dev Modifier to make a function callable only when the contract is paused.
598      *
599      * Requirements:
600      *
601      * - The contract must be paused.
602      */
603     modifier whenPaused() {
604         _requirePaused();
605         _;
606     }
607 
608     /**
609      * @dev Returns true if the contract is paused, and false otherwise.
610      */
611     function paused() public view virtual returns (bool) {
612         return _paused;
613     }
614 
615     /**
616      * @dev Throws if the contract is paused.
617      */
618     function _requireNotPaused() internal view virtual {
619         require(!paused(), "Pausable: paused");
620     }
621 
622     /**
623      * @dev Throws if the contract is not paused.
624      */
625     function _requirePaused() internal view virtual {
626         require(paused(), "Pausable: not paused");
627     }
628 
629     /**
630      * @dev Triggers stopped state.
631      *
632      * Requirements:
633      *
634      * - The contract must not be paused.
635      */
636     function _pause() internal virtual whenNotPaused {
637         _paused = true;
638         emit Paused(_msgSender());
639     }
640 
641     /**
642      * @dev Returns to normal state.
643      *
644      * Requirements:
645      *
646      * - The contract must be paused.
647      */
648     function _unpause() internal virtual whenPaused {
649         _paused = false;
650         emit Unpaused(_msgSender());
651     }
652 }
653 
654 // File: @openzeppelin/contracts/utils/Address.sol
655 
656 
657 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
658 
659 pragma solidity ^0.8.1;
660 
661 /**
662  * @dev Collection of functions related to the address type
663  */
664 library Address {
665     /**
666      * @dev Returns true if `account` is a contract.
667      *
668      * [IMPORTANT]
669      * ====
670      * It is unsafe to assume that an address for which this function returns
671      * false is an externally-owned account (EOA) and not a contract.
672      *
673      * Among others, `isContract` will return false for the following
674      * types of addresses:
675      *
676      *  - an externally-owned account
677      *  - a contract in construction
678      *  - an address where a contract will be created
679      *  - an address where a contract lived, but was destroyed
680      * ====
681      *
682      * [IMPORTANT]
683      * ====
684      * You shouldn't rely on `isContract` to protect against flash loan attacks!
685      *
686      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
687      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
688      * constructor.
689      * ====
690      */
691     function isContract(address account) internal view returns (bool) {
692         // This method relies on extcodesize/address.code.length, which returns 0
693         // for contracts in construction, since the code is only stored at the end
694         // of the constructor execution.
695 
696         return account.code.length > 0;
697     }
698 
699     /**
700      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
701      * `recipient`, forwarding all available gas and reverting on errors.
702      *
703      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
704      * of certain opcodes, possibly making contracts go over the 2300 gas limit
705      * imposed by `transfer`, making them unable to receive funds via
706      * `transfer`. {sendValue} removes this limitation.
707      *
708      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
709      *
710      * IMPORTANT: because control is transferred to `recipient`, care must be
711      * taken to not create reentrancy vulnerabilities. Consider using
712      * {ReentrancyGuard} or the
713      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
714      */
715     function sendValue(address payable recipient, uint256 amount) internal {
716         require(address(this).balance >= amount, "Address: insufficient balance");
717 
718         (bool success, ) = recipient.call{value: amount}("");
719         require(success, "Address: unable to send value, recipient may have reverted");
720     }
721 
722     /**
723      * @dev Performs a Solidity function call using a low level `call`. A
724      * plain `call` is an unsafe replacement for a function call: use this
725      * function instead.
726      *
727      * If `target` reverts with a revert reason, it is bubbled up by this
728      * function (like regular Solidity function calls).
729      *
730      * Returns the raw returned data. To convert to the expected return value,
731      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
732      *
733      * Requirements:
734      *
735      * - `target` must be a contract.
736      * - calling `target` with `data` must not revert.
737      *
738      * _Available since v3.1._
739      */
740     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
741         return functionCall(target, data, "Address: low-level call failed");
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
746      * `errorMessage` as a fallback revert reason when `target` reverts.
747      *
748      * _Available since v3.1._
749      */
750     function functionCall(
751         address target,
752         bytes memory data,
753         string memory errorMessage
754     ) internal returns (bytes memory) {
755         return functionCallWithValue(target, data, 0, errorMessage);
756     }
757 
758     /**
759      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
760      * but also transferring `value` wei to `target`.
761      *
762      * Requirements:
763      *
764      * - the calling contract must have an ETH balance of at least `value`.
765      * - the called Solidity function must be `payable`.
766      *
767      * _Available since v3.1._
768      */
769     function functionCallWithValue(
770         address target,
771         bytes memory data,
772         uint256 value
773     ) internal returns (bytes memory) {
774         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
779      * with `errorMessage` as a fallback revert reason when `target` reverts.
780      *
781      * _Available since v3.1._
782      */
783     function functionCallWithValue(
784         address target,
785         bytes memory data,
786         uint256 value,
787         string memory errorMessage
788     ) internal returns (bytes memory) {
789         require(address(this).balance >= value, "Address: insufficient balance for call");
790         require(isContract(target), "Address: call to non-contract");
791 
792         (bool success, bytes memory returndata) = target.call{value: value}(data);
793         return verifyCallResult(success, returndata, errorMessage);
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
798      * but performing a static call.
799      *
800      * _Available since v3.3._
801      */
802     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
803         return functionStaticCall(target, data, "Address: low-level static call failed");
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
808      * but performing a static call.
809      *
810      * _Available since v3.3._
811      */
812     function functionStaticCall(
813         address target,
814         bytes memory data,
815         string memory errorMessage
816     ) internal view returns (bytes memory) {
817         require(isContract(target), "Address: static call to non-contract");
818 
819         (bool success, bytes memory returndata) = target.staticcall(data);
820         return verifyCallResult(success, returndata, errorMessage);
821     }
822 
823     /**
824      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
825      * but performing a delegate call.
826      *
827      * _Available since v3.4._
828      */
829     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
830         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
831     }
832 
833     /**
834      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
835      * but performing a delegate call.
836      *
837      * _Available since v3.4._
838      */
839     function functionDelegateCall(
840         address target,
841         bytes memory data,
842         string memory errorMessage
843     ) internal returns (bytes memory) {
844         require(isContract(target), "Address: delegate call to non-contract");
845 
846         (bool success, bytes memory returndata) = target.delegatecall(data);
847         return verifyCallResult(success, returndata, errorMessage);
848     }
849 
850     /**
851      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
852      * revert reason using the provided one.
853      *
854      * _Available since v4.3._
855      */
856     function verifyCallResult(
857         bool success,
858         bytes memory returndata,
859         string memory errorMessage
860     ) internal pure returns (bytes memory) {
861         if (success) {
862             return returndata;
863         } else {
864             // Look for revert reason and bubble it up if present
865             if (returndata.length > 0) {
866                 // The easiest way to bubble the revert reason is using memory via assembly
867                 /// @solidity memory-safe-assembly
868                 assembly {
869                     let returndata_size := mload(returndata)
870                     revert(add(32, returndata), returndata_size)
871                 }
872             } else {
873                 revert(errorMessage);
874             }
875         }
876     }
877 }
878 
879 // File: @openzeppelin/contracts/utils/cryptography/SignatureChecker.sol
880 
881 
882 // OpenZeppelin Contracts (last updated v4.7.1) (utils/cryptography/SignatureChecker.sol)
883 
884 pragma solidity ^0.8.0;
885 
886 
887 
888 
889 /**
890  * @dev Signature verification helper that can be used instead of `ECDSA.recover` to seamlessly support both ECDSA
891  * signatures from externally owned accounts (EOAs) as well as ERC1271 signatures from smart contract wallets like
892  * Argent and Gnosis Safe.
893  *
894  * _Available since v4.1._
895  */
896 library SignatureChecker {
897     /**
898      * @dev Checks if a signature is valid for a given signer and data hash. If the signer is a smart contract, the
899      * signature is validated against that smart contract using ERC1271, otherwise it's validated using `ECDSA.recover`.
900      *
901      * NOTE: Unlike ECDSA signatures, contract signatures are revocable, and the outcome of this function can thus
902      * change through time. It could return true at block N and false at block N+1 (or the opposite).
903      */
904     function isValidSignatureNow(
905         address signer,
906         bytes32 hash,
907         bytes memory signature
908     ) internal view returns (bool) {
909         (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
910         if (error == ECDSA.RecoverError.NoError && recovered == signer) {
911             return true;
912         }
913 
914         (bool success, bytes memory result) = signer.staticcall(
915             abi.encodeWithSelector(IERC1271.isValidSignature.selector, hash, signature)
916         );
917         return (success &&
918             result.length == 32 &&
919             abi.decode(result, (bytes32)) == bytes32(IERC1271.isValidSignature.selector));
920     }
921 }
922 
923 // File: WS/Permission.sol
924 
925 
926 pragma solidity ^0.8.0;
927 
928 
929 library Permission {
930     function permissionCheck(
931         bytes32 _message,
932         bytes[] memory _signatures,
933         address[] memory _signers
934     ) internal view returns (bool) {
935         bytes32 prefixedMessage = ECDSA.toEthSignedMessageHash(_message);
936         uint256 signersLen = _signers.length;
937         for (uint256 i; i < signersLen; ++i) {
938             if (
939                 !SignatureChecker.isValidSignatureNow(
940                     _signers[i],
941                     prefixedMessage,
942                     _signatures[i]
943                 )
944             ) {
945                 return false;
946             }
947         }
948         return true;
949     }
950 }
951 
952 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
953 
954 
955 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
956 
957 pragma solidity ^0.8.0;
958 
959 /**
960  * @title ERC721 token receiver interface
961  * @dev Interface for any contract that wants to support safeTransfers
962  * from ERC721 asset contracts.
963  */
964 interface IERC721Receiver {
965     /**
966      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
967      * by `operator` from `from`, this function is called.
968      *
969      * It must return its Solidity selector to confirm the token transfer.
970      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
971      *
972      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
973      */
974     function onERC721Received(
975         address operator,
976         address from,
977         uint256 tokenId,
978         bytes calldata data
979     ) external returns (bytes4);
980 }
981 
982 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
983 
984 
985 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
986 
987 pragma solidity ^0.8.0;
988 
989 /**
990  * @dev Interface of the ERC165 standard, as defined in the
991  * https://eips.ethereum.org/EIPS/eip-165[EIP].
992  *
993  * Implementers can declare support of contract interfaces, which can then be
994  * queried by others ({ERC165Checker}).
995  *
996  * For an implementation, see {ERC165}.
997  */
998 interface IERC165 {
999     /**
1000      * @dev Returns true if this contract implements the interface defined by
1001      * `interfaceId`. See the corresponding
1002      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1003      * to learn more about how these ids are created.
1004      *
1005      * This function call must use less than 30 000 gas.
1006      */
1007     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1008 }
1009 
1010 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1011 
1012 
1013 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 
1018 /**
1019  * @dev Implementation of the {IERC165} interface.
1020  *
1021  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1022  * for the additional interface id that will be supported. For example:
1023  *
1024  * ```solidity
1025  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1026  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1027  * }
1028  * ```
1029  *
1030  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1031  */
1032 abstract contract ERC165 is IERC165 {
1033     /**
1034      * @dev See {IERC165-supportsInterface}.
1035      */
1036     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1037         return interfaceId == type(IERC165).interfaceId;
1038     }
1039 }
1040 
1041 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1042 
1043 
1044 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 /**
1050  * @dev Required interface of an ERC721 compliant contract.
1051  */
1052 interface IERC721 is IERC165 {
1053     /**
1054      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1055      */
1056     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1057 
1058     /**
1059      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1060      */
1061     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1062 
1063     /**
1064      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1065      */
1066     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1067 
1068     /**
1069      * @dev Returns the number of tokens in ``owner``'s account.
1070      */
1071     function balanceOf(address owner) external view returns (uint256 balance);
1072 
1073     /**
1074      * @dev Returns the owner of the `tokenId` token.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must exist.
1079      */
1080     function ownerOf(uint256 tokenId) external view returns (address owner);
1081 
1082     /**
1083      * @dev Safely transfers `tokenId` token from `from` to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must exist and be owned by `from`.
1090      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1091      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function safeTransferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes calldata data
1100     ) external;
1101 
1102     /**
1103      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1104      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1105      *
1106      * Requirements:
1107      *
1108      * - `from` cannot be the zero address.
1109      * - `to` cannot be the zero address.
1110      * - `tokenId` token must exist and be owned by `from`.
1111      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1112      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function safeTransferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) external;
1121 
1122     /**
1123      * @dev Transfers `tokenId` token from `from` to `to`.
1124      *
1125      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1126      *
1127      * Requirements:
1128      *
1129      * - `from` cannot be the zero address.
1130      * - `to` cannot be the zero address.
1131      * - `tokenId` token must be owned by `from`.
1132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function transferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) external;
1141 
1142     /**
1143      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1144      * The approval is cleared when the token is transferred.
1145      *
1146      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1147      *
1148      * Requirements:
1149      *
1150      * - The caller must own the token or be an approved operator.
1151      * - `tokenId` must exist.
1152      *
1153      * Emits an {Approval} event.
1154      */
1155     function approve(address to, uint256 tokenId) external;
1156 
1157     /**
1158      * @dev Approve or remove `operator` as an operator for the caller.
1159      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1160      *
1161      * Requirements:
1162      *
1163      * - The `operator` cannot be the caller.
1164      *
1165      * Emits an {ApprovalForAll} event.
1166      */
1167     function setApprovalForAll(address operator, bool _approved) external;
1168 
1169     /**
1170      * @dev Returns the account approved for `tokenId` token.
1171      *
1172      * Requirements:
1173      *
1174      * - `tokenId` must exist.
1175      */
1176     function getApproved(uint256 tokenId) external view returns (address operator);
1177 
1178     /**
1179      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1180      *
1181      * See {setApprovalForAll}
1182      */
1183     function isApprovedForAll(address owner, address operator) external view returns (bool);
1184 }
1185 
1186 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1187 
1188 
1189 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 
1194 /**
1195  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1196  * @dev See https://eips.ethereum.org/EIPS/eip-721
1197  */
1198 interface IERC721Enumerable is IERC721 {
1199     /**
1200      * @dev Returns the total amount of tokens stored by the contract.
1201      */
1202     function totalSupply() external view returns (uint256);
1203 
1204     /**
1205      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1206      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1207      */
1208     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1209 
1210     /**
1211      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1212      * Use along with {totalSupply} to enumerate all tokens.
1213      */
1214     function tokenByIndex(uint256 index) external view returns (uint256);
1215 }
1216 
1217 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1218 
1219 
1220 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1221 
1222 pragma solidity ^0.8.0;
1223 
1224 
1225 /**
1226  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1227  * @dev See https://eips.ethereum.org/EIPS/eip-721
1228  */
1229 interface IERC721Metadata is IERC721 {
1230     /**
1231      * @dev Returns the token collection name.
1232      */
1233     function name() external view returns (string memory);
1234 
1235     /**
1236      * @dev Returns the token collection symbol.
1237      */
1238     function symbol() external view returns (string memory);
1239 
1240     /**
1241      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1242      */
1243     function tokenURI(uint256 tokenId) external view returns (string memory);
1244 }
1245 
1246 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1247 
1248 
1249 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1250 
1251 pragma solidity ^0.8.0;
1252 
1253 
1254 
1255 
1256 
1257 
1258 
1259 
1260 /**
1261  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1262  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1263  * {ERC721Enumerable}.
1264  */
1265 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1266     using Address for address;
1267     using Strings for uint256;
1268 
1269     // Token name
1270     string private _name;
1271 
1272     // Token symbol
1273     string private _symbol;
1274 
1275     // Mapping from token ID to owner address
1276     mapping(uint256 => address) private _owners;
1277 
1278     // Mapping owner address to token count
1279     mapping(address => uint256) private _balances;
1280 
1281     // Mapping from token ID to approved address
1282     mapping(uint256 => address) private _tokenApprovals;
1283 
1284     // Mapping from owner to operator approvals
1285     mapping(address => mapping(address => bool)) private _operatorApprovals;
1286 
1287     /**
1288      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1289      */
1290     constructor(string memory name_, string memory symbol_) {
1291         _name = name_;
1292         _symbol = symbol_;
1293     }
1294 
1295     /**
1296      * @dev See {IERC165-supportsInterface}.
1297      */
1298     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1299         return
1300             interfaceId == type(IERC721).interfaceId ||
1301             interfaceId == type(IERC721Metadata).interfaceId ||
1302             super.supportsInterface(interfaceId);
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-balanceOf}.
1307      */
1308     function balanceOf(address owner) public view virtual override returns (uint256) {
1309         require(owner != address(0), "ERC721: address zero is not a valid owner");
1310         return _balances[owner];
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-ownerOf}.
1315      */
1316     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1317         address owner = _owners[tokenId];
1318         require(owner != address(0), "ERC721: invalid token ID");
1319         return owner;
1320     }
1321 
1322     /**
1323      * @dev See {IERC721Metadata-name}.
1324      */
1325     function name() public view virtual override returns (string memory) {
1326         return _name;
1327     }
1328 
1329     /**
1330      * @dev See {IERC721Metadata-symbol}.
1331      */
1332     function symbol() public view virtual override returns (string memory) {
1333         return _symbol;
1334     }
1335 
1336     /**
1337      * @dev See {IERC721Metadata-tokenURI}.
1338      */
1339     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1340         _requireMinted(tokenId);
1341 
1342         string memory baseURI = _baseURI();
1343         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1344     }
1345 
1346     /**
1347      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1348      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1349      * by default, can be overridden in child contracts.
1350      */
1351     function _baseURI() internal view virtual returns (string memory) {
1352         return "";
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-approve}.
1357      */
1358     function approve(address to, uint256 tokenId) public virtual override {
1359         address owner = ERC721.ownerOf(tokenId);
1360         require(to != owner, "ERC721: approval to current owner");
1361 
1362         require(
1363             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1364             "ERC721: approve caller is not token owner nor approved for all"
1365         );
1366 
1367         _approve(to, tokenId);
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-getApproved}.
1372      */
1373     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1374         _requireMinted(tokenId);
1375 
1376         return _tokenApprovals[tokenId];
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-setApprovalForAll}.
1381      */
1382     function setApprovalForAll(address operator, bool approved) public virtual override {
1383         _setApprovalForAll(_msgSender(), operator, approved);
1384     }
1385 
1386     /**
1387      * @dev See {IERC721-isApprovedForAll}.
1388      */
1389     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1390         return _operatorApprovals[owner][operator];
1391     }
1392 
1393     /**
1394      * @dev See {IERC721-transferFrom}.
1395      */
1396     function transferFrom(
1397         address from,
1398         address to,
1399         uint256 tokenId
1400     ) public virtual override {
1401         //solhint-disable-next-line max-line-length
1402         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1403 
1404         _transfer(from, to, tokenId);
1405     }
1406 
1407     /**
1408      * @dev See {IERC721-safeTransferFrom}.
1409      */
1410     function safeTransferFrom(
1411         address from,
1412         address to,
1413         uint256 tokenId
1414     ) public virtual override {
1415         safeTransferFrom(from, to, tokenId, "");
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-safeTransferFrom}.
1420      */
1421     function safeTransferFrom(
1422         address from,
1423         address to,
1424         uint256 tokenId,
1425         bytes memory data
1426     ) public virtual override {
1427         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1428         _safeTransfer(from, to, tokenId, data);
1429     }
1430 
1431     /**
1432      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1433      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1434      *
1435      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1436      *
1437      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1438      * implement alternative mechanisms to perform token transfer, such as signature-based.
1439      *
1440      * Requirements:
1441      *
1442      * - `from` cannot be the zero address.
1443      * - `to` cannot be the zero address.
1444      * - `tokenId` token must exist and be owned by `from`.
1445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1446      *
1447      * Emits a {Transfer} event.
1448      */
1449     function _safeTransfer(
1450         address from,
1451         address to,
1452         uint256 tokenId,
1453         bytes memory data
1454     ) internal virtual {
1455         _transfer(from, to, tokenId);
1456         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1457     }
1458 
1459     /**
1460      * @dev Returns whether `tokenId` exists.
1461      *
1462      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1463      *
1464      * Tokens start existing when they are minted (`_mint`),
1465      * and stop existing when they are burned (`_burn`).
1466      */
1467     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1468         return _owners[tokenId] != address(0);
1469     }
1470 
1471     /**
1472      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1473      *
1474      * Requirements:
1475      *
1476      * - `tokenId` must exist.
1477      */
1478     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1479         address owner = ERC721.ownerOf(tokenId);
1480         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1481     }
1482 
1483     /**
1484      * @dev Safely mints `tokenId` and transfers it to `to`.
1485      *
1486      * Requirements:
1487      *
1488      * - `tokenId` must not exist.
1489      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function _safeMint(address to, uint256 tokenId) internal virtual {
1494         _safeMint(to, tokenId, "");
1495     }
1496 
1497     /**
1498      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1499      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1500      */
1501     function _safeMint(
1502         address to,
1503         uint256 tokenId,
1504         bytes memory data
1505     ) internal virtual {
1506         _mint(to, tokenId);
1507         require(
1508             _checkOnERC721Received(address(0), to, tokenId, data),
1509             "ERC721: transfer to non ERC721Receiver implementer"
1510         );
1511     }
1512 
1513     /**
1514      * @dev Mints `tokenId` and transfers it to `to`.
1515      *
1516      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1517      *
1518      * Requirements:
1519      *
1520      * - `tokenId` must not exist.
1521      * - `to` cannot be the zero address.
1522      *
1523      * Emits a {Transfer} event.
1524      */
1525     function _mint(address to, uint256 tokenId) internal virtual {
1526         require(to != address(0), "ERC721: mint to the zero address");
1527         require(!_exists(tokenId), "ERC721: token already minted");
1528 
1529         _beforeTokenTransfer(address(0), to, tokenId);
1530 
1531         _balances[to] += 1;
1532         _owners[tokenId] = to;
1533 
1534         emit Transfer(address(0), to, tokenId);
1535 
1536         _afterTokenTransfer(address(0), to, tokenId);
1537     }
1538 
1539     /**
1540      * @dev Destroys `tokenId`.
1541      * The approval is cleared when the token is burned.
1542      *
1543      * Requirements:
1544      *
1545      * - `tokenId` must exist.
1546      *
1547      * Emits a {Transfer} event.
1548      */
1549     function _burn(uint256 tokenId) internal virtual {
1550         address owner = ERC721.ownerOf(tokenId);
1551 
1552         _beforeTokenTransfer(owner, address(0), tokenId);
1553 
1554         // Clear approvals
1555         _approve(address(0), tokenId);
1556 
1557         _balances[owner] -= 1;
1558         delete _owners[tokenId];
1559 
1560         emit Transfer(owner, address(0), tokenId);
1561 
1562         _afterTokenTransfer(owner, address(0), tokenId);
1563     }
1564 
1565     /**
1566      * @dev Transfers `tokenId` from `from` to `to`.
1567      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1568      *
1569      * Requirements:
1570      *
1571      * - `to` cannot be the zero address.
1572      * - `tokenId` token must be owned by `from`.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _transfer(
1577         address from,
1578         address to,
1579         uint256 tokenId
1580     ) internal virtual {
1581         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1582         require(to != address(0), "ERC721: transfer to the zero address");
1583 
1584         _beforeTokenTransfer(from, to, tokenId);
1585 
1586         // Clear approvals from the previous owner
1587         _approve(address(0), tokenId);
1588 
1589         _balances[from] -= 1;
1590         _balances[to] += 1;
1591         _owners[tokenId] = to;
1592 
1593         emit Transfer(from, to, tokenId);
1594 
1595         _afterTokenTransfer(from, to, tokenId);
1596     }
1597 
1598     /**
1599      * @dev Approve `to` to operate on `tokenId`
1600      *
1601      * Emits an {Approval} event.
1602      */
1603     function _approve(address to, uint256 tokenId) internal virtual {
1604         _tokenApprovals[tokenId] = to;
1605         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1606     }
1607 
1608     /**
1609      * @dev Approve `operator` to operate on all of `owner` tokens
1610      *
1611      * Emits an {ApprovalForAll} event.
1612      */
1613     function _setApprovalForAll(
1614         address owner,
1615         address operator,
1616         bool approved
1617     ) internal virtual {
1618         require(owner != operator, "ERC721: approve to caller");
1619         _operatorApprovals[owner][operator] = approved;
1620         emit ApprovalForAll(owner, operator, approved);
1621     }
1622 
1623     /**
1624      * @dev Reverts if the `tokenId` has not been minted yet.
1625      */
1626     function _requireMinted(uint256 tokenId) internal view virtual {
1627         require(_exists(tokenId), "ERC721: invalid token ID");
1628     }
1629 
1630     /**
1631      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1632      * The call is not executed if the target address is not a contract.
1633      *
1634      * @param from address representing the previous owner of the given token ID
1635      * @param to target address that will receive the tokens
1636      * @param tokenId uint256 ID of the token to be transferred
1637      * @param data bytes optional data to send along with the call
1638      * @return bool whether the call correctly returned the expected magic value
1639      */
1640     function _checkOnERC721Received(
1641         address from,
1642         address to,
1643         uint256 tokenId,
1644         bytes memory data
1645     ) private returns (bool) {
1646         if (to.isContract()) {
1647             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1648                 return retval == IERC721Receiver.onERC721Received.selector;
1649             } catch (bytes memory reason) {
1650                 if (reason.length == 0) {
1651                     revert("ERC721: transfer to non ERC721Receiver implementer");
1652                 } else {
1653                     /// @solidity memory-safe-assembly
1654                     assembly {
1655                         revert(add(32, reason), mload(reason))
1656                     }
1657                 }
1658             }
1659         } else {
1660             return true;
1661         }
1662     }
1663 
1664     /**
1665      * @dev Hook that is called before any token transfer. This includes minting
1666      * and burning.
1667      *
1668      * Calling conditions:
1669      *
1670      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1671      * transferred to `to`.
1672      * - When `from` is zero, `tokenId` will be minted for `to`.
1673      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1674      * - `from` and `to` are never both zero.
1675      *
1676      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1677      */
1678     function _beforeTokenTransfer(
1679         address from,
1680         address to,
1681         uint256 tokenId
1682     ) internal virtual {}
1683 
1684     /**
1685      * @dev Hook that is called after any transfer of tokens. This includes
1686      * minting and burning.
1687      *
1688      * Calling conditions:
1689      *
1690      * - when `from` and `to` are both non-zero.
1691      * - `from` and `to` are never both zero.
1692      *
1693      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1694      */
1695     function _afterTokenTransfer(
1696         address from,
1697         address to,
1698         uint256 tokenId
1699     ) internal virtual {}
1700 }
1701 
1702 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1703 
1704 
1705 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1706 
1707 pragma solidity ^0.8.0;
1708 
1709 
1710 /**
1711  * @dev ERC721 token with storage based token URI management.
1712  */
1713 abstract contract ERC721URIStorage is ERC721 {
1714     using Strings for uint256;
1715 
1716     // Optional mapping for token URIs
1717     mapping(uint256 => string) private _tokenURIs;
1718 
1719     /**
1720      * @dev See {IERC721Metadata-tokenURI}.
1721      */
1722     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1723         _requireMinted(tokenId);
1724 
1725         string memory _tokenURI = _tokenURIs[tokenId];
1726         string memory base = _baseURI();
1727 
1728         // If there is no base URI, return the token URI.
1729         if (bytes(base).length == 0) {
1730             return _tokenURI;
1731         }
1732         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1733         if (bytes(_tokenURI).length > 0) {
1734             return string(abi.encodePacked(base, _tokenURI));
1735         }
1736 
1737         return super.tokenURI(tokenId);
1738     }
1739 
1740     /**
1741      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1742      *
1743      * Requirements:
1744      *
1745      * - `tokenId` must exist.
1746      */
1747     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1748         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1749         _tokenURIs[tokenId] = _tokenURI;
1750     }
1751 
1752     /**
1753      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1754      * token-specific URI was set for the token, and if so, it deletes the token URI from
1755      * the storage mapping.
1756      */
1757     function _burn(uint256 tokenId) internal virtual override {
1758         super._burn(tokenId);
1759 
1760         if (bytes(_tokenURIs[tokenId]).length != 0) {
1761             delete _tokenURIs[tokenId];
1762         }
1763     }
1764 }
1765 
1766 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1767 
1768 
1769 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1770 
1771 pragma solidity ^0.8.0;
1772 
1773 
1774 
1775 /**
1776  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1777  * enumerability of all the token ids in the contract as well as all token ids owned by each
1778  * account.
1779  */
1780 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1781     // Mapping from owner to list of owned token IDs
1782     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1783 
1784     // Mapping from token ID to index of the owner tokens list
1785     mapping(uint256 => uint256) private _ownedTokensIndex;
1786 
1787     // Array with all token ids, used for enumeration
1788     uint256[] private _allTokens;
1789 
1790     // Mapping from token id to position in the allTokens array
1791     mapping(uint256 => uint256) private _allTokensIndex;
1792 
1793     /**
1794      * @dev See {IERC165-supportsInterface}.
1795      */
1796     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1797         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1798     }
1799 
1800     /**
1801      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1802      */
1803     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1804         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1805         return _ownedTokens[owner][index];
1806     }
1807 
1808     /**
1809      * @dev See {IERC721Enumerable-totalSupply}.
1810      */
1811     function totalSupply() public view virtual override returns (uint256) {
1812         return _allTokens.length;
1813     }
1814 
1815     /**
1816      * @dev See {IERC721Enumerable-tokenByIndex}.
1817      */
1818     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1819         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1820         return _allTokens[index];
1821     }
1822 
1823     /**
1824      * @dev Hook that is called before any token transfer. This includes minting
1825      * and burning.
1826      *
1827      * Calling conditions:
1828      *
1829      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1830      * transferred to `to`.
1831      * - When `from` is zero, `tokenId` will be minted for `to`.
1832      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1833      * - `from` cannot be the zero address.
1834      * - `to` cannot be the zero address.
1835      *
1836      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1837      */
1838     function _beforeTokenTransfer(
1839         address from,
1840         address to,
1841         uint256 tokenId
1842     ) internal virtual override {
1843         super._beforeTokenTransfer(from, to, tokenId);
1844 
1845         if (from == address(0)) {
1846             _addTokenToAllTokensEnumeration(tokenId);
1847         } else if (from != to) {
1848             _removeTokenFromOwnerEnumeration(from, tokenId);
1849         }
1850         if (to == address(0)) {
1851             _removeTokenFromAllTokensEnumeration(tokenId);
1852         } else if (to != from) {
1853             _addTokenToOwnerEnumeration(to, tokenId);
1854         }
1855     }
1856 
1857     /**
1858      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1859      * @param to address representing the new owner of the given token ID
1860      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1861      */
1862     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1863         uint256 length = ERC721.balanceOf(to);
1864         _ownedTokens[to][length] = tokenId;
1865         _ownedTokensIndex[tokenId] = length;
1866     }
1867 
1868     /**
1869      * @dev Private function to add a token to this extension's token tracking data structures.
1870      * @param tokenId uint256 ID of the token to be added to the tokens list
1871      */
1872     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1873         _allTokensIndex[tokenId] = _allTokens.length;
1874         _allTokens.push(tokenId);
1875     }
1876 
1877     /**
1878      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1879      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1880      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1881      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1882      * @param from address representing the previous owner of the given token ID
1883      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1884      */
1885     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1886         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1887         // then delete the last slot (swap and pop).
1888 
1889         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1890         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1891 
1892         // When the token to delete is the last token, the swap operation is unnecessary
1893         if (tokenIndex != lastTokenIndex) {
1894             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1895 
1896             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1897             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1898         }
1899 
1900         // This also deletes the contents at the last position of the array
1901         delete _ownedTokensIndex[tokenId];
1902         delete _ownedTokens[from][lastTokenIndex];
1903     }
1904 
1905     /**
1906      * @dev Private function to remove a token from this extension's token tracking data structures.
1907      * This has O(1) time complexity, but alters the order of the _allTokens array.
1908      * @param tokenId uint256 ID of the token to be removed from the tokens list
1909      */
1910     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1911         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1912         // then delete the last slot (swap and pop).
1913 
1914         uint256 lastTokenIndex = _allTokens.length - 1;
1915         uint256 tokenIndex = _allTokensIndex[tokenId];
1916 
1917         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1918         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1919         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1920         uint256 lastTokenId = _allTokens[lastTokenIndex];
1921 
1922         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1923         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1924 
1925         // This also deletes the contents at the last position of the array
1926         delete _allTokensIndex[tokenId];
1927         _allTokens.pop();
1928     }
1929 }
1930 
1931 // File: WS/RemasterNFT.sol
1932 
1933 
1934 pragma solidity ^0.8.2;
1935 
1936 
1937 
1938 
1939 
1940 
1941 
1942 
1943 /// @title RemasterNFT
1944 /// @author Remaster
1945 /// @notice This contract is used to implement NFT as per ERC-721 standard
1946 contract RemasterNFT is ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {
1947     // ** State Variables
1948 
1949     string public _signing_var;
1950     string public buri =
1951         "http://init-multibeast.remaster.io/";
1952     bool public isNormalTransferEnabled = true;
1953     bool public isMintingEnabled;
1954     uint256 public mintPrice;
1955     uint256 public mintLimit;
1956     uint256 public constant MAX_SUPPLY = 4444;
1957     R0 public r2Contract;
1958 
1959     mapping(address => uint256) public userMintCount;
1960 
1961     // ** Events
1962 
1963     event Mint(address owner, uint256 indexed tokenId, uint8 surveyCode);
1964 
1965     // ** Modifiers
1966 
1967     /// @notice Functions using this modifier can only be called by the R2 contract.
1968     modifier onlyR2() {
1969         require(msg.sender == address(r2Contract), "Only R2 can call");
1970         _;
1971     }
1972 
1973     /// @notice This modifier is used to check prerequisites for mintPaidToken
1974     modifier mintChecker(uint256 numberOfTokens) {
1975         require(isMintingEnabled, "Minting disabled");
1976         require(address(r2Contract) != address(0), "R2 address not set");
1977 
1978         require(
1979             totalSupply() + numberOfTokens < MAX_SUPPLY,
1980             "Purchase would exceed max supply"
1981         );
1982 
1983         uint256 userBalance = userMintCount[msg.sender] + numberOfTokens;
1984         require(userBalance <= mintLimit, "Minting would exceed mintLimit");
1985         userMintCount[msg.sender] = userBalance;
1986 
1987         require(
1988             msg.value >= mintPrice * numberOfTokens,
1989             "Ether value sent is not correct"
1990         );
1991 
1992         _;
1993     }
1994 
1995     // ** Constructor
1996 
1997     constructor(
1998         string memory _variable,
1999         uint256 _mintLimit,
2000         uint256 _mintPrice
2001     ) ERC721("MultibeastsByHaas", "MTBST") {
2002         _signing_var = _variable;
2003         mintLimit = _mintLimit;
2004         mintPrice = _mintPrice;
2005     }
2006 
2007     // ** Functions
2008 
2009     /** @notice Function that uses the default safeTransferFrom in ERC-721.
2010                 This function does not work if any licenses have been issued for that specific token.
2011                 This function does not work if isNormalTransferEnabled is set to false.
2012     */
2013     /// @param from Source Address
2014     /// @param to Destination Address
2015     /// @param tokenId TokenId of the nft
2016     function safeTransferFrom(
2017         address from,
2018         address to,
2019         uint256 tokenId
2020     ) public virtual override {
2021         require(isNormalTransferEnabled, "Disabled");
2022         require(address(r2Contract) != address(0), "R2 address not set");
2023         require(
2024             r2Contract.getLicenseIssuedHash(tokenId) == "",
2025             "Licenses issued"
2026         );
2027         safeTransferFrom(from, to, tokenId, "");
2028         r2Contract.signedUpdateOwnership(tokenId, to, "", false);
2029     }
2030 
2031     /** @notice Function that uses the default transferFrom in ERC-721.
2032                 This function does not work if any licenses have been issued for that specific token.
2033                 This function does not work if isNormalTransferEnabled is set to false.
2034     */
2035     /// @param from Source Address
2036     /// @param to Destination Address
2037     /// @param tokenId TokenId of the nft
2038     function transferFrom(
2039         address from,
2040         address to,
2041         uint256 tokenId
2042     ) public virtual override {
2043         require(isNormalTransferEnabled, "Disabled");
2044         require(address(r2Contract) != address(0), "R2 address not set");
2045         require(
2046             _isApprovedOrOwner(_msgSender(), tokenId),
2047             "ERC721: transfer caller is not owner nor approved"
2048         );
2049         require(
2050             r2Contract.getLicenseIssuedHash(tokenId) == "",
2051             "Licenses issued"
2052         );
2053         _transfer(from, to, tokenId);
2054         r2Contract.signedUpdateOwnership(tokenId, to, "", false);
2055     }
2056 
2057     /// @notice This function can only be called by the owner of this contract. It is used to mint tokens primarily for people who have paid in fiat currency to an address
2058     /// @param _to The address to which nfts will be minted
2059     /// @param numberOfTokens Number of Tokens to be minted
2060     /// @param readSignature The signature from the `to` address stating he has signed all the T&C
2061     function fiatMint(
2062         address _to,
2063         uint256 numberOfTokens,
2064         bytes memory readSignature
2065     ) public onlyOwner {
2066         require(address(r2Contract) != address(0), "R2 address not set");
2067 
2068         require(
2069             totalSupply() + numberOfTokens < MAX_SUPPLY,
2070             "Purchase would exceed max supply"
2071         );
2072 
2073         internalMint(_to, numberOfTokens, readSignature, 1);
2074     }
2075 
2076     /// @notice This function can only be called whitelisted addresses to mint NFTs
2077     /// @param signature Signature from owner of this contract stating the caller is in whitelist.
2078     /// @param numberOfTokens Number of Tokens to be minted
2079     /// @param readSignature The signature from the caller address stating he has signed all the T&C
2080     function mintPaidToken(
2081         bytes memory signature,
2082         uint256 numberOfTokens,
2083         bytes memory readSignature,
2084         uint8 _surveyCode
2085     ) public payable mintChecker(numberOfTokens) {
2086         bytes32 message = keccak256(abi.encodePacked(_signing_var, msg.sender));
2087 
2088         bytes32 prefixedMessage = ECDSA.toEthSignedMessageHash(message);
2089         require(
2090             SignatureChecker.isValidSignatureNow(
2091                 owner(),
2092                 prefixedMessage,
2093                 signature
2094             ),
2095             "Bad owner Sig"
2096         );
2097 
2098         internalMint(msg.sender, numberOfTokens, readSignature, _surveyCode);
2099 
2100         // Pay to escrow
2101         address escrow = r2Contract.escrow();
2102         (bool sent, ) = escrow.call{value: msg.value}("");
2103         require(sent, "Failed to send Ether");
2104     }
2105 
2106     /// @notice This function can only be called by the R2 contract. It is used to transfer tokens
2107     /// @param from Source Address
2108     /// @param to Destination Address
2109     /// @param tokenId TokenId of the nft
2110     function r2Transfer(
2111         address from,
2112         address to,
2113         uint256 tokenId
2114     ) external onlyR2 {
2115         require(address(r2Contract) != address(0), "R2 address not set");
2116         _safeTransfer(from, to, tokenId, "");
2117     }
2118 
2119     /// @notice Transfer all ETH from this contract to owner address
2120     function withdraw() public onlyOwner {
2121         uint256 balance = address(this).balance;
2122         payable(msg.sender).transfer(balance);
2123     }
2124 
2125     function _baseURI() internal view override returns (string memory) {
2126         return buri;
2127     }
2128 
2129     /// @notice Function to flip the working state of safeTransferFrom and transferFrom functions
2130     function flipNormalTransferState() external onlyOwner {
2131         isNormalTransferEnabled = !isNormalTransferEnabled;
2132     }
2133 
2134     /// @notice Function to flip the minting state on or off
2135     function flipMintingState() external onlyOwner {
2136         isMintingEnabled = !isMintingEnabled;
2137     }
2138 
2139     /// @notice Set R2 Address for this contract
2140     /// @param _r2Address Address of r2 contract
2141     function setR2Address(address _r2Address) external onlyOwner {
2142         r2Contract = R0(_r2Address);
2143     }
2144 
2145     /// @notice Set mint price for one nft
2146     /// @param _amount Amount in wei
2147     function setMintPrice(uint256 _amount) external onlyOwner {
2148         mintPrice = _amount;
2149     }
2150 
2151     /// @notice Set mint limit for each address. mintLimit means how many nft's can be minted by one single address
2152     /// @param _mintLimit Number of tokens
2153     function setMintLimit(uint256 _mintLimit) external onlyOwner {
2154         mintLimit = _mintLimit;
2155     }
2156 
2157     /// @notice Set the baseURI for this collection
2158     /// @param _value Base URL
2159     function setURI(string memory _value) public onlyOwner {
2160         buri = _value;
2161     }
2162 
2163     // ** Helpers/Defaults
2164 
2165     function internalMint(
2166         address _to,
2167         uint256 numberOfTokens,
2168         bytes memory readSignature,
2169         uint8 _surveyCode
2170     ) internal {
2171         uint256 tokenId = totalSupply();
2172         for (uint256 i; i < numberOfTokens; ++i) {
2173             _safeMint(_to, tokenId);
2174             _setTokenURI(tokenId, Strings.toString(tokenId));
2175 
2176             r2Contract.signedUpdateOwnership(tokenId, _to, readSignature, true);
2177             emit Mint(_to, tokenId, _surveyCode);
2178 
2179             tokenId++;
2180         }
2181     }
2182 
2183     /// @notice Pause the contract
2184     function pause() public onlyOwner {
2185         _pause();
2186     }
2187 
2188     /// @notice Unpause the contract
2189     function unpause() public onlyOwner {
2190         _unpause();
2191     }
2192 
2193     function _beforeTokenTransfer(
2194         address from,
2195         address to,
2196         uint256 tokenId
2197     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
2198         super._beforeTokenTransfer(from, to, tokenId);
2199     }
2200 
2201     // The following functions are overrides required by Solidity.
2202 
2203     function _burn(uint256 tokenId)
2204         internal
2205         override(ERC721, ERC721URIStorage)
2206     {
2207         super._burn(tokenId);
2208     }
2209 
2210     function tokenURI(uint256 tokenId)
2211         public
2212         view
2213         override(ERC721, ERC721URIStorage)
2214         returns (string memory)
2215     {
2216         return super.tokenURI(tokenId);
2217     }
2218 
2219     function supportsInterface(bytes4 interfaceId)
2220         public
2221         view
2222         override(ERC721, ERC721Enumerable)
2223         returns (bool)
2224     {
2225         return super.supportsInterface(interfaceId);
2226     }
2227 }