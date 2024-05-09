1 // https://www.daylight.xyz
2 // 🌞
3 
4 //SPDX-License-Identifier: MIT
5 pragma solidity ^0.8.0;
6 
7 /// [MIT License]
8 /// @title Base64
9 /// @notice Provides a function for encoding some bytes in base64
10 /// @author Brecht Devos <brecht@loopring.org>
11 library Utils {
12     bytes internal constant TABLE =
13         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
14 
15     /// @notice Encodes some bytes to the base64 representation
16     function base64Encode(bytes memory data)
17         internal
18         pure
19         returns (string memory)
20     {
21         uint256 len = data.length;
22         if (len == 0) return "";
23 
24         // multiply by 4/3 rounded up
25         uint256 encodedLen = 4 * ((len + 2) / 3);
26 
27         // Add some extra buffer at the end
28         bytes memory result = new bytes(encodedLen + 32);
29 
30         bytes memory table = TABLE;
31 
32         assembly {
33             let tablePtr := add(table, 1)
34             let resultPtr := add(result, 32)
35 
36             for {
37                 let i := 0
38             } lt(i, len) {
39 
40             } {
41                 i := add(i, 3)
42                 let input := and(mload(add(data, i)), 0xffffff)
43 
44                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
45                 out := shl(8, out)
46                 out := add(
47                     out,
48                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
49                 )
50                 out := shl(8, out)
51                 out := add(
52                     out,
53                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
54                 )
55                 out := shl(8, out)
56                 out := add(
57                     out,
58                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
59                 )
60                 out := shl(224, out)
61 
62                 mstore(resultPtr, out)
63 
64                 resultPtr := add(resultPtr, 4)
65             }
66 
67             switch mod(len, 3)
68             case 1 {
69                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
70             }
71             case 2 {
72                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
73             }
74 
75             mstore(result, encodedLen)
76         }
77 
78         return string(result);
79     }
80 
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT license
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     function strlen(string memory s) internal pure returns (uint256) {
104         uint256 len;
105         uint256 i = 0;
106         uint256 bytelength = bytes(s).length;
107         for (len = 0; i < bytelength; len++) {
108             bytes1 b = bytes(s)[i];
109             if (b < 0x80) {
110                 i += 1;
111             } else if (b < 0xE0) {
112                 i += 2;
113             } else if (b < 0xF0) {
114                 i += 3;
115             } else if (b < 0xF8) {
116                 i += 4;
117             } else if (b < 0xFC) {
118                 i += 5;
119             } else {
120                 i += 6;
121             }
122         }
123         return len;
124     }
125 }
126 
127 // File: contracts/TokenRenderer.sol
128 
129 
130 pragma solidity ^0.8.4;
131 
132 interface TokenRenderer {
133     function getTokenURI(uint256 tokenId, string memory name)
134         external
135         view
136         returns (string memory);
137 }
138 
139 // File: @openzeppelin/contracts/utils/Counters.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @title Counters
148  * @author Matt Condon (@shrugs)
149  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
150  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
151  *
152  * Include with `using Counters for Counters.Counter;`
153  */
154 library Counters {
155     struct Counter {
156         // This variable should never be directly accessed by users of the library: interactions must be restricted to
157         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
158         // this feature: see https://github.com/ethereum/solidity/issues/4637
159         uint256 _value; // default: 0
160     }
161 
162     function current(Counter storage counter) internal view returns (uint256) {
163         return counter._value;
164     }
165 
166     function increment(Counter storage counter) internal {
167         unchecked {
168             counter._value += 1;
169         }
170     }
171 
172     function decrement(Counter storage counter) internal {
173         uint256 value = counter._value;
174         require(value > 0, "Counter: decrement overflow");
175         unchecked {
176             counter._value = value - 1;
177         }
178     }
179 
180     function reset(Counter storage counter) internal {
181         counter._value = 0;
182     }
183 }
184 
185 // File: @openzeppelin/contracts/utils/Strings.sol
186 
187 
188 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev String operations.
194  */
195 library Strings {
196     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
197     uint8 private constant _ADDRESS_LENGTH = 20;
198 
199     /**
200      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
201      */
202     function toString(uint256 value) internal pure returns (string memory) {
203         // Inspired by OraclizeAPI's implementation - MIT licence
204         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
205 
206         if (value == 0) {
207             return "0";
208         }
209         uint256 temp = value;
210         uint256 digits;
211         while (temp != 0) {
212             digits++;
213             temp /= 10;
214         }
215         bytes memory buffer = new bytes(digits);
216         while (value != 0) {
217             digits -= 1;
218             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
219             value /= 10;
220         }
221         return string(buffer);
222     }
223 
224     /**
225      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
226      */
227     function toHexString(uint256 value) internal pure returns (string memory) {
228         if (value == 0) {
229             return "0x00";
230         }
231         uint256 temp = value;
232         uint256 length = 0;
233         while (temp != 0) {
234             length++;
235             temp >>= 8;
236         }
237         return toHexString(value, length);
238     }
239 
240     /**
241      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
242      */
243     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
244         bytes memory buffer = new bytes(2 * length + 2);
245         buffer[0] = "0";
246         buffer[1] = "x";
247         for (uint256 i = 2 * length + 1; i > 1; --i) {
248             buffer[i] = _HEX_SYMBOLS[value & 0xf];
249             value >>= 4;
250         }
251         require(value == 0, "Strings: hex length insufficient");
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
257      */
258     function toHexString(address addr) internal pure returns (string memory) {
259         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
264 
265 
266 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 
271 /**
272  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
273  *
274  * These functions can be used to verify that a message was signed by the holder
275  * of the private keys of a given address.
276  */
277 library ECDSA {
278     enum RecoverError {
279         NoError,
280         InvalidSignature,
281         InvalidSignatureLength,
282         InvalidSignatureS,
283         InvalidSignatureV
284     }
285 
286     function _throwError(RecoverError error) private pure {
287         if (error == RecoverError.NoError) {
288             return; // no error: do nothing
289         } else if (error == RecoverError.InvalidSignature) {
290             revert("ECDSA: invalid signature");
291         } else if (error == RecoverError.InvalidSignatureLength) {
292             revert("ECDSA: invalid signature length");
293         } else if (error == RecoverError.InvalidSignatureS) {
294             revert("ECDSA: invalid signature 's' value");
295         } else if (error == RecoverError.InvalidSignatureV) {
296             revert("ECDSA: invalid signature 'v' value");
297         }
298     }
299 
300     /**
301      * @dev Returns the address that signed a hashed message (`hash`) with
302      * `signature` or error string. This address can then be used for verification purposes.
303      *
304      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
305      * this function rejects them by requiring the `s` value to be in the lower
306      * half order, and the `v` value to be either 27 or 28.
307      *
308      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
309      * verification to be secure: it is possible to craft signatures that
310      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
311      * this is by receiving a hash of the original message (which may otherwise
312      * be too long), and then calling {toEthSignedMessageHash} on it.
313      *
314      * Documentation for signature generation:
315      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
316      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
317      *
318      * _Available since v4.3._
319      */
320     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
321         if (signature.length == 65) {
322             bytes32 r;
323             bytes32 s;
324             uint8 v;
325             // ecrecover takes the signature parameters, and the only way to get them
326             // currently is to use assembly.
327             /// @solidity memory-safe-assembly
328             assembly {
329                 r := mload(add(signature, 0x20))
330                 s := mload(add(signature, 0x40))
331                 v := byte(0, mload(add(signature, 0x60)))
332             }
333             return tryRecover(hash, v, r, s);
334         } else {
335             return (address(0), RecoverError.InvalidSignatureLength);
336         }
337     }
338 
339     /**
340      * @dev Returns the address that signed a hashed message (`hash`) with
341      * `signature`. This address can then be used for verification purposes.
342      *
343      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
344      * this function rejects them by requiring the `s` value to be in the lower
345      * half order, and the `v` value to be either 27 or 28.
346      *
347      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
348      * verification to be secure: it is possible to craft signatures that
349      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
350      * this is by receiving a hash of the original message (which may otherwise
351      * be too long), and then calling {toEthSignedMessageHash} on it.
352      */
353     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
354         (address recovered, RecoverError error) = tryRecover(hash, signature);
355         _throwError(error);
356         return recovered;
357     }
358 
359     /**
360      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
361      *
362      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
363      *
364      * _Available since v4.3._
365      */
366     function tryRecover(
367         bytes32 hash,
368         bytes32 r,
369         bytes32 vs
370     ) internal pure returns (address, RecoverError) {
371         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
372         uint8 v = uint8((uint256(vs) >> 255) + 27);
373         return tryRecover(hash, v, r, s);
374     }
375 
376     /**
377      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
378      *
379      * _Available since v4.2._
380      */
381     function recover(
382         bytes32 hash,
383         bytes32 r,
384         bytes32 vs
385     ) internal pure returns (address) {
386         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
387         _throwError(error);
388         return recovered;
389     }
390 
391     /**
392      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
393      * `r` and `s` signature fields separately.
394      *
395      * _Available since v4.3._
396      */
397     function tryRecover(
398         bytes32 hash,
399         uint8 v,
400         bytes32 r,
401         bytes32 s
402     ) internal pure returns (address, RecoverError) {
403         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
404         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
405         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
406         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
407         //
408         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
409         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
410         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
411         // these malleable signatures as well.
412         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
413             return (address(0), RecoverError.InvalidSignatureS);
414         }
415         if (v != 27 && v != 28) {
416             return (address(0), RecoverError.InvalidSignatureV);
417         }
418 
419         // If the signature is valid (and not malleable), return the signer address
420         address signer = ecrecover(hash, v, r, s);
421         if (signer == address(0)) {
422             return (address(0), RecoverError.InvalidSignature);
423         }
424 
425         return (signer, RecoverError.NoError);
426     }
427 
428     /**
429      * @dev Overload of {ECDSA-recover} that receives the `v`,
430      * `r` and `s` signature fields separately.
431      */
432     function recover(
433         bytes32 hash,
434         uint8 v,
435         bytes32 r,
436         bytes32 s
437     ) internal pure returns (address) {
438         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
439         _throwError(error);
440         return recovered;
441     }
442 
443     /**
444      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
445      * produces hash corresponding to the one signed with the
446      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
447      * JSON-RPC method as part of EIP-191.
448      *
449      * See {recover}.
450      */
451     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
452         // 32 is the length in bytes of hash,
453         // enforced by the type signature above
454         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
455     }
456 
457     /**
458      * @dev Returns an Ethereum Signed Message, created from `s`. This
459      * produces hash corresponding to the one signed with the
460      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
461      * JSON-RPC method as part of EIP-191.
462      *
463      * See {recover}.
464      */
465     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
466         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
467     }
468 
469     /**
470      * @dev Returns an Ethereum Signed Typed Data, created from a
471      * `domainSeparator` and a `structHash`. This produces hash corresponding
472      * to the one signed with the
473      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
474      * JSON-RPC method as part of EIP-712.
475      *
476      * See {recover}.
477      */
478     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
479         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
480     }
481 }
482 
483 // File: @openzeppelin/contracts/utils/Context.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Provides information about the current execution context, including the
492  * sender of the transaction and its data. While these are generally available
493  * via msg.sender and msg.data, they should not be accessed in such a direct
494  * manner, since when dealing with meta-transactions the account sending and
495  * paying for execution may not be the actual sender (as far as an application
496  * is concerned).
497  *
498  * This contract is only required for intermediate, library-like contracts.
499  */
500 abstract contract Context {
501     function _msgSender() internal view virtual returns (address) {
502         return msg.sender;
503     }
504 
505     function _msgData() internal view virtual returns (bytes calldata) {
506         return msg.data;
507     }
508 }
509 
510 // File: @openzeppelin/contracts/access/Ownable.sol
511 
512 
513 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @dev Contract module which provides a basic access control mechanism, where
520  * there is an account (an owner) that can be granted exclusive access to
521  * specific functions.
522  *
523  * By default, the owner account will be the one that deploys the contract. This
524  * can later be changed with {transferOwnership}.
525  *
526  * This module is used through inheritance. It will make available the modifier
527  * `onlyOwner`, which can be applied to your functions to restrict their use to
528  * the owner.
529  */
530 abstract contract Ownable is Context {
531     address private _owner;
532 
533     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
534 
535     /**
536      * @dev Initializes the contract setting the deployer as the initial owner.
537      */
538     constructor() {
539         _transferOwnership(_msgSender());
540     }
541 
542     /**
543      * @dev Throws if called by any account other than the owner.
544      */
545     modifier onlyOwner() {
546         _checkOwner();
547         _;
548     }
549 
550     /**
551      * @dev Returns the address of the current owner.
552      */
553     function owner() public view virtual returns (address) {
554         return _owner;
555     }
556 
557     /**
558      * @dev Throws if the sender is not the owner.
559      */
560     function _checkOwner() internal view virtual {
561         require(owner() == _msgSender(), "Ownable: caller is not the owner");
562     }
563 
564     /**
565      * @dev Leaves the contract without owner. It will not be possible to call
566      * `onlyOwner` functions anymore. Can only be called by the current owner.
567      *
568      * NOTE: Renouncing ownership will leave the contract without an owner,
569      * thereby removing any functionality that is only available to the owner.
570      */
571     function renounceOwnership() public virtual onlyOwner {
572         _transferOwnership(address(0));
573     }
574 
575     /**
576      * @dev Transfers ownership of the contract to a new account (`newOwner`).
577      * Can only be called by the current owner.
578      */
579     function transferOwnership(address newOwner) public virtual onlyOwner {
580         require(newOwner != address(0), "Ownable: new owner is the zero address");
581         _transferOwnership(newOwner);
582     }
583 
584     /**
585      * @dev Transfers ownership of the contract to a new account (`newOwner`).
586      * Internal function without access restriction.
587      */
588     function _transferOwnership(address newOwner) internal virtual {
589         address oldOwner = _owner;
590         _owner = newOwner;
591         emit OwnershipTransferred(oldOwner, newOwner);
592     }
593 }
594 
595 // File: contracts/SignedAllowlists.sol
596 
597 pragma solidity ^0.8.0;
598 
599 
600 
601 contract SignedAllowlists is Ownable {
602     using ECDSA for bytes32;
603 
604     // The key used to sign Allowlist signatures.
605     // We will check to ensure that the key that signed the signature
606     // is this one that we expect.
607     address AllowlistSigningKey = address(0);
608 
609     // Domain Separator is the EIP-712 defined structure that defines what contract
610     // and chain these signatures can be used for.  This ensures people can't take
611     // a signature used to mint on one contract and use it for another, or a signature
612     // from testnet to replay on mainnet.
613     // It has to be created in the constructor so we can dynamically grab the chainId.
614     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md#definition-of-domainseparator
615     bytes32 public DOMAIN_SEPARATOR;
616 
617     // The typehash for the data type specified in the structured data
618     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md#rationale-for-typehash
619     // This should match whats in the client side Allowlist signing code
620     // https://github.com/msfeldstein/EIP712-Allowlisting/blob/main/test/signAllowlist.ts#L22
621     bytes32 public constant MINTER_TYPEHASH =
622         keccak256("Minter(address wallet)");
623 
624     constructor(string memory name_) {
625         // This should match whats in the client side Allowlist signing code
626         // https://github.com/msfeldstein/EIP712-Allowlisting/blob/main/test/signAllowlist.ts#L12
627         DOMAIN_SEPARATOR = keccak256(
628             abi.encode(
629                 keccak256(
630                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
631                 ),
632                 // This should match the domain you set in your client side signing.
633                 keccak256(bytes(name_)),
634                 keccak256(bytes("1")),
635                 block.chainid,
636                 address(this)
637             )
638         );
639     }
640 
641     function setAllowlistSigningAddress(address newSigningKey)
642         public
643         onlyOwner
644     {
645         AllowlistSigningKey = newSigningKey;
646     }
647 
648     modifier requiresAllowlist(bytes calldata signature) {
649         require(AllowlistSigningKey != address(0), "Allowlist not enabled");
650         // Verify EIP-712 signature by recreating the data structure
651         // that we signed on the client side, and then using that to recover
652         // the address that signed the signature for this data.
653         bytes32 digest = keccak256(
654             abi.encodePacked(
655                 "\x19\x01",
656                 DOMAIN_SEPARATOR,
657                 keccak256(abi.encode(MINTER_TYPEHASH, msg.sender))
658             )
659         );
660         // Use the recover method to see what address was used to create
661         // the signature on this data.
662         // Note that if the digest doesn't exactly match what was signed we'll
663         // get a random recovered address.
664         address recoveredAddress = digest.recover(signature);
665 
666         require(recoveredAddress == AllowlistSigningKey, "Invalid Signature");
667         _;
668     }
669 }
670 
671 // File: @openzeppelin/contracts/security/Pausable.sol
672 
673 
674 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 
679 /**
680  * @dev Contract module which allows children to implement an emergency stop
681  * mechanism that can be triggered by an authorized account.
682  *
683  * This module is used through inheritance. It will make available the
684  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
685  * the functions of your contract. Note that they will not be pausable by
686  * simply including this module, only once the modifiers are put in place.
687  */
688 abstract contract Pausable is Context {
689     /**
690      * @dev Emitted when the pause is triggered by `account`.
691      */
692     event Paused(address account);
693 
694     /**
695      * @dev Emitted when the pause is lifted by `account`.
696      */
697     event Unpaused(address account);
698 
699     bool private _paused;
700 
701     /**
702      * @dev Initializes the contract in unpaused state.
703      */
704     constructor() {
705         _paused = false;
706     }
707 
708     /**
709      * @dev Modifier to make a function callable only when the contract is not paused.
710      *
711      * Requirements:
712      *
713      * - The contract must not be paused.
714      */
715     modifier whenNotPaused() {
716         _requireNotPaused();
717         _;
718     }
719 
720     /**
721      * @dev Modifier to make a function callable only when the contract is paused.
722      *
723      * Requirements:
724      *
725      * - The contract must be paused.
726      */
727     modifier whenPaused() {
728         _requirePaused();
729         _;
730     }
731 
732     /**
733      * @dev Returns true if the contract is paused, and false otherwise.
734      */
735     function paused() public view virtual returns (bool) {
736         return _paused;
737     }
738 
739     /**
740      * @dev Throws if the contract is paused.
741      */
742     function _requireNotPaused() internal view virtual {
743         require(!paused(), "Pausable: paused");
744     }
745 
746     /**
747      * @dev Throws if the contract is not paused.
748      */
749     function _requirePaused() internal view virtual {
750         require(paused(), "Pausable: not paused");
751     }
752 
753     /**
754      * @dev Triggers stopped state.
755      *
756      * Requirements:
757      *
758      * - The contract must not be paused.
759      */
760     function _pause() internal virtual whenNotPaused {
761         _paused = true;
762         emit Paused(_msgSender());
763     }
764 
765     /**
766      * @dev Returns to normal state.
767      *
768      * Requirements:
769      *
770      * - The contract must be paused.
771      */
772     function _unpause() internal virtual whenPaused {
773         _paused = false;
774         emit Unpaused(_msgSender());
775     }
776 }
777 
778 // File: @openzeppelin/contracts/utils/Address.sol
779 
780 
781 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
782 
783 pragma solidity ^0.8.1;
784 
785 /**
786  * @dev Collection of functions related to the address type
787  */
788 library Address {
789     /**
790      * @dev Returns true if `account` is a contract.
791      *
792      * [IMPORTANT]
793      * ====
794      * It is unsafe to assume that an address for which this function returns
795      * false is an externally-owned account (EOA) and not a contract.
796      *
797      * Among others, `isContract` will return false for the following
798      * types of addresses:
799      *
800      *  - an externally-owned account
801      *  - a contract in construction
802      *  - an address where a contract will be created
803      *  - an address where a contract lived, but was destroyed
804      * ====
805      *
806      * [IMPORTANT]
807      * ====
808      * You shouldn't rely on `isContract` to protect against flash loan attacks!
809      *
810      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
811      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
812      * constructor.
813      * ====
814      */
815     function isContract(address account) internal view returns (bool) {
816         // This method relies on extcodesize/address.code.length, which returns 0
817         // for contracts in construction, since the code is only stored at the end
818         // of the constructor execution.
819 
820         return account.code.length > 0;
821     }
822 
823     /**
824      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
825      * `recipient`, forwarding all available gas and reverting on errors.
826      *
827      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
828      * of certain opcodes, possibly making contracts go over the 2300 gas limit
829      * imposed by `transfer`, making them unable to receive funds via
830      * `transfer`. {sendValue} removes this limitation.
831      *
832      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
833      *
834      * IMPORTANT: because control is transferred to `recipient`, care must be
835      * taken to not create reentrancy vulnerabilities. Consider using
836      * {ReentrancyGuard} or the
837      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
838      */
839     function sendValue(address payable recipient, uint256 amount) internal {
840         require(address(this).balance >= amount, "Address: insufficient balance");
841 
842         (bool success, ) = recipient.call{value: amount}("");
843         require(success, "Address: unable to send value, recipient may have reverted");
844     }
845 
846     /**
847      * @dev Performs a Solidity function call using a low level `call`. A
848      * plain `call` is an unsafe replacement for a function call: use this
849      * function instead.
850      *
851      * If `target` reverts with a revert reason, it is bubbled up by this
852      * function (like regular Solidity function calls).
853      *
854      * Returns the raw returned data. To convert to the expected return value,
855      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
856      *
857      * Requirements:
858      *
859      * - `target` must be a contract.
860      * - calling `target` with `data` must not revert.
861      *
862      * _Available since v3.1._
863      */
864     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
865         return functionCall(target, data, "Address: low-level call failed");
866     }
867 
868     /**
869      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
870      * `errorMessage` as a fallback revert reason when `target` reverts.
871      *
872      * _Available since v3.1._
873      */
874     function functionCall(
875         address target,
876         bytes memory data,
877         string memory errorMessage
878     ) internal returns (bytes memory) {
879         return functionCallWithValue(target, data, 0, errorMessage);
880     }
881 
882     /**
883      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
884      * but also transferring `value` wei to `target`.
885      *
886      * Requirements:
887      *
888      * - the calling contract must have an ETH balance of at least `value`.
889      * - the called Solidity function must be `payable`.
890      *
891      * _Available since v3.1._
892      */
893     function functionCallWithValue(
894         address target,
895         bytes memory data,
896         uint256 value
897     ) internal returns (bytes memory) {
898         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
899     }
900 
901     /**
902      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
903      * with `errorMessage` as a fallback revert reason when `target` reverts.
904      *
905      * _Available since v3.1._
906      */
907     function functionCallWithValue(
908         address target,
909         bytes memory data,
910         uint256 value,
911         string memory errorMessage
912     ) internal returns (bytes memory) {
913         require(address(this).balance >= value, "Address: insufficient balance for call");
914         require(isContract(target), "Address: call to non-contract");
915 
916         (bool success, bytes memory returndata) = target.call{value: value}(data);
917         return verifyCallResult(success, returndata, errorMessage);
918     }
919 
920     /**
921      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
922      * but performing a static call.
923      *
924      * _Available since v3.3._
925      */
926     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
927         return functionStaticCall(target, data, "Address: low-level static call failed");
928     }
929 
930     /**
931      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
932      * but performing a static call.
933      *
934      * _Available since v3.3._
935      */
936     function functionStaticCall(
937         address target,
938         bytes memory data,
939         string memory errorMessage
940     ) internal view returns (bytes memory) {
941         require(isContract(target), "Address: static call to non-contract");
942 
943         (bool success, bytes memory returndata) = target.staticcall(data);
944         return verifyCallResult(success, returndata, errorMessage);
945     }
946 
947     /**
948      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
949      * but performing a delegate call.
950      *
951      * _Available since v3.4._
952      */
953     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
954         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
955     }
956 
957     /**
958      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
959      * but performing a delegate call.
960      *
961      * _Available since v3.4._
962      */
963     function functionDelegateCall(
964         address target,
965         bytes memory data,
966         string memory errorMessage
967     ) internal returns (bytes memory) {
968         require(isContract(target), "Address: delegate call to non-contract");
969 
970         (bool success, bytes memory returndata) = target.delegatecall(data);
971         return verifyCallResult(success, returndata, errorMessage);
972     }
973 
974     /**
975      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
976      * revert reason using the provided one.
977      *
978      * _Available since v4.3._
979      */
980     function verifyCallResult(
981         bool success,
982         bytes memory returndata,
983         string memory errorMessage
984     ) internal pure returns (bytes memory) {
985         if (success) {
986             return returndata;
987         } else {
988             // Look for revert reason and bubble it up if present
989             if (returndata.length > 0) {
990                 // The easiest way to bubble the revert reason is using memory via assembly
991                 /// @solidity memory-safe-assembly
992                 assembly {
993                     let returndata_size := mload(returndata)
994                     revert(add(32, returndata), returndata_size)
995                 }
996             } else {
997                 revert(errorMessage);
998             }
999         }
1000     }
1001 }
1002 
1003 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1004 
1005 
1006 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1007 
1008 pragma solidity ^0.8.0;
1009 
1010 /**
1011  * @title ERC721 token receiver interface
1012  * @dev Interface for any contract that wants to support safeTransfers
1013  * from ERC721 asset contracts.
1014  */
1015 interface IERC721Receiver {
1016     /**
1017      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1018      * by `operator` from `from`, this function is called.
1019      *
1020      * It must return its Solidity selector to confirm the token transfer.
1021      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1022      *
1023      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1024      */
1025     function onERC721Received(
1026         address operator,
1027         address from,
1028         uint256 tokenId,
1029         bytes calldata data
1030     ) external returns (bytes4);
1031 }
1032 
1033 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1034 
1035 
1036 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1037 
1038 pragma solidity ^0.8.0;
1039 
1040 /**
1041  * @dev Interface of the ERC165 standard, as defined in the
1042  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1043  *
1044  * Implementers can declare support of contract interfaces, which can then be
1045  * queried by others ({ERC165Checker}).
1046  *
1047  * For an implementation, see {ERC165}.
1048  */
1049 interface IERC165 {
1050     /**
1051      * @dev Returns true if this contract implements the interface defined by
1052      * `interfaceId`. See the corresponding
1053      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1054      * to learn more about how these ids are created.
1055      *
1056      * This function call must use less than 30 000 gas.
1057      */
1058     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1059 }
1060 
1061 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1062 
1063 
1064 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1065 
1066 pragma solidity ^0.8.0;
1067 
1068 
1069 /**
1070  * @dev Implementation of the {IERC165} interface.
1071  *
1072  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1073  * for the additional interface id that will be supported. For example:
1074  *
1075  * ```solidity
1076  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1077  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1078  * }
1079  * ```
1080  *
1081  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1082  */
1083 abstract contract ERC165 is IERC165 {
1084     /**
1085      * @dev See {IERC165-supportsInterface}.
1086      */
1087     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1088         return interfaceId == type(IERC165).interfaceId;
1089     }
1090 }
1091 
1092 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1093 
1094 
1095 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 
1100 /**
1101  * @dev Required interface of an ERC721 compliant contract.
1102  */
1103 interface IERC721 is IERC165 {
1104     /**
1105      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1106      */
1107     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1108 
1109     /**
1110      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1111      */
1112     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1113 
1114     /**
1115      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1116      */
1117     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1118 
1119     /**
1120      * @dev Returns the number of tokens in ``owner``'s account.
1121      */
1122     function balanceOf(address owner) external view returns (uint256 balance);
1123 
1124     /**
1125      * @dev Returns the owner of the `tokenId` token.
1126      *
1127      * Requirements:
1128      *
1129      * - `tokenId` must exist.
1130      */
1131     function ownerOf(uint256 tokenId) external view returns (address owner);
1132 
1133     /**
1134      * @dev Safely transfers `tokenId` token from `from` to `to`.
1135      *
1136      * Requirements:
1137      *
1138      * - `from` cannot be the zero address.
1139      * - `to` cannot be the zero address.
1140      * - `tokenId` token must exist and be owned by `from`.
1141      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function safeTransferFrom(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes calldata data
1151     ) external;
1152 
1153     /**
1154      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1155      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1156      *
1157      * Requirements:
1158      *
1159      * - `from` cannot be the zero address.
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must exist and be owned by `from`.
1162      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function safeTransferFrom(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) external;
1172 
1173     /**
1174      * @dev Transfers `tokenId` token from `from` to `to`.
1175      *
1176      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1177      *
1178      * Requirements:
1179      *
1180      * - `from` cannot be the zero address.
1181      * - `to` cannot be the zero address.
1182      * - `tokenId` token must be owned by `from`.
1183      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function transferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) external;
1192 
1193     /**
1194      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1195      * The approval is cleared when the token is transferred.
1196      *
1197      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1198      *
1199      * Requirements:
1200      *
1201      * - The caller must own the token or be an approved operator.
1202      * - `tokenId` must exist.
1203      *
1204      * Emits an {Approval} event.
1205      */
1206     function approve(address to, uint256 tokenId) external;
1207 
1208     /**
1209      * @dev Approve or remove `operator` as an operator for the caller.
1210      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1211      *
1212      * Requirements:
1213      *
1214      * - The `operator` cannot be the caller.
1215      *
1216      * Emits an {ApprovalForAll} event.
1217      */
1218     function setApprovalForAll(address operator, bool _approved) external;
1219 
1220     /**
1221      * @dev Returns the account approved for `tokenId` token.
1222      *
1223      * Requirements:
1224      *
1225      * - `tokenId` must exist.
1226      */
1227     function getApproved(uint256 tokenId) external view returns (address operator);
1228 
1229     /**
1230      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1231      *
1232      * See {setApprovalForAll}
1233      */
1234     function isApprovedForAll(address owner, address operator) external view returns (bool);
1235 }
1236 
1237 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1238 
1239 
1240 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1241 
1242 pragma solidity ^0.8.0;
1243 
1244 
1245 /**
1246  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1247  * @dev See https://eips.ethereum.org/EIPS/eip-721
1248  */
1249 interface IERC721Enumerable is IERC721 {
1250     /**
1251      * @dev Returns the total amount of tokens stored by the contract.
1252      */
1253     function totalSupply() external view returns (uint256);
1254 
1255     /**
1256      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1257      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1258      */
1259     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1260 
1261     /**
1262      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1263      * Use along with {totalSupply} to enumerate all tokens.
1264      */
1265     function tokenByIndex(uint256 index) external view returns (uint256);
1266 }
1267 
1268 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1269 
1270 
1271 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 
1276 /**
1277  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1278  * @dev See https://eips.ethereum.org/EIPS/eip-721
1279  */
1280 interface IERC721Metadata is IERC721 {
1281     /**
1282      * @dev Returns the token collection name.
1283      */
1284     function name() external view returns (string memory);
1285 
1286     /**
1287      * @dev Returns the token collection symbol.
1288      */
1289     function symbol() external view returns (string memory);
1290 
1291     /**
1292      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1293      */
1294     function tokenURI(uint256 tokenId) external view returns (string memory);
1295 }
1296 
1297 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1298 
1299 
1300 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1301 
1302 pragma solidity ^0.8.0;
1303 
1304 
1305 
1306 
1307 
1308 
1309 
1310 
1311 /**
1312  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1313  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1314  * {ERC721Enumerable}.
1315  */
1316 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1317     using Address for address;
1318     using Strings for uint256;
1319 
1320     // Token name
1321     string private _name;
1322 
1323     // Token symbol
1324     string private _symbol;
1325 
1326     // Mapping from token ID to owner address
1327     mapping(uint256 => address) private _owners;
1328 
1329     // Mapping owner address to token count
1330     mapping(address => uint256) private _balances;
1331 
1332     // Mapping from token ID to approved address
1333     mapping(uint256 => address) private _tokenApprovals;
1334 
1335     // Mapping from owner to operator approvals
1336     mapping(address => mapping(address => bool)) private _operatorApprovals;
1337 
1338     /**
1339      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1340      */
1341     constructor(string memory name_, string memory symbol_) {
1342         _name = name_;
1343         _symbol = symbol_;
1344     }
1345 
1346     /**
1347      * @dev See {IERC165-supportsInterface}.
1348      */
1349     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1350         return
1351             interfaceId == type(IERC721).interfaceId ||
1352             interfaceId == type(IERC721Metadata).interfaceId ||
1353             super.supportsInterface(interfaceId);
1354     }
1355 
1356     /**
1357      * @dev See {IERC721-balanceOf}.
1358      */
1359     function balanceOf(address owner) public view virtual override returns (uint256) {
1360         require(owner != address(0), "ERC721: address zero is not a valid owner");
1361         return _balances[owner];
1362     }
1363 
1364     /**
1365      * @dev See {IERC721-ownerOf}.
1366      */
1367     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1368         address owner = _owners[tokenId];
1369         require(owner != address(0), "ERC721: invalid token ID");
1370         return owner;
1371     }
1372 
1373     /**
1374      * @dev See {IERC721Metadata-name}.
1375      */
1376     function name() public view virtual override returns (string memory) {
1377         return _name;
1378     }
1379 
1380     /**
1381      * @dev See {IERC721Metadata-symbol}.
1382      */
1383     function symbol() public view virtual override returns (string memory) {
1384         return _symbol;
1385     }
1386 
1387     /**
1388      * @dev See {IERC721Metadata-tokenURI}.
1389      */
1390     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1391         _requireMinted(tokenId);
1392 
1393         string memory baseURI = _baseURI();
1394         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1395     }
1396 
1397     /**
1398      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1399      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1400      * by default, can be overridden in child contracts.
1401      */
1402     function _baseURI() internal view virtual returns (string memory) {
1403         return "";
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-approve}.
1408      */
1409     function approve(address to, uint256 tokenId) public virtual override {
1410         address owner = ERC721.ownerOf(tokenId);
1411         require(to != owner, "ERC721: approval to current owner");
1412 
1413         require(
1414             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1415             "ERC721: approve caller is not token owner nor approved for all"
1416         );
1417 
1418         _approve(to, tokenId);
1419     }
1420 
1421     /**
1422      * @dev See {IERC721-getApproved}.
1423      */
1424     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1425         _requireMinted(tokenId);
1426 
1427         return _tokenApprovals[tokenId];
1428     }
1429 
1430     /**
1431      * @dev See {IERC721-setApprovalForAll}.
1432      */
1433     function setApprovalForAll(address operator, bool approved) public virtual override {
1434         _setApprovalForAll(_msgSender(), operator, approved);
1435     }
1436 
1437     /**
1438      * @dev See {IERC721-isApprovedForAll}.
1439      */
1440     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1441         return _operatorApprovals[owner][operator];
1442     }
1443 
1444     /**
1445      * @dev See {IERC721-transferFrom}.
1446      */
1447     function transferFrom(
1448         address from,
1449         address to,
1450         uint256 tokenId
1451     ) public virtual override {
1452         //solhint-disable-next-line max-line-length
1453         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1454 
1455         _transfer(from, to, tokenId);
1456     }
1457 
1458     /**
1459      * @dev See {IERC721-safeTransferFrom}.
1460      */
1461     function safeTransferFrom(
1462         address from,
1463         address to,
1464         uint256 tokenId
1465     ) public virtual override {
1466         safeTransferFrom(from, to, tokenId, "");
1467     }
1468 
1469     /**
1470      * @dev See {IERC721-safeTransferFrom}.
1471      */
1472     function safeTransferFrom(
1473         address from,
1474         address to,
1475         uint256 tokenId,
1476         bytes memory data
1477     ) public virtual override {
1478         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1479         _safeTransfer(from, to, tokenId, data);
1480     }
1481 
1482     /**
1483      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1484      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1485      *
1486      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1487      *
1488      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1489      * implement alternative mechanisms to perform token transfer, such as signature-based.
1490      *
1491      * Requirements:
1492      *
1493      * - `from` cannot be the zero address.
1494      * - `to` cannot be the zero address.
1495      * - `tokenId` token must exist and be owned by `from`.
1496      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1497      *
1498      * Emits a {Transfer} event.
1499      */
1500     function _safeTransfer(
1501         address from,
1502         address to,
1503         uint256 tokenId,
1504         bytes memory data
1505     ) internal virtual {
1506         _transfer(from, to, tokenId);
1507         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1508     }
1509 
1510     /**
1511      * @dev Returns whether `tokenId` exists.
1512      *
1513      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1514      *
1515      * Tokens start existing when they are minted (`_mint`),
1516      * and stop existing when they are burned (`_burn`).
1517      */
1518     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1519         return _owners[tokenId] != address(0);
1520     }
1521 
1522     /**
1523      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1524      *
1525      * Requirements:
1526      *
1527      * - `tokenId` must exist.
1528      */
1529     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1530         address owner = ERC721.ownerOf(tokenId);
1531         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1532     }
1533 
1534     /**
1535      * @dev Safely mints `tokenId` and transfers it to `to`.
1536      *
1537      * Requirements:
1538      *
1539      * - `tokenId` must not exist.
1540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1541      *
1542      * Emits a {Transfer} event.
1543      */
1544     function _safeMint(address to, uint256 tokenId) internal virtual {
1545         _safeMint(to, tokenId, "");
1546     }
1547 
1548     /**
1549      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1550      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1551      */
1552     function _safeMint(
1553         address to,
1554         uint256 tokenId,
1555         bytes memory data
1556     ) internal virtual {
1557         _mint(to, tokenId);
1558         require(
1559             _checkOnERC721Received(address(0), to, tokenId, data),
1560             "ERC721: transfer to non ERC721Receiver implementer"
1561         );
1562     }
1563 
1564     /**
1565      * @dev Mints `tokenId` and transfers it to `to`.
1566      *
1567      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1568      *
1569      * Requirements:
1570      *
1571      * - `tokenId` must not exist.
1572      * - `to` cannot be the zero address.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _mint(address to, uint256 tokenId) internal virtual {
1577         require(to != address(0), "ERC721: mint to the zero address");
1578         require(!_exists(tokenId), "ERC721: token already minted");
1579 
1580         _beforeTokenTransfer(address(0), to, tokenId);
1581 
1582         _balances[to] += 1;
1583         _owners[tokenId] = to;
1584 
1585         emit Transfer(address(0), to, tokenId);
1586 
1587         _afterTokenTransfer(address(0), to, tokenId);
1588     }
1589 
1590     /**
1591      * @dev Destroys `tokenId`.
1592      * The approval is cleared when the token is burned.
1593      *
1594      * Requirements:
1595      *
1596      * - `tokenId` must exist.
1597      *
1598      * Emits a {Transfer} event.
1599      */
1600     function _burn(uint256 tokenId) internal virtual {
1601         address owner = ERC721.ownerOf(tokenId);
1602 
1603         _beforeTokenTransfer(owner, address(0), tokenId);
1604 
1605         // Clear approvals
1606         _approve(address(0), tokenId);
1607 
1608         _balances[owner] -= 1;
1609         delete _owners[tokenId];
1610 
1611         emit Transfer(owner, address(0), tokenId);
1612 
1613         _afterTokenTransfer(owner, address(0), tokenId);
1614     }
1615 
1616     /**
1617      * @dev Transfers `tokenId` from `from` to `to`.
1618      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1619      *
1620      * Requirements:
1621      *
1622      * - `to` cannot be the zero address.
1623      * - `tokenId` token must be owned by `from`.
1624      *
1625      * Emits a {Transfer} event.
1626      */
1627     function _transfer(
1628         address from,
1629         address to,
1630         uint256 tokenId
1631     ) internal virtual {
1632         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1633         require(to != address(0), "ERC721: transfer to the zero address");
1634 
1635         _beforeTokenTransfer(from, to, tokenId);
1636 
1637         // Clear approvals from the previous owner
1638         _approve(address(0), tokenId);
1639 
1640         _balances[from] -= 1;
1641         _balances[to] += 1;
1642         _owners[tokenId] = to;
1643 
1644         emit Transfer(from, to, tokenId);
1645 
1646         _afterTokenTransfer(from, to, tokenId);
1647     }
1648 
1649     /**
1650      * @dev Approve `to` to operate on `tokenId`
1651      *
1652      * Emits an {Approval} event.
1653      */
1654     function _approve(address to, uint256 tokenId) internal virtual {
1655         _tokenApprovals[tokenId] = to;
1656         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1657     }
1658 
1659     /**
1660      * @dev Approve `operator` to operate on all of `owner` tokens
1661      *
1662      * Emits an {ApprovalForAll} event.
1663      */
1664     function _setApprovalForAll(
1665         address owner,
1666         address operator,
1667         bool approved
1668     ) internal virtual {
1669         require(owner != operator, "ERC721: approve to caller");
1670         _operatorApprovals[owner][operator] = approved;
1671         emit ApprovalForAll(owner, operator, approved);
1672     }
1673 
1674     /**
1675      * @dev Reverts if the `tokenId` has not been minted yet.
1676      */
1677     function _requireMinted(uint256 tokenId) internal view virtual {
1678         require(_exists(tokenId), "ERC721: invalid token ID");
1679     }
1680 
1681     /**
1682      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1683      * The call is not executed if the target address is not a contract.
1684      *
1685      * @param from address representing the previous owner of the given token ID
1686      * @param to target address that will receive the tokens
1687      * @param tokenId uint256 ID of the token to be transferred
1688      * @param data bytes optional data to send along with the call
1689      * @return bool whether the call correctly returned the expected magic value
1690      */
1691     function _checkOnERC721Received(
1692         address from,
1693         address to,
1694         uint256 tokenId,
1695         bytes memory data
1696     ) private returns (bool) {
1697         if (to.isContract()) {
1698             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1699                 return retval == IERC721Receiver.onERC721Received.selector;
1700             } catch (bytes memory reason) {
1701                 if (reason.length == 0) {
1702                     revert("ERC721: transfer to non ERC721Receiver implementer");
1703                 } else {
1704                     /// @solidity memory-safe-assembly
1705                     assembly {
1706                         revert(add(32, reason), mload(reason))
1707                     }
1708                 }
1709             }
1710         } else {
1711             return true;
1712         }
1713     }
1714 
1715     /**
1716      * @dev Hook that is called before any token transfer. This includes minting
1717      * and burning.
1718      *
1719      * Calling conditions:
1720      *
1721      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1722      * transferred to `to`.
1723      * - When `from` is zero, `tokenId` will be minted for `to`.
1724      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1725      * - `from` and `to` are never both zero.
1726      *
1727      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1728      */
1729     function _beforeTokenTransfer(
1730         address from,
1731         address to,
1732         uint256 tokenId
1733     ) internal virtual {}
1734 
1735     /**
1736      * @dev Hook that is called after any transfer of tokens. This includes
1737      * minting and burning.
1738      *
1739      * Calling conditions:
1740      *
1741      * - when `from` and `to` are both non-zero.
1742      * - `from` and `to` are never both zero.
1743      *
1744      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1745      */
1746     function _afterTokenTransfer(
1747         address from,
1748         address to,
1749         uint256 tokenId
1750     ) internal virtual {}
1751 }
1752 
1753 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1754 
1755 
1756 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1757 
1758 pragma solidity ^0.8.0;
1759 
1760 
1761 
1762 /**
1763  * @title ERC721 Burnable Token
1764  * @dev ERC721 Token that can be burned (destroyed).
1765  */
1766 abstract contract ERC721Burnable is Context, ERC721 {
1767     /**
1768      * @dev Burns `tokenId`. See {ERC721-_burn}.
1769      *
1770      * Requirements:
1771      *
1772      * - The caller must own `tokenId` or be an approved operator.
1773      */
1774     function burn(uint256 tokenId) public virtual {
1775         //solhint-disable-next-line max-line-length
1776         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1777         _burn(tokenId);
1778     }
1779 }
1780 
1781 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1782 
1783 
1784 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1785 
1786 pragma solidity ^0.8.0;
1787 
1788 
1789 
1790 /**
1791  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1792  * enumerability of all the token ids in the contract as well as all token ids owned by each
1793  * account.
1794  */
1795 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1796     // Mapping from owner to list of owned token IDs
1797     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1798 
1799     // Mapping from token ID to index of the owner tokens list
1800     mapping(uint256 => uint256) private _ownedTokensIndex;
1801 
1802     // Array with all token ids, used for enumeration
1803     uint256[] private _allTokens;
1804 
1805     // Mapping from token id to position in the allTokens array
1806     mapping(uint256 => uint256) private _allTokensIndex;
1807 
1808     /**
1809      * @dev See {IERC165-supportsInterface}.
1810      */
1811     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1812         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1813     }
1814 
1815     /**
1816      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1817      */
1818     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1819         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1820         return _ownedTokens[owner][index];
1821     }
1822 
1823     /**
1824      * @dev See {IERC721Enumerable-totalSupply}.
1825      */
1826     function totalSupply() public view virtual override returns (uint256) {
1827         return _allTokens.length;
1828     }
1829 
1830     /**
1831      * @dev See {IERC721Enumerable-tokenByIndex}.
1832      */
1833     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1834         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1835         return _allTokens[index];
1836     }
1837 
1838     /**
1839      * @dev Hook that is called before any token transfer. This includes minting
1840      * and burning.
1841      *
1842      * Calling conditions:
1843      *
1844      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1845      * transferred to `to`.
1846      * - When `from` is zero, `tokenId` will be minted for `to`.
1847      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1848      * - `from` cannot be the zero address.
1849      * - `to` cannot be the zero address.
1850      *
1851      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1852      */
1853     function _beforeTokenTransfer(
1854         address from,
1855         address to,
1856         uint256 tokenId
1857     ) internal virtual override {
1858         super._beforeTokenTransfer(from, to, tokenId);
1859 
1860         if (from == address(0)) {
1861             _addTokenToAllTokensEnumeration(tokenId);
1862         } else if (from != to) {
1863             _removeTokenFromOwnerEnumeration(from, tokenId);
1864         }
1865         if (to == address(0)) {
1866             _removeTokenFromAllTokensEnumeration(tokenId);
1867         } else if (to != from) {
1868             _addTokenToOwnerEnumeration(to, tokenId);
1869         }
1870     }
1871 
1872     /**
1873      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1874      * @param to address representing the new owner of the given token ID
1875      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1876      */
1877     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1878         uint256 length = ERC721.balanceOf(to);
1879         _ownedTokens[to][length] = tokenId;
1880         _ownedTokensIndex[tokenId] = length;
1881     }
1882 
1883     /**
1884      * @dev Private function to add a token to this extension's token tracking data structures.
1885      * @param tokenId uint256 ID of the token to be added to the tokens list
1886      */
1887     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1888         _allTokensIndex[tokenId] = _allTokens.length;
1889         _allTokens.push(tokenId);
1890     }
1891 
1892     /**
1893      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1894      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1895      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1896      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1897      * @param from address representing the previous owner of the given token ID
1898      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1899      */
1900     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1901         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1902         // then delete the last slot (swap and pop).
1903 
1904         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1905         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1906 
1907         // When the token to delete is the last token, the swap operation is unnecessary
1908         if (tokenIndex != lastTokenIndex) {
1909             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1910 
1911             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1912             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1913         }
1914 
1915         // This also deletes the contents at the last position of the array
1916         delete _ownedTokensIndex[tokenId];
1917         delete _ownedTokens[from][lastTokenIndex];
1918     }
1919 
1920     /**
1921      * @dev Private function to remove a token from this extension's token tracking data structures.
1922      * This has O(1) time complexity, but alters the order of the _allTokens array.
1923      * @param tokenId uint256 ID of the token to be removed from the tokens list
1924      */
1925     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1926         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1927         // then delete the last slot (swap and pop).
1928 
1929         uint256 lastTokenIndex = _allTokens.length - 1;
1930         uint256 tokenIndex = _allTokensIndex[tokenId];
1931 
1932         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1933         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1934         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1935         uint256 lastTokenId = _allTokens[lastTokenIndex];
1936 
1937         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1938         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1939 
1940         // This also deletes the contents at the last position of the array
1941         delete _allTokensIndex[tokenId];
1942         _allTokens.pop();
1943     }
1944 }
1945 
1946 // File: contracts/Dawn.sol
1947 
1948 
1949 pragma solidity ^0.8.4;
1950 
1951 // 🌞
1952 contract Dawn is
1953     ERC721,
1954     ERC721Burnable,
1955     ERC721Enumerable,
1956     Pausable,
1957     Ownable,
1958     SignedAllowlists
1959 {
1960     using Counters for Counters.Counter;
1961     Counters.Counter private _tokenIdCounter;
1962     TokenRenderer private _getTokenUriAddress;
1963     bool private _isUriAddressFrozen;
1964 
1965     constructor(TokenRenderer getTokenUriAddress)
1966         ERC721("Dawn Pass", "DAWN")
1967         SignedAllowlists("Dawn Pass")
1968     {
1969         _getTokenUriAddress = getTokenUriAddress;
1970         _pause();
1971     }
1972 
1973     // PAUSE / UNPAUSE
1974     // ---------------
1975 
1976     function pause() public onlyOwner {
1977         _pause();
1978     }
1979 
1980     function unpause() public onlyOwner {
1981         _unpause();
1982     }
1983 
1984     // OPENSEA METADATA
1985     // ----------------
1986 
1987     function contractURI() public pure returns (string memory) {
1988         bytes
1989             memory json = '{"name": "Dawn Pass by Daylight","description": "The Dawn Pass grants access to Daylight, where you can discover everything your wallet can do: mints, airdrops, votes, token gates, and more.\\n\\nThis collection is soulbound.", "image": "https://www.daylight.xyz/images/opensea-contract-metadata-image.png", "external_link": "https://www.daylight.xyz" }';
1990 
1991         return
1992             string(
1993                 abi.encodePacked(
1994                     "data:application/json;base64,",
1995                     Utils.base64Encode(json)
1996                 )
1997             );
1998     }
1999 
2000     // URI
2001     // ---
2002 
2003     // This cannot be undone!
2004     function freezeUriAddress() public onlyOwner {
2005         _isUriAddressFrozen = true;
2006     }
2007 
2008     modifier whenUriNotFrozen() {
2009         require(!_isUriAddressFrozen, "URI getter is frozen");
2010         _;
2011     }
2012 
2013     function setTokenRendererAddress(TokenRenderer newAddress)
2014         public
2015         onlyOwner
2016         whenUriNotFrozen
2017     {
2018         _getTokenUriAddress = newAddress;
2019     }
2020 
2021     function tokenURI(uint256 tokenId)
2022         public
2023         view
2024         override
2025         returns (string memory)
2026     {
2027         _requireMinted(tokenId);
2028 
2029         return _getTokenUriAddress.getTokenURI(tokenId, name());
2030     }
2031 
2032     // MINTING
2033     // -------
2034 
2035     function allowlistMint(bytes calldata signature)
2036         public
2037         whenNotPaused
2038         requiresAllowlist(signature)
2039     {
2040         require(balanceOf(msg.sender) == 0, "One pass per person");
2041         uint256 tokenId = _tokenIdCounter.current();
2042         _tokenIdCounter.increment();
2043         _safeMint(msg.sender, tokenId);
2044     }
2045 
2046     function safeMint(address to) public onlyOwner {
2047         require(balanceOf(to) == 0, "One pass per person");
2048         uint256 tokenId = _tokenIdCounter.current();
2049         _tokenIdCounter.increment();
2050         _safeMint(to, tokenId);
2051     }
2052 
2053     // SOULBINDING
2054     // -----------
2055 
2056     function _beforeTokenTransfer(
2057         address from,
2058         address to,
2059         uint256 tokenId
2060     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
2061         super._beforeTokenTransfer(from, to, tokenId);
2062 
2063         // Revert if transfers are not from the 0 address
2064         // and not to the 0 address or the null address
2065         if (
2066             from != address(0) &&
2067             to != address(0) &&
2068             to != 0x000000000000000000000000000000000000dEaD
2069         ) {
2070             revert("Token is soulbound");
2071         }
2072     }
2073 
2074     // SOLIDITY OVERRIDES
2075     // ------------------
2076 
2077     function supportsInterface(bytes4 interfaceId)
2078         public
2079         view
2080         override(ERC721, ERC721Enumerable)
2081         returns (bool)
2082     {
2083         return super.supportsInterface(interfaceId);
2084     }
2085 }