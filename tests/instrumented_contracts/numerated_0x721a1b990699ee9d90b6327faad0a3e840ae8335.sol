1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/utils/Strings.sol
47 
48 
49 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev String operations.
55  */
56 library Strings {
57     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
61      */
62     function toString(uint256 value) internal pure returns (string memory) {
63         // Inspired by OraclizeAPI's implementation - MIT licence
64         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
65 
66         if (value == 0) {
67             return "0";
68         }
69         uint256 temp = value;
70         uint256 digits;
71         while (temp != 0) {
72             digits++;
73             temp /= 10;
74         }
75         bytes memory buffer = new bytes(digits);
76         while (value != 0) {
77             digits -= 1;
78             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
79             value /= 10;
80         }
81         return string(buffer);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
86      */
87     function toHexString(uint256 value) internal pure returns (string memory) {
88         if (value == 0) {
89             return "0x00";
90         }
91         uint256 temp = value;
92         uint256 length = 0;
93         while (temp != 0) {
94             length++;
95             temp >>= 8;
96         }
97         return toHexString(value, length);
98     }
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
102      */
103     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
104         bytes memory buffer = new bytes(2 * length + 2);
105         buffer[0] = "0";
106         buffer[1] = "x";
107         for (uint256 i = 2 * length + 1; i > 1; --i) {
108             buffer[i] = _HEX_SYMBOLS[value & 0xf];
109             value >>= 4;
110         }
111         require(value == 0, "Strings: hex length insufficient");
112         return string(buffer);
113     }
114 }
115 
116 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 
124 /**
125  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
126  *
127  * These functions can be used to verify that a message was signed by the holder
128  * of the private keys of a given address.
129  */
130 library ECDSA {
131     enum RecoverError {
132         NoError,
133         InvalidSignature,
134         InvalidSignatureLength,
135         InvalidSignatureS,
136         InvalidSignatureV
137     }
138 
139     function _throwError(RecoverError error) private pure {
140         if (error == RecoverError.NoError) {
141             return; // no error: do nothing
142         } else if (error == RecoverError.InvalidSignature) {
143             revert("ECDSA: invalid signature");
144         } else if (error == RecoverError.InvalidSignatureLength) {
145             revert("ECDSA: invalid signature length");
146         } else if (error == RecoverError.InvalidSignatureS) {
147             revert("ECDSA: invalid signature 's' value");
148         } else if (error == RecoverError.InvalidSignatureV) {
149             revert("ECDSA: invalid signature 'v' value");
150         }
151     }
152 
153     /**
154      * @dev Returns the address that signed a hashed message (`hash`) with
155      * `signature` or error string. This address can then be used for verification purposes.
156      *
157      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
158      * this function rejects them by requiring the `s` value to be in the lower
159      * half order, and the `v` value to be either 27 or 28.
160      *
161      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
162      * verification to be secure: it is possible to craft signatures that
163      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
164      * this is by receiving a hash of the original message (which may otherwise
165      * be too long), and then calling {toEthSignedMessageHash} on it.
166      *
167      * Documentation for signature generation:
168      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
169      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
170      *
171      * _Available since v4.3._
172      */
173     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
174         // Check the signature length
175         // - case 65: r,s,v signature (standard)
176         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
177         if (signature.length == 65) {
178             bytes32 r;
179             bytes32 s;
180             uint8 v;
181             // ecrecover takes the signature parameters, and the only way to get them
182             // currently is to use assembly.
183             assembly {
184                 r := mload(add(signature, 0x20))
185                 s := mload(add(signature, 0x40))
186                 v := byte(0, mload(add(signature, 0x60)))
187             }
188             return tryRecover(hash, v, r, s);
189         } else if (signature.length == 64) {
190             bytes32 r;
191             bytes32 vs;
192             // ecrecover takes the signature parameters, and the only way to get them
193             // currently is to use assembly.
194             assembly {
195                 r := mload(add(signature, 0x20))
196                 vs := mload(add(signature, 0x40))
197             }
198             return tryRecover(hash, r, vs);
199         } else {
200             return (address(0), RecoverError.InvalidSignatureLength);
201         }
202     }
203 
204     /**
205      * @dev Returns the address that signed a hashed message (`hash`) with
206      * `signature`. This address can then be used for verification purposes.
207      *
208      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
209      * this function rejects them by requiring the `s` value to be in the lower
210      * half order, and the `v` value to be either 27 or 28.
211      *
212      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
213      * verification to be secure: it is possible to craft signatures that
214      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
215      * this is by receiving a hash of the original message (which may otherwise
216      * be too long), and then calling {toEthSignedMessageHash} on it.
217      */
218     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
219         (address recovered, RecoverError error) = tryRecover(hash, signature);
220         _throwError(error);
221         return recovered;
222     }
223 
224     /**
225      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
226      *
227      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
228      *
229      * _Available since v4.3._
230      */
231     function tryRecover(
232         bytes32 hash,
233         bytes32 r,
234         bytes32 vs
235     ) internal pure returns (address, RecoverError) {
236         bytes32 s;
237         uint8 v;
238         assembly {
239             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
240             v := add(shr(255, vs), 27)
241         }
242         return tryRecover(hash, v, r, s);
243     }
244 
245     /**
246      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
247      *
248      * _Available since v4.2._
249      */
250     function recover(
251         bytes32 hash,
252         bytes32 r,
253         bytes32 vs
254     ) internal pure returns (address) {
255         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
256         _throwError(error);
257         return recovered;
258     }
259 
260     /**
261      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
262      * `r` and `s` signature fields separately.
263      *
264      * _Available since v4.3._
265      */
266     function tryRecover(
267         bytes32 hash,
268         uint8 v,
269         bytes32 r,
270         bytes32 s
271     ) internal pure returns (address, RecoverError) {
272         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
273         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
274         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
275         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
276         //
277         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
278         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
279         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
280         // these malleable signatures as well.
281         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
282             return (address(0), RecoverError.InvalidSignatureS);
283         }
284         if (v != 27 && v != 28) {
285             return (address(0), RecoverError.InvalidSignatureV);
286         }
287 
288         // If the signature is valid (and not malleable), return the signer address
289         address signer = ecrecover(hash, v, r, s);
290         if (signer == address(0)) {
291             return (address(0), RecoverError.InvalidSignature);
292         }
293 
294         return (signer, RecoverError.NoError);
295     }
296 
297     /**
298      * @dev Overload of {ECDSA-recover} that receives the `v`,
299      * `r` and `s` signature fields separately.
300      */
301     function recover(
302         bytes32 hash,
303         uint8 v,
304         bytes32 r,
305         bytes32 s
306     ) internal pure returns (address) {
307         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
308         _throwError(error);
309         return recovered;
310     }
311 
312     /**
313      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
314      * produces hash corresponding to the one signed with the
315      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
316      * JSON-RPC method as part of EIP-191.
317      *
318      * See {recover}.
319      */
320     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
321         // 32 is the length in bytes of hash,
322         // enforced by the type signature above
323         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
324     }
325 
326     /**
327      * @dev Returns an Ethereum Signed Message, created from `s`. This
328      * produces hash corresponding to the one signed with the
329      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
330      * JSON-RPC method as part of EIP-191.
331      *
332      * See {recover}.
333      */
334     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
335         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
336     }
337 
338     /**
339      * @dev Returns an Ethereum Signed Typed Data, created from a
340      * `domainSeparator` and a `structHash`. This produces hash corresponding
341      * to the one signed with the
342      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
343      * JSON-RPC method as part of EIP-712.
344      *
345      * See {recover}.
346      */
347     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
348         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
349     }
350 }
351 
352 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 
360 /**
361  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
362  *
363  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
364  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
365  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
366  *
367  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
368  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
369  * ({_hashTypedDataV4}).
370  *
371  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
372  * the chain id to protect against replay attacks on an eventual fork of the chain.
373  *
374  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
375  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
376  *
377  * _Available since v3.4._
378  */
379 abstract contract EIP712 {
380     /* solhint-disable var-name-mixedcase */
381     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
382     // invalidate the cached domain separator if the chain id changes.
383     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
384     uint256 private immutable _CACHED_CHAIN_ID;
385     address private immutable _CACHED_THIS;
386 
387     bytes32 private immutable _HASHED_NAME;
388     bytes32 private immutable _HASHED_VERSION;
389     bytes32 private immutable _TYPE_HASH;
390 
391     /* solhint-enable var-name-mixedcase */
392 
393     /**
394      * @dev Initializes the domain separator and parameter caches.
395      *
396      * The meaning of `name` and `version` is specified in
397      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
398      *
399      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
400      * - `version`: the current major version of the signing domain.
401      *
402      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
403      * contract upgrade].
404      */
405     constructor(string memory name, string memory version) {
406         bytes32 hashedName = keccak256(bytes(name));
407         bytes32 hashedVersion = keccak256(bytes(version));
408         bytes32 typeHash = keccak256(
409             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
410         );
411         _HASHED_NAME = hashedName;
412         _HASHED_VERSION = hashedVersion;
413         _CACHED_CHAIN_ID = block.chainid;
414         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
415         _CACHED_THIS = address(this);
416         _TYPE_HASH = typeHash;
417     }
418 
419     /**
420      * @dev Returns the domain separator for the current chain.
421      */
422     function _domainSeparatorV4() internal view returns (bytes32) {
423         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
424             return _CACHED_DOMAIN_SEPARATOR;
425         } else {
426             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
427         }
428     }
429 
430     function _buildDomainSeparator(
431         bytes32 typeHash,
432         bytes32 nameHash,
433         bytes32 versionHash
434     ) private view returns (bytes32) {
435         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
436     }
437 
438     /**
439      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
440      * function returns the hash of the fully encoded EIP712 message for this domain.
441      *
442      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
443      *
444      * ```solidity
445      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
446      *     keccak256("Mail(address to,string contents)"),
447      *     mailTo,
448      *     keccak256(bytes(mailContents))
449      * )));
450      * address signer = ECDSA.recover(digest, signature);
451      * ```
452      */
453     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
454         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
455     }
456 }
457 
458 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
467  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
468  *
469  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
470  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
471  * need to send a transaction, and thus is not required to hold Ether at all.
472  */
473 interface IERC20Permit {
474     /**
475      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
476      * given ``owner``'s signed approval.
477      *
478      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
479      * ordering also apply here.
480      *
481      * Emits an {Approval} event.
482      *
483      * Requirements:
484      *
485      * - `spender` cannot be the zero address.
486      * - `deadline` must be a timestamp in the future.
487      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
488      * over the EIP712-formatted function arguments.
489      * - the signature must use ``owner``'s current nonce (see {nonces}).
490      *
491      * For more information on the signature format, see the
492      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
493      * section].
494      */
495     function permit(
496         address owner,
497         address spender,
498         uint256 value,
499         uint256 deadline,
500         uint8 v,
501         bytes32 r,
502         bytes32 s
503     ) external;
504 
505     /**
506      * @dev Returns the current nonce for `owner`. This value must be
507      * included whenever a signature is generated for {permit}.
508      *
509      * Every successful call to {permit} increases ``owner``'s nonce by one. This
510      * prevents a signature from being used multiple times.
511      */
512     function nonces(address owner) external view returns (uint256);
513 
514     /**
515      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
516      */
517     // solhint-disable-next-line func-name-mixedcase
518     function DOMAIN_SEPARATOR() external view returns (bytes32);
519 }
520 
521 // File: @openzeppelin/contracts/utils/Context.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Provides information about the current execution context, including the
530  * sender of the transaction and its data. While these are generally available
531  * via msg.sender and msg.data, they should not be accessed in such a direct
532  * manner, since when dealing with meta-transactions the account sending and
533  * paying for execution may not be the actual sender (as far as an application
534  * is concerned).
535  *
536  * This contract is only required for intermediate, library-like contracts.
537  */
538 abstract contract Context {
539     function _msgSender() internal view virtual returns (address) {
540         return msg.sender;
541     }
542 
543     function _msgData() internal view virtual returns (bytes calldata) {
544         return msg.data;
545     }
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev Interface of the ERC20 standard as defined in the EIP.
557  */
558 interface IERC20 {
559     /**
560      * @dev Returns the amount of tokens in existence.
561      */
562     function totalSupply() external view returns (uint256);
563 
564     /**
565      * @dev Returns the amount of tokens owned by `account`.
566      */
567     function balanceOf(address account) external view returns (uint256);
568 
569     /**
570      * @dev Moves `amount` tokens from the caller's account to `recipient`.
571      *
572      * Returns a boolean value indicating whether the operation succeeded.
573      *
574      * Emits a {Transfer} event.
575      */
576     function transfer(address recipient, uint256 amount) external returns (bool);
577 
578     /**
579      * @dev Returns the remaining number of tokens that `spender` will be
580      * allowed to spend on behalf of `owner` through {transferFrom}. This is
581      * zero by default.
582      *
583      * This value changes when {approve} or {transferFrom} are called.
584      */
585     function allowance(address owner, address spender) external view returns (uint256);
586 
587     /**
588      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
589      *
590      * Returns a boolean value indicating whether the operation succeeded.
591      *
592      * IMPORTANT: Beware that changing an allowance with this method brings the risk
593      * that someone may use both the old and the new allowance by unfortunate
594      * transaction ordering. One possible solution to mitigate this race
595      * condition is to first reduce the spender's allowance to 0 and set the
596      * desired value afterwards:
597      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
598      *
599      * Emits an {Approval} event.
600      */
601     function approve(address spender, uint256 amount) external returns (bool);
602 
603     /**
604      * @dev Moves `amount` tokens from `sender` to `recipient` using the
605      * allowance mechanism. `amount` is then deducted from the caller's
606      * allowance.
607      *
608      * Returns a boolean value indicating whether the operation succeeded.
609      *
610      * Emits a {Transfer} event.
611      */
612     function transferFrom(
613         address sender,
614         address recipient,
615         uint256 amount
616     ) external returns (bool);
617 
618     /**
619      * @dev Emitted when `value` tokens are moved from one account (`from`) to
620      * another (`to`).
621      *
622      * Note that `value` may be zero.
623      */
624     event Transfer(address indexed from, address indexed to, uint256 value);
625 
626     /**
627      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
628      * a call to {approve}. `value` is the new allowance.
629      */
630     event Approval(address indexed owner, address indexed spender, uint256 value);
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev Interface for the optional metadata functions from the ERC20 standard.
643  *
644  * _Available since v4.1._
645  */
646 interface IERC20Metadata is IERC20 {
647     /**
648      * @dev Returns the name of the token.
649      */
650     function name() external view returns (string memory);
651 
652     /**
653      * @dev Returns the symbol of the token.
654      */
655     function symbol() external view returns (string memory);
656 
657     /**
658      * @dev Returns the decimals places of the token.
659      */
660     function decimals() external view returns (uint8);
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 
672 
673 /**
674  * @dev Implementation of the {IERC20} interface.
675  *
676  * This implementation is agnostic to the way tokens are created. This means
677  * that a supply mechanism has to be added in a derived contract using {_mint}.
678  * For a generic mechanism see {ERC20PresetMinterPauser}.
679  *
680  * TIP: For a detailed writeup see our guide
681  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
682  * to implement supply mechanisms].
683  *
684  * We have followed general OpenZeppelin Contracts guidelines: functions revert
685  * instead returning `false` on failure. This behavior is nonetheless
686  * conventional and does not conflict with the expectations of ERC20
687  * applications.
688  *
689  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
690  * This allows applications to reconstruct the allowance for all accounts just
691  * by listening to said events. Other implementations of the EIP may not emit
692  * these events, as it isn't required by the specification.
693  *
694  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
695  * functions have been added to mitigate the well-known issues around setting
696  * allowances. See {IERC20-approve}.
697  */
698 contract ERC20 is Context, IERC20, IERC20Metadata {
699     mapping(address => uint256) private _balances;
700 
701     mapping(address => mapping(address => uint256)) private _allowances;
702 
703     uint256 private _totalSupply;
704 
705     string private _name;
706     string private _symbol;
707 
708     /**
709      * @dev Sets the values for {name} and {symbol}.
710      *
711      * The default value of {decimals} is 18. To select a different value for
712      * {decimals} you should overload it.
713      *
714      * All two of these values are immutable: they can only be set once during
715      * construction.
716      */
717     constructor(string memory name_, string memory symbol_) {
718         _name = name_;
719         _symbol = symbol_;
720     }
721 
722     /**
723      * @dev Returns the name of the token.
724      */
725     function name() public view virtual override returns (string memory) {
726         return _name;
727     }
728 
729     /**
730      * @dev Returns the symbol of the token, usually a shorter version of the
731      * name.
732      */
733     function symbol() public view virtual override returns (string memory) {
734         return _symbol;
735     }
736 
737     /**
738      * @dev Returns the number of decimals used to get its user representation.
739      * For example, if `decimals` equals `2`, a balance of `505` tokens should
740      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
741      *
742      * Tokens usually opt for a value of 18, imitating the relationship between
743      * Ether and Wei. This is the value {ERC20} uses, unless this function is
744      * overridden;
745      *
746      * NOTE: This information is only used for _display_ purposes: it in
747      * no way affects any of the arithmetic of the contract, including
748      * {IERC20-balanceOf} and {IERC20-transfer}.
749      */
750     function decimals() public view virtual override returns (uint8) {
751         return 18;
752     }
753 
754     /**
755      * @dev See {IERC20-totalSupply}.
756      */
757     function totalSupply() public view virtual override returns (uint256) {
758         return _totalSupply;
759     }
760 
761     /**
762      * @dev See {IERC20-balanceOf}.
763      */
764     function balanceOf(address account) public view virtual override returns (uint256) {
765         return _balances[account];
766     }
767 
768     /**
769      * @dev See {IERC20-transfer}.
770      *
771      * Requirements:
772      *
773      * - `recipient` cannot be the zero address.
774      * - the caller must have a balance of at least `amount`.
775      */
776     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
777         _transfer(_msgSender(), recipient, amount);
778         return true;
779     }
780 
781     /**
782      * @dev See {IERC20-allowance}.
783      */
784     function allowance(address owner, address spender) public view virtual override returns (uint256) {
785         return _allowances[owner][spender];
786     }
787 
788     /**
789      * @dev See {IERC20-approve}.
790      *
791      * Requirements:
792      *
793      * - `spender` cannot be the zero address.
794      */
795     function approve(address spender, uint256 amount) public virtual override returns (bool) {
796         _approve(_msgSender(), spender, amount);
797         return true;
798     }
799 
800     /**
801      * @dev See {IERC20-transferFrom}.
802      *
803      * Emits an {Approval} event indicating the updated allowance. This is not
804      * required by the EIP. See the note at the beginning of {ERC20}.
805      *
806      * Requirements:
807      *
808      * - `sender` and `recipient` cannot be the zero address.
809      * - `sender` must have a balance of at least `amount`.
810      * - the caller must have allowance for ``sender``'s tokens of at least
811      * `amount`.
812      */
813     function transferFrom(
814         address sender,
815         address recipient,
816         uint256 amount
817     ) public virtual override returns (bool) {
818         _transfer(sender, recipient, amount);
819 
820         uint256 currentAllowance = _allowances[sender][_msgSender()];
821         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
822         unchecked {
823             _approve(sender, _msgSender(), currentAllowance - amount);
824         }
825 
826         return true;
827     }
828 
829     /**
830      * @dev Atomically increases the allowance granted to `spender` by the caller.
831      *
832      * This is an alternative to {approve} that can be used as a mitigation for
833      * problems described in {IERC20-approve}.
834      *
835      * Emits an {Approval} event indicating the updated allowance.
836      *
837      * Requirements:
838      *
839      * - `spender` cannot be the zero address.
840      */
841     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
842         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
843         return true;
844     }
845 
846     /**
847      * @dev Atomically decreases the allowance granted to `spender` by the caller.
848      *
849      * This is an alternative to {approve} that can be used as a mitigation for
850      * problems described in {IERC20-approve}.
851      *
852      * Emits an {Approval} event indicating the updated allowance.
853      *
854      * Requirements:
855      *
856      * - `spender` cannot be the zero address.
857      * - `spender` must have allowance for the caller of at least
858      * `subtractedValue`.
859      */
860     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
861         uint256 currentAllowance = _allowances[_msgSender()][spender];
862         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
863         unchecked {
864             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
865         }
866 
867         return true;
868     }
869 
870     /**
871      * @dev Moves `amount` of tokens from `sender` to `recipient`.
872      *
873      * This internal function is equivalent to {transfer}, and can be used to
874      * e.g. implement automatic token fees, slashing mechanisms, etc.
875      *
876      * Emits a {Transfer} event.
877      *
878      * Requirements:
879      *
880      * - `sender` cannot be the zero address.
881      * - `recipient` cannot be the zero address.
882      * - `sender` must have a balance of at least `amount`.
883      */
884     function _transfer(
885         address sender,
886         address recipient,
887         uint256 amount
888     ) internal virtual {
889         require(sender != address(0), "ERC20: transfer from the zero address");
890         require(recipient != address(0), "ERC20: transfer to the zero address");
891 
892         _beforeTokenTransfer(sender, recipient, amount);
893 
894         uint256 senderBalance = _balances[sender];
895         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
896         unchecked {
897             _balances[sender] = senderBalance - amount;
898         }
899         _balances[recipient] += amount;
900 
901         emit Transfer(sender, recipient, amount);
902 
903         _afterTokenTransfer(sender, recipient, amount);
904     }
905 
906     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
907      * the total supply.
908      *
909      * Emits a {Transfer} event with `from` set to the zero address.
910      *
911      * Requirements:
912      *
913      * - `account` cannot be the zero address.
914      */
915     function _mint(address account, uint256 amount) internal virtual {
916         require(account != address(0), "ERC20: mint to the zero address");
917 
918         _beforeTokenTransfer(address(0), account, amount);
919 
920         _totalSupply += amount;
921         _balances[account] += amount;
922         emit Transfer(address(0), account, amount);
923 
924         _afterTokenTransfer(address(0), account, amount);
925     }
926 
927     /**
928      * @dev Destroys `amount` tokens from `account`, reducing the
929      * total supply.
930      *
931      * Emits a {Transfer} event with `to` set to the zero address.
932      *
933      * Requirements:
934      *
935      * - `account` cannot be the zero address.
936      * - `account` must have at least `amount` tokens.
937      */
938     function _burn(address account, uint256 amount) internal virtual {
939         require(account != address(0), "ERC20: burn from the zero address");
940 
941         _beforeTokenTransfer(account, address(0), amount);
942 
943         uint256 accountBalance = _balances[account];
944         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
945         unchecked {
946             _balances[account] = accountBalance - amount;
947         }
948         _totalSupply -= amount;
949 
950         emit Transfer(account, address(0), amount);
951 
952         _afterTokenTransfer(account, address(0), amount);
953     }
954 
955     /**
956      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
957      *
958      * This internal function is equivalent to `approve`, and can be used to
959      * e.g. set automatic allowances for certain subsystems, etc.
960      *
961      * Emits an {Approval} event.
962      *
963      * Requirements:
964      *
965      * - `owner` cannot be the zero address.
966      * - `spender` cannot be the zero address.
967      */
968     function _approve(
969         address owner,
970         address spender,
971         uint256 amount
972     ) internal virtual {
973         require(owner != address(0), "ERC20: approve from the zero address");
974         require(spender != address(0), "ERC20: approve to the zero address");
975 
976         _allowances[owner][spender] = amount;
977         emit Approval(owner, spender, amount);
978     }
979 
980     /**
981      * @dev Hook that is called before any transfer of tokens. This includes
982      * minting and burning.
983      *
984      * Calling conditions:
985      *
986      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
987      * will be transferred to `to`.
988      * - when `from` is zero, `amount` tokens will be minted for `to`.
989      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
990      * - `from` and `to` are never both zero.
991      *
992      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
993      */
994     function _beforeTokenTransfer(
995         address from,
996         address to,
997         uint256 amount
998     ) internal virtual {}
999 
1000     /**
1001      * @dev Hook that is called after any transfer of tokens. This includes
1002      * minting and burning.
1003      *
1004      * Calling conditions:
1005      *
1006      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1007      * has been transferred to `to`.
1008      * - when `from` is zero, `amount` tokens have been minted for `to`.
1009      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1010      * - `from` and `to` are never both zero.
1011      *
1012      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1013      */
1014     function _afterTokenTransfer(
1015         address from,
1016         address to,
1017         uint256 amount
1018     ) internal virtual {}
1019 }
1020 
1021 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
1022 
1023 
1024 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-ERC20Permit.sol)
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 
1029 
1030 
1031 
1032 
1033 /**
1034  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1035  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1036  *
1037  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1038  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1039  * need to send a transaction, and thus is not required to hold Ether at all.
1040  *
1041  * _Available since v3.4._
1042  */
1043 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1044     using Counters for Counters.Counter;
1045 
1046     mapping(address => Counters.Counter) private _nonces;
1047 
1048     // solhint-disable-next-line var-name-mixedcase
1049     bytes32 private immutable _PERMIT_TYPEHASH =
1050         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1051 
1052     /**
1053      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1054      *
1055      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1056      */
1057     constructor(string memory name) EIP712(name, "1") {}
1058 
1059     /**
1060      * @dev See {IERC20Permit-permit}.
1061      */
1062     function permit(
1063         address owner,
1064         address spender,
1065         uint256 value,
1066         uint256 deadline,
1067         uint8 v,
1068         bytes32 r,
1069         bytes32 s
1070     ) public virtual override {
1071         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1072 
1073         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1074 
1075         bytes32 hash = _hashTypedDataV4(structHash);
1076 
1077         address signer = ECDSA.recover(hash, v, r, s);
1078         require(signer == owner, "ERC20Permit: invalid signature");
1079 
1080         _approve(owner, spender, value);
1081     }
1082 
1083     /**
1084      * @dev See {IERC20Permit-nonces}.
1085      */
1086     function nonces(address owner) public view virtual override returns (uint256) {
1087         return _nonces[owner].current();
1088     }
1089 
1090     /**
1091      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1092      */
1093     // solhint-disable-next-line func-name-mixedcase
1094     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1095         return _domainSeparatorV4();
1096     }
1097 
1098     /**
1099      * @dev "Consume a nonce": return the current value and increment.
1100      *
1101      * _Available since v4.1._
1102      */
1103     function _useNonce(address owner) internal virtual returns (uint256 current) {
1104         Counters.Counter storage nonce = _nonces[owner];
1105         current = nonce.current();
1106         nonce.increment();
1107     }
1108 }
1109 
1110 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1111 
1112 
1113 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)
1114 
1115 pragma solidity ^0.8.0;
1116 
1117 
1118 
1119 /**
1120  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1121  * tokens and those that they have an allowance for, in a way that can be
1122  * recognized off-chain (via event analysis).
1123  */
1124 abstract contract ERC20Burnable is Context, ERC20 {
1125     /**
1126      * @dev Destroys `amount` tokens from the caller.
1127      *
1128      * See {ERC20-_burn}.
1129      */
1130     function burn(uint256 amount) public virtual {
1131         _burn(_msgSender(), amount);
1132     }
1133 
1134     /**
1135      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1136      * allowance.
1137      *
1138      * See {ERC20-_burn} and {ERC20-allowance}.
1139      *
1140      * Requirements:
1141      *
1142      * - the caller must have allowance for ``accounts``'s tokens of at least
1143      * `amount`.
1144      */
1145     function burnFrom(address account, uint256 amount) public virtual {
1146         uint256 currentAllowance = allowance(account, _msgSender());
1147         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1148         unchecked {
1149             _approve(account, _msgSender(), currentAllowance - amount);
1150         }
1151         _burn(account, amount);
1152     }
1153 }
1154 
1155 // File: tests/LOOT.sol
1156 
1157 
1158 pragma solidity ^0.8.2;
1159 
1160 
1161 
1162 
1163 contract LOOTToken is ERC20, ERC20Burnable, ERC20Permit {
1164     constructor() ERC20("LOOT Token", "LOOT") ERC20Permit("LOOT Token") {
1165         _mint(msg.sender, 100_000_000 * 10 ** decimals());
1166     }
1167 }